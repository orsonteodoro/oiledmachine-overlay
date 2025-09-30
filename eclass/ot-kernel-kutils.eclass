# Copyright 2019-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
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
# using has_version if possible.  There is a big slow down introduced by
# emerge possibly unpickling the cached data plus extra loops.
#
#
# Intuitive time cost estimate:
#
# has_version:  Θ(lookup) = Θ(filesystem) + Θ(python context switch or load latency) + Θ(python loops) + Θ(cached pickle database access)
# ot-kernel_has_version without USE flags:  Θ(lookup) = Θ(filesystem)
# ot-kernel_has_version with USE flags:  Θ(lookup) = Θ(filesystem) + Θ(Boyer-Moore)
#
# The estimate just highlights the unintended consequence of platform independence.
# Θ (theta) is average case Big O measuring time complexity.
#
#
# BUG:  If the results could ambiguous and be fatal, use ot-kernel_has_version_slow instead.
# Example sys-apps/systemd and sys-apps/systemd-utils with OpenRC.
#
# You may ignore this recommendation if it meets the first if conditional block
# case below.
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
		# The find command is slow.  Don't use it.
		if ls "${ESYSROOT}/var/db/pkg/${pkg}"*"/CONTENTS" >/dev/null 2>&1 ; then
			return 0
		fi
	fi
	return 1
}

