# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="YANICK"
inherit perl-module

DESCRIPTION="Alien package for the Colored ASCII Art library"
HOMEPAGE="
https://github.com/yanick/Alien-caca
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
PERL_PV="5.6"
FILE_SHAREDIR_PV="1.3"
RDEPEND+="
	>=dev-lang/perl-${PERL_PV}
	>=dev-perl/Alien-Build-0.5
	>=dev-perl/File-ShareDir-${FILE_SHAREDIR_PV}
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-lang/perl-${PERL_PV}
	>=dev-perl/Alien-Base-ModuleBuild-0.5
	>=dev-perl/File-ShareDir-${FILE_SHAREDIR_PV}
	>=dev-perl/YAML-Tiny-1.67
	>=virtual/perl-ExtUtils-MakeMaker-6.59
	dev-perl/Module-Build
	virtual/perl-CPAN
"

# OILEDMACHINE-OVERLAY-META:  created-ebuild
# OILEDMACHINE-OVERLAY-TEST:  (20230620)

check_network_sandbox() {
	if has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package"
eerror "env to be able to download micropackages."
eerror
		die
	fi
}

pkg_setup() {
	check_network_sandbox
	perl-module_pkg_setup
}

# OILEDMACHINE-OVERLAY-META:  created-ebuild
# OILEDMACHINE-OVERLAY-TEST:  PASSED 0.0.3 (20230620)
# All tests successful.
# Files=2, Tests=2,  1 wallclock secs ( 0.03 usr  0.01 sys +  0.51 cusr  0.05 csys =  0.60 CPU)
# Result: PASS
