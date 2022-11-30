# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Framework to write Wayland compositors with Qt"
HOMEPAGE="https://github.com/lirios/aurora-compositor"
LICENSE="
	BSD
	GPL-3+
	FDL-1.3
	|| (
		LGPL-3+
		|| ( GPL-2 GPL-3+ )
	)
"
# BSD - features.cmake
# BSD - src/extensions/libhybris-egl-server-buffer.xml

# Live/snapshots ebuilds do not get KEYWORDS

SLOT="0/$(ver_cut 1-3 ${PV})"
IUSE_FEATURES=(
	datadevice
	brcm
	compositor-quick
	datadevice
	dmabuf-client-buffer
	dmabuf-server-buffer
	drm-atomic
	drm-egl-server-buffer
	libhybris-egl-server-buffer
	qpa
	shm-emulation-server
	vulkan-server-buffer
	wayland-egl
	xkbcommon
	xwayland
)
IUSE+="
${IUSE_FEATURES[@]/#/+}
test

r1
"
REQUIRED_USE+="
	qpa? ( xkbcommon )
"
QT_MIN_PV=5.15
EGL_DEPENDS="
	>=dev-qt/qtgui-${QT_MIN_PV}:5=[egl]
	>=dev-qt/qtopengl-${QT_MIN_PV}:5=
	media-libs/libglvnd
	x11-libs/libdrm
"
DEPEND+="
	>=dev-qt/qtcore-${QT_MIN_PV}:5=
	>=dev-qt/qtdbus-${QT_MIN_PV}:5=
	>=dev-qt/qtgui-${QT_MIN_PV}:5=[wayland]
	>=dev-qt/qtxml-${QT_MIN_PV}:5=
	>=dev-libs/wayland-1.15
	>=dev-libs/wayland-protocols-1.15
	dev-libs/libinput
	media-libs/fontconfig
	x11-libs/libX11
	compositor-quick? (
		>=dev-qt/qtdeclarative-${QT_MIN_PV}:5=
	)
	dmabuf-client-buffer? (
		${EGL_DEPENDS}
	)
	dmabuf-server-buffer? (
		${EGL_DEPENDS}
	)
	drm-egl-server-buffer? (
		>=dev-qt/qtgui-${QT_MIN_PV}:5=[egl]
		media-libs/libglvnd
	)
	shm-emulation-server? (
		>=dev-qt/qtopengl-${QT_MIN_PV}:5=

	)
	qpa? (
		${EGL_DEPENDS}
		virtual/udev
	)
	vulkan-server-buffer? (
		>=dev-qt/qtopengl-${QT_MIN_PV}:5=
		media-libs/vulkan-loader
	)
	wayland-egl? (
		${EGL_DEPENDS}
	)
	xwayland? (
		x11-libs/libxcb
		x11-libs/libXcursor
	)
	xkbcommon? (
		x11-libs/libxkbcommon
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=dev-qt/qttest-${QT_MIN_PV}:5=
	>=dev-util/cmake-3.10.0
	virtual/pkgconfig
	vulkan-server-buffer? (
		dev-util/vulkan-headers
	)
	~liri-base/aurora-scanner-0.0.0_p9999
	~liri-base/cmake-shared-2.0.0_p9999
"
SRC_URI=""
EGIT_BRANCH="develop"
EGIT_REPO_URI="https://github.com/lirios/${PN}.git"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

pkg_setup() {
	QTCORE_PV=$(pkg-config --modversion Qt5Core)
	QTDBUS_PV=$(pkg-config --modversion Qt5DBus)
	QTGUI_PV=$(pkg-config --modversion Qt5Gui)
	QTXML_PV=$(pkg-config --modversion Qt5Xml)
	if ver_test ${QTCORE_PV} -ne ${QTDBUS_PV} ; then
		die "Qt5Core is not the same version as Qt5DBus"
	fi
	if ver_test ${QTCORE_PV} -ne ${QTGUI_PV} ; then
		die "Qt5Core is not the same version as Qt5Gui"
	fi
	if use compositor-quick ; then
		QTQML_PV=$(pkg-config --modversion Qt5Qml)
		if ver_test ${QTCORE_PV} -ne ${QTQML_PV} ; then
			die "Qt5Core is not the same version as Qt5Qml (qtdeclarative)"
		fi
	fi
	if \
		   use dmabuf-client-buffer \
		&& use dmabuf-server-buffer \
		&& use qpa \
		&& use shm-emulation-server \
		&& use vulkan-server-buffer \
		&& use wayland-egl \
	; then
		QTOPENGL_PV=$(pkg-config --modversion Qt5OpenGL)
		if ver_test ${QTCORE_PV} -ne ${QTOPENGL_PV} ; then
			die "Qt5Core is not the same version as Qt5OpenGL"
		fi
	fi
	if ver_test ${QTCORE_PV} -ne ${QTXML_PV} ; then
		die "Qt5Core is not the same version as Qt5Xml"
	fi
	QTTEST_PV=$(pkg-config --modversion Qt5Test)
	if ver_test ${QTCORE_PV} -ne ${QTTEST_PV} ; then
		die "Qt5Core is not the same version as Qt5Test"
	fi
}

src_unpack() {
	git-r3_fetch
	git-r3_checkout
	local v_live=$(grep -r -e "VERSION \"" "${S}/CMakeLists.txt" \
		| head -n 1 \
		| cut -f 2 -d "\"")
	local v_expected=$(ver_cut 1-3 ${PV})
	if ver_test ${v_expected} -ne ${v_live} ; then
		eerror
		eerror "Version bump required."
		eerror
		eerror "v_expected=${v_expected}"
		eerror "v_live=${v_live}"
		eerror
		die
	else
		einfo
		einfo "v_expected=${v_expected}"
		einfo "v_live=${v_live}"
		einfo
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DFEATURE_aurora_brcm=$(usex brcm)
		-DFEATURE_aurora_compositor_quick=$(usex compositor-quick)
		-DFEATURE_aurora_datadevice=$(usex datadevice)
		-DFEATURE_aurora_dmabuf_client_buffer=$(usex dmabuf-client-buffer)
		-DFEATURE_aurora_dmabuf_server_buffer=$(usex dmabuf-server-buffer)
		-DFEATURE_aurora_drm_atomic=$(usex drm-atomic)
		-DFEATURE_aurora_drm_egl_server_buffer=$(usex drm-egl-server-buffer)
		-DFEATURE_aurora_libhybris_egl_server_buffer=$(usex libhybris-egl-server-buffer)
		-DFEATURE_aurora_qpa=$(usex qpa)
		-DFEATURE_aurora_shm_emulation_server=$(usex shm-emulation-server)
		-DFEATURE_aurora_vulkan_server_buffer=$(usex vulkan-server-buffer)
		-DFEATURE_aurora_wayland_egl=$(usex wayland-egl)
		-DFEATURE_aurora_xkbcommon=$(usex xkbcommon)
		-DFEATURE_aurora_xwayland=$(usex xwayland)
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
		-DINSTALL_PLUGINSDIR=/usr/$(get_libdir)/qt5/plugins
		-DINSTALL_QMLDIR=/usr/$(get_libdir)/qt5/qml
	)
	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
