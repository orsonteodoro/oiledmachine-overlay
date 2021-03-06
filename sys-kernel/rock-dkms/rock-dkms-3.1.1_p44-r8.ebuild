# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info unpacker

DESCRIPTION="ROCk DKMS kernel module"
HOMEPAGE="https://rocm-documentation.readthedocs.io/en/latest/Installation_Guide/ROCk-kernel.html"
LICENSE="GPL-2 MIT
	firmware? ( AMDGPU-FIRMWARE RADEON-FIRMWARE )"
KEYWORDS="amd64"
REV=$(ver_cut 5 ${PV})
PV_MAJOR_MINOR=$(ver_cut 1-2 ${PV})
ROCK_VER=$(ver_cut 1-3 ${PV})
SUFFIX="${PV_MAJOR_MINOR}-${REV}"
FN="rock-dkms_${SUFFIX}_all.deb"
BASE_URL="http://repo.radeon.com/rocm/apt/${ROCK_VER}/"
FOLDER="pool/main/r/rock-dkms/"
SRC_URI="${BASE_URL}${FOLDER}/${FN}"
SLOT="0/${PV}"
IUSE="acpi +build +check-mmu-notifier +check-pcie +check-gpu custom-kernel directgma firmware hybrid-graphics numa rt +sign-modules ssg"
REQUIRED_USE="hybrid-graphics? ( acpi )"
if [[ "${ROCK_DKMS_EBUILD_MAINTAINER}" == "1" ]] ; then
KV_NOT_SUPPORTED_MAX="99999"
KV_SUPPORTED_MIN="5.0"
else
KV_NOT_SUPPORTED_MAX="5.5"
KV_SUPPORTED_MIN="5.0"
fi
RDEPEND="firmware? ( sys-firmware/rock-firmware:${SLOT} )
	 sys-kernel/dkms
	 !custom-kernel? (
	 || ( <sys-kernel/bliss-kernel-bin-${KV_NOT_SUPPORTED_MAX}
	      <sys-kernel/ck-sources-${KV_NOT_SUPPORTED_MAX}
	      <sys-kernel/gentoo-kernel-bin-${KV_NOT_SUPPORTED_MAX}
	      <sys-kernel/gentoo-sources-${KV_NOT_SUPPORTED_MAX}
	      <sys-kernel/ot-sources-${KV_NOT_SUPPORTED_MAX}
	      <sys-kernel/pf-sources-${KV_NOT_SUPPORTED_MAX}
	      <sys-kernel/rt-sources-${KV_NOT_SUPPORTED_MAX}
	      <sys-kernel/vanilla-sources-${KV_NOT_SUPPORTED_MAX}
	      <sys-kernel/zen-sources-${KV_NOT_SUPPORTED_MAX} )
	 || ( >=sys-kernel/bliss-kernel-bin-${KV_SUPPORTED_MIN}
	      >=sys-kernel/ck-sources-${KV_SUPPORTED_MIN}
	      >=sys-kernel/gentoo-kernel-bin-${KV_SUPPORTED_MIN}
	      >=sys-kernel/gentoo-sources-${KV_SUPPORTED_MIN}
	      >=sys-kernel/ot-sources-${KV_SUPPORTED_MIN}
	      >=sys-kernel/pf-sources-${KV_SUPPORTED_MIN}
	      >=sys-kernel/rt-sources-${KV_SUPPORTED_MIN}
	      >=sys-kernel/vanilla-sources-${KV_SUPPORTED_MIN}
	      >=sys-kernel/zen-sources-${KV_SUPPORTED_MIN} )
	 )
"
DEPEND="${RDEPEND}"
BDEPEND="${BDEPEND}
	check-pcie? ( sys-apps/dmidecode )
	check-gpu? ( sys-apps/pciutils )
	rt? ( dev-util/patchutils )
	sys-apps/grep[pcre]"
S="${WORKDIR}/usr/src/amdgpu-${SUFFIX}"
RESTRICT="fetch"
DKMS_PKG_NAME="amdgpu"
DKMS_PKG_VER="${SUFFIX}"
DC_VER="3.2.68"
AMDGPU_VERSION="5.4.4"

