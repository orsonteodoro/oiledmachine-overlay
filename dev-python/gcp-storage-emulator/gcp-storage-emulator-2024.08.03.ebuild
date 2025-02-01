# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/oittaa/gcp-storage-emulator.git"
	FALLBACK_COMMIT="39bde7c55f7717d5ef5653abb89d86d8e0a5b04a" # Aug 3, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/oittaa/gcp-storage-emulator/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Local emulator for Google Cloud Storage"
HOMEPAGE="
	https://github.com/oittaa/gcp-storage-emulator
	https://pypi.org/project/gcp-storage-emulator
"
LICENSE="
	BSD
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev"
RDEPEND+="
	dev-python/fs[${PYTHON_USEDEP}]
	dev-python/google-crc32c[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	dev? (
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/google-cloud-storage[${PYTHON_USEDEP}]
		dev-python/google-crc32c[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENCE.md"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
