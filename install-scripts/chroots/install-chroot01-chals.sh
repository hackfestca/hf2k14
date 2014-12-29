#!/bin/ksh

TPL_FOLDER='./phpchals-files'
NGINX_TPL_FOLDER=$TPL_FOLDER'/vhost-tpl'
NGINX_TPL_FILE=$TPL_FOLDER'/nginx.tpl.conf'
PHP_FPM_TPL_FILE=$TPL_FOLDER'/php-fpm.tpl.conf'
STATIC_FOLDER=$TPL_FOLDER'/static'
NGINX_CONFIG_FOLDER='/etc/nginx/conf.d'
NGINX_VHOST_FOLDER='/var/www/htdocs'
NGINX_STATIC_FOLDER=$NGINX_VHOST_FOLDER'/static'
PHP_FPM_FOLDER='/etc/php-fpm-pool.d'
NGINX_GROUP='www'

. ./functions-bsd64.sh
#
# MAIN
#
initChroot
initSSHChrootEnv
createStaticFolder

# Description: Hack c99.php shell to pop the flag.
CHAL_NAME='php01'
CHAL_USER='_www1'
CHAL_PHP_PORT='9000'
CHAL_DIS_FUNC='dl,exec,passthru,shell_exec,system,proc_open,popen,curl_exec,curl_multi_exec,parse_ini_file,show_source,include,include_once,require,require_once,file_get_contents,readfile,fopen,fread,fwrite,fsockopen,socket_create,stream_socket_client,stream_socket_server'
CHAL_FLAG='FLAG-ZYfynIT9LvpoiadmmeNAtIOC8v1EPZhJ'
/usr/sbin/userinfo $CHAL_USER > /dev/null
if [ $? -eq 1 ]; then
    chrDir=$NGINX_VHOST_FOLDER'/'$CHAL_NAME
    chalFile=$chrDir'/var/www/'$CHAL_NAME'.php'
    flagFile=$chrDir'/flag.txt'
    indexFile=$chrDir'/var/www/index.php'

    createNginxChroot $CHAL_NAME $CHAL_USER $CHAL_PHP_PORT $CHAL_DIS_FUNC

    /bin/cp $TPL_FOLDER'/c99.php' $chalFile
    /sbin/chown root:$CHAL_USER $chalFile
    /bin/chmod 440 $chalFile

    /bin/echo "$CHAL_FLAG" > $flagFile
    /sbin/chown root:$CHAL_USER $flagFile
    /bin/chmod 440 $flagFile

    /bin/cp $TPL_FOLDER'/index.'$CHAL_NAME'.php' $indexFile
    /sbin/chown root:$CHAL_USER $indexFile
    /bin/chmod 440 $indexFile

    /etc/rc.d/nginx restart
    /etc/rc.d/php_fpm restart
fi

# Description: Use include to pop the flag.
CHAL_NAME='php02'
CHAL_USER='_www2'
CHAL_PHP_PORT='9001'
CHAL_DIS_FUNC='dir,readdir,opendir,scandir,dl,exec,passthru,shell_exec,system,proc_open,popen,curl_exec,curl_multi_exec,parse_ini_file,show_source,include,require,require_once,file_get_contents,readfile,fopen,fread,fwrite,fsockopen,socket_create,stream_socket_client,stream_socket_server'
CHAL_FLAG='FLAG-SO3e6n7qpfGTtgGXcDLtLWuDzo3f0kfp'
/usr/sbin/userinfo $CHAL_USER > /dev/null
if [ $? -eq 1 ]; then
    chrDir=$NGINX_VHOST_FOLDER'/'$CHAL_NAME
    flagFile=$chrDir'/flag.txt'
    indexFile=$chrDir'/var/www/index.php'

    createNginxChroot $CHAL_NAME $CHAL_USER $CHAL_PHP_PORT $CHAL_DIS_FUNC

    /bin/echo "Flag: $CHAL_FLAG" > $flagFile
    /sbin/chown root:$CHAL_USER $flagFile
    /bin/chmod 440 $flagFile

    /bin/cp $TPL_FOLDER'/index.'$CHAL_NAME'.php' $indexFile
    /sbin/chown root:$CHAL_USER $indexFile
    /bin/chmod 440 $indexFile

    /etc/rc.d/nginx restart
    /etc/rc.d/php_fpm restart
fi

