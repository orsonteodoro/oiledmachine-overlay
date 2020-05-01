# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Radeon™ Software for Linux®"
HOMEPAGE=\
"https://www.amd.com/en/support/kb/release-notes/rn-rad-lin-19-30-unified"
LICENSE="AMD GPL-2 QPL-1.0"
KEYWORDS="~amd64 ~x86"
MULTILIB_COMPAT=( abi_x86_{32,64} )
inherit check-reqs linux-info multilib-build unpacker rpm
PKG_VER=$(ver_cut 1-2)
PKG_VER_MAJ=$(ver_cut 1)
PKG_REV=$(ver_cut 3)
PKG_ARCH="rhel"
PKG_ARCH_VER="8"
PKG_ARCH_VER_MAJOR=$(ver_cut 1 ${PKG_ARCH_VER})
PKG_ARCH_SUFFIX=".el${PKG_ARCH_VER_MAJOR}."
PKG_VER_GCC="8.2.1"
PKG_VER_GST_OMX="1.0.0.1"
PKG_VER_HSAKMT="1.0.6"
PKG_VER_HSAKMT_A="1.0.9"
PKG_VER_ID="1.0.0"
PKG_VER_LIBDRM="2.4.98"
PKG_VER_LIBWAYLAND="1.15.0"
PKG_VER_LLVM_TRIPLE="9.0.0"
PKG_VER_LLVM=$(ver_cut 1-2 ${PKG_VER_LLVM_TRIPLE})
PKG_VER_LLVM_MAJ=$(ver_cut 1 ${PKG_VER_LLVM_TRIPLE})
PKG_VER_MESA="19.2.0"
PKG_VER_STRING=${PKG_VER}-${PKG_REV}
PKG_VER_STRING_DIR=${PKG_VER_STRING}-${PKG_ARCH}-${PKG_ARCH_VER}
PKG_VER_VA="1.8.3"
PKG_VER_WAYLAND_PROTO="1.17"
PKG_VER_WAYLAND="1.15.0"
PKG_VER_XORG_VIDEO_AMDGPU_DRV="19.0.1" # about the same as the mesa version
VULKAN_SDK_VER="1.1.109.0"
FN="amdgpu-pro-${PKG_VER_STRING}-${PKG_ARCH}-${PKG_ARCH_VER}.tar.xz"
SRC_URI="https://www2.ati.com/drivers/linux/${PKG_ARCH}/${FN}"
RESTRICT="fetch strip"
IUSE="developer dkms +egl +gles2 freesync hip-clang lf +open-stack +opencl \
opencl_orca opencl_pal +opengl +pro-stack roct +vaapi +vdpau +vulkan wayland"
SLOT="1"

# The x11-base/xorg-server-<ver> must match this drivers version or this error
# will be produced:
# modules abi version 23 doesn't match the server version 24
#
# For more info on VIDEODRV see https://www.x.org/wiki/XorgModuleABIVersions/
# sys-libs/ncurses[tinfo] required by llvm in this package

