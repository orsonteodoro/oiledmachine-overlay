# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="TOBYINK"
DIST_VERSION="0.011"
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="munge your \"has\" (works with Moo, Moose and Mouse)"
HOMEPAGE="
https://metacpan.org/release/MooseX-MungeHas
https://github.com/tobyink/p5-moosex-mungehas
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
PERL_PV="5.8.0"
RDEPEND+="
	>=dev-lang/perl-${PERL_PV}
	>=virtual/perl-Scalar-List-Utils-1.40
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-lang/perl-${PERL_PV}
	>=dev-perl/Test-Fatal-0
	>=dev-perl/Test-Requires-0.6
	>=virtual/perl-CPAN-Meta-YAML-0.18
	>=virtual/perl-ExtUtils-MakeMaker-6.17
	virtual/perl-CPAN
"

# OILEDMACHINE-OVERLAY-META:  created-ebuild
# OILEDMACHINE-OVERLAY-TEST:  PASSED 0.11 (20230620)
# USE="test -examples"
# All tests successful.
# Files=9, Tests=4,  1 wallclock secs ( 0.05 usr  0.01 sys +  0.89 cusr  0.10 csys =  1.05 CPU)
# Result: PASS
