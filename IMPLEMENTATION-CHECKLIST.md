# ✅ Implementation Checklist - Smart Cruise Vessel IT Simulation

## 📋 Quick Progress Tracker

Use this checklist to track your implementation progress. Mark items as you complete them.

---

## 🛠️ Phase 1: Environment Setup

### **Virtualization Setup**
- [ ] Choose virtualization platform (VMware/VirtualBox/Hyper-V)
- [ ] Install virtualization software
- [ ] Verify system meets requirements (16GB+ RAM, 200GB+ storage)
- [ ] Download Windows Server 2019/2022 ISO
- [ ] Download Windows 10/11 ISO

### **Virtual Network Configuration**
- [ ] Create virtual network (VMnet2/Host-only)
- [ ] Configure IP range: 10.20.20.0/24
- [ ] Disable DHCP (we'll configure our own)
- [ ] Test virtual network connectivity

### **VM Creation**
- [ ] Create DC01 VM (Domain Controller)
  - [ ] 2 vCPUs, 4GB RAM, 60GB disk
  - [ ] Install Windows Server 2019/2022
  - [ ] Set static IP: 10.20.20.10
  - [ ] Install VMware Tools/VirtualBox Guest Additions
- [ ] Create FS01 VM (File Server)
  - [ ] 2 vCPUs, 4GB RAM, 80GB disk
  - [ ] Install Windows Server 2019/2022
  - [ ] Set static IP: 10.20.20.20
- [ ] Create 4 client VMs
  - [ ] DECK-WS01, ENGINE-WS01, HOTEL-WS01, GUEST-WS01
  - [ ] 1 vCPU, 2GB RAM, 40GB disk each
  - [ ] Install Windows 10/11

**Phase 1 Status:** ⏳ Not Started | 🚧 In Progress | ✅ Complete

---

## 🖥️ Phase 2: Windows Infrastructure

### **Active Directory Setup**
- [ ] Run `01-Install-ADDS.ps1` on DC01
- [ ] Verify domain creation (CRUISE.LOCAL)
- [ ] Confirm DNS integration
- [ ] Test login as CRUISE\Administrator

### **Organizational Structure**
- [ ] Run `02-Create-OUs.ps1` on DC01
- [ ] Verify OU creation in Active Directory Users and Computers
- [ ] Check Users, Computers, and Groups containers

### **Security Groups**
- [ ] Run `03-Create-SecurityGroups.ps1` on DC01
- [ ] Verify group creation
- [ ] Check group memberships and scopes

### **DNS Configuration**
- [ ] Run `04-Configure-DNS.ps1` on DC01
- [ ] Verify forward lookup zones
- [ ] Check reverse lookup zones
- [ ] Test DNS resolution: `nslookup dc01.cruise.local`

### **DHCP Setup**
- [ ] Join FS01 to domain using `08-Join-ComputerToDomain.ps1`
- [ ] Run `05-Install-DHCP.ps1` on FS01
- [ ] Authorize DHCP server in AD
- [ ] Verify DHCP scopes (Crew/Admin, Hotel Operations)

### **User Management**
- [ ] Run `06-Create-Users.ps1` on DC01
- [ ] Verify user accounts in AD
- [ ] Check group memberships
- [ ] Test user authentication

### **File Services**
- [ ] Run `07-Create-FileShares.ps1` on FS01
- [ ] Verify share creation
- [ ] Test permissions from domain user
- [ ] Check NTFS and share permissions

### **Domain Join**
- [ ] Join all client VMs to domain
- [ ] Configure DNS to point to DC01 (10.20.20.10)
- [ ] Login with domain credentials
- [ ] Verify GPO application

### **Group Policy**
- [ ] Configure Default Domain Policy (password/account policies)
- [ ] Create department-specific GPOs
- [ ] Test GPO application on clients
- [ ] Verify settings enforcement

**Phase 2 Status:** ⏳ Not Started | 🚧 In Progress | ✅ Complete

---

## 🌐 Phase 3: Network Infrastructure

### **Network Tool Setup**
- [ ] Install GNS3 or Packet Tracer
- [ ] Configure GNS3 VM (if using GNS3)
- [ ] Import Cisco IOS images
- [ ] Test basic connectivity

### **Topology Design**
- [ ] Create core routers (2x)
- [ ] Add distribution switches (2x)
- [ ] Configure access switches (3x)
- [ ] Connect end devices

### **VLAN Configuration**
- [ ] Create VLANs 10, 20, 30, 40, 50
- [ ] Assign ports to VLANs
- [ ] Configure trunk links
- [ ] Verify VLAN isolation

### **Routing Setup**
- [ ] Configure OSPF on all routers
- [ ] Set router IDs
- [ ] Verify neighbor relationships
- [ ] Test inter-VLAN routing

### **High Availability**
- [ ] Configure HSRP/VRRP on core routers
- [ ] Set priorities (110/100)
- [ ] Enable preemption
- [ ] Test failover scenarios

### **Security Configuration**
- [ ] Configure ACLs for traffic filtering
- [ ] Enable DHCP snooping
- [ ] Set up port security
- [ ] Test security enforcement

### **Network Testing**
- [ ] Verify all VLAN connectivity
- [ ] Test HSRP failover
- [ ] Validate ACL rules
- [ ] Check OSPF convergence

**Phase 3 Status:** ⏳ Not Started | 🚧 In Progress | ✅ Complete

---

## 📊 Phase 4: Monitoring & IoT

### **Monitoring Platform**
- [ ] Choose platform (Grafana/Prometheus or Zabbix)
- [ ] Install monitoring server
- [ ] Configure data collection agents
- [ ] Verify basic functionality

### **Infrastructure Monitoring**
- [ ] Configure Windows Server monitoring
- [ ] Set up network device monitoring
- [ ] Monitor services (AD, DNS, DHCP)
- [ ] Test data collection

### **IoT Data Simulation**
- [ ] Run LED simulation script
- [ ] Generate sample data (60 minutes)
- [ ] Verify data format and realism
- [ ] Test different usage patterns

### **Dashboard Creation**
- [ ] Create infrastructure dashboard
- [ ] Build IoT monitoring dashboard
- [ ] Add operational analytics
- [ ] Configure time ranges and filters

### **Alerting Setup**
- [ ] Configure alert rules
- [ ] Set up notification channels
- [ ] Test alert triggers
- [ ] Verify alert delivery

**Phase 4 Status:** ⏳ Not Started | 🚧 In Progress | ✅ Complete

---

## ✅ Phase 5: Testing & Documentation

### **System Testing**
- [ ] End-to-end user authentication
- [ ] File share access testing
- [ ] Network connectivity verification
- [ ] Monitoring data accuracy
- [ ] Performance under load

### **Screenshot Capture**
- [ ] Windows Server configurations
- [ ] Active Directory structure
- [ ] DNS and DHCP settings
- [ ] File share permissions
- [ ] Group Policy settings
- [ ] Network device configurations
- [ ] Monitoring dashboards
- [ ] IoT data simulation

### **Documentation Updates**
- [ ] Record actual IP addresses used
- [ ] Document custom configurations
- [ ] Update troubleshooting steps
- [ ] Create implementation notes

### **Final Validation**
- [ ] All systems operational
- [ ] Documentation complete
- [ ] Screenshots organized
- [ ] Ready for portfolio presentation

**Phase 5 Status:** ⏳ Not Started | 🚧 In Progress | ✅ Complete

---

## 📊 Overall Progress Summary

| Phase | Status | Estimated Time | Progress |
|:-----:|:------:|:--------------:|:--------:|
| Phase 1: Environment Setup | ⏳ | 1-2 hours | 0% |
| Phase 2: Windows Infrastructure | ⏳ | 4-6 hours | 0% |
| Phase 3: Network Infrastructure | ⏳ | 3-4 hours | 0% |
| Phase 4: Monitoring & IoT | ⏳ | 2-3 hours | 0% |
| Phase 5: Testing & Documentation | ⏳ | 2-3 hours | 0% |

**Total Estimated Time:** 12-18 hours  
**Current Progress:** 0% (Ready to start!)

---

## 🎯 Success Checklist

### **Infrastructure Requirements**
- [ ] Domain controller operational with CRUISE.LOCAL
- [ ] DNS resolution working for all zones
- [ ] DHCP providing addresses to all VLANs
- [ ] File shares accessible with correct permissions
- [ ] Users can authenticate and access department resources

### **Network Requirements**
- [ ] All VLANs properly segmented (10,20,30,40,50)
- [ ] OSPF routing functional between all devices
- [ ] HSRP failover working (< 3 seconds)
- [ ] ACLs enforcing security policies
- [ ] Network monitoring operational

### **Monitoring Requirements**
- [ ] Infrastructure metrics being collected
- [ ] IoT simulation generating realistic data
- [ ] Dashboards displaying current status
- [ ] Alerting system configured and tested

### **Documentation Requirements**
- [ ] All configurations documented
- [ ] Screenshots captured (20+ images)
- [ ] Architecture diagrams updated
- [ ] Implementation guide complete
- [ ] Troubleshooting procedures documented

---

## 🚀 Quick Start Commands

```bash
# Phase 1: Check your environment
systeminfo | findstr /C:"Total Physical Memory"
wmic logicaldisk get size,freespace,caption

# Phase 2: Run Windows setup scripts (on DC01)
.\01-Install-ADDS.ps1
.\02-Create-OUs.ps1
.\03-Create-SecurityGroups.ps1
.\04-Configure-DNS.ps1

# Phase 2: Run DHCP setup (on FS01)
.\08-Join-ComputerToDomain.ps1
.\05-Install-DHCP.ps1

# Phase 2: Complete Windows setup
.\06-Create-Users.ps1
.\07-Create-FileShares.ps1

# Testing commands
nslookup dc01.cruise.local
gpresult /r
Get-DhcpServerv4Scope
```

---

## 🆘 Need Help?

- **Check the Implementation Guide** for detailed instructions
- **Review script comments** for what each step does
- **Test incrementally** - verify each component before moving on
- **Take screenshots** as you go for documentation

**Remember:** This is a learning experience! Take your time and understand each concept as you implement it.

---

**Ready to start? Update your progress as you complete each item! 🎯**
