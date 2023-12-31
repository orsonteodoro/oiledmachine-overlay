# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
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
# Alien-Build-Git-0.10 is override by ebuild for sed patch below
BDEPEND+="
	>=dev-lang/perl-${PERL_PV}
	>=dev-perl/Alien-Build-${ALIEN_BUILD_PV}
	>=dev-perl/Alien-Build-Git-0.10
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

src_prepare() {
	local f
	for f in $(grep -F -r -l -e "Alien::Build::Plugin::Download::GitHub" ./) ; do
einfo "Editing ${f}"
		sed -i -e "s|Alien::Build::Plugin::Download::GitHub|Alien::Build::Plugin::Download::Git|g" \
			"${f}" \
			|| die
	done
einfo "Editing alienfile"
	sed -i -e "s|Download::GitHub|Download::Git|g" \
		"alienfile" \
		|| die
	perl-module_src_prepare
}

# OILEDMACHINE-OVERLAY-META:  created-ebuild
# OILEDMACHINE-OVERLAY-TEST:  PASSED 0.27 (20230621)
# All tests successful.
# Files=2, Tests=4,  4 wallclock secs ( 0.04 usr  0.01 sys +  1.34 cusr  0.21 csys =  1.60 CPU)
# Result: PASS
