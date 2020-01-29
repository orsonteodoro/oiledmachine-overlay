# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="object code file converted (COFF, ELF, OMF, MACHO)"
HOMEPAGE="http://agner.org/optimize/#objconv"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
IUSE="doc"
BDEPEND="app-arch/unzip"
inherit toolchain-funcs unpacker
SRC_URI="https://www.agner.org/optimize/objconv.zip -> ${P}.zip"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
DOCS=( ../objconv-instructions.pdf )

src_unpack() {
	unpacker_src_unpack
	mkdir "${S}" || die
	cd "${S}" || die
	unpack_zip ../source.zip
}

src_prepare() {
	default
	local sources=$(echo *.cpp)
	cat "${FILESDIR}/Makefile" \
		| sed -e "s|SOURCES_LIST|${sources//.cpp/.o}|g" > Makefile
	tc-export CXX
}

src_install() {
	dobin objconv
}
