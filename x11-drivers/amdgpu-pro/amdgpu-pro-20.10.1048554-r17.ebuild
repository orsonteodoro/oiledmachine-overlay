# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Radeon™ Software for Linux®"
HOMEPAGE=\
"https://www.amd.com/en/support/kb/release-notes/rn-amdgpu-unified-linux-20-10"
LICENSE="AMDGPUPROEULA
	doc? ( AMDGPUPROEULA MIT BSD )
	dkms? ( AMDGPU-FIRMWARE GPL-2 MIT )
	open-stack? (
		egl? ( developer? ( BSD MIT ) MIT )
		gles2? ( MIT developer? ( Apache-2.0 MIT ) )
		opengl? ( MIT SGI-B-2.0 )
		opengl_mesa? ( all-rights-reserved MIT SGI-B-2.0 )
		osmesa? ( all-rights-reserved MIT )
		vdpau? ( MIT )
		vulkan_open? ( MIT )
		xa? ( MIT )
		developer? ( Apache-2.0-with-LLVM-exceptions UoI-NCSA BSD-2 BSD ) UoI-NCSA
		developer? ( opengl_mesa? ( all-rights-reserved MIT ) )
		MIT
	)
	pro-stack? (
		AMDGPUPROEULA
		clinfo? ( AMDGPUPROEULA )
		egl? ( AMDGPUPROEULA )
		gles2? ( AMDGPUPROEULA )
		hip-clang? ( AMDGPUPROEULA )
		opencl? ( AMDGPUPROEULA )
		opencl-icd-loader? ( AMDGPUPROEULA )
		opencl_pal? ( AMDGPUPROEULA )
		opencl_orca? ( AMDGPUPROEULA )
		opengl? ( AMDGPUPROEULA )
		opengl_pro? ( AMDGPUPROEULA )
		vulkan_pro? ( AMDGPUPROEULA )
	)
	X? ( MIT all-rights-reserved )"
