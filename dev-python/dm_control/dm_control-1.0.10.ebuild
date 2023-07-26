# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="DeepMind's software stack for physics-based simulation and \
Reinforcement Learning environments, using MuJoCo."
HOMEPAGE="
https://github.com/deepmind/dm_control
"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" hdf5 test"
# Needs packaging:
# dm-env
# dm-tree
# labmaze
# nose-xunitmp

DEPEND+="
	>=dev-python/absl-py-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/dm-env-1.6[${PYTHON_USEDEP}]
	>=dev-python/dm-tree-0.1.8[${PYTHON_USEDEP}]
	>=dev-python/labmaze-1.0.6[${PYTHON_USEDEP}]
	>=dev-python/lxml-4.9.2[${PYTHON_USEDEP}]
	>=dev-python/mujoco-2.3.2[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.24.2[${PYTHON_USEDEP}]
	>=dev-python/protobuf-python-3.19.4[${PYTHON_USEDEP}]
	>=dev-python/pyglfw-1.12.0[${PYTHON_USEDEP}]
	>=dev-python/pyopengl-3.1.6[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-3.0.9[${PYTHON_USEDEP}]
	>=dev-python/requests-2.28.2[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/tqdm-4.64.1[${PYTHON_USEDEP}]
	test? (
		>=dev-python/h5py-3.8.0[${PYTHON_USEDEP}]
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-67.2.0[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	test? (
		>=dev-python/mock-4.0.3[${PYTHON_USEDEP}]
		>=dev-python/nose-1.3.7[${PYTHON_USEDEP}]
		>=dev-python/nose-xunitmp-0.4.1[${PYTHON_USEDEP}]
		>=dev-python/pillow-9.4.0[${PYTHON_USEDEP}]
	)
"
SRC_URI="
https://github.com/deepmind/dm_control/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

distutils_enable_tests "nose"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
