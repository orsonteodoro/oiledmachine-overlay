# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit unpacker

# version based on Ubuntu18/RadeonImageFilters/RadeonImageFilters.h

DESCRIPTION="The non commerical sdk includes tools, object code, AMD ProRender, AMD Radeon Rays Library, AMD Image Filter Library"
HOMEPAGE="https://www.amd.com/en/technologies/radeon-prorender-developers"

MY_PN="RadeonProRenderSDK"
FN="RadeonProImageProcessing.7z"
SRC_URI="https://download.amd.com/software/${FN} -> ${P}.7z"

LICENSE="AMD-SOFTWARE-EVALUATION-LICENSE-AGREEMENT-OBJECT-CODE-ONLY-RADEON-PRORENDER-SDK"
KEYWORDS="~amd64"
SLOT="0"
RESTRICT="fetch strip"
IUSE="+samples +models"
IUSE+="video_cards_radeonsi video_cards_nvidia video_cards_fglrx video_cards_amdgpu video_cards_intel video_cards_r600"

S="${WORKDIR}"

RDEPEND="
	|| (
		virtual/opencl
		video_cards_nvidia? ( x11-drivers/nvidia-drivers )
		video_cards_fglrx? ( || ( x11-drivers/ati-drivers ) )
		video_cards_amdgpu? ( || ( dev-util/amdapp x11-drivers/amdgpu-pro[opencl] ) )
	)
	"
DEPEND="${RDEPEND}"

FINGERPRINT="f79cc5e0fd5d87d63705a9f660a1ab653385ed0"

pkg_nofetch() {
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	einfo "Please download"
	einfo "  - ${FN}"
	einfo "from ${HOMEPAGE} and rename it to ${P}.7z place it in ${distdir}"
}

src_unpack() {
	default
	X_FINGERPRINT=$(sha1sum Ubuntu18/RadeonImageFilters/RadeonImageFilters.h | cut -c 1-40)
	if [[ "${FINGERPRINT}" != "${X_FINGERPRINT}" ]] ; then
		die "Wrong version or newer"
	fi
}

src_install() {
	dodir /opt/${PN}
	insinto /opt/${PN}
	doins license.txt
	if use samples ; then
		doins Samples
	fi
	if use models ; then
		doins models
	fi
	doins Ubuntu18
}
