# Copyright 2019 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

HOMEPAGE="https://rocm.github.io/"
LICENSE=""
RESTRICT="fetch"

inherit unpacker

KEYWORDS="~amd64 ~x86"

pkg_setup() {
        kernel-2_pkg_setup
	ot-kernel-common_pkg_setup
}

src_unpack() {
	ot-kernel-common_src_unpack
}

src_compile() {
	ot-kernel-common_src_compile
}

src_install() {
	ot-kernel-common_src_install
	kernel-2_src_install
}

pkg_postinst() {
	kernel-2_pkg_postinst
	ot-kernel-common_pkg_postinst
}

pkg_postrm() {
	ot-kernel-common_pkg_postrm
}

