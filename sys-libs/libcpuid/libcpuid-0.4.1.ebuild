# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="a small C library for x86 CPU detection and feature extraction"
HOMEPAGE="http://libcpuid.sourceforge.net/"
LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
IUSE="doc python test"
PYTHON_COMPAT=( python2_7 )
inherit python-single-r1
REQUIRED_USE="test? ( python )
	      python? ( ${PYTHON_REQUIRED_USE} )"
DEPEND="doc? ( app-doc/doxygen )
	python? ( ${PYTHON_DEPS} )"
SRC_URI=\
"https://github.com/anrieff/${PN}/archive/v${PV}.tar.gz \
	-> ${P}.tar.gz"
inherit autotools eutils multilib-minimal
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default
	eautoreconf || die
	multilib_copy_sources
}

multilib_src_configure() {
	econf || die
}

multilib_src_compile() {
	emake || die
}

multilib_src_test() {
	if use test ; then
		./cpuid_tool/cpuid_tool
		${EPYTHON} tests/create_test.py raw.txt report.txt > mfg.test
		${EPYTHON} tests/run_tests.py ./cpuid_tool/cpuid_tool mfg.test 2>&1 > result.txt
		grep -F -e "All successfull!" result.txt
	fi
}

multilib_src_install() {
	emake DESTDIR="${D}" install
}
