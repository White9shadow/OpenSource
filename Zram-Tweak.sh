#!/system/bin/sh
# Author: @revWhiteShadow
# Build Date: null-null-2019
# Last Modified: 10-4-2024
# Description: This script is open for anyone to use. If you use any part of this script, please give proper credit.
# Disclaimer: This is a template. First, understand the code, then modify and use it at your own risk.
# Functionality of the script goes here
# Example usage:
# ./script.sh


# Define the swap sizes in MB for simplicity
SWAP_SIZES_MB=($(seq 4000 2000 20000)) # 4GB, 6GB, 8GB, 12GB, 14GB, 16GB, 18GB, 20GB
SWAP_COUNT=8 # Number of swap files to create

# Create the necessary directories
mkdir -p /data/adb/modules/zram_swap_changer/swapfiles

# Clean up any existing swap files
for i in $(seq 1 $SWAP_COUNT); do
  rm -f /data/adram/modules/zram_swap_changer/swapfiles/swap$i.swp
done

# Create new swap files with the desired sizes
for i in $(seq 0 $((${#SWAP_SIZES_MB[@]}-1))); do
  dd if=/dev/zero of=/data/adb/modules/zram_swap_changer/swapfiles/swap$i.swp bs=1M count=${SWAP_SIZES_MB[$i]}
  chmod 600 /data/adb/modules/zram_swap_changer/swapfiles/swap$i.swp
  mkswap /data/adb/modules/zram_swap_changer/swapfiles/swap$i.swp
done

# Enable the zram module and set the swappiness value
echo 100 > /sys/module/zram/parameters/swapiness

# Activate the desired number of swap files based on the user's choice
activate_swap() {
  SWAP_INDEX=$1
  for i in $(seq 0 $((${#SWAP_SIZES_MB[@]}-1))); do
    if [ $i -lt $SWAP_INDEX ]; then
      echo 1 > /sys/block/zram0/swapsize
      swapon /data/adb/modules/zram_swap_changer/swapfiles/swap$i.swp
    else
      echo 0 > /sys/block/zram0/swapsize
      swapoff /data/adb/modules/zram_swap_changer/swapfiles/swap$i.swp
    fi
  done
}

# Call the activate_swap function with the desired swap size index
activate_swap $MODPATH/configs/swap_size_index

# Restart any necessary services that may be affected by the swap change
# (e.g., start pm-service or restart the Android system UI)
