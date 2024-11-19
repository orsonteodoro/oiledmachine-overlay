# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} ) # upstream listed up to 3.10
CRFSUITE_COMMIT="dc5b6c7b726de90ca63cbf269e6476e18f1dd0d9"
LIBLBFGS_COMMIT="57678b188ae34c2fb2ed36baf54f9a58b4260d1c"

inherit distutils-r1 dep-prepare flag-o-matic

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
https://github.com/scrapinghub/python-crfsuite/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/chokkan/crfsuite/archive/${CRFSUITE_COMMIT}.tar.gz
	-> crfsuite-${CRFSUITE_COMMIT:0:7}.tar.gz
https://github.com/chokkan/liblbfgs/archive/${LIBLBFGS_COMMIT}.tar.gz
	-> liblbfgs-${LIBLBFGS_COMMIT:0:7}.tar.gz
"

DESCRIPTION="Create, fill a temporary directory"
HOMEPAGE="
	https://github.com/scrapinghub/python-crfsuite
	https://pypi.org/project/python-crfsuite
"
LICENSE="
	MIT
"
RESTRICT="mirror test" # untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev doc test"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
# dev-python/numpy-1.26.4 was bumped to avoid build error
BDEPEND+="
	>=dev-python/cython-3[${PYTHON_USEDEP}]
	>=dev-python/setuptools-42[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.26.4[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	dev? (
		dev-python/tox[${PYTHON_USEDEP}]
		dev-python/black[${PYTHON_USEDEP}]
		dev-python/isort[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
	)
	doc? (
		dev-python/numpydoc[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"
DOCS=( "CHANGES.rst" "README.rst" )
PATCHES=(
	"${FILESDIR}/${PN}-0.9.11-no-win32.patch"
)

src_unpack() {
	unpack ${A}
	dep_prepare_mv "${WORKDIR}/crfsuite-${CRFSUITE_COMMIT}" "${S}/crfsuite"
	dep_prepare_mv "${WORKDIR}/liblbfgs-${LIBLBFGS_COMMIT}" "${S}/liblbfgs"
}

python_configure() {
	export CC="gcc"
	export CXX="g++"
	export CPP="${CC} -E"
	strip-unsupported-flags
	# Fix ModuleNotFoundError: No module named 'distutils.msvccompiler'
#	sed -i -e "s|if c.compiler_type|if True or c.compiler_type|g" "setup.py" || die

	local actual_cython_pv=$(cython --version 2>&1 \
		| cut -f 3 -d " " \
		| sed -e "s|a|_alpha|g" \
		| sed -e "s|b|_beta|g" \
		| sed -e "s|rc|_rc|g")
	local expected_cython_pv="3"
	local required_cython_major=$(ver_cut 1 ${expected_cython_pv})
	if ver_test ${actual_cython_pv} -lt ${required_cython_major} ; then
eerror
eerror "Switch cython to >= ${expected_cython_pv} via eselect-cython"
eerror
eerror "Actual cython version:\t${actual_cython_pv}"
eerror "Expected cython version\t${expected_cython_pv}"
eerror
		die
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
