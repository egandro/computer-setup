#!/bin/bash
set -x

if [ -z "${CFG_HOSTNAME}" ]
then
  echo "setup the CFG_HOSTNAME"
  exit
fi

if [ -z "${CFG_USER}" ]
then
  echo "setup the CFG_USER"
  exit
fi

if [ -z "${CFG_PASSWORD}" ]
then
  echo "setup the CFG_PASSWORD"
  exit
fi

if [ -z "${CFG_WORLD_DEV}" ]
then
  echo "setup the CFG_WORLD_DEV e.g. eth0"
  exit
fi

if [ -z "${CFG_IP_PREFIX}" ]
then
  echo "setup the CFG_IP_PREFIX"
  echo "192.168.1.XXX < without the.XXX"
  exit
fi

if [ -z "${CFG_IP_ROUTER_POSTFIX}" ]
then
  echo "setup the CFG_IP_ROUTER_POSTFIX"
  echo "192.168.1.XXX < router XXX e.g. 1"
  exit
fi

if [ -z "${CFG_AP_SID}" ]
then
  echo "setup the CFG_AP_SID"
  echo "e.g. WLANrouter
  exit
fi

if [ -z "${CFG_AP_PASS}" ]
then
  echo "setup the CFG_AP_PASS"
  echo "e.g. testtest"
  exit
fi

# create user
echo -e "$CFG_PASSWORD\n$CFG_PASSWORD" adduser $CFG_USER 
usermod -a -G sudo $CFG_USER
usermod -a -G docker $CFG_USER || echo ""

# hostname
echo "${CFG_HOSTNAME}" > /etc/hostname
sed -i 's/raspberrypi/'${CFG_HOSTNAME}/'' /etc/hosts
hostname ${CFG_HOSTNAME}

#samba
DEBIAN_FRONTEND=noninteractive apt-get install -y samba samba-common smbclient

# dummy
mkdir -p /home/shares/users
chown root:users /home/shares/users/
chmod 770 /home/shares/users/

mv /etc/samba/smb.conf /etc/samba/smb.conf.orig

cat <<EOF > /etc/samba/smb.conf
# idea from https://www.elektronik-kompendium.de/sites/raspberry-pi/2007071.htm
[global]
workgroup = WORKGROUP
security = user
encrypt passwords = yes
client min protocol = SMB2
client max protocol = SMB3

[data]
comment = data
# dummy
path = /home/shares/users
read only = no
# create mask = 0644
# directory mask = 0755
# force user = shareuser
EOF

service smbd restart
service nmbd restart

echo -ne "$CFG_PASSWORD\n$CFG_PASSWORD\n" | smbpasswd -a -s $CFG_USER


#
# access point
# idea:  https://www.elektronik-kompendium.de/sites/raspberry-pi/2002171.htm


apt install -y dnsmasq hostapd

cat <<EOF >> /etc/dhcpcd.conf
interface wlan0
static ip_address=${CFG_IP_PREFIX}.${CFG_IP_ROUTER_POSTFIX}/24
nohook wpa_supplicant
EOF

mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig

cat <<EOF >> /etc/dnsmasq.conf
interface=wlan0
no-dhcp-interface=${CFG_WORLD_DEV}
dhcp-range=${CFG_IP_PREFIX}.150,${CFG_IP_PREFIX}.200,255.255.255.0,24h
dhcp-option=option:dns-server,${CFG_IP_PREFIX}.100
# dhcp-host=aa:bb:cc:dd:ee:ff,PS4,${CFG_IP_PREFIX}.20
EOF

cat <<EOF >  /etc/hostapd/hostapd.conf
interface=wlan0
#driver=nl80211

channel=10
hw_mode=g
ieee80211n=1
ieee80211d=1
country_code=DE
wmm_enabled=1

auth_algs=1
wpa=2
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP
ssid=${CFG_AP_SID}
wpa_passphrase=${CFG_AP_PASS}
EOF

chmod 600 /etc/hostapd/hostapd.conf

cat <<EOF > /etc/default/hostapd
RUN_DAEMON=yes
DAEMON_CONF="/etc/hostapd/hostapd.conf"
EOF

systemctl unmask hostapd
systemctl enable hostapd

cat <<EOF > /etc/sysctl.conf
net.ipv4.ip_forward=1
EOF

iptables -t nat -A POSTROUTING -o ${CFG_WORLD_DEV} -j MASQUERADE

sh -c "iptables-save > /etc/iptables.ipv4.nat"

sed -i 's/exit 0//' /etc/rc.local

cat <<EOF >> /etc/rc.local
iptables-restore < /etc/iptables.ipv4.nat
exit 0
EOF


