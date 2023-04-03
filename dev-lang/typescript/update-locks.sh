#!/bin/bash
# Update once a week
main() {
	local versions=(
		$(ls *ebuild \
			| tr " " "\n" \
			| grep -E -o -e "[0-9]+.[0-9]+.[0-9]+(-r[0-9]+)?")
	)
	#versions=(5.0.2)
	export UPDATE_YARN_LOCK=1
	local pv
	for pv in ${versions[@]} ; do
		echo "Updating ${pv}"
		cat typescript-${pv}.ebuild | sed -e '/UPDATER_START_YARN_EXTERNAL_URIS/,/UPDATER_END_YARN_EXTERNAL_URIS/{//!d}' > typescript-${pv}.ebuild.t
		mv typescript-${pv}.ebuild{.t,}
cat <<EOF > extern-uris.txt
YARN_EXTERNAL_URIS="
"
EOF
		local block
		block=$(cat extern-uris.txt)
		sed -i "/UPDATER_START_YARN_EXTERNAL_URIS/r extern-uris.txt" typescript-${pv}.ebuild
		ebuild typescript-${pv}.ebuild digest clean unpack
		cp -a /var/tmp/portage/dev-lang/typescript-${pv}/work/TypeScript-${pv%-*}/yarn.lock files/${pv%-*}
		grep "resolved" /var/tmp/portage/dev-lang/typescript-${pv}/work/TypeScript-${pv%-*}/yarn.lock \
			| cut -f 2 -d '"' \
			| cut -f 1 -d "#" \
			| sort \
			| uniq > yarn-uris.txt
		./transform-uris.sh > transformed-uris.txt
		cat typescript-${pv}.ebuild | sed -e '/UPDATER_START_YARN_EXTERNAL_URIS/,/UPDATER_END_YARN_EXTERNAL_URIS/{//!d}' > typescript-${pv}.ebuild.t
		mv typescript-${pv}.ebuild{.t,}
cat <<EOF > extern-uris.txt
YARN_EXTERNAL_URIS="
$(cat yarn-uris.txt)
"
EOF
		block=$(cat extern-uris.txt)
		sed -i "/UPDATER_START_YARN_EXTERNAL_URIS/r extern-uris.txt" typescript-${pv}.ebuild
		ebuild typescript-${pv}.ebuild digest
	done
	rm extern-uris.txt
	rm transformed-uris.txt
	rm yarn-uris.txt
}

main
