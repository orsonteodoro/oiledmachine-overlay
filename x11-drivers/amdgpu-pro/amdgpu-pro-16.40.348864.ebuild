# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MULTILIB_COMPAT=( abi_x86_{32,64} )
inherit eutils multilib-build unpacker

DESCRIPTION="Ati precompiled drivers for Radeon Evergreen (HD5000 Series) and newer chipsets"
HOMEPAGE="http://support.amd.com/en-us/kb-articles/Pages/AMDGPU-PRO-Beta-Driver-for-Vulkan-Release-Notes.aspx"
BUILD_VER=16.40-348864
VDPAU_BUILD_VER=11.2.2-348864
LIBDRM_BUILD_VER=2.4.66-348864
XSERVER_BUILD_VER=1.1.99-348864

SRC_URI="https://www2.ati.com/drivers/beta/${PN}-${BUILD_VER}.tar.xz"

RESTRICT="fetch strip"

IUSE="gles2 opencl +opengl vdpau +vulkan"

LICENSE="AMD GPL-2 QPL-1.0"
KEYWORDS=""
SLOT="1"

RDEPEND="
	>=app-eselect/eselect-opengl-1.0.7
	app-eselect/eselect-opencl
	sys-kernel/amdgpu-pro-dkms
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libXext[${MULTILIB_USEDEP}]
	x11-libs/libXinerama[${MULTILIB_USEDEP}]
	x11-libs/libXrandr[${MULTILIB_USEDEP}]
	x11-libs/libXrender[${MULTILIB_USEDEP}]
	vulkan? (
		media-libs/vulkan-base
	)
	!x11-drivers/ati-drivers
"

DEPEND="${RDEPEND}
	x11-proto/inputproto
	x11-proto/xf86miscproto
	x11-proto/xf86vidmodeproto
	x11-proto/xineramaproto
"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Please download"
	einfo "  - ${PN}_${BUILD_VER}.tar.xz" for Ubuntu 16.04
	einfo "from ${HOMEPAGE} and place them in ${DISTDIR}"
}

unpack_deb() {
	echo ">>> Unpacking ${1##*/} to ${PWD}"
	unpack $1
	unpacker ./data.tar*

	# Clean things up #458658.  No one seems to actually care about
	# these, so wait until someone requests to do something else ...
	rm -f debian-binary {control,data}.tar*
}

