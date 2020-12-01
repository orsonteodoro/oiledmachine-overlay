# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION='Client for the free and distributed render farm "SheepIt Render Farm"'
HOMEPAGE="https://github.com/laurent-clouet/sheepit-client"
LICENSE="GPL-2 Apache-2.0 LGPL-2.1+
!system-blender? (
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
	!no-repacks? (
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
	)
	blender279b_filmic? (
		all-rights-reserved
	)
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
#   No license stated or declared copyright in the filmic-blender project
#   or in any of the files.  For commentary about licensing numbers by
#   the owner of the filmic-blender project, see:
#
#     https://github.com/sobotka/filmic-blender/pull/29#issuecomment-502137400
#
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

IUSE=" +benchmark blender blender279b blender279b_filmic blender280 \
blender281a blender282 blender2831 blender2831 blender2832 blender2836 \
blender2839 blender2900 blender2901 blender2910 allow-unknown-renderers \
disable-hard-version-blocks cuda doc firejail intel-ocl lts +opencl \
opencl_rocm opencl_orca opencl_pal opengl_mesa pro-drivers split-drivers \
system-blender gentoo-blender no-repacks video_cards_amdgpu video_cards_i965 \
video_cards_iris video_cards_nvidia video_cards_radeonsi"
REQUIRED_USE="
	allow-unknown-renderers? ( blender !system-blender )
	benchmark
	benchmark? ( blender blender2901 )
	blender? ( || ( blender279b blender279b_filmic blender280 blender281a
			blender282 blender2831 blender2832 blender2836 blender2900
			blender2901
			allow-unknown-renderers ) )
	blender279b? ( blender )
	blender279b_filmic? ( blender )
	blender280? ( blender )
	blender281a? ( blender )
	blender282? ( blender )
	blender2831? ( blender )
	blender2832? ( blender )
	blender2836? ( blender )
	blender2900? ( blender )
	blender2901? ( blender )
	|| ( cuda opencl )
	no-repacks? ( !allow-unknown-renderers !system-blender )
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
	system-blender? ( !allow-unknown-renderers !no-repacks )
	video_cards_amdgpu? (
		|| ( pro-drivers split-drivers )
	)
"

# About the lib folder
# 2.79, 2.80 contains glu libglapi, mesa
# 2.82, 2.81a contains DirectFB, libcaca, libglapi, glu, mesa, slang, SDL:1.2, tslib, libXxf86vm

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

# Due to the many different Blender project requirements, the release config
# flags will be used to match especially those that affect the rendering.
#
# If you use the gentoo-overlay ebuilds, you must match exactly the benchmark
# version of Blender in order to progress to render other projects.  This
# may require to maintain your own version on your local repository.
RDEPEND="
	blender? (
		firejail? ( sys-apps/firejail )
		!system-blender? (
			${RDEPEND_BLENDER}
			blender281a? ( !no-repacks? ( ${RDEPEND_BLENDER_SHEEPIT282} ) )
			blender282? ( !no-repacks? ( ${RDEPEND_BLENDER_SHEEPIT282} ) )
		)
		system-blender? (
			gentoo-blender? (
				blender2836? (
					~media-gfx/blender-2.83.9[bullet,collada,color-management,cycles,dds,-debug,elbeem,fftw,-headless,nls,openexr,openimagedenoise,openimageio,opensubdiv,openvdb,openxr,osl,tiff]
					sci-physics/bullet
				)
				blender2901? (
					~media-gfx/blender-2.90.1[bullet,collada,color-management,cycles,dds,-debug,elbeem,embree,fftw,-headless,nls,openexr,openimagedenoise,openimageio,opensubdiv,openvdb,openxr,osl,tiff]
					media-libs/embree[raymask]
					sci-physics/bullet
				)
			)
			!gentoo-blender? (
				blender279b? ( ~media-gfx/blender-2.79b[cycles,build_creator(+),release(+)] )
				blender279b_filmic? (
					~media-gfx/blender-2.79b[cycles,build_creator(+),release(+)]
					media-plugins/filmic-blender:sheepit
				)
				blender280? ( ~media-gfx/blender-2.80[cycles,build_creator(+),release(+)] )
				blender281a? ( ~media-gfx/blender-2.81a[cycles,build_creator(+),release(+)] )
				blender282? ( ~media-gfx/blender-2.82[cycles,build_creator(+),release(+)] )
				blender2831? ( ~media-gfx/blender-2.83.1[cycles,build_creator(+),release(+)] )
				blender2832? ( ~media-gfx/blender-2.83.2[cycles,build_creator(+),release(+)] )
				blender2836? ( ~media-gfx/blender-2.83.6[cycles,build_creator(+),release(+)] )
				blender2900? ( ~media-gfx/blender-2.90.0[cycles,build_creator(+),release(+)] )
				blender2901? ( ~media-gfx/blender-2.90.1[cycles,build_creator(+),release(+)] )
				blender2910? ( ~media-gfx/blender-2.91.0[cycles,build_creator(+),release(+)] )
			)
		)
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
	no-repacks? (
		app-arch/bzip2
		app-arch/gzip
		app-arch/tar
		app-arch/xz-utils
	)
	virtual/jre:1.8"
DEPEND="${RDEPEND}
	dev-java/gradle-bin
	virtual/jdk:1.8"
inherit linux-info
SRC_URI="https://gitlab.com/sheepitrenderfarm/client/-/archive/v${PV}/client-v${PV}.tar.bz2 \
-> ${PN}-${PV}.tar.bz2"
S="${WORKDIR}/client-v${PV}"
RESTRICT="mirror"
WRAPPER_VERSION="3.0.0" # .sh file
GRADLE_V="6.3" # ~Mar 2020
EXPECTED_GRADLE_WRAPPER_JAR_SHA256=\
"1cef53de8dc192036e7b0cc47584449b0cf570a00d560bfaa6c9eabe06e1fc06"
# For the Wrapper JAR Checksum, see also
# https://gradle.org/release-checksums/

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

gbewarn() {
	local pv="${1}"
	ewarn "Blender ${pv} is not supported with the gentoo-blender USE flag"
}

check_embree() {
	# For the configuration, see
# https://github.com/blender/blender/blob/v2.90.1/build_files/build_environment/cmake/embree.cmake

	# There is no standard embree ebuild.  Assume other repo or local copy.

	# This check is ensure that the rendering quality is the same and the output
	# is the same especially if the animated movies are split.

	if has embree ${IUSE_EFFECTIVE} && use embree ; then
		# The default for EMBREE_FILTER_FUNCTION is ON in embree.
		if grep -q -F -e "EMBREE_FILTER_FUNCTION=OFF" \
			"${EROOT}/var/db/pkg/media-libs/embree-"*/*.ebuild ; then
			die "EMBREE_FILTER_FUNCTION should be set to ON for embree."
		else
			if has_version 'media-libs/embree[-filter_function]' || \
				has_version 'media-libs/embree[-filter-function]' || \
				has_version 'media-libs/embree[-filterfunction]' ; then
				die "EMBREE_FILTER_FUNCTION should be set to ON for embree."
			fi
		fi

		# The default for EMBREE_BACKFACE_CULLING is OFF in embree.
		if grep -q -F -e "EMBREE_BACKFACE_CULLING=ON" \
			"${EROOT}/var/db/pkg/media-libs/embree-"*/*.ebuild ; then
			die "EMBREE_BACKFACE_CULLING should be set to OFF for embree."
		else
			if has_version 'media-libs/embree[backface_culling]' || \
				has_version 'media-libs/embree[backface-culling]' || \
				has_version 'media-libs/embree[backfaceculling]' ; then
				die "EMBREE_BACKFACE_CULLING should be set to OFF for embree."
			fi
		fi

		# The default for EMBREE_RAY_MASK is OFF in embree.
		if grep -q -F -e "EMBREE_RAY_MASK=OFF" \
			"${EROOT}/var/db/pkg/media-libs/embree-"*/*.ebuild ; then
			die "EMBREE_RAY_MASK should be set to ON for embree."
		else
			if has_version 'media-libs/embree[-ray_mask]' || \
				has_version 'media-libs/embree[-ray-mask]' || \
				has_version 'media-libs/embree[-raymask]' ; then
				die "EMBREE_RAY_MASK should be set to ON for embree."
			elif has_version 'media-libs/embree[ray_mask]' || \
				has_version 'media-libs/embree[ray-mask]' || \
				has_version 'media-libs/embree[raymask]' ; then
				:;
			elif has_version 'media-libs/embree' ; then
				die "EMBREE_RAY_MASK should be set to ON for embree."
			fi
		fi
	fi
}

pkg_setup() {
	if use gentoo-blender ; then
		use blender279b_filmic && gbewarn "2.79b_filmic"
		use blender280 && gbewarn "2.80"
		use blender281a && gbewarn "2.81a"
		use blender282 && gbewarn "2.82"
		use blender2831 && gbewarn "2.83.1"
		use blender2832 && gbewarn "2.83.2"
		use blender2900 && gbewarn "2.90.0"
	fi

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

	if use blender ; then
		grep -q -i -E -e 'sse2( |$)' /proc/cpuinfo # 2000
		local has_sse2="$?"

		if [[ "${has_sse2}" != "0" ]] ; then
			die "Blender requires sse2 on your CPU."
		fi

		if (( $(nproc) < 2 )) ; then
			ewarn "Blender requires a dual core CPU."
		fi

		if use system-blender ; then
			check_embree
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
	X_GRADLE_WRAPPER_JAR_SHA256=$(sha256sum \
		"${S}/gradle/wrapper/gradle-wrapper.jar" \
		| cut -f 1 -d " ")
	if [[ "${X_GRADLE_WRAPPER_JAR_SHA256}" \
		!= "${EXPECTED_GRADLE_WRAPPER_JAR_SHA256}" ]] ; then
		die \
"X_GRADLE_WRAPPER_JAR_SHA256=${X_GRADLE_WRAPPER_JAR_SHA256} \
EXPECTED_GRADLE_WRAPPER_JAR_SHA256=${EXPECTED_GRADLE_WRAPPER_JAR_SHA256} \
wrong checksum"
	fi

	if ! use system-blender ; then
		ewarn
		ewarn "Security notices:"
		ewarn
		ewarn "${PN} downloads Blender 2.79 with Python 3.5.3 having critical security CVE advisories"
		ewarn "${PN} downloads Blender 2.80 with Python 3.7.0 having high security CVE advisory"
		ewarn "${PN} downloads Blender 2.81a with Python 3.7.4 having high security CVE advisory"
		ewarn "${PN} downloads Blender 2.82 with Python 3.7.4 having high security CVE advisory"
		ewarn "${PN} downloads Blender 2.83.1 with Python 3.7.4 having high security CVE advisory"
		ewarn "${PN} downloads Blender 2.83.2 with Python 3.7.4 having high security CVE advisory"
		ewarn "${PN} downloads Blender 2.90.0 with Python 3.7.7 having high security CVE advisory"
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
	fi

	default
	if use opencl ; then
		sed -i -e "s|os instanceof Windows|true|" \
			src/com/sheepit/client/hardware/gpu/GPU.java || die
	fi

	eapply "${FILESDIR}/sheepit-client-6.20304.0-r1-renderer-version-picker.patch"

	if use system-blender ; then
		if use gentoo-blender ; then
			sed -i -e "s|oiledmachine-overlay|gentoo-overlay|g" \
				src/com/sheepit/client/Configuration.java || die
		elif bzcat /var/db/pkg/media-gfx/blender-*/environment.bz2 \
			| grep -q -F -e "parent-datafiles-dir-change" ; then
			:;
		else
			die \
"Use either gentoo-blender or the blender ebuilds from the oiledmachine-overlay"
		fi
	fi

	if ! use system-blender ; then
		sed -i -e "s|USE_SYSTEM_RENDERERS = true|USE_SYSTEM_RENDERERS = false|g" \
			src/com/sheepit/client/Configuration.java || die
	fi

	if use no-repacks ; then
		sed -i -e "s|USE_ONLY_DOWNLOAD_DOT_BLENDER_DOT_ORG = false|USE_ONLY_DOWNLOAD_DOT_BLENDER_DOT_ORG = true|g" \
			src/com/sheepit/client/Configuration.java || die
	fi

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
	if ! use blender2836 ; then
		if ! use disable-hard-version-blocks ; then
			enable_hardblock "HARDBLOCK_BLENDER_2836"
		fi
	fi
	if ! use blender2839 ; then
		if ! use disable-hard-version-blocks ; then
			enable_hardblock "HARDBLOCK_BLENDER_2839"
		fi
	fi
	if ! use blender2900 ; then
		if ! use disable-hard-version-blocks ; then
			enable_hardblock "HARDBLOCK_BLENDER_2900"
		fi
	fi
	if ! use blender2901 ; then
		if ! use disable-hard-version-blocks ; then
			enable_hardblock "HARDBLOCK_BLENDER_2901"
		fi
	fi
	if ! use blender2910 ; then
		if ! use disable-hard-version-blocks ; then
			enable_hardblock "HARDBLOCK_BLENDER_2910"
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
	cat "${FILESDIR}/sheepit-client-v${WRAPPER_VERSION}" \
		> "${T}/sheepit-client" || die
	docinto licenses
	dodoc LICENSE
	local allowed_renderers=""
	if use blender279b ; then
		if ! use system-blender ; then
			dodoc -r "${FILESDIR}/blender-2.79b-licenses"
			use doc \
			dodoc -r "${FILESDIR}/blender-2.79b-readmes"
		fi
		allowed_renderers+=" --allow-blender279b"
	fi
	if use blender279b_filmic ; then
		if ! use system-blender ; then
			dodoc -r "${FILESDIR}/blender-2.79b-licenses"
			use doc \
			dodoc -r "${FILESDIR}/blender-2.79b-readmes"
		fi
		allowed_renderers+=" --allow-blender279b-filmic"
	fi
	if use blender280 ; then
		if ! use system-blender ; then
			dodoc -r "${FILESDIR}/blender-2.80-licenses"
			use doc \
			dodoc -r "${FILESDIR}/blender-2.80-readmes"
		fi
		allowed_renderers+=" --allow-blender280"
	fi
	if use blender281a ; then
		if ! use system-blender ; then
			dodoc -r "${FILESDIR}/blender-2.81a-licenses"
			use doc \
			dodoc -r "${FILESDIR}/blender-2.81a-readmes"
		fi
		allowed_renderers+=" --allow-blender281a"
	fi
	if use blender282 ; then
		if ! use system-blender ; then
			dodoc -r "${FILESDIR}/blender-2.82-licenses"
			use doc \
			dodoc -r "${FILESDIR}/blender-2.82-readmes"
		fi
		allowed_renderers+=" --allow-blender282"
	fi
	if use blender2831 ; then
		if ! use system-blender ; then
			dodoc -r "${FILESDIR}/blender-2.83.1-licenses"
			use doc \
			dodoc -r "${FILESDIR}/blender-2.83.1-readmes"
		fi
		allowed_renderers+=" --allow-blender2831"
	fi
	if use blender2832 ; then
		if ! use system-blender ; then
			dodoc -r "${FILESDIR}/blender-2.83.2-licenses"
			use doc \
			dodoc -r "${FILESDIR}/blender-2.83.2-readmes"
		fi
		allowed_renderers+=" --allow-blender2832"
	fi
	if use blender2836 ; then
		if ! use system-blender ; then
			dodoc -r "${FILESDIR}/blender-2.83.6-licenses"
			use doc \
			dodoc -r "${FILESDIR}/blender-2.83.6-readmes"
		fi
		allowed_renderers+=" --allow-blender2836"
	fi
	if use blender2839 ; then
		if ! use system-blender ; then
			dodoc -r "${FILESDIR}/blender-2.83.9-licenses"
			use doc \
			dodoc -r "${FILESDIR}/blender-2.83.9-readmes"
		fi
		allowed_renderers+=" --allow-blender2839"
	fi
	if use blender2900 ; then
		if ! use system-blender ; then
			dodoc -r "${FILESDIR}/blender-2.90.0-licenses"
			use doc \
			dodoc -r "${FILESDIR}/blender-2.90.0-readmes"
		fi
		allowed_renderers+=" --allow-blender2900"
	fi
	if use blender2901 ; then
		if ! use system-blender ; then
			dodoc -r "${FILESDIR}/blender-2.90.1-licenses"
			use doc \
			dodoc -r "${FILESDIR}/blender-2.90.1-readmes"
		fi
		allowed_renderers+=" --allow-blender2901"
	fi
	if use blender2910 ; then
		if ! use system-blender ; then
			dodoc -r "${FILESDIR}/blender-2.91.0-licenses"
			use doc \
			dodoc -r "${FILESDIR}/blender-2.91.0-readmes"
		fi
		allowed_renderers+=" --allow-blender2910"
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

	if use system-blender ; then
		sed -i -e "s|^#USE_SYSTEM_BLENDER|USE_SYSTEM_BLENDER|g" \
		"${T}/sheepit-client" || die
	fi

	# Work In Progress (WIP)
	if use firejail ; then
		sed -i -e "s|^#USE_FIREJAIL|USE_FIREJAIL|g" \
		"${T}/sheepit-client" || die

		insinto /etc/firejail
		if use system-blender ; then
			newins "${FILESDIR}/firejail-profiles/sheepit-client-system-blender.profile" \
				"sheepit-client.profile"
		else
			if use no-repacks ; then
				newins "${FILESDIR}/firejail-profiles/sheepit-client-no-repacks.profile" \
					"sheepit-client.profile"
			else
				newins "${FILESDIR}/firejail-profiles/sheepit-client-default.profile" \
					"sheepit-client.profile"

			fi
		fi
	fi

	doexe "${T}/sheepit-client"
}

pkg_postinst() {
	einfo
	einfo \
"You need an account from https://www.sheepit-renderfarm.com/ to use this \n\
product."
	einfo
	# This applies to the GUI part.
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
	einfo
	einfo "Don't forget to add your user account to the video group."
	einfo "This can be done with: \`gpasswd -a USERNAME video\`"
	einfo

	if use firejail ; then
		ewarn \
"The Firejail profile is experimental.  Several updates may occur to improve \n\
the privacy within the sandboxed image and reduce the attack surface.  Also, \n\
updates may occur to fix errors between different configurations."
		einfo \
"The Firejail profile requires additional rules for your JRE and video card \n\
drivers.  Add them to /etc/firejail/sheepit-client.local.  Use ldd on the\n\
shared libraries and drivers to add more private-lib or whitelist rules."
	fi
}
