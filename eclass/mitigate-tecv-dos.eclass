# @ECLASS: mitigate-tecv-dos.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Mitigate side channel DoS attacks
# @DESCRIPTION:
# This ebuild is to perform kernel checks on CPU hardware flaws that may
# cause a Denial of Service.
#
# TECV = Transient Execution CPU Vulnerability
# https://en.wikipedia.org/wiki/Transient_execution_CPU_vulnerability
#

# ITLB_MULTIHIT, CVE-2018-12207, DoS

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_MITIGATE_TECV_DOS_ECLASS} ]] ; then
_MITIGATE_TECV_DOS_ECLASS=1

FIRMWARE_VENDOR=""
_mitigate_tecv_set_globals() {
	if [[ -e "/proc/cpuinfo" ]] ; then
		while read -r line ; do
			if [[ "${line}" =~ "AuthenticAMD" ]] ; then
				FIRMWARE_VENDOR="amd"
				break
			fi
			if [[ "${line}" =~ "GenuineIntel" ]] ; then
				FIRMWARE_VENDOR="intel"
				break
			fi
		done < "/proc/cpuinfo"
	fi
}

_mitigate_tecv_set_globals
unset -f _mitigate_tecv_set_globals

CPU_TARGET_X86=(
	cpu_target_x86_haswell
	cpu_target_x86_broadwell
	cpu_target_x86_skylake
	cpu_target_x86_ice_lake
	cpu_target_x86_sapphire_rapids
	cpu_target_x86_sapphire_rapids_edge_enhanced
	cpu_target_x86_hewitt_lake
	cpu_target_x86_ice_lake
	cpu_target_x86_kaby_lake_gen7
	cpu_target_x86_kaby_lake_gen8
	cpu_target_x86_amber_lake_gen8
	cpu_target_x86_amber_lake_gen10
	cpu_target_x86_comet_lake
	cpu_target_x86_whiskey_lake
	cpu_target_x86_coffee_lake_gen8
	cpu_target_x86_coffee_lake_gen9
	cpu_target_x86_snow_ridge
	cpu_target_x86_parker_ridge
	cpu_target_x86_elkhart_lake
	cpu_target_x86_jasper_lake
	cpu_target_x86_tiger_lake
	cpu_target_x86_alder_lake
	cpu_target_x86_catlow_golden_cove
	cpu_target_x86_rocket_lake
	cpu_target_x86_raptor_lake_gen13
	cpu_target_x86_raptor_lake_gen14
	cpu_target_x86_alder_lake_n
	cpu_target_x86_idaville
	cpu_target_x86_whitley

	cpu_target_x86_cascade_lake
	cpu_target_x86_cooper_lake

	cpu_target_x86_naples
	cpu_target_x86_rome
	cpu_target_x86_milan
	cpu_target_x86_milan-x
	cpu_target_x86_genoa
	cpu_target_x86_genoa-x
	cpu_target_x86_bergamo
	cpu_target_x86_siena
)

inherit linux-info toolchain-funcs

IUSE+="
	${CPU_TARGET_X86[@]}
	auto
	custom-kernel
	firmware
	xen
	ebuild-revision-2
"
REQUIRED_USE="
	cpu_target_x86_ice_lake? (
		firmware
	)
	cpu_target_x86_sapphire_rapids? (
		firmware
	)
	cpu_target_x86_sapphire_rapids_edge_enhanced? (
		firmware
	)
	cpu_target_x86_snow_ridge? (
		firmware
	)
	cpu_target_x86_parker_ridge? (
		firmware
	)
	cpu_target_x86_elkhart_lake? (
		firmware
	)
	cpu_target_x86_jasper_lake? (
		firmware
	)
	cpu_target_x86_skylake? (
		firmware
	)
	cpu_target_x86_tiger_lake? (
		firmware
	)
	cpu_target_x86_alder_lake? (
		firmware
	)
	cpu_target_x86_catlow_golden_cove? (
		firmware
	)
	cpu_target_x86_rocket_lake? (
		firmware
	)
	cpu_target_x86_raptor_lake_gen13? (
		firmware
	)
	cpu_target_x86_raptor_lake_gen14? (
		firmware
	)
	cpu_target_x86_alder_lake_n? (
		firmware
	)
	cpu_target_x86_cooper_lake? (
		firmware
	)
	cpu_target_x86_idaville? (
		firmware
	)
	cpu_target_x86_whitley? (
		firmware
	)
	cpu_target_x86_naples? (
		firmware
	)
	cpu_target_x86_rome? (
		firmware
	)
	cpu_target_x86_milan? (
		firmware
	)
	cpu_target_x86_milan-x? (
		firmware
	)
	cpu_target_x86_genoa? (
		firmware
	)
	cpu_target_x86_genoa-x? (
		firmware
	)
	cpu_target_x86_bergamo? (
		firmware
	)
	cpu_target_x86_siena? (
		firmware
	)
