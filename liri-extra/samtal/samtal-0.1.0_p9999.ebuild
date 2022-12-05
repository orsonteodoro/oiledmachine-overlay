# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3 xdg

DESCRIPTION="Internet Relay Chat with Material Design"
HOMEPAGE="https://github.com/lirios/samtal"
LICENSE="GPL-3+"

# Live/snapshot do not get KEYWORDS.

SLOT="0/$(ver_cut 1-3 ${PV})"
IUSE+="
save-server-settings

r1
"
QT_MIN_PV=5.10
DEPEND+="
	>=dev-qt/qtcore-${QT_MIN_PV}:5=
	>=dev-qt/qtdeclarative-${QT_MIN_PV}:5=
	>=dev-qt/qtgui-${QT_MIN_PV}:5=
	>=dev-qt/qtquickcontrols2-${QT_MIN_PV}:5=
	>=net-im/libcommuni-3.5:=[qml]
	~liri-base/fluid-1.2.0_p9999
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=dev-util/cmake-3.10.0
	~liri-base/cmake-shared-2.0.0_p9999
"
# The README.md is outdated.  qbs -> cmake
# Dropped internal libcommuni (libirc) for system libcommuni.
SRC_URI=""
EGIT_BRANCH="develop"
EGIT_REPO_URI="https://github.com/lirios/${PN}.git"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
PATCHES=(
	"${FILESDIR}/${PN}-0.1.0_p9999-snackbar.patch"
	"${FILESDIR}/${PN}-0.1.0_p9999-icon-source.patch"
	"${FILESDIR}/${PN}-0.1.0_p9999-ChatTextBrowser-flickable.patch"
)

pkg_setup() {
	QTCORE_PV=$(pkg-config --modversion Qt5Core)
	QTGUI_PV=$(pkg-config --modversion Qt5Gui)
	QTQML_PV=$(pkg-config --modversion Qt5Qml)
	QTQUICKCONTROLS2_PV=$(pkg-config --modversion Qt5QuickControls2)
	if ver_test ${QTCORE_PV} -ne ${QTGUI_PV} ; then
		die "Qt5Core is not the same version as Qt5Gui"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTQML_PV} ; then
		die "Qt5Core is not the same version as Qt5Qml (qtdeclarative)"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTQUICKCONTROLS2_PV} ; then
		die "Qt5Core is not the same version as Qt5QuickControls2"
	fi
	local libpath=$(realpath "${ESYSROOT}/usr/$(get_libdir)/libIrcCore.so")
	if ! strings "${libpath}" \
		| grep -q $(ver_cut 1-2 "${QTCORE_PV}") ; then
		local expected_v=$(ver_cut 1-2 ${QTCORE_PV})
		local actual_v=$(strings "${libpath}" \
			| grep -E -o -e "Qt_[0-9]\.[0-9]+(\.[0-9]+)?" \
			| sed -e "s|Qt_||")
eerror
eerror "Qt5Core is not the same version as net-im/libcommuni's Qt version"
eerror
eerror "Expected version:\t${expected_v}"
eerror "Actual version:\t${actual_v}"
eerror
		die
	fi
}

src_unpack() {
	git-r3_fetch
	git-r3_checkout
	local v_live=$(grep -r -e "VERSION \"" "${S}/CMakeLists.txt" \
		| head -n 1 \
		| cut -f 2 -d "\"")
	local v_expected=$(ver_cut 1-3 ${PV})
	if ver_test ${v_expected} -ne ${v_live} ; then
		eerror
		eerror "Version bump required."
		eerror
		eerror "v_expected=${v_expected}"
		eerror "v_live=${v_live}"
		eerror
		die
	else
		einfo
		einfo "v_expected=${v_expected}"
		einfo "v_live=${v_live}"
		einfo
	fi
}

src_prepare() {
	cmake_src_prepare
	sed -i -e "/src\/libirc/d" CMakeLists.txt || die
	if ! use save-server-settings ; then
		eapply "${FILESDIR}/${PN}-0.1.0_p9999-non-persistent-server-info.patch"
	fi
}

src_configure() {
	local mycmakeargs=(
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
		-DINSTALL_PLUGINSDIR=/usr/$(get_libdir)/qt5/plugins
		-DINSTALL_QMLDIR=/usr/$(get_libdir)/qt5/qml
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
einfo
einfo "You may need to manually edit or delete"
einfo "~/.config/Liri/'Liri Samtal.conf'"
einfo "to remove/change servers or logon settings."
einfo
ewarn
ewarn "Security notice:"
ewarn
ewarn "Passwords stored in ~/.config/Liri/'Liri Samtal.conf'"
ewarn "are in plaintext."
ewarn
ewarn
ewarn "Either one of the following mitigations:"
ewarn
ewarn "1. Encrypt /home/<username>"
ewarn
ewarn "2. Use a wrapper script to shred ~/.config/Liri/'Liri Samtal.conf' after"
ewarn "exit.  (It does not work well in brownout or low power mobile/laptop.)"
ewarn
ewarn "3. Disable storing passwords.  (By setting the save-server-settings USE"
ewarn "flag disabled.  Unstucks user ident changes on app restart as well.)"
ewarn
ewarn
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
