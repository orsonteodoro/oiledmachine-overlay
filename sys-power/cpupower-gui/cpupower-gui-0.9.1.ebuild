# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See configure.ac for versioning
EAPI=7
DESCRIPTION="This program is designed to allow you to change the frequency \
limits of your cpu and its governor. The application is similar in \
functionality to cpupower."
HOMEPAGE="https://github.com/vagnum08/cpupower-gui"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
PYTHON_COMPAT=( python3_{6,7,8,9} )
SLOT="0"
inherit python-r1
LANGS=(el_GR en en_GB hu nl zh_CN)
IUSE="${LANGS[@]/#/l10n_} +l10n_en"
RDEPEND="${PYTHON_DEPS}
	 dev-libs/glib
	 dev-python/dbus-python[${PYTHON_USEDEP}]
	 >=dev-python/pygobject-3.30[${PYTHON_USEDEP}]
	 x11-libs/gtk+:3
	 sys-auth/polkit"
DEPEND="${RDEPEND}"
RESTRICT="mirror"
inherit eutils meson xdg-utils
SRC_URI=\
"https://github.com/vagnum08/cpupower-gui/archive/v${PV}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"

src_prepare() {
	default
	python_setup
}

src_configure() {
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
		sed -i -e "s|#!${T}/${EPYTHON}/bin/python3|#!/usr/bin/${EPYTHON}|g" \
			"${f}" || die
	done
}

pkg_postinst() {
	xdg_icon_cache_update
}
