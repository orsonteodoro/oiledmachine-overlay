# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="RadialGM"
EGIT_BRANCH="master"
EGIT_REPO_URI="https://github.com/enigma-dev/RadialGM.git"

inherit cmake desktop git-r3 toolchain-funcs xdg

DESCRIPTION="A native IDE for ENIGMA written in C++ using the Qt Framework."
LICENSE="GPL-3+"
#KEYWORDS="~amd64 ~x86" # Cannot build simple hello world.  Project is likely pre-alpha.
HOMEPAGE="https://github.com/enigma-dev/RadialGM"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE="
doc fallback-commit
r1
"
# See CI for *DEPENDs
# Upstream uses gcc 12.1.0 but relaxed in this ebuild
# Upstream uses protobuf 3.17.3
CDEPEND="
	>=net-libs/grpc-1.39.1
	>=sys-devel/gcc-11.1.0
	>=dev-libs/protobuf-3.17.3:0/3.21
"
QT_PV="5.15.2"
# Upstream uses qscintilla 2.13.3.  Downgraded because no ebuild available yet.
# pcre2 not listed in CI.
DEPEND+="
	${CDEPEND}
	>=dev-cpp/yaml-cpp-0.6.3
	>=dev-libs/double-conversion-3.1.5
	>=dev-libs/libpcre2-10.40[pcre16]
	>=dev-libs/openssl-1.1.1l
	>=dev-libs/pugixml-1.11.4
	>=dev-libs/rapidjson-1.1.0
	>=dev-qt/qtcore-${QT_PV}:5
	>=dev-qt/qtgui-${QT_PV}:5[png]
	>=dev-qt/qtmultimedia-${QT_PV}:5
	>=dev-qt/qtprintsupport-${QT_PV}:5
	>=dev-qt/qtwidgets-${QT_PV}:5[png]
	>=media-libs/freetype-2.11.0
	>=media-libs/harfbuzz-2.9.1
	>=net-dns/c-ares-1.17.2
	>=x11-libs/qscintilla-2.13.0
	dev-games/enigma:0/radialgm-f30646f
	virtual/jpeg
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	${CDEPEND}
	>=dev-util/cmake-3.23.2
	dev-util/patchelf
	media-gfx/imagemagick[png]
"
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"
DOCS=( README.md )
CMAKE_BUILD_TYPE="Release"
PATCHES=(
	"${FILESDIR}/${PN}-9999-external-enigma.patch"
)

pkg_setup() {
	export ENIGMA_INSTALL_DIR="/usr/$(get_libdir)/enigma"
}

S_ENIGMA="${S}/Submodules/enigma-dev"

src_unpack() {
	EGIT_REPO_URI="https://github.com/enigma-dev/RadialGM.git"
	EGIT_BRANCH="master"
	use fallback-commit && EGIT_COMMIT="5a41a5164759450714f6b859450a6586ccdf1650" # Jul 8, 2023
	git-r3_fetch
	git-r3_checkout
}

src_prepare() {
	cmake_src_prepare
	rm -rf "${S}/Submodules/enigma-dev" || die
	cp -a "${ENIGMA_INSTALL_DIR}" "${S}/Submodules" || die
	mv "${S}/Submodules/enigma" "${S}/Submodules/enigma-dev" || die
}

src_configure() {
	pushd "${ENIGMA_INSTALL_DIR}" 2>/dev/null 1>/dev/null || die
	LD_LIBRARY_PATH="$(pwd):${LD_LIBRARY_PATH}" ./emake --help \
		| grep -q -F -e "--server"
	if [[ "$?" != "0" ]] ; then
eerror
eerror "Your enigma is not built with --server.  Re-emerge with the radialgm"
eerror "USE flag.  Enigma must be built against the same abseil-cpp version"
eerror "installed."
eerror
		die
	fi
	popd 2>/dev/null 1>/dev/null || die

	local dirs=$(find /usr/lib/gcc/ -name "libstdc++fs.a" -print0 \
		| xargs -0 dirname \
		| tr "\n" ":")
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="/usr/$(get_libdir)/${MY_PN}"
		-DCMAKE_LIBRARY_PATH="${dirs}"
		-DEXTERNAL_ENIGMA=ON
		-DRGM_BUILD_EMAKE=OFF
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	export STRIP="true"
	cmake_src_install
	cat "${FILESDIR}/${MY_PN}" > "${T}/${MY_PN}" || die
	sed -i -e "s|LIBDIR|$(get_libdir)|g" "${T}/${MY_PN}" || die
	exeinto /usr/bin
	doexe "${T}/${MY_PN}"
	pushd Images || die
		convert -verbose "icon.ico[0]" "icon-32x32.png" || die
		convert -verbose "icon.ico[2]" "icon-16x16.png" || die
	popd
	newicon -s 32 "Images/icon-32x32.png" "${MY_PN}.png"
	newicon -s 16 "Images/icon-16x16.png" "${MY_PN}.png"
	make_desktop_entry "/usr/$(get_libdir)/${MY_PN}" "Development;IDE"
	dosym "${ENIGMA_INSTALL_DIR}" \
		"/usr/$(get_libdir)/${MY_PN}/enigma-dev"
	patchelf --remove-rpath "${ED}/usr/$(get_libdir)/${MY_PN}/${MY_PN}" || die
	patchelf --set-rpath "/usr/$(get_libdir)/enigma" \
		"${ED}/usr/$(get_libdir)/${MY_PN}/${MY_PN}" || die
}

pkg_postinst() {
	xdg_pkg_postinst
einfo
einfo "A build failure may happen in a simple hello world test if the"
einfo "appropriate subsystem USE flag in enigma was disabled when building it"
einfo "or a dependency is not available, but the game settings are the"
einfo "opposite.  Both the USE flag and the game setting and/or extensions must"
einfo "match."
einfo
einfo "You must carefully enable/disable the Resources > Create Settings >"
einfo "(double click) setting 0 > API and extensions in (double click)"
einfo "setting 0 > Extensions in RadialGM to fix inconsistencies to"
einfo "prevent game build failures."
einfo
ewarn
ewarn "This ebuild or project is WIP (Work In Progress) and will not build a"
ewarn "simple hello world game.  Do not use until KEYWORDS is enabled.  This"
ewarn "ebuild left for developers for fix and develop.  Use LateralGM for"
ewarn "now for production."
ewarn
ewarn "FIXMEs/broken:"
ewarn "Setting object to sprite."
ewarn "Setting extension game settings."
ewarn
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  YES
