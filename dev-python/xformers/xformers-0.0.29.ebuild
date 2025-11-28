# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package
# fairscale
# fvcore
# flake8-copyright
# pyre-check
# pyre-extensions
# submitit

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit abseil-cpp distutils-r1 protobuf pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/facebookresearch/xformers.git"
	FALLBACK_COMMIT="a934f413e487d6cf86dd24598a3d6f2dc3c246d5" # Jan 25, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/facebookresearch/xformers/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Hackable and optimized Transformers building blocks, supporting a composable construction"
HOMEPAGE="
	https://github.com/facebookresearch/xformers
	https://pypi.org/project/xformers
"
LICENSE="
	BSD
"
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" benchmark lra-benchmark test"
REQUIRED_USE="
	benchmark? (
		test
	)
"
RDEPEND+="
	>=sci-ml/pytorch-2.4[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
	')
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	benchmark? (
		$(python_gen_cond_dep '
			>=dev-python/tqdm-4.59.0[${PYTHON_USEDEP}]
			>=dev-python/pandas-2.2.2[${PYTHON_USEDEP}]
			>=dev-python/seaborn-0.13.2[${PYTHON_USEDEP}]
		')
		>=dev-python/pytorch-lightning-1.3[${PYTHON_SINGLE_USEDEP}]
		>=sci-ml/torchmetrics-0.7.0[${PYTHON_SINGLE_USEDEP}]
	)
	lra-benchmark? (
		$(python_gen_cond_dep '
			dev-python/submitit[${PYTHON_USEDEP}]
			dev-python/fvcore[${PYTHON_USEDEP}]
		')
		>=sci-ml/tensorflow-2.3.1[${PYTHON_SINGLE_USEDEP}]
		>=sci-ml/tensorflow-text-2.7.3[${PYTHON_SINGLE_USEDEP}]
		>=sci-ml/tensorflow-datasets-4.0.1[${PYTHON_SINGLE_USEDEP}]
		>=sci-visualization/tensorboard-2.3.0[${PYTHON_SINGLE_USEDEP}]
	)
	test? (
		$(python_gen_cond_dep '
			>=dev-python/black-22.3.0[${PYTHON_USEDEP}]
			>=dev-python/flake8-6.1.0[${PYTHON_USEDEP}]
			>=dev-python/isort-5.7.0[${PYTHON_USEDEP}]
			>=dev-python/mypy-1.10.0[${PYTHON_USEDEP}]
			>=dev-python/pyre-check-0.9.16[${PYTHON_USEDEP}]
			>=dev-python/pyre-extensions-0.0.29[${PYTHON_USEDEP}]
			>=dev-python/click-8.0.4[${PYTHON_USEDEP}]
			|| (
				dev-python/protobuf:4.21[${PYTHON_USEDEP}]
				dev-python/protobuf:4.25[${PYTHON_USEDEP}]
				dev-python/protobuf:5.29[${PYTHON_USEDEP}]
				dev-python/protobuf:6.33[${PYTHON_USEDEP}]
			)
			>=dev-python/protobuf-3.20.2[${PYTHON_USEDEP}]
			dev-python/protobuf:=
			dev-python/flake8-copyright[${PYTHON_USEDEP}]

			>=dev-python/pytest-7.2.0[${PYTHON_USEDEP}]
			>=dev-python/pytest-cov-2.10.0[${PYTHON_USEDEP}]
			>=dev-python/pytest-mpi-0.4[${PYTHON_USEDEP}]
			>=dev-python/pytest-timeout-1.4.2[${PYTHON_USEDEP}]
			>=dev-python/pytest-random-order-1.1.1[${PYTHON_USEDEP}]

			>=dev-python/fairscale-0.4.5[${PYTHON_USEDEP}]
			>=dev-python/scipy-1.7[${PYTHON_USEDEP}]
		')
	)
	dev-build/cmake
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

protobuf_configure() {
	if has_version "dev-libs/protobuf:3/3.21" ; then
		ABSEIL_CPP_SLOT="20220623"
		PROTOBUF_CPP_SLOT="3"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_3[@]}" )
	elif has_version "dev-libs/protobuf:4/4.25" ; then
		ABSEIL_CPP_SLOT="20240116"
		PROTOBUF_CPP_SLOT="4"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_4[@]}" )
	elif has_version "dev-libs/protobuf:5/5.29" ; then
		ABSEIL_CPP_SLOT="20240722"
		PROTOBUF_CPP_SLOT="5"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_5[@]}" )
	elif has_version "dev-libs/protobuf:6/6.33" ; then
		ABSEIL_CPP_SLOT="20250512"
		PROTOBUF_CPP_SLOT="6"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_6[@]}" )
	fi
	abseil-cpp_python_configure
	protobuf_python_configure
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
