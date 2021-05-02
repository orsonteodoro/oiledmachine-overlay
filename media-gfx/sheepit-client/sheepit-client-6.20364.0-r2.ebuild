# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-utils-2 linux-info

DESCRIPTION='Client for the free and distributed render farm "SheepIt Render Farm"'
HOMEPAGE="https://github.com/laurent-clouet/sheepit-client"
LICENSE="GPL-2 Apache-2.0 LGPL-2.1+
MIT
|| ( CDDL GPL-2-with-classpath-exception )
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
		sheepit_client_blender_2_82? (
			MIT
			LGPL-2.1
			LGPL-2.1+
			WTFPL-2
		)
		sheepit_client_blender_2_81a? (
			MIT
			LGPL-2.1
			LGPL-2.1+
			WTFPL-2
		)
	)
	sheepit_client_blender_2_79b_filmic? (
		all-rights-reserved
	)
)"

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
# Build time licenses:
#
#   gradle is Apache-2.0
#   The various third-party jars are either MIT, Apache-2.0, \
#     or || ( CDDL GPL-2-with-classpath-exception )
#
# Uncaught license corrections:
#
#   In LICENSE-droidsans.ttf.txt at line 49 in Blender 2.82, it mentions
#   GPL-2.1+.  It should be LGPL-2.1+.
#
KEYWORDS="~amd64"
SLOT="0"

BLENDER_VERSIONS=(
	2_79b
	2_79b_filmic
	2_80
	2_81a
	2_82
	2_83_9
	2_90_1
	2_91_0
	2_92_0
)

