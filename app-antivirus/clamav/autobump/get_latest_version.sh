#!/bin/bash
get_latest_version() {
	git ls-remote --tags "https://github.com/Cisco-Talos/clamav.git" \
		| grep -E -e "/(CLAMAV_|clamav-)" \
		| sed -r \
			-e "s|.*/CLAMAV_||g" \
			-e "s|.*/clamav-||g" \
			-e "s|[\^]\{\}||g" \
			-e "s|-|_|g" \
			-e "s|@|_p|g" \
			-e "s|RC|_rc|g" \
			-e "s|090|0.90|g" \
			-e "s|([0-9])beta|\1_beta|g" \
			-e "s|([0-9])rc([0-9]+)|\1_rc\2|g" \
			-e "s|([0-9])rc$|\1_rc|g" \
			-e "s|([0-9])_([0-9]{2})|\1.\2|g" \
			-e "/dmgxar/d" \
			-e "/[0-9]{4}/d" \
			-e "s|([0-9])rc|\1_rc|g" \
		| sed -e "/sf/d" \
		| sed -e "/2008/d" \
		| sed -E -e "s|_rc_|_rc0_|g" \
		| sed -E -e "s|_rc$|_rc0|g" \
		| sed -E -e "s|_rc|_mrc|g" \
		| sed -E -e "s|^([0-9]+\.[0-9]+\.[0-9]+)$|\1_o|g" \
		| sed -E -e "s|^([0-9]+\.[0-9]+)_|\1,|g" \
		| sed -E -e "s|^([0-9]+\.[0-9]+)$|\1,,|g" \
		| sort -V \
		| uniq \
		| sed -E -e "s|^([0-9]+\.[0-9]+),,$|\1|g" \
		| sed -E -e "s|^([0-9]+\.[0-9]+),|\1_|g" \
		| sed -E -e "s|^([0-9]+\.[0-9]+\.[0-9]+)_o$|\1|g" \
		| sed -E -e "s|_mrc|_rc|g" \
		| sed -E -e "s|_rc0$|_rc|g" \
		| sed -E -e "s|_rc0_|_rc_|g" \
		| sed -e "s|_z$||g" \
		| tail -n 1
}

get_latest_version
