#!/system/xbin/busybox sh

# Kernel Profile Script

USERPROP=/data/media/0/mystery-kernel/kernel.prop
PROFILE=/data/media/0/mystery-kernel/kernel-profile.prop
BB=/system/xbin/busybox

$BB mount -t rootfs -o remount,rw rootfs;
$BB mount -o remount,rw /system;
$BB mount -o remount,rw /data;

###############################################################################
# Battery
if [ "`grep "kernel.profile=battery" $PROFILE`" != "" ]; then
	rm -rf $USERPROP
	cp /sbin/profiles/battery/kernel.prop $PROFILE
fi

###############################################################################
# Performance
if [ "`grep "kernel.profile=performance" $PROFILE`" != "" ]; then
	rm -rf $USERPROP
	cp /sbin/profiles/performance/kernel.prop $PROFILE
fi

###############################################################################
# Stock
if [ "`grep "kernel.profile=stock" $PROFILE`" != "" ]; then
	rm -rf $USERPROP
	cp /sbin/profiles/stock/kernel.prop $PROFILE
fi

$BB mount -t rootfs -o remount,ro rootfs;
$BB mount -o remount,ro /system;
$BB mount -o remount,rw /data;
