# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.6"
NODE_MODULE_HAS_TEST="1"
NODE_MODULE_TEST_DEPEND="inline-source-map:0.3.1 tap:0.4.13"

inherit node-module

DESCRIPTION="Converts a source-map from/to different formats"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"

DEPEND="${DEPEND}
	test? ( dev-util/tap:0 )"
DOCS=( README.md )

src_install() {
	node-module_src_install
	use examples && dodoc -r example
}

node_module_run_test() {
	install_node_module_build_depend "tap:0"
	tap test || die "Tests failed"
}
