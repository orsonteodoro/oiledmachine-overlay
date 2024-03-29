#!/bin/bash

# Perform recursive autobump for supported packages

export DRY_RUN=${DRY_RUN:-1}
export TEST_MISPATCH=${TEST_MISPATCH:-0}

main() {
	local repo_root_dir=$(pwd)
	local PKG_DIRS=(
		$(find . -maxdepth 2 -type d \
			| sed -e "s|^./||g" \
			| grep -e "/")
	)

	local pkg_dir
	for pkg_dir in ${PKG_DIRS[@]} ; do
		[[ "${pkg_dir}" =~ ^".git" ]] && continue
		[[ "${pkg_dir}" =~ ^"profiles/" ]] && continue
		[[ "${pkg_dir}" =~ ^"metadata/" ]] && continue
		#echo "${pkg_dir}"
		AUTOBUMP=1
		CATEGORY=""
		PN=""
		SLOT_COMPONENTS="1-2"
		if [[ -e "${pkg_dir}/autobump/description" ]] ; then
			. "${pkg_dir}/autobump/description"
			echo "Package:  ${CATEGORY}/${PN}"
			[[ "${AUTOBUMP}" == "0" ]] && continue
			if [[ "${BUMP_POLICY}" == "custom" ]] ; then
				pushd "${pkg_dir}/autobump" >/dev/null 2>&1
					./custom.sh
				popd >/dev/null 2>&1
			elif [[ "${BUMP_POLICY}" == "latest-version" ]] ; then
				local latest_upstream_version=$("${repo_root_dir}/${pkg_dir}/autobump/get_latest_version.sh")
				local ebuild_versions=(
					$(ls -1 "${repo_root_dir}/${pkg_dir}" \
						| grep "\.ebuild" \
						| sort -V \
						| sed -e "/9999/d" \
						| sed -e "s|.ebuild||g" -e "s|${PN}-||g")
				)
				local latest_ebuild_version=(
					$(ls -1 "${repo_root_dir}/${pkg_dir}" \
						| grep "\.ebuild" \
						| sort -V \
						| sed -e "/9999/d" \
						| sed -e "s|.ebuild||g" -e "s|${PN}-||g" \
						| tail -n 1)
				)
				latest_ebuild_version_=$(echo "${latest_ebuild_version}" | sed -r -e "s|-r[0-9]+$||g")
				if [[ "${latest_ebuild_version_}" != "${latest_upstream_version}" ]] ; then
					echo "Auto bumping ${PN}-${latest_ebuild_version}.ebuild -> ${PN}-${latest_upstream_version}.ebuild"
					if [[ "${DRY_RUN}" != "1" ]] ; then
						pushd "${repo_root_dir}/${pkg_dir}" >/dev/null 2>&1
							cp -a \
								"${PN}-${latest_ebuild_version}.ebuild" \
								"${PN}-${latest_upstream_version}.ebuild"
							ebuild "${PN}-${latest_upstream_version}.ebuild" digest
							if [[ "${TEST_MISPATCH}" == "1" ]] ; then
								ebuild "${PN}-${latest_upstream_version}.ebuild" digest clean unpack prepare
								local ret="$?"
								if (( ${ret} != 0 )) ; then
									echo "[WARN] Detected possible mispatch in ${PN}-${latest_upstream_version}.ebuild"
									mkdir -p /var/log/autopatch
									echo "[WARN] Detected possible mispatch in ${PN}-${latest_upstream_version}.ebuild, $(date)" >> /var/log/autopatch/mispatch.log
								fi
							fi
							git add *
							git commit -m "Auto bumped to ${CATEGORY}/${PN}-${latest_upstream_version}.ebuild"
						popd >/dev/null 2>&1
					fi
				fi

				local ver
				for ver in ${ebuild_versions[@]} ; do
					[[ "${latest_ebuild_version_}" == "${latest_upstream_version}" ]] && continue
					[[ "${latest_ebuild_version_}" =~ "9999" ]] && continue
					echo "Auto pruning ${PN}-${ver}.ebuild"
					if [[ "${DRY_RUN}" != "1" ]] ; then
						pushd "${repo_root_dir}/${pkg_dir}" >/dev/null 2>&1
							git rm "${PN}-${ver}.ebuild"
							ebuild $(ls -1 *.ebuild | sort -V | tail -n 1) digest
							git add *
							git commit -m "Auto pruned to ${CATEGORY}/${PN}-${ver}.ebuild"
						popd >/dev/null 2>&1
					fi
				done
			elif [[ "${BUMP_POLICY}" == "new-patch-versions-per-minor-major" ]] ; then
				local major_minor_versions=(
					$(ls -1 "${repo_root_dir}/${pkg_dir}" \
						| grep ".ebuild" \
						| sort -V \
						| sed -e "s|\.ebuild||g" -e "s|${PN}-||g" \
						| grep -E "^[0-9]+\.[0-9]+" \
						| cut -f ${SLOT_COMPONENTS} -d "." \
						| sort -V \
						| uniq)
				)
				local slot
				for slot in ${major_minor_versions[@]} ; do
					local latest_upstream_version=$("${repo_root_dir}/${pkg_dir}/autobump/get_latest_patch_version.sh" "${slot}")
					local ebuild_versions=(
						$(ls -1 "${repo_root_dir}/${pkg_dir}" \
							| grep "\.ebuild" \
							| sort -V \
							| grep -e "-${slot}" \
							| sed -e "s|.ebuild||g" -e "s|${PN}-||g")
					)
					local latest_ebuild_version=(
						$(ls -1 "${repo_root_dir}/${pkg_dir}" \
							| grep "\.ebuild" \
							| sort -V \
							| sed -e "/9999/d" \
							| grep -e "-${slot}" \
							| sed -e "s|.ebuild||g" -e "s|${PN}-||g" \
							| tail -n 1)
					)
					latest_ebuild_version_=$(echo "${latest_ebuild_version}" \
						| sed -r -e "s|-r[0-9]+$||g")
					if [[ "${latest_ebuild_version_}" != "${latest_upstream_version}" ]] ; then
						echo "Auto bumping ${PN}-${latest_ebuild_version}.ebuild -> ${PN}-${latest_upstream_version}.ebuild"
						if [[ "${DRY_RUN}" != "1" ]] ; then
							pushd "${repo_root_dir}/${pkg_dir}" >/dev/null 2>&1
								cp -a \
									"${PN}-${latest_ebuild_version}.ebuild" \
									"${PN}-${latest_upstream_version}.ebuild"
								ebuild "${PN}-${latest_upstream_version}.ebuild" digest
								if [[ "${TEST_MISPATCH}" == "1" ]] ; then
									ebuild "${PN}-${latest_upstream_version}.ebuild" digest clean unpack prepare
									local ret="$?"
									if (( ${ret} != 0 )) ; then
										echo "[WARN] Detected possible mispatch in ${PN}-${latest_upstream_version}.ebuild"
										mkdir -p /var/log/autopatch
										echo "[WARN] Detected possible mispatch in ${PN}-${latest_upstream_version}.ebuild, $(date)" >> /var/log/autopatch/mispatch.log
									fi
								fi
								git add *
								git commit -m "Auto bumped to ${CATEGORY}/${PN}-${latest_upstream_version}.ebuild"
							popd >/dev/null 2>&1
						fi
					fi

					local ver
					for ver in ${ebuild_versions[@]} ; do
						[[ "${latest_ebuild_version_}" == "${latest_upstream_version}" ]] && continue
						[[ "${latest_ebuild_version_}" =~ "9999" ]] && continue
						echo "Auto pruning ${PN}-${ver}.ebuild"
						if [[ "${DRY_RUN}" != "1" ]] ; then
							pushd "${repo_root_dir}/${pkg_dir}" >/dev/null 2>&1
								git rm "${PN}-${ver}.ebuild"
								ebuild $(ls -1 *.ebuild | sort -V | tail -n 1) digest
								git add *
								git commit -m "Auto pruned to ${CATEGORY}/${PN}-${latest_upstream_version}.ebuild"
							popd >/dev/null 2>&1
						fi
					done
				done
			fi
		fi
	done
}

main
