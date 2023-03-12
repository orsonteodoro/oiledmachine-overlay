# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="A standard API for single-agent reinforcement learning \
environments, with popular reference environments and related utilities \
(formerly Gym)"
HOMEPAGE="
https://gymnasium.farama.org/
https://github.com/Farama-Foundation/Gymnasium
"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" atari accept-rom-license box2d jax mujoco mujoco_py pygame"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
	box2d? (
		pygame
	)
"
DEPEND+="
	${PYTHON_DEPS}
	>=dev-python/cloudpickle-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/importlib_metadata-4.8.0[${PYTHON_USEDEP}]
	>=dev-python/jumpy-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.21.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.3.0[${PYTHON_USEDEP}]
	>=dev-python/gymnasium-notices-0.0.1[${PYTHON_USEDEP}]

	>=dev-python/lz4-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-3.0[${PYTHON_USEDEP}]
	>=dev-python/moviepy-1.0.0[${PYTHON_USEDEP}]
	>=media-libs/opencv-3.0[${PYTHON_USEDEP}]
	>=sci-libs/pytorch-1.0.0[${PYTHON_USEDEP}]

	atari? (
		>=dev-python/shimmy-0.1.0[${PYTHON_USEDEP}]
		<dev-python/shimmy-1.0[${PYTHON_USEDEP}]
	)
	accept-rom-license? (
		>=dev-python/autorom-0.4.2[${PYTHON_USEDEP}]
	)
	box2d? (
		>=dev-python/box2d-py-2.3.5[${PYTHON_USEDEP}]
		>=dev-lang/swig-4
	)
	jax? (
		>=dev-python/jax-0.3.24[${PYTHON_USEDEP}]
		>=dev-python/jaxlib-0.3.24[${PYTHON_USEDEP}]
	)
	mujoco? (
		>=dev-python/mujoco-2.3.1[${PYTHON_USEDEP}]
		>=dev-python/imageio-2.3.1_p1[${PYTHON_USEDEP}]
	)
	mujoco_py? (
		>=dev-python/mujoco-2.1[${PYTHON_USEDEP}]
		<dev-python/mujoco-2.2[${PYTHON_USEDEP}]
	)
	pygame? (
		>=dev-python/pygame-2.1.3_pre[${PYTHON_USEDEP}]
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
"
SRC_URI="
https://github.com/Farama-Foundation/Gymnasium/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
