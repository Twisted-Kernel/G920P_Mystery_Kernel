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
	cp /sbin/profiles/battery/kernel.prop $USERPROP
fi

###############################################################################
# Performance
if [ "`grep "kernel.profile=performance" $PROFILE`" != "" ]; then
	rm -rf $USERPROP
	cp /sbin/profiles/performance/kernel.prop $USERPROP
fi

###############################################################################
# Stock
if [ "`grep "kernel.profile=stock" $PROFILE`" != "" ]; then
	rm -rf $USERPROP
	cp /sbin/profiles/stock/kernel.prop $USERPROP
fi

$BB mount -t rootfs -o remount,ro rootfs;
$BB mount -o remount,ro /system;
$BB mount -o remount,rw /data;
