#!/bin/bash
get_latest_version() {
	git ls-remote --tags "https://github.com/Cisco-Talos/clamav.git" \
		| grep -E -e "/(CLAMAV_|clamav-)" \
		| sed -r \
			-e "s|.*/CLAMAV_||g" \
			-e "s|.*/clamav-||g" \
			-e "s|[\^]\{\}||g" \
			-e "s|-rc$|_rc|g" \
			-e "s|-rc([0-9])|_rc\1|g" \
			-e "s|-beta|_beta|g" \
			-e "s|@|_p|g" \
			-e "s|([0-9])rc([0-9])|\1_rc\2|g" \
			-e "s|([0-9])rc$|\1_rc|g" \
			-e "s|([0-9])_([0-9]{2})|\1.\2|g" \
			-e "s|RC|_rc|g" \
			-e "s|090|0.90|g" \
			-e "s|([0-9])beta|\1_beta|g" \
			-e "/dmgxar/d" \
			-e "/[0-9]{4}/d" \
			-e "s|([0-9])rc|\1_rc|g" \
		| sed -e "/sf/d" \
		| sed -E -e "s|\.([0-9])$|.\1_z|g" \
		| sort -V \
		| uniq \
		| sed -e "s|_z$||g" \
		| tail -n 1
}

get_latest_version
