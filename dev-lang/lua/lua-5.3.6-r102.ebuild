# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CFLAGS_HARDENED_USE_CASES="language-runtime untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BO HO TC"
UOPTS_SUPPORT_EBOLT=0
UOPTS_SUPPORT_EPGO=0
UOPTS_SUPPORT_TBOLT=0
UOPTS_SUPPORT_TPGO=1

inherit autotools cflags-hardened portability toolchain-funcs uopts

# Tarballs are produced from ${PV} branches in
# https://gitweb.gentoo.org/proj/lua-patches.git
KEYWORDS="~amd64 ~arm ~arm64 ~s390 ~x86"
SRC_URI="
	https://dev.gentoo.org/~soap/distfiles/${P}.tar.xz
"

DESCRIPTION="A powerful light-weight programming language designed for \
extending applications"
HOMEPAGE="https://www.lua.org/"
LICENSE="MIT"
SLOT="5.3"
IUSE="
+deprecated readline static-libs test
ebuild_revision_12
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
	dev-build/libtool
"
RDEPEND="
	${COMMON_DEPEND}
"
BDEPEND="
	virtual/pkgconfig
"
PATCHES=(
)

pkg_setup() {
	uopts_setup
}

src_prepare() {
	default

	if use elibc_musl; then
		# locales on musl are non-functional (#834153)
		# https://wiki.musl-libc.org/open-issues.html#Locale-limitations
		sed -i \
			-e 's|os.setlocale("pt_BR") or os.setlocale("ptb")|false|g' \
			"tests/literals.lua" \
			|| die
	fi

	uopts_src_prepare
}

src_configure() { :; }

_src_configure_compiler() {
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	export CPP=$(tc-getCPP)
}

_src_configure() {
	uopts_src_configure
	if tc-is-gcc && [[ "${PGO_PHASE}" == "PGO" ]] ; then
		append-flags -Wno-error=coverage-mismatch
	fi
	use deprecated && append-cppflags -DLUA_COMPAT_5_1 -DLUA_COMPAT_5_2
	cflags-hardened_append
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
	ls "${S}/tests/"*".lua" || die
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
