# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See eclass for implementation

EAPI=6
inherit blender-v2.83

pkg_pretend() {
	blender_pkg_pretend
}

pkg_setup() {
	blender_pkg_setup
}

src_prepare() {
	blender_src_prepare
}

src_configure() {
	blender_src_configure
}

src_compile() {
	blender_src_compile
}

src_install() {
	blender_src_install
}

src_test() {
	blender_src_test
}

pkg_postinst() {
	blender_pkg_postinst
}

pkg_postrm() {
	blender_pkg_postrm
}
