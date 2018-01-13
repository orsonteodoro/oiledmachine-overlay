# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_EXTRA_FILES="bin"
NODE_MODULE_DEPEND="append-transform:0.2.0 arrify:1.0.1 caching-transform:1.0.0 convert-source-map:1.1.2 find-cache-dir:0.1.1 foreground-child:1.3.5 glob:6.0.2 istanbul:0.4.1 md5-hex:1.2.0 micromatch:2.1.6 mkdirp:0.5.0 pkg-up:1.0.0 read-pkg:1.0.0 resolve-from:2.0.0 rimraf:2.5.0 signal-exit:2.1.1 source-map:0.5.3 spawn-wrap:1.1.1 strip-bom:2.0.0 yargs:3.15.0"

inherit node-module

DESCRIPTION="The Istanbul command line interface"

LICENSE="ISC"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md CHANGELOG.md )
