# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This is a meta package
# D12, U22

CMAKE_MAKEFILE_GENERATOR="emake"

inherit check-compiler-switch cmake flag-o-matic

SRC_URI="
https://gitlab.com/coolercontrol/coolercontrol/-/archive/${PV}/coolercontrol-${PV}.tar.bz2
"
S="${WORKDIR}/${PN}-${PV}"

DESCRIPTION="A standalone desktop app for CoolerControl based on Qt6"
HOMEPAGE="
https://gitlab.com/coolercontrol/coolercontrol
https://gitlab.com/coolercontrol/coolercontrol/-/tree/main/coolercontrol
"
LICENSE="
	GPL-3+
"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" wayland X ebuild_revision_1"
REQUIRED_USE="
	|| (
		wayland
		X
	)
"
RDEPEND+="
	>=dev-qt/qtbase-6:6[wayland?,X?]
	>=dev-qt/qtwebchannel-6:6
	>=dev-qt/qtwebengine-6:6
	~sys-apps/coolercontrold-${PV}
"
DEPEND+="
	${RDEPEND}
	dev-build/automake
	dev-build/cmake
	dev-build/make
	sys-devel/gcc[cxx]
"

verify_qt_consistency() {
	local QT_SLOT="6"
	local QTCORE_PV=$(pkg-config --modversion "Qt${QT_SLOT}Core")

	local qt_pv_major=$(ver_cut 1 "${QTCORE_PV}")

	local L=(
		"Qt${QT_SLOT}Webchannel"
		"Qt${QT_SLOT}Webengine"
	)
	local QTPKG_PV
	local pkg_name
	for pkg_name in ${L[@]} ; do
		QTPKG_PV=$(pkg-config --modversion "${pkg_name}")
		if ver_test "${QTCORE_PV}" -ne "${QTPKG_PV}" ; then
eerror
eerror "Qt${QT_SLOT}Core is not the same version as ${pkg_name}."
eerror "Make them the same to continue."
eerror
eerror "Expected version (QtCore):\t\t${QTCORE_PV}"
eerror "Actual version (${pkg_name}):\t${QTPKG_PV}"
eerror
			die
		fi
	done
}

pkg_setup() {
	check-compiler-switch_start
}

src_configure() {
	export CC="gcc"
	export CXX="g++"
	export CPP="${CC} -E"

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Removing LTO."
		filter-lto
	fi

	verify_qt_consistency
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
