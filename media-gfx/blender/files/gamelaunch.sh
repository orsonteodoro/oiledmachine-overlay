#!/bin/bash
pushd $(dirname "${BASH_SOURCE[0]}") 2>/dev/null 1>/dev/null

# LIBGL_DRIVERS_DIR is deprecated and works with linked LLVM-9, but
# LIBGL_DRIVERS_PATH does not work but added for the future.
# This is to avoid multiple llvm problem.  This should match the LLVM-9 (or) the
# version linked to the same LLVM version in Blender and {...}_dri.so drivers
# needs to match that version.
export LIBGL_DRIVERS_DIR="$(pwd)/lib/dri"
export LIBGL_DRIVERS_PATH="$(pwd)/lib/dri"

# LD_LIBRARY_PATH loads libraries first before system's version
export LD_LIBRARY_PATH="$(pwd)/lib:${LD_LIBRARY_PATH}"

export PATH="$(pwd):$(pwd)/bin:${PATH}"
./blenderplayer my_game_project.blend "$@"
popd 2>/dev/null 1>/dev/null
