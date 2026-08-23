# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHKL_TIMESTAMPS=(
	"dev-libs/wayland-9999"
	"x11-libs/libX11-9999"
	"x11-libs/libXcursor-9999"
	"x11-libs/libxkbcommon-9999"
)

inherit chkl secure-version cmake-multilib

if [[ "${PV}" =~ "9999" ]] ; then
	INTERNAL_PV="3.6.0" # See https://github.com/glfw/glfw/blob/master/CMakeLists.txt#L3
	SOVER=$(ver_cut "1" "${INTERNAL_PV}")
	FALLBACK_COMMIT="92dcf4ce74f2e2554a98fea09be7c705c17daa5a"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/glfw/glfw.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SOVER=$(ver_cut "1" "${PV}")
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc64 ~riscv x86"
	SRC_URI="https://github.com/glfw/glfw/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Portable OpenGL FrameWork"
HOMEPAGE="https://www.glfw.org/"
LICENSE="ZLIB"
SLOT="0/${SOVER}"
IUSE+=" wayland X"

# Most are dlopen'd so use strings or check the source:
# grep -Eiro '[a-z0-9-]+\.so\.[0-9]+'
DEPEND="
	wayland? (
		>=dev-libs/wayland-${WAYLAND_PV}:=[${MULTILIB_USEDEP}]
		dev-libs/wayland-protocols:=
	)
	X? (
		x11-base/xorg-proto:=
		>=x11-libs/libX11-${LIBX11_PV}:=[${MULTILIB_USEDEP}]
		>=x11-libs/libXcursor-${LIBXCURSOR_PV}:=[${MULTILIB_USEDEP}]
		>=x11-libs/libXi-${LIBXI_PV}:=[${MULTILIB_USEDEP}]
		>=x11-libs/libXinerama-${LIBXINERAMA_PV}:=[${MULTILIB_USEDEP}]
		>=x11-libs/libxkbcommon-${LIBXKBCOMMON_PV}:=[${MULTILIB_USEDEP}]
		>=x11-libs/libXrandr-${LIBXRANDR_PV}:=[${MULTILIB_USEDEP}]
	)
"
RDEPEND="
	${DEPEND}
	>=media-libs/libglvnd-${LIBGLVND_PV}:=[X?,${MULTILIB_USEDEP}]
	wayland? (
		gui-libs/libdecor:=[${MULTILIB_USEDEP}]
	)
	X? (
		>=x11-libs/libXrender-${LIBXRENDER_PV}:=[${MULTILIB_USEDEP}]
		>=x11-libs/libXxf86vm-${LIBXXF86VM_PV}:=[${MULTILIB_USEDEP}]
	)
"
BDEPEND="
	wayland? (
		dev-util/wayland-scanner
		kde-frameworks/extra-cmake-modules
	)
"

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
	local actual_sover=$(grep -e "project(GLFW" "${S}/CMakeLists.txt" | cut -f 3 -d " " | cut -f 1 -d ".")
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Bump ebuild or INTERNAL_PV"
eerror "Actual SOVER:  ${actual_sover}"
eerror "Expected SOVER:  ${expected_sover}"
		die
	fi
}


src_configure() {
	chkl_check_many_timestamps
	local mycmakeargs=(
		-DGLFW_BUILD_EXAMPLES=no
		-DGLFW_BUILD_WAYLAND=$(usex wayland)
		-DGLFW_BUILD_X11=$(usex X)
	)

	cmake-multilib_src_configure
}