# eglextchromium.h - BSD
# gbm - MIT
# libdrm - MIT
# libglapi-amdgpu - MIT all-rights-reserved ; See [1]. The X USE flag unpacks mesa-amdgpu-libglapi.
# libglapi-amdgpu-pro - AMDGPUPROEULA
# llvm - developer? ( Apache-2.0-with-LLVM-exceptions UoI-NCSA BSD-2 ) UoI-NCSA
#   xxhash.h - BSD-2
# Mesa - MIT all-rights-reserved SGI-B-2.0 # See [1].
# xorg-x11-amdgpu-drv-amdgpu - MIT
#
# Footnote
# [1] There is no all rights reserved in the vanilla MIT license.
KEYWORDS="~amd64 ~x86"
MULTILIB_COMPAT=( abi_x86_{32,64} )
inherit check-reqs linux-info multilib-build unpacker rpm
PKG_VER=$(ver_cut 1-2)
PKG_VER_MAJ=$(ver_cut 1)
PKG_REV=$(ver_cut 3)
PKG_ARCH="rhel"
PKG_ARCH_VER="8.1"
PKG_ARCH_VER_MAJOR=$(ver_cut 1 ${PKG_ARCH_VER})
PKG_ARCH_SUFFIX=".el${PKG_ARCH_VER_MAJOR}."
PKG_VER_GCC="8.2.1"
PKG_VER_GST_OMX="1.0.0.1"
PKG_VER_HSAKMT="1.0.6"
PKG_VER_HSAKMT_A="1.0.9"
PKG_VER_ID="1.0.0"
PKG_VER_LIBDRM="2.4.100"
PKG_VER_LLVM_TRIPLE="9.0.0"
PKG_VER_LLVM=$(ver_cut 1-2 ${PKG_VER_LLVM_TRIPLE})
PKG_VER_LLVM_MAJ=$(ver_cut 1 ${PKG_VER_LLVM_TRIPLE})
PKG_VER_MESA="19.3.4"
PKG_VER_STRING=${PKG_VER}-${PKG_REV}
PKG_VER_STRING_DIR=${PKG_VER_STRING}-${PKG_ARCH}-${PKG_ARCH_VER}
PKG_VER_VA="1.8.3"
PKG_VER_XORG_VIDEO_AMDGPU_DRV="19.1.0" # about the same as the mesa version
VULKAN_SDK_VER="1.1.121.1"
ROCK_V="3.3.0_pre20200204" # an approximate
IUSE="bindist clinfo developer dkms doc +egl +gles2 freesync hip-clang
+open-stack +opencl opencl-icd-loader +opencl_orca +opencl_pal +opengl
opengl_mesa +opengl_pro osmesa +pro-stack rocm strict-pairing +vaapi
vaapi_r600 +vaapi_radeonsi +vdpau vdpau_r300 vdpau_r600 +vdpau_radeonsi +vulkan
vulkan_open vulkan_pro +X xa"
REQUIRED_USE="
	!abi_x86_32
	bindist? ( !doc !pro-stack )
	clinfo? ( opencl pro-stack )
	egl? ( || ( open-stack pro-stack ) X )
	gles2? ( egl || ( open-stack pro-stack ) )
	hip-clang? ( developer pro-stack rocm )
	opencl? ( || ( opencl_orca opencl_pal ) pro-stack )
	opencl-icd-loader? ( open-stack )
	opencl_orca? ( opencl )
	opencl_pal? ( opencl )
	opengl? ( ^^ ( opengl_mesa opengl_pro ) )
	opengl_mesa? ( open-stack opengl X )
	opengl_pro? ( egl pro-stack opengl X )
	osmesa? ( developer? ( X ) open-stack )
	rocm? ( dkms open-stack pro-stack )
	vaapi? ( open-stack X ^^ ( vaapi_r600 vaapi_radeonsi ) )
	vaapi_r600? ( vaapi )
	vaapi_radeonsi? ( vaapi )
	vdpau? ( open-stack ^^ ( vdpau_r300 vdpau_r600 vdpau_radeonsi ) )
	vdpau_r300? ( vdpau )
	vdpau_r600? ( vdpau )
	vdpau_radeonsi? ( vdpau )
	vulkan? ( || ( vulkan_open vulkan_pro ) )
	vulkan_open? ( open-stack vulkan )
	vulkan_pro? ( pro-stack vulkan )
	xa? ( open-stack )"
SLOT="1"

# The x11-base/xorg-server-<ver> must match this drivers version or this error
# will be produced:
# modules abi version 23 doesn't match the server version 24
#
# For more info on VIDEODRV see https://www.x.org/wiki/XorgModuleABIVersions/
# sys-libs/ncurses[tinfo] required by llvm in this package

