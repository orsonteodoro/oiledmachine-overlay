# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A smart and nice Twitter client on terminal written in Python."
HOMEPAGE="http://www.rainbowstream.org/"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86"
SLOT="0"
PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1
EGIT_COMMIT="1bb3cd901f6814d63abf2bd35718634dc808aeaa"
IUSE="jpeg"
DEPEND="dev-python/arrow[${PYTHON_USEDEP}]
	dev-python/pillow[jpeg?,${PYTHON_USEDEP}]
	dev-python/pocket[${PYTHON_USEDEP}]
	dev-python/pyfiglet[${PYTHON_USEDEP}]
	dev-python/PySocks[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/twitter[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
SRC_URI="\
https://github.com/orakaro/rainbowstream/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
inherit eutils
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
PATCHES=( "${FILESDIR}"/${PN}-1.3.7-no-user-env.patch
	"${FILESDIR}"/${PN}-1.3.5-requests-relax-version.patch )

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
