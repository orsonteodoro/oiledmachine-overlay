# Firejail profile for caprine
# Description: Unofficial electron based desktop wrapper for Caprine
# This file is overwritten after every install/update
# Persistent local customizations
include caprine.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Caprine

mkdir ${HOME}/.config/Caprine
whitelist ${HOME}/.config/Caprine
whitelist /opt/caprine

private-bin electron,electron[0-9],electron[0-9][0-9],caprine,bash
private-etc @tls-ca

# Redirect
include electron-common.profile
