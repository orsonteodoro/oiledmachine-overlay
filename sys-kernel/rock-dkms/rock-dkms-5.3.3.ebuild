# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_FIRMWARE_PV="5.18.2.50303"
DC_VER="3.2.196" # See https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/blob/rocm-5.3.3/drivers/gpu/drm/amd/display/dc/dc.h#L48
DCN_VER="3.2.1" # See https://github.com/ROCm/ROCK-Kernel-Driver/blob/rocm-5.3.3/drivers/gpu/drm/amd/display/include/dal_types.h#L61
DKMS_MODULES=(
# Keep in sync with https://github.com/ROCm/ROCK-Kernel-Driver/blob/rocm-5.3.3/drivers/gpu/drm/amd/dkms/dkms.conf
	"amdgpu amd/amdgpu /kernel/drivers/gpu/drm/amd/amdgpu"
	"amdttm ttm /kernel/drivers/gpu/drm/ttm"
	"amdkcl amd/amdkcl /kernel/drivers/gpu/drm/amd/amdkcl"
	"amd-sched scheduler /kernel/drivers/gpu/drm/scheduler"
	"amddrm_ttm_helper . /kernel/drivers/gpu/drm"
)
DKMS_PKG_NAME="amdgpu"
KV="5.18.0" # See https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/blob/rocm-5.3.3/Makefile#L2
KVS=(
# See https://github.com/ROCm/ROCm/blob/docs/5.3.3/docs/release/gpu_os_support.md#supported-distributions
# Commented out means EOL kernel.
#	"5.17" # U 22.04 Desktop OEM
	"5.15" # U 22.04 Desktop HWE, 22.04 Server generic
#	"5.14" # S 15.4; R 9.0, 9.1
#	"5.8"  # U 20.04 HWE
	"5.4"  # U 20.04 generic
#	"5.3"  # S 15.3
#	"4.18" # R 8.4, 8.5, 8.6
#	"3.10" # R 7.9
# Active LTS only supported in this overlay.
)
MAINTAINER_MODE=0
PV_MAJOR_MINOR=$(ver_cut 1-2 ${PV})
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCK_VER="${PV}"
SUFFIX="${PV_MAJOR_MINOR}"
DKMS_PKG_VER="${SUFFIX}"
USE_DKMS=0

if [[ "${MAINTAINER_MODE}" == "1" ]] ; then
# For verification of patch correctness
	KV_NOT_SUPPORTED_MAX="99999999"
	KV_SUPPORTED_MIN="3.10"
else
	KV_NOT_SUPPORTED_MAX="5.18" # Exclusive
	KV_SUPPORTED_MIN="5.4"
fi

inherit flag-o-matic linux-info toolchain-funcs

KEYWORDS="~amd64"
S="${WORKDIR}/usr/src/amdgpu-${SUFFIX}"
SRC_URI="
https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="ROCk DKMS kernel module"
HOMEPAGE="
https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver
"
LICENSE="
	GPL-2
	Linux-syscall-note
	MIT
"
# All the remaining licenses listed are based on the vanilla kernel.
# For kernel license templates see:
# https://github.com/torvalds/linux/tree/master/LICENSES
# See also https://github.com/torvalds/linux/blob/master/Documentation/process/license-rules.rst
LICENSE+=" GPL-2 Linux-syscall-note" #  Applies to whole source  \
	# that are GPL-2 compatible.  See paragraph 3 of the above link for details.
LICENSE+=" ( GPL-2 all-rights-reserved )" # See mm/list_lru.c
LICENSE+=" ( GPL-2+ all-rights-reserved )" # See drivers/gpu/drm/meson/meson_plane.c
LICENSE+=" ( all-rights-reserved BSD || ( GPL-2 BSD ) )" # See lib/zstd/compress.c
LICENSE+=" ( all-rights-reserved MIT || ( GPL-2 MIT ) )" # See drivers/gpu/drm/ttm/ttm_execbuf_util.c
LICENSE+=" ( custom GPL-2+ )" # See drivers/scsi/esas2r/esas2r_main.c, ... ; # \
	# Samples warranty/liability paragraphs from maybe EPL-2.0
