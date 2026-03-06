# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# D12, U22, U24

POSTGRES_COMPAT=( {14..19} )
POSTGRES_USEDEP="server"

inherit postgres-multi

SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="Open-source vector similarity search for Postgres"
HOMEPAGE="https://github.com/pgvector/pgvector"
LICENSE="POSTGRESQL"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs"
REQUIRED_USE="${POSTGRES_REQ_USE}"
RDEPEND="
	${POSTGRES_DEP}
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	eapply_user
	postgres-multi_src_prepare
}

src_compile() {
	postgres-multi_foreach emake
}

src_install() {
	postgres-multi_foreach emake DESTDIR="${D}" install

	use static-libs || find "${ED}" -name '*.a' -delete
}
