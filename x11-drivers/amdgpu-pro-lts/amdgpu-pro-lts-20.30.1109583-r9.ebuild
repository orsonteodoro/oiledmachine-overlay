# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Radeon™ Software for Linux®"
HOMEPAGE=\
"https://www.amd.com/en/support/kb/release-notes/rn-amdgpu-unified-linux-20-30"
LICENSE="AMDGPUPROEULA
	doc? ( AMDGPUPROEULA MIT BSD )
	dkms? ( AMDGPU-FIRMWARE GPL-2 MIT )
	open-stack? (
		egl? ( developer? ( BSD MIT ) MIT )
		glamor? ( MIT )
		gles2? ( MIT developer? ( Apache-2.0 MIT ) )
		hwe? ( MIT )
		opengl? ( MIT SGI-B-2.0 )
		opengl_mesa? ( all-rights-reserved MIT SGI-B-2.0 )
		openmax? ( BSD GPL-2+-with-autoconf-exception LGPL-2.1 MIT )
		osmesa? ( all-rights-reserved MIT )
		vaapi? ( MIT )
		vdpau? ( MIT )
		vulkan_open? ( MIT )
		xa? ( MIT )
		developer? ( Apache-2.0-with-LLVM-exceptions UoI-NCSA BSD-2 BSD ) UoI-NCSA
		developer? ( opengl_mesa? ( all-rights-reserved MIT ) )
		MIT
	)
	pro-stack? (
		AMDGPUPROEULA
		amf? ( AMDGPUPROEULA )
		clinfo? ( AMDGPUPROEULA )
		egl? ( AMDGPUPROEULA )
		gles2? ( AMDGPUPROEULA )
		hip-clang? ( AMDGPUPROEULA )
		hwe? ( AMDGPUPROEULA )
		opencl? ( AMDGPUPROEULA )
		opencl-icd-loader? ( AMDGPUPROEULA )
		opencl_orca? ( AMDGPUPROEULA )
		opencl_pal? ( AMDGPUPROEULA )
		opengl? (
			AMDGPUPROEULA
			hwe? ( AMDGPUPROEULA )
		)
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
inherit check-reqs linux-info multilib-build unpacker
PKG_VER=$(ver_cut 1-2)
PKG_VER_MAJ=$(ver_cut 1)
PKG_REV=$(ver_cut 3)
PKG_ARCH="ubuntu"
PKG_ARCH_VER="18.04"
PKG_ARCH_SUFFIX="_"
PKG_VER_AMF="1.4.17"
PKG_VER_GCC="5.2.0"
PKG_VER_GLAMOR="1.19.0"
PKG_VER_GST_OMX="1.0.0.1"
PKG_VER_GST=$(ver_cut 1-2 ${PKG_VER_GST_OMX})
PKG_VER_HSAKMT="1.0.6"
PKG_VER_HSAKMT_A="1.0.9"
PKG_VER_ID="1.0.0"
PKG_VER_LIBDRM="2.4.100"
PKG_VER_LIBWAYLAND="1.16.0"
PKG_VER_LLVM_TRIPLE="10.0.0"
PKG_VER_LLVM=$(ver_cut 1-2 ${PKG_VER_LLVM_TRIPLE})
PKG_VER_LLVM_MAJ=$(ver_cut 1 ${PKG_VER_LLVM_TRIPLE})
PKG_VER_MESA="20.1.0"
PKG_VER_ROCT="1.0.9"
PKG_VER_STRING=${PKG_VER}-${PKG_REV}
PKG_VER_STRING_DIR=${PKG_VER_STRING}-${PKG_ARCH}-${PKG_ARCH_VER}
PKG_VER_WAYLAND_PROTO="1.17"
PKG_VER_XORG_VIDEO_AMDGPU_DRV="19.1.0" # about the same as the mesa version
VULKAN_SDK_VER="1.2.135.0"
ROCK_V="3.5.1" # an approximate
IUSE="+amf bindist clinfo developer dkms doc +egl +gles2 freesync glamor
hip-clang +hwe +open-stack +opencl opencl-icd-loader +opencl_orca +opencl_pal
+opengl +opengl_pro opengl_mesa openmax osmesa +pro-stack rocm strict-pairing
+system-llvm +vaapi vaapi_r600 +vaapi_radeonsi +vdpau vdpau_r300 vdpau_r600
+vdpau_radeonsi +vulkan vulkan_open vulkan_pro wayland +X xa"
REQUIRED_USE="
	amf? ( pro-stack opencl vulkan_pro )
	bindist? ( !pro-stack !doc )
	clinfo? ( opencl pro-stack )
	developer? ( opengl_mesa? ( X ) )
	egl? ( || ( open-stack pro-stack ) wayland X )
	glamor? ( open-stack opengl X )
	gles2? ( egl || ( open-stack pro-stack ) )
	hip-clang? ( developer pro-stack rocm )
	hwe
	hwe? ( open-stack )
	opencl? ( || ( opencl_orca opencl_pal ) pro-stack )
	opencl-icd-loader? ( open-stack )
	opencl_orca? ( opencl )
	opencl_pal? ( opencl )
	opengl? ( ^^ ( opengl_mesa opengl_pro ) )
	opengl_mesa? ( open-stack opengl X )
	opengl_pro? ( egl !glamor opengl pro-stack wayland X )
	osmesa? ( developer? ( X ) open-stack )
	rocm? ( dkms open-stack pro-stack )
	vaapi? ( open-stack ^^ ( vaapi_r600 vaapi_radeonsi ) )
	vaapi_r600? ( vaapi )
	vaapi_radeonsi? ( vaapi )
	vdpau? ( open-stack ^^ ( vdpau_r300 vdpau_r600 vdpau_radeonsi ) )
	vdpau_r300? ( vdpau )
	vdpau_r600? ( vdpau )
	vdpau_radeonsi? ( vdpau )
	vulkan? ( || ( vulkan_open vulkan_pro ) wayland )
	vulkan_open? ( open-stack vulkan )
	vulkan_pro? ( pro-stack vulkan )
	wayland? ( open-stack )
	xa? ( open-stack )
	X? ( wayland )"
SLOT="1"

# The x11-base/xorg-server-<ver> must match this drivers version or this error
# will be produced:
# modules abi version 23 doesn't match the server version 24
#
# For more info on VIDEODRV see https://www.x.org/wiki/XorgModuleABIVersions/
# sys-libs/ncurses[tinfo] required by llvm in this package

RDEPEND="!x11-drivers/amdgpu-pro
	 || ( >=dev-libs/libelf-0.142 virtual/libelf:0/1 )
	 >=dev-util/cunit-2.1
	 >=dev-libs/expat-2.0.1
	 >=dev-libs/libedit-3.1[${MULTILIB_USEDEP}]
	 || ( dev-libs/libffi:0/7[${MULTILIB_USEDEP}]
	      dev-libs/libffi-compat:7[${MULTILIB_USEDEP}] )
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
			|| ( dev-libs/libffi:0/7[${MULTILIB_USEDEP}]
			     dev-libs/libffi-compat:7[${MULTILIB_USEDEP}] )
			virtual/libudev
		)
	 )
	 glamor? ( media-libs/libepoxy )
	 open-stack? (
	   sys-libs/ncurses:0/6[tinfo,${MULTILIB_USEDEP}]
	   sys-libs/ncurses-compat:5[tinfo,${MULTILIB_USEDEP}] )
	 opencl? ( !opencl-icd-loader? ( >=virtual/opencl-3 ) )
	 openmax? ( >=media-libs/gst-plugins-base-1.6.0[${MULTILIB_USEDEP}]
		    >=media-libs/gstreamer-1.6.0[${MULTILIB_USEDEP}]
		      media-libs/libomxil-bellagio
		    >=media-libs/mesa-${PKG_VER_MESA}[openmax] )
	 rocm? (  >=sys-apps/pciutils-3.5.2
		  >=sys-process/numactl-2.0.11
		   !strict-pairing? ( >=virtual/amdgpu-drm-3.2.87[dkms,firmware] )
		    strict-pairing? ( ~virtual/amdgpu-drm-3.2.87[dkms,firmware] )
		    >=dev-libs/roct-thunk-interface-${ROCK_V} )
	 !strict-pairing? (
		freesync? ( >=virtual/amdgpu-drm-3.2.08[dkms?] )
		>=virtual/amdgpu-drm-3.2.87[dkms?]
	 )
	 strict-pairing? (
		~virtual/amdgpu-drm-3.2.87[dkms?,strict-pairing]
	 )
	 system-llvm? (
		!~sys-devel/clang-${PKG_VER_LLVM_MAJ}.0.0.9999:${PKG_VER_LLVM_MAJ}
		!~sys-devel/llvm-${PKG_VER_LLVM_MAJ}.0.0.9999:${PKG_VER_LLVM_MAJ}
		>=sys-devel/clang-${PKG_VER_LLVM_TRIPLE}:${PKG_VER_LLVM_MAJ}[llvm_targets_AMDGPU]
		>=sys-devel/llvm-${PKG_VER_LLVM_TRIPLE}:${PKG_VER_LLVM_MAJ}[llvm_targets_AMDGPU]
	 )
	 vaapi? ( >=x11-libs/libva-2.1.0
		  >=virtual/amdgpu-drm-3.2.87[dkms?,firmware] )
	 vdpau? ( >=x11-libs/libvdpau-1.1.1 )
	 !vulkan? ( >=media-libs/mesa-${PKG_VER_MESA}:= )
	  vulkan? ( >=media-libs/mesa-${PKG_VER_MESA}:=[-vulkan]
		    >=media-libs/vulkan-loader-${VULKAN_SDK_VER} )
         wayland? ( >=dev-libs/wayland-${PKG_VER_LIBWAYLAND} )
	 X? (
	 || ( >=sys-fs/udev-183 virtual/libudev )
	 hwe? (
		>=x11-base/xorg-drivers-1.20
		<x11-base/xorg-drivers-1.21
		>=x11-base/xorg-server-1.20[-minimal,glamor(+)]
		<x11-base/xorg-server-1.21[-minimal,glamor(+)]
	 )
	 !hwe? (
		>=x11-base/xorg-drivers-1.19
		<x11-base/xorg-drivers-1.20
		>=x11-base/xorg-server-1.19[-minimal,glamor(+)]
		<x11-base/xorg-server-1.20[-minimal,glamor(+)]
	 )
	 >=sys-libs/libselinux-1.32[${MULTILIB_USEDEP}]
	   x11-base/xorg-proto
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
		CHECKREQS_DISK_BUILD="1697M"
		CHECKREQS_DISK_USR="1614M"
	else
		CHECKREQS_DISK_BUILD="1697M"
		CHECKREQS_DISK_USR="1614M"
	fi
}

