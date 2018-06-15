# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MULTILIB_COMPAT=( abi_x86_{32,64} )
#inherit eutils linux-info multilib-build unpacker
inherit multilib-build unpacker

DESCRIPTION="New generation AMD closed-source drivers for Southern Islands (HD7730 Series) and newer chipsets"
HOMEPAGE="http://support.amd.com/en-us/kb-articles/Pages/AMDGPU-PRO-Driver-for-Linux-Release-Notes.aspx"
PKG_VER=${PV:0:5}
PKG_REV=${PV:6:6}
PKG_VER_STRING=${PKG_VER}-${PKG_REV}
PKG_VER_LIBDRM="2.4.91"
PKG_VER_MESA="18.0.0"
PKG_VER_MESA_MAX="18.1.0"
PKG_VER_HSA="1.1.6"
PKG_VER_ROCT="1.0.8"
SRC_URI="https://www2.ati.com/drivers/linux/ubuntu/amdgpu-pro-${PKG_VER_STRING}.tar.xz"

RESTRICT="fetch strip"

# The binary blobs include binaries for other open sourced packages, we don't want to include those parts, if they are
# selected, they should come from portage.
IUSE="+gles2 +opencl +opengl +vdpau +vulkan hsa rocm rocr freesync pal orca"

LICENSE="AMD GPL-2 QPL-1.0"
KEYWORDS="~amd64"
SLOT="1"

RDEPEND="
	>=app-eselect/eselect-opengl-1.0.7
	app-eselect/eselect-opencl
	dev-libs/openssl[${MULTILIB_USEDEP}]
	dev-util/cunit
	>=media-libs/gst-plugins-base-1.6.0[${MULTILIB_USEDEP}]
	>=media-libs/gstreamer-1.6.0[${MULTILIB_USEDEP}]
	media-libs/libomxil-bellagio
	!vulkan? ( >=media-libs/mesa-${PKG_VER_MESA}[openmax]
		   <media-libs/mesa-${PKG_VER_MESA_MAX}[openmax] )
	vulkan? ( >=media-libs/mesa-${PKG_VER_MESA}[openmax,-vulkan]
		  <media-libs/mesa-${PKG_VER_MESA_MAX}[openmax,-vulkan]
		  media-libs/vulkan-loader )
	opencl? ( >=sys-devel/gcc-5.2.0 )
	vdpau? ( >=media-libs/mesa-${PKG_VER_MESA}[-vdpau]
		 <media-libs/mesa-${PKG_VER_MESA_MAX}[-vdpau] )
	>=sys-devel/lld-5.0.0
	>=sys-devel/llvm-5.0.0
	>=sys-libs/ncurses-5.0.0:5[${MULTILIB_USEDEP},tinfo]
	=x11-base/xorg-drivers-1.19
	=x11-base/xorg-server-1.19*[glamor]
	>=x11-libs/libdrm-${PKG_VER_LIBDRM}
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libXext[${MULTILIB_USEDEP}]
	x11-libs/libXinerama[${MULTILIB_USEDEP}]
	x11-libs/libXrandr[${MULTILIB_USEDEP}]
	x11-libs/libXrender[${MULTILIB_USEDEP}]
	x11-proto/inputproto
	x11-proto/xf86miscproto
	x11-proto/xf86vidmodeproto
	x11-proto/xineramaproto
	freesync? ( || ( >=sys-kernel/gentoo-sources-4.15.0
                         >=sys-kernel/vanilla-sources-4.15.0
                         >=sys-kernel/ck-sources-4.15.0
                         >=sys-kernel/git-sources-4.15
                         >=sys-kernel/hardened-sources-4.15.0
                         >=sys-kernel/pf-sources-4.15
                         >=sys-kernel/rt-sources-4.15.0
                         >=sys-kernel/zen-sources-4.15.0
                         >=sys-kernel/aufs-sources-4.15.0 ) )
"
DEPEND="
	>=sys-kernel/linux-firmware-20161205
"

S="${WORKDIR}"
REQUIRED_USE="!hsa !rocr || ( pal orca rocm )" #incomplete

pkg_nofetch() {
	einfo "Please download"
	einfo "  - ${PN}_${PV}.tar.xz"
	einfo "from ${HOMEPAGE} and place them in ${DISTDIR}"
}

unpack_deb() {
	echo ">>> Unpacking ${1##*/} to ${PWD}"
	unpack $1
	unpacker ./data.tar*
	rm -f debian-binary {control,data}.tar*
}

