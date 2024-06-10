# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{10..11} )
# Limited by jax

inherit distutils-r1

KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/Farama-Foundation/Gymnasium/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="A standard API for single-agent reinforcement learning \
environments, with popular reference environments and related utilities \
(formerly Gym)"
HOMEPAGE="
https://gymnasium.farama.org/
https://github.com/Farama-Foundation/Gymnasium
"
LICENSE="MIT"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" atari accept-rom-license box2d classic-control jax mujoco other pygame test toy-text"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
	box2d? (
		pygame
	)
	classic-control? (
		pygame
	)
	toy-text? (
		pygame
	)
"
RDEPEND+="
	${PYTHON_DEPS}
	>=dev-python/cloudpickle-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/farama-notifications-0.0.1[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.21.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.3.0[${PYTHON_USEDEP}]
	>=sci-libs/jumpy-0.2.0[${PYTHON_USEDEP}]

	atari? (
		>=sci-libs/shimmy-0.1.0[${PYTHON_USEDEP}]
		<sci-libs/shimmy-1.0[${PYTHON_USEDEP}]
	)
	accept-rom-license? (
		>=sci-libs/autorom-accept-rom-license-0.4.2[${PYTHON_USEDEP}]
	)
	box2d? (
		>=dev-python/box2d-py-2.3.5[${PYTHON_USEDEP}]
		>=dev-lang/swig-4
	)
	jax? (
		>=sci-libs/jax-0.4.0[${PYTHON_USEDEP}]
		>=sci-libs/jaxlib-0.4.0[${PYTHON_USEDEP}]
	)
	mujoco? (
		|| (
			(
				(
					>=dev-python/mujoco-2.3.3[${PYTHON_USEDEP}]
					<dev-python/mujoco-2.4.0[${PYTHON_USEDEP}]
				)
				>=dev-python/imageio-2.14.1[${PYTHON_USEDEP}]
			)
			(
				>=dev-python/mujoco-py-2.1[${PYTHON_USEDEP}]
				<dev-python/mujoco-py-2.2[${PYTHON_USEDEP}]
			)
		)
	)
	other? (
		$(python_gen_any_dep '
			>=sci-libs/pytorch-1.0.0[${PYTHON_SINGLE_USEDEP}]
		')
		>=dev-python/lz4-3.1.0[${PYTHON_USEDEP}]
		>=dev-python/matplotlib-3.0[${PYTHON_USEDEP}]
		>=dev-python/moviepy-1.0.0[${PYTHON_USEDEP}]
		>=media-libs/opencv-3.0[${PYTHON_USEDEP}]
	)
	pygame? (
		>=dev-python/pygame-2.1.3[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	>=dev-python/setuptools-61.0.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pytest-7.1.3[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.7.3[${PYTHON_USEDEP}]
		dev-python/black[${PYTHON_USEDEP}]
		dev-python/isort[${PYTHON_USEDEP}]
		dev-python/pyright[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests "pytest"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
