# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
PYPI_PN=${PN//-/.}
PYTHON_COMPAT=( pypy3_11 python3_{11..14} python3_{13,14}t )
ZIG_SLOT="0.15"

inherit distutils-r1 pypi

DESCRIPTION="C-based reader/scanner and emitter for dev-python/ruamel-yaml"
HOMEPAGE="
	https://pypi.org/project/ruamel.yaml.clibz/
	https://sourceforge.net/projects/ruamel-yaml-clibz/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

BDEPEND="
	>=dev-python/setuptools-80.9.0[${PYTHON_USEDEP}]
	>=dev-python/setuptools-zig-0.5.1[${PYTHON_USEDEP}]
	|| (
		(
			dev-lang/zig:${ZIG_SLOT}
			dev-lang/zig:=
		)
		(
			dev-lang/zig-bin:${ZIG_SLOT}
			dev-lang/zig-bin:=
		)
	)
"

python_configure() {
	if has_version "dev-lang/zig-bin:${ZIG_SLOT}" ; then
		PATH=$(realpath "/opt/zig-bin-${ZIG_SLOT}"*)":${PATH}"
	fi
	if has_version "dev-lang/zig:${ZIG_SLOT}" ; then
		PATH=$(realpath "/usr/$(get_libdir)/zig/${ZIG_SLOT}"*"/bin")":${PATH}"
	fi
	local zig_slot=$(zig version | cut -f 1-2 -d ".")
	if ver_test "${zig_slot}" "-ne" "${ZIG_SLOT}" ; then
eerror "The Zig SLOT is not compatible."
eerror "Expected zig SLOT:  ${ZIG_SLOT}"
eerror "Actual zig SLOT:  ${zig_slot}"
		die
	fi
einfo "Zig SLOT:  ${zig_slot}"
}

src_configure() {
	distutils-r1_src_configure
}
