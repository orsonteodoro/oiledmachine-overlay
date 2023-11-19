# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit linux-info toolchain-funcs

MAINTAINER_MODE=0

DESCRIPTION="ROCk DKMS kernel module"
HOMEPAGE="
https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver
"
LICENSE="
	GPL-2
	MIT
"
#KEYWORDS="~amd64" # Ebuild not finished
PV_MAJOR_MINOR=$(ver_cut 1-2 ${PV})
ROCK_VER="${PV}"
SUFFIX="${PV_MAJOR_MINOR}"
KV="6.0.0" # See https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/blob/rocm-5.5.1/Makefile#L2
KVS=(
# Commented out means EOL kernel.
#	"5.17" # U 22.04 Desktop OEM
	"5.15" # U 22.04 Desktop HWE, 22.04 Server generic
#	"5.14" # S 15.4; R 9.0, 9.1, 9.2
#	"5.8"  # U 20.04 HWE
	"5.4"  # U 20.04 generic
#	"5.3"  # S 15.3
#	"4.18" # R 8.4, 8.5, 8.6, 8.7
#	"3.10" # R 7.9
)
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
acpi +build +check-mmu-notifier custom-kernel directgma hybrid-graphics
numa +sign-modules ssg strict-pairing
r2
"
REQUIRED_USE="
	hybrid-graphics? (
		acpi
	)
"
if [[ "${MAINTAINER_MODE}" == "1" ]] ; then
# For verification of patch correctness
	KV_NOT_SUPPORTED_MAX="99999999"
	KV_SUPPORTED_MIN="3.10"
else
	KV_NOT_SUPPORTED_MAX="5.18" # Exclusive
	KV_SUPPORTED_MIN="5.4"
fi
gen_kernel_pairs() {
	local FLAVORS=(
		"sys-kernel/gentoo-kernel"
		"sys-kernel/gentoo-kernel-bin"
		"sys-kernel/gentoo-sources"
		"sys-kernel/ot-sources"
		"sys-kernel/pf-sources"
		"sys-kernel/rt-sources"
		"sys-kernel/vanilla-sources"
		"sys-kernel/zen-sources"
	)
	local kv
	for flavor in ${FLAVORS[@]} ; do
		for kv in ${KVS[@]} ; do
			local kv_min="$(ver_cut 1-2 ${kv})"
			local kv_max="${kv%%.*}.$(($(ver_cut 2 ${kv}) + 1))"
			echo "
			(
				>=${flavor}-${kv_min}
				<${flavor}-${kv_max}:=
			)
			"
			if [[ "${MAINTAINER_MODE}" == "1" ]] ; then
				echo "
			(
				>=${flavor}-0
				<${flavor}-99999999
			)
				"
			fi
		done
	done
}
AMDGPU_FIRMWARE_PV="6.0.5.50501"
CDEPEND="
	!custom-kernel? (
		|| (
			$(gen_kernel_pairs)
		)
	)
	!strict-pairing? (
		>=sys-firmware/amdgpu-dkms-firmware-${AMDGPU_FIRMWARE_PV}
	)
	strict-pairing? (
		~sys-firmware/amdgpu-dkms-firmware-${AMDGPU_FIRMWARE_PV}
	)
"
RDEPEND="
	!sys-kernel/rock-dkms:0
	${CDEPEND}
	>=sys-kernel/dkms-1.95
	sys-devel/autoconf
	sys-devel/automake
"
DEPEND="
	${CDEPEND}
	${RDEPEND}
"
BDEPEND="
	${BDEPEND}
	sys-apps/grep[pcre]
"
SRC_URI="
https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/usr/src/amdgpu-${SUFFIX}"
DKMS_PKG_NAME="amdgpu"
DKMS_PKG_VER="${SUFFIX}"
DC_VER="3.2.223" # See https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/blob/rocm-5.5.1/drivers/gpu/drm/amd/display/dc/dc.h#L48

PATCHES=(
	"${FILESDIR}/rock-dkms-3.10_p27-makefile-recognize-gentoo.patch"
	"${FILESDIR}/rock-dkms-3.1_p35-add-header-to-kcl_fence_c.patch"
	"${FILESDIR}/rock-dkms-5.4.3-seq_printf-header.patch"
	"${FILESDIR}/rock-dkms-5.4.3-cc-contains-gcc.patch"
	"${FILESDIR}/rock-dkms-5.4.3-pre-build-change-kcl-defs.patch"
)

