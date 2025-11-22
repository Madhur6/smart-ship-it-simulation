# DNS and DHCP Configuration Guide

## 📋 Overview

This guide provides detailed instructions for configuring DNS and DHCP services in the CRUISE.LOCAL domain. These services are critical for network functionality and client connectivity.

---

## 🌐 DNS Configuration

### **DNS Server Role**

DNS is automatically installed when you install Active Directory Domain Services. The domain controller acts as the DNS server for the domain.

### **Forward Lookup Zones**

#### **Primary Zone: cruise.local**

This zone is created automatically when you promote a server to Domain Controller. It contains:
- Domain controller records
- Server records
- Client records (if dynamic updates enabled)

**Verification:**
```powershell
Get-DnsServerZone -Name "cruise.local"
```

### **Reverse Lookup Zones**

Create reverse lookup zones for each subnet to enable reverse DNS lookups.

#### **Zone 1: 20.20.10.in-addr.arpa (10.20.20.0/24)**

**Creation via PowerShell:**
```powershell
Add-DnsServerPrimaryZone -Name "20.20.10.in-addr.arpa" `
                         -DynamicUpdate Secure `
                         -ReplicationScope Domain
```

**Creation via GUI:**
1. Open DNS Manager
2. Right-click "Reverse Lookup Zones" > New Zone
3. Select "Primary zone"
4. Select "Store the zone in Active Directory"
5. Enter network ID: 10.20.20
6. Select "Allow only secure dynamic updates"
7. Finish

#### **Zone 2: 50.50.10.in-addr.arpa (10.50.50.0/24)**

Follow the same steps as above, using network ID: 10.50.50

### **DNS Records**

#### **A Records (Host Records)**

| Name | IP Address | Purpose |
|------|------------|---------|
| DC01 | 10.20.20.10 | Primary Domain Controller |
| DC02 | 10.20.20.11 | Secondary Domain Controller |
| FS01 | 10.20.20.20 | File Server |

**Creation via PowerShell:**
```powershell
Add-DnsServerResourceRecordA -Name "DC01" `
                             -ZoneName "cruise.local" `
                             -IPv4Address "10.20.20.10"
```

**Creation via GUI:**
1. Open DNS Manager
2. Expand Forward Lookup Zones > cruise.local
3. Right-click zone > New Host (A or AAAA)
4. Enter name and IP address
5. Check "Create associated pointer (PTR) record" if reverse zone exists
6. Add Host

#### **CNAME Records (Alias Records)**

| Name | Target | Purpose |
|------|--------|---------|
| CRUISE-DC | DC01.cruise.local | Domain Controller alias |

**Creation via PowerShell:**
```powershell
Add-DnsServerResourceRecordCName -Name "CRUISE-DC" `
                                 -ZoneName "cruise.local" `
                                 -HostNameAlias "DC01.cruise.local"
```

**Creation via GUI:**
1. Open DNS Manager
2. Expand Forward Lookup Zones > cruise.local
3. Right-click zone > New Alias (CNAME)
4. Enter alias name and target host
5. OK

### **DNS Forwarders**

Configure forwarders to resolve external DNS queries.

**Configuration via PowerShell:**
```powershell
Set-DnsServerForwarder -IPAddress @("8.8.8.8", "1.1.1.1")
```

**Configuration via GUI:**
1. Open DNS Manager
2. Right-click server name > Properties
3. Forwarders tab
4. Edit
5. Add forwarder IPs: 8.8.8.8, 1.1.1.1
6. OK

### **DNS Testing**

**Test forward lookup:**
```powershell
nslookup DC01.cruise.local
```

**Test reverse lookup:**
```powershell
nslookup 10.20.20.10
```

**Test external resolution:**
```powershell
nslookup google.com
```

---

## 🔌 DHCP Configuration

### **DHCP Server Installation**

#### **Installation via PowerShell:**
```powershell
Install-WindowsFeature -Name DHCP -IncludeManagementTools
```

#### **Installation via GUI:**
1. Server Manager > Add Roles and Features
2. Select "DHCP Server"
3. Install

### **Authorize DHCP Server**

DHCP servers must be authorized in Active Directory before they can lease IP addresses.

**Authorization via PowerShell:**
```powershell
Import-Module DHCPServer
Add-DhcpServerInDC
```

**Authorization via GUI:**
1. Open DHCP console
2. Right-click server > Authorize
3. Wait for authorization (may take a few minutes)

### **DHCP Scopes**

#### **Scope 1: Crew/Admin Network (VLAN 20)**

**Configuration:**
- **Network:** 10.20.20.0/24
- **Subnet Mask:** 255.255.255.0
- **Range:** 10.20.20.100 - 10.20.20.200
- **Exclusions:** 10.20.20.1 - 10.20.20.99
- **Gateway:** 10.20.20.1
- **DNS Servers:** 10.20.20.10, 10.20.20.11
- **Lease Duration:** 8 days

**Creation via PowerShell:**
```powershell
# Create scope
Add-DhcpServerv4Scope -Name "Crew-Admin-Network" `
                      -StartRange "10.20.20.100" `
                      -EndRange "10.20.20.200" `
                      -SubnetMask "255.255.255.0" `
                      -State "Active" `
                      -Description "Crew/Admin Network (VLAN 20)" `
                      -LeaseDuration (New-TimeSpan -Days 8)

# Set scope options
Set-DhcpServerv4OptionValue -ScopeId "10.20.20.0" `
                            -Router "10.20.20.1" `
                            -DnsServer @("10.20.20.10", "10.20.20.11") `
                            -DnsDomain "cruise.local"

