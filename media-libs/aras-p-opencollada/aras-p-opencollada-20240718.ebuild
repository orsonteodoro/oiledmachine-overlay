# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="untrusted-data"
GCC_COMPAT=(
	"gcc_slot_14_3" # CY2026 is GCC 14.2; CUDA-12.9, CUDA-12.8
	"gcc_slot_13_4" # CUDA-12.6, CUDA-12.5, CUDA-12.4, CUDA-12.3
	"gcc_slot_11_5" # CY2025 is GCC 11.2.1, CUDA-11.8
)

inherit cflags-hardened cmake edos2unix flag-o-matic libstdcxx-slot

EGIT_COMMIT="dfc341ab0b3b23ee307ab8660c0213e64da1eac6"
S="${WORKDIR}/OpenCOLLADA-${EGIT_COMMIT}"
SRC_URI="
https://github.com/aras-p/OpenCOLLADA/archive/${EGIT_COMMIT}.tar.gz
	-> ${PN}-${EGIT_COMMIT:0:7}.tar.gz
"

DESCRIPTION="OpenCOLLADA Cleanup Fork"
HOMEPAGE="https://github.com/aras-p/OpenCOLLADA"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="
static-libs
ebuild_revision_1
"
RDEPEND="
	dev-libs/libpcre:=
	dev-libs/libxml2:=
	dev-libs/zziplib
	media-libs/lib3ds
	sys-libs/zlib
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}/opencollada-1.6.68-fix-null-conversion.patch"
	"${FILESDIR}/opencollada-1.6.68-cmake-fixes.patch"
#	"${FILESDIR}/opencollada-1.6.63-pcre-fix.patch"
#	"${FILESDIR}/opencollada-1.6.68-gcc13.patch"
#	"${FILESDIR}/opencollada-1.6.68-werror.patch"
	"${FILESDIR}/opencollada-1.6.68-cmake4.patch"
#	"${FILESDIR}/opencollada-1.6.68-unbundle-zlib.patch"
)

pkg_setup() {
	libstdcxx-slot_verify
}

src_prepare() {
	edos2unix "CMakeLists.txt"

	cmake_src_prepare

	# Remove bundled depends that have portage equivalents
	rm -rv "Externals/LibXML" || die

	# Remove unused build systems
	find "${S}" -name "SConscript" -delete || die
}

src_configure() {
	# Bug 619670
	append-cxxflags -std=c++14
	cflags-hardened_append

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="/usr/lib/aras-p-opencollada"
		-DUSE_LIBXML=ON
		-DUSE_SHARED=ON
		-DUSE_STATIC=$(usex static-libs)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
}
