# Create User Accounts
# This script creates sample user accounts for each department
# Run this script after OUs and security groups are created

#Requires -RunAsAdministrator

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Create User Accounts" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Import Active Directory module
Import-Module ActiveDirectory

# Domain information
$DomainName = (Get-ADDomain).DNSRoot
$DomainDN = (Get-ADDomain).DistinguishedName

Write-Host "Domain: $DomainName" -ForegroundColor Yellow
Write-Host ""

# Define users to create
$Users = @(
    # IT Staff
    @{FirstName = "John"; LastName = "Admin"; Username = "J.Admin"; Department = "IT Staff"; OU = "CN=Users,$DomainDN"; Groups = @("Domain Admins", "IT Support"); Title = "IT Administrator"},
    @{FirstName = "Sarah"; LastName = "Support"; Username = "S.Support"; Department = "IT Staff"; OU = "CN=Users,$DomainDN"; Groups = @("IT Support"); Title = "IT Support Technician"},
    
    # Deck Department
    @{FirstName = "Michael"; LastName = "Captain"; Username = "M.Captain"; Department = "Deck Department"; OU = "OU=Officers,OU=Deck Department,CN=Users,$DomainDN"; Groups = @("Deck Officers", "File Share - Deck"); Title = "Captain"},
    @{FirstName = "David"; LastName = "Officer"; Username = "D.Officer"; Department = "Deck Department"; OU = "OU=Officers,OU=Deck Department,CN=Users,$DomainDN"; Groups = @("Deck Officers", "File Share - Deck"); Title = "Deck Officer"},
    @{FirstName = "Robert"; LastName = "Crew"; Username = "R.Crew"; Department = "Deck Department"; OU = "OU=Crew,OU=Deck Department,CN=Users,$DomainDN"; Groups = @("File Share - Deck"); Title = "Deck Crew Member"},
    
    # Engine Department
    @{FirstName = "James"; LastName = "Engineer"; Username = "J.Engineer"; Department = "Engine Department"; OU = "OU=Engineers,OU=Engine Department,CN=Users,$DomainDN"; Groups = @("Engine Engineers", "File Share - Engine"); Title = "Chief Engineer"},
    @{FirstName = "William"; LastName = "Technician"; Username = "W.Technician"; Department = "Engine Department"; OU = "OU=Technicians,OU=Engine Department,CN=Users,$DomainDN"; Groups = @("File Share - Engine"); Title = "Engineering Technician"},
    
    # Hotel Department
    @{FirstName = "Jennifer"; LastName = "Manager"; Username = "J.Manager"; Department = "Hotel Department"; OU = "OU=Management,OU=Hotel Department,CN=Users,$DomainDN"; Groups = @("Hotel Management", "File Share - Hotel"); Title = "Hotel Manager"},
    @{FirstName = "Lisa"; LastName = "Staff"; Username = "L.Staff"; Department = "Hotel Department"; OU = "OU=Staff,OU=Hotel Department,CN=Users,$DomainDN"; Groups = @("File Share - Hotel"); Title = "Hotel Staff"},
    @{FirstName = "Maria"; LastName = "Service"; Username = "M.Service"; Department = "Hotel Department"; OU = "OU=Service Personnel,OU=Hotel Department,CN=Users,$DomainDN"; Groups = @("File Share - Hotel"); Title = "Service Personnel"},
    
    # Guest Services
    @{FirstName = "Patricia"; LastName = "Concierge"; Username = "P.Concierge"; Department = "Guest Services"; OU = "OU=Managers,OU=Guest Services,CN=Users,$DomainDN"; Groups = @("Guest Services Staff", "File Share - Guest Services"); Title = "Guest Services Manager"},
    @{FirstName = "Nancy"; LastName = "Reception"; Username = "N.Reception"; Department = "Guest Services"; OU = "OU=Staff,OU=Guest Services,CN=Users,$DomainDN"; Groups = @("Guest Services Staff", "File Share - Guest Services"); Title = "Reception Staff"}
)

Write-Host "Creating user accounts..." -ForegroundColor Green
Write-Host ""

# Default password (users will be forced to change on first logon)
$DefaultPassword = "TempPass123!" | ConvertTo-SecureString -AsPlainText -Force

$created = 0
$skipped = 0
$errors = 0

foreach ($user in $Users) {
    $firstName = $user.FirstName
    $lastName = $user.LastName
    $username = $user.Username
    $displayName = "$firstName $lastName"
    $department = $user.Department
    $ou = $user.OU
    $groups = $user.Groups
    $title = $user.Title
    $email = "$firstName.$lastName@$DomainName"
    
    try {
        # Check if user already exists
        $existingUser = Get-ADUser -Filter "SamAccountName -eq '$username'" -ErrorAction SilentlyContinue
        
        if ($existingUser) {
            Write-Host "  ⊘ Skipped: $username (already exists)" -ForegroundColor Yellow
            $skipped++
        } else {
            # Create user account
            New-ADUser -Name $displayName `
                       -GivenName $firstName `
                       -Surname $lastName `
                       -SamAccountName $username `
                       -UserPrincipalName "$username@$DomainName" `
                       -DisplayName $displayName `
                       -Path $ou `
                       -Department $department `
                       -Title $title `
                       -EmailAddress $email `
                       -AccountPassword $DefaultPassword `
                       -Enabled $true `
                       -PasswordNeverExpires $false `
                       -ChangePasswordAtLogon $true
            
            # Add user to groups
            foreach ($group in $groups) {
                try {
                    Add-ADGroupMember -Identity $group -Members $username -ErrorAction SilentlyContinue
                } catch {
                    Write-Host "    ⚠ Warning: Could not add $username to $group" -ForegroundColor Yellow
                }
            }
            
            Write-Host "  ✓ Created: $username ($displayName) - $title" -ForegroundColor Green
            Write-Host "    OU: $ou" -ForegroundColor Gray
            Write-Host "    Groups: $($groups -join ', ')" -ForegroundColor Gray
            $created++
        }
    } catch {
        Write-Host "  ✗ Error creating $username : $_" -ForegroundColor Red
        $errors++
    }
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Summary" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  Created:  $created users" -ForegroundColor Green
Write-Host "  Skipped:   $skipped users (already exist)" -ForegroundColor Yellow
Write-Host "  Errors:    $errors users" -ForegroundColor $(if ($errors -gt 0) { "Red" } else { "Green" })
Write-Host ""
Write-Host "Default Password: TempPass123!" -ForegroundColor Yellow
Write-Host "Users must change password at first logon." -ForegroundColor Yellow
Write-Host ""

if ($errors -eq 0) {
    Write-Host "User accounts created successfully!" -ForegroundColor Green
} else {
    Write-Host "Some users could not be created. Please review errors above." -ForegroundColor Yellow
}

Write-Host ""