src_prepare() {
	default

	ln -s "amdgpu-pro-${BUILD_VER}" "amdgpu-pro-driver"

	#unpack_deb "./amdgpu-pro-driver/amdgpu-pro-core_${BUILD_VER}_amd64.deb"
	#unpack_deb "./amdgpu-pro-driver/amdgpu-pro-graphics_${BUILD_VER}_amd64.deb"
	unpack_deb "./amdgpu-pro-driver/amdgpu-pro_${BUILD_VER}_amd64.deb"
	unpack_deb "./amdgpu-pro-driver/amdgpu-pro-lib32_${BUILD_VER}_amd64.deb"

	rm -rf ./lib

	if use opencl ; then
		if use amd64 ; then
			unpack_deb "./amdgpu-pro-driver/clinfo-amdgpu-pro_${BUILD_VER}_amd64.deb"

			#unpack_deb "./amdgpu-pro-driver/libopencl-dev_${BUILD_VER}_amd64.deb"
			unpack_deb "./amdgpu-pro-driver/libopencl1-amdgpu-pro_${BUILD_VER}_amd64.deb"
			unpack_deb "./amdgpu-pro-driver/opencl-amdgpu-pro-icd_${BUILD_VER}_amd64.deb"

			mkdir -p ./usr/lib64/OpenCL/vendors/amdgpu-pro
			#cp -d ./usr/lib/x86_64-linux-gnu/amdgpu-pro/* ./usr/lib64/OpenCL/vendors/amdgpu-pro
			cp -d ./opt/amdgpu-pro/lib/x86_64-linux-gnu/* ./usr/lib64/OpenCL/vendors/amdgpu-pro

			echo "/usr/lib64/OpenCL/vendors/amdgpu-pro/libamdocl64.so" > ./etc/OpenCL/vendors/amdocl64.icd
		fi
		#unpack_deb "./amdgpu-pro-driver/libopencl-dev_${BUILD_VER}_i386.deb"
		unpack_deb "./amdgpu-pro-driver/libopencl1-amdgpu-pro_${BUILD_VER}_i386.deb"
		unpack_deb "./amdgpu-pro-driver/opencl-amdgpu-pro-icd_${BUILD_VER}_i386.deb"

		mkdir -p ./usr/lib32/OpenCL/vendors/amdgpu-pro
		#cp -d ./usr/lib32/i386-linux-gnu/amdgpu-pro/* ./usr/lib32/OpenCL/vendors/amdgpu-pro
		cp -d ./opt/amdgpu-pro/lib/i386-linux-gnu/* ./usr/lib32/OpenCL/vendors/amdgpu-pro

		echo "/usr/lib32/OpenCL/vendors/amdgpu-pro/libamdocl32.so" > ./etc/OpenCL/vendors/amdocl32.icd

		chmod -x ./etc/OpenCL/vendors/*
		#rm -rf ./usr/lib
		rm -rf ./opt/amdgpu-pro/lib
	fi

	if use vulkan ; then
		if use amd64 ; then
			unpack_deb "./amdgpu-pro-driver/amdgpu-pro-vulkan-driver_${BUILD_VER}_amd64.deb"

			mkdir -p ./usr/lib64/vulkan/amdgpu-pro
			#cp -d ./usr/lib/x86_64-linux-gnu/* ./usr/lib64/vulkan/amdgpu-pro
			cp -d ./opt/amdgpu-pro/x86_64-linux-gnu/* ./usr/lib64/vulkan/amdgpu-pro
			sed -i 's|/usr/lib/x86_64-linux-gnu|/usr/lib64/vulkan/amdgpu-pro|g' ./etc/vulkan/icd.d/amd_icd64.json
		fi
		unpack_deb "./amdgpu-pro-driver/amdgpu-pro-vulkan-driver_${BUILD_VER}_i386.deb"

		mkdir -p ./usr/lib32/vulkan/amdgpu-pro
		#cp -d ./usr/lib/i386-linux-gnu/* ./usr/lib32/vulkan/amdgpu-pro
		cp -d ./opt/amdgpu-pro/lib/i386-linux-gnu/* ./usr/lib32/vulkan/amdgpu-pro
		sed -i 's|/usr/lib/i386-linux-gnu|/usr/lib32/vulkan/amdgpu-pro|g' ./etc/vulkan/icd.d/amd_icd32.json

		chmod -x ./etc/vulkan/icd.d/*
		#rm -rf ./usr/lib
		rm -rf ./opt/amdgpu-pro/lib
	fi

	if use opengl ; then
		if use amd64 ; then
			#unpack_deb "./amdgpu-pro-driver/libgl1-amdgpu-pro-dev_${BUILD_VER}_amd64.deb"
			unpack_deb "./amdgpu-pro-driver/libgl1-amdgpu-pro-dri_${BUILD_VER}_amd64.deb"
			unpack_deb "./amdgpu-pro-driver/libgl1-amdgpu-pro-glx_${BUILD_VER}_amd64.deb"

			mkdir -p ./usr/lib64/opengl/amdgpu-pro/lib
			#cp -dR ./usr/lib/x86_64-linux-gnu/amdgpu-pro/* ./usr/lib64/opengl/amdgpu-pro/lib
			cp -dR ./opt/amdgpu-pro/lib/x86_64-linux-gnu/* ./usr/lib64/opengl/amdgpu-pro/lib
			mkdir -p ./usr/lib64/dri
			#cp -dR ./usr/lib/x86_64-linux-gnu/dri/* ./usr/lib64/dri
			cp -dR ./opt/amdgpu-pro/lib/x86_64-linux-gnu/dri/* ./usr/lib64/dri
		fi
		#unpack_deb "./amdgpu-pro-driver/libgl1-amdgpu-pro-dev_${BUILD_VER}_i386.deb"
		unpack_deb "./amdgpu-pro-driver/libgl1-amdgpu-pro-dri_${BUILD_VER}_i386.deb"
		unpack_deb "./amdgpu-pro-driver/libgl1-amdgpu-pro-glx_${BUILD_VER}_i386.deb"

		mkdir -p ./usr/lib32/opengl/amdgpu-pro/lib
		#cp -dR ./usr/lib/i386-linux-gnu/amdgpu-pro/* ./usr/lib32/opengl/amdgpu-pro/lib
		cp -dR ./opt/amdgpu-pro/lib/i386-linux-gnu/* ./usr/lib32/opengl/amdgpu-pro/lib
		mkdir -p ./usr/lib32/dri
		#cp -dR ./usr/lib/i386-linux-gnu/dri/* ./usr/lib32/dri
		cp -dR ./opt/amdgpu-pro/lib/i386-linux-gnu/dri/* ./usr/lib32/dri

		#rm -rf ./usr/lib
		rm -rf ./opt/amdgpu-pro/lib
	fi

	if use gles2 ; then
		if use amd64 ; then
			unpack_deb "./amdgpu-pro-driver/libgles2-amdgpu-pro-dev_${BUILD_VER}_amd64.deb"
			unpack_deb "./amdgpu-pro-driver/libgles2-amdgpu-pro_${BUILD_VER}_amd64.deb"

			mkdir -p ./usr/lib64/opengl/amdgpu-pro/lib
			#cp -d ./usr/lib/x86_64-linux-gnu/amdgpu-pro/* ./usr/lib64/opengl/amdgpu-pro/lib
			cp -d ./opt/amdgpu-pro/lib/x86_64-linux-gnu/* ./usr/lib64/opengl/amdgpu-pro/lib
		fi
		unpack_deb "./amdgpu-pro-driver/libgles2-amdgpu-pro-dev_${BUILD_VER}_i386.deb"
		unpack_deb "./amdgpu-pro-driver/libgles2-amdgpu-pro_${BUILD_VER}_i386.deb"

		mkdir -p ./usr/lib32/opengl/amdgpu-pro/lib
		#cp -d ./usr/lib/i386-linux-gnu/amdgpu-pro/* ./usr/lib32/opengl/amdgpu-pro/lib
		cp -d ./opt/amdgpu-pro/lib/i386-linux-gnu/* ./usr/lib32/opengl/amdgpu-pro/lib

		#rm -rf ./usr/lib
		rm -rf ./opt/amdgpu-pro/lib
	fi

	if use vdpau ; then
		if use amd64 ; then
			unpack_deb "./amdgpu-pro-driver/libvdpau-amdgpu-pro_${VDPAU_BUILD_VER}_amd64.deb"

			mkdir -p ./usr/lib64/vdpau
			#cp -d ./usr/lib/x86_64-linux-gnu/vdpau/* ./usr/lib64/vdpau
			cp -d ./opt/amdgpu-pro/lib/x86_64-linux-gnu/vdpau/* ./usr/lib64/vdpau
		fi
		#unpack_deb "./amdgpu-pro-driver/libvdpau-amdgpu-pro_${VDPAU_BUILD_VER}_i386.deb"

		#rm -rf ./usr/lib
		rm -rf ./opt/amdgpu-pro/lib
	fi

	if use amd64 ; then
		unpack_deb "./amdgpu-pro-driver/libdrm-amdgpu-pro-amdgpu1_${LIBDRM_BUILD_VER}_amd64.deb"
		unpack_deb "./amdgpu-pro-driver/libdrm-amdgpu-pro-dev_${LIBDRM_BUILD_VER}_amd64.deb"
		unpack_deb "./amdgpu-pro-driver/libdrm2-amdgpu-pro_${LIBDRM_BUILD_VER}_amd64.deb"
		#unpack_deb "./amdgpu-pro-driver/libegl1-amdgpu-pro-dev_${BUILD_VER}_amd64.deb"
		unpack_deb "./amdgpu-pro-driver/libegl1-amdgpu-pro_${BUILD_VER}_amd64.deb"
		unpack_deb "./amdgpu-pro-driver/libgbm1-amdgpu-pro-dev_${BUILD_VER}_amd64.deb"
		unpack_deb "./amdgpu-pro-driver/libgbm1-amdgpu-pro_${BUILD_VER}_amd64.deb"

		unpack_deb "./amdgpu-pro-driver/xserver-xorg-video-amdgpu-pro_${XSERVER_BUILD_VER}_amd64.deb"

		mkdir -p ./usr/lib64/xorg/amdgpu-pro/{1.15,1.16,1.17,1.18}
		cp -dR ./usr/lib64/x86_64-linux-gnu/amdgpu-pro/1.15/* ./usr/lib64/xorg/amdgpu-pro/1.15
		cp -dR ./usr/lib64/x86_64-linux-gnu/amdgpu-pro/1.16/* ./usr/lib64/xorg/amdgpu-pro/1.16
		cp -dR ./usr/lib64/x86_64-linux-gnu/amdgpu-pro/1.17/* ./usr/lib64/xorg/amdgpu-pro/1.17
		cp -dR ./usr/lib64/x86_64-linux-gnu/amdgpu-pro/1.18/* ./usr/lib64/xorg/amdgpu-pro/1.18

		#rm ./usr/lib/x86_64-linux-gnu/amdgpu-pro/xorg
		rm ./opt/amdgpu-pro/lib/xorg

		# Default to X.org 1.18
		ln -s ../../xorg/amdgpu-pro/1.18/modules/drivers    ./usr/lib64/opengl/amdgpu-pro/drivers
		ln -s ../../xorg/amdgpu-pro/1.18/modules/extensions ./usr/lib64/opengl/amdgpu-pro/extensions

		#cp -d ./usr/lib/x86_64-linux-gnu/amdgpu-pro/gbm/* ./usr/lib64/opengl/amdgpu-pro/lib
		cp -d ./opt/amdgpu-pro/lib/x86_64-linux-gnu/gbm/* ./usr/lib64/opengl/amdgpu-pro/lib
		#cp -d ./usr/lib/x86_64-linux-gnu/amdgpu-pro/*     ./usr/lib64/opengl/amdgpu-pro/lib
		cp -d ./opt/amdgpu-pro/lib/x86_64-linux-gnu/*     ./usr/lib64/opengl/amdgpu-pro/lib

		rm -rf ./usr/share/X11
	fi
	unpack_deb "./amdgpu-pro-driver/libdrm-amdgpu-pro-amdgpu1_${LIBDRM_BUILD_VER}_i386.deb"
	unpack_deb "./amdgpu-pro-driver/libdrm-amdgpu-pro-dev_${LIBDRM_BUILD_VER}_i386.deb"
	unpack_deb "./amdgpu-pro-driver/libdrm2-amdgpu-pro_${LIBDRM_BUILD_VER}_i386.deb"
	#unpack_deb "./amdgpu-pro-driver/libegl1-amdgpu-pro-dev_${BUILD_VER}_i386.deb"
	unpack_deb "./amdgpu-pro-driver/libegl1-amdgpu-pro_${BUILD_VER}_i386.deb"
	unpack_deb "./amdgpu-pro-driver/libgbm1-amdgpu-pro-dev_${BUILD_VER}_i386.deb"
	unpack_deb "./amdgpu-pro-driver/libgbm1-amdgpu-pro_${BUILD_VER}_i386.deb"

	mkdir -p ./usr/lib32/opengl/amdgpu-pro/lib
	#cp -d ./usr/lib/i386-linux-gnu/amdgpu-pro/gbm/* ./usr/lib32/opengl/amdgpu-pro/lib
	cp -d ./opt/amdgpu-pro/lib/i386-linux-gnu/gbm/* ./usr/lib32/opengl/amdgpu-pro/lib
	#cp -d ./usr/lib/i386-linux-gnu/amdgpu-pro/*     ./usr/lib32/opengl/amdgpu-pro/lib
	cp -d ./opt/amdgpu-pro/lib/i386-linux-gnu/*     ./usr/lib32/opengl/amdgpu-pro/lib

	#added
	unpack_deb "./amdgpu-pro-driver/libgl1-amdgpu-pro-appprofiles_${BUILD_VER}_all.deb"
	mkdir -p ./usr/lib32/pkgconfig
	mkdir -p ./usr/lib64/pkgconfig
	cp -d ./opt/amdgpu-pro/lib/i386-linux-gnu/* ./usr/lib32/pkgconfig
	cp -d ./opt/amdgpu-pro/lib/x86_64-linux-gnu/* ./usr/lib64/pkgconfig

	#rm -rf ./usr/lib
	rm -rf ./opt/amdgpu-pro/lib
	rm -rf ./amdgpu-pro-driver

	chmod -x ./etc/amd/*
	chmod -x ./etc/gbm/*
	chmod -x ./usr/share/X11/xorg.conf.d/*

	# Hack for libGL.so hardcoded directory path for amdgpu_dri.so
	if use amd64 ; then
		mkdir -p ./usr/lib/x86_64-linux-gnu/dri
		ln -s ../../../lib64/dri/amdgpu_dri.so ./usr/lib/x86_64-linux-gnu/dri/amdgpu_dri.so
	fi
	mkdir -p ./usr/lib/i386-linux-gnu/dri
	ln -s ../../../lib32/dri/amdgpu_dri.so ./usr/lib/i386-linux-gnu/dri/amdgpu_dri.so
}

src_install() {
	cp -dR -t "${D}" * || die "Install failed!"
}

pkg_postinst() {
	elog "If you dont use xorg-server 1.18 you need to edit the following symlinks"
	elog "/usr/lib64/opengl/amdgpu-pro/drivers"
	elog "/usr/lib64/opengl/amdgpu-pro/extensions"
	elog "to point to the driver directory for your xorg-server version."
	elog "Supported versions are 1.15 to 1.18."
}
