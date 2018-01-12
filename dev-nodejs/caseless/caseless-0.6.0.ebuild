# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_HAS_TEST="1"
NODE_MODULE_TEST_DEPEND="tape:2.10.2"

inherit node-module

DESCRIPTION="Caseless object set/get/has, very useful when working with HTTP headers"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
DEPEND="${DEPEND}
	test? ( dev-util/tap:0 )"

node_module_run_test() {
	tap test.js || die "Tests failed"
}
