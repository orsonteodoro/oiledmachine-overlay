# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT="b59b2d7e489facca1a2b6d8e6f48e14909ecb355"

inherit toolchain-funcs

S="${WORKDIR}/evhz-${COMMIT}"
SRC_URI="https://git.sr.ht/~iank/evhz/archive/${COMMIT}.tar.gz -> ${P}-${COMMIT:0:7}.tar.gz"

DESCRIPTION="Show mouse refresh rate under linux + evdev"
HOMEPAGE="https://git.sr.ht/~iank/evhz"
LICENSE="
	Apache-2.0
	GPL-3+
"
SLOT="0"
KEYWORDS="~amd64"
DEPEND="
	virtual/libc
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	sys-kernel/linux-headers
"
DOCS=( "README.md" )

src_compile() {
	export CC=$(tc-getCC)
	[[ -z "${CC}" ]] && export CC="${CHOST}-gcc"
	${CC} "evhz.c" -o "evhz"
}

src_install() {
	dosbin "evhz"
}
