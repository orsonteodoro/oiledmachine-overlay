# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# The stable is missing some commits.
# This ebuild fork used AI for clarification or vulnerability detailed analysis.

CFLAGS_HARDENED_ASSEMBLERS="gas inline"
CFLAGS_HARDENED_LANG="asm c-lang"
CFLAGS_HARDENED_USE_CASES="security-critical untrusted-data security-critical"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BO BU BOR CE CRSH DOS DT DBZ DP HO ID IL IPI IU LPE MC ML OOBA OOBR OOBW PE RC RCE SO UAF"

CHKL_TIMESTAMPS=(
	"dev-libs/openssl-4.0.9999"
	"dev-libs/openssl-3.6.9999"
	"dev-libs/openssl-3.5.9999"
	"dev-libs/openssl-3.4.9999"
	"dev-libs/openssl-3.3.9999"
	"dev-libs/openssl-3.0.9999"
	"media-libs/libglvnd-9999"
	"media-libs/mesa-9999"
	"sys-apps/dbus-9999"
	"sys-apps/systemd-9999"
	"sys-auth/elogind-257.9999"
	"sys-auth/pambase-999999999"
	"sys-libs/libselinux-9999"
	"sys-libs/libunwind-9999"
	"sys-process/audit-9999"
	"x11-libs/libX11-9999"
	"x11-libs/libxcb-9999"
	"x11-libs/libxcvt-9999"
	"x11-libs/libXfont2-9999"
	"x11-libs/pixman-9999"
)

inherit cflags-hardened chkl flag-o-matic secure-version xorg-meson
EGIT_REPO_URI="https://gitlab.freedesktop.org/xorg/xserver.git"

DESCRIPTION="X.Org X servers"
SLOT="0/${PV}"
if [[ ${PV} != 9999* ]]; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

IUSE_SERVERS="xephyr xnest xorg xvfb"
IUSE="
${IUSE_SERVERS} debug +elogind minimal pciaccess selinux suid systemd test +udev unwind xcsecurity
ebuild_revision_4
"
RESTRICT="!test? ( test )"

CDEPEND="
	${OPENSSL_RDEPEND}
	>=media-libs/libglvnd-${LIBGLVND_PV}:=[X]
	>=dev-libs/libbsd-${LIBBSD_PV}:=
	>=x11-apps/iceauth-${ICEAUTH_PV}:=
	>=x11-apps/xauth-${XAUTH_PV}:=
	>=x11-apps/xkbcomp-${XKBCOMP_PV}:=
	>=x11-libs/libdrm-${LIBDRM_PV}:=
	>=x11-libs/libXau-1.0.4:=
	>=x11-libs/libXdmcp-${LIBXDMCP_PV}:=
	>=x11-libs/libXfont2-${LIBXFONT2_PV}:=
	>=x11-libs/libxkbfile-${LIBXKBFILE_PV}:=
	>=x11-libs/libxshmfence-${LIBXSHMFENCE_PV}:=
	>=x11-libs/pixman-${PIXMAN_PV}:=
	>=x11-misc/xbitmaps-1.0.1:=
	>=x11-misc/xkeyboard-config-${XKEYBOARD_CONFIG_PV}:=
	!pciaccess? (
		!x11-libs/libpciaccess
	)
	pciaccess? (
		>=x11-libs/libpciaccess-${LIBPCIACCESS_PV}:=
	)
	xorg? (
		>=x11-libs/libxcvt-${LIBXCVT_PV}:=
	)
	xnest? (
		>=x11-libs/libXext-${LIBXEXT_PV}:=
		>=x11-libs/libX11-${LIBX11_PV}:=
	)
	xephyr? (
		>=x11-libs/libxcb-${LIBXCB_PV}:=
		x11-libs/xcb-util:=
		x11-libs/xcb-util-image:=
		x11-libs/xcb-util-keysyms:=
		x11-libs/xcb-util-renderutil:=
		x11-libs/xcb-util-wm:=
	)
	!minimal? (
		>=media-libs/mesa-${MESA_PV}:=[X(+),egl(+),gbm(+)]
		>=media-libs/libepoxy-1.5.4:=[X,egl(+)]
	)
	udev? ( virtual/libudev:= )
	unwind? ( >=sys-libs/libunwind-${LIBUNWIND_PV}:= )
	selinux? (
		>=sys-process/audit-${AUDIT_PV}:=
		>=sys-libs/libselinux-${LIBSELINUX_PV}:=
	)
	systemd? (
		>=sys-apps/dbus-${DBUS_PV}:=
		>=sys-apps/systemd-${SYSTEMD_PV}:=
	)
	elogind? (
		>=sys-apps/dbus-${DBUS_PV}:=
		>=sys-auth/elogind-${ELOGIND_PV}:=[pam]
		>=sys-auth/pambase-${PAMBASE_PV}:=[elogind]
	)
	!!x11-drivers/nvidia-drivers[-libglvnd(+)]
"
DEPEND="${CDEPEND}
	>=x11-base/xorg-proto-2024.1:=
	>=x11-libs/xtrans-${XTRANS_PV}:=
	media-fonts/font-util:=
	test? ( >=x11-libs/libxcvt-${LIBXCVT_PV}:= )
