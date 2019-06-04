# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

DESCRIPTION="Emoji on the command line"
HOMEPAGE="https://github.com/mrowa44/emojify"
COMMIT="f561dab22eed075d2d4c0d5053ac74ff0712633d"
SRC_URI="https://github.com/mrowa44/emojify/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="doc"

RDEPEND="app-shells/bash"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${PN}-${COMMIT}"

src_install() {
	mkdir -p "${D}/usr/bin"
	cp "${S}/emojify" "${D}"/usr/bin/
	if use doc ; then
		mkdir -p "${D}/usr/share/${PN}"
		cp -a "README.md" "${D}"/usr/share/${PN}/
	fi
}
