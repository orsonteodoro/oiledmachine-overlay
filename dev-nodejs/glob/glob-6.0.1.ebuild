# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_EXTRA_FILES="common.js sync.js oh-my-glob.gif"
NODE_MODULE_DEPEND="inflight:1.0.4 inherits:2.0.0 minimatch:2.0.1 once:1.3.0 path-is-absolute:1.0.0"

inherit node-module

DESCRIPTION="A little globber"

SRC_URI="https://github.com/isaacs/node-glob/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="ISC"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}/node-glob-${PV}"
IUSE="examples"

DOCS=( README.md CONTRIBUTING.md )

src_install() {
	node-module_src_install
	use examples && dodoc -r examples
}
