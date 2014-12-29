#!/bin/ksh
./1-setupVM.sh
./2-customVM.sh -h 'scoreboard-be02' -d 'hf' -i '172.28.70.12' -n '255.255.255.0' -g '172.28.70.1' -z PUBLIC -o HF
#./3-installNginx