pkg_setup_warn() {
ewarn
ewarn "Disabling build is not recommended.  It is intended for unattended"
ewarn "installs.  You are responsible for the following .config flags:"
ewarn

	if ! linux_config_exists ; then
ewarn "You are missing a .config file in your linux sources."
	fi

	if ! linux_chkconfig_builtin "MODULES" ; then
ewarn "You need loadable modules support in your .config."
	fi

	# 5.5 Inclusive
	CONFIG_CHECK="!DRM_AMD_DC_DSC_SUPPORT"
	WARNING_DRM_AMD_DC_DSC_SUPPORT=\
"CONFIG_DRM_AMD_DC_DSC_SUPPORT must be set to =n in the kernel."
	check_extra_config

	CONFIG_CHECK="DRM"
	WARNING_DRM=\
"CONFIG_DRM must be set to =y in the kernel."
	check_extra_config

	CONFIG_CHECK="KALLSYMS"
	WARNING_KALLSYMS=\
"CONFIG_KALLSYMS must be set to =y in the kernel."
	check_extra_config

	CONFIG_CHECK="!TRIM_UNUSED_KSYMS"
	WARNING_TRIM_UNUSED_KSYMS=\
"CONFIG_TRIM_UNUSED_KSYMS should not be set and the kernel recompiled without "\
"it."
	check_extra_config

	CONFIG_CHECK="~AMD_IOMMU_V2"
	WARNING_MMU_NOTIFIER=\
"CONFIG_AMD_IOMMU_V2 must be set to =y in the kernel or CONFIG_HSA_AMD will "\
"be inaccessible in \`make menuconfig\`."
	check_extra_config

	if use check-mmu-notifier ; then
		if ! linux_chkconfig_module "HSA_AMD" ; then
			if ! linux_chkconfig_builtin "HSA_AMD" ; then
ewarn "CONFIG_HSA_AMD must be set to =y or =m in the kernel .config."
			fi
		fi
	fi

	CONFIG_CHECK="~MMU_NOTIFIER"
	WARNING_MMU_NOTIFIER=\
"CONFIG_MMU_NOTIFIER must be set to =y in the kernel or it will fail in the "\
"link stage."
	check_extra_config

	CONFIG_CHECK="~DRM_AMD_ACP"
	WARNING_MFD_CORE=\
"CONFIG_DRM_AMD_ACP (Enable ACP IP support) must be set to =y in the kernel "\
"or it will fail in the link stage."
	check_extra_config

	CONFIG_CHECK="~MFD_CORE"
	WARNING_MFD_CORE=\
"CONFIG_MFD_CORE must be set to =y or =m in the kernel or it will fail in "\
"the link stage."
	check_extra_config

	if use directgma || use ssg ; then
		# needs at least ZONE_DEVICE, rest are dependencies for it
		CONFIG_CHECK=\
"~ZONE_DEVICE ~MEMORY_HOTPLUG ~MEMORY_HOTREMOVE ~SPARSEMEM_VMEMMAP "\
"~ARCH_HAS_PTE_DEVMAP"
		WARNING_ZONE_DEVICE=\
"CONFIG_ZONE_DEVICE must be set to =y in the kernel .config."
		WARNING_MEMORY_HOTPLUG=\
"CONFIG_MEMORY_HOTPLUG must be set to =y in the kernel .config."
		WARNING_MEMORY_HOTREMOVE=\
"CONFIG_MEMORY_HOTREMOVE must be set to =y in the kernel .config."
		WARNING_SPARSEMEM_VMEMMAP=\
"CONFIG_SPARSEMEM_VMEMMAP must be set to =y in the kernel .config."
		WARNING_ARCH_HAS_PTE_DEVMAP=\
"CONFIG_ARCH_HAS_PTE_DEVMAP must be set to =y in the kernel .config."
		check_extra_config
	fi

	if use numa ; then
		CONFIG_CHECK="~NUMA"
		WARNING_NUMA=\
"CONFIG_NUMA must be set to =y in the kernel .config."
		check_extra_config
	fi

	if use acpi ; then
		CONFIG_CHECK="~ACPI"
		WARNING_ACPI=\
"CONFIG_ACPI must be set to =y in the kernel .config."
		check_extra_config
	fi

	if use hybrid-graphics ; then
		CONFIG_CHECK="~ACPI ~VGA_SWITCHEROO"
		WARNING_ACPI=\
"CONFIG_ACPI must be set to =y in the kernel .config."
		WARNING_VGA_SWITCHEROO=\
"CONFIG_VGA_SWITCHEROO must be set to =y in the kernel .config."
		check_extra_config
	fi

	if ! linux_chkconfig_module "DRM_AMDGPU" ; then
ewarn
ewarn "CONFIG_DRM_AMDGPU (Graphics support > AMD GPU) must be compiled as a"
ewarn "module (=m)."
ewarn
	fi

	if [ ! -e "${EROOT}/usr/src/linux-${k}/Module.symvers" ] ; then
ewarn
ewarn "Your kernel sources must have a Module.symvers in the root of the linux"
ewarn "sources folder produced from a successful kernel compile beforehand in"
ewarn "order to build this driver."
ewarn
	fi
}

