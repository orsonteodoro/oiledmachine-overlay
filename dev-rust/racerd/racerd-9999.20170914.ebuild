# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="libracerd"
HOMEPAGE=""
COMMIT="dc090ea11d550cd513416d21227d558dbfd2fcb6"
SRC_URI="https://github.com/jwilm/racerd/archive/${COMMIT}.zip -> ${P}.zip"
RESTRICT="mirror"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/rust"
DEPEND="${RDEPEND}
        dev-util/cargo"

S="${WORKDIR}/${PN}-${COMMIT}"

src_unpack() {
	unpack ${A}
}

src_compile() {
	cargo install
}

src_prepare() {
	default

	eapply_user
}

