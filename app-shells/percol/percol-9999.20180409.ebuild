# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit eutils distutils-r1

COMMIT="dac03893830c6b638a6292295580007fad7cdf17"
DESCRIPTION="Adds flavor of interactive filtering to the traditional pipe concept of shell"
HOMEPAGE="https://github.com/mooz/percol"
SRC_URI="https://github.com/mooz/percol/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="doc"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]
         app-text/cmigemo"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${PN}-${COMMIT}"