PATCHES=( "${FILESDIR}/rock-dkms-2.8_p13-makefile-recognize-gentoo.patch"
	  "${FILESDIR}/rock-dkms-3.0_p6-enable-mmu_notifier.patch"
	  "${FILESDIR}/rock-dkms-3.1_p44-no-firmware-install.patch"
	  "${FILESDIR}/rock-dkms-3.1_p35-add-header-to-kcl_fence_c.patch"
	  "${FILESDIR}/rock-dkms-3.1_p44-fix-retval-for-drm_dp_atomic_find_vcpi_slots.patch" )
RT_FN_="dma-buf-Use-seqlock_t-instread-disabling-preemption.patch"
RT_FN="5.4.123-rt59-0087-${RT_FN_}"

pkg_nofetch() {
        local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
        einfo "Please download"
        einfo "  - ${FN}"
        einfo "from ${BASE_URL} in the ${FOLDER} folder and place them in ${distdir}"
}

pkg_pretend() {
	ewarn "Long Term Support (LTS) kernels 5.4.x are only supported."
	if use check-pcie ; then
		if has sandbox $FEATURES ; then
			die "${PN} require sandbox to be disabled in FEATURES when testing hardware with check-pcie USE flag."
		fi
	fi
}

pkg_setup_warn() {
	ewarn "Disabling build is not recommended.  It is intended for unattended installs.  You are responsible for the following .config flags:"

	if ! linux_config_exists ; then
		ewarn "You are missing a .config file in your linux sources."
	fi

	if ! linux_chkconfig_builtin "MODULES" ; then
		ewarn "You need loadable modules support in your .config."
	fi

	CONFIG_CHECK=" !TRIM_UNUSED_KSYMS"
	WARNING_TRIM_UNUSED_KSYMS="CONFIG_TRIM_UNUSED_KSYMS should not be set and the kernel recompiled without it."
	check_extra_config

	CONFIG_CHECK=" ~AMD_IOMMU_V2"
	WARNING_MMU_NOTIFIER=" CONFIG_AMD_IOMMU_V2 must be set to =y in the kernel or CONFIG_HSA_AMD will be inaccessible in \`make menuconfig\`."
	check_extra_config

	if use check-mmu-notifier ; then
		if ! linux_chkconfig_module "HSA_AMD" ; then
			if ! linux_chkconfig_builtin "HSA_AMD" ; then
				ewarn "CONFIG_HSA_AMD must be set to =y or =m in the kernel .config."
			fi
		fi
	fi

	CONFIG_CHECK=" ~MMU_NOTIFIER"
	WARNING_MMU_NOTIFIER=" CONFIG_MMU_NOTIFIER must be set to =y in the kernel or it will fail in the link stage."
	check_extra_config

	CONFIG_CHECK=" ~DRM_AMD_ACP"
	WARNING_MFD_CORE=" CONFIG_DRM_AMD_ACP (Enable ACP IP support) must be set to =y in the kernel or it will fail in the link stage."
	check_extra_config

	CONFIG_CHECK=" ~MFD_CORE"
	WARNING_MFD_CORE=" CONFIG_MFD_CORE must be set to =y or =m in the kernel or it will fail in the link stage."
	check_extra_config

	if use directgma || use ssg ; then
		# needs at least ZONE_DEVICE, rest are dependencies for it
		CONFIG_CHECK=" ~ZONE_DEVICE ~MEMORY_HOTPLUG ~MEMORY_HOTREMOVE ~SPARSEMEM_VMEMMAP ~ARCH_HAS_PTE_DEVMAP"
		WARNING_ZONE_DEVICE=" CONFIG_ZONE_DEVICE must be set to =y in the kernel .config."
		WARNING_MEMORY_HOTPLUG=" CONFIG_MEMORY_HOTPLUG must be set to =y in the kernel .config."
		WARNING_MEMORY_HOTREMOVE=" CONFIG_MEMORY_HOTREMOVE must be set to =y in the kernel .config."
		WARNING_SPARSEMEM_VMEMMAP=" CONFIG_SPARSEMEM_VMEMMAP must be set to =y in the kernel .config."
		WARNING_ARCH_HAS_PTE_DEVMAP=" CONFIG_ARCH_HAS_PTE_DEVMAP must be set to =y in the kernel .config."
		check_extra_config
	fi

	if use numa ; then
		CONFIG_CHECK=" ~NUMA"
		WARNING_NUMA=" CONFIG_NUMA must be set to =y in the kernel .config."
		check_extra_config
	fi

	if use acpi ; then
		CONFIG_CHECK=" ~ACPI"
		WARNING_ACPI=" CONFIG_ACPI must be set to =y in the kernel .config."
		check_extra_config
	fi

	if use hybrid-graphics ; then
		CONFIG_CHECK=" ~ACPI ~VGA_SWITCHEROO"
		WARNING_ACPI=" CONFIG_ACPI must be set to =y in the kernel .config."
		WARNING_VGA_SWITCHEROO=" CONFIG_VGA_SWITCHEROO must be set to =y in the kernel .config."
		check_extra_config
	fi

	if ! linux_chkconfig_module "DRM_AMDGPU" ; then
		ewarn "CONFIG_DRM_AMDGPU (Graphics support > AMD GPU) must be compiled as a module (=m)."
	fi

	if [ ! -e "${EROOT}/usr/src/linux-${k}/Module.symvers" ] ; then
		ewarn "Your kernel sources must have a Module.symvers in the root of the linux sources folder produced from a successful kernel compile beforehand in order to build this driver."
	fi
}

