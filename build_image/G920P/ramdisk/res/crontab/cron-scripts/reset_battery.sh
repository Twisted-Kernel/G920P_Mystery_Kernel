#!/system/bin/sh

BB=/system/xbin/busybox;
FG_RESET=$(cat /res/synapse/Hybridmax/cron_fg);

if [ "$($BB mount | grep rootfs | cut -c 26-27 | grep -c ro)" -eq "1" ]; then
	$BB mount -o remount,rw /;
fi;

if [ "$FG_RESET" == 1 ]; then

	$BB chmod 666 /sys/devices/battery.51/power_supply/battery/fg_reset_cap;
	echo 1 > /sys/devices/battery.51/power_supply/battery/fg_reset_cap;

	date +%R-%F > /data/crontab/cron-reset_battery;
	echo " Battery Reset" >> /data/crontab/cron-reset_battery;

elif [ "$FG_RESET" == 0 ]; then

	date +%R-%F > /data/crontab/cron-reset_battery;
	echo " Battery Reset is disabled" >> /data/crontab/cron-reset_battery;
fi;

$BB mount -t rootfs -o remount,ro rootfs;
