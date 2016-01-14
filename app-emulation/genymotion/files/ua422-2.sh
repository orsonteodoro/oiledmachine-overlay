adb remount
adb push ./gapps-jb-20130812-signed.zip /sdcard/Download/
adb shell "/system/bin/flash-archive.sh /sdcard/Download/gapps-jb-20130812-signed.zip"
adb reboot
