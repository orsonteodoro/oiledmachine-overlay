# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# flake8-absolute-import
# flake8-docstrings
# flake8-rst-docstrings
# flake8-implicit-str-concat

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..11} ) # Upstream listed only up to 3.11

inherit distutils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/Zulko/moviepy.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="HEAD"
	FALLBACK_COMMIT="bc8d1a831d2d1f61abfdf1779e8df95d523947a5" # Jul 11, 2023
	inherit git-r3
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
else
	#MY_PV="${PV}"
	MY_PV="2.0.0.dev2"
	KEYWORDS="~amd64 ~arm64"
	SRC_URI="
https://github.com/Zulko/moviepy/archive/refs/tags/v${MY_PV}.tar.gz
	-> ${MY_PV}.tar.gz
	"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="Video editing with Python"
HOMEPAGE="
https://zulko.github.io/moviepy/
https://github.com/Zulko/moviepy
"
LICENSE="MIT"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
doc imagemagick lint matplotlib opencv pygame scipy scikit test youtube-dl
"
RDEPEND+="
	$(python_gen_cond_dep '
		(
			>=dev-python/decorator-4.0.2[${PYTHON_USEDEP}]
			<dev-python/decorator-6[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/imageio-2.5[${PYTHON_USEDEP}]
			<dev-python/imageio-3[${PYTHON_USEDEP}]
		)
		>=dev-python/imageio-ffmpeg-0.2.0[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.17.3[${PYTHON_USEDEP}]
		<dev-python/proglog-1.0.1[${PYTHON_USEDEP}]
		matplotlib? (
			dev-python/matplotlib[${PYTHON_USEDEP}]
		)
		pygame? (
			>=dev-python/pygame-1.9.3[${PYTHON_USEDEP}]
		)
		scipy? (
			dev-python/scipy[${PYTHON_USEDEP}]
		)
		scikit? (
			dev-python/scikit-image[${PYTHON_USEDEP}]
			dev-python/scikit-learn[${PYTHON_USEDEP}]
		)
		youtube-dl? (
			net-misc/yt-dlp
		)
	')
	opencv? (
		media-libs/opencv[${PYTHON_SINGLE_USEDEP},python]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		doc? (
			<dev-python/numpydoc-2[${PYTHON_USEDEP}]
			>=dev-python/sphinx-3.4.3[${PYTHON_USEDEP}]
			>=dev-python/sphinx-rtd-theme-0.5.1[${PYTHON_USEDEP}]
		)
		lint? (
			>=dev-python/black-22.3.0[${PYTHON_USEDEP}]
			>=dev-python/flake8-4.0.1[${PYTHON_USEDEP}]
			>=dev-python/flake8-absolute-import-1.0[${PYTHON_USEDEP}]
			>=dev-python/flake8-docstrings-0.2.5[${PYTHON_USEDEP}]
			>=dev-python/flake8-rst-docstrings-0.2.5[${PYTHON_USEDEP}]
			>=dev-python/flake8-implicit-str-concat-0.3.0[${PYTHON_USEDEP}]
			>=dev-python/isort-5.10.1[${PYTHON_USEDEP}]
		)
		test? (
			(
				>=dev-python/coveralls-3[${PYTHON_USEDEP}]
				<dev-python/coveralls-4[${PYTHON_USEDEP}]
			)
			(
				>=dev-python/pytest-3[${PYTHON_USEDEP}]
				<dev-python/pytest-7[${PYTHON_USEDEP}]
			)
			(
				>=dev-python/pytest-cov-2.5.1[${PYTHON_USEDEP}]
				<dev-python/pytest-cov-3[${PYTHON_USEDEP}]
			)
			>=dev-python/python-dotenv-0.10[${PYTHON_USEDEP}]
		)
	')
	lint? (
		>=dev-vcs/pre-commit-2.19.0[${PYTHON_SINGLE_USEDEP}]
	)
"

distutils_enable_sphinx "docs"
distutils_enable_tests "pytest"

unpack_live() {
	if use fallback-commit ; then
		EGIT_COMMIT="${FALLBACK_COMMIT}"
	fi
	git-r3_fetch
	git-r3_checkout
}

src_unpack() {
	if [[ "${PV}" =~ 9999 ]] ; then
		unpack_live
	else
		unpack ${A}
	fi
	if use youtube-dl ; then
		sed -i -e "s|youtube_dl|yt-dlp|g" \
			setup.py \
			|| die
		sed -i -e "s|youtube-dl|yt-dlp|g" \
			moviepy/video/io/downloader.py \
			|| die
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# A previous ebuild did exist but this was independently created.
