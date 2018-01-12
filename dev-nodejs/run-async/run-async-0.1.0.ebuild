# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="once:1.3.0"

inherit node-module

DESCRIPTION="Utility method to run function either synchronously or asynchronously using the common this.async() style."

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
