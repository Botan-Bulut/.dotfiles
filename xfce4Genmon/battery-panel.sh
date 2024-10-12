#!/usr/bin/env bash
# Dependencies: acpi, bash>=3.2, coreutils, file, gawk, grep, xfce4-power-manager
readonly BATTERY=$(awk '{print $1}' /sys/class/power_supply/BAT*/capacity)

# Panel
INFO+="<txt>"
if acpi -a | grep -i "off-line" &> /dev/null; then # if AC adapter is offline
  if [ "${BATTERY}" -lt 21 ]; then # if battery is less than 20%
    	INFO+="<span weight='Bold' fgcolor='Red'>" # make the text bold red
  
  
  elif [ "${BATTERY}" -lt 31 ]; then # if battery is less than 30%
	
	INFO+="<span weight='Medium' fgcolor='#FFA500'>" # make the text bold yellow

  elif [ "${BATTERY}" -lt 41 ]; then # if battery is less than 40%
	INFO+="<span weight='Medium' fgcolor='Yellow'>" # make the text bold yellow
  else
    INFO+="<span>" # make the text white
  fi
elif acpi -a | grep -i "on-line" &> /dev/null; then # if AC adapter is online
  INFO+="<span weight='Medium' fgcolor='#00FF00'>" # make the text bold light green
else # if battery is in unknown state (no battery at all, throttling, etc.)
  INFO+="<span weight='Regular' fgcolor='Yellow'>" # make the text bold yellow
fi

INFO+="  BAT  ${BATTERY}%  "
INFO+="</span>"
INFO+="</txt>"

echo -e "${INFO}"

BATTERY_INFO=$(acpi)

# Tooltip
MORE="<tool>"
MORE+="${BATTERY_INFO}"
MORE+="</tool>"

# Print tooltip
echo -e "${MORE}"
