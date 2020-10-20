# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See regex_{2,3}/regex.py for versioning
# The regex.py __version__ is equivalent to 2020.10.15 for the entire package.

# This is the same source as dev-python/regex in the gentoo overlay.
# We use this name because ycmd repo referred to it that way.

# Split for the possiblity of adding additional commit patches that
# ycmd may add.

EAPI=7
DESCRIPTION="Alternative regular expression module, to replace re."
HOMEPAGE="https://bitbucket.org/mrabarnett/mrab-regex/src/hg/"
LICENSE="CNRI"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/${PV}"
IUSE="test"
RDEPEND="!dev-python/regex"
DEPEND="!dev-python/regex"
PYTHON_COMPAT=( python3_{6,7,8,9} )
inherit distutils-r1
EHG_HASH_LONG="fa9def53cf920ed9343a0afab54d5075d4c75394"
EHG_HASH="${EHG_HASH_LONG:0:12}"
SRC_URI=\
"https://bitbucket.org/mrabarnett/mrab-regex/get/${EHG_HASH}.zip \
		-> ${P}.zip"
S="${WORKDIR}/mrabarnett-${PN}-${EHG_HASH}"
RESTRICT="mirror"
