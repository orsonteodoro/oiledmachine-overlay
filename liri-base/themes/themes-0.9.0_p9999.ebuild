# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Themes for a uniform look and feel throughout Liri OS"
HOMEPAGE="https://github.com/lirios/themes"
LICENSE="GPL-3+ grub? ( GPL-3-with-font-exception OFL-1.1 )"
# Noto fonts is OFL-1.1
# The KDE Oxygen font is || ( OFL-1.1 GPL-3-with-font-exception )

# Live/snapshot do not get KEYWORDS.

SLOT="0/$(ver_cut 1-3 ${PV})"
IUSE+="
grub plymouth sddm

r2
"
QT_MIN_PV=5.10
DEPEND+="
	grub? (
		sys-boot/grub
	)
	plymouth? (
		sys-boot/plymouth
	)
	sddm? (
		x11-misc/sddm
		~liri-base/fluid-1.2.0_p9999
		~liri-base/shell-0.9.0_p9999
		|| (
			virtual/freedesktop-icon-theme
			x11-themes/paper-icon-theme
			x11-themes/papirus-icon-theme
		)
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=dev-util/cmake-3.10.0
	virtual/pkgconfig
	~liri-base/cmake-shared-2.0.0_p9999
"
SRC_URI=""
EGIT_BRANCH="develop"
EGIT_REPO_URI="https://github.com/lirios/${PN}.git"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

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

change_icon_theme() {
einfo
einfo "Set LIRI_THEMES_DEFAULT_ICON_THEME to change the icon theme.  See"
einfo "metadata.xml or \`epkginfo -x ${CATEGORY}/${PN}\` for details."
einfo
	if [[ -n "${LIRI_THEMES_DEFAULT_ICON_THEME}" ]] ; then
einfo
einfo "Using the ${LIRI_THEMES_DEFAULT_ICON_THEME} icon theme as the default"
einfo
		sed -i -e "s|Paper|${LIRI_THEMES_DEFAULT_ICON_THEME}|g" \
			sddm/theme.conf \
			|| die
	elif has_version "x11-themes/paper-icon-theme" ; then
einfo
einfo "Using the Paper icon theme as the default" # Upstream default but EOL
einfo
	elif has_version "x11-themes/papirus-icon-theme" ; then
einfo
einfo "Using the Papirus icon theme as the default" # Similar look
einfo
		sed -i -e "s|Paper|Papirus|g" \
			sddm/theme.conf \
			|| die
	else
		local icon_theme=$(ls -1 "${ESYSROOT}/usr/share/icons" \
			| head -n 1)
		sed -i -e "s|Paper|${icon_theme}|g" \
			sddm/theme.conf \
			|| die
		einfo "Using the ${icon_theme} icon theme as the default"
	fi
}

src_configure() {
	use sddm && change_icon_theme
	local mycmakeargs=(
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
		-DINSTALL_PLUGINSDIR=/usr/$(get_libdir)/qt5/plugins
		-DINSTALL_QMLDIR=/usr/$(get_libdir)/qt5/qml
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	if ! use grub ; then
		rm -rf "${ED}/usr/boot" || die
	fi
	if ! use plymouth ; then
		rm -rf "${ED}/usr/share/plymouth" || die
	fi
	if ! use sddm ; then
		rm -rf "${ED}//usr/share/sddm" || die
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
