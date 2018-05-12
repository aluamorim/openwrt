#!/bin/sh


scp "*.ko" "root@192.168.1.1:/root"
scp "sine.wav" "root@192.168.1.1:/root"
scp "run.sh" "root@192.168.1.1:/root"