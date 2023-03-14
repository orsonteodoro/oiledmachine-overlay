# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

MY_PN="nvidia-ml-py"

DESCRIPTION="Python Bindings for the NVIDIA Management Library"
HOMEPAGE="http://www.nvidia.com/"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~arm64"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" sdk +runtime"
# See https://docs.nvidia.com/cuda/cuda-toolkit-release-notes/index.html
RDEPEND+="
	runtime? (
		>=x11-drivers/nvidia-drivers-$(ver_cut 2 ${PV})
	)
	sdk? (
		>=dev-util/nvidia-cuda-toolkit-11.5
	)
"
DEPEND+="
	${RDEPEND}
"
# See https://pypi.org/project/nvidia-ml-py/#history
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="mirror"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
