#!/bin/bash
# Bash script to setup basic configs of HF 2013 VMs

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Not running as root."
    exit
fi

TEXT_COLOR="[38;05;105m"
DEFAULT_COLOR="[38;05;015m"

# Install VMWare TOols
echo $TEXT_COLOR''Installing VMWare tools''$DEFAULT_COLOR
./sh/installTools.sh

# Install some packages
echo $TEXT_COLOR''Installing some packages''$DEFAULT_COLOR
./sh/installPackages.sh

# Generate a new SSH Key for the server
echo $TEXT_COLOR''Generating new ssh keys''$DEFAULT_COLOR
/usr/bin/ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
/usr/bin/ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa

# Set timezone
echo $TEXT_COLOR''Setting up timezone \(Etc/UTC\)''$DEFAULT_COLOR
echo 'Etc/UTC' > /etc/timezone
/bin/mv /etc/timezone /etc/timezone.dist
/bin/ln -s /usr/share/zoneinfo/Etc/UTC /etc/timezone

# Set authorized_keys
if [ ! -d ~/.ssh ]
then
	echo $TEXT_COLOR''.ssh folder doesn\' exist, creating.''$DEFAULT_COLOR
	/bin/mkdir ~/.ssh
fi
echo $TEXT_COLOR''Setting up authorized_keys''$DEFAULT_COLOR
/bin/cat files/ssh-keys/martin.pub > ~/.ssh/authorized_keys
/bin/cat files/ssh-keys/scoreboard-mon.pub >> ~/.ssh/authorized_keys

# Set default motd
echo $TEXT_COLOR''Disabling uname in /etc/init.d/motd''$DEFAULT_COLOR
FIND='uname -snrvm > \/var\/run\/motd\.dynamic'
REPLACE='#uname -snrvm > \/var\/run\/motd\.dynamic'
/bin/sed -i -e "s/$FIND/$REPLACE/" /etc/init.d/motd

echo $TEXT_COLOR''Updating motd file''$DEFAULT_COLOR
/bin/cp files/motd/motd.tbd /etc/motd

# Add HF CA certificate
#echo $TEXT_COLOR''Adding up HF CA certificate''$DEFAULT_COLOR
#/bin/mkdir /usr/share/ca-certificates/infra.hf
#/bin/cp files/HFCA.pem /usr/share/ca-certificates/infra.hf/HFCA.crt
#/usr/sbin/dpkg-reconfigure ca-certificates

# Delete hackfest user
echo $TEXT_COLOR''Deleting hackfest user''$DEFAULT_COLOR
/usr/sbin/deluser hackfest

