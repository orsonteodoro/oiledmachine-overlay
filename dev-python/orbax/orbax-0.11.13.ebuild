# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See https://github.com/google/orbax/blob/v0.1.7/.github/workflows/build.yml for supported python

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="flit"
PYTHON_COMPAT=( "python3_"{11,12} )

inherit distutils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	inherit git-r3
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/google/orbax.git"
	FALLBACK_COMMIT="cde8f95c466b889a0e0642e4474baea983b33134" # Mar 29, 2023
	IUSE+=" fallback-commit"
else
	KEYWORDS="~amd64"
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
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/simplejson-3.16.0[${PYTHON_USEDEP}]
		>=sci-libs/tensorstore-0.1.71[${PYTHON_USEDEP}]
		dev-python/absl-py[${PYTHON_USEDEP}]
		dev-python/humanize[${PYTHON_USEDEP}]
		dev-python/msgpack[${PYTHON_USEDEP}]
		dev-python/nest-asyncio[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/protobuf[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	')
	>=dev-python/jax-0.5.0[${PYTHON_SINGLE_USEDEP}]
	dev-python/etils[${PYTHON_SINGLE_USEDEP}]
	dev-python/jaxlib[${PYTHON_SINGLE_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		(
			>=dev-python/flit-core-3.5[${PYTHON_USEDEP}]
			<dev-python/flit-core-4[${PYTHON_USEDEP}]
		)
		test? (
			dev-python/aiofiles[${PYTHON_USEDEP}]
			dev-python/google-cloud-logging[${PYTHON_USEDEP}]
			dev-python/mock[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
		)
	')
	test? (
		dev-python/chex[${PYTHON_SINGLE_USEDEP}]
		dev-python/flax[${PYTHON_SINGLE_USEDEP}]
	)
"
DOCS=( "CHANGELOG.md" "README.md" )

distutils_enable_sphinx "docs"
distutils_enable_tests "pytest"

pkg_setup() {
	python-single-r1_pkg_setup
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
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
# OILEDMACHINE-OVERLAY-TEST:  UNTESTED
