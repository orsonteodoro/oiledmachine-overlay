# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# You can build this in a musl container to get strictly musl libs.

KEYWORDS="~amd64 ~arm ~arm64 ~x86"
SRC_URI=" "

DESCRIPTION="Building static binaries of some tools using an Alpine chroot with musl"
HOMEPAGE="https://github.com/probonopd/static-tools"
LICENSE="
	all-rights-reserved
	MIT
"
IUSE="fuse3"
REQUIRED_USE+="
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
RDEPEND+="
	>=app-arch/static-tools-appstreamcli-0.12.9:=
	>=app-arch/static-tools-bsdtar-3.3.2:=
	>=app-arch/static-tools-desktop-file-utils-20220215:=
	>=app-arch/static-tools-patchelf-0.9:=
	>=app-arch/static-tools-runtime-fuse-9999:=[fuse3=]
	>=app-arch/static-tools-squashfs-tools-4.5.1:=
	>=app-arch/static-tools-squashfuse-20211010:=
	>=app-arch/static-tools-zsyncmake-0.6.2:=
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
