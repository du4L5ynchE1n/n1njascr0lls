# Port scan and vulnscan without touching targets (via Shodan)
#!/bin/bash

# Check if targets.txt is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <targets.txt>"
  exit 1
fi

TARGETS_FILE="$1"

# Run the nrich command
nrich "$TARGETS_FILE" > nrich.txt

# Run the smap command
~/t00ls/n3t/smap/smap_0.1.12_linux_amd64/smap -iL "$TARGETS_FILE" -oS smap.txt

echo "Output written to nrich.txt and smap.txt"