"

# @FUNCTION: gen_patched_kernel_list
# @INTERNAL
# @DESCRIPTION:
# Generate the patched kernel list
gen_patched_kernel_list() {
	local kv="${1}"
	echo "
		|| (
			>=sys-kernel/gentoo-kernel-bin-${kv}
			>=sys-kernel/gentoo-kernel-${kv}
			>=sys-kernel/gentoo-sources-${kv}
			>=sys-kernel/vanilla-sources-${kv}
			>=sys-kernel/git-sources-${kv}
			>=sys-kernel/mips-sources-${kv}
			>=sys-kernel/pf-sources-${kv}
			>=sys-kernel/rt-sources-${kv}
			>=sys-kernel/zen-sources-${kv}
			>=sys-kernel/raspberrypi-sources-${kv}
			>=sys-kernel/gentoo-kernel-${kv}
			>=sys-kernel/gentoo-kernel-bin-${kv}
			>=sys-kernel/vanilla-kernel-${kv}
			>=sys-kernel/linux-next-${kv}
			>=sys-kernel/asahi-sources-${kv}
			>=sys-kernel/ot-sources-${kv}
		)
		!<sys-kernel/gentoo-kernel-bin-${kv}
		!<sys-kernel/gentoo-kernel-${kv}
		!<sys-kernel/gentoo-sources-${kv}
		!<sys-kernel/vanilla-sources-${kv}
		!<sys-kernel/git-sources-${kv}
		!<sys-kernel/mips-sources-${kv}
		!<sys-kernel/pf-sources-${kv}
		!<sys-kernel/rt-sources-${kv}
		!<sys-kernel/zen-sources-${kv}
		!<sys-kernel/raspberrypi-sources-${kv}
		!<sys-kernel/gentoo-kernel-${kv}
		!<sys-kernel/gentoo-kernel-bin-${kv}
		!<sys-kernel/vanilla-kernel-${kv}
		!<sys-kernel/linux-next-${kv}
		!<sys-kernel/asahi-sources-${kv}
		!<sys-kernel/ot-sources-${kv}
	"
}

_MITIGATE_TECV_TECRA_RDEPEND_X86_64="
	cpu_target_x86_ice_lake? (
		firmware? (
			>=sys-firmware/intel-microcode-20240312
		)
	)
	cpu_target_x86_sapphire_rapids? (
		firmware? (
			>=sys-firmware/intel-microcode-20240312
		)
	)
	cpu_target_x86_sapphire_rapids_edge_enhanced? (
		firmware? (
			>=sys-firmware/intel-microcode-20240312
		)
	)
"
_MITIGATE_TECV_TECRA_RDEPEND_X86_32="
	${_MITIGATE_TECV_TECRA_RDEPEND_X86_64}
"

_MITIGATE_TECV_ITLB_MULTIHIT_RDEPEND_X86_64="
	cpu_target_x86_haswell? (
		$(gen_patched_kernel_list 5.4)
	)
	cpu_target_x86_broadwell? (
		$(gen_patched_kernel_list 5.4)
	)
	cpu_target_x86_skylake? (
		$(gen_patched_kernel_list 5.4)
	)
	cpu_target_x86_cascade_lake? (
		$(gen_patched_kernel_list 5.4)
	)
	cpu_target_x86_cooper_lake? (
		$(gen_patched_kernel_list 5.4)
	)
	cpu_target_x86_hewitt_lake? (
		$(gen_patched_kernel_list 5.4)
	)
	cpu_target_x86_ice_lake? (
		$(gen_patched_kernel_list 5.4)
	)

	cpu_target_x86_kaby_lake_gen7? (
		$(gen_patched_kernel_list 5.4)
	)
	cpu_target_x86_kaby_lake_gen8? (
		$(gen_patched_kernel_list 5.4)
	)
	cpu_target_x86_amber_lake_gen8? (
		$(gen_patched_kernel_list 5.4)
	)
	cpu_target_x86_amber_lake_gen10? (
		$(gen_patched_kernel_list 5.4)
	)
	cpu_target_x86_comet_lake? (
		$(gen_patched_kernel_list 5.4)
	)
	cpu_target_x86_whiskey_lake? (
		$(gen_patched_kernel_list 5.4)
	)
	cpu_target_x86_coffee_lake_gen8? (
		$(gen_patched_kernel_list 5.4)
	)
	cpu_target_x86_coffee_lake_gen9? (
		$(gen_patched_kernel_list 5.4)
	)
