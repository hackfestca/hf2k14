#!/bin/ksh
./1-setupVM.sh
./2-customVM.sh -h 'prog01' -d 'ctf.hf' -i '172.28.72.12' -n '255.255.255.0' -g '172.28.72.1' -z 'CHALS' -o 'HF'
