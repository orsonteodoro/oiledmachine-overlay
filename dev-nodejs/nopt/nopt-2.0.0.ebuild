#todo
# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="abbrev:1.0.0"
NODE_MODULE_HAS_TEST="1"
NODE_MODULE_EXTRA_FILES="bin"

inherit node-module

DESCRIPTION="Option parsing for Node, supporting types, shorthands, etc."

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"

DOCS=( README.md )
DEPEND="${DEPEND}
	test? ( dev-util/tap:0 )"

src_install() {
	node-module_src_install
	use examples && dodoc -r examples
}

node_module_run_test() {
	install_node_module_build_depend "tap:0"
	tap test || die "Tests failed"
}
