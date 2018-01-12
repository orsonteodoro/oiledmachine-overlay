# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.6.0"
NODE_MODULE_DEPEND="graceful-fs:4.1.2 memory-fs:0.2.0 tapable:0.1.6 object-assign:4.0.1"

inherit node-module

DESCRIPTION="Offers a async require.resolve function. It's highly configurable."

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
