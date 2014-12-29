#!/bin/bash
# Bash script to customize HF 2013 VMs

TEXT_COLOR="[38;05;105m"
DEFAULT_COLOR="[38;05;015m"
ZONE_LIST=('MGMT' 'PUBLIC' 'CHALS')
OWNER_LIST=('HF')

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Not running as root."
    exit
fi

usage()
{
    echo "Customize a HF 2013 VM"
    echo " "
    echo "$0 -h HOST -d DOMAIN -i IP -n NETMASK -g GATEWAY -z ZONE -o OWNER"
    echo " "
    echo "options:"
    echo "--help                    show brief help"
    echo "-h, --hostname=HOSTNAME   Hostname of the VM (ex: nagios, irc, banane)"
    echo "-d, --domain=DOMAIN       Domain name of the VM (ex: hf, infra.hf, etc.)"
    echo "-i, --ip=IP               IP Address of eth0 (ex: 172.16.66.X, 1.3.3.X, etc.)"
    echo "-n, --netmask=NETMASK     Netmask of eth0 (ex: 255.255.255.0, 255.255.255.240)"
    echo "-g, --gateway=GATEWAY     Gateway of eth0 (ex: 172.16.66.1, 1.3.3.1, etc.)"
    echo "-z, --zone=ACTION         specify a zone (MGMT, PUBLIC, CHALS)"
    echo "-o, --owner=OWNER         specify an owner (HF)"
    echo ""
}

containsElement () {
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

# Menu, arguments, help
while test $# -gt 0; do
        case "$1" in
                --help)
			usage
                        exit 0
                        ;;
                -h)
                        shift
                        if test $# -gt 0; then
                                export HOST=$1
                        else
                                echo "no hostname specified"
                                exit 1
                        fi
                        shift
                        ;;
                --hostname*)
                        export HOST=`echo $1 | sed -e 's/^[^=]*=//g'`
                        shift
                        ;;
                -d)
                        shift
                        if test $# -gt 0; then
                                export DOMAIN=$1
                        else
                                echo "no domain specified"
                                exit 1
                        fi
                        shift
                        ;;
                --domain*)
                        export DOMAIN=`echo $1 | sed -e 's/^[^=]*=//g'`
                        shift
                        ;;
                -i)
                        shift
                        if test $# -gt 0; then
                                export IP=$1
                        else
                                echo "no ip address specified"
                                exit 1
                        fi
                        shift
                        ;;
                --ip*)
                        export IP=`echo $1 | sed -e 's/^[^=]*=//g'`
                        shift
                        ;;
                -n)
                        shift
                        if test $# -gt 0; then
                                export NETMASK=$1
                        else
                                echo "no netmask specified"
                                exit 1
                        fi
                        shift
                        ;;
                --netmask*)
                        export NETMASK=`echo $1 | sed -e 's/^[^=]*=//g'`
                        shift
                        ;;
                -g)
                        shift
                        if test $# -gt 0; then
                                export GATEWAY=$1
                        else
                                echo "no gateway specified"
                                exit 1
                        fi
                        shift
                        ;;
                --gateway*)
                        export GATEWAY=`echo $1 | sed -e 's/^[^=]*=//g'`
                        shift
                        ;;
                -z)
                        shift
                        if test $# -gt 0; then
                                export ZONE=$1
                        else
                                echo "no zone specified"
                                exit 1
                        fi
                        shift
                        ;;
                --zone*)
                        export ZONE=`echo $1 | sed -e 's/^[^=]*=//g'`
                        shift
                        ;;
                -o)
                        shift
                        if test $# -gt 0; then
                                export OWNER=$1
                        else
                                echo "no owner specified"
                                exit 1
                        fi
                        shift
                        ;;
                --owner*)
                        export OWNER=`echo $1 | sed -e 's/^[^=]*=//g'`
                        shift
                        ;;
                *)
                        #if test $# -gt 0; then
                        #        export OUT_FILE=$1
                        #else
                        #        echo "no file specified"
                        #        exit 1
                        #fi
                        break
                        ;;
        esac
done

# Some validations
if [ -z $HOST ] || [ -z $DOMAIN ] || [ -z $IP ] || [ -z $NETMASK ] || [ -z $GATEWAY ] || [ -z $ZONE ] || [ -z $OWNER ]
then
	usage
	echo There are missing arguments
	exit 1
fi

containsElement "$ZONE" "${ZONE_LIST[@]}"
if [ $? -eq 1 ]
then
	usage
	echo Invalid Zone. Please use one of the following: "${ZONE_LIST[@]}"
	exit 1
fi

containsElement "$OWNER" "${OWNER_LIST[@]}"
if [ $? -eq 1 ]
then
	usage
	echo Invalid Owner. Please use one of the following: "${OWNER_LIST[@]}"
	exit 1
fi

# Configure /etc/hostname 
echo $TEXT_COLOR''Setting up /etc/hostname''$DEFAULT_COLOR
echo $HOST > /etc/hostname
hostname -F /etc/hostname

# Configure /etc/hosts
echo $TEXT_COLOR''Setting up /etc/hosts''$DEFAULT_COLOR
sed -i -e "s/^127.0.1.1\(.*\)$/127.0.1.1 $HOST.$DOMAIN $HOST/" /etc/hosts
echo "$IP machine.local" >> /etc/hosts

# Configure MOTD
echo $TEXT_COLOR''Setting up /etc/motd''$DEFAULT_COLOR
./sh/genMotdHeader.sh -t "HF 2014" files/motd/motd.header
./sh/genMotd.sh -z $ZONE -o $OWNER "files/$HOST.motd"
/bin/cp "files/$HOST.motd" /etc/motd

# Configure a new .vimrc
echo $TEXT_COLOR''Setting up ~/.bashrc''$DEFAULT_COLOR
/bin/cp "files/.vimrc" ~/.vimrc

# Generate PS1
echo $TEXT_COLOR''Generating a PS1 with ./sh/genPS1.sh''$DEFAULT_COLOR
ps1=`./sh/genPS1.sh -z $ZONE -o $OWNER`

# Configure bashrc with new PS1
echo $TEXT_COLOR''Setting up ~/.bashrc''$DEFAULT_COLOR
/bin/cp "files/.bashrc" ~/.bashrc
FIND='PS1\=\"TPL_SHELL\"'
REPLACE="PS1\=\"$ps1\""
sed -i -e "s/$FIND/$REPLACE/" ~/.bashrc

# Configure /etc/network/interfaces
echo $TEXT_COLOR''Setting up /etc/network/interfaces''$DEFAULT_COLOR
cat > /etc/network/interfaces <<EOF
# Hackfest 2013
auto lo
iface lo inet loopback

###### MAIN INTERFACE ######
auto eth0
iface eth0 inet static
        address $IP
        netmask $NETMASK
        gateway $GATEWAY

#auto eth1
#iface eth1 inet static
#        address __________
#        netmask __________
#        gateway __________
#############################

EOF

# Configure /etc/network/interfaces
echo $TEXT_COLOR''Setting up /etc/resolv.conf''$DEFAULT_COLOR
cat > /etc/resolv.conf <<EOF
domain $DOMAIN
search $DOMAIN
nameserver 172.28.71.21
nameserver 172.28.71.22
options rotate
EOF

# Configure /etc/network/interfaces
echo $TEXT_COLOR''Restarting networking service''$DEFAULT_COLOR
/etc/init.d/networking restart