"
RDEPEND="${CDEPEND}
	!systemd? ( gui-libs/display-manager-init:= )
	selinux? ( sec-policy/selinux-xserver:* )
	xorg? ( >=x11-apps/xinit-${XINIT_PV}:= )
"
BDEPEND="
	app-alternatives/lex
"
PDEPEND="
	xorg? ( >=x11-base/xorg-drivers-$(ver_cut 1-2) )"

REQUIRED_USE="!minimal? (
		|| ( ${IUSE_SERVERS} )
	)
	elogind? ( udev )
	?? ( elogind systemd )"

PATCHES=(
	"${UPSTREAMED_PATCHES[@]}"
	"${FILESDIR}"/${PN}-1.12-unloadsubmodule.patch
	"${FILESDIR}"/${PN}-035ff561-optionalize-pci_device_is_boot_display.patch # oiledmachine-overlay patch
)

src_configure() {
	chkl_check_many_timestamps

	# bug #835653
	use x86 && replace-flags -Os -O2
	use x86 && replace-flags -Oz -O2

	use debug && EMESON_BUILDTYPE=debug

	cflags-hardened_append

	local use_pci_device_is_boot_display_stub=1
	if has_version ">=x11-libs/libpciaccess-0.19" ; then
		use_pci_device_is_boot_display_stub=0
	fi
	sed -i -e "s|@USE_PCI_DEVICE_IS_BOOT_DISPLAY_STUB@|${use_pci_device_is_boot_display_stub}|g" \
		"${S}/hw/xfree86/common/xf86platformBus.h" \
		|| die

	# localstatedir is used for the log location; we need to override the default
	#	from ebuild.sh
	# sysconfdir is used for the xorg.conf location; same applies
	local XORG_CONFIGURE_OPTIONS=(
		--localstatedir "${EPREFIX}/var"
		--sysconfdir "${EPREFIX}/etc/X11"
		-Db_ndebug=$(usex debug false true)
		$(meson_use !minimal dri1)
		$(meson_use !minimal dri2)
		$(meson_use !minimal dri3)
		$(meson_use !minimal glamor)
		$(meson_use !minimal glx)
		$(meson_use pciaccess)
		$(meson_use udev)
		$(meson_use udev udev_kms)
		$(meson_use unwind libunwind)
		$(meson_use xcsecurity)
		$(meson_use selinux xselinux)
		$(meson_use xephyr)
		$(meson_use xnest)
		$(meson_use xorg)
		$(meson_use xvfb)
		-Ddocs=false
		-Ddrm=true
		-Ddtrace=false
		-Dipv6=true
		-Dhal=false
		-Dlinux_acpi=false
		-Dlinux_apm=false
		-Dsha1=libcrypto
		-Dxkb_output_dir="${EPREFIX}/var/lib/xkb"
	)

	if [[ ${PV} == 9999 ]] ; then
		# Gone in 21.1.x, but not in master.
		XORG_CONFIGURE_OPTIONS+=( -Dxwayland=false )
	fi

	if use systemd || use elogind; then
		XORG_CONFIGURE_OPTIONS+=(
			-Dsystemd_logind=true
			$(meson_use suid suid_wrapper)
		)
	else
		XORG_CONFIGURE_OPTIONS+=(
			-Dsystemd_logind=false
			-Dsuid_wrapper=false
		)
	fi

	xorg-meson_src_configure
}

src_install() {
	xorg-meson_src_install

	# The meson build system does not support install-setuid
	if ! use systemd && ! use elogind; then
		if use suid; then
			chmod u+s "${ED}"/usr/bin/Xorg
		fi
	fi

	if ! use xorg; then
		rm -f "${ED}"/usr/share/man/man1/Xserver.1x \
			"${ED}"/usr/$(get_libdir)/xserver/SecurityPolicy \
			"${ED}"/usr/$(get_libdir)/pkgconfig/xorg-server.pc \
			"${ED}"/usr/share/man/man1/Xserver.1x || die
	fi

	# install the @x11-module-rebuild set for Portage
	insinto /usr/share/portage/config/sets
	newins "${FILESDIR}"/xorg-sets.conf xorg.conf
}

pkg_postinst() {
ewarn
ewarn "SECURITY NOTICE"
ewarn
ewarn "${PN} and associated packages have inadequate process isolation, so"
ewarn "the blast radius is extended for the compromised process with known"
ewarn "keyboard snooping or screen grabs capabilities for the threat actor."
ewarn "Users that use the show password feature are also affected."
ewarn "Use either the following for remediation:"
ewarn
ewarn "1. Use pure Wayland for full remediation"
ewarn "2. Use Wayland + Xwayland for partial remediation"
ewarn "3. Use Firejail + Xephyr"
ewarn "4. Use Firejail + Xpra"
ewarn "5. Use Firejail + either Xpra or Xephyr depending on the app"
ewarn
}

pkg_postrm() {
	# Get rid of module dir to ensure opengl-update works properly
	if [[ -z ${REPLACED_BY_VERSION} && -e ${EROOT}/usr/$(get_libdir)/xorg/modules ]]; then
		rm -rf "${EROOT}"/usr/$(get_libdir)/xorg/modules
	fi
}
