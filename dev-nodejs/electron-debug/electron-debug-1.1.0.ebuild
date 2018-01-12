# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="electron-is-dev:0.1.0 electron-localshortcut:0.6.0"

inherit node-module

DESCRIPTION="Adds useful debug features to your Electron app"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( readme.md )



