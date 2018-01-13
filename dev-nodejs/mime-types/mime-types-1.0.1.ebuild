# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.8"
NODE_MODULE_EXTRA_FILES="component.json"

inherit node-module

DESCRIPTION="The ultimate javascript content-type utility"

SRC_URI="https://github.com/jshttp/mime-types/archive/${PV}.tar.gz -> ${P}.tar.gz" #missing files from npm
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}/${PN}-${PV}"

DOCS=( README.md SOURCES.md )

src_prepare() {
	default
	sed -i -r -e "s|--harmony-generators|--harmony|g" Makefile || die
}

src_compile() {
	true
}
