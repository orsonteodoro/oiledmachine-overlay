# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# D12, U20, U22, U24

MY_PN="nvidia-ml-py"

DISTUTILS_USE_PEP517="setuptools"
PYPI_NO_NORMALIZE=1
PYPI_PN="nvidia-ml-py"
PYTHON_COMPAT=( "python3_"{8..12} )
inherit distutils-r1 #pypi

S="${WORKDIR}/${MY_PN//-/_}-${PV}"
SRC_URI="
https://files.pythonhosted.org/packages/d2/4d/6f017814ed5ac28e08e1b8a62e3a258957da27582c89b7f8f8b15ac3d2e7/nvidia_ml_py-12.575.51.tar.gz
"

DESCRIPTION="Python Bindings for the NVIDIA Management Library"
HOMEPAGE="
https://developer.nvidia.com/nvidia-management-library-nvml
https://pypi.org/project/nvidia-ml-py/
"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~arm64"
SLOT="0"
# See https://docs.nvidia.com/cuda/cuda-toolkit-release-notes/index.html
RDEPEND+="
	=dev-util/nvidia-cuda-toolkit-12.9*:=
	>=x11-drivers/nvidia-drivers-$(ver_cut 2 ${PV})
"
DEPEND+="
	${RDEPEND}
"
# See https://pypi.org/project/nvidia-ml-py/#history
RESTRICT="mirror"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
