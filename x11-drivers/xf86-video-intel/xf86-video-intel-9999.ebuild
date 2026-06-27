# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_DRI=dri
XORG_EAUTORECONF=yes

CHKL_TIMESTAMPS=(
	"x11-base/xorg-server-9999"
	"x11-libs/libX11-9999"
	"x11-libs/libxcb-9999"
	"x11-libs/libXcursor-9999"
	"x11-libs/pixman-9999"
)

inherit chkl linux-info xorg-3 flag-o-matic secure-version

if [[ ${PV} != 9999* ]]; then
	KEYWORDS="~amd64 ~x86"
	COMMIT_ID=""
	SRC_URI="https://gitlab.freedesktop.org/xorg/driver/xf86-video-intel/-/archive/${COMMIT_ID}/${P}.tar.bz2"
	S="${WORKDIR}/${PN}-${COMMIT_ID}"
fi

DESCRIPTION="X.Org driver for Intel cards"

IUSE="debug +sna tools +udev uxa valgrind xvmc"

REQUIRED_USE="
	|| ( sna uxa )
	uxa? ( dri )
"
RDEPEND="
	>=x11-libs/libXext-${LIBXEXT_PV}:=
	>=x11-libs/libXfixes-${LIBXFIXES_PV}:=
	x11-libs/libXScrnSaver:=
	>=x11-libs/pixman-${PIXMAN_PV}:=
	>=x11-libs/libdrm-${LIBDRM_PV}:=[video_cards_intel]
	>=x11-base/xorg-server-${XORG_SERVER_PV}:=
	tools? (
		>=x11-libs/libX11-${LIBX11_PV}:=
		>=x11-libs/libxcb-${LIBXCB_PV}:=
		>=x11-libs/libXcursor-${LIBXCURSOR_PV}:=
		x11-libs/libXdamage:=
		>=x11-libs/libXinerama-${LIBXINERAMA_PV}:=
		>=x11-libs/libXrandr-${LIBXRANDR_PV}:=
		>=x11-libs/libXrender-${LIBXRENDER_PV}:=
		>=x11-libs/libxshmfence-${LIBXSHMFENCE_PV}:=
		>=x11-libs/libXtst-${LIBXTST_PV}:=
	)
	udev? (
		virtual/libudev:=
	)
	xvmc? (
		>=x11-libs/libXvMC-1.0.12-r1:=
		>=x11-libs/libxcb-${LIBXCB_PV}:=
		x11-libs/xcb-util:=
	)
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto:=
	valgrind? ( dev-debug/valgrind:= )
"

pkg_setup() {
	linux-info_pkg_setup
	xorg-3_pkg_setup
}

src_configure() {
	chkl_check_many_timestamps
	# bug #582910
	replace-flags -Os -O2
	# Uses the 'flatten' attribute which explodes with LTO (bug #864379)
	filter-lto

	local XORG_CONFIGURE_OPTIONS=(
		--disable-dri1
		$(use_enable debug)
		$(use_enable dri)
		$(use_enable dri dri3)
		$(usex dri "--with-default-dri=3" "")
		$(use_enable sna)
		$(use_enable tools)
		$(use_enable udev)
		$(use_enable uxa)
		$(use_enable valgrind)
		$(use_enable xvmc)
	)
	xorg-3_src_configure
}

pkg_postinst() {
	if linux_config_exists && \
		kernel_is -lt 4 3 && ! linux_chkconfig_present DRM_I915_KMS; then
		echo
		ewarn "This driver requires KMS support in your kernel"
		ewarn "  Device Drivers --->"
		ewarn "    Graphics support --->"
		ewarn "      Direct Rendering Manager (XFree86 4.1.0 and higher DRI support)  --->"
		ewarn "      <*>   Intel 830M, 845G, 852GM, 855GM, 865G (i915 driver)  --->"
		ewarn "	      i915 driver"
		ewarn "      [*]       Enable modesetting on intel by default"
		echo
	fi
}
