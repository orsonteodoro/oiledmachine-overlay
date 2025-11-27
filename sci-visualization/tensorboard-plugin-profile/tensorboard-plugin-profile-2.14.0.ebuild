# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-/_}"

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{11..12} )

inherit abseil-cpp distutils-r1 protobuf pypi

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/tensorflow/profiler.git"
	FALLBACK_COMMIT="c9c8103cb1471fde513450567a29cee83c16bc82" # Oct 3, 2023
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	EGIT_COMMIT="c9c8103cb1471fde513450567a29cee83c16bc82"
	S="${WORKDIR}/profiler-${EGIT_COMMIT}"
	SRC_URI="
https://github.com/tensorflow/profiler/archive/${EGIT_COMMIT}.tar.gz
	-> tensorflow-profiler-${EGIT_COMMIT:0:7}.tar.gz
	"
fi

DESCRIPTION="Clean up the public namespace of your package!"
HOMEPAGE="
	https://github.com/tensorflow/profiler
	https://pypi.org/project/tensorboard-plugin-profile
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
gen_protobuf_rdepend() {
	local impl
	for impl in "${PYTHON_COMPAT[@]}" ; do
		echo "
			python_single_target_${impl}? (
				|| (
					dev-python/protobuf:4.21[python_targets_${impl}(-)]
					dev-python/protobuf:5.29[python_targets_${impl}(-)]
				)
			)
		"
	done
}
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/absl-py-0.4[${PYTHON_USEDEP}]
		>=dev-python/gviz-api-1.9.0[${PYTHON_USEDEP}]
		>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
		>=dev-python/werkzeug-0.11.15[${PYTHON_USEDEP}]
	')
	|| (
		$(gen_protobuf_rdepend)
	)
	dev-python/protobuf:=
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/setuptools-41.0.0[${PYTHON_USEDEP}]
	')
"
DOCS=( "${S}/README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "__version__ = \"2.14.0\"" "${S}/plugin/tensorboard_plugin_profile/version.py" \
			|| die "QA:  Bump version"
	else
		unpack ${A}
	fi
}

src_prepare() {
	cd "${S}/plugin" || die
	distutils-r1_src_prepare
}

python_configure() {
	if has_version "dev-libs/protobuf:5/5.29" ; then
	# Align with TensorFlow 2.20
		ABSEIL_CPP_SLOT="20240722"
		PROTOBUF_CPP_SLOT="5"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_5[@]}" )
	elif has_version "dev-libs/protobuf:3/3.21" ; then
	# Align with TensorFlow 2.17
		ABSEIL_CPP_SLOT="20220623"
		PROTOBUF_CPP_SLOT="4"
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

src_compile() {
	cd "${S}/plugin" || die
	distutils-r1_src_compile
}

src_install() {
	cd "${S}/plugin" || die
	distutils-r1_src_install
	cd "${S}" || die
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
