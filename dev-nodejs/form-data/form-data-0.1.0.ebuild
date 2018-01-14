# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.6.0"
NODE_MODULE_DEPEND="async:0.2.9 combined-stream:0.0.4 mime:1.2.9"

inherit node-module

SRC_URI="http://registry.npmjs.org/${PN}/-/${PN}-${PV}.tgz"

DESCRIPTION="A module to create readable \"multipart/form-data\" streams"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( Readme.md )
