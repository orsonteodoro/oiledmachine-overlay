# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RDEPEND="${RDEPEND}"

DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"

inherit eutils npm-secaudit versionator

PV_TRIPLE=$(get_version_component_range 1-3 ${PV})
PV_REV=$(get_version_component_range 4- ${PV})
MY_PV="${PV_TRIPLE}-${PV_REV}"

DESCRIPTION="Instagram Direct Messages in your terminal "
HOMEPAGE="https://github.com/mathdroid/igdm-cli"
SRC_URI="https://github.com/mathdroid/${PN}/archive/v${PV_TRIPLE}-${PV_REV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm ~arm64 ~ppc ~ppc64"
IUSE=""

S="${WORKDIR}/${PN}-${MY_PV}"

src_install() {
	npm-secaudit-install "*"

	#create wrapper
	mkdir -p "${D}/usr/bin"
	echo "#!/bin/bash" > "${D}/usr/bin/${PN}"
	echo "/usr/bin/node /usr/$(get_libdir)/node/${PN}/${SLOT}/bin \$*" >> "${D}/usr/bin/${PN}"
	chmod +x "${D}"/usr/bin/${PN}
}