LICENSE+=" 0BSD" # See lib/math/cordic.c
# It is missing SPDX: compared to the other all-rights-reserved files. \
LICENSE+=" all-rights-reserved" # See lib/dynamic_debug.c
LICENSE+=" BSD" # See include/linux/packing.h, ...
LICENSE+=" BSD-2" # See include/linux/firmware/broadcom/tee_bnxt_fw.h
LICENSE+=" Clear-BSD" # See drivers/net/wireless/ath/ath11k/core.h, ...
LICENSE+=" custom" # See crypto/cts.c
LICENSE+=" ISC" # See linux/drivers/net/wireless/ath/wil6210/trace.c, \
	# linux/drivers/net/wireless/ath/ath5k/Makefile, ...
LICENSE+=" LGPL-2.1" # See fs/ext4/migrate.c, ...
LICENSE+=" LGPL-2+ Linux-syscall-note" # See arch/x86/include/uapi/asm/mtrr.h
LICENSE+=" MIT" # See drivers/gpu/drm/drm_dsc.c
LICENSE+=" Prior-BSD-License" # See drivers/net/slip/slhc.c
LICENSE+=" unicode" # See fs/nls/mac-croatian.c ; 3 clause data files
LICENSE+=" Unlicense" # See tools/usb/ffs-aio-example/multibuff/device_app/aio_multibuff.c
LICENSE+=" ZLIB" # See lib/zlib_dfltcc/dfltcc.c, ...
LICENSE+=" || ( BSD GPL-2 )" # See lib/test_parman.c
LICENSE+=" || ( GPL-2 Apache-2.0 )" # See drivers/net/wireless/silabs/wfx/hif_api_cmd.h
LICENSE+=" || ( GPL-2 MIT )" # See lib/crypto/poly1305-donna32.c
LICENSE+=" || ( GPL-2 BSD-2 )" # See arch/x86/crypto/sha512-ssse3-asm.S
# The following licenses applies to individual files:
# The distro BSD license template does have all rights reserved and implied.
# The distro GPL licenses templates do not have all rights reserved but it's
# found in the headers.
# The distro MIT license template does not have all rights reserved.
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
acpi +build +check-mmu-notifier +compress custom-kernel directgma gzip hybrid-graphics
numa +sign-modules ssg strict-pairing xz zstd
ebuild_revision_16
"
REQUIRED_USE="
	compress? (
		|| (
			gzip
			xz
			zstd
		)
	)
	hybrid-graphics? (
		acpi
	)
"
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
	${CDEPEND}
	!sys-kernel/rock-dkms:0
	dev-build/autoconf
	dev-build/automake
	sys-apps/kmod[tools]
	!build? (
		>=sys-kernel/dkms-1.95
	)
"
DEPEND="
	${CDEPEND}
	${RDEPEND}
"
BDEPEND="
	${BDEPEND}
	sys-apps/grep[pcre]
	compress? (
		gzip? (
			sys-apps/kmod[zlib]
			app-arch/gzip
		)
		xz? (
			sys-apps/kmod[lzma]
			app-arch/xz-utils
		)
		zstd? (
			sys-apps/kmod[zstd]
			app-arch/zstd
		)
	)
