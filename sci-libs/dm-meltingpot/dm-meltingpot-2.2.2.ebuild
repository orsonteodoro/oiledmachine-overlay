# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# pip-tools
# pyink
# pytype

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/google-deepmind/meltingpot.git"
	FALLBACK_COMMIT="c3f7bb030a587cba344e4d81897ed218de529d30" # Mar 19, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${S}"
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
	S="${WORKDIR}/meltingpot-${PV}"
	SRC_URI="
https://github.com/google-deepmind/meltingpot/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A suite of test scenarios for multi-agent reinforcement learning."
HOMEPAGE="
	https://github.com/google-deepmind/meltingpot
	https://pypi.org/project/dm-meltingpot
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev"
RDEPEND+="
	<dev-python/opencv-4.7[${PYTHON_USEDEP}]
	dev-python/absl-py[${PYTHON_USEDEP}]
	dev-python/immutabledict[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/pygame[${PYTHON_USEDEP}]
	dev-python/reactivex[${PYTHON_USEDEP}]
	sci-libs/chex[${PYTHON_USEDEP}]
	sci-libs/dmlab2d[${PYTHON_USEDEP}]
	sci-libs/dm-tree[${PYTHON_USEDEP}]
	sci-libs/dm_env[${PYTHON_USEDEP}]
	sci-libs/ml-collections[${PYTHON_USEDEP}]
	sci-libs/tensorflow[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-42[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	dev? (
		dev-python/build[${PYTHON_USEDEP}]
		dev-python/isort[${PYTHON_USEDEP}]
		dev-python/pipreqs[${PYTHON_USEDEP}]
		dev-python/pip-tools[${PYTHON_USEDEP}]
		dev-python/pyink[${PYTHON_USEDEP}]
		dev-python/pylint[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/pytype[${PYTHON_USEDEP}]
		dev-python/twine[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "VERSION = '2.2.2'" "${S}/setup.py" \
			|| die "QA:  Bump version"
	else
		unpack ${A}
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
