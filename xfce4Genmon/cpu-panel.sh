#!/usr/bin/env bash
readonly CPU_PERCENTAGE=$(top -b -n1 | grep "%Cpu" | awk '{sum=(100 - $8)} END {print int(sum)}')
INFO="<txt>"
INFO+=" CPU  ${CPU_PERCENTAGE}% "
INFO+="</txt>"
echo -e "${INFO}"

