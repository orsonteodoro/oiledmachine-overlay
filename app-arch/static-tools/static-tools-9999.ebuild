# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# You can build this in a musl container to get strictly musl libs.

inherit git-r3

EGIT_REPO_URI="https://github.com/probonopd/static-tools.git"
EGIT_BRANCH="master"

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
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
SRC_URI=" "
RESTRICT="mirror"
PATCHES=(
)

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
