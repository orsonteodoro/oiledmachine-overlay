# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Encode/decode WOFF2 font format"
HOMEPAGE="https://github.com/google/woff2"
LICENSE="MIT"
KEYWORDS="~alpha amd64 ~amd64-linux ~arm arm64 ~ia64 ~ppc ~ppc64 ~s390 ~sparc \
~x64-macos ~x64-solaris x86 ~x86-linux ~x86-macos"
SLOT="0"
inherit cmake-multilib
RDEPEND="app-arch/brotli[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig[${MULTILIB_USEDEP}]"
SRC_URI=\
"https://github.com/google/${PN}/archive/v${PV}.tar.gz \
	-> ${P}.tar.gz"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON # needed, causes QA warnings otherwise
		-DCANONICAL_PREFIXES=ON #661942
	)
	cmake-multilib_src_configure
}
