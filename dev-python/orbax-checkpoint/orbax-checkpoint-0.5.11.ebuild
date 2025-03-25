# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

# See https://github.com/google/orbax/blob/main/.github/workflows/build.yml for supported python

DISTUTILS_USE_PEP517="flit"
PROTOBUF_SLOTS=(
	"3.21"
	"4.23"
	"4.24"
	"4.25"
	"5.26"
	"5.27"
)
PYTHON_COMPAT=( "python3_"{10,11} ) # Upstream only tests up to 3.11.

inherit distutils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/google/orbax.git"
	FALLBACK_COMMIT="87a30af2dc06a7f0a48f1bcebc787bf05b0e41a0" # May 10, 2024
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${P}/checkpoint"
	inherit pypi
fi

DESCRIPTION="A checkpointing library for Orbax"
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
gen_protobuf_checkpoint_rdepend() {
	local s
	for s in ${PROTOBUF_SLOTS[@]} ; do
		echo "
			dev-libs/protobuf:0/${s}
			dev-python/protobuf:0/${s}[${PYTHON_USEDEP}]
		"
	done
}
CHECKPOINT_RDEPEND="
	(
		>=sci-libs/tensorstore-0.1.51[${PYTHON_USEDEP}]
	)
	>=dev-python/jax-0.4.9[${PYTHON_USEDEP}]
	dev-python/absl-py[${PYTHON_USEDEP}]
	dev-python/etils[${PYTHON_USEDEP},epath,epy]
	dev-python/msgpack[${PYTHON_USEDEP}]
	dev-python/nest-asyncio[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	dev-python/jaxlib[${PYTHON_USEDEP}]
	dev-python/jaxtyping[${PYTHON_USEDEP}]
	|| (
		$(gen_protobuf_checkpoint_rdepend)
	)
	dev-libs/protobuf:=
	dev-python/protobuf:=
"
ORBAX_EXPORT_RDEPEND="
	dev-python/absl-py[${PYTHON_USEDEP}]
	dev-python/dataclasses-json[${PYTHON_USEDEP}]
	dev-python/etils[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/jax[${PYTHON_USEDEP}]
	dev-python/jaxlib[${PYTHON_USEDEP}]
"
RDEPEND+="
	${CHECKPOINT_RDEPEND}
"
DEPEND+="
	${RDEPEND}
"
CHECKPOINT_TEST_BDEPEND="
	dev-libs/pytest[${PYTHON_USEDEP}]
	dev-libs/pytest-xdist[${PYTHON_USEDEP}]
	dev-python/google-cloud-logging[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/flax[${PYTHON_USEDEP}]
"
ORBAX_EXPORT_TEST_BDEPEND="
	=sci-ml/tensorflow-9999[${PYTHON_USEDEP}]
	dev-libs/pytest[${PYTHON_USEDEP}]
	dev-libs/pytest-xdist[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
BDEPEND+="
	(
		>=dev-python/flit-core-3.5[${PYTHON_USEDEP}]
		<dev-python/flit-core-4[${PYTHON_USEDEP}]
	)
	test? (
		${CHECKPOINT_TEST_BDEPEND}
	)
"
# Avoid circular depends with tensorflow \
PDEPEND+="
	tensorflow? (
		>=sci-ml/tensorflow-2.15.0[${PYTHON_USEDEP}]
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
