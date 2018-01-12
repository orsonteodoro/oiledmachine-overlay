# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_HAS_TEST="1"
NODE_MODULE_TEST_DEPEND="tape:1.1.1"

inherit node-module

DESCRIPTION="Match balanced character pairs, like \"{\" and \"}\""

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"

DEPEND="${DEPEND}
	test? ( dev-util/tap:0 )"
DOCS=( README.md )

src_compile() { :; }

src_install() {
	node-module_src_install
	use examples && dodoc example.js
}

node_module_run_test() {
	tap test || die "Tests failed"
}
