#!/usr/bin/env bash

if (( $EUID != 0 )); then
    echo "Please run as root"
    echo "You can Try comand 'su root' or 'sudo -i'"
    exit 1
fi

sudo pkill -9 apt.systemd
echo "wait 10s"
sleep 10
sudo pkill -9 apt.systemd
lock1=/var/lib/apt/lists/lock
lock2=/var/lib/dpkg/lock-frontend
lock3=/var/lib/dpkg/lock
lock4=/var/cache/apt/archives/lock

for (( x=1; x<=4; x++ ))
do 
 plock="lock$x"
 if [ -f "${!plock}" ];then
     if [ -z $(lsof -t ${!plock}) ]
     then
        echo "Ok... file (${!plock}) already delete"
     else
        sudo kill -9 $(lsof -t ${!plock})
        echo "Found..PID (${!plock}) already kill & delete file"
     fi
 sudo rm ${!plock}
 fi
done

sudo dpkg --configure -a
sudo apt-get install --reinstall libappstream4 -y
sudo apt-get install -f
sudo apt-get update
