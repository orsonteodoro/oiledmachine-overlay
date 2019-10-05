# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info unpacker

DESCRIPTION="ROCk DKMS kernel module"
HOMEPAGE="https://rocm-documentation.readthedocs.io/en/latest/Installation_Guide/ROCk-kernel.html"
LICENSE="GPL-2"
KEYWORDS="amd64"
MY_RPR="${PV//_p/-}" # Remote PR
FN="rock-dkms_${MY_RPR}_all.deb"
BASE_URL="http://repo.radeon.com/rocm/apt/debian"
FOLDER="pool/main/r/rock-dkms"
SRC_URI="http://repo.radeon.com/rocm/apt/debian/pool/main/r/rock-dkms/${FN}"
SLOT="0"
IUSE="+build check-mmu-notifier-hard +check-mmu-notifier-easy +check-pcie-2_1 firmware"
RDEPEND="firmware? ( sys-firmware/rock-firmware )
	 sys-kernel/dkms"
# drm_format_info_plane_cpp got removed in 5.3 and this module uses it
DEPEND="${RDEPEND}
	|| ( <sys-kernel/ck-sources-5.3
	     <sys-kernel/gentoo-sources-5.3
	     <sys-kernel/git-sources-5.3
	     <sys-kernel/ot-sources-5.3
	     <sys-kernel/pf-sources-5.3
	     <sys-kernel/vanilla-sources-5.3
	     <sys-kernel/zen-sources-5.3 )"
S="${WORKDIR}/usr/src/amdgpu-${MY_RPR}"
RESTRICT="fetch"
DKMS_PKG_NAME="amdgpu"
DKMS_PKG_VER="${MY_RPR}"

# patches based on https://aur.archlinux.org/cgit/aur.git/tree/?h=amdgpu-dkms
# patches try to make it linux kernel 5.1+ compatible but still missing 5.3 compatibility.

# the use-drm_need_swiotlb and use-drm_helper_force_disable_all patches do not flag errors.  i don't know how these are sourced.

PATCHES=( "${FILESDIR}/rock-dkms-2.8_p13-makefile-recognize-gentoo.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-fix-ac_kernel_compile_ifelse.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_probe_helper-for-5_1-part-1.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_probe_helper-for-5_1-part-2.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_probe_helper-for-5_1-part-3.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_probe_helper-for-5_1-part-4.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_probe_helper-for-5_1-part-5.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_probe_helper-for-5_1-part-6.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_probe_helper-for-5_1-part-7.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_probe_helper-for-5_1-part-8.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_probe_helper-for-5_1-part-9.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_probe_helper-for-5_1-part-10.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_probe_helper-for-5_1-part-11.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-add-signal_h-for-signal_pending.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-add-drm_probe_helper_h-for-drm_helper_probe_single_connector_modes.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-either-drm_fb_helper_fill_var-or-drm_fb_helper_fill_info.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-ditched-driver_irq_shared.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_fb_helper_fill_fix-doesnt-apply-for-kernel-ver-5_2-and-above.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_helper_force_disable_all-only-for-before-kernel-ver-5_1.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_hdmi_avi_infoframe_from_display_mode-for-5_1-part-1.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_hdmi_avi_infoframe_from_display_mode-for-5_1-part-2.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_hdmi_avi_infoframe_from_display_mode-for-5_1-part-3.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_hdmi_avi_infoframe_from_display_mode-for-5_1-part-4.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_format_plane_cpp-ditched-in-5_3.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-use-ktime_get_boottime_ns-for-5_3.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-enable-mmu_notifier.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-fix-configure-test-invalidate_range_start-wants-2-args-requires-config-mmu-notifier.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-mmu_notifier_range_blockable-for-5_2.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-vm_fault_t-is-__bitwise-unsigned-int-for-5_1.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_atomic_private_obj_init-adev-ddev-arg-for-5_1.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-no-firmware-install.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-no-update-initramfs.patch"

	  # drm_crtc_force_disable_all was not marked error
	  "${FILESDIR}/rock-dkms-2.8_p13-use-drm_helper_force_disable_all-for-5_1.patch"

	  # adev->need_swiotlb = drm_get_max_iomem() > ((u64)1 << dma_bits); was not marked error
	  "${FILESDIR}/rock-dkms-2.8_p13-use-drm_need_swiotlb-for-5_2-part-1.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-use-drm_need_swiotlb-for-5_2-part-2.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-use-drm_need_swiotlb-for-5_2-part-3.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-use-drm_need_swiotlb-for-5_2-part-4.patch" )
