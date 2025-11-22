# Network Simulation Module

This directory contains all resources for Module B - Network Infrastructure & Zoning.

## 📋 Overview

This module implements the network infrastructure design using network simulation tools (GNS3, Packet Tracer, or EVE-NG). The simulation demonstrates VLAN segmentation, routing, high-availability, and network security.

## 📁 Directory Structure

```
network-simulation/
├── README.md              # This file
├── configs/               # Router and switch configuration files
├── gns3-project/          # GNS3 project files
└── packet-tracer/         # Packet Tracer project files
```

## 🛠️ Simulation Tools

### **Option 1: GNS3 (Recommended for Advanced Features)**

**Advantages:**
- Real Cisco IOS images
- Advanced features support
- Professional-grade simulation
- Supports complex topologies

**Requirements:**
- GNS3 software
- Cisco IOS images (legal copy required)
- Sufficient RAM (8GB+ recommended)

### **Option 2: Cisco Packet Tracer**

**Advantages:**
- Free for educational use
- Easy to use
- Good for basic to intermediate topologies
- Built-in device models

**Limitations:**
- Limited advanced features
- Simplified device behavior

### **Option 3: EVE-NG**

**Advantages:**
- Enterprise-grade simulation
- Supports multiple vendors
- Web-based interface
- Professional features

**Requirements:**
- EVE-NG installation
- Device images

## 🚀 Quick Start

### **Using GNS3**

1. **Install GNS3:**
   - Download from gns3.com
   - Install GNS3 and GNS3 VM (if using)

2. **Import Project:**
   - Open GNS3
   - Import project from `gns3-project/`
   - Load device configurations

3. **Start Simulation:**
   - Start all devices
   - Verify connectivity
   - Test configurations

### **Using Packet Tracer**

1. **Open Project:**
   - Open Packet Tracer
   - Load project from `packet-tracer/`
   - Review topology

2. **Configure Devices:**
   - Apply configurations from `configs/`
   - Verify settings
   - Test connectivity

## 📖 Documentation

- **[Network Architecture](../docs/architecture/network-architecture.md)** - Complete network design
- **Configuration Guides** - Coming soon
- **Troubleshooting Guide** - Coming soon

## 🔧 Configuration Files

Configuration files are organized by device type:
- Router configurations
- Switch configurations
- Access point configurations (if applicable)

## ✅ Testing Checklist

After setup, verify:
- [ ] All VLANs are configured correctly
- [ ] Inter-VLAN routing works
- [ ] HSRP/VRRP failover functions
- [ ] ACLs are enforced
- [ ] OSPF routing is working
- [ ] Port security is active
- [ ] DHCP snooping is enabled

## 🐛 Troubleshooting

### **Common Issues**

**Devices not connecting:**
- Verify network links are up
- Check IP addressing
- Verify routing configuration

**VLANs not working:**
- Check trunk configuration
- Verify VLAN IDs match
- Check switch port assignments

**Routing issues:**
- Verify OSPF is enabled
- Check router IDs
- Verify network statements

## 📝 Next Steps

1. Choose simulation tool
2. Set up project topology
3. Configure devices
4. Test connectivity
5. Document configurations
6. Capture screenshots

---

**Last Updated:** 2025 | **Status:** In Progress

