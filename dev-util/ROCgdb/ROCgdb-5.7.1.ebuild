# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=17
PYTHON_COMPAT=( "python3_"{10..12} )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit python-single-r1 rocm

if [[ ${PV} == *9999 ]] ; then
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

DESCRIPTION=""
HOMEPAGE="
https://rocm.docs.amd.com/projects/ROCgdb/en/latest/
https://github.com/ROCm-Developer-Tools/ROCgdb
"
LICENSE="
	GPL-3+
	LGPL-2.1+
"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="ebuild-revision-5"
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
	sys-apps/texinfo
	dev-build/automake
	dev-build/make
"
PATCHES=(
)
DOCS=( "README-ROCM.md" )

pkg_setup() {
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
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
