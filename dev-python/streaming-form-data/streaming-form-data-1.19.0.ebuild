# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="poetry"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit cython distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/siddhantgoel/streaming-form-data.git"
	FALLBACK_COMMIT="04833dbf2c5c6004f50cae4f374612be0d3f5c87" # Nov 7, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/siddhantgoel/streaming-form-data/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Streaming (and fast!) parser for multipart/form-data written in Cython"
HOMEPAGE="
	https://github.com/siddhantgoel/streaming-form-data
	https://pypi.org/project/streaming-form-data
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
dev
ebuild_revision_1
"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/poetry-core-1.8.4[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	dev? (
		=dev-python/cython-3*[${PYTHON_USEDEP}]
		dev-python/cython:=
		>=dev-python/flask-3.0.3[${PYTHON_USEDEP}]
		>=dev-python/mkdocs-1.6.1[${PYTHON_USEDEP}]
		>=dev-python/moto-5.0.18[${PYTHON_USEDEP}]
		>=dev-python/mypy-1.13.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-8.3.3[${PYTHON_USEDEP}]
		>=dev-python/requests-toolbelt-1.0.0[${PYTHON_USEDEP}]
		>=dev-util/ruff-0.7.1
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

python_configure() {
	if use dev ; then
		cython_set_cython_slot "3"
		cython_python_configure
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE.txt"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
