# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.4.7"
NODE_MODULE_EXTRA_FILES="dist runtime.js bin"
NODE_MODULE_DEPEND="optimist:0.3.0"

inherit node-module

DESCRIPTION="Provides the power necessary to let you build semantic templates effectively"

MY_PV="2.0.0-alpha.4"
SRC_URI="https://github.com/wycats/handlebars.js/archive/v2.0.0-alpha.4.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
S="${WORKDIR}/${PN}.js-${MY_PV}"

DOCS=( README.markdown CONTRIBUTING.md release-notes.md )

src_install() {
	node-module_src_install
	install_node_module_binary "bin/${PN}" "/usr/local/bin/${PN}-${SLOT}"
	use doc && dodoc docs/*
}
