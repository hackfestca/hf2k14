#!/bin/bash

#
# VARS
#
TPL_FOLDER='./files'
SSH_FOLDER='/home'
SSH_GROUP='_ssh'

#
# FUNCTIONS
#

# This should be run only once per server.
initSSHChrootEnv(){
    # Create ssh group if not exist
    cat /etc/group | grep $SSH_GROUP > /dev/null
    if [ $? -eq 1 ]; then
        /usr/sbin/groupadd $SSH_GROUP
    fi
    
    # Setup SSH to chroot ssh group
    echo Force ssh group to be chrooted
    if [[ -z "`grep "Match Group $SSH_GROUP" /etc/ssh/sshd_config`" ]];then
        echo '# Chroot setup for games' >> /etc/ssh/sshd_config
        echo "Match Group $SSH_GROUP" >> /etc/ssh/sshd_config
        echo '    ChrootDirectory %h' >> /etc/ssh/sshd_config
        echo '    X11Forwarding no' >> /etc/ssh/sshd_config
        echo '    AllowTcpForwarding no' >> /etc/ssh/sshd_config
        /etc/init.d/ssh restart
    fi
}

createSSHChroot(){
    name=$1
    user=$2
    pass=$3
    shell=$4

    cat /etc/passwd | grep $user > /dev/null
    if [ $? -eq 0 ]; then
        /bin/echo Not creating $name because user already exist
        return 0
    fi

    /bin/echo Creating ssh chroot for user $user
    /bin/mkdir $SSH_FOLDER'/'$user

    /bin/echo Creating user $user
    p=$(echo $pass | openssl passwd -1 -stdin)
    /usr/sbin/useradd -d $SSH_FOLDER'/'$user -s $shell -p $p --create-home --user-group $user
    /usr/sbin/adduser $user $SSH_GROUP
    
    /bin/echo Creating core folders
    mkdir -p $SSH_FOLDER'/'$user'/'{bin,dev,etc,lib,lib/x86_64-linux-gnu,lib64,usr,usr/lib,usr/include,usr/local/lib}
    /bin/chown -R root:root $SSH_FOLDER'/'$user
    /bin/chmod -R 550 $SSH_FOLDER'/'$user
   
    /bin/echo Creating some devices 
    mknod -m 666 $SSH_FOLDER'/'$user'/dev/null' c 1 3

    /bin/echo Copying some files
    cd $SSH_FOLDER'/'$user'/etc'
    /bin/cp /etc/ld.so.cache .
    /bin/cp /etc/ld.so.conf .
    /bin/cp /etc/nsswitch.conf .
    /bin/cp /etc/hosts .
    /bin/cp /etc/resolv.conf .
    cd - > /dev/null

    /bin/echo Setting ACLs on folders and files
    /bin/chown -R root:root $SSH_FOLDER'/'$user
    /usr/bin/find $SSH_FOLDER'/'$user -type d -exec /bin/chmod 755 {} \;
    /usr/bin/find $SSH_FOLDER'/'$user -type f -exec /bin/chmod 644 {} \;

    /bin/echo Creating home folder
    /bin/mkdir -p $SSH_FOLDER'/'$user'/home/'$user
    /bin/chown root:$user $SSH_FOLDER'/'$user'/home/'$user
    /usr/bin/find $SSH_FOLDER'/'$user'/home/'$user -type d -exec /bin/chmod 750 {} \;
    /usr/bin/find $SSH_FOLDER'/'$user'/home/'$user -type f -exec /bin/chmod 640 {} \;

    /bin/echo Copying /bin/sh as it\'s needed for many shit.
    addBinaryToChroot '/bin/sh' $SSH_FOLDER'/'$user $user

    /bin/echo Copying a statically-linked shell: $shell
    addBinaryToChroot $shell $SSH_FOLDER'/'$user $user

    /bin/echo Copying special lib for bash
    cp '/lib64/ld-linux-x86-64.so.2' $SSH_FOLDER'/'$user'/lib64/'
}


