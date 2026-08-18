# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
LLVM_SLOT=22
PYTHON_COMPAT=( "python3_"{10..13} )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

CHKL_TIMESTAMPS=(
	"app-arch/xz-utils-9999"
	"app-arch/zstd-9999"
	"dev-libs/expat-9999"
	"sys-libs/readline-9999"
)

inherit cflags-hardened check-compiler-switch chkl flag-o-matic python-single-r1 secure-version rocm

if [[ "${PV}" == *"9999" ]] ; then
	EGIT_REPO_URI="https://github.com/ROCm-Developer-Tools/ROCgdb/"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-rocm-${PV}"
	SRC_URI="
https://github.com/ROCm-Developer-Tools/ROCgdb/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Heterogeneous debugging for x86 and AMDGPU on ROCm™ software"
HOMEPAGE="
https://rocm.docs.amd.com/projects/ROCgdb/en/latest/
https://github.com/ROCm-Developer-Tools/ROCgdb
"
LICENSE="
	(
		all-rights-reserved
		custom
	)
	(
		all-rights-reserved
		GPL-3+
	)
	(
		all-rights-reserved
		MIT
	)
	(
		GPL-3+
		BSD
	)
	(
		GPL-3+
		gcc-runtime-library-exception-3.1
	)
	(
		GPL-3+
		LGPL-2.1+
		UoI-NCSA
		ZLIB
	)
	Boost-1.0
	BSD
	BSD-2
	custom
	FDL-1.3+
	GPL-2+
	GPL-3+
	LGPL-2.1+
	LIBGLOSS
	NEWLIB
	ZLIB
"
# all-rights-reserved custom - gdb/exc_request.defs
# all-rights-reserved GPL-3+ - binutils/dwarf.c
# all-rights-reserved MIT - gdb/testsuite/gdb.rocm/step-schedlock-spurious-waves.cpp
# Boost-1.0 - zlib/contrib/dotzlib/LICENSE_1_0.txt
# BSD - gprof/gprof.h
# BSD - libiberty/strtoul.c
# BSD-2 - ld/elf-hints-local.h
# custom - mkdep
# custom - libiberty/strncasecmp.c
# GPL-2+ - libiberty/cp-demangle.c
# GPL-3+ LGPL-2.1+ UoI-NCSA ZLIB - gdb/NOTICES.txt
# GPL-3+ BSD - gprofng/common/opteron_pcbe.c
# GPL-3+ gcc-runtime-library-exception-3.1 - include/dwarf2.def
# FDL-1.3+ - gdb/doc/python.texi
# LIBGLOSS - COPYING.LIBGLOSS
# NEWLIB - COPYING.NEWLIB
# ZLIB - zlib/contrib/puff/puff.h
# The distro's GPL-3+ license template does not contain all rights reserved.
# The distro's MIT license template does not contain all rights reserved.
SLOT="0/${ROCM_SLOT}"
IUSE="ebuild_revision_15"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"
RDEPEND="
	${PYTHON_DEPS}
	>=app-arch/xz-utils-${XZ_UTILS_PV}:=
	>=app-arch/zstd-${ZSTD_PV}:=
	>=dev-libs/expat-${EXPAT_PV}:=
	>=dev-libs/gmp-${GMP_PV}:=
	>=sys-libs/ncurses-${NCURSES_PV}:=
	>=virtual/zlib-${ZLIB_PV}:=
	dev-libs/mpfr:=
	dev-util/babeltrace:=
	sys-devel/gcc:=
	virtual/libc:=
	~dev-libs/ROCdbgapi-${PV}:=
"
DEPEND="
	${RDEPEND}
	>=sys-libs/readline-${READLINE_PV}:=
"
BDEPEND="
	${ROCM_GCC_DEPEND}
	app-alternatives/lex
	app-alternatives/sh
	app-alternatives/yacc
	sys-apps/texinfo
	dev-build/automake
	dev-build/make
"
PATCHES=(
)
DOCS=( "README-ROCM.md" )

pkg_setup() {
	check-compiler-switch_start
	python-single-r1_pkg_setup
	rocm_pkg_setup
}

src_prepare() {
	default
	rocm_src_prepare
}

src_configure() {
	chkl_check_many_timestamps

	rocm_set_default_gcc

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	cflags-hardened_append

	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if ! check-compiler-switch_is_system_flavor ; then
einfo "Detected GPU compiler switch.  Disabling LTO."
		filter-lto
	fi

	local myconf=(
		--enable-targets="${CHOST},amdgcn-amd-amdhsa"
		--enable-64-bit-bfd
		--enable-tui
		--datadir="${EPREFIX}${EROCM_PATH}/share"
		--datarootdir="${EPREFIX}${EROCM_PATH}/share"
		--disable-gas
		--disable-gdbserver
		--disable-gdbtk
		--disable-gprofng
		--disable-ld
		--disable-sim
		--disable-shared
		--infodir="${EPREFIX}${EROCM_PATH}/share/info"
		--libdir="${EPREFIX}${EROCM_PATH}/$(rocm_get_libdir)"
		--localedir="${EPREFIX}${EROCM_PATH}/share/locale"
		--mandir="${EPREFIX}${EROCM_PATH}/share/man"
		--program-prefix=roc
		--prefix="${EPREFIX}${EROCM_PATH}"
		--with-babeltrace
		--with-expat
		--with-lzma
		--with-python="${PYTHON}"
		--with-system-zlib
		--without-guile
	)
	econf "${myconf[@]}"
}

src_install() {
	emake V=1 DESTDIR="${D}" install
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs test
