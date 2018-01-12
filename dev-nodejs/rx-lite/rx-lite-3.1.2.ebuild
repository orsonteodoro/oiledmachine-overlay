# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.4.0"
NODE_MODULE_EXTRA_FILES="rx.lite.js  rx.lite.map  rx.lite.min.js"

inherit node-module

DESCRIPTION="Lightweight library for composing asynchronous and event-based operations in JavaScript"

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"

DOCS=( readme.md )
