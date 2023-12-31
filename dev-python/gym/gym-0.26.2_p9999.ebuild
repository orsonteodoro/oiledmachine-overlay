# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_10 )

inherit distutils-r1

if [[ "${PV}" =~ 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/openai/gym.git"
	EGIT_BRANCH="master"
	IUSE+=" fallback-commit"
else
	SRC_URI="
https://github.com/openai/gym/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi


DESCRIPTION="A toolkit for developing and comparing reinforcement learning \
algorithms."
HOMEPAGE="
https://www.gymlibrary.dev/
https://github.com/openai/gym
"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" atari accept-rom-license box2d classic-control mujoco mujoco-py pygame toy_text test"
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
DEPEND+="
	${PYTHON_DEPS}
	>=dev-python/ale-py-0.8.0[${PYTHON_USEDEP}]
	>=dev-python/cloudpickle-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/gym-notices-0.0.4[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.18.0[${PYTHON_USEDEP}]

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
		(
			<dev-python/mujoco-2.3.0[${PYTHON_USEDEP}]
			>=dev-python/mujoco-2.2.0[${PYTHON_USEDEP}]
		)
		>=dev-python/imageio-2.14.1[${PYTHON_USEDEP}]
	)
	mujoco-py? (
		<dev-python/mujoco-py-2.2[${PYTHON_USEDEP}]
		>=dev-python/mujoco-py-2.1[${PYTHON_USEDEP}]
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
			<dev-python/mujoco-py-2.2[${PYTHON_USEDEP}]
			>=dev-python/mujoco-py-2.1[${PYTHON_USEDEP}]
		)
		>=dev-python/box2d-py-2.3.5[${PYTHON_USEDEP}]
		>=dev-python/imageio-2.14.1[${PYTHON_USEDEP}]
		>=dev-python/lz4-3.1.0[${PYTHON_USEDEP}]
		>=dev-python/matplotlib-3.0[${PYTHON_USEDEP}]
		>=dev-python/mujoco-2.2.0[${PYTHON_USEDEP}]
		>=dev-python/pygame-2.1.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.0.1[${PYTHON_USEDEP}]
		>=media-libs/opencv-3.0[${PYTHON_USEDEP},python]
	)
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

distutils_enable_tests "pytest"

unpack_live() {
	use fallback-commit && EGIT_COMMIT="dcd185843a62953e27c2d54dc8c2d647d604b635"
	git-r3_fetch
	git-r3_checkout
	grep -E \
		-e "VERSION = \"$(ver_cut 1-3 ${PV})\"" \
		"${S}/gym/version.py" \
		|| die "QA:  Bump the version"
}

src_unpack() {
	if [[ "${PV}" =~ 9999 ]] ; then
		unpack_live
	else
		unpack ${A}
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
