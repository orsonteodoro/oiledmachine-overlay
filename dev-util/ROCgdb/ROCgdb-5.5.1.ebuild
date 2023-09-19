# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=16
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
	local rocm_path="/usr/$(get_libdir)/rocm/${ROCM_SLOT}"
	local myconf=(
		--enable-targets="${CHOST},amdgcn-amd-amdhsa"
		--enable-64-bit-bfd
		--enable-tui
		--datadir="${EPREFIX}${rocm_path}/share"
		--datarootdir="${EPREFIX}${rocm_path}/share"
		--disable-gas
		--disable-gdbserver
		--disable-gdbtk
		--disable-gprofng
		--disable-ld
		--disable-sim
		--disable-shared
		--infodir="${EPREFIX}${rocm_path}/share/info"
		--localedir="${EPREFIX}${rocm_path}/share/locale"
		--mandir="${EPREFIX}${rocm_path}/share/man"
		--program-prefix=roc
		--prefix="${EPREFIX}${rocm_path}"
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
		"/usr/$(get_libdir)/ROCgdb/bin/rocgcore"
		"/usr/$(get_libdir)/ROCgdb/bin/rocstrip"
		"/usr/$(get_libdir)/ROCgdb/bin/rocgprof"
		"/usr/$(get_libdir)/ROCgdb/bin/rocnm"
		"/usr/$(get_libdir)/ROCgdb/bin/rocranlib"
		"/usr/$(get_libdir)/ROCgdb/bin/rocc++filt"
		"/usr/$(get_libdir)/ROCgdb/bin/rocobjdump"
		"/usr/$(get_libdir)/ROCgdb/bin/rocsize"
		"/usr/$(get_libdir)/ROCgdb/bin/rocar"
		"/usr/$(get_libdir)/ROCgdb/bin/rocobjcopy"
		"/usr/$(get_libdir)/ROCgdb/bin/rocaddr2line"
		"/usr/$(get_libdir)/ROCgdb/bin/rocelfedit"
		"/usr/$(get_libdir)/ROCgdb/bin/rocreadelf"
		"/usr/$(get_libdir)/ROCgdb/bin/rocstrings"
		"/usr/$(get_libdir)/ROCgdb/bin/rocgdb-add-index"
		"/usr/$(get_libdir)/ROCgdb/bin/rocgdb"
	)
	local path
	for path in ${L[@]} ; do
		local bn=$(basename "${path}")
		dosym "${EPREFIX}/${path}" "/usr/bin/${bn}"
	done
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
