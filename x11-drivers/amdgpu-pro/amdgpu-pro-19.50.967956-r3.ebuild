# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Radeon™ Software for Linux®"
HOMEPAGE=\
"https://www.amd.com/en/support/kb/release-notes/rn-rad-lin-19-50-unified"
LICENSE="AMD GPL-2 QPL-1.0"
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
PKG_VER_LIBDRM="2.4.99"
PKG_VER_LIBVA="1.8.3"
PKG_VER_LIBWAYLAND="1.15.0"
PKG_VER_LLVM_TRIPLE="9.0.0"
PKG_VER_LLVM=$(ver_cut 1-2 ${PKG_VER_LLVM_TRIPLE})
PKG_VER_LLVM_MAJ=$(ver_cut 1 ${PKG_VER_LLVM_TRIPLE})
PKG_VER_MESA="19.2.2"
PKG_VER_STRING=${PKG_VER}-${PKG_REV}
PKG_VER_STRING_DIR=${PKG_VER_STRING}-${PKG_ARCH}-${PKG_ARCH_VER}
PKG_VER_WAYLAND_PROTO="1.18"
PKG_VER_WAYLAND="1.15.0"
PKG_VER_XORG_VIDEO_AMDGPU_DRV="19.0.1" # about the same as the mesa version
VULKAN_SDK_VER="1.1.109.0"
FN="amdgpu-pro-${PKG_VER_STRING}-${PKG_ARCH}-${PKG_ARCH_VER}.tar.xz"
SRC_URI="https://www2.ati.com/drivers/linux/${PKG_ARCH}/${FN}"
RESTRICT="fetch strip"
IUSE="dkms +egl +gles2 freesync hip-clang +opencl \
opencl_orca opencl_pal +opengl roct +vdpau +vulkan \
wayland"
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
		>=sys-kernel/aufs-sources-5.5
		>=sys-kernel/ck-sources-5.5
		>=sys-kernel/gentoo-sources-5.5
		>=sys-kernel/git-sources-5.5
		>=sys-kernel/hardened-sources-5.5
		>=sys-kernel/pf-sources-5.5
		>=sys-kernel/rock-dkms-3.0.0
		>=sys-kernel/rt-sources-5.5
		>=sys-kernel/vanilla-sources-5.5
		>=sys-kernel/xbox-sources-5.5
		>=sys-kernel/zen-sources-5.5 )
	 || ( >=sys-firmware/amdgpu-firmware-${PV}
	        >=sys-firmware/rock-firmware-3.0.0
		>=sys-kernel/linux-firmware-20200309 )
	 opencl? ( >=sys-devel/gcc-${PKG_VER_GCC} )
	 opengl? ( >=sys-devel/gcc-${PKG_VER_GCC} )
	 roct? ( !dev-libs/roct-thunk-interface
		  sys-process/numactl )
	 >=sys-libs/libselinux-2.8
	   sys-libs/ncurses:0/6[tinfo,${MULTILIB_USEDEP}]
	   sys-libs/ncurses-compat:5[tinfo,${MULTILIB_USEDEP}]
	  vdpau? (  >=media-libs/mesa-${PKG_VER_MESA}[-vdpau]
		    >=sys-devel/gcc-${PKG_VER_GCC} )
	 !vulkan? ( >=media-libs/mesa-${PKG_VER_MESA} )
	  vulkan? ( >=media-libs/mesa-${PKG_VER_MESA}[-vulkan]
		    >=media-libs/vulkan-loader-${VULKAN_SDK_VER}
		    >=sys-devel/gcc-${PKG_VER_GCC} )
         wayland? ( >=dev-libs/wayland-${PKG_VER_LIBWAYLAND} )
	 >=x11-base/xorg-drivers-1.20
	  <x11-base/xorg-drivers-1.21
	   x11-base/xorg-proto
	 >=x11-base/xorg-server-1.20[-minimal,glamor(+)]
	 >=x11-libs/libdrm-${PKG_VER_LIBDRM}[libkms]
	   x11-libs/libX11[${MULTILIB_USEDEP}]
	   x11-libs/libXext[${MULTILIB_USEDEP}]
	   x11-libs/libXinerama[${MULTILIB_USEDEP}]
	   x11-libs/libXrandr[${MULTILIB_USEDEP}]
	   x11-libs/libXrender[${MULTILIB_USEDEP}]
	 || ( >=sys-firmware/amdgpu-firmware-${PKG_VER}
		sys-firmware/rock-firmware
		sys-kernel/linux-firmware )"
