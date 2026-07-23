# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# For depends see nix/package.nix, nix/shell.nix

# Upstream recommends leaving all build options enabled by default

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CXX_STANDARD=23

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX23[@]}" # 15-16
)
LIBSTDCXX_USEDEP_DEV="gcc_slot_skip(+)"

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX23[@]/llvm_slot_}" # 21-22
)
LIBCXX_USEDEP_DEV="llvm_slot_skip(+)"

CHKL_TIMESTAMPS=(
	"dev-cpp/nlohmann_json-9999"
	"dev-libs/glib-2.89.9999"
	"dev-libs/jemalloc-9999"
	"dev-libs/libsodium-9999"
	"dev-libs/libxml2-9999"
	"dev-libs/wayland-9999"
	"gnome-base/librsvg-9999"
	"media-libs/fontconfig-9999"
	"media-libs/freetype-9999"
	"media-libs/harfbuzz-9999"
	"media-libs/libwebp-9999"
	"media-libs/mesa-9999"
	"media-video/pipewire-9999"
	"net-misc/curl-9999"
	"sys-apps/systemd-9999"
	"sys-libs/pam-9999"
	"sys-auth/polkit-9999"
	"x11-libs/cairo-9999"
	"x11-libs/libxkbcommon-9999"
)

inherit branding cflags-hardened chkl libcxx-slot libstdcxx-slot meson secure-version

if [[ "${PV}" =~ "9999" ]]; then
	FALLBACK_COMMIT="4c2dcd0995f9c570c0ced95561bf5e4685e2ad1b"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/noctalia-dev/noctalia.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	KEYWORDS="~amd64"
	SRC_URI="
https://github.com/noctalia-dev/noctalia/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	"
fi

DESCRIPTION="A sleek, customizable desktop shell crafted for Wayland."
HOMEPAGE="
	https://github.com/noctalia-dev/noctalia
"
LICENSE="MIT"
SLOT="0/5"
IUSE+="
jemalloc native-optimizations systemd test
"
REQUIRED_USE="
"

RDEPEND="
	>=app-crypt/libsecret-${LIBSECRET_PV}:=
	>=dev-cpp/nlohmann_json-${NLOHMANN_JSON_PV}:=
	>=dev-libs/glib-${GLIB_PV}:=
	>=dev-libs/jemalloc-${JEMALLOC_PV}:=
	>=dev-libs/libsodium-${LIBSODIUM_PV}:=
	>=dev-libs/wayland-${WAYLAND_PV}:=
	>=dev-libs/libxml2-${LIBXML2_PV}:=
	>=gnome-base/librsvg-${LIBRSVG_PV}:=
	>=media-libs/harfbuzz-${HARFBUZZ_PV}:=
	>=media-libs/fontconfig-${FONTCONFIG_PV}:=
	>=media-libs/freetype-${FREETYPE_PV}:=
	>=media-libs/libglvnd-${LIBGLVND_PV}:=
	>=media-libs/libwebp-${LIBWEBP_PV}:=
	>=media-libs/mesa-${MESA_PV}:=[opengl]
	>=media-video/pipewire-${PIPEWIRE_PV}:=
	>=net-misc/curl-${CURL_PV}:=
	>=sys-auth/polkit-${POLKIT_PV}:=
	>=sys-libs/pam-${PAM_PV}:=
	>=x11-libs/cairo-${CAIRO_PV}:=
	>=x11-libs/libxkbcommon-${LIBXKBCOMMON_PV}:=
	>=x11-libs/pango-${PANGO_PV}:=
	dev-cpp/sdbus-c++:=
	dev-cpp/tomlplusplus:=
	dev-libs/md4c:=
	dev-libs/stb:=
	media-video/wireplumber:=
	sci-libs/libqalculate:=
	systemd? (
		>=sys-apps/systemd-${SYSTEMD_PV}:=
	)

"
DEPEND="
	${RDEPEND}
	dev-libs/wayland-protocols
"
BDEPEND="
	dev-build/meson
	dev-util/wayland-scanner
	dev-vcs/git
	virtual/pkgconfig
"

DOCS=( "README.md" )

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]]; then
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
	chkl_check_many_timestamps
	cflags-hardened_append
	local emesonargs=(
		$(meson_feature jemalloc)
		$(meson_feature test tests)
		$(meson_use native-optimizations native_optimizations)
	)
	meson_src_configure
}

pkg_postinst() {
einfo
einfo "Tip:  Setting clock"
einfo
einfo "The clock settings can be found in Owl>Gear>Bar: default>Center>Clock>Gear"
einfo "The clock format documentation can be found at https://docs.noctalia.dev/v5/configuration/date-format-tokens/"
einfo
einfo "Tip:  Add \`noctalia --daemon\` to add to autostart."
einfo
}

# OILEDMACHINE_OVERLAY_TEST:  PASSED interactive 4c2dcd0 (20260723)
