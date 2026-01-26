#!/bin/bash
# smart_fan.sh - CPU-only automatic fan control

INTERVAL=5  # seconds between checks
LAST_LEVEL=-1

while true; do
    # Get CPU temperature as integer
    CPU_TEMP=$(sensors | awk '/CPU:/ {gsub(/\+|°C/,"",$2); print int($2)}')

    # Determine fan level
    if (( CPU_TEMP <= 45 )); then
        LEVEL=0
    elif (( CPU_TEMP <= 50 )); then
        LEVEL=1
    elif (( CPU_TEMP <= 55 )); then
        LEVEL=2
    elif (( CPU_TEMP <= 60 )); then
        LEVEL=3
    elif (( CPU_TEMP <= 65 )); then
        LEVEL=4
    elif (( CPU_TEMP <= 70 )); then
        LEVEL=5
    else
        LEVEL=7
    fi

    # Only update fan if it changed
    if [ "$LEVEL" -ne "$LAST_LEVEL" ]; then
        echo "$(date '+%H:%M:%S') CPU: ${CPU_TEMP}°C → Setting fan level $LEVEL"
        echo "level $LEVEL" | sudo tee /proc/acpi/ibm/fan > /dev/null
        LAST_LEVEL=$LEVEL
    fi

    sleep $INTERVAL
done
