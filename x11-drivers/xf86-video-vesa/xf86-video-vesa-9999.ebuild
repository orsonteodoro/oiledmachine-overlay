# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FALLBACK_COMMIT="de217f8e8fd11ea07279036b112601a912293333" # Sep 13, 2026

inherit linux-info secure-version xorg-3

KEYWORDS="-* ~alpha amd64 x86"

DESCRIPTION="Generic VESA video driver"
IUSE+=" ebuild_revision_3"

pkg_pretend() {
	linux-info_pkg_setup

	if ! linux_config_exists || ! linux_chkconfig_present DEVMEM; then
		echo
		ewarn "This driver requires /dev/mem support in your kernel"
		ewarn "  Device Drivers --->"
		ewarn "    Character devices  --->"
		ewarn "      [*] /dev/mem virtual device support"
		echo
	fi
}
