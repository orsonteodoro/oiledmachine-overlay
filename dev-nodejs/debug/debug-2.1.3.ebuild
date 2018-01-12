# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_EXTRA_FILES="browser.js node.js component.json"
NODE_MODULE_DEPEND="ms:0.7.0"

inherit node-module

DESCRIPTION="Small debugging utility"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( Readme.md History.md )

src_compile() { :; }
