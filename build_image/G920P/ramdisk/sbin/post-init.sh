#!/system/bin/sh

# Post-init Script by Hybridmax

BB=/system/xbin/busybox;

#####################################################################
# Mount root as RW to apply tweaks and settings
$BB mount -t rootfs -o remount,rw rootfs;
$BB mount -o remount,rw /system;

#####################################################################
# Set SELinux permissive by default
setenforce 0;

#####################################################################
# Make Kernel Data Path
if [ ! -d /data/.hybridmax ]; then
	$BB mkdir -p /data/.hybridmax;
	$BB chmod -R 0777 /.hybridmax/;
else
	$BB rm -rf /data/.hybridmax/*
	$BB chmod -R 0777 /.hybridmax/;
fi;

#####################################################################
# Clean old modules from /system and add new from ramdisk

#if [ ! -d /system/lib/modules ]; then
#	$BB mkdir /system/lib/modules
#	$BB cp -a /lib/modules/*.ko /system/lib/modules/*.ko
#	$BB chmod 755 /system/lib/modules/*.ko
#else
#	$BB rm -rf /system/lib/modules/*.ko
#	$BB cp -a /lib/modules/*.ko /system/lib/modules/*.ko
#	$BB chmod 755 /system/lib/modules/*.ko
#fi

#####################################################################
# No cache flush allowed for write protected devices
if [ "`grep "ro.build.version.release=5.1.1" $SYSTEMPROP`" != "" ]; then
	mkdir /system/su.d
	chmod 0700 /system/su.d
	echo "#!/tmp-mksh/tmp-mksh" > /system/su.d/000000deepsleep
	echo "echo "temporary none" > /sys/class/scsi_disk/0:0:0:1/cache_type" >>  /system/su.d/000000deepsleep
	echo "echo "temporary none" > /sys/class/scsi_disk/0:0:0:2/cache_type" >> /system/su.d/000000deepsleep
	chmod 0700 /system/su.d/000000deepsleep
	echo "Set deepsleep values on boot successful." >> /data/hackertest.log
fi

#####################################################################
# Set correct r/w permissions for LMK parameters
$BB chmod 666 /sys/module/lowmemorykiller/parameters/cost;
$BB chmod 666 /sys/module/lowmemorykiller/parameters/adj;
$BB chmod 666 /sys/module/lowmemorykiller/parameters/minfree;

#####################################################################
# Disable rotational storage for all blocks
# We need faster I/O so do not try to force moving to other CPU cores (dorimanx)
for i in /sys/block/*/queue; do
        echo "0" > "$i"/rotational;
        echo "2" > "$i"/rq_affinity;
done

#####################################################################
# Allow untrusted apps to read from debugfs (mitigate SELinux denials)
if [ -e /su/lib/libsupol.so ]; then
/system/xbin/supolicy --live \
	"allow untrusted_app debugfs file { open read getattr }" \
	"allow untrusted_app sysfs_lowmemorykiller file { open read getattr }" \
	"allow untrusted_app sysfs_devices_system_iosched file { open read getattr }" \
	"allow untrusted_app persist_file dir { open read getattr }" \
	"allow debuggerd gpu_device chr_file { open read getattr }" \
	"allow netd netd capability fsetid" \
	"allow netd { hostapd dnsmasq } process fork" \
	"allow { system_app shell } dalvikcache_data_file file write" \
	"allow { zygote mediaserver bootanim appdomain }  theme_data_file dir { search r_file_perms r_dir_perms }" \
	"allow { zygote mediaserver bootanim appdomain }  theme_data_file file { r_file_perms r_dir_perms }" \
	"allow system_server { rootfs resourcecache_data_file } dir { open read write getattr add_name setattr create remove_name rmdir unlink link }" \
	"allow system_server resourcecache_data_file file { open read write getattr add_name setattr create remove_name unlink link }" \
	"allow system_server dex2oat_exec file rx_file_perms" \
	"allow mediaserver mediaserver_tmpfs file execute" \
	"allow drmserver theme_data_file file r_file_perms" \
	"allow zygote system_file file write" \
	"allow atfwd property_socket sock_file write" \
	"allow untrusted_app sysfs_display file { open read write getattr add_name setattr remove_name }" \
	"allow debuggerd app_data_file dir search" \
	"allow sensors diag_device chr_file { read write open ioctl }" \
	"allow sensors sensors capability net_raw" \
	"allow init kernel security setenforce" \
	"allow netmgrd netmgrd netlink_xfrm_socket nlmsg_write" \
	"allow netmgrd netmgrd socket { read write open ioctl }"
