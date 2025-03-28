# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/florimondmanca/httpx-sse.git"
	FALLBACK_COMMIT="1b8f7f0f6a1ecca36d1a2f839f306c592e93db34" # Dec 21, 2023
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/florimondmanca/httpx-sse/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Consume Server-Sent Event (SSE) messages with HTTPX"
HOMEPAGE="
	https://github.com/florimondmanca/httpx-sse
	https://pypi.org/project/httpx-sse
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev test"
REQUIRED_USE="
	test? (
		dev
	)
"
RDEPEND+="
	dev-python/twine[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	dev? (
		>=dev-python/black-23.12.0[${PYTHON_USEDEP}]
		>=dev-python/httpx-0.26.0[${PYTHON_USEDEP}]
		>=dev-python/mypy-1.8.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.4.3[${PYTHON_USEDEP}]
		>=dev-python/pytest-asyncio-0.21.1[${PYTHON_USEDEP}]
		>=dev-python/sse-starlette-1.8.2[${PYTHON_USEDEP}]
		>=dev-python/starlette-0.27.0[${PYTHON_USEDEP}]
		>=dev-util/ruff-0.1.9
		dev-python/pytest-cov[${PYTHON_USEDEP}]
	)
"
DOCS=( "CHANGELOG.md" "README.md" )

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
