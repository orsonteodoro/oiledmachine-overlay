# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..11} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/diegoferigo/cmake-build-extension.git"
	FALLBACK_COMMIT="7a5deb54ee165aa157e33937420c933d0c2c41c6" # Sep 9, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/diegoferigo/cmake-build-extension/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Setuptools extension to build and package CMake projects"
HOMEPAGE="
	https://github.com/diegoferigo/cmake-build-extension
	https://pypi.org/project/cmake-build-extension
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
RDEPEND+="
	dev-build/cmake
	dev-build/ninja
	dev-python/GitPython[${PYTHON_USEDEP}]
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-45[${PYTHON_USEDEP}]
	>=dev-python/setuptools-scm-6.0[${PYTHON_USEDEP}]
	dev-vcs/git
	dev-python/wheel[${PYTHON_USEDEP}]
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
		gen_git_tag "${S}" "${PV}"
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
