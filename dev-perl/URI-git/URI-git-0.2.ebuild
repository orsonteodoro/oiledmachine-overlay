# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="MIYAGAWA"
DIST_VERSION="0.02"
inherit perl-module

DESCRIPTION="git URI scheme"
HOMEPAGE="
https://github.com/miyagawa/uri-git
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
RDEPEND+="
	>=dev-lang/perl-${PERL_PV}
	>=dev-perl/Filter-0
	>=dev-perl/URI-0
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-lang/perl-${PERL_PV}
	>=virtual/perl-ExtUtils-MakeMaker-6.42
	dev-perl/Module-Install
	virtual/perl-CPAN
"

# OILEDMACHINE-OVERLAY-META:  created-ebuild
# OILEDMACHINE-OVERLAY-TEST:  PASSED 0.2 (20230620)
# USE="test"
# All tests successful.
# Files=2, Tests=3,  0 wallclock secs ( 0.03 usr  0.01 sys +  0.13 cusr  0.01 csys =  0.18 CPU)
# Result: PASS
