# https://ikarus.sg/using-zram-to-get-more-out-of-your-raspberry-pi/

sudo apt-get install zram-tools
sudo /bin/bash -c 'echo "PERCENT=50" >> /etc/default/zramswap'
sudo systemctl restart zramswap.service

