#!/bin/bash
blockfile="adblock"
customblockfile="customrules"

# Lists to fetch.
#lists="
#http://chromeadblock.com/filters/adblock_custom.txt
#http://adblockplus.mozdev.org/easylist/easylist.txt
#http://adblockplus.mozdev.org/easylist/easylistgermany.txt
#http://lian.info.tm/liste_fr.txt
#"

lists="
https://easylist-downloads.adblockplus.org/easylist.txt
http://spam404bl.com/spam404scamlist.txt
https://easylist-downloads.adblockplus.org/malwaredomains_full.txt
"

#sort properly
LC_ALL=C 

for list in $lists; do
	wget --no-cache -q -O - $list
done | python2 convert.py > "$blockfile"

#cat "$blockfile" > /tmp/adblock
cat "$blockfile" "$customblockfile" > /tmp/adblock
cp /tmp/adblock $blockfile

rm block1.dat
rm block2.dat

python2 ./blocklists.py
