#!/bin/bash


# https://superuser.com/questions/404012/how-to-prevent-the-monitor-from-turning-off-in-linux
xset -dpms
xset s noblank
xset s off


while true;do
	echo "check"
	if ping -c 1 192.168.0.35; then
		# https://unix.stackexchange.com/questions/120153/resolving-mac-address-from-ip-address-in-linux
		if arp -a | grep 192.168.0.35 | grep 34:2e:b6:a3:82:6b; then
			echo "unlock"
			gnome-screensaver-command -d
			sleep 30
			continue
		fi
	fi
	echo "lock"
	gnome-screensaver-command -l
	sleep 30
done
