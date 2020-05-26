# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Shared CMake functions and macros"
HOMEPAGE="https://github.com/lirios/cmake-shared"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
RDEPEND=">=kde-frameworks/extra-cmake-modules-5.48.0"
DEPEND="${RDEPEND}
	>=dev-util/cmake-3.10.0"
inherit eutils cmake-utils
EGIT_COMMIT="11c53a19ae07bdd3aae4b96c553b4d0a3eec7869"
SRC_URI=\
"https://github.com/lirios/cmake-shared/archive/${EGIT_COMMIT}.tar.gz -> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