# Description: Use opendir, readdir, fopen and fgets to pop the flag.
CHAL_NAME='php03'
CHAL_USER='_www3'
CHAL_PHP_PORT='9002'
CHAL_DIS_FUNC='dir,scandir,dl,exec,passthru,shell_exec,system,proc_open,popen,curl_exec,curl_multi_exec,parse_ini_file,show_source,include,include_once,require,require_once,file_get_contents,readfile,fread,fwrite,fsockopen,socket_create,stream_socket_client,stream_socket_server'
CHAL_FLAG='FLAG-49DnMgcDQNiAaOcwMQGjfc22OrhrMrKK'
/usr/sbin/userinfo $CHAL_USER > /dev/null
if [ $? -eq 1 ]; then
    chrDir=$NGINX_VHOST_FOLDER'/'$CHAL_NAME
    flagFile=$chrDir'/nopzyoucantguessmemyfriend.txt'
    indexFile=$chrDir'/var/www/index.php'

    createNginxChroot $CHAL_NAME $CHAL_USER $CHAL_PHP_PORT $CHAL_DIS_FUNC

    /bin/echo "Flag: $CHAL_FLAG" > $flagFile
    /sbin/chown root:$CHAL_USER $flagFile
    /bin/chmod 440 $flagFile

    /bin/cp $TPL_FOLDER'/index.'$CHAL_NAME'.php' $indexFile
    /sbin/chown root:$CHAL_USER $indexFile
    /bin/chmod 440 $indexFile

    /etc/rc.d/nginx restart
    /etc/rc.d/php_fpm restart
fi

# Description: Use /bin/find to find and pop the flag
CHAL_NAME='php04'
CHAL_USER='_www4'
CHAL_PHP_PORT='9003'
CHAL_DIS_FUNC='eval,dir,scandir,opendir,readdir,dl,exec,passthru,system,proc_open,popen,curl_exec,curl_multi_exec,parse_ini_file,show_source,include,include_once,require,require_once,file_get_contents,readfile,fopen,fread,fwrite,fsockopen,socket_create,stream_socket_client,stream_socket_server'
CHAL_FLAG='FLAG-fmKqmp6JMWQ6bB2BCTfngSwb9ZGbT0MA'
/usr/sbin/userinfo $CHAL_USER > /dev/null
if [ $? -eq 1 ]; then
    chrDir=$NGINX_VHOST_FOLDER'/'$CHAL_NAME
    flagFolder=$chrDir'/thematrix'
    solutionFolder=$flagFolder'/22/72'
    flagFile=$solutionFolder'/flag.txt'
    indexFile=$chrDir'/var/www/index.php'

    createNginxChroot $CHAL_NAME $CHAL_USER $CHAL_PHP_PORT $CHAL_DIS_FUNC

    /bin/mkdir $flagFolder

    # Generate huge folder tree
    generateFolderTree $flagFolder 2 99

    /bin/echo "Flag: $CHAL_FLAG" > $flagFile
    /sbin/chown root:$CHAL_USER $flagFile
    /bin/chmod 440 $flagFile

    /bin/cp $TPL_FOLDER'/index.'$CHAL_NAME'.php' $indexFile
    /sbin/chown root:$CHAL_USER $indexFile
    /bin/chmod 440 $indexFile

    addBinaryToChroot /bin/sh $chrDir
    addBinaryToChroot /usr/bin/find $chrDir

    /etc/rc.d/nginx restart
    /etc/rc.d/php_fpm restart
fi

# Description: Understand the php brainfuck and send the right output
CHAL_NAME='php05'
CHAL_USER='_www5'
CHAL_PHP_PORT='9004'
CHAL_DIS_FUNC='eval,dir,readdir,opendir,scandir,dl,exec,passthru,shell_exec,system,proc_open,popen,curl_exec,curl_multi_exec,parse_ini_file,show_source,include,include_once,require,require_once,file_get_contents,readfile,fwrite,fsockopen,socket_create,stream_socket_client,stream_socket_server'
CHAL_FLAG='FLAG-JOeg18eFwC4SrWvyUHY5K5bLIk60PngP'
/usr/sbin/userinfo $CHAL_USER > /dev/null
if [ $? -eq 1 ]; then
    chrDir=$NGINX_VHOST_FOLDER'/'$CHAL_NAME
    staticDir=$NGINX_VHOST_FOLDER'/static'
    flagFile=$chrDir'/flag.txt'
    indexFile=$chrDir'/var/www/index.php'

    createNginxChroot $CHAL_NAME $CHAL_USER $CHAL_PHP_PORT $CHAL_DIS_FUNC

    /bin/echo "Flag: $CHAL_FLAG" > $flagFile
    /sbin/chown root:$CHAL_USER $flagFile
    /bin/chmod 440 $flagFile

    /bin/cp $TPL_FOLDER'/index.'$CHAL_NAME'.php' $indexFile
    /sbin/chown root:$CHAL_USER $indexFile
    /bin/chmod 440 $indexFile

    addFileToStatic $TPL_FOLDER'/index.'$CHAL_NAME'.php' 'php05.txt'

    /etc/rc.d/nginx restart
    /etc/rc.d/php_fpm restart
