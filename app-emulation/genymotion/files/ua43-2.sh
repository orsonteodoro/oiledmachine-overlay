ADB="/opt/genymotion/tools/adb"
"${ADB}" remount
"${ADB}" push /usr/portage/distfiles/gapps-jb-20130813-signed.zip /sdcard/Download/
"${ADB}" shell "/system/bin/flash-archive.sh /sdcard/Download/gapps-jb-20130813-signed.zip"
"${ADB}" reboot
