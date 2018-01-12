# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_EXTRA_FILES="duplex.js passthrough.js readable.js transform.js writable.js"
NODE_MODULE_DEPEND="string_decoder:0.10.31"

inherit node-module

DESCRIPTION="Streams3, a user-land copy of the stream library from Node.js"

LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DOCS=( README.md )

src_install() {
	node-module_src_install
	use doc && dodoc -r doc/*
}
