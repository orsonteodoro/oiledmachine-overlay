# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit cmake multilib-minimal python-any-r1

DESCRIPTION="a small C library for x86 CPU detection and feature extraction"
HOMEPAGE="http://libcpuid.sourceforge.net/"
LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc test"
BDEPEND+="
	doc? ( app-doc/doxygen )
	test? ( ${PYTHON_DEPS} )
"
SRC_URI="
https://github.com/anrieff/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
PATCHES=(
	"${FILESDIR}/${PN}-0.5.0-cmake-customize-libdir.patch"
)

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	configure_abi() {
	        local mycmakeargs=(
			-DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/$(get_libdir)"
		)
		cmake_src_configure
	}
	multilib_foreach_abi configure_abi
}

src_compile() {
	compile_abi() {
		cmake_src_compile
	}
	multilib_foreach_abi compile_abi
}

src_test() {
	test_abi() {
		if use test ; then
			./cpuid_tool/cpuid_tool
			${EPYTHON} tests/create_test.py raw.txt report.txt > mfg.test
			${EPYTHON} tests/run_tests.py ./cpuid_tool/cpuid_tool \
				mfg.test 2>&1 > result.txt
			grep -F -e "All successfull!" result.txt
		fi
	}
	multilib_foreach_abi test_abi
}

src_install() {
	install_abi() {
		cmake_src_install
		multilib_check_headers
	}
	multilib_foreach_abi install_abi
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  ebuild, multilib
