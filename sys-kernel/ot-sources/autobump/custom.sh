#!/bin/bash
DRY_RUN=${DRY_RUN:-1}

get_latest_clear_version() {
	local ver="${1}"
	git ls-remote --tags \
		"https://github.com/clearlinux-pkgs/linux.git" \
		| grep "refs/tags" \
		| grep -e "/${ver}" \
		| sed -e "s|.*/||g" \
		| sort -V \
		| tail -n 1
}

get_latest_genpatches_version() {
	local ver="${1}"
	git ls-remote --tags "https://anongit.gentoo.org/git/proj/linux-patches.git" \
		| grep "refs/tags" \
		| grep -e "/${ver}" \
		| sed -e "s|.*/||g" \
		| sort -V \
		| tail -n 1
}

get_latest_rt_patchset_version() {
	local ver="${1}"
	wget -q -O - "https://cdn.kernel.org/pub/linux/kernel/projects/rt/${ver}/" \
		| grep "patches.*tar\." \
		| cut -f 1 -d ">" \
		| cut -f 2- -d "-" \
		| sed -e "s|\.tar.*||g" \
		| sort -V \
		| uniq \
		| tail -n 1
}

get_latest_major_minor_version() {
	local ver="${1}"
	wget -q -O - "https://www.kernel.org/feeds/kdist.xml" \
		| grep -E -o -e ";linux.*tar" \
		| grep -E -o -e "[0-9]+\.[0-9]+(-rc[0-9]|.[0-9]+)" \
		| sort -V \
		| uniq \
		| grep -e "^${ver}"
}

get_ebuild_versions() {
	ls -1 $(realpath $(dirname "${BASH_SOURCE[0]}")"/../") \
		| grep -e "\.ebuild$" \
		| sed -e "s|.ebuild$||g" -e "s|ot-sources-||g" \
		| sed "/9999/d"
}

