# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit multilib unpacker versionator

MY_V="$(get_version_component_range 1).$(get_version_component_range 2).130.136-GA"

X86_AT="AMD-APP-SDKInstaller-v${MY_V}-linux32.tar.bz2"
AMD64_AT="AMD-APP-SDKInstaller-v${MY_V}-linux64.tar.bz2"

MY_P_AMD64="AMD-APP-SDK-v${MY_V}-linux64.sh"
MY_P_AMD32="AMD-APP-SDK-v${MY_V}-linux32.sh"

DESCRIPTION="AMD Accelerated Parallel Processing (APP) SDK"
HOMEPAGE="http://developer.amd.com/tools-and-sdks/opencl-zone/amd-accelerated-parallel-processing-app-sdk"
SRC_URI="
	amd64? ( ${AMD64_AT} )
	x86? ( ${X86_AT} )"

LICENSE="AMD-APPSDK"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="
	!<dev-util/amdstream-2.6
	app-eselect/eselect-opencl
	app-eselect/eselect-opengl
	media-libs/freeglut
	media-libs/mesa[video_cards_radeonsi]
	sys-devel/gcc:*
	sys-devel/llvm
	virtual/opencl
	examples? ( media-libs/glew:0= )"
DEPEND="
	${RDEPEND}
	dev-util/patchelf
	dev-lang/perl
	sys-apps/fakeroot
"

RESTRICT="mirror strip"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "AMD doesn't provide direct download links. Please download"
	einfo "${ARCHIVE} from ${HOMEPAGE}"
}

src_unpack() {
	default

	cd "${WORKDIR}" || die

	if use amd64 || use amd64-linux ; then
		unpacker ./${MY_P_AMD64}
	else
		unpacker ./${MY_P_X86}
	fi
}

src_compile() {
	MAKEOPTS+=" -j1"
	use examples && cd samples/opencl && default
}

src_install() {
	dodir /opt/AMDAPP
	cp -R "${S}/"* "${ED}/opt/AMDAPP" || die "Install failed!"

	#for eselect opencl switcher with eselect-opencl from oiledmachine-overlay
	if [[ "${ABI}" == "amd64" ]] ; then
		mkdir -p "${ED}/usr/$(get_libdir)/OpenCL/vendors/amdapp/"
		mkdir -p "${ED}/etc/OpenCL/profiles/amdapp/"
		dosym /opt/AMDAPP/lib/x86_64/sdk/libOpenCL.so "/usr/$(get_libdir)/OpenCL/vendors/amdapp/libOpenCL.so"
		dosym /opt/AMDAPP/lib/x86_64/sdk/libOpenCL.so.1 "/usr/$(get_libdir)/OpenCL/vendors/amdapp/libOpenCL.so.1"
		dosym /opt/AMDAPP/lib/x86_64/sdk/libamdocl64.so "/usr/$(get_libdir)/OpenCL/vendors/amdapp/libamdocl64.so"
		dosym /opt/AMDAPP/lib/x86_64/libamdocl12cl64.so "/usr/$(get_libdir)/OpenCL/vendors/amdapp/libamdocl12cl64.so"
		echo "/opt/AMDAPP/lib/x86_64/sdk/libamdocl64.so" > "${ED}/etc/OpenCL/profiles/amdapp/amdocl64.icd"
		#dosym "/etc/OpenCL/profiles/amdapp/amdocl64.icd" "/etc/OpenCL/vendors/ocl64.icd"

		mkdir -p "${ED}/usr/lib32/OpenCL/vendors/amdapp/"
		mkdir -p "${ED}/etc/OpenCL/profiles/amdapp/"
		dosym /opt/AMDAPP/lib/x86/libOpenCL.so "/usr/lib32/OpenCL/vendors/amdapp/libOpenCL.so"
		dosym /opt/AMDAPP/lib/x86/libOpenCL.so.1 "/usr/lib32/OpenCL/vendors/amdapp/libOpenCL.so.1"
		dosym /opt/AMDAPP/lib/x86/libamdocl32.so "/usr/lib32/OpenCL/vendors/amdapp/libamdocl32.so"
		dosym /opt/AMDAPP/lib/x86/libamdocl12cl32.so "/usr/lib32/OpenCL/vendors/amdapp/libamdocl12cl32.so"
		echo "/opt/AMDAPP/lib/x86/libamdocl32.so" > "${ED}/etc/OpenCL/profiles/amdapp/amdocl32.icd"
		#dosym "/etc/OpenCL/profiles/amdapp/amdocl32.icd" "/etc/OpenCL/vendors/ocl32.icd"
	elif [[ "${ABI}" == "x86" ]] ; then
		mkdir -p "${ED}/usr/$(get_libdir)/OpenCL/vendors/amdapp/"
		mkdir -p "${ED}/etc/OpenCL/profiles/amdapp/"
		dosym /opt/AMDAPP/lib/x86/libOpenCL.so "/usr/$(get_libdir)/OpenCL/vendors/amdapp/libOpenCL.so"
		dosym /opt/AMDAPP/lib/x86/libOpenCL.so.1 "/usr/$(get_libdir)/OpenCL/vendors/amdapp/libOpenCL.so.1"
		echo "/opt/AMDAPP/lib/x86/libamdocl32.so" > "${ED}/etc/OpenCL/profiles/amdapp/amdocl32.icd"
		#dosym "/etc/OpenCL/profiles/amdapp/amdocl32.icd" "/etc/OpenCL/vendors/ocl32.icd"
	fi
}
