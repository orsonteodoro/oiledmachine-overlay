# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

MY_PN="nvidia-ml-py"

DESCRIPTION="Python Bindings for the NVIDIA Management Library"
HOMEPAGE="http://www.nvidia.com/"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~arm64"
SLOT="0/${PV}"
IUSE+=" sdk +runtime"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
# See https://docs.nvidia.com/cuda/cuda-toolkit-release-notes/index.html
RDEPEND+=" ${PYTHON_DEPS}
	sdk? ( >=dev-util/nvidia-cuda-toolkit-11.2 )
	runtime? ( >=x11-drivers/nvidia-drivers-$(ver_cut 2-3 ${PV}) )"
DEPEND+=" ${RDEPEND}"
BDEPEND+=" ${PYTHON_DEPS}"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="mirror"
