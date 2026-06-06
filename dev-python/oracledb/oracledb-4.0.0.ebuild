# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CYTHON_SLOT="3.2"
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

ODPI_COMMIT="c0bb1328c4d535743a64f08ec51fb822c2bbcc1e"

inherit cython dep-prepare distutils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="0c8db52ad1d25c3aae98169334e7509f9bb6a4a2" # May 4, 2026
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/oracle/python-oracledb.git"
	IUSE+=" fallback-commit"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/python-oracledb-${PV}"
	inherit pypi
	SRC_URI="
https://github.com/oracle/odpi/archive/${ODPI_COMMIT}.tar.gz
	-> odpi-${ODPI_COMMIT:0:7}.tar.gz
https://github.com/oracle/python-oracledb/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A Python driver for the Oracle database"
HOMEPAGE="
	https://github.com/oracle/python-oracledb
	https://pypi.org/project/oracledb
"
LICENSE="
	|| (
		Apache-2.0
		UPL-1.0
	)
"
RESTRICT="mirror test" # untested
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+="
azure_auth azure_config oci_auth oci_config test
"
RDEPEND+="
	>=dev-python/cryptography-3.2.1[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.14.0[${PYTHON_USEDEP}]
	azure_auth? (
		dev-python/msal[${PYTHON_USEDEP}]
	)
	azure_config? (
		dev-python/azure-appconfiguration[${PYTHON_USEDEP}]
		dev-python/azure-identity[${PYTHON_USEDEP}]
		dev-python/azure-keyvault-secrets[${PYTHON_USEDEP}]
	)
	oci_auth? (
		>=dev-python/requests-2.33[${PYTHON_USEDEP}]
		dev-python/oci[${PYTHON_USEDEP}]
	)
	oci_config? (
		dev-python/oci[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-77.0.0[${PYTHON_USEDEP}]
	dev-python/cython:3.2[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	test? (
		dev-python/anyio[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/pyarrow[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/tox[${PYTHON_USEDEP}]
		virtual/numpy[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" "README.txt" )
PATCHES=(
)

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_prepare() {
	dep_prepare_mv "${WORKDIR}/odpi-${ODPI_COMMIT}" "${S}/src/oracledb/impl/thick/odpi"
	distutils-r1_src_prepare
}

python_configure() {
	cython_set_cython_slot "3.2"
	cython_python_configure
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE.txt" "NOTICE.txt" "THIRD_PARTY_LICENSES.txt"
}

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
