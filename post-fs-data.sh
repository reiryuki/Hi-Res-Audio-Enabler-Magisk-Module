mount -o rw,remount /data
MODPATH=${0%/*}

# log
exec 2>$MODPATH/debug-pfsd.log
set -x

# var
API=`getprop ro.build.version.sdk`
ABI=`getprop ro.product.cpu.abi`
if [ ! -d $MODPATH/vendor ]\
|| [ -L $MODPATH/vendor ]; then
  MODSYSTEM=/system
fi

# run
. $MODPATH/copy.sh
. $MODPATH/.aml.sh

# permission
if [ "$API" -ge 26 ]; then
  DIRS=`find $MODPATH/vendor\
             $MODPATH/system/vendor -type d`
  for DIR in $DIRS; do
    chown 0.2000 $DIR
  done
  chcon -R u:object_r:vendor_configs_file:s0 $MODPATH/system/odm/etc
  chcon -R u:object_r:vendor_file:s0 $MODPATH$MODSYSTEM/vendor
  chcon -R u:object_r:vendor_configs_file:s0 $MODPATH$MODSYSTEM/vendor/etc
  chcon -R u:object_r:vendor_configs_file:s0 $MODPATH$MODSYSTEM/vendor/odm/etc
fi

# function
mount_odm() {
DIR=$MODPATH/system/odm
FILES=`find $DIR -type f -name $AUD`
for FILE in $FILES; do
  DES=/odm`echo $FILE | sed "s|$DIR||g"`
  if [ -f $DES ]; then
    umount $DES
    mount -o bind $FILE $DES
  fi
done
}
mount_my_product() {
DIR=$MODPATH/system/my_product
FILES=`find $DIR -type f -name $AUD`
for FILE in $FILES; do
  DES=/my_product`echo $FILE | sed "s|$DIR||g"`
  if [ -f $DES ]; then
    umount $DES
    mount -o bind $FILE $DES
  fi
done
}

# mount
if [ -d /odm ] && [ "`realpath /odm/etc`" == /odm/etc ]\
&& ! grep /odm /data/adb/magisk/magisk\
&& ! grep /odm /data/adb/magisk/magisk64\
&& ! grep /odm /data/adb/magisk/magisk32; then
  mount_odm
fi
if [ -d /my_product ]\
&& ! grep /my_product /data/adb/magisk/magisk\
&& ! grep /my_product /data/adb/magisk/magisk64\
&& ! grep /my_product /data/adb/magisk/magisk32; then
  mount_my_product
fi











