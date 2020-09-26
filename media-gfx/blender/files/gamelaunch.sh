#!/bin/bash
pushd $(dirname "${BASH_SOURCE[0]}") 2>/dev/null 1>/dev/null
export LIBGL_DRIVERS_DIR="$(pwd)/lib/dri" # This is to avoid multiple llvm problem.  This should match the LLVM-9 linked {...}_dri.so drivers.
export LD_LIBRARY_PATH="$(pwd)/lib:${LD_LIBRARY_PATH}"
export PATH="$(pwd):$(pwd)/bin:${PATH}"
./blenderplayer my_game_project.blend "$@"
popd 2>/dev/null 1>/dev/null
