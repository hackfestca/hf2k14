#!/bin/ksh

# some vars
txtblk='\e[0;30m' # Black - Regular
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtblu='\e[0;34m' # Blue
txtpur='\e[0;35m' # Purple
txtcyn='\e[0;36m' # Cyan
txtwht='\e[0;37m' # White
bldblk='\e[1;30m' # Black - Bold
bldred='\e[1;31m' # Red
bldgrn='\e[1;32m' # Green
bldylw='\e[1;33m' # Yellow
bldblu='\e[1;34m' # Blue
bldpur='\e[1;35m' # Purple
bldcyn='\e[1;36m' # Cyan
bldwht='\e[1;37m' # White
unkblk='\e[4;30m' # Black - Underline
undred='\e[4;31m' # Red
undgrn='\e[4;32m' # Green
undylw='\e[4;33m' # Yellow
undblu='\e[4;34m' # Blue
undpur='\e[4;35m' # Purple
undcyn='\e[4;36m' # Cyan
undwht='\e[4;37m' # White
bakblk='\e[40m'   # Black - Background
bakred='\e[41m'   # Red
bakgrn='\e[42m'   # Green
bakylw='\e[43m'   # Yellow
bakblu='\e[44m'   # Blue
bakpur='\e[45m'   # Purple
bakcyn='\e[46m'   # Cyan
bakwht='\e[47m'   # White
txtrst='\e[0m'    # Text Reset

# Menu, arguments, help
while test $# -gt 0; do
        case "$1" in
                -h|--help)
                        echo "$package - generate a banner for hackfest 2013 VMs"
                        echo " "
                        echo "$package [options] OUTPUT_FILE"
                        echo " "
                        echo "options:"
                        echo "-h, --help                show brief help"
                        echo "-z, --zone=ACTION		specify a zone (MGMT, PUBLIC, CHALS)"
                        echo "-o, --owner=OWNER      	specify an owner (HF)"
                        exit 0
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
                        if test $# -gt 0; then
                                export OUT_FILE=$1
                        else
                                echo "no file specified"
                                exit 1
                        fi
                        break
                        ;;
        esac
done

# Some validations
if [ -z $ZONE ] || [ -z $OWNER ]
then
	echo There are missing arguments
	exit 1
fi

case "$OWNER" in
	HF) case "$ZONE" in
		MGMT) PREFIX="\[$txtrst$bakred\][MGT]\[$txtrst\] ";;
		PUBLIC) PREFIX="\[$txtrst$bakred\][PUB]\[$txtrst\] ";;
		CHALS) PREFIX="\[$txtrst$bakred\][CHL]\[$txtrst\] ";;
		*) PREFIX="\[$txtrst$bakred\][HF]\[$txtrst\] ";;
	   esac;;
	*) case "$ZONE" in
		MGMT) PREFIX="\[$txtrst$bakred\][MGT]\[$txtrst\] ";;
		PUBLIC) PREFIX="\[$txtrst$bakred\][PUB]\[$txtrst\] ";;
		CHALS) PREFIX="\[$txtrst$bakred\][CHL]\[$txtrst\] ";;
		*) PREFIX="\[$txtrst$bakred\][HF]\[$txtrst\] ";;
	   esac;;
esac

USRCOL="\[$txtrst$bldred\]"
#USRCOL="\[$txtrst$bldgrn\]"
HOSTCOL="\[$txtrst$bldgrn$undgrn\]"
#HOSTCOL="\[$txtrst$bldylw$undylw\]"

PS1=$PREFIX$USRCOL'\u\['$bldwht'\]@'$HOSTCOL'\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
echo "$PS1" | sed -e 's/[\/&]/\\&/g'

