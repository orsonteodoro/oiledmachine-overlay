# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Implementation of an OpenWebRX connector for BBRF103 / RX666 / RX888 devices based on llibsddc"
HOMEPAGE="https://github.com/jketterl/sddc_connector"
LICENSE="GPL-3"
# KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86" # Not tagged or live snapshot
SLOT="0/$(ver_cut 1-2 ${PV})"
RESTRICT="mirror"
CUDA_TARGETS=(
	sm_60
)
IUSE="
	${CUDA_TARGETS[@]/#/+cuda_targets_}
"
REQUIRED_USE="
	${CUDA_TARGETS[@]/#/cuda_targets_}
"
RDEPEND+="
	media-radio/csdr
	media-radio/owrx_connector
	cuda_targets_sm_60? (
		|| (
			=dev-util/nvidia-cuda-toolkit-8*:=
			=dev-util/nvidia-cuda-toolkit-9*:=
			=dev-util/nvidia-cuda-toolkit-10*:=
			=dev-util/nvidia-cuda-toolkit-11*:=
			=dev-util/nvidia-cuda-toolkit-12*:=
		)
	)
	|| (
		media-radio/libsddc
		media-radio/ExtIO_sddc
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	virtual/pkgconfig
"
EGIT_COMMIT="057e7c3ec0c027ca51d6113fc1bf326de2e107e1"
SRC_URI="
https://github.com/jketterl/sddc_connector/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}-${EGIT_COMMIT:0:7}.tar.gz
"
DOCS=( LICENSE )
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
