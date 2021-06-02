# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit eutils distutils-r1

DESCRIPTION="Adds flavor of interactive filtering to the traditional pipe \
concept of shell"
HOMEPAGE="https://github.com/mooz/percol"
LICENSE="MIT"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
SLOT="0"
LANGS="en ja"
IUSE+=" doc +l10n_en l10n_ja"
REQUIRED_USE=" ${PYTHON_REQUIRED_USE}"
RDEPEND+=" ${PYTHON_DEPS}
	>=dev-python/six-1.7.3[${PYTHON_USEDEP}]
	l10n_ja? ( >=app-text/cmigemo-0.1.5 )"
DEPEND+=" ${RDEPEND}"
BDEPEND+=" ${PYTHON_DEPS}
	dev-python/setuptools[${PYTHON_USEDEP}]"
EGIT_COMMIT="4b28037e328da3d0fe8165c11b800cbaddcb525e"
SRC_URI="\
https://github.com/mooz/percol/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
