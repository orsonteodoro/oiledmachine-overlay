ADB="/opt/genymotion/tools/adb"
"${ADB}" remount
#"${ADB}" push /usr/portage/distfiles/Genymotion-ARM-Translation_v1.1.zip /sdcard/Download/
"${ADB}" push /usr/portage/distfiles/Genymotion-ARM-Translation.zip /sdcard/Download/
#"${ADB}" shell "/system/bin/flash-archive.sh /sdcard/Download/Genymotion-ARM-Translation_v1.1.zip"
"${ADB}" shell "/system/bin/flash-archive.sh /sdcard/Download/Genymotion-ARM-Translation.zip"
"${ADB}" reboot
