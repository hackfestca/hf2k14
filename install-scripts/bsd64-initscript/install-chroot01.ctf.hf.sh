#!/bin/ksh
./1-setupVM.sh
./2-customVM.sh -h 'chroot01' -d 'ctf.hf' -i '172.28.72.10' -n '255.255.255.0' -g '172.28.72.1' -z 'CHALS' -o 'HF'