pkg_setup_error() {
	if ! linux_config_exists ; then
eerror
eerror "You must have a .config file in your linux sources"
eerror
		die
	fi

	check_modules_supported

	# 5.5 Inclusive
	CONFIG_CHECK="!DRM_AMD_DC_DSC_SUPPORT"
	ERROR_DRM_AMD_DC_DSC_SUPPORT=\
"CONFIG_DRM_AMD_DC_DSC_SUPPORT must be set to =n in the kernel."
	check_extra_config

	CONFIG_CHECK="DRM"
	ERROR_DRM=\
"CONFIG_DRM must be set to =y in the kernel."
	check_extra_config

	CONFIG_CHECK="KALLSYMS"
	ERROR_KALLSYMS=\
"CONFIG_KALLSYMS must be set to =y in the kernel."
	check_extra_config

	CONFIG_CHECK="!TRIM_UNUSED_KSYMS"
	ERROR_TRIM_UNUSED_KSYMS=\
"CONFIG_TRIM_UNUSED_KSYMS should not be set and the kernel recompiled without "\
"it."
	check_extra_config

	CONFIG_CHECK="AMD_IOMMU_V2"
	ERROR_MMU_NOTIFIER=\
"CONFIG_AMD_IOMMU_V2 must be set to =y in the kernel or CONFIG_HSA_AMD will "\
"be inaccessible in \`make menuconfig\`."
	check_extra_config

	if use check-mmu-notifier ; then
		if ! linux_chkconfig_module "HSA_AMD" ; then
			if ! linux_chkconfig_builtin "HSA_AMD" ; then
eerror
eerror "CONFIG_HSA_AMD must be set to =y or =m in the kernel .config."
eerror
				die
			fi
		fi
	fi

	CONFIG_CHECK="MMU_NOTIFIER"
	ERROR_MMU_NOTIFIER=\
"CONFIG_MMU_NOTIFIER must be set to =y in the kernel or it will fail in the "\
"link stage."
	check_extra_config

	CONFIG_CHECK="DRM_AMD_ACP"
	ERROR_MFD_CORE=\
"CONFIG_DRM_AMD_ACP (Enable ACP IP support) must be set to =y in the kernel "\
"or it will fail in the link stage."
	check_extra_config

	CONFIG_CHECK="MFD_CORE"
	ERROR_MFD_CORE=\
"CONFIG_MFD_CORE must be set to =y or =m in the kernel or it will fail in "\
"the link stage."
	check_extra_config

	if use directgma || use ssg ; then
		# It needs at least ZONE_DEVICE.  The rest are dependencies for
		# it
		CONFIG_CHECK=\
"ZONE_DEVICE MEMORY_HOTPLUG MEMORY_HOTREMOVE SPARSEMEM_VMEMMAP "\
"ARCH_HAS_PTE_DEVMAP"
		ERROR_ZONE_DEVICE=\
"CONFIG_ZONE_DEVICE must be set to =y in the kernel .config."
		ERROR_MEMORY_HOTPLUG=\
"CONFIG_MEMORY_HOTPLUG must be set to =y in the kernel .config."
		ERROR_MEMORY_HOTREMOVE=\
"CONFIG_MEMORY_HOTREMOVE must be set to =y in the kernel .config."
		ERROR_SPARSEMEM_VMEMMAP=\
"CONFIG_SPARSEMEM_VMEMMAP must be set to =y in the kernel .config."
		ERROR_ARCH_HAS_PTE_DEVMAP=\
"CONFIG_ARCH_HAS_PTE_DEVMAP must be set to =y in the kernel .config."
		check_extra_config
	fi

	if use numa ; then
		CONFIG_CHECK="NUMA"
		ERROR_NUMA=\
"CONFIG_NUMA must be set to =y in the kernel .config."
		check_extra_config
	fi

	if use acpi ; then
		CONFIG_CHECK="ACPI"
		ERROR_ACPI=\
"CONFIG_ACPI must be set to =y in the kernel .config."
		check_extra_config
	fi

	if use hybrid-graphics ; then
		CONFIG_CHECK="ACPI VGA_SWITCHEROO"
		ERROR_ACPI=\
"CONFIG_ACPI must be set to =y in the kernel .config."
		ERROR_VGA_SWITCHEROO=\
"CONFIG_VGA_SWITCHEROO must be set to =y in the kernel .config."
		check_extra_config
	fi

	if ! linux_chkconfig_module DRM_AMDGPU ; then
eerror
eerror "CONFIG_DRM_AMDGPU (Graphics support > AMD GPU) must be compiled as a"
eerror "module (=m)."
eerror
		die
	fi

	if [ ! -e "${EROOT}/usr/src/linux-${k}/Module.symvers" ] ; then
eerror
eerror "Your kernel sources must have a Module.symvers in the root folder"
eerror "produced from a successful kernel compile beforehand in order to"
eerror "build this driver."
eerror
		die
	fi
}

