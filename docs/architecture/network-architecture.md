# Network Architecture

## 📋 Overview

This document outlines the network infrastructure design for the Smart Cruise Vessel IT simulation. The architecture implements VLAN segmentation, high-availability routing, and network resilience to support multiple departments and operational modes.

---

## 🏗️ Network Design Principles

### **Design Goals**
- **Security:** Network segmentation through VLANs
- **Reliability:** High-availability and redundancy
- **Scalability:** Support for future expansion
- **Performance:** Optimized routing and QoS
- **Operational Flexibility:** Port mode vs Sea mode operation

### **Network Topology**
- **Type:** Hierarchical (Core-Distribution-Access)
- **Redundancy:** Dual links, HSRP/VRRP
- **Segmentation:** VLAN-based
- **Routing:** OSPF dynamic routing

---

## 🌐 VLAN Design

### **VLAN Overview**

| VLAN ID | Name | Subnet | Gateway | Purpose | Access Level |
|---------|------|--------|---------|---------|--------------|
| 10 | Guest WiFi | 10.10.10.0/24 | 10.10.10.1 | Public internet access for guests | Isolated |
| 20 | Crew/Admin | 10.20.20.0/24 | 10.20.20.1 | Crew and administrative access | Full internal |
| 30 | Engineering Systems | 10.30.30.0/24 | 10.30.30.1 | Critical engineering systems | Restricted |
| 40 | Navigation Support | 10.40.40.0/24 | 10.40.40.1 | Navigation and bridge systems | Critical |
| 50 | Hotel Operations | 10.50.50.0/24 | 10.50.50.1 | Hotel and guest services | Internal |

---

## 🔌 VLAN Details

### **VLAN 10: Guest WiFi**

**Purpose:** Provide internet access for guests while maintaining network isolation.

**Configuration:**
- **Subnet:** 10.10.10.0/24
- **Gateway:** 10.10.10.1
- **DHCP:** Enabled (scope: 10.10.10.100-200)
- **DNS:** Public DNS (8.8.8.8, 1.1.1.1)
- **Isolation:** No access to internal networks
- **QoS:** Fair usage bandwidth limiting
- **Security:** Captive portal authentication (optional)

**Access Control:**
- No inter-VLAN routing to internal networks
- Internet access only
- Bandwidth throttling per user

---

### **VLAN 20: Crew/Admin Network**

**Purpose:** Primary network for crew members and administrative systems.

**Configuration:**
- **Subnet:** 10.20.20.0/24
- **Gateway:** 10.20.20.1
- **DHCP:** Enabled (scope: 10.20.20.100-200)
- **DNS:** Internal DNS (10.20.20.10, 10.20.20.11)
- **Access:** Full internal network access
- **Security:** Enhanced monitoring and logging

**Devices:**
- Domain Controllers (DC01, DC02): 10.20.20.10, 10.20.20.11
- File Server (FS01): 10.20.20.20
- IT Workstations
- Administrative Systems

**Access Control:**
- Access to all internal VLANs
- Internet access through proxy/firewall
- Enhanced security monitoring

---

### **VLAN 30: Engineering Systems**

**Purpose:** Isolated network for critical engineering and propulsion systems.

**Configuration:**
- **Subnet:** 10.30.30.0/24
- **Gateway:** 10.30.30.1
- **DHCP:** Disabled (static IPs only)
- **DNS:** Internal DNS
- **Access:** Restricted, critical systems only
- **Redundancy:** High-availability links

**Devices:**
- Engine monitoring systems
- Propulsion control systems
- Engineering workstations
- Critical sensors and IoT devices

**Access Control:**
- Restricted access from other VLANs
- Engineering staff only
- No internet access
- High-priority QoS

---

### **VLAN 40: Navigation Support**

**Purpose:** Critical network for navigation and bridge operations.

**Configuration:**
- **Subnet:** 10.40.40.0/24
- **Gateway:** 10.40.40.1
- **DHCP:** Disabled (static IPs only)
- **DNS:** Internal DNS
- **Access:** Isolated, critical for operations
- **Priority:** Highest QoS priority

**Devices:**
- Navigation systems
- Bridge workstations
- Radar and GPS systems
- Communication systems

**Access Control:**
- Highly restricted access
- Navigation officers only
- No internet access
- Highest network priority

---

### **VLAN 50: Hotel Operations**

**Purpose:** Network for hotel operations, POS systems, and guest services.

