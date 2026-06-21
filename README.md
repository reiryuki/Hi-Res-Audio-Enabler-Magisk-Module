# Hi-Res Audio Enabler Magisk Module

## Descriptions
- Enables high resolution 24 or 32 bit width audio output if device is supported.
- Causes no sound or low sound issue in unsupported device
- Not for Bluetooth audio
- Adds path name hph-highquality-mode to mixer path if not available yet

## Changelog

v3.12
- Support NoMount metamodule
- Resets module folders/files permissions at post-fs-data
- Move _uninstall.log to /data/adb/logs/

v3.11
- Fix wrong target in latest KernelSU

v3.10
- Improve /odm and /my_product support detection

v3.9
- Fix bug in uninstall.sh

v3.8
- Improve .conf and .xml patch detection
- Fix conflict with modules_update while installing via recovery if Magisk installed
- Remove unneeded props
- Add vendor.audio.capture.pcm.32bit.enable=true

v3.7
- Redirect /sdcard to /data/media/"$UID"
- Kitsune Mask detection

v3.6
- Add optional debug.log=1 for more detailed install log
- Specify UID at script

v3.5
- KernelSU support
- Magisk v26.1 support
- Save install log at /sdcard/..._recovery.log while installing via Recovery
- Save uninstall log in /data/adb/modules/..._uninstall.log

v3.4
- Disable audio format PCM patch by default
- Adds hph-highquality-mode to mixer path if not available yet
- Creates /sdcard/optionals.prop file if doesn't exist
- Moved audioserver restart to the beginning of service.sh

v3.3
- Added mirror /odm and /my_product Magisk Delta Canary support
- Script enhancements

## Screenshots
- https://t.me/androidryukimodsdiscussions/6546
- https://t.me/androidryukimodsdiscussions/6539
- https://t.me/androidryukimodsdiscussions/1532

## Requirements
Magisk or Kitsune Mask or KernelSU or Apatch installed

## Installation Guide & Download Link
- Install this https://devuploads.com/gfyydglk22qb module via Magisk app or Kitsune Mask app or KernelSU app or Apatch app or Recovery if Magisk or Kitsune Mask installed
- This is also an audio mod so, you need to install AML Magisk Module https://t.me/ryukinotes/34 if using any other else audio mod module
- Reboot
- For checking is it applied or not, read Troubleshootings bellow!

## Optionals
- https://t.me/ryukinotes/53
- Global: https://t.me/ryukinotes/35

## Troubleshootings
- https://t.me/ryukinotes/53
- Global: https://t.me/ryukinotes/34

## Support & Bug Report
- https://t.me/ryukinotes/54
- If you don't do above, issues will be closed immediately

## Credits and Contributors
- https://t.me/viperatmos
- https://t.me/androidryukimodsdiscussions
- You can contribute ideas about this Magisk Module here: https://t.me/androidappsportdevelopment

## Sponsors
https://t.me/ryukinotes/25


