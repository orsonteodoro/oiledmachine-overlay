# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.10.22"
NODE_MODULE_DEPEND="optimist:0.6.1 esprima:1.0.0 chai:1.9.1 handlebars:1.2.0 async:0.2.10 diff:1.0.0"

#    "optimist": "0.6.x",
#    "esprima": "1.0.x",
#    "chai": "^1.9.1",
#    "handlebars": "1.2.x",
#    "async": "0.2.x",
#    "diff": "1.0.x"

NODE_MODULE_EXTRA_FILES="bin images"

inherit node-module

DESCRIPTION="Test utility"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
