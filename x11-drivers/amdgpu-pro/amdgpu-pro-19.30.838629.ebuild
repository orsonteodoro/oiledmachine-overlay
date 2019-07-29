# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MULTILIB_COMPAT=( abi_x86_{32,64} )
inherit multilib-build unpacker linux-info

DESCRIPTION="Radeon™ Software for Linux® 19.30 for Radeon RX 5700 Series"
HOMEPAGE="https://www.amd.com/zh-hant/support/kb/release-notes/rn-amdgpu-unified-navi-linux"
PKG_VER=${PV:0:5}
PKG_VER_MAJ=${PV:0:2}
PKG_REV=${PV:6:6}
PKG_ARCH="ubuntu"
PKG_ARCH_VER="18.04"
PKG_VER_STRING=${PKG_VER}-${PKG_REV}
PKG_VER_STRING_DIR=${PKG_VER}-${PKG_REV}-${PKG_ARCH}-${PKG_ARCH_VER}
PKG_VER_LIBDRM="2.4.98"
PKG_VER_MESA="19.2.0"
PKG_VER_HSA="1.1.6"
PKG_VER_ROCT="1.0.9"
PKG_VER_XORG_VIDEO_AMDGPU_DRV="19.0.1" # about the same as the mesa version
PKG_VER_AMF="1.4.12"
PKG_VER_ID="1.0.0"
PKG_VER_LLVM="9.0"
PKG_VER_LLVM_MAJ="9"
PKG_VER_LLVM_TRIPLE="9.0.0"
PKG_VER_LIBWAYLAND="1.15.0"
PKG_VER_WAYLAND_PROTO="1.16"
PKG_VER_GLAMOR="1.19.0"
FN="amdgpu-pro-${PKG_VER_STRING}-${PKG_ARCH}-${PKG_ARCH_VER}.tar.xz"
SRC_URI="https://www2.ati.com/drivers/linux/${PKG_ARCH}/${FN}"

RESTRICT="fetch strip"

IUSE="+amf +egl +gles2 freesync hsa +opencl +opengl orca pal +vaapi vega +vdpau +vulkan wayland"

LICENSE="AMD GPL-2 QPL-1.0"
KEYWORDS="~amd64 ~x86"
SLOT="1"

# The x11-base/xorg-server-<ver> must match this drivers version or this error will be produced:
# modules abi version 23 doesn't match the server version 24
#
# For more info on VIDEODRV see https://www.x.org/wiki/XorgModuleABIVersions/
# sys-libs/ncurses[tinfo] required by llvm in this package

# roct-thunk-interface (aka hsa) is outdated

#	>=sys-devel/lld-7.0.0
#	>=sys-devel/llvm-7.0.0
# libglapi.so.0 needs libselinux
RDEPEND="
	hsa? ( sys-process/numactl
	       !dev-libs/roct-thunk-interface )
	sys-libs/ncurses[tinfo]
	dev-libs/libedit
	>=sys-libs/libselinux-1.32
	>=app-eselect/eselect-opengl-1.0.7
	app-eselect/eselect-opencl
	dev-util/cunit
	>=media-libs/gst-plugins-base-1.6.0[${MULTILIB_USEDEP}]
	>=media-libs/gstreamer-1.6.0[${MULTILIB_USEDEP}]
	!vulkan? ( >=media-libs/mesa-${PKG_VER_MESA} )
	vulkan? ( >=media-libs/mesa-${PKG_VER_MESA}[-vulkan]
		  media-libs/vulkan-loader )
	opencl? ( >=sys-devel/gcc-5.2.0 )
	vdpau? ( >=media-libs/mesa-${PKG_VER_MESA}[-vdpau] )
	>=x11-base/xorg-drivers-1.19
	<x11-base/xorg-drivers-1.20
	>=x11-base/xorg-server-1.19[glamor]
	>=x11-libs/libdrm-${PKG_VER_LIBDRM}[libkms]
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libXext[${MULTILIB_USEDEP}]
	x11-libs/libXinerama[${MULTILIB_USEDEP}]
	x11-libs/libXrandr[${MULTILIB_USEDEP}]
	x11-libs/libXrender[${MULTILIB_USEDEP}]
	x11-base/xorg-proto
	freesync? ( || (   sys-kernel/ot-sources
			 >=sys-kernel/git-sources-5.0_rc1
			 >=sys-kernel/gentoo-sources-5.0
			 >=sys-kernel/vanilla-sources-5.0 ) )
"
#hsakmt requires libnuma.so.1
#kmstest requires libkms
#amdgpu_dri.so requires wayland?
#vdpau requires llvm7

DEPEND="
	>=sys-kernel/linux-firmware-20161205
"

S="${WORKDIR}"
REQUIRED_USE="|| ( pal orca )" #incomplete
#!hsa

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

pkg_setup() {
	ewarn "This package is compatible for only the Radeon RX 5700 series only.  Other products are not supported."

	if [ ! -L /lib64/libedit.so.2 ] ; then
		einfo "You need to do \`ln -s /lib64/libedit.so.0 /lib64/libedit.so.2\`"
		die
	fi

	CONFIG_CHECK="~DRM_AMDGPU"

	ERROR_KERNEL_DRM_AMDGPU="DRM_AMDGPU which is required for FreeSync or AMDGPU-PRO driver to work"

	linux-info_pkg_setup

	if use pal ; then
		einfo "OpenCL PAL (Portable Abstraction Layer) being used.  It is only supported by GCN 5.x (Vega).  It is still in development."
	fi

	if use orca ; then
		einfo "OpenCL orca is being used. You are enabling the older legacy OpenCL driver implementation used by older fglrx."
	fi

	if use hsa ; then
		# remove if it works and been tested on hsa hardware
		eerror "hsa not supported and not tested"
	fi
}

