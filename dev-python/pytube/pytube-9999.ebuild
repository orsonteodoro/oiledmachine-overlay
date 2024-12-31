# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..11} ) # Upstream only test up to 3.11

inherit distutils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/pytube/pytube.git"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	FALLBACK_COMMIT="a32fff39058a6f7e5e59ecd06a7467b71197ce35"
	IUSE+=" fallback-commit"
	inherit git-r3
else
	inherit pypi
	KEYWORDS="~amd64"
fi

DESCRIPTION="Python tools for downloading YouTube Videos"
HOMEPAGE="https://github.com/pytube/pytube"
LICENSE="Unlicense"
SLOT="0"
IUSE+=" test"
RESTRICT="
	!test? (
		test
	)
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

python_test() {
	py.test -v || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all
}
