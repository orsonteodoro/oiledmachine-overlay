# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=18
PYTHON_COMPAT=( "python3_12" )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit check-compiler-switch flag-o-matic python-single-r1 rocm

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
SLOT="${ROCM_SLOT}/${PV}"
IUSE="ebuild_revision_9"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"
RDEPEND="
	${PYTHON_DEPS}
	>=sys-libs/zlib-1.1.4
	app-arch/xz-utils
	app-arch/zstd
	dev-libs/expat
	dev-libs/gmp
	dev-libs/mpfr
	dev-util/babeltrace
	sys-devel/gcc
	sys-libs/ncurses
	virtual/libc
	~dev-libs/ROCdbgapi-${PV}:${ROCM_SLOT}
"
DEPEND="
	${RDEPEND}
	sys-libs/readline
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
	# Speed up symbol replacmenet for @...@ by reducing the search space
	# Generated from below one liner ran in the same folder as this file:
	# grep -F -r -e "+++" | cut -f 2 -d " " | cut -f 1 -d $'\t' | sort | uniq | cut -f 2- -d $'/' | sort | uniq
	PATCH_PATHS=(
		"${S}/gdb/configure" # placeholder
	)
	rocm_src_prepare
}

src_configure() {
	rocm_set_default_gcc

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

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