**Configuration:**
- **Subnet:** 10.50.50.0/24
- **Gateway:** 10.50.50.1
- **DHCP:** Enabled (scope: 10.50.50.100-200)
- **DNS:** Internal DNS
- **Access:** Hotel systems, POS, guest services
- **Integration:** Connected to Windows domain

**Devices:**
- POS terminals
- Hotel management systems
- Guest services workstations
- Hotel department computers

**Access Control:**
- Access to internal networks (restricted)
- Internet access for hotel systems
- Integration with Windows domain

---

## 🛣️ Routing Design

### **Routing Protocol: OSPF**

**OSPF Configuration:**
- **Process ID:** 1
- **Router ID:** Manually assigned (based on highest IP)
- **Area:** Single area (Area 0) for simplicity
- **Authentication:** MD5 (recommended for production)

**OSPF Areas:**
- **Area 0 (Backbone):** All routers participate

**Router IDs:**
- **Core Router 1:** 10.20.20.1
- **Core Router 2:** 10.20.20.2
- **Distribution Switches:** Based on VLAN gateways

### **Static Routes**

**Default Route:**
- **Destination:** 0.0.0.0/0
- **Next Hop:** Internet gateway (varies by mode)
- **Purpose:** Internet access

**Route Summarization:**
- Summarize VLAN subnets where possible
- Reduce routing table size
- Improve convergence time

---

## 🔄 High Availability

### **HSRP/VRRP Configuration**

**Purpose:** Provide gateway redundancy for each VLAN.

**VLAN 20 (Crew/Admin):**
- **Virtual IP:** 10.20.20.1
- **Primary Router:** 10.20.20.1 (Priority: 110)
- **Secondary Router:** 10.20.20.2 (Priority: 100)
- **Preemption:** Enabled

**VLAN 30 (Engineering):**
- **Virtual IP:** 10.30.30.1
- **Primary Router:** 10.30.30.1 (Priority: 110)
- **Secondary Router:** 10.30.30.2 (Priority: 100)
- **Preemption:** Enabled

**VLAN 40 (Navigation):**
- **Virtual IP:** 10.40.40.1
- **Primary Router:** 10.40.40.1 (Priority: 110)
- **Secondary Router:** 10.40.40.2 (Priority: 100)
- **Preemption:** Enabled

**VLAN 50 (Hotel):**
- **Virtual IP:** 10.50.50.1
- **Primary Router:** 10.50.50.1 (Priority: 110)
- **Secondary Router:** 10.50.50.2 (Priority: 100)
- **Preemption:** Enabled

### **Link Aggregation (LACP)**

**Purpose:** Increase bandwidth and provide redundancy.

**Configuration:**
- **Protocol:** LACP (802.3ad)
- **Links:** 2x Gigabit Ethernet
- **Mode:** Active-Active
- **Load Balancing:** Source-destination IP

**Applied To:**
- Core router interconnections
- Distribution switch uplinks
- Critical server connections

---

## 🔐 Security Configuration

### **Access Control Lists (ACLs)**

#### **VLAN 10 (Guest WiFi) ACLs**

**Outbound (to Internet):**
- Permit: All traffic to internet
- Deny: All traffic to internal networks

**Inbound (from Internet):**
- Deny: All traffic (no inbound access)

#### **VLAN 20 (Crew/Admin) ACLs**

**Inter-VLAN:**
- Permit: Access to VLAN 30, 40, 50 (with restrictions)
- Deny: Access to VLAN 10 (guest network)

**Internet:**
- Permit: HTTP, HTTPS, DNS, NTP
- Deny: All other traffic (unless required)

#### **VLAN 30 (Engineering) ACLs**

**Inter-VLAN:**
- Permit: Access from VLAN 20 (IT/admin only)
- Deny: All other inter-VLAN access

**Internet:**
- Deny: All internet access

#### **VLAN 40 (Navigation) ACLs**

**Inter-VLAN:**
- Permit: Access from VLAN 20 (IT/admin only)
- Deny: All other inter-VLAN access

**Internet:**
- Deny: All internet access

#### **VLAN 50 (Hotel) ACLs**

**Inter-VLAN:**
- Permit: Access to VLAN 20 (domain services)
- Deny: Access to VLAN 30, 40

**Internet:**
- Permit: Required hotel systems
- Deny: General internet browsing

### **Port Security**

