# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=pyproject.toml
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Quart is a Python ASGI web microframework with the same API as Flask."
HOMEPAGE="https://gitlab.com/pgjones/quart/"
LICENSE="MIT CC0-1.0"
# CC0 artwork/LICENSE
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/${PV}"
IUSE+=" doc test"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
# Deps last updated Oct 15, 2021
DEPEND+=" ${PYTHON_DEPS}
	dev-python/aiofiles[${PYTHON_USEDEP}]
	dev-python/blinker[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/python-dotenv[${PYTHON_USEDEP}]
	>=dev-python/hypercorn-0.7.0[${PYTHON_USEDEP}]
	dev-python/itsdangerous[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	>=dev-python/werkzeug-2.0.0[${PYTHON_USEDEP}]"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" ${PYTHON_DEPS}
	test? (
		dev-python/aiofiles[${PYTHON_USEDEP}]
		dev-python/black[${PYTHON_USEDEP}]
		dev-python/isort[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/mypy[${PYTHON_USEDEP}]
		>=dev-python/poetry-1[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/python-dotenv[${PYTHON_USEDEP}]
		dev-python/pytest-sugar[${PYTHON_USEDEP}]
		dev-python/toml[${PYTHON_USEDEP}]
		dev-python/twine[${PYTHON_USEDEP}]
		doc? (
			dev-python/pydata-sphinx-theme[${PYTHON_USEDEP}]
			dev-python/sphinx[${PYTHON_USEDEP}]
		)
	)"
SRC_URI="
https://gitlab.com/pgjones/${PN}/-/archive/${PV}/${PN}-${PV}.tar.bz2"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
