# Copyright 2019-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-kutils.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass for patching the kernel
# @DESCRIPTION:
# The ot-kernel-kutils eclass contains utility functions to alter the kernel
# config.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z "${OT_KERNEL_KUTILS_ECLASS}" ]] ; then

inherit toolchain-funcs

# @FUNCTION: ot-kernel_has_version
# @DESCRIPTION:
# Use the fewest steps to check for the existence of package instead of
# using has_version if possible.  There is a big slow down introducted by
# emerge.
# Bug:  Use has_version instead if the package looks ambiguous like
# sys-apps/systemd vs sys-apps/systemd-utils and the outcome could be fatal.
# This recommendation doesn't apply if the first case below.
ot-kernel_has_version() {
	local pkg="${1}"
	local ret
	if [[ "${pkg}" =~ ("(+)"|"(-)"|":"|"<"|"="|">"|"~"|"[-"|",-") ]] ; then
		has_version "${pkg}" # It has a *very expensive* time cost.
		ret="$?"
		return ${ret}
	elif [[ "${pkg}" =~ ("["|",") ]] ; then
		ot-kernel_has_version_use "${pkg}"
		ret="$?"
		return ${ret}
	else
		# Upstream uses EROOT for pickled merged package database not ESYSROOT.
		# No guarantee of atomic tree but very fast.
		if ls "${ESYSROOT}/var/db/pkg/${pkg}-"*"/CONTENTS" 2>/dev/null 1>/dev/null ; then
			return 0
		fi
	fi
	return 1
}

# @FUNCTION: ot-kernel_has_version_use
# @DESCRIPTION:
# Uses the fewest steps to check for the existence of package USE flags instead
# of using has_version if possible.
ot-kernel_has_version_use() {
	local pkg_raw="${1}"
	local pkg="${1%[*}"
	local X
	local Y
	local x
	local y

	local Y=(
		$(cat "${ESYSROOT}/var/db/pkg/${pkg}-"*"/USE" 2>/dev/null)
	)

	X=$(echo "${pkg_raw}" | sed -e "s|.*\[||g" -e "s|\].*||g" | tr "," " ")
	for x in ${X} ; do
		for y in ${Y[@]} ; do
			if [[ "${x}" == "${y}" ]] ; then
				return 0
			fi
		done
	done
	return 1
}

# @FUNCTION: ot-kernel_set_configopt
# @DESCRIPTION:
# Sets the kernel option with a string value or single char option
ot-kernel_set_configopt() {
	local opt="${1}"
	local val="${2}"
	if grep -q -E -e "# ${opt} is not set" "${path_config}" ; then
		sed -i -e "s@# ${opt} is not set@${opt}=${val}@g" "${path_config}" || die
	elif grep -q -E -e "^${opt}=" "${path_config}" ; then
		sed -i -r -e "s@${opt}=.*@${opt}=${val}@g" "${path_config}" || die
	else
		echo "${opt}=${val}" >> "${path_config}" || die
	fi
}

# @FUNCTION: ot-kernel_unset_configopt
# @DESCRIPTION:
# Unsets the kernel option.  Unset means no or disable.
ot-kernel_unset_configopt() {
	local opt="${1}"
	if grep -q -E -e "# ${opt} is not set" "${path_config}" ; then
		:;
	elif grep -q -E -e "^${opt}=" "${path_config}" ; then
		sed -r -i -e "s@^${opt}=.*@# ${opt} is not set@g" "${path_config}" || die
	else
		echo "# ${opt} is not set" >> "${path_config}" || die
	fi
}

# @FUNCTION: ot-kernel_y_configopt
# @DESCRIPTION:
# Sets the kernel option to y
ot-kernel_y_configopt() {
	local opt="${1}"
	if grep -q -E -e "# ${opt} is not set" "${path_config}" ; then
		sed -i -e "s@# ${opt} is not set@${opt}=y@g" "${path_config}" || die
	elif grep -q -E -e "^${opt}=" "${path_config}" ; then
		sed -i -r -e "s@^${opt}=.*@${opt}=y@g" "${path_config}" || die
	else
		echo "${opt}=y" >> "${path_config}" || die
	fi
}

# @FUNCTION: ot-kernel_n_configopt
# @DESCRIPTION:
# Unset kernel config option
ot-kernel_n_configopt() {
	local opt="${1}"
	if grep -q -E -e "# ${opt} is not set" "${path_config}" ; then
		:;
	elif grep -q -E -e "^${opt}=" "${path_config}" ; then
		sed -r -i -e "s@^${opt}=.*@# ${opt} is not set@g" "${path_config}" || die
	else
		echo "# ${opt} is not set" >> "${path_config}" || die
	fi
}

