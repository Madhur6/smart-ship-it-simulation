# Create Organizational Units (OUs) Structure
# This script creates the OU hierarchy for the CRUISE.LOCAL domain
# Run this script after AD DS is installed and domain is created

#Requires -RunAsAdministrator

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Create Organizational Units Structure" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Import Active Directory module
Import-Module ActiveDirectory

# Domain DN
$DomainDN = (Get-ADDomain).DistinguishedName

Write-Host "Domain: $DomainDN" -ForegroundColor Yellow
Write-Host ""

# Define OU structure
$OUs = @(
    # Computers OUs
    @{Path = $DomainDN; Name = "Computers"; Description = "Computer objects container"},
    @{Path = "CN=Computers,$DomainDN"; Name = "Servers"; Description = "Server computers"},
    @{Path = "OU=Servers,CN=Computers,$DomainDN"; Name = "Domain Controllers"; Description = "Domain Controller servers"},
    @{Path = "OU=Servers,CN=Computers,$DomainDN"; Name = "File Servers"; Description = "File and storage servers"},
    @{Path = "CN=Computers,$DomainDN"; Name = "Workstations"; Description = "Client workstations"},
    @{Path = "OU=Workstations,CN=Computers,$DomainDN"; Name = "Deck Department"; Description = "Deck department workstations"},
    @{Path = "OU=Workstations,CN=Computers,$DomainDN"; Name = "Engine Department"; Description = "Engine department workstations"},
    @{Path = "OU=Workstations,CN=Computers,$DomainDN"; Name = "Hotel Department"; Description = "Hotel department workstations"},
    @{Path = "OU=Workstations,CN=Computers,$DomainDN"; Name = "Guest Services"; Description = "Guest Services workstations"},
    
    # Users OUs
    @{Path = $DomainDN; Name = "Users"; Description = "User accounts container"},
    @{Path = "CN=Users,$DomainDN"; Name = "Administrators"; Description = "Administrator accounts"},
    @{Path = "CN=Users,$DomainDN"; Name = "IT Staff"; Description = "IT department staff"},
    @{Path = "CN=Users,$DomainDN"; Name = "Deck Department"; Description = "Deck department users"},
    @{Path = "OU=Deck Department,CN=Users,$DomainDN"; Name = "Officers"; Description = "Deck officers"},
    @{Path = "OU=Deck Department,CN=Users,$DomainDN"; Name = "Crew"; Description = "Deck crew members"},
    @{Path = "CN=Users,$DomainDN"; Name = "Engine Department"; Description = "Engine department users"},
    @{Path = "OU=Engine Department,CN=Users,$DomainDN"; Name = "Engineers"; Description = "Engineering staff"},
    @{Path = "OU=Engine Department,CN=Users,$DomainDN"; Name = "Technicians"; Description = "Engineering technicians"},
    @{Path = "CN=Users,$DomainDN"; Name = "Hotel Department"; Description = "Hotel department users"},
    @{Path = "OU=Hotel Department,CN=Users,$DomainDN"; Name = "Management"; Description = "Hotel management"},
    @{Path = "OU=Hotel Department,CN=Users,$DomainDN"; Name = "Staff"; Description = "Hotel staff"},
    @{Path = "OU=Hotel Department,CN=Users,$DomainDN"; Name = "Service Personnel"; Description = "Hotel service personnel"},
    @{Path = "CN=Users,$DomainDN"; Name = "Guest Services"; Description = "Guest Services users"},
    @{Path = "OU=Guest Services,CN=Users,$DomainDN"; Name = "Managers"; Description = "Guest Services managers"},
    @{Path = "OU=Guest Services,CN=Users,$DomainDN"; Name = "Staff"; Description = "Guest Services staff"},
    
    # Groups OUs
    @{Path = $DomainDN; Name = "Groups"; Description = "Security and distribution groups"},
    @{Path = "OU=Groups,$DomainDN"; Name = "Security Groups"; Description = "Security groups"},
    @{Path = "OU=Groups,$DomainDN"; Name = "Distribution Groups"; Description = "Distribution groups"}
)

Write-Host "Creating Organizational Units..." -ForegroundColor Green
Write-Host ""

$created = 0
$skipped = 0
$errors = 0

foreach ($ou in $OUs) {
    $ouPath = $ou.Path
    $ouName = $ou.Name
    $ouDescription = $ou.Description
    $ouDN = "OU=$ouName,$ouPath"
    
    try {
        # Check if OU already exists
        $existingOU = Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$ouDN'" -ErrorAction SilentlyContinue
        
        if ($existingOU) {
            Write-Host "  ⊘ Skipped: $ouName (already exists)" -ForegroundColor Yellow
            $skipped++
        } else {
            New-ADOrganizationalUnit -Name $ouName -Path $ouPath -Description $ouDescription -ProtectedFromAccidentalDeletion $false
            Write-Host "  ✓ Created: $ouName" -ForegroundColor Green
            $created++
        }
    } catch {
        Write-Host "  ✗ Error creating $ouName : $_" -ForegroundColor Red
        $errors++
    }
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Summary" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  Created:  $created OUs" -ForegroundColor Green
Write-Host "  Skipped:   $skipped OUs (already exist)" -ForegroundColor Yellow
Write-Host "  Errors:    $errors OUs" -ForegroundColor $(if ($errors -gt 0) { "Red" } else { "Green" })
Write-Host ""

if ($errors -eq 0) {
    Write-Host "OU structure created successfully!" -ForegroundColor Green
} else {
    Write-Host "Some OUs could not be created. Please review errors above." -ForegroundColor Yellow
}

Write-Host ""

