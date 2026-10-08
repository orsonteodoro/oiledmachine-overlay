# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FALLBACK_COMMIT="c4ec4b582a48b751a28777419860abf182197c5d" # Aug 12, 2025

inherit udev xorg-3

DESCRIPTION="VMWare mouse input driver"

IUSE+=" ebuild_revision_2"
DEPEND="x11-base/xorg-proto:="

src_configure() {
	local XORG_CONFIGURE_OPTIONS=(
		--with-hal-bin-dir=/punt
		--with-hal-callouts-dir=/punt
		--with-hal-fdi-dir=/punt
		--with-udev-rules-dir=$(get_udevdir)/rules.d
	)
	xorg-3_src_configure
}

src_install() {
	xorg-3_src_install
	rm -r "${ED}"/punt || die
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
