# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="graceful-fs:3.0.2 slide:1.1.5"

inherit node-module

DESCRIPTION="Write files in an atomic fashion w/configurable ownership"

LICENSE="ISC"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
