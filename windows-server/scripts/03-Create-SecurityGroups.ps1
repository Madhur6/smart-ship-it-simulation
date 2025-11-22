# Create Security Groups
# This script creates security groups for the CRUISE.LOCAL domain
# Run this script after OUs are created

#Requires -RunAsAdministrator

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Create Security Groups" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Import Active Directory module
Import-Module ActiveDirectory

# Domain DN
$DomainDN = (Get-ADDomain).DistinguishedName
$SecurityGroupsOU = "OU=Security Groups,OU=Groups,$DomainDN"

# Ensure Security Groups OU exists
try {
    $existingOU = Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$SecurityGroupsOU'" -ErrorAction SilentlyContinue
    if (-not $existingOU) {
        Write-Host "Creating Security Groups OU..." -ForegroundColor Yellow
        New-ADOrganizationalUnit -Name "Security Groups" -Path "OU=Groups,$DomainDN" -ProtectedFromAccidentalDeletion $false
    }
} catch {
    Write-Host "Error with Security Groups OU: $_" -ForegroundColor Red
}

# Define Security Groups
$SecurityGroups = @(
    @{Name = "IT Support"; Description = "IT support staff with elevated permissions"; GroupScope = "Global"; GroupCategory = "Security"},
    @{Name = "Deck Officers"; Description = "Deck department officers"; GroupScope = "Global"; GroupCategory = "Security"},
    @{Name = "Engine Engineers"; Description = "Engineering department engineers"; GroupScope = "Global"; GroupCategory = "Security"},
    @{Name = "Hotel Management"; Description = "Hotel department management"; GroupScope = "Global"; GroupCategory = "Security"},
    @{Name = "Guest Services Staff"; Description = "Guest Services department staff"; GroupScope = "Global"; GroupCategory = "Security"},
    @{Name = "File Share - Deck"; Description = "Access to Deck department file share"; GroupScope = "DomainLocal"; GroupCategory = "Security"},
    @{Name = "File Share - Engine"; Description = "Access to Engine department file share"; GroupScope = "DomainLocal"; GroupCategory = "Security"},
    @{Name = "File Share - Hotel"; Description = "Access to Hotel department file share"; GroupScope = "DomainLocal"; GroupCategory = "Security"},
    @{Name = "File Share - Guest Services"; Description = "Access to Guest Services file share"; GroupScope = "DomainLocal"; GroupCategory = "Security"}
)

Write-Host "Creating Security Groups..." -ForegroundColor Green
Write-Host ""

$created = 0
$skipped = 0
$errors = 0

foreach ($group in $SecurityGroups) {
    $groupName = $group.Name
    $groupDescription = $group.Description
    $groupScope = $group.GroupScope
    $groupCategory = $group.GroupCategory
    
    try {
        # Check if group already exists
        $existingGroup = Get-ADGroup -Filter "Name -eq '$groupName'" -ErrorAction SilentlyContinue
        
        if ($existingGroup) {
            Write-Host "  ⊘ Skipped: $groupName (already exists)" -ForegroundColor Yellow
            $skipped++
        } else {
            New-ADGroup -Name $groupName `
                        -GroupScope $groupScope `
                        -GroupCategory $groupCategory `
                        -Path $SecurityGroupsOU `
                        -Description $groupDescription
            
            Write-Host "  ✓ Created: $groupName ($groupScope)" -ForegroundColor Green
            $created++
        }
    } catch {
        Write-Host "  ✗ Error creating $groupName : $_" -ForegroundColor Red
        $errors++
    }
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Summary" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  Created:  $created groups" -ForegroundColor Green
Write-Host "  Skipped:   $skipped groups (already exist)" -ForegroundColor Yellow
Write-Host "  Errors:    $errors groups" -ForegroundColor $(if ($errors -gt 0) { "Red" } else { "Green" })
Write-Host ""

if ($errors -eq 0) {
    Write-Host "Security groups created successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "  1. Add users to appropriate groups" -ForegroundColor White
    Write-Host "  2. Configure file share permissions using these groups" -ForegroundColor White
} else {
    Write-Host "Some groups could not be created. Please review errors above." -ForegroundColor Yellow
}

Write-Host ""

