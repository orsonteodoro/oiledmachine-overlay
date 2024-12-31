#!/bin/bash

# Converts cargo.lock to a format used by CRATES variable used by the cargo.eclass.
# cargo-ebuild is broken

CATEGORY="dev-python"
PN="kornia-rs"
MY_PN="kornia-rs"
PV="${1}" # left version in ${S}
MY_PV="${1}" # right version in ${S}

# - has ambiguous means
declare -A CARGO_PATHS=(
	[onenote_parser]="onenote.rs-%commit%"
)

main() {
	unset IFS
	local l

	local lockfiles=(
		"files/0.1.7/Cargo.lock"
		"files/0.1.7/kornia-serve/Cargo.lock"
		"files/0.1.7/kornia-py/Cargo.lock"
	)

	local s_live=""
	local s_nlive=""

	for p in ${lockfiles[@]} ; do
		echo "Processing ${p}"
		rm "${PN}-config"*".txt"
		csplit \
			--quiet \
			--prefix=${PN}-config \
			--suffix-format=%02d.txt  \
			"${p}" \
			/^$/ \
			{*}

		echo "Done splitting ${p}"

		local NL=$(grep -v -l -F "git+" ${PN}-config*.txt)
		local L=$(grep -l -F "git+" ${PN}-config*.txt)


		local live_packages=()

		# live (GIT_CRATES)
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
					-e "s|[?]branch=[a-zA-Z0-9.-]+||" \
					-e "s|#|;|g" \
					-e "s|[?]rev=[a-zA-Z0-9]{0,40}||" \
					-e "s|\.git||")
			[[ -z "${version}" ]] && continue
			cargo_path="${CARGO_PATHS[${name}]}"
			s_live+="[${name}]=\"${source};${cargo_path}\" # ${version}\n"
			live_packages+=("${name}")
		done

		# non-live (CRATES)
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

			[[ "${name}" == "clamav_rust" ]] && continue # internal
			[[ -z "${name}" ]] && continue
			[[ "${is_live}" == "1" ]] && continue
			s_nlive+="${name}-${version}\n"
		done

	done

	echo
	echo "Live:"
	echo
	echo -e "${s_live}" | sort

	echo
	echo "Non-live:"
	echo
	echo -e "${s_nlive}" | sort

	echo ""

	rm ${PN}-config*.txt

}

main
