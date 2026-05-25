# Firejail profile for twitch
# Description: Unofficial electron based desktop wrapper for Upscayl
# This file is overwritten after every install/update
# Persistent local customizations
include upscayl.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Upscayl

mkdir ${HOME}/.config/Upscayl
whitelist ${HOME}/.config/Upscayl
whitelist /opt/upscayl

private-bin electron,electron[0-9],electron[0-9][0-9],upscayl,bash
private-etc @tls-ca

# Redirect
include electron-common.profile
