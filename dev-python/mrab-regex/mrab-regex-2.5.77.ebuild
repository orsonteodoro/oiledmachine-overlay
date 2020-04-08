# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See regex_{2,3}/regex.py for versioning

EAPI=7
DESCRIPTION="Alternative regular expression module, to replace re."
HOMEPAGE="https://bitbucket.org/mrabarnett/mrab-regex/src/hg/"
LICENSE="CNRI"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/${PV}"
IUSE="test"
PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1
EHG_HASH_LONG="c660527507bb5a4cef10568a74a4ff1fa309504e"
EHG_HASH="${EHG_HASH_LONG:0:12}"
SRC_URI=\
"https://bitbucket.org/mrabarnett/mrab-regex/get/${EHG_HASH}.zip \
		-> ${P}.zip"
S="${WORKDIR}/mrabarnett-${PN}-${EHG_HASH}"
RESTRICT="mirror"
