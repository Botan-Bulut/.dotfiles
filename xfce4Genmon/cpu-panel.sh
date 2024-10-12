#!/usr/bin/env bash
# Dependencies: bash>=3.2, coreutils, file, gawk, grep, lm_sensors, sed, xfce4-taskmanager

# Get CPU usage percentage
readonly CPU_PERCENTAGE=$(top -b -n1 | grep "%Cpu" | awk '{sum=(100 - $8)} END {print int(sum)}')

# Define color variables for CPU
readonly WHITE=""
readonly YELLOW="<span color='#FFFF00'>"
readonly ORANGE="<span color='#FFA500'>"
readonly RED="<span color='#FF0000'>"
readonly RESET="</span>"

# Set color based on CPU percentage
if [[ ${CPU_PERCENTAGE} -lt 30 ]]; then
    INFO="<txt>"
	INFO+="  CPU  ${CPU_PERCENTAGE}%  "
	INFO+="</txt>"
else
	if [[ ${CPU_PERCENTAGE} -lt 50 ]]; then
    COLOR=${YELLOW}
	elif [[ ${CPU_PERCENTAGE} -lt 70 ]]; then
    COLOR=${ORANGE}
	else
    COLOR=${RED}
	fi
	INFO="<txt>"
	INFO+="  ${COLOR}CPU  ${CPU_PERCENTAGE}%${RESET}  "
	INFO+="</txt>"
fi



# Panel Print
echo -e "${INFO}"