pkg_nofetch() {
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	einfo "Please download"
	einfo "  - ${FN}"
	einfo "from ${HOMEPAGE} and place them in ${distdir}"
}

unpack_deb() {
	echo ">>> Unpacking ${1##*/} to ${PWD}"
	unpack $1
	unpacker ./data.tar*
	rm -f debian-binary {control,data}.tar*
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

	if use opengl_mesa ; then
		ewarn "The opengl_mesa USE flag is still broken."
	fi

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
	unpack_deb "${d_debs}/amdgpu-doc_${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${archall}.deb"
	if use X ; then
		unpack_deb "${d_debs}/libgl1-amdgpu-mesa-dri_${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
		unpack_deb "${d_debs}/libgbm1-amdgpu_${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
		unpack_deb "${d_debs}/libglapi-amdgpu-mesa_${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
	fi
}

src_unpack_open_stack() {
	unpack_deb "${d_debs}/amdgpu-core_${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${archall}.deb"
	if [[ "${ABI}" == "amd64" ]] ; then
		unpack_deb "${d_debs}/amdgpu_${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.deb"
		unpack_deb "${d_debs}/amdgpu-lib32_${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.deb"
		if use hwe ; then
			unpack_deb "${d_debs}/amdgpu-hwe_${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.deb"
			unpack_deb "${d_debs}/amdgpu-lib-hwe_${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.deb"
		fi
	fi

	unpack_deb "${d_debs}/libdrm-amdgpu-amdgpu1_${PKG_VER_LIBDRM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
	unpack_deb "${d_debs}/libdrm-amdgpu-common_${PKG_VER_ID}-${PKG_REV}${PKG_ARCH_SUFFIX}${archall}.deb"
	! use system-llvm && use developer && \
	unpack_deb "${d_debs}/libdrm-amdgpu-dev_${PKG_VER_LIBDRM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
	unpack_deb "${d_debs}/libdrm-amdgpu-radeon1_${PKG_VER_LIBDRM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
	unpack_deb "${d_debs}/libdrm-amdgpu-utils_${PKG_VER_LIBDRM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
	unpack_deb "${d_debs}/libdrm2-amdgpu_${PKG_VER_LIBDRM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"

	# vdpau and mesa-amdgpu are consumers of llvm
	# The Internal LLVM9 is required since Gentoo is missing the
	# shared libLLVM-9.so with -DLLVM_BUILD_LLVM_DYLIB=ON that is
	# enabled on >=llvm-10.  Gentoo only use split llvm libraries
	# but the driver components use the shared.
	! use system-llvm && unpack_deb "${d_debs}/libllvm${PKG_VER_LLVM}-amdgpu_${PKG_VER_LLVM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
	if ! use system-llvm && use developer ; then
		unpack_deb "${d_debs}/llvm-amdgpu-${PKG_VER_LLVM}-dev_${PKG_VER_LLVM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
		unpack_deb "${d_debs}/llvm-amdgpu-${PKG_VER_LLVM}-runtime_${PKG_VER_LLVM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
		unpack_deb "${d_debs}/llvm-amdgpu-${PKG_VER_LLVM}_${PKG_VER_LLVM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
		unpack_deb "${d_debs}/llvm-amdgpu-dev_${PKG_VER_LLVM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
		unpack_deb "${d_debs}/llvm-amdgpu-runtime_${PKG_VER_LLVM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
		unpack_deb "${d_debs}/llvm-amdgpu_${PKG_VER_LLVM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
	fi

	if use egl ; then
		unpack_deb "${d_debs}/libegl1-amdgpu-mesa_${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
		use developer && \
		unpack_deb "${d_debs}/libegl1-amdgpu-mesa-dev_${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
		unpack_deb "${d_debs}/libegl1-amdgpu-mesa-drivers_${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
		if use gles2 ; then
			unpack_deb "${d_debs}/libgles1-amdgpu-mesa_${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
			use developer && \
			unpack_deb "${d_debs}/libgles1-amdgpu-mesa-dev_${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
			unpack_deb "${d_debs}/libgles2-amdgpu-mesa_${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
			use developer && \
			unpack_deb "${d_debs}/libgles2-amdgpu-mesa-dev_${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
		fi
	fi

	use X && use developer && \
	unpack_deb "${d_debs}/libgbm-amdgpu-dev_${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"

	if use glamor ; then
		if [[ "${ABI}" == "amd64" ]] ; then
			unpack_deb "${d_debs}/glamor-amdgpu_${PKG_VER_GLAMOR}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
			use developer && \
			unpack_deb "${d_debs}/glamor-amdgpu-dev_${PKG_VER_GLAMOR}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
		fi
	fi

	use X && use developer && \
	unpack_deb "${d_debs}/mesa-amdgpu-common-dev_${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"

	if use opengl_mesa ; then
		unpack_deb "${d_debs}/libgl1-amdgpu-mesa-glx_${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
		use developer && \
		unpack_deb "${d_debs}/libgl1-amdgpu-mesa-dev_${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
	fi

	if use osmesa ; then
		unpack_deb "${d_debs}/libosmesa6-amdgpu_${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
		use developer && \
		unpack_deb "${d_debs}/libosmesa6-amdgpu-dev_${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
	fi

	if use xa ; then
		unpack_deb "${d_debs}/libxatracker2-amdgpu_${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
		use developer && \
		unpack_deb "${d_debs}/libxatracker-amdgpu-dev_${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
	fi

	if use openmax ; then
		unpack_deb "${d_debs}/gst-omx-amdgpu_${PKG_VER_GST_OMX}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
		unpack_deb "${d_debs}/mesa-amdgpu-omx-drivers_${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
	fi

	if use vaapi ; then
		unpack_deb "${d_debs}/mesa-amdgpu-va-drivers_${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
	fi

	if use vdpau ; then
		unpack_deb "${d_debs}/mesa-amdgpu-vdpau-drivers_${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
	fi

	if use vulkan_open ; then
		unpack_deb "${d_debs}/vulkan-amdgpu_${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.deb"
	fi

	if use X ; then
		if [[ "${ABI}" == "amd64" ]] ; then
			if use hwe ; then
				unpack_deb "${d_debs}/xserver-xorg-hwe-amdgpu-video-amdgpu_${PKG_VER_XORG_VIDEO_AMDGPU_DRV}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
			else
				unpack_deb "${d_debs}/xserver-xorg-amdgpu-video-amdgpu_${PKG_VER_XORG_VIDEO_AMDGPU_DRV}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.deb"
			fi
		fi
		# no x86 ABI
	fi
}

