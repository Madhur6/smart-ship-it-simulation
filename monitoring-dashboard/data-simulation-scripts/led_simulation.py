#!/usr/bin/env python3
"""
LED Lighting System Data Simulation
Simulates data from 20,000+ LED nodes across multiple zones
"""

import random
import time
import json
from datetime import datetime, timedelta
from typing import Dict, List

# Configuration
TOTAL_NODES = 20000
ZONES = [
    "Deck-5-Cabins", "Deck-6-Cabins", "Deck-7-Cabins", "Deck-8-Cabins",
    "Deck-9-Cabins", "Deck-10-Cabins", "Deck-11-Cabins", "Deck-12-Cabins",
    "Deck-5-Public", "Deck-6-Public", "Deck-7-Public", "Deck-8-Public",
    "Deck-9-Public", "Deck-10-Public", "Deck-11-Public", "Deck-12-Public",
    "Restaurant-Main", "Restaurant-Specialty", "Theater", "Casino",
    "Pool-Deck", "Spa", "Gym", "Library", "Shops", "Atrium"
]
NODES_PER_ZONE = TOTAL_NODES // len(ZONES)

# LED specifications
LED_POWER_WATTS_ON = 12.5  # Power when fully on
LED_POWER_WATTS_OFF = 0.1   # Standby power
LED_DIM_LEVELS = [0, 25, 50, 75, 100]  # Dimming levels (%)
COLOR_TEMPERATURES = [2700, 3000, 3500, 4000, 5000]  # Kelvin

def generate_led_data(zone: str, node_id: int, timestamp: datetime) -> Dict:
    """
    Generate data for a single LED node
    
    Args:
        zone: Zone name
        node_id: Node identifier
        timestamp: Current timestamp
    
    Returns:
        Dictionary with LED node data
    """
    # Determine if LED should be on based on time of day and zone type
    hour = timestamp.hour
    
    # Different zones have different usage patterns
    if "Cabin" in zone:
        # Cabins: Higher usage in evening (18-23) and morning (6-9)
        on_probability = 0.3 if (6 <= hour <= 9 or 18 <= hour <= 23) else 0.1
    elif "Public" in zone:
        # Public areas: Higher usage during day (8-22)
        on_probability = 0.7 if (8 <= hour <= 22) else 0.3
    elif zone in ["Restaurant-Main", "Restaurant-Specialty"]:
        # Restaurants: Higher usage during meal times
        on_probability = 0.9 if (7 <= hour <= 10 or 12 <= hour <= 14 or 18 <= hour <= 22) else 0.4
    elif zone in ["Theater", "Casino"]:
        # Entertainment: Higher usage in evening
        on_probability = 0.8 if (18 <= hour <= 23) else 0.2
    else:
        # Other areas: Moderate usage
        on_probability = 0.5 if (8 <= hour <= 20) else 0.2
    
    # Determine LED status
    is_on = random.random() < on_probability
    
    if is_on:
        dim_level = random.choice(LED_DIM_LEVELS[1:])  # Exclude 0 (off)
        power_watts = LED_POWER_WATTS_ON * (dim_level / 100)
        color_temp = random.choice(COLOR_TEMPERATURES)
    else:
        dim_level = 0
        power_watts = LED_POWER_WATTS_OFF
        color_temp = 3000  # Default when off
    
    return {
        "timestamp": timestamp.isoformat(),
        "zone": zone,
        "node_id": f"LED-{node_id:05d}",
        "status": "on" if is_on else "off",
        "power_watts": round(power_watts, 2),
        "dim_level": dim_level,
        "temperature_k": color_temp,
        "lifetime_hours": random.randint(1000, 50000)  # Simulated lifetime
    }

def generate_zone_summary(zone: str, nodes_data: List[Dict]) -> Dict:
    """
    Generate summary statistics for a zone
    
    Args:
        zone: Zone name
        nodes_data: List of node data dictionaries
    
    Returns:
        Dictionary with zone summary
    """
    total_nodes = len(nodes_data)
    nodes_on = sum(1 for node in nodes_data if node["status"] == "on")
    total_power = sum(node["power_watts"] for node in nodes_data)
    avg_dim_level = sum(node["dim_level"] for node in nodes_data) / total_nodes if total_nodes > 0 else 0
    
    return {
        "timestamp": nodes_data[0]["timestamp"] if nodes_data else datetime.now().isoformat(),
        "zone": zone,
        "total_nodes": total_nodes,
        "nodes_on": nodes_on,
        "nodes_off": total_nodes - nodes_on,
        "on_percentage": round((nodes_on / total_nodes) * 100, 2) if total_nodes > 0 else 0,
        "total_power_watts": round(total_power, 2),
        "total_power_kw": round(total_power / 1000, 3),
        "avg_dim_level": round(avg_dim_level, 1)
    }

def simulate_led_system(output_file: str = "led_data.json", duration_minutes: int = 60, interval_seconds: int = 30):
    """
    Simulate LED system data for specified duration
    
    Args:
        output_file: Output file path
        duration_minutes: Duration of simulation in minutes
        interval_seconds: Data collection interval in seconds
    """
    start_time = datetime.now()
    end_time = start_time + timedelta(minutes=duration_minutes)
    current_time = start_time
    
    all_data = []
    
    print(f"Starting LED simulation...")
    print(f"Total nodes: {TOTAL_NODES}")
    print(f"Zones: {len(ZONES)}")
    print(f"Duration: {duration_minutes} minutes")
    print(f"Interval: {interval_seconds} seconds")
    print()
    
    while current_time <= end_time:
        timestamp = current_time
        print(f"Generating data for {timestamp.strftime('%Y-%m-%d %H:%M:%S')}...")
        
        # Generate data for all nodes
        nodes_data = []
        node_counter = 1
        
        for zone in ZONES:
            for _ in range(NODES_PER_ZONE):
                node_data = generate_led_data(zone, node_counter, timestamp)
                nodes_data.append(node_data)
                node_counter += 1
        
        # Generate zone summaries
        zone_summaries = []
        for zone in ZONES:
            zone_nodes = [node for node in nodes_data if node["zone"] == zone]
            zone_summary = generate_zone_summary(zone, zone_nodes)
            zone_summaries.append(zone_summary)
        
        # Store data
        all_data.append({
            "timestamp": timestamp.isoformat(),
            "nodes": nodes_data,
            "zone_summaries": zone_summaries,
            "total_nodes": TOTAL_NODES,
            "total_power_kw": round(sum(node["power_watts"] for node in nodes_data) / 1000, 3)
        })
        
        # Wait for next interval
        time.sleep(interval_seconds)
        current_time += timedelta(seconds=interval_seconds)
    
    # Save to file
    print(f"\nSaving data to {output_file}...")
    with open(output_file, 'w') as f:
        json.dump(all_data, f, indent=2)
    
    print(f"Simulation complete! Generated {len(all_data)} data points.")
    print(f"Total nodes per data point: {TOTAL_NODES}")
    print(f"Total records: {len(all_data) * TOTAL_NODES}")

if __name__ == "__main__":
    import argparse
    
    parser = argparse.ArgumentParser(description="Simulate LED lighting system data")
    parser.add_argument("--output", "-o", default="led_data.json", help="Output file path")
    parser.add_argument("--duration", "-d", type=int, default=60, help="Duration in minutes")
    parser.add_argument("--interval", "-i", type=int, default=30, help="Interval in seconds")
    
    args = parser.parse_args()
    
    simulate_led_system(
        output_file=args.output,
        duration_minutes=args.duration,
        interval_seconds=args.interval
    )

