#!/bin/bash
DRY_RUN=${DRY_RUN:-1}
get_latest_patch_version() {
	local ver="${1}"
	git ls-remote --tags "https://github.com/JannisX11/blockbench.git" \
		| grep -e "/v${ver}" \
		| sed -e "s|.*/||g" \
		| sort -V \
		| uniq \
		| sed -e "s|^v||g" -e "s|-beta\.|_beta|" \
		| tail -n 1
}

main() {
	local pkg_dir=$(realpath $(dirname $(realpath "$0"))"/..")
	local repo_dir=$(realpath $(dirname $(realpath "$0"))"/../../../")
	export PATH="${repo_dir}/scripts:${PATH}"
	#echo "pkg_dir:  ${pkg_dir}"
	#echo "repo_dir:  ${repo_dir}"
	. "${pkg_dir}/autobump/description"

	pushd "${pkg_dir}" >/dev/null 2>&1
		local ebuild_versions
		ebuild_versions=(
			$(ls -1 *.ebuild | sort -V | sed -e "s|blockbench-||g" -e "s|\.ebuild||g")
		)
		for ver in ${ebuild_versions[@]} ; do
			local latest_ebuild_version=$(ls -1 "blockbench-${ver}"*".ebuild" | sort -V | sed -e "s|blockbench-||g" -e "s|\.ebuild||g")
			#echo "${latest_ebuild_version}"
			local latest_ebuild_version_=$(echo "${latest_ebuild_version}" | sed -r -e "s|-r[0-9]+||g")

			local slot=$(echo "${latest_ebuild_version}" | cut -f 1-2 -d ".")
			local latest_upstream_version=$(get_latest_patch_version "${slot}")

			if [[ "${latest_ebuild_version_}" != "${latest_upstream_version}" ]] ; then
				echo "Auto bumping to blockbench-${latest_ebuild_version}.ebuild -> blockbench-${latest_upstream_version}.ebuild"
				if [[ "${DRY_RUN}" != "1" ]] ; then
					cp -a \
						"blockbench-${latest_ebuild_version}.ebuild" \
						"blockbench-${latest_upstream_version}.ebuild"
					echo "Auto generating audit fixed lockfiles"
					NPM_UPDATER_VERSIONS="${latest_upstream_version}" npm_updater_update_locks.sh
					ebuild $(ls -1 *.ebuild | sort -V | tail -n 1) digest
					git add *
					git commit -m "Auto bumping to blockbench-${latest_upstream_version}.ebuild"
				fi
			fi
		done

		ebuild_versions=(
			$(ls -1 *.ebuild | sort -V | sed -e "s|blockbench-||g" -e "s|\.ebuild||g")
		)
		for ver in ${ebuild_versions[@]} ; do
			local ver_=$(echo "${ver}" | sed -r -e "s|-r[0-9]+||g")

			local slot=$(echo "${ver}" | cut -f 1-2 -d ".")
			local latest_upstream_version=$(get_latest_patch_version "${slot}")

			if [[ "${latest_ebuild_version_}" != "${latest_upstream_version}" ]] ; then
				echo "Auto pruning blockbench-${ver}.ebuild and lockfiles"
				if [[ "${DRY_RUN}" != "1" ]] ; then
					local ver3=$(echo "${ver}" | cut -f 1-3 -d ".")
					git rm -rf "${pkg_dir}/files/${ver3}"
					git rm "blockbench-${ver}.ebuild"
					ebuild $(ls -1 *.ebuild | sort -V | tail -n 1) digest
					git add *
					git commit -m "Auto pruning blockbench-${ver}.ebuild and lockfiles"
				fi
			fi
		done
	popd >/dev/null 2>&1
}

main
