# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit eutils distutils-r1

LANGS="en ja"

COMMIT="4b28037e328da3d0fe8165c11b800cbaddcb525e"
DESCRIPTION="Adds flavor of interactive filtering to the traditional pipe concept of shell"
HOMEPAGE="https://github.com/mooz/percol"
SRC_URI="https://github.com/mooz/percol/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="doc +l10n_en l10n_ja"

RDEPEND=">=dev-python/six-1.7.3[${PYTHON_USEDEP}]
         l10n_ja? ( >=app-text/cmigemo-0.1.5 )"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${PN}-${COMMIT}"

