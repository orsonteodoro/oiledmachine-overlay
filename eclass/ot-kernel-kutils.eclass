# Copyright 2019-2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-kutils.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7
# @BLURB: Eclass for patching the kernel
# @DESCRIPTION:
# The ot-kernel-kutils eclass contains utility functions to alter the kernel
# config.

if [[ -z "${OT_KERNEL_KUTILS_ECLASS}" ]] ; then

# @FUNCTION: ot-kernel_set_configopt
# @DESCRIPTION:
# Sets the kernel option with a string value or single char option
ot-kernel_set_configopt() {
	local opt="${1}"
	local val="${2}"
	if grep -q -E -e "# ${opt} is not set" "${path_config}" ; then
		sed -i -e "s|# ${opt} is not set|${opt}=${val}|g" "${path_config}" || die
	elif grep -q -E -e "^${opt}=" "${path_config}" ; then
		sed -i -r -e "s#${opt}=.*#${opt}=${val}#g" "${path_config}" || die
	else
		echo "${opt}=${val}" >> "${path_config}" || die
	fi
}

# @FUNCTION: ot-kernel_unset_configopt
# @DESCRIPTION:
# Unsets the kernel option.  Unset means no or disable.
ot-kernel_unset_configopt() {
	local opt="${1}"
	sed -r -i -e "s/^${opt}=.*/# ${opt} is not set/g" "${path_config}" || die
}

# @FUNCTION: ot-kernel_y_configopt
# @DESCRIPTION:
# Sets the kernel option to y
ot-kernel_y_configopt() {
	local opt="${1}"
	if grep -q -E -e "# ${opt} is not set" "${path_config}" ; then
		sed -i -e "s|# ${opt} is not set|${opt}=y|g" "${path_config}" || die
	elif grep -q -E -e "^${opt}=" "${path_config}" ; then
		sed -i -r -e "s#${opt}=[y|n|m]#${opt}=y#g" "${path_config}" || die
	else
		echo "${opt}=y" >> "${path_config}" || die
	fi
}

# @FUNCTION: ot-kernel_n_configopt
# @DESCRIPTION:
# Unset kernel config option
ot-kernel_n_configopt() {
	local opt="${1}"
	sed -i -e "s|^${opt}=.*|# ${opt} is not set|g" "${path_config}" || die
}

OT_KERNEL_KUTILS_ECLASS="1"
fi
