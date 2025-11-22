# Create File Shares
# This script creates shared folders for each department
# Run this script on the File Server (FS01) after it's joined to domain

#Requires -RunAsAdministrator

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Create File Shares" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Import required modules
Import-Module ActiveDirectory

# Configuration
$ShareRoot = "C:\Shares"
$DomainName = (Get-ADDomain).DNSRoot

Write-Host "Share Root: $ShareRoot" -ForegroundColor Yellow
Write-Host "Domain: $DomainName" -ForegroundColor Yellow
Write-Host ""

# Check if running on File Server
$computerName = $env:COMPUTERNAME
if ($computerName -ne "FS01") {
    Write-Host "⚠ Warning: This script is designed to run on FS01" -ForegroundColor Yellow
    Write-Host "  Current computer: $computerName" -ForegroundColor Yellow
    $continue = Read-Host "Continue anyway? (Y/N)"
    if ($continue -ne "Y" -and $continue -ne "y") {
        exit 0
    }
}

# Define file shares
$FileShares = @(
    @{
        Name = "Deck"
        Path = "$ShareRoot\Deck"
        Description = "Deck Department Shared Folder"
        SharePermissions = @{Identity = "CRUISE\File Share - Deck"; AccessControlType = "Allow"; Rights = "Change"}
        NTFSPermissions = @(
            @{Identity = "CRUISE\File Share - Deck"; Rights = "Modify"}
            @{Identity = "CRUISE\Deck Officers"; Rights = "FullControl"}
        )
        Subfolders = @("Operations", "Reports", "Public")
    },
    @{
        Name = "Engine"
        Path = "$ShareRoot\Engine"
        Description = "Engine Department Shared Folder"
        SharePermissions = @{Identity = "CRUISE\File Share - Engine"; AccessControlType = "Allow"; Rights = "Change"}
        NTFSPermissions = @(
            @{Identity = "CRUISE\File Share - Engine"; Rights = "Modify"}
            @{Identity = "CRUISE\Engine Engineers"; Rights = "FullControl"}
        )
        Subfolders = @("Maintenance", "Logs", "Reports")
    },
    @{
        Name = "Hotel"
        Path = "$ShareRoot\Hotel"
        Description = "Hotel Department Shared Folder"
        SharePermissions = @{Identity = "CRUISE\File Share - Hotel"; AccessControlType = "Allow"; Rights = "Change"}
        NTFSPermissions = @(
            @{Identity = "CRUISE\File Share - Hotel"; Rights = "Modify"}
            @{Identity = "CRUISE\Hotel Management"; Rights = "FullControl"}
        )
        Subfolders = @("Operations", "Guest Data", "Reports")
    },
    @{
        Name = "GuestServices"
        Path = "$ShareRoot\GuestServices"
        Description = "Guest Services Shared Folder"
        SharePermissions = @{Identity = "CRUISE\File Share - Guest Services"; AccessControlType = "Allow"; Rights = "Change"}
        NTFSPermissions = @(
            @{Identity = "CRUISE\File Share - Guest Services"; Rights = "Modify"}
            @{Identity = "CRUISE\Guest Services Staff"; Rights = "FullControl"}
        )
        Subfolders = @("CheckIn", "Concierge", "Reports")
    },
    @{
        Name = "IT"
        Path = "$ShareRoot\IT"
        Description = "IT Department Shared Folder"
        SharePermissions = @{Identity = "CRUISE\IT Support"; AccessControlType = "Allow"; Rights = "FullControl"}
        NTFSPermissions = @(
            @{Identity = "CRUISE\IT Support"; Rights = "FullControl"}
            @{Identity = "CRUISE\Domain Admins"; Rights = "FullControl"}
        )
        Subfolders = @("Scripts", "Documentation", "Software")
    },
    @{
        Name = "Public"
        Path = "$ShareRoot\Public"
        Description = "Public Shared Folder"
        SharePermissions = @{Identity = "Everyone"; AccessControlType = "Allow"; Rights = "Read"}
        NTFSPermissions = @(
            @{Identity = "Everyone"; Rights = "Read"}
        )
        Subfolders = @("Shared")
    }
)

