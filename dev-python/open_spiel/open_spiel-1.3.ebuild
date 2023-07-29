# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{10..11} )
# Limited by jax
inherit distutils-r1

DESCRIPTION="OpenSpiel is a collection of environments and algorithms for \
research in general reinforcement learning and search/planning in games."
HOMEPAGE="
https://github.com/deepmind/open_spiel
"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc -eigen -go -jax -julia -libnop -python-misc -pytorch -rust -tensorflow"
# See also https://github.com/deepmind/open_spiel/blob/v1.3/open_spiel/scripts/python_extra_deps.sh
# TODO:  package
# clu
# distrax
# ecos
# flax
# rlax
# tensorflow-datasets
# tensorflow-probability
# nashpy
DEPEND+="
	>=dev-python/attrs-19.3.0[${PYTHON_USEDEP}]
	>=dev-python/absl-py-0.10.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.21.5[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.10.1[${PYTHON_USEDEP}]
	go? (
		dev-lang/go
	)
	jax? (
		>=dev-python/chex-0.1.5[${PYTHON_USEDEP}]
		>=dev-python/distrax-0.1.3[${PYTHON_USEDEP}]
		>=dev-python/dm-haiku-0.0.8[${PYTHON_USEDEP}]
		>=dev-python/jax-0.3.24[${PYTHON_USEDEP}]
		>=dev-python/jaxlib-0.3.24[${PYTHON_USEDEP}]
		>=dev-python/optax-0.1.3[${PYTHON_USEDEP}]
		>=dev-python/rlax-0.1.5[${PYTHON_USEDEP}]
	)
	julia? (
		dev-lang/julia
	)
	libnop? (
		dev-libs/libnop
	)
	python-misc? (
		>=dev-python/clu-0.0.6[${PYTHON_USEDEP}]
		>=dev-python/cvxopt-1.3.1[${PYTHON_USEDEP}]
		>=dev-python/cvxpy-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/ecos-2.0.10[${PYTHON_USEDEP}]
		>=dev-python/flax-0.5.3[${PYTHON_USEDEP}]
		>=dev-python/ipython-5.8.0[${PYTHON_USEDEP}]
		>=dev-python/matplotlib-3.5.2[${PYTHON_USEDEP}]
		>=dev-python/mock-4.0.2[${PYTHON_USEDEP}]
		>=dev-python/nashpy-0.0.19[${PYTHON_USEDEP}]
		>=dev-python/networkx-2.4[${PYTHON_USEDEP}]
		>=dev-python/osqp-python-0.6.2_p5[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.10.1[${PYTHON_USEDEP}]
		>=dev-python/testresources-2.0.1[${PYTHON_USEDEP}]
	)
	pytorch? (
		$(python_gen_any_dep '
			=sci-libs/pytorch-1.13.0*[${PYTHON_SINGLE_USEDEP}]
		')
	)
	rust? (
		virtual/rust
	)
	tensorflow? (
		=dev-python/keras-2.12*[${PYTHON_USEDEP}]
		=sci-libs/tensorflow-0.12*[${PYTHON_USEDEP},python]
		>=dev-python/numpy-1.23.5[${PYTHON_USEDEP}]
		>=dev-python/tensorflow-probability-0.19.0[${PYTHON_USEDEP}]
		>=dev-python/tensorflow-datasets-4.9.2[${PYTHON_USEDEP}]
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=dev-python/pip-20.0.2[${PYTHON_USEDEP}]
	>=dev-util/cmake-3.17
	>=sys-devel/clang-7
	doc? (
		dev-python/recommonmark[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-markdown-tables[${PYTHON_USEDEP}]
		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
	)
"
SRC_URI="
https://github.com/deepmind/open_spiel/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

src_configure() {
	export CC=${CHOST}-clang
	export CXX=${CHOST}-clang++
	# If it is marked off, it means I don't have time to package it at this time.
	export OPEN_SPIEL_BUILD_WITH_ACPC=OFF
	export OPEN_SPIEL_BUILD_WITH_EIGEN=$(usex eigen "ON" "OFF")
	export OPEN_SPIEL_BUILD_WITH_GAMUT=OFF
	export OPEN_SPIEL_BUILD_WITH_GO=$(usex go "ON" "OFF")
	export OPEN_SPIEL_BUILD_WITH_HANABI=OFF
	export OPEN_SPIEL_BUILD_WITH_HIGC=OFF
	export OPEN_SPIEL_BUILD_WITH_JULIA=$(usex julia "ON" "OFF")
	export OPEN_SPIEL_BUILD_WITH_LIBNOP=OFF
	export OPEN_SPIEL_BUILD_WITH_ORTOOLS=OFF
	export OPEN_SPIEL_BUILD_WITH_ROSHAMBO=OFF
	export OPEN_SPIEL_BUILD_WITH_RUST=$(usex rust "ON" "OFF")
	export OPEN_SPIEL_BUILD_WITH_TENSORFLOW_CC=$(usex tensorflow "ON" "OFF")
	export OPEN_SPIEL_BUILD_WITH_XINXIN=OFF
	export OPEN_SPIEL_ENABLE_JAX=$(usex jax "ON" "OFF")
	export OPEN_SPIEL_ENABLE_PYTHON_MISC=$(usex tensorflow "ON" "OFF")
	export OPEN_SPIEL_ENABLE_PYTORCH=$(usex pytorch "ON" "OFF")
	export OPEN_SPIEL_ENABLE_TENSORFLOW=$(usex tensorflow "ON" "OFF")
	distutils-r1_src_configure
}

distutils_enable_sphinx="docs"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
