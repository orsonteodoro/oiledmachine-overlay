# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-/_}"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_10 )

inherit distutils-r1

if [[ "${PV}" =~ 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/deepmind/dm_env.git"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${MY_PN}-${PV}"
	IUSE+=" fallback-commit"
else
	SRC_URI="
https://github.com/deepmind/dm_env/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A Python interface for reinforcement learning environments"
HOMEPAGE="https://github.com/deepmind/dm_env"
LICENSE="
	Apache-2.0
"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
DEPEND+="
	>=dev-python/absl-py-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/dm-tree-0.1.6[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.22.0[${PYTHON_USEDEP}]
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	test? (
		>=dev-python/pytest-6.2.5[${PYTHON_USEDEP}]
	)
"
S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="mirror"
DOCS=( CHANGELOG.md docs/index.md README.md )

src_unpack() {
	if [[ "${PV}" =~ 9999 ]] ; then
		use fallback-commit && EGIT_COMMIT="91b46797fea731f80eab8cd2c8352a0674141d89"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "__version__ = '1.6'" "${S}/dm_env/_metadata.py" \
			|| die "QA:  Bump version"
	else
		unpack ${A}
	fi
}

src_install() {
	distutils-r1_src_install
	docinto licenses
	dodoc LICENSE
}

distutils_enable_tests "pytest"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
