# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package (optional):
# docker-compose (pypi)
# pytest-pylint
# pytest-pycodestyle
# pytest-mypy

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/avast/pytest-docker.git"
	FALLBACK_COMMIT="a934f413e487d6cf86dd24598a3d6f2dc3c246d5" # Jan 25, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/avast/pytest-docker/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Create, fill a temporary directory"
HOMEPAGE="
	https://github.com/avast/pytest-docker
	https://pypi.org/project/pytest-docker
"
LICENSE="
	MIT
"
RESTRICT="mirror test" # Missing test dependencies
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" docker-compose-v1 test"
RDEPEND+="
	>=dev-python/pytest-4.0
	>=dev-python/attrs-19.2.0
	docker-compose-v1? (
		>=dev-python/docker-compose-1.27.3
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	test? (
		>=dev-python/requests-2.22.0[${PYTHON_USEDEP}]
		>=dev-python/mypy-0.500[${PYTHON_USEDEP}]
		>=dev-python/pytest-pylint-0.14.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-pycodestyle-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-mypy-0.10[${PYTHON_USEDEP}]
		>=dev-python/types-requests-2.31[${PYTHON_USEDEP}]
		>=dev-python/types-setuptools-69.0[${PYTHON_USEDEP}]
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
	dodoc "LICENSE.txt"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