pkg_setup_error() {
	if ! linux_config_exists ; then
		die "You must have a .config file in your linux sources"
	fi

	check_modules_supported

	CONFIG_CHECK=" !TRIM_UNUSED_KSYMS"
	ERROR_TRIM_UNUSED_KSYMS="CONFIG_TRIM_UNUSED_KSYMS should not be set and the kernel recompiled without it."
	check_extra_config

	CONFIG_CHECK=" AMD_IOMMU_V2"
	ERROR_MMU_NOTIFIER=" CONFIG_AMD_IOMMU_V2 must be set to =y in the kernel or CONFIG_HSA_AMD will be inaccessible in \`make menuconfig\`."
	check_extra_config

	if use check-mmu-notifier ; then
		if ! linux_chkconfig_module "HSA_AMD" ; then
			if ! linux_chkconfig_builtin "HSA_AMD" ; then
				die "CONFIG_HSA_AMD must be set to =y or =m in the kernel .config."
			fi
		fi
	fi

	CONFIG_CHECK=" MMU_NOTIFIER"
	ERROR_MMU_NOTIFIER=" CONFIG_MMU_NOTIFIER must be set to =y in the kernel or it will fail in the link stage."
	check_extra_config

	CONFIG_CHECK=" DRM_AMD_ACP"
	ERROR_MFD_CORE=" CONFIG_DRM_AMD_ACP (Enable ACP IP support) must be set to =y in the kernel or it will fail in the link stage."
	check_extra_config

	CONFIG_CHECK=" MFD_CORE"
	ERROR_MFD_CORE=" CONFIG_MFD_CORE must be set to =y or =m in the kernel or it will fail in the link stage."
	check_extra_config

	if use directgma || use ssg ; then
		# needs at least ZONE_DEVICE, rest are dependencies for it
		CONFIG_CHECK=" ZONE_DEVICE MEMORY_HOTPLUG MEMORY_HOTREMOVE SPARSEMEM_VMEMMAP ARCH_HAS_PTE_DEVMAP"
		ERROR_ZONE_DEVICE=" CONFIG_ZONE_DEVICE must be set to =y in the kernel .config."
		ERROR_MEMORY_HOTPLUG=" CONFIG_MEMORY_HOTPLUG must be set to =y in the kernel .config."
		ERROR_MEMORY_HOTREMOVE=" CONFIG_MEMORY_HOTREMOVE must be set to =y in the kernel .config."
		ERROR_SPARSEMEM_VMEMMAP=" CONFIG_SPARSEMEM_VMEMMAP must be set to =y in the kernel .config."
		ERROR_ARCH_HAS_PTE_DEVMAP=" CONFIG_ARCH_HAS_PTE_DEVMAP must be set to =y in the kernel .config."
		check_extra_config
	fi

	if use numa ; then
		CONFIG_CHECK=" NUMA"
		ERROR_NUMA=" CONFIG_NUMA must be set to =y in the kernel .config."
		check_extra_config
	fi

	if use acpi ; then
		CONFIG_CHECK=" ACPI"
		ERROR_ACPI=" CONFIG_ACPI must be set to =y in the kernel .config."
		check_extra_config
	fi

	if use hybrid-graphics ; then
		CONFIG_CHECK=" ACPI VGA_SWITCHEROO"
		ERROR_ACPI=" CONFIG_ACPI must be set to =y in the kernel .config."
		ERROR_VGA_SWITCHEROO=" CONFIG_VGA_SWITCHEROO must be set to =y in the kernel .config."
		check_extra_config
	fi

	if ! linux_chkconfig_module DRM_AMDGPU ; then
		die "CONFIG_DRM_AMDGPU (Graphics support > AMD GPU) must be compiled as a module (=m)."
	fi

	if [ ! -e "${EROOT}/usr/src/linux-${k}/Module.symvers" ] ; then
		die "Your kernel sources must have a Module.symvers in the root folder produced from a successful kernel compile beforehand in order to build this driver."
	fi
}

