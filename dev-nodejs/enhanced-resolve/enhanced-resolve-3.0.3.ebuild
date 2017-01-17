# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

NODE_MODULE_DEPEND="object-assign:4.0.1 graceful-fs:4.1.2 memory-fs:0.4.0 tapable:0.2.5"

inherit node-module

DESCRIPTION="Offers a async require.resolve function. It's highly configurable."

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
