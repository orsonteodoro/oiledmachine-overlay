# Copyright 2022-2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for Linux kernel sources"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="custom-kernel firmware"

RDEPEND="
	firmware? (
		sys-kernel/linux-firmware
	)
!custom-kernel? (
	|| (
		sys-kernel/gentoo-sources
		sys-kernel/vanilla-sources
		sys-kernel/git-sources
		sys-kernel/mips-sources
		sys-kernel/pf-sources
		sys-kernel/rt-sources
		sys-kernel/zen-sources
		sys-kernel/raspberrypi-sources
		sys-kernel/gentoo-kernel
		sys-kernel/gentoo-kernel-bin
		sys-kernel/vanilla-kernel
		sys-kernel/linux-next
		sys-kernel/asahi-sources
	)
)
"

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  anti-vendor-lock-in, customization, crap-kernels