#	>=sys-devel/lld-7.0.0
#	>=sys-devel/llvm-7.0.0
# libglapi.so.0 needs libselinux
# requires >=dkms-1.95
RDEPEND="!x11-drivers/amdgpu-pro
	  app-eselect/eselect-opencl
	 >=app-eselect/eselect-opengl-1.0.7
	 >=dev-util/cunit-2.1_p3
	 >=dev-libs/libedit-3.1
	 dkms? ( || ( sys-kernel/amdgpu-dkms sys-kernel/rock-dkms ) )
	 freesync? ( || (
		>=sys-kernel/amdgpu-dkms-18.50
		>=sys-kernel/aufs-sources-5.0
		>=sys-kernel/ck-sources-5.0
		>=sys-kernel/git-sources-5.0
		>=sys-kernel/gentoo-sources-5.0
		>=sys-kernel/hardened-sources-5.0
		>=sys-kernel/pf-sources-5.0
		>=sys-kernel/rock-dkms-2.0.0
		>=sys-kernel/rt-sources-5.0
		>=sys-kernel/vanilla-sources-5.0
		>=sys-kernel/xbox-sources-5.0
		>=sys-kernel/zen-sources-5.0 ) )
	 || (
		>=sys-kernel/amdgpu-dkms-${PV}
		>=sys-kernel/aufs-sources-5.4
		>=sys-kernel/ck-sources-5.4
		>=sys-kernel/gentoo-sources-5.4
		>=sys-kernel/git-sources-5.4
		>=sys-kernel/hardened-sources-5.4
		>=sys-kernel/pf-sources-5.4
		>=sys-kernel/rock-dkms-2.8.0
		>=sys-kernel/rt-sources-5.4
		>=sys-kernel/vanilla-sources-5.4
		>=sys-kernel/xbox-sources-5.4
		>=sys-kernel/zen-sources-5.4 )
	 || ( >=sys-firmware/amdgpu-firmware-${PV}
	        >=sys-firmware/rock-firmware-2.8.0
		>=sys-kernel/linux-firmware-20191113 )
	 opencl? ( >=sys-devel/gcc-${PKG_VER_GCC} )
	 opengl? ( >=sys-devel/gcc-${PKG_VER_GCC} )
	 roct? ( !dev-libs/roct-thunk-interface
		  sys-process/numactl )
	 >=sys-libs/libselinux-2.8
	   sys-libs/ncurses:0/6[tinfo,${MULTILIB_USEDEP}]
	   sys-libs/ncurses-compat:5[tinfo,${MULTILIB_USEDEP}]
	  vaapi? (  >=media-libs/mesa-${PKG_VER_MESA}[-vaapi] )
	  vdpau? (  >=media-libs/mesa-${PKG_VER_MESA}[-vdpau]
		    >=sys-devel/gcc-${PKG_VER_GCC} )
	 !vulkan? ( >=media-libs/mesa-${PKG_VER_MESA} )
	  vulkan? ( >=media-libs/mesa-${PKG_VER_MESA}[-vulkan]
		    >=media-libs/vulkan-loader-${VULKAN_SDK_VER}
		    >=sys-devel/gcc-${PKG_VER_GCC} )
         wayland? ( >=dev-libs/wayland-${PKG_VER_LIBWAYLAND}
		    dev-libs/libffi:0/6 )
	 >=x11-base/xorg-drivers-1.20
	  <x11-base/xorg-drivers-1.21
	   x11-base/xorg-proto
	 >=x11-base/xorg-server-1.20[-minimal,glamor(+)]
	 >=x11-libs/libdrm-${PKG_VER_LIBDRM}[libkms]
	   x11-libs/libX11[${MULTILIB_USEDEP}]
	   x11-libs/libXext[${MULTILIB_USEDEP}]
	   x11-libs/libXinerama[${MULTILIB_USEDEP}]
	   x11-libs/libXrandr[${MULTILIB_USEDEP}]
	   x11-libs/libXrender[${MULTILIB_USEDEP}]"
# hsakmt requires libnuma.so.1
# kmstest requires libkms
# amdgpu_dri.so requires wayland?
# vdpau requires llvm
S="${WORKDIR}"
REQUIRED_USE="opencl? ( || ( opencl_pal opencl_orca ) )
	opencl_pal? ( opencl )
	opencl_orca? ( opencl )
	roct? ( dkms )"

_set_check_reqs_requirements() {
	if use abi_x86_32 && use abi_x86_64 ; then
		CHECKREQS_DISK_BUILD="991M"
		CHECKREQS_DISK_USR="901M"
	else
		CHECKREQS_DISK_BUILD="991M"
		CHECKREQS_DISK_USR="901M"
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
	#unpacker ./data.tar*
	#rm -f debian-binary {control,data}.tar*
}

pkg_pretend() {
	_set_check_reqs_requirements
	check-reqs_pkg_setup
}

pkg_setup() {
	if ! grep -q -e "Added amdgpu-pro, amdgpu-pro-lts support" \
		"${EROOT}/usr/share/eselect/modules/opengl.eselect" ; then
		die "You need eselect-opengl from the oiledmachine-overlay."
	fi

	if [ ! -L /lib64/libedit.so.2 ] ; then
		einfo \
"You need to do \`ln -s /lib64/libedit.so.0 /lib64/libedit.so.2\`"
		die
	fi

	if use open-stack ; then
		ewarn "open-stack (with Mesa OpenGL) is still WIP"
	fi

	CONFIG_CHECK="~DRM_AMDGPU"

	WARNING_DRM_AMDGPU=\
"The CONFIG_DRM_AMDGPU kernel option is required for FreeSync or AMDGPU-PRO\n\
driver to work"

	linux-info_pkg_setup

	if use opencl_orca ; then
		einfo \
"OpenCL orca is being used. You are enabling the older legacy OpenCL driver\n\
implementation used by older fglrx."
	fi

	if use roct ; then
		ewarn "ROCt has not been tested"
		ewarn \
"It's recommended to use the dev-libs/roct-thunk-interface package instead of\n\
the roct USE flag."
	fi

	_set_check_reqs_requirements
	check-reqs_pkg_setup
}

