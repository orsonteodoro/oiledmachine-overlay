# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..11} ) # Up to 3.11

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/aio-libs/aiocache.git"
	FALLBACK_COMMIT="e673d62e98bf89b619e48f44cd68c96a30d95a1b" # Sep 25, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/aio-libs/aiocache/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Multi backend asyncio cache"
HOMEPAGE="
	https://github.com/aio-libs/aiocache
	https://pypi.org/project/aiocache
"
LICENSE="
	BSD
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+=" dev memcached msgpack redis test"
RDEPEND+="
	memcached? (
		>=dev-python/aiomcache-0.8.0[${PYTHON_USEDEP}]
	)
	msgpack? (
		>=dev-python/msgpack-1.0.4[${PYTHON_USEDEP}]
	)
	redis? (
		>=dev-python/redis-4.4.2[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		>=dev-python/flake8-6.0.0[${PYTHON_USEDEP}]
		>=dev-python/flake8-bandit-4.1.1[${PYTHON_USEDEP}]
		>=dev-python/flake8-bugbear-22.12.6[${PYTHON_USEDEP}]
		>=dev-python/flake8-import-order-0.18.2[${PYTHON_USEDEP}]
		>=dev-python/flake8-requirements-1.7.6[${PYTHON_USEDEP}]
		>=dev-python/mypy-0.991[${PYTHON_USEDEP}]
		>=dev-python/types-redis-4.4.0.0[${PYTHON_USEDEP}]
		>=dev-python/types-ujson-5.7.0.0[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/aiohttp-3.8.3[${PYTHON_USEDEP}]
		>=dev-python/marshmallow-3.19.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.2.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-asyncio-0.20.3[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-4.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-mock-3.10.0[${PYTHON_USEDEP}]
	)
"
DOCS=( "CHANGES.rst" "README.md" )

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

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
