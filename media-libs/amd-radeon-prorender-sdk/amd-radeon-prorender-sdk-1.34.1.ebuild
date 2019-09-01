# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit unpacker

DESCRIPTION="The non commerical sdk includes tools, object code, AMD ProRender, AMD Radeon Rays Library, AMD Image Filter Library"
HOMEPAGE="https://www.amd.com/en/technologies/radeon-prorender-developers"

MY_PN="RadeonProRenderSDK"
FN="RadeonProRenderSDK.zip"
SRC_URI="https://download.amd.com/software/${FN} -> ${P}.zip"

# special licenses beyond AMD-SOFTWARE-EVALUATION-LICENSE-AGREEMENT-OBJECT-CODE-ONLY-RADEON-PRORENDER-SDK are due to 3rdParty folder and possibly static linking
# Khronos-IP-framework license applies to glTF
LICENSE="AMD-SOFTWARE-EVALUATION-LICENSE-AGREEMENT-OBJECT-CODE-ONLY-RADEON-PRORENDER-SDK MIT BSD Apache-2.0 BSD-Leffler-SGI-LIBTIFF Khronos-IP-framework"
KEYWORDS="~amd64"
SLOT="0"
RESTRICT="fetch strip"
IUSE="premake +tutorials +resources"

RDEPEND="premake? ( dev-util/premake:4 )
	 sys-devel/gcc[openmp]"
DEPEND=""


S="${WORKDIR}/${MY_PN}-${PV}"

pkg_nofetch() {
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	einfo "Please download"
	einfo "  - ${FN}"
	einfo "from ${HOMEPAGE} and rename it to ${P}.zip place it in ${distdir}"
}

src_unpack() {
	default
}

src_install() {
	cd "${S}"
	dodir /opt/${PN}
	insinto /opt/${PN}

	# ebuild does a bad job reporting the location of the error when using doins so do report the steps for future install breakage
	einfo "Installing license"
	doins license.txt
	einfo "Installing documentation"
	dodoc readme.md
	dodoc release_notes.txt
	if use tutorials ; then
		einfo "Installing tutorials"
		doins -r tutorials
	fi
	# premake 4 already provided by gentoo
	dodir /opt/${PN}/premake4/linux64
	dosym /usr/bin/premake4 /opt/${PN}/premake4/linux64/premake4
	# scripts folder skipped
	doins -r tracePlayer

	if use resources ; then
		einfo "Installing resources (e.g. artwork)"
		doins -r Resources
	fi

	dodir /opt/${PN}/RadeonProRender
	insinto /opt/${PN}/RadeonProRender
	pushd RadeonProRender || die
		doins -r binUbuntu18 inc RprTools.cpp RprTools.h
	popd

	fperms +x /opt/${PN}/RadeonProRender/binUbuntu18/RprsRender64

	#einfo "Installing third party libraries"
	#dodir /opt/${PN}/3rdParty
	#insinto /opt/${PN}/3rdParty
	#pushd 3rdParty || die
		# some may be statically linked and require special constants from headers even though obsolete
		# freeglut already provided by portage
		# glew already provided by portage
		# stb already provided by portage
	#popd

}

pkg_postinst() {
	# RprsRender64 needs LD_LIBRARY_PATH to libRadeonProRender64.so's folder
	# we can use doenv or do it at the ebuild level

	einfo "You need to set LD_LIBRARY_PATH to the location of libRadeonProRender64.so or else RprsRender64 will not work"
}
