# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="pend:1.1.3"

inherit node-module

DESCRIPTION="safely create multiple ReadStream or WriteStream objects from the same file descriptor"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( CHANGELOG.md README.md )
