# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=20

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX20[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX20[@]/llvm_slot_}"
)

inherit check-compiler-switch cmake flag-o-matic git-r3 libcxx-slot libstdcxx-slot multilib-minimal toolchain-funcs

if [[ ${PV} =~ "9999" ]] ; then
	FALLBACK_COMMIT="9f4ce64458dfae86e1239c525ddc219c4e9e06f1"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/recastnavigation/recastnavigation.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	S="${WORKDIR}/${P}"
else
	KEYWORDS="~amd64 ~arm64"
	S="${WORKDIR}/${P}"
	SRC_URI="
https://github.com/recastnavigation/recastnavigation/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Navigation-mesh Toolset for Games"
HOMEPAGE="https://github.com/memononen/recastnavigation"
LICENSE="ZLIB"
SOVER="1"
SLOT="0/${SOVER}"
# Upstream has test ON by default.
IUSE+="
debug +demo -dt-polyref64 -dt-virtual-queryfilter +examples static-libs test
wayland X
ebuild_revision_6
"
REQUIRED_USE+="
	demo? (
		|| (
			wayland
			X
		)
	)
"
RDEPEND+="
	virtual/libc:*
	demo? (
		>=media-libs/libsdl2-2.0.20[${MULTILIB_USEDEP},haptic,opengl,wayland?,X?]
		virtual/opengl:*[${MULTILIB_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-build/cmake-3.22.1
"

pkg_setup() {
	check-compiler-switch_start
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	export CPP=$(tc-getCPP)
	strip-unsupported-flags

	libcxx-slot_verify
	libstdcxx-slot_verify

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi
}

get_lib_type() {
	use static-libs && echo "static"
	echo "shared"
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			export EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
	local actual_sover=$(grep -r -e "SOVERSION" "${S}/CMakeLists.txt" | cut -f 2 -d " " | sed -e "s|)||g")
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Update SOVER in ebuild"
eerror "Actual SOVER:  ${actual_sover}"
eerror "Expected SOVER:  ${expected_sover}"
		die
	fi
}

src_prepare() {
	export CMAKE_USE_DIR="${S}"
	cd "${CMAKE_USE_DIR}" || die
	cmake_src_prepare
	prepare_abi() {
		local lib_type
		for lib_type in $(get_lib_type) ; do
			cp -a \
				"${S}" \
				"${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}" \
				|| die
		done
	}
	multilib_foreach_abi prepare_abi
}

src_configure() {
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	configure_abi() {
		local lib_type
		for lib_type in $(get_lib_type) ; do
			CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${CMAKE_USE_DIR}" || die
			local mycmakeargs=(
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
				:
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
	docinto "licenses"
	dodoc "License.txt"
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
