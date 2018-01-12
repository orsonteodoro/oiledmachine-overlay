# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="4.0.0"
NODE_MODULE_DEPEND="p-cancelable:0.3.0"

inherit node-module

DESCRIPTION="Detect when an element is ready in the DOM"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( readme.md )
