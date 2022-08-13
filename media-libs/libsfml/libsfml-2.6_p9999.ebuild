# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# TODO delete exlibs and replace with external libraries

EAPI=8

inherit cmake-multilib git-r3

DESCRIPTION="Simple and Fast Multimedia Library (SFML)"
HOMEPAGE="https://www.sfml-dev.org/ https://github.com/SFML/SFML"
LICENSE="
	ZLIB
	BSD
	( all-rights-reserved Boost-1.0 )
	CC0-1.0
	FTL
	LGPL-2
"
# The extra licenses are due to the prebuilt libraries in extlibs
# See https://github.com/SFML/SFML/blob/2.6.x/license.md#external-libraries-used-by-sfml
# Missing copyright notices for BSD
# all-rights-reserved Boost-1.0 - extlibs/headers/catch.hpp
# The Boost-1.0 license template doesn't contain all rights reserved

#KEYWORDS="~arm ~arm64 ~amd64 ~x86" # Live ebuilds don't get KEYWORDed
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
audio X debug doc drm examples flac graphics ios network test udev window
vulkan
"
VULKAN_LINUX_DRIVERS=( amdgpu intel nvidia radeonsi )
IUSE+=" ${VULKAN_LINUX_DRIVERS[@]/#/video_cards_} "
REQUIRED_USE+="
	drm? ( kernel_linux window )
	graphics? ( window )
	kernel_linux? (
		^^ ( X drm )
		vulkan? (
			|| (
				video_cards_amdgpu
				video_cards_intel
				video_cards_nvidia
				video_cards_radeonsi
			)
		)
	)
	udev? ( kernel_linux window )
	X? ( kernel_linux window )
"
NV_DRIVER_VERSION_VULKAN="390.132"
VULKAN_LINUX_RDEPEND="
	|| (
		video_cards_amdgpu? (
			media-libs/mesa[video_cards_radeonsi,vulkan]
			x11-base/xorg-drivers[video_cards_amdgpu]
		)
		video_cards_intel? (
			media-libs/mesa[video_cards_intel,vulkan]
			x11-base/xorg-drivers[video_cards_intel]
		)
		video_cards_nvidia? (
			>=x11-drivers/nvidia-drivers-${NV_DRIVER_VERSION_VULKAN}
		)
		video_cards_radeonsi? (
			media-libs/mesa[video_cards_radeonsi,vulkan]
			x11-base/xorg-drivers[video_cards_radeonsi]
		)
	)
"

RDEPEND+="
	audio? (
		media-libs/flac[${MULTILIB_USEDEP}]
		media-libs/libogg[${MULTILIB_USEDEP}]
		media-libs/libvorbis[${MULTILIB_USEDEP}]
		media-libs/openal[${MULTILIB_USEDEP}]
	)
	graphics? (
		media-libs/freetype:2[${MULTILIB_USEDEP}]
		elibc_bionic? (
			sys-libs/zlib[${MULTILIB_USEDEP}]
		)
		elibc_Darwin? (
			ios? (
				app-arch/bzip2[${MULTILIB_USEDEP}]
				sys-libs/zlib[${MULTILIB_USEDEP}]
			)
		)
	)
	window? (
		virtual/opengl[${MULTILIB_USEDEP}]
		elibc_bionic? (
			media-libs/libglvnd
		)
		elibc_Darwin? (
			media-libs/libglvnd
		)
		kernel_linux? (
			virtual/libudev:0[${MULTILIB_USEDEP}]
			virtual/libc

			drm? (
				media-libs/libglvnd[${MULTILIB_USEDEP}]
				media-libs/mesa[${MULTILIB_USEDEP}]
				x11-libs/libdrm[${MULTILIB_USEDEP}]
			)
			vulkan? ( || ( ${VULKAN_LINUX_RDEPEND} ) )
			X? (
				x11-libs/libX11[${MULTILIB_USEDEP}]
				x11-libs/libXrandr[${MULTILIB_USEDEP}]
				x11-libs/libXcursor[${MULTILIB_USEDEP}]

				x11-libs/libxcb[${MULTILIB_USEDEP}]
				x11-libs/xcb-util-image[${MULTILIB_USEDEP}]
			)
		)
	)
	elibc_Winnt? (
		dev-util/mingw64-runtime
	)
"
DEPEND="
	${RDEPEND}
	doc? ( app-doc/doxygen )
