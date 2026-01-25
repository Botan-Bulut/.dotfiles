#!/usr/bin/env bash
readonly CPU_PERCENTAGE=$(top -b -n1 | grep "%Cpu" | awk '{sum=(100 - $8)} END {print int(sum)}')
readonly CPU_TEMP=$(sensors | awk '/CPU:/ {gsub(/\+|°C/,"",$2); print $2}')
INFO="<txt>"
INFO+=" CPU  ${CPU_PERCENTAGE}% - ${CPU_TEMP}°C"
INFO+="</txt>"
echo -e "${INFO}"
