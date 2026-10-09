# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=23
CFLAGS_HARDENED_USE_CASES="untrusted-data security-critical sensitive-data"
PYTHON_COMPAT=( python3_{12..14} )
GNOME_ORG_MODULE="vte"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX23[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX23[@]/llvm_slot_}"
)

CHKL_TIMESTAMPS=(
	"app-arch/lz4-9999"
	"dev-cpp/fast_float-9999"
	"dev-libs/fribidi-9999"
	"dev-libs/glib-2.90.9999"
	"gui-libs/gtk-4.25.9999"
	"sys-apps/systemd-9999"
	"x11-libs/cairo-9999"
	"x11-libs/gtk+-3.24.9999"
	"x11-libs/pango-9999"
)

inherit cflags-hardened chkl flag-o-matic gnome.org libcxx-slot libstdcxx-slot meson secure-version python-any-r1

DESCRIPTION="Library providing a virtual terminal emulator widget"
HOMEPAGE="https://gitlab.gnome.org/GNOME/vte"

S="${WORKDIR}/vte-${PV}"

# Once SIXEL support ships (0.66 or later), might need xterm license (but code might be considered upgraded to LGPL-3+)
LICENSE="LGPL-3+ GPL-3+"

API_VERSION="2.91" # vte_api_version in meson.build
SLOT="${API_VERSION}"

KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

IUSE="
systemd gtk3 gtk4
ebuild_revision_3
"

DEPEND="
	>=app-arch/lz4-${LZ4_PV}:=
	>=dev-cpp/fast_float-${FAST_FLOAT_PV}:=
	>=dev-libs/fribidi-${FRIBIDI_PV}:=
	>=dev-libs/glib-${GLIB_PV}:=
	>=dev-libs/libpcre2-${LIBPCRE2_PV}:=
	>=x11-libs/cairo-${CAIRO_PV}:=
	>=x11-libs/pango-${PANGO_PV}:=
	gtk3? (
		>=x11-libs/gtk+-${GTK3_PV}:3=
	)
	gtk4? (
		>=gui-libs/gtk-${GTK4_PV}:4=
	)
	systemd? (
		>=sys-apps/systemd-${SYSTEMD_PV}:=
	)
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/libxml2-${LIBXML2_PV}:=
	>=sys-devel/gettext-0.19.8
	dev-util/glib-utils
	virtual/pkgconfig
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
		git-r3_src_unpack
	else
		unpack ${A}
	fi

	local expected_api_version="${API_VERSION}"
	local api_ver_c1=$(grep -E -o -e "vte_api_major_version = [0-9]+" "${S}/meson.build" | cut -f 3 -d " ")
	local api_ver_c2=$(grep -E -o -e "vte_api_minor_version = [0-9]+" "${S}/meson.build" | cut -f 3 -d " ")
	local actual_api_version="${api_ver_c1}.${api_ver_c2}"
	if ver_test "${actual_api_version}" "-ne" "${expected_api_version}" ; then
eerror "QA:  Update API_VERSION"
eerror "Actual API_VERSION:  ${actual_api_version}"
eerror "Expected API_VERSION:  ${expected_api_version}"
		die
	fi
}

src_prepare() {
	default
	use elibc_musl && eapply "${FILESDIR}"/${PN}-0.84.0-musl-W_EXITCODE.patch
}

src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	# Upstream don't support LTO & error out on it in meson.build (bug #926156)
	filter-lto

	local emesonargs=(
		-Da11y=false
		-Ddebug=false
		-Ddocs=false
		-Dgir=false
		-Dfribidi=true # pulled in by pango anyhow
		-Dglade=false
		-Dgnutls=false
		-Dgtk3=false
		-Dgtk4=false
		-Dicu=false
		$(meson_use systemd _systemd)
		-Dvapi=false
	)
	meson_src_configure
}

src_install() {
	exeinto /usr/libexec/
	doexe "${BUILD_DIR}"/src/vte-urlencode-cwd
	insinto /etc/profile.d/
	newins "${BUILD_DIR}"/src/vte.sh vte-${SLOT}.sh
	newins "${BUILD_DIR}"/src/vte.csh vte-${SLOT}.csh
	if  use systemd; then
		insinto /usr/lib/systemd/user/vte-spawn-.scode.d/
		newins "${S}"/src/vte-spawn-.scope.conf defaults.conf
	fi
	einstalldocs
}
