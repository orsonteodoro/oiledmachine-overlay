# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="PLICEASE"
DIST_VERSION="0.06"
DIST_EXAMPLES=("example/*")
inherit perl-module

DESCRIPTION="Compare a URL in your Test2 test"
HOMEPAGE="
https://metacpan.org/pod/Test2::Tools::URL
https://github.com/uperl/Test2-Tools-URL
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
PERL_PV="5.8.1"
TEST2_SUITE_PV="0.0.121"
RDEPEND+="
	>=dev-lang/perl-${PERL_PV}
	>=dev-perl/Test2-Suite-${TEST2_SUITE_PV}
	>=dev-perl/URI-1.61
	>=virtual/perl-Carp-0
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-lang/perl-${PERL_PV}
	>=dev-perl/Test2-Suite-${TEST2_SUITE_PV}
	>=dev-perl/YAML-Tiny-1.73
	>=virtual/perl-ExtUtils-MakeMaker-0
	virtual/perl-CPAN
"

# OILEDMACHINE-OVERLAY-META:  created-ebuild
# OILEDMACHINE-OVERLAY-TEST:  PASSED 0.6 (20230620)
# USE="test -examples"
# All tests successful.
# Files=3, Tests=27,  1 wallclock secs ( 0.05 usr  0.00 sys +  0.95 cusr  0.08 csys =  1.08 CPU)
# Result: PASS
