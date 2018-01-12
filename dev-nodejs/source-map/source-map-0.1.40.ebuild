# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.8.0"
NODE_MODULE_DEPEND="amdefine:1.0.0"
NODE_MODULE_HAS_TEST="1"

inherit node-module

DESCRIPTION="Generates and consumes source maps"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md CHANGELOG.md )

node_module_run_test() {
	node test/run-tests.js || die "Tests failed"
}
