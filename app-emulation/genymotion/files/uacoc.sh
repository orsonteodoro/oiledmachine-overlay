ADB="/opt/genymotion/tools/adb"
"${ADB}" remount
"${ADB}" install /usr/portage/distfiles/com.supercell.clashofclans-6.407.2-APK4Fun.com.apk
"${ADB}" reboot
