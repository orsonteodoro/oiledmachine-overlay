# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="is-glob:1.1.1"
NODE_MODULE_HAS_TEST="1"
NODE_MODULE_TEST_DEPEND="coveralls:2.11.2 istanbul:0.3.5 mocha:2.1.0"

inherit node-module

DESCRIPTION="Strips glob magic from a string to provide the parent path"

LICENSE="ISC"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
DEPEND="${DEPEND}
	test? ( dev-util/mocha )"

node_module_run_test() {
	mocha || die "Tests failed"
}
