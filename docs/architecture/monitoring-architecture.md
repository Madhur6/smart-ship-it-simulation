# Monitoring Architecture

## 📋 Overview

This document outlines the monitoring and analytics infrastructure for the Smart Cruise Vessel IT simulation. The architecture includes infrastructure monitoring, IoT data collection, energy analytics, and operational dashboards.

---

## 🎯 Monitoring Objectives

### **Primary Goals**
- **Infrastructure Health:** Monitor servers, network, and services
- **IoT Data Collection:** Collect data from 20,000+ LED nodes and sensors
- **Energy Analytics:** Track and optimize energy consumption
- **Operational Insights:** Provide actionable analytics for operations
- **Proactive Alerting:** Notify of issues before they impact operations

### **Monitoring Scope**
1. **Infrastructure Monitoring**
   - Windows Server health (CPU, memory, disk)
   - Network device status and performance
   - Service availability (AD, DNS, DHCP)
   - Application performance

2. **IoT & Energy Monitoring**
   - LED lighting system (20,000+ nodes)
   - Energy consumption by zone
   - Temperature and HVAC
   - Power distribution

3. **Operational Analytics**
   - Food waste tracking
   - Resource consumption patterns
   - Guest activity (anonymized)
   - Crew efficiency metrics

---

## 🏗️ Architecture Design

### **Monitoring Platform Options**

#### **Option 1: Grafana + Prometheus (Recommended)**

**Components:**
- **Grafana:** Visualization and dashboards
- **Prometheus:** Metrics collection and storage
- **Node Exporter:** System metrics
- **Windows Exporter:** Windows-specific metrics
- **SNMP Exporter:** Network device metrics

**Advantages:**
- Open-source and free
- Highly customizable
- Excellent visualization
- Strong community support
- Scalable architecture

#### **Option 2: Grafana + InfluxDB**

**Components:**
- **Grafana:** Visualization
- **InfluxDB:** Time-series database
- **Telegraf:** Data collection agent

**Advantages:**
- Optimized for time-series data
- Good for IoT data
- Easy to set up
- Good performance

#### **Option 3: Zabbix**

**Components:**
- **Zabbix Server:** Central monitoring server
- **Zabbix Agent:** Client agents
- **Zabbix Web Interface:** Dashboard

**Advantages:**
- All-in-one solution
- Built-in alerting
- Good Windows support
- Enterprise features

#### **Option 4: Power BI**

**Components:**
- **Power BI Desktop:** Report creation
- **Power BI Service:** Cloud dashboard
- **Data Sources:** Various connectors

**Advantages:**
- Microsoft ecosystem integration
- Excellent visualization
- Easy to share
- Business-focused

---

## 📊 Data Collection Strategy

### **Infrastructure Metrics**

#### **Windows Server Monitoring**

**Metrics Collected:**
- CPU utilization (%)
- Memory usage (MB/GB)
- Disk I/O (read/write)
- Disk space usage (%)
- Network interface statistics
- Service status (running/stopped)
- Event log errors/warnings

**Collection Method:**
- Windows Performance Counters
- WMI queries
- Windows Exporter (Prometheus)
- Zabbix Agent (Zabbix)

**Collection Interval:** 1 minute

#### **Network Device Monitoring**

**Metrics Collected:**
- Interface utilization (%)
- Interface errors/discards
- CPU utilization
- Memory usage
- Temperature
- Uptime

**Collection Method:**
- SNMP (v2c or v3)
- SNMP Exporter (Prometheus)
- Zabbix SNMP monitoring

**Collection Interval:** 1-5 minutes

#### **Application Monitoring**

**Metrics Collected:**
- Service availability
- Response time
- Error rates
- Transaction counts

**Collection Method:**
- Application logs
- Custom metrics endpoints
- Health check endpoints

---

### **IoT & Energy Metrics**

#### **LED Lighting System (20,000+ Nodes)**

**Metrics Collected:**
- LED status (on/off) per zone
- Power consumption per zone
- Usage hours per zone
- Dimming levels
- Color temperature (if applicable)

**Data Structure:**
```json
{
  "timestamp": "2025-01-15T10:30:00Z",
  "zone": "Deck-5-Cabins",
  "node_id": "LED-12345",
  "status": "on",
  "power_watts": 12.5,
  "dim_level": 80,
  "temperature_k": 3000
}
```

**Collection Method:**
- MQTT broker (for IoT devices)
- REST API endpoints
- Python data simulation scripts
- Direct database writes

**Collection Interval:** 30 seconds - 1 minute

#### **Energy Consumption**

**Metrics Collected:**
- Total power consumption (kW)
- Power consumption by zone
- Power consumption by system
- Peak demand
- Energy cost estimates

**Data Sources:**
- Power meters
- Smart breakers
- Building management systems
- Calculated from device data

**Collection Interval:** 1 minute

#### **Environmental Monitoring**

**Metrics Collected:**
- Temperature (°C/°F) by zone
- Humidity (%) by zone
- Air quality (if sensors available)
- HVAC system status

**Collection Interval:** 1-5 minutes

---

### **Operational Analytics**

#### **Food Waste Tracking**

