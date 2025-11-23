# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{8..11} )

inherit cython distutils-r1 optfeature

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/KhronosGroup/NNEF-Tools.git"
	FALLBACK_COMMIT="c1aac758ad155d8c132e9b5166d9490b73f70811"
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}/nnef-pyproject"
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/NNEF-Tools-nnef-v${PV}/nnef-pyproject"
	SRC_URI="
https://github.com/KhronosGroup/NNEF-Tools/archive/refs/tags/nnef-v${PV}.tar.gz
	"
fi

DESCRIPTION="A parser to add support for neural network NNEF files"
HOMEPAGE="https://github.com/KhronosGroup/NNEF-Tools/tree/main/nnef-pyproject"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
ebuild_revision_3
"
REQUIRED_USE="
"
RDEPEND+="
	dev-python/numpy[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/cython:=
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
"
DOCS=( "README.md" )
PATCHES=(
)

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_prepare() {
	default
	pushd "${S}/.." >/dev/null 2>&1 || die
		eapply "${FILESDIR}/${PN}-1.0.7-change-install-paths.patch"
	popd >/dev/null 2>&1 || die
}

build_libnnef() {
	pushd "${S}/nnef/cpp" >/dev/null 2>&1 || die
		local mycmakeargs=(
			-DBUILD_SHARED_LIBS=ON
			-DCMAKE_INSTALL_LIBDIR="$(get_libdir)"
			-DCMAKE_INSTALL_PREFIX="/usr"
		)
		mkdir -p "build" || die
einfo "Building libnnef"
		cd "build" || die
		cmake ${mycmakeargs[@]} ".." || die
		emake || die
	popd >/dev/null 2>&1 || die
}

python_configure() {
	local cython_slot=$(best_version "dev-python/cython" | sed -e "s|dev-python/cython-||")
	cython_slot=$(ver_cut "1-2" "${cython_slot}")
	export CYTHON_SLOT="${cython_slot}"
	cython_python_configure
}

python_compile() {
	build_libnnef
	distutils-r1_python_compile
}

python_install() {
einfo "Installing libnnef"
	pushd "${S}/nnef/cpp/build" >/dev/null 2>&1 || die
		emake DESTDIR="${D}" install || die
	popd >/dev/null 2>&1 || die
	distutils-r1_python_install
}

pkg_postinst() {
	optfeature "prebuilt models" "sci-ml/nnef-models"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
