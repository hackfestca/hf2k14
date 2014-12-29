#!/bin/bash
./1-setupVM.sh
./2-customVM.sh -h chuck -d hf -i 172.28.70.30 -n 255.255.255.0 -g 172.28.70.1 -z PUBLIC -o HF

