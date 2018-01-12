# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="ansi-escapes:1.1.0 ansi-regex:2.0.0 chalk:1.0.0 cli-cursor:1.0.1 cli-width:1.0.1 figures:1.3.5 lodash:3.3.1 readline2:1.0.1 run-async:0.1.0 rx-lite:3.1.2 strip-ansi:3.0.0 through:2.3.6"

inherit node-module

DESCRIPTION="A collection of common interactive command line user interfaces."

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
