# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

# TODO packaging:
# nose-xunitmp

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{8..11} ) # CI tests with 3.10

inherit distutils-r1

KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
https://github.com/deepmind/dm_control/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="DeepMind's software stack for physics-based simulation and \
Reinforcement Learning environments, using MuJoCo."
HOMEPAGE="
https://github.com/deepmind/dm_control
"
LICENSE="Apache-2.0"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
hdf5 test
ebuild-revision-1
"

DEPEND+="
	>=dev-python/absl-py-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/lxml-5.2.1[${PYTHON_USEDEP}]
	>=dev-python/mujoco-3.1.5[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.26.4[${PYTHON_USEDEP}]
	>=dev-python/protobuf-python-3.19.4:0/3.21[${PYTHON_USEDEP}]
	>=dev-python/pyglfw-1.12.0[${PYTHON_USEDEP}]
	>=dev-python/pyopengl-3.1.7[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-3.1.2[${PYTHON_USEDEP}]
	>=dev-python/requests-2.31.0[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.13.0[${PYTHON_USEDEP}]
	>=dev-python/tqdm-4.66.4[${PYTHON_USEDEP}]
	>=sci-libs/dm-tree-0.1.8[${PYTHON_USEDEP}]
	>=sci-libs/dm_env-1.6[${PYTHON_USEDEP}]
	>=sci-libs/labmaze-1.0.6[${PYTHON_USEDEP}]
	hdf5? (
		>=dev-python/h5py-3.11.0[${PYTHON_USEDEP}]
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-69.0.2[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-3.1.2[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	test? (
		>=dev-python/mock-5.1.0[${PYTHON_USEDEP}]
		>=dev-python/nose-1.3.7[${PYTHON_USEDEP}]
		>=dev-python/nose-xunitmp-0.4.1[${PYTHON_USEDEP}]
		>=dev-python/pillow-10.3.0[${PYTHON_USEDEP}]
	)
"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
