# Copyright 2019-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
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

# @ECLASS_VARIABLE: LCNR_TAG
# @DESCRIPTION:
# Separate recursive searches with a tag.  In addition install the recursive
# search in its own sub folder.

# @ECLASS_VARIABLE: LCNR_COPY_ONCE
# @DESCRIPTION:
# Tranverse the entire project source once
LCNR_COPY_ONCE=${LCNR_COPY_ONCE:-1}

# @ECLASS_VARIABLE: LCNR_SOURCE
# @DESCRIPTION:
# The default source location to recursively search

# @ECLASS_VARIABLE: LCNR_ADD_GH_DEV_FILES
# @DESCRIPTION:
# Add development documentation such as bug report templates or
# version control documentation

# @FUNCTION: lcnr_install_header
# @DESCRIPTION:
# Installs a license or copyright notice from the start of a file.
lcnr_install_header() {
	local LCNR_SOURCE=${LCNR_SOURCE:-${S}}
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
	local LCNR_SOURCE=${LCNR_SOURCE:-${S}}
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
# packages recursively.
lcnr_install_files() {
	local LCNR_SOURCE=${LCNR_SOURCE:-${S}}
	local filename="${T}/.copied_licenses_or_copyright_notices_${LCNR_TAG}"
	if [[ "${LCNR_COPY_ONCE}" == "1" ]] ; then
		# Only traverse once.
		[[ -f "${filename}" ]] && return
	fi
	local message_extension=""
	if [[ -n "${LCNR_TAG}" ]] ; then
		message_extension=" for ${LCNR_TAG}"
	fi
einfo "Copying third party licenses and copyright notices${message_extension}"
	export IFS=$'\n'
	local f
	for f in \
		$(find "${LCNR_SOURCE}" \
			   -iname "*licen*" \
			-o -iname "*copyright*" \
			-o -iname "*copying*" \
			-o -iname "*patent*" \
			-o -iname "ofl.txt" \
			-o -iname "*notice*" \
			-o -iname "*author*" \
			-o -iname "*CONTRIBUTORS*" \
			-o -iname "*credits*" \
			-o -iname "*EULA*" \
			-o -iname "*maintainers*") \
		$(grep -i -G -l \
			-e "copyright" \
			-e "licen" \
			-e "warrant" \
			$(find "${LCNR_SOURCE}" -iname "*readme*" -type f)) ; \
	do
		local d
		if [[ -f "${f}" ]] ; then
			d=$(dirname "${f}" | sed -e "s|^${LCNR_SOURCE}||")
		else
			d=$(echo "${f}" | sed -e "s|^${LCNR_SOURCE}||")
		fi
		if [[ -n "${LCNR_TAG}" ]] ; then
			docinto "licenses/${LCNR_TAG}/${d}"
		else
			docinto "licenses/${d}"
		fi
		dodoc -r "${f}"
	done
	export IFS=$' \t\n'

	if [[ "${LCNR_COPY_ONCE}" == "1" ]] ; then
		touch "${filename}"
	fi
}

# @FUNCTION: lcnr_install_readmes
# @DESCRIPTION:
# Installs all readmes including those from micropackages recursively.
# Standardizes the process.
lcnr_install_readmes() {
	local LCNR_SOURCE=${LCNR_SOURCE:-${S}}
	local filename="${T}/.copied_readmes_${LCNR_TAG}"
	if [[ "${LCNR_COPY_ONCE}" == "1" ]] ; then
		# Only traverse once.
		[[ -f "${filename}" ]] && return
	fi
	local message_extension=""
	if [[ -n "${LCNR_TAG}" ]] ; then
		message_extension=" for ${LCNR_TAG}"
	fi
einfo "Copying readmes${message_extension}"

	local extra_args=()
	if [[ "${LCNR_ADD_GH_DEV_FILES}" == "1" ]] ; then
		extra_args=(
			-o -iname "*bug*report*.md"
			-o -iname "*feature*request*.md"
			-o -iname "*issue*template*.md"
			-o -iname "*pull*request*template*.md"
			-o -iname "*code*of*conduct*"
		)
	fi

	export IFS=$'\n'
	local f
	for f in \
		$(find "${LCNR_SOURCE}" \
			   -iname "*.pdf" \
			-o -iname "*changelog*" \
			-o -iname "*changes*" \
			-o -iname "*contributing*" \
			-o -iname "*governance*" \
			-o -iname "*history*" \
			-o -iname "*language*.md" \
			-o -iname "*readme*" \
			-o -ipath "*/doc/*" \
			-o -ipath "*/docs/*" \
			${extra_args[@]}) ; \
	do
		local d
		if [[ -f "${f}" ]] ; then
			d=$(dirname "${f}" | sed -e "s|^${LCNR_SOURCE}||")
		else
			d=$(echo "${f}" | sed -e "s|^${LCNR_SOURCE}||")
		fi
		if [[ -n "${LCNR_TAG}" ]] ; then
			docinto "readmes/${LCNR_TAG}/${d}"
		else
			docinto "readmes/${d}"
		fi
		dodoc -r "${f}"
	done
	export IFS=$' \t\n'
	if [[ "${LCNR_COPY_ONCE}" == "1" ]] ; then
		touch "${filename}"
	fi
}
