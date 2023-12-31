# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Redirect from Alien::Build::Plugin::Download::Git

DIST_AUTHOR="PLICEASE"
DIST_NAME="Alien-Build-Git"
DIST_VERSION="0.10"
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Alien::Build tools for interacting with git"
HOMEPAGE="
https://metacpan.org/pod/Alien::Build::Git
https://github.com/PerlAlien/Alien-Build-Git
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
ALIEN_BUILD_PV="0.65"
PERL_PV="5.8.1"
FILE_WHICH_PV="0"
RDEPEND+="
	>=dev-lang/perl-${PERL_PV}
	>=dev-perl/Alien-Build-${ALIEN_BUILD_PV}
	>=dev-perl/Capture-Tiny-0
	>=dev-perl/File-chdir-0
	>=dev-perl/File-Which-${FILE_WHICH_PV}
	>=dev-perl/Path-Tiny-0
	>=dev-perl/PerlX-Maybe-0.3
	>=dev-perl/PerlX-Maybe-XS-0
	>=dev-perl/URI-0
	>=dev-perl/URI-git-0
	>=perl-core/File-Temp-0
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-lang/perl-${PERL_PV}
	>=dev-perl/Alien-Build-${ALIEN_BUILD_PV}
	>=dev-perl/File-Which-${FILE_WHICH_PV}
	>=dev-perl/Test2-Suite-0.0.121
	>=dev-perl/Test2-Tools-URL-0.2
	>=dev-perl/YAML-Tiny-1.73
	>=virtual/perl-ExtUtils-MakeMaker-0
	virtual/perl-CPAN
"

# OILEDMACHINE-OVERLAY-META:  created-ebuild
# OILEDMACHINE-OVERLAY-TEST:  PASSED 0.10 (20230620)
# USE="test -examples"
# All tests successful.
# Files=6, Tests=18,  2 wallclock secs ( 0.05 usr  0.00 sys +  2.35 cusr  0.30 csys =  2.70 CPU)
# Result: PASS
