#!/bin/bash
. ./functions-deb64.sh

#
# MAIN
#

initSSHChrootEnv

# Chal 1: Make some rop
CHAL_NAME='pwn01'
CHAL_USER='pwn01'
CHAL_PASS='pwn01'
CHAL_SHELL='/bin/bash'
CHAL_FLAG='AzTxYDhq5oK0wRStvmuE1ChAEdJWwMO2'
cat /etc/passwd | grep $CHAL_USER > /dev/null
if [ $? -eq 1 ]; then
    sgid='pwn01s'
    chrDir=$SSH_FOLDER'/'$CHAL_USER
    exePath='pwn01/exe'
    flagPath=$chrDir'/home/'$CHAL_USER'/flag.txt'

    createSSHChroot "$CHAL_NAME" "$CHAL_USER" "$CHAL_PASS" "$CHAL_SHELL"

    echo Copying chroot into binaries
    cmds=(/bin/ls /bin/rm /bin/mkdir /bin/cp /bin/mv \
            /bin/echo /bin/cat /bin/ps /usr/bin/python2.7 \
            /usr/bin/strace /usr/bin/gdb /usr/bin/objdump \
            /usr/bin/gcc /usr/bin/id)
    
    for c in ${cmds[@]}
    do
        addBinaryToChroot $c $chrDir $CHAL_USER
    done
    addPython27ToChroot $chrDir $CHAL_USER

    addSecuredTmp $chrDir $CHAL_USER
    addPS1 $chrDir $CHAL_USER
    fixNameResolution $chrDir $CHAL_USER
    grep "$sgid:" /etc/passwd >> $chrootDir'/etc/passwd'
    grep "$sgid:" /etc/group >> $chrootDir'/etc/group'

    /bin/echo Creating setgid group $sgid
    /usr/sbin/useradd $sgid
    /bin/mkdir $chrDir'/home/'$sgid
    /bin/chown root:$sgid $chrDir'/home/'$sgid
    /bin/chmod 770 $chrDir'/home/'$sgid

    /bin/echo Copy exe
    /bin/cp $exePath $chrDir'/home/'$CHAL_USER'/exe'
    /bin/echo Set exe with guid
    /bin/chown root:$sgid $chrDir'/home/'$CHAL_USER'/exe'
    /bin/chmod 755 $chrDir'/home/'$CHAL_USER'/exe'
    /bin/chmod g+s $chrDir'/home/'$CHAL_USER'/exe'

    /bin/echo Creating flag
    /bin/echo $CHAL_FLAG > $flagPath
    /bin/chown root:$sgid $flagPath
    /bin/chmod 640 $flagPath

fi