"
BDEPEND+="
	sys-devel/gcc
"
DOCS=( changelog.md readme.md )
SRC_URI=""
S="${WORKDIR}/${P}"
EXPECTED_DEPENDS="\
490b9b7c315763a3fa5bfe5123371de4c5a7bace6bc1e39db2cd270c2a7fb2b8\
353c5bc684d32ae577ce31c90aa9199d66191fe3344cc59dc52c99f5f62f1c72"
RESTRICT="fetch" # Missing BSD copyright notices
PATCHES=(
	"${FILESDIR}/libsfml-2.6x_p9999-drm-null.patch"
)

verify_version() {
	local actual_version=$(\
		grep -F -e "project(SFML" \
			"${S}/CMakeLists.txt" \
		| cut -f 3 -d " " \
		| sed -e "s|[)]||g"
	)
	local expected_version=$(ver_cut 1-3 ${PV})
	if [[ "${actual_version}" != "${expected_version}" ]] ; then
eerror
eerror "The package needs a version bump"
eerror
eerror "Expected version:  ${expected_version}"
eerror "Acutal version:  ${actual_version}"
eerror
		die
	fi
}

pkg_setup() {
	if use elibc_Cygwin ; then
eerror
eerror "Cygwin is Unsupported.  You must use outside of Cygwin with a MinGW-w64"
eerror "toolchain."
eerror
eerror "See https://github.com/SFML/SFML/blob/master/cmake/Config.cmake#L70"
eerror
		die
	fi
}

src_unpack() {
	export EGIT_BRANCH="2.6.x"
	export EGIT_REPO_URI="https://github.com/SFML/SFML.git"
	git-r3_fetch
	git-r3_checkout
	cd "${S}" || die
	#verify_version
	local actual_depends=$(cat $(find "${S}" -name "CMakeLists.txt" -o -name "*.cmake" | sort) \
		| sha512sum \
		| cut -f 1 -d " ")
	if [[ "${actual_depends}" != "${EXPECTED_DEPENDS}" ]] ; then
eerror
eerror "The package needs an IUSE or *DEPENDs review"
eerror
eerror "Expected depends:  ${EXPECTED_DEPENDS}"
eerror "Acutal depends:  ${actual_depends}"
eerror
		die
	fi
}

src_prepare() {
	sed -i "s:DESTINATION .*:DESTINATION ${EPREFIX}/usr/share/doc/${PF}:" \
		"doc/CMakeLists.txt" || die
	find "examples" -name "CMakeLists.txt" -delete || die

	sed -i "s|VERSION_MAJOR 2|VERSION_MAJOR 2|g" \
		"CMakeLists.txt" || die
	sed -i "s|VERSION_MINOR 5|VERSION_MINOR 6|g" \
		"CMakeLists.txt" || die
	sed -i "s|VERSION_PATCH 1|VERSION_PATCH 0|g" \
		"CMakeLists.txt" || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=$(usex debug "Debug" "Release")
		-DSFML_BUILD_AUDIO=$(usex audio)
		-DSFML_BUILD_EXAMPLES=$(usex examples)
		-DSFML_BUILD_GRAPHICS=$(usex graphics)
		-DSFML_BUILD_DOC=$(usex doc)
		-DSFML_BUILD_NETWORK=$(usex network)
		-DSFML_BUILD_TEST_SUITE=$(usex test)
		-DSFML_BUILD_WINDOW=$(usex window)
		-DSFML_USE_SYSTEM_DEPS=TRUE
		-DSFML_INSTALL_PKGCONFIG_FILES=TRUE
	)
	if use elibc_bionic || ( use elibc_Darwin && use ios ) ; then
		mycmakeargs+=( -DSFML_OPENGL_ES=TRUE )
	else
		mycmakeargs+=( -DSFML_OPENGL_ES=FLASE )
	fi
	if use drm ; then
		mycmakeargs+=( -DSFML_USE_DRM=TRUE )
	elif use X ; then
		mycmakeargs+=( -DSFML_USE_DRM=FALSE )
	fi
	cmake-multilib_src_configure
}

src_install() {
	cmake-multilib_src_install
	insinto "/usr/share/cmake/Modules"
	doins "cmake/SFMLConfig.cmake.in"
	doins "cmake/SFMLConfigDependencies.cmake.in"
	if use examples ; then
		docompress -x "/usr/share/doc/${PF}/examples"
		dodoc -r "examples"
	fi
}
