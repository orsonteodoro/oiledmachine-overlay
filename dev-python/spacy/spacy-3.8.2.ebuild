# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package (optional):
# cython-lint
# spacy_lookups_data
# spacy_transformers
# sudachipy
# sudachidict_core
# natto-py
# pythainlp

MY_PN="spaCy-release"

CYTHON_SLOT="0.29"
DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
LANGS=(
	"ja"
	"ko"
	"th"
)
PYTHON_COMPAT=( "python3_"{10..12} )

inherit cython distutils-r1 pypi

#KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${MY_PN}-v${PV}"
SRC_URI="
https://github.com/explosion/spaCy/archive/refs/tags/release-v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="💫 Industrial-strength Natural Language Processing (NLP) in Python"
HOMEPAGE="
	https://github.com/explosion/spaCy
	https://pypi.org/project/spacy
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
${LANGS[@]/#/l10n_}
cuda dev lookups transformers
ebuild_revision_2
"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/catalogue-2.0.6[${PYTHON_USEDEP}]
		>=dev-python/cymem-2.0.2[${PYTHON_USEDEP}]
		>=dev-python/packaging-20.0[${PYTHON_USEDEP}]
		>=dev-python/jinja2-2[${PYTHON_USEDEP}]
		>=dev-python/langcodes-3.2.0[${PYTHON_USEDEP}]
		>=dev-python/ml-datasets-0.2.0[${PYTHON_USEDEP}]
		>=dev-python/murmurhash-0.28.0[${PYTHON_USEDEP}]
		>=dev-python/numpy-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/preshed-3.0.2[${PYTHON_USEDEP}]
		=dev-python/preshed-3*[${PYTHON_USEDEP}]
		>=dev-python/pydantic-1.7.4[${PYTHON_USEDEP}]
		>=dev-python/requests-2.13.0[${PYTHON_USEDEP}]
		>=dev-python/srsly-2.4.3[${PYTHON_USEDEP}]
		>=dev-python/tqdm-4.38.0[${PYTHON_USEDEP}]
		>=dev-python/typer-0.3.0[${PYTHON_USEDEP}]
		>=dev-python/wasabi-0.9.1[${PYTHON_USEDEP}]
		>=dev-python/weasel-0.1.0[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
		cuda? (
			>=dev-python/cupy-5.0.0_beta4[${PYTHON_USEDEP}]
		)
		l10n_ja? (
			>=dev-python/sudachipy-0.5.2[${PYTHON_USEDEP}]
			>=dev-python/sudachidict_core-20211220[${PYTHON_USEDEP}]
		)
		l10n_ko? (
			>=dev-python/natto-py-0.9.0[${PYTHON_USEDEP}]
		)
		l10n_th? (
			>=dev-python/pythainlp-2.0[${PYTHON_USEDEP}]
		)
	')
	>=dev-python/thinc-8.3.0[${PYTHON_SINGLE_USEDEP}]
	=dev-python/thinc-8*[${PYTHON_SINGLE_USEDEP}]
	dev-python/spacy-legacy[${PYTHON_SINGLE_USEDEP}]
	dev-python/spacy-loggers[${PYTHON_SINGLE_USEDEP}]
	lookups? (
		>=dev-python/spacy-lookups-data-1.0.3[${PYTHON_SINGLE_USEDEP}]
	)
	transformers? (
		>=dev-python/spacy-transformers-1.1.2[${PYTHON_SINGLE_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/cymem-2.0.2[${PYTHON_USEDEP}]
		>=dev-python/cython-0.25:'${CYTHON_SLOT}'[${PYTHON_USEDEP}]
		dev-python/cython:=
		>=dev-python/preshed-3.0.2[${PYTHON_USEDEP}]
		>=dev-python/murmurhash-0.28.0[${PYTHON_USEDEP}]
		>=dev-python/numpy-2.0.0[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev? (
			!~dev-python/pytest-7.1.0
			>=dev-python/black-22.3.0[${PYTHON_USEDEP}]
			>=dev-python/cython-0.25[${PYTHON_USEDEP}]
			>=dev-python/cython-lint-0.15.0[${PYTHON_USEDEP}]
			>=dev-python/hypothesis-3.27.0[${PYTHON_USEDEP}]
			>=dev-python/isort-5.0[${PYTHON_USEDEP}]
			>=dev-python/flake8-3.8.0[${PYTHON_USEDEP}]
			>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
			>=dev-python/pytest-5.2.0[${PYTHON_USEDEP}]
			>=dev-python/pytest-timeout-1.3.0[${PYTHON_USEDEP}]
			>=dev-python/types-mock-0.1.1[${PYTHON_USEDEP}]
			>=dev-python/types-setuptools-57.0.0[${PYTHON_USEDEP}]
			dev-python/types-requests[${PYTHON_USEDEP}]
			!arm64? (
				>=dev-python/mypy-1.5.0[${PYTHON_USEDEP}]
			)
		)
	')
	>=dev-python/thinc-8.3.0[${PYTHON_SINGLE_USEDEP}]
	dev? (
		>=dev-vcs/pre-commit-2.13.0[${PYTHON_SINGLE_USEDEP}]
	)
"
DOCS=( "CITATION.cff" "README.md" )

python_configure() {
	cython_python_configure
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
