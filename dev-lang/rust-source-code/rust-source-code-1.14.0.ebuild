# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils versionator

if [[ ${PV} = *beta* ]]; then
        betaver=${PV//*beta}
        BETA_SNAPSHOT="${betaver:0:4}-${betaver:4:2}-${betaver:6:2}"
        MY_P="rustc-beta"
        SLOT="beta/${PV}"
        SRC="${BETA_SNAPSHOT}/rustc-beta-src.tar.gz"
        KEYWORDS=""
else
    	ABI_VER="$(get_version_component_range 1-2)"
        SLOT="stable/${ABI_VER}"
        MY_P="rustc-${PV}"
        SRC="${MY_P}-src.tar.gz"
        KEYWORDS="~amd64 ~x86"
fi


DESCRIPTION="The Rust programming language source code for use for ycmd code completion."
HOMEPAGE=""
SRC_URI="https://static.rust-lang.org/dist/${SRC} -> rustc-${PV}-src.tar.gz"

LICENSE="|| ( MIT Apache-2.0 ) BSD-1 BSD-2 BSD-4 UoI-NCSA"
SLOT="${PV}"
IUSE=""
RESTRICT="binchecks strip"

S="${WORKDIR}/rustc-${PV}"

src_prepare() {
	eapply_user
}

src_configure() {
	true
}

src_compile() {
	true
}

src_install() {
	mkdir -p "${D}/usr/share/rust"
	cp -a src "${D}/usr/share/rust"
}
