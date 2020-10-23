# Reference articles
# https://ardupilot.org/dev/docs/making-a-mavlink-wifi-bridge-using-the-raspberry-pi.html
# https://www.raspberrypi.org/documentation/configuration/wireless/access-point-routed.md

# Update system files
sudo apt-get update

# Install Python and MavProxy
sudo apt-get install python-pip python-dev libxml2-dev libxslt-dev
sudo pip install MAVProxy

# Install networking files
sudo apt install hostapd
sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo apt install dnsmasq

sudo DEBIAN_FRONTEND=noninteractive apt install -y netfilter-persistent iptables-persistent

# Define the wireless interface IP configuration
DHCPCD_CONF="/etc/dhcpcd.conf"
sudo echo "interface wlan0" >> $DHCPCD_CONF
sudo echo "    static ip_address=192.168.4.1/24" >> $DHCPCD_CONF
sudo echo "    nohook wpa_supplicant" >> $DHCPCD_CONF

# Create the dnsmasq config file
DNSMASQ_CONF="/etc/dnsmasq.conf"
sudo echo "interface=wlan0" >> $DNSMASQ_CONF
sudo echo "dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h" >> $DNSMASQ_CONF
sudo echo "domain=wlan" >> $DNSMASQ_CONF
sudo echo "address=/gw.wlan/192.168.4.1" >> $DNSMASQ_CONF

# Make sure wifi is not blocked 
sudo rfkill unblock wlan

# Create the hostapd config file
HOSTAPD_CONF="/etc/hostapd/hostapd.conf"
sudo echo "country_code=US" >> $HOSTAPD_CONF
sudo echo "interface=wlan0" >> $HOSTAPD_CONF
sudo echo "ssid=rad-bridge" >> $HOSTAPD_CONF
sudo echo "hw_mode=g" >> $HOSTAPD_CONF
sudo echo "channel=7" >> $HOSTAPD_CONF
sudo echo "macaddr_acl=0" >> $HOSTAPD_CONF
sudo echo "auth_algs=1" >> $HOSTAPD_CONF
sudo echo "ignore_broadcast_ssid=0" >> $HOSTAPD_CONF
sudo echo "wpa=2" >> $HOSTAPD_CONF
sudo sudo echo "wpa_passphrase=testing123" >> $HOSTAPD_CONF
sudo echo "wpa_key_mgmt=WPA-PSK" >> $HOSTAPD_CONF
sudo echo "wpa_pairwise=TKIP" >> $HOSTAPD_CONF
sudo echo "rsn_pairwise=CCMP" >> $HOSTAPD_CONF

# Enable SSH so we can get in after reboot
sudo systemctl enable ssh
sudo systemctl start ssh

# Reboot
# sudo reboot