# The sandbox/ebuild doesn't allow to check in setup phase
check_hardware() {
	local is_pci_slots_supported=1
	einfo "Testing hardware for ROCm API compatibility"
	if use check-pcie ; then
		if ! ( dmidecode -t slot | grep "PCI Express 3" > /dev/null ); then
			ewarn "Your PCIe slots are not supported for ROCm support, but it depends on if the GPU doesn't require them."
			is_pci_slots_supported=0
		fi
	fi

	# sandbox or emerge won't allow reading FILESDIR in setup phase
	local atomic_f=0
	local atomic_not_required=0
	local device_ids
	local blacklisted_gpu=0
	if use check-gpu ; then
		device_ids=$(lspci -nn | grep VGA | grep -P -o -e "[0-9a-f]{4}:[0-9a-f]{4}" | cut -f2 -d ":" | tr "[:lower:]" "[:upper:]")
		for device_id in ${device_ids} ; do
			if [[ -z "${device_id}" ]] ; then
				ewarn "Your APU/GPU is not supported for device_id=${device_id}"
				continue
			fi
			# the format is asicname_needspciatomics
			local asics="kaveri_0 carrizo_0 raven_1 hawaii_1 tonga_1 fiji_1 fijivf_0 polaris10_1 polaris10vf_0 polaris11_1 polaris12_1 vegam_1 vega10_0 vega10vf_0 vega12_0 vega20_0 arcturus_0 arcturusvf_0 navi10_0"
			local no_support="tonga iceland vegam vega12" # See https://rocm-documentation.readthedocs.io/en/latest/InstallGuide.html#not-supported
			local found_asic=$(grep -i "${device_id}" "${FILESDIR}/kfd_device.c_v${ROCK_VER}" | grep -P -o -e "/\* [ a-zA-Z0-9]+\*/" | sed -e "s|[ /*]||g" | tr "[:upper:]" "[:lower:]")
			x_atomic_f=$(echo "${asics}" | grep -P -o -e "${found_asic}_[01]" | sed -e "s|${found_asic}_||g")
			atomic_f=$(( ${atomic_f} | ${x_atomic_f} ))
			if [[ "${no_support}" =~ "${found_asic}" ]] ; then
				ewarn "Your ${found_asic} GPU is not supported."
				blacklisted_gpu=1
			elif [[ "${x_atomic_f}" == "1" ]] ; then
				ewarn "Your APU/GPU requires PCIe atomics support for device_id=${device_id}"
			else
				atomic_not_required=1
				einfo "Your APU/GPU is supported for device_id=${device_id}"
			fi
		done
	fi

	if use check-pcie && use check-gpu ; then
		einfo "ROCm hardware support results:"
		if (( ${#device_ids} >= 1 )) && [[ "${is_pci_slots_supported}" == "1" && "${blacklisted_gpu}" == "0" ]] ; then
			einfo "Your setup is supported."
		elif (( ${#device_ids} == 1 )) && [[ "${atomic_not_required}" == "1" && "${blacklisted_gpu}" == "0" ]] ; then
			einfo "Your setup is supported."
		elif (( ${#device_ids} == 1 )) && [[ "${atomic_f}" == "1" && "${is_pci_slots_supported}" != "1" ]] ; then
			die "Your APU/GPU and PCIe combo is not supported.  You may disable check-pcie or check-gpu to continue."
		elif (( ${#device_ids} > 1 )) && [[ "${atomic_f}" == "1" && "${is_pci_slots_supported}" != "1" && "${atomic_not_required}" == "0" ]] ; then
			die "You APU/GPU and PCIe combo is not supported for your multiple GPU setup.  You may disable check-pcie or check-gpu to continue."
		elif (( ${#device_ids} > 1 )) && [[ "${atomic_f}" == "1" && "${is_pci_slots_supported}" != "1" && "${atomic_not_required}" == "1" ]] ; then
			ewarn "You APU/GPU and PCIe combo may not be supported for some of your GPUs."
		fi
	fi
}

check_kernel() {
	local k="$1"
	local kv=$(echo "${k}" | cut -f1 -d'-')
	if ver_test ${kv} -ge ${KV_NOT_SUPPORTED_MAX} ; then
		die "Kernel version ${kv} is not supported.  Update your ROCK_DKMS_KERNELS environmental variable."
	fi
	if ver_test ${kv} -lt ${KV_SUPPORTED_MIN} ; then
		die "Kernel version ${kv} is not supported.  Update your ROCK_DKMS_KERNELS environmental variable."
	fi
	KERNEL_DIR="/usr/src/linux-${k}"
	get_version || die
	linux_config_exists
	if use build || [[ "${EBUILD_PHASE_FUNC}" == "pkg_config" ]]; then
		pkg_setup_error
	else
		pkg_setup_warn
	fi
	if use rt ; then
		if grep -q -F -e "read_seqbegin" "${KERNEL_DIR}/drivers/dma-buf/dma-buf.c" ; then
			einfo "Passed rt kernel check on ${k}."
		else
			die "Failed kernel check on ${k}.  Missing read_seqbegin changes in \${KERNEL_DIR}/drivers/dma-buf/dma-buf.c from ${RT_FN_} for <= 5.6.x kernel series."
		fi
	else
		if grep -q -F -e "ARCH_SUPPORTS_RT" "${KERNEL_DIR}/arch/x86/Kconfig" ; then
			ewarn "The rt USE flag is recommended to avoid hang on ${k}."
		fi
	fi
}

pkg_setup() {
	if [[ -z "${ROCK_DKMS_KERNELS}" ]] ; then
		eerror "You must define a per-package env or add to /etc/portage/make.conf an environmental variable named ROCK_DKMS_KERNELS"
		eerror "containing a space delimited <kernvel_ver>-<extra_version>."
		eerror
		eerror "It should look like ROCK_DKMS_KERNELS=\"5.2.17-pf 5.2.17-gentoo\""
		die
	fi

if [[ "${ROCK_DKMS_EBUILD_MAINTAINER}" != "1" ]] ; then
	for k in ${ROCK_DKMS_KERNELS} ; do
		if [[ "${k}" =~ "*" ]] ; then
			# pick all point releases: 5.2.*-ot
			V=$(find /usr/src/ -maxdepth 1 -name "linux-${k}" | sort --version-sort -r | cut -f 4 -d "/" | sed -e "s|linux-||")
			for v in ${V} ; do
				k="${v}"
				check_kernel "${k}"
			done
		elif [[ "${k}" =~ "^" ]] ; then
			# pick highest version: 5.2.^-ot
			local pat="${k/^/*}"
			k=$(find /usr/src/ -maxdepth 1 -name "linux-${pat}" | sort --version-sort -r | head -n 1 | cut -f 4 -d "/" | sed -e "s|linux-||")
			check_kernel "${k}"
		else
			check_kernel "${k}"
		fi
	done
fi
}

src_unpack() {
	unpack_deb ${A}
	rm -rf "${S}/firmware" || die
}

apply_rt() {
	einfo "Applying PREEMPT_RT driver patch"
	filterdiff \
		-x '*/dma-buf.c' \
		-x '*/i915_gem_busy.c' \
		"${FILESDIR}/${RT_FN}" > "${T}/${RT_FN}" || die
	sed -i -e 's|drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c|amd/amdgpu/amdgpu_amdkfd_gpuvm.c|g' \
		"${T}/${RT_FN}" || die
	sed -i -e 's|drivers/dma-buf/dma-resv.c|amd/amdkcl/dma-resv.c|g' \
		"${T}/${RT_FN}" || die
	eapply "${T}/${RT_FN}"
}

src_prepare() {
	default
	if use rt ; then
		apply_rt
	fi
	einfo "DC_VER=${DC_VER}"
	einfo "AMDGPU_VERSION=${AMDGPU_VERSION}"
	einfo "ROCK_VER=${ROCK_VER}"
if [[ "${ROCK_DKMS_EBUILD_MAINTAINER}" != "1" ]] ; then
	check_hardware
fi
	chmod 0750 autogen.sh || die
	./autogen.sh || die
	pushd amd/dkms || die
	chmod 0750 autogen.sh || die
	./autogen.sh || die
	popd
}

src_configure() {
	set_arch_to_kernel
}

src_compile() {
	:;
}

src_install() {
	dodir usr/src/${DKMS_PKG_NAME}-${DKMS_PKG_VER}
	insinto usr/src/${DKMS_PKG_NAME}-${DKMS_PKG_VER}
	doins -r "${S}"/*
	fperms 0750 /usr/src/${DKMS_PKG_NAME}-${DKMS_PKG_VER}/{post-install.sh,post-remove.sh,pre-build.sh,config/install-sh,configure,amd/dkms/configure,amd/dkms/pre-build.sh,autogen.sh,amd/dkms/autogen.sh}
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
		die "Could not locate modules folder to sign."
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
		die "Could not locate modules folder to sign."
	fi
	echo "${md}"
}

sign_module() {
	local module_path="${1}"
	einfo "Signing $(basename ${module_path})"
	/usr/src/linux-${k}/scripts/sign-file "${module_sig_hash}" "${key_path}" "${cert_path}" "${module_path}" || die
}

signing_modules() {
	local k="${1}"
	KERNEL_DIR="/usr/src/linux-${k}"
	get_version
	linux_config_exists
	if linux_chkconfig_builtin "MODULE_SIG" && use sign-modules ; then
		local kd="/usr/src/linux-${k}"
		local md=$(get_modules_folder)
		local module_sig_hash="$(grep -Po '(?<=CONFIG_MODULE_SIG_HASH=").*(?=")' ${kd}/.config)"
		local module_sig_key="$(grep -Po '(?<=CONFIG_MODULE_SIG_KEY=").*(?=")' ${kd}/.config)"
		module_sig_key="${module_sig_key:-certs/signing_key.pem}"
		if [[ "${module_sig_key#pkcs11:}" == "${module_sig_key}" && "${module_sig_key#/}" == "${module_sig_key}" ]]; then
			local key_path="${kd}/${module_sig_key}"
		else
			local key_path="${module_sig_key}"
		fi
		local cert_path="${kd}/certs/signing_key.x509"
		sign_module "${md}/updates/amd-sched.ko" || die
		sign_module "${md}/updates/amdttm.ko" || die
		sign_module "${md}/updates/amdkcl.ko" || die
		sign_module "${md}/updates/amdgpu.ko" || die
	fi
}

dkms_build() {
	local _k="${k}$(git_modules_folder_suffix)/${ARCH}"
	einfo "Running: \`dkms build ${DKMS_PKG_NAME}/${DKMS_PKG_VER} -k ${_k}\`"
	dkms build ${DKMS_PKG_NAME}/${DKMS_PKG_VER} -k ${_k} || die
	einfo "Running: \`dkms install ${DKMS_PKG_NAME}/${DKMS_PKG_VER} -k ${_k} --force\`"
	dkms install ${DKMS_PKG_NAME}/${DKMS_PKG_VER} -k ${_k} --force || die
	einfo "The modules were installed in $(get_modules_folder)/updates"
	signing_modules ${k}
}

check_modprobe_conf() {
	if grep -r -e "options amdgpu virtual_display" /etc/modprobe.d/ ; then
		local files=$(grep -l -r -e "options amdgpu virtual_display" /etc/modprobe.d/)
		ewarn "Detected ${files} containing options amdgpu virtual_display."
		ewarn "You may get a blank screen when loading module.  Add # to the front of that line."
	fi
}

pkg_postinst() {
	dkms add ${DKMS_PKG_NAME}/${DKMS_PKG_VER}
	if use build ; then
		for k in ${ROCK_DKMS_KERNELS} ; do
			if [[ "${k}" =~ "*" ]] ; then
				# pick all point releases: 5.2.*-ot
				V=$(find /usr/src/ -maxdepth 1 -name "linux-${k}" | sort --version-sort -r | cut -f 4 -d "/" | sed -e "s|linux-||")
				for v in ${V} ; do
					k="${v}"
					dkms_build
				done
			elif [[ "${k}" =~ "^" ]] ; then
				# pick highest version: 5.2.^-ot
				local pat="${k/^/*}"
				k=$(find /usr/src/ -maxdepth 1 -name "linux-${pat}" | sort --version-sort -r | head -n 1 | cut -f 4 -d "/" | sed -e "s|linux-||")
				dkms_build
			else
				dkms_build
			fi
		done
	else
		einfo
		einfo "The ${PN} source code has been installed but not compiled."
		einfo "You may do \`emerge ${PN} --config\` to compile them"
		einfo " or "
		einfo "Run something like \`dkms build ${DKMS_PKG_NAME}/${DKMS_PKG_VER} -k 5.2.17-gentoo/x86_64\`"
		einfo
	fi
	einfo
	einfo "For fully utilizing ROCmRDMA, it is recommend to set iommu off or in passthough mode."
	einfo "Do \`dmesg | grep -i iommu\` to see if Intel or AMD."
	einfo "If AMD IOMMU, add to kernel parameters either amd_iommu=off or iommu=pt"
	einfo "If Intel IOMMU, add to kernel parameters either intel_iommu=off or iommu=pt"
	einfo "For more information, See https://rocm-documentation.readthedocs.io/en/latest/Remote_Device_Programming/Remote-Device-Programming.html#rocmrdma ."
	einfo
	einfo "Only <${KV_NOT_SUPPORTED_MAX} kernels are supported for these kernel modules."
	einfo

	einfo "DirectGMA / SSG is disabled by default.  You need to explicitly enable it in your bootloader config."
	einfo "You need to add to your kernel parameters:"
	einfo
	einfo "  amdgpu.ssg=1 amdgpu.direct_gma_size=X"
	einfo
	einfo "where X is in MB with max limit of 96"
	einfo "For details see:  https://www.amd.com/en/support/kb/release-notes/rn-radeonprossg-linux"

	# For possible impractical passthough (pt) DMA attack, see
	# https://link.springer.com/article/10.1186/s13173-017-0066-7#Fn1
	ewarn
	ewarn "Disabling IOMMU or using passthrough (pt) is not recommended to mitigate against a DMA attack"
	ewarn "used in cold boot attacks for full disk encryption."
	ewarn

	check_modprobe_conf
}

pkg_prerm() {
	dkms remove ${DKMS_PKG_NAME}/${DKMS_PKG_VER} --all
}

pkg_config() {
	local k
	local v=$(cat /proc/version | cut -f 3 -d " ")
	einfo "Found ${v}.  Use this (yes/no/quit)?  Choosing no will allow to pick the version & extraversion."
	read choice
	choice="${choice,,}"
	case ${choice} in
		yes|y)
			k="${v}"
			;;
		no|n)
			einfo "What is your kernel version? (5.2.17)"
			read kernel_ver
			einfo "What is your kernel extraversion? (gentoo, pf, git, ...)"
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
