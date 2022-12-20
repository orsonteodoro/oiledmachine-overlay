# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="A high performance C++ math library"
LICENSE="BSD"
HOMEPAGE="https://bitbucket.org/blaze-lib/blaze"
SLOT="0/${PV}"
IUSE+=" boost +lapack"
RDEPEND+="
	lapack? (
		|| (
			sci-libs/mkl-rt
			sci-libs/openblas
			virtual/lapack
		)
	)
"
DEPEND+=" ${RDEPEND}"
BDEPEND+="
	>=dev-util/cmake-3.8
	|| (
		sys-devel/clang
		sys-devel/gcc[cxx]
	)
"
RESTRICT="mirror"
S="${WORKDIR}/${P}"
SRC_URI="https://bitbucket.org/blaze-lib/blaze/downloads/blaze-${PV}.tar.gz"

src_configure() {
	local mycmakeargs=(
		-DUSE_LAPACK=$(usex lapack)
	)
	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
