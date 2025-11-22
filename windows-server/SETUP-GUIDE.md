# Module A - Complete Setup Guide

This guide walks you through the complete setup of Module A - Windows & Departmental Systems from start to finish.

---

## 📋 Prerequisites

### **Hardware Requirements**
- **Host Machine:** 16GB+ RAM recommended, 100GB+ free disk space
- **Virtualization Software:** VMware Workstation Pro, VirtualBox, or Hyper-V

### **Software Requirements**
- Windows Server 2019/2022 ISO
- Windows 10/11 ISO (4x copies for client VMs)
- PowerShell 5.1 or later

### **Network Requirements**
- Virtual network adapter configured (NAT or Bridged)
- Ability to create multiple VMs on same network

---

## 🚀 Step-by-Step Setup

### **Phase 1: Virtual Environment Setup**

#### **1.1 Create Virtual Network**

**VMware:**
1. Edit > Virtual Network Editor
2. Create VMnet (e.g., VMnet2)
3. Configure as NAT or Bridged
4. Subnet: 10.20.20.0/24

**VirtualBox:**
1. File > Host Network Manager
2. Create new network adapter
3. Configure IP: 10.20.20.1/24

**Hyper-V:**
1. Virtual Switch Manager
2. Create Internal or External switch
3. Configure subnet

#### **1.2 Create Domain Controller VM (DC01)**

**Specifications:**
- **Name:** DC01
- **OS:** Windows Server 2019/2022
- **RAM:** 4GB minimum (8GB recommended)
- **Disk:** 60GB
- **Network:** Connect to virtual network
- **IP:** 10.20.20.10 (static, configure after OS install)

**Installation Steps:**
1. Create new VM
2. Attach Windows Server ISO
3. Install Windows Server (Desktop Experience)
4. Set administrator password
5. Complete initial setup

**Configure Static IP:**
```powershell
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress 10.20.20.10 -PrefixLength 24 -DefaultGateway 10.20.20.1
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 127.0.0.1
```

#### **1.3 Create File Server VM (FS01)**

**Specifications:**
- **Name:** FS01
- **OS:** Windows Server 2019/2022
- **RAM:** 4GB
- **Disk:** 80GB (for file shares)
- **Network:** Same virtual network
- **IP:** 10.20.20.20 (static, configure after OS install)

Follow same installation steps as DC01.

#### **1.4 Create Client VMs**

Create 4x Windows 10/11 VMs:

| VM Name | Department | IP (DHCP) | RAM | Disk |
|--------|------------|-----------|-----|------|
| DECK-WS01 | Deck | Auto | 2GB | 40GB |
| ENGINE-WS01 | Engine | Auto | 2GB | 40GB |
| HOTEL-WS01 | Hotel | Auto | 2GB | 40GB |
| GUEST-WS01 | Guest Services | Auto | 2GB | 40GB |

**Installation:**
1. Create VMs with Windows 10/11
2. Configure to obtain IP automatically
3. Set computer names
4. Complete initial setup

---

### **Phase 2: Active Directory Setup**

#### **2.1 Install Active Directory Domain Services**

**On DC01:**

1. **Copy script to DC01:**
   - Copy `01-Install-ADDS.ps1` to DC01
   - Or manually install via Server Manager

2. **Run installation script:**
   ```powershell
   .\01-Install-ADDS.ps1
   ```
   
   **OR Manual Installation:**
   - Server Manager > Add Roles and Features
   - Select "Active Directory Domain Services"
   - Install
   - Promote this server to a domain controller
   - Create new forest: `CRUISE.LOCAL`
   - Set DSRM password
   - Complete installation (server will restart)

3. **After restart, log in as:** `CRUISE\Administrator`

#### **2.2 Create Organizational Units**

**On DC01:**

```powershell
.\02-Create-OUs.ps1
```

This creates the complete OU structure for departments.

#### **2.3 Create Security Groups**

**On DC01:**

```powershell
.\03-Create-SecurityGroups.ps1
```

This creates all security groups for departments and file shares.

---

### **Phase 3: DNS Configuration**

#### **3.1 Configure DNS Zones and Records**

**On DC01:**

```powershell
.\04-Configure-DNS.ps1
```

This script:
- Creates reverse lookup zones
- Adds DNS records (DC01, DC02, FS01)
- Configures DNS forwarders

**Verify DNS:**
```powershell
nslookup DC01.cruise.local
nslookup 10.20.20.10
```

---

### **Phase 4: DHCP Configuration**

#### **4.1 Join FS01 to Domain**

**On FS01:**

1. Configure DNS to point to DC01 (10.20.20.10)
2. Run join script:
   ```powershell
   .\08-Join-ComputerToDomain.ps1
   ```
3. Restart and log in as domain user

#### **4.2 Install and Configure DHCP**

**On FS01:**

```powershell
.\05-Install-DHCP.ps1
```

This script:
- Installs DHCP Server role
- Authorizes DHCP in AD
- Creates scopes for VLANs
- Configures exclusions