REQUIRED_USE="|| ( check-mmu-notifier-hard check-mmu-notifier-easy )"

pkg_nofetch() {
        local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
        einfo "Please download"
        einfo "  - ${FN}"
        einfo "from ${BASE_URL} in the ${FOLDER} folder and place them in ${distdir}"
}

pkg_setup_warn() {
	ewarn "Disabling build is not recommended.  It is intended for unattended installs.  You are responsible for the following .config flags:"

	# The CONFIG_MMU_NOTIFIER must be set to =y indirectly with CONFIG_HMM_MIRROR, CONFIG_DEVICE_PRIVATE, CONFIG_DEVICE_PUBLIC, CONFIG_DRM_AMDGPU_USERPTR.
	# You can do it the hard way with more kernel options or easy way with less kernel options.

	CONFIG_CHECK+=" !TRIM_UNUSED_KSYMS"
	WARNING_TRIM_UNUSED_KSYMS="CONFIG_TRIM_UNUSED_KSYMS should not be set and the kernel recompiled without it."
	check_extra_config

	unset CONFIG_CHECK

	_COMMON_MMU_NOTIFIER_ALT="CONFIG_HMM_MIRROR, CONFIG_DEVICE_PRIVATE, or CONFIG_DEVICE_PUBLIC"
	_COMMON_MMU_NOTIFIER_REQ="Either CONFIG_HMM_MIRROR, CONFIG_DEVICE_PRIVATE, or CONFIG_DEVICE_PUBLIC must be set to =y in the kernel .config."
	if use check-mmu-notifier-hard ; then
		# HARD WAY:
		CONFIG_CHECK+=" ~MEMORY_HOTPLUG ~MEMORY_HOTREMOVE ~ZONE_DEVICE ~SPARSEMEM_VMEMMAP ~ZONE_DEVICE"
		CONFIG_CHECK+=" ~HMM_MIRROR ~DEVICE_PRIVATE ~DEVICE_PUBLIC"
		WARNING_MEMORY_HOTPLUG="You may need to set up MEMORY_HOTPLUG in the kernel .config to unlock ${_COMMON_MMU_NOTIFIER_ALT}."
		WARNING_MEMORY_HOTREMOVE="You may need to set up MEMORY_HOTREMOVE"
		WARNING_ZONE_DEVICE="You may need to set up ZONE_DEVICE"
		WARNING_SPARSEMEM_VMEMMAP="You may need to set up SPARSEMEM_VMEMMAP"
		WARNING_ZONE_DEVICE="You may need to set up ZONE_DEVICE"
		WARNING_HMM_MIRROR=" ${_COMMON_MMU_NOTIFIER_REQ}"
		WARNING_DEVICE_PRIVATE=" ${_COMMON_MMU_NOTIFIER_REQ}"
		WARNING_DEVICE_PUBLIC=" ${_COMMON_MMU_NOTIFIER_REQ}"
	fi

	if use check-mmu-notifier-easy ; then
		# EASY WAY:
		CONFIG_CHECK+=" ~DRM_AMDGPU_USERPTR"
		WARNING_DRM_AMDGPU_USERPTR=" CONFIG_DRM_AMDGPU_USERPTR must be set to =y in the kernel .config."
	fi

	check_extra_config

	unset CONFIG_CHECK

	# Either HARD WAY or EASY WAY will enable MMU_NOTIFIER
	CONFIG_CHECK+=" ~MMU_NOTIFIER"
	WARNING_MMU_NOTIFIER=" CONFIG_MMU_NOTIFIER must be set to =y in the kernel or it will fail in the link stage."

	linux-info_pkg_setup

	if ! linux_chkconfig_module "DRM_AMDGPU" ; then
		ewarn "CONFIG_DRM_AMDGPU (Graphics support > AMD GPU) must be compiled as a module (=m)."
	fi

	if [ ! -e "${ROOT}/usr/src/linux-${kv}/Module.symvers" ] ; then
		ewarn "Your kernel sources must have a Module.symvers in the root folder produced from a successful kernel compile beforehand in order to build this driver."
	fi
}

