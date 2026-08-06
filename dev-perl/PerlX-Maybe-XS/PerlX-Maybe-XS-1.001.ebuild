# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="TOBYINK"
inherit secure-version perl-module

DESCRIPTION="XS backend for PerlX::Maybe"
HOMEPAGE="
https://metacpan.org/release/PerlX-Maybe-XS
https://github.com/tobyink/p5-perlx-maybe-xs
"
LICENSE="
	|| (
		GPL-1+
		Artistic
	)
"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"
RDEPEND+="
	$(secure-version_gen_perl_depends)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(secure-version_gen_perl_depends)
	>=virtual/perl-ExtUtils-MakeMaker-6.17
	virtual/perl-CPAN
"
PDEPEND+="
	>=dev-perl/PerlX-Maybe-0
"

# OILEDMACHINE-OVERLAY-META:  created-ebuild
# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.001 (20230620)
# USE="test"
# All tests successful.
# Files=3, Tests=5,  1 wallclock secs ( 0.03 usr  0.00 sys +  0.31 cusr  0.03 csys =  0.37 CPU)
# Result: PASS
