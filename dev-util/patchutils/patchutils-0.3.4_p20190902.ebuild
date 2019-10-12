# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A collection of tools that operate on patch files"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sh sparc x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
HOMEPAGE="http://cyberelk.net/tim/patchutils/"
SLOT="0"
IUSE="test"
# testsuite makes use of gendiff(1) that comes from rpm, thus if the user wants
# to run tests, it should install that package as well.
DEPEND="test? ( app-arch/rpm )"
EGIT_COMMIT="d6d4eb252d2c6f3445e31f1050cfd8afcca3a3be"
SRC_URI="https://github.com/twaugh/patchutils/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"
inherit autotools
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

src_prepare() {
	default
	eautoreconf
}

src_test() {
	# See bug 605952.
	make check || die
}
