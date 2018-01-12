# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.4.0"
NODE_MODULE_EXTRA_FILES="fs.js legacy-streams.js polyfills.js"

NODE_MODULE_DEPEND="mkdirp:0.5.0 rimraf:2.2.8 tap:5.4.2"

inherit node-module

DESCRIPTION="A drop-in replacement for fs, making various improvements"

LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
