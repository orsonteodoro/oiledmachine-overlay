# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_TARBALL="${P}.tar.gz"
NODE_SLOTS=( 16 ) # Upstream uses node 16
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} ) # Lists up to 3.12

inherit distutils-r1 npm

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/facultyai/dash-bootstrap-components/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Bootstrap components for Plotly Dash"
HOMEPAGE="
https://dash-bootstrap-components.opensource.faculty.ai/
https://github.com/facultyai/dash-bootstrap-components
https://pypi.org/project/dash-bootstrap-components/
"
LICENSE="Apache-2.0"
RESTRICT="mirror test" # Did not test
SLOT="0"
IUSE="dev pandas ebuild_revision_3"
RDEPEND+="
	>=sci-visualization/dash-2.0.0[${PYTHON_USEDEP},dev(+)]
	pandas? (
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-42[${PYTHON_USEDEP}]
	dev-python/invoke[${PYTHON_USEDEP}]
	dev-python/semver[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	net-libs/nodejs:16[jit,webassembly]
	dev? (
		>=sci-visualization/dash-2.0.0[${PYTHON_USEDEP},dev(+)]
		dev-python/build[${PYTHON_USEDEP}]
		dev-python/termcolor[${PYTHON_USEDEP}]

		>=dev-python/pytest-6.0[${PYTHON_USEDEP}]
		dev-python/black[${PYTHON_USEDEP}]
	)
"

#distutils_enable_tests "pytest"

pkg_setup() {
	python_setup
	npm_pkg_setup
}

src_unpack() {
	npm_src_unpack
}

src_compile() {
	npm_hydrate
	enpm run build
	distutils-r1_src_compile
	grep -q -e "WARNING warning: no files found matching" "${T}/build.log" && die "Detected error"
	grep -q -e "ModuleNotFoundError: No module named" "${T}/build.log" && die "Detected error"
}

src_install() {
	distutils-r1_src_install
}