#	 >=media-libs/gst-plugins-base-1.6.0[${MULTILIB_USEDEP}]
#	 >=media-libs/gstreamer-1.6.0[${MULTILIB_USEDEP}]
# hsakmt requires libnuma.so.1
# kmstest requires libkms
# amdgpu_dri.so requires wayland?
# vdpau requires llvm7
S="${WORKDIR}"
REQUIRED_USE="opencl? ( || ( opencl_pal opencl_orca ) )
	opencl_pal? ( opencl )
	opencl_orca? ( opencl )
	roct? ( dkms )"

_set_check_reqs_requirements() {
	if use abi_x86_32 && use abi_x86_64 ; then
		CHECKREQS_DISK_BUILD="906M"
		CHECKREQS_DISK_USR="583M"
	else
		CHECKREQS_DISK_BUILD="644M"
		CHECKREQS_DISK_USR="296M"
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
		einfo \
"OpenCL PAL (Portable Abstraction Layer) being used.  It is only supported\n\
by GCN 5.x (Vega).  It is still in development."
	fi

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

src_unpack() {
	default

	local arch="noarch"
	local d_noarch="amdgpu-pro-${PKG_VER_STRING_DIR}/RPMS/${arch}"
	local d_rpms

	unpack_rpm "${d_noarch}/libgl-amdgpu-pro-appprofiles-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
	unpack_rpm "${d_noarch}/libdrm-amdgpu-common-${PKG_VER_ID}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
	unpack_rpm "${d_noarch}/amdgpu-doc-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
	unpack_rpm "${d_noarch}/wayland-amdgpu-doc-${PKG_VER_WAYLAND}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"

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

		d_rpms="amdgpu-pro-${PKG_VER_STRING_DIR}/RPMS/${arch}"

		unpack_rpm "${d_rpms}/amdgpu-pro-versionlist-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
		unpack_rpm "${d_rpms}/drm-utils-amdgpu-${PKG_VER_LIBDRM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"

		if use opencl ; then
			if [[ "${ABI}" == "amd64" ]] ; then
				# Install clinfo
				unpack_rpm "${d_rpms}/clinfo-amdgpu-pro-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
			fi

			# Install OpenCL components
			unpack_rpm "${d_rpms}/libopencl-amdgpu-pro-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
			if use opencl_pal ; then
				if [[ "${ABI}" == "amd64" ]] ; then
					unpack_rpm "${d_rpms}/opencl-amdgpu-pro-icd-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
					unpack_rpm "${d_rpms}/opencl-amdgpu-pro-comgr-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
				fi
			fi

			if use opencl_orca ; then
				unpack_rpm "${d_rpms}/opencl-orca-amdgpu-pro-icd-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
			fi
		fi

		if use roct ; then
			if [[ "${ABI}" == "amd64" ]] ; then
				unpack_rpm "${d_rpms}/hsakmt-roct-amdgpu-${PKG_VER_HSAKMT_A}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
				unpack_rpm "${d_rpms}/hsakmt-roct-amdgpu-devel-${PKG_VER_HSAKMT_A}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
			fi
		fi

		if use opengl ; then
			# Install OpenGL
			unpack_rpm "${d_rpms}/libgl-amdgpu-pro-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
			unpack_rpm "${d_rpms}/libgl-amdgpu-pro-ext-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
			mv opt/amdgpu-pro/lib${b}/xorg/modules/extensions/libglx.so \
				opt/amdgpu-pro/lib${b}/xorg/modules/extensions/libglx${b}.so \
				|| die
			unpack_rpm "${d_rpms}/libgl-amdgpu-pro-dri-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"

			# Install GBM
			unpack_rpm "${d_rpms}/mesa-amdgpu-libgbm-${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"

			unpack_rpm "${d_rpms}/libglapi-amdgpu-pro-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
			unpack_rpm "${d_rpms}/mesa-amdgpu-libglapi-${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		fi

		if use gles2 ; then
			# Install GLES2
			unpack_rpm "${d_rpms}/libgles-amdgpu-pro-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
		fi

		if use egl ; then
			# Install EGL libs
			unpack_rpm "${d_rpms}/libegl-amdgpu-pro-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
		fi

		if use vulkan ; then
			# Install Vulkan driver
			unpack_rpm "${d_rpms}/vulkan-amdgpu-pro-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
		fi

		if use vdpau ; then
			# Install VDPAU
			unpack_rpm "${d_rpms}/mesa-amdgpu-vdpau-drivers-${PKG_VER_MESA}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		fi

		if use hip-clang ; then
			if [[ "${ABI}" == "amd64" ]] ; then
				unpack_rpm "${d_rpms}/hip-amdgpu-pro-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
			fi
		fi

		unpack_rpm "${d_rpms}/libdrm-amdgpu-${PKG_VER_LIBDRM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		#unpack_rpm "${d_rpms}/libdrm-amdgpu-devel-${PKG_VER_LIBDRM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"

		# Install xorg drivers
		unpack_rpm "${d_rpms}/xorg-x11-amdgpu-drv-amdgpu-${PKG_VER_XORG_VIDEO_AMDGPU_DRV}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		mv opt/amdgpu/lib${b}/xorg/modules/drivers/amdgpu_drv.so \
			opt/amdgpu/lib${b}/xorg/modules/drivers/amdgpu_drv${b}.so \
			|| die

		# Internal LLVM9 required since Gentoo is missing the shared
		# libLLVM-9.so .  Gentoo only use split llvm libraries but the
		# driver components use the shared.
		unpack_rpm "${d_rpms}/llvm${PKG_VER_LLVM/\./}-amdgpu-${PKG_VER_LLVM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		#unpack_rpm "${d_rpms}/llvm${PKG_VER_LLVM/\./}-amdgpu-devel-${PKG_VER_LLVM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		unpack_rpm "${d_rpms}/llvm-amdgpu-${PKG_VER_LLVM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		unpack_rpm "${d_rpms}/llvm-amdgpu-libs-${PKG_VER_LLVM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		unpack_rpm "${d_rpms}/llvm-amdgpu-static-${PKG_VER_LLVM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		#unpack_rpm "${d_rpms}/llvm-amdgpu-devel-${PKG_VER_LLVM}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"

		#if use wayland ; then
			unpack_rpm "${d_rpms}/libwayland-amdgpu-client-${PKG_VER_LIBWAYLAND}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
			unpack_rpm "${d_rpms}/libwayland-amdgpu-egl-${PKG_VER_LIBWAYLAND}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
			unpack_rpm "${d_rpms}/libwayland-amdgpu-server-${PKG_VER_LIBWAYLAND}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
			#unpack_rpm "${d_rpms}/libwayland-amdgpu-cursor-${PKG_VER_LIBWAYLAND}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
			#unpack_rpm "${d_rpms}/libwayland-amdgpu-dev-${PKG_VER_LIBWAYLAND}-${PKG_REV}${PKG_ARCH_SUFFIX}${arch}.rpm"
		#fi

		unpack_rpm "${d_rpms}/amdgpu-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
		unpack_rpm "${d_rpms}/amdgpu-lib-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"

		unpack_rpm "${d_rpms}/amdgpu-pro-${PKG_VER_STRING}${PKG_ARCH_SUFFIX}${arch}.rpm"
	}
	multilib_foreach_abi unpack_abi

	#if use opengl ; then
	#	unpack_rpm "${d_rpms}/libgbm1-amdgpu-pro-base-${PKG_VER_STRING}_all.rpm"
	#	libgbm-amdgpu-dev_19.2.2-967956_i386.rpm
	#fi

	# Pin version (contains version requirements)
	#unpack_rpm "${d_rpms}/amdgpu-pro-pin-${PKG_VER_STRING}_all.rpm"

	#if use wayland ; then
		#unpack_rpm "${d_rpms}/libwayland-amdgpu-doc-${PKG_VER_LIBWAYLAND}-${PKG_REV}_all.rpm"
		#unpack_rpm "${d_rpms}/wayland-protocols-amdgpu-${PKG_VER_WAYLAND_PROTO}-${PKG_REV}_all.rpm"
	#fi
}

src_prepare() {
	default

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
}

src_install() {
	insinto /lib/udev/rules.d/
	doins "${T}/91-drm_pro-modeset.rules"
	insinto /etc/ld.so.conf.d/
	doins "${T}/01-amdgpu.conf"
	insinto /etc/X11/xorg.conf.d/
	doins "${T}/10-screen.conf"
	doins "${T}/10-monitor.conf"
	doins "${T}/10-device.conf"
	insinto /etc/amd/
	doins etc/amd/amdapfxx.blb

	into /usr/
	pushd opt/amdgpu/bin/ || die
	dobin amdgpu_test
	dobin kms-steal-crtc
	dobin kmstest
	dobin kms-universal-planes
	dobin modeprint
	dobin modetest
	dobin proptest
	dobin vbltest
	popd

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

		local dd_opengl="/usr/$(get_libdir)/opengl/amdgpu"
		local sd_amdgpupro="opt/amdgpu-pro/lib${b}"
		local sd_amdgpu="opt/amdgpu/lib${b}"
		local dd_amdgpu="${dd_opengl}/lib${b}"

		if use opencl ; then
			if [[ "${ABI}" == "amd64" ]] ; then
				# Install clinfo
				insinto /usr/bin
				dobin opt/amdgpu-pro/bin/clinfo
			fi

			# Install OpenCL components
			insinto /etc/OpenCL/vendors/
			if use opencl_pal ; then
				if [[ "${ABI}" == "amd64" ]] ; then
					doins etc/OpenCL/vendors/amdocl${b}.icd
					exeinto ${dd_amdgpu}/
					doexe ${sd_amdgpupro}/libamd_comgr.so
				fi
			fi

			insinto /etc/OpenCL/vendors/
			local dd_opencl="/usr/$(get_libdir)/OpenCL/vendors/amdgpu"
			if use opencl_orca ; then
				doins etc/OpenCL/vendors/amdocl-orca${b}.icd

				exeinto ${dd_opencl}/
				doexe ${sd_amdgpupro}/libamdocl12cl${b}.so
				doexe ${sd_amdgpupro}/libamdocl-orca${b}.so
			fi

			exeinto ${dd_opencl}/
			doexe ${sd_amdgpupro}/libOpenCL.so.1
			dosym libOpenCL.so.1 \
				${dd_opencl}/libOpenCL.so
		fi

		if use roct ; then
			if [[ "${ABI}" == "amd64" ]] ; then
				exeinto ${dd_amdgpu}/
				doexe ${sd_amdgpu}/libhsakmt.so.${PKG_VER_HSAKMT}
				dosym libhsakmt.so.${PKG_VER_HSAKMT} \
					${dd_amdgpu}/libhsakmt.so.$(ver_cut 1-2 ${PKG_VER_HSAKMT})
				dosym libhsakmt.so.${PKG_VER_HSAKMT} \
					${dd_amdgpu}/libhsakmt.so.$(ver_cut 1 ${PKG_VER_HSAKMT})
				dosym libhsakmt.so.${PKG_VER_HSAKMT} \
					${dd_amdgpu}/libhsakmt.so

				local sd_amdgpu_include="opt/amdgpu/include"
				insinto /usr/include/libhsakmt/
				doins ${sd_amdgpu_include}/hsakmttypes.h
				doins ${sd_amdgpu_include}/hsakmt.h

				#insinto /usr/include/libhsakmt/linux/
				#doins ${sd_amdgpu_include}/linux/kfd_ioctl.h

				local sd_amdgpu_share="opt/amdgpu/share"
				insinto /usr/$(get_libdir)/pkgconfig/
				sed -i -e "s|/opt/rocm||g" \
					${sd_amdgpu_share}/pkgconfig/libhsakmt.pc
				sed -i -e "s|//${sd_amdgpupro}|${d_amdgpu}/|g" \
					${sd_amdgpu_share}/pkgconfig/libhsakmt.pc
				sed -i -e "s|/include|/usr/include/libhsakmt/|g" \
					${sd_amdgpu_share}/pkgconfig/libhsakmt.pc
				doins ${sd_amdgpu_share}/pkgconfig/libhsakmt.pc
			fi
			# no x86 abi
		fi

		if use vulkan ; then
			# Install Vulkan driver
			insinto /etc/vulkan/icd.d/
			doins "${T}/amd_icd${b}.json"
			exeinto /usr/$(get_libdir)/vulkan/vendors/amdgpu/
			doexe ${sd_amdgpupro}/amdvlk${b}.so
		fi

		if use opengl ; then
			# Install OpenGL
			exeinto ${dd_amdgpu}/
			doexe ${sd_amdgpu}/libdrm_amdgpu.so.1.0.0
			dosym libdrm_amdgpu.so.1.0.0 \
				${dd_amdgpu}/libdrm_amdgpu.so.1
			dosym libdrm_amdgpu.so.1.0.0 \
				${dd_amdgpu}/libdrm_amdgpu.so
			doexe ${sd_amdgpupro}/libGL.so.1.2
			dosym libGL.so.1.2 ${dd_amdgpu}/libGL.so.1
			dosym libGL.so.1.2 ${dd_amdgpu}/libGL.so
			exeinto ${dd_amdgpu}/
			doexe ${sd_amdgpu}/libdrm_radeon.so.1.0.1
			dosym libdrm_radeon.so.1.0.1 \
				${dd_amdgpu}/libdrm_radeon.so.1
			dosym libdrm_radeon.so.1.0.1 \
				${dd_amdgpu}/libdrm_radeon.so
			exeinto ${dd_opengl}/extensions/
			mv opt/amdgpu-pro/lib${b}/xorg/modules/extensions/libglx${b}.so \
				opt/amdgpu-pro/lib${b}/xorg/modules/extensions/libglx.so \
				|| die
			doexe opt/amdgpu-pro/lib${b}/xorg/modules/extensions/libglx.so
			exeinto ${dd_opengl}/dri/
			doexe usr/lib${b}/dri/amdgpu_dri.so
			dosym ../opengl/amdgpu/dri/amdgpu_dri.so \
				/usr/$(get_libdir)/dri/amdgpu_dri.so
			#dosym ../../opengl/amdgpu/dri/amdgpu_dri.so \
			#	/usr/$(get_libdir)/${arch}-linux-gnu/dri/amdgpu_dri.so

			# Install GBM
			exeinto ${dd_amdgpu}/
			doexe ${sd_amdgpu}/libgbm.so.1.0.0
			dosym libgbm.so.1.0.0 ${dd_amdgpu}/libgbm.so.1
			dosym libgbm.so.1.0.0 ${dd_amdgpu}/libgbm.so
			#exeinto ${dd_opengl}/gbm/
			#doexe ${sd_amdgpu}/gbm/gbm_amdgpu.so
			#dosym gbm_amdgpu.so \
			#	${dd_opengl}/gbm/libdummy.so
			#dosym opengl/amdgpu/gbm \
			#	/usr/$(get_libdir)/gbm

			insinto /etc/amd/
			doins etc/amd/amdrc

			#insinto /etc/gbm/
			#doins etc/gbm/gbm.conf
		fi

		if use gles2 ; then
			# Install GLES2
			exeinto ${dd_amdgpu}/
			doexe ${sd_amdgpupro}/libGLESv2.so.2
			dosym libGLESv2.so.2 ${dd_amdgpu}/libGLESv2.so
		fi

		if use egl ; then
			# Install EGL libs
			exeinto ${dd_amdgpu}/
			doexe ${sd_amdgpupro}/libEGL.so.1
			dosym libEGL.so.1 ${dd_amdgpu}/libEGL.so
		fi

		if use vdpau ; then
			# Install VDPAU
			exeinto ${dd_opengl}/vdpau/
			local sd_vdpau="${sd_amdgpu}/vdpau"
			local dd_vdpau="/usr/$(get_libdir)/vdpau"
			doexe ${sd_vdpau}/libvdpau_r300.so.1.0.0
			doexe ${sd_vdpau}/libvdpau_r600.so.1.0.0
			doexe ${sd_vdpau}/libvdpau_radeonsi.so.1.0.0
			dosym ../opengl/amdgpu/vdpau/libvdpau_r300.so.1.0.0 \
				${dd_vdpau}/libvdpau_r300.so.1.0.0
			dosym ../opengl/amdgpu/vdpau/libvdpau_r600.so.1.0.0 \
				${dd_vdpau}/libvdpau_r600.so.1.0.0
			dosym ../opengl/amdgpu/vdpau/libvdpau_radeonsi.so.1.0.0 \
				${dd_vdpau}/libvdpau_radeonsi.so.1.0.0
			dosym libvdpau_r300.so.1.0.0 \
				${dd_vdpau}/libvdpau_r300.so.1.0
			dosym libvdpau_r300.so.1.0.0 \
				${dd_vdpau}/libvdpau_r300.so.1
			dosym libvdpau_r300.so.1.0.0 \
				${dd_vdpau}/libvdpau_r300.so
			dosym libvdpau_r600.so.1.0.0 \
				${dd_vdpau}/libvdpau_r600.so.1.0
			dosym libvdpau_r600.so.1.0.0 \
				${dd_vdpau}/libvdpau_r600.so.1
			dosym libvdpau_r600.so.1.0.0 \
				${dd_vdpau}/libvdpau_r600.so
			dosym libvdpau_radeonsi.so.1.0.0 \
				${dd_vdpau}/libvdpau_radeonsi.so.1.0
			dosym libvdpau_radeonsi.so.1.0.0 \
				${dd_vdpau}/libvdpau_radeonsi.so.1
			dosym libvdpau_radeonsi.so.1.0.0 \
				${dd_vdpau}/libvdpau_radeonsi.so
		fi

		# Install libglapi
		exeinto ${dd_amdgpu}/
		doexe ${sd_amdgpupro}/libglapi.so.1
		dosym libglapi.so.1 ${dd_amdgpu}/libglapi.so
		doexe ${sd_amdgpu}/libglapi.so.0.0.0 # mesa
		dosym libglapi.so.0.0.0 ${dd_amdgpu}/libglapi.so.0 # mesa

		# Install the shared LLVM libraries that Gentoo doesn't produce
		exeinto ${dd_amdgpu}/llvm-${PKG_VER_LLVM}/lib/
		local sd_llvm="${sd_amdgpu}/llvm-${PKG_VER_LLVM}/lib"
		#doexe ${sd_llvm}/BugpointPasses.so
		doexe ${sd_llvm}/libRemarks.so.${PKG_VER_LLVM_MAJ}
		doexe ${sd_llvm}/libLLVM-${PKG_VER_LLVM_MAJ}.so
		doexe ${sd_llvm}/libLTO.so.${PKG_VER_LLVM_MAJ}
		#doexe ${sd_llvm}/LLVMHello.so
		#doexe ${sd_llvm}/TestPlugin.so
		exeinto ${dd_amdgpu}/
		local d="${EPREFIX}${dd_amdgpu}"
		local s="${dd_amdgpu}/llvm-${PKG_VER_LLVM}/lib"
		dosym "${s}"/libLTO.so.${PKG_VER_LLVM_MAJ} \
			"${d}"/libLTO.so.${PKG_VER_LLVM_MAJ}
		dosym "${s}"/libLTO.so.${PKG_VER_LLVM_MAJ} \
			"${s}"/libLTO.so.${PKG_VER_LLVM}
		#dosym "${s}"/BugpointPasses.so \
		#	"${d}"/BugpointPasses.so
		dosym "${s}"/libRemarks.so.${PKG_VER_LLVM_MAJ} \
			"${d}"/libRemarks.so.${PKG_VER_LLVM_MAJ}
		dosym "${s}"/libRemarks.so.${PKG_VER_LLVM_MAJ} \
			"${s}"/libRemarks.so
		dosym "${s}"/libRemarks.so.${PKG_VER_LLVM_MAJ} \
			"${d}"/libRemarks.so
		dosym "${s}"/libLTO.so.${PKG_VER_LLVM_MAJ} \
			"${d}"/libLTO.so.${PKG_VER_LLVM_MAJ}
		dosym "${s}"/libLTO.so.${PKG_VER_LLVM} \
			"${d}"/libLTO.so.${PKG_VER_LLVM}
		dosym "${s}"/libLLVM-${PKG_VER_LLVM_MAJ}.so \
			"${d}"/libLLVM-${PKG_VER_LLVM_MAJ}.so
		dosym "${s}"/libLLVM-${PKG_VER_LLVM_MAJ}.so \
			"${s}"/libLLVM-${PKG_VER_LLVM}.so
		dosym "${s}"/libLLVM-${PKG_VER_LLVM}.so \
			"${d}"/libLLVM-${PKG_VER_LLVM}.so
		#dosym "${s}"/LLVMHello.so \
		#	"${d}"/LLVMHello.so
		#dosym "${s}"/TestPlugin.so \
		#	"${d}"/TestPlugin.so

		# Install xorg drivers
		if [[ "${ABI}" == "amd64" ]] ; then
			exeinto ${dd_opengl}/modules/drivers/
			mv opt/amdgpu/lib${b}/xorg/modules/drivers/amdgpu_drv${b}.so \
				opt/amdgpu/lib${b}/xorg/modules/drivers/amdgpu_drv.so \
				|| die
			doexe opt/amdgpu/lib${b}/xorg/modules/drivers/amdgpu_drv.so
		fi
		if [[ "${ABI}" == "x86" ]] ; then
			if use abi_x86_32 && use abi_x86_64 ; then
				true
			else
				# currently bugged when both are installed on amd64
				exeinto /usr/lib32/opengl/amdgpu/modules/drivers/
				mv opt/amdgpu/lib${b}/xorg/modules/drivers/amdgpu_drv32.so \
					opt/amdgpu/lib${b}/xorg/modules/drivers/amdgpu_drv.so \
					|| die
				doexe opt/amdgpu/lib${b}/xorg/modules/drivers/amdgpu_drv.so
			fi
		fi

		if use hip-clang ; then
			if [[ "${ABI}" == "amd64" ]] ; then
				exeinto ${dd_amdgpu}/
				doexe ${sd_amdgpupro}/libamdhip64.so
				doexe ${sd_amdgpupro}/libhip_hcc.so
			fi
		fi

		# Install wayland libraries.  Installing these are required.
		# if use wayland ; then
			exeinto ${dd_amdgpu}/
			doexe ${sd_amdgpu}/libwayland-client.so.0.3.0
			dosym libwayland-client.so.0.3.0 \
				${dd_amdgpu}/libwayland-client.so.0
			doexe ${sd_amdgpu}/libwayland-server.so.0.1.0
			dosym libwayland-server.so.0.1.0 \
				${dd_amdgpu}/libwayland-server.so.0
			doexe ${sd_amdgpu}/libwayland-egl.so.1.0.0
			dosym libwayland-egl.so.1.0.0 \
				${dd_amdgpu}/libwayland-egl.so.1
		# fi

		# TODO: install dev libraries if any

		# Link for hardcoded path
		dosym /usr/share/libdrm/amdgpu.ids \
			/opt/amdgpu/share/libdrm/amdgpu.ids
	}

	multilib_foreach_abi install_abi

	if use vdpau ; then
		cat <<-EOF > "${T}"/50${P}-vdpau
			LDPATH=\
"/usr/lib64/vdpau:
/usr/lib32/vdpau"
		EOF
		doenvd "${T}"/50${P}-vdpau
	fi

	docinto doc
	dodoc -r usr/share/doc/* \
		opt/amdgpu/share/doc/*
	docinto licenses
	dodoc -r usr/share/licenses/* \
		opt/amdgpu-pro/share/licenses/*
	doman usr/share/man/man7/amdgpu-doc.7.gz
}

pkg_prerm() {
	if use opengl ; then
		"${ROOT}"/usr/bin/eselect opengl set --use-old xorg-x11
	fi

	if use opencl ; then
		if "${ROOT}"/usr/bin/eselect opencl list | grep mesa ; then
			"${ROOT}"/usr/bin/eselect opencl set --use-old mesa
		fi
	fi
}

pkg_postinst() {
	if use opengl ; then
		"${ROOT}"/usr/bin/eselect opengl set --use-old amdgpu
	fi

	if use opencl ; then
		"${ROOT}"/usr/bin/eselect opencl set --use-old amdgpu
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

	# remove generated by eselect-opengl
	# rm "${ROOT}"/etc/X11/xorg.conf.d/20opengl.conf > /dev/null
}

#1234567890123456789012345678901234567890123456789012345678901234567890123456789
