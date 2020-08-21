#!/bin/sh

#
# Run Mozilla Firefox under Wayland
#
export MOZ_ENABLE_WAYLAND=1
abi=$(basename "$0" | cut -f 2 -d "-")
exec @PREFIX@/bin/firefox-${abi} "$@"
