# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# ebuild obtained from the bgo-overlay
# See https://bugs.gentoo.org/678292 for acceptance progress into the gentoo-overlay.

EAPI=7

inherit cmake-utils

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/Tessil/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/Tessil/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
fi

DESCRIPTION="C++ implementation of a fast hash map and hash set using robin hood hashing"
HOMEPAGE="https://github.com/Tessil/robin-map"

LICENSE="MIT"
SLOT="0"
RESTRICT="mirror"

src_configure() {
	cmake-utils_src_configure
}
