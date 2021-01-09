# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils desktop eutils toolchain-funcs xdg

DESCRIPTION="A native IDE for ENIGMA written in C++ using the Qt Framework."
HOMEPAGE="https://github.com/enigma-dev/RadialGM"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
IUSE="doc"
ENIGMA_V="9999_p20201116"
CDEPEND="dev-libs/protobuf
	 net-libs/grpc
	 >=sys-devel/gcc-7.4.0"
DEPEND+=" ${CDEPEND}
	  dev-cpp/yaml-cpp
	  dev-libs/double-conversion
	  dev-libs/libpcre2[pcre16]
	  dev-libs/openssl
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
	  x11-libs/qscintilla
	  virtual/jpeg"
RDEPEND=" ${DEPEND}"
BDEPEND+=" ${CDEPEND}
	   media-gfx/imagemagick[png]"
EGIT_COMMIT="394448fff27e4cdd63b108a8be898c17a25a711d"
SRC_URI=\
"https://github.com/enigma-dev/RadialGM/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
MY_PN="RadialGM"
S="${WORKDIR}/${MY_PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
DOCS=( README.md )
CMAKE_BUILD_TYPE="Release"

pkg_setup() {
	pushd /usr/$(get_libdir)/enigma/vanilla 2>/dev/null 1>/dev/null || die
	LD_LIBRARY_PATH="$(pwd):${LD_LIBRARY_PATH}" ./emake --help \
		| grep -q -F -e "--server"
	if [[ "$?" != "0" ]] ; then
		die \
"Your enigma is not built with --server.  Re-emerge with the radialgm USE flag."
	fi
	popd 2>/dev/null 1>/dev/null || die
}

src_prepare() {
	cmake-utils_src_prepare
	xdg_src_prepare
	rm -rf "${S}/Submodules/enigma-dev" || die
	cp -a /usr/$(get_libdir)/enigma/vanilla "${S}/Submodules" || die
	mv "${S}/Submodules/vanilla" "${S}/Submodules/enigma-dev" || die
}

src_configure() {
	DIRS=$(find /usr/lib/gcc/ -name "libstdc++fs.a" -print0 \
		| xargs -0 dirname | tr "\n" ":")
	local mycmakeargs=(
		-DRGM_BUILD_EMAKE=OFF
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
	pushd Images || die
		convert -verbose icon.ico[0] icon-32x32.png || die
		convert -verbose icon.ico[2] icon-16x16.png || die
	popd
	newicon -s 32 Images/icon-32x32.png ${MY_PN}.png
	newicon -s 16 Images/icon-16x16.png ${MY_PN}.png
	make_desktop_entry /usr/$(get_libdir)/${MY_PN} "Development;IDE"
	dosym /usr/$(get_libdir)/enigma/vanilla \
		/usr/$(get_libdir)/${MY_PN}/enigma-dev
}
