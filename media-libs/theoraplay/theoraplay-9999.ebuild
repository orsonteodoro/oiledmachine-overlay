# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EXPECTED_FINGERPRINT="\
663a214a40467616454a1d33947088beba518913a81e84b5dcb73282e80bdf37\
8e1ea4325d982f902f7c9e093c78752cd9a4f5aa893faf0deb7af0791cd96a04\
"

inherit check-compiler-switch flag-o-matic multilib-build git-r3

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/icculus/theoraplay.git"
	FALLBACK_COMMIT="925f9598b5706694889b8e7accd5d9c2bf658912"
	IUSE+=" fallback-commit"
else
	SRC_URI=""
	die "FIXME"
fi

DESCRIPTION="TheoraPlay is a simple library to make decoding of Ogg Theora \
videos easier."
HOMEPAGE="https://icculus.org/theoraplay/"
LICENSE="ZLIB"
KEYWORDS="~amd64 ~x86"
SLOT="0/${FALLBACK_COMMIT:0:7}"
IUSE+=" debug static-libs"
RDEPEND+="
	media-libs/libtheora:=[static-libs?,${MULTILIB_USEDEP}]
	media-libs/libogg:=[static-libs?,${MULTILIB_USEDEP}]
	media-libs/libvorbis:=[static-libs?,${MULTILIB_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-util/premake:5
"
S="${WORKDIR}/${P}"

unpack_live() {
	use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
	git-r3_fetch
	git-r3_checkout
	[[ -e "${S}/.github/workflows/main.yml" ]] || die "missing file"
	local actual_fingerprint=$(cat "${S}/.github/workflows/main.yml" \
		| sha512sum \
		| cut -f 1 -d " ")
	if [[ "${actual_fingerprint}" != "${EXPECTED_FINGERPRINT}" ]] ; then
eerror
eerror "Expected fingerprint:  ${EXPECTED_FINGERPRINT}"
eerror "Actual fingerprint:  ${actual_fingerprint}"
eerror
eerror "A change to the CI settings was detected."
eerror "This indicates that possibly the *DEPENDs has changed"
eerror
		die
	fi
}

pkg_setup() {
	check-compiler-switch_start
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		unpack_live
	fi
}

get_lib_types() {
	use static-libs && echo "static"
	echo "shared"
}

src_prepare() {
	default
	cp "${FILESDIR}/buildcpp.lua" "${S}" || die
	premake5 --file=buildcpp.lua gmake || die
	prepare_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			cp -a "${S}" "${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}" || die
		done
	}
	multilib_foreach_abi prepare_abi
}

src_configure() {
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi
}

src_compile() {
	local mydebug=$(usex debug "debug" "release")
	compile_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			cd "${BUILD_DIR}" || die
			cd build/ || die
			emake config=${mydebug}${lib_type}lib || die
		done
	}
	multilib_foreach_abi compile_abi
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")
	install_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			cd "${BUILD_DIR}" || die
			if [[ "${lib_type}" == "shared" ]] ; then
				cd "build/bin/${mydebug}SharedLib" || die
				dolib.so lib${PN}.so
			else
				cd "build/bin/${mydebug}StaticLib" || die
				dolib.a lib${PN}.a
			fi
			cd "${BUILD_DIR}" || die
			doheader ${PN}.h
		done
		multilib_check_headers
	}
	multilib_foreach_abi install_abi
	multilib_src_install_all
}

multilib_src_install_all() {
	cd "${S}" || die
	dodoc LICENSE.txt README.md
}

# OILEDMACHINE-OVERLAY-META-REVDEP:  fna
