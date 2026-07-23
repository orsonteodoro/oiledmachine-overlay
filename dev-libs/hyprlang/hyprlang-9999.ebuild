# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CXX_STANDARD=23

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX23[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX23[@]/llvm_slot_}"
)

CHKL_TIMESTAMPS=(
	"gui-libs/hyprutils-9999"
)

inherit cflags-hardened chkl cmake libcxx-slot libstdcxx-slot secure-version toolchain-funcs

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="090117506ddc3d7f26e650ff344d378c2ec329cc"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/hyprwm/hyprlang.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="https://github.com/hyprwm/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
fi

DESCRIPTION="Official implementation library for the hypr config language"
HOMEPAGE="https://github.com/hyprwm/hyprlang"

LICENSE="LGPL-3"
SOVER="2"
SLOT="0/${SOVER}"
KEYWORDS="~amd64"
IUSE+="
ebuild_revision_2
"
RDEPEND="
	>=gui-libs/hyprutils-${HYPRUTILS_PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/cmake-3.19
	virtual/pkgconfig
"

pkg_setup() {
	[[ "${MERGE_TYPE}" == "binary" ]] && return

	libcxx-slot_verify
	libstdcxx-slot_verify

	tc-check-min_ver gcc 14
	tc-check-min_ver clang 17
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
	local actual_sover=$(grep -E -e "SOVERSION [0-9]+" "${S}/CMakeLists.txt" | grep -E -o -e "[0-9]+")
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Update SOVER in ebuild"
eerror "Actual SOVER:  ${actual_sover}"
eerror "Expected SOVER:  ${expected_sover}"
		die
	fi
}

src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	cmake_src_configure
}