# @FUNCTION: ot-kernel_has_version_slow
# @DESCRIPTION:
# Alias
ot-kernel_has_version_slow() {
	local pkg="${1}"
	if has_version "${pkg}" ; then
		return 0
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

	# The find command is slow.  Don't use it.
	local Y=(
		$(cat "${ESYSROOT}/var/db/pkg/${pkg}"*"/USE" 2>/dev/null)
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
		:
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
		:
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
			cmd=$(echo "${cmd}" | sed -r -e "s#(^| )${x}#\1#g")
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

# @FUNCTION: ot-kernel_has_acpi_support
# @DESCRIPTION:
# Checks for ACPI support
ot-kernel_has_acpi_support() {
	if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] ; then
		if grep -q -E -e "^CONFIG_X86_32=y" ; then
			return 1
		else
			return 0
		fi
	elif [[ "${arch}" == "arm64" ]] ; then
		if grep -q -E -e "^CONFIG_EFI=y" "${path_config}" ; then
			return 0
		fi
	elif [[ "${arch}" == "loongarch" ]] ; then
		return 0
	elif [[ "${arch}" == "riscv" ]] ; then
		if grep -q -E -e "^CONFIG_EFI=y" "${path_config}" && grep -q -E -e "^CONFIG_64BIT=y" "${path_config}" ; then
			return 0
		fi
	fi
	return 1
}

# @FUNCTION: ot-kernel_has_apm_support
# @DESCRIPTION:
# Checks for APM support
ot-kernel_has_apm_support() {
	if [[ "${arch}" == "x86" || "${arch}" == "x86_64" ]] && grep -q -E -e "^CONFIG_X86_32=y" "${path_config}" && grep -q -E -e "^CONFIG_PM_SLEEP=y" "${path_config}" ; then
		return 0
	else
		return 1
	fi
}

# @FUNCTION: ot-kernel_get_vendor_from_cpuinfo
# @DESCRIPTION:
ot-kernel_get_vendor_from_cpuinfo() {
	local vendor=$(cat "/proc/cpuinfo" \
		| grep "vendor_id" \
		| sed -E -e "s|[[:space:]]+| |g" \
		| cut -f 3 -d " " \
		| tr "[A-Z]" "[a-z]" \
		| head -n 1)
	echo "${vendor}"
}

# @FUNCTION: ot-kernel_get_vendor_from_flags
# @DESCRIPTION:
# Gets the implied vendor name from -march= or -mtune= or -mips* from user
# compiler flags to improve auto detect.
ot-kernel_get_vendor_from_flags() {
	declare -A MODEL_TO_VENDOR_NAME_MARCH=(
		["native"]="generic"
		["unset"]="generic"

		["x86-64"]="generic"
		["x86-64-v2"]="generic"
		["x86-64-v3"]="generic"
		["x86-64-v4"]="generic"
		["i386"]="intel"
		["i486"]="intel"
		["i586"]="intel"
		["pentium"]="intel"
		["lakemont"]="intel"
		["pentium-mmx"]="intel"
		["pentiumpro"]="intel"
		["i686"]="intel"
		["pentium2"]="intel"
		["pentium3"]="intel"
		["pentium3m"]="intel"
		["pentium-m"]="intel"
		["pentium4"]="intel"
		["pentium4m"]="intel"
		["prescott"]="intel"
		["nocona"]="intel"
		["core2"]="intel"
		["nehalem"]="intel"
		["corei7"]="intel"
		["westmere"]="intel"
		["sandybridge"]="intel"
		["corei7-avx"]="intel"
		["ivybridge"]="intel"
		["core-avx-i"]="intel"
		["haswell"]="intel"
		["core-avx2"]="intel"
		["broadwell"]="intel"
		["skylake"]="intel"
		["skylake-avx512"]="intel"
		["cascadelake"]="intel"
		["cannonlake"]="intel"
		["cooperlake"]="intel"
		["icelake-client"]="intel"
		["icelake-server"]="intel"
		["tigerlake"]="intel"
		["rocketlake"]="intel"
		["alderlake"]="intel"
		["raptorlake"]="intel"
		["meteorlake"]="intel"
		["gracemont"]="intel"
		["arrowlake"]="intel"
		["arrowlake-s"]="intel"
		["lunarlake"]="intel"
		["pantherlake"]="intel"
		["sapphirerapids"]="intel"
		["emeraldrapids"]="intel"
		["graniterapids"]="intel"
		["graniterapids-d"]="intel"
		["diamondrapids"]="intel"
		["bonnell"]="intel"
		["atom"]="intel"
		["silvermont"]="intel"
		["slm"]="intel"
		["goldmont"]="intel"
		["goldmont-plus"]="intel"
		["tremont"]="intel"
		["sierraforest"]="intel"
		["grandridge"]="intel"
		["clearwaterforest"]="intel"
		["k6"]="amd"
		["k6-2"]="amd"
		["k6-3"]="amd"
		["athlon"]="amd"
		["athlon-tbird"]="amd"
		["athlon-4"]="amd"
		["athlon-xp"]="amd"
		["athlon-mp"]="amd"
		["k8"]="amd"
		["opteron"]="amd"
		["athlon64"]="amd"
		["athlon-fx"]="amd"
		["k8-sse3"]="amd"
		["opteron-sse3"]="amd"
		["athlon64-sse3"]="amd"
		["amdfam10"]="amd"
		["barcelona"]="amd"
		["bdver1"]="amd"
		["bdver2"]="amd"
		["bdver3"]="amd"
		["bdver4"]="amd"
		["znver1"]="amd"
		["znver2"]="amd"
		["znver3"]="amd"
		["znver4"]="amd"
		["znver5"]="amd"
		["btver1"]="amd"
		["btver2"]="amd"
		["winchip-c6"]="idt"
		["winchip2"]="idt"
		["c3"]="via"
		["c3-2"]="via"
		["c7"]="via"
		["samuel-2"]="via"
		["nehemiah"]="via"
		["esther"]="via"
		["eden-x2"]="via"
		["eden-x4"]="via"
		["nano"]="via"
		["nano-1000"]="via"
		["nano-2000"]="via"
		["nano-3000"]="via"
		["nano-x2"]="via"
		["nano-x4"]="via"
		["lujiazui"]="zhaoxin"
		["yongfeng"]="zhaoxin"
		["shijidadao"]="zhaoxin"
		["geode"]="amd"

		["armv4t"]="arm"
		["armv5t"]="arm"
		["armv5te"]="arm"
		["armv6"]="arm"
		["armv6-m"]="arm"
		["armv6s-m"]="arm"
		["armv6j"]="arm"
		["armv6k"]="arm"
		["armv6kz"]="arm"
		["armv6t2"]="arm"
		["armv6z"]="arm"
		["armv6zk"]="arm"
		["armv7"]="arm"
		["armv7-a"]="arm"
		["armv7-m"]="arm"
		["armv7ve"]="arm"
		["armv8-a"]="arm"
		["armv8.1-a"]="arm"
		["armv8.2-a"]="arm"
		["armv8.3-a"]="arm"
		["armv8.4-a"]="arm"
		["armv8.5-a"]="arm"
		["armv8.6-a"]="arm"
		["armv8.7-a"]="arm"
		["armv8.8-a"]="arm"
		["armv8.9-a"]="arm"
		["armv9-a"]="arm"
		["armv9.1-a"]="arm"
		["armv9.2-a"]="arm"
		["armv9.3-a"]="arm"
		["armv9.4-a"]="arm"
		["armv9.5-a"]="arm"
		["armv7-r"]="arm"
		["armv7e-m"]="arm"
		["armv8-m.base"]="arm"
		["armv8-m.main"]="arm"
		["armv8-r"]="arm"
		["armv8.1-m.main"]="arm"
		["iwmmxt"]="intel/marvell"
		["iwmmxt2"]="intel"

		["mips1"]="generic"
		["mips2"]="generic"
		["mips3"]="generic"
		["mips4"]="generic"
		["mips32"]="generic"
		["mips32r2"]="generic"
		["mips32r3"]="generic"
		["mips32r5"]="generic"
		["mips32r6"]="generic"
		["mips64"]="generic"
		["mips64r2"]="generic"
		["mips64r3"]="generic"
		["mips64r5"]="generic"
		["mips64r6"]="generic"
		["4kc"]="mips"
		["4km"]="mips"
		["4kp"]="mips"
		["4ksc"]="mips"
		["4kec"]="mips"
		["4kem"]="mips"
		["4kep"]="mips"
		["4ksd"]="mips"
		["5kc"]="mips"
		["5kf"]="mips"
		["20kc"]="mips"
		["24kc"]="mips"
		["24kf2_1"]="mips"
		["24kf1_1"]="mips"
		["24kec"]="mips"
		["24kef2_1"]="mips"
		["24kef1_1"]="mips"
		["34kc"]="mips"
		["34kf2_1"]="mips"
		["34kf1_1"]="mips"
		["34kn"]="mips"
		["74kc"]="mips"
		["74kf2_1"]="mips"
		["74kf1_1"]="mips"
		["74kf3_2"]="mips"
		["1004kc"]="mips"
		["1004kf2_1"]="mips"
		["1004kf1_1"]="mips"
		["i6400"]="imagination"
		["i6500"]="imagination"
		["interaptiv"]="mips"
		["loongson2e"]="loongson"
		["loongson2f"]="loongson"
		["loongson3a"]="loongson"
		["gs464"]="imagination"
		["gs464e"]="loongson"
		["gs264e"]="loongson"
		["m4k"]="mips"
		["m14k"]="mips"
		["m14kc"]="mips"
		["m14ke"]="mips"
		["m14kec"]="mips"
		["m5100"]="imagination"
		["m5101"]="imagination"
		["octeon"]="cavium/marvell"
		["octeon+"]="cavium/marvell"
		["octeon2"]="cavium/marvell"
		["octeon3"]="cavium/marvell"
		["orion"]="amd"
		["p5600"]="imagination"
		["p6600"]="imagination"
		["r2000"]="mips"
		["r3000"]="mips"
		["r3900"]="mips"
		["r4000"]="mips"
		["r4400"]="mips"
		["r4600"]="mips"
		["r4650"]="mips"
		["r4700"]="mips"
		["r5900"]="mips"
		["r6000"]="mips"
		["r8000"]="mips"
		["rm7000"]="qed"
		["rm9000"]="pmc-sierra"
		["r10000"]="mips"
		["r12000"]="sgi"
		["r14000"]="sgi"
		["r16000"]="sgi"
		["sb1"]="broadcom"
		["sr71000"]="sandcraft"
		["vr4100"]="nec"
		["vr4111"]="nec"
		["vr4120"]="nec"
		["vr4130"]="nec"
		["vr4300"]="nec"
		["vr5000"]="nec"
		["vr5400"]="nec"
		["vr5500"]="nec"
		["xlr"]="broadcom"
		["xlp"]="cavium"

		["loongarch64"]="loongson"
		["la464"]="loongson"
		["la664"]="loongson"
		["la64v1.0"]="loongson"
		["la64v1.1"]="loongson"

		["1.0"]="hp"
		["1.1"]="hp"
		["2.0"]="hp"
	)

	# -mtune=
	declare -A MODEL_TO_VENDOR_NAME_MTUNE=(
		["generic"]="generic"

		["cortex-a35"]="arm"
		["cortex-a53"]="arm"
		["cortex-a55"]="arm"
		["cortex-a57"]="arm"
		["cortex-a72"]="arm"
		["cortex-a73"]="arm"
		["cortex-a75"]="arm"
		["cortex-a76"]="arm"
		["cortex-a76ae"]="arm"
		["cortex-a77"]="arm"
		["cortex-a65"]="arm"
		["cortex-a65ae"]="arm"
		["cortex-a34"]="arm"
		["cortex-a78"]="arm"
		["cortex-a78ae"]="arm"
		["cortex-a78c"]="arm"
		["ares"]="arm"
		["exynos-m1"]="samsung"
		["emag"]="ampere"
		["falkor"]="qualcomm"
		["oryon-1"]="qualcomm"
		["neoverse-512tvb"]="arm"
		["neoverse-e1"]="arm"
		["neoverse-n1"]="arm"
		["neoverse-n2"]="arm"
		["neoverse-v1"]="arm"
		["neoverse-v2"]="arm"
		["grace"]="nvidia"
		["neoverse-v3"]="arm"
		["neoverse-v3ae"]="arm"
		["neoverse-n3"]="arm"
		["olympus"]="microsoft"
		["cortex-a725"]="arm"
		["cortex-x925"]="arm"
		["qdf24xx"]="qualcomm"
		["saphira"]="ampere"
		["phecda"]="marvell"
		["xgene1"]="amcc"
		["vulcan"]="cavium"
		["octeontx"]="marvell"
		["octeontx81"]="marvell"
		["octeontx83"]="cavium/marvell"
		["octeontx2"]="marvell"
		["octeontx2t98"]="marvell"
		["octeontx2t96"]="marvell"
		["octeontx2t93"]="marvell"
		["octeontx2f95"]="marvell"
		["octeontx2f95n"]="marvell"
		["octeontx2f95mm"]="marvell"
		["a64fx"]="fujitsu"
		["fujitsu-monaka"]="fujitsu"
		["thunderx"]="marvell"
		["thunderxt88"]="marvell"
		["thunderxt88p1"]="marvell"
		["thunderxt81"]="marvell"
		["tsv110"]="hisilicon"
		["thunderxt83"]="marvell"
		["thunderx2t99"]="marvell"
		["thunderx3t110"]="marvell"
		["zeus"]="arm"
		["cortex-a57.cortex-a53"]="arm"
		["cortex-a72.cortex-a53"]="arm"
		["cortex-a73.cortex-a35"]="arm"
		["cortex-a73.cortex-a53"]="arm"
		["cortex-a75.cortex-a55"]="arm"
		["cortex-a76.cortex-a55"]="arm"
		["cortex-r82"]="arm"
		["cortex-r82ae"]="arm"
		["cortex-x1"]="arm"
		["cortex-x1c"]="arm"
		["cortex-x2"]="arm"
		["cortex-x3"]="arm"
		["cortex-x4"]="arm"
		["cortex-a510"]="arm"
		["cortex-a520"]="arm"
		["cortex-a520ae"]="arm"
		["cortex-a710"]="arm"
		["cortex-a715"]="arm"
		["cortex-a720"]="arm"
		["cortex-a720ae"]="arm"
		["ampere1"]="ampere"
		["ampere1a"]="ampere"
		["ampere1b"]="ampere"
		["cobalt-100"]="microsoft"
		["apple-m1"]="apple"
		["apple-m2"]="apple"
		["apple-m3"]="apple"
		["native"]="generic"

		["rocket"]="sifive"
		["sifive-3-series"]="sifive"
		["sifive-5-series"]="sifive"
		["sifive-7-series"]="sifive"
		["sifive-p400-series"]="sifive"
		["sifive-p600-series"]="sifive"
		["tt-ascalon-d8"]="t-head"
		["thead-c906"]="t-head"
		["xt-c908"]="t-head"
		["xt-c908v"]="t-head"
		["xt-c910"]="t-head"
		["xt-c910v2"]="t-head"
		["xt-c920"]="t-head"
		["xt-c920v2"]="t-head"
		["xiangshan-nanhu"]="open-source"
		["xiangshan-kunminghu"]="open-source"
		["generic-ooo"]="generic"
		["size"]="generic"
		["mips-p8700"]="mobileye"
	)

	# -mcpu=
	declare -A MODEL_TO_VENDOR_NAME_MCPU=(
		["401"]="ibm"
		["403"]="ibm/amcc"
		["405"]="ibm/amcc/xilinx/synopsys/hifn/culturecom"
		["405fp"]="ibm/xilinx/amcc/hifn/culturecom/synopsys"
		["440"]="ibm/amcc/xilinx"
		["440fp"]="ibm/amcc/xilinx"
		["464"]="ibm/amcc"
		["464fp"]="ibm/amcc"
		["476"]="ibm/lsi"
		["476fp"]="ibm/lsi"
		["505"]="motorola"
		["601"]="ibm/motorola" # aim alliance
		["602"]="ibm/motorola"
		["603"]="ibm/motorola/freescale/chip-supply/qed/atmel/honeywell"
		["603e"]="ibm/motorola/freescale"
		["604"]="apple/ibm/motorola"
		["604e"]="apple/ibm/motorola"
		["620"]="apple/ibm/motorola"
		["630"]="ibm/motorola/freescale" # aim alliance
		["740"]="apple/ibm/motorola"
		["7400"]="apple/ibm/motorola"
		["7450"]="apple/ibm/motorola"
		["750"]="apple/ibm/motorola"
		["801"]="motorola"
		["821"]="motorola/freescale"
		["823"]="motorola/freescale"
		["860"]="motorola/freescale"
		["970"]="ibm/apple"
		["8540"]="freescale"
		["a2"]="ibm"
		["e300c2"]="freescale/nxp"
		["e300c3"]="freescale/nxp"
		["e500mc"]="freescale/nxp"
		["e500mc64"]="freescale"
		["e5500"]="freescale"
		["e6500"]="freescale/nxp"
		["ec603e"]="motorola/ibm/freescale"
		["G3"]="apple/ibm/motorola"
		["G4"]="apple/ibm/motorola"
		["G5"]="apple/ibm/motorola"
		["titan"]="amcc"
		["power3"]="ibm"
		["power4"]="ibm"
		["power5"]="ibm"
		["power5+"]="ibm"
		["power6"]="ibm"
		["power6x"]="ibm"
		["power7"]="ibm"
		["power8"]="ibm"
		["power9"]="ibm"
		["power10"]="ibm"
		["power11"]="ibm"
		["powerpc"]="generic"
		["powerpc64"]="generic"
		["powerpc64le"]="generic"
		["rs64"]="ibm"
		["native"]="generic"

		["sifive-e20"]="sifive"
		["sifive-e21"]="sifive"
		["sifive-e24"]="sifive"
		["sifive-e31"]="sifive"
		["sifive-e34"]="sifive"
		["sifive-e76"]="sifive"
		["sifive-s21"]="sifive"
		["sifive-s51"]="sifive"
		["sifive-s54"]="sifive"
		["sifive-s76"]="sifive"
		["sifive-u54"]="sifive"
		["sifive-u74"]="sifive"
		["sifive-x280"]="sifive"
		["sifive-p450"]="sifive"
		["sifive-p670"]="sifive"
		["thead-c906"]="t-head"
		["xt-c908"]="t-head"
		["xt-c908v"]="t-head"
		["xt-c910"]="t-head"
		["xt-c910v2"]="t-head"
		["xt-c920"]="t-head"
		["xt-c920v2"]="t-head"
		["tt-ascalon-d8"]="tenstorrent"
		["xiangshan-nanhu"]="open-source"
		["xiangshan-kunminghu"]="open-source"
		["mips-p8700"]="mobileye"

		["ev4"]="dec"
		["ev45"]="dec"
		["21064"]="dec"
		["ev5"]="dec"
		["21164"]="dec"
		["ev56"]="dec"
		["21164a"]="dec"
		["pca56"]="nxp/freescale"
		["21164pc"]="digital/mitsubishi"
		["21164PC"]="digital/mitsubishi"
		["ev6"]="dec"
		["21264"]="dec"
		["ev67"]="dec"
		["21264a"]="dec"

		["v7"]="generic"
		["cypress"]="cypress"
		["v8"]="generic"
		["supersparc"]="sun"
		["hypersparc"]="ross"
		["leon"]="aeroflex-gaisler"
		["leon3"]="aeroflex-gaisler"
		["leon3v7"]="gaisler"
		["leon5"]="gaisler"
		["sparclite"]="generic"
		["f930"]="fujitsu"
		["f934"]="fujitsu"
		#["sparclite86x"]="" # Human hallucination?
		["sparclet"]="generic"
		["tsc701"]="temic"
		["v9"]="generic"
		["ultrasparc"]="sun"
		["ultrasparc3"]="sun"
		["niagara"]="sun"
		["niagara2"]="sun"
		["niagara3"]="sun/oracle"
		["niagara4"]="oracle"
		#["niagara7"]="" # Human hallucination?
		["m8"]="oracle"
	)

	local flags

	local vendor="unknown"
	local model="unknown"
	local x
	for x in ${CFLAGS} ${CPU_MODEL} ; do
		if [[ "${x}" =~ "-march" ]] ; then
			case ${x} in
				"-march=native")
					vendor=$(ot-kernel_get_vendor_from_cpuinfo)
					break
					;;
				"-march=octeon+")
					vendor="cavium/marvell"
					break
					;;
				"-mpa-risc-1-0"|"-mpa-risc-1-1"|"-mpa-risc-2-0")
					vendor="hp"
					break
					;;
			esac
			model="${x#*=}"
			model="${model%%+*}"
			vendor="${MODEL_TO_VENDOR_NAME_MARCH[${model}]}"
			break
		elif [[ "${x}" =~ "-mtune" ]] ; then
			model="${x#*=}"
			model="${model%%+*}"
			vendor="${MODEL_TO_VENDOR_NAME_MTUNE[${model}]}"
			break
		elif [[ "${x}" =~ "-mcpu" ]] ; then
			model="${x#*=}"
			vendor="${MODEL_TO_VENDOR_NAME_MCPU[${model}]}"
			break
		else
			case ${x} in
				"-mips1"|"-mips2"|"-mips3"|"-mips4"|"-mips32"|"-mips32r3"|"-mips32r5"|"-mips32r6"|"-mips64"|"-mips64r2"|"-mips64r3"|"-mips64r5"|"-mips64r6")
					vendor="generic"
					break
					;;
			esac
		fi
	done
	unset MODEL_TO_VENDOR_NAME_MARCH
	unset MODEL_TO_VENDOR_NAME_MTUNE
	unset MODEL_TO_VENDOR_NAME_MCPU
	echo "${vendor}"
}

