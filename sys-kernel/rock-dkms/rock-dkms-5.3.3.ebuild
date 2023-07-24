# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info

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
KV="5.18.0" # See https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/blob/rocm-5.4.3/Makefile#L2
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE="
acpi +build +check-mmu-notifier custom-kernel directgma hybrid-graphics
numa +sign-modules ssg strict-pairing
"
REQUIRED_USE="
	hybrid-graphics? (
		acpi
	)
"
if [[ "${MAINTAINER_MODE}" == "1" ]] ; then
# For verification of patch correctness
	KV_NOT_SUPPORTED_MAX="99999999"
	KV_SUPPORTED_MIN="${KV%%.*}.0"
else
	KV_NOT_SUPPORTED_MAX="${KV%%.*}.$(($(ver_cut 2 ${KV}) + 1))"
	KV_SUPPORTED_MIN="${KV%%.*}.0"
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
	local KVS=(
		"$(ver_cut 1-2 ${KV})"
		"5.15"
		"5.10"
		"5.4"
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
		>=sys-kernel/linux-firmware-20221012
	)
	strict-pairing? (
		~sys-kernel/linux-firmware-20221012
	)
"
RDEPEND="
	${CDEPEND}
	sys-kernel/dkms
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
DC_VER="3.2.196" # See https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/blob/rocm-5.3.3/drivers/gpu/drm/amd/display/dc/dc.h#L48

PATCHES=(
	"${FILESDIR}/rock-dkms-3.10_p27-makefile-recognize-gentoo.patch"
	"${FILESDIR}/rock-dkms-5.3.3-enable-mmu_notifier.patch"
	"${FILESDIR}/rock-dkms-3.1_p35-add-header-to-kcl_fence_c.patch"
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
	if ver_test ${kv} -ge ${KV_NOT_SUPPORTED_MAX} ; then
eerror
eerror "Kernel version ${kv} is not supported.  Update your ROCK_DKMS_KERNELS"
eerror "environmental variable."
eerror
		die
	fi
	if ver_test ${kv} -lt ${KV_SUPPORTED_MIN} ; then
eerror
eerror "Kernel version ${kv} is not supported.  Update your ROCK_DKMS_KERNELS"
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
ewarn "LTS 5.4.x"
ewarn "LTS 5.10.x"
ewarn "LTS 5.15.x"
ewarn
}

pkg_setup() {
	show_supported_kv
	if [[ -z "${ROCK_DKMS_KERNELS}" ]] ; then
eerror
eerror "You must define a per-package env or add to /etc/portage/make.conf an"
eerror "environmental variable named ROCK_DKMS_KERNELS containing a space"
eerror "delimited <kernvel_ver>-<extra_version>."
eerror
eerror "It should look like ROCK_DKMS_KERNELS=\"${KV}-pf ${KV}-zen\""
eerror
		die
	fi

if [[ "${MAINTAINER_MODE}" != "1" ]] ; then
	local k
	for k in ${ROCK_DKMS_KERNELS} ; do
		if [[ "${k}" =~ "*" ]] ; then
			# Pick all point releases:  6.1.*-zen
			local V=$(find /usr/src/ -maxdepth 1 -name "linux-${k}" \
				| sort --version-sort -r \
				| cut -f 4 -d "/" \
				| sed -e "s|linux-||")
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
				| cut -f 4 -d "/" \
				| sed -e "s|linux-||")
			check_kernel "${k}"
		else
			check_kernel "${k}"
		fi
	done
fi
}

_reconstruct_tarball_layout() {
	local tarball_root="${WORKDIR}/ROCK-Kernel-Driver-rocm-${PV}"
	local base="${WORKDIR}/usr/src/amdgpu-${SUFFIX}"
	mkdir -p "${base}" || die
	pushd "${base}" || die
		mkdir -p "${base}/include" || die
		mkdir -p "${base}/include/include/linux" || die
		mkdir -p "${base}/include/uapi/drm" || die
		mkdir -p "${base}/include/uapi/linux" || die
		cp -a \
			"${tarball_root}/drivers/gpu/drm/amd/dkms/"* \
			"${base}" \
			|| die
		cp -a \
			"${tarball_root}/drivers/gpu/drm/scheduler" \
			"${base}" \
			|| die
		cp -a \
			"${tarball_root}/drivers/gpu/drm/ttm" \
			"${base}" \
			|| die
		cp -a \
			"${tarball_root}/drivers/gpu/drm/amd" \
			"${base}" \
			|| die
		cp -a \
			"${tarball_root}/include/drm" \
			"${base}/include" \
			|| die
		cp -a \
			"${tarball_root}/include/kcl" \
			"${base}/include" \
			|| die
		cp -a \
			"${tarball_root}/include/linux/dma-resv.h" \
			"${base}/include/linux" \
			|| die
		cp -a \
			"${tarball_root}/include/kcl/reservation.h" \
			"${base}/include/linux" \
			|| die
		cp -a \
			"${tarball_root}/include/uapi/drm/amdgpu_drm.h" \
			"${base}/include/uapi/drm" \
			|| die
		cp -a \
			"${tarball_root}/include/uapi/linux/kfd_ioctl.h" \
			"${base}/include/uapi/linux" \
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
	chmod 0750 amd/dkms/autogen.sh || die
	pushd amd/dkms || die
		./autogen.sh || die
	popd || die
}

src_configure() {
	set_arch_to_kernel
}

src_compile() {
	:;
}

src_install() {
	dodir "usr/src/${DKMS_PKG_NAME}-${DKMS_PKG_VER}"
	insinto "usr/src/${DKMS_PKG_NAME}-${DKMS_PKG_VER}"
	doins -r "${S}/"*
	local paths=(
		"amd/dkms/post-remove.sh"
		"amd/dkms/pre-build.sh"
		"amd/dkms/config/install-sh"
		"amd/dkms/configure"
		"amd/dkms/autogen.sh"
	)
	local path
	for path in ${paths[@]} ; do
		fperms 0750 "/usr/src/${DKMS_PKG_NAME}-${DKMS_PKG_VER}/${path}"
	done
	insinto /etc/modprobe.d
	doins "${WORKDIR}/etc/modprobe.d/blacklist-radeon.conf"
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

dkms_build() {
	local _k="${k}$(git_modules_folder_suffix)/${ARCH}"
einfo "Running:  \`dkms build ${DKMS_PKG_NAME}/${DKMS_PKG_VER} -k ${_k}\`"
	dkms build "${DKMS_PKG_NAME}/${DKMS_PKG_VER}" -k "${_k}" || die
einfo "Running:  \`dkms install ${DKMS_PKG_NAME}/${DKMS_PKG_VER} -k ${_k} --force\`"
	dkms install "${DKMS_PKG_NAME}/${DKMS_PKG_VER}" -k "${_k}" --force || die
einfo "The modules were installed in $(get_modules_folder)/updates"
	signing_modules "${k}"
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

pkg_postinst() {
	dkms add ${DKMS_PKG_NAME}/${DKMS_PKG_VER}
	if use build ; then
		local k
		for k in ${ROCK_DKMS_KERNELS} ; do
			if [[ "${k}" =~ "*" ]] ; then
				# Pick all point releases:  6.1.*-zen
				local V=$(find /usr/src/ -maxdepth 1 -name "linux-${k}" \
					| sort --version-sort -r \
					| cut -f 4 -d "/" \
					| sed -e "s|linux-||")
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
					| cut -f 4 -d "/" \
					| sed -e "s|linux-||")
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