pkg_setup_error() {
	# The CONFIG_MMU_NOTIFIER must be set to =y indirectly with CONFIG_HMM_MIRROR, CONFIG_DEVICE_PRIVATE, CONFIG_DEVICE_PUBLIC, CONFIG_DRM_AMDGPU_USERPTR.
	# You can do it the hard way with more kernel options or easy way with less kernel options.

	CONFIG_CHECK+=" !TRIM_UNUSED_KSYMS"
	ERROR_TRIM_UNUSED_KSYMS="CONFIG_TRIM_UNUSED_KSYMS should not be set and the kernel recompiled without it."
	check_extra_config

	unset CONFIG_CHECK

	_COMMON_MMU_NOTIFIER_ALT="CONFIG_HMM_MIRROR, CONFIG_DEVICE_PRIVATE, or CONFIG_DEVICE_PUBLIC"
	_COMMON_MMU_NOTIFIER_REQ="Either CONFIG_HMM_MIRROR, CONFIG_DEVICE_PRIVATE, or CONFIG_DEVICE_PUBLIC must be set to =y in the kernel .config."
	if use check-mmu-notifier-hard ; then
		# HARD WAY:
		CONFIG_CHECK+=" ~MEMORY_HOTPLUG ~MEMORY_HOTREMOVE ~ZONE_DEVICE ~SPARSEMEM_VMEMMAP ~ZONE_DEVICE"
		CONFIG_CHECK+=" ~HMM_MIRROR ~DEVICE_PRIVATE ~DEVICE_PUBLIC"
		WARNING_MEMORY_HOTPLUG="You may need to set up MEMORY_HOTPLUG in the kernel .config to unlock ${_COMMON_MMU_NOTIFIER_ALT}."
		WARNING_MEMORY_HOTREMOVE="You may need to set up MEMORY_HOTREMOVE"
		WARNING_ZONE_DEVICE="You may need to set up ZONE_DEVICE"
		WARNING_SPARSEMEM_VMEMMAP="You may need to set up SPARSEMEM_VMEMMAP"
		WARNING_ZONE_DEVICE="You may need to set up ZONE_DEVICE"
		WARNING_HMM_MIRROR=" ${_COMMON_MMU_NOTIFIER_REQ}"
		WARNING_DEVICE_PRIVATE=" ${_COMMON_MMU_NOTIFIER_REQ}"
		WARNING_DEVICE_PUBLIC=" ${_COMMON_MMU_NOTIFIER_REQ}"
	fi

	if use check-mmu-notifier-easy ; then
		# EASY WAY:
		CONFIG_CHECK+=" ~DRM_AMDGPU_USERPTR"
		WARNING_DRM_AMDGPU_USERPTR=" CONFIG_DRM_AMDGPU_USERPTR must be set to =y in the kernel .config."
	fi

	check_extra_config

	unset CONFIG_CHECK

	# Either having HARD WAY or EASY WAY will enable MMU_NOTIFIER
	CONFIG_CHECK+=" MMU_NOTIFIER"
	ERROR_MMU_NOTIFIER=" CONFIG_MMU_NOTIFIER must be set to =y in the kernel or it will fail in the link stage."

	linux-info_pkg_setup

	if ! linux_chkconfig_module DRM_AMDGPU ; then
		die "CONFIG_DRM_AMDGPU (Graphics support > AMD GPU) must be compiled as a module (=m)."
	fi

	if [ ! -e "${ROOT}/usr/src/linux-${kv}/Module.symvers" ] ; then
		die "Your kernel sources must have a Module.symvers in the root folder produced from a successful kernel compile beforehand in order to build this driver."
	fi

}

pkg_setup() {
	if [[ -z "${ROCK_DKMS_KERNELS}" ]] ; then
		eerror "You must define a per-package env or add to /etc/portage/make.conf a environmental variable ROCK_DKMS_KERNELS"
		eerror "containing a space delimited <kernvel_ver>-<extra_version>."
		eerror
		eerror "It should look like ROCK_DKMS_KERNELS=\"5.2.17-pf 5.2.17-gentoo\""
		die
	fi

	for k in ${ROCK_DKMS_KERNELS} ; do
		local kv=$(echo "${k}" | cut -f1 -d'/')
		if [ ! -e /usr/src/linux-${kv} ] ; then
			die "You need to build your ${kv} kernel first before using the build USE flag."
		fi
		KERNEL_DIR="/usr/src/linux-${kv}"
		if use build ; then
			pkg_setup_error
		else
			pkg_setup_warn
		fi
	done

	if use check-pcie-2_1 ; then
		#todo
		true
	fi
}

