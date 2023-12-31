# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LIBCACA_PV="0.99.beta20"
DIST_AUTHOR="YANICK"
inherit perl-module

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
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE+=" system-libcaca r5"
RESTRICT="mirror"
PERL_PV="5.6"
FILE_SHAREDIR_PV="1.3"
RDEPEND_LIBCACA+="
	dev-libs/glib:2
	media-libs/freeglut
	media-libs/glu
	media-libs/imlib2
	media-libs/libglvnd
	sys-devel/gcc
	sys-libs/ncurses
	sys-libs/slang
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/pango
	virtual/libc
"
RDEPEND+="
	!system-libcaca? (
		${RDEPEND_LIBCACA}
	)
	>=dev-lang/perl-${PERL_PV}
	>=dev-perl/Alien-Build-0.5
	>=dev-perl/File-ShareDir-${FILE_SHAREDIR_PV}
	system-libcaca? (
		|| (
			~media-libs/libcaca-0.99_beta20_p20211207
			~media-libs/libcaca-0.99_beta20
		)
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND_LIBCACA+="
	dev-util/pkgconf
	sys-devel/gcc
"
BDEPEND+="
	!system-libcaca? (
		${BDEPEND_LIBCACA}
	)
	>=dev-lang/perl-${PERL_PV}
	>=dev-perl/Alien-Base-ModuleBuild-0.5
	>=dev-perl/File-ShareDir-${FILE_SHAREDIR_PV}
	>=dev-perl/YAML-Tiny-1.67
	>=virtual/perl-ExtUtils-MakeMaker-6.59
	dev-perl/Module-Build
	virtual/perl-CPAN
"
SRC_URI+="
https://github.com/cacalabs/libcaca/commit/d33a9ca2b7e9f32483c1aee4c3944c56206d456b.patch
	-> libcaca-pr66-d33a9ca.patch
"
PATCHES+=(
	"${FILESDIR}/Alien-caca-0.0.3-fix-CVE-2022-0856.patch"
)

check_network_sandbox() {
	if has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package"
eerror "env to be able to download micropackages."
eerror
		die
	fi
}

pkg_setup() {
	if ! use system-libcaca ; then
		check_network_sandbox
	fi
}

src_prepare() {
	# Fix vulnerabilities
	sed -i -e "s|v0.99.beta19.tar.gz|v${LIBCACA_PV}.tar.gz|" \
		"Build.PL" \
		|| die
	sed -i -e "s|\"make\"|\"make V=1\"|g" \
		"Build.PL" \
		|| die
	perl-module_src_prepare
}

# OILEDMACHINE-OVERLAY-META:  created-ebuild
# OILEDMACHINE-OVERLAY-TEST:  PASSED 0.0.3 (20230621)
# USE="test"
# All tests successful.
# Files=2, Tests=2,  1 wallclock secs ( 0.03 usr  0.01 sys +  0.51 cusr  0.05 csys =  0.60 CPU)
# Result: PASS
