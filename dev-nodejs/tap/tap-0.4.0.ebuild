# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

#glob:3.2.14 doesn't exist
NODE_MODULE_DEPEND="inherits:2.0.3 yamlish:0.0.7 slide:1.1.6 runforcover:0.0.2 nopt:2.0.0 mkdirp:0.3.0 difflet:0.2.0 deep-equal:0.0.0 buffer-equal:0.0.0 glob:3.2.11"
#inherits yamlish slide -- accept any version
NODE_MODULE_EXTRA_FILES="bin node_modules"

inherit node-module

DESCRIPTION="A Test-Anything-Protocol library"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DOCS=( AUTHORS README.md )

src_prepare() {
	default
	#delete packages and use the system ones
	rm -rf node_modules/*
}

src_install() {
	node-module_src_install
	install_node_module_binary "bin/${PN}.js" "/usr/local/bin/${PN}-${SLOT}"
	use examples && dodoc -r example coverage-example
}