RDEPEND="!x11-drivers/amdgpu-pro-lts
	 || ( >=dev-libs/libelf-0.174 virtual/libelf:0/1 )
	 >=dev-util/cunit-2.1_p3
	 >=dev-libs/expat-2.2.5
	 >=dev-libs/libedit-3.1
	 >=sys-devel/gcc-${PKG_VER_GCC}
	 >=sys-libs/zlib-1.2.0
	 developer? (
		egl? (
			x11-base/xorg-proto
			x11-libs/libX11
			x11-libs/libXdamage
			x11-libs/libXext
			x11-libs/libXfixes
			x11-libs/libXxf86vm
			x11-libs/libxcb
			x11-libs/libxshmfence
		)
		opengl_mesa? (
			x11-base/xorg-proto
			x11-libs/libX11
			x11-libs/libXdamage
			x11-libs/libXext
			x11-libs/libXfixes
			x11-libs/libXxf86vm
			x11-libs/libxcb
			x11-libs/libxshmfence
		)
		open-stack? (
			X? ( x11-libs/libX11 )
			sys-libs/ncurses[tinfo]
			virtual/libffi
			virtual/libudev
		)
	 )
	 open-stack? (
	   sys-libs/ncurses:0/6[tinfo,${MULTILIB_USEDEP}]
	   sys-libs/ncurses-compat:5[tinfo,${MULTILIB_USEDEP}] )
	 opencl? ( !opencl-icd-loader? ( >=virtual/opencl-3 ) )
	 rocm? ( >=sys-apps/pciutils-3.5.6
		 >=sys-process/numactl-2.0.11
		  !strict-pairing? ( >=virtual/amdgpu-drm-3.2.72[dkms,firmware] )
		   strict-pairing? ( ~virtual/amdgpu-drm-3.2.72[dkms,firmware] )
		   >=dev-libs/roct-thunk-interface-${ROCK_V} )
	 !strict-pairing? (
		freesync? ( >=virtual/amdgpu-drm-3.2.08[dkms?] )
		>=virtual/amdgpu-drm-3.2.72[dkms?]
	 )
	 strict-pairing? (
		~virtual/amdgpu-drm-3.2.72[dkms?,strict-pairing]
	 )
	 vaapi? (  >=x11-libs/libva-${PKG_VER_VA} )
	 vdpau? ( >=x11-libs/libvdpau-1.1.1 )
	 !vulkan? ( >=media-libs/mesa-${PKG_VER_MESA}:= )
	  vulkan? ( >=media-libs/mesa-${PKG_VER_MESA}:=[-vulkan]
		    >=media-libs/vulkan-loader-${VULKAN_SDK_VER} )
	 X? (
	 >=sys-libs/libselinux-2.8
	   virtual/libudev
	 >=x11-base/xorg-drivers-1.20
	  <x11-base/xorg-drivers-1.21
	   x11-base/xorg-proto
	 >=x11-base/xorg-server-1.20[-minimal,glamor(+)]
	 >=x11-libs/libdrm-${PKG_VER_LIBDRM}[libkms]
	   x11-libs/libX11[${MULTILIB_USEDEP}]
	   x11-libs/libXext[${MULTILIB_USEDEP}]
	   x11-libs/libXinerama[${MULTILIB_USEDEP}]
	   x11-libs/libXrandr[${MULTILIB_USEDEP}]
	   x11-libs/libXrender[${MULTILIB_USEDEP}] )"
FN="amdgpu-pro-${PKG_VER_STRING}-${PKG_ARCH}-${PKG_ARCH_VER}.tar.xz"
SRC_URI="https://www2.ati.com/drivers/linux/${PKG_ARCH}/${FN}"
S="${WORKDIR}"
RESTRICT="fetch strip"

_set_check_reqs_requirements() {
	if use abi_x86_32 && use abi_x86_64 ; then
		CHECKREQS_DISK_BUILD="976M"
		CHECKREQS_DISK_USR="881M"
	else
		CHECKREQS_DISK_BUILD="976M"
		CHECKREQS_DISK_USR="881M"
	fi
}

pkg_nofetch() {
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	einfo "Please download"
	einfo "  - ${FN}"
	einfo "from ${HOMEPAGE} and place them in ${distdir}"
}

unpack_rpm() {
	echo ">>> Unpacking ${1##*/} to ${PWD}"
	rpm_unpack "${S}/${1}"
}

pkg_pretend() {
	_set_check_reqs_requirements
	check-reqs_pkg_setup
}

