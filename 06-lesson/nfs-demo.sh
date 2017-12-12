# How to Share Files Using NFS: Linux Server Training 101
# https://www.youtube.com/watch?v=c3dL0ULEH-s

# 1) install these commands
sudo apt-get install nfs-kernel-server nfs-common rpcbind -y

# 2) start the daemon
sudo /etc/init.d/rpcbind restart

# 3) 
sudo echo "iface enp0s3 inte dhcp" | tee -a /etc/network/interfaces
sudo echo "address 191.168.1.1" | tee -a /etc/network/interfaces
sudo echo "netmask 255.255.255.0" | tee -a /etc/network/interfaces


sudo /etc/init.d/nfs-kernel-server restart

showmount -e
sudo apt-get update
# if error occures and that file is locked with this message (/var/lib/dpkg), is another process using it?
sudo rm /var/lib/apt/lists/lock

sudo apt-get install rpcbind nfs-common -y


sudo iptables -A INPUT -s 192.168.0.0/16 -p tcp -m multiport --ports 111,2000,2001,2049,37611,37328 -j ACCEPT
sudo iptables -A INPUT -s 192.168.0.0/16 -p udp -m multiport --ports 111,2000,2002,2049,37611,37328 -j ACCEPT


# How to get NFS working with Ubuntu-CE-Firewall
# https://wiki.ubuntu.com/How%20to%20get%20NFS%20working%20with%20Ubuntu-CE-Firewall


sudo mount -t nfs -o proto=tcp,port=2049 -v 192.168.99.101:/opt/data /mnt/opt/data


