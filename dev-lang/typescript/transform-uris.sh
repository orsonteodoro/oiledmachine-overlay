#!/bin/bash

# Helper script to transform URIs

YARN_EXTERNAL_URIS="
$(cat yarn-uris.txt)
"

yarn-utils_gen_yarn_uris() {
	IFS=$'\n'
	local uri
	for uri in ${YARN_EXTERNAL_URIS} ; do
		if [[ "${uri}" =~ "->" ]] ; then
			echo "${uri}"
		elif [[ "${uri}" =~ "@" ]] ; then
			local ns=$(echo "${uri}" \
				| grep -E -o -e "@[a-z.-]+")
			local bn="${uri##*/}"
			echo "${uri} -> yarnpkg-${ns}-${bn}"
		else
			local bn="${uri##*/}"
			echo "${uri} -> yarnpkg-${bn}"
		fi
	done
	IFS=$' \t\n'
}

main() {
	yarn-utils_gen_yarn_uris
}

main
