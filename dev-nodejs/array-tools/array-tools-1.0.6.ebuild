# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="typical:1.0.0"
#object-tools:1.0.0 refers to deleted object use 1.0.2 instead

inherit node-module

DESCRIPTION="Useful functions for working with arrays"

SRC_URI="https://github.com/75lb/array-tools/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="" #it doesn't say
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}/${PN}-${PV}"

#fix circular dependency
PDEPEND="dev-nodejs/object-tools:1.0.2"

DOCS=( jsdoc2md/README.hbs README.md )

src_install() {
        node-module_src_install
	dosym "${EROOT}usr/$(get_libdir)/node/object-tools/1.0.2" "/usr/$(get_libdir)/node/${NODE_MODULE_NAME}/${SLOT}/node_modules/object-tools"
}

