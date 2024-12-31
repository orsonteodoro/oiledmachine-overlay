# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{9..11} ) # Upstream lists up to 3.6

inherit distutils-r1

KEYWORDS="~amd64 ~arm64 ~x86"
SRC_URI="
https://github.com/keras-team/keras-applications/archive/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Keras deep learning library reference implementations of deep \
learning models"
HOMEPAGE="
	https://keras.io/applications/
	https://github.com/keras-team/keras-applications
"
LICENSE="MIT"
SLOT="0"
IUSE+=" test"
RDEPEND+="
	>=dev-python/numpy-1.9.1[${PYTHON_USEDEP}]
	dev-python/h5py[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-pep8[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
	)
"
