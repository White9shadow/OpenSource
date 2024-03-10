#!/system/bin/sh
# Author: @revWhiteShadow
# Build Date: 1-2-2022
# Last Modified: 10-4-2024
# Description: This script is open for anyone to use. If you use any part of this script, please give proper credit.
# Disclaimer: This is a template. First, understand the code, then modify and use it at your own risk.
# Functionality of the script goes here
# Example usage:
# ./script.sh

# Clear app caches
for app in $(pm list packages -f | cut -d ':' -f 2); do
    app_name=$(echo $app | sed 's/\//\//g' | sed 's/^.*\///')
    rm -rf /data/data/$app/cache/*
    echo "Cache cleared for $app_name"
done

# Stop unnecessary background services
for service in $(service list | grep user | awk '{print $2}'); do
    am force-stop $service
done

# Disable animations
settings put system window_animation_scale 0
settings put system transition_animation_scale 0
settings put system animator_duration_scale 0

###################################
# service.sh > Boot on start
###################################
start() {
  ui_print "Starting AndroOptimizer services..."
  start lowmemorykiller
  start vmpressure
}

stop() {
  ui_print "Stopping AndroOptimizer services..."
  stop lowmemorykiller
  stop vmpressure
}

# Add start/stop hooks
add_service_hooks() {
  install -Dm644 $MODPATH/config/android.permissions $MODPATH/system/etc/permissions/
  sed -i 's|#service_manager|service_manager|g' $MODPATH/system/etc/permissions/android.permissions
  sed -i 's|#androoptimizer|androoptimizer|g' $MODPATH/system/etc/permissions/android.permissions

  install -Dm644 $MODPATH/service $MODPATH/system/bin/
  chmod 755 $MODPATH/system/bin/service
}

# Initialize service hooks
add_service_hooks

# Start services
start

# Auto-start on boot
on property:sys.boot_completed=1
start
