# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="New generation AMD closed-source drivers for Southern Islands \
(HD7730 Series) and newer chipsets"
HOMEPAGE=\
"https://www.amd.com/en/support/kb/release-notes/rn-rad-lin-18-50-unified"
LICENSE="AMD GPL-2 QPL-1.0"
KEYWORDS="~amd64 ~x86"
MULTILIB_COMPAT=( abi_x86_{32,64} )
inherit check-reqs linux-info multilib-build unpacker
PKG_VER=$(ver_cut 1-2)
PKG_VER_MAJ=$(ver_cut 1)
PKG_REV=$(ver_cut 3)
PKG_ARCH="ubuntu"
PKG_ARCH_VER="18.04"
PKG_VER_AMF="1.4.11"
PKG_VER_GLAMOR="1.19.0"
PKG_VER_GST_OMX="1.0.0.1"
PKG_VER_HSA="1.1.6"
PKG_VER_ID="1.0.0"
PKG_VER_LIBDRM="2.4.95"
PKG_VER_LIBWAYLAND="1.15.0"
PKG_VER_LLVM="7.0"
PKG_VER_LLVM_MAJ="7"
PKG_VER_MESA="18.2.0"
PKG_VER_ROCT="1.0.9"
PKG_VER_STRING=${PKG_VER}-${PKG_REV}
PKG_VER_STRING_DIR=${PKG_VER}-${PKG_REV}-${PKG_ARCH}-${PKG_ARCH_VER}
PKG_VER_WAYLAND_PROTO="1.16"
PKG_VER_XORG_VIDEO_AMDGPU_DRV="18.1.99" # about the same as the mesa version
FN="amdgpu-pro-${PKG_VER_STRING}-${PKG_ARCH}-${PKG_ARCH_VER}.tar.xz"
SRC_URI="https://www2.ati.com/drivers/linux/${PKG_ARCH}/${FN}"
RESTRICT="fetch strip"
IUSE="+amf dkms +egl +gles2 freesync hsa +opencl +opengl openmax orca pal \
+vaapi +vdpau +vulkan wayland"
SLOT="1"

# The x11-base/xorg-server-<ver> must match this drivers version or this error
# will be produced:
# modules abi version 23 doesn't match the server version 24
#
# For more info on VIDEODRV see https://www.x.org/wiki/XorgModuleABIVersions/
# sys-libs/ncurses[tinfo] required by llvm in this package

# roct-thunk-interface (aka hsa) is outdated

#	>=sys-devel/lld-7.0.0
#	>=sys-devel/llvm-7.0.0
# libglapi.so.0 needs libselinux
RDEPEND="app-eselect/eselect-opencl
	 >=app-eselect/eselect-opengl-1.0.7
	 dev-util/cunit
	 dev-libs/libedit
	 freesync? ( || (
		  sys-kernel/amdgpu-dkms
		>=sys-kernel/aufs-sources-5.0
		>=sys-kernel/ck-sources-5.0
		>=sys-kernel/git-sources-5.0
		>=sys-kernel/gentoo-sources-5.0
		>=sys-kernel/hardened-sources-5.0
		>=sys-kernel/pf-sources-5.0
		  sys-kernel/rock-dkms
		>=sys-kernel/rt-sources-5.0
		>=sys-kernel/vanilla-sources-5.0
		>=sys-kernel/xbox-sources-5.0
		>=sys-kernel/zen-sources-5.0 ) )
	 hsa? ( !dev-libs/roct-thunk-interface
		 sys-process/numactl )
	 media-libs/libomxil-bellagio
	 >=media-libs/gst-plugins-base-1.6.0[${MULTILIB_USEDEP}]
	 >=media-libs/gstreamer-1.6.0[${MULTILIB_USEDEP}]
	 opencl? ( >=sys-devel/gcc-5.2.0 )
	 openmax? ( >=media-libs/mesa-${PKG_VER_MESA}[openmax] )
	 >=sys-libs/libselinux-1.32
	 sys-libs/ncurses[tinfo]
	 vdpau? ( >=media-libs/mesa-${PKG_VER_MESA}[-vdpau] )
	 !vulkan? ( >=media-libs/mesa-${PKG_VER_MESA} )
	 vulkan? ( >=media-libs/mesa-${PKG_VER_MESA}[-vulkan]
		     media-libs/vulkan-loader )
	 >=x11-base/xorg-drivers-1.19
	 <x11-base/xorg-drivers-1.20
	 x11-base/xorg-proto
	 >=x11-base/xorg-server-1.19[glamor]
	 >=x11-libs/libdrm-${PKG_VER_LIBDRM}[libkms]
	 x11-libs/libX11[${MULTILIB_USEDEP}]
	 x11-libs/libXext[${MULTILIB_USEDEP}]
	 x11-libs/libXinerama[${MULTILIB_USEDEP}]
	 x11-libs/libXrandr[${MULTILIB_USEDEP}]
	 x11-libs/libXrender[${MULTILIB_USEDEP}]
	 dkms? ( sys-kernel/amdgpu-dkms sys-kernel/rock-dkms )"
