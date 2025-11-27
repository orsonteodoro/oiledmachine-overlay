# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

# See https://github.com/google/orbax/blob/main/.github/workflows/build.yml for supported python

# TODO package:
# google-cloud-logging

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="flit"
PYTHON_COMPAT=( "python3_11" ) # Upstream only tests up to 3.11.

inherit abseil-cpp distutils-r1 protobuf

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/google/orbax.git"
	FALLBACK_COMMIT="93f635031c2120bc9390f6657ed3849329819efb" # Dec 1, 2023
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
	local impl
	for impl in "${PYTHON_COMPAT[@]}" ; do
		echo "
			python_single_target_${impl}? (
				|| (
					(
						dev-libs/protobuf:3
						dev-python/protobuf:4.21[python_targets_${impl}(-)]
					)
					(
						dev-libs/protobuf:5
						dev-python/protobuf:5.29[python_targets_${impl}(-)]
					)
				)
			)
		"
	done
}
CHECKPOINT_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=sci-libs/tensorstore-0.1.35[${PYTHON_USEDEP}]
			<sci-libs/tensorstore-0.1.38[${PYTHON_USEDEP}]
		)
		dev-python/absl-py[${PYTHON_USEDEP}]
		dev-python/msgpack[${PYTHON_USEDEP}]
		dev-python/nest-asyncio[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	')
	>=dev-python/jax-0.4.9[${PYTHON_SINGLE_USEDEP}]
	dev-python/etils[${PYTHON_SINGLE_USEDEP},epath,epy]
	dev-python/jaxlib[${PYTHON_SINGLE_USEDEP}]
	dev-python/jaxtyping[${PYTHON_SINGLE_USEDEP}]
	|| (
		$(gen_protobuf_checkpoint_rdepend)
	)
	dev-libs/protobuf:=
	dev-python/protobuf:=
"
ORBAX_EXPORT_RDEPEND="
	$(python_gen_cond_dep '
		dev-python/absl-py[${PYTHON_USEDEP}]
		dev-python/dataclasses-json[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
	')
	dev-python/etils[${PYTHON_SINGLE_USEDEP}]
	dev-python/jax[${PYTHON_SINGLE_USEDEP}]
	dev-python/jaxlib[${PYTHON_SINGLE_USEDEP}]
	dev-python/jaxtyping[${PYTHON_SINGLE_USEDEP}]
"
RDEPEND+="
	${CHECKPOINT_RDEPEND}
"
DEPEND+="
	${RDEPEND}
"
CHECKPOINT_TEST_BDEPEND="
	$(python_gen_cond_dep '
		dev-libs/pytest[${PYTHON_USEDEP}]
		dev-libs/pytest-xdist[${PYTHON_USEDEP}]
	')
	dev-python/flax[${PYTHON_SINGLE_USEDEP}]
"
ORBAX_EXPORT_TEST_BDEPEND="
	$(python_gen_cond_dep '
		dev-libs/pytest[${PYTHON_USEDEP}]
		dev-libs/pytest-xdist[${PYTHON_USEDEP}]
	')
	=sci-ml/tensorflow-9999[${PYTHON_SINGLE_USEDEP}]
"
BDEPEND+="
	$(python_gen_cond_dep '
		(
			>=dev-python/flit-core-3.5[${PYTHON_USEDEP}]
			<dev-python/flit-core-4[${PYTHON_USEDEP}]
		)
	')
	test? (
		${CHECKPOINT_TEST_BDEPEND}
	)
"
# Avoid circular depends with tensorflow \
PDEPEND+="
	$(python_gen_cond_dep '
		tensorflow? (
			sci-ml/tensorflow[${PYTHON_SINGLE_USEDEP}]
		)
	')
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

python_configure() {
	if has_version "dev-libs/protobuf:5/5.29" ; then
	# Align with TensorFlow 2.20
		ABSEIL_CPP_SLOT="20240722"
		PROTOBUF_CPP_SLOT="5"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_5[@]}" )
	elif has_version "dev-libs/protobuf:4/4.25" ; then
	# Align with TensorFlow 2.17
		ABSEIL_CPP_SLOT="20220623"
		PROTOBUF_CPP_SLOT="3"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_3[@]}" )
	else
	# Align with TensorFlow 2.20
		ABSEIL_CPP_SLOT="20240722"
		PROTOBUF_CPP_SLOT="5"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_5[@]}" )
	fi
	abseil-cpp_python_configure
	protobuf_python_configure
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