"
_MITIGATE_TECV_ITLB_MULTIHIT_RDEPEND_X86_32="
	${_MITIGATE_TECV_ITLB_MULTIHIT_RDEPEND_X86_64}
"

_MITIGATE_TECV_MPF_RDEPEND_X86_64="
	cpu_target_x86_snow_ridge? (
		firmware? (
			>=sys-firmware/intel-microcode-20220207
		)
	)
	cpu_target_x86_parker_ridge? (
		firmware? (
			>=sys-firmware/intel-microcode-20220207
		)
	)
	cpu_target_x86_elkhart_lake? (
		firmware? (
			>=sys-firmware/intel-microcode-20220207
		)
	)
	cpu_target_x86_jasper_lake? (
		firmware? (
			>=sys-firmware/intel-microcode-20220207
		)
	)
"
_MITIGATE_TECV_MPF_RDEPEND_X86_32="
	${_MITIGATE_TECV_MPF_RDEPEND_X86_64}
"

# The table says that the MCU is required but the git note does not specifically
# match the security advisory number.  The date is based on the monotonic
# numbering of the advisory.
_MITIGATE_TECV_UMH_RDEPEND_X86_64="
	cpu_target_x86_skylake? (
		firmware? (
			>=sys-firmware/intel-microcode-20220809
		)
		xen? (
			>=app-emulation/xen-4.17
		)
	)
	cpu_target_x86_coffee_lake_gen8? (
		xen? (
			>=app-emulation/xen-4.17
		)
	)
	cpu_target_x86_kaby_lake_gen7? (
		xen? (
			>=app-emulation/xen-4.17
		)
	)
	cpu_target_x86_kaby_lake_gen8? (
		xen? (
			>=app-emulation/xen-4.17
		)
	)
	cpu_target_x86_amber_lake_gen8? (
		xen? (
			>=app-emulation/xen-4.17
		)
	)
	cpu_target_x86_amber_lake_gen10? (
		xen? (
			>=app-emulation/xen-4.17
		)
	)
	cpu_target_x86_coffee_lake_gen8? (
		xen? (
			>=app-emulation/xen-4.17
		)
	)
	cpu_target_x86_coffee_lake_gen9? (
		xen? (
			>=app-emulation/xen-4.17
		)
	)
	cpu_target_x86_comet_lake? (
		xen? (
			>=app-emulation/xen-4.17
		)
	)
	cpu_target_x86_rocket_lake? (
		xen? (
			>=app-emulation/xen-4.17
		)
	)
"
_MITIGATE_TECV_UMH_RDEPEND_X86_32="
	${_MITIGATE_TECV_UMH_RDEPEND_X86_64}
"

_MITIGATE_TECV_REPTAR_RDEPEND_X86_64="
	cpu_target_x86_ice_lake? (
		firmware? (
			>=sys-firmware/intel-microcode-20231114
		)
	)
	cpu_target_x86_tiger_lake? (
		firmware? (
			>=sys-firmware/intel-microcode-20231114
		)
	)
	cpu_target_x86_sapphire_rapids? (
		firmware? (
			>=sys-firmware/intel-microcode-20231114
		)
	)
	cpu_target_x86_alder_lake? (
		firmware? (
			>=sys-firmware/intel-microcode-20231114
		)
	)
	cpu_target_x86_catlow_golden_cove? (
		firmware? (
			>=sys-firmware/intel-microcode-20231114
		)
	)
	cpu_target_x86_rocket_lake? (
		firmware? (
			>=sys-firmware/intel-microcode-20231114
		)
	)
	cpu_target_x86_raptor_lake_gen13? (
		firmware? (
			>=sys-firmware/intel-microcode-20231114
		)
	)
	cpu_target_x86_raptor_lake_gen14? (
		firmware? (
			>=sys-firmware/intel-microcode-20231114
		)
	)
