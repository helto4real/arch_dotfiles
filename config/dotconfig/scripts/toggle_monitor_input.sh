#!/bin/bash

# Specify your two input codes here (bare lowercase hex, without x or 0x prefix)
INPUT1="0f" # e.g., DisplayPort
INPUT2="12" # e.g., HDMI-2

# Get current input (add --bus <n> if needed for multi-monitor)
CURRENT=$(ddcutil getvcp 0x60 --brief | awk '{print $4}' | sed 's/^0x//; s/^x//' | tr '[:upper:]' '[:lower:]')

if [ "$CURRENT" = "$INPUT1" ]; then
  ddcutil setvcp 0x60 0x$INPUT2
else
  ddcutil setvcp 0x60 0x$INPUT1
fi
