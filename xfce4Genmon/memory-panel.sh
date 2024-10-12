#!/usr/bin/env bash
# Dependencies: bash>=3.2, coreutils, file, gawk, grep, lm_sensors, sed, xfce4-taskmanager

# Get RAM usage percentage
readonly USED_RAM_MB=$(free --si -t -h | grep Total | awk '{gsub("G", "", $3); print $3}')

INFO="<txt>"
INFO+=" MEM ${USED_RAM_MB}G "
INFO+="</txt>"

# Panel Print
echo -e "${INFO}"

