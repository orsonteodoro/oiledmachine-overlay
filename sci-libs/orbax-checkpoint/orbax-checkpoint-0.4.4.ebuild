# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

# See https://github.com/google/orbax/blob/main/.github/workflows/build.yml for supported python

# TODO package:
# google-cloud-logging

DISTUTILS_USE_PEP517="flit"
PROTOBUF_PV="3.21.11"
PYTHON_COMPAT=( "python3_"{10,11} ) # Upstream only tests up to 3.11.

inherit distutils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/google/orbax.git"
	FALLBACK_COMMIT="93f635031c2120bc9390f6657ed3849329819efb" # Dec 1, 2023
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
	S="${WORKDIR}/${P}/checkpoint"
	inherit pypi
fi

DESCRIPTION="Orbax Checkpoint"
HOMEPAGE="
https://github.com/google/orbax/tree/main/checkpoint
https://pypi.org/project/orbax-checkpoint
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror test"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
tensorflow test
"
REQUIRED_USE="
"
CHECKPOINT_DEPEND="
	(
		>=sci-libs/tensorstore-0.1.35[${PYTHON_USEDEP}]
		<sci-libs/tensorstore-0.1.38[${PYTHON_USEDEP}]
	)
	>=dev-libs/protobuf-${PROTOBUF_PV}:0/${PROTOBUF_PV%.*}
	>=sci-libs/jax-0.4.9[${PYTHON_USEDEP}]
	dev-python/absl-py[${PYTHON_USEDEP}]
	dev-python/etils[${PYTHON_USEDEP}]
	dev-python/jaxtyping[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]
	dev-python/nest-asyncio[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/protobuf-python:0/${PROTOBUF_PV%.*}[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	sci-libs/jaxlib[${PYTHON_USEDEP}]
"
DEPEND+="
	${CHECKPOINT_DEPEND}
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	(
		>=dev-python/flit-core-3.5[${PYTHON_USEDEP}]
		<dev-python/flit-core-4[${PYTHON_USEDEP}]
	)
	test? (
		sci-libs/flax[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
"
# Avoid circular depends with tensorflow \
PDEPEND+="
	tensorflow? (
		>=sci-libs/tensorflow-2.15.0[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" )

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
	docinto "docs"
	dodoc *".md"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
# OILEDMACHINE-OVERLAY-TEST:  UNTESTED
