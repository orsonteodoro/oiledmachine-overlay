# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="YANICK"
inherit perl-module

DESCRIPTION="A perl interface for libcaca (Colour AsCii Art library)"
HOMEPAGE="
http://search.cpan.org/dist/Term-Caca
https://github.com/yanick/Term-Caca/tree/master
"
LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
RESTRICT="mirror"
PERL_PV="5.20"
RDEPEND+="
	>=dev-lang/perl-${PERL_PV}
	>=dev-perl/Alien-caca-0
	>=dev-perl/Exporter-Tiny-0
	>=dev-perl/FFI-Platypus-0.88
	>=dev-perl/List-MoreUtils-0
	>=dev-perl/Moo-0
	>=dev-perl/MooseX-MungeHas-0
	>=dev-perl/Path-Tiny-0
	>=virtual/perl-Carp-0
	>=virtual/perl-Scalar-List-Utils-0
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-lang/perl-${PERL_PV}
	>=dev-perl/Test-Exception-0
	>=dev-perl/YAML-Tiny-1.68
	>=virtual/perl-ExtUtils-MakeMaker-0
	virtual/perl-CPAN
"

# OILEDMACHINE-OVERLAY-META:  created-ebuild
# OILEDMACHINE-OVERLAY-TEST:  PASSED 3.1.0 (20230621)
# All tests successful.
# Files=5, Tests=33,  8 wallclock secs ( 0.04 usr  0.00 sys +  3.02 cusr  0.30 csys =  3.36 CPU)
# Result: PASS
