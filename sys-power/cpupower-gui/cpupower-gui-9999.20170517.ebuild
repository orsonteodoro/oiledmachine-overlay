# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6
PYTHON_COMPAT=( python{3_3,3_4,3_5} )

inherit eutils autotools distutils-r1

DESCRIPTION="This program is designed to allow you to change the frequency limits of your cpu and its governor. The application is similar in functionality to cpupower."
HOMEPAGE="https://github.com/vagnum08/cpupower-gui"
COMMIT="d326a228c9cee6c5bb778fc8666bad340ac7c0ef"
SRC_URI="https://github.com/vagnum08/cpupower-gui/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${PN}-${COMMIT}"
DOCS=""

RDEPEND="dev-libs/glib
	 dev-python/pygobject
	 x11-libs/gtk+:3
	 sys-auth/polkit"

DEPEND="${RDEPEND}"

src_prepare() {
	eapply_user
	eautoreconf

	python_copy_sources


	python_prepare_patches() {
		sed -i -e "s|python3.6|${EPYTHON}|g" ${S}/bin/cpupower-gui-pkexec.in || die
	}
	python_foreach_impl python_prepare_patches
}

src_configure() {
	python_configure() {
		econf
	}
	python_foreach_impl python_configure
}

src_compile()
{
	python_compile() {
		emake
	}
	python_foreach_impl python_compile
}

src_install()
{
	python_install() {
		emake DESTDIR="${D}" install
	}
	python_foreach_impl python_install
}