fi

# Description: Understand the php brainfuck and send the right output
CHAL_NAME='php06'
CHAL_USER='_www6'
CHAL_PHP_PORT='9005'
CHAL_DIS_FUNC='eval,dir,readdir,opendir,scandir,dl,exec,passthru,shell_exec,system,proc_open,popen,curl_exec,curl_multi_exec,parse_ini_file,show_source,include,include_once,require,require_once,file_get_contents,readfile,fwrite,fsockopen,socket_create,stream_socket_client,stream_socket_server'
CHAL_FLAG='FLAG-WPXqxGXyJ7vh1gUc5JpXwCZfRK9Du5Lw'
/usr/sbin/userinfo $CHAL_USER > /dev/null
if [ $? -eq 1 ]; then
    chrDir=$NGINX_VHOST_FOLDER'/'$CHAL_NAME
    staticDir=$NGINX_VHOST_FOLDER'/static'
    flagFile=$chrDir'/flag.txt'
    indexFile=$chrDir'/var/www/index.php'

    createNginxChroot $CHAL_NAME $CHAL_USER $CHAL_PHP_PORT $CHAL_DIS_FUNC

    /bin/echo "Flag: $CHAL_FLAG" > $flagFile
    /sbin/chown root:$CHAL_USER $flagFile
    /bin/chmod 440 $flagFile

    /bin/cp $TPL_FOLDER'/index.'$CHAL_NAME'.php' $indexFile
    /sbin/chown root:$CHAL_USER $indexFile
    /bin/chmod 440 $indexFile

    addFileToStatic $TPL_FOLDER'/index.'$CHAL_NAME'.php' 'php06.txt'

    /etc/rc.d/nginx restart
    /etc/rc.d/php_fpm restart
fi

# Description: Find the flag using ls, cat and rksh
CHAL_NAME='ssh01'
CHAL_USER='ssh01'
CHAL_PASS='ssh01'
CHAL_SHELL='/bin/rksh'
CHAL_FLAG='NlBuBcqlzzEJhsSUSUwUtRNoMdESDqVU'
/usr/sbin/userinfo $CHAL_USER > /dev/null
if [ $? -eq 1 ]; then
    chrDir=$SSH_FOLDER'/'$CHAL_NAME
    hintFile=$chrDir'/home/'$CHAL_USER'/FLAG_IS_HIDDEN_SOMEWHERE'
    flagFolder=$chrDir'/lib//.../*'
    flagFile=$flagFolder'/...'

    createSSHChroot $CHAL_NAME $CHAL_USER $CHAL_PASS $CHAL_SHELL

    /bin/mkdir -p $flagFolder
    /sbin/chown root:$CHAL_USER $flagFolder
    /bin/chmod 550 $flagFolder

    /bin/echo '' > $hintFile
    /sbin/chown root:$CHAL_USER $hintFile
    /bin/chmod 440 $hintFile

    /bin/echo 'Flag: '$CHAL_FLAG > $flagFile
    /sbin/chown root:$CHAL_USER $flagFile
    /bin/chmod 440 $flagFile

    addBinaryToChroot /bin/ls $chrDir
    addBinaryToChroot /bin/cat $chrDir

    /etc/rc.d/sshd restart
fi

