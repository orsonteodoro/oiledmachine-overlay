# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# mdx_truly_sane_lists

DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} ) # Lists up to 3.8

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/pytorch-image-models-${PV}"
SRC_URI="
https://github.com/huggingface/pytorch-image-models/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="PyTorch Image Models"
HOMEPAGE="
https://github.com/huggingface/pytorch-image-models
https://pypi.org/project/timm/
"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="doc modelindex"
RDEPEND+="
	$(python_gen_cond_dep '
		dev-python/pyyaml[${PYTHON_USEDEP}]
		modelindex? (
			>=dev-python/model-index-0.1.10[${PYTHON_USEDEP}]
			>=dev-python/jinja2-2.11.3[${PYTHON_USEDEP}]
		)
	')
	>=sci-ml/pytorch-1.4.0[${PYTHON_SINGLE_USEDEP}]
	>=sci-libs/torchvision-0.5.0[${PYTHON_SINGLE_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
		doc? (
			dev-python/mkdocs[${PYTHON_USEDEP}]
			dev-python/mkdocs-awesome-pages-plugin[${PYTHON_USEDEP}]
			dev-python/mkdocs-material[${PYTHON_USEDEP}]
			dev-python/mdx_truly_sane_lists[${PYTHON_USEDEP}]
		)
	')
"

distutils_enable_tests "pytest"
