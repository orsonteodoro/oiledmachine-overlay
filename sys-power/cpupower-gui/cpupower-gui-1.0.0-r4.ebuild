# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See configure.ac for versioning
EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit meson python-r1 xdg-utils

DESCRIPTION="This program is designed to allow you to change the frequency \
limits of your cpu and its governor. The application is similar in \
functionality to cpupower."
HOMEPAGE="https://github.com/vagnum08/cpupower-gui"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0"
LANGS=( el_GR en en_GB hu it nl zh_CN )
IUSE+="
${LANGS[@]/#/l10n_}
+l10n_en -libexec -pkla wayland X
"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
"
# See README.md for dependencies
RDEPEND+="
	${PYTHON_DEPS}
	>=dev-python/pygobject-3.30[${PYTHON_USEDEP}]
	>=gui-libs/libhandy-1
	dev-libs/glib:2
	dev-libs/libappindicator:3
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	sys-auth/polkit
	x11-libs/gtk+:3[wayland?,X?]
	x11-themes/hicolor-icon-theme
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	>=dev-build/meson-0.50
	dev-util/ninja
	virtual/pkgconfig
"
SRC_URI="
https://github.com/vagnum08/cpupower-gui/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"

pkg_setup() {
	CPUPOWER_GUI_SYSTEMD_SYSTEM_DIR=${CPUPOWER_GUI_SYSTEMD_SYSTEM_DIR:="/usr/lib/systemd"}
	einfo "See \`epkginfo -du cpupower-gui\` for details on setting up this package."
}

src_prepare() {
	default
	python_setup
}

src_configure() {
	# patch positional argument for >=meson-0.60
	sed -i '15d' "$S/data/meson.build"

	local emesonargs=(
		$(meson_use pkla)
		$(meson_use libexec use_libexec)
		-Dsystemddir=${CPUPOWER_GUI_SYSTEMD_SYSTEM_DIR}
	)
	meson_src_configure
	local langs=""
	for l in ${L10N} ; do
		einfo "Adding language ${l}"
		langs+=" ${l}"
	done
	echo "${langs}" > po/LINGUAS || die
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install
	L=$(grep -r -l -e "#!${T}/${EPYTHON}/bin/python3" "${D}")
	for f in ${L} ; do
		einfo "Fixing shebang for ${f}"
		sed -i -e "s|#!${T}/${EPYTHON}/bin/python3|#!/usr/bin/python3|g" \
			"${f}" || die
	done
}

pkg_postinst() {
	xdg_icon_cache_update
einfo
einfo "You may want to use a GUI authentication agent (analog of sudo under"
einfo "desktop environments).  See"
einfo
einfo "  https://wiki.archlinux.org/title/Polkit#Authentication_agents"
einfo
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
