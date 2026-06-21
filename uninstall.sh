mount -o rw,remount /data
[ ! "$MODPATH" ] && MODPATH=${0%/*}
[ ! "$MODID" ] && MODID=`basename "$MODPATH"`
UID=`id -u`
[ ! "$UID" ] && UID=0

# log
DIR=/data/adb/logs
mkdir -p $DIR
exec 2>$DIR/$MODID\_uninstall.log
set -x

# run
. $MODPATH/function.sh

# cleaning
resetprop -p --delete persist.vendor.audio_hal.dsp_bit_width_enforce_mode
remove_sepolicy_rule









