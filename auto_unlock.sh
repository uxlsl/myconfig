#!/bin/bash


# https://superuser.com/questions/404012/how-to-prevent-the-monitor-from-turning-off-in-linux
xset -dpms
xset s noblank
xset s off


while true;do
	echo "check"
	if ping -c 1 192.168.0.35; then
		echo "unlock"
		gnome-screensaver-command -d
	else
		echo "lock"
		gnome-screensaver-command -l
	fi

	sleep 60
done