src_unpack() {
	default

	unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libgl1-amdgpu-pro-appprofiles_${PKG_VER_STRING}_all.deb"

	if use abi_x86_64 ; then
		unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libdrm-amdgpu-utils_${PKG_VER_LIBDRM}-${PKG_REV}_amd64.deb"

		if use opencl ; then
			# Install clinfo
			unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/clinfo-amdgpu-pro_${PKG_VER_STRING}_amd64.deb"

			# Install OpenCL components
			unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libopencl1-amdgpu-pro_${PKG_VER_STRING}_amd64.deb"
			if use pal ; then
				unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/opencl-amdgpu-pro-icd_${PKG_VER_STRING}_amd64.deb"
			fi

			if use orca ; then
				unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/opencl-orca-amdgpu-pro-icd_${PKG_VER_STRING}_amd64.deb"
			fi

			unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/roct-amdgpu-pro_${PKG_VER_ROCT}-${PKG_REV}_amd64.deb"
			unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/roct-amdgpu-pro-dev_${PKG_VER_ROCT}-${PKG_REV}_amd64.deb"
		fi

		if use opengl ; then
			# Install OpenGL
			unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libgl1-amdgpu-pro-glx_${PKG_VER_STRING}_amd64.deb"
			unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libgl1-amdgpu-pro-ext_${PKG_VER_STRING}_amd64.deb"
			mv opt/amdgpu-pro/lib/xorg/modules/extensions/libglx.so opt/amdgpu-pro/lib/xorg/modules/extensions/libglx64.so || die
			unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libgl1-amdgpu-pro-dri_${PKG_VER_STRING}_amd64.deb"

			# Install GBM
			unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libgbm1-amdgpu-pro_${PKG_VER_STRING}_amd64.deb"

			unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libglapi1-amdgpu-pro_${PKG_VER}-${PKG_REV}_amd64.deb"
			unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libglapi-amdgpu-mesa_${PKG_VER_MESA}-${PKG_REV}_amd64.deb"
		fi

		if use gles2 ; then
			# Install GLES2
			unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libgles2-amdgpu-pro_${PKG_VER_STRING}_amd64.deb"
		fi

		if use egl ; then
			# Install EGL libs
			unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libegl1-amdgpu-pro_${PKG_VER_STRING}_amd64.deb"
		fi

		if use vulkan ; then
			# Install Vulkan driver
			unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/vulkan-amdgpu-pro_${PKG_VER_STRING}_amd64.deb"
		fi

		if use vdpau ; then
			# Install VDPAU
			unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/mesa-amdgpu-vdpau-drivers_${PKG_VER_MESA}-${PKG_REV}_amd64.deb"
		fi

		if use vaapi ; then
			# Install Mesa VA-API video acceleration drivers
			unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/mesa-amdgpu-va-drivers_${PKG_VER_MESA}-${PKG_REV}_amd64.deb"
		fi

		if use amf ; then
			# Install AMDGPU Pro Advanced Multimedia Framework
			unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/amf-amdgpu-pro_${PKG_VER_AMF}-${PKG_REV}_amd64.deb"
		fi

		unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libdrm-amdgpu-amdgpu1_${PKG_VER_LIBDRM}-${PKG_REV}_amd64.deb"
		unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libdrm-amdgpu-radeon1_${PKG_VER_LIBDRM}-${PKG_REV}_amd64.deb"

		unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/glamor-amdgpu_${PKG_VER_GLAMOR}-${PKG_REV}_amd64.deb"
		mv opt/amdgpu/lib/xorg/modules/libglamoregl.so opt/amdgpu/lib/xorg/modules/libglamoregl64.so || die

		# Install xorg drivers
		unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/xserver-xorg-amdgpu-video-amdgpu_${PKG_VER_XORG_VIDEO_AMDGPU_DRV}-${PKG_REV}_amd64.deb"
		mv opt/amdgpu/lib/xorg/modules/drivers/amdgpu_drv.so opt/amdgpu/lib/xorg/modules/drivers/amdgpu_drv64.so || die

		# Internal LLVM7 required since Gentoo is missing the shared libLLVM-7.so .  Gentoo only use split llvm libraries but the driver components use the shared.
		unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libllvm${PKG_VER_LLVM}-amdgpu_${PKG_VER_LLVM}-${PKG_REV}_amd64.deb"
		#unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/llvm-amdgpu-${PKG_VER_LLVM}_${PKG_VER_LLVM}-${PKG_REV}_amd64.deb"
		#unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/llvm-amdgpu-${PKG_VER_LLVM}-runtime_${PKG_VER_LLVM}-${PKG_REV}_amd64.deb"

		unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libwayland-amdgpu-client0_${PKG_VER_LIBWAYLAND}-${PKG_REV}_amd64.deb"
		unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libwayland-amdgpu-egl1_${PKG_VER_LIBWAYLAND}-${PKG_REV}_amd64.deb"
		unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libwayland-amdgpu-server0_${PKG_VER_LIBWAYLAND}-${PKG_REV}_amd64.deb"
		#unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libwayland-amdgpu-cursor0_${PKG_VER_LIBWAYLAND}-${PKG_REV}_amd64.deb"
		#unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libwayland-amdgpu-dev_${PKG_VER_LIBWAYLAND}-${PKG_REV}_amd64.deb"
	fi

	if use abi_x86_32 ; then
		unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libdrm-amdgpu-utils_${PKG_VER_LIBDRM}-${PKG_REV}_i386.deb"

		if use opencl ; then
			# Install OpenCL components
			if use orca ; then
				unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/opencl-orca-amdgpu-pro-icd_${PKG_VER_STRING}_i386.deb"
			fi

			unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libopencl1-amdgpu-pro_${PKG_VER_STRING}_i386.deb"
			#unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/opencl-amdgpu-pro-icd_${PKG_VER_STRING}_i386.deb" fixme
		fi

		if use opengl ; then
			unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libgl1-amdgpu-pro-glx_${PKG_VER_STRING}_i386.deb"
			unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libgl1-amdgpu-pro-ext_${PKG_VER_STRING}_i386.deb"
			mv opt/amdgpu-pro/lib/xorg/modules/extensions/libglx.so opt/amdgpu-pro/lib/xorg/modules/extensions/libglx32.so || die
			unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libgl1-amdgpu-pro-dri_${PKG_VER_STRING}_i386.deb"

			# Install GBM
			unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libgbm1-amdgpu-pro_${PKG_VER_STRING}_i386.deb"

			unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libglapi1-amdgpu-pro_${PKG_VER}-${PKG_REV}_i386.deb"
			unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libglapi-amdgpu-mesa_${PKG_VER_MESA}-${PKG_REV}_i386.deb"
		fi

		if use gles2 ; then
			unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libgles2-amdgpu-pro_${PKG_VER_STRING}_i386.deb"
		fi

		if use egl ; then
			# Install EGL libs
			unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libegl1-amdgpu-pro_${PKG_VER_STRING}_i386.deb"
		fi

		if use vulkan ; then
			unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/vulkan-amdgpu-pro_${PKG_VER_STRING}_i386.deb"
		fi

		if use vdpau ; then
			# Install VDPAU
			unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/mesa-amdgpu-vdpau-drivers_${PKG_VER_MESA}-${PKG_REV}_i386.deb"
		fi

		if use vaapi ; then
			# Install Mesa VA-API video acceleration drivers
			unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/mesa-amdgpu-va-drivers_${PKG_VER_MESA}-${PKG_REV}_i386.deb"
		fi

		unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libdrm-amdgpu-amdgpu1_${PKG_VER_LIBDRM}-${PKG_REV}_i386.deb"
		unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libdrm-amdgpu-radeon1_${PKG_VER_LIBDRM}-${PKG_REV}_i386.deb"

		unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/glamor-amdgpu_${PKG_VER_GLAMOR}-${PKG_REV}_i386.deb"
		mv opt/amdgpu/lib/xorg/modules/libglamoregl.so opt/amdgpu/lib/xorg/modules/libglamoregl32.so || die

		# Install xorg drivers
		unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/xserver-xorg-amdgpu-video-amdgpu_${PKG_VER_XORG_VIDEO_AMDGPU_DRV}-${PKG_REV}_i386.deb"
		mv opt/amdgpu/lib/xorg/modules/drivers/amdgpu_drv.so opt/amdgpu/lib/xorg/modules/drivers/amdgpu_drv32.so || die

		# Internal LLVM7 required since Gentoo is missing the shared libLLVM-7.so .  Gentoo only use split llvm libraries but the driver components use the shared.
		unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libllvm${PKG_VER_LLVM}-amdgpu_${PKG_VER_LLVM}-${PKG_REV}_i386.deb"
		##unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/llvm-amdgpu-${PKG_VER_LLVM}-runtime_${PKG_VER_LLVM}-${PKG_REV}_i386.deb"
		##unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/llvm-amdgpu_${PKG_VER_LLVM}-${PKG_REV}_i386.deb"
		#unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/llvm-amdgpu-runtime_${PKG_VER_LLVM}-${PKG_REV}_i386.deb"

		unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libwayland-amdgpu-client0_${PKG_VER_LIBWAYLAND}-${PKG_REV}_i386.deb"
		unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libwayland-amdgpu-egl1_${PKG_VER_LIBWAYLAND}-${PKG_REV}_i386.deb"
		unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libwayland-amdgpu-server0_${PKG_VER_LIBWAYLAND}-${PKG_REV}_i386.deb"
		#unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libwayland-amdgpu-cursor0_${PKG_VER_LIBWAYLAND}-${PKG_REV}_i386.deb"
		#unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libwayland-amdgpu-dev_${PKG_VER_LIBWAYLAND}-${PKG_REV}_i386.deb"
	fi

	if use opengl ; then
		unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libgbm1-amdgpu-pro-base_${PKG_VER_STRING}_all.deb"
	fi

	# Pin version (contains version requirements)
	unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/amdgpu-pro-pin_${PKG_VER}-${PKG_REV}_all.deb"

	unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libdrm-amdgpu-common_${PKG_VER_ID}-${PKG_REV}_all.deb"

	#unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/libwayland-amdgpu-doc_${PKG_VER_LIBWAYLAND}-${PKG_REV}_all.deb"
	#unpack_deb "amdgpu-pro-${PKG_VER_STRING_DIR}/wayland-protocols-amdgpu_${PKG_VER_WAYLAND_PROTO}-${PKG_REV}_all.deb"

	# todo dev use flag
echo << EOF > /dev/null
./glamor-amdgpu-dev_1.19.0-708488_i386.deb : glamor-amdgpu-dev
./glamor-amdgpu-dev_1.19.0-708488_amd64.deb : glamor-amdgpu-dev
./libdrm-amdgpu-dev_2.4.95-708488_i386.deb  : libdrm-amdgpu-dev
./libdrm-amdgpu-dev_2.4.95-708488_amd64.deb : libdrm-amdgpu-dev
./libegl1-amdgpu-mesa-dev_18.2.0-708488_amd64.deb : libegl1-amdgpu-mesa-dev
./libegl1-amdgpu-mesa-dev_18.2.0-708488_i386.deb : libegl1-amdgpu-mesa-dev
./libgbm-amdgpu-dev_18.2.0-708488_i386.deb : libgbm-amdgpu-dev
./libgbm-amdgpu-dev_18.2.0-708488_amd64.deb : libgbm-amdgpu-dev
./libgbm1-amdgpu-pro-dev_18.50-708488_amd64.deb : libgbm1-amdgpu-pro-dev
./libgbm1-amdgpu-pro-dev_18.50-708488_i386.deb : libgbm1-amdgpu-pro-dev
./libgl1-amdgpu-mesa-dev_18.2.0-708488_amd64.deb : libgl1-amdgpu-mesa-dev
./libgl1-amdgpu-mesa-dev_18.2.0-708488_i386.deb : libgl1-amdgpu-mesa-dev
./libgles1-amdgpu-mesa-dev_18.2.0-708488_amd64.deb : libgles1-amdgpu-mesa-dev
./libgles1-amdgpu-mesa-dev_18.2.0-708488_i386.deb : libgles1-amdgpu-mesa-dev
./libgles2-amdgpu-mesa-dev_18.2.0-708488_amd64.deb : libgles2-amdgpu-mesa-dev
./libgles2-amdgpu-mesa-dev_18.2.0-708488_i386.deb : libgles2-amdgpu-mesa-dev
./libosmesa6-amdgpu-dev_18.2.0-708488_amd64.deb : libosmesa6-amdgpu-dev
./libosmesa6-amdgpu-dev_18.2.0-708488_i386.deb : libosmesa6-amdgpu-dev
./libwayland-amdgpu-dev_1.15.0-708488_amd64.deb : libwayland-amdgpu-dev
./libwayland-amdgpu-dev_1.15.0-708488_i386.deb : libwayland-amdgpu-dev
./libxatracker-amdgpu-dev_18.2.0-708488_amd64.deb : libxatracker-amdgpu-dev
./libxatracker-amdgpu-dev_18.2.0-708488_i386.deb : libxatracker-amdgpu-dev
./llvm-amdgpu-7.0-dev_7.0-708488_i386.deb : llvm-amdgpu-7.0-dev
./llvm-amdgpu-7.0-dev_7.0-708488_amd64.deb : llvm-amdgpu-7.0-dev
./llvm-amdgpu-dev_7.0-708488_amd64.deb : llvm-amdgpu-dev
./llvm-amdgpu-dev_7.0-708488_i386.deb : llvm-amdgpu-dev
./mesa-amdgpu-common-dev_18.2.0-708488_i386.deb : mesa-amdgpu-common-dev
./mesa-amdgpu-common-dev_18.2.0-708488_amd64.deb : mesa-amdgpu-common-dev
./opencl-amdgpu-pro-dev_18.50-708488_amd64.deb : opencl-amdgpu-pro-dev
./roct-amdgpu-pro-dev_1.0.9-708488_amd64.deb : roct-amdgpu-pro-dev
EOF
}

