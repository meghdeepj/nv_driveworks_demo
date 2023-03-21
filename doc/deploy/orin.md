# deploy on orin

```sh
sudo dmesg -C
sudo dmesg

sudo ifconfig mgbe1_0 192.168.137.113 netmask 255.255.255.0

cd ./zhensheng/arm-dev/vscode
sudo dpkg -i ./netplan.io_0.104-0ubuntu2_20.04.2_arm64.deb \
libnetplan0_0.104-0ubuntu2_20.04.2_arm64.deb python3-netifaces_0.10.4-1ubuntu4_arm64.deb nano_4.8-1ubuntu1_arm64.deb
sudo nano /etc/netplan/01-network-mgbe1_0.yaml

# edited by zhensheng

network:
  version: 2
  renderer: networkd
  ethernets:
    mgbe1_0:
      dhcp4: no
      dhcp6: no
      addresses: [192.168.137.113/24]
        # 10.10.11.112/24
      gateway4: 192.168.137.1
      nameservers:
        addresses: [168.168.3.1,168.168.3.2,168.168.1.75]

sudo netplan apply

sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
sudo sed -i 's/ports.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list
sudo sed -i 's/mirrors.tuna.tsinghua.edu.cn/mirrors.ustc.edu.cn/' /etc/apt/sources.list

sudo sed -i 's/mirrors.ustc.edu.cn/ports.ubuntu.com/' /etc/apt/sources.list

sudo apt install ntp
sudo service ntp restart
date
```
