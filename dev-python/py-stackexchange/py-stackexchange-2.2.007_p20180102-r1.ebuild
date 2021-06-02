# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A Python binding for the StackExchange API"
HOMEPAGE="https://github.com/lucjon/Py-StackExchange"
LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/${PV}"
PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
MY_PN="Py-StackExchange"
EGIT_COMMIT="18243b192c7a1abe9f67b538c4156507e795bf1c"
SRC_URI=\
"https://github.com/lucjon/${MY_PN}/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${EGIT_COMMIT}"
RESTRICT="mirror"

pkg_postinst() {
	einfo \
"This is rate limited to 300 requests per day and may require an API key for\n\
10,000 requests per day.  For details see\n\
https://github.com/lucjon/Py-StackExchange ."
}
