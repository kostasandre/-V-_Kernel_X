#!/system/bin/sh

# -V- Kernel X main script file
# Written for -V- Kernel X by Vagelis1608 @xda-developers

# Variables
# Busybox build by osm0sis @xda-developers
BB=/sbin/bb/busybox
PROP=/data/vkx.prop

# Create the properties file, if missing, then set permissions/owner.
if [ ! -e $PROP ]; then
    touch $PROP
    echo "# Properties file for -V- Kernel X" > $PROP
    echo "" >> $PROP
fi
chmod 644 $PROP
chown root.root $PROP

# Grab properties
gprop() { $BB grep "^$1" "$PROP" | $BB cut -d= -f2; }

MPDS=`gprop persist.mpdecision.stop`
if [ -z $MPDS ]; then
    echo "persist.mpdecision.stop=1" >> $PROP
    MPDS=1
fi

# Force stop MPDecision if the prop persist.mpdecision.stop is set to 1
if [ "$MPDS" == "1" ]; then
    setprop ctl.stop mpdecision
    stop mpdecision
    if [ -e /system/bin/mpdecision ]; then
        mount -t auto -o rw,remount /system
        $BB cp -af /system/bin/mpdecision /system/bin/mpdecision-dis
        $BB rm -f /system/bin/mpdecision
        mount -t auto -o ro,remount /system
    fi
elif [ "$MPDS" == "0" -a -e /system/bin/mpdecision-dis ]; then
        mount -t auto -o rw,remount /system
        $BB cp -af /system/bin/mpdecision-dis /system/bin/mpdecision
        $BB rm -f /system/bin/mpdecision-dis
        mount -t auto -o ro,remount /system        
fi

