# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit eutils distutils-r1 python-utils-r1 python-r1

DESCRIPTION="Generates config files for YouCompleteMe"
HOMEPAGE=""
COMMIT="4d92151f0b29afadacdd3a6c90e5a449afc34bb1"
SRC_URI="https://github.com/rdnetto/YCM-Generator/archive/${COMMIT}.zip -> ${P}.zip"
KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-3"

IUSE=""
REQUIRED_USE=""

COMMON_DEPEND="
	${PYTHON_DEPS}
	|| ( dev-util/ycmd app-vim/youcompleteme )
"
RDEPEND="
	${COMMON_DEPEND}
"
DEPEND="
	${COMMON_DEPEND}
"

S="${WORKDIR}/YCM-Generator-${COMMIT}"

src_prepare() {
	eapply "${FILESDIR}/${PN}-9999-20160820-shebang.patch"

	eapply_user

	python_copy_sources
}

src_compile() {
	true
}

src_install() {
        inst() {
                mkdir -p "${D}/$(python_get_sitedir)"
                cp -a *.py "${D}/$(python_get_sitedir)"
		python_domodule fake-toolchain
		chmod 755 "${D}/$(python_get_sitedir)/fake-toolchain/Unix"/*
		python_domodule plugin
        }

	python_foreach_impl inst

        link() {
                mkdir -p "${D}/usr/lib/python-exec/${EPYTHON}"
                ln -s "$(python_get_sitedir)/config_gen.py" "${D}/usr/lib/python-exec/${EPYTHON}/config_gen.py"
        }

	python_foreach_impl link

        mkdir -p "${D}/usr/bin/"
        ln -s "${D}/usr/lib/python-exec/python-exec2" "${D}/usr/bin/config_gen.py"



}


