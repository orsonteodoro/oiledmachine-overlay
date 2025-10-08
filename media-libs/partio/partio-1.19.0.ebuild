# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX14[@]}
)
PYTHON_COMPAT=( "python3_"{11,12} )

inherit cmake libstdcxx-slot python-single-r1

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/wdas/partio.git"
else
	SRC_URI="https://github.com/wdas/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Library for particle IO and manipulation"
HOMEPAGE="http://partio.us/"
LICENSE="BSD"
RESTRICT="test"
SLOT="0"
IUSE="
doc test
ebuild_revision_1
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"
RDEPEND="
	${PYTHON_DEPS}
	>=media-libs/freeglut-3.4.0
	>=media-libs/glu-9.0.2[${LIBSTDCXX_USEDEP}]
	media-libs/glu:=
	>=sys-libs/zlib-1.3
	virtual/opengl
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-lang/swig-4.2.0
	doc? (
		>=app-text/doxygen-1.9.8
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
	test? (
		dev-cpp/gtest
	)
"
PATCHES=(
)

pkg_setup() {
	python-single-r1_pkg_setup
	libstdcxx-slot_verify
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package doc Doxygen)
		-DPYTHON_DEST="/usr/lib/${EPYTHON}/site-packages/partio"
	)
	cmake_src_configure
}
