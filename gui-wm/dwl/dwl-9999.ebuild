# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild fork contains a patch with AI generated recommended fix.

CFLAGS_HARDENED_USE_CASES="copy-paste-password security-critical sensitive-data untrusted-data" # Add retpoline to password widget

CHKL_TIMESTAMPS=(
	"dev-libs/libinput-9999"
	"dev-libs/wayland-9999"
	"gui-libs/wlroots-9999"
	"x11-libs/libxcb-9999"
	"x11-libs/libxkbcommon-9999"
)

inherit cflags-hardened chkl savedconfig secure-version toolchain-funcs

if [[ ${PV} == 9999 ]]; then
	FALLBACK_COMMIT="d41ecb745cc94fbb48e93af01f5fd5d0b2488945"
	EGIT_BRANCH="wlroots-next"
	EGIT_REPO_URI="https://codeberg.org/dwl/dwl.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	MY_PV="${PV/_rc/-rc}"
	MY_P="${PN}-v${MY_PV}"
	SRC_URI="https://codeberg.org/${PN}/${PN}/releases/download/v${MY_PV}/${MY_P}.tar.gz"
	S="${WORKDIR}/${MY_P}"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
fi

DESCRIPTION="dwm for Wayland"
HOMEPAGE="https://codeberg.org/dwl/dwl"

LICENSE="CC0-1.0 GPL-3+ MIT"
SLOT="0"
IUSE+=" X"

COMMON_DEPEND+="
	>=dev-libs/libinput-${LIBINPUT_PV}:=
	>=dev-libs/wayland-${WAYLAND_PV}
	>=gui-libs/wlroots-${WLROOTS_PV}:=[libinput,session,X?]
	>=x11-libs/libxkbcommon-${LIBXKBCOMMON_PV}:=
	X? (
		>=x11-libs/libxcb-${LIBXCB_PV}:=
		x11-libs/xcb-util-wm:=
	)
"
RDEPEND="
	${COMMON_DEPEND}
	X? (
		x11-base/xwayland:=
	)
"
# uses <linux/input-event-codes.h>
DEPEND="
	${COMMON_DEPEND}
	sys-kernel/linux-headers:=
"
BDEPEND="
	>=dev-libs/wayland-protocols-1.32
	>=dev-util/wayland-scanner-1.23
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}/dwl-d41ecb7-use-wlroots-live.patch"
	"${FILESDIR}/dwl-d41ecb7-dwl.c-use-wlroots-live.patch"
)

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

src_prepare() {
	restore_config config.h

	default
}

src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
}

src_compile() {
	emake PKG_CONFIG="$(tc-getPKG_CONFIG)" CC="$(tc-getCC)" \
		XWAYLAND="$(usev X -DXWAYLAND)" XLIBS="$(usev X "xcb xcb-icccm")" dwl
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
	dodoc CHANGELOG.md README.md

	save_config config.h
}