Write-Host "Step 1: Creating share root directory..." -ForegroundColor Green
try {
    if (-not (Test-Path $ShareRoot)) {
        New-Item -ItemType Directory -Path $ShareRoot -Force | Out-Null
        Write-Host "  ✓ Created: $ShareRoot" -ForegroundColor Green
    } else {
        Write-Host "  ⊘ Already exists: $ShareRoot" -ForegroundColor Yellow
    }
} catch {
    Write-Host "  ✗ Error creating share root: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Step 2: Creating folders and shares..." -ForegroundColor Green
Write-Host ""

$created = 0
$skipped = 0
$errors = 0

foreach ($share in $FileShares) {
    $shareName = $share.Name
    $sharePath = $share.Path
    $shareDescription = $share.Description
    $subfolders = $share.Subfolders
    
    try {
        # Create folder if it doesn't exist
        if (-not (Test-Path $sharePath)) {
            New-Item -ItemType Directory -Path $sharePath -Force | Out-Null
            Write-Host "  ✓ Created folder: $sharePath" -ForegroundColor Green
        }
        
        # Create subfolders
        foreach ($subfolder in $subfolders) {
            $subfolderPath = Join-Path $sharePath $subfolder
            if (-not (Test-Path $subfolderPath)) {
                New-Item -ItemType Directory -Path $subfolderPath -Force | Out-Null
            }
        }
        
        # Check if share already exists
        $existingShare = Get-SmbShare -Name $shareName -ErrorAction SilentlyContinue
        
        if ($existingShare) {
            Write-Host "  ⊘ Skipped share: $shareName (already exists)" -ForegroundColor Yellow
            $skipped++
        } else {
            # Create SMB share
            New-SmbShare -Name $shareName `
                         -Path $sharePath `
                         -Description $shareDescription `
                         -FullAccess "CRUISE\Domain Admins" | Out-Null
            
            # Configure share permissions
            $sharePerm = $share.SharePermissions
            Grant-SmbShareAccess -Name $shareName `
                                -AccountName $sharePerm.Identity `
                                -AccessRight $sharePerm.Rights `
                                -Force | Out-Null
            
            # Configure NTFS permissions
            foreach ($ntfsPerm in $share.NTFSPermissions) {
                $acl = Get-Acl $sharePath
                $permission = $ntfsPerm.Identity, $ntfsPerm.Rights, "ContainerInherit,ObjectInherit", "None", "Allow"
                $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
                $acl.SetAccessRule($accessRule)
                Set-Acl -Path $sharePath -AclObject $acl
            }
            
            Write-Host "  ✓ Created share: $shareName" -ForegroundColor Green
            Write-Host "    Path: $sharePath" -ForegroundColor Gray
            Write-Host "    Subfolders: $($subfolders -join ', ')" -ForegroundColor Gray
            $created++
        }
    } catch {
        Write-Host "  ✗ Error creating share $shareName : $_" -ForegroundColor Red
        $errors++
    }
}

Write-Host ""
Write-Host "Step 3: Configuring quota management..." -ForegroundColor Green

try {
    # Install File Server Resource Manager if not installed
    $fsrmInstalled = Get-WindowsFeature -Name FS-Resource-Manager | Where-Object { $_.InstallState -eq "Installed" }
    if (-not $fsrmInstalled) {
        Write-Host "  ⚠ File Server Resource Manager not installed. Quota management skipped." -ForegroundColor Yellow
        Write-Host "    Install FS-Resource-Manager feature to enable quota management." -ForegroundColor Yellow
    } else {
        Write-Host "  ✓ Quota management available (configure manually if needed)" -ForegroundColor Green
    }
} catch {
    Write-Host "  ⚠ Could not check File Server Resource Manager: $_" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Summary" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  Created:  $created shares" -ForegroundColor Green
Write-Host "  Skipped:   $skipped shares (already exist)" -ForegroundColor Yellow
Write-Host "  Errors:    $errors shares" -ForegroundColor $(if ($errors -gt 0) { "Red" } else { "Green" })
Write-Host ""

if ($errors -eq 0) {
    Write-Host "File shares created successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Share paths:" -ForegroundColor Yellow
    foreach ($share in $FileShares) {
        Write-Host "  \\$computerName\$($share.Name) -> $($share.Path)" -ForegroundColor White
    }
} else {
    Write-Host "Some shares could not be created. Please review errors above." -ForegroundColor Yellow
}

Write-Host ""