fi;

#####################################################################
# Fix for earphone / handsfree no in-call audio
if [ -d "/sys/class/misc/arizona_control" ]; then
	echo "1" >/sys/class/misc/arizona_control/switch_eq_hp;
fi;

#####################################################################
# Synapse
$BB mount -t rootfs -o remount,rw rootfs;
$BB chmod -R 755 /res/*;
$BB ln -fs /res/synapse/uci /sbin/uci;
/sbin/uci;

#####################################################################
# Init.d
if [ "$($BB mount | grep rootfs | cut -c 26-27 | grep -c ro)" -eq "1" ]; then
	$BB mount -o remount,rw /;
fi;
if [ "$($BB mount | grep system | grep -c ro)" -eq "1" ]; then
	$BB mount -o remount,rw /system;
fi;
if [ ! -d /system/etc/init.d ]; then
	mkdir -p /system/etc/init.d/;
	chown -R root.root /system/etc/init.d;
	chmod 777 /system/etc/init.d/;
	chmod 777 /system/etc/init.d/*;
fi;
$BB run-parts /system/etc/init.d;

#####################################################################
# Fixing Permissions
$BB chown -R system:system /data/anr
$BB chown -R root:root /tmp
$BB chown -R root:root /res
$BB chown -R root:root /sbin
$BB chown -R root:root /lib
$BB chmod -R 777 /tmp/
$BB chmod -R 775 /res/
$BB chmod -R 06755 /sbin/ext/
$BB chmod -R 0777 /data/anr/
$BB chmod -R 0400 /data/tombstones
$BB chown -R root:root /data/property
$BB chmod -R 0700 /data/property
$BB chmod 06755 /sbin/busybox
$BB chmod 06755 /system/xbin/busybox

#####################################################################
# Kernel custom test
if [ -e /data/.hybridmax/Kernel-test.log ]; then
	rm /data/.hybridmax/Kernel-test.log
fi;
echo  Kernel script is working !!! >> /data/.hybridmax/Kernel-test.log
echo "excecuted on $(date +"%d-%m-%Y %r" )" >> /data/.hybridmax/Kernel-test.log

#####################################################################
# Arizona earphone sound default (parametric equalizer preset values by AndreiLux)
#if [ -d "/sys/class/misc/arizona_control" ]; then
#	sleep 20;
#	echo "0x0FF3 0x041E 0x0034 0x1FC8 0xF035 0x040D 0x00D2 0x1F6B 0xF084 0x0409 0x020B 0x1EB8 0xF104 0x0409 0x0406 0x0E08 0x0782 0x2ED8" > /sys/class/misc/arizona_control/eq_A_freqs
#	echo "0x0C47 0x03F5 0x0EE4 0x1D04 0xF1F7 0x040B 0x07C8 0x187D 0xF3B9 0x040A 0x0EBE 0x0C9E 0xF6C3 0x040A 0x1AC7 0xFBB6 0x0400 0x2ED8" > /sys/class/misc/arizona_control/eq_B_freqs
#fi;

#####################################################################
# Run Cortexbrain script
# Cortex parent should be ROOT/INIT and not Synapse
#cortexbrain_background_process=$(cat /res/synapse/hybridmax/cortexbrain_background_process);
#if [ "$cortexbrain_background_process" == "1" ]; then
#	sleep 30
#	$BB nohup $BB sh /sbin/cortexbrain-tune.sh > /dev/null 2>&1 &
#fi;

#####################################################################
# Start CROND by tree root, so it's will not be terminated.
#$BB nohup $BB sh /res/crontab_service/service.sh > /dev/null;


$BB mount -t rootfs -o remount,ro rootfs;
$BB mount -o remount,ro /system;
$BB mount -o remount,rw /data;
