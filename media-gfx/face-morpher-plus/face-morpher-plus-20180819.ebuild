# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="face_morpher_plus"

DISTUTILS_SINGLE_IMPL=1 # Wrapper
FALLBACK_COMMIT="27e6b07fb22732d99a7126d9df86c4e451e6c1c4" # Aug 19, 2018
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/HighCWu/face_morpher_plus.git"
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
#	KEYWORDS="~amd64" # Broken
	S="${WORKDIR}/${MY_PN}-${FALLBACK_COMMIT}"
	SRC_URI="
https://github.com/HighCWu/face_morpher_plus/archive/${FALLBACK_COMMIT}.tar.gz
	-> ${P}-${FALLBACK_COMMIT:0:7}.tar.gz
	"
fi

DESCRIPTION="Face morpher plus based on facemorpher"
HOMEPAGE="
	https://github.com/HighCWu/face_morpher_plus
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
ffmpeg gtk3 gstreamer +jpeg +png qt5 qt6 wayland
ebuild_revision_3
"
REQUIRED_USE="
	^^ (
		gtk3
		qt5
		qt6
		wayland
	)
	|| (
		ffmpeg
		gstreamer
	)
	|| (
		jpeg
		png
	)
"
RDEPEND+="
	$(python_gen_cond_dep '
		dev-python/docopt[${PYTHON_USEDEP}]
		dev-python/facemorpher[${PYTHON_USEDEP},ffmpeg?,gstreamer?,stasm]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/stasm[${PYTHON_USEDEP}]
		sci-libs/dlib[${PYTHON_USEDEP},jpeg?,png?]
	')
	>=media-libs/opencv-3.4.1[${PYTHON_SINGLE_USEDEP},ffmpeg?,gstreamer?,gtk3?,jpeg?,png?,python,qt5?,qt6?,wayland?]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "README.md" )
PATCHES=(
	"${FILESDIR}/${PN}-27e6b07-type-fixes.patch"
	"${FILESDIR}/${PN}-27e6b07-add-assert-rotated-face-points.patch"
	"${FILESDIR}/${PN}-27e6b07-face-point-correspondance-fix.patch"
	"${FILESDIR}/${PN}-27e6b07-type-fix.patch"
	"${FILESDIR}/${PN}-27e6b07-writable-array-fix.patch"
	"${FILESDIR}/${PN}-27e6b07-cwd-changes.patch"
)

pkg_setup() {
	python-single-r1_pkg_setup
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_compile() {
	:
}

src_install() {
	docinto "licenses"
	dodoc "LICENSE"
	python_moduleinto "${MY_PN}"
	python_domodule "plotter.py" "process.py"
	dodir /usr/bin
cat <<EOF > "${ED}/usr/bin/${PN}"
#!/bin/bash
IMG_CWD=\$(realpath \$(pwd))
cd "/usr/lib/${EPYTHON}/site-packages/${PN//-/_}"
${EPYTHON} process.py "\$@"
EOF
	fperms 0755 "/usr/bin/${PN}"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASS (27e6b07, 20241221)
# Show plotter - pass
# Result write - pass
# Texture blending quality - fail
# Local result matches upstream result - pass