src_unpack() {
	unpack_deb ${A}
	rm -rf "${S}/firmware" || die
}

src_prepare() {
	default
	chmod 0770 autogen.sh || die
	./autogen.sh || die
	pushd amd/dkms || die
	chmod 0770 autogen.sh || die
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
	fperms 0770 /usr/src/${DKMS_PKG_NAME}-${DKMS_PKG_VER}/{post-install.sh,post-remove.sh,pre-build.sh,config/install-sh,configure,amd/dkms/pre-build.sh,autogen.sh,amd/dkms/autogen.sh}
	insinto /etc/modprobe.d
	doins "${WORKDIR}/etc/modprobe.d/blacklist-radeon.conf"
}

pkg_postinst() {
	dkms add ${DKMS_PKG_NAME}/${DKMS_PKG_VER}
	if use build ; then
		for k in ${ROCK_DKMS_KERNELS} ; do
			einfo "Running: \`dkms build ${DKMS_PKG_NAME}/${DKMS_PKG_VER} -k ${k}/${ARCH}\`"
			dkms build ${DKMS_PKG_NAME}/${DKMS_PKG_VER} -k ${k}/${ARCH} || die
			einfo "Running: \`dkms install ${DKMS_PKG_NAME}/${DKMS_PKG_VER} -k ${k}/${ARCH}\`"
			dkms install ${DKMS_PKG_NAME}/${DKMS_PKG_VER} -k ${k}/${ARCH} || die
			einfo "The modules where installed in /lib/modules/${kernel_ver}-${kernel_extraversion}/updates"
		done
	else
		einfo "The ${PN} source code has been installed but not compiled."
		einfo "You may do \`emerge ${PN} --config\` to compile them"
		einfo " or "
		einfo "Run something like \`dkms build ${DKMS_PKG_NAME}/${DKMS_PKG_VER} -k 5.2.17-gentoo/x86_64\`"
	fi
	einfo
	einfo "For fully utilizing ROCmRDMA, it is recommend to set iommu off or in passthough mode."
	einfo "Do `dmesg | grep -i iommu` to see if Intel or AMD."
	einfo "If AMD IOMMU, add to kernel parameters either amd_iommu=off or iommu=pt"
	einfo "If Intel IOMMU, add to kernel parameters either intel_iommu=off or iommu=pt"
	einfo "For more information, See https://rocm-documentation.readthedocs.io/en/latest/Remote_Device_Programming/Remote-Device-Programming.html#rocmrdma ."
	einfo
	einfo
	einfo "Only <5.3 kernels are supported for these kernel modules."
	einfo
	einfo "You need a PCIe 3.0 or a GPU that doesn't require PCIe atomics to use ROCK."
	einfo "See needs_pci_atomics field for your GPU family in"
	einfo "https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/blob/master/drivers/gpu/drm/amd/amdkfd/kfd_device.c"
	einfo "for the exception.  For supported CPUs see"
	einfo "https://rocm.github.io/hardware.html"
	einfo
}

pkg_prerm() {
	dkms remove ${DKMS_PKG_NAME}/${DKMS_PKG_VER} --all
}

pkg_config() {
	einfo "What is your kernel version? (5.2.17)"
	read kernel_ver
	einfo "What is your kernel extraversion? (gentoo, pf, git, ...)"
	read kernel_extraversion

	einfo "Running: \`dkms build ${DKMS_PKG_NAME}/${DKMS_PKG_VER} -k ${kernel_ver}-${kernel_extraversion}/${ARCH}\`"
	dkms build ${DKMS_PKG_NAME}/${DKMS_PKG_VER} -k ${kernel_ver}-${kernel_extraversion}/${ARCH} || die "Your module build failed."
	einfo "Running: \`dkms install ${DKMS_PKG_NAME}/${DKMS_PKG_VER} -k ${kernel_ver}-${kernel_extraversion}/${ARCH}\`"
	dkms install ${DKMS_PKG_NAME}/${DKMS_PKG_VER} -k ${kernel_ver}-${kernel_extraversion}/${ARCH} || die "Your module install failed."
	einfo "The modules where installed in /lib/modules/${kernel_ver}-${kernel_extraversion}/updates"
}
