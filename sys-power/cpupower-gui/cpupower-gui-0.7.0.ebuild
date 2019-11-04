# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="This program is designed to allow you to change the frequency \
limits of your cpu and its governor. The application is similar in \
functionality to cpupower."
HOMEPAGE="https://github.com/vagnum08/cpupower-gui"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
PYTHON_COMPAT=( python{3_3,3_4,3_5,3_6,3_7} )
SRC_URI=\
"https://github.com/vagnum08/cpupower-gui/archive/v${PV}.tar.gz \
	-> ${P}.tar.gz"
SLOT="0"
RDEPEND="dev-libs/glib
	 dev-python/pygobject
	 x11-libs/gtk+:3
	 sys-auth/polkit"
DEPEND="${RDEPEND}"
inherit autotools distutils-r1 eutils
RESTRICT="mirror"
S="${WORKDIR}/${PN}-${PV}"

src_prepare() {
	default
	eautoreconf
	python_copy_sources
	python_foreach_impl python_prepare_patches
}

src_configure() {
	python_configure() {
		econf
	}
	python_foreach_impl python_configure
}

src_compile() {
	python_compile() {
		emake
	}
	python_foreach_impl python_compile
}

src_install() {
	python_install() {
		emake DESTDIR="${D}" install
	}
	python_foreach_impl python_install
}
