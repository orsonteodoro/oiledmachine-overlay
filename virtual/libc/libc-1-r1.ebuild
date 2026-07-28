# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit secure-version

DESCRIPTION="Virtual for the C library"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

# explicitly depend on SLOT 2.2 of glibc, because it sets
# a different SLOT for cross-compiling
RDEPEND="
	!prefix-guest? (
		elibc_glibc? ( >=sys-libs/glibc-${GLIBC_PV}:2.2 )
		elibc_musl? ( >=sys-libs/musl-${MUSL_PV} )
	)
	prefix-guest? (
		!sys-libs/glibc
		!sys-libs/musl
	)"
