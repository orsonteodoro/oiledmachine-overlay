# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Corresponds to gcc-10.3.0-r2.ebuild on the gentoo-overlay

EAPI="7"

PATCH_VER="3"

inherit toolchain

KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND=""
BDEPEND="${CATEGORY}/binutils"

src_prepare() {
	if has_version '>=sys-libs/glibc-2.32-r1'; then
		rm -v "${WORKDIR}/patch/23_all_disable-riscv32-ABIs.patch" || die
	fi

	fix_param_max_lto_streaming_parallelism
	toolchain_src_prepare
}
