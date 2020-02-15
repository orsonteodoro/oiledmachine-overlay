#!/bin/bash
pushd $(dirname "${BASH_SOURCE[0]}") >/dev/null

cumulative_blockfile="adblock"
custom_blockfile="customrules"

# Lists to fetch.
lists="
https://easylist-downloads.adblockplus.org/easylist.txt
https://easylist-downloads.adblockplus.org/malwaredomains_full.txt
https://raw.githubusercontent.com/Spam404/lists/master/adblock-list.txt
"

# Sort it properly.
LC_ALL=C

for list in ${lists}; do
	wget --no-cache -q -O - $list
done | python3 convert.py > "${cumulative_blockfile}"

temp_blockfile=$(mktemp -u)
cat "${cumulative_blockfile}" "${custom_blockfile}" > "${temp_blockfile}"
mv "${temp_blockfile}" "${cumulative_blockfile}"

popd >/dev/null