# Add exclusions
Add-DhcpServerv4ExclusionRange -ScopeId "10.20.20.0" `
                               -StartRange "10.20.20.1" `
                               -EndRange "10.20.20.99"
```

**Creation via GUI:**
1. Open DHCP console
2. Expand server > IPv4
3. Right-click IPv4 > New Scope
4. Scope Name: "Crew-Admin-Network"
5. IP Address Range: 10.20.20.100 - 10.20.20.200
6. Subnet Mask: 255.255.255.0
7. Add Exclusions: 10.20.20.1 - 10.20.20.99
8. Lease Duration: 8 days
9. Configure Router (Default Gateway): 10.20.20.1
10. Domain Name: cruise.local
11. DNS Servers: 10.20.20.10, 10.20.20.11
12. Activate scope

#### **Scope 2: Hotel Operations (VLAN 50)**

**Configuration:**
- **Network:** 10.50.50.0/24
- **Subnet Mask:** 255.255.255.0
- **Range:** 10.50.50.100 - 10.50.50.200
- **Exclusions:** 10.50.50.1 - 10.50.50.99
- **Gateway:** 10.50.50.1
- **DNS Servers:** 10.20.20.10, 10.20.20.11
- **Lease Duration:** 8 days

Follow the same steps as Scope 1, using the Hotel Operations network settings.

### **DHCP Reservations**

Reserve specific IP addresses for servers and critical devices.

**Example: Reserve IP for File Server**

**Via PowerShell:**
```powershell
Add-DhcpServerv4Reservation -ScopeId "10.20.20.0" `
                            -IPAddress "10.20.20.20" `
                            -ClientId "AA-BB-CC-DD-EE-FF" `
                            -Description "File Server FS01"
```

**Via GUI:**
1. Open DHCP console
2. Expand scope > Reservations
3. Right-click Reservations > New Reservation
4. Reservation Name: FS01
5. IP Address: 10.20.20.20
6. MAC Address: [Device MAC address]
7. Description: File Server FS01
8. Add

### **DHCP Testing**

**Verify scope is active:**
```powershell
Get-DhcpServerv4Scope
```

**Check leased addresses:**
```powershell
Get-DhcpServerv4Lease -ScopeId "10.20.20.0"
```

**Test from client:**
1. Configure client to obtain IP automatically
2. Run `ipconfig /release`
3. Run `ipconfig /renew`
4. Verify IP address is in scope range
5. Verify DNS servers are configured correctly

---

## 🔍 Troubleshooting

### **DNS Issues**

**Problem: Cannot resolve domain names**

**Solutions:**
1. Verify DNS service is running: `Get-Service DNS`
2. Check DNS server IP in network settings
3. Test DNS server connectivity: `Test-NetConnection -ComputerName 10.20.20.10 -Port 53`
4. Verify forwarders are configured correctly
5. Check DNS event logs: Event Viewer > DNS Server

**Problem: Reverse lookup not working**

**Solutions:**
1. Verify reverse lookup zone exists
2. Check PTR records are created
3. Enable dynamic updates on reverse zone

### **DHCP Issues**

**Problem: Clients cannot obtain IP address**

**Solutions:**
1. Verify DHCP server is authorized: `Get-DhcpServerInDC`
2. Check DHCP service is running: `Get-Service DHCPServer`
3. Verify scope is active: `Get-DhcpServerv4Scope`
4. Check scope has available addresses
5. Verify network connectivity between client and server
6. Check DHCP event logs: Event Viewer > DHCP Server

**Problem: Wrong DNS servers assigned**

**Solutions:**
1. Verify scope options: `Get-DhcpServerv4OptionValue -ScopeId "10.20.20.0"`
2. Update DNS server option if incorrect
3. Release and renew client IP address

---

## 📊 Monitoring

### **DNS Monitoring**

**Key Metrics:**
- DNS query response time
- Failed query count
- Zone transfer status
- Forwarder response time

**Monitoring Commands:**
```powershell
# Get DNS server statistics
Get-DnsServerStatistics

# Get zone statistics
Get-DnsServerZoneStatistics -ZoneName "cruise.local"
```

### **DHCP Monitoring**

**Key Metrics:**
- Scope utilization percentage
- Lease duration statistics
- Failed lease attempts
- Reservation usage

**Monitoring Commands:**
```powershell
# Get scope statistics
Get-DhcpServerv4ScopeStatistics

# Get lease statistics
Get-DhcpServerv4Lease -ScopeId "10.20.20.0" | Measure-Object
```

---

## ✅ Best Practices

1. **DNS:**
   - Use secure dynamic updates
   - Configure forwarders for external resolution
   - Create reverse lookup zones
   - Monitor DNS performance

2. **DHCP:**
   - Reserve IPs for servers and network devices
   - Use appropriate lease duration (8 days recommended)
   - Monitor scope utilization
   - Document all reservations

3. **General:**
   - Document all configurations
   - Test after changes
   - Monitor event logs regularly
   - Keep backups of configurations

---

**Last Updated:** 2025 | **Version:** 1.0.0 | **Status:** Active

