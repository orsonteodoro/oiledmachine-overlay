# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit eutils

DESCRIPTION="Fastest freeware utility to crack RAR password"
HOMEPAGE="http://www.crark.net/"
SRC_URI="http://www.crark.net/download/crark51-linux.rar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="opencl cuda cpu"
IUSE+=" video_cards_fglrx video_cards_amdgpu"
REQUIRED_USE="^^ ( opencl cuda cpu )"

RDEPEND="opencl? (
		|| (
			virtual/opencl
			dev-util/nvidia-cuda-sdk[opencl]
			video_cards_fglrx? ( || ( x11-drivers/ati-drivers ) )
			video_cards_amdgpu? ( || ( dev-util/amdapp x11-drivers/amdgpu-pro[opencl] ) )
		)
	)
	cuda? ( dev-util/nvidia-cuda-sdk )
	"
DEPEND="${RDEPEND}
	app-arch/unrar"
PROPERTIES="interactive"
S="${WORKDIR}"

src_prepare() {
	eapply_user
}

src_unpack() {
	einfo "The author said that there is no password.  Press enter to continue."
	echo "${DISTDIR}/${A}"
	unrar x -p "${DISTDIR}/${A}"
}

src_install() {
	mkdir -p "${D}/opt/crark"
	cp -R "${WORKDIR}"/* "${D}/opt/crark"
	mkdir -p "${D}/usr/bin"
	if use cpu ; then
		cp "${FILESDIR}/5.0/crark" "${D}/usr/bin" #wrapper script
	else
		rm "${D}/opt/crark/crark"
	fi
	if use opencl ; then
		cp "${FILESDIR}/5.0/crark-ocl" "${D}/usr/bin" #wrapper script
	else
		rm "${D}/opt/crark/crark-ocl"
		rm "${D}"/opt/crark/{rarcrypt30-cl.dll,rarcrypt50-cl.dll}
	fi
	if use cuda ; then
		cp "${FILESDIR}/5.0/crark-cuda" "${D}/usr/bin" #wrapper script
	else
		rm "${D}/opt/crark/crark-cuda"
		rm "${D}"/opt/crark/{rarcrypt30-2.dll,rarcrypt30-5.dll,rarcrypt50-2.dll,rarcrypt50-5.dll,rarcrypt30-3.dll,rarcrypt50-3.dll}
	fi
}

