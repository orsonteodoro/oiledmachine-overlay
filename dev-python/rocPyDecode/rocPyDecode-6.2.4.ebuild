# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_12" )
LLVM_SLOT=18
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_VERSION="${PV}"

inherit distutils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/ROCm/rocPyDecode.git"
	FALLBACK_COMMIT="ffcfaf1c654b7ef8f88b3661c3511504f1a874f9" # Aug 13, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-rocm-${PV}"
	SRC_URI="
https://github.com/ROCm/rocPyDecode/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="rocPyDecode is a set of Python bindings to rocDecode C++ library which provides full HW acceleration for video decoding on AMD GPUs"
HOMEPAGE="
	https://github.com/ROCm/rocPyDecode
"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
	MIT
"
# all-rights-reserved MIT - src/roc_pybuffer.h
# The distro's MIT license does not contain all rights reserved.
RESTRICT="mirror"
SLOT="${ROCM_SLOT}/${PV}"
IUSE+=" ebuild_revision_1"
RDEPEND+="
	~sci-libs/rocDecode-${PV}:${ROCM_SLOT}
	dev-python/pybind11[${PYTHON_USEDEP}]
	|| (
		>=media-video/ffmpeg-4.2.7:56.58.58
		>=media-video/ffmpeg-4.2.7:0/56.58.58
	)
	media-video/ffmpeg:=
"
DEPEND+="
	${RDEPEND}
	>=dev-libs/dlpack-0.6
"
BDEPEND+="
	>=dev-python/setuptools-42[${PYTHON_USEDEP}]
	dev-build/cmake
	dev-python/wheel[${PYTHON_USEDEP}]
	virtual/pkgconfig
"
DOCS=( "CHANGELOG.md" "README.md" )
PATCHES=(
	"${FILESDIR}/rocPyDecode-6.2.4-ffmpeg-path.patch"
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

python_configure() {
	if has_version "media-video/ffmpeg:56.58.58" ; then
einfo "Detected media-video/ffmpeg:56.58.58 (4.x series)"
		export PKG_CONFIG_PATH="/usr/lib/ffmpeg/56.58.58/$(get_libdir)/pkgconfig:${PKG_CONFIG_PATH}"
		export FFMPEG_INCLUDES_PATH="/usr/lib/ffmpeg/56.58.58/include"
		export FFMPEG_LIBS_PATH="/usr/lib/ffmpeg/56.58.58/$(get_libdir)"
	fi
}

python_compile() {
	distutils-r1_python_compile
}

python_install() {
	distutils-r1_python_install
	dodir "/opt/rocm-${ROCM_VERSION}/lib"
	cp -aT \
		"${ED}/usr/lib/${EPYTHON}" \
		"${ED}/opt/rocm-${ROCM_VERSION}/lib" \
		|| die
	rm -rf "${ED}/usr/lib/${EPYTHON}" || die
	# Dev note:  Use PYTHONPATH
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