src_unpack_pro_stack() {
	unpack_deb "${d_debs}/amdgpu-pro-core_${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${archall}.deb"
	if [[ "${ABI}" == "amd64" ]] ; then
		unpack_deb "${d_debs}/amdgpu-pro_${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.deb"
		unpack_deb "${d_debs}/amdgpu-pro-lib32_${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.deb"
		if use hwe ; then
			unpack_deb "${d_debs}/amdgpu-pro-hwe_${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.deb"
		fi
	fi
	unpack_deb "${d_debs}/amdgpu-pro-pin_${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${archall}.deb"

	if use X ; then
		unpack_deb "${d_debs}/libglapi1-amdgpu-pro_${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.deb"
	fi

	if use amf ; then
		if [[ "${ABI}" == "amd64" ]] ; then
			unpack_deb "${d_debs}/amf-amdgpu-pro_${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.deb"
		fi
	fi

	if use egl && ! use opengl_mesa ; then
		unpack_deb "${d_debs}/libegl1-amdgpu-pro_${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.deb"
		if use gles2 ; then
			unpack_deb "${d_debs}/libgles2-amdgpu-pro_${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.deb"
		fi
	fi

	if use opencl_pal ; then
		if [[ "${ABI}" == "amd64" ]] ; then
			unpack_deb "${d_debs}/opencl-amdgpu-pro-comgr_${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.deb"
		fi
	fi

	if use opencl ; then
		use opencl-icd-loader && \
		unpack_deb "${d_debs}/opencl-amdgpu-pro_${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.deb"
		if use opencl_orca ; then
			unpack_deb "${d_debs}/opencl-orca-amdgpu-pro-icd_${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.deb"
		fi
		if [[ "${ABI}" == "amd64" ]] ; then
			use clinfo && \
			unpack_deb "${d_debs}/clinfo-amdgpu-pro_${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.deb"
			if use opencl_pal ; then
				unpack_deb "${d_debs}/opencl-amdgpu-pro-icd_${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.deb"
			fi
			use developer && \
			unpack_deb "${d_debs}/opencl-amdgpu-pro-dev_${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.deb"
		fi
	fi

	if use opengl_pro ; then
		unpack_deb "${d_debs}/libgl1-amdgpu-pro-appprofiles_${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${archall}.deb"
		if use hwe ; then
			unpack_deb "${d_debs}/libgl1-amdgpu-pro-ext-hwe_${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.deb"
		else
			unpack_deb "${d_debs}/libgl1-amdgpu-pro-ext_${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.deb"
		fi
		unpack_deb "${d_debs}/libgl1-amdgpu-pro-dri_${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.deb"
		unpack_deb "${d_debs}/libgl1-amdgpu-pro-glx_${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.deb"
	fi

	if use rocm ; then
		if use developer ; then
			if use hip-clang ; then
				if [[ "${ABI}" == "amd64" ]] ; then
					unpack_deb "${d_debs}/hip-amdgpu-pro_${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.deb"
				fi
			fi
		fi
	fi

	if use vulkan_pro ; then
		unpack_deb "${d_debs}/vulkan-amdgpu-pro_${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.deb"
	fi
}