check_kernel() {
	local k="${1}"
	local kv=$(echo "${k}" \
		| cut -f1 -d'-')
	if [[ -n "${ROCK_DKMS_KERNELS}" ]] ; then
eerror
eerror "The ROCK_DKMS_KERNELS has been renamed to ROCK_DKMS_KERNELS_X_Y, where"
eerror "X is the major version and Y is the minor version corresponding to this"
eerror "package.  For this kernel it is named ROCK_DKMS_KERNELS_5_5."
eerror
eerror "Rename it to continue."
eerror
		die
	fi
	if ver_test ${kv} -ge ${KV_NOT_SUPPORTED_MAX} ; then
eerror
eerror "Kernel version ${kv} is not supported.  Update your ROCK_DKMS_KERNELS_5_5"
eerror "environmental variable."
eerror
		die
	fi
	if ver_test ${kv} -lt ${KV_SUPPORTED_MIN} ; then
eerror
eerror "Kernel version ${kv} is not supported.  Update your ROCK_DKMS_KERNELS_5_5"
eerror "environmental variable."
eerror
		die
	fi
	KERNEL_DIR="/usr/src/linux-${k}"
	get_version || die
	linux_config_exists
	if use build || [[ "${EBUILD_PHASE_FUNC}" == "pkg_config" ]]; then
		pkg_setup_error
	else
		pkg_setup_warn
	fi
}

show_supported_kv() {
ewarn
ewarn "The following kernel versions are only supported for ${P}:"
ewarn
ewarn "LTS 5.15.x"
ewarn "LTS 5.4.x"
ewarn
}

pkg_setup() {
	show_supported_kv
	if [[ -z "${ROCK_DKMS_KERNELS_5_5}" ]] ; then
eerror
eerror "You must define a per-package env or add to /etc/portage/make.conf an"
eerror "environmental variable named ROCK_DKMS_KERNELS_5_5 containing a space"
eerror "delimited <kernvel_ver>-<extra_version>."
eerror
eerror "It should look like ROCK_DKMS_KERNELS_5_5=\"${KV}-pf ${KV}-zen\""
eerror
		die
	fi

if [[ "${MAINTAINER_MODE}" != "1" ]] ; then
	local k
	for k in ${ROCK_DKMS_KERNELS_5_5} ; do
		if [[ "${k}" =~ "*" ]] ; then
			# Pick all point releases:  6.1.*-zen
			local V=$(find /usr/src/ -maxdepth 1 -name "linux-${k}" \
				| sort --version-sort -r \
				| sed -e "s|.*/linux-||")
			local v
			for v in ${V} ; do
				k="${v}"
				check_kernel "${k}"
			done
		elif [[ "${k}" =~ "^" ]] ; then
			# Pick the highest version:  6.1.^-zen
			local pat="${k/^/*}"
			k=$(find /usr/src/ -maxdepth 1 -name "linux-${pat}" \
				| sort --version-sort -r \
				| head -n 1 \
				| sed -e "s|.*/linux-||")
			check_kernel "${k}"
		else
			check_kernel "${k}"
		fi
	done
fi
}

