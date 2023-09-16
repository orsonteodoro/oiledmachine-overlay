# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit portability toolchain-funcs uopts

# Tarballs are produced from ${PV} branches in
# https://gitweb.gentoo.org/proj/lua-patches.git
SRC_URI="
	https://dev.gentoo.org/~soap/distfiles/${P}.tar.xz
"

DESCRIPTION="A powerful light-weight programming language designed for \
extending applications"
HOMEPAGE="https://www.lua.org/"
LICENSE="MIT"
SLOT="5.1"
KEYWORDS="
~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390
sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris
"
IUSE="
+deprecated readline static-libs test
"
REQUIRED_USE="
	pgo? (
		test
	)
"
COMMON_DEPEND="
	!dev-lang/lua:0
	>=app-eselect/eselect-lua-3
	readline? (
		sys-libs/readline:=
	)
"
# Cross-compiling note:
# Must use libtool from the target system (DEPEND) because
# libtool from the build system (BDEPEND) is for building
# native binaries.
DEPEND="
	${COMMON_DEPEND}
	sys-devel/libtool
"
RDEPEND="
	${COMMON_DEPEND}
"
BDEPEND="
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}/${SLOT}"
)

pkg_setup() {
	uopts_setup
}

src_prepare() {
	! use deprecated && PATCHES+=(
		"${FILESDIR}/${PN}-5.1.4-test.patch"
	)

	default

	uopts_src_prepare
}

src_configure() { :; }

_src_configure() {
	uopts_src_configure
	if tc-is-gcc && [[ "${PGO_PHASE}" == "PGO" ]] ; then
		append-flags -Wno-error=coverage-mismatch
	fi
	econf
}

_src_compile() {
	default
}

src_compile() {
	export BUILD_DIR="${S}"
	uopts_src_compile
}

_src_pre_train() {
einfo "Running _src_pre_train"
	emake install DESTDIR="${D}"
	export LD_LIBRARY_PATH="${ED}/usr/$(get_libdir)"
	export PATH_BAK="${PATH}"
	export PATH="${ED}/usr/bin:${PATH}"
}

_src_post_train() {
	rm -rf "${ED}" || die
	unset LD_LIBRARY_PATH
	export PATH="${PATH_BAK}"
}

train_trainer_list() {
	ls "${S}/test/"*".lua" || die
}

train_get_trainer_exe() {
	realpath -e "${ED}/usr/bin/lua${SLOT}" || die
}

train_get_trainer_args() {
	local trainer="${1}"
	echo "${trainer}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
	uopts_src_install
}

pkg_postinst() {
	eselect lua set --if-unset "${PN}${SLOT}"

	if has_version "app-editor/emacs"; then
		if ! has_version "app-emacs/lua-mode"; then
einfo "Install app-emacs/lua-mode for lua support for emacs"
		fi
	fi
	uopts_pkg_postinst
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  allow-static-libs, pgo
