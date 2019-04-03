# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_4,3_5,3_6} )

inherit python-single-r1 eutils python-utils-r1

COMMIT="2d0f3522cb8c6c9b71e678a8ec2d0427b1fcccef"
DESCRIPTION="DuckDuckGo from the terminal"
HOMEPAGE="https://github.com/jarun/ddgr"
SRC_URI="https://github.com/jarun/ddgr/archive/${COMMIT}.zip -> ${P}.zip"
LICENSE="GPL-3+"

SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"

IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${PN}-${COMMIT}"

pkg_setup() {
	python_setup
}

src_install() {
	SITEDIR="/usr/$(get_libdir)/${EPYTHON}/site-packages"
	python_scriptinto "${SITEDIR}/${PN}"
	python_doexe ddgr

	mkdir -p "${D}/usr/bin/"
	ln -s "${D}/usr/lib/python-exec/${EPYTHON}/ddgr" "${D}/usr/bin/ddgr"

	doman ddgr.1
}
