# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# A middle man package for copy-paste
CFLAGS_HARDENED_LANGS="cxx"
CFLAGS_HARDENED_USE_CASES="copy-paste-password security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VTABLE_VERIFY=1
CXX_STANDARD=17

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX17[@]}
)

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}
)

inherit cflags-hardened libcxx-slot libstdcxx-slot qt6-build

DESCRIPTION="Wayland platform plugin for Qt"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv x86"
fi

IUSE="accessibility compositor gnome qml vulkan"

RDEPEND="
	dev-libs/wayland
	~dev-qt/qtbase-${PV}:6[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},accessibility=,gui,opengl,vulkan=,wayland]
	dev-qt/qtbase:=
	media-libs/libglvnd
	x11-libs/libxkbcommon
	compositor? (
		qml? (
			~dev-qt/qtdeclarative-${PV}:6[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
			dev-qt/qtdeclarative:=
		)
	)
	gnome? (
		~dev-qt/qtbase-${PV}:6[dbus]
		~dev-qt/qtsvg-${PV}:6[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		dev-qt/qtsvg:=
	)
"
DEPEND="
	${RDEPEND}
	vulkan? ( dev-util/vulkan-headers )
"
BDEPEND="dev-util/wayland-scanner"

CMAKE_SKIP_TESTS=(
	# segfaults for not-looked-into reasons, but not considered
	# an issue given >=seatv5 exists since wayland-1.10 (2016)
	tst_seatv4
	# needs a compositor/opengl, skip the extra trouble
	tst_surface
	tst_xdgdecorationv1
	# known failing with wayland-1.23.0 (or at least with offscreen), not
	# believed to result in critical runtime issues so skip until this is
	# looked at upstream (https://bugreports.qt.io/browse/QTBUG-126379)
	tst_client
	tst_compositor
	tst_scaling
)

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_configure() {
	cflags-hardened_append
	local mycmakeargs=(
		$(cmake_use_find_package compositor Qt6Quick)
		$(cmake_use_find_package qml Qt6Quick)
		$(qt_feature compositor wayland_server)
		$(qt_feature gnome wayland_decoration_adwaita)
	)

	qt6-build_src_configure
}

src_test() {
	# users' session setting may break tst_clientextension (bug #927030)
	unset DESKTOP_SESSION XDG_CURRENT_DESKTOP
	unset GNOME_DESKTOP_SESSION_ID KDE_FULL_SESSION

	qt6-build_src_test
}
