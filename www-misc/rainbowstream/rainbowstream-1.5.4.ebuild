# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_7 )

inherit distutils-r1 eutils

DESCRIPTION="A smart and nice Twitter client on terminal written in Python."
HOMEPAGE="http://www.rainbowstream.org/"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86"
SLOT="0"
IUSE+=" jpeg"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
DEPEND+=" dev-python/arrow[${PYTHON_USEDEP}]
	dev-python/pillow[jpeg?,${PYTHON_USEDEP}]
	dev-python/pocket[${PYTHON_USEDEP}]
	dev-python/pyfiglet[${PYTHON_USEDEP}]
	dev-python/PySocks[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/twitter[${PYTHON_USEDEP}]"
RDEPEND+=" ${DEPEND}"
EGIT_COMMIT="be1eaa59e1549ac8fec72193ff19faa419900b84"
SRC_URI="\
https://github.com/orakaro/rainbowstream/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
PATCHES=( "${FILESDIR}"/${PN}-1.3.7-no-user-env.patch )

python_compile() {
	distutils-r1_python_compile
	cat "${HOME}/.rainbow_config.json" \
		> "${T}/.rainbow_config.json"
}

python_install_all() {
	distutils-r1_python_install_all
	insinto "/usr/share/${P}/homedir/"
	doins "${T}/.rainbow_config.json"
	for python_target in ${PYTHON_TARGETS}; do
		dosym "/etc/rainbowstream/consumer.py" \
		"/usr/lib/${python_target}/site-packages/${PN}/consumer.py"
	done
	insinto /etc/rainbowstream
	doins "${FILESDIR}"/consumer.py
	dodoc LICENSE.txt
}

pkg_postinst() {
	einfo \
"You need to create a consumer.py in /etc/rainbowstream.  Details about this\n\
is in /usr/share/${P}/consumer.py and https://github.com/DTVD/rainbowstream .\n\
You need to copy /usr/share/${P}/homedir/.rainbow_config.json to your homedir."
}
