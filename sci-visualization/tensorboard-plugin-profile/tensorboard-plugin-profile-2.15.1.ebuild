# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-/_}"

inherit protobuf-ver

DISTUTILS_USE_PEP517="setuptools"
PROTOBUF_SLOTS=(
	${PROTOBUF_3_SLOTS[@]}
	${PROTOBUF_4_SLOTS[@]}
)
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/tensorflow/profiler.git"
	FALLBACK_COMMIT="f3deeb88dcdab123ebaf45712fb3952bbb874be6" # Feb 7, 2024
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	EGIT_COMMIT="f3deeb88dcdab123ebaf45712fb3952bbb874be6"
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
	local s
	for s in ${PROTOBUF_SLOTS[@]} ; do
		echo "
			dev-python/protobuf:0/${s}[${PYTHON_USEDEP}]
		"
	done
}
RDEPEND+="
	>=dev-python/absl-py-0.4[${PYTHON_USEDEP}]
	>=dev-python/gviz-api-1.9.0[${PYTHON_USEDEP}]
	|| (
		$(gen_protobuf_rdepend)
	)
	dev-python/protobuf:=
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/werkzeug-0.11.15[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-41.0.0[${PYTHON_USEDEP}]
"
DOCS=( "${S}/README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "__version__ = \"2.15.1\"" "${S}/plugin/tensorboard_plugin_profile/version.py" \
			|| die "QA:  Bump version"
	else
		unpack ${A}
	fi
}

src_prepare() {
	cd "${S}/plugin" || die
	distutils-r1_src_prepare
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
