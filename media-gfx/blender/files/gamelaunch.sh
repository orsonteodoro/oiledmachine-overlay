#!/bin/bash
pushd $(dirname "${BASH_SOURCE[0]}") 2>/dev/null 1>/dev/null
LD_LIBRARY_PATH="$(pwd)/lib"
PATH="$(pwd):$(pwd)/bin"
./blenderplayer my_game_project.blend "$@"
popd 2>/dev/null 1>/dev/null