main() {
	local repo_dir=$(realpath $(dirname "${BASH_SOURCE[0]}")"/../../../")
	local package_dir=$(realpath $(dirname "${BASH_SOURCE[0]}")"/../")

	. description

	# Update sys-kernel/ot-sources
	#echo "package_dir: ${package_dir}"
	#echo "repo_dir: ${repo_dir}"
	local ver
	for ver in $(get_ebuild_versions) ; do
		local slot=$(echo "${ver}" | cut -f 1-2 -d ".")
		local latest_upstream_version=$(get_latest_major_minor_version "${slot}")
		if [[ -z "${latest_upstream_version}" ]] ; then
			echo "Skipping EOL branch:  ${slot}"
			continue
		fi
		echo "Processing:  ${latest_upstream_version}"
		local ver_=$(echo "${ver}" | sed -e "s|-r[0-9]$||g")
		if [[ "${latest_upstream_version}" != "${ver_}" ]] ; then
			local current_rt_ver=$(get_latest_rt_patchset_version "${slot}")
			if [[ -n "${current_rt_ver}" ]] ; then
				echo "Auto bumping -rt patchset to ${current_rt_ver}"
				local lineno=$(grep -n "PATCH_RT_VER" "${package_dir}/ot-sources-${ver}.ebuild" | cut -f 1 -d ":")
				if [[ -z "${lineno}" ]] ; then
					lineno=6
					[[ "${DRY_RUN}" != "1" ]] && sed -i -e "${lineno}i PATCH_RT_VER=\"${current_rt_ver}\""
				else
					[[ "${DRY_RUN}" != "1" ]] && sed -i -e "${lineno}d"
					[[ "${DRY_RUN}" != "1" ]] && sed -i -e "${lineno}i PATCH_RT_VER=\"${current_rt_ver}\""
				fi
			fi

			local current_genpatches_ver=$(get_latest_genpatches_version "${slot}" | cut -f 2 -d "-")
			if [[ -n "${current_genpatches_ver}" ]] ; then
				echo "Auto bumping genpatches patchset to ${current_genpatches_ver}"
				local lineno=$(grep -n "GENPATCHES_VER" "${package_dir}/ot-sources-${ver}.ebuild" | cut -f 1 -d ":")
				if [[ -z "${lineno}" ]] ; then
					lineno=6
					[[ "${DRY_RUN}" != "1" ]] && sed -i -e "${lineno}i GENPATCHES_VER=\"${current_genpatches_ver}\""
				else
					[[ "${DRY_RUN}" != "1" ]] && sed -i -e "${lineno}d"
					[[ "${DRY_RUN}" != "1" ]] && sed -i -e "${lineno}i GENPATCHES_VER=\"${current_genpatches_ver}\""
				fi
			fi

			local current_clear_ver=$(get_latest_genpatches_version "${slot}" | cut -f 2 -d "-")
			if [[ -n "${current_clear_ver}" ]] ; then
				echo "Auto bumping clear patchset to ${current_clear_ver}"
				local lineno=$(grep -n "CLEAR_LINUX_PATCHES_VER" "${package_dir}/ot-sources-${ver}.ebuild" | cut -f 1 -d ":")
				if [[ -z "${lineno}" ]] ; then
					lineno=6
					[[ "${DRY_RUN}" != "1" ]] && sed -i -e "${lineno}i CLEAR_LINUX_PATCHES_VER=\"${current_clear_ver}\""
				else
					[[ "${DRY_RUN}" != "1" ]] && sed -i -e "${lineno}d"
					[[ "${DRY_RUN}" != "1" ]] && sed -i -e "${lineno}i CLEAR_LINUX_PATCHES_VER=\"${current_clear_ver}\""
				fi
			fi

			if [[ "${ver_}" != "${latest_upstream_version}" ]] ; then
				echo "Auto bumping ot-sources-${ver}.ebuild -> ot-sources-${latest_upstream_version}.ebuild"
				if [[ "${DRY_RUN}" != "1" ]] ; then
					cp -a \
						"${package_dir}/ot-sources-${ver}.ebuild" \
						"${package_dir}/ot-sources-${latest_upstream_version}.ebuild"
				fi
			fi
		fi
	done

	# Update virtual/ot-sources-stable
	pushd "${repo_dir}/virtual/ot-sources-stable"
		for slot in ${STABLE_SLOTS[@]} ; do
			local latest_stable_ebuild_version=$(ls -1 \
				| grep -E -e "ot-sources-stable-${slot}\..*\.ebuild$" \
				| sort -V \
				| tail -n 1 \
				| sed -e "s|ot-sources-stable-||" -e "s|\.ebuild$||")
			local latest_stable_ebuild_version_=$(echo "latest_stable_ebuild_version" | sed -r -e "s|-r[0-9]+||g")
			pushd "${repo_dir}/sys-kernel/ot-sources/"
				local latest_current_release=$(ls -1 "ot-sources-${slot}."*".ebuild" \
					| sort -V \
					| tail -n 1 \
					| sed -e "s|ot-sources-||g" -e "s|\.ebuild||g")
				if [[ "${latest_stable_ebuild_version_}" != "${latest_current_release}" ]] ; then
					echo "Auto bumping ot-sources-stable-${latest_stable_ebuild_version}.ebuild -> ot-sources-stable-${latest_current_release}.ebuild"
					if [[ "${DRY_RUN}" != "1" ]] ; then
						cp -a \
							"${repo_dir}/virtual/ot-sources-stable/ot-sources-stable-${latest_stable_ebuild_version}.ebuild" \
							"${repo_dir}/virtual/ot-sources-stable/ot-sources-stable-${latest_current_release}.ebuild"
					fi
				fi
			popd
			pushd "${repo_dir}/virtual/ot-sources-stable" || popd
				local ebuild_path=$(ls -1 *.ebuild)
				ebuild "${ebuild_path}" digest
			popd
		done
	popd

	# Update virtual/ot-sources-lts
	local current_lts_timestamp=$(wget -q -O - "https://www.kernel.org/" \
		| html2text -width 240 \
		| grep "longterm" \
		| grep -o -E "[0-9]{4}-[0-9]{2}-[0-9]+" \
		| sort -V \
		| tail -n 1 \
		| sed -e "s|-||g")
	pushd "${repo_dir}/virtual/ot-sources-lts"
		local latest_lts_ebuild_timestamp=$(ls -1 \
			| grep -e "\.ebuild$" \
			| sort -V \
			| tail -n 1 \
			| sed -e "s|ot-sources-lts-||" -e "s|\.ebuild$||")

		if [[ "${latest_lts_ebuild_timestamp}" != "${current_lts_timestamp}" ]] ; then
			echo "Auto bumping ot-sources-lts-${latest_lts_ebuild_timestamp}.ebuild -> ot-sources-lts-${current_lts_timestamp}.ebuild"
			if [[ "${DRY_RUN}" != "1" ]] ; then
				cp -a \
					"${repo_dir}/virtual/ot-sources-lts/ot-sources-lts-${latest_lts_ebuild_timestamp}.ebuild" \
					"${repo_dir}/virtual/ot-sources-lts/ot-sources-lts-${current_lts_timestamp}.ebuild"
			fi
		fi

		for slot in ${LTS_SLOTS[@]} ; do
			pushd "${repo_dir}/sys-kernel/ot-sources/"
				local ver=$(ls -1 "ot-sources-${slot}."*".ebuild" | sort -V | tail -n 1)
			popd
			local lineno=$(grep -n "~sys-kernel/ot-sources-${slot}" "${repo_dir}/virtual/ot-sources-lts/"*"ebuild" | cut -f 1 -d ":")
			if [[ "${DRY_RUN}" != "1" ]] ; then
				sed -i -e "${lineno}d" "${repo_dir}/virtual/ot-sources-lts/"*"ebuild"
				sed -i -e "${lineno}i ~sys-kernel/ot-sources-${ver}" "${repo_dir}/virtual/ot-sources-lts/"*"ebuild"
			fi
		done
		pushd "${repo_dir}/virtual/ot-sources-lts" || popd
			local ebuild_path=$(ls -1 *.ebuild)
			ebuild "${ebuild_path}" digest
		popd
	popd
}

main
