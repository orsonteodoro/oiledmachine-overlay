# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.4.0"
NODE_MODULE_HAS_TEST="1"
NODE_MODULE_DEPEND="deep-equal:0.0.0
	charm:0.0.1
	traverse:0.6.6"
NODE_MODULE_TEST_DEPEND="ent:0.0.7 tap:0.1.0"

inherit node-module

DESCRIPTION="Colorful diffs for javascript objects"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"

DEPEND="${DEPEND}
	test? ( dev-util/tap:0 )"
DOCS=( README.markdown )

src_install() {
	node-module_src_install
	use examples && dodoc -r example
}

node_module_run_test() {
	install_node_module_build_depend "tap:0"
	tap test || die "Tests failed"
}