src_unpack() {
	default

	local archall="all"
	local d_debs="amdgpu-pro-${PKG_VER_STRING_DIR}"

	unpack_abi() {
		local arch
		local b

		if [[ "${ABI}" == "amd64" ]] ; then
			arch="amd64"
			b="64"
		elif [[ "${ABI}" == "x86" ]] ; then
			arch="i386"
			b="32"
		else
			die "arch not supported"
		fi

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

	# LDPATHs are already handled by eselect-opengl
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
		local chost="${arch}-linux-gnu"

		local sd_amdgpu="opt/amdgpu"
		local sd_amdgpupro="opt/amdgpu-pro"
		local dd_amdgpu="/usr/$(get_libdir)/opengl/amdgpu"
		local dd_amdgpupro="/usr/$(get_libdir)/opengl/amdgpu-pro"
		local od_amdgpu="/opt/amdgpu"
		local od_amdgpupro="/opt/amdgpu-pro"

		if use open-stack ; then
			chmod 0755 "${ED}/${od_amdgpu}/bin/"* || die
			chmod 0755 "${ED}/${od_amdgpu}/lib/${chost}/"*.so* || die
			if use vdpau ; then
				chmod 0755 "${ED}/${od_amdgpu}/lib/${chost}/vdpau/"*.so* || die
			fi
			! use system-llvm && \
			chmod 0755 "${ED}/${od_amdgpu}/lib/${chost}/llvm-${PKG_VER_LLVM}/lib/"*.so* || die
			if ! use system-llvm && use developer ; then
				chmod 0755 "${ED}/${od_amdgpu}/lib/${chost}/llvm-${PKG_VER_LLVM}/bin/"* || die
				chmod 0755 "${ED}/${od_amdgpu}/lib/${chost}/llvm-${PKG_VER_LLVM}/share/opt-viewer/"*.py || die
			fi
			if use open-stack && ( use X || use hwe ) ; then
				chmod 0755 "${ED}/${od_amdgpu}/lib/xorg/modules/drivers/"*.so* || die
			fi
			if use glamor ; then
				chmod 0755 "${ED}/${od_amdgpu}/lib/xorg/modules/"*.so* || die
			fi
			if use openmax ; then
				chmod 0755 "${ED}/${od_amdgpu}/lib/libomxil-bellagio0/"*.so* || die
				chmod 0755 "${ED}/${od_amdgpu}/lib/${chost}/gstreamer-${PKG_VER_GST}/libgstomx.so" || die
			fi
			if use opengl_mesa ; then
				dosym libGL.so.1.2.0 ${od_amdgpu}/lib/${chost}/libGL.so
			fi
			if use vulkan_open ; then
				insinto /etc/vulkan/icd.d
				doins opt/amdgpu/etc/vulkan/icd.d/amd_icd${b}.json
			fi
		fi

		if use pro-stack ; then
			chmod 0755 "${ED}/${od_amdgpupro}/lib/${chost}/"*.so* || die
			if use opengl_pro ; then
				chmod 0755 "${ED}/${od_amdgpu}/lib/${chost}/dri/"*.so* || die
				dosym ../../../../../usr/lib/${chost}/dri/amdgpu_dri.so \
					${od_amdgpu}/lib/${chost}/dri/amdgpu_dri.so
				chmod 0755 "${ED}/${od_amdgpupro}/lib/xorg/modules/extensions/"*.so* || die
				insinto /usr/lib/${chost}/dri
				doins usr/lib/${chost}/dri/amdgpu_dri.so
				chmod 0755 "${ED}/usr/lib/${chost}/dri/amdgpu_dri.so" || die
				cp -a "${ED}/${od_amdgpu}/lib/${chost}/"libgbm* \
					"${ED}/${od_amdgpupro}/lib/${chost}" || die
				dosym ../../../../../usr/lib/${chost}/dri/amdgpu_dri.so \
					${od_amdgpupro}/lib/${chost}/dri/amdgpu_dri.so
			fi

			if use opencl ; then
				if use clinfo ; then
					chmod 0755 "${ED}/${od_amdgpupro}/bin/"* || die
				fi
				if has_version 'app-eselect/eselect-opencl' ; then
					dosym ../../../../../opt/amdgpu-pro/lib/${chost}/libOpenCL.so.1 \
						/usr/$(get_libdir)/OpenCL/vendors/amdgpu-pro/libOpenCL.so.1
					dosym ../../../../../opt/amdgpu-pro/lib/${chost}/libOpenCL.so \
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

	if ! use system-llvm && use open-stack && use developer ; then
		insinto /usr/share/binfmts
		doins usr/share/binfmts/llvm-amdgpu-${PKG_VER_LLVM}-runtime.binfmt
	fi

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
	local libva_drivers_path="/opt/amdgpu/lib/x86_64-linux-gnu/dri"
	local libvdpau_drivers_path="/opt/amdgpu/lib/x86_64-linux-gnu/vdpau"

	if use vaapi ; then
		cat <<-EOF > "${T}"/50${P}-vaapi
			LIBVA_DRIVERS_PATH="${libva_drivers_path}"
			LIBVA_DRIVER_NAME="${vaapi_drv_name}"
		EOF
		doenvd "${T}"/50${P}-vaapi
	fi

	if use vdpau ; then
		cat <<-EOF > "${T}"/50${P}-vdpau
			VDPAU_DRIVER_PATH="${libvdpau_drivers_path}"
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

	if ! use system-llvm ; then
		ewarn \
"You must manually set LD_LIBRARY_PATH=\"/opt/amdgpu-pro/lib/x86_64-linux-gnu:/opt/amdgpu/lib/x86_64-linux-gnu:/opt/amdgpu-pro/lib/i386-linux-gnu:/opt/amdgpu/lib/i386-linux-gnu\"\n
whenever VA-API, VDPAU, XA (libxatracker) are being used."
	fi
}

#1234567890123456789012345678901234567890123456789012345678901234567890123456789
