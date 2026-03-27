#!/bin/sh

# RADIO RECEIVER SCRIPT
# This is a script to start the radio receiver program on startup.
# Systemd will execute any commands in this script after the system boots.

python3 Cloudjumper-Sensors/main.py > test_output.txt