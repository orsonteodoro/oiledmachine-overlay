# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} pypy )

inherit distutils-r1 git-r3
EGIT_REPO_URI="https://github.com/sixohsix/twitter.git"

DESCRIPTION="An API and command-line toolset for Twitter (twitter.com)"
HOMEPAGE="http://mike.verdone.ca/twitter/"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

python_prepare_all() {
    eapply "${FILESDIR}"/${PN}-9999-search.patch
    eapply "${FILESDIR}"/${PN}-9999-ansi-fix.patch

    eapply_user

    distutils-r1_python_prepare_all
}
