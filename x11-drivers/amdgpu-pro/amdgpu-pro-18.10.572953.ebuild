# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MULTILIB_COMPAT=( abi_x86_{32,64} )
#inherit eutils linux-info multilib-build unpacker
inherit multilib-build unpacker linux-info

DESCRIPTION="New generation AMD closed-source drivers for Southern Islands (HD7730 Series) and newer chipsets"
HOMEPAGE="https://www.amd.com/en/support/kb/release-notes/rn-rad-pro-lin-18-10"
PKG_VER=${PV:0:5}
PKG_REV=${PV:6:6}
PKG_ARCH="ubuntu"
PKG_ARCH_VER="18.04"
PKG_VER_STRING=${PKG_VER}-${PKG_REV}
PKG_VER_LIBDRM="2.4.89"
PKG_VER_MESA="17.3.3"
PKG_VER_HSA="1.1.6"
PKG_VER_ROCT="1.0.7"
PKG_VER_XORG_VIDEO_AMDGPU_DRV="1.4.0"
PKG_VER_ID="1.0.0"
PKG_VER_GST_OMX="1.0.0.1"
SRC_URI="https://www2.ati.com/drivers/linux/${PKG_ARCH}/amdgpu-pro-${PKG_VER_STRING}.tar.xz"

RESTRICT="fetch strip"

# The binary blobs include binaries for other open sourced packages, we don't want to include those parts, if they are
# selected, they should come from portage.
IUSE="+gles2 +opencl +opengl openmax +vdpau +vulkan hsa rocm rocr freesync pal orca vega +egl"

LICENSE="AMD GPL-2 QPL-1.0"
KEYWORDS="~amd64"
SLOT="1"

# The x11-base/xorg-server-<ver> must match this drivers version or this error will be produced:
# modules abi version 23 doesn't match the server version 24
#
# For more info on VIDEODRV see https://www.x.org/wiki/XorgModuleABIVersions/
RDEPEND="
	>=app-eselect/eselect-opengl-1.0.7
	app-eselect/eselect-opencl
	dev-libs/openssl[${MULTILIB_USEDEP}]
	dev-util/cunit
	media-libs/libomxil-bellagio
	>=media-libs/gst-plugins-base-1.6.0[${MULTILIB_USEDEP}]
	>=media-libs/gstreamer-1.6.0[${MULTILIB_USEDEP}]
	!vulkan? ( >=media-libs/mesa-${PKG_VER_MESA}[openmax?] )
	vulkan? ( >=media-libs/mesa-${PKG_VER_MESA}[openmax?,-vulkan]
		  media-libs/vulkan-loader )
	opencl? ( >=sys-devel/gcc-5.2.0 )
	vdpau? ( >=media-libs/mesa-${PKG_VER_MESA}[-vdpau] )
	>=sys-devel/lld-5.0.0
	>=sys-devel/llvm-5.0.0
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
	freesync? ( || (   sys-kernel/ot-sources[amd]
			 >=sys-kernel/git-sources-5.0_rc1 ) )
"
DEPEND="
	>=sys-kernel/linux-firmware-20161205
"

S="${WORKDIR}"
REQUIRED_USE="!rocr || ( pal orca rocm )" #incomplete
#!hsa

pkg_nofetch() {
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	einfo "Please download"
	einfo "  - ${PN}_${PV}.tar.xz"
	einfo "from ${HOMEPAGE} and place them in ${distdir}"
}

unpack_deb() {
	echo ">>> Unpacking ${1##*/} to ${PWD}"
	unpack $1
	unpacker ./data.tar*
	rm -f debian-binary {control,data}.tar*
}

