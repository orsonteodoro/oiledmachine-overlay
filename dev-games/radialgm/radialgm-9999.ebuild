# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="RadialGM"

CMAKE_BUILD_TYPE="Release"
CXX_STANDARD=17
ENIGMA_COMMIT="f30646f"
QT_PV="5.15.2"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

inherit abseil-cpp cmake desktop git-r3 grpc libcxx-slot libstdcxx-slot protobuf re2 toolchain-funcs xdg

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/enigma-dev/RadialGM.git"
	FALLBACK_COMMIT="08cc7191608c3f5cbfa0e49bafe2b8d344a0746d" # Jan 20, 2025
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${PN}-${PV}"
	S_ENIGMA="${S}/Submodules/enigma-dev"
else
	SRC_URI=""
	S="${WORKDIR}/${PN}-${PV}"
	die "FIXME"
fi

DESCRIPTION="A native IDE for ENIGMA written in C++ using the Qt Framework."
LICENSE="GPL-3+"
#KEYWORDS="~amd64 ~x86" # Cannot build simple hello world.  Project is likely pre-alpha.
HOMEPAGE="https://github.com/enigma-dev/RadialGM"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE="
doc
ebuild_revision_6
"
# See CI for *DEPENDs
# Upstream uses gcc 12.1.0 but relaxed in this ebuild
# Upstream uses protobuf 3.17.3
# Originally >=net-libs/grpc-1.39.1
# Upstream uses qscintilla 2.13.3.  Downgraded because no ebuild available yet.
# pcre2 not listed in CI.
RDEPEND+="
	>=dev-cpp/yaml-cpp-0.6.3[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=dev-libs/double-conversion-3.1.5[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=dev-libs/libpcre2-10.40[pcre16]
	>=dev-libs/openssl-1.1.1l
	>=dev-libs/pugixml-1.11.4[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=dev-qt/qtcore-${QT_PV}:5
	>=dev-qt/qtgui-${QT_PV}:5[png]
	>=dev-qt/qtmultimedia-${QT_PV}:5
	>=dev-qt/qtprintsupport-${QT_PV}:5
	>=dev-qt/qtwidgets-${QT_PV}:5[png]
	>=media-libs/freetype-2.11.0
	>=media-libs/harfbuzz-2.9.1
	>=net-dns/c-ares-1.17.2
	|| (
		net-libs/grpc:3/1.30[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		net-libs/grpc:6/1.75[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	)
	net-libs/grpc:=
	>=x11-libs/qscintilla-2.13.0
	dev-games/enigma:0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	virtual/jpeg
"
DEPEND+="
	${RDEPEND}
	>=dev-libs/rapidjson-1.1.0
"
BDEPEND+="
	${CDEPEND}
	>=dev-build/cmake-3.23.2
	dev-libs/protobuf[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	dev-libs/protobuf:=
	dev-util/patchelf
	media-gfx/imagemagick[png]
"
RESTRICT="mirror"
DOCS=( README.md )
PATCHES=(
	"${FILESDIR}/${PN}-9999-external-enigma.patch"
)

pkg_setup() {
	export ENIGMA_INSTALL_DIR="/usr/lib/enigma"
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		EGIT_REPO_URI="https://github.com/enigma-dev/RadialGM.git"
		EGIT_BRANCH="master"
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_prepare() {
	cmake_src_prepare
	rm -rf "${S}/Submodules/enigma-dev" || die
	cp -a \
		"${ENIGMA_INSTALL_DIR}" \
		"${S}/Submodules" \
		|| die
	mv \
		"${S}/Submodules/enigma" \
		"${S}/Submodules/enigma-dev" \
		|| die
}

src_configure() {
	if has_version "dev-libs/protobuf:6/6.33" ; then
	# Enigma slot equivalent being CI tested
		ABSEIL_CPP_SLOT="20250512"
		GRPC_SLOT="6"
		PROTOBUF_CPP_SLOT="6"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_6[@]}" )
		RE2_SLOT="20240116"
	elif has_version "dev-libs/protobuf:3/3.12" ; then
	# Enigma slot equivalent being CI tested
		ABSEIL_CPP_SLOT="20200225"
		GRPC_SLOT="3"
		PROTOBUF_CPP_SLOT="3"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_3[@]}" )
		RE2_SLOT="20220623"
	else
	# Enigma slot equivalent fallback
		ABSEIL_CPP_SLOT="20250512"
		GRPC_SLOT="6"
		PROTOBUF_CPP_SLOT="6"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_6[@]}" )
		RE2_SLOT="20240116"
	fi
	pushd "${ENIGMA_INSTALL_DIR}" >/dev/null 2>&1 || die
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
	popd >/dev/null 2>&1 || die
	abseil-cpp_src_configure
	protobuf_src_configure
	re2_src_configure
	grpc_src_configure

	local slot
	if use gcc_slot_11_5 ; then
		slot="11"
	elif use gcc_slot_12_5 ; then
		slot="12"
	elif use gcc_slot_13_4 ; then
		slot="13"
	elif use gcc_slot_14_3 ; then
		slot="14"
	else
eerror "Use gcc_slot_<x> USE flag to make this error disappear."
		die
	fi

	local dirs=$(find "/usr/lib/gcc/${CHOST}/${slot}" -name "libstdc++fs.a" -print0 \
		| xargs -0 dirname \
		| tr "\n" ":")
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="/usr/lib/${MY_PN}"
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
	cat \
		"${FILESDIR}/${MY_PN}" \
			> \
		"${T}/${MY_PN}" \
		|| die
	sed -i \
		-e "s|LIBDIR|$(get_libdir)|g" \
		"${T}/${MY_PN}" \
		|| die
	exeinto "/usr/bin"
	doexe "${T}/${MY_PN}"
	pushd "Images" >/dev/null 2>&1 || die
		convert \
			-verbose \
			"icon.ico[0]" \
			"icon-32x32.png" \
			|| die
		convert \
			-verbose \
			"icon.ico[2]" \
			"icon-16x16.png" \
		|| die
	popd >/dev/null 2>&1 || die
	newicon \
		-s 32 \
		"Images/icon-32x32.png" \
		"${MY_PN}.png"
	newicon \
		-s 16 \
		"Images/icon-16x16.png" \
		"${MY_PN}.png"
	make_desktop_entry \
		"/usr/lib/${MY_PN}" \
		"Development;IDE"
	dosym \
		"${ENIGMA_INSTALL_DIR}" \
		"/usr/lib/${MY_PN}/enigma-dev"

	local BINS=(
		"${ED}/usr/lib/${MY_PN}/${MY_PN}"
	)

	local f
	for f in "${BINS[@]}" ; do
		local p="${ED}${install_dir}/${f}"
		patchelf --remove-rpath "${p}" || die
		patchelf --add-rpath "/usr/lib/enigma"
		patchelf --add-rpath "/usr/lib/abseil-cpp/${ABSEIL_CPP_SLOT}/$(get_libdir)" "${p}" || die
		patchelf --add-rpath "/usr/lib/protobuf/${PROTOBUF_SLOT}/$(get_libdir)" "${p}" || die
		patchelf --add-rpath "/usr/lib/re2/${RE2_SLOT}/$(get_libdir)" "${p}" || die
		patchelf --add-rpath "/usr/lib/grpc/${PROTOBUF_SLOT}/$(get_libdir)" "${p}" || die
	done
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
