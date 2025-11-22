# Configure DNS Zones and Records
# This script configures DNS forward and reverse lookup zones
# Run this script on the Domain Controller after AD DS is installed

#Requires -RunAsAdministrator

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Configure DNS Zones and Records" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Import DNS module
Import-Module DnsServer

# Domain information
$DomainName = (Get-ADDomain).DNSRoot
$DomainDN = (Get-ADDomain).DistinguishedName

Write-Host "Domain: $DomainName" -ForegroundColor Yellow
Write-Host ""

# Check if DNS server role is installed
$dnsInstalled = Get-WindowsFeature -Name DNS | Where-Object { $_.InstallState -eq "Installed" }
if (-not $dnsInstalled) {
    Write-Host "ERROR: DNS Server role is not installed!" -ForegroundColor Red
    Write-Host "DNS is typically installed automatically with AD DS." -ForegroundColor Yellow
    exit 1
}

Write-Host "Step 1: Verifying primary zone exists..." -ForegroundColor Green
try {
    $primaryZone = Get-DnsServerZone -Name $DomainName -ErrorAction SilentlyContinue
    if ($primaryZone) {
        Write-Host "  ✓ Primary zone '$DomainName' already exists" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Primary zone not found. This is unusual for an AD-integrated zone." -ForegroundColor Red
    }
} catch {
    Write-Host "  ✗ Error checking primary zone: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "Step 2: Creating reverse lookup zones..." -ForegroundColor Green

# Reverse zones to create
$ReverseZones = @(
    @{Network = "10.20.20.0/24"; ZoneName = "20.20.10.in-addr.arpa"; Description = "Crew/Admin Network"},
    @{Network = "10.50.50.0/24"; ZoneName = "50.50.10.in-addr.arpa"; Description = "Hotel Operations Network"}
)

foreach ($zone in $ReverseZones) {
    $zoneName = $zone.ZoneName
    $description = $zone.Description
    
    try {
        $existingZone = Get-DnsServerZone -Name $zoneName -ErrorAction SilentlyContinue
        if ($existingZone) {
            Write-Host "  ⊘ Skipped: $zoneName (already exists)" -ForegroundColor Yellow
        } else {
            Add-DnsServerPrimaryZone -Name $zoneName -DynamicUpdate Secure -ReplicationScope Domain
            Write-Host "  ✓ Created: $zoneName - $description" -ForegroundColor Green
        }
    } catch {
        Write-Host "  ✗ Error creating $zoneName : $_" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Step 3: Creating DNS records..." -ForegroundColor Green

# DNS records to create
$DnsRecords = @(
    @{Name = "DC01"; Type = "A"; Data = "10.20.20.10"; Zone = $DomainName; Description = "Primary Domain Controller"},
    @{Name = "DC02"; Type = "A"; Data = "10.20.20.11"; Zone = $DomainName; Description = "Secondary Domain Controller"},
    @{Name = "FS01"; Type = "A"; Data = "10.20.20.20"; Zone = $DomainName; Description = "File Server"},
    @{Name = "CRUISE-DC"; Type = "CNAME"; Data = "DC01.$DomainName"; Zone = $DomainName; Description = "Domain Controller alias"}
)

foreach ($record in $DnsRecords) {
    $recordName = $record.Name
    $recordType = $record.Type
    $recordData = $record.Data
    $recordZone = $record.Zone
    $recordDescription = $record.Description
    
    try {
        # Check if record exists
        $existingRecord = Get-DnsServerResourceRecord -ZoneName $recordZone -Name $recordName -ErrorAction SilentlyContinue | Where-Object { $_.RecordType -eq $recordType }
        
        if ($existingRecord) {
            Write-Host "  ⊘ Skipped: $recordName ($recordType) - already exists" -ForegroundColor Yellow
        } else {
            if ($recordType -eq "A") {
                Add-DnsServerResourceRecordA -Name $recordName -ZoneName $recordZone -IPv4Address $recordData
            } elseif ($recordType -eq "CNAME") {
                Add-DnsServerResourceRecordCName -Name $recordName -ZoneName $recordZone -HostNameAlias $recordData
            }
            Write-Host "  ✓ Created: $recordName ($recordType) - $recordDescription" -ForegroundColor Green
        }
    } catch {
        Write-Host "  ✗ Error creating $recordName : $_" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Step 4: Configuring DNS forwarders..." -ForegroundColor Green

try {
    # Set DNS forwarders
    Set-DnsServerForwarder -IPAddress @("8.8.8.8", "1.1.1.1")
    Write-Host "  ✓ DNS forwarders configured (8.8.8.8, 1.1.1.1)" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Error configuring forwarders: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "DNS Configuration Complete!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Verify DNS resolution: nslookup DC01.$DomainName" -ForegroundColor White
Write-Host "  2. Test reverse lookup: nslookup 10.20.20.10" -ForegroundColor White
Write-Host "  3. Verify forwarders: Test-NetConnection 8.8.8.8 -Port 53" -ForegroundColor White
Write-Host ""

