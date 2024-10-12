#!/usr/bin/env bash

# Get used and total disk space for the specified partition
USED=$(df / -H  | awk 'NR==2 {print $3}')
TOTAL=$(df / -H | awk 'NR==2 {print $2}')

# Panel
INFO="<txt> DISK $USED/$TOTAL </txt>"

# Panel Print
echo -e "${INFO}"