# @FUNCTION: ot-kernel_get_cpu_model_from_flags
# @DESCRIPTION:
# Gets the CPU model from -march= or -mtune= or -mips* from user compiler flags
# to improve auto detect.
ot-kernel_get_cpu_model_from_flags() {
	local model="unknown"
	local x
	for x in ${CFLAGS} ${CPU_MODEL} ; do
	# The name in canonical form for easy processing.
		if [[ "${x}" =~ "-march" ]] ; then
			case ${x} in
				"-march=octeon+")
					model="octeon+"
					break
					;;
				"-mpa-risc-1-0"|"-march=1.0")
					model="mpa-risc-1-0"
					break
					;;
				"-mpa-risc-1-1"|"-march=1.1")
					model="mpa-risc-1-1"
					break
					;;
				"-mpa-risc-2-0"|"-march=2.0")
					model="mpa-risc-2-0"
					break
					;;
			esac
			model="${x#*=}"
			model="${model%%+*}"
			break
		elif [[ "${x}" =~ "-mtune" ]] ; then
			model="${x#*=}"
			model="${model%%+*}"
			break
		else
			case ${x} in
				"-mips1"|"-mips2"|"-mips3"|"-mips4"|"-mips32"|"-mips32r3"|"-mips32r5"|"-mips32r6"|"-mips64"|"-mips64r2"|"-mips64r3"|"-mips64r5"|"-mips64r6")
					model="${x/-}"
					break
					;;
			esac
		fi
	done
	echo "${model}"
}

