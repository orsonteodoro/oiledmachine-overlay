# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# D12, D13, U22, U24

MY_PN="nvidia-ml-py"

DISTUTILS_USE_PEP517="setuptools"
PYPI_NO_NORMALIZE=1
PYPI_PN="nvidia-ml-py"
PYTHON_COMPAT=( "python3_"{10..12} )
inherit distutils-r1 #pypi

S="${WORKDIR}/${MY_PN//-/_}-${PV}"
SRC_URI="
https://files.pythonhosted.org/packages/ce/49/c29f6e30d8662d2e94fef17739ea7309cc76aba269922ae999e4cc07f268/nvidia_ml_py-13.595.45.tar.gz
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
	=dev-util/nvidia-cuda-toolkit-13.2*:=
	>=x11-drivers/nvidia-drivers-$(ver_cut 2 ${PV})
"
DEPEND+="
	${RDEPEND}
"
# See https://pypi.org/project/nvidia-ml-py/#history
RESTRICT="mirror"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
