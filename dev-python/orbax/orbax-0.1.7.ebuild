# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See https://github.com/google/orbax/blob/v0.1.7/.github/workflows/build.yml for supported python

DISTUTILS_USE_PEP517="flit"
PYTHON_COMPAT=( python3_10 ) # Upstream only tests up to 3.9.  3.10 is an untested ebuild modificiation and may break.

inherit distutils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	inherit git-r3
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/google/orbax.git"
	FALLBACK_COMMIT="cde8f95c466b889a0e0642e4474baea983b33134" # Mar 29, 2023
	IUSE+=" fallback-commit"
else
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
	S="${WORKDIR}/${P}"
	SRC_URI="
https://github.com/google/orbax/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Orbax is a library providing common utilities for JAX users."
HOMEPAGE="
https://github.com/google/orbax
https://pypi.org/project/orbax
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
doc test
"
REQUIRED_USE="
"
DEPEND+="
	>=dev-python/jax-0.4.6[${PYTHON_USEDEP}]
	>=dev-python/tensorstore-0.1.20[${PYTHON_USEDEP}]
	dev-python/absl-py[${PYTHON_USEDEP}]
	dev-python/cached-property[${PYTHON_USEDEP}]
	dev-python/etils[${PYTHON_USEDEP}]
	dev-python/importlib-resources[${PYTHON_USEDEP}]
	dev-python/jaxlib[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]
	dev-python/nest-asyncio[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	(
		<dev-python/flit-core-4[${PYTHON_USEDEP}]
		>=dev-python/flit-core-3.5[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/flax[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
"
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

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if has "fallback-commit" ${IUSE_EFFECTIVE} ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
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
# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
# OILEDMACHINE-OVERLAY-TEST:  UNTESTED
