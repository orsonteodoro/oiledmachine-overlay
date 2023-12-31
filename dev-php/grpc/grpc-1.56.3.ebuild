# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="High-performance RPC framework (PHP libraries)"
HOMEPAGE="https://grpc.io"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
RESTRICT="mirror"
RDEPEND+="
	>=dev-lang/php-7
	dev-php/composer
	dev-php/PEAR-PEAR
	~net-libs/grpc-${PV}
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
GRPC_PN="grpc"
GRPC_P="${GRPC_PN}-${PV}"
SRC_URI+="
https://github.com/${GRPC_PN}/${GRPC_PN}/archive/v${MY_PV}.tar.gz
	-> ${GRPC_P}.tar.gz
"
S="${WORKDIR}/${GRPC_P}/src/php"

src_compile() {
	local grpc_root="${WORKDIR}/${GRPC_P}"
	cd "${WORKDIR}/${GRPC_P}/src/php/ext/grpc" || die
	phpize || die
	export GRPC_LIB_SUBDIR="libs/opt"
	econf \
		--enable-grpc="${grpc_root}"
	emake
}

src_install() {
	cd "${WORKDIR}/${GRPC_P}/src/php/ext/grpc" || die
	emake INSTALL_ROOT="${D}" install
}
