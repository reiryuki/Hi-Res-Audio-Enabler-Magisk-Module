[ ! "$MODPATH" ] && MODPATH=${0%/*}

# destination
MODAPCS=`find $MODPATH -type f -name *policy*.conf`
MODAPXS=`find $MODPATH -type f -name *policy*.xml`
MODAPIS=`find $MODPATH -type f -name *audio*platform*info*.xml`
MODMPS=`find $MODPATH -type f -name *mixer*paths*.xml`

# function
patch_audio_format_pcm() {
# patch audio policy conf
for MODAPC in $MODAPCS; do
  if ! grep -q deep_buffer_24 $MODAPC; then
    sed -i '/^outputs/a\
  deep_buffer_24 {\
    flags AUDIO_OUTPUT_FLAG_DEEP_BUFFER\
    formats AUDIO_FORMAT_PCM_24_BIT_PACKED|AUDIO_FORMAT_PCM_8_24_BIT\
    sampling_rates 44100|48000\
    bit_width 24\
    app_type 69940\
  }' $MODAPC
  fi
#p  if ! grep -q default_24bit $MODAPC; then
#p    sed -i '/^outputs/a\
#p  default_24bit {\
#p    flags AUDIO_OUTPUT_FLAG_PRIMARY\
#p    formats AUDIO_FORMAT_PCM_24_BIT_PACKED|AUDIO_FORMAT_PCM_8_24_BIT\
#p    sampling_rates 44100|48000\
#p    bit_width 24\
#p    app_type 69937\
#p  }' $MODAPC
#p  fi
#32  if ! grep -q deep_buffer_32 $MODAPC; then
#32    sed -i '/^outputs/a\
#32  deep_buffer_32 {\
#32    flags AUDIO_OUTPUT_FLAG_DEEP_BUFFER\
#32    formats AUDIO_FORMAT_PCM_32_BIT\
#32    sampling_rates 44100|48000\
#32    bit_width 32\
#32    app_type 69940\
#32  }' $MODAPC
#32  fi
#32#p  if ! grep -q default_32bit $MODAPC; then
#32#p    sed -i '/^outputs/a\
#32#p  default_32bit {\
#32#p    flags AUDIO_OUTPUT_FLAG_PRIMARY\
#32#p    formats AUDIO_FORMAT_PCM_32_BIT\
#32#p    sampling_rates 44100|48000\
#32#p    bit_width 32\
#32#p    app_type 69937\
#32#p  }' $MODAPC
#32#p  fi
#f  if ! grep -q deep_buffer_float $MODAPC; then
#f    sed -i '/^outputs/a\
#f  deep_buffer_float {\
#f    flags AUDIO_OUTPUT_FLAG_DEEP_BUFFER\
#f    formats AUDIO_FORMAT_PCM_FLOAT\
#f    sampling_rates 44100|48000\
#f    app_type 69940\
#f  }' $MODAPC
#f  fi
#f#p  if ! grep -q default_float $MODAPC; then
#f#p    sed -i '/^outputs/a\
#f#p  default_float {\
#f#p    flags AUDIO_OUTPUT_FLAG_PRIMARY\
#f#p    formats AUDIO_FORMAT_PCM_FLOAT\
#f#p    sampling_rates 44100|48000\
#f#p    app_type 69937\
#f#p  }' $MODAPC
#f#p  fi
done
# patch audio policy xml
for MODAPX in $MODAPXS; do
  sed -i '/AUDIO_OUTPUT_FLAG_DEEP_BUFFER/a\
                    <profile name="" format="AUDIO_FORMAT_PCM_24_BIT_PACKED"\
                             samplingRates="44100,48000"\
                             channelMasks="AUDIO_CHANNEL_OUT_STEREO,AUDIO_CHANNEL_OUT_MONO"/>\
                    <profile name="" format="AUDIO_FORMAT_PCM_8_24_BIT"\
                             samplingRates="44100,48000"\
                             channelMasks="AUDIO_CHANNEL_OUT_STEREO,AUDIO_CHANNEL_OUT_MONO"/>' $MODAPX
#p  sed -i '/AUDIO_OUTPUT_FLAG_PRIMARY/a\
#p                    <profile name="" format="AUDIO_FORMAT_PCM_24_BIT_PACKED"\
#p                             samplingRates="44100,48000"\
#p                             channelMasks="AUDIO_CHANNEL_OUT_STEREO,AUDIO_CHANNEL_OUT_MONO"/>\
#p                    <profile name="" format="AUDIO_FORMAT_PCM_8_24_BIT"\
#p                             samplingRates="44100,48000"\
#p                             channelMasks="AUDIO_CHANNEL_OUT_STEREO,AUDIO_CHANNEL_OUT_MONO"/>' $MODAPX
#32  sed -i '/AUDIO_OUTPUT_FLAG_DEEP_BUFFER/a\
#32                    <profile name="" format="AUDIO_FORMAT_PCM_32_BIT"\
#32                             samplingRates="44100,48000"\
#32                             channelMasks="AUDIO_CHANNEL_OUT_STEREO,AUDIO_CHANNEL_OUT_MONO"/>' $MODAPX
#32#p  sed -i '/AUDIO_OUTPUT_FLAG_PRIMARY/a\
#32#p                    <profile name="" format="AUDIO_FORMAT_PCM_32_BIT"\
#32#p                             samplingRates="44100,48000"\
#32#p                             channelMasks="AUDIO_CHANNEL_OUT_STEREO,AUDIO_CHANNEL_OUT_MONO"/>' $MODAPX
#f  sed -i '/AUDIO_OUTPUT_FLAG_DEEP_BUFFER/a\
#f                    <profile name="" format="AUDIO_FORMAT_PCM_FLOAT"\
#f                             samplingRates="44100,48000"\
#f                             channelMasks="AUDIO_CHANNEL_OUT_STEREO,AUDIO_CHANNEL_OUT_MONO"/>' $MODAPX
#f#p  sed -i '/AUDIO_OUTPUT_FLAG_PRIMARY/a\
#f#p                    <profile name="" format="AUDIO_FORMAT_PCM_FLOAT"\
#f#p                             samplingRates="44100,48000"\
#f#p                             channelMasks="AUDIO_CHANNEL_OUT_STEREO,AUDIO_CHANNEL_OUT_MONO"/>' $MODAPX
done
}

# patch audio format pcm
#cpatch_audio_format_pcm

# patch audio platform info
for MODAPI in $MODAPIS; do
  if ! grep -q '<bit_width_configs>' $MODAPI; then
    sed -i '/<audio_platform_info>/a\
    <bit_width_configs>\
        <device name="SND_DEVICE_OUT_HEADPHONES" bit_width="24"/>\
        <device name="SND_DEVICE_OUT_SPEAKER" bit_width="24"/>\
    </bit_width_configs>' $MODAPI
  fi
  if ! grep -q '<device name="SND_DEVICE_OUT_SPEAKER" bit_width=' $MODAPI; then
    sed -i '/<bit_width_configs>/a\
        <device name="SND_DEVICE_OUT_SPEAKER" bit_width="24"/>' $MODAPI
  fi
  if ! grep -q '<device name="SND_DEVICE_OUT_HEADPHONES" bit_width=' $MODAPI; then
    sed -i '/<bit_width_configs>/a\
        <device name="SND_DEVICE_OUT_HEADPHONES" bit_width="24"/>' $MODAPI
  fi
  sed -i 's|<device name="SND_DEVICE_OUT_HEADPHONES" bit_width="16"|<device name="SND_DEVICE_OUT_HEADPHONES" bit_width="24"|g' $MODAPI
  sed -i 's|<device name="SND_DEVICE_OUT_SPEAKER" bit_width="16"|<device name="SND_DEVICE_OUT_SPEAKER" bit_width="24"|g' $MODAPI
#32  sed -i 's|<device name="SND_DEVICE_OUT_HEADPHONES" bit_width="24"|<device name="SND_DEVICE_OUT_HEADPHONES" bit_width="32"|g' $MODAPI
#32  sed -i 's|<device name="SND_DEVICE_OUT_SPEAKER" bit_width="24"|<device name="SND_DEVICE_OUT_SPEAKER" bit_width="32"|g' $MODAPI
#s16  sed -i 's|<device name="SND_DEVICE_OUT_SPEAKER" bit_width="24"|<device name="SND_DEVICE_OUT_SPEAKER" bit_width="16"|g' $MODAPI
#s16  sed -i 's|<device name="SND_DEVICE_OUT_SPEAKER" bit_width="32"|<device name="SND_DEVICE_OUT_SPEAKER" bit_width="16"|g' $MODAPI
#s24  sed -i 's|<device name="SND_DEVICE_OUT_SPEAKER" bit_width="16"|<device name="SND_DEVICE_OUT_SPEAKER" bit_width="24"|g' $MODAPI
#s24  sed -i 's|<device name="SND_DEVICE_OUT_SPEAKER" bit_width="32"|<device name="SND_DEVICE_OUT_SPEAKER" bit_width="24"|g' $MODAPI
done

# patch mixer path
for MODMP in $MODMPS; do
  if ! grep -q hph-highquality-mode $MODMP; then
    sed -i '/<\/mixer>/i\
    <path name="hph-highquality-mode">\
    <\/path>\' $MODMP
  fi
done








