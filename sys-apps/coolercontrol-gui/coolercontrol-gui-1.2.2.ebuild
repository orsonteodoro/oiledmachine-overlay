# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U 22.04

DISTUTILS_USE_PEP517="poetry"
QT_PV="6.6.2"
PYTHON_COMPAT=( python3_{10..11} ) # Can support 3.12 but limited by Nuitka

inherit desktop distutils-r1 xdg

KEYWORDS="~amd64"
S="${WORKDIR}/coolercontrol-${PV}/coolercontrol-gui"
SRC_URI="
https://gitlab.com/coolercontrol/coolercontrol/-/archive/${PV}/coolercontrol-${PV}.tar.bz2
"

DESCRIPTION="coolercontrol-gui is the frontend UI, client of the daemon program, and main coolercontrol program and desktop application"
HOMEPAGE="
https://gitlab.com/coolercontrol/coolercontrol
https://gitlab.com/coolercontrol/coolercontrol/-/tree/main/coolercontrol-gui
"
LICENSE="
	GPL-3+
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" hwmon wayland X r2"
REQUIRED_USE="
	|| (
		wayland
		X
	)
"
RDEPEND+="
	${PYTHON_DEPS}
	>=dev-python/APScheduler-3.8.1[${PYTHON_USEDEP}]
	>=dev-python/dataclass-wizard-0.22.2[${PYTHON_USEDEP}]
	>=dev-python/jeepney-0.7.1[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-3.5.1[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.21.5[${PYTHON_USEDEP}]
	>=dev-python/requests-2.25.1[${PYTHON_USEDEP}]
	>=dev-python/setproctitle-1.2.2[${PYTHON_USEDEP}]
	>=media-libs/mesa-22.0.1
	~dev-python/pyside6-${QT_PV}[${PYTHON_USEDEP},svg,widgets,xml]
	~dev-qt/qtbase-${QT_PV}[wayland?,X?]
	hwmon? (
		>=sys-apps/lm-sensors-3.6.0
	)
	~sys-apps/coolercontrold-${PV}[hwmon?]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	>=dev-python/Nuitka-0.6.19.1[${PYTHON_USEDEP}]
	>=dev-python/poetry-1.1.12[${PYTHON_USEDEP}]
	>=dev-build/make-4.3
"

pkg_setup() {
ewarn "Do not emerge ${CATEGORY}/${PN} package directly.  Emerge sys-apps/coolercontrol instead."
	python_setup
}

set_gui_port() {
	local L=(
		"coolercontrol-gui/coolercontrol/repositories/daemon_repo.py"
	)
	local port=${COOLERCONTROL_GUI_PORT:-11987}
	local p
	for p in "${L[@]}" ; do
		sed -i -e "s|11987|${port}|g" "${p}" || die
	done
}

python_configure() {
	pushd "${WORKDIR}/coolercontrol-${PV}" || die
		set_gui_port
	popd
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

gen_wrapper() {
	# dev-lang/python-exec requires exact name for it to work.
	# A workaround for using a different name.
cat <<EOF > "${ED}/usr/bin/coolercontrol-qt6"
#!/bin/bash
EPYTHON="${EPYTHON:-${EPYTHON}}"
\${EPYTHON} -m coolercontrol "\${@}"
EOF
ewarn "coolercontrol-qt6 is using the same file permissions as unwrapped."
# Some fan programs require elevated priveleges I think.
	fperms 0755 "/usr/bin/coolercontrol-qt6"
}

python_install_all() {
	distutils-r1_python_install_all
	python_optimize
	rm "${ED}/usr/bin/coolercontrol" || die
	gen_wrapper
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
