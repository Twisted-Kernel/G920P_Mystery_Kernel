#!/system/xbin/busybox sh

# Kernel Profile Script

USERPROP=/data/media/0/mystery-kernel/kernel.prop
PROFILE=/data/media/0/mystery-kernel/kernel-profile.prop

$BB mount -t rootfs -o remount,rw rootfs;
$BB mount -o remount,rw /system;
$BB mount -o remount,rw /data;

###############################################################################
# Battery
if [ "`grep "kernel_profile=battery" $PROFILE`" != "" ]; then
	sed -i -e '/kernel.turbo/c\kernel.turbo=false' $USERPROP;
	sed -i -e '/kernel.initd/c\kernel.initd=true' $USERPROP;
	sed -i -e '/kernel.interactive/c\kernel.interactive=battery' $USERPROP;
	sed -i -e '/kernel.scheduler/c\kernel.scheduler=row' $USERPROP;
	sed -i -e '/kernel.governor/c\kernel.governor=interactive' $USERPROP;
	sed -i -e '/kernel.cpu.a53.min/c\kernel.cpu.a53.min=400000' $USERPROP;
	sed -i -e '/kernel.cpu.a53.max/c\kernel.cpu.a53.max=1200000' $USERPROP;
	sed -i -e '/kernel.cpu.a57.min/c\kernel.cpu.a57.min=400000' $USERPROP;
	sed -i -e '/kernel.cpu.a57.max/c\kernel.cpu.a57.max=1896000' $USERPROP;
	sed -i -e '/kernel.tcp.cong/c\kernel.tcp.cong=westwood' $USERPROP;
	sed -i -e '/kernel.vm/c\kernel.vm=battery' $USERPROP;
	sed -i -e '/kernel.archpower/c\kernel.archpower=false' $USERPROP;
	sed -i -e '/kernel.gentlefairsleepers/c\kernel.gentlefairsleepers=false' $USERPROP;
	sed -i -e '/kernel.gapps/c\kernel.gapps=true' $USERPROP;
	sed -i -e '/kernel.knox/c\kernel.knox=false' $USERPROP;
else
	echo "kernel.turbo=false" > $USERPROP;
	echo "kernel.initd=true" > $USERPROP;
	echo "kernel.interactive=battery" > $USERPROP;
	echo "kernel.scheduler=row" > $USERPROP;
	echo "kernel.governor=interactive" > $USERPROP;
	echo "kernel.cpu.a53.min=400000" > $USERPROP;
	echo "kernel.cpu.a53.max=1200000" > $USERPROP;
	echo "kernel.cpu.a57.min=400000" > $USERPROP;
	echo "kernel.cpu.a57.max=1896000" > $USERPROP;
	echo "kernel.tcp.cong=westwood" > $USERPROP;
	echo "kernel.vm=battery" > $USERPROP;
	echo "kernel.archpower=false" > $USERPROP;
	echo "kernel.gentlefairsleepers=false" > $USERPROP;
	echo "kernel.gapps=true" > $USERPROP;
	echo "kernel.knox=false" > $USERPROP;
fi

###############################################################################
# Performance
if [ "`grep "kernel_profile=performance" $PROFILE`" != "" ]; then
	sed -i -e '/kernel.turbo/c\kernel.turbo=true' $USERPROP;
	sed -i -e '/kernel.initd/c\kernel.initd=true' $USERPROP;
	sed -i -e '/kernel.interactive/c\kernel.interactive=performance' $USERPROP;
	sed -i -e '/kernel.scheduler/c\kernel.scheduler=deadline' $USERPROP;
	sed -i -e '/kernel.governor/c\kernel.governor=interactive' $USERPROP;
	sed -i -e '/kernel.cpu.a53.min/c\kernel.cpu.a53.min=400000' $USERPROP;
	sed -i -e '/kernel.cpu.a53.max/c\kernel.cpu.a53.max=1600000' $USERPROP;
	sed -i -e '/kernel.cpu.a57.min/c\kernel.cpu.a57.min=800000' $USERPROP;
	sed -i -e '/kernel.cpu.a57.max/c\kernel.cpu.a57.max=2304000' $USERPROP;
	sed -i -e '/kernel.tcp.cong/c\kernel.tcp.cong=westwood' $USERPROP;
	sed -i -e '/kernel.vm/c\kernel.vm=tuned' $USERPROP;
	sed -i -e '/kernel.archpower/c\kernel.archpower=true' $USERPROP;
	sed -i -e '/kernel.gentlefairsleepers/c\kernel.gentlefairsleepers=false' $USERPROP;
	sed -i -e '/kernel.gapps/c\kernel.gapps=true' $USERPROP;
	sed -i -e '/kernel.knox/c\kernel.knox=false' $USERPROP;
