# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit check-compiler-switch cmake flag-o-matic

if [[ ${PV} == *"9999" ]] ; then
	EGIT_REPO_URI="https://github.com/dyninst/dyninst/"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${P}"
	SRC_URI="
https://github.com/dyninst/dyninst/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="DyninstAPI: Tools for binary instrumentation, analysis, and modification."
HOMEPAGE="https://github.com/dyninst/dyninst"
LICENSE="
	custom
	LGPL-2.1+
"
# custom LGPL-2.1+ - dwarf/src/dwarfResult.C
SLOT="0"
IUSE="
-debuginfod +openmp -valgrind
ebuild_revision_10
"
REQUIRED_USE="
"
RDEPEND="
	>=dev-libs/boost-1.71.0
	>=dev-libs/elfutils-0.186
	=dev-cpp/tbb-2019*
	dev-cpp/tbb:=
	sys-devel/gcc[openmp?]
	debuginfod? (
		dev-libs/elfutils[debuginfod(-)]
	)
	valgrind? (
		dev-debug/valgrind
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/cmake-3.14
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}/${PN}-13.0.0-disable-exact-version-elfutils.patch"
	"${FILESDIR}/${PN}-13.0.0-use-system-elfutils.patch"
	"${FILESDIR}/${PN}-13.0.0-cache-install-paths.patch"
)
DOCS=( "CHANGELOG.md" )

pkg_setup() {
	check-compiler-switch_start
}

src_prepare() {
	cmake_src_prepare
	sed -i -e "/set(DYNINST_INSTALL_LIBDIR/d" "cmake/DyninstLibrarySettings.cmake" || die
}

src_configure() {
	# It is forced so we can use OpenMP without adding more flags.
	export CC="${CHOST}-gcc"
	export CXX="${CHOST}-g++"
	export CPP="${CC} -E"
	strip-unsupported-flags

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	strip-flags
	filter-flags '-O0' '-pipe'

	local mycmakeargs=(
		-DADD_VALGRIND_ANNOTATIONS=$(usex valgrind)
		-DCMAKE_INSTALL_PREFIX="/usr"
		-DDYNINST_INSTALL_LIBDIR="$(get_libdir)"
		-DENABLE_DEBUGINFOD=$(usex debuginfod)
		-DUSE_OpenMP=$(usex openmp)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	docinto "licenses"
	dodoc "COPYRIGHT"
	dodoc "LICENSE.md"
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