pkg_setup() {
	CONFIG_CHECK="~DRM_AMDGPU"

	ERROR_KERNEL_DRM_AMDGPU="DRM_AMDGPU which is required for FreeSync or AMDGPU-PRO driver to work"

	linux-info_pkg_setup

	if use pal ; then
		einfo "OpenCL PAL (Portable Abstraction Layer) being used.  It is only supported by GCN 5.x (Vega).  It is still in development."
	fi

	if use orca ; then
		einfo "OpenCL orca is being used. You are enabling the older legacy OpenCL driver implementation used by older fglrx."
	fi

	if use rocm ; then
		einfo "OpenCL ROCm is being used."
	fi

	if use freesync ; then
		if kernel_is -ge 4 15 0 && kernel_is -lt 4 16 0 ; then
			CONFIG_CHECK="~DRM_AMD_DC"
			if ! use vega ; then
				CONFIG_CHECK+=" ~DRM_AMD_DC_PRE_VEGA"
			fi

			ERROR_KERNEL_DRM_AMD_DC="DRM_AMD_DC which is required for FreeSync to work"
			ERROR_KERNEL_DRM_AMD_DC_PRE_VEGA="DRM_AMD_DC_PRE_VEGA which is required for pre Vega cards for FreeSync to work"

			check_extra_config
		elif kernel_is -ge 4 17 0; then
			CONFIG_CHECK="~DRM_AMD_DC"

			ERROR_KERNEL_DRM_AMD_DC="DRM_AMD_DC which is required for FreeSync to work"

			check_extra_config
		else
			eerror "Kernel version not supported for FreeSync."
			die
		fi

		einfo "Checking kernel is properly patched with freesync_capable."
		grep -r -e "\"freesync_capable\"" ${EROOT}/usr/src/linux/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c >/dev/null
		if [[ "$?" != "0" ]] ; then
			einfo "Use the ot-sources with the amd use flag from the oiledmachine-overlay or the >=git-sources-5.0_rc1 ."
			die
		fi
	fi

	if use hsa ; then
		# remove if it works and been tested on hsa hardware
		eerror "hsa not supported and not tested"
	fi

	if use rocr ; then
		eerror "rocr not supported"
	fi
}

