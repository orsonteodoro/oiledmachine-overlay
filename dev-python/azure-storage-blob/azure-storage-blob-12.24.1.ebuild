# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="azure_storage_blob"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
	$(pypi_wheel_url ${PN} ${PV})
"

DESCRIPTION="Microsoft Azure Blob Storage Client Library for Python"
HOMEPAGE="
	https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/storage/azure-storage-blob
	https://pypi.org/project/azure-storage-blob/
"
LICENSE="MIT"
SLOT="0"
IUSE="aio test"
RESTRICT="
	!test? (
		test
	)
"
DOCS=()
RDEPEND="
	>=dev-python/azure-core-1.30.0[${PYTHON_USEDEP},aio(+)]
	>=dev-python/cryptography-2.1.4[${PYTHON_USEDEP}]
	>=dev-python/isodate-0.6.1[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.6.0[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools-74.1.3[${PYTHON_USEDEP}]
	app-arch/unzip
"

distutils_enable_tests "pytest"

src_unpack() {
	mkdir -p "${S}" || die
#	unzip "${DISTDIR}/${MY_PN}-${PV}-py3-none-any.whl"
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
