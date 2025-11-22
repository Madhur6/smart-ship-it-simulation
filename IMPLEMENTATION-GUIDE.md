# 🚢 Smart Cruise Vessel IT Simulation - Implementation Guide

## 📋 Overview

This guide will walk you through implementing the Smart Cruise Vessel IT Simulation step-by-step. We'll build a production-grade enterprise infrastructure while learning key concepts in Windows Server administration, networking, and monitoring.

---

## 🎯 Implementation Phases

### **Phase 1: Environment Setup (1-2 hours)**
- Set up virtualization environment
- Create Windows Server VMs
- Prepare client workstations

### **Phase 2: Windows Infrastructure (4-6 hours)**
- Install Active Directory Domain Services
- Configure DNS and DHCP
- Create organizational structure
- Set up file services and policies

### **Phase 3: Network Infrastructure (3-4 hours)**
- Configure VLANs and routing
- Set up high availability
- Implement security policies

### **Phase 4: Monitoring & IoT (2-3 hours)**
- Set up monitoring platform
- Create data simulation
- Build dashboards

### **Phase 5: Testing & Documentation (2-3 hours)**
- Test all systems
- Capture screenshots
- Document everything

---

## 🛠️ Phase 1: Environment Setup

### **Step 1.1: Choose Virtualization Platform**

**Options:**
- **VMware Workstation Pro** (Recommended) - Professional features
- **VirtualBox** (Free) - Good for beginners
- **Hyper-V** (Free with Windows Pro) - Integrated with Windows

**Download:**
- VMware: https://www.vmware.com/products/workstation-pro.html
- VirtualBox: https://www.virtualbox.org/
- Hyper-V: Enable in Windows Features

### **Step 1.2: System Requirements**

**Host Machine:**
- CPU: 8+ cores (Intel i5/i7 or AMD Ryzen)
- RAM: 16GB+ (32GB recommended)
- Storage: 200GB+ free space
- OS: Windows 10/11 Pro, macOS, or Linux

**VM Specifications:**
```
Windows Server (DC01): 2 vCPUs, 4GB RAM, 60GB disk
Windows Server (FS01): 2 vCPUs, 4GB RAM, 80GB disk
Windows Client x4: 1 vCPU, 2GB RAM, 40GB disk each
```

### **Step 1.3: Create Virtual Network**

