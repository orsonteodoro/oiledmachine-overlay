# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.4"
NODE_MODULE_DEPEND="object-keys:0.4.0"
NODE_MODULE_EXTRA_FILES="mutable.js has-keys.js"
NODE_MODULE_HAS_TEST="1"
NODE_MODULE_TEST_DEPEND="tape:1.1.0"

inherit node-module

DESCRIPTION="Extend like a boss"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
DEPEND="${DEPEND}
	test? ( dev-util/tap:0 )"

src_compile() { :; }

node_module_run_test() {
	tap test.js || die "Tests failed"
}
