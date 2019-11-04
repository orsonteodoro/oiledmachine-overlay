# Copyright 1999-2019 Gentoo Authors
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
EGIT_COMMIT="4d739105fcb8ae20417804d74936a2e8fb81bf65"
SRC_URI=\
"https://github.com/vagnum08/cpupower-gui/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
SLOT="0"
RDEPEND="dev-libs/glib
	 dev-python/pygobject
	 x11-libs/gtk+:3
	 sys-auth/polkit"
DEPEND="${RDEPEND}"
RESTRICT="mirror"
inherit autotools distutils-r1 eutils
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

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
