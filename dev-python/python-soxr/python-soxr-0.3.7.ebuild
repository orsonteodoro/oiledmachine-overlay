# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="Python-SoXR"

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit cython distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}-${PV}"
	EGIT_REPO_URI="https://github.com/dofuuz/python-soxr.git"
	FALLBACK_COMMIT="4a8f74cb950b99bb108485c6f08adf1eb6dc4fa2" # Feb 27, 2023
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm64"
	DOFUUZ_SOXR_COMMIT="acc0dacd79bf48229d33f6efa209e4f9d8fbb41c"
	SRC_URI="
	!system-soxr? (
https://github.com/dofuuz/soxr/archive/${DOFUUZ_SOXR_COMMIT}.tar.gz
	-> dofuzz-soxr-${DOFUUZ_SOXR_COMMIT:0:7}.tar.gz
	)
https://github.com/dofuuz/python-soxr/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi
S="${WORKDIR}/${PN}-${PV}"

DESCRIPTION="Fast and high quality sample-rate conversion library for Python"
HOMEPAGE="
	https://github.com/dofuuz/python-soxr
	https://pypi.org/project/soxr/
"
LICENSE="
	LGPL-2.1+
"
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
doc system-soxr test
ebuild_revision_1
"
RDEPEND+="
	dev-python/numpy[${PYTHON_USEDEP}]
	system-soxr? (
		>=media-libs/soxr-0.1.3
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/cython-3.0_alpha7[${PYTHON_USEDEP}]
	=dev-python/cython-3*[${PYTHON_USEDEP}]
	dev-python/cython:=
	>=dev-python/setuptools-42[${PYTHON_USEDEP}]
	>=dev-python/setuptools-scm-6.2[${PYTHON_USEDEP}]
	dev-python/oldest-supported-numpy[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	dev-vcs/git
	doc? (
		dev-python/linkify-it-py[${PYTHON_USEDEP}]
		dev-python/myst-parser[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-book-theme[${PYTHON_USEDEP}]
	)
	system-soxr? (
		>=dev-build/cmake-3.1
	)
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" )
PATCHES=(
	"${FILESDIR}/${PN}-0.3.7-use-system-soxr-from-envvar.patch"
)

# For setuptools-scm
init_repo() {
	cd "${S}" || die
	git init || die
	touch dummy || die
	git config user.email "name@example.com" || die
	git config user.name "John Doe" || die
	git add dummy || die
	git commit -m "Dummy" || die
	git tag v${PV} || die
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "__version__ = '${PV}'" "${S}/setup.py" \
			|| die "QA:  Bump version"
	else
		unpack ${A}
		if ! use system-soxr ; then
			rm -rf "${S}/libsoxr"
			mv \
				"${WORKDIR}/soxr-${DOFUUZ_SOXR_COMMIT}" \
				"${S}/libsoxr" \
				|| die
		fi
		init_repo
	fi
}

python_configure() {
	cython_set_cython_slot "3"
	cython_python_configure
	export USE_SYSTEM_LIBSOXR=$(usex system-soxr "1" "0")
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "COPYING.LGPL"
	dodoc "LICENSE.txt"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
