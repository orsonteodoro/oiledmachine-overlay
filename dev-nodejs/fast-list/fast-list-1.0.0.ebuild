# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit node-module

DESCRIPTION="A fast linked list (good for queues, stacks, etc.)"

LICENSE="ISC"
KEYWORDS="~amd64 ~x86"
IUSE=""

DOCS=( README.md )

src_install() {
	node-module_src_install
}
