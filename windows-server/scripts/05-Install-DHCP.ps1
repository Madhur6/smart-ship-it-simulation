# Install and Configure DHCP Server
# This script installs DHCP Server role and creates scopes
# Run this script on the File Server (FS01) or dedicated DHCP server

#Requires -RunAsAdministrator

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Install and Configure DHCP Server" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "ERROR: This script must be run as Administrator!" -ForegroundColor Red
    exit 1
}

# Domain information
$DomainName = (Get-ADDomain).DNSRoot
$DomainDN = (Get-ADDomain).DistinguishedName

# DNS servers (Domain Controllers)
$DnsServers = @("10.20.20.10", "10.20.20.11")

Write-Host "Domain: $DomainName" -ForegroundColor Yellow
Write-Host "DNS Servers: $($DnsServers -join ', ')" -ForegroundColor Yellow
Write-Host ""

# Step 1: Install DHCP Server role
Write-Host "Step 1: Installing DHCP Server role..." -ForegroundColor Green

$dhcpInstalled = Get-WindowsFeature -Name DHCP | Where-Object { $_.InstallState -eq "Installed" }
if ($dhcpInstalled) {
    Write-Host "  ⊘ DHCP Server role already installed" -ForegroundColor Yellow
} else {
    try {
        Install-WindowsFeature -Name DHCP -IncludeManagementTools
        Write-Host "  ✓ DHCP Server role installed" -ForegroundColor Green
    } catch {
        Write-Host "  ✗ Error installing DHCP: $_" -ForegroundColor Red
        exit 1
    }
}

# Step 2: Authorize DHCP server in AD
Write-Host ""
Write-Host "Step 2: Authorizing DHCP server in Active Directory..." -ForegroundColor Green

try {
    Import-Module DHCPServer
    Add-DhcpServerInDC
    Write-Host "  ✓ DHCP server authorized in Active Directory" -ForegroundColor Green
} catch {
    Write-Host "  ⚠ Warning: Could not authorize DHCP server: $_" -ForegroundColor Yellow
    Write-Host "    You may need to authorize manually in DHCP console" -ForegroundColor Yellow
}

# Step 3: Create DHCP scopes
Write-Host ""
Write-Host "Step 3: Creating DHCP scopes..." -ForegroundColor Green

# Define DHCP scopes
$DhcpScopes = @(
    @{
        Name = "Crew-Admin-Network"
        StartRange = "10.20.20.100"
        EndRange = "10.20.20.200"
        SubnetMask = "255.255.255.0"
        State = "Active"
        Description = "Crew/Admin Network (VLAN 20)"
        Gateway = "10.20.20.1"
        DnsServers = $DnsServers
        LeaseDuration = (New-TimeSpan -Days 8)
    },
    @{
        Name = "Hotel-Operations-Network"
        StartRange = "10.50.50.100"
        EndRange = "10.50.50.200"
        SubnetMask = "255.255.255.0"
        State = "Active"
        Description = "Hotel Operations Network (VLAN 50)"
        Gateway = "10.50.50.1"
        DnsServers = $DnsServers
        LeaseDuration = (New-TimeSpan -Days 8)
    }
)

foreach ($scope in $DhcpScopes) {
    $scopeName = $scope.Name
    $scopeId = ($scope.StartRange -split '\.')[0..2] -join '.'
    
    try {
        # Check if scope already exists
        $existingScope = Get-DhcpServerv4Scope -ScopeId $scopeId -ErrorAction SilentlyContinue
        
        if ($existingScope) {
            Write-Host "  ⊘ Skipped: $scopeName ($scopeId) - already exists" -ForegroundColor Yellow
        } else {
            # Create scope
            Add-DhcpServerv4Scope -Name $scopeName `
                                   -StartRange $scope.StartRange `
                                   -EndRange $scope.EndRange `
                                   -SubnetMask $scope.SubnetMask `
                                   -State $scope.State `
                                   -Description $scope.Description `
                                   -LeaseDuration $scope.LeaseDuration
            
            # Set scope options
            Set-DhcpServerv4OptionValue -ScopeId $scopeId `
                                       -Router $scope.Gateway `
                                       -DnsServer $scope.DnsServers `
                                       -DnsDomain $DomainName
            
            Write-Host "  ✓ Created: $scopeName ($scopeId)" -ForegroundColor Green
            Write-Host "    Range: $($scope.StartRange) - $($scope.EndRange)" -ForegroundColor Gray
            Write-Host "    Gateway: $($scope.Gateway)" -ForegroundColor Gray
        }
    } catch {
        Write-Host "  ✗ Error creating scope $scopeName : $_" -ForegroundColor Red
    }
}

# Step 4: Configure exclusions (reserved IPs for servers)
Write-Host ""
Write-Host "Step 4: Configuring IP exclusions (server reservations)..." -ForegroundColor Green

$Exclusions = @(
    @{ScopeId = "10.20.20.0"; StartRange = "10.20.20.1"; EndRange = "10.20.20.99"; Description = "Reserved for servers and network devices"},
    @{ScopeId = "10.50.50.0"; StartRange = "10.50.50.1"; EndRange = "10.50.50.99"; Description = "Reserved for servers and network devices"}
)

foreach ($exclusion in $Exclusions) {
    $scopeId = $exclusion.ScopeId
    try {
        Add-DhcpServerv4ExclusionRange -ScopeId $scopeId `
                                       -StartRange $exclusion.StartRange `
                                       -EndRange $exclusion.EndRange
        Write-Host "  ✓ Exclusion: $($exclusion.StartRange) - $($exclusion.EndRange) in scope $scopeId" -ForegroundColor Green
    } catch {
        Write-Host "  ⚠ Warning: Could not add exclusion for $scopeId : $_" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "DHCP Configuration Complete!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Verify scopes in DHCP console" -ForegroundColor White
Write-Host "  2. Test DHCP lease from a client" -ForegroundColor White
Write-Host "  3. Configure DHCP reservations for specific devices if needed" -ForegroundColor White
Write-Host ""

