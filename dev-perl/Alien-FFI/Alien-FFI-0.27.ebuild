# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="PLICEASE"
DIST_VERSION="0.27"
inherit perl-module

DESCRIPTION="Build and make available libffi"
HOMEPAGE="
https://metacpan.org/pod/Alien::FFI
https://github.com/PerlFFI
"
LICENSE="
	|| (
		GPL-1+
		Artistic
	)
"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
RESTRICT="mirror"
ALIEN_BUILD_PV="2.10"
PERL_PV="5.6"
RDEPEND+="
	>=dev-lang/perl-${PERL_PV}
	>=dev-perl/Alien-Build-${ALIEN_BUILD_PV}
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-lang/perl-${PERL_PV}
	>=dev-perl/Alien-Build-${ALIEN_BUILD_PV}
	>=dev-perl/Alien-Build-Git-0.9
	>=dev-perl/Capture-Tiny-0
	>=dev-perl/IO-Socket-SSL-1.56
	>=dev-perl/Mojo-DOM58-1.0
	>=dev-perl/Mozilla-CA-0
	>=dev-perl/Net-SSLeay-1.49
	>=dev-perl/Test2-Suite-0.0.121
	>=dev-perl/URI-0
	>=dev-perl/YAML-Tiny-1.73
	>=virtual/perl-ExtUtils-MakeMaker-6.52
	virtual/perl-CPAN
"

# OILEDMACHINE-OVERLAY-META:  created-ebuild
# OILEDMACHINE-OVERLAY-TEST:  (20230620)
