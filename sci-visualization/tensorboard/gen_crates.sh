#!/bin/bash

# List from grep -r -e "https://crates.io" /var/tmp/portage/sci-visualization/tensorboard-2.11.2/work/tensorboard-2.11.2/third_party/rust/crates.bzl  | cut -f 2 -d "\""
L="
$(cat crates-uris.txt)
"

main() {
	local row
	for row in ${L} ; do
		local name=$(echo "${row}" | cut -f 7 -d "/")
		local ver=$(echo "${row}" | cut -f 8 -d "/")
		echo "${row} -> rust-crates--${name}-${ver}.tar.gz"
	done
}

main