"
_MITIGATE_TECV_REPTAR_RDEPEND_X86_32="
	${_MITIGATE_TECV_REPTAR_RDEPEND_X86_64}
"

_MITIGATE_TECV_BLR_RDEPEND_X86_64="
	cpu_target_x86_sapphire_rapids? (
		firmware? (
			>=sys-firmware/intel-microcode-20240312
		)
	)
	cpu_target_x86_alder_lake? (
		firmware? (
			>=sys-firmware/intel-microcode-20240312
		)
	)
	cpu_target_x86_catlow_golden_cove? (
		firmware? (
			>=sys-firmware/intel-microcode-20240312
		)
	)
	cpu_target_x86_raptor_lake_gen13? (
		firmware? (
			>=sys-firmware/intel-microcode-20240312
		)
	)
	cpu_target_x86_raptor_lake_gen14? (
		firmware? (
			>=sys-firmware/intel-microcode-20240312
		)
	)
	cpu_target_x86_alder_lake_n? (
		firmware? (
			>=sys-firmware/intel-microcode-20240312
		)
	)
"
_MITIGATE_TECV_BLR_RDEPEND_X86_32="
	${_MITIGATE_TECV_BLR_RDEPEND_X86_64}
"

_MITIGATE_TECV_MCEAD_RDEPEND_X86_64="
	cpu_target_x86_cooper_lake? (
		firmware? (
			>=sys-firmware/intel-microcode-20240813
		)
	)
"
_MITIGATE_TECV_MCEAD_RDEPEND_X86_32="
	${_MITIGATE_TECV_MCEAD_RDEPEND_X86_64}
"

_MITIGATE_TECV_CVE_2024_24968_RDEPEND_X86_64="
	cpu_target_x86_ice_lake? (
		firmware? (
			>=sys-firmware/intel-microcode-20240910
		)
	)
	cpu_target_x86_rocket_lake? (
		firmware? (
			>=sys-firmware/intel-microcode-20240910
		)
	)
	cpu_target_x86_tiger_lake? (
		firmware? (
			>=sys-firmware/intel-microcode-20240910
		)
	)
	cpu_target_x86_alder_lake? (
		firmware? (
			>=sys-firmware/intel-microcode-20240910
		)
	)
	cpu_target_x86_raptor_lake_gen13? (
		firmware? (
			>=sys-firmware/intel-microcode-20240910
		)
	)
	cpu_target_x86_idaville? (
		firmware? (
			>=sys-firmware/intel-microcode-20240910
		)
	)
	cpu_target_x86_whitley? (
		firmware? (
			>=sys-firmware/intel-microcode-20240910
		)
	)
"
_MITIGATE_TECV_CVE_2024_24968_RDEPEND_X86_32="
	${_MITIGATE_TECV_CVE_2024_24968_RDEPEND_X86_64}
"

_MITIGATE_TECV_SLB_RDEPEND_X86_64="
	cpu_target_x86_naples? (
		>=sys-kernel/linux-firmware-20240710
	)
	cpu_target_x86_rome? (
		>=sys-kernel/linux-firmware-20240710
	)
	cpu_target_x86_milan? (
		>=sys-kernel/linux-firmware-20240710
	)
	cpu_target_x86_milan-x? (
		>=sys-kernel/linux-firmware-20240710
	)
	cpu_target_x86_genoa? (
		>=sys-kernel/linux-firmware-20240710
	)
	cpu_target_x86_genoa-x? (
		>=sys-kernel/linux-firmware-20240710
	)
	cpu_target_x86_bergamo? (
		>=sys-kernel/linux-firmware-20240710
	)
	cpu_target_x86_siena? (
		>=sys-kernel/linux-firmware-20240710
	)
"
_MITIGATE_TECV_SLB_RDEPEND_X86_32="
	${_MITIGATE_TECV_SLB_RDEPEND_X86_64}
"

_MITIGATE_TECV_AUTO="
	amd64? (
		$(gen_patched_kernel_list 5.4)
	)
	x86? (
		$(gen_patched_kernel_list 5.4)
	)
