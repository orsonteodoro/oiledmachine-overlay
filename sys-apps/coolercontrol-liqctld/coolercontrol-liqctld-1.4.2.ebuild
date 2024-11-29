# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U 22.04

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{10,11} ) # Can support 3.12 but limited by Nuitka

inherit lcnr distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/coolercontrol-${PV}/coolercontrol-liqctld"
SRC_URI="
https://gitlab.com/coolercontrol/coolercontrol/-/archive/${PV}/coolercontrol-${PV}.tar.bz2
"

DESCRIPTION="A daemon for interacting with liquidctl"
HOMEPAGE="
https://gitlab.com/coolercontrol/coolercontrol
https://gitlab.com/coolercontrol/coolercontrol/-/tree/main/coolercontrol-liqctld
"
LICENSE="
	GPL-3+
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" openrc systemd ebuild-revision-1"
RDEPEND+="
	${PYTHON_DEPS}
	>=app-misc/liquidctl-1.5.1[${PYTHON_USEDEP}]
	>=dev-python/fastapi-0.63.0[${PYTHON_USEDEP}]
	>=dev-python/orjson-3.9.10[${PYTHON_USEDEP}]
	>=dev-python/setproctitle-1.2.2[${PYTHON_USEDEP}]
	>=dev-python/uvicorn-0.15.0[${PYTHON_USEDEP}]
	>=dev-libs/libusb-1.0.25
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	>=dev-python/Nuitka-0.6.19.1[${PYTHON_USEDEP}]
	>=dev-python/poetry-1.1.12[${PYTHON_USEDEP}]
	>=dev-python/setuptools-46.4[${PYTHON_USEDEP}]
	>=dev-build/make-4.3
	dev-python/wheel[${PYTHON_USEDEP}]
"

set_gui_port() {
	local L=(
		"coolercontrol-liqctld/coolercontrol_liqctld/server.py"
	)
	local port=${COOLERCONTROL_GUI_PORT:-11987}
	local p
	for p in "${L[@]}" ; do
		sed -i -e "s|11987|${port}|g" "${p}" || die
	done
}

set_liqctld_port() {
	local L=(
		"coolercontrol-liqctld/coolercontrol_liqctld/server.py"
	)
	local port=${COOLERCONTROL_LIQCTLD_PORT:-11986}
	local p
	for p in "${L[@]}" ; do
		sed -i -e "s|11986|${port}|g" "${p}" || die
	done
}

pkg_setup() {
ewarn "Do not emerge ${CATEGORY}/${PN} package directly.  Emerge sys-apps/coolercontrol instead."
	python_setup
}

python_configure() {
	pushd "${WORKDIR}/coolercontrol-${PV}" || die
		set_gui_port
		set_liqctld_port
	popd
}

# Disabled
_python_compile() {
	#poetry install
	poetry run ${EPYTHON} -m nuitka coolercontrol-liqctld.py
}

python_install_all() {
	distutils-r1_python_install_all
	python_optimize
	if use openrc ; then
ewarn
ewarn "The OpenRC script is experimental for ${CATEGORY}/${PN}."
ewarn "If it works, send an issue request to remove this message."
ewarn
		exeinto /etc/init.d
		doexe "${FILESDIR}/coolercontrol-liqctld"
	fi
	if use systemd ; then
		insinto /lib/systemd/system
		doins "${WORKDIR}/coolercontrol-${PV}/packaging/systemd/coolercontrol-liqctld.service"
	fi
	if ! use openrc && ! use systemd ; then
ewarn
ewarn "You are responsible to creating the init service for ${PN} for your"
ewarn "init system."
ewarn
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  passed (0.17.2, 20131201)
