# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_10" ) # Upstream tags up to 3.10

inherit distutils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_REPO_URI="https://github.com/MatthieuDartiailh/pyclibrary.git"
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}-${PV}"
	FALLBACK_COMMIT="2e38ac3c42c8744e9db5163068f6f451eeb78d67" # Jan 22, 2024
	inherit git-r3
else
	KEYWORDS="~amd64"
	SRC_URI="
https://github.com/MatthieuDartiailh/pyclibrary/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi
S="${WORKDIR}/${PN}-${PV}"

DESCRIPTION="C parser and ctypes automation for Python"
HOMEPAGE="https://github.com/MatthieuDartiailh/pyclibrary"
LICENSE="
	MIT
"
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc test"
RDEPEND+="
	(
		>=dev-python/pyparsing-2.3.1[${PYTHON_USEDEP}]
		<dev-python/pyparsing-4[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	doc? (
		(
			>=dev-python/pyparsing-2.3.1[${PYTHON_USEDEP}]
			<dev-python/pyparsing-3[${PYTHON_USEDEP}]
		)
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"
DOCS=( "AUTHORS" "CHANGES" "README.rst" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "^MAJOR = $(ver_cut 1 ${PV})" "${S}/pyclibrary/version.py" \
			|| die "Detected version inconsitency.  Use fallback USE flag."
		grep -q -e "^MINOR = $(ver_cut 2 ${PV})" "${S}/pyclibrary/version.py" \
			|| die "Detected version inconsitency.  Use fallback USE flag."
		grep -q -e "^MICRO = $(ver_cut 3 ${PV})" "${S}/pyclibrary/version.py" \
			|| die "Detected version inconsitency.  Use fallback USE flag."
	else
		unpack ${A}
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
	einstalldocs
}

distutils_enable_tests "pytest"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
