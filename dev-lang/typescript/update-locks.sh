#!/bin/bash
# Update once a week
my_dir=$(dirname "$0")
main() {
	local versions=(
		$(ls *ebuild \
			| tr " " "\n" \
			| grep -E -o -e "[0-9]+.[0-9]+.[0-9]+(-r[0-9]+)?")
	)
# Do one by one because of flakey servers.
#	versions=(4.5.5 4.8.4 4.9.5 5.0.2)
#	versions=(4.2.4-r1 4.4.4 4.5.5 4.8.4 4.9.5 5.0.2)
#	versions=(4.2.4-r1 4.4.4)
#	versions=(5.0.2)
#	versions=(3.9.10)
#	versions=(4.0.8)
#	versions=(4.1.6)
	export UPDATE_YARN_LOCK=1
	local pv
	for pv in ${versions[@]} ; do
		echo "Updating ${pv}"
		cat "typescript-${pv}.ebuild" | sed -e '/UPDATER_START_YARN_EXTERNAL_URIS/,/UPDATER_END_YARN_EXTERNAL_URIS/{//!d}' > "typescript-${pv}.ebuild.t"
		mv "typescript-${pv}.ebuild"{.t,}
cat <<EOF > extern-uris.txt
YARN_EXTERNAL_URIS="
"
EOF
		local block
		block=$(cat extern-uris.txt)
		sed -i "/UPDATER_START_YARN_EXTERNAL_URIS/r extern-uris.txt" "typescript-${pv}.ebuild"
		ebuild "typescript-${pv}.ebuild" digest clean unpack
		cp -a "/var/tmp/portage/dev-lang/typescript-${pv}/work/TypeScript-${pv%-*}/yarn.lock" "${my_dir}/files/${pv%-*}"
		grep "resolved" "/var/tmp/portage/dev-lang/typescript-${pv}/work/TypeScript-${pv%-*}/yarn.lock" \
			| cut -f 2 -d '"' \
			| cut -f 1 -d "#" \
			| sort \
			| uniq > yarn-uris.txt
		./transform-uris.sh > transformed-uris.txt
		cat "typescript-${pv}.ebuild" | sed -e '/UPDATER_START_YARN_EXTERNAL_URIS/,/UPDATER_END_YARN_EXTERNAL_URIS/{//!d}' > "typescript-${pv}.ebuild.t"
		mv "typescript-${pv}.ebuild"{.t,}
cat <<EOF > extern-uris.txt
YARN_EXTERNAL_URIS="
$(cat transformed-uris.txt)
"
EOF
		block=$(cat extern-uris.txt)
		sed -i "/UPDATER_START_YARN_EXTERNAL_URIS/r extern-uris.txt" "typescript-${pv}.ebuild"
		ebuild "typescript-${pv}.ebuild" digest
	done
	rm extern-uris.txt
	rm transformed-uris.txt
	rm yarn-uris.txt
}

main
