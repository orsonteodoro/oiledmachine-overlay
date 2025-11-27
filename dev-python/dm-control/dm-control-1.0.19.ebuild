# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

MY_PN="${PN/-/_}"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{8..11} ) # CI tests with 3.10

inherit abseil-cpp distutils-r1 protobuf

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${PV}"
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
ebuild_revision_1
"
RDEPEND+="
	>=dev-python/absl-py-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/lxml-5.2.1[${PYTHON_USEDEP}]
	>=dev-python/mujoco-3.1.5[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.26.4[${PYTHON_USEDEP}]
	>=dev-python/pyglfw-1.12.0[${PYTHON_USEDEP}]
	>=dev-python/pyopengl-3.1.7[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-3.1.2[${PYTHON_USEDEP}]
	>=dev-python/requests-2.31.0[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.13.0[${PYTHON_USEDEP}]
	>=dev-python/tqdm-4.66.4[${PYTHON_USEDEP}]
	>=dev-python/dm-tree-0.1.8[${PYTHON_USEDEP}]
	>=dev-python/dm-env-1.6[${PYTHON_USEDEP}]
	>=dev-python/labmaze-1.0.6[${PYTHON_USEDEP}]
	hdf5? (
		>=dev-python/h5py-3.11.0[${PYTHON_USEDEP}]
	)
	|| (
		dev-python/protobuf:4.21[${PYTHON_USEDEP}]
		dev-python/protobuf:5.29[${PYTHON_USEDEP}]
	)
	dev-python/protobuf:=
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-69.0.2[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-3.1.2[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	test? (
		>=dev-python/mock-5.1.0[${PYTHON_USEDEP}]
		>=dev-python/nose-1.3.7[${PYTHON_USEDEP}]
		>=dev-python/nose_xunitmp-0.4.1[${PYTHON_USEDEP}]
		>=virtual/pillow-10.3.0[${PYTHON_USEDEP}]
	)
"

python_configure() {
	if has_version "dev-libs/protobuf:5/5.29" ; then
	# Align with TensorFlow 2.20
		ABSEIL_CPP_SLOT="20240722"
		PROTOBUF_CPP_SLOT="5"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_5[@]}" )
	elif has_version "dev-libs/protobuf:3/3.21" ; then
	# Align with TensorFlow 2.17
		ABSEIL_CPP_SLOT="20220623"
		PROTOBUF_CPP_SLOT="4"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_3[@]}" )
	else
	# Align with TensorFlow 2.20
		ABSEIL_CPP_SLOT="20240722"
		PROTOBUF_CPP_SLOT="5"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_5[@]}" )
	fi
	abseil-cpp_python_configure
	protobuf_python_configure
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
