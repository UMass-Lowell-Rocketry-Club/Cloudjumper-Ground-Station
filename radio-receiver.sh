#!/bin/sh

# RADIO RECEIVER SCRIPT
# This is a script to start the radio receiver program on startup.
# Systemd will execute any commands in this script after the system boots.

cd /home/rocketry/Cloudjumper-Sensors
./start_radio.sh >> radio_transmission.log