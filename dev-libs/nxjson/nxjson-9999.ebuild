# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EXPECTED_FINGERPRINT="\
cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce\
47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e\
"

inherit cmake git-r3 multilib-minimal toolchain-funcs

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/yarosla/nxjson.git"
	FALLBACK_COMMIT="d2c6fba9d5b0d445722105dd2a64062c1309ac86"
	S="${WORKDIR}/${P}"
	IUSE+=" fallback-commit"
else
	SRC_URI=""
	S="${WORKDIR}/${P}"
	die "FIXME"
fi

DESCRIPTION="Very small JSON parser written in C."
LICENSE="LGPL-3+"
HOMEPAGE="https://github.com/yarosla/nxjson"
# Live ebuilds do not get keyworded
SLOT="0/${EXPECTED_FINGERPRINT:0:7}"
IUSE="debug static-libs test"
RDEPEND+="
	virtual/libc
"
BDEPEND="
	>=dev-build/cmake-2.8
	|| (
		sys-devel/gcc
		sys-devel/clang
	)
"
PATCHES=(
	"${FILESDIR}/nxjson-9999_p20200927-libdir-path.patch"
)

get_lib_types() {
	use static-libs && echo "static"
	echo "shared"
}

live_unpack() {
	use fallback-commit && export EGIT_COMMIT="${FALLBACK_COMMIT}"
	git-r3_fetch
	git-r3_checkout
	local actual_fingerprint=$(cat \
		$(find "${S}" -name "CMakeLists.txt" -o -name "*.cmake" -o "nxjson.h") \
		| sha512sum \
		| cut -f 1 -d " ")
	if [[ "${actual_fingerprint}" != "${EXPECTED_FINGERPRINT}" ]] ; then
eerror
eerror "Actual build file(s) fingerprint:  ${actual_fingerprint}"
eerror "Expected build file(s) fingerprint:  ${EXPECTED_FINGERPRINT}"
eerror
eerror "A change in build files is detected.  This is indicative of a *DEPENDs"
eerror "IUSE, KEYWORDs, SLOT change."
eerror
eerror "Notify the ebuild maintainer about this change."
eerror
		die
	fi
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		live_unpack
	else
		unpack ${A}
	fi
}

src_prepare() {
	export CMAKE_USE_DIR="${S}"
	cd "${CMAKE_USE_DIR}" || die
	cmake_src_prepare
	export CMAKE_BUILD_TYPE=$(usex debug "Debug" "Release")
	prepare_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			cp -a "${S}" "${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}" || die
			export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			cd "${CMAKE_USE_DIR}" || die
			if [[ "${lib_type}" == "shared" ]] ; then
				sed -i -e "s|STATIC|SHARED|" CMakeLists.txt || die
			fi
		done
	}
	multilib_foreach_abi prepare_abi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
	)
	configure_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			cp -a "${S}-${MULTILIB_ABI_FLAG}.${ABI}"
			export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${CMAKE_USE_DIR}" || die
			cmake_src_configure
		done
	}
	multilib_foreach_abi configure_abi
}

src_compile() {
	compile_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			cp -a "${S}-${MULTILIB_ABI_FLAG}.${ABI}"
			export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${BUILD_DIR}" || die
			cmake_src_compile
		done
	}
	multilib_foreach_abi compile_abi
}

src_test() {
	test_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			cp -a "${S}-${MULTILIB_ABI_FLAG}.${ABI}"
			export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${BUILD_DIR}" || die
			if use test ; then
				nxjson || die
			fi
		done
	}
	multilib_foreach_abi test_abi
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")
	install_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			cp -a "${S}-${MULTILIB_ABI_FLAG}.${ABI}"
			export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${BUILD_DIR}" || die
			cmake_src_install
		done
		multilib_check_headers
	}
	multilib_foreach_abi install_abi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