pkg_setup() {
	ewarn "This driver does not work on RX 480.  It may segfault on X startup."
	sleep 5

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
		grep -r -e "\"freesync_capable\"" ${EROOT}/usr/src/linux/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
		if [[ "$?" != "0" ]] ; then
			einfo "You need to fetch the branch amd-staging-4.15.  Diff it against 4.15 vanilla and stick it in your /etc/portage/patches folder."
			einfo "git clone -b amd-staging-4.15 git://people.freedesktop.org/~agd5f/linux"
			einfo 'git diff d8a5b80568a9cb66810e75b182018e9edb68e8ff..origin/amd-staging-4.15 > ~/drm-staging-4.15.patch'
			einfo 'd8a5b80568a9cb66810e75b182018e9edb68e8ff refers to tag v4.15 of torvalds/linux'
			einfo
			einfo "v4.15 only supported since drm-next head is being reworked."
			die
		fi
	fi

	if use hsa ; then
		eerror "hsa not supported"
	fi
	if use hsa ; then
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
		
		if use hsa ; then
			unpack_deb "amdgpu-pro-${PKG_VER_STRING}/hsa-ext-amdgpu-finalize_${PKG_VER_HSA}-${PKG_REV}_amd64.deb"
			unpack_deb "amdgpu-pro-${PKG_VER_STRING}/hsa-ext-amdgpu-image_${PKG_VER_HSA}-${PKG_REV}_amd64.deb"
			unpack_deb "amdgpu-pro-${PKG_VER_STRING}/hsa-runtime-tools-amdgpu_${PKG_VER_HSA}-${PKG_REV}_amd64.deb"
			unpack_deb "amdgpu-pro-${PKG_VER_STRING}/hsa-runtime-tools-amdgpu-dev_${PKG_VER_HSA}-${PKG_REV}_amd64.deb"
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
	
	# Install EGL libs
	unpack_deb "amdgpu-pro-${PKG_VER_STRING}/libegl1-amdgpu-pro_${PKG_VER_STRING}_amd64.deb"
	
	if use abi_x86_32 ; then
		unpack_deb "amdgpu-pro-${PKG_VER_STRING}/libegl1-amdgpu-pro_${PKG_VER_STRING}_i386.deb"
	fi
	
	if use vdpau ; then
		# Install VDPAU
		unpack_deb "amdgpu-pro-${PKG_VER_STRING}/mesa-amdgpu-vdpau-drivers_${PKG_VER_MESA}-${PKG_REV}_amd64.deb"
		
		if use abi_x86_32 ; then
			unpack_deb "amdgpu-pro-${PKG_VER_STRING}/mesa-amdgpu-vdpau-drivers_${PKG_VER_MESA}-${PKG_REV}_i386.deb"
		fi
	fi
	
	# Install xorg drivers
	unpack_deb "amdgpu-pro-${PKG_VER_STRING}/xserver-xorg-amdgpu-video-amdgpu_1.4.0-${PKG_REV}_amd64.deb"
	
	# Install gstreamer OpenMAX plugin
	unpack_deb "amdgpu-pro-${PKG_VER_STRING}/gst-omx-amdgpu_1.0.0.1-${PKG_REV}_amd64.deb"
	if use abi_x86_32 ; then
		unpack_deb "amdgpu-pro-${PKG_VER_STRING}/gst-omx-amdgpu_1.0.0.1-${PKG_REV}_i386.deb"
	fi

	unpack_deb "amdgpu-pro-${PKG_VER_STRING}/ids-amdgpu_1.0.0-${PKG_REV}_all.deb"
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
	Option		"TearFree" "on"
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
	insinto /etc/udev/rules.d/
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
		if use hsa ; then
			doexe opt/amdgpu-pro/lib/x86_64-linux-gnu/libhsa-ext-finalize64.so.1.0.0
			dosym libhsa-ext-finalize64.so.1.0.0 /usr/lib64/OpenCL/vendors/amdgpu/libhsa-ext-finalize64.so.1.0
			dosym libhsa-ext-finalize64.so.1.0.0 /usr/lib64/OpenCL/vendors/amdgpu/libhsa-ext-finalize64.so.1
			dosym libhsa-ext-finalize64.so.1.0.0 /usr/lib64/OpenCL/vendors/amdgpu/libhsa-ext-finalize64.so
			doexe opt/amdgpu-pro/lib/x86_64-linux-gnu/libhsa-ext-image64.so.1.0.0
			dosym libhsa-ext-image64.so.1.0.0 /usr/lib64/OpenCL/vendors/amdgpu/libhsa-ext-image64.so.1.0
			dosym libhsa-ext-image64.so.1.0.0 /usr/lib64/OpenCL/vendors/amdgpu/libhsa-ext-image64.so.1
			dosym libhsa-ext-image64.so.1.0.0 /usr/lib64/OpenCL/vendors/amdgpu/libhsa-ext-image64.so
			doexe opt/amdgpu-pro/lib/x86_64-linux-gnu/libhsa-runtime-tools64.so.1.0.0
			dosym libhsa-runtime-tools64.so.1.0.0 /usr/lib64/OpenCL/vendors/amdgpu/libhsa-runtime-tools64.so.1.0
			dosym libhsa-runtime-tools64.so.1.0.0 /usr/lib64/OpenCL/vendors/amdgpu/libhsa-runtime-tools64.so.1
			dosym libhsa-runtime-tools64.so.1.0.0 /usr/lib64/OpenCL/vendors/amdgpu/libhsa-runtime-tools64.so
		fi
		if use rocr ; then
			doexe opt/amdgpu-pro/lib/x86_64-linux-gnu/libamdocl-rocr64.so
		fi
		#doexe opt/amdgpu-pro/lib/x86_64-linux-gnu/libcltrace.so #fixme
		if use hsa ; then
			doexe opt/amdgpu-pro/lib/x86_64-linux-gnu/libhsa-runtime64.so.1.0.0
			dosym libhsa-runtime64.so.1.0.0 /usr/lib64/OpenCL/vendors/amdgpu/libhsa-runtime64.so.1.0
			dosym libhsa-runtime64.so.1.0.0 /usr/lib64/OpenCL/vendors/amdgpu/libhsa-runtime64.so.1
			dosym libhsa-runtime64.so.1.0.0 /usr/lib64/OpenCL/vendors/amdgpu/libhsa-runtime64.so
		fi
		doexe opt/amdgpu-pro/lib/x86_64-linux-gnu/libhsakmt.so.1.0.0
		dosym libhsakmt.so.1.0.0 /usr/lib64/OpenCL/vendors/amdgpu/libhsakmt.so.1.0
		dosym libhsakmt.so.1.0.0 /usr/lib64/OpenCL/vendors/amdgpu/libhsakmt.so.1
		dosym libhsakmt.so.1.0.0 /usr/lib64/OpenCL/vendors/amdgpu/libhsakmt.so
		
		if use hsa ; then
			insinto /usr/include/hsa
			doins opt/amdgpu-pro/include/hsa/hsa_ext_debugger.h
			doins opt/amdgpu-pro/include/hsa/hsa_ext_profiler.h
			doins opt/amdgpu-pro/include/hsa/amd_hsa_tools_interfaces.h
			doins opt/amdgpu-pro/include/hsa/Brig.h
			doins opt/amdgpu-pro/include/hsa/amd*
			doins opt/amdgpu-pro/include/hsa/hsa*
		fi
		
		insinto /usr/include/libhsakmt
		doins opt/amdgpu-pro/include/libhsakmt/hsakmt*
		
		insinto /usr/include/libhsakmt/linux
		doins opt/amdgpu-pro/include/libhsakmt/linux/kfd_ioctl.h
		
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
	
	# Install EGL libs
	exeinto /usr/lib64/opengl/amdgpu/lib
	doexe opt/amdgpu-pro/lib/x86_64-linux-gnu/libEGL.so.1
	dosym libEGL.so.1 /usr/lib64/opengl/amdgpu/lib/libEGL.so

	if use abi_x86_32 ; then
		exeinto /usr/lib32/opengl/amdgpu/lib
		doexe opt/amdgpu-pro/lib/i386-linux-gnu/libEGL.so.1
		dosym libEGL.so.1 /usr/lib32/opengl/amdgpu/lib/libEGL.so
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
		#exeinto /usr/lib64/opengl/amdgpu/dri/
		#doexe opt/amdgpu-pro/lib/x86_64-linux-gnu/dri/radeonsi_drv_video.so
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
			#exeinto /usr/lib32/opengl/amdgpu/dri/
			#doexe opt/amdgpu-pro/lib/i386-linux-gnu/dri/radeonsi_drv_video.so
		fi
	fi
	
	# Install xorg drivers
	exeinto /usr/lib64/opengl/amdgpu/modules/drivers
	doexe opt/amdgpu/lib/xorg/modules/drivers/amdgpu_drv.so
	
	# Install gstreamer OpenMAX plugin
	insinto /etc/xdg/
	doins etc/xdg/gstomx.conf
	exeinto /usr/lib64/gstreamer-1.0/
	doexe opt/amdgpu/lib/x86_64-linux-gnu/gstreamer-1.0/libgstomx.so
	if use abi_x86_32 ; then
		exeinto /usr/lib32/gstreamer-1.0/
		doexe opt/amdgpu/lib/i386-linux-gnu/gstreamer-1.0/libgstomx.so
	fi
	
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
}
