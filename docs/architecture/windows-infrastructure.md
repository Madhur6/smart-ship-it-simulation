# Windows Infrastructure Architecture

## 📋 Overview

This document outlines the Windows Server infrastructure design for the Smart Cruise Vessel IT simulation. The architecture supports multiple departments (Deck, Engine, Hotel, Guest Services) with centralized identity management, file services, and policy enforcement.

---

## 🏗️ Architecture Design

### **Domain Structure**

- **Domain Name:** `CRUISE.LOCAL`
- **Forest Functional Level:** Windows Server 2016 or higher
- **Domain Functional Level:** Windows Server 2016 or higher
- **DNS Name:** cruise.local

### **Server Infrastructure**

#### **Primary Domain Controller (DC01)**
- **Role:** Domain Controller, DNS Server
- **OS:** Windows Server 2019/2022
- **IP Address:** 10.20.20.10
- **Services:**
  - Active Directory Domain Services (AD DS)
  - DNS Server
  - Global Catalog
  - Operations Master Roles (all 5 FSMO roles)

#### **Secondary Domain Controller (DC02)**
- **Role:** Domain Controller, DNS Server (Secondary)
- **OS:** Windows Server 2019/2022
- **IP Address:** 10.20.20.11
- **Services:**
  - Active Directory Domain Services (AD DS)
  - DNS Server
  - Global Catalog
  - Backup Operations Master (if needed)

#### **File Server / DHCP Server (FS01)**
- **Role:** File Server, DHCP Server
- **OS:** Windows Server 2019/2022
- **IP Address:** 10.20.20.20
- **Services:**
  - File and Storage Services
  - DHCP Server
  - Print Services (optional)

### **Client Workstations**

| Department | Hostname | OS | IP Range | Purpose |
|------------|----------|----|----------|---------| 
| Deck | DECK-WS01 | Windows 10/11 | 10.20.20.100-109 | Navigation, deck operations |
| Engine | ENGINE-WS01 | Windows 10/11 | 10.20.20.110-119 | Engineering systems, monitoring |
| Hotel | HOTEL-WS01 | Windows 10/11 | 10.50.50.100-109 | Hotel operations, guest services |
| Guest Services | GUEST-WS01 | Windows 10/11 | 10.50.50.110-119 | Guest check-in, concierge services |

---

## 📁 Active Directory Structure

### **Organizational Units (OUs)**

```
CRUISE.LOCAL
├── Computers
│   ├── Servers
│   │   ├── Domain Controllers
│   │   └── File Servers
│   └── Workstations
│       ├── Deck Department
│       ├── Engine Department
│       ├── Hotel Department
│       └── Guest Services
├── Users
│   ├── Administrators
│   ├── IT Staff
│   ├── Deck Department
│   │   ├── Officers
│   │   └── Crew
│   ├── Engine Department
│   │   ├── Engineers
│   │   └── Technicians
│   ├── Hotel Department
│   │   ├── Management
│   │   ├── Staff
│   │   └── Service Personnel
│   └── Guest Services
│       ├── Managers
│       └── Staff
└── Groups
    ├── Security Groups
    │   ├── Domain Admins
    │   ├── IT Support
    │   ├── Deck Officers
    │   ├── Engine Engineers
    │   ├── Hotel Management
    │   └── Guest Services Staff
    └── Distribution Groups
```

### **User Account Naming Convention**

- **Format:** `FirstInitial.LastName` (e.g., `J.Smith`)
- **Display Name:** `First Name Last Name` (e.g., `John Smith`)
- **Email:** `firstname.lastname@cruise.local` (if Exchange configured)

### **Security Groups**

| Group Name | Scope | Members | Purpose |
|------------|-------|---------|---------|
| Domain Admins | Domain Local | IT Administrators | Full domain administration |
| IT Support | Global | IT Staff | IT support and troubleshooting |
| Deck Officers | Global | Deck Department Officers | Deck operations access |
| Engine Engineers | Global | Engineering Staff | Engineering systems access |
| Hotel Management | Global | Hotel Managers | Hotel operations management |
| Guest Services Staff | Global | Guest Services Personnel | Guest services systems access |
| File Share - Deck | Domain Local | Deck Department Users | Deck file share access |
| File Share - Engine | Domain Local | Engine Department Users | Engine file share access |
| File Share - Hotel | Domain Local | Hotel Department Users | Hotel file share access |
| File Share - Guest Services | Domain Local | Guest Services Users | Guest Services file share access |