IUSE=" +benchmark blender allow-unknown-renderers
disable-hard-version-blocks cuda doc firejail intel-ocl lts +opencl
opencl_rocm opencl_orca opencl_pal opengl_mesa pro-drivers split-drivers
system-blender gentoo-blender no-repacks video_cards_amdgpu video_cards_i965
video_cards_iris video_cards_nvidia video_cards_radeonsi"
IUSE_BLENDER_VERSIONS=( ${BLENDER_VERSIONS[@]/#/sheepit_client_blender_} )
IUSE+=" ${IUSE_BLENDER_VERSIONS[@]}"

gen_required_use_blender()
{
	local version="${1}"
	local o=""
	for x in ${IUSE_BLENDER_VERSIONS[@]} ; do
		o+=" ${x}? ( blender )"
	done
	echo "${o}"
}

REQUIRED_USE+=" "$(gen_required_use_blender)
REQUIRED_USE+="
	allow-unknown-renderers? ( blender !system-blender )
	benchmark
	benchmark? ( blender sheepit_client_blender_2_90_1 )
	blender? ( || ( ${IUSE_BLENDER_VERSIONS[@]}
			allow-unknown-renderers ) )
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
# 2.82, 2.81a contains DirectFB, libcaca, libglapi, glu, mesa, slang, SDL:1.2, \
#   tslib, libXxf86vm

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
	x11-libs/libXtst"

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
	x11-libs/libxshmfence"

# Due to the many different Blender project requirements, the release config
# flags will be used to match especially those that affect the rendering.
#
# If you use the gentoo-overlay blender ebuilds, you must match exactly the
# benchmark version of Blender in order to progress to render other projects.
# This may require to maintain your own version on your local repository.  Bad
# news is that you can only use the benchmark version since there is no
# effort for multislot.

JAVA_V="1.8"
RDEPEND="
	blender? (
		firejail? ( sys-apps/firejail )
		!system-blender? (
			${RDEPEND_BLENDER}
			sheepit_client_blender_2_81a? (
				!no-repacks? ( ${RDEPEND_BLENDER_SHEEPIT282} )
			)
			sheepit_client_blender_2_82? (
				!no-repacks? ( ${RDEPEND_BLENDER_SHEEPIT282} )
			)
		)
		system-blender? (
			gentoo-blender? (
				sheepit_client_blender_2_90_1? (
~media-gfx/blender-2.90.1\
[alembic,bullet,collada,color-management,cycles,dds,-debug,elbeem,embree,fftw,\
-headless,nls,openexr,openimagedenoise,openimageio,opensubdiv,openvdb,openxr,\
osl,tiff]
					media-libs/embree[raymask]
					sci-physics/bullet
				)
				sheepit_client_blender_2_91_0? (
~media-gfx/blender-2.90.1\
[alembic,bullet,collada,color-management,cycles,dds,-debug,elbeem,embree,fftw,\
-headless,nls,openexr,openimagedenoise,openimageio,opensubdiv,openvdb,\
openxr,osl,tiff]
					media-libs/embree[raymask]
					sci-physics/bullet
				)
			)
			!gentoo-blender? (
sheepit_client_blender_2_79b? (
	~media-gfx/blender-2.79b[cycles,build_creator(+),release(+)]
)
sheepit_client_blender_2_79b_filmic? (
	~media-gfx/blender-2.79b[cycles,build_creator(+),release(+)]
	media-plugins/filmic-blender:sheepit
)
sheepit_client_blender_2_80? (
	~media-gfx/blender-2.80[cycles,build_creator(+),release(+)]
)
sheepit_client_blender_2_81a? (
	~media-gfx/blender-2.81a[cycles,build_creator(+),release(+)]
)
sheepit_client_blender_2_82? (
	~media-gfx/blender-2.82[cycles,build_creator(+),release(+)]
)
sheepit_client_blender_2_83_9? (
	~media-gfx/blender-2.83.9[cycles,build_creator(+),release(+)]
)
sheepit_client_blender_2_90_1? (
	~media-gfx/blender-2.90.1[cycles,build_creator(+),release(+)]
)
sheepit_client_blender_2_91_0? (
	~media-gfx/blender-2.91.0[cycles,build_creator(+),release(+)]
)
sheepit_client_blender_2_92_0? (
	~media-gfx/blender-2.92.0[cycles,build_creator(+),release(+)]
)
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
						!lts? (
x11-drivers/amdgpu-pro\
[X,developer,open-stack,opengl_mesa,opencl,opencl_pal?,opencl_orca?]
						)
						lts? (
x11-drivers/amdgpu-pro-lts\
[X,developer,open-stack,opengl_mesa,opencl,opencl_pal?,opencl_orca?]
						)
					)
					!opengl_mesa? (
						!lts? (
x11-drivers/amdgpu-pro\
[opencl,opencl_pal?,opencl_orca?]
						)
						lts? (
x11-drivers/amdgpu-pro-lts\
[opencl,opencl_pal?,opencl_orca?]
						)
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
	>=virtual/jre-${JAVA_V}"
BDEPEND="${RDEPEND}
	dev-java/gradle-bin
	>=virtual/jdk-${JAVA_V}"

# Sorted output from gradlew
GRADLE_DOWNLOADS="
https://jcenter.bintray.com/args4j/args4j/2.33/args4j-2.33.jar
https://jcenter.bintray.com/args4j/args4j/2.33/args4j-2.33.pom
https://jcenter.bintray.com/args4j/args4j-site/2.33/args4j-site-2.33.pom
https://jcenter.bintray.com/com/formdev/flatlaf/0.30/flatlaf-0.30.jar
https://jcenter.bintray.com/com/formdev/flatlaf/0.30/flatlaf-0.30.pom
https://jcenter.bintray.com/com/github/jengelman/gradle/plugins/shadow/4.0.4/shadow-4.0.4.jar
https://jcenter.bintray.com/com/github/jengelman/gradle/plugins/shadow/4.0.4/shadow-4.0.4.pom
https://jcenter.bintray.com/com/squareup/okhttp3/okhttp/4.7.2/okhttp-4.7.2.jar
https://jcenter.bintray.com/com/squareup/okhttp3/okhttp/4.7.2/okhttp-4.7.2.pom
https://jcenter.bintray.com/com/squareup/okhttp3/okhttp-urlconnection/4.7.2/okhttp-urlconnection-4.7.2.jar
https://jcenter.bintray.com/com/squareup/okhttp3/okhttp-urlconnection/4.7.2/okhttp-urlconnection-4.7.2.pom
https://jcenter.bintray.com/com/squareup/okio/okio/2.6.0/okio-2.6.0.jar
https://jcenter.bintray.com/com/squareup/okio/okio/2.6.0/okio-2.6.0.pom
https://jcenter.bintray.com/com/sun/activation/all/1.2.0/all-1.2.0.pom
https://jcenter.bintray.com/javax/activation/javax.activation-api/1.2.0/javax.activation-api-1.2.0.jar
https://jcenter.bintray.com/javax/activation/javax.activation-api/1.2.0/javax.activation-api-1.2.0.pom
https://jcenter.bintray.com/javax/xml/bind/jaxb-api/2.3.1/jaxb-api-2.3.1.jar
https://jcenter.bintray.com/javax/xml/bind/jaxb-api/2.3.1/jaxb-api-2.3.1.pom
https://jcenter.bintray.com/javax/xml/bind/jaxb-api-parent/2.3.1/jaxb-api-parent-2.3.1.pom
https://jcenter.bintray.com/net/java/dev/jna/jna/5.0.0/jna-5.0.0.jar
https://jcenter.bintray.com/net/java/dev/jna/jna/5.0.0/jna-5.0.0.pom
https://jcenter.bintray.com/net/java/dev/jna/jna-platform/5.0.0/jna-platform-5.0.0.jar
https://jcenter.bintray.com/net/java/dev/jna/jna-platform/5.0.0/jna-platform-5.0.0.pom
https://jcenter.bintray.com/net/java/jvnet-parent/1/jvnet-parent-1.pom
https://jcenter.bintray.com/net/java/jvnet-parent/5/jvnet-parent-5.pom
https://jcenter.bintray.com/net/lingala/zip4j/zip4j/1.3.3/zip4j-1.3.3.jar
https://jcenter.bintray.com/net/lingala/zip4j/zip4j/1.3.3/zip4j-1.3.3.pom
https://jcenter.bintray.com/org/codehaus/groovy/groovy-backports-compat23/2.4.15/groovy-backports-compat23-2.4.15.jar
https://jcenter.bintray.com/org/codehaus/groovy/groovy-backports-compat23/2.4.15/groovy-backports-compat23-2.4.15.pom
https://jcenter.bintray.com/org/jetbrains/annotations/13.0/annotations-13.0.jar
https://jcenter.bintray.com/org/jetbrains/annotations/13.0/annotations-13.0.pom
https://jcenter.bintray.com/org/jetbrains/kotlin/kotlin-stdlib/1.3.71/kotlin-stdlib-1.3.71.jar
https://jcenter.bintray.com/org/jetbrains/kotlin/kotlin-stdlib/1.3.71/kotlin-stdlib-1.3.71.pom
https://jcenter.bintray.com/org/jetbrains/kotlin/kotlin-stdlib-common/1.3.70/kotlin-stdlib-common-1.3.70.pom
https://jcenter.bintray.com/org/jetbrains/kotlin/kotlin-stdlib-common/1.3.71/kotlin-stdlib-common-1.3.71.jar
https://jcenter.bintray.com/org/jetbrains/kotlin/kotlin-stdlib-common/1.3.71/kotlin-stdlib-common-1.3.71.pom
https://jcenter.bintray.com/org/kohsuke/pom/14/pom-14.pom
https://jcenter.bintray.com/org/projectlombok/lombok/1.18.12/lombok-1.18.12.jar
https://jcenter.bintray.com/org/projectlombok/lombok/1.18.12/lombok-1.18.12.pom
https://jcenter.bintray.com/org/simpleframework/simple-xml/2.7.1/simple-xml-2.7.1.jar
https://jcenter.bintray.com/org/simpleframework/simple-xml/2.7.1/simple-xml-2.7.1.pom
https://jcenter.bintray.com/org/sonatype/oss/oss-parent/9/oss-parent-9.pom
https://jcenter.bintray.com/stax/stax/1.2.0/stax-1.2.0.jar
https://jcenter.bintray.com/stax/stax/1.2.0/stax-1.2.0.pom
https://jcenter.bintray.com/stax/stax-api/1.0.1/stax-api-1.0.1.jar
https://jcenter.bintray.com/stax/stax-api/1.0.1/stax-api-1.0.1.pom
https://jcenter.bintray.com/xpp3/xpp3/1.1.3.3/xpp3-1.1.3.3.jar
https://jcenter.bintray.com/xpp3/xpp3/1.1.3.3/xpp3-1.1.3.3.pom
"

SRC_URI="https://gitlab.com/sheepitrenderfarm/client/-/archive/v${PV}/client-v${PV}.tar.bz2
	-> ${PN}-${PV}.tar.bz2
	${GRADLE_DOWNLOADS}"
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
	einfo "Device IDs <-> codename: \
https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/blob/roc-3.3.0/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c#L777"
	einfo
}

show_notice_pcie3_atomics_required() {
	# See \
# https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/blob/roc-3.3.0/drivers/gpu/drm/amd/amdkfd/kfd_device.c
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
		use sheepit_client_blender_2_79b_filmic && gbewarn "2.79b_filmic"
		use sheepit_client_blender_2_80 && gbewarn "2.80"
		use sheepit_client_blender_2_81a && gbewarn "2.81a"
		use sheepit_client_blender_2_82 && gbewarn "2.82"
		use sheepit_client_blender_2_83_1 && gbewarn "2.83.1"
		use sheepit_client_blender_2_83_2 && gbewarn "2.83.2"
		use sheepit_client_blender_2_90_0 && gbewarn "2.90.0"
	fi

#	if has network-sandbox $FEATURES ; then
#		die \
#"${PN} requires network-sandbox to be disabled in FEATURES."
#	fi

	if use opencl_rocm ; then
		# No die checks for this kernel config in
		# dev-libs/rocm-opencl-runtime.
		CONFIG_CHECK="HSA_AMD"
		ERROR_HSA_AMD=\
"Change CONFIG_HSA_AMD=y in kernel config.  It's required for opencl_rocm support."
		linux-info_pkg_setup
		if dmesg \
			| grep kfd \
			| grep "PCI rejects atomics" \
				2>/dev/null 1>/dev/null ; then
			show_notice_pcie3_atomics_required
		elif dmesg \
			| grep -e '\[drm\] PCIE atomic ops is not supported' \
			2>/dev/null 1>/dev/null ; then
			show_notice_pcie3_atomics_required
		fi
	fi

	if use opencl_pal ; then
		CONFIG_CHECK="HSA_AMD"
		WARNING_HSA_AMD=\
"Change CONFIG_HSA_AMD=y kernel config.  It may be required for opencl_pal support for pre-Vega 10."
		linux-info_pkg_setup
		if dmesg \
			| grep kfd \
			| grep "PCI rejects atomics" \
				2>/dev/null 1>/dev/null ; then
			show_notice_pal_support
		elif dmesg \
			| grep -e '\[drm\] PCIE atomic ops is not supported' \
			2>/dev/null 1>/dev/null ; then
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

	java-pkg_init
	java-pkg_ensure-vm-version-ge ${JAVA_V}
}

enable_hardblock() {
	sed -i -e "s|\
public static final boolean ${1} = false;|\
public static final boolean ${1} = true;|g" \
		src/com/sheepit/client/Configuration.java || die
}

disable_hardblock() {
	sed -i -e "s|\
public static final boolean ${1} = true;|\
public static final boolean ${1} = false;|g" \
		src/com/sheepit/client/Configuration.java || die
}

unpack_gradle()
{
	# from `find ${HOME}/.gradle/.gradle/caches/modules-2/files-2.1`
	local pkgs=(
                "args4j/args4j/2.33/168b592340292d4410a1d000bb7fa7144967fc12/args4j-2.33.pom"
                "args4j/args4j/2.33/bd87a75374a6d6523de82fef51fc3cfe9baf9fc9/args4j-2.33.jar"
                "args4j/args4j-site/2.33/9ba12fde00306694af3ce9f5ff302c858345edf/args4j-site-2.33.pom"
                "com.formdev/flatlaf/0.30/1ebd625c1844170cebc7bcf02856e5e2dd396070/flatlaf-0.30.jar"
                "com.formdev/flatlaf/0.30/3d886d1d5f7551b56553fa949c62055044d3a866/flatlaf-0.30.pom"
                "com.github.jengelman.gradle.plugins/shadow/4.0.4/891b9d8131c22794b87d29be8968b24fafe5604e/shadow-4.0.4.jar"
                "com.github.jengelman.gradle.plugins/shadow/4.0.4/ae03091ddcba917cfcafe93ef226796281208487/shadow-4.0.4.pom"
                "com.squareup.okhttp3/okhttp/4.7.2/c9acfd63537db1d7d21d98a7405e22449bb881d6/okhttp-4.7.2.jar"
                "com.squareup.okhttp3/okhttp/4.7.2/db4f01eaabed8c683fee36b4f5fa9af6cc0e6190/okhttp-4.7.2.pom"
                "com.squareup.okhttp3/okhttp-urlconnection/4.7.2/7e1421fe4d6d63b4d2a4afcc89ae88090cafd74d/okhttp-urlconnection-4.7.2.pom"
                "com.squareup.okhttp3/okhttp-urlconnection/4.7.2/812effc52e6988e36b5868c153276ab581af8394/okhttp-urlconnection-4.7.2.jar"
                "com.squareup.okio/okio/2.6.0/c099e0689dcc10dd26a653ac0587c036d42b704c/okio-2.6.0.pom"
                "com.squareup.okio/okio/2.6.0/f06923d428f3c8e6f571043ec29a45d0cd9d2bf/okio-2.6.0.jar"
                "com.sun.activation/all/1.2.0/9b1023e38195ea19d1a0ac79192d486da1904f97/all-1.2.0.pom"
                "javax.activation/javax.activation-api/1.2.0/1aa9ef58e50ba6868b2e955d61fcd73be5b4cea5/javax.activation-api-1.2.0.pom"
                "javax.activation/javax.activation-api/1.2.0/85262acf3ca9816f9537ca47d5adeabaead7cb16/javax.activation-api-1.2.0.jar"
                "javax.xml.bind/jaxb-api/2.3.1/8531ad5ac454cc2deb9d4d32c40c4d7451939b5d/jaxb-api-2.3.1.jar"
                "javax.xml.bind/jaxb-api/2.3.1/c42c51ae84892b73ef7de5351188908e673f5c69/jaxb-api-2.3.1.pom"
                "javax.xml.bind/jaxb-api-parent/2.3.1/26101e8a1a09e16cdf277a4591f6d29917b2e06e/jaxb-api-parent-2.3.1.pom"
                "net.java.dev.jna/jna/5.0.0/a6b7cb36b5f8dba90275675571b4f4e127d64cd1/jna-5.0.0.pom"
                "net.java.dev.jna/jna/5.0.0/a73c9c974cf7d3b1b84bca99e30d16ec3f371b44/jna-5.0.0.jar"
                "net.java.dev.jna/jna-platform/5.0.0/15949855e46be4f528d7eb9904bb346bcedccbfa/jna-platform-5.0.0.jar"
                "net.java.dev.jna/jna-platform/5.0.0/2eab4ec05d07ba88ed7831ba595b5f979342a668/jna-platform-5.0.0.pom"
                "net.java/jvnet-parent/1/b55a1b046dbe82acdee8edde7476eebcba1e57d8/jvnet-parent-1.pom"
                "net.java/jvnet-parent/5/5343c954d21549d039feebe5fadef023cdfc1388/jvnet-parent-5.pom"
                "net.lingala.zip4j/zip4j/1.3.3/ae79277a25359a2657f7d7f6fd0fb4917cf2d0e7/zip4j-1.3.3.jar"
                "net.lingala.zip4j/zip4j/1.3.3/e314de3702fb052338fe56d620603e177bda7469/zip4j-1.3.3.pom"
                "org.codehaus.groovy/groovy-backports-compat23/2.4.15/96cbcd01eaa6038f900b7154d08aae462c5430e/groovy-backports-compat23-2.4.15.jar"
                "org.codehaus.groovy/groovy-backports-compat23/2.4.15/ce562f829e998dfb3a30442aab9f7a5e6031aa01/groovy-backports-compat23-2.4.15.pom"
                "org.jetbrains/annotations/13.0/919f0dfe192fb4e063e7dacadee7f8bb9a2672a9/annotations-13.0.jar"
                "org.jetbrains/annotations/13.0/fa7d3d07cc80547e2d15bf4839d3267c637c642f/annotations-13.0.pom"
                "org.jetbrains.kotlin/kotlin-stdlib/1.3.71/47da9a84ba07a4de17cddff5e139f8d120627c62/kotlin-stdlib-1.3.71.pom"
                "org.jetbrains.kotlin/kotlin-stdlib/1.3.71/898273189ad22779da6bed88ded39b14cb5fd432/kotlin-stdlib-1.3.71.jar"
                "org.jetbrains.kotlin/kotlin-stdlib-common/1.3.70/bd1d0642aedfd3780a730235af7499706225ccb3/kotlin-stdlib-common-1.3.70.pom"
                "org.jetbrains.kotlin/kotlin-stdlib-common/1.3.71/dc5b708b195cb44fcb098c96c5ed4774a53d5c93/kotlin-stdlib-common-1.3.71.pom"
                "org.jetbrains.kotlin/kotlin-stdlib-common/1.3.71/e71c3fef58e26affeb03d675e91fd8abdd44aa7b/kotlin-stdlib-common-1.3.71.jar"
                "org.kohsuke/pom/14/7e52f77bc3cd74f323816fadbcb9303df219b1ea/pom-14.pom"
                "org.projectlombok/lombok/1.18.12/48e4e5d60309ebd833bc528dcf77668eab3cd72c/lombok-1.18.12.jar"
                "org.projectlombok/lombok/1.18.12/4f6ff5ec7e7e286da5393d18f2214e0d8a5278be/lombok-1.18.12.pom"
                "org.simpleframework/simple-xml/2.7.1/dd91fb744c2ff921407475cb29a1e3fee397d411/simple-xml-2.7.1.jar"
                "org.simpleframework/simple-xml/2.7.1/e5272a3c03686ecb3e1adf929681fca23215f52b/simple-xml-2.7.1.pom"
                "org.sonatype.oss/oss-parent/9/e5cdc4d23b86d79c436f16fed20853284e868f65/oss-parent-9.pom"
                "stax/stax/1.2.0/25c804f06fe1d144906fb812b88e60711cc2b3fd/stax-1.2.0.pom"
                "stax/stax/1.2.0/c434800de5e4bbe1822805be5fb1c32d6834f830/stax-1.2.0.jar"
                "stax/stax-api/1.0.1/49c100caf72d658aca8e58bd74a4ba90fa2b0d70/stax-api-1.0.1.jar"
                "stax/stax-api/1.0.1/e3a933099229a34b22e9e78b2b999e1eb03b3e4e/stax-api-1.0.1.pom"
                "xpp3/xpp3/1.1.3.3/2bd55af9b5089d6a7aae908fc2a155a19ee88cba/xpp3-1.1.3.3.pom"
                "xpp3/xpp3/1.1.3.3/64f9d2bb88f58ad2a15a4301487d977ee9b4294/xpp3-1.1.3.3.jar"
	)

	for x in ${pkgs[@]} ; do
		local d_rel=$(dirname "${x}" \
			| sed -r -e "s|/[0-9a-z]{39,40}||g" \
			| tr "/" "\n" \
			| sed -e "1s|[.]|/|g" \
			| tr "\n" "/" \
			| sed -e "s|/$||g")
		#local d_base="${HOME}/.gradle/caches/modules-2/files-2.1"
		local d_base="${HOME}/.m2/repository"
		local d="${d_base}/${d_rel}"
		mkdir -p "${d}" || die
		local s=$(realpath "${DISTDIR}/"$(basename ${x}))
		einfo "Copying ${s} to ${d}"
		cp -a "${s}" "${d}" || die
	done
}

src_unpack() {
	unpack ${PN}-${PV}.tar.bz2
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
		ewarn \
"\n\
Security notices:\n\
\n\
${PN} downloads Blender 2.79 with Python 3.5.3 having critical security CVE \
advisories\n\
https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=python%203.5&search_type=all\n\
\n\
${PN} downloads Blender 2.80 with Python 3.7.0 having high security CVE \
advisory\n\
${PN} downloads Blender 2.81a with Python 3.7.4 having high security CVE \
advisory\n\
${PN} downloads Blender 2.82 with Python 3.7.4 having high security CVE \
advisory\n\
${PN} downloads Blender 2.83.1 with Python 3.7.4 having high security CVE \
advisory\n\
${PN} downloads Blender 2.83.2 with Python 3.7.4 having high security CVE \
advisory\n\
${PN} downloads Blender 2.90.0 with Python 3.7.7 having high security CVE \
advisory\n\
https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=python%203.7&search_type=all\n\
\n\
${PN} downloads repackaged Blender 2.81a with DirectFB 1.2.10.\n\
https://security.gentoo.org/glsa/201701-55\n\
\n\
${PN} downloads repackaged Blender 2.82 with DirectFB 1.2.10.\n\
https://security.gentoo.org/glsa/201701-55\n\
\n\
${PN} downloads Blender 2.81a with SDL 1.2.14_pre20091018.\n\
https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=sdl%201.2&search_type=all\n\
\n\
${PN} downloads Blender 2.82 with SDL 1.2.14_pre20091018.\n\
https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=sdl%201.2&search_type=all\n\
\n"
	fi

	default
	if use opencl ; then
		sed -i -e "s|os instanceof Windows|true|" \
			src/com/sheepit/client/hardware/gpu/GPU.java || die
	fi

	eapply "${FILESDIR}/sheepit-client-6.20304.0-r4-renderer-version-picker.patch"
	eapply "${FILESDIR}/sheepit-client-6.20304.0-use-maven-local.patch" # mutually exclusive with compile_with_gradlew
	sed -i -e "s|__MAVEN_PATH__|${HOME}/.m2/repository|g" build.gradle || die

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
		sed -i -e "s|\
USE_SYSTEM_RENDERERS = true|\
USE_SYSTEM_RENDERERS = false|g" \
			src/com/sheepit/client/Configuration.java || die
	fi

	if use no-repacks ; then
		sed -i -e "s|\
USE_ONLY_DOWNLOAD_DOT_BLENDER_DOT_ORG = false|\
USE_ONLY_DOWNLOAD_DOT_BLENDER_DOT_ORG = true|g" \
			src/com/sheepit/client/Configuration.java || die
	fi

	if ! use allow-unknown-renderers ; then
		if ! use disable-hard-version-blocks ; then
			enable_hardblock "HARDBLOCK_UNKNOWN_RENDERERS"
		fi
	fi

	for x in ${IUSE_BLENDER_VERSIONS[@]} ; do
		if ! use ${x} ; then
			local v=${x//sheepit_client_blender_}
			v=${x^^}
			enable_hardblock "HARDBLOCK_BLENDER_${v}"
		fi
	done
}

# For use in sandboxed build, normal use case
compile_with_gradle()
{
	# Prevents: Could not open terminal for stdout: could not get termcap
	# entry
	export TERM=linux # pretend to be outside of X

	# This has to be placed here because something is up with the sandbox.
	unpack_gradle

	export GRADLE_USER_HOME="${HOME}/.gradle"
	export PATH="/usr/share/gradle-bin-${GRADLE_V}/bin:${PATH}"
	einfo "GRADLE_USER_HOME=${GRADLE_USER_HOME}"
	einfo "PATH=${PATH}"
	gradle shadowJar || die
}

# For inspecting the dependency tree, ebuild development
compile_with_gradlew()
{
	# Prevents: Could not open terminal for stdout: could not get termcap
	# entry
	export TERM=linux # pretend to be outside of X

	# TODO use system gradle instead
	chmod +x gradlew || die
	cd "${S}" || die
	chmod +x gradlew || die
	export GRADLE_USER_HOME="${HOME}/.gradle"
	./gradlew shadowJar || die
}

src_compile() {
	compile_with_gradle
}

src_install() {
	insinto /usr/share/${PN}
	local ext="" # -all <-> gradlew ; "" <-> gradle (i.e. the system's)
	doins build/libs/sheepit-client${ext}.jar
	exeinto /usr/bin
	cat "${FILESDIR}/sheepit-client-v${WRAPPER_VERSION}" \
		> "${T}/sheepit-client" || die
	docinto licenses
	dodoc LICENSE
	local allowed_renderers=""

	for x in ${IUSE_BLENDER_VERSIONS[@]} ; do
		if use ${x} ; then
			einfo "Installing ${x}"
			local v0=${x//sheepit_client_blender_}
			v1=${v0}
			v0=${v0//_/.}

			if ! use system-blender ; then
		if ! use sheepit_client_blender_2_92_0 ; then
				dodoc -r "${FILESDIR}/blender-${v0}-licenses"
				use doc \
				dodoc -r "${FILESDIR}/blender-${v0}-readmes"
		fi
			fi
			allowed_renderers+=" --allow-blender-${v1}"
		else
			einfo "Skipping ${x}"
		fi
	done
	if use allow-unknown-renderers ; then
		allowed_renderers+=" --allow-unknown-renderers"
	fi
	if use doc ; then
		docinto docs
		dodoc protocol.txt README.md
	fi
	einfo "allowed_renderers=${allowed_renderers}"
	sed -i -e "s|ALLOWED_RENDERERS|${allowed_renderers}|g" \
		-e "s|sheepit-client.jar|sheepit-client${ext}.jar|g" \
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
			newins \
	"${FILESDIR}/firejail-profiles/sheepit-client-system-blender.profile" \
	"sheepit-client.profile"
		else
			if use no-repacks ; then
				newins \
	"${FILESDIR}/firejail-profiles/sheepit-client-no-repacks.profile" \
	"sheepit-client.profile"
			else
				newins \
	"${FILESDIR}/firejail-profiles/sheepit-client-default.profile" \
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
		ewarn "For details see, \
https://github.com/laurent-clouet/sheepit-client/issues/165"
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
