#!/bin/bash
./1-setupVM.sh
./2-customVM.sh -h irc -d hf -i 172.28.71.5 -n 255.255.255.0 -g 172.28.71.1 -z PUBLIC -o HF