---

## 🌐 DNS Configuration

### **Forward Lookup Zones**

- **Primary Zone:** `cruise.local`
- **Reverse Zone:** `20.20.10.in-addr.arpa` (for 10.20.20.0/24)
- **Additional Zones:**
  - `50.50.10.in-addr.arpa` (for 10.50.50.0/24)

### **DNS Records**

| Record Type | Name | Value | Purpose |
|-------------|------|-------|---------|
| A | DC01 | 10.20.20.10 | Primary Domain Controller |
| A | DC02 | 10.20.20.11 | Secondary Domain Controller |
| A | FS01 | 10.20.20.20 | File Server |
| A | CRUISE-DC | 10.20.20.10 | Domain Controller alias |
| CNAME | www | DC01.cruise.local | Web services (if applicable) |

### **DNS Forwarding**

- **Forwarders:** Configure to forward external queries to:
  - 8.8.8.8 (Google DNS)
  - 1.1.1.1 (Cloudflare DNS)
- **Conditional Forwarding:** None (single domain)

---

## 🔌 DHCP Configuration

### **DHCP Scopes**

#### **Scope 1: Crew/Admin Network (VLAN 20)**
- **Network:** 10.20.20.0/24
- **Subnet Mask:** 255.255.255.0
- **Range:** 10.20.20.100 - 10.20.20.200
- **Exclusions:** 10.20.20.1 - 10.20.20.99 (reserved for servers and network devices)
- **Gateway:** 10.20.20.1
- **DNS Servers:** 10.20.20.10, 10.20.20.11
- **Lease Duration:** 8 days

#### **Scope 2: Hotel Operations (VLAN 50)**
- **Network:** 10.50.50.0/24
- **Subnet Mask:** 255.255.255.0
- **Range:** 10.50.50.100 - 10.50.50.200
- **Exclusions:** 10.50.50.1 - 10.50.50.99
- **Gateway:** 10.50.50.1
- **DNS Servers:** 10.20.20.10, 10.20.20.11
- **Lease Duration:** 8 days

### **DHCP Reservations**

| Device | MAC Address | IP Address | Purpose |
|--------|-------------|------------|---------|
| DC01 | [MAC] | 10.20.20.10 | Domain Controller |
| DC02 | [MAC] | 10.20.20.11 | Domain Controller |
| FS01 | [MAC] | 10.20.20.20 | File Server |

---

## 📂 File Services

### **Shared Folders Structure**

```
\\FS01\Shares\
├── DepartmentShares\
│   ├── Deck\
│   │   ├── Operations\
│   │   ├── Reports\
│   │   └── Public\
│   ├── Engine\
│   │   ├── Maintenance\
│   │   ├── Logs\
│   │   └── Reports\
│   ├── Hotel\
│   │   ├── Operations\
│   │   ├── Guest Data\
│   │   └── Reports\
│   └── GuestServices\
│       ├── CheckIn\
│       ├── Concierge\
│       └── Reports\
├── IT\
│   ├── Scripts\
│   ├── Documentation\
│   └── Software\
└── Public\
    └── Shared\
```

### **Share Permissions**

| Share | Share Permissions | NTFS Permissions |
|-------|-------------------|------------------|
| \\FS01\Deck | Deck Department: Change | Deck Officers: Modify<br>Deck Crew: Read |
| \\FS01\Engine | Engine Department: Change | Engine Engineers: Modify<br>Engine Technicians: Read |
| \\FS01\Hotel | Hotel Department: Change | Hotel Management: Full Control<br>Hotel Staff: Modify |
| \\FS01\GuestServices | Guest Services: Change | Guest Services Staff: Modify |
| \\FS01\IT | IT Support: Full Control | IT Support: Full Control |
| \\FS01\Public | Everyone: Read | Everyone: Read |

### **Quota Management**

- **Default Quota:** 5 GB per user
- **Warning Threshold:** 4 GB (80%)
- **Hard Limit:** 5 GB
- **Exceptions:** IT Support: 20 GB, Department Managers: 10 GB

---

## 🔐 Group Policy Objects (GPOs)

### **GPO Structure**

