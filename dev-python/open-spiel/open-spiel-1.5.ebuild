# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# For test wheel requirements, see also https://github.com/deepmind/open_spiel/blob/v1.5/open_spiel/scripts/python_extra_deps.sh

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} ) # Upstream only tests up to 3.11

# Limited by jax
inherit check-compiler-switch distutils-r1 flag-o-matic

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/deepmind/open_spiel/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="OpenSpiel is a collection of environments and algorithms for \
research in general reinforcement learning and search/planning in games."
HOMEPAGE="
https://github.com/deepmind/open_spiel
"
LICENSE="Apache-2.0"
RESTRICT="mirror test" # Not tested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
doc -eigen -go -jax -julia -libnop -python-misc-deps -torch -rust -tensorflow test
ebuild_revision_6
"
REQUIRED_USE="
	tensorflow? (
		python_single_target_python3_11
		python_single_target_python3_12
	)
"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/attrs-19.3.0[${PYTHON_USEDEP}]
		>=dev-python/absl-py-0.10.0[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.10.1[${PYTHON_USEDEP}]
		>=dev-python/ml-collections-0.1.1[${PYTHON_USEDEP}]
		virtual/numpy[${PYTHON_USEDEP}]
		go? (
			dev-lang/go
		)
		julia? (
			dev-lang/julia
		)
		libnop? (
			dev-libs/libnop
		)
		rust? (
			|| (
				dev-lang/rust:=
				dev-lang/rust-bin:=
			)
		)
		tensorflow? (
			virtaul/numpy[${PYTHON_USEDEP}]
		)
	')
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/pip-20.0.2[${PYTHON_USEDEP}]
		>=dev-build/cmake-3.17
		>=llvm-core/clang-7
		doc? (
			>=dev-python/markdown-3.4[${PYTHON_USEDEP}]
			>=dev-python/recommonmark-0.7.1[${PYTHON_USEDEP}]
			>=dev-python/sphinx-5.1[${PYTHON_USEDEP}]
			>=dev-python/sphinx-markdown-tables-0.0.17[${PYTHON_USEDEP}]
			>=dev-python/sphinx-rtd-theme-1.3.0[${PYTHON_USEDEP}]
		)
		test? (
			dev-python/nox[${PYTHON_USEDEP}]
		)
	')
	jax? (
		$(python_gen_cond_dep '
			~dev-python/jax-0.4.20[${PYTHON_SINGLE_USEDEP}]
			~dev-python/jaxlib-0.4.20[${PYTHON_SINGLE_USEDEP}]
			~dev-python/dm-haiku-0.0.10[${PYTHON_SINGLE_USEDEP}]
			~dev-python/optax-0.1.7[${PYTHON_SINGLE_USEDEP}]
			~dev-python/chex-0.1.84[${PYTHON_SINGLE_USEDEP}]
			~dev-python/rlax-0.1.6[${PYTHON_SINGLE_USEDEP}]
			~dev-python/distrax-0.1.4[${PYTHON_SINGLE_USEDEP}]
		' python3_{10,11})
		$(python_gen_cond_dep '
			~dev-python/jax-0.4.26[${PYTHON_SINGLE_USEDEP}]
			~dev-python/jaxlib-0.4.26[${PYTHON_SINGLE_USEDEP}]
			~dev-python/dm-haiku-0.0.12[${PYTHON_SINGLE_USEDEP}]
			~dev-python/optax-0.2.2[${PYTHON_SINGLE_USEDEP}]
			~dev-python/chex-0.1.86[${PYTHON_SINGLE_USEDEP}]
			~dev-python/rlax-0.1.6[${PYTHON_SINGLE_USEDEP}]
			~dev-python/distrax-0.1.5[${PYTHON_SINGLE_USEDEP}]
		' python3_12)
	)
	python-misc-deps? (
		$(python_gen_cond_dep '
			~dev-python/ipython-5.8.0[${PYTHON_USEDEP}]
			~dev-python/networkx-3.2[${PYTHON_USEDEP}]
			~dev-python/matplotlib-3.5.2[${PYTHON_USEDEP}]
			~dev-python/mock-4.0.2[${PYTHON_USEDEP}]
			~dev-python/nashpy-0.0.19[${PYTHON_USEDEP}]
			~dev-python/scipy-1.11.3[${PYTHON_USEDEP}]
			~dev-python/testresources-2.0.1[${PYTHON_USEDEP}]
			~dev-python/cvxopt-1.3.1[${PYTHON_USEDEP}]
			~dev-python/cvxpy-1.4.1[${PYTHON_USEDEP}]
			~dev-python/ecos-2.0.10[${PYTHON_USEDEP}]
			~dev-python/osqp-0.6.2_p5[${PYTHON_USEDEP}]
		' python3_{10..11})
		$(python_gen_cond_dep '
			~dev-python/ipython-8.23.0[${PYTHON_USEDEP}]
			~dev-python/networkx-3.3[${PYTHON_USEDEP}]
			~dev-python/matplotlib-3.8.4[${PYTHON_USEDEP}]
			~dev-python/mock-5.1.0[${PYTHON_USEDEP}]
			~dev-python/nashpy-0.0.41[${PYTHON_USEDEP}]
			~dev-python/scipy-1.11.4[${PYTHON_USEDEP}]
			~dev-python/testresources-2.0.1[${PYTHON_USEDEP}]
			~dev-python/cvxopt-1.3.2[${PYTHON_USEDEP}]
			~dev-python/cvxpy-1.4.2[${PYTHON_USEDEP}]
			~dev-python/ecos-2.0.13[${PYTHON_USEDEP}]
			~dev-python/osqp-0.6.5[${PYTHON_USEDEP}]
		' python3_12)
		python_single_target_python3_11? (
			~dev-python/clu-0.0.6[${PYTHON_SINGLE_USEDEP}]
			~dev-python/flax-0.5.3[${PYTHON_SINGLE_USEDEP}]
		)
		python_single_target_python3_12? (
			~dev-python/clu-0.0.11[${PYTHON_SINGLE_USEDEP}]
			~dev-python/flax-0.8.2[${PYTHON_SINGLE_USEDEP}]
		)
	)
	tensorflow? (
		$(python_gen_cond_dep '
			~dev-python/keras-2.14.0[${PYTHON_SINGLE_USEDEP}]
			~sci-ml/tensorflow-2.14.0[${PYTHON_SINGLE_USEDEP},python]
			~sci-ml/tensorflow-probability-0.22.1[${PYTHON_SINGLE_USEDEP}]
			~sci-ml/tensorflow_datasets-4.9.2[${PYTHON_SINGLE_USEDEP}]
			virtual/numpy[${PYTHON_USEDEP}]
		' python3_{10,11})
		$(python_gen_cond_dep '
			~dev-python/keras-3.1.1[${PYTHON_SINGLE_USEDEP}]
			~sci-ml/tensorflow-2.16.1[${PYTHON_SINGLE_USEDEP},python]
			~sci-ml/tensorflow_datasets-4.9.4[${PYTHON_SINGLE_USEDEP}]
			virtual/numpy[${PYTHON_USEDEP}]
		' python3_12)
	)
	torch? (
		$(python_gen_cond_dep '
			~sci-ml/pytorch-2.1.0[${PYTHON_SINGLE_USEDEP}]
		' python3_{10,11})
		$(python_gen_cond_dep '
			~sci-ml/pytorch-2.2.2[${PYTHON_SINGLE_USEDEP}]
		' python3_12)
	)
"

distutils_enable_sphinx="docs"

pkg_setup() {
	check-compiler-switch_start
	python-single-r1_pkg_setup
}

src_configure() {
	export CC="${CHOST}-clang"
	export CXX="${CHOST}-clang++"
	export CPP="${CPP} -E"
	strip-unsupported-flags

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

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

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