src_prepare() {
	cat << EOF > "${T}/91-drm_pro-modeset.rules" || die
KERNEL=="controlD[0-9]*", SUBSYSTEM=="drm", MODE="0600"
EOF

	cat << EOF > "${T}/01-amdgpu.conf" || die
/usr/$(get_libdir)/gbm
/usr/lib32/gbm
EOF

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

	if use vulkan ; then
		cat << EOF > "${T}/amd_icd64.json" || die
{
   "file_format_version": "1.0.0",
	   "ICD": {
		   "library_path": "/usr/$(get_libdir)/vulkan/vendors/amdgpu/amdvlk64.so",
		   "abi_versions": "0.9.0"
	   }
}
EOF

		if use abi_x86_32 ; then
			cat << EOF > "${T}/amd_icd32.json" || die
{
   "file_format_version": "1.0.0",
	   "ICD": {
		   "library_path": "/usr/lib32/vulkan/vendors/amdgpu/amdvlk32.so",
		   "abi_versions": "0.9.0"
	   }
}
EOF
		fi
	fi

	if use opengl ; then
		if use abi_x86_32 ; then
			# todo 32 bit version
			ewarn "20-opengl.conf not tested for abi_x86_32 abi"
			cat << EOF > "${T}/20-opengl.conf" || die
Section "OutputClass"
        Identifier "AMDgpu"
        MatchDriver "amdgpu"
        Driver "amdgpu"
EndSection

Section "Files"
	ModulePath "/usr/lib64/opengl/amdgpu-pro/modules"
	ModulePath "/usr/lib64/opengl/amdgpu-pro"
	ModulePath "/usr/lib64/opengl/amdgpu/modules"
	ModulePath "/usr/lib64/opengl/amdgpu"
	ModulePath "/usr/lib64/xorg/modules"
	ModulePath "/usr/lib32/opengl/amdgpu-pro/modules"
	ModulePath "/usr/lib32/opengl/amdgpu-pro"
	ModulePath "/usr/lib32/opengl/amdgpu/modules"
	ModulePath "/usr/lib32/opengl/amdgpu"
	ModulePath "/usr/lib32/xorg/modules"
EndSection
EOF
			cat << EOF > "${T}/000opengl"
# Generated by amdgpu-pro
LDPATH="/usr/lib64/opengl/amdgpu-pro/lib:/usr/lib64/opengl/amdgpu-pro:/usr/lib64/opengl/amdgpu/lib:/usr/lib64/opengl/amdgpu:/usr/lib32/opengl/amdgpu-pro/lib:/usr/lib32/opengl/amdgpu-pro:/usr/lib32/opengl/amdgpu/lib:/usr/lib32/opengl/amdgpu"
OPENGL_PROFILE="amdgpu"
EOF
		else
			cat << EOF > "${T}/20-opengl.conf" || die
Section "OutputClass"
        Identifier "AMDgpu"
        MatchDriver "amdgpu"
        Driver "amdgpu"
EndSection

Section "Files"
	ModulePath "/usr/lib64/opengl/amdgpu-pro/modules"
	ModulePath "/usr/lib64/opengl/amdgpu-pro"
	ModulePath "/usr/lib64/opengl/amdgpu/modules"
	ModulePath "/usr/lib64/opengl/amdgpu"
	ModulePath "/usr/lib64/xorg/modules"
EndSection
EOF
			cat << EOF > "${T}/000opengl"
# Generated by amdgpu-pro
LDPATH="/usr/lib64/opengl/amdgpu-pro/lib:/usr/lib64/opengl/amdgpu-pro:/usr/lib64/opengl/amdgpu/lib:/usr/lib64/opengl/amdgpu"
OPENGL_PROFILE="amdgpu"
EOF
		fi
	fi

	eapply_user
}

