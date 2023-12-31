# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="GFUJI"
DIST_VERSION="0.015"
DIST_EXAMPLES=("example/*")
inherit perl-module

DESCRIPTION="Detects unused variables in perl modules"
HOMEPAGE="
https://github.com/houseabsolute/p5-Test-Vars
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
PERL_PV="5.10.0"
RDEPEND+="
	>=dev-lang/perl-${PERL_PV}
	>=virtual/perl-Scalar-List-Utils-1.33
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-lang/perl-${PERL_PV}
	>=dev-perl/Module-Build-Tiny-0.035
	>=dev-perl/Test-Output-0
	>=virtual/perl-CPAN-Meta-YAML-0.18
	>=virtual/perl-ExtUtils-MakeMaker-6.59
	virtual/perl-CPAN
"

# OILEDMACHINE-OVERLAY-META:  created-ebuild
# OILEDMACHINE-OVERLAY-TEST:  PASSED 0.15 (20230620)
# USE="test -examples"
# All tests successful.
# Files=11, Tests=67,  1 wallclock secs ( 0.08 usr  0.02 sys +  1.80 cusr  0.23 csys =  2.13 CPU)
# Result: PASS
