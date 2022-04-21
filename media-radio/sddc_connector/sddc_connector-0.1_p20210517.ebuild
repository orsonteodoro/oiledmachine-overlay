# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Implementation of an OpenWebRX connector for BBRF103 / RX666 / RX888 devices based on llibsddc"
HOMEPAGE="https://github.com/jketterl/sddc_connector"
LICENSE="GPL-3"
# KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86" # Not tested due to lack of cuda hardware
SLOT="0/${PV}"
RESTRICT="mirror"
DEPEND+="
	dev-util/nvidia-cuda-toolkit
	media-radio/csdr
	media-radio/owrx_connector
	|| (
		media-radio/libsddc
		media-radio/ExtIO_sddc
	)
"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	virtual/pkgconfig
"
EGIT_COMMIT="a921bb7d353f33732e00daba1fe62f647b4872f3"
SRC_URI="
https://github.com/jketterl/sddc_connector/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}.tar.gz
"
DOCS=( LICENSE )
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
