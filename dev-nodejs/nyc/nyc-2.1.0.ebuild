# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_EXTRA_FILES="bin"
NODE_MODULE_DEPEND="foreground-child:1.2.0 istanbul:0.3.14 jsonstream:1.0.3 lodash:3.8.0 mkdirp:0.5.0 rimraf:2.3.3 signal-exit:2.0.0 spawn-wrap:1.0.1 strip-bom:1.0.0 yargs:3.8.0"

inherit node-module

DESCRIPTION="The Istanbul command line interface"

LICENSE="ISC"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md CHANGELOG.md )

src_prepare() {
	eapply_user
	rm -r node_modules || die
}
