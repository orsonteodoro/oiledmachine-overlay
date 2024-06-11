# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
PYTHON_COMPAT=( "python3_10" )

inherit cmake distutils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_REPO_URI="https://github.com/google/sentencepiece.git"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}-${PV}"
	FALLBACK_COMMIT="17d7580d6407802f85855d2cc9190634e2c95624" # Feb 19, 2024
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm64 ~alpha ~ppc ~ppc64 ~m68k ~riscv ~s390 ~sparc ~x86"
	SRC_URI="
https://github.com/google/sentencepiece/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi
S="${WORKDIR}/${PN}-${PV}"

DESCRIPTION="Unsupervised text tokenizer for Neural Network-based text generation."
HOMEPAGE="https://github.com/google/sentencepiece"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" python test"
RDEPEND+="
	>=dev-libs/protobuf-3.14:0/3.21
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-build/cmake-3.8.0
	virtual/pkgconfig
"
DOCS=( "README.md" )

pkg_setup() {
	if use python ; then
		python_setup
	fi
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_prepare() {
	cmake_src_prepare
	cd "${S}/python" || die
	distutils-r1_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DSPM_PROTOBUF_PROVIDER="package"
	)
	cmake_src_configure
	cd "${S}/python" || die
	distutils-r1_src_configure
}

src_compile() {
	cmake_src_compile
	cd "${S}/python" || die
	distutils-r1_src_compile
}

src_install() {
	cmake_src_install
	docinto "licenses"
	dodoc "LICENSE"

	cd "${S}/python" || die
	distutils-r1_src_install
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
