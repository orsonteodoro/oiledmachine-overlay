# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Breaks during linking dev-util/hyprwayland-scanner
#CFLAGS_HARDENED_SANITIZERS="address hwaddress undefined"
#CFLAGS_HARDENED_SANITIZERS_COMPAT="clang gcc"
CFLAGS_HARDENED_TOLERANCE="4.0"
CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"

CXX_STANDARD=17

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

inherit cflags-hardened check-compiler-switch cmake libcxx-slot libstdcxx-slot

if [[ ${PV} == *9999 ]] ; then
	FALLBACK_COMMIT="27b68329de32cf9c601ca8eb6c588fd639960c40"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/zeux/pugixml.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	# Use non-release tarball for tests
	# TODO: ask upstream to include tests in release tarballs?
	SRC_URI="https://github.com/zeux/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

DESCRIPTION="Light-weight, simple, and fast XML parser for C++ with XPath support"
HOMEPAGE="https://pugixml.org/ https://github.com/zeux/pugixml"

LICENSE="MIT"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

pkg_setup() {
	check-compiler-switch_start
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	if [[ ${PV} == *9999 ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_configure() {
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	cflags-hardened_append

	local mycmakeargs=(
		-DPUGIXML_BUILD_TESTS=$(usex test ON OFF)
	)
	cmake_src_configure
}

src_install() {
	cmake-multilib_src_install
	dodoc "LICENSE.md"
	use doc && einstalldocs
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED (1.15, 20250503)
# test-suite gcc:  passed with asan, ubsan
# test-suite clang:  passed with asan, ubsan
