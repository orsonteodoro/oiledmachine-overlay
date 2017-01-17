# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

NODE_MODULE_DEPEND="resolve-from:2.0.0 minimatch:0.2.0 glob:3.0.0 enhanced-resolve:2.2.2 acorn:3.2.0"
NODE_MODULE_EXTRA_FILES="bin defs lib plugin CONTRIBUTING.md"

inherit node-module

DESCRIPTION="A JavaScript code analyzer for deep, cross-editor language support"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
