# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="through2:0.2.3 speedometer:0.1.2 single-line-log:0.3.1"

inherit node-module

DESCRIPTION="Read the progress of a stream"

LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
