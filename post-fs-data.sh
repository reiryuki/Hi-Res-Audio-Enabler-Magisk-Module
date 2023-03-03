mount -o rw,remount /data
MODPATH=${0%/*}
API=`getprop ro.build.version.sdk`
AML=/data/adb/modules/aml

# debug
exec 2>$MODPATH/debug-pfsd.log
set -x

# run
FILE=$MODPATH/sepolicy.pfsd
if [ -f $FILE ]; then
  magiskpolicy --live --apply $FILE
fi

# context
if [ "$API" -ge 26 ]; then
  chcon -R u:object_r:vendor_file:s0 $MODPATH/system/vendor
  chcon -R u:object_r:vendor_configs_file:s0 $MODPATH/system/vendor/etc
  chcon -R u:object_r:vendor_configs_file:s0 $MODPATH/system/vendor/odm/etc
  chcon -R u:object_r:vendor_configs_file:s0 $MODPATH/system/odm/etc
fi

# magisk
if [ -d /sbin/.magisk ]; then
  MAGISKTMP=/sbin/.magisk
else
  MAGISKTMP=`realpath /dev/*/.magisk`
fi

# path
MIRROR=$MAGISKTMP/mirror
SYSTEM=`realpath $MIRROR/system`
VENDOR=`realpath $MIRROR/vendor`
ODM=`realpath $MIRROR/odm`
MY_PRODUCT=`realpath $MIRROR/my_product`
ETC=$SYSTEM/etc
VETC=$VENDOR/etc
VOETC=$VENDOR/odm/etc
OETC=$ODM/etc
MPETC=$MY_PRODUCT/etc
MODETC=$MODPATH/system/etc
MODVETC=$MODPATH/system/vendor/etc
MODVOETC=$MODPATH/system/vendor/odm/etc
MODOETC=$MODPATH/system/odm/etc
MODMPETC=$MODPATH/system/my_product/etc

# directory
SKU=`ls $VETC/audio | grep sku_`
if [ "$SKU" ]; then
  for SKUS in $SKU; do
    mkdir -p $MODVETC/audio/$SKUS
  done
fi
PROP=`getprop ro.build.product`
if [ -d $VETC/audio/"$PROP" ]; then
  mkdir -p $MODVETC/audio/"$PROP"
fi

# audio files
NAME="*policy*.conf -o -name *policy*.xml -o -name *audio*platform*info*.xml -o -name *mixer*paths*.xml"
rm -f `find $MODPATH/system -type f -name $NAME`
A=`find $ETC -maxdepth 1 -type f -name $NAME`
VA=`find $VETC -maxdepth 1 -type f -name $NAME`
VOA=`find $VOETC -maxdepth 1 -type f -name $NAME`
VAA=`find $VETC/audio -maxdepth 1 -type f -name $NAME`
VBA=`find $VETC/audio/"$PROP" -maxdepth 1 -type f -name $NAME`
OA=`find $OETC -maxdepth 1 -type f -name $NAME`
MPA=`find $MPETC -maxdepth 1 -type f -name $NAME`
if [ "$A" ]; then
  cp -f $A $MODETC
fi
if [ "$VA" ]; then
  cp -f $VA $MODVETC
fi
if [ "$VOA" ]; then
  cp -f $VOA $MODVOETC
fi
if [ "$VAA" ]; then
  cp -f $VAA $MODVETC/audio
fi
if [ "$VBA" ]; then
  cp -f $VBA $MODVETC/audio/"$PROP"
fi
if [ "$SKU" ]; then
  for SKUS in $SKU; do
    VSA=`find $VETC/audio/$SKUS -maxdepth 1 -type f -name $NAME`
    if [ "$VSA" ]; then
      cp -f $VSA $MODVETC/audio/$SKUS
    fi
  done
fi
if [ "$OA" ]; then
  cp -f $OA $MODOETC
fi
if [ "$MPA" ]; then
  cp -f $MPA $MODMPETC
fi
if [ ! -d $ODM ]\
&& [ "`realpath /odm/etc`" == /odm/etc ]; then
  OA=`find /odm/etc -maxdepth 1 -type f -name $NAME`
  if [ "$OA" ]; then
    cp -f $OA $MODVETC
  fi
fi
if [ ! -d $MY_PRODUCT ] && [ -d /my_product/etc ]; then
  MPA=`find /my_product/etc -maxdepth 1 -type f -name $NAME`
  if [ "$MPA" ]; then
    cp -f $MPA $MODVETC
  fi
fi
rm -f `find $MODPATH/system -type f -name *policy*volume*.xml`

# run
. $MODPATH/.aml.sh





