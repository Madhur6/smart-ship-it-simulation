# Network Setup Guide

## 📋 Overview

This guide provides step-by-step instructions for setting up the network infrastructure simulation using GNS3, Packet Tracer, or EVE-NG.

---

## 🛠️ Tool Selection

### **GNS3 (Recommended)**

**Advantages:**
- Real Cisco IOS images
- Advanced features
- Professional simulation
- Supports complex topologies

**Setup Steps:**
1. Download and install GNS3
2. Install GNS3 VM (optional but recommended)
3. Import Cisco IOS images (legal copy required)
4. Create new project
5. Import device configurations

### **Cisco Packet Tracer**

**Advantages:**
- Free for educational use
- Easy to use
- Built-in device models

**Setup Steps:**
1. Download Packet Tracer from Cisco Networking Academy
2. Install and launch
3. Create new project
4. Add devices and configure

### **EVE-NG**

**Advantages:**
- Enterprise-grade
- Web-based interface
- Multiple vendor support

**Setup Steps:**
1. Install EVE-NG (VM or bare metal)
2. Access web interface
3. Upload device images
4. Create lab topology

---

## 🏗️ Network Topology Setup

### **Physical Topology**

```
                    [Internet]
                         |
                    [Gateway]
                         |
        +----------------+----------------+
        |                                 |
   [Core-Router-01]              [Core-Router-02]
        |                                 |
        +----------------+----------------+
                         |
              [Distribution-Switch-01]
                         |
              [Distribution-Switch-02]
                         |
        +----------------+----------------+
        |                |                |
  [Access-Switch-01] [Access-Switch-02] [Access-Switch-03]
        |                |                |
     [Devices]        [Devices]        [Devices]
```

### **Logical Topology (VLANs)**

```
VLAN 10 (Guest WiFi)      - Isolated
VLAN 20 (Crew/Admin)      - Full Access
VLAN 30 (Engineering)     - Restricted
VLAN 40 (Navigation)       - Critical
VLAN 50 (Hotel)           - Internal
```

---

## 📝 Step-by-Step Configuration

### **Step 1: Create Network Topology**

1. **Add Core Routers (2x)**
   - Add 2 routers for redundancy
   - Connect with serial or Ethernet link
   - Configure IP addresses on link

2. **Add Distribution Switches (2x)**
   - Add Layer 3 switches
   - Connect to both core routers
   - Configure trunk links

3. **Add Access Switches (Multiple)**
   - Add Layer 2 switches
   - Connect to distribution switches
   - Configure trunk links

4. **Add End Devices**
   - Add PCs/workstations
   - Connect to access switches
   - Configure for appropriate VLANs

### **Step 2: Configure Core Routers**

1. **Apply Core Router 1 Configuration**
   - Copy configuration from `configs/ROUTER-CORE-01.txt`
   - Paste into router console
   - Verify interfaces are up

2. **Configure Core Router 2**
   - Similar configuration with different priorities
   - Adjust HSRP priorities (100 instead of 110)
   - Verify redundancy

### **Step 3: Configure Distribution Switches**

1. **Apply Distribution Switch Configuration**
   - Copy from `configs/SWITCH-DISTRIBUTION-01.txt`
   - Configure VLANs
   - Set up trunk links
   - Configure HSRP

2. **Configure Second Distribution Switch**
   - Similar configuration
   - Adjust HSRP priorities
   - Set up link aggregation

### **Step 4: Configure Access Switches**

1. **Apply Access Switch Configuration**
   - Copy from `configs/SWITCH-ACCESS-01.txt`
   - Configure VLANs
   - Set up access ports
   - Enable port security

2. **Configure Additional Access Switches**
   - Repeat for each access switch
   - Adjust port assignments as needed

### **Step 5: Configure End Devices**

1. **Configure PCs/Workstations**
   - Set IP addresses (DHCP or static)
   - Configure default gateway
   - Set DNS servers
   - Test connectivity

2. **VLAN Assignment**
   - Ensure devices are on correct VLANs
   - Verify port assignments on switches