src_unpack_open_stack() {
	unpack_rpm "${d_rpms}/amdgpu-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"

	unpack_rpm "${d_rpms}/drm-utils-amdgpu-${PKG_VER_LIBDRM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"

	unpack_rpm "${d_rpms}/libdrm-amdgpu-${PKG_VER_LIBDRM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
	unpack_rpm "${d_noarch}/libdrm-amdgpu-common-${PKG_VER_ID}-${PKG_REV}${PKG_ARCH_SUFFIX}${noarch}.rpm"
	use developer && \
	unpack_rpm "${d_rpms}/libdrm-amdgpu-devel-${PKG_VER_LIBDRM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"

	unpack_rpm "${d_rpms}/libgbm-amdgpu-pro-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
	use developer && \
	unpack_rpm "${d_rpms}/libgbm-amdgpu-pro-devel-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"

	# vdpau and mesa-amdgpu are consumers of llvm
	# The Internal LLVM9 is required since Gentoo is missing the
	# shared libLLVM-9.so with -DLLVM_BUILD_LLVM_DYLIB=ON that is
	# enabled on >=llvm-10.  Gentoo only use split llvm libraries
	# but the driver components use the shared.
	unpack_rpm "${d_rpms}/llvm${PKG_VER_LLVM/\./}-amdgpu-${PKG_VER_LLVM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
	use developer && \
	unpack_rpm "${d_rpms}/llvm${PKG_VER_LLVM/\./}-amdgpu-devel-${PKG_VER_LLVM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
	unpack_rpm "${d_rpms}/llvm-amdgpu-${PKG_VER_LLVM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
	unpack_rpm "${d_rpms}/llvm-amdgpu-libs-${PKG_VER_LLVM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
	unpack_rpm "${d_rpms}/llvm-amdgpu-static-${PKG_VER_LLVM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
	use developer && \
	unpack_rpm "${d_rpms}/llvm-amdgpu-devel-${PKG_VER_LLVM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"

	if use opengl ; then
		unpack_rpm "${d_rpms}/mesa-amdgpu-dri-drivers-${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		unpack_rpm "${d_rpms}/mesa-amdgpu-libEGL-${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		use developer && \
		unpack_rpm "${d_rpms}/mesa-amdgpu-libEGL-devel-${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		unpack_rpm "${d_rpms}/mesa-amdgpu-libGL-${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		use developer && \
		unpack_rpm "${d_rpms}/mesa-amdgpu-libGL-devel-${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		unpack_rpm "${d_rpms}/mesa-amdgpu-libGLES-${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		use developer && \
		unpack_rpm "${d_rpms}/mesa-amdgpu-libGLES-devel-${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		unpack_rpm "${d_rpms}/mesa-amdgpu-libOSMesa-${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		use developer && \
		unpack_rpm "${d_rpms}/mesa-amdgpu-libOSMesa-devel-${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		unpack_rpm "${d_rpms}/mesa-amdgpu-libgbm-${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		use developer && \
		unpack_rpm "${d_rpms}/mesa-amdgpu-libgbm-devel-${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		unpack_rpm "${d_rpms}/mesa-amdgpu-libglapi-${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		unpack_rpm "${d_rpms}/mesa-amdgpu-libxatracker-${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		use developer && \
		unpack_rpm "${d_rpms}/mesa-amdgpu-libxatracker-devel-${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
	fi

	if use vaapi ; then
		unpack_rpm "${d_rpms}/libva-amdgpu-${PKG_VER_VA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		use developer && \
		unpack_rpm "${d_rpms}/libva-amdgpu-devel-${PKG_VER_VA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		# The VA-API driver is in the dri package.
	fi

	if use vdpau ; then
		unpack_rpm "${d_rpms}/mesa-amdgpu-vdpau-drivers-${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
	fi

	if use vulkan ; then
		unpack_rpm "${d_rpms}/vulkan-amdgpu-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
	fi

	if use wayland ; then
		unpack_rpm "${d_rpms}/libwayland-amdgpu-client-${PKG_VER_LIBWAYLAND}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		unpack_rpm "${d_rpms}/libwayland-amdgpu-egl-${PKG_VER_LIBWAYLAND}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		unpack_rpm "${d_rpms}/libwayland-amdgpu-server-${PKG_VER_LIBWAYLAND}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		unpack_rpm "${d_rpms}/libwayland-amdgpu-cursor-${PKG_VER_LIBWAYLAND}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		unpack_rpm "${d_noarch}/wayland-amdgpu-doc-${PKG_VER_WAYLAND}-${PKG_REV}${PKG_ARCH_SUFFIX}${noarch}.rpm"
		use developer && \
		unpack_rpm "${d_noarch}/wayland-protocols-amdgpu-devel-${PKG_VER_WAYLAND_PROTO}-${PKG_REV}${PKG_ARCH_SUFFIX}${noarch}.rpm"
	fi

	unpack_rpm "${d_rpms}/xorg-x11-amdgpu-drv-amdgpu-${PKG_VER_XORG_VIDEO_AMDGPU_DRV}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"

}

src_unpack_pro_stack() {
	unpack_rpm "${d_rpms}/amdgpu-pro-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
	unpack_rpm "${d_noarch}/amdgpu-pro-core-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${noarch}.rpm"
	unpack_rpm "${d_rpms}/amdgpu-pro-versionlist-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"

	if use egl ; then
		unpack_rpm "${d_rpms}/libegl-amdgpu-pro-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
	fi

	if use gles2 ; then
		unpack_rpm "${d_rpms}/libgles-amdgpu-pro-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
	fi

	if use hip-clang ; then
		if [[ "${ABI}" == "amd64" ]] ; then
			unpack_rpm "${d_rpms}/hip-amdgpu-pro-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
		fi
	fi

	if use opencl ; then
		if [[ "${ABI}" == "amd64" ]] ; then
			unpack_rpm "${d_rpms}/clinfo-amdgpu-pro-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
		fi
		unpack_rpm "${d_rpms}/libopencl-amdgpu-pro-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
		unpack_rpm "${d_rpms}/opencl-amdgpu-pro-comgr-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
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

	if use opengl ; then
		unpack_rpm "${d_rpms}/libgl-amdgpu-pro-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
		unpack_rpm "${d_noarch}/libgl-amdgpu-pro-appprofiles-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${noarch}.rpm"
		unpack_rpm "${d_rpms}/libgl-amdgpu-pro-ext-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
		unpack_rpm "${d_rpms}/libgl-amdgpu-pro-dri-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
		unpack_rpm "${d_rpms}/libglapi-amdgpu-pro-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
	fi

	if use roct ; then
		if [[ "${ABI}" == "amd64" ]] ; then
			unpack_rpm "${d_rpms}/roct-amdgpu-pro-${PKG_VER_HSAKMT_A}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
			use developer && \
			unpack_rpm "${d_rpms}/roct-amdgpu-pro-devel-${PKG_VER_HSAKMT_A}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		fi
	fi

	if use vulkan ; then
		unpack_rpm "${d_rpms}/vulkan-amdgpu-pro-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
	fi
}

src_unpack() {
	default

	local noarch="noarch"
	local d_noarch="amdgpu-pro-${PKG_VER_STRING_DIR}/RPMS/${noarch}"

	unpack_rpm "${d_noarch}/amdgpu-doc-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${noarch}.rpm"

	unpack_abi() {
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
}

src_install() {
	insinto /etc/X11/xorg.conf.d/
	doins "${T}/10-screen.conf"
	doins "${T}/10-monitor.conf"
	doins "${T}/10-device.conf"

	insinto /lib/udev/rules.d
	doins lib/udev/rules.d/91-amdgpu-pro-modeset.rules

	#rm etc/ld.so.conf.d/10-amdgpu-pro-x86_64.conf || die
	insinto /
	doins -r etc
	doins -r opt

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
			chmod 0755 "${ED}/${od_amdgpu}/lib${b}/vdpau/"*.so* || die
			chmod 0755 "${ED}/${od_amdgpu}/lib${b}/llvm-9.0/lib/"*.so* || die
			chmod 0755 "${ED}/${od_amdgpu}/lib${b}/llvm-9.0/bin/"* || die
			if [[ -d "${ED}/${od_amdgpu}/lib${b}/llvm-9.0/share/opt-viewer" ]] ; then
				chmod 0755 "${ED}/${od_amdgpu}/lib${b}/llvm-9.0/share/opt-viewer/"*.py || die
			fi
			chmod 0755 "${ED}/${od_amdgpu}/lib${b}/xorg/modules/drivers/"*.so* || die
			chmod 0755 "${ED}/${od_amdgpu}/lib${b}/dri/"*.so* || die
			dosym ../../../../../usr/lib${b}/dri/amdgpu_dri.so ${od_amdgpu}/lib${b}/dri/amdgpu_dri.so
			dosym libGL.so.1.2.0 ${od_amdgpu}/lib${b}/libGL.so
		fi

		if use pro-stack ; then
			chmod 0755 "${ED}/${od_amdgpupro}/bin/"* || die
			chmod 0755 "${ED}/${od_amdgpupro}/lib${b}/"*.so* || die
			chmod 0755 "${ED}/${od_amdgpupro}/lib${b}/xorg/modules/extensions/"*.so* || die
			chmod 0755 "${ED}/${od_amdgpupro}/lib${b}/gbm/"*.so* || die
			insinto /usr/lib64/dri
			doins usr/lib64/dri/amdgpu_dri.so
			chmod 0755 "${ED}/usr/lib64/dri/amdgpu_dri.so" || die
			cp -a "${ED}/${od_amdgpu}/lib${b}/"libgbm* \
				"${ED}/${od_amdgpupro}/lib${b}" || die
#			cp -a "${ED}/${od_amdgpu}/lib${b}/"llvm-${PKG_VER_LLVM} \
#				"${ED}/${od_amdgpupro}/lib${b}" || die
#			cp -a "${ED}/${od_amdgpu}/lib${b}/"libLLVM*.so* \
#				"${ED}/${od_amdgpupro}/lib${b}" || die
#			cp -a "${ED}/${od_amdgpu}/lib${b}/"libLTO.so* \
#				"${ED}/${od_amdgpupro}/lib${b}" || die
#			cp -a "${ED}/${od_amdgpu}/lib${b}/"libRemarks.so* \
#				"${ED}/${od_amdgpupro}/lib${b}" || die
			dosym ../../../../../usr/lib${b}/dri/amdgpu_dri.so ${od_amdgpupro}/lib${b}/dri/amdgpu_dri.so

			if use roct ; then
				if [[ "${ABI}" == "amd64" ]] ; then
					sed -i -e "s|/opt/rocm|/${sd_amdgpupro}|g" \
						"${ED}/${od_amdgpupro}/lib${b}/pkgconfig/libhsakmt.pc" || die
					sed -i -e "s|//${sd_amdgpupro}/lib${b}|/lib${b}|g" \
						"${ED}/${od_amdgpupro}/lib${b}/pkgconfig/libhsakmt.pc" || die
				fi
				# no x86 abi
			fi
		fi
	}

	multilib_foreach_abi install_abi

	# Link for hardcoded path
	dosym /usr/share/libdrm/amdgpu.ids \
		/opt/amdgpu/share/libdrm/amdgpu.ids

	docinto docs
	dodoc -r usr/share/doc/*
	docinto licenses
	dodoc -r usr/share/licenses/*
	doman usr/share/man/man7/amdgpu-doc.7.gz

	if use vdpau ; then
		cat <<-EOF > "${T}"/50${P}-vdpau
			LDPATH=\
"/opt/amdgpu-pro/lib64/vdpau"
		EOF
		doenvd "${T}"/50${P}-vdpau
	fi
}

pkg_prerm() {
	if use opengl ; then
		"${EROOT}"/usr/bin/eselect opengl set xorg-x11
	fi

	if use opencl ; then
		if "${EROOT}"/usr/bin/eselect opencl list | grep mesa ; then
			"${EROOT}"/usr/bin/eselect opencl set --use-old mesa
		fi
	fi
}

pkg_postinst() {
	if use opengl ; then
		"${EROOT}"/usr/bin/eselect opengl set amdgpu-pro
	fi

	if use opencl ; then
		"${EROOT}"/usr/bin/eselect opencl set --use-old amdgpu
	fi

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
}

#1234567890123456789012345678901234567890123456789012345678901234567890123456789
