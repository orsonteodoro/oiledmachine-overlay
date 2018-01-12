# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="errno:0.1.3 readable-stream:2.0.1" #it actually doesn't say the dependencies

inherit node-module

DESCRIPTION="A simple in-memory filesystem. Holds data in a javascript object."

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
