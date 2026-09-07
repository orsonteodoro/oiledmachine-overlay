# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

API_VERSION="2.48" # See https://gitlab.gnome.org/GNOME/pangomm/-/blob/master/meson.build?ref_type=heads#L13
CFLAGS_HARDENED="security-critical sensitive-data untrusted-data"
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

DESCRIPTION="C++ interface for pango"
HOMEPAGE="https://gtkmm.gnome.org/en/index.html"

LICENSE="LGPL-2.1+"
RESTRICT="mirror" # Speed up download and stop snooping
SLOT="${API_VERSION}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="dot gtk-doc"

RDEPEND="
	>=dev-cpp/cairomm-1.15.1:1.16=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP},gtk-doc?]
	>=dev-cpp/glibmm-2.68.0:2.68=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP},gtk-doc?]
	>=dev-libs/libsigc++-3:3=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP},gtk-doc?]
	>=x11-libs/pango-${PANGO_PV}:=[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
	gtk-doc? (
		>=dev-cpp/mm-common-1.0.4
		app-text/doxygen
		dot? ( app-text/doxygen[dot] )
		>=dev-libs/libxslt-${LIBXSLT_PV}
	)
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

multilib_src_install(){
	meson_src_install
	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/ || die
		mv "${ED}"/usr/share/doc/pangomm-*/reference/html/ "${ED}"/usr/share/gtk-doc/ || die
		# remove leftovers in doc folder:
		# - pangomm-${SLOT}/images contains multiple gif files
		# - pangomm-${SLOT}/reference contains compressed pango-${SLOT}.tag file
		# - pangomm-${PV} contains compressed Changelog, NEWS, README.md, README.win32.md
		rm -r "${ED}"/usr/share/doc/* || die
	fi
}
