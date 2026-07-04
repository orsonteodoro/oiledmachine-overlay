# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Note: please bump this together with gui-wm/tinywl

CFLAGS_HARDENED_USE_CASES="copy-paste-password security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY=""

CHKL_TIMESTAMPS=(
	"dev-libs/libinput-9999"
	"dev-libs/libliftoff-9999"
	"dev-libs/wayland-9999"
	"media-libs/lcms-9999"
	"media-libs/libdisplay-info-9999"
	"media-libs/mesa-9999"
	"media-libs/vulkan-loader-9999"
	"sys-auth/seatd-9999"
	"x11-libs/libxcb-9999"
	"x11-libs/libxkbcommon-9999"
	"x11-libs/pixman-9999"
	"x11-base/xwayland-9999"
)

inherit cflags-hardened chkl meson secure-version

DESCRIPTION="Pluggable, composable, unopinionated modules for building a Wayland compositor"
HOMEPAGE="https://gitlab.freedesktop.org/wlroots/wlroots"

if [[ ${PV} == 9999 ]]; then
	FALLBACK_COMMIT="29fc556f4cd70896e464b3402b510d9759707cf8"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://gitlab.freedesktop.org/${PN}/${PN}.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
	SLOT="0.21"
else
	inherit verify-sig
	SRC_URI="https://gitlab.freedesktop.org/${PN}/${PN}/-/releases/${PV}/downloads/${P}.tar.gz
		https://gitlab.freedesktop.org/${PN}/${PN}/-/releases/${PV}/downloads/${P}.tar.gz.sig"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
	SLOT="$(ver_cut 1-2)"
fi

LICENSE="MIT"
IUSE+=" liftoff +libinput +drm +session lcms vulkan x11-backend xcb-errors X"
REQUIRED_USE="
	drm? ( session )
	libinput? ( session )
	liftoff? ( drm )
	xcb-errors? ( || ( x11-backend X ) )
"

RDEPEND="
	>=dev-libs/wayland-${WAYLAND_PV}:=
	>=media-libs/libglvnd-${LIBGLVND_PV}:=
	>=media-libs/mesa-${MESA_PV}:=[opengl]
	>=x11-libs/libdrm-${LIBDRM_PV}:=
	>=x11-libs/libxkbcommon-${LIBXKBCOMMON_PV}:=
	>=x11-libs/pixman-${PIXMAN_PV}:=
	drm? (
		>=media-libs/libdisplay-info-${LIBDISPLAY_INFO_PV}:=
		sys-apps/hwdata:=
		liftoff? ( >=dev-libs/libliftoff-${LIBLIFTOFF_PV}:= )
	)
	lcms? ( >=media-libs/lcms-${LCMS_PV}:= )
	libinput? ( >=dev-libs/libinput-${LIBINPUT_PV}:= )
	session? (
		>=sys-auth/seatd-${SEATD_PV}:=
		virtual/libudev:=
	)
	vulkan? (
		dev-util/glslang:=
		dev-util/vulkan-headers:=
		>=media-libs/vulkan-loader-${VULKAN_LOADER_PV}:=
	)
	xcb-errors? ( x11-libs/xcb-util-errors:= )
	x11-backend? (
		>=x11-libs/libxcb-${LIBXCB_PV}:=
		x11-libs/xcb-util-renderutil:=
	)
	X? (
		>=x11-libs/libxcb-${LIBXCB_PV}:=
		x11-libs/xcb-util-wm:=
		>=x11-base/xwayland-${XWAYLAND_PV}:=
	)
"
DEPEND="
	${RDEPEND}
	>=dev-libs/wayland-protocols-1.47:=
"
BDEPEND="
	dev-util/wayland-scanner
	virtual/pkgconfig
"

if [[ ${PV} != 9999 ]]; then
	BDEPEND+=" verify-sig? ( >=sec-keys/openpgp-keys-emersion-20260503 )"
	VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/emersion.asc"
fi

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		# TODO:  add verify-sig
		unpack ${A}
	fi
}

src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append

	# assert SLOT matches the version
	grep -q -e "version.*${SLOT}" meson.build || die "SLOT ${SLOT} does not match the version in meson.build"

	local backends=(
		$(usev drm)
		$(usev libinput)
		$(usev x11-backend 'x11')
	)
	local meson_backends=$(IFS=','; echo "${backends[*]}")
	local emesonargs=(
		$(meson_feature xcb-errors)
		-Dexamples=false
		-Drenderers=$(usex vulkan 'gles2,vulkan' gles2)
		$(meson_feature X xwayland)
		-Dbackends=${meson_backends}
		$(meson_feature session)
		$(meson_feature lcms color-management)
		$(meson_feature liftoff libliftoff)
	)

	meson_src_configure
}

src_install() {
	meson_src_install
	dodoc docs/*
}

pkg_postinst() {
	if use !session; then
		elog "You must be in the input group to allow your compositor"
		elog "to access input devices via libinput."
	fi
}
