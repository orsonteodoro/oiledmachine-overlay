# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

CXX_STANDARD=11

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX11[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX11[@]/llvm_slot_}"
)

CHKL_TIMESTAMPS=(
	"dev-libs/libfmt-9999"
)

inherit check-compiler-switch chkl libcxx-slot libstdcxx-slot sandbox-changes secure-version cmake-multilib

if [[ "${PV}" =~ "9999" ]] ; then
	INTERNAL_VERSION="1.17.0"
	SOVER=$(ver_cut "1-2" "${INTERNAL_VERSION}")
	FALLBACK_COMMIT="f5f173a1a57d0e2e0115f2ed71ee7ea316516853"
	EGIT_BRANCH="v1.x"
	EGIT_REPO_URI="https://github.com/gabime/${PN}"
	inherit git-r3
else
	SOVER=$(ver_cut "1-2" "${PV}")
	KEYWORDS="~amd64 ~arm64"
	SRC_URI="
https://github.com/gabime/spdlog/archive/v${PV}.tar.gz -> ${P}.tar.gz
	"
fi

DESCRIPTION="Very fast, header only, C++ logging library"
HOMEPAGE="https://github.com/gabime/spdlog"
LICENSE="MIT"
SLOT="0/${SOVER}"
IUSE="
test
ebuild_revision_3
"
DEPEND="
	>=dev-libs/libfmt-${LIBFMT_PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP}]
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	sys-devel/gcc:=
	>=dev-build/cmake-3.28.3
	>=dev-util/pkgconf-1.8.1[${MULTILIB_USEDEP},pkg-config(+)]
"
PATCHES=(
	"${FILESDIR}/${PN}-force_external_fmt.patch"
)

check_network_sandbox() {
	# We need to download catch2 to make it multilib since the catch ebuild
	# package is unilib.
	sandbox-changes_no_network_sandbox "To download catch2 for running multilib tests"
}

pkg_setup() {
	check-compiler-switch_start
	use test && check_network_sandbox
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
	local pv_major=$(grep -r -e "SPDLOG_VER_MAJOR" "${S}/include/spdlog/version.h" | head -n 1 | cut -f 3 -d " ")
	local pv_minor=$(grep -r -e "SPDLOG_VER_MINOR" "${S}/include/spdlog/version.h" | head -n 1 | cut -f 3 -d " ")
	local actual_sover="${pv_major}.${pv_minor}"
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Update the package version or INTERNAL_VERSION"
eerror "Actual SOVER:  ${actual_sover}"
eerror "Expected SOVER:  ${expected_sover}"
		die
	fi
}

src_prepare() {
	cmake_src_prepare
	rm -r \
		"include/spdlog/fmt/bundled" \
		|| die "Failed to delete bundled libfmt"
	sed -i \
		-e "s|Catch2 3 QUIET|Catch2 3|g" \
		"tests/CMakeLists.txt" \
		|| die
}

src_configure() {
	chkl_check_many_timestamps

	# Reduce chance of build time failure
	export CC="${CHOST}-gcc"
	export CXX="${CHOST}-g++"
	export CPP="${CC} -E"
	strip-unsupported-flags
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	local mycmakeargs=(
		-DSPDLOG_BUILD_BENCH=no
		-DSPDLOG_BUILD_EXAMPLE=no
		-DSPDLOG_BUILD_SHARED=yes
		-DSPDLOG_BUILD_TESTS=$(usex test)
		-DSPDLOG_FMT_EXTERNAL=yes

	# We don't want c++20 yet.  When it is the compiler default for both GCC
	# and Clang, then it is allowed.
		-DSPDLOG_USE_STD_FORMAT=OFF
	)
	cmake-multilib_src_configure
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.12.0 (20230715)
# Notes:  Both 32-bit and 64-bit tested
#     Start 1: spdlog-utests
# 1/1 Test #1: spdlog-utests ....................   Passed    5.08 sec
#
# 100% tests passed, 0 tests failed out of 1
#
# Total Test time (real) =   5.08 sec
