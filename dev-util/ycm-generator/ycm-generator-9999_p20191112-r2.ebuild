# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Generates config files for YouCompleteMe"
HOMEPAGE="https://github.com/rdnetto/YCM-Generator"

# Live ebuilds don't get KEYWORDed

LICENSE="GPL-3"
SLOT="0"
PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1
IUSE="autotools cmake qt5"
RDEPEND="sys-devel/clang
	autotools? ( sys-devel/make )
	cmake? ( dev-util/cmake )
	qt5? ( dev-qt/qtcore:5 )"
DEPEND="dev-python/future[${PYTHON_USEDEP}]"
EGIT_COMMIT="7c0f5701130f4178cb63d10da88578b9b705fbb1"
SRC_URI="\
https://github.com/rdnetto/YCM-Generator/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
inherit eutils python-utils-r1
S="${WORKDIR}/YCM-Generator-${EGIT_COMMIT}"
RESTRICT="mirror"

src_prepare() {
	default
	futurize -0 -v -w "${S}" || die
	sed -i -e "s|#!/usr/bin/env python2|#!/usr/bin/env python|" \
		config_gen.py || die
	python_copy_sources
}

src_compile() {
	:;
}

src_install() {
	python_install_impl() {
		python_moduleinto "${PN}"
		python_domodule *.py fake-toolchain plugin
		fperms 755 \
		"$(python_get_sitedir)/${PN}/fake-toolchain/Unix"/{cc,cxx,true} \
		"$(python_get_sitedir)/${PN}/config_gen.py"
		dodir "/usr/lib/python-exec/${EPYTHON}"
		dosym "$(python_get_sitedir)/${PN}/config_gen.py" \
			"/usr/lib/python-exec/${EPYTHON}/config_gen.py"
	}
	python_foreach_impl python_install_impl
	dosym "/usr/lib/python-exec/python-exec2" \
		"/usr/bin/config_gen.py"
}
