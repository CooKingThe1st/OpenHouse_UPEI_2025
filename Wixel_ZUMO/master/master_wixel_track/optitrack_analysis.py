import matplotlib.pyplot as plt
from datetime import datetime
import re

# Read the OptiTrack log file
optitrack_file = 'optitrack.log'
sent_packets_file = 'sent_packets_bug.log'

# OptiTrack data
timestamps = []
heading_angles = []
x_positions = []
y_positions = []

with open(optitrack_file, 'r') as f:
    lines = f.readlines()
    
    i = 0
    while i < len(lines):
        line = lines[i].strip()
        
        if line.startswith('@@'):
            timestamp_str = line.replace('@@', '').strip()
            timestamp = datetime.strptime(timestamp_str, '%Y-%m-%d %H:%M:%S.%f')
            
            if i + 1 < len(lines):
                data_line = lines[i + 1].strip()
                parts = data_line.split()
                
                if len(parts) >= 4 and parts[0] == '1':
                    x_pos = float(parts[1])
                    y_pos = float(parts[2])
                    heading = float(parts[3])
                    
                    timestamps.append(timestamp)
                    x_positions.append(x_pos)
                    y_positions.append(y_pos)
                    heading_angles.append(heading)
        
        i += 1

# Read sent packets log for GO_TO commands and sent theta
go_to_times = []
sent_theta_times = []
sent_theta_values = []

with open(sent_packets_file, 'r') as f:
    lines = f.readlines()
    
    i = 0
    while i < len(lines):
        line = lines[i].strip()
        
        # Look for CMD_GO_TO_ORIGIN lines
        if 'CMD_GO_TO_ORIGIN' in line or 'CMD_GO_TO' in line:
            # Extract timestamp from the line like "[2025-10-24 20:37:17.460]"
            timestamp_match = re.search(r'\[(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d+)\]', line)
            if timestamp_match:
                timestamp_str = timestamp_match.group(1)
                timestamp = datetime.strptime(timestamp_str, '%Y-%m-%d %H:%M:%S.%f')
                go_to_times.append(timestamp)
                
                # Look for the slave data in subsequent lines to extract theta
                j = i + 1
                while j < len(lines) and j < i + 10:  # Look ahead a few lines
                    if 'Slave 1' in lines[j] and 'CMD=GO_TO' in lines[j]:
                        # Extract position and theta from line like:
                        # "  Slave 1 (ADD=0x01): Pos=(-1.31, -0.54, 103) CMD=GO_TO"
                        pos_match = re.search(r'Pos=\(([^,]+),\s*([^,]+),\s*(\d+)\)', lines[j])
                        if pos_match:
                            theta_raw = int(pos_match.group(3))
                            sent_theta_times.append(timestamp)
                            sent_theta_values.append(theta_raw)
                        break
                    j += 1
        i += 1

# Convert timestamps to relative seconds
if timestamps:
    start_time = timestamps[0]
    time_seconds = [(t - start_time).total_seconds() for t in timestamps]
    go_to_seconds = [(t - start_time).total_seconds() for t in go_to_times]
    sent_theta_seconds = [(t - start_time).total_seconds() for t in sent_theta_times]
    
    # Create plots
    fig, axes = plt.subplots(4, 1, figsize=(14, 12))
    
    # Plot 1: Heading angle
    axes[0].plot(time_seconds, heading_angles, 'b-', linewidth=1, label='Measured Heading')
    for gt in go_to_seconds:
        axes[0].axvline(x=gt, color='r', linestyle='--', alpha=0.5, linewidth=1.5)
    axes[0].set_xlabel('Time (seconds)')
    axes[0].set_ylabel('Heading Angle (degrees)')
    axes[0].set_title('Robot 1 - Measured Heading Angle Over Time')
    axes[0].grid(True, alpha=0.3)
    axes[0].axhline(y=0, color='k', linestyle='--', alpha=0.3)
    axes[0].legend(['Measured Heading', 'GO_TO Command'])
    
    # Plot 2: Sent Theta (raw value from packet)
    if sent_theta_values:
        axes[1].plot(sent_theta_seconds, sent_theta_values, 'ro-', linewidth=1.5, markersize=4, label='Sent Theta (raw)')
        for gt in go_to_seconds:
            axes[1].axvline(x=gt, color='r', linestyle='--', alpha=0.3, linewidth=1)
        axes[1].set_xlabel('Time (seconds)')
        axes[1].set_ylabel('Sent Theta Value (0-255)')
        axes[1].set_title('Robot 1 - Sent Theta Values in Packets')
        axes[1].grid(True, alpha=0.3)
        axes[1].legend()
    
    # Plot 3: X position
    axes[2].plot(time_seconds, x_positions, 'g-', linewidth=1)
    for gt in go_to_seconds:
        axes[2].axvline(x=gt, color='r', linestyle='--', alpha=0.5, linewidth=1.5)
    axes[2].set_xlabel('Time (seconds)')
    axes[2].set_ylabel('X Position (m)')
    axes[2].set_title('Robot 1 - X Position Over Time')
    axes[2].grid(True, alpha=0.3)
    
    # Plot 4: Y position
    axes[3].plot(time_seconds, y_positions, 'orange', linewidth=1)
    for gt in go_to_seconds:
        axes[3].axvline(x=gt, color='r', linestyle='--', alpha=0.5, linewidth=1.5)
    axes[3].set_xlabel('Time (seconds)')
    axes[3].set_ylabel('Y Position (m)')
    axes[3].set_title('Robot 1 - Y Position Over Time')
    axes[3].grid(True, alpha=0.3)
    
    plt.tight_layout()
    plt.savefig('robot_analysis.png', dpi=300, bbox_inches='tight')
    plt.show()
    
    # Print statistics
    print(f"\n{'='*60}")
    print(f"Data Summary for Robot 1:")
    print(f"{'='*60}")
    print(f"Total data points: {len(timestamps)}")
    print(f"Time range: {time_seconds[0]:.2f}s to {time_seconds[-1]:.2f}s")
    print(f"Duration: {time_seconds[-1]:.2f}s")
    print(f"\nHeading Angle:")
    print(f"  Range: {min(heading_angles):.2f}° to {max(heading_angles):.2f}°")
    print(f"  Mean: {sum(heading_angles)/len(heading_angles):.2f}°")
    print(f"\nPosition:")
    print(f"  X range: {min(x_positions):.4f}m to {max(x_positions):.4f}m")
    print(f"  Y range: {min(y_positions):.4f}m to {max(y_positions):.4f}m")
    print(f"\nCommands:")
    print(f"  Total GO_TO commands sent: {len(go_to_times)}")
    print(f"  Command times (relative to start):")
    for i, gt in enumerate(go_to_seconds, 1):
        theta_idx = i - 1
        if theta_idx < len(sent_theta_values):
            print(f"    {i}. {gt:.3f}s - Sent Theta: {sent_theta_values[theta_idx]}")
        else:
            print(f"    {i}. {gt:.3f}s")
    
    if sent_theta_values:
        print(f"\nSent Theta Statistics:")
        print(f"  Range: {min(sent_theta_values)} to {max(sent_theta_values)}")
        print(f"  Mean: {sum(sent_theta_values)/len(sent_theta_values):.1f}")

else:
    print("No data found in OptiTrack log file!")