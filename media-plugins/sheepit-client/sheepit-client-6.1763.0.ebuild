# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION='Client for the free and distributed render farm "SheepIt Render Farm"'
HOMEPAGE="https://github.com/laurent-clouet/sheepit-client"
LICENSE="GPL-2 Apache-2.0"
KEYWORDS="~amd64"
SLOT="0"
IUSE="cuda intel-ocl lts +opencl opencl_rocm opencl_orca \
opencl_pal opengl_mesa pro-drivers split-drivers \
video_cards_amdgpu video_cards_i965 video_cards_iris video_cards_nvidia \
video_cards_radeonsi"
REQUIRED_USE="^^ ( cuda opencl )"
RDEPEND="
	opencl? (
	intel-ocl? ( dev-util/intel-ocl-sdk )
	|| (
		video_cards_amdgpu? (
			|| (
				pro-drivers? (
					opengl_mesa? (
						!lts? ( x11-drivers/amdgpu-pro[X,developer,open-stack,opengl_mesa,opencl,opencl_pal?,opencl_orca?] )
						lts? ( x11-drivers/amdgpu-pro-lts[X,developer,open-stack,opengl_mesa,opencl,opencl_pal?,opencl_orca?] )
					)
					!opengl_mesa? (
						!lts? ( x11-drivers/amdgpu-pro[opencl,opencl_pal?,opencl_orca?] )
						lts? ( x11-drivers/amdgpu-pro-lts[opencl,opencl_pal?,opencl_orca?] )
					)
				)
				split-drivers? (
					opencl_orca? ( dev-libs/amdgpu-pro-opencl )
					opencl_rocm? ( dev-libs/rocm-opencl-runtime )
				)
			)
		)
		video_cards_i965? (
			dev-libs/intel-neo
		)
		video_cards_iris? (
			dev-libs/intel-neo
		)
		video_cards_nvidia? (
			x11-drivers/nvidia-drivers
		)
		video_cards_radeonsi? (
			dev-libs/amdgpu-pro-opencl
		)
	)
	)
	cuda? ( x11-drivers/nvidia-drivers )
	virtual/jre:1.8"
DEPEND="${RDEPEND}
	dev-java/gradle-bin
	virtual/jdk:1.8"
REQUIRED_USE="
	pro-drivers? ( || ( opencl_orca opencl_pal opencl_rocm ) )
	opencl_orca? (
		|| ( split-drivers pro-drivers )
		video_cards_amdgpu
	)
	opencl_pal? (
		pro-drivers
		video_cards_amdgpu
	)
	opencl_rocm? (
		split-drivers
		video_cards_amdgpu
	)
	split-drivers? ( || ( opencl_orca opencl_rocm ) )
	video_cards_amdgpu? (
		|| ( pro-drivers split-drivers )
	)
"
inherit linux-info
SRC_URI="https://github.com/laurent-clouet/sheepit-client/archive/v${PV}.tar.gz \
-> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"

show_codename_docs() {
	einfo
	einfo "Details about codenames can be found at"
	einfo
	einfo "Radeon Pro:  https://en.wikipedia.org/wiki/Radeon_Pro"
	einfo "Radeon RX Vega:  https://en.wikipedia.org/wiki/Radeon_RX_Vega_series"
	einfo "Radeon RX 5xx:  https://en.wikipedia.org/wiki/Radeon_RX_500_series"
	einfo "Radeon RX 4xx:  https://en.wikipedia.org/wiki/Radeon_RX_400_series"
	einfo "Radeon R5/R7/R9:  https://en.wikipedia.org/wiki/Radeon_Rx_300_series"
	einfo "APU: https://en.wikipedia.org/wiki/AMD_Accelerated_Processing_Unit"
	einfo "Device IDs <-> codename: https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/blob/roc-3.3.0/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c#L777"
	einfo
}

