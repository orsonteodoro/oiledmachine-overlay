#!/bin/bash

# Converts cargo.lock to a format used by CRATES variable used by the cargo.eclass.
# cargo-ebuild is broken

CATEGORY="app-misc"
PN="amica"
MY_PN="amica" # amica-app for stable, amica for unstable
PV="${1}"
MY_PV="${2}" # Prefix with v if stable

# - has ambiguous means
declare -A CARGO_PATHS=(
[tauri-plugin-autostart]="plugins-workspace-%commit%/plugins/autostart" # 0.0.0
[tauri-plugin-localhost]="plugins-workspace-%commit%/plugins/localhost" # 0.0.0
[tauri-plugin-single-instance]="plugins-workspace-%commit%/plugins/single-instance" # 0.0.0
[tauri-plugin-store]="plugins-workspace-%commit%/plugins/store" # 0.0.0
[tauri-plugin-window-state]="plugins-workspace-%commit%/plugins/window-state" # 0.0.0
[tauri-plugin-cli]="plugins-workspace-%commit%/plugins/cli"
[tauri-plugin-shell]="plugins-workspace-%commit%/plugins/shell"
)

main() {
	unset IFS
	local l

	csplit \
		--quiet \
		--prefix=${PN}-config \
		--suffix-format=%02d.txt  \
		/var/tmp/portage/${CATEGORY}/${PN}-${PV}/work/${MY_PN}-${MY_PV}/src-tauri/Cargo.lock \
		/^$/ \
		{*}

	echo "Done splitting"

	local NL=$(grep -v -l -F "git+" ${PN}-config*.txt)
	local L=$(grep -l -F "git+" ${PN}-config*.txt)

	local s_live=""
	local s_nlive=""
	local live_packages=()

	# live
	local L=$(grep -l -F "git+" ${PN}-config*.txt)
	for l in ${L[@]} ; do
		local name=$(grep "name = " ${l} \
			| cut -f 2 -d '"')
		local version=$(grep "version = " ${l} \
			| cut -f 2 -d '"')
		local source=$(grep "source = " ${l} \
			| cut -f 2 -d '"' \
			| sed -r \
				-e "s|git[+]||g" \
				-e "s|[?]branch=[a-zA-Z0-9.]+||" \
				-e "s|#|;|g" \
				-e "s|[?]rev=[a-zA-Z0-9]{0,40}||" \
				-e "s|\.git||")
		[[ -z "${version}" ]] && continue
		cargo_path="${CARGO_PATHS[${name}]}"
		s_live+="[${name}]=\"${source};${cargo_path}\" # ${version}\n"
		live_packages+=("${name}")
	done

	# non-live
	for l in ${NL[@]} ; do
		local name=$(grep "name = " ${l} \
			| cut -f 2 -d '"')
		local version=$(grep "version = " ${l} \
			| cut -f 2 -d '"')

		local is_live=0
		local x
		for x in ${live_packages[@]} ; do
			if [[ "${x}" == "${name}" ]] ; then
				is_live=1
			fi
		done

		[[ "${name}" == "breezy" ]] && continue # internal
		[[ "${name}" == "rio-py" ]] && continue # internal
		[[ -z "${name}" ]] && continue
		[[ "${is_live}" == "1" ]] && continue
		s_nlive+="${name}-${version}\n"
	done

	echo
	echo "Live:"
	echo
	echo -e "${s_live}" | sort

	echo
	echo "Non-live:"
	echo
	echo -e "${s_nlive}" | sort | sed -e "/^coolercontrol-/d"

	echo ""

	rm ${PN}-config*.txt
}

main
