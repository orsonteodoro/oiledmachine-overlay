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
PYTHON_COMPAT=( python{3_3,3_4,3_5,3_6,3_7} )
EGIT_COMMIT="8831a0f2a14480085e1fcf1e4af4bfc76de8d59f"
SRC_URI=\
"https://github.com/vagnum08/cpupower-gui/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
SLOT="0"
DISTUTILS_SINGLE_IMPL="1"
inherit distutils-r1
RDEPEND="dev-libs/glib
	 dev-python/dbus-python[${PYTHON_USEDEP}]
	 dev-python/pygobject[${PYTHON_USEDEP}]
	 x11-libs/gtk+:3
	 sys-auth/polkit"
DEPEND="${RDEPEND}"
RESTRICT="mirror"
inherit distutils-r1 eutils meson
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

src_prepare() {
	default
	python-single-r1_pkg_setup
}

src_configure() {
	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install
}
