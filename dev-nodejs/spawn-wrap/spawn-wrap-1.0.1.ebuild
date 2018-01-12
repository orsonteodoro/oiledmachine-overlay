# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_HAS_TEST="1"
NODE_MODULE_EXTRA_FILES="shim.js t.js"
NODE_MODULE_DEPEND="signal-exit:2.0.0 mkdirp:0.5.0 foreground-child:1.2.0 rimraf:2.3.3"

inherit node-module

DESCRIPTION="Wrap all spawned Node.js child processes"

LICENSE="ISC"
KEYWORDS="~amd64 ~x86"

DEPEND="${DEPEND}
	test? ( dev-util/tap:0 )"
DOCS=( README.md notes.md TODO.md )

node_module_run_test() {
	install_node_module_build_depend "tap:0"
	tap test/*.js || die "Tests failed"
}