| GPO Name | Linked To | Purpose |
|----------|-----------|---------|
| Default Domain Policy | Domain | Default domain settings |
| Default Domain Controllers Policy | Domain Controllers OU | DC security settings |
| Password Policy | Domain | Password complexity, length, expiration |
| Account Lockout Policy | Domain | Account lockout threshold and duration |
| Desktop Environment - Deck | Deck Department OU | Deck-specific desktop settings |
| Desktop Environment - Engine | Engine Department OU | Engine-specific desktop settings |
| Desktop Environment - Hotel | Hotel Department OU | Hotel-specific desktop settings |
| Desktop Environment - Guest Services | Guest Services OU | Guest Services-specific desktop settings |
| Security Settings | Domain | Security hardening policies |
| Software Deployment | Various OUs | Software installation policies |

### **Key Policy Settings**

#### **Password Policy (Default Domain Policy)**
- **Minimum Password Length:** 12 characters
- **Password Complexity:** Enabled
- **Password History:** Remember last 24 passwords
- **Maximum Password Age:** 90 days
- **Minimum Password Age:** 1 day

#### **Account Lockout Policy**
- **Account Lockout Threshold:** 5 invalid attempts
- **Account Lockout Duration:** 30 minutes
- **Reset Account Lockout Counter:** 30 minutes

#### **Desktop Environment Policies**
- **Desktop Wallpaper:** Department-specific (optional)
- **Screen Saver:** Enabled after 15 minutes
- **Start Menu:** Customized per department
- **Restricted Applications:** Block unauthorized software

---

## 🔒 Security Configuration

### **User Rights Assignment**

- **Log on locally:** Domain Users (workstations only)
- **Deny log on locally:** Guest account
- **Allow log on through Remote Desktop Services:** IT Support, Administrators
- **Change system time:** Administrators, IT Support

### **Audit Policies**

- **Audit Account Logon Events:** Success, Failure
- **Audit Account Management:** Success, Failure
- **Audit Directory Service Access:** Success, Failure
- **Audit Logon Events:** Success, Failure
- **Audit Object Access:** Success (for sensitive files)
- **Audit Policy Change:** Success, Failure
- **Audit Privilege Use:** Success, Failure
- **Audit System Events:** Success, Failure

---

## 📊 Monitoring & Maintenance

### **Key Performance Indicators (KPIs)**

- **Domain Controller Health:** Monitor replication, DNS resolution
- **DHCP Availability:** Monitor lease distribution, scope utilization
- **File Server Performance:** Monitor disk usage, share access
- **User Authentication:** Monitor failed login attempts
- **GPO Application:** Verify policies apply correctly

### **Maintenance Tasks**

- **Daily:** Review event logs, check backup status
- **Weekly:** Review security logs, verify GPO application
- **Monthly:** Review user accounts, update documentation
- **Quarterly:** Review and update GPOs, security policies

---

## 🚀 Implementation Steps

### **Phase 1: Initial Setup**
1. Install Windows Server 2019/2022 on DC01
2. Configure static IP address (10.20.20.10)
3. Install Active Directory Domain Services
4. Promote server to Domain Controller
5. Create `CRUISE.LOCAL` domain

### **Phase 2: Infrastructure Services**
1. Configure DNS zones and records
2. Install and configure DHCP
3. Create DHCP scopes for each VLAN
4. Install File and Storage Services
5. Create shared folders and configure permissions

### **Phase 3: Organizational Structure**
1. Create Organizational Units (OUs)
2. Create security groups
3. Create user accounts
4. Join client workstations to domain
5. Move computer objects to appropriate OUs

### **Phase 4: Group Policy**
1. Create and link GPOs
2. Configure password and account policies
3. Set up desktop environment policies
4. Test GPO application
5. Document policy settings

### **Phase 5: Testing & Validation**
1. Test user authentication
2. Verify file share access
3. Test GPO application
4. Verify DNS resolution
5. Test DHCP lease distribution
6. Document all configurations

---

## 📝 Documentation Requirements

- [ ] Network diagram showing server placement
- [ ] AD structure diagram
- [ ] DNS zone configuration screenshots
- [ ] DHCP scope configuration screenshots
- [ ] File share permissions documentation
- [ ] GPO settings documentation
- [ ] User account creation procedures
- [ ] Troubleshooting runbook

---

## 🔗 Related Documentation

- [IT Support Workflows](../procedures/it-support-workflows.md) - Operational procedures
- [Project Plan](../project-plan.md) - Overall project documentation
- [Network Architecture](../architecture/network-architecture.md) - Network design (coming soon)

---

**Last Updated:** 2025 | **Version:** 1.0.0 | **Status:** In Progress

