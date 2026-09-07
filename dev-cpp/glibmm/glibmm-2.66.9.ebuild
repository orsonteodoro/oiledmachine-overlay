# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

API_VERSION="2.4" # https://gitlab.gnome.org/GNOME/glibmm/-/blob/2.66.9/meson.build?ref_type=tags#L13
CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
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

CHKL_TIMESTAMPS=(
	"dev-libs/glib-2.89.9999"
)

inherit cflags-hardened chkl libcxx-slot libstdcxx-slot gnome.org meson-multilib secure-version python-any-r1

DESCRIPTION="C++ interface for glib2"
HOMEPAGE="https://gtkmm.gnome.org/en/index.html"
LICENSE="LGPL-2.1+"
RESTRICT="mirror
	!test? (
		test
	)
" # speed up and stop snooping
SLOT="${API_VERSION}"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86"
IUSE="gtk-doc debug test"
RDEPEND="
	>=dev-libs/glib-${GLIB_PV}:2=[${MULTILIB_USEDEP}]
	>=dev-libs/libsigc++-2.9.1:2=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-lang/perl-${PERL_PV}
	dev-perl/XML-Parser
	virtual/pkgconfig
	gtk-doc? (
		app-text/doxygen[dot]
		>=dev-libs/libxslt-${LIBXSLT_PV}
		media-gfx/graphviz
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
	local actual_subslot=$(grep -E -e "glibmm_api_version" "${S}/meson.build" | head -n 1 | cut -f 2 -d "'")
	local expected_subslot="${API_VERSION}"
	if ver_test "${actual_subslot}" "-ne" "${expected_subslot}" ; then
eerror "QA:  Update API_VERSION"
eerror "Actual subslot:  ${actual_subslot}"
eerror "Expected subslot:  ${expected_subslot}"
		die
	fi
}

src_prepare() {
	default

	# giomm_tls_client requires FEATURES=-network-sandbox and glib-networking rdep
	sed -i -e '/giomm_tls_client/d' tests/meson.build || die

	if ! use test; then
		sed -i -e "/^subdir('tests')/d" meson.build || die
	fi
}

multilib_src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	local emesonargs=(
		-Dwarnings=min
		-Dbuild-deprecated-api=true
		$(meson_native_use_bool gtk-doc build-documentation)
		$(meson_use debug debug-refcounting)
		-Dbuild-examples=false
	)
	meson_src_configure
}
