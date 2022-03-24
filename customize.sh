ui_print " "

# info
MODVER=`grep_prop version $MODPATH/module.prop`
MODVERCODE=`grep_prop versionCode $MODPATH/module.prop`
ui_print " ID=$MODID"
ui_print " Version=$MODVER"
ui_print " VersionCode=$MODVERCODE"
ui_print " MagiskVersion=$MAGISK_VER"
ui_print " MagiskVersionCode=$MAGISK_VER_CODE"
ui_print " "

# sepolicy.rule
if [ "$BOOTMODE" != true ]; then
  mount -o rw -t auto /dev/block/bootdevice/by-name/persist /persist
  mount -o rw -t auto /dev/block/bootdevice/by-name/metadata /metadata
fi
FILE=$MODPATH/sepolicy.sh
DES=$MODPATH/sepolicy.rule
if [ -f $FILE ] && ! getprop | grep -Eq "sepolicy.sh\]: \[1"; then
  mv -f $FILE $DES
  sed -i 's/magiskpolicy --live "//g' $DES
  sed -i 's/"//g' $DES
fi

# .aml.sh
mv -f $MODPATH/aml.sh $MODPATH/.aml.sh

# cleaning
ui_print "- Cleaning..."
rm -f $MODPATH/LICENSE
rm -rf /metadata/magisk/$MODID
rm -rf /mnt/vendor/persist/magisk/$MODID
rm -rf /persist/magisk/$MODID
rm -rf /data/unencrypted/magisk/$MODID
rm -rf /cache/magisk/$MODID
ui_print " "

# primary
if getprop | grep -Eq "hires.primary\]: \[1"; then
  ui_print "- Enable Hi-Res to low latency playback (primary) output..."
  sed -i 's/#p//g' $MODPATH/.aml.sh
  sed -i 's/buffer/buffer and low latency/g' $MODPATH/module.prop
  ui_print " "
fi

# force 32
if getprop | grep -Eq "hires.32\]: \[1"; then
  ui_print "- Forcing audio format PCM to 32 bit instead of 24 bit..."
  sed -i 's/#h//g' $MODPATH/.aml.sh
  sed -i 's/#h//g' $MODPATH/service.sh
  sed -i 's/enforce_mode 24/enforce_mode 32/g' $MODPATH/service.sh
  sed -i 's/24 bit/32 bit/g' $MODPATH/module.prop
  ui_print " "
fi

# force float
if getprop | grep -Eq "hires.float\]: \[1"; then
  ui_print "- Enable audio format PCM float..."
  sed -i 's/#f//g' $MODPATH/.aml.sh
  sed -i 's/24 bit/24 bit and float/g' $MODPATH/module.prop
  sed -i 's/32 bit/32 bit and float/g' $MODPATH/module.prop
  ui_print " "
fi

# speaker 16
if getprop | grep -Eq "speaker.16\]: \[1"; then
  ui_print "- Forcing audio format PCM 16 bit to internal speaker..."
  sed -i 's/#s//g' $MODPATH/.aml.sh
  sed -i 's/playback/playback and low resolution to internal speaker/g' $MODPATH/module.prop
  ui_print " "
fi

# sampling rates
if getprop | grep -Eq "sample.rate\]: \[88"; then
  ui_print "- Forcing sample rate to 88200..."
  sed -i 's/|48000/|48000|88200/g' $MODPATH/.aml.sh
  sed -i 's/,48000/,48000,88200/g' $MODPATH/.aml.sh
  sed -i 's/bit/bit with sample rate 88200/g' $MODPATH/module.prop
  ui_print " "
elif getprop | grep -Eq "sample.rate\]: \[96"; then
  ui_print "- Forcing sample rate to 96000..."
  sed -i 's/|48000/|48000|88200|96000/g' $MODPATH/.aml.sh
  sed -i 's/,48000/,48000,88200,96000/g' $MODPATH/.aml.sh
  sed -i 's/bit/bit with sample rate 96000/g' $MODPATH/module.prop
  ui_print " "
elif getprop | grep -Eq "sample.rate\]: \[128"; then
  ui_print "- Forcing sample rate to 128000..."
  sed -i 's/|48000/|48000|88200|96000|128000/g' $MODPATH/.aml.sh
  sed -i 's/,48000/,48000,88200,96000,128000/g' $MODPATH/.aml.sh
  sed -i 's/bit/bit with sample rate 128000/g' $MODPATH/module.prop
  ui_print " "
elif getprop | grep -Eq "sample.rate\]: \[176"; then
  ui_print "- Forcing sample rate to 176400..."
  sed -i 's/|48000/|48000|88200|96000|128000|176400/g' $MODPATH/.aml.sh
  sed -i 's/,48000/,48000,88200,96000,128000,176400/g' $MODPATH/.aml.sh
  sed -i 's/bit/bit with sample rate 192000/g' $MODPATH/module.prop
  ui_print " "
elif getprop | grep -Eq "sample.rate\]: \[192"; then
  ui_print "- Forcing sample rate to 192000..."
  sed -i 's/|48000/|48000|88200|96000|128000|176400|192000/g' $MODPATH/.aml.sh
  sed -i 's/,48000/,48000,88200,96000,128000,176400,192000/g' $MODPATH/.aml.sh
  sed -i 's/bit/bit with sample rate 192000/g' $MODPATH/module.prop
  ui_print " "
elif getprop | grep -Eq "sample.rate\]: \[352"; then
  ui_print "- Forcing sample rate to 352800..."
  sed -i 's/|48000/|48000|88200|96000|128000|176400|192000|352800/g' $MODPATH/.aml.sh
  sed -i 's/,48000/,48000,88200,96000,128000,176400,192000,352800/g' $MODPATH/.aml.sh
  sed -i 's/bit/bit with sample rate 352800/g' $MODPATH/module.prop
  ui_print " "
elif getprop | grep -Eq "sample.rate\]: \[384"; then
  ui_print "- Forcing sample rate to 384000..."
  sed -i 's/|48000/|48000|88200|96000|128000|176400|192000|352800|384000/g' $MODPATH/.aml.sh
  sed -i 's/,48000/,48000,88200,96000,128000,176400,192000,352800,384000/g' $MODPATH/.aml.sh
  sed -i 's/bit/bit with sample rate 354000/g' $MODPATH/module.prop
  ui_print " "
fi

# permission
ui_print "- Setting permission..."
DIR=`find $MODPATH/system/vendor -type d`
for DIRS in $DIR; do
  chown 0.2000 $DIRS
done
if [ "$API" -gt 25 ]; then
  magiskpolicy "dontaudit { vendor_file vendor_configs_file } labeledfs filesystem associate"
  magiskpolicy "allow     { vendor_file vendor_configs_file } labeledfs filesystem associate"
  magiskpolicy "dontaudit init { vendor_file vendor_configs_file } dir relabelfrom"
  magiskpolicy "allow     init { vendor_file vendor_configs_file } dir relabelfrom"
  magiskpolicy "dontaudit init { vendor_file vendor_configs_file } file relabelfrom"
  magiskpolicy "allow     init { vendor_file vendor_configs_file } file relabelfrom"
  chcon -R u:object_r:vendor_file:s0 $MODPATH/system/vendor
  chcon -R u:object_r:vendor_configs_file:s0 $MODPATH/system/vendor/etc
  chcon -R u:object_r:vendor_configs_file:s0 $MODPATH/system/vendor/odm/etc
fi
ui_print " "



