# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic savedconfig toolchain-funcs

WLROOTS_PV="0.16.2" # Prevent crash
WLROOTS_SUBSLOT=$(ver_cut 2 ${WLROOTS_PV})
WLROOTS_PKG=">=gui-libs/wlroots-${WLROOTS_PV}:0/${WLROOTS_SUBSLOT}[X(-)?]"
if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/djpohly/dwl"
	inherit git-r3

	# 9999-r0: main (latest wlroots release)
	# 9999-r1: wlroots-next (wlroots-9999)
	case ${PVR} in
		9999)
			EGIT_BRANCH=main
			;;
		9999-r1)
			EGIT_BRANCH=wlroots-next
			WLROOTS_PKG="gui-libs/wlroots:0/9999[X(-)?]"
			;;
	esac
	IUSE+=" fallback-commit"
else
	SRC_URI="https://github.com/djpohly/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="dwm for Wayland"
HOMEPAGE="https://github.com/djpohly/dwl"

LICENSE="CC0-1.0 GPL-3 MIT"
SLOT="0"
IUSE+=" somebar X r1"

RDEPEND="
	${WLROOTS_PKG}
	dev-libs/libinput:=
	dev-libs/wayland
	x11-libs/libxkbcommon
	X? (
		x11-libs/libxcb:=
		x11-libs/xcb-util-wm
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/wayland-protocols
	dev-util/wayland-scanner
	virtual/pkgconfig
"

src_unpack() {
	if [[ ${PV} == *9999 ]]; then
		if use fallback-commit ; then
			EGIT_COMMIT="6722a8953243387545a6bab23514b84cffd6a3bf"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_prepare() {
	restore_config config.h
	# Patch from https://git.sr.ht/~raphi/dwl
	use somebar && eapply "${FILESDIR}/${PN}-0.4-wayland-ipc.patch"

	default
}

src_configure() {
	sed -i "s:/local::g" config.mk || die

	sed -i "s:pkg-config:$(tc-getPKG_CONFIG):g" config.mk || die

	if use X; then
		append-cppflags '-DXWAYLAND'
		append-libs '-lxcb' '-lxcb-icccm'
	fi
}

src_install() {
	default

	insinto /usr/share/wayland-sessions
	doins "${FILESDIR}"/dwl.desktop

	save_config config.h
}

pkg_postinst() {
	savedconfig_pkg_postinst
ewarn
ewarn "This program is buggy or or the dependencies are."
ewarn
ewarn "Accessing the menu with ctrl+p after monitor is off or suspended may"
ewarn "lead to loss of unsaved work (or data loss) due to crash."
ewarn
ewarn "Switching from other vt console too long may make it impossible"
ewarn "to return back to dwl desktop."
ewarn
# A similar problem (issue 107) was addressed in this project.
}
