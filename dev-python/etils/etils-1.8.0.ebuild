# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# dataclass-array
# chex
# fsspec
# gcsfs
# mediapy
# optree
# pyink
# simple_parsing
# sphinx-apitree (missing for doc)

DISTUTILS_USE_PEP517="flit"
PYTHON_COMPAT=( python3_11 ) # Upstream only tests 3.11

# Limited by jax
inherit distutils-r1

KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/google/etils/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Collection of eclectic utils for python."
HOMEPAGE="
https://github.com/google/etils
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror test"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
array-types doc eapp ecolab edc enp epath epath-gcs epath-s3 epy etqdm etree
etree-dm etree-jax etree-tf lazy-imports test
"
REQUIRED_USE+="
	array-types? (
		enp
	)
	eapp? (
		epy
	)
	ecolab? (
		enp
		epy
		etree
	)
	doc? (
		array-types
		eapp
		ecolab
		edc
		enp
		epath
		epath-gcs
		epath-s3
		epy
		etqdm
		etree
		etree-dm
		etree-jax
		etree-tf
		test
	)
	edc? (
		epy
	)
	enp? (
		epy
	)
	epath? (
		epy
	)
	epath-gcs? (
		epath
	)
	epath-s3? (
		epath
	)
	etqdm? (
		epy
	)
	etree? (
		array-types
		epy
		enp
		etqdm
	)
	etree-dm? (
		etree
	)
	etree-jax? (
		etree
	)
	etree-tf? (
		etree
	)
	lazy-imports? (
		ecolab
	)
"
DEPEND+="
	eapp? (
		dev-python/absl-py[${PYTHON_USEDEP}]
		dev-python/simple_parsing[${PYTHON_USEDEP}]
	)
	ecolab? (
		dev-python/jupyter[${PYTHON_USEDEP}]
		dev-python/mediapy[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/python-protobuf[${PYTHON_USEDEP}]
	)
	enp? (
		dev-python/numpy[${PYTHON_USEDEP}]
	)
	epath? (
		dev-python/fsspec[${PYTHON_USEDEP}]
		dev-python/importlib-resources[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
		dev-python/zipp[${PYTHON_USEDEP}]
	)
	epath-gcs? (
		dev-python/gcsfs[${PYTHON_USEDEP}]
	)
	epath-s3? (
		dev-python/s3[${PYTHON_USEDEP}]
	)
	epy? (
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	)
	etqdm? (
		dev-python/absl-py[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
	)
	etree-dm? (
		dev-python/dm-tree[${PYTHON_USEDEP}]
	)
	etree-jax? (
		dev-python/jax[${PYTHON_USEDEP}]
	)
	etree-tf? (
		sci-libs/tensorflow[${PYTHON_USEDEP}]
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	(
		<dev-python/flit_core-4[${PYTHON_USEDEP}]
		>=dev-python/flit_core-3.8[${PYTHON_USEDEP}]
	)
	doc? (
		dev-python/sphinx-apitree[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/pylint-2.6.0[${PYTHON_USEDEP}]
		dev-python/chex[${PYTHON_USEDEP}]
		dev-python/dataclass-array[${PYTHON_USEDEP}]
		dev-python/optree[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-subtests[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/pyink[${PYTHON_USEDEP}]
		sci-libs/pytorch[${PYTHON_USEDEP}]
	)
"
DOCS=( "CHANGELOG.md" "README.md" )

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

distutils_enable_tests "pytest"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  UNTESTED
