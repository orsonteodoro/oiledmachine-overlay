# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_EXTRA_FILES="uuid.js"
NODE_MODULE_HAS_TEST="1"

inherit node-module

DESCRIPTION="Rigorous implementation of RFC4122 (v1 and v4) UUIDs"

LICENSE="MIT GPL-2"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

src_prepare() {
	# Make the tests fail on invalid results instead of just printing to stdout
	sed -i "s/error('/throw new Error('/g" test/test.js || die
	eapply_user
}

node_module_run_test() {
	node test/test.js || die "Tests failed"
}
