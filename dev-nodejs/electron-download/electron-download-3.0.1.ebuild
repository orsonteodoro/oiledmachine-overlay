# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.4.0"
NODE_MODULE_DEPEND="debug:2.2.0 fs-extra:0.30.0 home-path:1.0.1 minimist:1.2.0 nugget:2.0.0 path-exists:2.1.0 rc:1.1.2 semver:5.3.0 sumchecker:1.2.0"
NODE_MODULE_EXTRA_FILES="build"

inherit node-module

DESCRIPTION="download electron prebuilt binary zips from github releases"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"

DOCS=( collaborators.md readme.md )

src_install() {
        node-module_src_install
	install_node_module_binary "bin/cli.js" "/usr/local/bin/${PN}-${SLOT}"
}
