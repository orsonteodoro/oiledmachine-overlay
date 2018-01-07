# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6
inherit multilib cmake-utils

DESCRIPTION="Build EAR: tool for generating llvm compilation databases"
HOMEPAGE="https://github.com/rizsotto/Bear"

if [[ ${PV} == 9999* ]] ; then
	EGIT_REPO_URI="git://github.com/rizsotto/Bear.git"
	KEYWORDS=""
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/rizsotto/Bear/archive/${PV}.tar.gz -> ${P}-git.tgz"
	MY_PN="${PN/b/B}"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND=">=dev-libs/libconfig-1.4"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.8
	virtual/pkgconfig
"

src_prepare()
{
	eapply_user
}

src_configure()
{
	cmake-utils_src_configure
}