# @FUNCTION: ot-kernel_set_kconfig_kernel_cmdline
# @DESCRIPTION:
# Adds kernel cmdline args
ot-kernel_set_kconfig_kernel_cmdline() {
	local inargs=(
		$@
	)
	local cmd

	if grep -q -E -e "# CONFIG_CMDLINE_BOOL is not set" "${path_config}" ; then
		ot-kernel_y_configopt "CONFIG_CMDLINE_BOOL"
		ot-kernel_set_configopt "CONFIG_CMDLINE" "\"${inargs[@]}\""
	else
		cmd=$(grep "CONFIG_CMDLINE=" "${BUILD_DIR}/.config" | sed -e "s|CONFIG_CMDLINE=\"||g" -e "s|\"$||g")
		for x in ${inargs[@]} ; do
			# Remove duplicates
			cmd=$(echo "${cmd}" | sed -e "s|${x}||g")
		done
		ot-kernel_set_configopt "CONFIG_CMDLINE" "\"\""
		local outargs=(
			${cmd}
			$@
		)
		local outargs_="${outargs[@]}" # Cannot expand right directly
		ot-kernel_y_configopt "CONFIG_CMDLINE_BOOL"
		ot-kernel_set_configopt "CONFIG_CMDLINE" "\"${outargs_}\""
	fi
	cmd=$(grep "CONFIG_CMDLINE=" "${BUILD_DIR}/.config" | sed -e "s|CONFIG_CMDLINE=\"||g" -e "s|\"$||g")
	einfo "BOOT_ARGS:  ${cmd}"

}

# @FUNCTION: ot-kernel_unset_pat_kconfig_kernel_cmdline
# @DESCRIPTION:
# Unsets kernel cmdline args
ot-kernel_unset_pat_kconfig_kernel_cmdline() {
	local inargs=(
		$@
	)
	local cmd

	if grep -q -E -e "# CONFIG_CMDLINE_BOOL is not set" "${path_config}" ; then
		:
	else
		cmd=$(grep "CONFIG_CMDLINE=" "${BUILD_DIR}/.config" | sed -e "s|CONFIG_CMDLINE=\"||g" -e "s|\"$||g")
		for x in ${inargs[@]} ; do
			# Remove duplicates
			cmd=$(echo "${cmd}" | sed -r -e "s#${x}##g")
		done
		ot-kernel_set_configopt "CONFIG_CMDLINE" "\"\""
		local outargs=(
			${cmd}
		)
		local outargs_="${outargs[@]}" # Cannot expand right directly
		ot-kernel_y_configopt "CONFIG_CMDLINE_BOOL"
		ot-kernel_set_configopt "CONFIG_CMDLINE" "\"${outargs_}\""
	fi
	cmd=$(grep "CONFIG_CMDLINE=" "${BUILD_DIR}/.config" | sed -e "s|CONFIG_CMDLINE=\"||g" -e "s|\"$||g")
	einfo "BOOT_ARGS:  ${cmd}"

}

# @FUNCTION: ot-kernel_get_cpu_mfg_id
# @DESCRIPTION:
# Gets the mfg name for proper config.  CPU_MFG can be used to override.
# Otherwise, autodetect starting with the most portable way.
ot-kernel_get_cpu_mfg_id() {
	local mfg
	# Set by environment variable
	if [[ -n "${CPU_MFG}" ]] ; then
		echo "${CPU_MFG,,}"
		return
	fi
	if tc-is-cross-compiler ; then
eerror
eerror "You must set CPU_MFG to the vendor name.  See metadata.xml for details."
eerror
		die
	fi
	# Autodetect by /proc/cpuinfo
	# Least portable since CBUILD is not always equal to CHOST/CTARGET.
	mfg=$(cat /proc/cpuinfo \
		| grep "vendor_id" \
		| head -n 1 \
		| cut -f 2 -d ":" \
		| sed -e "s@ @@g")
	if [[ "${mfg}" =~ ("Authentic"|"Genuine") ]] ; then
		mfg=$(echo "${mfg}" \
			| sed -E -e "s@(Authentic|Genuine)@@g")
	fi
	if [[ -n "${mfg}" ]] ; then
		echo "${mfg,,}"
		return
	fi
}

OT_KERNEL_KUTILS_ECLASS="1"
fi
