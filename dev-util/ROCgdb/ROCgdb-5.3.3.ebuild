# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=15
PYTHON_COMPAT=( python3_{10..12} )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit llvm python-single-r1 rocm

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ROCm-Developer-Tools/ROCgdb/"
	inherit git-r3
else
	SRC_URI="
https://github.com/ROCm-Developer-Tools/ROCgdb/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-rocm-${PV}"
fi

DESCRIPTION=""
HOMEPAGE="
https://rocm.docs.amd.com/projects/ROCgdb/en/latest/
https://github.com/ROCm-Developer-Tools/ROCgdb
"
LICENSE="GPL-3+ LGPL-2.1+"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="system-llvm r1"
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
	app-alternatives/lex
	app-alternatives/sh
	app-alternatives/yacc
	dev-util/rocm-compiler[system-llvm=]
	sys-apps/texinfo
	sys-devel/automake
	sys-devel/make
"
PATCHES=(
	"${FILESDIR}/${PN}-5.1.3-path-changes.patch"
)
DOCS=( README-ROCM.md )

pkg_setup() {
	llvm_pkg_setup
	python-single-r1_pkg_setup
	rocm_pkg_setup
}

src_prepare() {
	default
	PATCH_PATHS=(
		"${S}/gdb/configure"
		"${S}/gdb/configure.ac"
		"${S}/gdb/testsuite/lib/rocm.exp"
	)
	rocm_src_prepare
}

src_configure() {
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
	local L=(
		"${EROCM_PATH}/$(get_libdir)/ROCgdb/bin/rocgcore"
		"${EROCM_PATH}/$(get_libdir)/ROCgdb/bin/rocstrip"
		"${EROCM_PATH}/$(get_libdir)/ROCgdb/bin/rocgprof"
		"${EROCM_PATH}/$(get_libdir)/ROCgdb/bin/rocnm"
		"${EROCM_PATH}/$(get_libdir)/ROCgdb/bin/rocranlib"
		"${EROCM_PATH}/$(get_libdir)/ROCgdb/bin/rocc++filt"
		"${EROCM_PATH}/$(get_libdir)/ROCgdb/bin/rocobjdump"
		"${EROCM_PATH}/$(get_libdir)/ROCgdb/bin/rocsize"
		"${EROCM_PATH}/$(get_libdir)/ROCgdb/bin/rocar"
		"${EROCM_PATH}/$(get_libdir)/ROCgdb/bin/rocobjcopy"
		"${EROCM_PATH}/$(get_libdir)/ROCgdb/bin/rocaddr2line"
		"${EROCM_PATH}/$(get_libdir)/ROCgdb/bin/rocelfedit"
		"${EROCM_PATH}/$(get_libdir)/ROCgdb/bin/rocreadelf"
		"${EROCM_PATH}/$(get_libdir)/ROCgdb/bin/rocstrings"
		"${EROCM_PATH}/$(get_libdir)/ROCgdb/bin/rocgdb-add-index"
		"${EROCM_PATH}/$(get_libdir)/ROCgdb/bin/rocgdb"
	)
	local path
	for path in ${L[@]} ; do
		local bn=$(basename "${path}")
		dosym "${EPREFIX}/${path}" "/usr/bin/${bn}"
	done
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
