# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION='Client for the free and distributed render farm "SheepIt Render Farm"'
HOMEPAGE="https://github.com/laurent-clouet/sheepit-client"
LICENSE="GPL-2 Apache-2.0 LGPL-2.1+
blender? (
	Apache-2.0
	BitstreamVera
	Boost-1.0
	BSD
	BSD-2
	CC0-1.0
	GPL-2
	GPL-2-with-font-exception
	LGPL-2.1+
	GPL-3
	GPL-3-with-font-exception
	MIT
	MIT all-rights-reserved
	PSF-2
	PSF-2.4
	SGI-B-1.1
	SGI-B-2.0
)
blender282? (
	MIT
	LGPL-2.1
	LGPL-2.1+
	WTFPL-2
)
blender281a? (
	MIT
	LGPL-2.1
	LGPL-2.1+
	WTFPL-2
)
"
#
# About the sheepit-client licenses
#
#   The licenses in the first line of the LICENSE field are those that were
#   found in sheepit-client sources.
#
#
# Third Party Licenses
#
#   The licenses in the blender section of the LICENSE variable
#   are licenses files and references in readmes in Blender 2.79b, 2.82, 2.83.
#
#   The GLU library references strings covered under under either
#     SGI Free Software License B, Version 1.1
#   or
#     SGI FREE SOFTWARE LICENSE B (Version 2.0, Sept. 18, 2008).
#
#   The Mesa library has MIT license with all rights reserved as default.
#   There is no all rights reserved in the vanilla MIT license.  Parts of it
#   contains strings sourced from SGI-B-2.0 licensed files.
#
#   The libglapi is under SGI-B-2.0.  It was bundled in precompiled Blender
#   2.80+.
#
# Additional Third Party Licenses (in SheepIt's Blender 2.82)
#
#   The libcaca library is under WTFPL-2.
#
#   The libfusion-1.2.so.9 library contains LGPL-2.1+ strings.
#
#   The libSDL [1.2.14_pre20091018] library was made
#   available under LGPL-2.1+ in Jan 30, 2006.
#
#   The libXxf86vm is under MIT.
#
#   The tslib is under LGPL-2.1.
#
#
# Uncaught license corrections:
#
#   In LICENSE-droidsans.ttf.txt at line 49 in Blender 2.82, it mentions
#   GPL-2.1+.  It should be LGPL-2.1+.
#
KEYWORDS="~amd64"
SLOT="0"

IUSE=" \
blender \
blender279b blender279b_filmic blender280 blender281a blender282 \
blender2831 blender2831-benchmark blender2832 \
allow-unknown-renderers disable-hard-version-blocks \
cuda doc intel-ocl lts +opencl opencl_rocm opencl_orca \
opencl_pal opengl_mesa pro-drivers split-drivers \
renderer-version-picker \
video_cards_amdgpu video_cards_i965 video_cards_iris video_cards_nvidia \
video_cards_radeonsi"
REQUIRED_USE="
	allow-unknown-renderers? ( blender )
	blender279b? ( blender )
	blender279b_filmic? ( blender )
	blender280? ( blender )
	blender281a? ( blender )
	blender282? ( blender )
	blender2831? ( blender )
	blender2831-benchmark? ( blender ) blender2831-benchmark
	blender2832? ( blender )
	|| ( cuda opencl )
	|| ( blender279b blender279b_filmic blender280 blender281a blender282
		allow-unknown-renderers )
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
# This maybe required for filmic
# todo inspect via ldd
RDEPEND_BLENDER_SHEEPIT_OIIO="
media-libs/openimageio
"

# About the lib folder
# 2.79, 2.80 contains glu libglapi, mesa
# 2.82 contains DirectFB, libcaca, libglapi, glu, mesa, slang, SDL:1.2, tslib, libXxf86vm

# Additional libraries referenced in the custom build of 2.82
RDEPEND_BLENDER_SHEEPIT282="
sys-apps/dbus
sys-apps/util-linux
media-libs/alsa-lib
media-libs/flac
media-libs/libogg
media-libs/libsndfile
media-libs/libvorbis
media-libs/opus
media-sound/pulseaudio
net-libs/libasyncns
sys-apps/tcp-wrappers
sys-libs/ncurses-compat[tinfo]
sys-libs/slang
x11-libs/libICE
x11-libs/libSM
x11-libs/libXtst
"

