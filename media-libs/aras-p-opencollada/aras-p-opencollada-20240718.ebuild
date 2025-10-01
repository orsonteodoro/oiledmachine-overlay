# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake edos2unix flag-o-matic

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
IUSE="static-libs"
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
