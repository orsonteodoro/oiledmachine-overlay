# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1 git-r3

DESCRIPTION="Adds flavor of interactive filtering to the traditional pipe \
concept of shell"
HOMEPAGE="https://github.com/mooz/percol"
LICENSE="MIT"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
SLOT="0"
LANGS="en ja"
IUSE+=" doc fallback-commit +l10n_en l10n_ja"
RDEPEND+="
	>=dev-python/six-1.7.3[${PYTHON_USEDEP}]
	l10n_ja? (
		>=app-text/cmigemo-0.1.5
	)
"
DEPEND+="
	${RDEPEND}
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

src_unpack() {
	EGIT_REPO_URI="https://github.com/mooz/percol.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="HEAD"
	use fallback-commit && EGIT_COMMIT="4b28037e328da3d0fe8165c11b800cbaddcb525e"
	git-r3_fetch
	git-r3_checkout
}
