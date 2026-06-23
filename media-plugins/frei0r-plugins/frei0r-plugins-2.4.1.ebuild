# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=17 # Compiler default
DOCS_BUILDER="doxygen"
DOCS_DIR="doc"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

CHKL_TIMESTAMPS=(
	"media-libs/gavl-9999"
	"media-libs/opencv-4.9999"
	"media-libs/opencv-5.9999"
	"x11-libs/cairo-9999"
)

inherit chkl docs libcxx-slot libstdcxx-slot secure-version cmake-multilib

DESCRIPTION="A minimalistic plugin API for video effects"
HOMEPAGE="https://www.dyne.org/software/frei0r/"
SRC_URI="https://github.com/dyne/frei0r/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/frei0r-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="doc +facedetect +scale0tilt"

RDEPEND="
	>=x11-libs/cairo-${CAIRO_PV}:=[${MULTILIB_USEDEP}]
	facedetect? (
		media-libs/opencv:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP},contrib,contribdnn,features2d]
		~media-libs/opencv-${OPENCV4_PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP},contrib,contribdnn,features2d]
		~media-libs/opencv-${OPENCV5_PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP},contrib,contribdnn,features2d]
	)
	scale0tilt? (
		>=media-libs/gavl-${GAVL_PV}:=[${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-text/doxygen[dot]
	)
"

DOCS=( "AUTHORS.md" "README.md" )

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_prepare() {
	cmake_src_prepare

	# https://bugs.gentoo.org/418243
	sed -i \
		-e '/set.*CMAKE_C_FLAGS/s:"): ${CMAKE_C_FLAGS}&:' \
		src/filter/*/CMakeLists.txt || die
}

src_configure() {
	chkl_check_many_timestamps
	local mycmakeargs=(
		-DWITHOUT_OPENCV=$(usex !facedetect)
		-DWITHOUT_GAVL=$(usex !scale0tilt)
	)
	cmake-multilib_src_configure
}

src_compile() {
	cmake-multilib_src_compile
	use doc && docs_compile
}
