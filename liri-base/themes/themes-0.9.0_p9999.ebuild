# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils git-r3 eutils

DESCRIPTION="Themes for a uniform look and feel throughout Liri OS"
HOMEPAGE="https://github.com/lirios/themes"
LICENSE="GPL-3+ grub? ( GPL-3-with-font-exception OFL-1.1 )"
# Noto fonts is OFL-1.1
# The KDE Oxygen font is || ( OFL-1.1 GPL-3-with-font-exception )

# Live/snapshot do not get KEYWORDS.

SLOT="0/${PV}"
IUSE+=" grub plymouth sddm"
QT_MIN_PV=5.10
DEPEND+="
	grub? ( sys-boot/grub )
	plymouth? ( sys-boot/plymouth )
	sddm? ( ~liri-base/fluid-1.2.0_p9999
		~liri-base/shell-0.9.0_p9999
		 x11-misc/sddm )"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	>=dev-util/cmake-3.10.0
	~liri-base/cmake-shared-2.0.0_p9999
	  virtual/pkgconfig"
SRC_URI=""
EGIT_BRANCH="develop"
EGIT_REPO_URI="https://github.com/lirios/${PN}.git"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
PROPERTIES="live"

src_unpack() {
	git-r3_fetch
	git-r3_checkout
	local v_live=$(grep -r -e "VERSION \"" "${S}/CMakeLists.txt" | head -n 1 | cut -f 2 -d "\"")
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

src_configure() {
	local mycmakeargs=(
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
		-DINSTALL_PLUGINSDIR=/usr/$(get_libdir)/qt5/plugins
		-DINSTALL_QMLDIR=/usr/$(get_libdir)/qt5/qml
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
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
