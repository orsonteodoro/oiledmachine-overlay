# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5,3_6} pypy )

inherit distutils-r1

MY_PN="Py-StackExchange"
DESCRIPTION="A Python binding for the StackExchange API"
HOMEPAGE="https://github.com/lucjon/Py-StackExchange"
COMMIT="18243b192c7a1abe9f67b538c4156507e795bf1c"
SRC_URI="https://github.com/lucjon/${MY_PN}/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""
S="${WORKDIR}/${MY_PN}-${COMMIT}"

pkg_postinst() {
	einfo "This is rate limited to 300 requests per day and may require an API key for 10,000 requests per day."
	einfo "For details see https://github.com/lucjon/Py-StackExchange ."
}
