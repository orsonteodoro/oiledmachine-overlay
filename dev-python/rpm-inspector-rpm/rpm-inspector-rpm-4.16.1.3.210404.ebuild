# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# The last release was 4 years ago, so live is used.

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="65bab7582ce14c55cdeec2244c65ea23039c9e6f"
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/nexB/scancode-plugins.git"
	IUSE+=" fallback-commit"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	inherit pypi
	SRC_URI="
mirror://pypi/${PN:0:1}/${PN}/${PN}-${PV}.tar.gz
	"
fi

DESCRIPTION="A ScanCode path provider plugin to provide a prebuilt native rpm binary built with many rpm backend database formats supported. The rpm binary is built from sources that are bundled in the repo and sdist."
HOMEPAGE="
	https://github.com/nexB/scancode-plugins
	https://pypi.org/project/rpm-inspector-rpm
"
LICENSE="
	(
		Apache-2.0
		(
			GPL-2.0
			LGPL-2.0
		)
	)
"
RESTRICT="mirror test" # untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
"
RDEPEND+="
	dev-python/plugincode[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "rpm-inspector-rpm.ABOUT" "rpm.ABOUT" "README.rst" )
PATCHES=(
)

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "version=\"4.16.1.3.210404\"" "${S}/setup.py" \
			|| die "QA:  Bump version"
	else
		unpack ${A}
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "apache-2.0.LICENSE" "gpl-2.0.LICENSE" "lgpl-2.0.LICENSE" "rpm.NOTICE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
