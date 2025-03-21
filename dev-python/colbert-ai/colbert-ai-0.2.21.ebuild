# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package
# faiss-cpu
# faiss-gpu

MY_PN="${PN/-/_}"

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="Efficient and Effective Passage Search via Contextualized Late Interaction over BERT"
HOMEPAGE="
	https://github.com/stanford-futuredata/ColBERT
	https://pypi.org/project/colbert-ai
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" faiss-cpu faiss-gpu torch"
# Upstream lists ninja (a pypi package), but cannot find reference.
RDEPEND+="
	$(python_gen_cond_dep '
		dev-python/bitarray[${PYTHON_USEDEP}]
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/gitpython[${PYTHON_USEDEP}]
		dev-python/python-dotenv[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		dev-python/ujson[${PYTHON_USEDEP}]
	')
	sci-ml/datasets[${PYTHON_SINGLE_USEDEP}]
	sci-libs/transformers[${PYTHON_SINGLE_USEDEP}]
	faiss-cpu? (
		>=dev-python/faiss-cpu-1.7.0[${PYTHON_SINGLE_USEDEP}]
	)
	faiss-gpu? (
		>=dev-python/faiss-gpu-1.7.0[${PYTHON_SINGLE_USEDEP}]
	)
	torch? (
		~sci-ml/pytorch-1.13.1[${PYTHON_SINGLE_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "README.md" )

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
