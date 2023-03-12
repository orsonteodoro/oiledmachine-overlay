# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="A toolkit for developing and comparing reinforcement learning \
algorithms."
HOMEPAGE="
https://www.gymlibrary.dev/
https://github.com/openai/gym
"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" atari accept-rom-license box2d classic-control mujoco mujoco_py pygame toy_text test"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
	box2d? (
		pygame
	)
	classic-control? (
		pygame
	)
	toy_text? (
		pygame
	)
"
#	>=dev-python/dataclasses-0.8[${PYTHON_USEDEP}] # 3.6 only
DEPEND+="
	${PYTHON_DEPS}
	>=dev-python/ale-py-0.8.0[${PYTHON_USEDEP}]
	>=dev-python/cloudpickle-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/gym-notices-0.0.4[${PYTHON_USEDEP}]
	>=dev-python/importlib_metadata-4.8.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.18.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.3.0[${PYTHON_USEDEP}]

	>=dev-python/lz4-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-3.0[${PYTHON_USEDEP}]
	>=dev-python/moviepy-1.0.0[${PYTHON_USEDEP}]
	>=media-libs/opencv-3.0[${PYTHON_USEDEP},python]

	atari? (
		>=dev-python/ale-py-0.8.0[${PYTHON_USEDEP}]
	)
	accept-rom-license? (
		>=dev-python/autorom-0.4.2[${PYTHON_USEDEP}]
	)
	box2d? (
		>=dev-lang/swig-4
		>=dev-python/box2d-py-2.3.5[${PYTHON_USEDEP}]
	)
	mujoco? (
		>=dev-python/mujoco-2.2.0[${PYTHON_USEDEP}]
		>=dev-python/imageio-2.14.1[${PYTHON_USEDEP}]
	)
	mujoco_py? (
		>=dev-python/mujoco-py-2.1[${PYTHON_USEDEP}]
		<dev-python/mujoco-py-2.2[${PYTHON_USEDEP}]
	)
	pygame? (
		>=dev-python/pygame-2.1.0[${PYTHON_USEDEP}]
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	test? (
		(
			>=dev-python/mujoco-py-2.1[${PYTHON_USEDEP}]
			<dev-python/mujoco-py-2.2[${PYTHON_USEDEP}]
		)
		>=dev-python/box2d-py-2.3.5[${PYTHON_USEDEP}]
		>=dev-python/imageio-2.14.1[${PYTHON_USEDEP}]
		>=dev-python/lz4-3.1.0[${PYTHON_USEDEP}]
		>=dev-python/matplotlib-3.0[${PYTHON_USEDEP}]
		>=dev-python/mujoco-2.2.0[${PYTHON_USEDEP}]
		>=dev-python/pygame-2.1.0[${PYTHON_USEDEP}]
		>=media-libs/opencv-3.0[${PYTHON_USEDEP},python]
		<dev-python/pytest-7.0.1[${PYTHON_USEDEP}]
	)
"
SRC_URI="
https://github.com/openai/gym/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
