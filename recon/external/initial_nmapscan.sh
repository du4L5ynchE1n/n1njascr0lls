#!/bin/bash

# Check if targets.txt is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <targets.txt>"
  exit 1
fi

TARGETS_FILE="$1"

# Run the first nmap command
sudo nmap -Pn -T4 -sV -iL "$TARGETS_FILE" -oN sS.txt --open -vvv

# Run the second nmap command
sudo nmap -Pn -sU -sV --version-intensity 0 -F -n -iL "$TARGETS_FILE" --open -vvv

# Run the third nmap command
sudo nmap -Pn -T4 -sV -p- -iL "$TARGETS_FILE" -oN sSall.txt --open -vvv

echo "Output written to sS.txt, sU.txt, and sSall.txt"
