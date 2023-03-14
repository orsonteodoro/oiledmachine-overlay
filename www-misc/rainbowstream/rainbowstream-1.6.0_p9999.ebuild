# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1 git-r3

DESCRIPTION="A smart and nice Twitter client on terminal written in Python."
HOMEPAGE="http://www.rainbowstream.org/"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86"
SLOT="0"
IUSE+=" doc fallback-commit jpeg sixel"
DEPEND+="
	dev-python/arrow[${PYTHON_USEDEP}]
	dev-python/pillow[jpeg?,${PYTHON_USEDEP}]
	dev-python/pocket[${PYTHON_USEDEP}]
	dev-python/pyfiglet[${PYTHON_USEDEP}]
	dev-python/PySocks[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/twitter[${PYTHON_USEDEP}]
	sixel? (
		media-libs/libsixel[${PYTHON_USEDEP},python]
		dev-python/python-resize-image[${PYTHON_USEDEP}]
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
PATCHES=(
	"${FILESDIR}/${PN}-1.3.7-no-user-env.patch"
)

EXPECTED_PV="${PV%_*}"

distutils_enable_sphinx "docs"

src_unpack() {
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/orakaro/rainbowstream.git"
	EGIT_COMMIT="HEAD"
	use fallback-commit && EGIT_COMMIT="8b2efa52574865646adfb157f4563a72d9e37d96"
	git-r3_fetch
	git-r3_checkout
	local pv=$(grep "version = " "${S}/setup.py" \
		| cut -f 3 -d " " \
		| sed -e "s|'||g")
#einfo "pv:  ${pv}"
	if ver_test "${pv}" -ne "${EXPECTED_PV}" ; then
eerror
eerror "Version change detected"
eerror
eerror "Expected version:  ${EXPECTED_PV}"
eerror "Actual version:  ${pv}"
eerror
eerror "Bump the EXPECTED_PV, check dependencies, check patches"
eerror
eerror "\tor"
eerror
eerror "Use the fallback-commit USE flag to continue"
eerror
		die
	fi
}

python_compile() {
	distutils-r1_python_compile
	cat "${HOME}/.rainbow_config.json" \
		> "${T}/.rainbow_config.json" || die
}

python_install_all() {
	distutils-r1_python_install_all
	insinto "/usr/share/${P}/homedir/"
	doins "${T}/.rainbow_config.json"
	for python_target in ${PYTHON_TARGETS}; do
		dosym \
			"/etc/rainbowstream/consumer.py" \
			"/usr/lib/${python_target}/site-packages/${PN}/consumer.py"
	done
	insinto /etc/rainbowstream
	doins "${FILESDIR}"/consumer.py
	dodoc LICENSE.txt
}

pkg_postinst() {
einfo
einfo "You need to create a consumer.py in /etc/rainbowstream.  Details about"
einfo "this is in /usr/share/${P}/consumer.py and online at"
einfo
einfo "  https://github.com/DTVD/rainbowstream"
einfo
einfo
einfo "You need to copy"
einfo
einfo "  /usr/share/${P}/homedir/.rainbow_config.json"
einfo
einfo "to your homedir."
einfo
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
