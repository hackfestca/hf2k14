#!/bin/bash
./1-setupVM.sh
./2-customVM.sh -h monitoring -d hf -i 172.16.66.4 -n 255.255.255.0 -g 172.16.66.1 -z MGMT -o HF