show_notice_pcie3_atomics_required() {
	# See https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/blob/roc-3.3.0/drivers/gpu/drm/amd/amdkfd/kfd_device.c
	# https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/blob/master/runtime/device/rocm/rocdevice.cpp
	# Device should be supported end-to-end from kfd to runtime.
	ewarn
	ewarn "Detected no PCIe atomics."
	ewarn
	ewarn "ROCm OpenCL requires PCIe atomics for the following:"
	ewarn "raven"
	ewarn "fiji"
	ewarn "polaris10"
	ewarn "polaris11"
	ewarn "polaris12"
	einfo
	einfo "If your device matches one of the codenames above, use the"
	einfo "opencl_orca (for polaris 10, polaris 11, polaris 12, fiji) or"
	einfo "opencl_pal (for raven) USE flag instead or upgrade CPU and"
	einfo "Mobo combo with both PCIe 3.0 support, or upgrade to one of"
	einfo "the GPUs in the list following immediately."
	einfo
	einfo "In addition, your kernel config must have CONFIG_HSA_AMD=y."
	einfo
	einfo
	einfo "You may ignore if your device is the following:"
	einfo "kaveri"
	einfo "carrizo"
	einfo "hawaii"
	einfo "vega10"
	einfo "vega20"
	einfo "renoir"
	einfo "navi10"
	einfo "navi12"
	einfo "navi14"
	einfo
	einfo "Not supported for ROCm:"
	ewarn "tonga (PCIe atomics required, don't work on ROCm)"
	ewarn "vegam (PCIe atomics required, may work on ROCm)"
	ewarn "iceland"
	ewarn "vega12 (no PCIE atomics required)"
	einfo
	einfo "Try opencl_orca for tonga, vegam, iceland."
	einfo "Try opencl_pal for vega12."
	einfo
	einfo "If ROCm OpenCL doesn't work, stick to either opencl_pal"
	einfo "opencl_orca."
	einfo
	show_codename_docs
}

show_notice_pal_support() {
	# Vega 10 is in the GFX_v9 set
	# Navi 10 is GFX_v10
	einfo
	einfo "opencl_pal is only supported for GFX_v9 and the following:"
	einfo "vega10"
	einfo "vega12"
	einfo "vega20"
	einfo "renoir"
	einfo "navi10"
	einfo "raven"
	einfo
	einfo "If your device does not match one of the codenames above, use"
	einfo "the opencl_rocm if CPU and Mobo both have PCIe 3.0 support;"
	einfo "otherwise, try opencl_orca."
	einfo
	show_codename_docs
}

pkg_setup() {
	if has network-sandbox $FEATURES ; then
		die \
"${PN} requires network-sandbox to be disabled in FEATURES."
	fi

	if use opencl_rocm ; then
		# No die checks for this kernel config in dev-libs/rocm-opencl-runtime.
		CONFIG_CHECK="HSA_AMD"
		ERROR_HSA_AMD=\
"Change CONFIG_HSA_AMD=y in kernel config.  It's required for opencl_rocm support."
		linux-info_pkg_setup
		if dmesg | grep kfd | grep "PCI rejects atomics" 2>/dev/null 1>/dev/null ; then
			show_notice_pcie3_atomics_required
		elif dmesg | grep -e '\[drm\] PCIE atomic ops is not supported' 2>/dev/null 1>/dev/null ; then
			show_notice_pcie3_atomics_required
		fi
	fi

	if use opencl_pal ; then
		CONFIG_CHECK="HSA_AMD"
		WARNING_HSA_AMD=\
"Change CONFIG_HSA_AMD=y kernel config.  It may be required for opencl_pal support for pre-Vega 10."
		linux-info_pkg_setup
		if dmesg | grep kfd | grep "PCI rejects atomics" 2>/dev/null 1>/dev/null ; then
			show_notice_pal_support
		elif dmesg | grep -e '\[drm\] PCIE atomic ops is not supported' 2>/dev/null 1>/dev/null ; then
			show_notice_pal_support
		fi
	fi
}


src_prepare() {
	default
	if use opencl ; then
		sed -i -e "s|os instanceof Windows|true|" \
			src/com/sheepit/client/hardware/gpu/GPU.java || die
	fi
}

src_compile() {
	# Prevents: Could not open terminal for stdout: could not get termcap entry
	export TERM=linux # pretend to be outside of X

	chmod +x gradlew
	./gradlew shadowJar
}

src_install() {
	insinto /usr/share/${PN}
	doins build/libs/sheepit-client-all.jar
	exeinto /usr/bin
	doexe "${FILESDIR}/sheepit-client"
}

pkg_postinst() {
	if [[ -d "${EROOT}/tmp/sheepit_binary_cache" ]] ; then
		ewarn "Found ${EROOT}/tmp/sheepit_binary_cache.  Removing it."
		rm -rf "${EROOT}/tmp/sheepit_binary_cache"
	fi
	einfo \
"You need an account from https://www.sheepit-renderfarm.com/ to use this \n\
product."
        elog \
"If you are using dwm or non-parenting window manager and see\n\
no buttons or input boxes, you need to:\n\
  emerge wmname\n\
  wmname LG3D\n\
Run 'wmname LG3D' before you run '${PN}'"
	if use opencl ; then
		ewarn "OpenCL support is not officially supported for Linux."
		ewarn "For details see, https://github.com/laurent-clouet/sheepit-client/issues/165"
	fi
}
