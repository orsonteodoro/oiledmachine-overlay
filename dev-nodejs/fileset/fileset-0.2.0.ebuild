# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit node-module

NODE_MODULE_DEPEND="minimatch:0.3.0 glob:5.0.6"
#    "minimatch": "0.x",
#    "glob": "5.x"

DESCRIPTION="Wrapper around miniglob / minimatch combo to allow multiple patterns matching and include-exclude ability"

SRC_URI="https://github.com/mklabs/node-fileset/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}/node-${PN}-${PV}"

DOCS=( README.md CHANGELOG.md )
