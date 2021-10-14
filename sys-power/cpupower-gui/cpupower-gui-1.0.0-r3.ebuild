# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See configure.ac for versioning
EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit eutils meson python-r1 xdg-utils

DESCRIPTION="This program is designed to allow you to change the frequency \
limits of your cpu and its governor. The application is similar in \
functionality to cpupower."
HOMEPAGE="https://github.com/vagnum08/cpupower-gui"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0"
LANGS=(el_GR en en_GB hu it nl zh_CN)
IUSE+=" ${LANGS[@]/#/l10n_} +l10n_en -libexec -pkla"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
# See README.md for dependencies
RDEPEND+=" ${PYTHON_DEPS}
	 dev-libs/glib:2
	 dev-libs/libappindicator:3
	 dev-python/dbus-python[${PYTHON_USEDEP}]
	 >=dev-python/pygobject-3.30[${PYTHON_USEDEP}]
	   dev-python/pyxdg
	 >=gui-libs/libhandy-1
	 sys-auth/polkit
	 x11-libs/gtk+:3
	 x11-themes/hicolor-icon-theme"
DEPEND+=" ${RDEPEND}
	dev-libs/glib:2"
BDEPEND+=" ${PYTHON_DEPS}
	>=dev-util/meson-0.50
	dev-util/ninja
	virtual/pkgconfig"
RESTRICT="mirror"
SRC_URI="
https://github.com/vagnum08/cpupower-gui/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"
CPUPOWER_GUI_SYSTEMD_SYSTEM_DIR=${CPUPOWER_GUI_SYSTEMD_SYSTEM_DIR:="/usr/lib/systemd"}

pkg_setup() {
	einfo "See \`epkginfo -du cpupower-gui\` for details on setting up this package."
}

src_prepare() {
	default
	python_setup
}

src_configure() {
	local emesonargs=(
		$(meson_use pkla)
		$(meson_use libexec)
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
}
