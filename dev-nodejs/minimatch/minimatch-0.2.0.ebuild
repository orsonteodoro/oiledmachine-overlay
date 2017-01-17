# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

NODE_MODULE_DEPEND="
	lru-cache:1.0.5"
NODE_MODULE_HAS_TEST="1"

inherit node-module

DESCRIPTION="A glob matcher in javascript"

LICENSE="ISC"
KEYWORDS="~amd64 ~x86"

RESTRICT="test" # Broken

DOCS=( README.md )

node_module_run_test() {
	install_node_module_build_depend "tap:0"
	tap test || die "Tests failed"
}