**VMware:**
1. Edit → Virtual Network Editor
2. Create VMnet2 (Host-only or NAT)
3. IP Range: 10.20.20.0/24
4. DHCP: Disabled (we'll configure our own)

**VirtualBox:**
1. File → Host Network Manager
2. Create network adapter
3. Configure: 10.20.20.1/24

### **Step 1.4: Download ISO Files**

**Required ISOs:**
- Windows Server 2019/2022 Evaluation: https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server
- Windows 10/11 Evaluation: https://www.microsoft.com/en-us/software-download/windows10ISO

### **Step 1.5: Create Windows Server VM (DC01)**

**VMware Steps:**
1. File → New Virtual Machine
2. Select "Custom" configuration
3. Name: DC01, Location: Choose folder
4. Guest OS: Microsoft Windows → Windows Server 2019
5. Processors: 2, Memory: 4096MB
6. Network: Custom (VMnet2)
7. Disk: 60GB, Single file
8. Finish and power on

**Post-Installation:**
1. Set administrator password: `Admin123!`
2. Complete initial setup
3. Install VMware Tools (VM → Install VMware Tools)

### **Step 1.6: Configure Static IP on DC01**

**Open PowerShell as Administrator:**

```powershell
# Set static IP
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress 10.20.20.10 -PrefixLength 24 -DefaultGateway 10.20.20.1

# Set DNS to localhost (for now)
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 127.0.0.1

# Rename computer (optional)
Rename-Computer -NewName DC01 -Restart
```

### **Step 1.7: Create Additional VMs**

**Repeat for FS01:**
- Name: FS01
- IP: 10.20.20.20
- Memory: 4GB
- Disk: 80GB

**Create Client VMs:**
- DECK-WS01, ENGINE-WS01, HOTEL-WS01, GUEST-WS01
- IP: DHCP (will be configured later)
- Memory: 2GB each
- Disk: 40GB each

---

## 🖥️ Phase 2: Windows Infrastructure

### **Step 2.1: Install Active Directory Domain Services**

**Learning:** Active Directory is the foundation of enterprise Windows networks. It provides centralized authentication, authorization, and directory services.

**On DC01:**

```powershell
# Copy the script to DC01
# Run as Administrator
.\01-Install-ADDS.ps1
```

**What this script does:**
1. Installs AD DS Windows feature
2. Promotes server to Domain Controller
3. Creates `CRUISE.LOCAL` domain
4. Configures DNS integration

**After reboot, login as:** `CRUISE\Administrator`

### **Step 2.2: Create Organizational Units**

**Learning:** OUs provide hierarchical organization for users, computers, and groups, enabling delegated administration and Group Policy application.

```powershell
# Run on DC01
.\02-Create-OUs.ps1
```

**OU Structure Created:**
```
CRUISE.LOCAL
├── Users
│   ├── Administrators
│   ├── IT Staff
│   ├── Deck Department
│   ├── Engine Department
│   ├── Hotel Department
│   └── Guest Services
├── Computers
│   ├── Servers
│   ├── Domain Controllers
│   ├── File Servers
│   └── Workstations
└── Groups
    ├── Security Groups
    └── Distribution Groups
```

### **Step 2.3: Create Security Groups**

**Learning:** Security groups control access to resources. Domain Local groups contain users, Global groups contain resources.

```powershell
# Run on DC01
.\03-Create-SecurityGroups.ps1
```

**Groups Created:**
- `Deck Officers` (Global) - Deck department users
- `Engine Engineers` (Global) - Engineering staff
- `File Share - Deck` (Domain Local) - Access to deck files

### **Step 2.4: Configure DNS**

**Learning:** DNS translates human-readable names to IP addresses. In AD, DNS is critical for domain functionality.

```powershell
# Run on DC01
.\04-Configure-DNS.ps1
```

**DNS Configuration:**
- Forward lookup zone: `cruise.local`
- Reverse lookup zones: `10.20.20.x`, `10.50.50.x`
- Forwarders: Google DNS (8.8.8.8)

**Test DNS:**
```cmd
nslookup DC01.cruise.local
nslookup google.com
```

### **Step 2.5: Install and Configure DHCP**

**Learning:** DHCP automatically assigns IP addresses to devices on the network, essential for large enterprise environments.

**On FS01 (File Server):**

```powershell
# First, join FS01 to domain
.\08-Join-ComputerToDomain.ps1

# After reboot, run DHCP setup
.\05-Install-DHCP.ps1
```

**DHCP Scopes:**
- Crew/Admin: 10.20.20.100-200
- Hotel Operations: 10.50.50.100-200

### **Step 2.6: Create User Accounts**

**Learning:** User accounts in AD provide authentication and authorization. Proper naming conventions and group memberships are crucial for security.

```powershell
# Run on DC01
.\06-Create-Users.ps1
```

**Sample Users Created:**
- IT Staff: John Admin (Domain Admin), Sarah Support (IT Support)
- Department Users: Officers, managers, staff for each department
- Default Password: `TempPass123!` (force change on first login)

### **Step 2.7: Create File Shares**

**Learning:** File shares provide centralized storage with controlled access. NTFS permissions work with share permissions for security.

```powershell
# Run on FS01
.\07-Create-FileShares.ps1
```

**Shares Created:**
- `\\FS01\Deck` - Deck department files
- `\\FS01\Engine` - Engineering files
- `\\FS01\Hotel` - Hotel operations
- `\\FS01\GuestServices` - Guest services
- `\\FS01\IT` - IT documentation

### **Step 2.8: Join Client Workstations**

**Learning:** Domain joining provides centralized management, policy application, and resource access.

**On each client VM:**

```powershell
# Configure DNS first
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 10.20.20.10

# Join domain
.\08-Join-ComputerToDomain.ps1
```

**After joining:**
- Login with domain credentials: `CRUISE\username`
- Test file share access
- Verify Group Policy application

### **Step 2.9: Configure Group Policies**

**Learning:** Group Policy Objects (GPOs) enforce settings across domain-joined computers and users.

**Manual Configuration:**

1. **Open Group Policy Management** on DC01
2. **Edit Default Domain Policy:**
   - Password Policy: 12 chars, complexity enabled
   - Account Lockout: 5 attempts, 30 min lockout

3. **Create Department GPOs:**
   - Desktop Environment - Deck
   - Security Settings
   - Software Deployment policies

---

## 🌐 Phase 3: Network Infrastructure

### **Step 3.1: Install Network Simulation Tool**

**Options:**
- **GNS3** (Recommended for learning): https://www.gns3.com/
- **Cisco Packet Tracer** (Free): https://www.netacad.com/courses/packet-tracer

**GNS3 Setup:**
1. Download and install GNS3
2. Install GNS3 VM
3. Import Cisco IOS images (legal copy required)

### **Step 3.2: Create Network Topology**

**Learning:** Network topology design affects performance, security, and scalability.

**Create in GNS3/Packet Tracer:**
1. **Core Routers:** 2x (for redundancy)
2. **Distribution Switches:** 2x (Layer 3)
3. **Access Switches:** 3x (Layer 2)
4. **End Devices:** PCs representing workstations

**Topology Layout:**
```
Internet Gateway
      |
   Core Router 1 ─── Core Router 2
      |                    |
   Dist Switch 1 ─── Dist Switch 2
      |                    |
   Access Switch 1-3
      |
   Workstations
```

### **Step 3.3: Configure VLANs**

**Learning:** VLANs segment networks for security and performance.

**VLAN Configuration:**
```cisco
# On switches
vlan 10
 name Guest-WiFi
vlan 20
 name Crew-Admin
vlan 30
 name Engineering-Systems
vlan 40
 name Navigation-Support
vlan 50
 name Hotel-Operations
```

**Port Assignment:**
- Ports 1-12: VLAN 20 (Crew/Admin)
- Ports 13-18: VLAN 30 (Engineering)
- Ports 19-22: VLAN 40 (Navigation)
- Ports 23-24: VLAN 50 (Hotel)

### **Step 3.4: Configure OSPF Routing**

**Learning:** OSPF is a link-state routing protocol that provides fast convergence and scalability.

```cisco
# On core routers
router ospf 1
 router-id 10.20.20.1
 network 10.20.20.0 0.0.0.255 area 0
 network 10.30.30.0 0.0.0.255 area 0
 network 10.40.40.0 0.0.0.255 area 0
 network 10.50.50.0 0.0.0.255 area 0
```

### **Step 3.5: Configure HSRP/VRRP**

**Learning:** First Hop Redundancy Protocols provide gateway redundancy.

```cisco
# On core routers
interface GigabitEthernet0/0
 standby 20 ip 10.20.20.1
 standby 20 priority 110
 standby 20 preempt
 standby 20 name HSRP-VLAN20

# Secondary router (priority 100)
interface GigabitEthernet0/0
 standby 20 ip 10.20.20.1
 standby 20 priority 100
 standby 20 preempt
```

### **Step 3.6: Configure ACLs**

**Learning:** Access Control Lists filter traffic based on rules.

```cisco
# Restrict engineering access
ip access-list extended ENG-OUTBOUND
 permit ip 10.30.30.0 0.0.0.255 10.20.20.0 0.0.0.255
 deny ip any any

interface GigabitEthernet0/1
 ip access-group ENG-OUTBOUND out
```

### **Step 3.7: Test Network Functionality**

**Learning:** Network testing ensures reliability and performance.

**Tests to Perform:**
1. **Ping tests:** Verify connectivity between VLANs
2. **HSRP failover:** Disconnect primary router, verify failover
3. **ACL enforcement:** Attempt blocked connections
4. **OSPF convergence:** Check routing table updates

---

## 📊 Phase 4: Monitoring & IoT

### **Step 4.1: Install Monitoring Platform**

**Option 1: Grafana + Prometheus**
```bash
# Install Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.40.0/prometheus-2.40.0.windows-amd64.zip

# Install Grafana
# Download from https://grafana.com/grafana/download
```

**Option 2: Zabbix (Easier)**
```bash
# Download Zabbix from https://www.zabbix.com/download
# Install Zabbix Server and Agent
```

### **Step 4.2: Configure Infrastructure Monitoring**

**Learning:** Infrastructure monitoring tracks system health and performance.

**Monitor:**
- Windows Server CPU, memory, disk
- Network device interfaces
- Service availability (AD, DNS, DHCP)
- Event logs and errors

### **Step 4.3: Generate IoT Data**

**Learning:** IoT simulation creates realistic sensor data for testing analytics.

```bash
# Run the LED simulation
cd monitoring-dashboard/data-simulation-scripts
python led_simulation.py --duration 60 --interval 30
```

**Simulation Features:**
- 20,000+ LED nodes
- Zone-based distribution (Cabins, Public areas, etc.)
- Realistic usage patterns (day/night cycles)
- Power consumption calculations

### **Step 4.4: Create Dashboards**

**Learning:** Dashboards visualize data for monitoring and decision-making.

**Dashboard Components:**
1. **Infrastructure Health**
   - Server performance graphs
   - Network utilization charts
   - Service status indicators

2. **IoT Monitoring**
   - LED status by zone
   - Power consumption trends
   - Energy efficiency metrics

3. **Operational Analytics**
   - Usage patterns over time
   - Peak demand analysis
   - Predictive insights

### **Step 4.5: Configure Alerting**

**Learning:** Alerting notifies administrators of issues before they impact users.

**Alert Rules:**
- CPU usage > 80% for 5 minutes
- Disk space < 15%
- Service down
- Network interface errors

---

## ✅ Phase 5: Testing & Documentation

### **Step 5.1: End-to-End Testing**

**Test Scenarios:**
1. **User Authentication:** Login from client VM with domain credentials
2. **File Access:** Verify department-specific file share access
3. **Network Connectivity:** Test inter-VLAN communication
4. **Monitoring:** Verify data collection and dashboard updates
5. **Failover:** Test HSRP/network redundancy

### **Step 5.2: Capture Screenshots**

**Required Screenshots:**
- Active Directory structure
- DNS zone configuration
- DHCP scope settings
- File share permissions
- Group Policy settings
- Network device configurations
- Monitoring dashboards
- IoT data simulation

**Save to:** `windows-server/screenshots/`, `assets/screenshots/`

### **Step 5.3: Performance Testing**

**Load Testing:**
- Simulate multiple users accessing resources
- Test concurrent file operations
- Monitor resource utilization under load

### **Step 5.4: Security Validation**

**Security Tests:**
- Verify ACL enforcement
- Test unauthorized access attempts
- Validate Group Policy application
- Check audit logging

### **Step 5.5: Documentation Updates**

**Update Documentation:**
- Record actual configurations
- Document troubleshooting steps
- Update architecture diagrams
- Create implementation notes

---

## 🐛 Troubleshooting Guide

### **Common Issues**

**VM Network Issues:**
```powershell
# Check IP configuration
ipconfig /all

# Reset network stack
netsh winsock reset
netsh int ip reset
```

**Domain Join Failures:**
- Verify DNS points to DC
- Check domain credentials
- Ensure DC is reachable

**GPO Not Applying:**
```powershell
# Force GPO update
gpupdate /force

# Check GPO status
gpresult /r
```

**Network Connectivity:**
```cisco
# Check interface status
show ip interface brief

# Test connectivity
ping 10.20.20.10
```

---

## 📚 Learning Outcomes

By completing this implementation, you'll learn:

- **🏢 Enterprise IT:** Windows Server administration, Active Directory
- **🌐 Network Engineering:** VLAN design, routing protocols, security
- **📊 Infrastructure Monitoring:** Data collection, visualization, alerting
- **🔧 Automation:** PowerShell scripting, configuration management
- **📚 Documentation:** Technical writing, diagram creation

---

## 🎯 Success Criteria

**Infrastructure:**
- ✅ Domain controller operational
- ✅ DNS resolution working
- ✅ DHCP leasing addresses
- ✅ File shares accessible with proper permissions
- ✅ Users can authenticate and access resources

**Network:**
- ✅ VLANs properly segmented
- ✅ OSPF routing functional
- ✅ HSRP failover working
- ✅ ACLs enforcing security

**Monitoring:**
- ✅ Data collection active
- ✅ Dashboards displaying metrics
- ✅ Alerts configured and tested

**Documentation:**
- ✅ Screenshots captured
- ✅ Configurations documented
- ✅ Implementation guide complete

---

**Ready to start? Begin with Phase 1: Environment Setup! 🚀**

This implementation will give you hands-on experience with enterprise infrastructure that directly translates to real-world IT roles.
