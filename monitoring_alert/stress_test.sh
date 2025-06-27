#!/bin/bash
# This script installs the stress tool and generates high CPU load on a Linux VM.

# Install stress tool
sudo apt-get update
sudo apt-get install stress

# Generate high CPU load
# This will use 4 workers, each spinning on a sqrt() calculation for 600 seconds
stress --cpu 6 --timeout 600


#!/bin/bash

# Check if stress-ng is installed
if ! command -v stress-ng &> /dev/null; then
    echo "stress-ng is not installed. Installing..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y stress-ng
    elif command -v yum &> /dev/null; then
        sudo yum install -y stress-ng
    else
        echo "Could not install stress-ng. Please install it manually."
        exit 1
    fi
fi

# Get number of CPU cores
num_cores=$(nproc)

# Calculate load per core to achieve ~60% total CPU usage
# Using 0.6 as multiplier for 60%
load_per_core=$(echo "scale=2; 0.6 * $num_cores" | bc)

echo "Starting CPU stress test..."
echo "Number of CPU cores: $num_cores"
echo "Target load: 60%"

# Run stress-ng with calculated load
stress-ng --cpu $load_per_core --cpu-load 60 --timeout 300s

echo "Stress test completed"