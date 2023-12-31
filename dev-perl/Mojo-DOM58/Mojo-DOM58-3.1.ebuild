# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="DBOOK"
DIST_VERSION="3.001"
DIST_EXAMPLES=("example/*")
inherit perl-module

DESCRIPTION="Minimalistic HTML/XML DOM parser with CSS selectors"
HOMEPAGE="
https://github.com/Grinnz/Mojo-DOM58
"
LICENSE="
	Artistic-2
"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
RESTRICT="mirror"
PERL_PV="5.8.1"
RDEPEND+="
	>=dev-lang/perl-${PERL_PV}
	>=virtual/perl-Scalar-List-Utils-0
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-lang/perl-${PERL_PV}
	>=dev-perl/YAML-Tiny-1.73
	>=virtual/perl-ExtUtils-MakeMaker-0
	>=virtual/perl-JSON-PP-0
	virtual/perl-CPAN
"

# OILEDMACHINE-OVERLAY-META:  created-ebuild
# OILEDMACHINE-OVERLAY-TEST:  PASSED 3.1 (20230620)
# USE="test -examples"
# All tests successful.
# Files=5, Tests=155,  1 wallclock secs ( 0.25 usr  0.02 sys +  2.11 cusr  0.12 csys =  2.50 CPU)
# Result: PASS
