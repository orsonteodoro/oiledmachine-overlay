# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

#inherit

DESCRIPTION="A small, fast, JavaScript-based JavaScript parser"
HOMEPAGE="https://github.com/acornjs/acorn"
SRC_URI="https://registry.npmjs.org/${PN}/-/${PN}-${PV}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~ia64 ~mips ~ppc64 ~riscv ~s390 ~sparc ~amd64-linux ~sparc64-solaris"
IUSE=""

RDEPEND="net-libs/nodejs[npm]"
DEPEND="${RDEPEND}"

src_unpack() {
	mkdir -p "${S}" || die
}

src_install() {
	npm install -g --prefix "${ED}/usr" "${DISTDIR}/${PN}-${PV}.tgz" || die
	einfo "Sanitizing file permissions and ownership"
	local x
	for x in $(find "${ED}") ; do
		local raw_x="${x}"
		x="${x/${ED}}"
		[[ ! -e "${x}" ]] && continue
		fperms u=rwX,go=rX "${x}"
		fowners root:root "${x}"
	done
}
