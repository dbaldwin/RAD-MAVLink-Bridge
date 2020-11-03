# RAD-MAVLink-Bridge
MAVLink Wifi Bridge for Raspberry Pi with Built-in Wifi

* Must have built-in Wifi (will add support for USB wifi later)
* Make sure to get IP address before reboot and hopefully your router keeps that same IP
* Make sure to run with sudo! This is important!

This script has been tested on the following models:

* Raspberry Pi 3 Model B+
* Raspberry Pi 4 Model B

Please consider testing with different versions of Pi and let us know if you run into any issues.

***

## Reference Links
This script takes bits and pieces from the following articles to offer the simplest path to get up and running. If you'd like to learn more about what's going on in the ssetup script be sure to check out these links:

* https://ardupilot.org/dev/docs/making-a-mavlink-wifi-bridge-using-the-raspberry-pi.html
* https://www.raspberrypi.org/documentation/configuration/wireless/access-point-routed.md

***

## Installing
Fire up your KVM or shell into Pi and run:
* wget "https://raw.githubusercontent.com/dbaldwin/RAD-MAVLink-Bridge/main/setup.sh"
* chmod a+x setup.sh
* sudo ./setup.sh
* Be sure to plug in your telemetry radio when rebooting

***

## Configuration
* After reboot connect to rad-bridge wifi
* Configure QGC or Mission Planner
* IP of Pi will be 192.168.4.1



