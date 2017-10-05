# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MULTILIB_COMPAT=( abi_x86_{32,64} )

inherit unpacker versionator \
	multilib-build

SUPER_PN='ati'
MY_PV=$(replace_version_separator 2 '-')

DESCRIPTION="Proprietary OpenCL implementation for AMD GPUs"
HOMEPAGE="http://support.amd.com/en-us/kb-articles/Pages/November-30-hotfix.aspx"

DRV_VER="amd-catalyst-${PV}-linux-installer-15.201.1151-x86.x86_64.zip"
DRIVERS_URI="mirror://gentoo/${DRV_VER}"
#XVBA_SDK_URI="http://developer.amd.com/wordpress/media/2012/10/xvba-sdk-0.74-404001.tar.gz"
SRC_URI="${DRIVERS_URI} ${XVBA_SDK_URI}"

LICENSE="AMD-GPU-PRO-EULA"

BUILD_VER="15.201.1151"
RUN="${WORKDIR}/AMD-Catalyst-15.9-Linux-installer-${BUILD_VER}-x86.x86_64.run"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror fetch strip"

DEPEND="dev-util/patchelf"
RDEPEND="dev-libs/ocl-icd"

QA_PREBUILT="/opt/${SUPER_PN}/lib*/*"

#S="${WORKDIR}/${SUPER_PN}-${MY_PV}"
S="${WORKDIR}/fglrx-${BUILD_VER}"

pkg_nofetch() {
	einfo "The driver packages"
	einfo ${A}
	einfo "need to be downloaded manually from"
	einfo "http://support.amd.com/en-us/download/desktop?os=Linux%20x86_64"
	einfo "and ${XVBA_SDK_URI}"
}

src_unpack() {
	local DRIVERS_DISTFILE XVBA_SDK_DISTFILE
	DRIVERS_DISTFILE=${DRIVERS_URI##*/}
	#XVBA_SDK_DISTFILE=${XVBA_SDK_URI##*/}

	if [[ ${DRIVERS_DISTFILE} =~ .*\.tar\.gz ]]; then
		unpack ${DRIVERS_DISTFILE}
		mkdir -p common
		mv etc lib usr common || die "Assumed to find etc lib and usr for common"
	else
		#please note, RUN may be insanely assigned at top near SRC_URI
		if [[ ${DRIVERS_DISTFILE} =~ .*\.zip ]]; then
			unpack ${DRIVERS_DISTFILE}
			[[ -z "$RUN" ]] && RUN="${S}/${DRIVERS_DISTFILE/%.zip/.run}"
		else
			RUN="${DISTDIR}/${DRIVERS_DISTFILE}"
		fi
		sh "${RUN}" --extract "${S}" 2>&1 > /dev/null || die
	fi

	#mkdir xvba_sdk
	#cd xvba_sdk
	#unpack ${XVBA_SDK_DISTFILE}

	#mkdir -p "${WORKDIR}/extra" || die "mkdir extra failed"
	#cd "${WORKDIR}/extra"
	#tar -xf "../fglrx-${BUILD_VER}/common/usr/src/ati/fglrx_sample_source.tgz"
}

src_prepare() {
	default

	#cd "${S}/arch/x86_64/usr/lib64/" || die
	#patchelf --set-rpath '$ORIGIN' libamdocl64.so || die "Failed to fix library rpath"
}

src_install() {
	into "/opt/${SUPER_PN}"
	if use amd64 ; then
		dolib arch/x86_64/usr/lib64/*ocl*
		dolib arch/x86_64/usr/lib64/*cal*
		dolib arch/x86_64/usr/lib64/*uki*
		dolib arch/x86_64/usr/lib64/libOpenCL.so.1
		dosym /opt/ati/lib64/libOpenCL.so.1 /opt/ati/lib64/libOpenCL.so
	fi
	if use x86 ; then
		dolib arch/x86/usr/lib/*ocl*
		dolib arch/x86/usr/lib/*cal*
		dolib arch/x86/usr/lib/*uki*
		dolib arch/x86/usr/lib/libOpenCL.so.1
		dosym /opt/ati/lib32/libOpenCL.so.1 /opt/ati/lib32/libOpenCL.so
	fi

	#it should contain /opt/amdgpu-pro/share/libdrm/amdgpu.ids
	#insinto "/opt/${SUPER_PN}"
	#doins -r opt/${SUPER_PN}/share

	insinto /etc/OpenCL/vendors/
	echo "/opt/${SUPER_PN}/$(get_libdir)/libamdocl64.so" > "${SUPER_PN}.icd" || die "Failed to generate ICD file"
	doins "${SUPER_PN}.icd"

if false ; then
	#for eselect opencl switcher with eselect-opencl from oiledmachine-overlay
	if use amd64 ; then
		mkdir -p "${ED}/usr/$(get_libdir)/OpenCL/vendors/ati/"
		mkdir -p "${ED}/etc/OpenCL/profiles/ati/"
		dosym /opt/ati/lib64/libOpenCL.so "/usr/$(get_libdir)/OpenCL/vendors/ati/libOpenCL.so"
		dosym /opt/ati/lib64/libOpenCL.so.1 "/usr/$(get_libdir)/OpenCL/vendors/ati/libOpenCL.so.1"
		dosym /opt/ati/lib64/libamdocl64.so "/usr/$(get_libdir)/OpenCL/vendors/ati/libamdocl64.so"
		dosym /opt/ati/lib64/libamdocl12cl64.so "/usr/$(get_libdir)/OpenCL/vendors/ati/libamdocl12cl64.so"
		echo "/opt/ati/lib64/libamdocl64.so" > "${ED}/etc/OpenCL/profiles/ati/amdocl64.icd"
		#dosym "/etc/OpenCL/profiles/ati/amdocl64.icd" "/etc/OpenCL/vendors/ocl64.icd"
	fi

	if use x86 ; then
		mkdir -p "${ED}/usr/lib32/OpenCL/vendors/ati/"
		mkdir -p "${ED}/etc/OpenCL/profiles/ati/"
		dosym /opt/ati/lib32/libOpenCL.so "/usr/lib32/OpenCL/vendors/ati/libOpenCL.so"
		dosym /opt/ati/lib32/libOpenCL.so.1 "/usr/lib32/OpenCL/vendors/ati/libOpenCL.so.1"
		dosym /opt/ati/lib32/libamdocl32.so "/usr/lib32/OpenCL/vendors/ati/libamdocl32.so"
		dosym /opt/ati/lib32/libamdocl12cl32.so "/usr/lib32/OpenCL/vendors/ati/libamdocl12cl32.so"
		echo "/opt/ati/lib32/libamdocl32.so" > "${ED}/etc/OpenCL/profiles/ati/amdocl32.icd"
		#dosym "/etc/OpenCL/profiles/ati/amdocl32.icd" "/etc/OpenCL/vendors/ocl32.icd"
	fi
fi
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		ewarn "Please note that using proprietary OpenCL libraries together with the"
		ewarn "Open Source amdgpu stack is not officially supported by AMD. Do not ask them"
		ewarn "for support in case of problems with this package."
		ewarn ""
		ewarn "Furthermore, if you have the whole ati stack installed this package"
		ewarn "will almost certainly conflict with it. This might change once ati"
		ewarn "has become officially supported by Gentoo."
	fi

	elog "AMD OpenCL driver relies on dev-libs/ocl-icd to work. To enable it, please run"
	elog ""
	elog "    eselect opencl set ocl-icd"
	elog ""
}