# See also https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/blob/rocm-5.5.1/drivers/gpu/drm/amd/dkms/sources
_reconstruct_tarball_layout() {
einfo "Reconstructing tarball layout"
	local tarball_root="${WORKDIR}/ROCK-Kernel-Driver-rocm-${PV}"
	local base="${WORKDIR}/usr/src/amdgpu-${SUFFIX}"
	mkdir -p "${base}" || die
	pushd "${base}" || die
		while IFS= read -r row ; do
			[[ "${row:0:1}" == "#" ]] && continue
			local src=$(echo "${row}" | cut -f 1 -d " ")
			local dest=$(echo "${row}" | cut -f 2 -d " ")
			if [[ "${dest: -1}" == "/" ]] ; then
				mkdir -p "${base}/${dest}"
			fi
			cp -a \
				"${tarball_root}/${src}" \
				"${base}/${dest}" \
				|| die
		done < "${WORKDIR}/ROCK-Kernel-Driver-rocm-${PV}/drivers/gpu/drm/amd/dkms/sources"
		ln -s \
			amd/dkms/dkms.conf \
			dkms.conf \
			|| die
		ln -s \
			amd/dkms/Makefile \
			Makefile \
			|| die
	popd
}

src_unpack() {
	unpack ${A}
	_reconstruct_tarball_layout
}

src_prepare() {
	default
	einfo "DC_VER=${DC_VER}"
	einfo "ROCK_VER=${ROCK_VER}"
	chmod -v 0750 amd/dkms/autogen.sh || die
	sed -i \
		-e "s|-j\$(num_cpu_cores)||g" \
		-e "s|\"make |\"make V=1 |g" \
		amd/dkms/dkms.conf \
		|| die
	cd amd/dkms/ || die
	./autogen.sh || die
	chmod -v 0750 configure || die
}

src_configure() {
	set_arch_to_kernel
}

src_compile() {
	:;
}

install_examples() {
	insinto "/usr/share/doc/${P}/examples"
	doins "amd/dkms/docs/examples/wattman-example-script"
}

src_install() {
	install_examples
	dodir "usr/src/${DKMS_PKG_NAME}-${DKMS_PKG_VER}"
	insinto "usr/src/${DKMS_PKG_NAME}-${DKMS_PKG_VER}"
	doins -r "${S}/"*
	local d="${DKMS_PKG_NAME}-${DKMS_PKG_VER}"
	local paths=(
		"/usr/src/${d}/pre-build.sh"
		"/usr/src/${d}/autogen.sh"
		"/usr/src/${d}/amd/dkms/pre-build.sh"
		"/usr/src/${d}/amd/dkms/autogen.sh"
		"/usr/src/${d}/configure"
	)
	local path
	for path in ${paths[@]} ; do
		[[ -e "${ED}/${path}" ]] || continue
		fperms 0750 "${path}"
	done
}

get_arch() {
	# defined in /usr/share/genkernel/arch
	echo $(uname -m)
}

get_modules_folder() {
	local md
	if [[ -d "/lib/modules/${k}-$(get_arch)" ]] ; then
		md="/lib/modules/${k}-$(get_arch)"
	elif [[ -d "/lib/modules/${k}" ]] ; then
		md="/lib/modules/${k}"
	else
eerror
eerror "Could not locate modules folder to sign."
eerror
		die
	fi
	echo "${md}"
}

git_modules_folder_suffix() {
	local md
	if [[ -d "/lib/modules/${k}-$(get_arch)" ]] ; then
		md="-$(get_arch)"
	elif [[ -d "/lib/modules/${k}" ]] ; then
		md=""
	else
eerror
eerror "Could not locate modules folder to sign."
eerror
		die
	fi
	echo "${md}"
}

sign_module() {
	local module_path="${1}"
	einfo "Signing $(basename ${module_path})"
	/usr/src/linux-${k}/scripts/sign-file \
		"${module_sig_hash}" \
		"${key_path}" \
		"${cert_path}" \
		"${module_path}" \
		|| die
}

