# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# TODO delete exlibs and replace with external libraries

EAPI=8

LIBX11_PV="1.7.5"
MESA_PV="22.0.1"
NV_DRIVER_VERSION_VULKAN="390.132"
XORG_SERVER_PV="21.1.4"

inherit cmake-multilib

if [[ "${PV}" =~ "9999" ]] ; then
	export EGIT_BRANCH="master"
	export EGIT_REPO_URI="https://github.com/SFML/SFML.git"
	inherit git-r3
	SRC_URI=""
	S="${WORKDIR}/${P}"
	IUSE+=" fallback-commit"
else
	SRC_URI="
https://github.com/SFML/SFML/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
	S="${WORKDIR}/SFML-${PV}"
fi

DESCRIPTION="Simple and Fast Multimedia Library (SFML)"
HOMEPAGE="
	https://www.sfml-dev.org/
	https://github.com/SFML/SFML
"
LICENSE="
	ZLIB
	BSD
	CC0-1.0
	FTL
	LGPL-2
"
# The extra licenses are due to the prebuilt libraries in extlibs
# See https://github.com/SFML/SFML/blob/2.6.x/license.md#external-libraries-used-by-sfml
# See headers for copyright notices for BSD.

#KEYWORDS="~arm ~arm64 ~amd64 ~x86" # Live ebuilds don't get KEYWORDed
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
audio debug doc drm examples flac graphics ios network test udev window
vulkan X
"
VULKAN_LINUX_DRIVERS=(
	amdgpu
	intel
	nvidia
	radeonsi
)
IUSE+=" ${VULKAN_LINUX_DRIVERS[@]/#/video_cards_} "
REQUIRED_USE+="
	drm? (
		kernel_linux
		window
	)
	graphics? (
		window
	)
	kernel_linux? (
		^^ (
			X
			drm
		)
		vulkan? (
			|| (
				video_cards_amdgpu
				video_cards_intel
				video_cards_nvidia
				video_cards_radeonsi
			)
		)
	)
	udev? (
		kernel_linux
		window
	)
	X? (
		kernel_linux
		window
	)
"
# U 22.04
# *DEPENDS last check:  Dec 22, 2022
VULKAN_LINUX_RDEPEND="
	|| (
		video_cards_amdgpu? (
			>=media-libs/mesa-${MESA_PV}[video_cards_radeonsi,vulkan]
			>=x11-base/xorg-drivers-${XORG_SERVER_PV}[video_cards_amdgpu]
		)
		video_cards_intel? (
			>=media-libs/mesa-${MESA_PV}[video_cards_intel,vulkan]
			>=x11-base/xorg-drivers-${XORG_SERVER_PV}[video_cards_intel]
		)
		video_cards_nvidia? (
			>=x11-drivers/nvidia-drivers-${NV_DRIVER_VERSION_VULKAN}
		)
		video_cards_radeonsi? (
			>=media-libs/mesa-${MESA_PV}[video_cards_radeonsi,vulkan]
			>=x11-base/xorg-drivers-${XORG_SERVER_PV}[video_cards_radeonsi]
		)
	)
"
RDEPEND+="
	audio? (
		>=media-libs/flac-1.3.3[${MULTILIB_USEDEP}]
		>=media-libs/libogg-1.3.5[${MULTILIB_USEDEP}]
		>=media-libs/libvorbis-1.3.7[${MULTILIB_USEDEP}]
		>=media-libs/openal-1.19.1[${MULTILIB_USEDEP}]
	)
	graphics? (
		>=media-libs/freetype-2.11.1:2[${MULTILIB_USEDEP}]
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
				>=media-libs/libglvnd-1.4.0[${MULTILIB_USEDEP}]
				>=media-libs/mesa-${MESA_PV}[${MULTILIB_USEDEP}]
				>=x11-libs/libdrm-2.4.110[${MULTILIB_USEDEP}]
			)
			vulkan? (
				|| (
					${VULKAN_LINUX_RDEPEND}
				)
			)
			X? (
				>=x11-libs/libX11-${LIBX11_PV}[${MULTILIB_USEDEP}]
				>=x11-libs/libXrandr-1.5.2[${MULTILIB_USEDEP}]
				>=x11-libs/libxcb-1.14[${MULTILIB_USEDEP}]
				>=x11-libs/libXcursor-1.2.0[${MULTILIB_USEDEP}]
				>=x11-libs/xcb-util-image-0.4.0[${MULTILIB_USEDEP}]
			)
		)
	)
	elibc_mingw? (
		dev-util/mingw64-runtime
	)
"
DEPEND="
	${RDEPEND}
	doc? (
		>=app-doc/doxygen-1.9.1
	)
"
BDEPEND+="
	>=dev-util/cmake-3.24
	>=sys-devel/gcc-11.2.0
"
DOCS=( changelog.md readme.md )
EXPECTED_DEPENDS="\
0e5f94b63a76f9bb2e29f16f851b7544749c7e938d46de68d9f47844c78a099d\
fb05d9599b8f5dd7ce06783fe22959e8a53e13d862350e5c91b629fbc5ce7769\
"
RESTRICT="" # See headers for copyright notices
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
eerror "Expected version:\t${expected_version}"
eerror "Actual version:\t${actual_version}"
eerror
		die
	fi
}

pkg_setup() {
	use drm && ewarn "USE=drm does not compile.  USE=X instead."
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="cf3f4e8d89904d6d9da52e0aadf212932f9a9b3f" # 20231223
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
	cd "${S}" || die
	if [[ "${PV}" =~ "9999" ]] ; then
		verify_version
		local actual_depends=$(cat $(find "${S}" -name "CMakeLists.txt" -o -name "*.cmake" | sort) \
			| sha512sum \
			| cut -f 1 -d " ")
		if [[ "${actual_depends}" != "${EXPECTED_DEPENDS}" ]] ; then
eerror
eerror "The package needs an IUSE or *DEPENDs review"
eerror
eerror "Expected depends:\t${EXPECTED_DEPENDS}"
eerror "Actual depends:\t${actual_depends}"
eerror
			die
		fi
	fi
}

src_prepare() {
	sed -i \
		"s:DESTINATION .*:DESTINATION ${EPREFIX}/usr/share/doc/${PF}:" \
		"doc/CMakeLists.txt" \
		|| die
	find "examples" -name "CMakeLists.txt" -delete || die
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
		-DSFML_INSTALL_PKGCONFIG_FILES=TRUE
		-DSFML_USE_SYSTEM_DEPS=TRUE
	)
	if \
		use elibc_bionic \
		|| ( \
			   use elibc_Darwin \
			&& use ios \
		) \
	; then
		mycmakeargs+=( -DSFML_OPENGL_ES=TRUE )
	else
		mycmakeargs+=( -DSFML_OPENGL_ES=FALSE )
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
