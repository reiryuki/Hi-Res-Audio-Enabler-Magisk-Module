# Hi-Res Audio Enabler Magisk Module

## Descriptions
- Enable hi-res audio format PCM 24 bit or 32 bit through modification of audio policy for supported Android devices. 
- May causes problems in unsupported hardware or unsupported library.

## Screenshots
- https://t.me/androidryukimodsdiscussions/6546
- https://t.me/androidryukimodsdiscussions/6539
- https://t.me/androidryukimodsdiscussions/1532

## Requirements
- Magisk installed

## Tested
- Android 10 arm64 CrDroid ROM

## Installation Guide
- Install the module via Magisk Manager or recovery
- Install Audio Modification Library Module if you using other audio mods
- Reboot
- You can check is it applied or not via Terminal Emulator:

  su

  `dumpsys media.audio_flinger`

- You can check via logcats and filter "bit" to confirm your library is supported or not

- Don't trust any other apps

## Optional
- You can run Terminal Emulator:

  su

  `setprop hires.32 1`

  to enable 32 bit instead of 24 bit and reflash the module. Don't do this if you're facing no sound issue on speaker or logcats shows resetting back to 24 bit.

- If you're facing low volume or no sound issue on speaker, run Terminal Emulator:

  su

  `setprop speaker.16 1`

  Reflash the module after.

## Troubleshootings
- Use Audio Modification Library module if you using other audio mods
- If logcat shows still running in PCM 16 bit, mean your audio primary library is not supported.
- Delete /data/adb/modules/HiResAudio folder via recovery if you facing bootloop.

## Bug Report
- There is no fix. Only ROM and device compatibility.

## Thanks for Donations
- https://t.me/androidryukimodsdiscussions/2619
- https://www.paypal.me/reiryuki

## Download
- Moved link here: https://www.pling.com/p/1532198/
