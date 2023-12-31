# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="PLICEASE"
DIST_VERSION="2.08"
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION=""
HOMEPAGE="
https://pl.atypus.org
https://github.com/PerlFFI/FFI-Platypus
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
CAPTURE_TINY_PV="0"
EXTUTILS_MAKEMAKER_PV="7.12"
JSON_PP_PV="0"
PERL_PV="5.8.4"
RDEPEND+="
	>=dev-lang/perl-${PERL_PV}
	>=dev-perl/Capture-Tiny-${CAPTURE_TINY_PV}
	>=dev-perl/FFI-CheckLib-0.5
	>=dev-perl/PathTools-0
	>=virtual/perl-ExtUtils-MakeMaker-${EXTUTILS_MAKEMAKER_PV}
	>=virtual/perl-JSON-PP-${JSON_PP_PV}
	>=virtual/perl-Scalar-List-Utils-1.45
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-lang/perl-${PERL_PV}
	>=dev-perl/Alien-FFI-0.20
	>=dev-perl/Capture-Tiny-${CAPTURE_TINY_PV}
	>=dev-perl/Test2-Suite-0.0.121
	>=dev-perl/YAML-Tiny-1.73
	>=perl-core/Test-Simple-1.302.15
	>=virtual/perl-ExtUtils-CBuilder-0
	>=virtual/perl-ExtUtils-MakeMaker-${EXTUTILS_MAKEMAKER_PV}
	>=virtual/perl-ExtUtils-ParseXS-3.30
	>=virtual/perl-JSON-PP-${JSON_PP_PV}
	virtual/perl-CPAN
"

# OILEDMACHINE-OVERLAY-META:  created-ebuild
# OILEDMACHINE-OVERLAY-TEST:  PASSED 2.8 (20230621)
# All tests successful.
# Files=72, Tests=317,  8 wallclock secs ( 0.75 usr  0.09 sys + 23.80 cusr  2.63 csys = 27.27 CPU)
# Result: PASS
