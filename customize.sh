# space
ui_print " "

# var
UID=`id -u`

# log
if [ "$BOOTMODE" != true ]; then
  FILE=/data/media/"$UID"/$MODID\_recovery.log
  ui_print "- Log will be saved at $FILE"
  exec 2>$FILE
  ui_print " "
fi

# optionals
OPTIONALS=/data/media/"$UID"/optionals.prop
if [ ! -f $OPTIONALS ]; then
  touch $OPTIONALS
fi

# debug
if [ "`grep_prop debug.log $OPTIONALS`" == 1 ]; then
  ui_print "- The install log will contain detailed information"
  set -x
  ui_print " "
fi

# run
. $MODPATH/function.sh

# info
MODVER=`grep_prop version $MODPATH/module.prop`
MODVERCODE=`grep_prop versionCode $MODPATH/module.prop`
ui_print " ID=$MODID"
ui_print " Version=$MODVER"
ui_print " VersionCode=$MODVERCODE"
if [ "$KSU" == true ]; then
  ui_print " KSUVersion=$KSU_VER"
  ui_print " KSUVersionCode=$KSU_VER_CODE"
  ui_print " KSUKernelVersionCode=$KSU_KERNEL_VER_CODE"
  sed -i 's|#k||g' $MODPATH/post-fs-data.sh
else
  ui_print " MagiskVersion=$MAGISK_VER"
  ui_print " MagiskVersionCode=$MAGISK_VER_CODE"
fi
ui_print " "

# sepolicy
FILE=$MODPATH/sepolicy.rule
DES=$MODPATH/sepolicy.pfsd
if [ "`grep_prop sepolicy.sh $OPTIONALS`" == 1 ]\
&& [ -f $FILE ]; then
  mv -f $FILE $DES
fi

# .aml.sh
mv -f $MODPATH/aml.sh $MODPATH/.aml.sh

# cleaning
ui_print "- Cleaning..."
remove_sepolicy_rule
ui_print " "

# pcm
if [ "`grep_prop hires.pcm $OPTIONALS`" == 1 ]; then
  ui_print "- Enables audio format PCM patch to deep buffer playback"
  ui_print "  Probably doesn't work in Android 13 (SDK 33) and above"
  ui_print "  and produce bugs in some devices"
  sed -i 's/#c//g' $MODPATH/.aml.sh
  ui_print " "
fi

# primary
if [ "`grep_prop hires.primary $OPTIONALS`" == 1 ]\
&& [ "`grep_prop hires.pcm $OPTIONALS`" == 1 ]; then
  ui_print "- Enables audio format PCM patch to low latency playback (primary output) also"
  sed -i 's/#p//g' $MODPATH/.aml.sh
  ui_print " "
fi

# force 32
if [ "`grep_prop hires.32 $OPTIONALS`" == 1 ]; then
  ui_print "- Enables 32 bit width instead of 24 bit width"
  sed -i 's/#32//g' $MODPATH/.aml.sh
  sed -i 's/#32//g' $MODPATH/service.sh
  sed -i 's/enforce_mode 24/enforce_mode 32/g' $MODPATH/service.sh
  sed -i 's/24 bit width/32 bit width/g' $MODPATH/module.prop
  ui_print " "
fi

# force float
if [ "`grep_prop hires.float $OPTIONALS`" == 1 ]\
&& [ "`grep_prop hires.pcm $OPTIONALS`" == 1 ]; then
  ui_print "- Enables audio format PCM float patch"
  sed -i 's/#f//g' $MODPATH/.aml.sh
  ui_print " "
fi

# speaker
if [ "`grep_prop speaker.bit $OPTIONALS`" == 16 ]; then
  ui_print "- Forces 16 bit width to internal speaker"
  sed -i 's/#s16//g' $MODPATH/.aml.sh
  ui_print " "
