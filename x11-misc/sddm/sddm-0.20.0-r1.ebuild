# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT5_PV="5.15.8"
QT6_PV="6.4.2"

inherit cmake linux-info optfeature systemd tmpfiles

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	SRC_URI="
https://github.com/${PN}/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
	KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
fi


DESCRIPTION="Simple Desktop Display Manager"
HOMEPAGE="https://github.com/sddm/sddm"

LICENSE="
	GPL-2+
	CC-BY-3.0
	CC-BY-SA-3.0
	MIT
	public-domain
"
SLOT="0"
IUSE="
+elogind systemd qt5 qt6 test wayland X
"

REQUIRED_USE="
	^^ (
		elogind
		systemd
	)
	^^ (
		qt5
		qt6
	)
	^^ (
		wayland
		X
	)
"
RESTRICT="
	!test? (
		test
	)
"

# U 23.04
COMMON_DEPEND="
	!systemd? (
		sys-power/upower
	)
	>=sys-libs/pam-1.5.2
	acct-group/sddm
	acct-user/sddm
	elogind? (
		sys-auth/elogind[pam]
	)
	qt5? (
		>=dev-qt/qtcore-${QT5_PV}:5
		>=dev-qt/qtdbus-${QT5_PV}:5
		>=dev-qt/qtdeclarative-${QT5_PV}:5
		>=dev-qt/qtgui-${QT5_PV}:5[wayland?,X?]
		>=dev-qt/qtnetwork-${QT5_PV}:5
	)
	qt6? (
		>=dev-qt/qtbase-${QT6_PV}:6[dbus,gui,network,wayland?,X?]
		>=dev-qt/qtdeclarative-${QT6_PV}:6
		wayland? (
			>=dev-qt/qtwayland-${QT6_PV}:6
			>=dev-qt/qtdeclarative-${QT6_PV}:6[opengl]
		)
	)
	systemd? (
		>=sys-apps/systemd-252.5:=[pam]
	)
	wayland? (
		>=x11-misc/xkeyboard-config-2.38
	)
	X? (
		>=x11-libs/libXau-1.0.9
		>=x11-libs/libxcb-1.15:=
		>=x11-libs/libxkbcommon-1.5.0
	)
"
DEPEND="
	${COMMON_DEPEND}
	test? (
		qt5? (
			>=dev-qt/qttest-${QT5_PV}:5
		)
		qt6? (
			>=dev-qt/qtbase-${QT6_PV}:6[test]
		)
	)
"
RDEPEND="
	${COMMON_DEPEND}
	!systemd? (
		gui-libs/display-manager-init
	)
	>=x11-base/xorg-server-21.1.7
"
BDEPEND="
	>=dev-util/cmake-3.4
	>=kde-frameworks/extra-cmake-modules-1.4.0:5
	>=dev-python/docutils-0.19
	virtual/pkgconfig
	qt5? (
		>=dev-qt/linguist-tools-${QT5_PV}:5
	)
	qt6? (
		>=dev-qt/qttools-${QT6_PV}:6[linguist]
	)
"

PATCHES=(
	# Downstream patches
	"${FILESDIR}/${PN}-0.20.0-respect-user-flags.patch"
	"${FILESDIR}/${PN}-0.18.1-Xsession.patch" # bug 611210
	"${FILESDIR}/${PN}-0.20.0-sddm.pam-use-substack.patch" # bug 728550
	"${FILESDIR}/${PN}-0.20.0-disable-etc-debian-check.patch"
	"${FILESDIR}/${PN}-0.20.0-no-default-pam_systemd-module.patch" # bug 669980
	# git master
	"${FILESDIR}/${PN}-0.20.0-fix-use-development-sessions.patch"
	"${FILESDIR}/${PN}-0.20.0-greeter-platform-detection.patch"
	"${FILESDIR}/${PN}-0.20.0-no-qtvirtualkeyboard-on-wayland.patch"
	"${FILESDIR}/${PN}-0.20.0-dbus-policy-in-usr.patch"

	# oiledmachine-overlay patches
	"${FILESDIR}/${PN}-0.20.0-r1-qt6-x-changes.patch"
)

pkg_setup() {
	local CONFIG_CHECK="~DRM"
	use kernel_linux && linux-info_pkg_setup
}

gen_config() {
	touch 01gentoo.conf || die
cat <<-EOF >> 01gentoo.conf
[General]
# Remove qtvirtualkeyboard as InputMethod default
InputMethod=
EOF
}

src_prepare() {
	gen_config
	cmake_src_prepare

	if ! use test ; then
		sed \
			-e "/^find_package/s/ Test//" \
			-i CMakeLists.txt \
			|| die
		cmake_comment_add_subdirectory test
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_MAN_PAGES=ON
		-DBUILD_WITH_X=$(usex X)
		-DBUILD_WITH_QT6=$(usex qt6)
		-DDBUS_CONFIG_FILENAME="org.freedesktop.sddm.conf"
		-DNO_SYSTEMD=$(usex !systemd)
		-DRUNTIME_DIR=/run/sddm
		-DSYSTEMD_TMPFILES_DIR="/usr/lib/tmpfiles.d"
		-DUSE_ELOGIND=$(usex elogind)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	insinto /etc/sddm.conf.d/
	doins "${S}"/01gentoo.conf
}

pkg_postinst() {
	tmpfiles_process "${PN}.conf"
ewarn
ewarn "If SDDM startup appears to hang then entropy pool is too low.  This can"
ewarn "be fixed by configuring one of the following:"
ewarn
ewarn "  - Enable the CONFIG_RANDOM_TRUST_CPU in the Linux kernel."
ewarn "  - \`emerge sys-apps/haveged && rc-update add haveged boot\`"
ewarn "  - \`emerge sys-apps/rng-tools && rc-update add rngd boot\`"
ewarn
einfo
einfo "SDDM example config can be shown with:"
einfo
einfo "  ${EROOT}/usr/bin/sddm --example-config"
einfo
einfo "Use ${EROOT}/etc/sddm.conf.d/ directory to override specific options."
einfo
einfo "For more information on how to configure SDDM, please visit the wiki:"
einfo
einfo "  https://wiki.gentoo.org/wiki/SDDM"
einfo
	if has_version x11-drivers/nvidia-drivers; then
ewarn
ewarn "Nvidia GPU owners in particular should pay attention to the"
ewarn "troubleshooting section."
ewarn
	fi
	optfeature "Weston DisplayServer support (EXPERIMENTAL)" dev-libs/weston
	optfeature "KWin DisplayServer support (EXPERIMENTAL)" kde-plasma/kwin
	systemd_reenable sddm.service
}

# OILEDMACHINE-OVERLAY-TEST: ok
# qt5:  untested
# qt6:  pass
# wayland:  fail
# X:  pass
