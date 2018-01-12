# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_HAS_TEST="1"
NODE_MODULE_DEPEND="cross-spawn-async:2.1.1 signal-exit:2.0.0 which:1.2.1"
NODE_MODULE_EXTRA_FILES="appveyor.yml"

inherit node-module

DESCRIPTION="Run a child as if it's the foreground process. Give it stdio. Exit when it exits"

LICENSE="ISC"
KEYWORDS="~amd64 ~x86"

DEPEND="${DEPEND}
	test? ( dev-util/tap:0 )"
DOCS=( README.md )

node_module_run_test() {
	install_node_module_build_depend "tap:0"
	tap test || die "Tests failed"
}
