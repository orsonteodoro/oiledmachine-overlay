# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHKL_TIMESTAMPS=(
	"x11-libs/libX11-9999"
)

inherit chkl linux-info systemd udev secure-version xorg-3 meson

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="2d8e0f866e6f901434ea1c551a3d44f6c4576a41"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/linuxwacom/xf86-input-wacom.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="https://github.com/linuxwacom/${PN}/releases/download/${P}/${P}.tar.bz2"
fi

DESCRIPTION="Driver for Wacom tablets and drawing devices"
HOMEPAGE="https://linuxwacom.github.io/"

LICENSE="GPL-2+"
KEYWORDS="~alpha amd64 arm arm64 ~loong ppc ppc64 ~riscv ~sparc x86"
IUSE+=" test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=x11-libs/libX11-${LIBX11_PV}:=
	>=x11-libs/libXext-${LIBXEXT_PV}:=
	>=x11-libs/libXi-${LIBXI_PV}:=
	>=x11-libs/libXrandr-${LIBXRANDR_PV}:=
	>=x11-libs/libXinerama-${LIBXINERAMA_PV}:=
	virtual/libudev:="
DEPEND="${RDEPEND}"

pkg_pretend() {
	linux-info_pkg_setup

	if ! linux_config_exists \
			|| ! linux_chkconfig_present HID_WACOM; then
		echo
		ewarn "If you use a USB Wacom tablet, you need to enable support in your kernel"
		ewarn "  Device Drivers --->"
		ewarn "    HID support  --->"
		ewarn "      Special HID drivers  --->"
		ewarn "        <*> Wacom Intuos/Graphire tablet support (USB)"
		echo
	fi
}

pkg_setup() {
	linux-info_pkg_setup
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
}

src_configure() {
	chkl_check_many_timestamps
	xorg-3_flags_setup

	local emesonargs=(
		-Dsystemd-unit-dir="$(systemd_get_systemunitdir)"
		-Dudev-rules-dir="$(get_udevdir)/rules.d"
		$(meson_feature test unittests)
		-Dwacom-gobject=disabled
	)
	meson_src_configure
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
