# @ECLASS: mitigate-tecv.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Spectre and Meltdown kernel mitigation
# @DESCRIPTION:
# This ebuild is to perform kernel checks on Spectre and Meltdown on the kernel
# level.
# TECV = Transient Execution CPU Vulnerability
# https://en.wikipedia.org/wiki/Transient_execution_CPU_vulnerability

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_MITIGATE_TECV_ECLASS} ]] ; then
_MITIGATE_TECV_ECLASS=1

inherit linux-info

IUSE+=" custom-kernel"

# @ECLASS_VARIABLE: _MITIGATE_TECV_RDEPEND
# @INTERNAL
# @DESCRIPTION:
# List of kernels mitigated against Spectre and Meltdown
# Mitigation against
# Spectre (2018)
# Meltdown (2018)
_MITIGATE_TECV_RDEPEND="
	|| (
		>=sys-kernel/gentoo-kernel-bin-5.10
		>=sys-kernel/gentoo-sources-5.10
		>=sys-kernel/vanilla-sources-5.10
		>=sys-kernel/git-sources-5.10
		>=sys-kernel/mips-sources-5.10
		>=sys-kernel/pf-sources-5.10
		>=sys-kernel/rt-sources-5.10
		>=sys-kernel/zen-sources-5.10
		>=sys-kernel/raspberrypi-sources-5.10
		>=sys-kernel/gentoo-kernel-5.10
		>=sys-kernel/gentoo-kernel-bin-5.10
		>=sys-kernel/vanilla-kernel-5.10
		>=sys-kernel/linux-next-5.10
		>=sys-kernel/asahi-sources-5.10
		>=sys-kernel/ot-sources-5.10
	)
	!<sys-kernel/gentoo-kernel-bin-5.10
	!<sys-kernel/gentoo-sources-5.10
	!<sys-kernel/vanilla-sources-5.10
	!<sys-kernel/git-sources-5.10
	!<sys-kernel/mips-sources-5.10
	!<sys-kernel/pf-sources-5.10
	!<sys-kernel/rt-sources-5.10
	!<sys-kernel/zen-sources-5.10
	!<sys-kernel/raspberrypi-sources-5.10
	!<sys-kernel/gentoo-kernel-5.10
	!<sys-kernel/gentoo-kernel-bin-5.10
	!<sys-kernel/vanilla-kernel-5.10
	!<sys-kernel/linux-next-5.10
	!<sys-kernel/asahi-sources-5.10
	!<sys-kernel/ot-sources-5.10
"

# @ECLASS_VARIABLE: MITIGATE_TECV_RDEPEND
# @INTERNAL
# @DESCRIPTION:
# High level RDEPEND
MITIGATE_TECV_RDEPEND="
	kernel_linux? (
		!custom-kernel? (
			${_MITIGATE_TECV_RDEPEND}
		)
	)
"

# @FUNCTION: _mitigate-tecv_check_kernel_flags
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags
_mitigate-tecv_check_kernel_flags() {
	einfo "Kernel version:  ${KV_MAJOR}.${KV_MINOR}"
	if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "5.10" ; then
		CONFIG_CHECK="
			PAGE_TABLE_ISOLATION
			RETPOLINE
		"
		WARNING_PAGE_TABLE_ISOLATION="CONFIG_PAGE_TABLE_ISOLATION is required for Meltdown mitigation."
		WARNING_RETPOLINE="CONFIG_RETPOLINE is required for Spectre mitigation."
	fi
	if ver_test "${KV_MAJOR}.${KV_MINOR}" -ge "6.9" ; then
		CONFIG_CHECK="
			MITIGATION_PAGE_TABLE_ISOLATION
			MITIGATION_RETPOLINE
		"
		WARNING_MITIGATION_PAGE_TABLE_ISOLATION="CONFIG_MITIGATION_PAGE_TABLE_ISOLATION is required for Meltdown mitigation."
		WARNING_MITIGATION_RETPOLINE="CONFIG_MITIGATION_RETPOLINE is required for Spectre mitigation."
	fi
	check_extra_config
}

# @FUNCTION: mitigate-tecv_pkg_setup
# @DESCRIPTION:
# Check the kernel config
mitigate-tecv_pkg_setup() {
	if use kernel_linux ; then
		linux-info_pkg_setup
		_mitigate-tecv_check_kernel_flags
		if use custom-kernel ; then
	# For Spectre/Meltdown
ewarn "You are responsible for using only Linux Kernel >= 5.10."
		fi
	fi
}

# @FUNCTION: mitigate-tecv_pkg_postinst
# @DESCRIPTION:
# Remind user to use only patched kernels.
mitigate-tecv_pkg_postinst() {
	# For Spectre/Meltdown
	if use kernel_linux ; then
		if use custom-kernel ; then
ewarn "You are responsible for using only Linux Kernel >= 5.10."
		fi
	fi
}

fi
