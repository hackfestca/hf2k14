#!/bin/ksh

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Not running as root."
    exit
fi

if [ ! -d /etc/nginx/conf.d ]
then
    mkdir /etc/nginx/conf.d
fi

# Generate and append PS1 to .profile
echo $TEXT_COLOR''Generating a PS1 with ./sh/genPS1.sh''$DEFAULT_COLOR
ps1="`./sh/genPS1.sh -z $ZONE -o $OWNER`"
if [[ -z "`grep PS1 ~/.profile`" ]];then
    echo "PS1=\"$ps1\"" >> ~/.profile
else
    mv ~/.profile ~/.profile.tmp
    sed -e "s/^PS1\(.*\)$/PS1=\"$ps1\"/" ~/.profile.tmp > ~/.profile
    #rm ~/.profile.tmp
fi

mkdir /var/log/nxing