src_unpack() {
	default

	unpack_deb "amdgpu-pro-${PKG_VER_STRING}/libgl1-amdgpu-pro-appprofiles_${PKG_VER_STRING}_all.deb"
	unpack_deb "amdgpu-pro-${PKG_VER_STRING}/libdrm-amdgpu-utils_${PKG_VER_LIBDRM}-${PKG_REV}_amd64.deb"

	if use opencl ; then
		# Install clinfo
		unpack_deb "amdgpu-pro-${PKG_VER_STRING}/clinfo-amdgpu-pro_${PKG_VER_STRING}_amd64.deb"

		# Install OpenCL components
		unpack_deb "amdgpu-pro-${PKG_VER_STRING}/libopencl1-amdgpu-pro_${PKG_VER_STRING}_amd64.deb"
		if use pal ; then
			unpack_deb "amdgpu-pro-${PKG_VER_STRING}/opencl-amdgpu-pro-icd_${PKG_VER_STRING}_amd64.deb"
		fi

		if use rocm ; then
			unpack_deb "amdgpu-pro-${PKG_VER_STRING}/rocm-amdgpu-pro_${PKG_VER_STRING}_amd64.deb"
			#unpack_deb "amdgpu-pro-${PKG_VER_STRING}/rocm-amdgpu-pro-icd_${PKG_VER_STRING}_amd64.deb" fixme
			unpack_deb "amdgpu-pro-${PKG_VER_STRING}/rocm-amdgpu-pro-opencl_${PKG_VER_STRING}_amd64.deb"
			unpack_deb "amdgpu-pro-${PKG_VER_STRING}/rocm-amdgpu-pro-opencl-dev_${PKG_VER_STRING}_amd64.deb"
		fi

		if use rocr ; then
			unpack_deb "amdgpu-pro-${PKG_VER_STRING}/rocr-amdgpu_1.1.6-${PKG_REV}_amd64.deb"
			unpack_deb "amdgpu-pro-${PKG_VER_STRING}/rocr-amdgpu-dev_1.1.6-${PKG_REV}_amd64.deb"
		fi

		if use orca ; then
			unpack_deb "amdgpu-pro-${PKG_VER_STRING}/opencl-orca-amdgpu-pro-icd_${PKG_VER_STRING}_amd64.deb"
			if use abi_x86_32 ; then
				unpack_deb "amdgpu-pro-${PKG_VER_STRING}/opencl-orca-amdgpu-pro-icd_${PKG_VER_STRING}_i386.deb"
			fi
		fi

		unpack_deb "amdgpu-pro-${PKG_VER_STRING}/roct-amdgpu-pro_${PKG_VER_ROCT}-${PKG_REV}_amd64.deb"
		unpack_deb "amdgpu-pro-${PKG_VER_STRING}/roct-amdgpu-pro-dev_${PKG_VER_ROCT}-${PKG_REV}_amd64.deb"

		if use abi_x86_32 ; then
			unpack_deb "amdgpu-pro-${PKG_VER_STRING}/libopencl1-amdgpu-pro_${PKG_VER_STRING}_i386.deb"
			#unpack_deb "amdgpu-pro-${PKG_VER_STRING}/opencl-amdgpu-pro-icd_${PKG_VER_STRING}_i386.deb" fixme
		fi
	fi

	if use vulkan ; then
		# Install Vulkan driver
		unpack_deb "amdgpu-pro-${PKG_VER_STRING}/vulkan-amdgpu-pro_${PKG_VER_STRING}_amd64.deb"

		if use abi_x86_32 ; then
			unpack_deb "amdgpu-pro-${PKG_VER_STRING}/vulkan-amdgpu-pro_${PKG_VER_STRING}_i386.deb"
		fi
	fi

	if use opengl ; then
		# Install OpenGL
		unpack_deb "amdgpu-pro-${PKG_VER_STRING}/libdrm-amdgpu-amdgpu1_${PKG_VER_LIBDRM}-${PKG_REV}_amd64.deb"
		unpack_deb "amdgpu-pro-${PKG_VER_STRING}/libdrm-amdgpu-radeon1_${PKG_VER_LIBDRM}-${PKG_REV}_amd64.deb"
		unpack_deb "amdgpu-pro-${PKG_VER_STRING}/libgl1-amdgpu-pro-glx_${PKG_VER_STRING}_amd64.deb"
		unpack_deb "amdgpu-pro-${PKG_VER_STRING}/libgl1-amdgpu-pro-ext_${PKG_VER_STRING}_amd64.deb"
		unpack_deb "amdgpu-pro-${PKG_VER_STRING}/libgl1-amdgpu-pro-dri_${PKG_VER_STRING}_amd64.deb"

		# Install GBM
		unpack_deb "amdgpu-pro-${PKG_VER_STRING}/libgbm1-amdgpu-pro_${PKG_VER_STRING}_amd64.deb"
		unpack_deb "amdgpu-pro-${PKG_VER_STRING}/libgbm1-amdgpu-pro-base_${PKG_VER_STRING}_all.deb"

		if use abi_x86_32 ; then
			unpack_deb "amdgpu-pro-${PKG_VER_STRING}/libdrm-amdgpu-amdgpu1_${PKG_VER_LIBDRM}-${PKG_REV}_i386.deb"
			unpack_deb "amdgpu-pro-${PKG_VER_STRING}/libdrm-amdgpu-radeon1_${PKG_VER_LIBDRM}-${PKG_REV}_i386.deb"
			unpack_deb "amdgpu-pro-${PKG_VER_STRING}/libgl1-amdgpu-pro-glx_${PKG_VER_STRING}_i386.deb"
			unpack_deb "amdgpu-pro-${PKG_VER_STRING}/libgl1-amdgpu-pro-dri_${PKG_VER_STRING}_i386.deb"

			# Install GBM
			unpack_deb "amdgpu-pro-${PKG_VER_STRING}/libgbm1-amdgpu-pro_${PKG_VER_STRING}_i386.deb"
		fi
	fi

	if use gles2 ; then
		# Install GLES2
		unpack_deb "amdgpu-pro-${PKG_VER_STRING}/libgles2-amdgpu-pro_${PKG_VER_STRING}_amd64.deb"

		if use abi_x86_32 ; then
			unpack_deb "amdgpu-pro-${PKG_VER_STRING}/libgles2-amdgpu-pro_${PKG_VER_STRING}_i386.deb"
		fi
	fi

	if use egl ; then
		# Install EGL libs
		unpack_deb "amdgpu-pro-${PKG_VER_STRING}/libegl1-amdgpu-pro_${PKG_VER_STRING}_amd64.deb"

		if use abi_x86_32 ; then
			unpack_deb "amdgpu-pro-${PKG_VER_STRING}/libegl1-amdgpu-pro_${PKG_VER_STRING}_i386.deb"
		fi
	fi

	if use openmax ; then
		# Install gstreamer OpenMAX plugin
		unpack_deb "amdgpu-pro-${PKG_VER_STRING}/gst-omx-amdgpu_${PKG_VER_GST_OMX}-${PKG_REV}_amd64.deb"
		if use abi_x86_32 ; then
			unpack_deb "amdgpu-pro-${PKG_VER_STRING}/gst-omx-amdgpu_${PKG_VER_GST_OMX}-${PKG_REV}_i386.deb"
		fi
	fi

	if use vdpau ; then
		# Install VDPAU
		unpack_deb "amdgpu-pro-${PKG_VER_STRING}/mesa-amdgpu-vdpau-drivers_${PKG_VER_MESA}-${PKG_REV}_amd64.deb"

		if use abi_x86_32 ; then
			unpack_deb "amdgpu-pro-${PKG_VER_STRING}/mesa-amdgpu-vdpau-drivers_${PKG_VER_MESA}-${PKG_REV}_i386.deb"
		fi
	fi

	# Install xorg drivers
	unpack_deb "amdgpu-pro-${PKG_VER_STRING}/xserver-xorg-amdgpu-video-amdgpu_${PKG_VER_XORG_VIDEO_AMDGPU_DRV}-${PKG_REV}_amd64.deb"

	unpack_deb "amdgpu-pro-${PKG_VER_STRING}/ids-amdgpu_${PKG_VER_ID}-${PKG_REV}_all.deb"
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

	eapply_user
}

