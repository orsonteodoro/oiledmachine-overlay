# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Simple and Fast Multimedia Library (SFML)"
HOMEPAGE="https://www.sfml-dev.org/ https://github.com/SFML/SFML"
LICENSE="ZLIB"
KEYWORDS="amd64 x86"
SLOT="0/${PV}"
IUSE="debug doc examples"
inherit cmake-multilib
RDEPEND="
	media-libs/flac[${MULTILIB_USEDEP}]
	media-libs/freetype:2[${MULTILIB_USEDEP}]
	media-libs/libpng:0=[${MULTILIB_USEDEP}]
	media-libs/libogg[${MULTILIB_USEDEP}]
	media-libs/libvorbis[${MULTILIB_USEDEP}]
	media-libs/openal[${MULTILIB_USEDEP}]
	kernel_linux? ( virtual/libudev:0[${MULTILIB_USEDEP}] )
	sys-libs/zlib[${MULTILIB_USEDEP}]
	virtual/jpeg:0[${MULTILIB_USEDEP}]
	virtual/opengl[${MULTILIB_USEDEP}]
	!kernel_Winnt? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXrandr[${MULTILIB_USEDEP}]
		x11-libs/libxcb[${MULTILIB_USEDEP}]
		x11-libs/xcb-util-image[${MULTILIB_USEDEP}]
	)"
DEPEND="
	${RDEPEND}
	doc? ( app-doc/doxygen )"
DOCS=( changelog.md readme.md )
EGIT_COMMIT="50e173e403ef8912e3d8ac3c7ab3e27e32243339"
SRC_URI=\
"https://github.com/SFML/SFML/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/SFML-${EGIT_COMMIT}"

src_prepare() {
	sed -i "s:DESTINATION .*:DESTINATION /usr/share/doc/${PF}:" \
		doc/CMakeLists.txt || die
	find examples -name CMakeLists.txt -delete || die
	cmake-utils_src_prepare
	multilib_copy_sources
}

src_configure() {
	local mycmakeargs=(
		-DSFML_BUILD_DOC=$(usex doc)
		-DSFML_INSTALL_PKGCONFIG_FILES=TRUE
	)
	if use kernel_Winnt; then
		mycmakeargs+=( -DSFML_USE_SYSTEM_DEPS=TRUE )
	fi
	cmake-multilib_src_configure
}

src_install() {
	cmake-multilib_src_install
	insinto /usr/share/cmake/Modules
	doins cmake/SFMLConfig.cmake.in
	doins cmake/SFMLConfigDependencies.cmake.in
	if use examples ; then
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples
	fi
}
