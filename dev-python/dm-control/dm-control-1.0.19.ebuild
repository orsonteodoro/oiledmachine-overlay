# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

MY_PN="${PN/-/_}"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{8..11} ) # CI tests with 3.10

inherit distutils-r1 protobuf-ver

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
gen_protobuf_rdepend() {
	local s
	for s in ${PROTOBUF_SLOTS[@]} ; do
		echo "
			dev-python/protobuf:0/${s}[${PYTHON_USEDEP}]
		"
	done
}
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
		$(gen_protobuf_rdepend)
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

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
