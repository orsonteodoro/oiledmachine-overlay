# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="poetry"
PYTHON_COMPAT=( python3_{10..11} ) # Can support 3.12 but limited by Nuitka

inherit desktop distutils-r1 xdg

SRC_URI="
https://gitlab.com/coolercontrol/coolercontrol/-/archive/${PV}/coolercontrol-${PV}.tar.bz2
"
S="${WORKDIR}/coolercontrol-${PV}/coolercontrol-gui"

DESCRIPTION="coolercontrol-gui is the frontend UI, client of the daemon program, and main coolercontrol program and desktop application"
HOMEPAGE="
https://gitlab.com/coolercontrol/coolercontrol
https://gitlab.com/coolercontrol/coolercontrol/-/tree/main/coolercontrol-gui
"
LICENSE="
	GPL-3+
"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" wayland X r1"
REQUIRED_USE="
	|| (
		wayland
		X
	)
"
# U 20.04
RDEPEND+="
	${PYTHON_DEPS}
	>=dev-python/APScheduler-3.10.4[${PYTHON_USEDEP}]
	>=dev-python/dataclass-wizard-0.22.2[${PYTHON_USEDEP}]
	>=dev-python/jeepney-0.8.0[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-3.8.2[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.26.2[${PYTHON_USEDEP}]
	>=dev-python/pyside6-6.6.0[${PYTHON_USEDEP},svg,widgets,xml]
	>=dev-python/requests-2.31.0[${PYTHON_USEDEP}]
	>=dev-python/setproctitle-1.3.3[${PYTHON_USEDEP}]
	>=dev-qt/qtbase-6.6.0[wayland?,X?]
	>=media-libs/mesa-20.0.4
	~sys-apps/coolercontrold-${PV}
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	>=dev-python/Nuitka-1.9[${PYTHON_USEDEP}]
	>=dev-python/poetry-1.4.2[${PYTHON_USEDEP}]
	>=sys-devel/make-4.2.1
"
RESTRICT="mirror"

pkg_setup() {
ewarn "Do not emerge ${CATEGORY}/${PN} package directly.  Emerge sys-apps/coolercontrol instead."
	python_setup
}

# Using nuitka is broken
_python_compile() {
	${EPYTHON} -m nuitka --static-libpython=no --enable-plugins=pyside6 coolercontrol.py || die
	mv \
		coolercontrol.dist/coolercontrol.bin \
		coolercontrol.dist/coolercontrol-gui \
		|| die
	mv \
		coolercontrol.dist/coolercontrol_data \
		coolercontrol.dist/coolercontrol \
		|| die
}

src_install() {
	distutils-r1_python_install_all
	python_optimize
	mv "${ED}/usr/bin/coolercontrol"{,-qt6} || die
	make_desktop_entry \
		"/usr/bin/coolercontrol-qt6" \
		"CoolerControl (Qt6)" \
		"org.coolercontrol.CoolerControl" \
		"Utility;"
}

pkg_postinst() {
	ln -sf \
		"${EROOT}/usr/bin/coolercontrol-qt6" \
		"${EROOT}/usr/bin/coolercontrol" \
		|| die
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  passed (0.17.2, 20231201)
