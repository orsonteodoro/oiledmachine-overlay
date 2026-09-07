# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

API_VERSION="1.4" # See https://gitlab.gnome.org/GNOME/pangomm/-/blob/2.46.4/meson.build?ref_type=tags#L14
CFLAGS_HARDENED="security-critical sensitive-data untrusted-data"
CXX_STANDARD=11
PYTHON_COMPAT=( python3_{10..14} )

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX11[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX11[@]/llvm_slot_}"
)

inherit cflags-hardened gnome.org libcxx-slot libstdcxx-slot meson-multilib secure-version python-any-r1


DESCRIPTION="C++ interface for pango"
HOMEPAGE="https://gtkmm.gnome.org/en/index.html"

LICENSE="LGPL-2.1+"
SLOT="1.4"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~sparc x86"
IUSE="gtk-doc"
RDEPEND="
	>=dev-cpp/cairomm-1.2.2:1.0=[gtk-doc?,${MULTILIB_USEDEP}]
	>=dev-cpp/glibmm-2.48.0:2.4=[gtk-doc?,${MULTILIB_USEDEP}]
	>=dev-libs/libsigc++-2:2=[gtk-doc?,${MULTILIB_USEDEP}]
	>=x11-libs/pango-${PANGO_PV}:=[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	gtk-doc? (
		>=dev-cpp/mm-common-1.0.4
		app-text/doxygen[dot]
		>=dev-libs/libxslt-${LIBXSLT_PV}
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
	local actual_subslot=$(grep -E -e "pangomm_api_version" "${S}/meson.build" | head -n 1 | cut -f 2 -d "'")
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
		-Dmaintainer-mode=false
		$(meson_native_use_bool gtk-doc build-documentation)
	)
	meson_src_configure
}
