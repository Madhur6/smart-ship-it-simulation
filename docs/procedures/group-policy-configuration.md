# Group Policy Objects (GPO) Configuration Guide

## 📋 Overview

This guide provides detailed instructions for creating and configuring Group Policy Objects (GPOs) in the CRUISE.LOCAL domain. GPOs enforce security settings, desktop configurations, and software deployment across departments.

---

## 🎯 GPO Strategy

### **GPO Hierarchy**

1. **Domain-Level GPOs:** Apply to entire domain
   - Default Domain Policy (password, account lockout)
   - Security Settings
   - Software Deployment (if applicable)

2. **OU-Level GPOs:** Apply to specific departments
   - Desktop Environment - Deck
   - Desktop Environment - Engine
   - Desktop Environment - Hotel
   - Desktop Environment - Guest Services

3. **Computer-Level GPOs:** Apply to specific computer types
   - Default Domain Controllers Policy
   - Server Security Settings

### **GPO Processing Order**

GPOs are processed in this order:
1. Local GPO
2. Site GPOs
3. Domain GPOs
4. OU GPOs (parent to child)
5. Nested OU GPOs

**Note:** If multiple GPOs are linked, they process in link order (highest priority first).

---

## 🔐 Domain-Level GPOs

### **Default Domain Policy**

This GPO is created automatically with the domain. Modify it to enforce password and account policies.

#### **Password Policy**

**Location:** Computer Configuration > Policies > Windows Settings > Security Settings > Account Policies > Password Policy

**Recommended Settings:**

| Setting | Value | Description |
|---------|-------|-------------|
| Enforce password history | 24 passwords remembered | Prevents password reuse |
| Maximum password age | 90 days | Forces periodic password changes |
| Minimum password age | 1 day | Prevents immediate password changes |
| Minimum password length | 12 characters | Enforces strong passwords |
| Password must meet complexity requirements | Enabled | Requires mix of character types |
| Store passwords using reversible encryption | Disabled | Security best practice |

**Configuration via GUI:**
1. Open Group Policy Management Console (GPMC)
2. Expand Forest > Domains > cruise.local
3. Right-click "Default Domain Policy" > Edit
4. Navigate to: Computer Configuration > Policies > Windows Settings > Security Settings > Account Policies > Password Policy
5. Configure each setting
6. Close GPO Editor

**Configuration via PowerShell:**
```powershell
# Note: Password policy must be set via Default Domain Policy
# These settings are domain-wide and cannot be set via other GPOs

# Set password policy (requires RSAT or run on DC)
$GPO = Get-GPO -Name "Default Domain Policy"
Set-GPRegistryValue -Name "Default Domain Policy" `
                   -Key "HKLM\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" `
                   -ValueName "MaximumPasswordAge" `
                   -Type DWord `
                   -Value 90
```

#### **Account Lockout Policy**

**Location:** Computer Configuration > Policies > Windows Settings > Security Settings > Account Policies > Account Lockout Policy

**Recommended Settings:**

| Setting | Value | Description |
|---------|-------|-------------|
| Account lockout duration | 30 minutes | Time before account automatically unlocks |
| Account lockout threshold | 5 invalid logon attempts | Number of failed attempts before lockout |
| Reset account lockout counter after | 30 minutes | Time before failed attempt counter resets |

**Configuration via GUI:**
1. Edit Default Domain Policy
2. Navigate to: Computer Configuration > Policies > Windows Settings > Security Settings > Account Policies > Account Lockout Policy
3. Configure each setting
4. Close GPO Editor

---

## 🖥️ Department-Specific GPOs

### **Desktop Environment - Deck Department**

**Purpose:** Customize desktop environment for Deck department users.

**Linked To:** OU=Deck Department,CN=Users,DC=cruise,DC=local

#### **Desktop Settings**

**Location:** User Configuration > Policies > Administrative Templates > Desktop

**Settings:**
- **Desktop Wallpaper:** Set department-specific wallpaper (optional)
- **Remove Recycle Bin from Desktop:** Disabled
- **Prohibit User from changing My Documents path:** Enabled

#### **Start Menu and Taskbar**

**Location:** User Configuration > Policies > Administrative Templates > Start Menu and Taskbar

