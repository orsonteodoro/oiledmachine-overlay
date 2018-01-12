# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_HAS_TEST="1"
NODE_MODULE_DEPEND="readable-stream:1.0.26"
NODE_MODULE_TEST_DEPEND="tape:2.12.3 hash_file:0.1.1 faucet:0.1.1 brtapsauce:0.3.0"

inherit node-module

DESCRIPTION="Buffer List: Collect buffers, access with a standard readable Buffer interface"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DEPEND="${DEPEND}
	test? ( dev-util/tap:0 )"
DOCS=( README.md )

node_module_run_test() {
	sed -i "s/\/tmp\///g" test/*.js || die # Fix sandbox violation
	tap test || die "Tests failed"
}

