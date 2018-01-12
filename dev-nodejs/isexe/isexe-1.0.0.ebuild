# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_EXTRA_FILES="access.js mode.js windows.js"
NODE_MODULE_HAS_TEST="1"
NODE_MODULE_TEST_DEPEND="mkdirp:0.5.1 rimraf:2.5.0 tap:5.0.1"

inherit node-module

DESCRIPTION="Minimal module to check if a file is executable"

LICENSE="ISC"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
DEPEND="${DEPEND}
	test? ( dev-util/tap:0 )"

node_module_run_test() {
	install_node_module_build_depend "tap:0"
	tap test || die "Tests failed"
}
