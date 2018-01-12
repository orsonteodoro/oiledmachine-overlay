# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.10.0"
NODE_MODULE_DEPEND="is-equal-shallow:0.1.0 is-primitive:1.0.0"

inherit node-module

DESCRIPTION="Memoize the results of a call to the RegExp constructor, avoiding repetitious runtime compilation of the same string and options, resulting in dramatic speed improvements."

SRC_URI="https://github.com/jonschlinkert/regex-cache/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}/${PN}-${PV}"

DOCS=( README.md )
