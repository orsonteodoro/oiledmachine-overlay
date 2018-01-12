# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.10.0"
NODE_MODULE_DEPEND="dot-prop:2.3.0 graceful-fs:4.1.2 mkdirp:0.5.0 object-assign:4.0.1 os-tmpdir:1.0.0 osenv:0.1.0 uuid:2.0.1 write-file-atomic:1.1.2 xdg-basedir:2.0.0"

inherit node-module

DESCRIPTION="Easily load and save config without having to think about where and how"

LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"

DOCS=( readme.md )
