#!/bin/bash
get_latest_version() {
	if [[ "${ESR}" =~ "1" ]] ; then
		curl -s -l "http://ftp.mozilla.org/pub/firefox/releases/" \
			| cut -f 3 -d ">" \
			| cut -f 1 -d "<" \
			| grep "esr" \
			| sed -e "s|/||g" \
			| grep "^[0-9]" \
			| sort -V \
			| tail -n 1 \
			| sed -e "s|esr|e|g"
	else
		curl -s -l "http://ftp.mozilla.org/pub/firefox/releases/" \
			| cut -f 3 -d ">" \
			| cut -f 1 -d "<" \
			| grep -v "esr" \
			| grep -v "b" \
			| sed -e "s|/||g" \
			| grep "^[0-9]" \
			| sort -V \
			| tail -n 1
	fi
}

get_latest_version
