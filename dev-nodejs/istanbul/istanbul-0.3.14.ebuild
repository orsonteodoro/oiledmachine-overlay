# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="esprima:2.1.0 escodegen:1.6.1 handlebars:3.0.0 mkdirp:0.5.0 nopt:3.0.6 fileset:0.1.0 which:1.0.0 async:0.9.0 supports-color:1.3.1 abbrev:1.0.0 wordwrap:0.0.3 resolve:1.1.7 js-yaml:3.0.1 once:1.4.0"

#        "esprima": "2.1.x",
#        "escodegen": "1.6.x",
#        "handlebars": "3.0.0",
#        "mkdirp": "0.5.x",
#        "nopt": "3.x",
#        "fileset": "0.1.x",
#        "which": "1.0.x",
#        "async": "0.9.x",
#        "supports-color": "1.3.x",
#        "abbrev": "1.0.x",
#        "wordwrap": "0.0.x",
#        "resolve": "1.1.x",
#        "js-yaml": "3.x",
#        "once": "1.x"

NODE_MODULE_EXTRA_FILES="download-escodegen-browser.sh"

inherit node-module

DESCRIPTION="Yet another JS code coverage tool that computes statement, line, function and branch coverage with module loader hooks to transparently add coverage when running tests."

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
