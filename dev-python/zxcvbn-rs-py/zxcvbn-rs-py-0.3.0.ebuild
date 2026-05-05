# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="maturin"
PYTHON_COMPAT=( "python3_"{10..14} ) # U22 supports up to 3.11, gnome-misc/secrets supports 12-14

inherit distutils-r1 pypi sandbox-changes

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/fief-dev/zxcvbn-rs-py.git"
	FALLBACK_COMMIT="a934f413e487d6cf86dd24598a3d6f2dc3c246d5" # Jan 25, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~s390 ~x86"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/fief-dev/zxcvbn-rs-py/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Python bindings for zxcvbn-rs, the Rust implementation of zxcvbn"
HOMEPAGE="
	https://github.com/fief-dev/zxcvbn-rs-py
	https://pypi.org/project/zxcvbn-rs-py
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"

# No longer supported by distro
#	>=dev-python/mkdocstrings-0.18[${PYTHON_USEDEP},python(+)]
#	dev-python/mkdocs-material[${PYTHON_USEDEP}]
BDEPEND+="
	dev-python/black[${PYTHON_USEDEP}]
	dev-python/mypy[${PYTHON_USEDEP}]
	dev-python/pip[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-util/maturin[${PYTHON_USEDEP}]
	dev-util/ruff
"
DOCS=( "README.md" )

pkg_setup() {
	sandbox-changes_no_network_sandbox "To download crates"
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

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
