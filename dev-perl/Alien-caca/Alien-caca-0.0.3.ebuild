# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LIBCACA_PV_VENDORED="0.99.beta20"
DIST_AUTHOR="YANICK"

FILE_SHAREDIR_PV="1.3"

CHKL_TIMESTAMPS=(
	"dev-libs/glib-2.89.9999"
	"x11-libs/libX11-9999"
)

inherit cflags-hardened chkl sandbox-changes secure-version perl-module

DESCRIPTION="Alien package for the Colored ASCII Art library"
HOMEPAGE="
https://github.com/yanick/Alien-caca
"
LICENSE="
	!system-libcaca? (
		WTFPL-2
	)
	|| (
		GPL-1+
		Artistic
	)
"
SLOT="0"
KEYWORDS="~amd64"
IUSE+="
system-libcaca
ebuild_revision_7
"
REQUIRED_USE="
	system-libcaca
"
RESTRICT="mirror"
RDEPEND_LIBCACA+="
	>=dev-libs/glib-${GLIB_PV}:=
	>=media-libs/freeglut-${FREEGLUT_PV}:=
	media-libs/glu:=
	media-libs/imlib2:=
	>=media-libs/libglvnd-${LIBGLVND_PV}:=
	sys-devel/gcc:=
	>=sys-libs/ncurses-${NCURSES_PV}:=
	>=sys-libs/slang-${SLANG_PV}:=
	>=virtual/zlib-${ZLIB_PV}:=
	>=x11-libs/libX11-${LIBX11_PV}:=
	>=x11-libs/pango-${PANGO_PV}:=
	virtual/libc
"
RDEPEND+="
	$(secure-version_gen_perl_depends)
	>=dev-perl/Alien-Build-0.5
	>=dev-perl/File-ShareDir-${FILE_SHAREDIR_PV}
	!system-libcaca? (
		${RDEPEND_LIBCACA}
	)
	system-libcaca? (
		>=media-libs/libcaca-${LIBCACA_PV}:=
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND_LIBCACA+="
	dev-util/pkgconf
	sys-devel/gcc:=
"
BDEPEND+="
	$(secure-version_gen_perl_depends)
	>=dev-perl/Alien-Base-ModuleBuild-0.5
	>=dev-perl/File-ShareDir-${FILE_SHAREDIR_PV}
	>=dev-perl/YAML-Tiny-1.67
	>=virtual/perl-ExtUtils-MakeMaker-6.59
	dev-perl/Module-Build
	virtual/perl-CPAN
	!system-libcaca? (
		${BDEPEND_LIBCACA}
	)
"
SRC_URI+="
https://github.com/cacalabs/libcaca/commit/d33a9ca2b7e9f32483c1aee4c3944c56206d456b.patch
	-> libcaca-pr66-d33a9ca.patch
"
PATCHES+=(
	"${FILESDIR}/Alien-caca-0.0.3-fix-CVE-2022-0856.patch"
)

pkg_setup() {
	if ! use system-libcaca ; then
		sandbox-changes_no_network_sandbox "To download micropackages"
	fi
}

src_prepare() {
	# Fix vulnerabilities
	sed -i -e "s|v0.99.beta19.tar.gz|v${LIBCACA_PV_VENDORED}.tar.gz|" \
		"Build.PL" \
		|| die
	sed -i -e "s|\"make\"|\"make V=1\"|g" \
		"Build.PL" \
		|| die
	perl-module_src_prepare
}

src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	perl-module_src_configure
}

# OILEDMACHINE-OVERLAY-META:  created-ebuild
# OILEDMACHINE-OVERLAY-TEST:  PASSED 0.0.3 (20230621)
# USE="test"
# All tests successful.
# Files=2, Tests=2,  1 wallclock secs ( 0.03 usr  0.01 sys +  0.51 cusr  0.05 csys =  0.60 CPU)
# Result: PASS
