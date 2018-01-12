# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_HAS_TEST="1"
NODE_MODULE_DEPEND="jsonify:0.0.0 deep-equal:0.1.0 defined:0.0.0 through:2.3.4 resumer:0.0.0 stream-combiner:0.0.2 split:0.2.10 inherits:2.0.1"
NODE_MODULE_TEST_DEPEND="falafel:0.1.4 tap:0.3.0"
NODE_MODULE_EXTRA_FILES="bin"

inherit node-module

DESCRIPTION="Tap-producing test harness for node and browsers"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"

DOCS=( readme.markdown )
DEPEND="${DEPEND}
	test? ( dev-util/tap:0.7 )"

src_install() {
	node-module_src_install
	use examples && dodoc -r example
}

node_module_run_test() {
	install_node_module_build_depend "tap:0.7"
	tap-0.7 test/*.js || die "Tests failed"
}
