# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_HAS_TEST="1"
NODE_MODULE_DEPEND="color-support:1.1.0 debug:2.1.3 diff:1.3.2 escape-string-regexp:1.0.3 glob:7.0.5 js-yaml:3.3.1 tap-parser:1.0.4 unicode-length:1.0.0"
NODE_MODULE_EXTRA_FILES="both.out fast.js fast.out out.html slow.js slow.out"

inherit node-module

DESCRIPTION="Format a TAP stream using Mocha's set of reporters"

LICENSE="ISC"
KEYWORDS="~amd64 ~x86"

DEPEND="${DEPEND}
	test? ( dev-util/tap:0 )"
DOCS=( README.md )

node_module_run_test() {
	install_node_module_build_depend "tap:0"
	tap test || die "Tests failed"
}