else
	echo "kernel.turbo=true" > $USERPROP;
	echo "kernel.initd=true" > $USERPROP;
	echo "kernel.interactive=performance" > $USERPROP;
	echo "kernel.scheduler=deadline" > $USERPROP;
	echo "kernel.governor=interactive" > $USERPROP;
	echo "kernel.cpu.a53.min=400000" > $USERPROP;
	echo "kernel.cpu.a53.max=1600000" > $USERPROP;
	echo "kernel.cpu.a57.min=800000" > $USERPROP;
	echo "kernel.cpu.a57.max=2304000" > $USERPROP;
	echo "kernel.tcp.cong=westwood" > $USERPROP;
	echo "kernel.vm=tuned" > $USERPROP;
	echo "kernel.archpower=true" > $USERPROP;
	echo "kernel.gentlefairsleepers=false" > $USERPROP;
	echo "kernel.gapps=true" > $USERPROP;
	echo "kernel.knox=false" > $USERPROP;
fi

###############################################################################
# Stock
if [ "`grep "kernel_profile=stock" $PROFILE`" != "" ]; then
	sed -i -e '/kernel.turbo/c\kernel.turbo=false' $USERPROP;
	sed -i -e '/kernel.initd/c\kernel.initd=true' $USERPROP;
	sed -i -e '/kernel.interactive/c\kernel.interactive=stock' $USERPROP;
	sed -i -e '/kernel.scheduler/c\kernel.scheduler=cfq' $USERPROP;
	sed -i -e '/kernel.governor/c\kernel.governor=interactive' $USERPROP;
	sed -i -e '/kernel.cpu.a53.min/c\kernel.cpu.a53.min=400000' $USERPROP;
	sed -i -e '/kernel.cpu.a53.max/c\kernel.cpu.a53.max=1500000' $USERPROP;
	sed -i -e '/kernel.cpu.a57.min/c\kernel.cpu.a57.min=800000' $USERPROP;
	sed -i -e '/kernel.cpu.a57.max/c\kernel.cpu.a57.max=2100000' $USERPROP;
	sed -i -e '/kernel.tcp.cong/c\kernel.tcp.cong=westwood' $USERPROP;
	sed -i -e '/kernel.vm/c\kernel.vm=stock' $USERPROP;
	sed -i -e '/kernel.archpower/c\kernel.archpower=true' $USERPROP;
	sed -i -e '/kernel.gentlefairsleepers/c\kernel.gentlefairsleepers=true' $USERPROP;
	sed -i -e '/kernel.gapps/c\kernel.gapps=true' $USERPROP;
	sed -i -e '/kernel.knox/c\kernel.knox=false' $USERPROP;
else
	echo "kernel.turbo=false" > $USERPROP;
	echo "kernel.initd=true" > $USERPROP;
	echo "kernel.interactive=stock" > $USERPROP;
	echo "kernel.scheduler=cfq" > $USERPROP;
	echo "kernel.governor=interactive" > $USERPROP;
	echo "kernel.cpu.a53.min=400000" > $USERPROP;
	echo "kernel.cpu.a53.max=1500000" > $USERPROP;
	echo "kernel.cpu.a57.min=800000" > $USERPROP;
	echo "kernel.cpu.a57.max=2100000" > $USERPROP;
	echo "kernel.tcp.cong=westwood" > $USERPROP;
	echo "kernel.vm=stock" > $USERPROP;
	echo "kernel.archpower=true" > $USERPROP;
	echo "kernel.gentlefairsleepers=true" > $USERPROP;
	echo "kernel.gapps=true" > $USERPROP;
	echo "kernel.knox=false" > $USERPROP;
fi

$BB mount -t rootfs -o remount,ro rootfs;
$BB mount -o remount,ro /system;
$BB mount -o remount,rw /data;
