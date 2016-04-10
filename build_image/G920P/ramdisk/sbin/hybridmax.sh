#!/system/xbin/busybox sh

# Kernel Tuning by Hybridmax

#vars
BB=/system/xbin/busybox
PROP=/system/kernel.prop
USERPROP=/data/media/0/mystery-kernel/kernel.prop
BPROP=/system/build.prop
CPU_GOV_A53=/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
CPU_GOV_A57=/sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
CPU_MIN_FREQ_A53_0=/sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
CPU_MIN_FREQ_A53_1=/sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
CPU_MIN_FREQ_A53_2=/sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
CPU_MIN_FREQ_A53_3=/sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq
CPU_MAX_FREQ_A53_0=/sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
CPU_MAX_FREQ_A53_1=/sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
CPU_MAX_FREQ_A53_2=/sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
CPU_MAX_FREQ_A53_3=/sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq
CPU_MIN_FREQ_A57_4=/sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
CPU_MIN_FREQ_A57_5=/sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq
CPU_MIN_FREQ_A57_6=/sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq
CPU_MIN_FREQ_A57_7=/sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq
CPU_MAX_FREQ_A57_4=/sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
CPU_MAX_FREQ_A57_5=/sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq
CPU_MAX_FREQ_A57_6=/sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq
CPU_MAX_FREQ_A57_7=/sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq
TCP_CONG=/proc/sys/net/ipv4/tcp_congestion_control
ARCH_POWER=/sys/kernel/sched/arch_power
GENTLE_FAIR_SLEEPERS=/sys/kernel/sched/gentle_fair_sleepers
DATE=$(date)
LOG=/data/.hybridmax/Kernel-Tune.log

###############################################################################
# Open Partitions in writable mode

$BB mount -t rootfs -o remount,rw rootfs
$BB mount -o remount,rw /system
$BB mount -o remount,rw /data
$BB mount -o remount,rw /
sync

sleep 1
###############################################################################
# Parse Mode Enforcement from prop

if [ "`grep "kernel.turbo=true" $USERPROP`" != "" ]; then
	echo "1" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/enforced_mode
	echo "1" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/enforced_mode
fi

sleep 1
###############################################################################
# Kernel Settings

if [ ! -f $USERPROP ]; then
	mkdir /data/media/0/mystery-kernel
	chmod 0777 /data/media/0/mystery-kernel
	cp /system/kernel.prop $USERPROP
else
	chmod 0777 /data/media/0/mystery-kernel
fi

sleep 1
###############################################################################
# Create Log File

$BB touch $LOG
echo "$DATE" >> $LOG
echo "" >> $LOG
echo "=========================" >> $LOG
echo "System Informations:" >> $LOG
$BB grep ro.build.display.id /system/build.prop >> $LOG
$BB grep ro.product.model /system/build.prop >> $LOG
$BB grep ro.build.version /system/build.prop >> $LOG
$BB grep ro.product.board /system/build.prop >> $LOG
echo "=========================" >> $LOG
echo "" >> $LOG

sleep 1
###############################################################################
# Parse init/d support from prop