"
if [[ "${FIRMWARE_VENDOR}" == "amd" ]] ; then
	_MITIGATE_TECV_AUTO+="
		>=sys-kernel/linux-firmware-20240811
	"
fi
if [[ "${FIRMWARE_VENDOR}" == "intel" ]] ; then
	_MITIGATE_TECV_AUTO+="
		>=sys-firmware/intel-microcode-20240910
	"
fi

# @ECLASS_VARIABLE: MITIGATE_TECV_RDEPEND
# @INTERNAL
# @DESCRIPTION:
# High level RDEPEND
MITIGATE_TECV_RDEPEND="
	kernel_linux? (
		!custom-kernel? (
			auto? (
				${_MITIGATE_TECV_AUTO}
			)
			amd64? (
				${_MITIGATE_TECV_TECRA_RDEPEND_X86_64}
				${_MITIGATE_TECV_ITLB_MULTIHIT_RDEPEND_X86_64}
				${_MITIGATE_TECV_MPF_RDEPEND_X86_64}
				${_MITIGATE_TECV_REPTAR_RDEPEND_X86_64}
				${_MITIGATE_TECV_BLR_RDEPEND_X86_64}
				${_MITIGATE_TECV_MCEAD_RDEPEND_X86_64}
				${_MITIGATE_TECV_SLB_RDEPEND_X86_64}
			)
			x86? (
				${_MITIGATE_TECV_TECRA_RDEPEND_X86_32}
				${_MITIGATE_TECV_ITLB_MULTIHIT_RDEPEND_X86_32}
				${_MITIGATE_TECV_MPF_RDEPEND_X86_32}
				${_MITIGATE_TECV_REPTAR_RDEPEND_X86_32}
				${_MITIGATE_TECV_BLR_RDEPEND_X86_32}
				${_MITIGATE_TECV_MCEAD_RDEPEND_X86_32}
				${_MITIGATE_TECV_SLB_RDEPEND_X86_32}
			)
		)
	)
"

# @FUNCTION: _check_kernel_cmdline
# @INTERNAL
# @DESCRIPTION:
# Checks the kernel command line for the option.
_check_kernel_cmdline() {
	local option="${1}"
	local cl=$(linux_chkconfig_string "CMDLINE")
	if [[ "${cl}" =~ "${option}" ]] ; then
		return 0
	fi
	if grep -q "${option}" "/etc/default/grub" ; then
		return 0
	fi
	if grep -q "${option}" "/etc/grub.d/40_custom" ; then
		return 0
	fi
	return 1
}

# @FUNCTION: _mitigate_tecv_mitigate_with_ssp
# @INTERNAL
# @DESCRIPTION:
# Check for SSP to prevent pre attack for privilege escalation which can lead to data theft.
_mitigate_tecv_mitigate_with_ssp() {
	CONFIG_CHECK="
		STACKPROTECTOR
	"
	ERROR_STACKPROTECTOR="CONFIG_STACKPROTECTOR is required for SSP to mitigate against privilege escalation which could lead to data theft."
	check_extra_config
}

# @FUNCTION: _mitigate_tecv_mitigate_with_aslr
# @INTERNAL
# @DESCRIPTION:
# Check for ASLR to prevent pre attack for privilege escalation which can lead to data theft.
_mitigate_tecv_mitigate_with_aslr() {
	if [[ "${ARCH}" == "amd64" || "${ARCH}" == "x86" ]] ; then
		CONFIG_CHECK="
			RELOCATABLE
			RANDOMIZE_BASE
		"
		if [[ "${ARCH}" == "amd64" ]] ; then
			CONFIG_CHECK+="
				RANDOMIZE_MEMORY
			"
		fi
		ERROR_RELOCATABLE="CONFIG_RELOCATABLE is required for KASLR to mitigate against privilege escalation which could lead to data theft."
		ERROR_RANDOMIZE_BASE="CONFIG_RANDOMIZE_BASE is required for KASLR to mitigate against privilege escalation which could lead to data theft."
		ERROR_RANDOMIZE_MEMORY="CONFIG_RANDOMIZE_MEMORY is required to mitigate against privilege escalation which could lead to data theft."
		check_extra_config
	fi
}

