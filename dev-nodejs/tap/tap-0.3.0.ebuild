# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="inherits yamlish slide runforcover:0.0.2 nopt:2.0.0 mkdirp:0.3 difflet:0.2.0 deep-equal:0.0.0 buffer-equal:0.0.0"
NODE_MODULE_EXTRA_FILES="bin node_modules"

inherit node-module

DESCRIPTION="A Test-Anything-Protocol library"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DOCS=( AUTHORS README.md )

src_install() {
	node-module_src_install
	use examples && dodoc -r example coverage-example
}
