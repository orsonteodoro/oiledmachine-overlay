# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} ) # upstream listed up to 3.10
CRFSUITE_COMMIT="dc5b6c7b726de90ca63cbf269e6476e18f1dd0d9"
LIBLBFGS_COMMIT="57678b188ae34c2fb2ed36baf54f9a58b4260d1c"

inherit check-compiler-switch distutils-r1 dep-prepare flag-o-matic

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

DESCRIPTION="A Python binding for CRFsuite"
HOMEPAGE="
	https://github.com/scrapinghub/python-crfsuite
	https://pypi.org/project/python-crfsuite
"
LICENSE="
	MIT
"
RESTRICT="mirror test" # untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
dev doc test
ebuild_revision_5
"
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

pkg_setup() {
	check-compiler-switch_start
	python_setup
}

src_unpack() {
	unpack ${A}
	dep_prepare_mv "${WORKDIR}/crfsuite-${CRFSUITE_COMMIT}" "${S}/crfsuite"
	dep_prepare_mv "${WORKDIR}/liblbfgs-${LIBLBFGS_COMMIT}" "${S}/liblbfgs"
}

python_configure() {
	export CC="${CHOST}-gcc"
	export CXX="${CHOST}-g++"
	export CPP="${CC} -E"
	strip-unsupported-flags

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	# Fix ModuleNotFoundError: No module named 'distutils.msvccompiler'
#	sed -i -e "s|if c.compiler_type|if True or c.compiler_type|g" "setup.py" || die

	local actual_cython_pv=$(cython --version 2>&1 \
		| cut -f 3 -d " " \
		| sed -e "s|a|_alpha|g" \
		| sed -e "s|b|_beta|g" \
		| sed -e "s|rc|_rc|g")
	local actual_cython_slot=$(ver_cut 1-2 ${actual_cython_pv})
	if ver_test ${actual_cython_slot} -ne "3.0" && ver_test ${actual_cython_slot} -ne "3.1" ; then
eerror
eerror "Do \`eselect cython set 3.0\` or \`eselect cython set 3.1\` to continue."
eerror
eerror "Actual cython version:\t${actual_cython_pv}"
eerror "Expected cython version\t3.0 or 3.1"
eerror
		die
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
