# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} )
inherit distutils-r1


DESCRIPTION="compdb is a command line tool to manipulates compilation databases."
HOMEPAGE="https://github.com/Sarcasm/compdb"

KEYWORDS="~amd64 ~x86"
COMMIT="d58236d1b02ce8fd9a6e14d6663f31ab8b5d955b"
PROJECT="compdb"
SRC_URI="https://github.com/Sarcasm/compdb/archive/${COMMIT}.zip -> ${P}.zip"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

python_prepare_all()
{
	rm -rf tests
	distutils-r1_python_prepare_all
}

