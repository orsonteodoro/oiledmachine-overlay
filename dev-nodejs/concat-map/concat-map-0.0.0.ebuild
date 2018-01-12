# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_HAS_TEST="1"
NODE_MODULE_TEST_DEPEND="tap:0.2.5"

inherit node-module

DESCRIPTION="Concatenative mapdashery"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"

DOCS=( README.markdown )
DEPEND="${DEPEND}
	test? ( dev-util/tap:0 )"

src_install() {
	node-module_src_install
	use examples && dodoc -r example
}

node_module_run_test() {
	tap test || die "Tests failed"
}