# For vanilla Blender 2.79-2.83.1
RDEPEND_BLENDER="
	dev-libs/expat
	sys-libs/glibc
	dev-libs/libbsd
	media-libs/mesa
	sys-devel/gcc[cxx]
	sys-libs/zlib
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrender
	x11-libs/libXxf86vm
	x11-libs/libxcb
	x11-libs/libxshmfence
"

RDEPEND="blender? (
		${RDEPEND_BLENDER}
		${RDEPEND_BLENDER_SHEEPIT_OIIO}
		blender282? ( ${RDEPEND_BLENDER_SHEEPIT282} )
	)
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

enable_hardblock() {
	sed -i -e "s|public static final boolean ${1} = false;|public static final boolean ${1} = true;|g" \
		src/com/sheepit/client/Configuration.java || die
}

disable_hardblock() {
	sed -i -e "s|public static final boolean ${1} = true;|public static final boolean ${1} = false;|g" \
		src/com/sheepit/client/Configuration.java || die
}

src_prepare() {
	ewarn
	ewarn "Security notices:"
	ewarn
	ewarn "${PN} downloads Blender 2.79 with Python 3.5.3 having critical security CVE advisories"
	ewarn "${PN} downloads Blender 2.80 with Python 3.7.0 having high security CVE advisory"
	ewarn "${PN} downloads Blender 2.81a with Python 3.7.4 having high security CVE advisory"
	ewarn "${PN} downloads Blender 2.82 with Python 3.7.4 having high security CVE advisory"
	ewarn "${PN} downloads Blender 2.83.1 with Python 3.7.4 having high security CVE advisory"
	ewarn "${PN} downloads Blender 2.83.2 with Python 3.7.4 having high security CVE advisory"
	ewarn "https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=python%203.5&search_type=all"
	ewarn "https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=python%203.7&search_type=all"
	ewarn
	ewarn "${PN} downloads repackaged Blender 2.81a with DirectFB 1.2.10."
	ewarn "https://security.gentoo.org/glsa/201701-55"
	ewarn
	ewarn "${PN} downloads repackaged Blender 2.82 with DirectFB 1.2.10."
	ewarn "https://security.gentoo.org/glsa/201701-55"
	ewarn
	ewarn "${PN} downloads Blender 2.81a with SDL 1.2.14_pre20091018."
	ewarn "https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=sdl%201.2&search_type=all"
	ewarn
	ewarn "${PN} downloads Blender 2.82 with SDL 1.2.14_pre20091018."
	ewarn "https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=sdl%201.2&search_type=all"
	ewarn

	default
	if use opencl ; then
		sed -i -e "s|os instanceof Windows|true|" \
			src/com/sheepit/client/hardware/gpu/GPU.java || die
	fi

	eapply "${FILESDIR}/sheepit-client-6.2020.0-r1-renderer-version-picker.patch"
	if ! use allow-unknown-renderers ; then
		if ! use disable-hard-version-blocks ; then
			enable_hardblock "HARDBLOCK_UNKNOWN_RENDERERS"
		fi
	fi
	if ! use blender279b ; then
		if ! use disable-hard-version-blocks ; then
			enable_hardblock "HARDBLOCK_BLENDER_279B"
		fi
	fi
	if ! use blender279b_filmic ; then
		if ! use disable-hard-version-blocks ; then
			enable_hardblock "HARDBLOCK_BLENDER_279B_FILMIC"
		fi
	fi
	if ! use blender280 ; then
		if ! use disable-hard-version-blocks ; then
			enable_hardblock "HARDBLOCK_BLENDER_280"
		fi
	fi
	if ! use blender281a ; then
		if ! use disable-hard-version-blocks ; then
			enable_hardblock "HARDBLOCK_BLENDER_281A"
		fi
	fi
	if ! use blender282 ; then
		if ! use disable-hard-version-blocks ; then
			enable_hardblock "HARDBLOCK_BLENDER_282"
		fi
	fi
	if ! use blender2831 ; then
		if ! use disable-hard-version-blocks ; then
			enable_hardblock "HARDBLOCK_BLENDER_2831"
		fi
	fi
	if ! use blender2832 ; then
		if ! use disable-hard-version-blocks ; then
			enable_hardblock "HARDBLOCK_BLENDER_2832"
		fi
	fi
}

