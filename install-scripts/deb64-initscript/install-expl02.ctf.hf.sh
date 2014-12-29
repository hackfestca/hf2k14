#!/bin/bash
./1-setupVM.sh
./2-customVM.sh -h expl02 -d ctf.hf -i 172.28.72.130 -n 255.255.255.0 -g 172.28.72.1 -z CHALS -o HF
