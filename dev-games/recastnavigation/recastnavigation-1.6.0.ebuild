# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic git-r3 multilib-minimal toolchain-funcs

EXPECTED="\
a8713189737e6d885b7e9badbd494d495a460cd47b0eaac9424dbc72d133e49a\
fc8fd1891a1255b4347c0fbabbd5fc841dc0d3c622137e494a454a312ba5e483\
"

DESCRIPTION="Navigation-mesh Toolset for Games"
LICENSE="ZLIB"
HOMEPAGE="https://github.com/memononen/recastnavigation"
SLOT="0/$(ver_cut 1-2 ${PV})"
# Upstream has test ON by default.
IUSE+="
debug +demo -dt-polyref64 -dt-virtual-queryfilter +examples static-libs test
wayland X
"
REQUIRED_USE+="
	demo? (
		|| (
			wayland
			X
		)
	)
"
# CI uses U22.04.2
CDEPEND+="
	>=sys-devel/gcc-11.2.0
"
RDEPEND+="
	virtual/libc
	demo? (
		>=media-libs/libsdl2-2.0.20[${MULTILIB_USEDEP},haptic,opengl,wayland?,X?]
		virtual/opengl[${MULTILIB_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
	|| (
		>=sys-devel/gcc-11.2.0
		>=sys-devel/clang-14.0
	)
"
BDEPEND+="
	>=dev-util/cmake-3.22.1
"
if [[ ${PV} =~ 99999999 ]] ; then
	SRC_URI=""
	IUSE+=" fallback-commit"
else
	SRC_URI="
https://github.com/recastnavigation/recastnavigation/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
fi
S="${WORKDIR}/${P}"

pkg_setup() {
	export CC=$(tc-getCC)
	if [[ -z "${CC}" ]] ; then
		export CC="${CHOST}-gcc"
		strip-unsupported-flags
	fi
	if tc-is-gcc ; then
		local gcc_pv=$(gcc-fullversion)
		if ver_test ${gcc_pv} -lt "8.0" ; then
			die "You need at least gcc 8.0 to compile."
		fi
	fi
}

get_lib_type() {
	use static-libs && echo "static"
	echo "shared"
}

_unpack_live() {
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/recastnavigation/recastnavigation.git"
	if use fallback-commit ; then
		export EGIT_COMMIT="b51925bb8720e78a65c77339a532459b96ddfc7e" # Dec 22, 2022
	fi
	git-r3_fetch
	git-r3_checkout
	local actual=$(cat $(find "${S}" -name "CMakeLists.txt" -o -name "*.cmake") \
		| sha512sum \
		| cut -f 1 -d " ")
	if [[ "${actual}" != "${EXPECTED}" ]] ; then
eerror
eerror "Actual build files fingerprint:\t${actual}"
eerror "Expected build files fingerprint:\t${EXPECTED}"
eerror
eerror "Detected a change in build files that is indicative of a new option,"
eerror "*DEPENDs, IUSE, KEYWORDS."
eerror
eerror "Notify the ebuild maintainer to update this ebuild."
eerror
		die
	fi
}

src_unpack() {
	if [[ ${PV} =~ 99999999 ]] ; then
		_unpack_live
	else
		unpack ${A}
	fi
}

src_prepare() {
	export CMAKE_USE_DIR="${S}"
	cd "${CMAKE_USE_DIR}" || die
	cmake_src_prepare
	prepare_abi() {
		local lib_type
		for lib_type in $(get_lib_type) ; do
			cp -a "${S}" "${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}" || die
		done
	}
	multilib_foreach_abi prepare_abi
}



src_configure() {
	configure_abi() {
		local lib_type
		for lib_type in $(get_lib_type) ; do
			CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${CMAKE_USE_DIR}" || die
			mycmakeargs=(
				-DRECASTNAVIGATION_DEMO=$(usex demo)
				-DRECASTNAVIGATION_DT_POLYREF64=$(usex dt-polyref64)
				-DRECASTNAVIGATION_DT_VIRTUAL_QUERYFILTER=$(usex dt-virtual-queryfilter)
				-DRECASTNAVIGATION_EXAMPLES=$(usex examples)
				-DRECASTNAVIGATION_TESTS=$(usex test)
			)
			if [[ "${lib_type}" == "static" ]] ; then
				local libs=(DetourTileCache Detour DetourCrowd DebugUtils Recast)
				for lib in ${libs[@]} ; do
					sed -i -e "s|add_library(${lib} |add_library(${lib} STATIC |g" \
						"${CMAKE_USE_DIR}/${lib}/CMakeLists.txt" || die
				done
			else
				:;
			fi
			cmake_src_configure
		done
	}
	multilib_foreach_abi configure_abi
}

src_compile() {
	compile_abi() {
		local lib_type
		for lib_type in $(get_lib_type) ; do
			CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${BUILD_DIR}" || die
			cmake_src_compile
		done
	}
	multilib_foreach_abi compile_abi
}

src_test() {
	test_abi() {
		local lib_type
		for lib_type in $(get_lib_type) ; do
			CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${BUILD_DIR}" || die
			cmake_src_test
		done
	}
	multilib_foreach_abi test_abi
}

src_install() {
	install_abi() {
		local lib_type
		for lib_type in $(get_lib_type) ; do
			CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${BUILD_DIR}" || die
			cmake_src_install
		done
		multilib_check_headers
	}
	multilib_foreach_abi install_abi
	multilib_src_install_all
}

multilib_src_install_all() {
	cd "${S}" || die
	docinto licenses
	dodoc License.txt
	if use demo ; then
einfo
einfo "To run the demo:"
einfo
einfo "  cd /usr/bin && RecastDemo"
einfo
	fi
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multiabi, static-libs

# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.6.0 (20230601)
# USE="X demo examples static-libs test wayland (-debug) -dt-polyref64
# -dt-virtual-queryfilter"
# demo:  passed (both wayland and X), but crashes when build not clicked first
# test suite:  passed
# 32-bit and 64-bit test suite:
# 100% tests passed, 0 tests failed out of 1
