# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_{4,5,6,7}} )

inherit distutils-r1

DESCRIPTION="A Python wrapper around the Soundcloud API"
HOMEPAGE="https://github.com/soundcloud/soundcloud-python"
COMMIT="d77f6e5a7ce4852244e653cb67bb20a8a5f04849"
SRC_URI="https://github.com/${PN/-*}/${PN}/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${PYTHON_DEPEND}"
RDEPEND="${DEPEND}
	>=dev-python/fudge-1.0.3[${PYTHON_USEDEP}]
	>=dev-python/simplejson-2.0[${PYTHON_USEDEP}]
	>=dev-python/requests-1.0.0[${PYTHON_USEDEP}]"
S="${WORKDIR}/${PN}-${COMMIT}"