signing_modules() {
	local k="${1}"
	KERNEL_DIR="/usr/src/linux-${k}"
	get_version
	linux_config_exists
	if linux_chkconfig_builtin "MODULE_SIG" && use sign-modules ; then
		local kd="/usr/src/linux-${k}"
		local md=$(get_modules_folder)
		local module_sig_hash=$(grep \
			-Po '(?<=CONFIG_MODULE_SIG_HASH=").*(?=")' \
			"${kd}/.config")
		local module_sig_key=$(grep \
			-Po '(?<=CONFIG_MODULE_SIG_KEY=").*(?=")' \
			"${kd}/.config")
		module_sig_key="${module_sig_key:-certs/signing_key.pem}"
		if [[ "${module_sig_key#pkcs11:}" == "${module_sig_key}" \
			&& "${module_sig_key#/}" == "${module_sig_key}" ]]; then
			local key_path="${kd}/${module_sig_key}"
		else
			local key_path="${module_sig_key}"
		fi
		local cert_path="${kd}/certs/signing_key.x509"

		# If you get No such file or directory:  crypto/bio/bss_file.c,
		# This means that the kernel module location changed.  Set below
		# paths in amd/dkms/dkms.conf.

		sign_module \
			"${md}/kernel/drivers/gpu/drm/scheduler/amd-sched.ko" \
			|| die
		sign_module \
			"${md}/kernel/drivers/gpu/drm/ttm/amdttm.ko" \
			|| die
		sign_module \
			"${md}/kernel/drivers/gpu/drm/amd/amdkcl/amdkcl.ko" \
			|| die
		sign_module \
			"${md}/kernel/drivers/gpu/drm/amd/amdgpu/amdgpu.ko" \
			|| die
	fi
}

set_cc() {
	local raw_text

	# For older kernels like 5.4.
	if grep -q -e "Compiler:" "/usr/src/linux-${k}/.config" ; then
		raw_text=$(grep -e "Compiler:" "/usr/src/linux-${k}/.config" \
			| cut -f 3- -d " ")
	else
		raw_text=$(grep -e "CONFIG_CC_VERSION_TEXT" "/usr/src/linux-${k}/.config" \
			| cut -f 2 -d '"' \
			| cut -f 1 -d " ")
	fi

	export CC=$(echo "${raw_text}" \
		| cut -f 1 -d " ")
einfo "CC:  ${CC}"
	${CC} --version || die

	sed -r \
		-i \
		-e "s/ CC=('|\"|)[a-z0-9._-]+('|\"|)//g" \
		"/usr/src/${DKMS_PKG_NAME}-${DKMS_PKG_VER}/amd/dkms/dkms.conf" \
		|| die
	sed -i \
		-e "s/make /make CC=${CC} /" \
		"/usr/src/${DKMS_PKG_NAME}-${DKMS_PKG_VER}/amd/dkms/dkms.conf" \
		|| die
}

get_n_cpus() {
	local n_cpus=$(echo "${MAKEOPTS}" \
		| grep -E -o -e "-j[ ]*[0-9]+" \
		| sed -e "s|-j||")
	[[ -z "${n_cpus}" ]] && n_cpus=1
	n_cpus=1
	echo "${n_cpus}"
}

die_build() {
	env > "/var/lib/dkms/${DKMS_PKG_NAME}/${DKMS_PKG_VER}/build/env.log"
eerror
eerror "Log dumps:"
eerror
eerror "/var/lib/dkms/${DKMS_PKG_NAME}/${DKMS_PKG_VER}/build/env.log"
eerror "/var/lib/dkms/${DKMS_PKG_NAME}/${DKMS_PKG_VER}/build/make.log"
eerror
	die "${@}"
}

read_kernel_config() {
	IFS=$'\n'
	local x
	for x in $(env | grep "^CONFIG.*=") ; do
		local id="${x%%=*}"
einfo "Unsetting ${id}"
		unset "${id}"
	done
	# This just fixes cosmetic bugs.
	# dkms or the build scripts are broken because it should include the .config file for the Makefile.
	if [[ ! -e "${config_path}" ]] ; then
eerror
eerror "Missing ${config_path}"
eerror
		die
	fi
	for x in $(grep "^CONFIG_" "${config_path}" | sort) ; do
		local key="${x%%=*}"
		local value="${x#*=}"
einfo "Running:  export ${key}=${value}"
		export ${key}="${value}"
	done
	IFS=$' \t\n'
}