src_install() {
	#insinto /etc/env.d/
	#doins "${T}/000opengl"
	insinto /lib/udev/rules.d/
	doins "${T}/91-drm_pro-modeset.rules"
	insinto /etc/ld.so.conf.d/
	doins "${T}/01-amdgpu.conf"
	insinto /etc/X11/xorg.conf.d/
	doins "${T}/10-screen.conf"
	doins "${T}/10-monitor.conf"
	doins "${T}/10-device.conf"
	#doins "${T}/20-opengl.conf"
	insinto /etc/amd/
	doins etc/amd/amdapfxx.blb

	into /usr/
	cd opt/amdgpu/bin/
	dobin amdgpu_test
	dobin kms-steal-crtc
	dobin kmstest
	dobin kms-universal-planes
	dobin modeprint
	dobin modetest
	dobin proptest
	dobin vbltest
	cd ../../..

	if use opencl ; then
		if use abi_x86_64 ; then
			# Install clinfo
			insinto /usr/bin
			dobin opt/amdgpu-pro/bin/clinfo
		fi

		# Install OpenCL components
		if use abi_x86_64 ; then
			insinto /etc/OpenCL/vendors/
			if use pal ; then
				doins etc/OpenCL/vendors/amdocl64.icd
			fi

			if use orca ; then
				doins etc/OpenCL/vendors/amdocl-orca64.icd

				exeinto /usr/lib64/OpenCL/vendors/amdgpu/
				doexe opt/amdgpu-pro/lib/x86_64-linux-gnu/libamdocl12cl64.so
				doexe opt/amdgpu-pro/lib/x86_64-linux-gnu/libamdocl-orca64.so
			fi

			exeinto /usr/lib64/OpenCL/vendors/amdgpu/
			doexe opt/amdgpu-pro/lib/x86_64-linux-gnu/libOpenCL.so.1
			dosym libOpenCL.so.1 /usr/lib64/OpenCL/vendors/amdgpu/libOpenCL.so
		fi
		if use abi_x86_32 ; then
			insinto /etc/OpenCL/vendors/
			if use pal ; then
				#doins etc/OpenCL/vendors/amdocl32.icd #fixme
				true
			fi

			if use orca ; then
				doins etc/OpenCL/vendors/amdocl-orca32.icd

				exeinto /usr/lib32/OpenCL/vendors/amdgpu/
				doexe opt/amdgpu-pro/lib/i386-linux-gnu/libamdocl12cl32.so
				doexe opt/amdgpu-pro/lib/i386-linux-gnu/libamdocl-orca32.so
			fi

			exeinto /usr/lib32/OpenCL/vendors/amdgpu/
			doexe opt/amdgpu-pro/lib/i386-linux-gnu/libOpenCL.so.1
			dosym libOpenCL.so.1 /usr/lib32/OpenCL/vendors/amdgpu/libOpenCL.so
		fi
	fi

	if use hsa ; then
		if use abi_x86_64 ; then
			exeinto /usr/lib64/opengl/amdgpu/lib/
			doexe opt/amdgpu-pro/lib/x86_64-linux-gnu/libhsakmt.so.1.0.0
			dosym libhsakmt.so.1.0.0 /usr/lib64/opengl/amdgpu/lib/libhsakmt.so.1.0
			dosym libhsakmt.so.1.0.0 /usr/lib64/opengl/amdgpu/lib/libhsakmt.so.1
			dosym libhsakmt.so.1.0.0 /usr/lib64/opengl/amdgpu/lib/libhsakmt.so

			insinto /usr/include/libhsakmt/
			doins opt/amdgpu-pro/include/hsakmttypes.h
			doins opt/amdgpu-pro/include/hsakmt.h

			insinto /usr/include/libhsakmt/linux/
			doins opt/amdgpu-pro/include/linux/kfd_ioctl.h

			insinto /usr/lib64/pkgconfig/
			sed -i -e "s|/opt/rocm||g" opt/amdgpu-pro/lib/x86_64-linux-gnu/pkgconfig/libhsakmt.pc
			sed -i -e "s|//opt/amdgpu-pro/lib/x86_64-linux-gnu|/usr/lib64/opengl/amdgpu/lib/|g" opt/amdgpu-pro/lib/x86_64-linux-gnu/pkgconfig/libhsakmt.pc
			sed -i -e "s|/include|/usr/include/libhsakmt/|g" opt/amdgpu-pro/lib/x86_64-linux-gnu/pkgconfig/libhsakmt.pc
			doins opt/amdgpu-pro/lib/x86_64-linux-gnu/pkgconfig/libhsakmt.pc
		fi
		# no x86 abi
	fi

	if use vulkan ; then
		# Install Vulkan driver
		insinto /etc/vulkan/icd.d/
		if use abi_x86_64 ; then
			doins "${T}/amd_icd64.json"
			exeinto /usr/lib64/vulkan/vendors/amdgpu/
			doexe opt/amdgpu-pro/lib/x86_64-linux-gnu/amdvlk64.so
		fi
		if use abi_x86_32 ; then
			doins "${T}/amd_icd32.json"
			exeinto /usr/lib32/vulkan/vendors/amdgpu/
			doexe opt/amdgpu-pro/lib/i386-linux-gnu/amdvlk32.so
		fi
	fi

	if use opengl ; then
		# Install OpenGL
		if use abi_x86_64 ; then
			exeinto /usr/lib64/opengl/amdgpu/lib/
			doexe opt/amdgpu/lib/x86_64-linux-gnu/libdrm_amdgpu.so.1.0.0
			dosym libdrm_amdgpu.so.1.0.0 /usr/lib64/opengl/amdgpu/lib/libdrm_amdgpu.so.1
			dosym libdrm_amdgpu.so.1.0.0 /usr/lib64/opengl/amdgpu/lib/libdrm_amdgpu.so
			doexe opt/amdgpu-pro/lib/x86_64-linux-gnu/libGL.so.1.2
			dosym libGL.so.1.2 /usr/lib64/opengl/amdgpu/lib/libGL.so.1
			dosym libGL.so.1.2 /usr/lib64/opengl/amdgpu/lib/libGL.so
			exeinto /usr/lib64/opengl/radeon/lib/
			doexe opt/amdgpu/lib/x86_64-linux-gnu/libdrm_radeon.so.1.0.1
			dosym libdrm_radeon.so.1.0.1 /usr/lib64/opengl/radeon/lib/libdrm_radeon.so.1
			dosym libdrm_radeon.so.1.0.1 /usr/lib64/opengl/radeon/lib/libdrm_radeon.so
			exeinto /usr/lib64/opengl/amdgpu/extensions/
			mv opt/amdgpu-pro/lib/xorg/modules/extensions/libglx64.so opt/amdgpu-pro/lib/xorg/modules/extensions/libglx.so
			doexe opt/amdgpu-pro/lib/xorg/modules/extensions/libglx.so
			exeinto /usr/lib64/opengl/amdgpu/dri/
			doexe usr/lib/x86_64-linux-gnu/dri/amdgpu_dri.so
			dosym ../opengl/amdgpu/dri/amdgpu_dri.so /usr/lib64/dri/amdgpu_dri.so
			dosym ../../opengl/amdgpu/dri/amdgpu_dri.so /usr/lib64/x86_64-linux-gnu/dri/amdgpu_dri.so

			# Install GBM
			exeinto /usr/lib64/opengl/amdgpu/lib/
			doexe opt/amdgpu-pro/lib/x86_64-linux-gnu/libgbm.so.1.0.0
			dosym libgbm.so.1.0.0 /usr/lib64/opengl/amdgpu/lib/libgbm.so.1
			dosym libgbm.so.1.0.0 /usr/lib64/opengl/amdgpu/lib/libgbm.so
			exeinto /usr/lib64/opengl/amdgpu/gbm/
			doexe opt/amdgpu-pro/lib/x86_64-linux-gnu/gbm/gbm_amdgpu.so
			dosym gbm_amdgpu.so /usr/lib64/opengl/amdgpu/gbm/libdummy.so
			dosym opengl/amdgpu/gbm /usr/lib64/gbm
		fi

		if use abi_x86_32 ; then
			# Install 32 bit OpenGL
			exeinto /usr/lib32/opengl/amdgpu/lib/
			doexe opt/amdgpu/lib/i386-linux-gnu/libdrm_amdgpu.so.1.0.0
			dosym libdrm_amdgpu.so.1.0.0 /usr/lib32/opengl/amdgpu/lib/libdrm_amdgpu.so.1
			dosym libdrm_amdgpu.so.1.0.0 /usr/lib32/opengl/amdgpu/lib/libdrm_amdgpu.so
			doexe opt/amdgpu-pro/lib/i386-linux-gnu/libGL.so.1.2
			dosym libGL.so.1.2 /usr/lib32/opengl/amdgpu/lib/libGL.so.1
			dosym libGL.so.1.2 /usr/lib32/opengl/amdgpu/lib/libGL.so
			exeinto /usr/lib32/opengl/radeon/lib/
			doexe opt/amdgpu/lib/i386-linux-gnu/libdrm_radeon.so.1.0.1
			dosym libdrm_radeon.so.1.0.1 /usr/lib32/opengl/radeon/lib/libdrm_radeon.so.1
			dosym libdrm_radeon.so.1.0.1 /usr/lib32/opengl/radeon/lib/libdrm_radeon.so
			exeinto /usr/lib32/opengl/amdgpu/extensions/
			mv opt/amdgpu-pro/lib/xorg/modules/extensions/libglx32.so opt/amdgpu-pro/lib/xorg/modules/extensions/libglx.so
			doexe opt/amdgpu-pro/lib/xorg/modules/extensions/libglx.so
			exeinto /usr/lib32/opengl/amdgpu/dri/
			doexe usr/lib/i386-linux-gnu/dri/amdgpu_dri.so
			dosym ../opengl/amdgpu/dri/amdgpu_dri.so /usr/lib32/dri/amdgpu_dri.so
			dosym ../../opengl/amdgpu/dri/amdgpu_dri.so /usr/lib64/i386-linux-gnu/dri/amdgpu_dri.so

			# Install GBM
			exeinto /usr/lib32/opengl/amdgpu/lib
			doexe opt/amdgpu-pro/lib/i386-linux-gnu/libgbm.so.1.0.0
			dosym libgbm.so.1.0.0 /usr/lib32/opengl/amdgpu/lib/libgbm.so.1
			dosym libgbm.so.1.0.0 /usr/lib32/opengl/amdgpu/lib/libgbm.so
			exeinto /usr/lib32/opengl/amdgpu/gbm/
			doexe opt/amdgpu-pro/lib/i386-linux-gnu/gbm/gbm_amdgpu.so
			dosym gbm_amdgpu.so /usr/lib32/opengl/amdgpu/gbm/libdummy.so
			dosym opengl/amdgpu/gbm /usr/lib32/gbm
		fi

		insinto /etc/amd/
		doins etc/amd/amdrc

		insinto /etc/gbm/
		doins etc/gbm/gbm.conf
	fi

	if use gles2 ; then
		# Install GLES2
		if use abi_x86_64 ; then
			exeinto /usr/lib64/opengl/amdgpu/lib/
			doexe opt/amdgpu-pro/lib/x86_64-linux-gnu/libGLESv2.so.2
			dosym libGLESv2.so.2 /usr/lib64/opengl/amdgpu/lib/libGLESv2.so
		fi
		if use abi_x86_32 ; then
			exeinto /usr/lib32/opengl/amdgpu/lib/
			doexe opt/amdgpu-pro/lib/i386-linux-gnu/libGLESv2.so.2
			dosym libGLESv2.so.2 /usr/lib32/opengl/amdgpu/lib/libGLESv2.so
		fi
	fi

	if use egl ; then
		# Install EGL libs
		if use abi_x86_64 ; then
			exeinto /usr/lib64/opengl/amdgpu/lib/
			doexe opt/amdgpu-pro/lib/x86_64-linux-gnu/libEGL.so.1
			dosym libEGL.so.1 /usr/lib64/opengl/amdgpu/lib/libEGL.so
		fi
		if use abi_x86_32 ; then
			exeinto /usr/lib32/opengl/amdgpu/lib/
			doexe opt/amdgpu-pro/lib/i386-linux-gnu/libEGL.so.1
			dosym libEGL.so.1 /usr/lib32/opengl/amdgpu/lib/libEGL.so
		fi
	fi

	if use vdpau ; then
		# Install VDPAU
		if use abi_x86_64 ; then
			exeinto /usr/lib64/opengl/amdgpu/vdpau/
			doexe opt/amdgpu/lib/x86_64-linux-gnu/vdpau/libvdpau_r300.so.1.0.0
			doexe opt/amdgpu/lib/x86_64-linux-gnu/vdpau/libvdpau_r600.so.1.0.0
			doexe opt/amdgpu/lib/x86_64-linux-gnu/vdpau/libvdpau_radeonsi.so.1.0.0
			dosym ../opengl/amdgpu/vdpau/libvdpau_r300.so.1.0.0 /usr/lib64/vdpau/libvdpau_r300.so.1.0.0
			dosym ../opengl/amdgpu/vdpau/libvdpau_r600.so.1.0.0 /usr/lib64/vdpau/libvdpau_r600.so.1.0.0
			dosym ../opengl/amdgpu/vdpau/libvdpau_radeonsi.so.1.0.0 /usr/lib64/vdpau/libvdpau_radeonsi.so.1.0.0
			dosym libvdpau_r300.so.1.0.0 /usr/lib64/vdpau/libvdpau_r300.so.1.0
			dosym libvdpau_r300.so.1.0.0 /usr/lib64/vdpau/libvdpau_r300.so.1
			dosym libvdpau_r300.so.1.0.0 /usr/lib64/vdpau/libvdpau_r300.so
			dosym libvdpau_r600.so.1.0.0 /usr/lib64/vdpau/libvdpau_r600.so.1.0
			dosym libvdpau_r600.so.1.0.0 /usr/lib64/vdpau/libvdpau_r600.so.1
			dosym libvdpau_r600.so.1.0.0 /usr/lib64/vdpau/libvdpau_r600.so
			dosym libvdpau_radeonsi.so.1.0.0 /usr/lib64/vdpau/libvdpau_radeonsi.so.1.0
			dosym libvdpau_radeonsi.so.1.0.0 /usr/lib64/vdpau/libvdpau_radeonsi.so.1
			dosym libvdpau_radeonsi.so.1.0.0 /usr/lib64/vdpau/libvdpau_radeonsi.so
		fi
		if use abi_x86_32 ; then
			exeinto /usr/lib32/opengl/amdgpu/vdpau/
			doexe opt/amdgpu/lib/i386-linux-gnu/vdpau/libvdpau_r300.so.1.0.0
			doexe opt/amdgpu/lib/i386-linux-gnu/vdpau/libvdpau_r600.so.1.0.0
			doexe opt/amdgpu/lib/i386-linux-gnu/vdpau/libvdpau_radeonsi.so.1.0.0
			dosym ../opengl/amdgpu/vdpau/libvdpau_r300.so.1.0.0 /usr/lib32/vdpau/libvdpau_r300.so.1.0.0
			dosym ../opengl/amdgpu/vdpau/libvdpau_r600.so.1.0.0 /usr/lib32/vdpau/libvdpau_r600.so.1.0.0
			dosym ../opengl/amdgpu/vdpau/libvdpau_radeonsi.so.1.0.0 /usr/lib32/vdpau/libvdpau_radeonsi.so.1.0.0
			dosym libvdpau_r300.so.1.0.0 /usr/lib32/vdpau/libvdpau_r300.so.1.0
			dosym libvdpau_r300.so.1.0.0 /usr/lib32/vdpau/libvdpau_r300.so.1
			dosym libvdpau_r300.so.1.0.0 /usr/lib32/vdpau/libvdpau_r300.so
			dosym libvdpau_r600.so.1.0.0 /usr/lib32/vdpau/libvdpau_r600.so.1.0
			dosym libvdpau_r600.so.1.0.0 /usr/lib32/vdpau/libvdpau_r600.so.1
			dosym libvdpau_r600.so.1.0.0 /usr/lib32/vdpau/libvdpau_r600.so
			dosym libvdpau_radeonsi.so.1.0.0 /usr/lib32/vdpau/libvdpau_radeonsi.so.1.0
			dosym libvdpau_radeonsi.so.1.0.0 /usr/lib32/vdpau/libvdpau_radeonsi.so.1
			dosym libvdpau_radeonsi.so.1.0.0 /usr/lib32/vdpau/libvdpau_radeonsi.so
		fi
	fi

	if use vaapi ; then
		if use abi_x86_64 ; then
			exeinto /usr/lib64/opengl/amdgpu/dri/
			doexe opt/amdgpu/lib/x86_64-linux-gnu/dri/radeonsi_drv_video.so
			doexe opt/amdgpu/lib/x86_64-linux-gnu/dri/r600_drv_video.so
		fi
		if use abi_x86_32 ; then
			exeinto /usr/lib32/opengl/amdgpu/dri/
			doexe opt/amdgpu/lib/i386-linux-gnu/dri/radeonsi_drv_video.so
			doexe opt/amdgpu/lib/i386-linux-gnu/dri/r600_drv_video.so
		fi
	fi

	# Install amf libraries
	if use amf ; then
		if use abi_x86_64 ; then
			exeinto /usr/lib64/opengl/amdgpu/lib
			doexe opt/amdgpu-pro/lib/x86_64-linux-gnu/libamfrt64.so.${PKG_VER}
			dosym libamfrt64.so.${PKG_VER} /usr/lib64/opengl/amdgpu/lib/libamfrt64.so.${PKG_VER_MAJ}
			dosym libamfrt64.so.${PKG_VER} /usr/lib64/opengl/amdgpu/lib/libamfrt64.so
			dosym libamfrt64.so.${PKG_VER} /usr/lib64/opengl/amdgpu/lib/libamfrt64.so.1 # from Gentoo QA notice when installing
		fi
	fi

	# Install glamor
	if use abi_x86_64 ; then
		exeinto /usr/lib64/opengl/amdgpu/
		mv opt/amdgpu/lib/xorg/modules/libglamoregl64.so opt/amdgpu/lib/xorg/modules/libglamoregl.so
		doexe opt/amdgpu/lib/xorg/modules/libglamoregl.so
	fi
	if use abi_x86_32 ; then
		exeinto /usr/lib64/opengl/amdgpu/
		mv opt/amdgpu/lib/xorg/modules/libglamoregl32.so opt/amdgpu/lib/xorg/modules/libglamoregl.so
		doexe opt/amdgpu/lib/xorg/modules/libglamoregl.so
	fi

	# Install libglapi
	if use abi_x86_64 ; then
		exeinto /usr/lib64/opengl/amdgpu/lib/
		doexe opt/amdgpu-pro/lib/x86_64-linux-gnu/libglapi.so.1
		dosym libglapi.so.1 /usr/lib64/opengl/amdgpu/lib/libglapi.so
		doexe opt/amdgpu/lib/x86_64-linux-gnu/libglapi.so.0.0.0
		dosym libglapi.so.0.0.0 /usr/lib64/opengl/amdgpu/lib/libglapi.so.0
	fi
	if use abi_x86_32 ; then
		exeinto /usr/lib32/opengl/amdgpu/lib/
		doexe opt/amdgpu-pro/lib/i386-linux-gnu/libglapi.so.1
		dosym libglapi.so.1 /usr/lib32/opengl/amdgpu/lib/libglapi.so
		doexe opt/amdgpu/lib/i386-linux-gnu/libglapi.so.0.0.0
		dosym libglapi.so.0.0.0 /usr/lib32/opengl/amdgpu/lib/libglapi.so.0
	fi

	# Install the shared LLVM libraries that Gentoo doesn't produce
	if use abi_x86_64 ; then
		exeinto /usr/lib64/opengl/amdgpu/lib/llvm-${PKG_VER_LLVM}/lib/
		#doexe opt/amdgpu/lib/x86_64-linux-gnu/llvm-${PKG_VER_LLVM}/lib/BugpointPasses.so
		doexe opt/amdgpu/lib/x86_64-linux-gnu/llvm-${PKG_VER_LLVM}/lib/libRemarks.so.${PKG_VER_LLVM_MAJ}
		doexe opt/amdgpu/lib/x86_64-linux-gnu/llvm-${PKG_VER_LLVM}/lib/libLLVM-${PKG_VER_LLVM_MAJ}.so
		doexe opt/amdgpu/lib/x86_64-linux-gnu/llvm-${PKG_VER_LLVM}/lib/libLTO.so.${PKG_VER_LLVM_MAJ}
		#doexe opt/amdgpu/lib/x86_64-linux-gnu/llvm-${PKG_VER_LLVM}/lib/LLVMHello.so
		#doexe opt/amdgpu/lib/x86_64-linux-gnu/llvm-${PKG_VER_LLVM}/lib/TestPlugin.so
		exeinto /usr/lib64/opengl/amdgpu/lib/
		local d="${EPREFIX}/usr/lib64/opengl/amdgpu/lib"
		local s="/usr/lib64/opengl/amdgpu/lib/llvm-${PKG_VER_LLVM}/lib"
		dosym "${s}"/libLTO.so.${PKG_VER_LLVM_MAJ} "${d}"/libLTO.so.${PKG_VER_LLVM_MAJ}
		dosym "${s}"/libLTO.so.${PKG_VER_LLVM_MAJ} "${s}"/libLTO.so.${PKG_VER_LLVM}
		#dosym "${s}"/BugpointPasses.so "${d}"/BugpointPasses.so
		dosym "${s}"/libRemarks.so.${PKG_VER_LLVM_MAJ} "${d}"/libRemarks.so.${PKG_VER_LLVM_MAJ}
		dosym "${s}"/libRemarks.so.${PKG_VER_LLVM_MAJ} "${s}"/libRemarks.so
		dosym "${s}"/libRemarks.so.${PKG_VER_LLVM_MAJ} "${d}"/libRemarks.so
		dosym "${s}"/libLTO.so.${PKG_VER_LLVM_MAJ} "${d}"/libLTO.so.${PKG_VER_LLVM_MAJ}
		dosym "${s}"/libLTO.so.${PKG_VER_LLVM} "${d}"/libLTO.so.${PKG_VER_LLVM}
		dosym "${s}"/libLLVM-${PKG_VER_LLVM_MAJ}.so "${d}"/libLLVM-${PKG_VER_LLVM_MAJ}.so
		dosym "${s}"/libLLVM-${PKG_VER_LLVM_MAJ}.so "${s}"/libLLVM-${PKG_VER_LLVM}.so
		dosym "${s}"/libLLVM-${PKG_VER_LLVM}.so "${d}"/libLLVM-${PKG_VER_LLVM}.so
		#dosym "${s}"/LLVMHello.so "${d}"/LLVMHello.so
		#dosym "${s}"/TestPlugin.so "${d}"/TestPlugin.so
	fi
	if use abi_x86_32 ; then
		exeinto /usr/lib32/opengl/amdgpu/lib/llvm-${PKG_VER_LLVM}/lib/
		#doexe opt/amdgpu/lib/i386-linux-gnu/llvm-${PKG_VER_LLVM}/lib/BugpointPasses.so
		doexe opt/amdgpu/lib/i386-linux-gnu/llvm-${PKG_VER_LLVM}/lib/libRemarks.so.${PKG_VER_LLVM_MAJ}
		doexe opt/amdgpu/lib/i386-linux-gnu/llvm-${PKG_VER_LLVM}/lib/libLLVM-${PKG_VER_LLVM_MAJ}.so
		doexe opt/amdgpu/lib/i386-linux-gnu/llvm-${PKG_VER_LLVM}/lib/libLTO.so.${PKG_VER_LLVM_MAJ}
		#doexe opt/amdgpu/lib/i386-linux-gnu/llvm-${PKG_VER_LLVM}/lib/LLVMHello.so
		#doexe opt/amdgpu/lib/i386-linux-gnu/llvm-${PKG_VER_LLVM}/lib/TestPlugin.so
		local d="${EPREFIX}/usr/lib32/opengl/amdgpu/lib"
		local s="/usr/lib32/opengl/amdgpu/lib/llvm-${PKG_VER_LLVM}/lib"
		dosym "${s}"/libLTO.so.${PKG_VER_LLVM_MAJ} "${d}"/libLTO.so.${PKG_VER_LLVM_MAJ}
		dosym "${s}"/libLTO.so.${PKG_VER_LLVM_MAJ} "${s}"/libLTO.so.${PKG_VER_LLVM}
		#dosym "${s}"/BugpointPasses.so "${d}"/BugpointPasses.so
		dosym "${s}"/libRemarks.so.${PKG_VER_LLVM_MAJ} "${d}"/libRemarks.so.${PKG_VER_LLVM_MAJ}
		dosym "${s}"/libRemarks.so.${PKG_VER_LLVM_MAJ} "${s}"/libRemarks.so
		dosym "${s}"/libRemarks.so.${PKG_VER_LLVM_MAJ} "${d}"/libRemarks.so
		dosym "${s}"/libLTO.so.${PKG_VER_LLVM_MAJ} "${d}"/libLTO.so.${PKG_VER_LLVM_MAJ}
		dosym "${s}"/libLTO.so.${PKG_VER_LLVM} "${d}"/libLTO.so.${PKG_VER_LLVM}
		dosym "${s}"/libLLVM-${PKG_VER_LLVM_MAJ}.so "${d}"/libLLVM-${PKG_VER_LLVM_MAJ}.so
		dosym "${s}"/libLLVM-${PKG_VER_LLVM_MAJ}.so "${s}"/libLLVM-${PKG_VER_LLVM}.so
		dosym "${s}"/libLLVM-${PKG_VER_LLVM}.so "${d}"/libLLVM-${PKG_VER_LLVM}.so
		#dosym "${s}"/LLVMHello.so "${d}"/LLVMHello.so
		#dosym "${s}"/TestPlugin.so "${d}"/TestPlugin.so
	fi

	# Install xorg drivers
	if use abi_x86_64 ; then
		exeinto /usr/lib64/opengl/amdgpu/modules/drivers/
		mv opt/amdgpu/lib/xorg/modules/drivers/amdgpu_drv64.so opt/amdgpu/lib/xorg/modules/drivers/amdgpu_drv.so || die
		doexe opt/amdgpu/lib/xorg/modules/drivers/amdgpu_drv.so
	fi
	if use abi_x86_32 ; then
		if use abi_x86_64 ; then
			true
		else
			# currently bugged when both are installed on amd64
			exeinto /usr/lib32/opengl/amdgpu/modules/drivers/
			mv opt/amdgpu/lib/xorg/modules/drivers/amdgpu_drv32.so opt/amdgpu/lib/xorg/modules/drivers/amdgpu_drv.so || die
			doexe opt/amdgpu/lib/xorg/modules/drivers/amdgpu_drv.so
		fi
	fi

	# Install wayland libraries.  Installing these are required.
	#if use wayland ; then
	if use abi_x86_64 ; then
		exeinto /usr/lib64/opengl/amdgpu/lib/
		doexe opt/amdgpu/lib/x86_64-linux-gnu/libwayland-client.so.0.3.0
		dosym libwayland-client.so.0.3.0 /usr/lib64/opengl/amdgpu/lib/libwayland-client.so.0
		doexe opt/amdgpu/lib/x86_64-linux-gnu/libwayland-server.so.0.1.0
		dosym libwayland-server.so.0.1.0 /usr/lib64/opengl/amdgpu/lib/libwayland-server.so.0
		doexe opt/amdgpu/lib/x86_64-linux-gnu/libwayland-egl.so.1.0.0
		dosym libwayland-egl.so.1.0.0 /usr/lib64/opengl/amdgpu/lib/libwayland-egl.so.1
	fi
	if use abi_x86_32 ; then
		exeinto /usr/lib32/opengl/amdgpu/lib/
		doexe opt/amdgpu/lib/i386-linux-gnu/libwayland-client.so.0.3.0
		dosym libwayland-client.so.0.3.0 /usr/lib32/opengl/amdgpu/lib/libwayland-client.so.0
		doexe opt/amdgpu/lib/i386-linux-gnu/libwayland-server.so.0.1.0
		dosym libwayland-server.so.0.1.0 /usr/lib32/opengl/amdgpu/lib/libwayland-server.so.0
		doexe opt/amdgpu/lib/i386-linux-gnu/libwayland-egl.so.1.0.0
		dosym libwayland-egl.so.1.0.0 /usr/lib32/opengl/amdgpu/lib/libwayland-egl.so.1
	fi
	#fi

	# TODO: install dev libraries if any

	# Link for hardcoded path
	dosym /usr/share/libdrm/amdgpu.ids /opt/amdgpu/share/libdrm/amdgpu.ids
}

pkg_prerm() {
	einfo "pkg_prerm"
	if use opengl ; then
		"${ROOT}"/usr/bin/eselect opengl set --use-old xorg-x11
	fi

	if use opencl ; then
		"${ROOT}"/usr/bin/eselect opencl set --use-old mesa
	fi
}

pkg_postinst() {
	einfo "pkg_postinst"
	if use opengl ; then
		"${ROOT}"/usr/bin/eselect opengl set --use-old amdgpu
	fi

	if use opencl ; then
		"${ROOT}"/usr/bin/eselect opencl set --use-old amdgpu
	fi

	if use freesync ; then
		einfo "Refer to https://support.amd.com/en-us/kb-articles/pages/how-to-enable-amd-freesync-in-linux.aspx"
		einfo "to enable FreeSync per each DisplayPort and to view the software supported by FreeSync."
		einfo "You must have VSync on to use FreeSync.  Modify /etc/amd/amdrc to turn on VSync."
	fi

	# remove generated by eselect-opengl
	#rm "${ROOT}"/etc/X11/xorg.conf.d/20opengl.conf > /dev/null
}
