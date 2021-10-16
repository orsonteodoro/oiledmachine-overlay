# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PATCH_VER="1"

inherit toolchain

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND=""
BDEPEND="${CATEGORY}/binutils"

src_prepare() {
	if ! use vanilla && [[ -z "${DISABLE_LTO1_WPA_MEM_RESERVATION}" \
		|| ( -n "${DISABLE_LTO1_WPA_MEM_RESERVATION}" \
			&& "${DISABLE_LTO1_WPA_MEM_RESERVATION}" == "0" ) ]] ; then
		eapply "${FILESDIR}/gcc-11.2.0-reduce-lto1-wpa-by-1.patch"
	fi

	fix_param_max_lto_streaming_parallelism
	toolchain_src_prepare
}
