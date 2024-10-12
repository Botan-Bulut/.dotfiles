#!/usr/bin/env bash
# Dependencies: bash>=3.2, coreutils, file, gawk, grep, lm_sensors, sed, xfce4-taskmanager

# Get RAM usage percentage
readonly USED_RAM_MB=$(free -m --si | awk 'NR==2 {print $3}')
# Define color variables for RAM
readonly YELLOW="<span color='#FFFF00'>"
readonly ORANGE="<span color='#FFA500'>"
readonly RED="<span color='#FF0000'>"
readonly RESET="</span>"

# Set color based on RAM usage
if (( USED_RAM_MB < 3000 )); then
    INFO="<txt>"
    INFO+="  MEM  ${USED_RAM_MB}  "
    INFO+="</txt>"
elif (( USED_RAM_MB < 6000 )); then
    COLOR=${YELLOW}
elif (( USED_RAM_MB < 9000 )); then
    COLOR=${ORANGE}
else
    COLOR=${RED}
fi

if [[ -n "$COLOR" ]]; then
    INFO="<txt>"
    INFO+="  ${COLOR}MEM ${USED_RAM_MB}${RESET}  "
    INFO+="</txt>"
fi

# Panel Print
echo -e "${INFO}"

