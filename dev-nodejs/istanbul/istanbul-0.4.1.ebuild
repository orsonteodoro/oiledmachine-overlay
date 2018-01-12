# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="abbrev:1.0.0 async:1.0.0 escodegen:1.7.0 esprima:2.7.2 fileset:0.2.0 handlebars:4.0.1 js-yaml:3.0.1 mkdirp:0.5.0 nopt:3.0.6 once:1.4.0 resolve:1.1.7 supports-color:3.1.0 which:1.1.1 wordwrap:1.0.0"

#    "abbrev": "1.0.x",
#    "async": "1.x",
#    "escodegen": "1.7.x",
#    "esprima": "2.7.x",
#    "fileset": "0.2.x",
#    "handlebars": "^4.0.1",
#    "js-yaml": "3.x",
#    "mkdirp": "0.5.x",
#    "nopt": "3.x",
#    "once": "1.x",
#    "resolve": "1.1.x",
#    "supports-color": "^3.1.0",
#    "which": "^1.1.1",
#    "wordwrap": "^1.0.0"


inherit node-module

DESCRIPTION=""

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
