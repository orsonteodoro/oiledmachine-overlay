# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# You can build this in a musl container to get strictly musl libs.

SRC_URI=" "

KEYWORDS="~amd64 ~arm ~arm64 ~x86"
DESCRIPTION="Building static binaries of some tools using an Alpine chroot with musl"
HOMEPAGE="https://github.com/probonopd/static-tools"
LICENSE="
	all-rights-reserved
	MIT
"
IUSE="fallback-commit +runtime"
REQUIRED_USE+="
"
SLOT="0/$(ver_cut 1-2 ${PV})"
RDEPEND+="
	>=app-arch/static-tools-bsdtar-3.3.2
	>=app-arch/static-tools-patchelf-0.9
	>=app-arch/static-tools-runtime-9999
	>=app-arch/static-tools-squashfuse-20211010
	>=app-arch/static-tools-zsyncmake-0.6.2
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
RESTRICT="mirror"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
