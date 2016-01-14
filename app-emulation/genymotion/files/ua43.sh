adb remount
#adb push ./Genymotion-ARM-Translation_v1.1.zip /sdcard/Download/
adb push ./Genymotion-ARM-Translation.zip /sdcard/Download/
#adb shell "/system/bin/flash-archive.sh /sdcard/Download/Genymotion-ARM-Translation_v1.1.zip"
adb shell "/system/bin/flash-archive.sh /sdcard/Download/Genymotion-ARM-Translation.zip"
adb push ./gapps-jb-20130813-signed.zip /sdcard/Download/
adb shell "/system/bin/flash-archive.sh /sdcard/Download/gapps-jb-20130813-signed.zip"
adb reboot
