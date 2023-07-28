# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="flit"
PYTHON_COMPAT=( python3_{8..10} ) # Upstream only tests up to 3.9
inherit distutils-r1

DESCRIPTION="Orbax is a library providing common utilities for JAX users."
HOMEPAGE="
https://github.com/google/orbax
"
LICENSE="
	Apache-2.0
"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
doc test
python_targets_python3_9
"
REQUIRED_USE="
python_targets_python3_9
"
DEPEND+="
	$(python_gen_cond_dep 'dev-python/importlib-resources[${PYTHON_USEDEP}]' python3_9)
	>=dev-python/jax-0.4.6[${PYTHON_USEDEP}]
	>=dev-python/tensorstore-0.1.20[${PYTHON_USEDEP}]
	dev-python/absl-py[${PYTHON_USEDEP}]
	dev-python/cached-property[${PYTHON_USEDEP}]
	dev-python/etils[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]
	dev-python/nest_asyncio[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	|| (
		dev-python/jaxlib[${PYTHON_USEDEP}]
		dev-python/jaxlib-bin[${PYTHON_USEDEP}]
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	(
		<dev-python/flit_core-4[${PYTHON_USEDEP}]
		>=dev-python/flit_core-3.5[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/flax[${PYTHON_USEDEP}]
	)
"
SRC_URI="
https://github.com/google/orbax/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
DOCS=( CHANGELOG.md README.md )

pkg_setup() {
	if use python_target_python3_10 ; then
eerror
eerror "python_target_python3_10 is a dummy placeholder"
eerror "Please remove it.  Upstream only supports up to 3.9."
eerror
		die
	fi
}

src_install() {
	distutils-r1_src_install
	docinto licenses
	dodoc LICENSE
	docinto docs
	dodoc docs/*.md
}

distutils_enable_tests "pytest"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
