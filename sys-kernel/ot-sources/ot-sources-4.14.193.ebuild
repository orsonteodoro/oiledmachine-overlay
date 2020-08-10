# Copyright 2019-2020 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

K_GENPATCHES_VER="201"

# Not supported by the Gentoo crew
K_SECURITY_UNSUPPORTED="1"

inherit ot-kernel-v4.14

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
