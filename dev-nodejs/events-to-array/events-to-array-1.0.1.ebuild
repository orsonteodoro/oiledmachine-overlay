# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_EXTRA_FILES="etoa.js"
NODE_MODULE_HAS_TEST="1"

inherit node-module

DESCRIPTION="Put a bunch of emitted events in an array, for testing"

LICENSE="ISC"
KEYWORDS="~amd64 ~x86"

DEPEND="${DEPEND}
	test? ( dev-util/tap:0 )"
DOCS=( README.md )

node_module_run_test() {
	install_node_module_build_depend "tap:0"
	tap test || die "Tests failed"
}
