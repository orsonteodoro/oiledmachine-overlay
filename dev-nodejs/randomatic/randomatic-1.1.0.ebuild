# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="is-number:1.1.0 kind-of:1.0.0"

inherit node-module

DESCRIPTION="Generate randomized strings of a specified length, fast"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
