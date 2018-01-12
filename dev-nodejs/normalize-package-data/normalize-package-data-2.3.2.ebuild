# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_HAS_TEST="1"
NODE_MODULE_DEPEND="semver:5.1.0 hosted-git-info:2.0.2 validate-npm-package-license:3.0.1"
NODE_MODULE_TEST_DEPEND="async:0.9.0 underscore:1.4.4 tap:1.1.0"

inherit node-module

DESCRIPTION="Normalizes data that can be found in package.json files"

LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md AUTHORS )
DEPEND="${DEPEND}
	test? ( dev-util/tap:0 )"

node_module_run_test() {
	install_node_module_build_depend "tap:0"
	tap test || die "Tests failed"
}
