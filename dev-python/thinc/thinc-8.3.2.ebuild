# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package (optional)
# cupy-wheel

CYTHON_SLOT="0.29"
DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit cython distutils-r1 pypi

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${PN}-release-v${PV}"
SRC_URI="
https://github.com/explosion/thinc/archive/refs/tags/release-v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="🔮 A refreshing functional take on deep learning, compatible with your favorite libraries"
HOMEPAGE="
	https://github.com/explosion/thinc
	https://pypi.org/project/thinc
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
cuda cuda-autodetect datasets mxnet pytorch tensorflow
ebuild_revision_2
"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/blis-0.7.8[${PYTHON_USEDEP}]
		>=dev-python/murmurhash-1.0.2[${PYTHON_USEDEP}]
		>=dev-python/cymem-2.0.2[${PYTHON_USEDEP}]
		>=dev-python/preshed-3.0.2[${PYTHON_USEDEP}]
		>=dev-python/wasabi-0.8.1[${PYTHON_USEDEP}]
		>=dev-python/srsly-2.4.0[${PYTHON_USEDEP}]
		>=dev-python/catalogue-2.0.4[${PYTHON_USEDEP}]
		>=dev-python/confection-0.0.1[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.19.0[${PYTHON_USEDEP}]
		>=dev-python/pydantic-1.7.4[${PYTHON_USEDEP}]
		>=dev-python/packaging-20.0[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
		cuda? (
			>=dev-python/cupy-11.0.0[${PYTHON_USEDEP}]
			dev-python/cupy:=
		)
		cuda-autodetect? (
			>=dev-python/cupy-wheel-11.0.0[${PYTHON_USEDEP}]
		)
		datasets? (
			>=dev-python/ml-datasets-0.2.0[${PYTHON_USEDEP}]
		)
		mxnet? (
			>=dev-python/mxnet-1.5.1[${PYTHON_USEDEP}]
		)
	')
	pytorch? (
		>=sci-ml/pytorch-1.6.0[${PYTHON_SINGLE_USEDEP}]
	)
	tensorflow? (
		>=sci-ml/tensorflow-2.0.0[${PYTHON_SINGLE_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/cython-0.25:'${CYTHON_SLOT}'[${PYTHON_USEDEP}]
		dev-python/cython:=
		>=dev-python/numpy-1.15.0[${PYTHON_USEDEP}]
		>=dev-python/cymem-2.0.2[${PYTHON_USEDEP}]
		>=dev-python/preshed-3.0.2[${PYTHON_USEDEP}]
		>=dev-python/murmurhash-1.0.2[${PYTHON_USEDEP}]
		>=dev-python/blis-0.7.8[${PYTHON_USEDEP}]
	')
"
DOCS=( "README.md" )

python_configure() {
	cython_python_configure
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