src_compile() {
	# Prevents: Could not open terminal for stdout: could not get termcap entry
	export TERM=linux # pretend to be outside of X

	chmod +x gradlew
	./gradlew shadowJar || die
}

src_install() {
	insinto /usr/share/${PN}
	doins build/libs/sheepit-client-all.jar
	exeinto /usr/bin
	cat "${FILESDIR}/sheepit-client-v2.1.6" \
		> "${T}/sheepit-client" || die
	docinto licenses
	dodoc LICENSE
	local allowed_renderers=""
	if use blender279b ; then
		dodoc -r "${FILESDIR}/blender-2.79b-licenses"
		use doc \
		dodoc -r "${FILESDIR}/blender-2.79b-readmes"
		allowed_renderers+=" --allow-blender279b"
	fi
	if use blender279b_filmic ; then
		dodoc -r "${FILESDIR}/blender-2.79b-licenses"
		use doc \
		dodoc -r "${FILESDIR}/blender-2.79b-readmes"
		allowed_renderers+=" --allow-blender279b-filmic"
	fi
	if use blender280 ; then
		dodoc -r "${FILESDIR}/blender-2.80-licenses"
		use doc \
		dodoc -r "${FILESDIR}/blender-2.80-readmes"
		allowed_renderers+=" --allow-blender280"
	fi
	if use blender281a ; then
		dodoc -r "${FILESDIR}/blender-2.81a-licenses"
		use doc \
		dodoc -r "${FILESDIR}/blender-2.81a-readmes"
		allowed_renderers+=" --allow-blender281a"
	fi
	if use blender282 ; then
		dodoc -r "${FILESDIR}/blender-2.82-licenses"
		use doc \
		dodoc -r "${FILESDIR}/blender-2.82-readmes"
		allowed_renderers+=" --allow-blender282"
	fi
	if use blender2831-benchmark ; then
		dodoc -r "${FILESDIR}/blender-2.83.1-licenses"
		use doc \
		dodoc -r "${FILESDIR}/blender-2.83.1-readmes"
	fi
	if use blender2831 ; then
		dodoc -r "${FILESDIR}/blender-2.83.1-licenses"
		use doc \
		dodoc -r "${FILESDIR}/blender-2.83.1-readmes"
		allowed_renderers+=" --allow-blender2831"
	fi
	if use blender2832 ; then
		dodoc -r "${FILESDIR}/blender-2.83.2-licenses"
		use doc \
		dodoc -r "${FILESDIR}/blender-2.83.2-readmes"
		allowed_renderers+=" --allow-blender2832"
	fi
	if use allow-unknown-renderers ; then
		allowed_renderers+=" --allow-unknown-renderers"
	fi
	if use doc ; then
		docinto docs
		dodoc protocol.txt README.md
	fi
	sed -i -e "s|ALLOWED_RENDERERS|${allowed_renderers}|g" \
		"${T}/sheepit-client" || die
	doexe "${T}/sheepit-client"
}

pkg_postinst() {
	einfo
	einfo \
"You need an account from https://www.sheepit-renderfarm.com/ to use this \n\
product."
	einfo
        elog \
"If you are using dwm or non-parenting window manager and see\n\
no buttons or input boxes, you need to:\n\
  emerge wmname\n\
  wmname LG3D\n\
Run 'wmname LG3D' before you run '${PN}'"
	einfo
	if use opencl ; then
		ewarn "OpenCL support is not officially supported for Linux."
		ewarn "For details see, https://github.com/laurent-clouet/sheepit-client/issues/165"
	fi
	einfo
	einfo "Don't forget to add your user account to the video group."
	einfo "This can be done with: \`gpasswd -a USERNAME video\`"
	einfo
}