---

## ✅ Testing and Verification

### **Connectivity Tests**

1. **Test Inter-VLAN Routing**
   ```bash
   # From VLAN 20 device
   ping 10.30.30.10  # Should work (if ACL allows)
   ping 10.40.40.10  # Should work (if ACL allows)
   ping 10.50.50.10  # Should work (if ACL allows)
   ```

2. **Test VLAN Isolation**
   ```bash
   # From VLAN 10 (Guest WiFi)
   ping 10.20.20.10  # Should fail (isolated)
   ping 8.8.8.8      # Should work (internet access)
   ```

3. **Test High Availability**
   - Shut down primary router interface
   - Verify failover to secondary router
   - Check HSRP status

4. **Test ACL Enforcement**
   - Attempt blocked connections
   - Verify traffic is denied
   - Check ACL logs

### **Verification Commands**

**On Routers:**
```bash
show ip route              # Verify routing table
show ip ospf neighbor      # Verify OSPF neighbors
show standby brief         # Verify HSRP status
show ip access-lists       # Verify ACLs
show interfaces           # Verify interface status
```

**On Switches:**
```bash
show vlan brief           # Verify VLANs
show interfaces trunk     # Verify trunk links
show spanning-tree        # Verify STP
show port-security        # Verify port security
show ip dhcp snooping     # Verify DHCP snooping
```

---

## 🔧 Troubleshooting

### **Common Issues**

**Problem: Devices cannot communicate**

**Solutions:**
1. Verify IP addressing
2. Check routing table
3. Verify VLAN assignments
4. Check trunk links
5. Verify ACLs are not blocking

**Problem: HSRP not working**

**Solutions:**
1. Verify HSRP configuration
2. Check interface status
3. Verify HSRP group numbers match
4. Check priority settings
5. Verify preemption is enabled

**Problem: VLANs not working**

**Solutions:**
1. Verify VLANs are created
2. Check trunk configuration
3. Verify access port assignments
4. Check VLAN IDs match
5. Verify inter-VLAN routing

**Problem: OSPF not forming neighbors**

**Solutions:**
1. Verify OSPF is enabled
2. Check network statements
3. Verify area numbers match
4. Check interface status
5. Verify router IDs

---

## 📊 Network Monitoring

### **Key Metrics to Monitor**

- Interface utilization
- Bandwidth usage per VLAN
- Error rates
- Latency
- Uptime/availability
- ACL hits/denies
- HSRP failover events

### **Monitoring Commands**

```bash
# Interface statistics
show interfaces
show interfaces counters

# VLAN statistics
show vlan
show vlan id [vlan-id]

# Routing statistics
show ip ospf database
show ip route summary

# Security statistics
show ip access-lists
show port-security
```

---

## 🔐 Security Best Practices

1. **Change Default Passwords**
   - Set strong passwords
   - Use password encryption
   - Enable SSH instead of Telnet

2. **Enable Logging**
   - Configure syslog
   - Monitor security events
   - Review logs regularly

3. **Port Security**
   - Enable on all access ports
   - Set maximum MAC addresses
   - Configure violation actions

4. **ACL Management**
   - Document all ACLs
   - Review regularly
   - Test before deploying

5. **DHCP Snooping**
   - Enable on all switches
   - Trust only uplinks
   - Monitor for violations

---

## 📝 Documentation Checklist

- [ ] Network topology diagram
- [ ] IP addressing scheme
- [ ] VLAN assignment table
- [ ] Router configurations backed up
- [ ] Switch configurations backed up
- [ ] ACL documentation
- [ ] HSRP configuration documented
- [ ] OSPF configuration documented
- [ ] Testing results documented

---

## 🚀 Next Steps

After network setup:
1. Integrate with Windows domain (Module A)
2. Set up monitoring (Module C)
3. Test failover scenarios
4. Document configurations
5. Capture screenshots

---

**Last Updated:** 2024 | **Version:** 1.0.0 | **Status:** Active

