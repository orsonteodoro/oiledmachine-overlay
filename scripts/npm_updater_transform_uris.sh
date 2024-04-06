#!/bin/bash

__NPM_UPDATER_PKG_FOLDER_PATH=$(pwd)
NPM_UPDATER_PKG_FOLDER="${NPM_UPDATER_PKG_FOLDER:-${__NPM_UPDATER_PKG_FOLDER_PATH}}"
NPM_UPDATER_SCRIPTS_PATH=$(realpath $(dirname "${BASH_SOURCE[0]}"))

# Helper script to transform URIs

NPM_EXTERNAL_URIS="
$(cat npm-uris.txt)
"

npm_updater_gen_npm_uris() {
	IFS=$'\n'
	local row
	local uri
	for row in ${NPM_EXTERNAL_URIS} ; do
		[[ "${row}" =~ "http" || "${row}" =~ "git+ssh" ]] || continue
		local uri=$(echo "${row}" \
			| cut -f 1 -d "#")
		uri=$(echo "${uri}" | sed -e "s|[?].*||")
		if [[ "${row}" =~ ".git" && "${row}" =~ "github" ]] ; then
			local commit_id=$(echo "${row}" \
				| cut -f 2 -d "#")
			local owner=$(echo "${row}" \
				| cut -f 4 -d "/")
			local project_name=$(echo "${row}" \
				| cut -f 5 -d "/" \
				| cut -f 1 -d "#" \
				| cut -f 1 -d ".")
			echo "https://github.com/${owner}/${project_name}/archive/${commit_id}.tar.gz -> npmpkg-${project_name}.git-${commit_id}.tgz"
		elif [[ "${row}" =~ "->" ]] ; then
			echo "${uri}"
		elif [[ "${row}" =~ "@" ]] ; then
			local ns=$(echo "${uri}" \
				| grep -E -o -e "@[a-zA-Z0-9._-]+" \
				| tr " " "\n" \
		                | head -n 1)
			local bn="${uri##*/}"
			echo "${uri} -> npmpkg-${ns}-${bn}"
		else
			local bn="${uri##*/}"
			echo "${uri} -> npmpkg-${bn}"
		fi
	done
	IFS=$' \t\n'
}

npm_updater_transform_npm_uris() {
	cd "${NPM_UPDATER_PKG_FOLDER}"
	npm_updater_gen_npm_uris
}

npm_updater_transform_npm_uris

