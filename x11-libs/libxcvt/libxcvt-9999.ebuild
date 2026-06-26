# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See also https://gitlab.freedesktop.org/xorg/lib/libxcvt

inherit xorg-3 meson

if [[ ${PV} == *9999* ]]; then
	FALLBACK_COMMIT="049b79b74a42dfdc5feea6dd9b98256269610935"
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

DESCRIPTION="X.Org xcvt library and cvt program"

# Override xorg-3's src_prepare
src_prepare() {
	default
}