# @FUNCTION: _mitigate_tecv_verify_mitigation_tecra
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CVE-2023-22655, also known as the Trusted Execution Register Access (TECRA) vulnerability.
_mitigate_tecv_verify_mitigation_tecra() {
	if \
		   use cpu_target_x86_ice_lake \
		|| use cpu_target_x86_sapphire_rapids \
		|| use cpu_target_x86_sapphire_rapids_edge_enhanced \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
	# Needs microcode mitigation
		CONFIG_CHECK="
			CPU_SUP_INTEL
		"
		ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for mitigation against CVE-2023-22655, also known as the Trusted Execution Register Access (TECRA) vulnerability, may lead to privilege escalation."
		check_extra_config
	fi
	if \
		use cpu_target_x86_ice_lake \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
		ewarn "Ice Lake still needs a BIOS firmware update for Trusted Execution Register Access (TECRA) mitigation."
	fi
	if \
		use cpu_target_x86_sapphire_rapids \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
		ewarn "Sapphire Rapids still needs a BIOS firmware update for Trusted Execution Register Access (TECRA) mitigation."
	fi
	if \
		use cpu_target_x86_sapphire_rapids_edge_enhanced \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
		ewarn "Sapphire Rapids Edge Enhanced still needs a BIOS firmware update for Trusted Execution Register Access (TECRA) mitigation."
	fi
}

# @FUNCTION: _mitigate_tecv_verify_mitigation_itlb_multihit
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CVE-2018-12207, also known as the iTLB multihit vulnerability or the Machine Check Error Avoidance vulnerability.
_mitigate_tecv_verify_mitigation_itlb_multihit() {
	:
}

# @FUNCTION: _mitigate_tecv_verify_mitigation_mpf
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CVE-2021-33120, also known as the Missing Page Fault (MPF) vulnerability.
_mitigate_tecv_verify_mitigation_mpf() {
	if \
		   use cpu_target_x86_snow_ridge \
		|| use cpu_target_x86_parker_ridge \
		|| use cpu_target_x86_elkhart_lake \
		|| use cpu_target_x86_jasper_lake \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
	# Needs microcode mitigation
		CONFIG_CHECK="
			CPU_SUP_INTEL
		"
		ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for mitigation against CVE-2021-33120, also know as the Missing Page Fault (MPF) vulnerability."
		check_extra_config
	fi
}

# @FUNCTION: _mitigate_tecv_verify_mitigation_umh
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CVE-2022-21180, also known as the Undefined MMIO Hang (UMH) vulnerability.
_mitigate_tecv_verify_mitigation_umh() {
	if \
		   use cpu_target_x86_skylake \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
	# Needs microcode mitigation
		CONFIG_CHECK="
			CPU_SUP_INTEL
		"
		ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for mitigation against CVE-2022-21180, also known as the Undefined MMIO Hang (UMH) vulnerability."
		check_extra_config
	fi
}

# @FUNCTION: _mitigate_tecv_verify_mitigation_blr
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CVE-2023-39368, also known as the Bus Lock Regulator (BLR) vulnerability.
_mitigate_tecv_verify_mitigation_blr() {
	if \
		   use cpu_target_x86_sapphire_rapids \
		|| use cpu_target_x86_alder_lake \
		|| use cpu_target_x86_catlow_golden_cove \
		|| use cpu_target_x86_raptor_lake_gen13 \
		|| use cpu_target_x86_raptor_lake_gen14 \
		|| use cpu_target_x86_alder_lake_n \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
	# Needs microcode mitigation
		CONFIG_CHECK="
			CPU_SUP_INTEL
		"
		ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for mitigation against CVE-2023-39368, also know as the Bus Lock Regulator (BLR) vulnerability."
		check_extra_config
	fi
}

# @FUNCTION: _mitigate_tecv_verify_mitigation_mcead
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CVE-2024-25939, also known as the Machine Check Error Avoidance Derivative (MCEAD) vulnerability.
_mitigate_tecv_verify_mitigation_mcead() {
	if \
		use cpu_target_x86_cooper_lake \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
	# Needs microcode mitigation
		CONFIG_CHECK="
			CPU_SUP_INTEL
		"
		ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for mitigation against CVE-2024-25939, also know as the Machine Check Error Avoidance Derivative (MCEAD) vulnerability."
		check_extra_config
	fi
}

