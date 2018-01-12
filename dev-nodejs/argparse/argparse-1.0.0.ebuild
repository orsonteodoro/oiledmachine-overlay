# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="lodash:3.2.0 sprintf-js:1.0.2"
NODE_MODULE_EXTRA_FILES=""

inherit node-module

DESCRIPTION="Very powerful CLI arguments parser. Native port of argparse - python's options parsing library"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DOCS=( CHANGELOG.md README.md )

src_install() {
	node-module_src_install
	use examples && dodoc -r example
}
