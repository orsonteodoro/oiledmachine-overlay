# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.8.0"
NODE_MODULE_DEPEND="bluebird:2.9.34 clean-yaml-object:0.1.0 codecov-io:0.1.6 coveralls:2.11.2 deeper:2.1.0 foreground-child:1.3.3 glob:6.0.1 isexe:1.0.0 js-yaml:3.3.1 nyc:5.5.0 only-shallow:1.0.2 opener:1.4.1 readable-stream:2.0.2 signal-exit:2.0.0 stack-utils:0.3.0 supports-color:1.3.1 tap-mocha-reporter:0.0.27 tap-parser:1.2.2 tmatch:1.0.2"
NODE_MODULE_EXTRA_FILES="bin"

inherit node-module

DESCRIPTION="A Test-Anything-Protocol library"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DOCS=( README.md CHANGELOG.md )

src_install() {
	node-module_src_install
	use examples && dodoc -r example coverage-example
}
