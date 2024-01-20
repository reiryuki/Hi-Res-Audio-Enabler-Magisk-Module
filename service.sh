MODPATH=${0%/*}

# log
exec 2>$MODPATH/debug.log
set -x

# var
API=`getprop ro.build.version.sdk`

# property
#32resetprop -n vendor.audio.flac.sw.decoder.32bit true
resetprop -n vendor.audio.flac.sw.decoder.24bit true
#32resetprop -n audio.offload.pcm.32bit.enabled true
resetprop -n audio.offload.pcm.24bit.enabled true
resetprop -n audio.offload.pcm.16bit.enabled true
resetprop -p --delete persist.vendor.audio_hal.dsp_bit_width_enforce_mode
resetprop -n persist.vendor.audio_hal.dsp_bit_width_enforce_mode 24

# restart
if [ "$API" -ge 24 ]; then
  SERVER=audioserver
else
  SERVER=mediaserver
fi
killall $SERVER\
 android.hardware.audio@4.0-service-mediatek

# wait
sleep 20

# aml fix
AML=/data/adb/modules/aml
if [ -L $AML/system/vendor ]\
&& [ -d $AML/vendor ]; then
  DIR=$AML/vendor/odm/etc
else
  DIR=$AML/system/vendor/odm/etc
fi
if [ "$API" -ge 26 ] && [ -d $DIR ]\
&& [ ! -f $AML/disable ]; then
  chcon -R u:object_r:vendor_configs_file:s0 $DIR
fi
AUD=`grep AUD= $MODPATH/copy.sh | sed -e 's|AUD=||g' -e 's|"||g'`
if [ -L $AML/system/vendor ]\
&& [ -d $AML/vendor ]; then
  DIR=$AML/vendor
else
  DIR=$AML/system/vendor
fi
FILES=`find $DIR -type f -name $AUD`
if [ -d $AML ] && [ ! -f $AML/disable ]\
&& find $DIR -type f -name $AUD; then
  if ! grep '/odm' $AML/post-fs-data.sh && [ -d /odm ]\
  && [ "`realpath /odm/etc`" == /odm/etc ]; then
    for FILE in $FILES; do
      DES=/odm`echo $FILE | sed "s|$DIR||g"`
      if [ -f $DES ]; then
        umount $DES
        mount -o bind $FILE $DES
      fi
    done
  fi
  if ! grep '/my_product' $AML/post-fs-data.sh\
  && [ -d /my_product ]; then
    for FILE in $FILES; do
      DES=/my_product`echo $FILE | sed "s|$DIR||g"`
      if [ -f $DES ]; then
        umount $DES
        mount -o bind $FILE $DES
      fi
    done
  fi
fi

# audio flinger
DMAF=`dumpsys media.audio_flinger`










