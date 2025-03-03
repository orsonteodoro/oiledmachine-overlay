# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "pypy3" "python3_"{10..13} )

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/python-soundfile-${PV}"
SRC_URI="
https://github.com/bastibe/python-soundfile/archive/${PV}.tar.gz
	-> ${P}.gh.tar.gz
"

DESCRIPTION="SoundFile is an audio library based on libsndfile, CFFI, and NumPy"
HOMEPAGE="
	https://github.com/bastibe/python-soundfile/
	https://pypi.org/project/soundfile/
"
LICENSE="BSD"
SLOT="0"
RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/cffi-1.0.0[${PYTHON_USEDEP}]
	' 'python*')
	dev-python/numpy[${PYTHON_USEDEP}]
	media-libs/libsndfile
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/cffi-1.0.0[${PYTHON_USEDEP}]
	' 'python*')
"

distutils_enable_tests "pytest"
