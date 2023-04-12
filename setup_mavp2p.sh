# Reference articles
# https://ardupilot.org/dev/docs/making-a-mavlink-wifi-bridge-using-the-raspberry-pi.html
# https://www.raspberrypi.org/documentation/configuration/wireless/access-point-routed.md

# Update system files
sudo apt update

# Install mavp2p
sudo wget "https://github.com/bluenviron/mavp2p/releases/download/v0.7.0/mavp2p_v0.7.0_linux_arm6.tar.gz"
sudo tar -zxvf mavp2p_v0.7.0_linux_arm6.tar.gz
sudo mv mavp2p /usr/local/bin

# Install networking files
sudo apt install hostapd
sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo apt install dnsmasq -y

sudo DEBIAN_FRONTEND=noninteractive apt install -y netfilter-persistent iptables-persistent

# Define the wireless interface IP configuration
DHCPCD_CONF="/etc/dhcpcd.conf"
echo "interface wlan0" | sudo tee -a $DHCPCD_CONF
echo "    static ip_address=192.168.4.1/24" | sudo tee -a $DHCPCD_CONF
echo "    nohook wpa_supplicant" | sudo tee -a $DHCPCD_CONF

# Create the dnsmasq config file
DNSMASQ_CONF="/etc/dnsmasq.conf"
sudo mv $DNSMASQ_CONF /etc/dnsmasq.conf.orig
sudo touch $DNSMASQ_CONF
echo "interface=wlan0" | sudo tee -a $DNSMASQ_CONF
echo "dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h" | sudo tee -a $DNSMASQ_CONF
echo "domain=wlan" | sudo tee -a $DNSMASQ_CONF
echo "address=/gw.wlan/192.168.4.1" | sudo tee -a $DNSMASQ_CONF

# Make sure wifi is not blocked 
sudo rfkill unblock wlan

# Create the hostapd config file
HOSTAPD_CONF="/etc/hostapd/hostapd.conf"
echo "country_code=US" | sudo tee -a $HOSTAPD_CONF
echo "interface=wlan0" | sudo tee -a $HOSTAPD_CONF
echo "ssid=rad-bridge" | sudo tee -a $HOSTAPD_CONF
echo "hw_mode=g" | sudo tee -a $HOSTAPD_CONF
echo "channel=7" | sudo tee -a $HOSTAPD_CONF
echo "macaddr_acl=0" | sudo tee -a $HOSTAPD_CONF
echo "auth_algs=1" | sudo tee -a $HOSTAPD_CONF
echo "ignore_broadcast_ssid=0" | sudo tee -a $HOSTAPD_CONF
echo "wpa=2" | sudo tee -a $HOSTAPD_CONF
echo "wpa_passphrase=testing123" | sudo tee -a >> $HOSTAPD_CONF
echo "wpa_key_mgmt=WPA-PSK" | sudo tee -a $HOSTAPD_CONF
echo "wpa_pairwise=TKIP" | sudo tee -a $HOSTAPD_CONF
echo "rsn_pairwise=CCMP" | sudo tee -a $HOSTAPD_CONF

# Enable SSH so we can get in after reboot
sudo systemctl enable ssh
sudo systemctl start ssh

# Setup mavproxy to autostart on boot
wget "https://github.com/dbaldwin/RAD-MAVLink-Bridge/blob/feature/mavp2p/mavp2pgateway"
sudo mv mavp2pgateway /etc/init.d/mavp2pgateway
cd /etc/init.d/
sudo chown root:root mavp2pgateway
sudo chmod 755 mavp2pgateway
sudo update-rc.d mavp2pgateway defaults

# Disable serial console
#sed 's/console=serial0,115200 //' /boot/cmdline.txt

# Enable uart for MAVLink communication
#echo "enable_uart=1" | sudo tee -a /boot/config.txt

# TODO: prompt before reboot

# Reboot
sudo reboot