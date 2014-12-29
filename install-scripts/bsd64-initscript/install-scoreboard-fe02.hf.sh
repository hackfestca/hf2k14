#!/bin/ksh
./1-setupVM.sh
./2-customVM.sh -h 'scoreboard-fe02' -d 'hf' -i '172.28.71.12' -n '255.255.255.0' -g '172.28.71.1' -z PUBLIC -o HF
#./3-installNginx