**Settings:**
- **Remove Run menu from Start Menu:** Disabled
- **Remove Search from Start Menu:** Disabled
- **Remove frequent programs list from Start Menu:** Disabled

#### **Control Panel**

**Location:** User Configuration > Policies > Administrative Templates > Control Panel

**Settings:**
- **Prohibit access to Control Panel:** Disabled (allow access)
- **Hide specified Control Panel items:** Configure as needed

**Creation Steps:**
1. Open GPMC
2. Right-click Group Policy Objects > New
3. Name: "Desktop Environment - Deck"
4. Right-click new GPO > Edit
5. Configure settings under User Configuration
6. Link GPO to: OU=Deck Department,CN=Users,DC=cruise,DC=local

### **Desktop Environment - Engine Department**

Follow same steps as Deck Department, customize for Engineering needs.

**Additional Settings:**
- **Software Restrictions:** Allow engineering-specific applications
- **Printer Access:** Configure engineering printer access

### **Desktop Environment - Hotel Department**

Follow same steps as Deck Department, customize for Hotel operations.

**Additional Settings:**
- **POS System Access:** Configure point-of-sale system shortcuts
- **Guest Services Applications:** Allow hotel management software

### **Desktop Environment - Guest Services**

Follow same steps as Deck Department, customize for Guest Services.

**Additional Settings:**
- **Check-in System Access:** Configure guest check-in applications
- **Concierge Tools:** Allow concierge-specific software

---

## 🔒 Security Settings GPO

### **Computer Security Settings**

**Purpose:** Enforce security hardening across all computers.

**Linked To:** Domain (or specific OUs)

#### **Local Policies - Audit Policy**

**Location:** Computer Configuration > Policies > Windows Settings > Security Settings > Local Policies > Audit Policy

**Recommended Settings:**

| Policy | Setting | Description |
|--------|---------|-------------|
| Audit account logon events | Success, Failure | Track authentication attempts |
| Audit account management | Success, Failure | Track user account changes |
| Audit directory service access | Success, Failure | Track AD object access |
| Audit logon events | Success, Failure | Track logon/logoff events |
| Audit object access | Success | Track file/folder access |
| Audit policy change | Success, Failure | Track policy changes |
| Audit privilege use | Success, Failure | Track privilege usage |
| Audit system events | Success, Failure | Track system events |

#### **User Rights Assignment**

**Location:** Computer Configuration > Policies > Windows Settings > Security Settings > Local Policies > User Rights Assignment

**Key Settings:**

| Policy | Assignment | Description |
|--------|------------|-------------|
| Allow log on locally | Domain Users (workstations only) | Allow domain users to log on |
| Deny log on locally | Guest | Prevent guest account logon |
| Allow log on through Remote Desktop Services | IT Support, Administrators | Control RDP access |
| Change the system time | Administrators, IT Support | Control time changes |

#### **Security Options**

**Location:** Computer Configuration > Policies > Windows Settings > Security Settings > Local Policies > Security Options

**Key Settings:**

| Policy | Setting | Description |
|--------|---------|-------------|
| Accounts: Rename administrator account | [Custom name] | Rename default admin account |
| Interactive logon: Do not display last user name | Enabled | Security best practice |
| Interactive logon: Require Domain Controller authentication to unlock workstation | Enabled | Require DC for unlock |
| Network access: Do not allow anonymous enumeration of SAM accounts | Enabled | Prevent anonymous enumeration |
| Network security: Force logoff when logon hours expire | Enabled | Enforce logon hours |

---

## 📦 Software Deployment (Optional)

### **Software Installation via GPO**

**Purpose:** Deploy software automatically to computers or users.

#### **Computer-Based Software Deployment**

**Location:** Computer Configuration > Policies > Software Settings > Software Installation

**Steps:**
1. Create shared folder with software installation files
2. Copy MSI file to shared folder
3. Set appropriate share and NTFS permissions
4. Edit GPO
5. Right-click "Software Installation" > New > Package
6. Browse to MSI file
7. Select deployment method:
   - **Assigned:** Install automatically
   - **Published:** Available in Add/Remove Programs
8. Configure installation options

#### **User-Based Software Deployment**

**Location:** User Configuration > Policies > Software Settings > Software Installation

Follow same steps as computer-based, but under User Configuration.

---

