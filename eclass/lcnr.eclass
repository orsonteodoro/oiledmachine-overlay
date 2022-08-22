# Copyright 2019-2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: lcnr.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: license, copyright notice, readme saver
# @DESCRIPTION:
# Standardizes license, copyright notice, readme retreval

# This will ultimately be replaced with a script to autoscan and auto extract
# and dedupe copyright notices, but currently the prototype script has false
# positives.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# @ECLASS_VARIABLE: LCNR_COPY_ONCE
# @DESCRIPTION:
# Tranverse the entire project source once
LCNR_COPY_ONCE=${LCNR_COPY_ONCE:-1}

# @ECLASS_VARIABLE: LCNR_COPY_ONCE
# @DESCRIPTION:
# The default source location to recursively search
LCNR_SOURCE=${LCNR_SOURCE:-${S}}

# @FUNCTION: lcnr_install_header
# @DESCRIPTION:
# Installs a license or copyright notice from the start of a file.
lcnr_install_header() {
	local dir_path=$(dirname "${1}")
	local file_name=$(basename "${1}")
	local license_name="${2}"
	local length="${3}"
einfo "Copying header copyright notice: file=${1}, length=${length}"
	local d="${dir_path}"
	local dl="licenses/${d}"
	if [[ -e "${LCNR_SOURCE}/${d}/${file_name}" ]] ; then
		docinto "${dl}"
		mkdir -p "${T}/${dl}" || die
		head -n ${length} "${LCNR_SOURCE}/${d}/${file_name}" > \
			"${T}/${dl}/${license_name}" || die
		dodoc "${T}/${dl}/${license_name}"
	else
ewarn "QA:  ${LCNR_SOURCE}/${d}/${file_name} is missing"
	fi
}

# @FUNCTION: lcnr_get_mid
# @DESCRIPTION:
# Installs a license or copyright notice from the middle of a file.
lcnr_install_mid() {
	local dir_path=$(dirname "${1}")
	local file_name=$(basename "${1}")
	local license_name="${2}"
	local start="${3}"
	local length="${4}"
einfo "Copying middle copyright notice: file=${1}, start=${start}, length=${length}"
	local d="${dir_path}"
	local dl="licenses/${d}"
	if [[ -e "${LCNR_SOURCE}/${d}/${file_name}" ]] ; then
		docinto "${dl}"
		mkdir -p "${T}/${dl}" || die
		tail -n +${start} "${LCNR_SOURCE}/${d}/${file_name}" \
			| head -n ${length} > \
			"${T}/${dl}/${license_name}" || die
		dodoc "${T}/${dl}/${license_name}"
	else
ewarn "QA:  ${LCNR_SOURCE}/${d}/${file_name} is missing"
	fi
}

# @FUNCTION: lcnr_install_files
# @DESCRIPTION:
# Installs a licenses or copyright notices from packages and other internal
# packages.
lcnr_install_files() {
	local filename="${T}/.copied_licenses_or_copyright_notices"
	if [[ "${LCNR_COPY_ONCE}" == "1" ]] ; then
		# Only traverse once.
		[[ -f "${filename}" ]] && return
	fi
einfo
einfo "Copying third party licenses and copyright notices"
einfo
	export IFS=$'\n'
	local f
	for f in $(find "${LCNR_SOURCE}" \
		-iname "*licen*" \
		-o -iname "*copyright*" \
		-o -iname "*copying*" \
		-o -iname "*patent*" \
		-o -iname "ofl.txt" \
		-o -iname "*notice*" \
		-o -iname "*author*" \
		-o -iname "*CONTRIBUTORS*" \
	) $(grep -i -G -l \
		-e "copyright" \
		-e "licen" \
		-e "warrant" \
		$(find "${LCNR_SOURCE}" -iname "*readme*")) ; \
	do
		local d
		if [[ -f "${f}" ]] ; then
			d=$(dirname "${f}" | sed -e "s|^${S}||")
		else
			d=$(echo "${f}" | sed -e "s|^${S}||")
		fi
		docinto "licenses/${d}"
		dodoc -r "${f}"
	done
	export IFS=$' \t\n'

	if [[ "${LCNR_COPY_ONCE}" == "1" ]] ; then
		touch "${filename}"
	fi
}

# @FUNCTION: lcnr_install_readmes
# @DESCRIPTION:
# Installs all readmes including those from micropackages.  Standardizes the
# process.
lcnr_install_readmes() {
	local filename="${T}/.copied_readmes"
	if [[ "${LCNR_COPY_ONCE}" == "1" ]] ; then
		# Only traverse once.
		[[ -f "${filename}" ]] && return
	fi
einfo
einfo "Copying readmes"
einfo
	export IFS=$'\n'
	local f
	for f in $(find "${LCNR_SOURCE}" \
		-iname "*.pdf" \
		-o -iname "*bug*report*.md" \
		-o -iname "*changelog*" \
		-o -iname "*changes*" \
		-o -iname "*code*of*conduct*" \
		-o -iname "*contributing*" \
		-o -iname "*feature*request*.md" \
		-o -iname "*governance*" \
		-o -iname "*history*" \
		-o -iname "*issue*template*.md" \
		-o -iname "*language*.md" \
		-o -iname "*pull*request*template*.md" \
		-o -iname "*readme*" \
		-o -ipath "*/doc/*" \
		-o -ipath "*/docs/*" \
	) ; \
	do
		local d
		if [[ -f "${f}" ]] ; then
			d=$(dirname "${f}" | sed -e "s|^${S}||")
		else
			d=$(echo "${f}" | sed -e "s|^${S}||")
		fi
		docinto "readmes/${d}"
		dodoc -r "${f}"
	done
	export IFS=$' \t\n'
	if [[ "${LCNR_COPY_ONCE}" == "1" ]] ; then
		touch "${filename}"
	fi
}
