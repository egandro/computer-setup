#!/bin/bash
set -x

if [ -z "$CFG_HOSTNAME" ]
then
  echo "setup the CFG_HOSTNAME"
  exit
fi

if [ -z "$CFG_USER" ]
then
  echo "setup the CFG_USER"
  exit
fi

if [ -z "$CFG_PASSWORD" ]
then
  echo "setup the CFG_PASSWORD"
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
