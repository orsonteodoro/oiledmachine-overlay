#!/bin/bash
DRY_RUN=${DRY_RUN:-1}
get_latest_stable() {
	local evens="("$(seq 0 2 200 | tr "\n" "|" | sed -e "s/[|]$//g")")"; \
	wget -q -O - "https://webkitgtk.org/releases/" \
		| html2text -nobs \
		| grep -E -o -e "webkitgtk-[0-9\.]+\.tar\.xz" \
		| sed -r -e "s|webkitgtk-||g" -e "s|\.tar\.xz||g" \
		| tr " " "\n" \
		| uniq \
		| sed -r -e "/\.(90|91|92|90.1$)/d" | grep -E "[0-9]+\.${evens}\." \
		| tail -n 1
}

get_latest_unstable() {
	local odds="("$(seq 1 2 201 | tr "\n" "|" | sed -e "s/[|]$//g")")"
	local events="("$(seq 2 2 200 | tr "\n" "|" | sed -e "s/[|]$//g")")"
	local L1=(
		$(wget -q -O - "https://webkitgtk.org/releases/" \
			| html2text -nobs \
			| grep -E -o -e "webkitgtk-[0-9\.]+\.tar\.xz" \
			| sed -r -e "s|webkitgtk-||g" -e "s|\.tar\.xz||g" \
			| tr " " "\n" \
			| uniq \
			| sed -r -e "/\.(90|91|92|90.1$)/d" \
			| grep -E "[0-9]+\.${odds}\."
		)
	)
	# .90, .91, .92 are considered development
	local L2=(
		$(wget -q -O - "https://webkitgtk.org/releases/" \
			| html2text -nobs \
			| grep -E -o -e "webkitgtk-[0-9\.]+\.tar\.xz" \
			| sed -r -e "s|webkitgtk-||g" -e "s|\.tar\.xz||g" \
			| tr " " "\n" \
			| uniq \
			| grep -E -e "\.(90|91|92|90.1$)"
		)

	)
	echo ${L1[@]} ${L2[@]} \
		| tr " " "\n" \
		| sort -V \
		| uniq \
		| tail -n 1
}

get_latest_stable_slot() {
	local ver="${1}"
	local evens="("$(seq 0 2 200 | tr "\n" "|" | sed -e "s/[|]$//g")")"; \
	wget -q -O - "https://webkitgtk.org/releases/" \
		| html2text -nobs \
		| grep -E -o -e "webkitgtk-[0-9\.]+\.tar\.xz" \
		| sed -r -e "s|webkitgtk-||g" -e "s|\.tar\.xz||g" \
		| tr " " "\n" \
		| uniq \
		| sed -r -e "/\.(90|91|92|90.1$)/d" | grep -E "[0-9]+\.${evens}\." \
		| grep "^${ver//./\\.}\." \
		| tail -n 1
}

get_latest_unstable_slot() {
	local ver="${1}"
	local odds="("$(seq 1 2 201 | tr "\n" "|" | sed -e "s/[|]$//g")")"
	local events="("$(seq 2 2 200 | tr "\n" "|" | sed -e "s/[|]$//g")")"
	local L1=(
		$(wget -q -O - "https://webkitgtk.org/releases/" \
			| html2text -nobs \
			| grep -E -o -e "webkitgtk-[0-9\.]+\.tar\.xz" \
			| sed -r -e "s|webkitgtk-||g" -e "s|\.tar\.xz||g" \
			| tr " " "\n" \
			| uniq \
			| sed -r -e "/\.(90|91|92|90.1$)/d" \
			| grep -E "[0-9]+\.${odds}\."
		)
	)
	# .90, .91, .92 are considered development
	local L2=(
		$(wget -q -O - "https://webkitgtk.org/releases/" \
			| html2text -nobs \
			| grep -E -o -e "webkitgtk-[0-9\.]+\.tar\.xz" \
			| sed -r -e "s|webkitgtk-||g" -e "s|\.tar\.xz||g" \
			| tr " " "\n" \
			| uniq \
			| grep -E -e "\.(90|91|92|90.1$)"
		)

	)
	echo ${L1[@]} ${L2[@]} \
		| tr " " "\n" \
		| sort -V \
		| uniq \
		| grep "^${ver//./\\.}\." \
		| tail -n 1
}


