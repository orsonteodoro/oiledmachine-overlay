# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.10.0"
NODE_MODULE_DEPEND="arr-diff:1.0.1 braces:1.8.0 debug:2.1.3 expand-brackets:0.1.1 filename-regex:2.0.0 is-glob:1.1.3 kind-of:1.1.0 parse-glob:3.0.0 regex-cache:0.4.0"
NODE_MODULE_TEST_DEPEND="benchmarked:0.1.3 browserify:9.0.3 chalk:1.0.0 minimatch:2.0.1 minimist:1.1.0 mocha:2.1.0 multimatch:2.0.0 should:5.0.1 write:0.1.1"

inherit node-module

RDEPEND="${RDEPEND}
	dev-nodejs/object-omit:0.2.1"

DESCRIPTION="Glob matching for javascript/node.js"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

src_install() {
	node-module_src_install
	install_node_module_depend "object.omit:0.2.1"
}
