# space
if [ "$BOOTMODE" == true ]; then
  ui_print " "
fi

# magisk
if [ -d /sbin/.magisk ]; then
  MAGISKTMP=/sbin/.magisk
else
  MAGISKTMP=`realpath /dev/*/.magisk`
fi

# path
if [ "$BOOTMODE" == true ]; then
  MIRROR=$MAGISKTMP/mirror
else
  MIRROR=
fi
SYSTEM=`realpath $MIRROR/system`
PRODUCT=`realpath $MIRROR/product`
VENDOR=`realpath $MIRROR/vendor`
SYSTEM_EXT=`realpath $MIRROR/system_ext`
if [ -d $MIRROR/odm ]; then
  ODM=`realpath $MIRROR/odm`
else
  ODM=`realpath /odm`
fi
if [ -d $MIRROR/my_product ]; then
  MY_PRODUCT=`realpath $MIRROR/my_product`
else
  MY_PRODUCT=`realpath /my_product`
fi

# optionals
OPTIONALS=/sdcard/optionals.prop

# info
MODVER=`grep_prop version $MODPATH/module.prop`
MODVERCODE=`grep_prop versionCode $MODPATH/module.prop`
ui_print " ID=$MODID"
ui_print " Version=$MODVER"
ui_print " VersionCode=$MODVERCODE"
ui_print " MagiskVersion=$MAGISK_VER"
ui_print " MagiskVersionCode=$MAGISK_VER_CODE"
ui_print " "

# mount
if [ "$BOOTMODE" != true ]; then
  mount -o rw -t auto /dev/block/bootdevice/by-name/cust /vendor
  mount -o rw -t auto /dev/block/bootdevice/by-name/vendor /vendor
  mount -o rw -t auto /dev/block/bootdevice/by-name/persist /persist
  mount -o rw -t auto /dev/block/bootdevice/by-name/metadata /metadata
fi

# sepolicy.rule
FILE=$MODPATH/sepolicy.sh
DES=$MODPATH/sepolicy.rule
if [ "`grep_prop sepolicy.sh $OPTIONALS`" != 1 ]\
&& [ -f $FILE ]; then
  mv -f $FILE $DES
  sed -i 's/magiskpolicy --live "//g' $DES
  sed -i 's/"//g' $DES
fi

# .aml.sh
mv -f $MODPATH/aml.sh $MODPATH/.aml.sh

# cleaning
ui_print "- Cleaning..."
rm -rf /metadata/magisk/$MODID
rm -rf /mnt/vendor/persist/magisk/$MODID
rm -rf /persist/magisk/$MODID
rm -rf /data/unencrypted/magisk/$MODID
rm -rf /cache/magisk/$MODID
ui_print " "

# pcm
if [ "`grep_prop hires.pcm $OPTIONALS`" == 0 ]; then
  ui_print "- Disable audio format PCM patches & only using system"
  ui_print "  property & audio platform info patches..."
  ui_print " "
else
  sed -i 's/#c//g' $MODPATH/.aml.sh
fi

# primary
if [ "`grep_prop hires.primary $OPTIONALS`" == 1 ]\
&& [ "`grep_prop hires.pcm $OPTIONALS`" != 0 ]; then
  ui_print "- Enable Hi-Res to low latency playback (primary) output..."
  sed -i 's/#p//g' $MODPATH/.aml.sh
  sed -i 's/buffer/buffer and low latency/g' $MODPATH/module.prop
  ui_print " "
fi

# force 32
if [ "`grep_prop hires.32 $OPTIONALS`" == 1 ]; then
  ui_print "- Forcing audio format PCM to 32 bit instead of 24 bit..."
  sed -i 's/#32//g' $MODPATH/.aml.sh
  sed -i 's/#32//g' $MODPATH/service.sh
  sed -i 's/enforce_mode 24/enforce_mode 32/g' $MODPATH/service.sh
  sed -i 's/24 bit/32 bit/g' $MODPATH/module.prop
  ui_print " "
fi

# force float
if [ "`grep_prop hires.float $OPTIONALS`" == 1 ]\
&& [ "`grep_prop hires.pcm $OPTIONALS`" != 0 ]; then
  ui_print "- Enable audio format PCM float..."
  sed -i 's/#f//g' $MODPATH/.aml.sh
  sed -i 's/24 bit/24 bit and float/g' $MODPATH/module.prop
  sed -i 's/32 bit/32 bit and float/g' $MODPATH/module.prop
  ui_print " "
fi

# speaker
if [ "`grep_prop speaker.bit $OPTIONALS`" == 16 ]; then
  ui_print "- Forcing audio format PCM 16 bit to internal speaker..."
  sed -i 's/#s16//g' $MODPATH/.aml.sh
  sed -i 's/playback/playback and low resolution to internal speaker/g' $MODPATH/module.prop
  ui_print " "
elif [ "`grep_prop hires.32 $OPTIONALS`" == 1 ]\
&& [ "`grep_prop speaker.bit $OPTIONALS`" == 24 ]; then
  ui_print "- Forcing audio format PCM 24 bit to internal speaker..."
  sed -i 's/#s24//g' $MODPATH/.aml.sh
  sed -i 's/playback/playback and 24 bit to internal speaker/g' $MODPATH/module.prop
  ui_print " "