# @FUNCTION: ot-kernel_get_cpu_vendor
# @DESCRIPTION:
# Gets the vendor name for proper config.
#
# It will auto detect the implied vendor name based on the user's compiler
# flags.
#
# The CPU_VENDOR can be used to do a manual override.
ot-kernel_get_cpu_vendor() {
	local vendor
	# Set by environment variable

	if [[ -n "${CPU_VENDOR}" ]] ; then
		echo "${CPU_VENDOR,,}"
		return
	fi

	# Auto detect based on user's compiler flags
	local vendor=$(ot-kernel_get_vendor_from_flags)
	echo "${vendor}"
}

# @FUNCTION: ot-kernel_get_cpu_model
# @DESCRIPTION:
# Gets the model name for proper config.
#
# It will auto detect the implied vendor name based on the user's compiler
# flags.
#
# The CPU_VENDOR can be used to do a manual override.
ot-kernel_get_cpu_model() {
	local model
	# Set by environment variable

	if [[ -n "${CPU_MODEL}" ]] ; then
		echo "${CPU_MODEL}"
		return
	fi

	# Auto detect based on user's compiler flags
	local model=$(ot-kernel_get_cpu_model_from_flags)
	echo "${model}"
}

# @FUNCTION: ot-kernel_has_heterogeneous_power_cores
# @DESCRIPTION:
# Reports if the arch has asymmetric power cores
ot-kernel_has_heterogeneous_power_cores() {
	if [[ -n "${CPU_HETEROGENEOUS_POWER_CORES}" ]] ; then
		return "${CPU_HETEROGENEOUS_POWER_CORES}"
	fi

	local model=$(ot-kernel_get_cpu_model)
	case ${model} in
		"cortex-a57.cortex-a53" | \
		"cortex-a72.cortex-a53" | \
		"cortex-a73.cortex-a35" | \
		"cortex-a73.cortex-a53" | \
		"cortex-a75.cortex-a55" | \
		"cortex-a76.cortex-a55" | \
		"alderlake" | \
		"raptorlake" | \
		"meteorlake" | \
		"lunarlake" | \
		"pantherlake" )
			return 0
			;;
	esac
	return 1
}