pkg_setup() {
	if [ ! -L /lib64/libedit.so.2 ] ; then
		einfo \
"You need to do \`ln -s /lib64/libedit.so.0 /lib64/libedit.so.2\`"
		die
	fi

	CONFIG_CHECK="~DRM_AMDGPU"

	WARNING_DRM_AMDGPU=\
"The CONFIG_DRM_AMDGPU kernel option is required for FreeSync or AMDGPU-PRO\n\
driver to work"

	linux-info_pkg_setup

	if use opencl_pal ; then
		einfo "opencl_pal for Vega 10 or newer is enabled"
	fi

	if use opencl_orca ; then
		einfo "opencl_orca for pre-Vega 10 is enabled"
	fi

	_set_check_reqs_requirements
	check-reqs_pkg_setup

	if [[ -f "${EROOT}/etc/env.d/000opengl" ]] ; then
		ewarn \
"Please remove /etc/env.d/000opengl and do ldconfig && env-update manually. \
This is to remove leftovers from eselect-opengl removal that might cause \
problems."
	fi
	if [[ -f "${EROOT}/etc/X11/xorg.conf.d/20opengl.conf" ]] ; then
		ewarn \
"Please remove /etc/X11/xorg.conf.d/20opengl.conf manually.  This is to remove \
leftovers from eselect-opengl removal that might cause problems."
	fi
}

