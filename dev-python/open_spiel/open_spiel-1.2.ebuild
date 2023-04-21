# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..9} )
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
IUSE+=" doc -eigen -go -jax -julia -libnop -pytorch -rust -tensorflow"
DEPEND+="
	>=dev-python/attrs-19.3.0[${PYTHON_USEDEP}]
	>=dev-python/absl-py-0.10.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.21.5[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.7.3[${PYTHON_USEDEP}]
	go? (
		dev-lang/go
	)
	jax? (
		dev-python/jax
	)
	julia? (
		dev-lang/julia
	)
	libnop? (
		dev-libs/libnop
	)
	rust? (
		virtual/rust
	)
	tensorflow? (
		sci-libs/tensorflow[${PYTHON_USEDEP},python]
	)
	pytorch? (
		$(python_gen_any_dep 'sci-libs/pytorch[${PYTHON_SINGLE_USEDEP}]')
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
	export OPEN_SPIEL_BUILD_WITH_JULIA=$(usex julia "ON" "OFF")
	export OPEN_SPIEL_BUILD_WITH_EIGEN=$(usex eigen "ON" "OFF")
	export OPEN_SPIEL_BUILD_WITH_GAMUT=OFF
	export OPEN_SPIEL_BUILD_WITH_GO=$(usex go "ON" "OFF")
	export OPEN_SPIEL_BUILD_WITH_HANABI=OFF
	export OPEN_SPIEL_BUILD_WITH_HIGC=OFF
	export OPEN_SPIEL_BUILD_WITH_LIBNOP=OFF
	export OPEN_SPIEL_BUILD_WITH_ORTOOLS=OFF
	export OPEN_SPIEL_BUILD_WITH_ROSHAMBO=OFF
	export OPEN_SPIEL_BUILD_WITH_RUST=$(usex rust "ON" "OFF")
	export OPEN_SPIEL_BUILD_WITH_TENSORFLOW_CC=$(usex tensorflow "ON" "OFF")
	export OPEN_SPIEL_BUILD_WITH_XINXIN=OFF
	export OPEN_SPIEL_ENABLE_JAX=$(usex jax "ON" "OFF")
	export OPEN_SPIEL_ENABLE_PYTORCH=$(usex pytorch "ON" "OFF")
	export OPEN_SPIEL_ENABLE_TENSORFLOW=$(usex tensorflow "ON" "OFF")
	distutils-r1_src_configure
}

distutils_enable_sphinx="docs"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
