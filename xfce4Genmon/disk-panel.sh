#!/usr/bin/env bash

# Get used and total disk space for the specified partition
USED=$(df -H | grep '/dev/nvme0n1p2' | awk '{print $3}')
TOTAL=$(df -H | grep '/dev/nvme0n1p2' | awk '{print $2}')

# Panel
INFO="<txt>  DISK $USED / $TOTAL  </txt>"

# Panel Print
echo -e "${INFO}"