_dkms_build_clean() {
	[[ -z "${DKMS_PKG_NAME}" ]] && die
	[[ -z "${DKMS_PKG_VER}" ]] && die
	rm -rf "/${DKMS_PKG_NAME}/${DKMS_PKG_VER}"
}

dkms_build() {
	local kernel_source_path="/usr/src/linux-${k}"
	local config_path="/usr/src/linux-${k}/.config"
	local dkms_conf_path="/usr/src/${DKMS_PKG_NAME}-${DKMS_PKG_VER}/dkms.conf"
einfo "KERNEL_SOURCE_PATH:  ${kernel_source_path}"
einfo "KERNEL_CONFIG_PATH:  ${config_path}"
	read_kernel_config
einfo "CONFIG_GCC_VERSION:  ${CONFIG_GCC_VERSION}"
	set_cc
	local n_cpus=$(get_n_cpus)
	local args=( -j ${n_cpus} )
	args+=( --verbose )

	# Fixes make[2]: /bin/sh: Argument list too long
	# Fixes long abspaths for .o files before linking.
	args+=( --dkmstree "/" )
	_dkms_build_clean

	local _k="${k}$(git_modules_folder_suffix)/${ARCH}"
einfo "Running:  \`dkms build ${DKMS_PKG_NAME}/${DKMS_PKG_VER} -k ${_k} ${args[@]}\`"
	dkms build "${DKMS_PKG_NAME}/${DKMS_PKG_VER}" -k "${_k}" ${args[@]} || die_build
einfo "Running:  \`dkms install ${DKMS_PKG_NAME}/${DKMS_PKG_VER} -k ${_k} --force\`"
	dkms install "${DKMS_PKG_NAME}/${DKMS_PKG_VER}" -k "${_k}" --force ${args[@]} || die_build
einfo "The modules were installed in $(get_modules_folder)/updates"
	signing_modules "${k}"
	_dkms_build_clean
}

check_modprobe_conf() {
	if grep -r -e "options amdgpu virtual_display" /etc/modprobe.d/ ; then
		local files=$(grep \
			-l \
			-r \
			-e "options amdgpu virtual_display" \
			/etc/modprobe.d/)
ewarn
ewarn "Detected ${files} containing options amdgpu virtual_display."
ewarn
ewarn "You may get a blank screen when loading module.  Add # to the front of"
ewarn "that line."
ewarn
	fi
}

switch_firmware() {
	if use strict-pairing ; then
		if [[ -e "/usr/bin/install-rocm-firmware-${PV}.sh" ]] ; then
einfo "Switching to ${PV} firmware"
			/usr/bin/install-rocm-firmware-${PV}.sh
		fi
	else
		local pv=$(best_version ">=sys-firmware/amdgpu-dkms-firmware-${PV}" \
			| sed -e "s|sys-firmware/amdgpu-dkms-firmware-||g")
		if [[ -n "${pv}" ]] ; then
			if [[ -e "/usr/bin/install-amdgpu-dkms-firmware-${pv}.sh" ]] ; then
einfo "Switching to ${pv} firmware"
				/usr/bin/install-amdgpu-dkms-firmware-${pv}.sh
			fi
		fi
	fi
}

add_env_files() {
	mkdir -p "${EROOT}/etc/modprobe.d"
cat <<EOF > "${EROOT}/etc/modprobe.d/blacklist-radeon.conf"
blacklist radeon
EOF
	mkdir -p "${EROOT}/etc/udev/rules.d"
cat <<EOF > "${EROOT}/etc/udev/rules.d/70-amdgpu.rules"
KERNEL=="kfd", GROUP=="video", MODE="0660"
EOF
	chmod 0644 "${EROOT}/etc/modprobe.d/blacklist-radeon.conf"
	chmod 0644 "${EROOT}/etc/udev/rules.d/70-amdgpu.rules"
	chown root:root "${EROOT}/etc/modprobe.d/blacklist-radeon.conf"
	chown root:root "${EROOT}/etc/udev/rules.d/70-amdgpu.rules"
}

