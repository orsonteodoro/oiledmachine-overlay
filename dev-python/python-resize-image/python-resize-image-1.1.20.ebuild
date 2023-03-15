# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="A Small python package to easily resize images"
HOMEPAGE="https://github.com/VingtCinq/python-resize-image"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
DEPEND+="
	>=dev-python/pillow-5.1.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.19.1[${PYTHON_USEDEP}]
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/tox[${PYTHON_USEDEP}]
	)
"
ASSET_COMMIT="fb3e82d0da2c108e05499f57cdf5c02210b482f7" # In the repo but not in the pypi tarball.
SRC_URI="
mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	test? (
https://github.com/VingtCinq/python-resize-image/raw/${ASSET_COMMIT}/tests/test-image.jpeg
	-> ${PN}-test-image.jpeg.${ASSET_COMMIT:0:7}
	)
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
PATCHES=(
	"${FILESDIR}/${PN}-1.1.20-use-rgb-convert.patch"
)

src_unpack() {
	unpack ${A}
	cp -a \
		$(realpath "${DISTDIR}/${PN}-test-image.jpeg.${ASSET_COMMIT:0:7}") \
		"${S}/tests/test-image.jpeg"
}

src_test() {
	run_test() {
einfo "Running test for ${PYTHON}"
		coverage run --source resizeimage setup.py test || die
	}
	python_foreach_impl run_test
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
