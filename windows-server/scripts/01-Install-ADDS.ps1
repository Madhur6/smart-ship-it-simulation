# Install Active Directory Domain Services
# This script installs and configures AD DS on a Windows Server
# Run this script on the server that will become the Domain Controller

#Requires -RunAsAdministrator

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Active Directory Domain Services Setup" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "ERROR: This script must be run as Administrator!" -ForegroundColor Red
    exit 1
}

# Configuration Variables
$DomainName = "CRUISE.LOCAL"
$DomainNetBIOSName = "CRUISE"
$SafeModePassword = Read-Host "Enter Safe Mode Administrator Password" -AsSecureString

Write-Host "Configuration:" -ForegroundColor Yellow
Write-Host "  Domain Name: $DomainName" -ForegroundColor White
Write-Host "  NetBIOS Name: $DomainNetBIOSName" -ForegroundColor White
Write-Host ""

# Confirm before proceeding
$confirm = Read-Host "Proceed with AD DS installation? (Y/N)"
if ($confirm -ne "Y" -and $confirm -ne "y") {
    Write-Host "Installation cancelled." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "Step 1: Installing AD DS Windows Feature..." -ForegroundColor Green
try {
    Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
    Write-Host "  ✓ AD DS feature installed successfully" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Error installing AD DS: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Step 2: Importing ADDSDeployment module..." -ForegroundColor Green
try {
    Import-Module ADDSDeployment
    Write-Host "  ✓ Module imported successfully" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Error importing module: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Step 3: Installing Active Directory Forest..." -ForegroundColor Green
Write-Host "  This may take several minutes..." -ForegroundColor Yellow

try {
    $params = @{
        CreateDnsDelegation = $false
        DatabasePath = "C:\Windows\NTDS"
        DomainMode = "Win2016"
        DomainName = $DomainName
        DomainNetbiosName = $DomainNetBIOSName
        ForestMode = "Win2016"
        InstallDns = $true
        LogPath = "C:\Windows\NTDS"
        NoRebootOnCompletion = $false
        SafeModeAdministratorPassword = $SafeModePassword
        Force = $true
    }
    
    Install-ADDSForest @params
    
    Write-Host ""
    Write-Host "  ✓ Active Directory Forest installed successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "Installation Complete!" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "The server will restart automatically." -ForegroundColor Yellow
    Write-Host "After restart, log in as: $DomainNetBIOSName\Administrator" -ForegroundColor Yellow
    Write-Host ""
    
} catch {
    Write-Host ""
    Write-Host "  ✗ Error installing AD Forest: $_" -ForegroundColor Red
    Write-Host "  Check the error details above." -ForegroundColor Yellow
    exit 1
}

