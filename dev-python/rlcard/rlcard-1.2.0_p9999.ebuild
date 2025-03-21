# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{8..11} )

inherit distutils-r1

if [[ ${PV} =~ 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/datamllab/rlcard.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="HEAD"
	FALLBACK_COMMIT="7fc56edebe9a2e39c94f872edd8dbe325c61b806" # Jul 11, 2023
	IUSE+=" fallback-commit"
else
	KEYWORDS="~amd64"
	SRC_URI="
https://github.com/datamllab/rlcard/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi
S="${WORKDIR}/${P}"

DESCRIPTION="Reinforcement Learning or AI bots for card games like Blackjack, Leduc, Texas, DouDizhu, Mahjong, UNO"
HOMEPAGE="
	http://www.rlcard.org/
	https://github.com/datamllab/rlcard
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" docs test torch"
REQUIRED_USE="
	test? (
		torch
	)
"
RDEPEND+="
	>=dev-python/numpy-1.16.3[${PYTHON_USEDEP}]
	dev-python/termcolor[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
	)
	torch? (
		$(python_gen_any_dep '
			sci-ml/caffe2[${PYTHON_SINGLE_USEDEP},numpy]
			sci-libs/pytorch[${PYTHON_SINGLE_USEDEP}]
		')
		>=dev-python/gitdb-2[${PYTHON_USEDEP}]
		dev-python/GitPython[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
DOCS=( "README.md" )
PATCHES=(
	"${FILESDIR}/${PN}-1.1.0-fix-exclude-tests.patch"
)

verify_version() {
	cd "${S}"
	local actual_version=$(grep -r -e "__version__" \
		"rlcard/__init__.py" \
		| cut -f 2 -d  '"')
	local expected_version=$(ver_cut 1-3 "${PV}")
	if ver_test ${actual_version} -ne ${expected_version} ; then
eerror
eerror "A version change detected which could introduce *DEPENDs changes"
eerror
eerror "Expected verrsion:\t${expected_version}"
eerror "Actual verrsion:\t${actual_version}"
eerror
eerror "To continue, use the fallback-commit USE flag."
eerror
		die
	fi
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		verify_version
	else
		unpack ${A}
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE.md"
	docinto docs
	dodoc -r docs/*
}

src_test() {
	run_test() {
einfo "Running test for ${EPYTHON}"
		py.test tests/ --cov=rlcard || die
	}
	python_foreach_impl run_test
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
