# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="poetry"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Quart is a Python ASGI web microframework with the same API as Flask."
HOMEPAGE="https://github.com/pallets/quart"
LICENSE="MIT CC0-1.0"
# CC0 artwork/LICENSE
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc test"
# Deps last updated Oct 15, 2021
DEPEND+="
	$(python_gen_cond_dep 'dev-python/importlib_metadata[${PYTHON_USEDEP}]' python3_{8..9})
	>=dev-python/click-8[${PYTHON_USEDEP}]
	>=dev-python/hypercorn-0.11.2[${PYTHON_USEDEP}]
	>=dev-python/jinja-2[${PYTHON_USEDEP}]
	>=dev-python/werkzeug-2.2.0[${PYTHON_USEDEP}]
	dev-python/aiofiles[${PYTHON_USEDEP}]
	dev-python/blinker[${PYTHON_USEDEP}]
	dev-python/itsdangerous[${PYTHON_USEDEP}]
	dev-python/markupsafe[${PYTHON_USEDEP}]
	dev-python/python-dotenv[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	doc? (
		dev-python/pydata-sphinx-theme[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
"
RDEPEND+="
	${DEPEND}
"
#missing
#
#		>=dev-python/poetry-1[${PYTHON_USEDEP}]
BDEPEND+="
	>=dev-python/poetry-core-1.0.0
	test? (
		>=dev-python/poetry-1[${PYTHON_USEDEP}]
		dev-python/black[${PYTHON_USEDEP}]
		dev-python/isort[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/flake8-future-import[${PYTHON_USEDEP}]
		dev-python/flake8-print[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-python/pep8-naming[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/python-dotenv[${PYTHON_USEDEP}]
		dev-python/pytest-sugar[${PYTHON_USEDEP}]
		dev-python/toml[${PYTHON_USEDEP}]
		dev-python/types-toml[${PYTHON_USEDEP}]
		dev-python/types-aiofiles[${PYTHON_USEDEP}]
		dev-python/twine[${PYTHON_USEDEP}]
	)
"
SRC_URI="
https://github.com/pallets/quart/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

#distutils_enable_tests "pytest"

src_test() {
	run_test() {
einfo "Running test for ${EPYTHON}"
		tox || die
	}
	python_foreach_impl run_test
}

# OILEDMACHINE-OVERLAY-META-TAGS:  orphaned