"
PATCHES=(
	"${FILESDIR}/rock-dkms-3.10_p27-makefile-recognize-gentoo.patch"
	"${FILESDIR}/rock-dkms-3.1_p35-add-header-to-kcl_fence_c.patch"
	"${FILESDIR}/rock-dkms-5.4.3-seq_printf-header.patch"
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
eerror "package.  For this kernel it is named ROCK_DKMS_KERNELS_5_3."
eerror
eerror "Rename it to continue."
eerror
		die
	fi
	if ver_test ${kv} -ge ${KV_NOT_SUPPORTED_MAX} ; then
eerror
eerror "Kernel version ${kv} is not supported.  Update your ROCK_DKMS_KERNELS_5_3"
eerror "environmental variable."
eerror
		die
	fi
	if ver_test ${kv} -lt ${KV_SUPPORTED_MIN} ; then
eerror
eerror "Kernel version ${kv} is not supported.  Update your ROCK_DKMS_KERNELS_5_3"
eerror "environmental variable."
eerror
		die
	fi
	KERNEL_DIR="/usr/src/linux-${k}"
	get_version || die
	linux_config_exists
	if use build || [[ "${EBUILD_PHASE_FUNC}" == "pkg_config" ]]; then
		pkg_setup_error
		USE_DKMS=0
	else
		pkg_setup_warn
		USE_DKMS=1
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
	if [[ -z "${ROCK_DKMS_KERNELS_5_3}" ]] ; then
eerror
eerror "You must define a per-package env or add to /etc/portage/make.conf an"
eerror "environmental variable named ROCK_DKMS_KERNELS_5_3 containing a space"
eerror "delimited <kernvel_ver>-<extra_version>."
eerror
eerror "It should look like ROCK_DKMS_KERNELS_5_3=\"${KV}-pf ${KV}-zen\""
eerror
		die
	fi

if [[ "${MAINTAINER_MODE}" != "1" ]] ; then
	local k
	for k in ${ROCK_DKMS_KERNELS_5_3} ; do
		if [[ "${k}" =~ "*" ]] ; then
			# Pick all point releases:  6.1.*-zen
			local V=$(find /usr/src/ -maxdepth 1 -name "linux-${k}" \
				| sort --version-sort -r \
				| sed -e "s|.*/linux-||")
			if [[ -z "${V}" ]] ; then
eerror "Missing kernel sources.  Install the kernel sources package first."
				die
			fi
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
			if [[ -z "${k}" ]] ; then
eerror "Missing kernel sources.  Install the kernel sources package first."
				die
			fi
			check_kernel "${k}"
		else
			check_kernel "${k}"
		fi
	done
fi
}

# See also https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/blob/rocm-5.3.3/drivers/gpu/drm/amd/dkms/sources
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
	:
}

install_examples() {
	insinto "/usr/share/doc/${P}/examples"
	doins "amd/dkms/docs/examples/wattman-example-script"
}

