#!/bin/sh

#
# Run Mozilla Firefox on X11
#
export MOZ_DISABLE_WAYLAND=1
abi=$(basename "$0" | cut -f 2 -d "-")
exec @PREFIX@/bin/firefox-${abi} "$@"