# @FUNCTION: _mitigate_tecv_verify_mitigation_mcead
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CVE-2024-24968.
_mitigate_tecv_verify_mitigation_cve_2024_24968() {
	if \
		   use cpu_target_x86_ice_lake \
		|| use cpu_target_x86_rocket_lake \
		|| use cpu_target_x86_tiger_lake \
		|| use cpu_target_x86_alder_lake \
		|| use cpu_target_x86_raptor_lake_gen13 \
		|| use cpu_target_x86_idaville \
		|| use cpu_target_x86_whitley \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "intel" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
	# Needs microcode mitigation
		CONFIG_CHECK="
			CPU_SUP_INTEL
		"
		ERROR_CPU_SUP_INTEL="CONFIG_CPU_SUP_INTEL is required for mitigation against CVE-2024-24968."
		check_extra_config
	fi
}

# @FUNCTION: _mitigate_tecv_verify_mitigation_slb
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags and kernel command line to mitigate against CVE-2023-31315, SMM Lock Bypass (SLB) vulnerability.
_mitigate_tecv_verify_mitigation_slb() {
	if \
		   use cpu_target_x86_naples \
		|| use cpu_target_x86_rome \
		|| use cpu_target_x86_milan \
		|| use cpu_target_x86_milan-x \
		|| use cpu_target_x86_genoa \
		|| use cpu_target_x86_genoa-x \
		|| use cpu_target_x86_bergamo \
		|| use cpu_target_x86_siena \
		|| ( use auto && [[ "${FIRMWARE_VENDOR}" == "amd" && "${ARCH}" =~ ("amd64"|"x86") ]] ) \
	; then
	# Needs microcode mitigation
		CONFIG_CHECK="
			CPU_SUP_AMD
		"
		ERROR_CPU_SUP_AMD="CONFIG_CPU_SUP_AMD is required for SMM Lock Bypass (SLB) mitigation."
		check_extra_config
		if ! has_version ">=sys-kernel/linux-firmware-20240710" ; then
# Needed for custom-kernel USE flag due to RDEPEND being bypassed.
eerror ">=sys-kernel/linux-firmware-20240710 is required for SMM Lock Bypass (SLB) mitigation."
			die
		fi
	fi
	if [[ "${FIRMWARE_VENDOR}" == "amd" ]] ; then
ewarn "A BIOS firmware update is required for non datacenter for SMM Lock Bypass mitigation for CPUs and GPUs."
	fi
}

