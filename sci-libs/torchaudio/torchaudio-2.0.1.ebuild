# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
MY_PN="audio"
PYTHON_COMPAT=( "python3_10" )

inherit distutils-r1 pypi

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${MY_PN}-${PV}"
SRC_URI="
https://github.com/pytorch/audio/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Data manipulation and transformation for audio signal processing, powered by PyTorch"
HOMEPAGE="
	https://github.com/pytorch/audio
	https://pypi.org/project/torchaudio
"
LICENSE="
	BSD-2
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
RDEPEND+="
	$(python_gen_cond_dep '
		dev-python/kaldi-io[${PYTHON_USEDEP}]
		dev-python/soundfile[${PYTHON_USEDEP}]
	')
	~sci-libs/pytorch-${PV}[${PYTHON_SINGLE_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
	')
"
DOCS=( "README.md" )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
