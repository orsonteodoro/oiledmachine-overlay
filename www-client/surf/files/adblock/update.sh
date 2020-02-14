#!/bin/bash
pushd $(dirname "${BASH_SOURCE[0]}") >/dev/null

blockfile="adblock"
customblockfile="customrules"

# Lists to fetch.
lists="
https://easylist-downloads.adblockplus.org/easylist.txt
https://easylist-downloads.adblockplus.org/malwaredomains_full.txt
https://raw.githubusercontent.com/Spam404/lists/master/adblock-list.txt
"

# Sort properly
LC_ALL=C

for list in ${lists}; do
	wget --no-cache -q -O - $list
done | python3 convert.py > "${blockfile}"

FN=$(mktemp -u)
cat "${blockfile}" "${customblockfile}" > "${FN}"
mv "${FN}" "${blockfile}"

popd >/dev/null
