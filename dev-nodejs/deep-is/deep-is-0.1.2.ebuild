# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_HAS_TEST="1"
NODE_MODULE_TEST_DEPEND="tape:1.0.2"

inherit node-module

DESCRIPTION="Node's assert.deepEqual algorithm except for NaN being equal to NaN"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="test examples"

DEPEND="${DEPEND}
	test? ( dev-util/tap:0 )"
DOCS=( README.markdown )

src_install() {
	node-module_src_install
	use examples && dodoc -r example
}

node_module_run_test() {
	tap test || die "Tests failed"
}
