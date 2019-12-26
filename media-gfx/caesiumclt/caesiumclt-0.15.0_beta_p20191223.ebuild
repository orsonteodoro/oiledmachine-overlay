# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See CMakeLists.txt for versioning
EAPI=7
DESCRIPTION="Caesium Command Line Tools - Lossy/lossless image compression tool\
 using mozjpeg and zopflipng"
HOMEPAGE="http://saerasoft.com/caesium/clt"
LICENSE="Apache-2.0 Unlicense BSD-2"
# The licenses are for internal dependencies
# optparse - Unlicense
# tinydir - BSD-2
EGIT_COMMIT="5a0e77e9acb4bfe456d9e2c16827bfb25864b97c"
SRC_URI=\
"https://github.com/Lymphatus/CaesiumCLT/archive/${EGIT_COMMIT}.tar.gz \
	-> caesiumctl-${EGIT_COMMIT}.tar.gz"
inherit eutils cmake-utils
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="media-libs/libcaesium"
DEPEND="${RDEPEND}"
RESTRICT="mirror"
S="${WORKDIR}/caesium-clt-${EGIT_COMMIT}"
