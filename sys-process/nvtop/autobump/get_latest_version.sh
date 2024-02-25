#!/bin/bash
get_latest_version() {
	git ls-remote --tags "https://github.com/Syllo/nvtop.git" \
		| grep "/" \
		| sed -e "s|.*/||g" \
		| sort -V \
		| uniq \
		| tail -n 1
}

get_latest_version
