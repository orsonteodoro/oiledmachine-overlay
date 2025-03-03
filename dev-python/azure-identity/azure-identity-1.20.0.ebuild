# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="azure_identity"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..13} )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
	$(pypi_wheel_url ${PN} ${PV})
"

DESCRIPTION="Microsoft Azure Identity Library for Python"
HOMEPAGE="
	https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/identity/azure-identity
	https://pypi.org/project/azure-identity/
"
LICENSE="MIT"
RESTRICT="
	!test? (
		test
	)
"
SLOT="0"
IUSE="test"
RDEPEND="
	>=dev-python/azure-core-1.31.0[${PYTHON_USEDEP}]
	>=dev-python/cryptography-2.5[${PYTHON_USEDEP}]
	>=dev-python/msal-1.30.0[${PYTHON_USEDEP}]
	>=dev-python/msal-extensions-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	app-arch/unzip
	dev-python/gpep517[${PYTHON_USEDEP}]
"
DOCS=()

distutils_enable_tests "pytest"

src_unpack() {
	mkdir -p "${S}" || die
	:
}

python_compile() {
einfo "EPYTHON:  ${EPYTHON}"
	local wheel_path
	local d="${WORKDIR}/${PN}-${PV}-${EPYTHON/./_}/install"
	mkdir -p "${d}" || die
	wheel_path=$(realpath "${DISTDIR}/${MY_PN}-${PV}-py3-none-any.whl")
	distutils_wheel_install "${d}" \
		"${wheel_path}"
}

src_install() {
	distutils-r1_src_install
}
