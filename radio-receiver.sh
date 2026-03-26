#!/bin/sh

# RADIO RECEIVER SCRIPT
# This is a script to start the radio receiver program on startup.
# Systemd will execute any commands in this script after the system boots.

ping google.com > /home/rocketry/ping-test
