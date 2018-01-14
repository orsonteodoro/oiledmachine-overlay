# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="array-tools:1.0.6 object-tools:1.0.0"
#array-tools:1.0.1 is broken use 1.0.6
#object-tools:1.0.0 is broken use 1.0.2

inherit node-module

DESCRIPTION="Merges together config data loaded from external JSON files"

LICENSE=""
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
