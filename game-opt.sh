#!/system/bin/sh
# Author: @revWhiteShadow
# Build Date: 12-03-2024
# Last Modified: 
# Description: This script is open for anyone to use. If you use any part of this script, please give proper credit.

# Disclaimer: This is a template. First, understand the code, then modify and use it at your own risk.

# Functionality of the script goes here

# Example usage:
# ./script.sh

# Magisk Module Script for Game Optimization Service

# Ensure the necessary files are in place
if [ ! -f /system/bin/game_optimization ]; then
    install -Dm644 $MODPATH/files/game_optimization /system/bin/
    chmod 0755 /system/bin/game_optimization
fi

# Create the service
if [ ! -f /system/etc/init/game_optimization.rc ]; then
    cat <<EOF >/system/etc/init/game_optimization.rc
service game_optimization /system/bin/game_optimization
    class main
    user system
    group system
    oneshot
EOF
fi

# Enable the service
if ! grep -q "game_optimization" /system/etc/init/init.rc; then
    sed -i '/^service netd/,/^}$/ s/^/$&    on boot game_optimization\n/' /system/etc/init/init.rc
fi
