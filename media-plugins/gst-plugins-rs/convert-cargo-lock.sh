#!/bin/bash

# Converts cargo.lock to a format used by CRATES variable used by the cargo.eclass.

CATEGORY="media-plugins"
PN="gst-plugins-rs"
PV="0.9.0_alpha1"
MY_PV="gstreamer-1.21.1"

main() {
	unset IFS
	local l
	LINES=$(cat /var/tmp/portage/${CATEGORY}/${PN}-${PV}/work/${PN}-${MY_PV}/Cargo.lock \
			| grep -Pzo "name = \"[a-zA-Z0-_9-]+\"\nversion = \"[0-9a-z.+-]+\"" \
			| sed -r -e "s|version = \"([0-9a-z.+-]+)\"|,version = \"\1\"\^|g" \
			| tr "\n" " " \
			| tr "\0" " " \
			| tr "\0" " " \
			| tr "," " " \
			| tr "^" "\n")
	IFS=$'\n'
	for l in ${LINES} ; do
		local pn=$(echo "${l}" | cut -f 2 -d '"')
		local pv=$(echo "${l}" | cut -f 4 -d '"')
		echo "${pn}-${pv}"
	done
	IFS=$' \t\n'
}

main
