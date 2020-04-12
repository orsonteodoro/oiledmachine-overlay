# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A native IDE for ENIGMA written in C++ using the Qt Framework."
HOMEPAGE="https://github.com/enigma-dev/RadialGM"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
ENIGMA_V="9999_p20200409"
GCC_V="9.2.0"
RDEPEND="dev-cpp/yaml-cpp
	 dev-libs/double-conversion
	 dev-libs/libpcre2[pcre16]
	 dev-libs/openssl
	 dev-libs/protobuf
	 dev-libs/pugixml
	 dev-libs/rapidjson
	 dev-qt/qtcore:5
	 dev-qt/qtgui:5
	 dev-qt/qtmultimedia:5
	 dev-qt/qtprintsupport:5
	 dev-qt/qtwidgets:5
	 >=games-misc/enigma-${ENIGMA_V}[vanilla,radialgm]
	 media-libs/freetype
	 media-libs/harfbuzz
	 net-dns/c-ares
	 net-libs/grpc
	 sys-devel/gcc
	 x11-libs/qscintilla
	 virtual/jpeg"
EGIT_COMMIT_ENIGMA="3fa4e21ab49e07370481cd1c35714d611bf1f9f6"
EGIT_COMMIT="356b0edeaba4bbb426407c16c3d4663e4b04f9dc"
SRC_URI=\
"https://github.com/enigma-dev/RadialGM/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
inherit cmake-utils desktop eutils toolchain-funcs
MY_PN="RadialGM"
S="${WORKDIR}/${MY_PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
DOCS=( README.md )
CMAKE_BUILD_TYPE=Release

src_prepare() {
	cmake-utils_src_prepare
	rm -rf "${S}/Submodules/enigma-dev" || die
	cp -a /usr/$(get_libdir)/enigma/vanilla "${S}/Submodules" || die
	mv "${S}/Submodules/vanilla" "${S}/Submodules/enigma-dev" || die
}

src_configure() {
	DIRS=$(find /usr/lib/gcc/ -name "libstdc++fs.a" -print0 | xargs -0 dirname | tr "\n" ":")

	local mycmakeargs=(
		-DEGM_BUILD_EMAKE=OFF
		-DCMAKE_INSTALL_PREFIX=/usr/$(get_libdir)/${MY_PN}
	)
	CMAKE_LIBRARY_PATH=\"${DIRS}\" \
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	cat "${FILESDIR}/${MY_PN}" > "${T}/${MY_PN}" || die
	sed -i -e "s|lib64|$(get_libdir)|g" "${T}/${MY_PN}" || die
	exeinto /usr/bin
	doexe "${T}/${MY_PN}"
	newicon Images/icon.ico ${MY_PN}.ico
	make_desktop_entry /usr/$(get_libdir)/${MY_PN} "Development;IDE"
	dosym /usr/$(get_libdir)/enigma/vanilla /usr/$(get_libdir)/${MY_PN}/enigma-dev
}
