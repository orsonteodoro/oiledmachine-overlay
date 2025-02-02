# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/milvus-io/milvus-model.git"
	FALLBACK_COMMIT="e4726cdb9aebbcc080f38f4f568dc011ba1a1c49" # Jan 23, 2025
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/milvus-io/milvus-model/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A library provides the integration with common embedding and reranker models for Milvus, a high performance open-source vector database built for AI applications"
HOMEPAGE="
	https://github.com/milvus-io/milvus-model
	https://pypi.org/project/milvus-model
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/scipy-1.10.0[${PYTHON_USEDEP}]
		dev-python/onnxruntime[${PYTHON_USEDEP}]
		dev-python/protobuf[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
	')
	>=sci-libs/transformers-4.36.0[${PYTHON_SINGLE_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/setuptools-75[${PYTHON_USEDEP}]
		>=dev-python/setuptools-scm-8.0[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
		dev-python/gitpython[${PYTHON_USEDEP}]
	')
"
DOCS=( "README.md" )

gen_git_tag() {
	local path="${1}"
	local tag_name="${2}"
einfo "Generating tag start for ${path}"
	pushd "${path}" >/dev/null 2>&1 || die
		git init || die
		git config user.email "name@example.com" || die
		git config user.name "John Doe" || die
		touch dummy || die
		git add dummy || die
		#git add -f * || die
		git commit -m "Dummy" || die
		git tag ${tag_name} || die
	popd >/dev/null 2>&1 || die
einfo "Generating tag done"
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
		gen_git_tag "${S}" "v${PV}"
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