addBinaryToChroot(){
    binFile=$1
    chrootDir=$2
    user=$3
    
    /bin/echo Copying $binFile to chroot $chrootDir
    /bin/cp $binFile $chrootDir'/bin/'
    
    if [[ -z "`file $binFile | grep 'statically linked'`" ]];then
    	/bin/echo Copying dependencies
        cp `ldd $binFile | awk '{ print $3 }' |egrep -v ^'\('` $chrootDir/lib/
    fi

    /bin/chown -R root:root $chrootDir/lib
    /bin/chmod -R 755 $chrootDir/lib
}

addPython27ToChroot(){
    chrootDir=$1
    user=$2
    p27Dir='/usr/lib/python2.7'
    p27Dir2='/usr/local/lib/python2.7'
    p27Dir3='/usr/include/python2.7'

    /bin/cp -R $p27Dir $chrootDir''$p27Dir
    /bin/chown -R root:$user $chrootDir''$p27Dir
    /bin/chmod -R 550 $chrootDir''$p27Dir

    /bin/cp -R $p27Dir2 $chrootDir''$p27Dir2
    /bin/chown -R root:$user $chrootDir''$p27Dir2
    /bin/chmod -R 550 $chrootDir''$p27Dir2

    /bin/cp -R $p27Dir3 $chrootDir''$p27Dir3
    /bin/chown -R root:$user $chrootDir''$p27Dir3
    /bin/chmod -R 550 $chrootDir''$p27Dir3
}

addSecuredTmp(){
    chrootDir=$1
    user=$2

    /bin/echo Securing tmp folder so nobody can list content
    tmpDir=$chrootDir'/tmp'
    if [ ! -d $tmpDir ]; then
        /bin/mkdir $tmpDir
    fi

    /bin/chown root:root $tmpDir
    /bin/chmod 753 $tmpDir
}

addProc(){
    chrootDir=$1
    user=$2
    procDir=$chrootDir'/proc'

    if mount | grep $procDir > /dev/null; then
        /bin/echo /proc is already mounted in chroot. Unmounting
        umount $procDir
    fi

    /bin/echo Creating /proc
    if [ ! -d $procDir ]; then
        /bin/mkdir $procDir
    fi

    mount -o bind /proc $procDir
}

addPS1(){
    chrootDir=$1
    user=$2
    profilePath=$chrootDir'/home/'$user'/.profile'

    echo Generating a PS1 with genPS1.sh
    ps1=`../deb64-initscript/sh/genPS1.sh -z PUBLIC -o HF`

    if [ ! -f $profilePath ]; then
        touch $profilePath
    fi

    echo Adding PS1 var to .profile
    if [[ -z "`grep PS1 $profilePath`" ]];then
        echo 'PS1="'$ps1'"' >> $profilePath
    else
        sed -i -e "s/^PS1\(.*\)$/PS1=\"$ps1\"/" $profilePath
    fi
}

setUmask(){
    chrootDir=$1
    user=$2
    umaskValue=$3
    profilePath=$chrootDir'/home/'$user'/.profile'

    if [ ! -f $profilePath ]; then
        touch $profilePath
    fi

    echo Adding umask var to .bashrc
    if [[ -z "`grep umask $profilePath`" ]];then
        echo "umask $umaskValue" >> $profilePath
    else
        sed -i -e "s/^umask\(.*\)$/umask $umaskValue/" $profilePath
    fi
}

fixNameResolution(){
    chrootDir=$1
    user=$2

    echo Creating a custom passwd file
    grep 'root:' /etc/passwd > $chrootDir'/etc/passwd'
    grep "$user:" /etc/passwd >> $chrootDir'/etc/passwd'

    echo Creating a custom group file
    grep 'root:' /etc/group > $chrootDir'/etc/group'
    grep "$user:" /etc/group >> $chrootDir'/etc/group'

    echo Adding some libraries to resolve uid and gid
    cp -R '/lib/x86_64-linux-gnu/'* $chrootDir'/lib/x86_64-linux-gnu/'
}
