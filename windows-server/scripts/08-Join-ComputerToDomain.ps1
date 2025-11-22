# Join Computer to Domain
# This script joins a Windows client computer to the CRUISE.LOCAL domain
# Run this script on each client workstation that needs to join the domain

#Requires -RunAsAdministrator

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Join Computer to Domain" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$DomainName = "CRUISE.LOCAL"
$DomainNetBIOS = "CRUISE"

# Check if already domain joined
$currentDomain = (Get-WmiObject Win32_ComputerSystem).Domain
if ($currentDomain -eq $DomainName) {
    Write-Host "Computer is already joined to $DomainName" -ForegroundColor Green
    Write-Host "Current domain: $currentDomain" -ForegroundColor Yellow
    exit 0
}

Write-Host "Current domain/workgroup: $currentDomain" -ForegroundColor Yellow
Write-Host "Target domain: $DomainName" -ForegroundColor Yellow
Write-Host ""

# Get domain credentials
Write-Host "Enter domain administrator credentials:" -ForegroundColor Cyan
$domainAdmin = Read-Host "Domain Administrator Username"
$securePassword = Read-Host "Password" -AsSecureString
$credential = New-Object System.Management.Automation.PSCredential("$DomainNetBIOS\$domainAdmin", $securePassword)

Write-Host ""
Write-Host "Joining computer to domain..." -ForegroundColor Green

try {
    # Test domain connectivity
    $dc = (Get-ADDomainController -DomainName $DomainName -Discover -Service PrimaryDC).HostName
    Write-Host "  ✓ Domain controller found: $dc" -ForegroundColor Green
    
    # Test DNS resolution
    $dnsTest = Resolve-DnsName -Name $DomainName -ErrorAction SilentlyContinue
    if ($dnsTest) {
        Write-Host "  ✓ DNS resolution working" -ForegroundColor Green
    } else {
        Write-Host "  ⚠ Warning: DNS resolution may have issues" -ForegroundColor Yellow
    }
    
    # Join domain
    Add-Computer -DomainName $DomainName -Credential $credential -OUPath "" -Force
    
    Write-Host ""
    Write-Host "  ✓ Computer successfully joined to domain!" -ForegroundColor Green
    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "Next Steps" -ForegroundColor Cyan
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "  1. Restart the computer" -ForegroundColor White
    Write-Host "  2. Log in with domain credentials" -ForegroundColor White
    Write-Host "  3. Verify GPO application: gpupdate /force" -ForegroundColor White
    Write-Host "  4. Test file share access" -ForegroundColor White
    Write-Host ""
    Write-Host "Restart now? (Y/N)" -ForegroundColor Yellow
    $restart = Read-Host
    if ($restart -eq "Y" -or $restart -eq "y") {
        Restart-Computer -Force
    }
    
} catch {
    Write-Host ""
    Write-Host "  ✗ Error joining domain: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Troubleshooting:" -ForegroundColor Yellow
    Write-Host "  1. Verify network connectivity to domain controller" -ForegroundColor White
    Write-Host "  2. Check DNS settings point to domain controller" -ForegroundColor White
    Write-Host "  3. Verify domain credentials are correct" -ForegroundColor White
    Write-Host "  4. Check if computer account already exists in AD" -ForegroundColor White
    Write-Host "  5. Ensure domain controller is accessible" -ForegroundColor White
    exit 1
}

