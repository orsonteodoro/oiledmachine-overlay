#!/bin/bash
get_latest_version() {
	wget -q -O - "https://pypi.org/rss/project/types-aiofiles/releases.xml" \
		| grep "title" \
		| tail -n +2 \
		| cut -f 2 -d ">" \
		| cut -f 1 -d "<" \
		| sort -V \
		| tail -n 1

}

get_latest_version
