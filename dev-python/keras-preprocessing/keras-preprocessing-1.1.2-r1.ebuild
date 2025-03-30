# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYPI_NO_NORMALIZE=1
PYPI_PN="Keras_Preprocessing"
PYTHON_COMPAT=( "python3_"{9..11} ) # Upstream list up to 3.6

inherit distutils-r1

KEYWORDS="~amd64"
SRC_URI="
https://github.com/keras-team/keras-preprocessing/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Easy data preprocessing and data augmentation for deep learning models"
HOMEPAGE="
	https://keras.io/
	https://github.com/keras-team/keras-preprocessing
"
LICENSE="MIT"
SLOT="0"
IUSE+=" dev image test"
RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/numpy-1.9.1[${PYTHON_USEDEP}]
		>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		image? (
			>=dev-python/cipy-0.14[${PYTHON_USEDEP}]
			>=virtual/pillow-5.2.0[${PYTHON_USEDEP}]
		)
	')
"
BDEPEND+="
	$(python_gen_cond_dep '
		dev? (
			dev-python/flake8[${PYTHON_USEDEP}]
		)
		test? (
			dev-python/pandas[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
			dev-python/pytest-cov[${PYTHON_USEDEP}]
			sci-ml/tensorflow[${PYTHON_USEDEP}]
			virtual/pillow[${PYTHON_USEDEP}]
		)
	')
	test? (
		dev-python/keras[${PYTHON_SINGLE_USEDEP}]
	)
"