src_install() {
	insinto /lib/udev/rules.d/
	doins "${T}/91-drm_pro-modeset.rules"
	insinto /etc/ld.so.conf.d
	doins "${T}/01-amdgpu.conf"
	insinto /etc/X11/xorg.conf.d
	doins "${T}/10-screen.conf"
	doins "${T}/10-monitor.conf"
	doins "${T}/10-device.conf"
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
		# Install clinfo
		into /usr/
		cd opt/amdgpu-pro/bin/
		dobin clinfo
		cd ../../..

		# Install OpenCL components
		insinto /etc/OpenCL/vendors
		if use pal ; then
			doins etc/OpenCL/vendors/amdocl64.icd
		fi

		if use rocr ; then
			doins etc/OpenCL/vendors/amdocl-rocr64.icd
		fi

		if use orca ; then
			doins etc/OpenCL/vendors/amdocl-orca64.icd
			if use abi_x86_32 ; then
				doins etc/OpenCL/vendors/amdocl-orca32.icd
			fi
		fi

		exeinto /usr/lib64/OpenCL/vendors/amdgpu
		doexe opt/amdgpu-pro/lib/x86_64-linux-gnu/libamdocl*
		doexe opt/amdgpu-pro/lib/x86_64-linux-gnu/libOpenCL.so.1
		dosym libOpenCL.so.1 /usr/lib64/OpenCL/vendors/amdgpu/libOpenCL.so

		if use rocr ; then
			doexe opt/amdgpu-pro/lib/x86_64-linux-gnu/libamdocl-rocr64.so
		fi

		#doexe opt/amdgpu-pro/lib/x86_64-linux-gnu/libcltrace.so #fixme

		if use abi_x86_32 ; then
			# Install 32 bit OpenCL ICD
			insinto /etc/OpenCL/vendors
			#doins etc/OpenCL/vendors/amdocl32.icd #fixme
			exeinto /usr/lib32/OpenCL/vendors/amdgpu
			#doexe opt/amdgpu-pro/lib/i386-linux-gnu/libamdocl* #fixme
			if use orca ; then
				doexe opt/amdgpu-pro/lib/i386-linux-gnu/libamdocl*
			fi

			# Install 32 bit OpenCL library
			doexe opt/amdgpu-pro/lib/i386-linux-gnu/libOpenCL.so.1
			dosym libOpenCL.so.1 /usr/lib32/OpenCL/vendors/amdgpu/libOpenCL.so
		fi
	fi

	if use hsa ; then
		exeinto /usr/lib64/opengl/amdgpu/lib/
		doexe opt/amdgpu-pro/lib/x86_64-linux-gnu/libhsakmt.so.1.0.0
		dosym libhsakmt.so.1.0.0 /usr/lib64/opengl/amdgpu/lib/libhsakmt.so.1.0
		dosym libhsakmt.so.1.0.0 /usr/lib64/opengl/amdgpu/lib/libhsakmt.so.1
		dosym libhsakmt.so.1.0.0 /usr/lib64/opengl/amdgpu/lib/libhsakmt.so

		insinto /usr/include/libhsakmt
		doins opt/amdgpu-pro/include/libhsakmt/hsakmt*

		insinto /usr/include/libhsakmt/linux
		doins opt/amdgpu-pro/include/libhsakmt/linux/kfd_ioctl.h
	fi

	if use vulkan ; then
		# Install Vulkan driver
		insinto /etc/vulkan/icd.d
		doins "${T}/amd_icd64.json"
		exeinto /usr/lib64/vulkan/vendors/amdgpu
		doexe opt/amdgpu-pro/lib/x86_64-linux-gnu/amdvlk64.so

		if use abi_x86_32 ; then
			# Install Vulkan driver
			insinto /etc/vulkan/icd.d
			doins "${T}/amd_icd32.json"
			exeinto /usr/lib32/vulkan/vendors/amdgpu
			doexe opt/amdgpu-pro/lib/i386-linux-gnu/amdvlk32.so
		fi
	fi

	if use opengl ; then
		# Install OpenGL
		exeinto /usr/lib64/opengl/amdgpu/lib
		doexe opt/amdgpu/lib/x86_64-linux-gnu/libdrm_amdgpu.so.1.0.0
		dosym libdrm_amdgpu.so.1.0.0 /usr/lib64/opengl/amdgpu/lib/libdrm_amdgpu.so.1
		dosym libdrm_amdgpu.so.1.0.0 /usr/lib64/opengl/amdgpu/lib/libdrm_amdgpu.so
		doexe opt/amdgpu-pro/lib/x86_64-linux-gnu/libGL.so.1.2
		dosym libGL.so.1.2 /usr/lib64/opengl/amdgpu/lib/libGL.so.1
		dosym libGL.so.1.2 /usr/lib64/opengl/amdgpu/lib/libGL.so
		exeinto /usr/lib64/opengl/radeon/lib
		doexe opt/amdgpu/lib/x86_64-linux-gnu/libdrm_radeon.so.1.0.1
		dosym libdrm_radeon.so.1.0.1 /usr/lib64/opengl/radeon/lib/libdrm_radeon.so.1
		dosym libdrm_radeon.so.1.0.1 /usr/lib64/opengl/radeon/lib/libdrm_radeon.so
		insinto /etc/amd/
		doins etc/amd/amdrc
		exeinto /usr/lib64/opengl/amdgpu/extensions
		doexe opt/amdgpu-pro/lib/xorg/modules/extensions/libglx.so
		exeinto /usr/lib64/opengl/amdgpu/dri
		doexe usr/lib/x86_64-linux-gnu/dri/amdgpu_dri.so
		dosym ../opengl/amdgpu/dri/amdgpu_dri.so /usr/lib64/dri/amdgpu_dri.so
		dosym ../../opengl/amdgpu/dri/amdgpu_dri.so /usr/lib64/x86_64-linux-gnu/dri/amdgpu_dri.so

		# Install GBM
		exeinto /usr/lib64/opengl/amdgpu/lib
		doexe opt/amdgpu-pro/lib/x86_64-linux-gnu/libgbm.so.1.0.0
		dosym libgbm.so.1.0.0 /usr/lib64/opengl/amdgpu/lib/libgbm.so.1
		dosym libgbm.so.1.0.0 /usr/lib64/opengl/amdgpu/lib/libgbm.so
		exeinto /usr/lib64/opengl/amdgpu/gbm
		doexe opt/amdgpu-pro/lib/x86_64-linux-gnu/gbm/gbm_amdgpu.so
		dosym gbm_amdgpu.so /usr/lib64/opengl/amdgpu/gbm/libdummy.so
		dosym opengl/amdgpu/gbm /usr/lib64/gbm
		insinto /etc/gbm/
		doins etc/gbm/gbm.conf

		if use abi_x86_32 ; then
			# Install 32 bit OpenGL
			exeinto /usr/lib32/opengl/amdgpu/lib
			doexe opt/amdgpu/lib/i386-linux-gnu/libdrm_amdgpu.so.1.0.0
			dosym libdrm_amdgpu.so.1.0.0 /usr/lib32/opengl/amdgpu/lib/libdrm_amdgpu.so.1
			dosym libdrm_amdgpu.so.1.0.0 /usr/lib32/opengl/amdgpu/lib/libdrm_amdgpu.so
			doexe opt/amdgpu-pro/lib/i386-linux-gnu/libGL.so.1.2
			dosym libGL.so.1.2 /usr/lib32/opengl/amdgpu/lib/libGL.so.1
			dosym libGL.so.1.2 /usr/lib32/opengl/amdgpu/lib/libGL.so
			exeinto /usr/lib32/opengl/radeon/lib
			doexe opt/amdgpu/lib/i386-linux-gnu/libdrm_radeon.so.1.0.1
			dosym libdrm_radeon.so.1.0.1 /usr/lib32/opengl/radeon/lib/libdrm_radeon.so.1
			dosym libdrm_radeon.so.1.0.1 /usr/lib32/opengl/radeon/lib/libdrm_radeon.so
			exeinto /usr/lib32/opengl/amdgpu/dri
			doexe usr/lib/i386-linux-gnu/dri/amdgpu_dri.so
			dosym ../opengl/amdgpu/dri/amdgpu_dri.so /usr/lib32/dri/amdgpu_dri.so
			dosym ../../opengl/amdgpu/dri/amdgpu_dri.so /usr/lib64/i386-linux-gnu/dri/amdgpu_dri.so

			# Install GBM
			exeinto /usr/lib32/opengl/amdgpu/lib
			doexe opt/amdgpu-pro/lib/i386-linux-gnu/libgbm.so.1.0.0
			dosym libgbm.so.1.0.0 /usr/lib32/opengl/amdgpu/lib/libgbm.so.1
			dosym libgbm.so.1.0.0 /usr/lib32/opengl/amdgpu/lib/libgbm.so
			exeinto /usr/lib32/opengl/amdgpu/gbm
			doexe opt/amdgpu-pro/lib/i386-linux-gnu/gbm/gbm_amdgpu.so
			dosym gbm_amdgpu.so /usr/lib32/opengl/amdgpu/gbm/libdummy.so
			dosym opengl/amdgpu/gbm /usr/lib32/gbm
		fi
	fi

	if use gles2 ; then
		# Install GLES2
		exeinto /usr/lib64/opengl/amdgpu/lib
		doexe opt/amdgpu-pro/lib/x86_64-linux-gnu/libGLESv2.so.2
		dosym libGLESv2.so.2 /usr/lib64/opengl/amdgpu/lib/libGLESv2.so

		if use abi_x86_32 ; then
			exeinto /usr/lib32/opengl/amdgpu/lib
			doexe opt/amdgpu-pro/lib/i386-linux-gnu/libGLESv2.so.2
			dosym libGLESv2.so.2 /usr/lib32/opengl/amdgpu/lib/libGLESv2.so
		fi
	fi

	if use egl ; then
		# Install EGL libs
		exeinto /usr/lib64/opengl/amdgpu/lib
		doexe opt/amdgpu-pro/lib/x86_64-linux-gnu/libEGL.so.1
		dosym libEGL.so.1 /usr/lib64/opengl/amdgpu/lib/libEGL.so

		if use abi_x86_32 ; then
			exeinto /usr/lib32/opengl/amdgpu/lib
			doexe opt/amdgpu-pro/lib/i386-linux-gnu/libEGL.so.1
			dosym libEGL.so.1 /usr/lib32/opengl/amdgpu/lib/libEGL.so
		fi
	fi

	if use vdpau ; then
		# Install VDPAU
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
		dosym libvdpau_r600.so.1.0.0 /usr/lib64/vdpau/libvdpau_r600.so.1.
		dosym libvdpau_r600.so.1.0.0 /usr/lib64/vdpau/libvdpau_r600.so
		dosym libvdpau_radeonsi.so.1.0.0 /usr/lib64/vdpau/libvdpau_radeonsi.so.1.0
		dosym libvdpau_radeonsi.so.1.0.0 /usr/lib64/vdpau/libvdpau_radeonsi.so.1
		dosym libvdpau_radeonsi.so.1.0.0 /usr/lib64/vdpau/libvdpau_radeonsi.so

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
			dosym libvdpau_r600.so.1.0.0 /usr/lib32/vdpau/libvdpau_r600.so.1.
			dosym libvdpau_r600.so.1.0.0 /usr/lib32/vdpau/libvdpau_r600.so
			dosym libvdpau_radeonsi.so.1.0.0 /usr/lib32/vdpau/libvdpau_radeonsi.so.1.0
			dosym libvdpau_radeonsi.so.1.0.0 /usr/lib32/vdpau/libvdpau_radeonsi.so.1
			dosym libvdpau_radeonsi.so.1.0.0 /usr/lib32/vdpau/libvdpau_radeonsi.so

		fi
	fi

	# missing or can't find it
	#if use vaapi ; then
	#	exeinto /usr/lib64/opengl/amdgpu/dri/
	#	doexe opt/amdgpu/lib/x86_64-linux-gnu/dri/radeonsi_drv_video.so
	#	doexe opt/amdgpu/lib/x86_64-linux-gnu/dri/r600_drv_video.so
	#	if use abi_x86_32 ; then
	#		exeinto /usr/lib32/opengl/amdgpu/dri/
	#		doexe opt/amdgpu/lib/i386-linux-gnu/dri/radeonsi_drv_video.so
	#		doexe opt/amdgpu/lib/i386-linux-gnu/dri/r600_drv_video.so
	#	fi
	#fi

	# Install xorg drivers
	exeinto /usr/lib64/opengl/amdgpu/modules/drivers
	doexe opt/amdgpu/lib/xorg/modules/drivers/amdgpu_drv.so

	if use openmax ; then
		# Install gstreamer OpenMAX plugin
		insinto /etc/xdg/
		doins etc/xdg/gstomx.conf
		exeinto /usr/lib64/gstreamer-1.0/
		doexe opt/amdgpu/lib/x86_64-linux-gnu/gstreamer-1.0/libgstomx.so
		if use abi_x86_32 ; then
			exeinto /usr/lib32/gstreamer-1.0/
			doexe opt/amdgpu/lib/i386-linux-gnu/gstreamer-1.0/libgstomx.so
		fi
	fi

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
}