## 🔄 GPO Management

### **GPO Backup and Restore**

**Backup GPO:**
```powershell
Backup-GPO -Name "Desktop Environment - Deck" -Path "C:\GPOBackups"
```

**Restore GPO:**
```powershell
Restore-GPO -Name "Desktop Environment - Deck" -Path "C:\GPOBackups"
```

**Backup All GPOs:**
```powershell
Get-GPO -All | Backup-GPO -Path "C:\GPOBackups"
```

### **GPO Import/Export**

**Export GPO:**
```powershell
Get-GPO -Name "Desktop Environment - Deck" | Export-GPO -Path "C:\GPOExports\Deck-GPO"
```

**Import GPO:**
```powershell
Import-GPO -BackupId [GUID] -Path "C:\GPOExports\Deck-GPO" -TargetName "Desktop Environment - Deck"
```

### **GPO Reporting**

**Generate HTML Report:**
```powershell
Get-GPOReport -Name "Desktop Environment - Deck" -ReportType Html -Path "C:\Reports\Deck-GPO.html"
```

**Generate XML Report:**
```powershell
Get-GPOReport -Name "Desktop Environment - Deck" -ReportType Xml -Path "C:\Reports\Deck-GPO.xml"
```

---

## ✅ GPO Testing and Validation

### **Testing Procedure**

1. **Create Test OU:**
   - Create test OU with test user/computer
   - Link GPO to test OU

2. **Apply GPO:**
   - Run `gpupdate /force` on test computer
   - Restart computer if needed

3. **Verify Settings:**
   - Log in as test user
   - Verify GPO settings are applied
   - Check Event Viewer for GPO errors

4. **Production Deployment:**
   - Once verified, link GPO to production OU
   - Monitor for issues
   - Document any exceptions

### **GPO Verification Commands**

**Check GPO application:**
```powershell
gpresult /r
gpresult /h report.html
```

**Force GPO update:**
```powershell
gpupdate /force
```

**Check GPO processing:**
```powershell
Get-GPResultantSetOfPolicy -User [username] -Computer [computername]
```

---

## 🐛 Troubleshooting

### **Common Issues**

**Problem: GPO not applying**

**Solutions:**
1. Verify GPO is linked to correct OU
2. Check GPO link order (higher priority = processed first)
3. Verify GPO is not disabled
4. Check if GPO is blocked by inheritance
5. Run `gpupdate /force` on client
6. Check Event Viewer > Application and Services Logs > Microsoft > Windows > GroupPolicy

**Problem: Settings not taking effect**

**Solutions:**
1. Verify setting is configured correctly
2. Check if setting is overridden by another GPO
3. Verify user/computer is in correct OU
4. Check GPO processing order
5. Restart computer (some settings require restart)

**Problem: GPO processing slow**

**Solutions:**
1. Reduce number of GPOs linked to OU
2. Optimize GPO settings (remove unused settings)
3. Check network connectivity to domain controller
4. Verify DNS resolution is working
5. Check domain controller performance

---

## 📊 GPO Best Practices

1. **Naming Convention:**
   - Use descriptive names (e.g., "Desktop Environment - Deck")
   - Include purpose in name
   - Use consistent naming across organization

2. **Organization:**
   - Group related settings in same GPO
   - Avoid too many GPOs (consolidate when possible)
   - Document GPO purpose and settings

3. **Security:**
   - Use security filtering to limit GPO scope
   - Regularly review GPO settings
   - Test GPOs before production deployment

4. **Performance:**
   - Minimize GPO processing time
   - Use item-level targeting when possible
   - Avoid unnecessary GPO links

5. **Maintenance:**
   - Regularly backup GPOs
   - Document all changes
   - Review and update GPOs quarterly

---

## 📝 GPO Documentation Template

For each GPO, document:
- **GPO Name:** [Name]
- **Purpose:** [Why this GPO exists]
- **Linked To:** [OU or domain]
- **Settings Configured:** [List of key settings]
- **Target Users/Computers:** [Who/what is affected]
- **Last Modified:** [Date]
- **Modified By:** [Name]
- **Testing Status:** [Tested/Not Tested]
- **Notes:** [Any special considerations]

---

**Last Updated:** 2024 | **Version:** 1.0.0 | **Status:** Active

