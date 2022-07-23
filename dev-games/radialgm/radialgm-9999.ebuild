# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="RadialGM"
EGIT_BRANCH="master"
EGIT_REPO_URI="https://github.com/enigma-dev/RadialGM.git"
# enigma is downloaded twice to verify ABI compatibility.

inherit cmake-utils desktop eutils git-r3 toolchain-funcs xdg

DESCRIPTION="A native IDE for ENIGMA written in C++ using the Qt Framework."
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
HOMEPAGE="https://github.com/enigma-dev/RadialGM"
SLOT="0/${PV}"
IUSE="doc"
ENIGMA_ABI_FINGERPRINT="3660f4e5cab9d7d7db6fd8b5c4b6f7089b923e283daef5eb7c41094626b90001"
# See CI for *DEPENDs
# Upstream uses gcc 12.1.0 but relaxed in this ebuild
CDEPEND="
	>=dev-libs/protobuf-21.1
	>=net-libs/grpc-1.47.0
	>=sys-devel/gcc-10.3.0
"
QT_PV="5.15.5"
DEPEND+="
	${CDEPEND}
	>=dev-cpp/yaml-cpp-0.7.0
	>=dev-libs/double-conversion-3.2.0
	>=dev-libs/libpcre2-10.40[pcre16]
	>=dev-libs/openssl-1.1.1p
	>=dev-libs/pugixml-1.12.1
	>=dev-libs/rapidjson-1.1.0
	>=dev-qt/qtcore-${QT_PV}:5
	>=dev-qt/qtgui-${QT_PV}:5
	>=dev-qt/qtmultimedia-${QT_PV}:5
	>=dev-qt/qtprintsupport-${QT_PV}:5
	>=dev-qt/qtwidgets-${QT_PV}:5
	dev-games/enigma:0/${ENIGMA_ABI_FINGERPRINT}
	>=media-libs/freetype-2.12.1
	>=media-libs/harfbuzz-4.4.1
	>=net-dns/c-ares-1.18.1
	>=x11-libs/qscintilla-2.13.3
	virtual/jpeg
"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	${CDEPEND}
	>=dev-util/cmake-3.23.2
	media-gfx/imagemagick[png]
"
S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="mirror"
DOCS=( README.md )
CMAKE_BUILD_TYPE="Release"
_PATCHES=(
	"${FILESDIR}/radialgm-9999_p20211115-re-enable-grpc-block.patch"
)

pkg_setup() {
	export ENIGMA_INSTALL_DIR="/usr/$(get_libdir)/enigma"
}

S_ENIGMA="${S}/Submodules/enigma-dev"

_calculate_enigma_abi_fingerprint() {
	#
	# Generate fingerprint for ABI compatibility checks and subslot.
	#
	# libEGM -> EGM
	# shared -> ENIGMAShared
	# shared/protos -> Protocols
	#
	# The calculation for the ABI may change depending on the dependencies.
	#
	local H=()
	local x

	# Library ABI compatibility
	for x in $(find \
		"${S_ENIGMA}/CommandLine/libEGM" \
		"${S_ENIGMA}/shared" \
		-name "*.h" | sort) ; do
		H+=( $(sha256sum "${x}" | cut -f 1 -d " ") )
	done
	for x in $(find "${S_ENIGMA}/shared/protos/" -name "*.proto" | sort) ; do
		H+=( $(sha256sum "${x}" | cut -f 1 -d " ") )
	done

	# Drag and drop actions
	for x in $(find "${S_ENIGMA}" -name "*.ey") ; do
		H+=( $(sha256sum "${x}" | cut -f 1 -d " ") )
	done

	# File formats
	local FFP=($(grep -E -l -r -e  "(Write|Load)Project\(" "${S_ENIGMA}" \
		| grep -e ".cpp" \
		| grep -e "libEGM" \
		| grep -v -e "file-format.cpp"))
	for x in ${FFP} ; do
		H+=( $(sha256sum "${x}" | cut -f 1 -d " ") )
	done

	# Command line option changes
	H+=( $(sha256sum "${S_ENIGMA}/CommandLine/emake/OptionsParser.cpp" | cut -f 1 -d " ") )

	# No SOVER, no semver
	local abi_fingerprint=$(echo "${H[@]}" \
		| tr " " "\n" \
		| sort \
		| uniq \
		| sha256sum \
		| cut -f 1 -d " ")
	echo "${abi_fingerprint}"
}

src_prepare() {
	cmake-utils_src_prepare
	xdg_src_prepare
	rm -rf "${S}/Submodules/enigma-dev" || die
	cp -a "${ENIGMA_INSTALL_DIR}" "${S}/Submodules" || die
	mv "${S}/Submodules/vanilla" "${S}/Submodules/enigma-dev" || die
	eapply "${_PATCHES[@]}"
}

src_configure() {
	local submodule_enigma_abi_fingerprint=$(_calculate_enigma_abi_fingerprint)
	if [[ "${submodule_enigma_abi_fingerprint}" != "${ENIGMA_ABI_FINGERPRINT}" ]] ; then
eerror
eerror "SUBMODULE_ABI_FINGERPRINT:   ${submodule_enigma_abi_fingerprint}"
eerror "EXPECTED_ABI_FINGERPRINT:  ${ENIGMA_ABI_FINGERPRINT}"
eerror
eerror "Notify the ebuild maintainer to update the enigma package"
eerror "for ${PN}."
eerror
		die
	fi

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
		-DRGM_BUILD_EMAKE=OFF
		-DCMAKE_INSTALL_PREFIX="/usr/$(get_libdir)/${MY_PN}"
	)
	CMAKE_LIBRARY_PATH=\"${dirs}\" \
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
		convert -verbose "icon.ico[0]" "icon-32x32.png" || die
		convert -verbose "icon.ico[2]" "icon-16x16.png" || die
	popd
	newicon -s 32 "Images/icon-32x32.png" "${MY_PN}.png"
	newicon -s 16 "Images/icon-16x16.png" "${MY_PN}.png"
	make_desktop_entry "/usr/$(get_libdir)/${MY_PN}" "Development;IDE"
	dosym "${ENIGMA_INSTALL_DIR}" \
		"/usr/$(get_libdir)/${MY_PN}/enigma-dev"
}
