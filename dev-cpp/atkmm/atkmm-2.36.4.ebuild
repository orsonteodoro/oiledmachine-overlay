# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

API_VERSION="2.36"
CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CXX_STANDARD=17
PYTHON_COMPAT=( python3_{10..14} )

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

inherit cflags-hardened gnome.org libcxx-slot libstdcxx-slot meson-multilib secure-version python-any-r1

DESCRIPTION="C++ interface for the ATK library"
HOMEPAGE="https://gtkmm.gnome.org https://gitlab.gnome.org/GNOME/atkmm"

LICENSE="LGPL-2.1+"
RESTRICT="mirror" # Speed up downloads and stop snooping
SLOT="${API_VERSION}"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~sparc x86"
IUSE="gtk-doc"

DEPEND="
	>=dev-cpp/glibmm-2.68.0:2.68[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP},gtk-doc?]
	>=dev-libs/atk-2.33.3[${MULTILIB_USEDEP}]
	>=dev-libs/libsigc++-3:3[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP},gtk-doc?]
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	gtk-doc? (
		>=dev-cpp/mm-common-1.0.4
		>=dev-libs/libxslt-${LIBXSLT_PV}
		app-text/doxygen[dot]
	)
	${PYTHON_DEPS}
"

pkg_setup() {
	python-any-r1_pkg_setup
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
	local actual_subslot=$(grep -E -e "atkmm_api_version" "${S}/meson.build" | head -n 1 | cut -f 2 -d "'")
	local expected_subslot="${API_VERSION}"
	if ver_test "${actual_subslot}" "-ne" "${expected_subslot}" ; then
eerror "QA:  Update API_VERSION"
eerror "Actual subslot:  ${actual_subslot}"
eerror "Expected subslot:  ${expected_subslot}"
		die
	fi
}

multilib_src_configure() {
	cflags-hardened_append
	local emesonargs=(
		$(meson_native_use_bool gtk-doc build-documentation)
	)
	meson_src_configure
}
