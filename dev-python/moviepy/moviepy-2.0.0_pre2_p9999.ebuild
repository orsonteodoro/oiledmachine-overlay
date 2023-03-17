# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} ) # Upstream listed only up to 3.9
inherit distutils-r1 git-r3

DESCRIPTION="Video editing with Python"
HOMEPAGE="
https://zulko.github.io/moviepy/
https://github.com/Zulko/moviepy
"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
doc fallback-commit imagemagick lint matplotlib opencv pygame scipy scikit test
"
DEPEND+="
	(
		<dev-python/decorator-6[${PYTHON_USEDEP}]
		>=dev-python/decorator-4.0.2[${PYTHON_USEDEP}]
	)
	(
		<dev-python/imageio-3[${PYTHON_USEDEP}]
		>=dev-python/imageio-2.5[${PYTHON_USEDEP}]
	)
	>=dev-python/imageio-ffmpeg-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.17.3[${PYTHON_USEDEP}]
	<=dev-python/proglog-1.0[${PYTHON_USEDEP}]
	matplotlib? (
		dev-python/matplotlib[${PYTHON_USEDEP}]
	)
	pygame? (
		dev-python/pygame[${PYTHON_USEDEP}]
	)
	opencv? (
		media-libs/opencv[${PYTHON_USEDEP},python]
	)
	scipy? (
		dev-python/scipy[${PYTHON_USEDEP}]
	)
	scikit? (
		sci-libs/scikit-image[${PYTHON_USEDEP}]
		sci-libs/scikit-learn[${PYTHON_USEDEP}]
	)
"
RDEPEND+="
	${DEPEND}
"
# TODO: create package:
# flake8-absolute-import
# flake8-docstrings
# flake8-rst-docstrings
# flake8-implicit-str-concat
#
BDEPEND+="
	doc? (
		<dev-python/numpydoc-2[${PYTHON_USEDEP}]
		>=dev-python/sphinx-3.4.3[${PYTHON_USEDEP}]
		>=dev-python/sphinx_rtd_theme-0.5.1[${PYTHON_USEDEP}]
	)
	lint? (
		$(python_gen_any_dep 'dev-vcs/pre-commit[${PYTHON_SINGLE_USEDEP}]')
		dev-python/black[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/flake8-absolute-import[${PYTHON_USEDEP}]
		dev-python/flake8-docstrings[${PYTHON_USEDEP}]
		dev-python/flake8-rst-docstrings[${PYTHON_USEDEP}]
		dev-python/flake8-implicit-str-concat[${PYTHON_USEDEP}]
		dev-python/isort[${PYTHON_USEDEP}]
	)
	test? (
		(
			<dev-python/coveralls-4[${PYTHON_USEDEP}]
			>=dev-python/coveralls-3[${PYTHON_USEDEP}]
		)
		(
			<dev-python/pytest-7[${PYTHON_USEDEP}]
			>=dev-python/pytest-3[${PYTHON_USEDEP}]
		)
		(
			<dev-python/pytest-cov-3[${PYTHON_USEDEP}]
			>=dev-python/pytest-cov-2.5.1[${PYTHON_USEDEP}]
		)
	)
"
SRC_URI="
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

distutils_enable_sphinx "docs"
distutils_enable_tests "pytest"

src_unpack() {
	EGIT_REPO_URI="https://github.com/Zulko/moviepy.git"
	EGIT_BRANCH="master"
	if use fallback-commit ; then
		EGIT_COMMIT="99a9657ea411c81cdc88b9e9ef9bf8e4047a32d2"
	else
		EGIT_COMMIT="HEAD"
	fi
	git-r3_fetch
	git-r3_checkout
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# A previous ebuild did exist but this was independently created.