**Verify DHCP:**
- Check scopes in DHCP console
- Test from client VM (release/renew IP)

---

### **Phase 5: User Account Creation**

#### **5.1 Create User Accounts**

**On DC01:**

```powershell
.\06-Create-Users.ps1
```

This creates sample users for each department.

**Default Password:** `TempPass123!`  
**Users must change password at first logon.**

---

### **Phase 6: File Shares**

#### **6.1 Create File Shares**

**On FS01:**

```powershell
.\07-Create-FileShares.ps1
```

This script:
- Creates shared folders for each department
- Configures share permissions
- Sets NTFS permissions
- Creates subfolders

**Verify Shares:**
- Test access from client VMs
- Verify permissions are correct

---

### **Phase 7: Join Client Workstations**

#### **7.1 Join Each Client VM to Domain**

**On each client VM (DECK-WS01, ENGINE-WS01, etc.):**

1. Configure DNS to point to DC01 (10.20.20.10)
2. Run join script:
   ```powershell
   .\08-Join-ComputerToDomain.ps1
   ```
3. Restart
4. Log in with domain user credentials

**OR Manual Join:**
- System Properties > Computer Name > Change
- Select "Domain" > Enter: `CRUISE.LOCAL`
- Provide domain admin credentials
- Restart

---

### **Phase 8: Group Policy Configuration**

#### **8.1 Configure Default Domain Policy**

**On DC01:**

1. Open Group Policy Management Console (GPMC)
2. Edit "Default Domain Policy"
3. Configure Password Policy:
   - Minimum length: 12 characters
   - Complexity: Enabled
   - Maximum age: 90 days
4. Configure Account Lockout Policy:
   - Threshold: 5 attempts
   - Duration: 30 minutes

#### **8.2 Create Department GPOs**

**On DC01:**

1. Create new GPO: "Desktop Environment - Deck"
2. Link to: OU=Deck Department,CN=Users,DC=cruise,DC=local
3. Configure desktop settings
4. Repeat for other departments

**See:** `docs/procedures/group-policy-configuration.md` for detailed GPO setup.

---

### **Phase 9: Testing and Validation**

#### **9.1 Test Checklist**

- [ ] **Domain Authentication**
  - Log in to client VM with domain user
  - Verify user can authenticate

- [ ] **DNS Resolution**
  - Test: `nslookup DC01.cruise.local`
  - Test: `nslookup google.com`

- [ ] **DHCP Leasing**
  - Verify client gets IP from DHCP scope
  - Check DNS servers are assigned correctly

- [ ] **File Share Access**
  - Access: `\\FS01\Deck` from Deck user
  - Verify read/write permissions
  - Test access denied for unauthorized users

- [ ] **GPO Application**
  - Run: `gpresult /r`
  - Verify GPOs are applied
  - Check settings are enforced

- [ ] **User Permissions**
  - Test user can access department share
  - Verify user cannot access other department shares

---

### **Phase 10: Documentation and Screenshots**

#### **10.1 Capture Screenshots**

Capture screenshots of:
- [ ] AD DS installation
- [ ] Domain creation
- [ ] OU structure
- [ ] Security groups
- [ ] DNS zones and records
- [ ] DHCP scopes
- [ ] File shares
- [ ] GPO configuration
- [ ] User accounts
- [ ] Client domain join
- [ ] GPO application (gpresult)
- [ ] File share access test
- [ ] DNS resolution test

**Save to:** `windows-server/screenshots/`

#### **10.2 Create Diagrams**

Create:
- [ ] Active Directory structure diagram
- [ ] Network topology diagram
- [ ] File share permissions diagram

**Save to:** `docs/diagrams/`

---

## 🐛 Troubleshooting

### **Common Issues**

**Cannot join domain:**
- Verify DNS points to DC01
- Check network connectivity
- Verify domain controller is accessible
- Check domain credentials

**GPO not applying:**
- Run `gpupdate /force`
- Verify OU placement
- Check GPO link status
- Review Event Viewer logs

**File share access denied:**
- Verify user is in correct security group
- Check share permissions
- Verify NTFS permissions
- Check user is logged in with domain account

**DHCP not leasing:**
- Verify DHCP server is authorized
- Check scope is active
- Verify network connectivity
- Check DHCP service is running

---

## ✅ Completion Checklist

- [ ] All VMs created and configured
- [ ] Domain controller installed and configured
- [ ] OUs and security groups created
- [ ] DNS configured and working
- [ ] DHCP installed and configured
- [ ] User accounts created
- [ ] File shares created and permissions set
- [ ] Client workstations joined to domain
- [ ] GPOs created and linked
- [ ] All services tested and working
- [ ] Screenshots captured
- [ ] Diagrams created
- [ ] Documentation updated

---

## 📚 Next Steps

After completing Module A:
1. Review all configurations
2. Document any customizations
3. Prepare for Module B (Network Infrastructure)
4. Update project progress tracker

---

**Last Updated:** 2024 | **Status:** Active Guide

