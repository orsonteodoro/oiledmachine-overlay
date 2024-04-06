#!/bin/bash

__YARN_UPDATER_PKG_FOLDER_PATH=$(pwd)
YARN_UPDATER_PKG_FOLDER="${YARN_UPDATER_PKG_FOLDER:-${__YARN_UPDATER_PKG_FOLDER_PATH}}"
YARN_UPDATER_SCRIPTS_PATH=$(realpath $(dirname "${BASH_SOURCE[0]}"))

# Helper script to transform URIs

YARN_EXTERNAL_URIS="
$(cat yarn-uris.txt)
"

yarn_updater_gen_yarn_uris() {
	IFS=$'\n'
	local row
	local uri
	for row in ${YARN_EXTERNAL_URIS} ; do
		[[ "${row}" =~ "http" ]] || continue
		local uri=$(echo "${row}" \
			| cut -f 1 -d "#")
		if [[ "${row}" =~ ".git" && "${row}" =~ "github" ]] ; then
			local commit_id=$(echo "${row}" \
				| cut -f 2 -d "#")
			local owner=$(echo "${row}" \
				| cut -f 4 -d "/")
			local project_name=$(echo "${row}" \
				| cut -f 5 -d "/" \
				| cut -f 1 -d "#" \
				| sed -e "s|.git$||")
			echo "https://github.com/${owner}/${project_name}/archive/${commit_id}.tar.gz -> yarnpkg-${project_name}.git-${commit_id}.tgz"
		elif [[ "${row}" =~ "->" ]] ; then
			echo "${uri}"
		elif [[ "${row}" =~ "@" ]] ; then
			local ns=$(echo "${uri}" \
				| grep -E -o -e "@[a-zA-Z0-9._-]+")
			local bn="${uri##*/}"
			echo "${uri} -> yarnpkg-${ns}-${bn}"
		else
			local bn="${uri##*/}"
			echo "${uri} -> yarnpkg-${bn}"
		fi
	done
	IFS=$' \t\n'
}

yarn_updater_transform_yarn_uris() {
	cd "${YARN_UPDATER_PKG_FOLDER}"
	yarn_updater_gen_yarn_uris
}

yarn_updater_transform_yarn_uris