# hsakmt requires libnuma.so.1
# kmstest requires libkms
# amdgpu_dri.so requires wayland?
# vdpau requires llvm7
DEPEND=">=sys-kernel/linux-firmware-20161205"
S="${WORKDIR}"
REQUIRED_USE="|| ( pal orca )" # incomplete
# !hsa

_set_check_reqs_requirements() {
	if use abi_x86_32 && use abi_x86_64 ; then
		CHECKREQS_DISK_BUILD="721M"
		CHECKREQS_DISK_USR="474M"
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

	if use pal ; then
		einfo \
"OpenCL PAL (Portable Abstraction Layer) being used.  It is only supported\n\
by GCN 5.x (Vega).  It is still in development."
	fi

	if use orca ; then
		einfo \
"OpenCL orca is being used. You are enabling the older legacy OpenCL driver\n\
implementation used by older fglrx."
	fi

	if use hsa ; then
		# remove if it works and been tested on hsa hardware
		eerror "hsa not supported and not tested"
	fi

	_set_check_reqs_requirements
	check-reqs_pkg_setup
}

src_unpack() {
	default

	local d="amdgpu-pro-${PKG_VER_STRING_DIR}"

	unpack_deb "${d}/libgl1-amdgpu-pro-appprofiles_${PKG_VER_STRING}_all.deb"

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

		unpack_deb "${d}/libdrm-amdgpu-utils_${PKG_VER_LIBDRM}-${PKG_REV}_${arch}.deb"

		if use opencl ; then
			if [[ "${ABI}" == "amd64" ]] ; then
				# Install clinfo
				unpack_deb "${d}/clinfo-amdgpu-pro_${PKG_VER_STRING}_${arch}.deb"
			fi

			# Install OpenCL components
			unpack_deb "${d}/libopencl1-amdgpu-pro_${PKG_VER_STRING}_${arch}.deb"
			if use pal ; then
				if [[ "${ABI}" == "amd64" ]] ; then
					unpack_deb "${d}/opencl-amdgpu-pro-icd_${PKG_VER_STRING}_${arch}.deb"
				fi
			fi

			if use orca ; then
				unpack_deb "${d}/opencl-orca-amdgpu-pro-icd_${PKG_VER_STRING}_${arch}.deb"
			fi

			if [[ "${ABI}" == "amd64" ]] ; then
				unpack_deb "${d}/roct-amdgpu-pro_${PKG_VER_ROCT}-${PKG_REV}_${arch}.deb"
				unpack_deb "${d}/roct-amdgpu-pro-dev_${PKG_VER_ROCT}-${PKG_REV}_${arch}.deb"
			fi
		fi

		if use opengl ; then
			# Install OpenGL
			unpack_deb "${d}/libgl1-amdgpu-pro-glx_${PKG_VER_STRING}_${arch}.deb"
			unpack_deb "${d}/libgl1-amdgpu-pro-ext_${PKG_VER_STRING}_${arch}.deb"
			mv opt/amdgpu-pro/lib/xorg/modules/extensions/libglx.so \
				opt/amdgpu-pro/lib/xorg/modules/extensions/libglx${b}.so \
				|| die
			unpack_deb "${d}/libgl1-amdgpu-pro-dri_${PKG_VER_STRING}_${arch}.deb"

			# Install GBM
			unpack_deb "${d}/libgbm1-amdgpu-pro_${PKG_VER_STRING}_${arch}.deb"

			unpack_deb "${d}/libglapi1-amdgpu-pro_${PKG_VER}-${PKG_REV}_${arch}.deb"
			unpack_deb "${d}/libglapi-amdgpu-mesa_${PKG_VER_MESA}-${PKG_REV}_${arch}.deb"
		fi

		if use gles2 ; then
			# Install GLES2
			unpack_deb "${d}/libgles2-amdgpu-pro_${PKG_VER_STRING}_${arch}.deb"
		fi

		if use egl ; then
			# Install EGL libs
			unpack_deb "${d}/libegl1-amdgpu-pro_${PKG_VER_STRING}_${arch}.deb"
		fi

		if use vulkan ; then
			# Install Vulkan driver
			unpack_deb "${d}/vulkan-amdgpu-pro_${PKG_VER_STRING}_${arch}.deb"
		fi

		if use openmax ; then
			# Install gstreamer OpenMAX plugin
			unpack_deb "${d}/gst-omx-amdgpu_${PKG_VER_GST_OMX}-${PKG_REV}_${arch}.deb"
		fi

		if use vdpau ; then
			# Install VDPAU
			unpack_deb "${d}/mesa-amdgpu-vdpau-drivers_${PKG_VER_MESA}-${PKG_REV}_${arch}.deb"
		fi

		if use vaapi ; then
			# Install Mesa VA-API video acceleration drivers
			unpack_deb "${d}/mesa-amdgpu-va-drivers_${PKG_VER_MESA}-${PKG_REV}_${arch}.deb"
		fi

		if use amf ; then
			if [[ "${ABI}" == "amd64" ]] ; then
				# Install AMDGPU Pro Advanced Multimedia Framework
				unpack_deb "${d}/amf-amdgpu-pro_${PKG_VER_AMF}-${PKG_REV}_${arch}.deb"
			fi
		fi

		unpack_deb "${d}/libdrm-amdgpu-amdgpu1_${PKG_VER_LIBDRM}-${PKG_REV}_${arch}.deb"
		unpack_deb "${d}/libdrm-amdgpu-radeon1_${PKG_VER_LIBDRM}-${PKG_REV}_${arch}.deb"

		unpack_deb "${d}/glamor-amdgpu_${PKG_VER_GLAMOR}-${PKG_REV}_${arch}.deb"
		mv opt/amdgpu/lib/xorg/modules/libglamoregl.so \
			opt/amdgpu/lib/xorg/modules/libglamoregl${b}.so \
			|| die

		# Install xorg drivers
		unpack_deb "${d}/xserver-xorg-amdgpu-video-amdgpu_${PKG_VER_XORG_VIDEO_AMDGPU_DRV}-${PKG_REV}_${arch}.deb"
		mv opt/amdgpu/lib/xorg/modules/drivers/amdgpu_drv.so \
			opt/amdgpu/lib/xorg/modules/drivers/amdgpu_drv${b}.so \
			|| die

		# Internal LLVM7 required since Gentoo is missing the shared
		# libLLVM-7.so .  Gentoo only use split llvm libraries but the
		# driver components use the shared.
		unpack_deb "${d}/libllvm${PKG_VER_LLVM}-amdgpu_${PKG_VER_LLVM}-${PKG_REV}_${arch}.deb"
		#unpack_deb "${d}/llvm-amdgpu-${PKG_VER_LLVM}_${PKG_VER_LLVM}-${PKG_REV}_${arch}.deb"
		#unpack_deb "${d}/llvm-amdgpu-${PKG_VER_LLVM}-runtime_${PKG_VER_LLVM}-${PKG_REV}_${arch}.deb"

		unpack_deb "${d}/libwayland-amdgpu-client0_${PKG_VER_LIBWAYLAND}-${PKG_REV}_${arch}.deb"
		unpack_deb "${d}/libwayland-amdgpu-egl1_${PKG_VER_LIBWAYLAND}-${PKG_REV}_${arch}.deb"
		unpack_deb "${d}/libwayland-amdgpu-server0_${PKG_VER_LIBWAYLAND}-${PKG_REV}_${arch}.deb"
		#unpack_deb "${d}/libwayland-amdgpu-cursor0_${PKG_VER_LIBWAYLAND}-${PKG_REV}_${arch}.deb"
		#unpack_deb "${d}/libwayland-amdgpu-dev_${PKG_VER_LIBWAYLAND}-${PKG_REV}_${arch}.deb"
	}
	multilib_foreach_abi unpack_abi

	if use opengl ; then
		unpack_deb "${d}/libgbm1-amdgpu-pro-base_${PKG_VER_STRING}_all.deb"
	fi

	# Pin version (contains version requirements)
	unpack_deb "${d}/amdgpu-pro-pin_${PKG_VER}-${PKG_REV}_all.deb"

	unpack_deb "${d}/libdrm-amdgpu-common_${PKG_VER_ID}-${PKG_REV}_all.deb"

	#unpack_deb "${d}/libwayland-amdgpu-doc_${PKG_VER_LIBWAYLAND}-${PKG_REV}_all.deb"
	#unpack_deb "${d}/wayland-protocols-amdgpu_${PKG_VER_WAYLAND_PROTO}-${PKG_REV}_all.deb"
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
LDPATH=\
"/usr/lib64/opengl/amdgpu-pro/lib:\
/usr/lib64/opengl/amdgpu-pro:\
/usr/lib64/opengl/amdgpu/lib:\
/usr/lib64/opengl/amdgpu:\
/usr/lib32/opengl/amdgpu-pro/lib:\
/usr/lib32/opengl/amdgpu-pro:\
/usr/lib32/opengl/amdgpu/lib:\
/usr/lib32/opengl/amdgpu"
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
LDPATH=\
"/usr/lib64/opengl/amdgpu-pro/lib:\
/usr/lib64/opengl/amdgpu-pro:\
/usr/lib64/opengl/amdgpu/lib:\
/usr/lib64/opengl/amdgpu"
OPENGL_PROFILE="amdgpu"
EOF
		fi
	fi
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
		local sd_amdgpupro="opt/amdgpu-pro/lib/${arch}-linux-gnu"
		local sd_amdgpu="opt/amdgpu/lib/${arch}-linux-gnu"
		local d_amdgpu="${dd_opengl}/lib"
		local d_radeon="/usr/$(get_libdir)/opengl/radeon/lib"

		if use opencl ; then
			if [[ "${ABI}" == "amd64" ]] ; then
				# Install clinfo
				insinto /usr/bin
				dobin opt/amdgpu-pro/bin/clinfo
			fi

			# Install OpenCL components
			insinto /etc/OpenCL/vendors/
			if use pal ; then
				if [[ "${ABI}" == "amd64" ]] ; then
					doins etc/OpenCL/vendors/amdocl${b}.icd
				fi
			fi

			local dd_opencl="/usr/$(get_libdir)/OpenCL/vendors/amdgpu"
			if use orca ; then
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

		if use hsa ; then
			if [[ "${ABI}" == "amd64" ]] ; then
				exeinto ${d_amdgpu}/
				doexe ${sd_amdgpupro}/libhsakmt.so.1.0.0
				dosym libhsakmt.so.1.0.0 \
					${d_amdgpu}/libhsakmt.so.1.0
				dosym libhsakmt.so.1.0.0 \
					${d_amdgpu}/libhsakmt.so.1
				dosym libhsakmt.so.1.0.0 \
					${d_amdgpu}/libhsakmt.so

				local sd_include="opt/amdgpu-pro/include"
				insinto /usr/include/libhsakmt/
				doins ${sd_include}/hsakmttypes.h
				doins ${sd_include}/hsakmt.h

				insinto /usr/include/libhsakmt/linux/
				doins ${sd_include}/linux/kfd_ioctl.h

				insinto /usr/$(get_libdir)/pkgconfig/
				sed -i -e "s|/opt/rocm||g" \
					${sd_amdgpupro}/pkgconfig/libhsakmt.pc
				sed -i -e "s|//${sd_amdgpupro}|${d_amdgpu}/|g" \
					${sd_amdgpupro}/pkgconfig/libhsakmt.pc
				sed -i -e "s|/include|/usr/include/libhsakmt/|g" \
					${sd_amdgpupro}/pkgconfig/libhsakmt.pc
				doins ${sd_amdgpupro}/pkgconfig/libhsakmt.pc
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
			exeinto ${d_amdgpu}/
			doexe ${sd_amdgpu}/libdrm_amdgpu.so.1.0.0
			dosym libdrm_amdgpu.so.1.0.0 \
				${d_amdgpu}/libdrm_amdgpu.so.1
			dosym libdrm_amdgpu.so.1.0.0 \
				${d_amdgpu}/libdrm_amdgpu.so
			doexe ${sd_amdgpupro}/libGL.so.1.2
			dosym libGL.so.1.2 ${d_amdgpu}/libGL.so.1
			dosym libGL.so.1.2 ${d_amdgpu}/libGL.so
			exeinto ${d_radeon}/
			doexe ${sd_amdgpu}/libdrm_radeon.so.1.0.1
			dosym libdrm_radeon.so.1.0.1 ${d_radeon}/libdrm_radeon.so.1
			dosym libdrm_radeon.so.1.0.1 ${d_radeon}/libdrm_radeon.so
			exeinto ${dd_opengl}/extensions/
			mv opt/amdgpu-pro/lib/xorg/modules/extensions/libglx${b}.so \
				opt/amdgpu-pro/lib/xorg/modules/extensions/libglx.so \
				|| die
			doexe opt/amdgpu-pro/lib/xorg/modules/extensions/libglx.so
			exeinto ${dd_opengl}/dri/
			doexe usr/lib/${arch}-linux-gnu/dri/amdgpu_dri.so
			dosym ../opengl/amdgpu/dri/amdgpu_dri.so \
				/usr/$(get_libdir)/dri/amdgpu_dri.so
			dosym ../../opengl/amdgpu/dri/amdgpu_dri.so \
				/usr/$(get_libdir)/${arch}-linux-gnu/dri/amdgpu_dri.so

			# Install GBM
			exeinto ${d_amdgpu}/
			doexe ${sd_amdgpupro}/libgbm.so.1.0.0
			dosym libgbm.so.1.0.0 ${d_amdgpu}/libgbm.so.1
			dosym libgbm.so.1.0.0 ${d_amdgpu}/libgbm.so
			exeinto ${dd_opengl}/gbm/
			doexe ${sd_amdgpupro}/gbm/gbm_amdgpu.so
			dosym gbm_amdgpu.so \
				${dd_opengl}/gbm/libdummy.so
			dosym opengl/amdgpu/gbm \
				/usr/$(get_libdir)/gbm

			insinto /etc/amd/
			doins etc/amd/amdrc

			insinto /etc/gbm/
			doins etc/gbm/gbm.conf
		fi

		if use gles2 ; then
			# Install GLES2
			exeinto ${d_amdgpu}/
			doexe ${sd_amdgpupro}/libGLESv2.so.2
			dosym libGLESv2.so.2 ${d_amdgpu}/libGLESv2.so
		fi

		if use egl ; then
			# Install EGL libs
			exeinto ${d_amdgpu}/
			doexe ${sd_amdgpupro}/libEGL.so.1
			dosym libEGL.so.1 ${d_amdgpu}/libEGL.so
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

		if use vaapi ; then
			exeinto ${dd_opengl}/dri/
			doexe ${sd_amdgpu}/dri/radeonsi_drv_video.so
			doexe ${sd_amdgpu}/dri/r600_drv_video.so
		fi

		# Install amf libraries
		if use amf ; then
			if [[ "${ABI}" == "amd64" ]] ; then
				exeinto ${d_amdgpu}
				doexe ${sd_amdgpupro}/libamfrt${b}.so.${PKG_VER}
				dosym libamfrt${b}.so.${PKG_VER} \
					${d_amdgpu}/libamfrt${b}.so.${PKG_VER_MAJ}
				dosym libamfrt${b}.so.${PKG_VER} \
					${d_amdgpu}/libamfrt${b}.so
				dosym libamfrt${b}.so.${PKG_VER} \
					${d_amdgpu}/libamfrt${b}.so.1
					# from Gentoo QA notice when installing
			fi
		fi

		# Install glamor
		exeinto ${dd_opengl}/
		mv opt/amdgpu/lib/xorg/modules/libglamoregl${b}.so \
			opt/amdgpu/lib/xorg/modules/libglamoregl.so \
			|| die
		doexe opt/amdgpu/lib/xorg/modules/libglamoregl.so

		# Install libglapi
		exeinto ${d_amdgpu}/
		doexe ${sd_amdgpupro}/libglapi.so.1
		dosym libglapi.so.1 ${d_amdgpu}/libglapi.so
		doexe ${sd_amdgpu}/libglapi.so.0.0.0
		dosym libglapi.so.0.0.0 ${d_amdgpu}/libglapi.so.0

		# Install the shared LLVM libraries that Gentoo doesn't produce
		exeinto ${d_amdgpu}/llvm-${PKG_VER_LLVM}/lib/
		local sd_llvm="${sd_amdgpu}/llvm-${PKG_VER_LLVM}/lib"
		doexe ${sd_llvm}/BugpointPasses.so
		doexe ${sd_llvm}/libLLVM-${PKG_VER_LLVM_MAJ}.so
		doexe ${sd_llvm}/libLTO.so.${PKG_VER_LLVM_MAJ}
		doexe ${sd_llvm}/LLVMHello.so
		doexe ${sd_llvm}/TestPlugin.so
		local d="${EPREFIX}${d_amdgpu}"
		local s="${d_amdgpu}/llvm-${PKG_VER_LLVM}/lib"
		dosym "${s}"/BugpointPasses.so \
			"${d}"/BugpointPasses.so
		dosym "${s}"/libLLVM-${PKG_VER_LLVM_MAJ}.so \
			"${d}"/libLLVM-${PKG_VER_LLVM_MAJ}.so
		dosym "${s}"/libLTO.so.${PKG_VER_LLVM_MAJ} \
			"${d}"/libLTO.so.${PKG_VER_LLVM_MAJ}
		dosym "${s}"/LLVMHello.so "${d}"/LLVMHello.so
		dosym "${s}"/TestPlugin.so "${d}"/TestPlugin.so

		# Install xorg drivers
		if [[ "${ABI}" == "amd64" ]] ; then
			exeinto ${dd_opengl}/modules/drivers/
			mv opt/amdgpu/lib/xorg/modules/drivers/amdgpu_drv${b}.so \
				opt/amdgpu/lib/xorg/modules/drivers/amdgpu_drv.so \
				|| die
			doexe opt/amdgpu/lib/xorg/modules/drivers/amdgpu_drv.so
		fi
		if [[ "${ABI}" == "x86" ]] ; then
			if use abi_x86_32 && use abi_x86_64 ; then
				true
			else
				# currently bugged when both are installed on amd64
				exeinto /usr/lib32/opengl/amdgpu/modules/drivers/
				mv opt/amdgpu/lib/xorg/modules/drivers/amdgpu_drv32.so \
					opt/amdgpu/lib/xorg/modules/drivers/amdgpu_drv.so \
					|| die
				doexe opt/amdgpu/lib/xorg/modules/drivers/amdgpu_drv.so
			fi
		fi

		if use openmax ; then
			# Install gstreamer OpenMAX plugin
			insinto /etc/xdg/
			doins etc/xdg/gstomx.conf
				exeinto /usr/$(get_libdir)/gstreamer-1.0/
				doexe ${sd_amdgpu}/gstreamer-1.0/libgstomx.so
		fi

		# Install wayland libraries.  Installing these are required.
		# if use wayland ; then
			exeinto ${d_amdgpu}/
			doexe ${sd_amdgpu}/libwayland-client.so.0.3.0
			dosym libwayland-client.so.0.3.0 \
				${d_amdgpu}/libwayland-client.so.0
			doexe ${sd_amdgpu}/libwayland-server.so.0.1.0
			dosym libwayland-server.so.0.1.0 \
				${d_amdgpu}/libwayland-server.so.0
			doexe ${sd_amdgpu}/libwayland-egl.so.1.0.0
			dosym libwayland-egl.so.1.0.0 \
				${d_amdgpu}/libwayland-egl.so.1
		# fi

		# TODO: install dev libraries if any

		# Link for hardcoded path
		dosym /usr/share/libdrm/amdgpu.ids \
			/opt/amdgpu/share/libdrm/amdgpu.ids
	}

	multilib_foreach_abi install_abi
}

pkg_prerm() {
	if use opengl ; then
		"${ROOT}"/usr/bin/eselect opengl set --use-old xorg-x11
	fi

	if use opencl ; then
		"${ROOT}"/usr/bin/eselect opencl set --use-old mesa
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
  https://support.amd.com/en-us/kb-articles/pages/how-to-enable-amd-freesync-in-linux.aspx\n\
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