src_install() {
	install_examples
	insinto "/usr/src/${DKMS_PKG_NAME}-${DKMS_PKG_VER}"
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
	local k="${1}" # ${kv}-${extraversion}
	KERNEL_DIR="/usr/src/linux-${k}"
	get_version
	linux_config_exists
	if linux_chkconfig_builtin "MODULE_SIG" && use sign-modules ; then
		local kernel_path="/usr/src/linux-${k}"
		local kernel_release=$(cat "${kernel_path}/include/config/kernel.release") # ${PV}-${EXTRAVERSION}-${ARCH}
		local modules_path="/lib/modules/${kernel_release}"
		local module_sig_hash=$(grep \
			-Po '(?<=CONFIG_MODULE_SIG_HASH=").*(?=")' \
			"${kernel_path}/.config")
		local module_sig_key=$(grep \
			-Po '(?<=CONFIG_MODULE_SIG_KEY=").*(?=")' \
			"${kernel_path}/.config")
		module_sig_key="${module_sig_key:-certs/signing_key.pem}"
		if [[ "${module_sig_key#pkcs11:}" == "${module_sig_key}" \
			&& "${module_sig_key#/}" == "${module_sig_key}" ]]; then
			local key_path="${kernel_path}/${module_sig_key}"
		else
			local key_path="${module_sig_key}"
		fi
		local cert_path="${kernel_path}/certs/signing_key.x509"

		# If you get No such file or directory:  crypto/bio/bss_file.c,
		# This means that the kernel module location changed.  Set below
		# paths in amd/dkms/dkms.conf.

		IFS=$'\n'
		local x
		for x in ${DKMS_MODULES[@]} ; do
			local built_name=$(echo "${x}" | cut -f 1 -d " ")
			local built_location=$(echo "${x}" | cut -f 2 -d " ")
			local dest_location=$(echo "${x}" | cut -f 3 -d " ")
			sign_module \
				"${modules_path}${dest_location}/${built_name}.ko" \
				|| die
		done
		IFS=$' \t\n'
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
	export CPP="${CC} -E"
einfo "CC:  ${CC}"
	${CC} --version || die
	strip-unsupported-flags

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
	env > "${build_root}/build/env.log"
eerror
eerror "Log dumps:"
eerror
eerror "${build_root}/build/env.log"
eerror "${build_root}/build/make.log"
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

_build_clean() {
	if [[ "${USE_DKMS}" == "1" ]] ; then
		[[ -z "${DKMS_PKG_NAME}" ]] && die
		[[ -z "${DKMS_PKG_VER}" ]] && die
		[[ "/${DKMS_PKG_NAME}/${DKMS_PKG_VER}" == "//" ]] && die
		rm -rf "/${DKMS_PKG_NAME}/${DKMS_PKG_VER}"
	else
		rm -rf "${build_root}"
	fi
}

_verify_magic() {
	local actual_ko_path="${1}" # abspath to a single .ko* file
	[[ -e "${actual_ko_path}" ]] || die "Path is missing"
	local expected_source_path="${2}" # "/usr/src/linux-${k}"
	[[ -e "${expected_source_path}" ]] || die "Path is missing"
        local kernel_release=$(cat "${expected_source_path}/include/config/kernel.release") # ${PV}-${EXTRAVERSION}-${ARCH}
	if [[ -z "${kernel_release}" ]] ; then
eerror
eerror "${expected_source_path}/include/config/kernel.release needs to be generated."
eerror
eerror "Rebuild kernel."
eerror
		die
	fi
	local actual_kernel_release=$(modinfo -F vermagic "${actual_ko_path}" \
		| cut -f 1 -d " ")
	local expected_kernel_release="${kernel_release}"
	if [[ "${actual_kernel_release}" != "${expected_kernel_release}" ]] ; then
eerror
eerror "Inconsistent build detected"
eerror
eerror "Actual kernel module release:  ${actual_kernel_release}"
eerror "Expected kernel module release:  ${expected_kernel_release}"
eerror
		die
	fi
}

_verify_magic_all() {
	local actual_kernel_modules_root_path="${1}" # /lib/modules or /lib/modules-rock/${PV}
	local expected_source_path="${2}" # "/usr/src/linux-${k}"
        local kernel_release=$(cat "${expected_source_path}/include/config/kernel.release") # ${PV}-${EXTRAVERSION}-${ARCH}

	IFS=$'\n'
	local modules_path="${actual_kernel_modules_root_path}/${kernel_release}"
	local x
	for x in ${DKMS_MODULES[@]} ; do
		local built_name=$(echo "${x}" | cut -f 1 -d " ")
		local built_location=$(echo "${x}" | cut -f 2 -d " ")
		local dest_location=$(echo "${x}" | cut -f 3 -d " ")
		_verify_magic $(realpath "${modules_path}${dest_location}/${built_name}.ko"*) "${expected_source_path}"
	done
	IFS=$' \t\n'
}

_copy_modules() {
	# Keep in sync with https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/blob/rocm-5.3.3/drivers/gpu/drm/amd/dkms/dkms.conf
	IFS=$'\n'

	local x
	local modules_path="/lib/modules/${kernel_release}"
	local build_root="${build_root}/build"
	for x in ${DKMS_MODULES[@]} ; do
		local built_name=$(echo "${x}" | cut -f 1 -d " ")
		local built_location=$(echo "${x}" | cut -f 2 -d " ")
		local dest_location=$(echo "${x}" | cut -f 3 -d " ")

		# For default install
		mkdir -p "${modules_path}${dest_location}"
		rm -f "${modules_path}${dest_location}/${built_name}.ko"{,.gz,.xz,.zst}
		cp -a "${build_root}/${built_location}/${built_name}.ko" "${modules_path}${dest_location}" || die "Kernel module copy failed"

		# For slot switch
		# ${PV} is preferred over ${ROCM_SLOT} to avoid boot failure with login display managers.
		mkdir -p "/lib/modules-rock/${PV}/${kernel_release}/${dest_location}"
		rm -f "/lib/modules-rock/${PV}/${kernel_release}/${dest_location}/${built_name}.ko"{,.gz,.xz,.zst}
		cp -a "${build_root}/${built_location}/${built_name}.ko" "/lib/modules-rock/${PV}/${kernel_release}/${dest_location}" || die "Kernel module copy failed"
	done
	IFS=$' \t\n'
}

_copy_modules_dkms() {
	# Keep in sync with https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/blob/rocm-5.6.1/drivers/gpu/drm/amd/dkms/dkms.conf
	IFS=$'\n'

	local x
	local modules_path="/lib/modules/${kernel_release}"
	local build_root="${build_root}/build"
	for x in ${DKMS_MODULES[@]} ; do
		local built_name=$(echo "${x}" | cut -f 1 -d " ")
		local built_location=$(echo "${x}" | cut -f 2 -d " ")
		local dest_location=$(echo "${x}" | cut -f 3 -d " ")

		# For slot switch
		# ${PV} is preferred over ${ROCM_SLOT} to avoid boot failure with login display managers.
		mkdir -p "/lib/modules-rock/${PV}/${kernel_release}/${dest_location}"
		rm -f "/lib/modules-rock/${PV}/${kernel_release}/${dest_location}/${built_name}.ko"{,.gz,.xz,.zst}
		cp -a "/lib/modules/${kernel_release}/${built_name}.ko" "/lib/modules-rock/${PV}/${kernel_release}/${dest_location}" || die "Kernel module copy failed"
	done
	IFS=$' \t\n'
}

_compress_modules() {
	use compress || return
	IFS=$'\n'
	local x
	local modules_path="${1}"
	for x in ${DKMS_MODULES[@]} ; do
		local built_name=$(echo "${x}" | cut -f 1 -d " ")
		local built_location=$(echo "${x}" | cut -f 2 -d " ")
		local dest_location=$(echo "${x}" | cut -f 3 -d " ")
		pushd "${modules_path}${dest_location}" || die
			rm -f "${built_name}.ko"{.gz,.xz,.zst}
			if [[ "${CONFIG_MODULE_COMPRESS_ZSTD}" == "y" ]] && has_version "sys-apps/kmod[zstd]" && has_version "app-arch/zstd" ; then
				# .ko.zst
				zstd -T0 --rm -f -q "${built_name}.ko"
			elif [[ "${CONFIG_MODULE_COMPRESS_XZ}" == "y" ]] && has_version "sys-apps/kmod[lzma]" && has_version "app-arch/xz-utils" ; then
				# .ko.xz
				xz --lzma2=dict=2MiB -f "${built_name}.ko"
			elif [[ "${CONFIG_MODULE_COMPRESS_GZIP}" == "y" ]] && has_version "sys-apps/kmod[zlib]" && has_version "app-arch/gzip" ; then
				# .ko.gz
				gzip -n -f "${built_name}.ko"
			fi
		popd
	done
	IFS=$' \t\n'
}

# For multiple slot support.
_gen_switch_wrapper() {
	local strict_pairing
	local best_pv=""
	if use strict-pairing ; then
		strict_pairing="y"
	else
		strict_pairing="n"
		local pv=$(best_version ">=sys-firmware/amdgpu-dkms-firmware-${PV}" \
			| sed -e "s|sys-firmware/amdgpu-dkms-firmware-||g")
		best_pv="${pv}"
	fi

cat <<EOF > "${EROOT}/usr/bin/install-rock-dkms-${PV}-for-${k}.sh"
#!/bin/bash
echo "Switching to rock-dkms ${PV}"
PV="${PV}"
ROCM_SLOT="${ROCM_SLOT}"
kernel_release="${kernel_release}"
modules_path="/lib/modules/\${kernel_release}"
strict_pairing="${strict_pairing}"
best_pv="${best_pv}"

if [[ "\${strict_pairing}" == "y" ]] ; then
	if [[ -e "/usr/bin/install-rocm-firmware-\${PV}.sh" ]] ; then
		/usr/bin/install-rocm-firmware-\${PV}.sh
	fi
else
	if [[ -n "\${best_pv}" ]] ; then
		if [[ -e "/usr/bin/install-amdgpu-dkms-firmware-\${best_pv}.sh" ]] ; then
			/usr/bin/install-amdgpu-dkms-firmware-\${best_pv}.sh
		fi
	fi
fi

DKMS_MODULES=(
        "amdgpu amd/amdgpu /kernel/drivers/gpu/drm/amd/amdgpu"
        "amdttm ttm /kernel/drivers/gpu/drm/ttm"
        "amdkcl amd/amdkcl /kernel/drivers/gpu/drm/amd/amdkcl"
        "amd-sched scheduler /kernel/drivers/gpu/drm/scheduler"
        "amddrm_ttm_helper . /kernel/drivers/gpu/drm"
)

# Entries from all versions of the rock-dkms driver and the vanilla amdgpu kernel driver.
_DKMS_MODULES=(
	"amdgpu /kernel/drivers/gpu/drm/amd/amdgpu"
	"amdttm /kernel/drivers/gpu/drm/ttm"
	"amdkcl /kernel/drivers/gpu/drm/amd/amdkcl"
	"amd-sched /kernel/drivers/gpu/drm/scheduler"
	"amddrm_ttm_helper /kernel/drivers/gpu/drm"
	"amddrm_buddy /kernel/drivers/gpu/drm"
	"amdxcp /kernel/drivers/gpu/drm/amd/amdxcp"
)

IFS=\$'\n'

for x in \${_DKMS_MODULES[@]} ; do
        built_name=\$(echo "\${x}" | cut -f 1 -d " ")
        dest_location=\$(echo "\${x}" | cut -f 2 -d " ")
        rm -fv "\${modules_path}\${dest_location}/\${built_name}.ko"*
done

for x in \${DKMS_MODULES[@]} ; do
	built_name=\$(echo "\${x}" | cut -f 1 -d " ")
	built_location=\$(echo "\${x}" | cut -f 2 -d " ")
	dest_location=\$(echo "\${x}" | cut -f 3 -d " ")
	mkdir -p "\${modules_path}\${dest_location}"
	cp -a "/lib/modules-rock/\${PV}/\${kernel_release}/\${dest_location}/\${built_name}.ko"* "\${modules_path}\${dest_location}"
done

IFS=\$' \t\n'

echo "Updating /lib/modules/\${kernel_release}/module.dep for \`modprobe amdgpu\`"
depmod -a \${kernel_release}
EOF
	chmod -v 0750 "${EROOT}/usr/bin/install-rock-dkms-${PV}-for-${k}.sh"
	ln -sf "${EROOT}/usr/bin/install-rock-dkms-${PV}-for-${k}.sh" "${EROOT}/usr/bin/install-rock-dkms-slot-${ROCM_SLOT}-for-${k}.sh"
}

dkms_build() {
	local kernel_source_path="/usr/src/linux-${k}"
	if [[ -z "${k}" || ! -e "${kernel_source_path}" ]] ; then
eerror "Missing kernel sources for linux-${pat}"
		die
	fi
	local kernel_release=$(cat "${kernel_source_path}/include/config/kernel.release") # ${PV}-${EXTRAVERSION}-${ARCH}
	if [[ -z "${kernel_release}" ]] ; then
eerror
eerror "${kernel_source_path}/include/config/kernel.release is not initalized."
eerror
eerror "It must contain a value like 5.15.138-builder-x86_64"
eerror
		die
	fi
	local modules_path="/lib/modules/${kernel_release}"
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
	local kv="${k%%-*}"
	local build_root
	if ver_test ${kv} -ge 5.15 ; then
		args+=( --dkmstree "/" )
		build_root="/rock_build"
	else
		# "/" breaks with 5.4
		# Default M=/var/lib/dkms/amdgpu/5.3/build
		args+=( --dkmstree "/" )
		build_root="/rock_build"
	fi
	_build_clean

	local _k="${kernel_release}/${ARCH}"
	if [[ "${USE_DKMS}" == "1" ]] ; then
einfo "Running:  \`dkms build ${DKMS_PKG_NAME}/${DKMS_PKG_VER} -k ${_k} ${args[@]}\`"
		dkms build "${DKMS_PKG_NAME}/${DKMS_PKG_VER}" -k "${_k}" ${args[@]} || die_build
einfo "Running:  \`dkms install ${DKMS_PKG_NAME}/${DKMS_PKG_VER} -k ${_k} --force\`"
		dkms install "${DKMS_PKG_NAME}/${DKMS_PKG_VER}" -k "${_k}" --force ${args[@]} || die_build
	else
	# Do it this way to avoid the argument list too long bug caused by long abspaths.
	# There may be a 32k limit in arg file with .o abspaths fed to ld.bfd.
		mkdir -p "${build_root}/build"
		cp -aT "/usr/src/${DKMS_PKG_NAME}-${DKMS_PKG_VER}" "${build_root}/build"
		ln -sf "/usr/src/${DKMS_PKG_NAME}-${DKMS_PKG_VER}" "${build_root}/source"
		mkdir -p "/lib/modules/${kernel_release}"
		ln -sf "/usr/src/linux-${k}" "/lib/modules/${kernel_release}/build"
		ln -sf "/usr/src/linux-${k}" "/lib/modules/${kernel_release}/source"
		pushd "${build_root}/build" || die
	# Generate a ${build_root}/build/include/rename_symbol.h first
			amd/dkms/pre-build.sh ${kernel_release} || die
			local mymakeargs=(
				-C "/lib/modules/${kernel_release}/build"
				-j1
				ARCH="$(tc-arch-kernel)"
				CC="${CC}"
				KDIR="/lib/modules/${kernel_release}/build"
				KERNELRELEASE="${kernel_release}"
				M="${build_root}/build"
				SCHED_NAME="amd-sched"
				TTM_NAME="amdttm"
				V=1
			)
			einfo "Running:  \`make ${mymakeargs[@]}\`"
			make "${mymakeargs[@]}"
		popd || die
	fi
	signing_modules "${k}"
	if [[ "${USE_DKMS}" == "1" ]] ; then
		# Already copied to production
		# Copy for slotification
		_copy_modules_dkms
	else
		# Copy to production
		# Copy for slotification
		_copy_modules
	fi
	_compress_modules "/lib/modules/${kernel_release}"
	_compress_modules "/lib/modules-rock/${PV}/${kernel_release}" # slotified path
	_verify_magic_all "/lib/modules" "/usr/src/linux-${k}"
	_verify_magic_all "/lib/modules-rock/${PV}" "/usr/src/linux-${k}"
	_build_clean
	_gen_switch_wrapper
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
	local K=()
	add_env_files
	switch_firmware
	if [[ "${USE_DKMS}" == "1" ]] ; then
		dkms add "${DKMS_PKG_NAME}/${DKMS_PKG_VER}"
	fi
	chmod -v 0750 "${EROOT}/usr/src/${DKMS_PKG_NAME}-${DKMS_PKG_VER}/amd/dkms/configure"
	if use build ; then
		local k
		for k in ${ROCK_DKMS_KERNELS_5_3} ; do
			if [[ "${k}" =~ "*" ]] ; then
				# Pick all point releases:  6.1.*-zen
				local pat="${k}"
				local V=$(find /usr/src/ -maxdepth 1 -name "linux-${pat}" \
					| sort --version-sort -r \
					| sed -e "s|.*/linux-||")
				local v
				for v in ${V} ; do
					k="${v}"
					K+=( "${k}" )
					dkms_build
				done
			elif [[ "${k}" =~ "^" ]] ; then
				# Pick the highest version:  6.1.^-zen
				local pat="${k/^/*}"
				k=$(find /usr/src/ -maxdepth 1 -name "linux-${pat}" \
					| sort --version-sort -r \
					| head -n 1 \
					| sed -e "s|.*/linux-||")
				K+=( "${k}" )
				dkms_build
			else
				K+=( "${k}" )
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

	if use build ; then
einfo
einfo "The following can be used to switch between ROCm slots/versions for the"
einfo "rock-dkms (aka amdgpu-dkms) kernel driver:"
einfo
		local k
		for k in ${K[@]} ; do
einfo "/usr/bin/install-rock-dkms-${PV}-for-${k}.sh"
einfo "/usr/bin/install-rock-dkms-slot-${ROCM_SLOT}-for-${k}.sh"
		done
einfo

einfo
		for k in ${K[@]} ; do
			local kernel_path="/usr/src/linux-${k}"
			local kernel_release=$(cat "${kernel_path}/include/config/kernel.release") # ${PV}-${EXTRAVERSION}-${ARCH}
# Fixes missing symbols for amdgpu.ko.
einfo "Updating /lib/modules/${kernel_release}/modules.dep for \`modprobe amdgpu\`."
			depmod -a ${kernel_release}
		done
einfo
	fi
ewarn "FIXME:  Security fixes have not been applied.  Please apply manually."
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

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems (5.3.3, 20231115, kernel 5.15.138)
# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems (5.3.3, 20231118, kernel 5.4.260)
