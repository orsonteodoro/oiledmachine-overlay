# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_NAME="lodash.debounce"
NODEJS_MIN_VERSION="0.4.0"
NODE_MODULE_DEPEND="lodash-isnative:3.0.0"

inherit node-module

DESCRIPTION="The modern build of lodash.debounce as a module"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

RDEPEND="=dev-nodejs/lodash-isnative-3.0.0"
DEPEND="${RDEPEND}"

DOCS=( README.md )
