# Hi-Res Audio Enabler Magisk Module

## Descriptions
- Enable hi-res audio format PCM 32 bit or 24 bit for deep buffer, & primary output and primary & fast input through modification of audio policy for supported Android devices. 
- May causes problems in unsupported hardware and unsupported library.

## Screenshots
- https://t.me/audioryukimods/6546
- https://t.me/audioryukimods/6539
- https://t.me/audioryukimods/1532

## Requirements
- Magisk installed

## Tested
- Android 10 arm64 CrDroid ROM

## Installation Guide
- Install the module via Magisk Manager or recovery
- Install Audio Modification Library Module if you using other audio mods (If other audio mods ain't patching audio policy, so it's not required)
- Reboot
- You can check is it applied or not:

  su

  `dumpsys media.audio_flinger`

## Troubleshootings
- Use Audio Modification Library module if you using other modules which also patching audio policy files like Moto Waves, Audio Compatibilty Patch, Dolby Atmos Oneplus 8 Visible, DTS, and Sound Enhancement.
- If logcat shows still running in PCM 16 bit, mean your audio primary library is not supported.
- Delete /data/adb/modules/HiResAudio folder via recovery if you facing bootloop and send copied and zipped /data/system/dropbox/ files.

## Bug Report
- Sending logcats and ...policy....xml and ...policy....conf files from /system/etc/ and /vendor/etc/ is a must. Otherwise, will be closed immediately.

## Thanks for Donations
- https://t.me/audioryukimods/2619
- https://www.paypal.me/reiryuki

## Download
- Tap "Releases"
