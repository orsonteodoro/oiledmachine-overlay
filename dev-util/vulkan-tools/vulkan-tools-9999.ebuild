# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=Vulkan-Tools

# The Glslang version to Vulkan version correspondence is based on the date.
INTERNAL_GLSLANG_SLOT="16.4" # From https://github.com/KhronosGroup/glslang/blob/main/CHANGES.md
PYTHON_COMPAT=( python3_{10..14} )

CHKL_TIMESTAMPS=(
	"dev-util/glslang-9999"
	"dev-libs/wayland-9999"
	"dev-util/vulkan-headers-9999"
	"media-libs/vulkan-loader-9999"
	"x11-libs/libX11-9999"
	"x11-libs/libxcb-9999"
)

inherit chkl cmake-multilib python-any-r1 secure-version

if [[ ${PV} == *9999* ]]; then
	FALLBACK_COMMIT="a665e21f3061f34064b39937cf00fe8d8769f4ef"
	EGIT_REPO_URI="https://github.com/KhronosGroup/${MY_PN}.git"
	EGIT_SUBMODULES=()
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="https://github.com/KhronosGroup/${MY_PN}/archive/vulkan-sdk-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv"
	S="${WORKDIR}"/${MY_PN}-vulkan-sdk-${PV}
fi

DESCRIPTION="Official Vulkan Tools and Utilities for Windows, Linux, Android, and MacOS"
HOMEPAGE="https://github.com/KhronosGroup/Vulkan-Tools"

LICENSE="Apache-2.0"
SLOT="0"
IUSE+=" cube wayland test X"
RESTRICT="!test? ( test )"

BDEPEND="${PYTHON_DEPS}
	cube? (
		>=dev-util/glslang-${GLSLANG_PV}:=[${MULTILIB_USEDEP}]
		|| (
			dev-util/glslang:0/${INTERNAL_GLSLANG_SLOT}[${MULTILIB_USEDEP}]
		)
	)
	test? ( dev-cpp/gtest )
"
RDEPEND="
	wayland? ( >=dev-libs/wayland-${WAYLAND_PV}:=[${MULTILIB_USEDEP}] )
	X? (
		>=x11-libs/libX11-${LIBX11_PV}:=[${MULTILIB_USEDEP}]
		>=x11-libs/libxcb-${LIBXCB_PV}:=[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	>=dev-util/vulkan-headers-${VULKAN_PV}:=
	X? ( >=x11-libs/libXrandr-${LIBXRANDR_PV}:=[${MULTILIB_USEDEP}] )
	test? ( >=media-libs/vulkan-loader-${VULKAN_PV}:=[${MULTILIB_USEDEP},wayland?,X?] )
"

pkg_setup() {
	MULTILIB_CHOST_TOOLS=(
		/usr/bin/vulkaninfo
	)

	use cube && MULTILIB_CHOST_TOOLS+=(
		/usr/bin/vkcube
		/usr/bin/vkcubepp
	)

	python-any-r1_pkg_setup
}

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

multilib_src_configure() {
	local vulkan_headers_slot=$(grep -r -e "api version" "/usr/share/vulkan/registry/validusage.json" | sed -r -e "s|[ ]+||g" | cut -f 4 -d '"')
	local vulkan_loader_slot=$(pkg-config --modversion vulkan)
	if ver_test "${vulkan_headers_pv}" "-ne" "${vulkan_loader_pv}" ; then
eerror "Detected inconsistency between vulkan-headers and vulkan-loaders slots"
eerror "vulkan-headers slot:  ${vulkan_headers_slot}"
eerror "vulkan-loader slot:  ${vulkan_loader_slot}"
eerror "Re-emerge both if live ebuilds or use the fallback-commit USE flag."
		die
	fi
	local actual_glslang_pv=$(/usr/bin/glslang --version | head -n 1 | cut -f 3 -d ":" | cut -f 1-2 -d ".")
	local expected_glslang_pv="${INTERNAL_GLSLANG_SLOT}"
	if ver_test "${actual_glslang_slot}" "-ne" "${expected_glslang_slot}" ; then
eerror "Detected old glslang version"
eerror "Actual slot:  ${actual_glslang_slot}"
eerror "Expected slot:  ${expected_glslang_slot}"
eerror "Re-emerge the glslang ebuild or use the fallback-commit USE flag."
		die
	fi

	chkl_check_many_timestamps
	local mycmakeargs=(
		-DCMAKE_C_FLAGS="${CFLAGS} -DNDEBUG"
		-DCMAKE_CXX_FLAGS="${CXXFLAGS} -DNDEBUG -DGIT_BRANCH_NAME=\\\"gentoo\\\" -DGIT_TAG_INFO=\\\"${PV//./_}\\\""
		-DCMAKE_DISABLE_FIND_PACKAGE_Git=ON
		-DCMAKE_SKIP_RPATH=ON
		-DBUILD_VULKANINFO=ON
		-DBUILD_CUBE=$(usex cube)
		-DBUILD_TESTS=$(usex test)
		-DBUILD_WERROR=OFF
		-DBUILD_WSI_WAYLAND_SUPPORT=$(usex wayland)
		-DBUILD_WSI_XCB_SUPPORT=$(usex X)
		-DBUILD_WSI_XLIB_SUPPORT=$(usex X)
		-DVULKAN_HEADERS_INSTALL_DIR="${ESYSROOT}/usr"
	)

	cmake_src_configure
}

pkg_postinst() {
	if use cube; then
		einfo "As of version 1.4.304.0 or recent versions, the window system for 'vkcube' and 'vkcubepp'"
		einfo "can be selected at runtime using the '--wsi' runtime argument."
		einfo "For example, Wayland can be selected using '--wsi wayland'."
		einfo "As such, 'vkcube-wayland' has been removed and the runtime argument"
		einfo "must be used instead. See 'vkcube --help' for more information."
	fi
}
