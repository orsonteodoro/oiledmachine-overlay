# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BO CRSH DP HO ID MC OOBW PE SO UAF"

CHKL_TIMESTAMPS=(
	"dev-libs/wayland-9999"
	"sys-apps/systemd-9999"
	"sys-libs/libunwind-9999"
	"x11-libs/libX11-9999"
	"x11-libs/libxcvt-9999"
	"x11-libs/libXfont2-9999"
	"x11-libs/pixman-9999"
)

inherit cflags-hardened chkl meson secure-version

if [[ ${PV} == "9999" ]] ; then
	FALLBACK_COMMIT="https://gitlab.freedesktop.org/xorg/xserver.git"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://gitlab.freedesktop.org/xorg/xserver.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="https://xorg.freedesktop.org/archive/individual/xserver/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

DESCRIPTION="Standalone X server running under Wayland"
HOMEPAGE="https://www.x.org/wiki/ https://gitlab.freedesktop.org/xorg/xserver/xorg-server"

LICENSE="MIT"
SLOT="0"

IUSE+=" libei selinux systemd test unwind xcsecurity"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	${OPENSSL_DEPEND}
	>=dev-libs/libbsd-${LIBBSD_PV}:=
	>=dev-libs/wayland-${WAYLAND_PV}:=
	>=dev-libs/wayland-protocols-1.34:=
	media-fonts/font-util:=
	>=media-libs/libepoxy-1.5.4:=[X,egl(+)]
	>=media-libs/libglvnd-${LIBGLVND_PV}:=[X]
	>=media-libs/mesa-${MESA_PV}:=[X(+),egl(+),gbm(+)]
	>=x11-libs/libdrm-${LIBDRM_PV}:=
	>=x11-libs/libXau-1.0.4:=
	>=x11-libs/libxcvt-${LIBXCVT_PV}:=
	>=x11-libs/libXdmcp-${LIBXDMCP_PV}:=
	>=x11-libs/libXfont2-${LIBXFONT2_PV}:=
	>=x11-libs/libxkbfile-${LIBXKBFILE_PV}:=
	>=x11-libs/libxshmfence-${LIBXSHMFENCE_PV}:=
	>=x11-libs/pixman-${PIXMAN_PV}:=
	>=x11-misc/xkeyboard-config-${XKEYBOARD_CONFIG_PV}:=

	libei? ( >=dev-libs/libei-${LIBEI_PV}:= )
	systemd? ( >=sys-apps/systemd-${SYSTEMD_PV}:= )
	unwind? ( >=sys-libs/libunwind-${LIBUNWIND_PV}:= )
"
DEPEND="
	${COMMON_DEPEND}
	>=x11-base/xorg-proto-2024.1:=
	>=x11-libs/xtrans-${XTRANS_PV}:=
	test? (
		x11-misc/rendercheck:=
		>=x11-libs/libX11-${LIBX11_PV}:=
	)
"
RDEPEND="
	${COMMON_DEPEND}
	>=x11-apps/xkbcomp-${LIBXKBCOMP_PV}:=

	libei? ( >=sys-apps/xdg-desktop-portal-${XDG_DESKTOP_PORTAL_PV}:= )
	selinux? ( sec-policy/selinux-xserver:* )
"
BDEPEND="
	app-alternatives/lex
	dev-util/wayland-scanner
"

src_unpack() {
	if [[ ${PV} == "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			FALLBACK_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_prepare() {
	default

	if ! use test; then
		sed -i -e "s/dependency('x11')/disabler()/" meson.build || die
	fi
}

src_configure() {
	chkl_check_many_timestamps
	cflags_hardened_append
	local emesonargs=(
		$(meson_use selinux xselinux)
		$(meson_use systemd systemd_notify)
		$(meson_use unwind libunwind)
		$(meson_use xcsecurity)
		-Ddpms=true
		-Ddri3=true
		-Ddrm=true
		-Ddtrace=false
		-Dglamor=true
		-Dglx=true
		-Dipv6=true
		-Dscreensaver=true
		-Dsha1=libcrypto
		-Dxace=true
		-Dxdmcp=true
		-Dxinerama=true
		-Dxvfb=true
		-Dxv=true
		-Dxwayland-path="${EPREFIX}"/usr/bin
		-Dlibdecor=false
		-Ddocs=false
		-Ddevel-docs=false
		-Ddocs-pdf=false
	)

	if [[ ${PV} == "9999" ]]; then
		emesonargs+=(
			-Dxorg=false
			-Dxnest=false
			-Dxvfb=false
			-Dxwayland=true
		)
	fi

	if use libei; then
		emesonargs+=( -Dxwayland_ei=portal )
	else
		emesonargs+=( -Dxwayland_ei=false )
	fi

	meson_src_configure
}

src_install() {
	dosym ../bin/Xwayland /usr/libexec/Xwayland

	meson_src_install

	# Remove files installed by x11-base/xorg-xserver
	rm \
		"${ED}"/usr/share/man/man1/Xserver.1 \
		"${ED}"/usr/$(get_libdir)/xorg/protocol.txt \
		|| die
}