# @FUNCTION: ot-kernel_has_multicore
# @DESCRIPTION:
# Reports if the arch has multicore support
ot-kernel_has_multicore() {
	if [[ -n "${CPU_MULTICORE}" ]] ; then
		return "${CPU_MULTICORE}"
	fi

	# TODO finish
	local model=$(ot-kernel_get_cpu_model)
	case ${model} in
		"core2" | \
		"nehalem" | \
		"corei7" | \
		"westmere" | \
		"sandybridge" | \
		"corei7-avx" | \
		"ivybridge" | \
		"core-avx-i" | \
		"haswell" | \
		"core-avx2" | \
		"broadwell" | \
		"skylake" | \
		"skylake-avx512" | \
		"cascadelake" | \
		"cannonlake" | \
		"cooperlake" | \
		"icelake-client" | \
		"icelake-server" | \
		"tigerlake" | \
		"rocketlake" | \
		"alderlake" | \
		"raptorlake" | \
		"meteorlake" | \
		"gracemont" | \
		"arrowlake" | \
		"arrowlake-s" | \
		"lunarlake" | \
		"pantherlake" | \
		"sapphirerapids" | \
		"emeraldrapids" | \
		"graniterapids" | \
		"graniterapids-d" | \
		"diamondrapids" | \
		"bonnell" | \
		"atom" | \
		"silvermont" | \
		"slm" | \
		"goldmont" | \
		"goldmont-plus" | \
		"tremont" | \
		"sierraforest" | \
		"grandridge" | \
		"clearwaterforest" | \
		"amdfam10" | \
		"barcelona" | \
		"bdver1" | \
		"bdver2" | \
		"bdver3" | \
		"bdver4" | \
		"znver1" | \
		"znver2" | \
		"znver3" | \
		"znver4" | \
		"znver5" | \
		"btver1" | \
		"btver2" | \
		"eden-x2" | \
		"eden-x4" | \
		"lujiazui" | \
		"yongfeng" | \
		"shijidadao" | \
		"apple-m1" | \
		"apple-m2" | \
		"apple-m3" | \
		"cobalt-100" | \
		"cortex-a57.cortex-a53" | \
		"cortex-a72.cortex-a53" | \
		"cortex-a73.cortex-a35" | \
		"cortex-a73.cortex-a53" | \
		"cortex-a75.cortex-a55" | \
		"cortex-a76.cortex-a55" | \
		"octeontx" | \
		"octeontx81" | \
		"octeontx83" | \
		"octeontx2" | \
		"octeontx2t96" | \
		"octeontx2t98" | \
		"octeontx2t93" | \
		"octeontx2f95" | \
		"octeontx2f95n" | \
		"thunderx2t99" | \
		"thunderx3t110" | \
		"xgene1" )
			return 0
			;;
	esac
	return 1
}

OT_KERNEL_KUTILS_ECLASS="1"
fi