**Metrics Collected:**
- Food waste by meal type (kg)
- Waste by location (restaurant, buffet, etc.)
- Waste trends over time
- Cost of waste
- Reduction targets vs actual

**Data Sources:**
- Manual entry (kitchen staff)
- Automated scales (if available)
- POS system integration

**Collection Interval:** Daily/Per meal

#### **Resource Consumption**

**Metrics Collected:**
- Water consumption (liters)
- Fuel consumption (if applicable)
- Supplies usage
- Inventory levels

**Collection Interval:** Hourly/Daily

---

## 🗄️ Data Storage

### **Time-Series Database**

**Recommended:** InfluxDB or TimescaleDB

**Schema Design:**
- **Measurement:** Type of metric (e.g., "cpu_usage", "led_status")
- **Tags:** Dimensions (e.g., server, zone, department)
- **Fields:** Actual values (e.g., value, count)
- **Timestamp:** Time of measurement

**Example:**
```
Measurement: led_power
Tags: zone=Deck-5-Cabins, node_id=LED-12345
Fields: power_watts=12.5, status=on
Timestamp: 2025-01-15T10:30:00Z
```

### **Retention Policy**

- **Raw Data:** 30 days
- **1-minute aggregates:** 90 days
- **5-minute aggregates:** 1 year
- **Hourly aggregates:** 5 years
- **Daily aggregates:** 10 years

---

## 📈 Dashboard Design

### **Infrastructure Dashboard**

**Panels:**
1. **Server Health Overview**
   - CPU utilization (all servers)
   - Memory usage (all servers)
   - Disk space (all servers)
   - Service status indicators

2. **Network Performance**
   - Interface utilization graphs
   - Network latency
   - Packet loss
   - Bandwidth usage

3. **Service Availability**
   - AD DS status
   - DNS resolution time
   - DHCP lease distribution
   - File share availability

4. **Alert Summary**
   - Active alerts
   - Alert history
   - Critical issues

### **Energy & IoT Dashboard**

**Panels:**
1. **LED Usage Overview**
   - Total LEDs on/off
   - Power consumption by zone
   - Usage heatmap
   - Cost analysis

2. **Energy Consumption**
   - Total power consumption
   - Consumption by zone
   - Consumption trends
   - Peak demand

3. **Environmental Monitoring**
   - Temperature by zone
   - HVAC status
   - Energy efficiency metrics

4. **Optimization Insights**
   - Energy savings opportunities
   - Usage patterns
   - Recommendations

### **Operational Dashboard**

**Panels:**
1. **Food Waste Analytics**
   - Waste trends
   - Waste by location
   - Cost analysis
   - Reduction progress

2. **Resource Utilization**
   - Water consumption
   - Supplies usage
   - Inventory levels

3. **Department Performance**
   - Department metrics
   - Efficiency indicators
   - Comparison charts

---

## 🔔 Alerting Configuration

### **Alert Levels**

1. **Critical:** Immediate action required
   - Service down
   - Disk space < 5%
   - Network outage
   - Security incident

2. **Warning:** Attention needed
   - High CPU usage (>80%)
   - High memory usage (>85%)
   - Disk space < 15%
   - Service degradation

3. **Info:** Informational
   - Scheduled maintenance
   - Configuration changes
   - Routine events

### **Alert Channels**

- **Email:** For all alerts
- **SMS:** For critical alerts only
- **Slack/Teams:** For team notifications
- **PagerDuty:** For on-call escalation

### **Alert Rules Examples**

**Infrastructure:**
- CPU usage > 80% for 5 minutes
- Memory usage > 85% for 5 minutes
- Disk space < 10%
- Service down
- Network interface down

**Energy:**
- Power consumption > threshold
- LED system failure
- HVAC system failure

**Operational:**
- Food waste > daily target
- Resource consumption spike
- Inventory low

---

## 🚀 Implementation Steps

### **Phase 1: Platform Setup**
1. Choose monitoring platform
2. Install monitoring server
3. Configure database
4. Set up data collection agents

### **Phase 2: Infrastructure Monitoring**
1. Deploy agents to Windows servers
2. Configure SNMP for network devices
3. Set up service monitoring
4. Create infrastructure dashboards

### **Phase 3: IoT Data Collection**
1. Set up data simulation scripts
2. Configure MQTT broker (if needed)
3. Create data ingestion pipeline
4. Set up IoT dashboards

### **Phase 4: Analytics & Reporting**
1. Create operational dashboards
2. Set up alerting rules
3. Configure notification channels
4. Test alerting

### **Phase 5: Optimization**
1. Analyze data for insights
2. Create optimization reports
3. Implement recommendations
4. Monitor improvements

---

## 📝 Documentation Requirements

- [ ] Monitoring architecture diagram
- [ ] Data flow diagram
- [ ] Dashboard screenshots
- [ ] Alert configuration documentation
- [ ] Data retention policies
- [ ] Troubleshooting guide

---

## 🔗 Related Documentation

- [Windows Infrastructure](../architecture/windows-infrastructure.md) - Monitored systems
- [Network Architecture](../architecture/network-architecture.md) - Network monitoring
- [Project Plan](../project-plan.md) - Overall project

---

**Last Updated:** 2025 | **Version:** 1.0.0 | **Status:** In Progress

