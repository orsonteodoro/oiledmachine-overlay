# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# A middle man package for copy-paste
CFLAGS_HARDENED_LANGS="cxx"
CFLAGS_HARDENED_USE_CASES="copy-paste-password security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VTABLE_VERIFY=1
CXX_STANDARD=17

FALLBACK_COMMIT="882935fdbc3b06dc4cd45b8e5181906916403243"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

CHKL_TIMESTAMPS=(
	"dev-qt/qtbase-6.9999"
	"dev-qt/qtdeclarative-6.9999"
	"dev-qt/qtsvg-6.9999"
	"dev-libs/wayland-9999"
	"x11-libs/libxkbcommon-9999"
)

inherit cflags-hardened chkl libcxx-slot libstdcxx-slot secure-version qt6-build

DESCRIPTION="Toolbox for making Qt based Wayland compositors"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
fi

IUSE+="
gnome qml
ebuild_revision_1
"

RDEPEND="
	>=dev-libs/wayland-${WAYLAND_PV}:=
	~dev-qt/qtbase-${PV}:6=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},gui,opengl,wayland]
	media-libs/libglvnd:=
	>=x11-libs/libxkbcommon-${LIBXKBCOMMON_PV}:=
	qml? (
		~dev-qt/qtdeclarative-${PV}:6=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	)
	gnome? (
		~dev-qt/qtbase-${PV}:6=[dbus]
		~dev-qt/qtsvg-${PV}:6=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/wayland-scanner
"

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	local mycmakeargs=(
		$(cmake_use_find_package qml Qt6Quick)
		$(qt_feature gnome wayland_decoration_adwaita)
	)

	qt6-build_src_configure
}