**Configuration:**
- **Maximum MAC addresses:** 2 per port
- **Violation action:** Shutdown
- **Sticky MAC:** Enabled

**Applied To:**
- Access switch ports
- Guest WiFi access points
- Public-facing ports

### **DHCP Snooping**

**Purpose:** Prevent rogue DHCP servers.

**Configuration:**
- **Enabled:** On all access switches
- **Trusted ports:** Uplinks to distribution/core
- **Untrusted ports:** All access ports

---

## ⚙️ Operational Modes

### **Port Mode**

**Characteristics:**
- Full internet connectivity via shore power/land connection
- High bandwidth available
- Optimized for data synchronization
- Full access to cloud services

**Configuration:**
- **Internet Gateway:** Shore connection
- **Bandwidth:** High (100Mbps+)
- **QoS:** Standard
- **Services:** All services available

### **Sea Mode**

**Characteristics:**
- Limited satellite connectivity
- Bandwidth conservation required
- Priority-based traffic management
- Essential services only

**Configuration:**
- **Internet Gateway:** Satellite link
- **Bandwidth:** Limited (10-20Mbps)
- **QoS:** Aggressive prioritization
- **Services:** Essential services only

**QoS Priorities (Sea Mode):**
1. **Highest:** Navigation (VLAN 40)
2. **High:** Engineering (VLAN 30)
3. **Medium:** Hotel Operations (VLAN 50)
4. **Low:** Crew/Admin (VLAN 20)
5. **Lowest:** Guest WiFi (VLAN 10)

---

## 📊 Network Devices

### **Core Routers**

**Quantity:** 2 (for redundancy)

**Specifications:**
- Layer 3 routing capability
- OSPF support
- HSRP/VRRP support
- ACL support
- High throughput

**Configuration:**
- OSPF routing
- HSRP/VRRP for gateway redundancy
- Inter-VLAN routing
- ACL enforcement

### **Distribution Switches**

**Quantity:** 2 per department (redundancy)

**Specifications:**
- Layer 3 switching
- VLAN support
- Trunking capability
- STP support

**Configuration:**
- VLAN trunking
- Inter-VLAN routing
- STP configuration
- Link aggregation

### **Access Switches**

**Quantity:** Multiple (based on physical layout)

**Specifications:**
- Layer 2 switching
- VLAN support
- Port security
- PoE (for access points)

**Configuration:**
- VLAN assignment
- Port security
- DHCP snooping
- STP participation

---

## 🔍 Monitoring and Management

### **Network Monitoring**

**Key Metrics:**
- Interface utilization
- Bandwidth usage per VLAN
- Error rates
- Latency
- Uptime/availability

**Tools:**
- SNMP monitoring
- Network management system
- Flow analysis (NetFlow/sFlow)

### **Logging**

**Events to Log:**
- ACL violations
- Port security violations
- DHCP snooping violations
- Interface status changes
- Routing changes
- Authentication failures

---

## 🚀 Implementation Steps

### **Phase 1: Design and Planning**
1. Review network requirements
2. Design VLAN structure
3. Plan IP addressing
4. Design routing topology
5. Plan high-availability

### **Phase 2: Core Infrastructure**
1. Configure core routers
2. Set up OSPF routing
3. Configure HSRP/VRRP
4. Test core connectivity

### **Phase 3: VLAN Implementation**
1. Create VLANs on switches
2. Configure trunk links
3. Set up inter-VLAN routing
4. Configure ACLs

### **Phase 4: Security Configuration**
1. Configure ACLs
2. Enable port security
3. Configure DHCP snooping
4. Set up logging

### **Phase 5: Testing and Validation**
1. Test inter-VLAN routing
2. Test high-availability failover
3. Verify ACL enforcement
4. Test QoS policies
5. Validate security controls

---

## 📝 Documentation Requirements

- [ ] Physical network diagram
- [ ] Logical network diagram
- [ ] VLAN topology diagram
- [ ] IP addressing scheme
- [ ] Routing table documentation
- [ ] ACL documentation
- [ ] Device configuration backups
- [ ] Network monitoring setup

---

## 🔗 Related Documentation

- [Windows Infrastructure](../architecture/windows-infrastructure.md) - Integration with Windows domain
- [Project Plan](../project-plan.md) - Overall project documentation
- [Network Simulation Guide](../../network-simulation/README.md) - Simulation setup (coming soon)

---

**Last Updated:** 2024 | **Version:** 1.0.0 | **Status:** In Progress