elif [ "`grep_prop hires.32 $OPTIONALS`" == 1 ]\
&& [ "`grep_prop speaker.bit $OPTIONALS`" == 24 ]; then
  ui_print "- Forces 24 bit width to internal speaker"
  sed -i 's/#s24//g' $MODPATH/.aml.sh
  ui_print " "
fi

# sampling rates
if [ "`grep_prop sample.rate $OPTIONALS`" == 44 ]\
&& [ "`grep_prop hires.pcm $OPTIONALS`" == 1 ]; then
  ui_print "- Enables sample rate to 44100"
  sed -i 's/|48000//g' $MODPATH/.aml.sh
  sed -i 's/,48000//g' $MODPATH/.aml.sh
  ui_print " "
elif [ "`grep_prop sample.rate $OPTIONALS`" == 88 ]\
&& [ "`grep_prop hires.pcm $OPTIONALS`" == 1 ]; then
  ui_print "- Enables sample rate to 88200"
  sed -i 's/|48000/|48000|88200/g' $MODPATH/.aml.sh
  sed -i 's/,48000/,48000,88200/g' $MODPATH/.aml.sh
  ui_print " "
elif [ "`grep_prop sample.rate $OPTIONALS`" == 96 ]\
&& [ "`grep_prop hires.pcm $OPTIONALS`" == 1 ]; then
  ui_print "- Enables sample rate to 96000"
  sed -i 's/|48000/|48000|88200|96000/g' $MODPATH/.aml.sh
  sed -i 's/,48000/,48000,88200,96000/g' $MODPATH/.aml.sh
  ui_print " "
elif [ "`grep_prop sample.rate $OPTIONALS`" == 128 ]\
&& [ "`grep_prop hires.pcm $OPTIONALS`" == 1 ]; then
  ui_print "- Enables sample rate to 128000"
  sed -i 's/|48000/|48000|88200|96000|128000/g' $MODPATH/.aml.sh
  sed -i 's/,48000/,48000,88200,96000,128000/g' $MODPATH/.aml.sh
  ui_print " "
elif [ "`grep_prop sample.rate $OPTIONALS`" == 176 ]\
&& [ "`grep_prop hires.pcm $OPTIONALS`" == 1 ]; then
  ui_print "- Enables sample rate to 176400"
  sed -i 's/|48000/|48000|88200|96000|128000|176400/g' $MODPATH/.aml.sh
  sed -i 's/,48000/,48000,88200,96000,128000,176400/g' $MODPATH/.aml.sh
  ui_print " "
elif [ "`grep_prop sample.rate $OPTIONALS`" == 192 ]\
&& [ "`grep_prop hires.pcm $OPTIONALS`" == 1 ]; then
  ui_print "- Enables sample rate to 192000"
  sed -i 's/|48000/|48000|88200|96000|128000|176400|192000/g' $MODPATH/.aml.sh
  sed -i 's/,48000/,48000,88200,96000,128000,176400,192000/g' $MODPATH/.aml.sh
  ui_print " "
elif [ "`grep_prop sample.rate $OPTIONALS`" == 352 ]\
&& [ "`grep_prop hires.pcm $OPTIONALS`" == 1 ]; then
  ui_print "- Enables sample rate to 352800"
  sed -i 's/|48000/|48000|88200|96000|128000|176400|192000|352800/g' $MODPATH/.aml.sh
  sed -i 's/,48000/,48000,88200,96000,128000,176400,192000,352800/g' $MODPATH/.aml.sh
  ui_print " "
elif [ "`grep_prop sample.rate $OPTIONALS`" == 384 ]\
&& [ "`grep_prop hires.pcm $OPTIONALS`" == 1 ]; then
  ui_print "- Enables sample rate to 384000"
  sed -i 's/|48000/|48000|88200|96000|128000|176400|192000|352800|384000/g' $MODPATH/.aml.sh
  sed -i 's/,48000/,48000,88200,96000,128000,176400,192000,352800,384000/g' $MODPATH/.aml.sh
  ui_print " "
fi

# run
. $MODPATH/copy.sh
. $MODPATH/.aml.sh














