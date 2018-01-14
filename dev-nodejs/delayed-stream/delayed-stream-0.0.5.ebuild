# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.4.0"

inherit node-module

DESCRIPTION="Buffers events from a stream until you are ready to handle them"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( Readme.md )

src_compile() { :; }
