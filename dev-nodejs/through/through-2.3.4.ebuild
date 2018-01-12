# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_HAS_TEST="1"
NODE_MODULE_TEST_DEPEND="tape:0.2.2 stream-spec:0.3.5"

inherit node-module

DESCRIPTION="Simplified stream construction"

LICENSE="MIT Apache-2.0"
KEYWORDS="~amd64 ~x86"

DOCS=( readme.markdown )
DEPEND="${DEPEND}
	test? ( dev-util/tap:0 )"

node_module_run_test() {
	tap test || die "Tests failed"
}