pkg_postinst() {
	add_env_files
	switch_firmware
	dkms add "${DKMS_PKG_NAME}/${DKMS_PKG_VER}"
	chmod -v 0750 "${EROOT}/usr/src/${DKMS_PKG_NAME}-${DKMS_PKG_VER}/amd/dkms/configure"
	if use build ; then
		local k
		for k in ${ROCK_DKMS_KERNELS_5_5} ; do
			if [[ "${k}" =~ "*" ]] ; then
				# Pick all point releases:  6.1.*-zen
				local V=$(find /usr/src/ -maxdepth 1 -name "linux-${k}" \
					| sort --version-sort -r \
					| sed -e "s|.*/linux-||")
				local v
				for v in ${V} ; do
					k="${v}"
					dkms_build
				done
			elif [[ "${k}" =~ "^" ]] ; then
				# Pick the highest version:  6.1.^-zen
				local pat="${k/^/*}"
				k=$(find /usr/src/ -maxdepth 1 -name "linux-${pat}" \
					| sort --version-sort -r \
					| head -n 1 \
					| sed -e "s|.*/linux-||")
				dkms_build
			else
				dkms_build
			fi
		done
	else
einfo
einfo "The ${PN} source code has been installed but not compiled.  You may do"
einfo
einfo "  emerge ${PN} --config"
einfo
einfo " or "
einfo
einfo "  dkms build ${DKMS_PKG_NAME}/${DKMS_PKG_VER} -k ${KV}-zen/x86_64"
einfo
	fi
einfo
einfo "For fully utilizing ROCmRDMA, it is recommend to set iommu off or in"
einfo "passthough mode."
einfo
einfo "Do \`dmesg | grep -i iommu\` to see if Intel or AMD."
einfo
einfo "If AMD IOMMU, add to kernel parameters either amd_iommu=off or iommu=pt"
einfo "If Intel IOMMU, add to kernel parameters either intel_iommu=off or iommu=pt"
einfo
einfo "For more information, see"
einfo
einfo "  https://rocm-documentation.readthedocs.io/en/latest/Remote_Device_Programming/Remote-Device-Programming.html#rocmrdma ."
einfo
einfo "Only <${KV_NOT_SUPPORTED_MAX} kernels are supported for these kernel modules."
einfo

einfo
einfo "DirectGMA / SSG is disabled by default.  You need to explicitly enable"
einfo "it in your bootloader config."
einfo
einfo "You need to add to your kernel parameters:"
einfo
einfo "  amdgpu.ssg=1 amdgpu.direct_gma_size=X"
einfo
einfo "where X is in MB with max limit of 96"
einfo "For details see"
einfo
einfo "  https://www.amd.com/en/support/kb/release-notes/rn-radeonprossg-linux"
einfo

	# For possible impractical passthough (pt) DMA attack, see
	# https://link.springer.com/article/10.1186/s13173-017-0066-7#Fn1
ewarn
ewarn "Disabling IOMMU or using passthrough (pt) is not recommended to"
ewarn "mitigate against a DMA attack used in cold boot attacks for full disk"
ewarn "encryption."
ewarn

	check_modprobe_conf
ewarn
ewarn "It is recommended to load this module manually after rebooting to easily"
ewarn "repair/update the driver if missed signing the module or avoid boot time"
ewarn "reboot or a boot time freeze possibility."
ewarn
}

pkg_prerm() {
	dkms remove "${DKMS_PKG_NAME}/${DKMS_PKG_VER}" --all
}

pkg_config() {
	local k
	local v=$(cat /proc/version \
		| cut -f 3 -d " ")
einfo
einfo "Found ${v}.  Use this (yes/no/quit)?  Choosing no will allow to pick the"
einfo "version & extraversion."
einfo
	read choice
	choice="${choice,,}"
	case ${choice} in
		yes|y)
			k="${v}"
			;;
		no|n)
einfo "What is your kernel version? (${KV})"
			read kernel_ver
einfo "What is your kernel extraversion? (pf, zen, ...)"
			read kernel_extraversion
			local k="${kernel_ver}-${kernel_extraversion}"
			;;
		quit|q)
			return
			;;
		*)
einfo "Try again"
			return
			;;
	esac
	dkms_build
	check_modprobe_conf
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems (5.5.1, 20231115, kernel 5.15.138)
# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems (5.5.1, 20231118, kernel 5.4.260) w/ot-sources changes to /usr/src/linux-5.4.260-builder/scripts/Makefile.build at multi-used-m patch
