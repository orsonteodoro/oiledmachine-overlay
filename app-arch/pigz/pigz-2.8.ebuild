# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/madler.asc"

inherit toolchain-funcs flag-o-matic multilib-minimal

SRC_URI="
	https://www.zlib.net/pigz/${P}.tar.gz
	verify-sig? (
		https://www.zlib.net/pigz/${P}-sig.txt -> ${P}.tar.gz.asc
	)
"

DESCRIPTION="A parallel implementation of gzip"
HOMEPAGE="https://www.zlib.net/pigz/"
LICENSE="ZLIB"
SLOT="0"
KEYWORDS="
~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86
~amd64-linux ~ppc-macos ~sparc64-solaris
"
IUSE="static symlink test verify-sig"
RESTRICT="!test? ( test )"
LIB_DEPEND="sys-libs/zlib[static-libs(+),${MULTILIB_USEDEP}]"
RDEPEND="
	!static? (
		${LIB_DEPEND//\[static-libs(+)]}
	)
"
DEPEND="
	${RDEPEND}
	static? (
		${LIB_DEPEND}
	)
	test? (
		app-arch/ncompress
	)
"
BDEPEND="
	verify-sig? (
		sec-keys/openpgp-keys-madler
	)
"

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_compile() {
	use static && append-ldflags -static
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

multilib_src_install() {
	if multilib_is_native_abi ; then
		dobin ${PN}
		dosym ${PN} /usr/bin/un${PN}
	else
		newbin ${PN} ${PN}-${ABI}
		dosym ${PN}-${ABI} /usr/bin/un${PN}-${ABI}
	fi
	dodoc README
	doman ${PN}.1

	if use symlink; then
		dosym ${PN} /usr/bin/gzip
		dosym un${PN} /usr/bin/gunzip
	fi
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multilib