if [ "`grep "kernel.initd=true" $USERPROP`" != "" ]; then
	if [ -d /system/etc/init.d ]; then
		chmod 755 /system/etc/init.d
		chmod 755 /system/etc/init.d/*
		run-parts /system/etc/init.d
	else
		mkdir /system/etc/init.d
		chmod 755 /system/etc/init.d
	fi
	echo "init.d Support enabled successful." >> $LOG
fi

sleep 1
###############################################################################
# Parse Interactive tuning from prop

if [ "`grep "kernel.interactive=performance" $USERPROP`" != "" ]; then
	# apollo	
	echo "12000"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay
	echo "45000"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/boostpulse_duration
	echo "80"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
	echo "1"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/io_is_busy
	echo "70"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
	echo "35000"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time
	echo "20000"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
	# atlas
	echo "25000 1300000:20000 1700000:20000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay
	echo "45000"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/boostpulse_duration
	echo "83"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load
	echo "1"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/io_is_busy
	echo "60 1500000:70"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads
	echo "35000"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time
	echo "15000"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate
elif [ "`grep "kernel.interactive=battery" $USERPROP`" != "" ]; then
	# apollo	
	echo "37000"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay
	echo "25000"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/boostpulse_duration
	echo "80"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
	echo "0"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/io_is_busy
	echo "90"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
	echo "15000"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time
	echo "15000"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
	# atlas
	echo "70000 1300000:55000 1700000:55000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay
	echo "25000"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/boostpulse_duration
	echo "95"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load
	echo "0"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/io_is_busy
	echo "80 1500000:90"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads
	echo "15000"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time
	echo "15000"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate
fi

sleep 5
###############################################################################
# Parse IO Scheduler from prop

if [ "`grep "kernel.scheduler=noop" $USERPROP`" != "" ]; then
	echo "noop" > /sys/block/mmcblk0/queue/scheduler
    	echo "noop" > /sys/block/sda/queue/scheduler
    	echo "noop" > /sys/block/sdb/queue/scheduler
    	echo "noop" > /sys/block/sdc/queue/scheduler
    	echo "noop" > /sys/block/vnswap0/queue/scheduler
elif [ "`grep "kernel.scheduler=fiops" $USERPROP`" != "" ]; then
	echo "fiops" > /sys/block/mmcblk0/queue/scheduler
    	echo "fiops" > /sys/block/sda/queue/scheduler
    	echo "fiops" > /sys/block/sdb/queue/scheduler
    	echo "fiops" > /sys/block/sdc/queue/scheduler
    	echo "fiops" > /sys/block/vnswap0/queue/scheduler
elif [ "`grep "kernel.scheduler=deadline" $USERPROP`" != "" ]; then
	echo "deadline" > /sys/block/mmcblk0/queue/scheduler
    	echo "deadline" > /sys/block/sda/queue/scheduler
    	echo "deadline" > /sys/block/sdb/queue/scheduler
    	echo "deadline" > /sys/block/sdc/queue/scheduler
    	echo "deadline" > /sys/block/vnswap0/queue/scheduler
elif [ "`grep "kernel.scheduler=bfq" $USERPROP`" != "" ]; then
	echo "bfq" > /sys/block/mmcblk0/queue/scheduler
    	echo "bfq" > /sys/block/sda/queue/scheduler
    	echo "bfq" > /sys/block/sdb/queue/scheduler
    	echo "bfq" > /sys/block/sdc/queue/scheduler
    	echo "bfq" > /sys/block/vnswap0/queue/scheduler
elif [ "`grep "kernel.scheduler=cfg" $USERPROP`" != "" ]; then
	echo "cfq" > /sys/block/mmcblk0/queue/scheduler
    	echo "cfq" > /sys/block/sda/queue/scheduler
    	echo "cfq" > /sys/block/sdb/queue/scheduler
    	echo "cfq" > /sys/block/sdc/queue/scheduler
    	echo "cfq" > /sys/block/vnswap0/queue/scheduler
elif [ "`grep "kernel.scheduler=row" $USERPROP`" != "" ]; then
	echo "row" > /sys/block/mmcblk0/queue/scheduler
    	echo "row" > /sys/block/sda/queue/scheduler
    	echo "row" > /sys/block/sdb/queue/scheduler
    	echo "row" > /sys/block/sdc/queue/scheduler
    	echo "row" > /sys/block/vnswap0/queue/scheduler
elif [ "`grep "kernel.scheduler=sioplus" $USERPROP`" != "" ]; then
	echo "sioplus" > /sys/block/mmcblk0/queue/scheduler
    	echo "sioplus" > /sys/block/sda/queue/scheduler
    	echo "sioplus" > /sys/block/sdb/queue/scheduler
    	echo "sioplus" > /sys/block/sdc/queue/scheduler
    	echo "sioplus" > /sys/block/vnswap0/queue/scheduler
elif [ "`grep "kernel.scheduler=tripndroid" $USERPROP`" != "" ]; then
	echo "tripndroid" > /sys/block/mmcblk0/queue/scheduler
    	echo "tripndroid" > /sys/block/sda/queue/scheduler
    	echo "tripndroid" > /sys/block/sdb/queue/scheduler
    	echo "tripndroid" > /sys/block/sdc/queue/scheduler
    	echo "tripndroid" > /sys/block/vnswap0/queue/scheduler
else
	echo "cfq" > /sys/block/mmcblk0/queue/scheduler
    	echo "cfq" > /sys/block/sda/queue/scheduler
    	echo "cfq" > /sys/block/sdb/queue/scheduler
    	echo "cfq" > /sys/block/sdc/queue/scheduler
    	echo "cfq" > /sys/block/vnswap0/queue/scheduler
fi

sleep 1
###############################################################################
# Parse Governor from prop

if [ "`grep "kernel.governor=conservative" $USERPROP`" != "" ]; then
	echo "conservative" > $CPU_GOV_A53
	echo "conservative" > $CPU_GOV_A57
elif [ "`grep "kernel.governor=interactive" $USERPROP`" != "" ]; then
	echo "interactive" > $CPU_GOV_A53
	echo "interactive" > $CPU_GOV_A57
elif [ "`grep "kernel.governor=ondemand" $USERPROP`" != "" ]; then
	echo "ondemand" > $CPU_GOV_A53
	echo "ondemand" > $CPU_GOV_A57
elif [ "`grep "kernel.governor=performance" $USERPROP`" != "" ]; then
	echo "performance" > $CPU_GOV_A53
	echo "performance" > $CPU_GOV_A57
elif [ "`grep "kernel.governor=alucard" $USERPROP`" != "" ]; then
	echo "alucard" > $CPU_GOV_A53
	echo "alucard" > $CPU_GOV_A57
elif [ "`grep "kernel.governor=bioshock" $USERPROP`" != "" ]; then
	echo "bioshock" > $CPU_GOV_A53
	echo "bioshock" > $CPU_GOV_A57
elif [ "`grep "kernel.governor=dancedance" $USERPROP`" != "" ]; then
	echo "dancedance" > $CPU_GOV_A53
	echo "dancedance" > $CPU_GOV_A57
elif [ "`grep "kernel.governor=lionheart" $USERPROP`" != "" ]; then
	echo "lionheart" > $CPU_GOV_A53
	echo "lionheart" > $CPU_GOV_A57
elif [ "`grep "kernel.governor=smartass2" $USERPROP`" != "" ]; then
	echo "smartass2" > $CPU_GOV_A53
	echo "smartass2" > $CPU_GOV_A57
elif [ "`grep "kernel.governor=wheatley" $USERPROP`" != "" ]; then
	echo "wheatley" > $CPU_GOV_A53
	echo "wheatley" > $CPU_GOV_A57
else 
	echo "interactive" > $CPU_GOV_A53
	echo "interactive" > $CPU_GOV_A57
fi

sleep 1
###############################################################################
# Parse CPU CLOCK from prop

# a53-min
if [ "`grep "kernel.cpu.a53.min=200000" $USERPROP`" != "" ]; then
	echo "200000" > $CPU_MIN_FREQ_A53_0
	echo "200000" > $CPU_MIN_FREQ_A53_1
	echo "200000" > $CPU_MIN_FREQ_A53_2
	echo "200000" > $CPU_MIN_FREQ_A53_3
elif [ "`grep "kernel.cpu.a53.min=300000" $USERPROP`" != "" ]; then
	echo "300000" > $CPU_MIN_FREQ_A53_0
	echo "300000" > $CPU_MIN_FREQ_A53_1
	echo "300000" > $CPU_MIN_FREQ_A53_2
	echo "300000" > $CPU_MIN_FREQ_A53_3
elif [ "`grep "kernel.cpu.a53.min=400000" $USERPROP`" != "" ]; then
	echo "400000" > $CPU_MIN_FREQ_A53_0
	echo "400000" > $CPU_MIN_FREQ_A53_1
	echo "400000" > $CPU_MIN_FREQ_A53_2
	echo "400000" > $CPU_MIN_FREQ_A53_3
else
	echo "400000" > $CPU_MIN_FREQ_A53_0
	echo "400000" > $CPU_MIN_FREQ_A53_1
	echo "400000" > $CPU_MIN_FREQ_A53_2
	echo "400000" > $CPU_MIN_FREQ_A53_3
fi

sleep 1;

# a53-max
if [ "`grep "kernel.cpu.a53.max=1200000" $USERPROP`" != "" ]; then
	echo "1200000" > $CPU_MAX_FREQ_A53_0
	echo "1200000" > $CPU_MAX_FREQ_A53_1
	echo "1200000" > $CPU_MAX_FREQ_A53_2
	echo "1200000" > $CPU_MAX_FREQ_A53_3
elif [ "`grep "kernel.cpu.a53.min=1296000" $USERPROP`" != "" ]; then
	echo "1296000" > $CPU_MAX_FREQ_A53_0
	echo "1296000" > $CPU_MAX_FREQ_A53_1
	echo "1296000" > $CPU_MAX_FREQ_A53_2
	echo "1296000" > $CPU_MAX_FREQ_A53_3
elif [ "`grep "kernel.cpu.a53.min=1400000" $USERPROP`" != "" ]; then
	echo "1400000" > $CPU_MAX_FREQ_A53_0
	echo "1400000" > $CPU_MAX_FREQ_A53_1
	echo "1400000" > $CPU_MAX_FREQ_A53_2
	echo "1400000" > $CPU_MAX_FREQ_A53_3
elif [ "`grep "kernel.cpu.a53.min=1500000" $USERPROP`" != "" ]; then
	echo "1500000" > $CPU_MAX_FREQ_A53_0
	echo "1500000" > $CPU_MAX_FREQ_A53_1
	echo "1500000" > $CPU_MAX_FREQ_A53_2
	echo "1500000" > $CPU_MAX_FREQ_A53_3
elif [ "`grep "kernel.cpu.a53.min=1600000" $USERPROP`" != "" ]; then
	echo "1600000" > $CPU_MAX_FREQ_A53_0
	echo "1600000" > $CPU_MAX_FREQ_A53_1
	echo "1600000" > $CPU_MAX_FREQ_A53_2
	echo "1600000" > $CPU_MAX_FREQ_A53_3
else
	echo "1500000" > $CPU_MAX_FREQ_A53_0
	echo "1500000" > $CPU_MAX_FREQ_A53_1
	echo "1500000" > $CPU_MAX_FREQ_A53_2
	echo "1500000" > $CPU_MAX_FREQ_A53_3
fi

sleep 1;

# a57-min
if [ "`grep "kernel.cpu.a57.min=200000" $USERPROP`" != "" ]; then
	echo "200000" > $CPU_MIN_FREQ_A57_4
	echo "200000" > $CPU_MIN_FREQ_A57_5
	echo "200000" > $CPU_MIN_FREQ_A57_6
	echo "200000" > $CPU_MIN_FREQ_A57_7
elif [ "`grep "kernel.cpu.a57.min=300000" $USERPROP`" != "" ]; then
	echo "300000" > $CPU_MIN_FREQ_A57_4
	echo "300000" > $CPU_MIN_FREQ_A57_5
	echo "300000" > $CPU_MIN_FREQ_A57_6
	echo "300000" > $CPU_MIN_FREQ_A57_7
elif [ "`grep "kernel.cpu.a57.min=400000" $USERPROP`" != "" ]; then
	echo "400000" > $CPU_MIN_FREQ_A57_4
	echo "400000" > $CPU_MIN_FREQ_A57_5
	echo "400000" > $CPU_MIN_FREQ_A57_6
	echo "400000" > $CPU_MIN_FREQ_A57_7
elif [ "`grep "kernel.cpu.a57.min=500000" $USERPROP`" != "" ]; then
	echo "500000" > $CPU_MIN_FREQ_A57_4
	echo "500000" > $CPU_MIN_FREQ_A57_5
	echo "500000" > $CPU_MIN_FREQ_A57_6
	echo "500000" > $CPU_MIN_FREQ_A57_7
elif [ "`grep "kernel.cpu.a57.min=600000" $USERPROP`" != "" ]; then
	echo "600000" > $CPU_MIN_FREQ_A57_4
	echo "600000" > $CPU_MIN_FREQ_A57_5
	echo "600000" > $CPU_MIN_FREQ_A57_6
	echo "600000" > $CPU_MIN_FREQ_A57_7
elif [ "`grep "kernel.cpu.a57.min=700000" $USERPROP`" != "" ]; then
	echo "700000" > $CPU_MIN_FREQ_A57_4
	echo "700000" > $CPU_MIN_FREQ_A57_5
	echo "700000" > $CPU_MIN_FREQ_A57_6
	echo "700000" > $CPU_MIN_FREQ_A57_7
elif [ "`grep "kernel.cpu.a57.min=800000" $USERPROP`" != "" ]; then
	echo "800000" > $CPU_MIN_FREQ_A57_4
	echo "800000" > $CPU_MIN_FREQ_A57_5
	echo "800000" > $CPU_MIN_FREQ_A57_6
	echo "800000" > $CPU_MIN_FREQ_A57_7
else
	echo "800000" > $CPU_MIN_FREQ_A57_4
	echo "800000" > $CPU_MIN_FREQ_A57_5
	echo "800000" > $CPU_MIN_FREQ_A57_6
	echo "800000" > $CPU_MIN_FREQ_A57_7
fi

sleep 1;

# a57-max
if [ "`grep "kernel.cpu.a57.max=1704000" $USERPROP`" != "" ]; then
	echo "1704000" > $CPU_MAX_FREQ_A57_4
	echo "1704000" > $CPU_MAX_FREQ_A57_5
	echo "1704000" > $CPU_MAX_FREQ_A57_6
	echo "1704000" > $CPU_MAX_FREQ_A57_7
elif [ "`grep "kernel.cpu.a57.max=1800000" $USERPROP`" != "" ]; then
	echo "1800000" > $CPU_MAX_FREQ_A57_4
	echo "1800000" > $CPU_MAX_FREQ_A57_5
	echo "1800000" > $CPU_MAX_FREQ_A57_6
	echo "1800000" > $CPU_MAX_FREQ_A57_7
elif [ "`grep "kernel.cpu.a57.max=1896000" $USERPROP`" != "" ]; then
	echo "1896000" > $CPU_MAX_FREQ_A57_4
	echo "1896000" > $CPU_MAX_FREQ_A57_5
	echo "1896000" > $CPU_MAX_FREQ_A57_6
	echo "1896000" > $CPU_MAX_FREQ_A57_7
elif [ "`grep "kernel.cpu.a57.max=2000000" $USERPROP`" != "" ]; then
	echo "2000000" > $CPU_MAX_FREQ_A57_4
	echo "2000000" > $CPU_MAX_FREQ_A57_5
	echo "2000000" > $CPU_MAX_FREQ_A57_6
	echo "2000000" > $CPU_MAX_FREQ_A57_7
elif [ "`grep "kernel.cpu.a57.max=2100000" $USERPROP`" != "" ]; then
	echo "2100000" > $CPU_MAX_FREQ_A57_4
	echo "2100000" > $CPU_MAX_FREQ_A57_5
	echo "2100000" > $CPU_MAX_FREQ_A57_6
	echo "2100000" > $CPU_MAX_FREQ_A57_7
elif [ "`grep "kernel.cpu.a57.max=2200000" $USERPROP`" != "" ]; then
	echo "2200000" > $CPU_MAX_FREQ_A57_4
	echo "2200000" > $CPU_MAX_FREQ_A57_5
	echo "2200000" > $CPU_MAX_FREQ_A57_6
	echo "2200000" > $CPU_MAX_FREQ_A57_7
elif [ "`grep "kernel.cpu.a57.max=2304000" $USERPROP`" != "" ]; then
	echo "2304000" > $CPU_MAX_FREQ_A57_4
	echo "2304000" > $CPU_MAX_FREQ_A57_5
	echo "2304000" > $CPU_MAX_FREQ_A57_6
	echo "2304000" > $CPU_MAX_FREQ_A57_7
else
	echo "2100000" > $CPU_MAX_FREQ_A57_4
	echo "2100000" > $CPU_MAX_FREQ_A57_5
	echo "2100000" > $CPU_MAX_FREQ_A57_6
	echo "2100000" > $CPU_MAX_FREQ_A57_7
fi

sleep 1;
###############################################################################
# Parse TCP Congestion Controller from prop

if [ "`grep "kernel.tcp.cong=bic" $USERPROP`" != "" ]; then
	echo "bic" > $TCP_CONG
elif [ "`grep "kernel.tcp.cong=cubic" $USERPROP`" != "" ]; then
	echo "cubic" > $TCP_CONG
elif [ "`grep "kernel.tcp.cong=westwood" $USERPROP`" != "" ]; then
	echo "westwood" > $TCP_CONG
elif [ "`grep "kernel.tcp.cong=hstcp" $USERPROP`" != "" ]; then
	echo "hstcp" > $TCP_CONG
elif [ "`grep "kernel.tcp.cong=hybla" $USERPROP`" != "" ]; then
	echo "hybla" > $TCP_CONG
elif [ "`grep "kernel.tcp.cong=htcp" $USERPROP`" != "" ]; then
	echo "htcp" > $TCP_CONG
else
	echo "bic" > $TCP_CONG
fi

sleep 1
###############################################################################
# Parse VM Tuning from prop

if [ "`grep "kernel.vm=tuned" $USERPROP`" != "" ]; then
	echo "200"	> /proc/sys/vm/vfs_cache_pressure
	echo "200"	> /proc/sys/vm/dirty_expire_centisecs
	echo "200"	> /proc/sys/vm/dirty_writeback_centisecs
	echo "135"	> /proc/sys/vm/swappiness
	echo "48"	> /sys/block/sda/queue/read_ahead_kb
	echo "48"	> /sys/block/sdb/queue/read_ahead_kb
	echo "48"	> /sys/block/sdb/queue/read_ahead_kb
	echo "48"	> /sys/block/vnswap0/queue/read_ahead_kb
fi

sleep 1
###############################################################################
# Parse Arch Power from prop

if [ "`grep "kernel.archpower=true" $USERPROP`" != "" ]; then
	echo "1" > $ARCH_POWER

elif [ "`grep "kernel.archpower=false" $USERPROP`" != "" ]; then
	echo "0" > $ARCH_POWER
else
	echo "1" > $ARCH_POWER
fi

sleep 1
###############################################################################
# Parse Gentle Fair Sleepers from prop

if [ "`grep "kernel.gentlefairsleepers=true" $USERPROP`" != "" ]; then
	echo "1" > $GENTLE_FAIR_SLEEPERS

elif [ "`grep "kernel.gentlefairsleepers=false" $USERPROP`" != "" ]; then
	echo "0" > $GENTLE_FAIR_SLEEPERS
else
	echo "1" > $GENTLE_FAIR_SLEEPERS
fi

sleep 1
###############################################################################
# Parse KNOX from prop

if [ "`grep "kernel.knox=false" $USERPROP`" != "" ]; then
	cd /system
	rm -rf *app/BBCAgent*
	rm -rf *app/Bridge*
	rm -rf *app/ContainerAgent*
	rm -rf *app/ContainerEventsRelayManager*
	rm -rf *app/DiagMonAgent*
	rm -rf *app/ELMAgent*
	rm -rf *app/FotaClient*
	rm -rf *app/FWUpdate*
	rm -rf *app/FWUpgrade*
	rm -rf *app/HLC*
	rm -rf *app/KLMSAgent*
	rm -rf *app/*Knox*
	rm -rf *app/*KNOX*
	rm -rf *app/LocalFOTA*
	rm -rf *app/RCPComponents*
	rm -rf *app/SecKids*;
	rm -rf *app/SecurityLogAgent*
	rm -rf *app/SPDClient*
	rm -rf *app/SyncmlDM*
	rm -rf *app/UniversalMDMClient*
	rm -rf container/*Knox*
	rm -rf container/*KNOX*
	cd /
	echo "KNOX was removed successful." >> $LOG
fi
###############################################################################
# Parse GApps wakelock fix from prop

if [ "`grep "kernel.gapps=true" $USERPROP`" != "" ]; then
	# Google Services battery drain fixer by Alcolawl@xda
	# http://forum.xda-developers.com/google-nexus-5/general/script-google-play-services-battery-t3059585/post59563859
	sleep 60
	pm enable com.google.android.gms/.update.SystemUpdateActivity
	pm enable com.google.android.gms/.update.SystemUpdateService
	pm enable com.google.android.gms/.update.SystemUpdateService$ActiveReceiver
	pm enable com.google.android.gms/.update.SystemUpdateService$Receiver
	pm enable com.google.android.gms/.update.SystemUpdateService$SecretCodeReceiver
	pm enable com.google.android.gsf/.update.SystemUpdateActivity
	pm enable com.google.android.gsf/.update.SystemUpdatePanoActivity
	pm enable com.google.android.gsf/.update.SystemUpdateService
	pm enable com.google.android.gsf/.update.SystemUpdateService$Receiver
	pm enable com.google.android.gsf/.update.SystemUpdateService$SecretCodeReceiver
	echo "GApps Fix applied." >> $LOG
fi

sleep 1
###############################################################################
# Script finish here, so let me know when

echo "" >> $LOG
echo "Done, Kernel Tuning finished." >> $LOG
echo "$DATE" >> $LOG
