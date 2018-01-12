# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.4.0"
NODE_MODULE_EXTRA_FILES="completion.sh.hbs"
NODE_MODULE_DEPEND="camelcase:1.0.2 cliui:2.1.0 decamelize:1.0.0 window-size:0.1.0"
NODE_MODULE_TEST_DEPEND="chai:2.2.0 coveralls:2.11.2 hashish:0.0.4 mocha:2.2.1 mocha-lcov-reporter:0.0.2 mocoverage:1.0.0 patched-blanket:1.0.1 standard:3.6.0"

inherit node-module

RDEPEND="${RDEPEND}"

DESCRIPTION="Yargs the modern, pirate-themed, successor to optimist"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md CHANGELOG.md )

src_prepare() {
	eapply_user
}

src_install() {
	node-module_src_install
}