src_unpack_common() {
	use doc && \
	unpack_rpm "${d_noarch}/amdgpu-doc-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${noarch}.rpm"
	if use X ; then
		unpack_rpm "${d_rpms}/mesa-amdgpu-dri-drivers-${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		unpack_rpm "${d_rpms}/mesa-amdgpu-libgbm-${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		unpack_rpm "${d_rpms}/mesa-amdgpu-libglapi-${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
	fi
}

src_unpack_open_stack() {
	unpack_rpm "${d_rpms}/amdgpu-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"

	unpack_rpm "${d_rpms}/drm-utils-amdgpu-${PKG_VER_LIBDRM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
	unpack_rpm "${d_rpms}/libdrm-amdgpu-${PKG_VER_LIBDRM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
	unpack_rpm "${d_noarch}/libdrm-amdgpu-common-${PKG_VER_ID}-${PKG_REV}${PKG_ARCH_SUFFIX}${noarch}.rpm"
	use developer && \
	unpack_rpm "${d_rpms}/libdrm-amdgpu-devel-${PKG_VER_LIBDRM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"

	# vdpau and mesa-amdgpu are consumers of llvm
	# The Internal LLVM9 is required since Gentoo is missing the
	# shared libLLVM-9.so with -DLLVM_BUILD_LLVM_DYLIB=ON that is
	# enabled on >=llvm-10.  Gentoo only use split llvm libraries
	# but the driver components use the shared.
	unpack_rpm "${d_rpms}/llvm-amdgpu-libs-${PKG_VER_LLVM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
	if use developer ; then
		unpack_rpm "${d_rpms}/llvm${PKG_VER_LLVM/\./}-amdgpu-${PKG_VER_LLVM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		unpack_rpm "${d_rpms}/llvm${PKG_VER_LLVM/\./}-amdgpu-devel-${PKG_VER_LLVM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		unpack_rpm "${d_rpms}/llvm-amdgpu-${PKG_VER_LLVM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		unpack_rpm "${d_rpms}/llvm-amdgpu-static-${PKG_VER_LLVM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		unpack_rpm "${d_rpms}/llvm-amdgpu-devel-${PKG_VER_LLVM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
	fi

	if use egl ; then
		unpack_rpm "${d_rpms}/mesa-amdgpu-libEGL-${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		use developer && \
		unpack_rpm "${d_rpms}/mesa-amdgpu-libEGL-devel-${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		if use gles2 ; then
			unpack_rpm "${d_rpms}/mesa-amdgpu-libGLES-${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
			use developer && \
			unpack_rpm "${d_rpms}/mesa-amdgpu-libGLES-devel-${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		fi
	fi

	use X && use developer && \
	unpack_rpm "${d_rpms}/mesa-amdgpu-libgbm-devel-${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"

	if use opengl_mesa ; then
		unpack_rpm "${d_rpms}/mesa-amdgpu-libGL-${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		use developer && \
		unpack_rpm "${d_rpms}/mesa-amdgpu-libGL-devel-${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
	fi

	if use osmesa ; then
		unpack_rpm "${d_rpms}/mesa-amdgpu-libOSMesa-${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		use developer && \
		unpack_rpm "${d_rpms}/mesa-amdgpu-libOSMesa-devel-${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
	fi

	if use xa ; then
		unpack_rpm "${d_rpms}/mesa-amdgpu-libxatracker-${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		use developer && \
		unpack_rpm "${d_rpms}/mesa-amdgpu-libxatracker-devel-${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
	fi

	# The VA-API driver is in the dri package.

	if use vdpau ; then
		unpack_rpm "${d_rpms}/mesa-amdgpu-vdpau-drivers-${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
	fi

	if use vulkan_open ; then
		unpack_rpm "${d_rpms}/vulkan-amdgpu-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
	fi

	if use X ; then
		unpack_rpm "${d_rpms}/xorg-x11-amdgpu-drv-amdgpu-${PKG_VER_XORG_VIDEO_AMDGPU_DRV}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
	fi
}

src_unpack_pro_stack() {
	unpack_rpm "${d_rpms}/amdgpu-pro-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
	unpack_rpm "${d_noarch}/amdgpu-pro-core-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${noarch}.rpm"
	unpack_rpm "${d_noarch}/amdgpu-pro-versionlist-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${noarch}.rpm"

	if use X ; then
		unpack_rpm "${d_rpms}/libglapi-amdgpu-pro-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
	fi

	if use egl && ! use opengl_mesa ; then
		unpack_rpm "${d_rpms}/libegl-amdgpu-pro-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
		if use gles2 ; then
			unpack_rpm "${d_rpms}/libgles-amdgpu-pro-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
		fi
	fi

	if use opencl_pal ; then
		unpack_rpm "${d_rpms}/opencl-amdgpu-pro-comgr-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
	fi

	if use opencl ; then
		if [[ "${ABI}" == "amd64" ]] ; then
			use clinfo && \
			unpack_rpm "${d_rpms}/clinfo-amdgpu-pro-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
		fi
		use opencl-icd-loader && \
		unpack_rpm "${d_rpms}/libopencl-amdgpu-pro-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
		if use opencl_pal ; then
			if [[ "${ABI}" == "amd64" ]] ; then
				unpack_rpm "${d_rpms}/opencl-amdgpu-pro-icd-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
			fi
		fi
		if use opencl_orca ; then
			unpack_rpm "${d_rpms}/opencl-orca-amdgpu-pro-icd-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
		fi
		use developer && \
		unpack_rpm "${d_rpms}/opencl-amdgpu-pro-devel-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
	fi

	if use opengl_pro ; then
		unpack_rpm "${d_rpms}/libgl-amdgpu-pro-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
		unpack_rpm "${d_noarch}/libgl-amdgpu-pro-appprofiles-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${noarch}.rpm"
		unpack_rpm "${d_rpms}/libgl-amdgpu-pro-ext-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
		unpack_rpm "${d_rpms}/libgl-amdgpu-pro-dri-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
	fi

	if use rocm ; then
		if use developer ; then
			if use hip-clang ; then
				if [[ "${ABI}" == "amd64" ]] ; then
					unpack_rpm "${d_rpms}/hip-amdgpu-pro-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
				fi
			fi
		fi
	fi

	if use vulkan_pro ; then
		unpack_rpm "${d_rpms}/vulkan-amdgpu-pro-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
	fi
}

src_unpack() {
	default

	local noarch="noarch"
	local d_noarch="amdgpu-pro-${PKG_VER_STRING_DIR}/RPMS/${noarch}"

	unpack_abi() {
		local arch
		local b

		if [[ "${ABI}" == "amd64" ]] ; then
			arch="x86_64"
			arch2="amd64"
			b="64"
		elif [[ "${ABI}" == "x86" ]] ; then
			arch="i386"
			b="32"
		else
			die "arch not supported"
		fi

		local d_rpms="amdgpu-pro-${PKG_VER_STRING_DIR}/RPMS/${arch}"

		src_unpack_common

		if use open-stack ; then
			src_unpack_open_stack
		fi

		if use pro-stack ; then
			src_unpack_pro_stack
		fi
	}
	multilib_foreach_abi unpack_abi
}

src_prepare() {
	default

	cat << EOF > "${T}/10-device.conf" || die
Section "Device"
	Identifier  "My graphics card"
	Driver      "amdgpu"
	BusID       "PCI:1:0:0"
	Option      "AccelMethod" "glamor"
	Option      "DRI" "3"
	Option	    "TearFree" "on"
EndSection
EOF

	cat << EOF > "${T}/10-screen.conf" || die
Section "Screen"
		Identifier      "Screen0"
		DefaultDepth    24
		SubSection      "Display"
		Depth   24
		EndSubSection
EndSection
EOF

	cat << EOF > "${T}/10-monitor.conf" || die
Section "Monitor"
	Identifier   "My monitor"
	VendorName   "BrandName"
	ModelName    "ModelName"
	Option       "DPMS"   "true"
EndSection
EOF

	modulepaths=
	[[ -d "${ED}/opt/amdgpu-pro/lib/xorg/modules" ]] && modulepaths+="\tModulePath \"/opt/amdgpu-pro/lib/xorg/modules\"\n"
	[[ -d "${ED}/opt/amdgpu/lib/xorg/modules" ]] && modulepaths+="\tModulePath \"/opt/amdgpu/lib/xorg/modules\"\n"
	[[ -d "${ED}/opt/amdgpu-pro/lib64/xorg/modules" ]] && modulepaths+="\tModulePath \"/opt/amdgpu-pro/lib64/xorg/modules\"\n"
	[[ -d "${ED}/opt/amdgpu/lib64/xorg/modules" ]] && modulepaths+="\tModulePath \"/opt/amdgpu/lib64/xorg/modules\"\n"
	[[ -d "${EROOT}/usr/lib/xorg/modules" ]] && modulepaths+="\tModulePath \"/usr/lib/xorg/modules\"\n"
	[[ -d "${EROOT}/usr/lib64/xorg/modules" ]] && modulepaths+="\tModulePath \"/usr/lib64/xorg/modules\"\n"
	modulepaths=$(echo -e "${modulepaths}")
	cat << EOF > "${T}/20-${PN}-opengl.conf"
Section "Files"
${modulepaths}
EndSection
EOF
}

src_install() {
	if use X ; then
		insinto /etc/X11/xorg.conf.d/
		doins "${T}/10-screen.conf"
		doins "${T}/10-monitor.conf"
		doins "${T}/10-device.conf"
		doins "${T}/20-${PN}-opengl.conf"
	fi

	insinto /lib/udev/rules.d
	[[ -e lib/udev/rules.d/91-amdgpu-pro-modeset.rules ]] && \
	doins lib/udev/rules.d/91-amdgpu-pro-modeset.rules

	insinto /
	doins -r etc
	doins -r opt

	# LDPATHs already handled in eselect-opengl
	if use opengl_pro ; then
		rm -rf "${ED}/etc/ld.so.conf.d" || die
	fi

	install_abi() {
		local arch
		local b

		if [[ "${ABI}" == "amd64" ]] ; then
			arch="x86_64"
			b="64"
		elif [[ "${ABI}" == "x86" ]] ; then
			arch="i386"
			b="32"
		else
			die "arch not supported"
		fi

		local sd_amdgpu="opt/amdgpu"
		local sd_amdgpupro="opt/amdgpu-pro"
		local dd_amdgpu="/usr/$(get_libdir)/opengl/amdgpu"
		local dd_amdgpupro="/usr/$(get_libdir)/opengl/amdgpu-pro"
		local od_amdgpu="/opt/amdgpu"
		local od_amdgpupro="/opt/amdgpu-pro"

		if use open-stack ; then
			chmod 0755 "${ED}/${od_amdgpu}/bin/"* || die
			chmod 0755 "${ED}/${od_amdgpu}/lib${b}/"*.so* || die
			if use vdpau ; then
				chmod 0755 "${ED}/${od_amdgpu}/lib${b}/vdpau/"*.so* || die
			fi
			if use developer ; then
				chmod 0755 "${ED}/${od_amdgpu}/lib${b}/llvm-${PKG_VER_LLVM}/lib/"*.so* || die
				chmod 0755 "${ED}/${od_amdgpu}/lib${b}/llvm-${PKG_VER_LLVM}/bin/"* || die
				chmod 0755 "${ED}/${od_amdgpu}/lib${b}/llvm-${PKG_VER_LLVM}/share/opt-viewer/"*.py || die
			fi
			if use open-stack && use X ; then
				chmod 0755 "${ED}/${od_amdgpu}/lib${b}/xorg/modules/drivers/"*.so* || die
			fi
			if use opengl_mesa ; then
				dosym libGL.so.1.2.0 ${od_amdgpu}/lib${b}/libGL.so
			fi
			if use vulkan_open ; then
				insinto /etc/vulkan/icd.d
				doins opt/amdgpu/etc/vulkan/icd.d/amd_icd${b}.json
			fi
		fi

		if use pro-stack ; then
			chmod 0755 "${ED}/${od_amdgpupro}/lib${b}/"*.so* || die
			if use opengl_pro ; then
				chmod 0755 "${ED}/${od_amdgpu}/lib${b}/dri/"*.so* || die
				dosym ../../../../../usr/lib${b}/dri/amdgpu_dri.so \
					${od_amdgpu}/lib${b}/dri/amdgpu_dri.so
				chmod 0755 "${ED}/${od_amdgpupro}/lib${b}/xorg/modules/extensions/"*.so* || die
				insinto /usr/lib64/dri
				doins usr/lib64/dri/amdgpu_dri.so
				chmod 0755 "${ED}/usr/lib64/dri/amdgpu_dri.so" || die
				cp -a "${ED}/${od_amdgpu}/lib${b}/"libgbm* \
					"${ED}/${od_amdgpupro}/lib${b}" || die
				dosym ../../../../../usr/lib${b}/dri/amdgpu_dri.so \
					${od_amdgpupro}/lib${b}/dri/amdgpu_dri.so
			fi

			if use opencl ; then
				if use clinfo ; then
					chmod 0755 "${ED}/${od_amdgpupro}/bin/"* || die
				fi
				if has_version 'app-eselect/eselect-opencl' ; then
					dosym ../../../../../opt/amdgpu-pro/$(get_libdir)/libOpenCL.so.1 \
						/usr/$(get_libdir)/OpenCL/vendors/amdgpu-pro/libOpenCL.so.1
					dosym ../../../../../opt/amdgpu-pro/$(get_libdir)/libOpenCL.so \
						/usr/$(get_libdir)/OpenCL/vendors/amdgpu-pro/libOpenCL.so
					dosym ../../../../../../opt/amdgpu-pro/include/CL \
						/usr/$(get_libdir)/OpenCL/vendors/amdgpu-pro/include/CL
				fi
			fi

			if use vulkan_pro ; then
				insinto /etc/vulkan/icd.d
				doins opt/amdgpu-pro/etc/vulkan/icd.d/amd_icd${b}.json
			fi
		fi
	}

	multilib_foreach_abi install_abi

	if use doc ; then
		docinto docs
		dodoc -r usr/share/doc/*
		doman usr/share/man/man7/amdgpu-doc.7.gz
	fi
	docinto licenses
	[[ -d usr/share/licenses ]] && \
	dodoc -r usr/share/licenses/*

	local vaapi_drv_name="radeonsi"
	local vdpau_drv_name="radeonsi"
	if use vaapi_r600 ; then
		vaapi_drv_name="r600"
	fi
	if use vdpau_r300 ; then
		vdpau_drv_name="r300"
	fi
	if use vdpau_r600 ; then
		vdpau_drv_name="r600"
	fi

	if use vaapi ; then
		cat <<-EOF > "${T}"/50${P}-vaapi
			LIBVA_DRIVERS_PATH="/opt/amdgpu/lib64/dri"
			LIBVA_DRIVER_NAME="${vaapi_drv_name}"
		EOF
		doenvd "${T}"/50${P}-vaapi
	fi

	if use vdpau ; then
		cat <<-EOF > "${T}"/50${P}-vdpau
			VDPAU_DRIVER_PATH="/opt/amdgpu/lib64/vdpau"
			VDPAU_DRIVER="${vdpau_drv_name}"
		EOF
		doenvd "${T}"/50${P}-vdpau
	fi

	ldpaths=""
	[[ -d "${ED}/opt/amdgpu-pro/lib/x86_64-linux-gnu" ]] && ldpaths+="/opt/amdgpu-pro/lib/x86_64-linux-gnu\n"
	[[ -d "${ED}/opt/amdgpu-pro/lib/i386-linux-gnu" ]] && ldpaths+="/opt/amdgpu-pro/lib/i386-linux-gnu\n"
	[[ -d "${ED}/opt/amdgpu/lib/x86_64-linux-gnu" ]] && ldpaths+="/opt/amdgpu/lib/x86_64-linux-gnu\n"
	[[ -d "${ED}/opt/amdgpu/lib/i386-linux-gnu" ]] && ldpaths+="/opt/amdgpu/lib/i386-linux-gnu\n"
	[[ -d "${ED}/opt/amdgpu-pro/lib64" ]] && ldpaths+="/opt/amdgpu-pro/lib64\n"
	ldpaths=$(echo -e "${ldpaths}" | tr "\n" ":")
	opengl_profile=
	if use opengl_mesa ; then
		opengl_profile=amdgpu
	elif use opengl_pro ; then
		opengl_profile=amdgpu-pro
	fi
	cat <<-EOF > "${T}"/000${PN}
		LDPATH="${ldpaths}"
		OPENGL_PROFILE="${opengl_profile}"
	EOF
	doenvd "${T}"/000${PN}
}

pkg_prerm() {
	if use opencl ; then
		if has_version 'app-eselect/eselect-opencl' ; then
			if "${EROOT}"/usr/bin/eselect opencl list | grep -q -e "mesa" ; then
				"${EROOT}"/usr/bin/eselect opencl set mesa
			elif "${EROOT}"/usr/bin/eselect opencl list | grep -q -e "ocl-icd" ; then
				"${EROOT}"/usr/bin/eselect opencl set ocl-icd
			fi
		fi
	fi
}

pkg_postinst() {
	if use opencl ; then
		if has_version 'app-eselect/eselect-opencl' ; then
			"${EROOT}"/usr/bin/eselect opencl set amdgpu-pro
		fi
	fi

	env-update
	einfo "You need to \`. /etc/profile\` or reboot before starting X"

	if use freesync ; then
		einfo \
"Refer to\n\
  https://www.amd.com/en/support/kb/faq/gpu-754\n\
to enable FreeSync per each DisplayPort and to view the software supported\n\
by FreeSync.  You must have VSync on to use FreeSync.  Modify /etc/amd/amdrc\n\
to turn on VSync."
	fi

	einfo \
"For DirectGMA, SSG, and ROCm API support re-emerge with dkms and make sure\n\
that either amdgpu-dkms or rock-dkms is installed"

	if has_version 'app-eselect/eselect-opencl' ; then
		einfo \
"Re-emerge this package with the opencl-icd-loader USE flag to fix the\n\
libOpenCL.so symlink complaint by eselect-opencl"
	fi
}

#1234567890123456789012345678901234567890123456789012345678901234567890123456789
