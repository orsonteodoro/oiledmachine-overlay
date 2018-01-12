# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.4.0"
NODE_MODULE_DEPEND="code-point-at:1.0.0 is-fullwidth-code-point:1.0.0 mute-stream:0.0.5"

inherit node-module

DESCRIPTION="Readline Faade fixing bugs and issues found in releases 0.8 and 0,10"


LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
