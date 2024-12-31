# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# ASSET_COMMIT is in the repo but not in the pypi tarball.
ASSET_COMMIT="9c9a1f6d61abf3f5072ca0934963fcd75ed24c08" # Nov 4, 2021 from  committer-date:<=2021-11-04  GitHub search
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{8..11} )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${PYPI_PN}-$(pypi_translate_version "${PV}")"
SRC_URI="
	$(pypi_sdist_url --no-normalize)
	test? (
https://github.com/VingtCinq/python-resize-image/raw/${ASSET_COMMIT}/tests/test-image.jpeg
	-> ${PN}-test-image.jpeg.${ASSET_COMMIT:0:7}
	)
"

DESCRIPTION="A small Python package to easily resize images"
HOMEPAGE="https://github.com/VingtCinq/python-resize-image"
LICENSE="MIT"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
RDEPEND+="
	>=virtual/pillow-5.1.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.19.1[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-1.1.20-use-rgb-convert.patch"
)

src_unpack() {
	unpack ${A}
	cp -a \
		$(realpath "${DISTDIR}/${PN}-test-image.jpeg.${ASSET_COMMIT:0:7}") \
		"${S}/tests/test-image.jpeg" \
		|| die
}

src_test() {
	run_test() {
einfo "Running test for ${EPYTHON}"
		coverage run --source resizeimage setup.py test || die
	}
	python_foreach_impl run_test
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