# @FUNCTION: _mitigate-tecv-dos_check_kernel_flags
# @INTERNAL
# @DESCRIPTION:
# Check the kernel config flags
_mitigate-tecv-dos_check_kernel_flags() {
	einfo "Kernel version:  ${KV_MAJOR}.${KV_MINOR}"

	if ! linux_config_src_exists ; then
eerror "Missing .config in /usr/src/linux"
		die
	fi

	local x="${KERNEL_DIR}/Makefile"
	local pv_major=$(grep "VERSION =" "${x}" | head -n 1 | grep -E -oe "[0-9]+")
	local pv_minor=$(grep "PATCHLEVEL =" "${x}" | head -n 1 | grep -E -oe "[0-9]+")
	local pv_patch=$(grep "SUBLEVEL =" "${x}" | head -n 1 | grep -E -oe "[0-9]+")
	local pv_extraversion=$(grep "EXTRAVERSION =" "${x}" | head -n 1 | cut -f 2 -d "=" | sed -E -e "s|[ ]+||g")
	local auto_version=$(_mitigate-tecv_get_fallback_version)
	if use auto && ver_test "${pv_major}.${pv_minor}" -lt "${auto_version}" ; then
		if [[ -L "${KERNEL_DIR}" ]] ; then
eerror "You need to switch the /usr/src/linux symlink to Linux Kernel >= ${auto_version} for USE=auto."
		else
eerror "You need to replace the kernel sources to Linux Kernel >= ${auto_version} for USE=auto."
		fi
eerror "Actual version:  ${pv_major}.${pv_minor}.${pv_patch}${pv_extraversion}"
		die
	fi

	if ! tc-is-cross-compiler && use custom-kernel ; then
		local required_version=$(_mitigate-tecv_get_required_version)
		[[ -z "${required_version}" ]] && required_version=$(_mitigate-tecv_get_fallback_version)
		is_microarch_selected || required_version=$(_mitigate-tecv_get_fallback_version)
einfo "The required Linux Kernel version is >= ${required_version}."
		local prev_kernel_dir="${KERNEL_DIR}"
		local L=(
			$(grep -l "EXTRAVERSION" $(ls "/usr/src/"*"/Makefile"))
		)
		local x
		for x in ${L[@]} ; do
			unset KV_FULL
			local pv_major=$(grep "VERSION =" "${x}" | head -n 1 | grep -E -oe "[0-9]+")
			local pv_minor=$(grep "PATCHLEVEL =" "${x}" | head -n 1 | grep -E -oe "[0-9]+")
			local pv_patch=$(grep "SUBLEVEL =" "${x}" | head -n 1 | grep -E -oe "[0-9]+")
			local pv_extraversion=$(grep "EXTRAVERSION =" "${x}" | head -n 1 | cut -f 2 -d "=" | sed -E -e "s|[ ]+||g")
	# linux-info's get_version() is spammy.
			if ver_test "${pv_major}.${pv_minor}" -lt "${required_version}" ; then
ewarn "${pv_major}.${pv_minor}.${pv_patch}${pv_extraversion} does not have mitigations and should be deleted."
			else
einfo "${pv_major}.${pv_minor}.${pv_patch}${pv_extraversion} has mitigations."
			fi
		done
	fi

	if linux_chkconfig_present "BPF" && ! use bpf ; then
eerror "Detected BPF in the kernel config.  Enable the bpf USE flag."
		die
	fi
	if linux_chkconfig_present "KVM" && ! use kvm ; then
eerror "Detected KVM in the kernel config.  Enable the kvm USE flag."
		die
	fi

	# Vulnerability classes
	# CE  - Code Execution
	# CI  - Compromisable Integrity (aka I:H)
	# DoS - Denial of Service
	# ID  - Information Disclosure (aka Data Leak)
	# PE  - Privilege Escalation

	# Security implications
	# PE -> ID
	# PE -> DoS
	# PE -> ID + DoS

	_mitigate_tecv_mitigate_with_ssp			# PE, CE
	_mitigate_tecv_mitigate_with_aslr			# PE

	# Notify if grub or the kernel config is incorrectly configured/tampered
	# or a copypasta-ed workaround.

	_mitigate_tecv_verify_mitigation_tecra			# PE, Mitigations against TECRA (2023)
	_mitigate_tecv_verify_mitigation_itlb_multihit		# DoS, Mitigations against iTLB multihit
	_mitigate_tecv_verify_mitigation_mpf			# ID, DoS, Mitigations against MPF (2021)
	_mitigate_tecv_verify_mitigation_umh			# DoS, Mitigations against UMH (2022)
	_mitigate_tecv_verify_mitigation_reptar			# EP, ID, DoS, Mitigations against Reptar (2023)
	_mitigate_tecv_verify_mitigation_blr			# DoS, Mitigations against BLR (2023)
	_mitigate_tecv_verify_mitigation_mcead			# DoS, Mitigations against MCEAD (2024)
	_mitigate_tecv_verify_mitigation_cve_2024_24968		# DoS (2024)
	_mitigate_tecv_verify_mitigation_slb			# CE, DoS, ID, CI, Mitigations against SLB (2024)
}

# @FUNCTION: _mitigate-tecv_get_fallback_version
# @DESCRIPTION:
# Get the fallback version when no microarches selected
_mitigate-tecv_get_fallback_version() {
	if [[ "${ARCH}" == "amd64" || "${ARCH}" == "x86" ]] ; then
		echo "5.4"
	fi
}

# @FUNCTION: _mitigate-tecv_get_required_version
# @DESCRIPTION:
# Get the required kernel version for custom-kernel.
_mitigate-tecv_get_required_version() {
	if [[ "${ARCH}" == "amd64" || "${ARCH}" == "x86" ]] ; then
		if \
			   use cpu_target_x86_apollo_lake \
			|| use cpu_target_x86_denverton \
		; then
			echo "5.4"
		fi
	fi
}

# @FUNCTION: mitigate-tecv_pkg_setup
# @DESCRIPTION:
# Check the kernel config
mitigate-tecv-dos_pkg_setup() {
	if tc-is-cross-compiler && use auto ; then
eerror "The auto USE flag can only be used in native builds."
		die
	fi
	use auto && einfo "FIRMWARE_VENDOR=${FIRMWARE_VENDOR}"
	if use kernel_linux ; then
		linux-info_pkg_setup
		_mitigate-tecv-dos_check_kernel_flags
	fi
}

fi