main() {
	local pkg_dir=$(realpath $(dirname $(realpath "$0"))"/..")
	local repo_dir=$(realpath $(dirname $(realpath "$0"))"/../../../")
	pushd "${pkg_dir}" >/dev/null 2>&1
		local ebuild_versions=$(ls -1 *.ebuild | sed -e "s|webkit-gtk-||g" -e "s|\.ebuild||g" | sed -e "/-r/d")
		local ver
		for ver in ${ebuild_versions[@]} ; do
			local midc=$(echo "${ver}" | cut -f 2 -d ".")
			local slot=$(echo "${ver}" | cut -f 1-2 -d ".")
			local upstream_latest_release
			if (( ${midc} % 2 == 0 )) ; then
				# stable
				upstream_latest_release=$(get_latest_stable_slot "${slot}")
			else
				# devel
				upstream_latest_release=$(get_latest_unstable_slot "${slot}")
			fi
			if [[ "${ver}" != "${upstream_latest_release}" ]] ; then
				echo "Auto bumping webkit-gtk-${ver}.ebuild -> webkit-gtk-${upstream_latest_release}.ebuild"
				if [[ "${DRY_RUN}" != "1" ]] ; then
					cp -a \
						"webkit-gtk-${ver}.ebuild" \
						"webkit-gtk-${upstream_latest_release}.ebuild"
					ebuild $(ls -1 *.ebuild | sort -V | tail -n 1)
					git add *
					git commit "Auto bumped to webkit-gtk-${upstream_latest_release}.ebuild"
				fi
				echo "Auto bumping webkit-gtk-${ver}-r41000.ebuild -> webkit-gtk-${upstream_latest_release}-r41000.ebuild"
				if [[ "${DRY_RUN}" != "1" ]] ; then
					cp -a \
						"webkit-gtk-${ver}-r41000.ebuild" \
						"webkit-gtk-${upstream_latest_release}-r41000.ebuild"
					ebuild $(ls -1 *.ebuild | sort -V | tail -n 1)
					git add *
					git commit "Auto bumped to webkit-gtk-${upstream_latest_release}-r41000.ebuild"
				fi
				echo "Auto bumping webkit-gtk-${ver}-r60000.ebuild -> webkit-gtk-${upstream_latest_release}-r60000.ebuild"
				if [[ "${DRY_RUN}" != "1" ]] ; then
					cp -a \
						"webkit-gtk-${ver}-r60000.ebuild" \
						"webkit-gtk-${upstream_latest_release}-r60000.ebuild"
					ebuild $(ls -1 *.ebuild | sort -V | tail -n 1)
					git add *
					git commit "Auto bumped to webkit-gtk-${upstream_latest_release}-r60000.ebuild"
				fi
			fi
		done
		for ver in ${ebuild_versions[@]} ; do
			local midc=$(echo "${ver}" | cut -f 2 -d ".")
			local slot=$(echo "${ver}" | cut -f 1-2 -d ".")
			local upstream_latest_release
			if (( ${midc} % 2 == 0 )) ; then
				# stable
				upstream_latest_release=$(get_latest_stable_slot "${slot}")
			else
				# devel
				upstream_latest_release=$(get_latest_unstable_slot "${slot}")
			fi
			if [[ "${ver}" != "${upstream_latest_release}" ]] ; then
				echo "Auto pruning webkit-gtk-${ver}.ebuild"
				if [[ "${DRY_RUN}" != "1" ]] ; then
					git rm "webkit-gtk-${ver}.ebuild"
					ebuild $(ls -1 *.ebuild | sort -V | tail -n 1)
					git add *
					git commit "Auto pruning webkit-gtk-${ver}.ebuild"
				fi
				echo "Auto pruning webkit-gtk-${ver}-r41000.ebuild"
				if [[ "${DRY_RUN}" != "1" ]] ; then
					git rm "webkit-gtk-${ver}-r41000.ebuild"
					ebuild $(ls -1 *.ebuild | sort -V | tail -n 1)
					git add *
					git commit "Auto pruning webkit-gtk-${ver}-r41000.ebuild"
				fi
				echo "Auto pruning webkit-gtk-${ver}-r60000.ebuild"
				if [[ "${DRY_RUN}" != "1" ]] ; then
					git rm "webkit-gtk-${ver}-r60000.ebuild"
					ebuild $(ls -1 *.ebuild | sort -V | tail -n 1)
					git add *
					git commit "Auto pruning webkit-gtk-${ver}-r60000.ebuild"
				fi
			fi
		done
	popd >/dev/null 2>&1
}

main
