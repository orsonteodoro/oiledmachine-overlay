# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN//-bin/}"
MY_P="${MY_PN}-${PV}" # Line must go after MY_PN.

DISTUTILS_USE_PEP517="setuptools"
HOSTED="files.pythonhosted.org/packages/py3/${MY_P:0:1}/${MY_PN}/${MY_P}-py3-none"
PYTHON_COMPAT=( "python3_"{10..13} )
QA_PREBUILT="usr/lib/python*/site-packages/playwright/driver/node"

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/"
SRC_URI="
	amd64? (
		https://${HOSTED}-manylinux1_x86_64.whl -> ${MY_P}_x86_64.zip
	)
	arm64? (
		https://${HOSTED}-manylinux_2_17_aarch64.manylinux2014_aarch64.whl -> ${MY_P}_aarch64.zip
	)
"

DESCRIPTION="Automate Chromium, Firefox and WebKit browsers with a single API"
HOMEPAGE="https://github.com/Microsoft/playwright-python"
LICENSE="Apache-2.0"
RESTRICT="test"
SLOT="0"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"
RDEPEND="
	(
		>=dev-python/pyee-12[${PYTHON_USEDEP}]
		<dev-python/pyee-13[${PYTHON_USEDEP}]
	)
	(
		>=dev-python/greenlet-3.1.1[${PYTHON_USEDEP}]
		<dev-python/greenlet-4.0.0[${PYTHON_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-python/auditwheel-6.2.0[${PYTHON_USEDEP}]
	>=dev-python/setuptools-75.6.0[${PYTHON_USEDEP}]
	>=dev-python/setuptools-scm-8.1.0[${PYTHON_USEDEP}]
	>=dev-python/wheel-0.45.1[${PYTHON_USEDEP}]
	app-arch/unzip
"

pkg_setup() {
	python_setup
}

src_compile() {
	:
}

#python_src_install() {
src_install() {
#	insinto "$(python_get_sitedir)"
#	doins playwright
#	doins playwright-${PV}.dist-info
	do_install() {
		python_domodule "${MY_PN}"
		python_domodule "${MY_PN}-${PV}.dist-info"
		#FIXME: playwright/driver/node and playwright.sh must be executable?
		#dosym  /opt/${MY_PN} "$(python_get_sitedir)/${MY_PN}/executable"
	}
	python_foreach_impl "do_install"
}
