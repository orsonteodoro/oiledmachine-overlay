# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="graceful-fs:1.2.0 inherits:1.0.0 minimatch:0.2.11"

inherit node-module

DESCRIPTION="A little globber"

SRC_URI="https://github.com/isaacs/node-glob/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE="examples"
S="${WORKDIR}/node-glob-${PV}"

DOCS=( README.md )

src_install() {
	node-module_src_install
	use examples && dodoc -r examples
}
