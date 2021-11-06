# Copyright 2021 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Corresponds to gcc-11.2.0.ebuild on the gentoo-overlay

EAPI="7"

PATCH_VER="1"

inherit toolchain

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND=""
BDEPEND="${CATEGORY}/binutils"

src_prepare() {
	if use experimental ; then
		if [[ -z "${GCC_SEM_WPA_PATCH}" \
		|| ( -n "${GCC_SEM_WPA_PATCH}" && "${GCC_SEM_WPA_PATCH}" == "1" ) ]] ; then
			ewarn
			ewarn "The GCC_SEM_WPA_PATCH is in testing.  Manual removal of"
			ewarn "/dev/shm/sem.gcc-lto-wpa when Ctrl+C is used may be required."
			ewarn
			ewarn "It is not necessary to apply this patch if the machine already has 2 GiB"
			ewarn "per core.  GCC_SEM_WPA_PATCH=0 envvar may be supplied to disable it."
			ewarn
			eapply "${FILESDIR}/gcc-11.2.0-sem-limit-wpa-per-cpu.patch"
		fi
	fi

	fix_param_max_lto_streaming_parallelism
	toolchain_src_prepare
}
