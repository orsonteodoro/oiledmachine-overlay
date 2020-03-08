# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="compdb is a command line tool to manipulates compilation databases."
HOMEPAGE="https://github.com/Sarcasm/compdb"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
EGIT_COMMIT="62b4c0f6daa0654256a0ae9036d59cd5026f280f"
SLOT="0"
RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}"
SRC_URI=\
"https://github.com/Sarcasm/${PN}/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
PYTHON_COMPAT=( python3_6 )
inherit distutils-r1
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
