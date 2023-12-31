# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="TOBYINK"
inherit perl-module

DESCRIPTION="return a pair only if they are both defined"
HOMEPAGE="
https://metacpan.org/release/PerlX-Maybe
https://github.com/tobyink/p5-perlx-maybe
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
PERL_PV="5.6.0"
RDEPEND+="
	>=dev-lang/perl-${PERL_PV}
	>=dev-perl/Exporter-Tiny-0
	>=dev-perl/PerlX-Maybe-XS-0
	>=virtual/perl-Scalar-List-Utils-0
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-lang/perl-${PERL_PV}
	>=virtual/perl-CPAN-Meta-YAML-0.018
	>=virtual/perl-ExtUtils-MakeMaker-6.17
	virtual/perl-CPAN
"

# OILEDMACHINE-OVERLAY-META:  created-ebuild
# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.202 (20230620)
# USE="test"
# All tests successful.
# Files=5, Tests=11,  1 wallclock secs ( 0.04 usr  0.01 sys +  0.51 cusr  0.06 csys =  0.62 CPU)
# Result: PASS
