# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="poetry"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
https://github.com/jdepoix/youtube-transcript-api/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="A Python API which allows you to get the transcript/subtitles for a given YouTube video"
HOMEPAGE="
	https://github.com/jdepoix/youtube-transcript-api
	https://pypi.org/project/youtube-transcript-api
"
LICENSE="
	MIT
"
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev test"
RDEPEND+="
	${PYTHON_DEPS}
	>=dev-python/defusedxml-0.7.1[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	dev? (
		>=dev-util/ruff-0.6.8
	)
	test? (
		>=dev-python/coverage-7.6.1[${PYTHON_USEDEP}]
		>=dev-python/mock-5.1.0[${PYTHON_USEDEP}]
		>=dev-python/httpretty-1.1.4[${PYTHON_USEDEP}]
		>=dev-python/pytest-8.3.3[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "version = \"1.8.2\"" "${S}/pyproject.toml" \
			|| die "QA:  Bump version"
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
