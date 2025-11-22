# Windows Server Module

This directory contains all resources for Module A - Windows & Departmental Systems.

## 📋 Overview

This module establishes the enterprise Windows Server infrastructure for the Smart Cruise Vessel IT simulation, including:
- Active Directory Domain Services (AD DS)
- DNS and DHCP services
- File services and permissions
- Group Policy Objects (GPOs)
- Multi-department client environments

## 📁 Directory Structure

```
windows-server/
├── README.md              # This file
├── scripts/               # PowerShell automation scripts
│   ├── 01-Install-ADDS.ps1
│   ├── 02-Create-OUs.ps1
│   ├── 03-Create-SecurityGroups.ps1
│   ├── 04-Configure-DNS.ps1
│   └── 05-Install-DHCP.ps1
├── screenshots/           # Configuration screenshots
└── configs/               # Configuration files and exports
```

## 🚀 Quick Start Guide

### Prerequisites

- Windows Server 2019/2022 (VM or physical)
- Administrator access
- Network connectivity
- At least 4GB RAM, 40GB disk space

### Installation Steps

1. **Install Active Directory Domain Services**
   ```powershell
   .\scripts\01-Install-ADDS.ps1
   ```
   - Prompts for Safe Mode Administrator password
   - Creates CRUISE.LOCAL domain
   - Server will restart automatically

2. **Create Organizational Units**
   ```powershell
   .\scripts\02-Create-OUs.ps1
   ```
   - Creates OU structure for departments
   - Sets up Computers and Users containers

3. **Create Security Groups**
   ```powershell
   .\scripts\03-Create-SecurityGroups.ps1
   ```
   - Creates department security groups
   - Sets up file share access groups

4. **Configure DNS**
   ```powershell
   .\scripts\04-Configure-DNS.ps1
   ```
   - Creates reverse lookup zones
   - Adds DNS records
   - Configures forwarders

5. **Install and Configure DHCP**
   ```powershell
   .\scripts\05-Install-DHCP.ps1
   ```
   - Installs DHCP Server role
   - Creates scopes for VLANs
   - Configures exclusions

## 📖 Detailed Documentation

- **[Windows Infrastructure Architecture](../docs/architecture/windows-infrastructure.md)** - Complete architecture design
- **[IT Support Workflows](../docs/procedures/it-support-workflows.md)** - Operational procedures

## 🔧 Manual Configuration (Alternative)

If you prefer manual configuration or need to customize:

1. **Active Directory**
   - Server Manager > Add Roles > Active Directory Domain Services
   - Promote to Domain Controller
   - Create OUs manually in Active Directory Users and Computers

2. **DNS**
   - DNS Manager > Create zones
   - Add A and CNAME records
   - Configure forwarders

3. **DHCP**
   - Server Manager > Add Roles > DHCP Server
   - Authorize in Active Directory
   - Create scopes manually

## 📸 Screenshots Checklist

Capture screenshots of:
- [ ] AD DS installation
- [ ] Domain creation
- [ ] OU structure
- [ ] Security groups
- [ ] DNS zones and records
- [ ] DHCP scopes
- [ ] File shares and permissions
- [ ] GPO configuration
- [ ] User account creation
- [ ] Client domain join
- [ ] GPO application verification
- [ ] File share access test
- [ ] DNS resolution test
- [ ] DHCP lease test

## ✅ Verification Checklist

After setup, verify:
- [ ] Domain controllers can replicate
- [ ] DNS resolves internal and external names
- [ ] DHCP distributes IP addresses
- [ ] Users can authenticate
- [ ] File shares are accessible with correct permissions
- [ ] GPOs apply to appropriate OUs
- [ ] Client workstations can join domain

## 🐛 Troubleshooting

### Common Issues

**Cannot join domain:**
- Verify DNS resolution to domain controller
- Check network connectivity
- Verify domain credentials

**GPO not applying:**
- Run `gpupdate /force` on client
- Verify OU placement
- Check GPO link status

**DNS resolution fails:**
- Verify DNS server IP in network settings
- Check DNS server service is running
- Test with `nslookup`

**DHCP not leasing:**
- Verify DHCP server is authorized
- Check scope is active
- Verify network connectivity

## 📝 Next Steps

After completing Windows Server setup:
1. Create user accounts
2. Join client workstations to domain
3. Configure file shares
4. Create and link GPOs
5. Test all services
6. Document configurations
7. Capture screenshots

## 🔗 Related Modules

- **Module B:** Network Infrastructure & Zoning
- **Module C:** Monitoring, Data Analytics & IoT
- **Module D:** Guest/Service Experience & Collaboration

---

**Last Updated:** 2024 | **Status:** In Progress