fi

# sampling rates
if [ "`grep_prop sample.rate $OPTIONALS`" == 44 ]\
&& [ "`grep_prop hires.pcm $OPTIONALS`" != 0 ]; then
  ui_print "- Forcing sample rate to 44100..."
  sed -i 's/|48000//g' $MODPATH/.aml.sh
  sed -i 's/,48000//g' $MODPATH/.aml.sh
  sed -i 's/bit/bit with sample rate 44100/g' $MODPATH/module.prop
  ui_print " "
elif [ "`grep_prop sample.rate $OPTIONALS`" == 88 ]\
&& [ "`grep_prop hires.pcm $OPTIONALS`" != 0 ]; then
  ui_print "- Forcing sample rate to 88200..."
  sed -i 's/|48000/|48000|88200/g' $MODPATH/.aml.sh
  sed -i 's/,48000/,48000,88200/g' $MODPATH/.aml.sh
  sed -i 's/bit/bit with sample rate 88200/g' $MODPATH/module.prop
  ui_print " "
elif [ "`grep_prop sample.rate $OPTIONALS`" == 96 ]\
&& [ "`grep_prop hires.pcm $OPTIONALS`" != 0 ]; then
  ui_print "- Forcing sample rate to 96000..."
  sed -i 's/|48000/|48000|88200|96000/g' $MODPATH/.aml.sh
  sed -i 's/,48000/,48000,88200,96000/g' $MODPATH/.aml.sh
  sed -i 's/bit/bit with sample rate 96000/g' $MODPATH/module.prop
  ui_print " "
elif [ "`grep_prop sample.rate $OPTIONALS`" == 128 ]\
&& [ "`grep_prop hires.pcm $OPTIONALS`" != 0 ]; then
  ui_print "- Forcing sample rate to 128000..."
  sed -i 's/|48000/|48000|88200|96000|128000/g' $MODPATH/.aml.sh
  sed -i 's/,48000/,48000,88200,96000,128000/g' $MODPATH/.aml.sh
  sed -i 's/bit/bit with sample rate 128000/g' $MODPATH/module.prop
  ui_print " "
elif [ "`grep_prop sample.rate $OPTIONALS`" == 176 ]\
&& [ "`grep_prop hires.pcm $OPTIONALS`" != 0 ]; then
  ui_print "- Forcing sample rate to 176400..."
  sed -i 's/|48000/|48000|88200|96000|128000|176400/g' $MODPATH/.aml.sh
  sed -i 's/,48000/,48000,88200,96000,128000,176400/g' $MODPATH/.aml.sh
  sed -i 's/bit/bit with sample rate 192000/g' $MODPATH/module.prop
  ui_print " "
elif [ "`grep_prop sample.rate $OPTIONALS`" == 192 ]\
&& [ "`grep_prop hires.pcm $OPTIONALS`" != 0 ]; then
  ui_print "- Forcing sample rate to 192000..."
  sed -i 's/|48000/|48000|88200|96000|128000|176400|192000/g' $MODPATH/.aml.sh
  sed -i 's/,48000/,48000,88200,96000,128000,176400,192000/g' $MODPATH/.aml.sh
  sed -i 's/bit/bit with sample rate 192000/g' $MODPATH/module.prop
  ui_print " "
elif [ "`grep_prop sample.rate $OPTIONALS`" == 352 ]\
&& [ "`grep_prop hires.pcm $OPTIONALS`" != 0 ]; then
  ui_print "- Forcing sample rate to 352800..."
  sed -i 's/|48000/|48000|88200|96000|128000|176400|192000|352800/g' $MODPATH/.aml.sh
  sed -i 's/,48000/,48000,88200,96000,128000,176400,192000,352800/g' $MODPATH/.aml.sh
  sed -i 's/bit/bit with sample rate 352800/g' $MODPATH/module.prop
  ui_print " "
elif [ "`grep_prop sample.rate $OPTIONALS`" == 384 ]\
&& [ "`grep_prop hires.pcm $OPTIONALS`" != 0 ]; then
  ui_print "- Forcing sample rate to 384000..."
  sed -i 's/|48000/|48000|88200|96000|128000|176400|192000|352800|384000/g' $MODPATH/.aml.sh
  sed -i 's/,48000/,48000,88200,96000,128000,176400,192000,352800,384000/g' $MODPATH/.aml.sh
  sed -i 's/bit/bit with sample rate 354000/g' $MODPATH/module.prop
  ui_print " "
fi

# other
FILE=$MODPATH/service.sh
if [ "`grep_prop other.etc $OPTIONALS`" == 1 ]; then
  ui_print "- Activating other etc files bind mount..."
  sed -i 's/#p//g' $FILE
  ui_print " "
fi

# permission
if [ "$API" -ge 26 ]; then
  ui_print "- Setting permission..."
  DIR=`find $MODPATH/system/vendor -type d`
  for DIRS in $DIR; do
    chown 0.2000 $DIRS
  done
  ui_print " "
fi