# Description: Find the flag using ls, cat, on a systrace protected shell.
CHAL_NAME='ssh02'
CHAL_USER='ssh02'
CHAL_PASS=$CHAL_FLAG
CHAL_SHELL='/bin/hfsh'
CHAL_FLAG='4lIoz0EtV41IiE5UQfKaNuKDwpP2nDK'
/usr/sbin/userinfo $CHAL_USER > /dev/null
if [ $? -eq 1 ]; then
    chrDir=$SSH_FOLDER'/'$CHAL_NAME
    flagPath=$SSH_FOLDER'/'$CHAL_USER'/flag.txt'
    srcShell='chroot01/hfsh.c'
    binShell='chroot01/hfsh'
    policyPath='chroot01/'$CHAL_NAME'.bin_ksh'
    dPolicyPath=$chrDir'/home/'$CHAL_USER'/.systrace/bin_ksh'
    policyLogPath=$chrDir'/var/log/systrace.log'

    /bin/echo 'Compiling hfsh'
    gcc $srcShell -o $binShell
    /bin/cp $binShell '/bin/hfsh'

    createSSHChroot $CHAL_NAME $CHAL_USER $CHAL_PASS $CHAL_SHELL

    /bin/echo 'Flag: '$CHAL_FLAG > $flagPath
    /sbin/chown root:$CHAL_USER $flagPath
    /bin/chmod 740 $flagPath

    /bin/echo 'Copying policy file'
    /bin/cp $policyPath $dPolicyPath
    /sbin/chown root:$CHAL_USER $dPolicyPath
    /bin/chmod 740 $dPolicyPath

    /bin/echo 'Create systrace log file'
    /usr/bin/touch $policyLogPath
    /sbin/chown root:$CHAL_USER $policyLogPath
    /bin/chmod 760 $policyLogPath

    addBinaryToChroot '/bin/ksh' $chrDir
    addBinaryToChroot '/bin/hfsh' $chrDir
    addBinaryToChroot '/bin/ls' $chrDir
    addBinaryToChroot '/bin/cat' $chrDir
    addBinaryToChroot '/bin/systrace' $chrDir
fi

# Description: Find the flag using gcc, on a systrace protected shell.
CHAL_NAME='ssh03'
CHAL_USER='ssh03'
CHAL_PASS=$CHAL_FLAG
CHAL_SHELL='/bin/hfsh'
CHAL_FLAG='P2nxFor2SKSwDiBOoO1TJf8VEmBdMaNT'
/usr/sbin/userinfo $CHAL_USER > /dev/null
if [ $? -eq 1 ]; then
    chrDir=$SSH_FOLDER'/'$CHAL_NAME
    flagPath=$SSH_FOLDER'/'$CHAL_USER'/flag.txt'
    srcShell='chroot01/hfsh.c'
    binShell='chroot01/hfsh'
    policyPath='chroot01/'$CHAL_NAME'.bin_ksh'
    dPolicyPath=$chrDir'/home/'$CHAL_USER'/.systrace/bin_ksh'
    policyLogPath=$chrDir'/var/log/systrace.log'

    /bin/echo 'Compiling hfsh'
    gcc $srcShell -o $binShell
    /bin/cp $binShell '/bin/hfsh'

    createSSHChroot $CHAL_NAME $CHAL_USER $CHAL_PASS $CHAL_SHELL
    addSecuredTmp $chrDir $CHAL_USER

    /bin/echo 'Flag: '$CHAL_FLAG > $flagPath
    /sbin/chown root:$CHAL_USER $flagPath
    /bin/chmod 740 $flagPath

    /bin/echo 'Copying policy file'
    /bin/cp $policyPath $dPolicyPath
    /sbin/chown root:$CHAL_USER $dPolicyPath
    /bin/chmod 740 $dPolicyPath

    /bin/echo 'Create systrace log file'
    /usr/bin/touch $policyLogPath
    /sbin/chown root:$CHAL_USER $policyLogPath
    /bin/chmod 760 $policyLogPath

    addBinaryToChroot '/bin/ksh' $chrDir
    addBinaryToChroot '/bin/hfsh' $chrDir
    addBinaryToChroot '/bin/ls' $chrDir
    addBinaryToChroot '/bin/cat' $chrDir
    addBinaryToChroot '/usr/bin/touch' $chrDir
    addBinaryToChroot '/bin/mkdir' $chrDir
    addBinaryToChroot '/usr/bin/gcc' $chrDir
    addBinaryToChroot '/bin/systrace' $chrDir
    addBinaryToChroot '/usr/local/bin/vim' $chrDir
    addBinaryToChroot '/usr/bin/id' $chrDir
fi

