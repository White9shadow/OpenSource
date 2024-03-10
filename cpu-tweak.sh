#!/system/bin/sh


# Author: @revWhiteShadow
# Build Date: null
# Last Modified: 10-4-2024
# Description: This script is open for anyone to use. If you use any part of this script, please give proper credit.

# Disclaimer: This is a template. First, understand the code, then modify and use it at your own risk.

# Functionality of the script goes here

# Example usage:
# ./script.sh

# Check if the device is rooted and Magisk is installed
if [ ! -f /system/bin/su ]; then
    echo "Error: Device is not rooted or Magisk is not installed."
    exit 1
fi

# Check if the user has provided the desired governor and frequency
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <governor> <frequency>"
    echo "Example: $0 conservative 1800000"
    exit 1
fi

# Save the governor and frequency to variables
GOVERNOR="$1"
FREQUENCY="$2"

# Check if the governor is valid
if [ ! -f "/sys/devices/system/cpu/cpu0/cpufreq/$GOVERNOR" ]; then
    echo "Error: Invalid governor."
    exit 1
fi

# Change the governor for all cores
for i in /sys/devices/system/cpu/cpu[0-9]*; do
    echo $GOVERNOR > ${i}/cpufreq/scaling_governor
done

# Set the maximum frequency for all cores
for i in /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_max_freq; do
    echo $FREQUENCY > $i
done

# Verify that the governor and frequency have been changed
for i in /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_governor; do
    GOVERNOR_CURRENT=$(cat $i)
    if [ "$GOVERNOR_CURRENT" != "$GOVERNOR" ]; then
        echo "Error: Governor not changed for core $(basename $i)"
        exit 1
    fi
done

for i in /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_max_freq; do
    FREQUENCY_CURRENT=$(cat $i)
    if [ "$GOVERNOR_CURRENT" != "$FREQUENCY" ]; then
        echo "Error: Frequency not changed for core $(basename $i)"
        exit 1
    fi
done

echo "Success: Governor and frequency have been changed for all cores."
