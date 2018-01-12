# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.10.0"
NODE_MODULE_DEPEND="md5-hex:1.2.0
	write-file-atomic:1.1.4
	mkdirp:0.5.1"

inherit node-module

DESCRIPTION="Wraps a transform and provides caching"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( readme.md )
