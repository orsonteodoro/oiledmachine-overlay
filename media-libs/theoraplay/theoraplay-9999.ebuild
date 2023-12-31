# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_BRANCH="main"
EGIT_REPO_URI="https://github.com/icculus/theoraplay.git"

inherit multilib-build git-r3

DESCRIPTION="TheoraPlay is a simple library to make decoding of Ogg Theora \
videos easier."
HOMEPAGE="https://icculus.org/theoraplay/"
LICENSE="ZLIB"
KEYWORDS="~amd64 ~x86"
EXPECTED="\
f45d14bf8a3cd4816dba29e0fab9fe0efcf26628d681491090bfe2dc20a46540\
377e07984e42a17c77476616cfb10d85376f655a53adf6f63ccee92e9e4a04ec\
"
SLOT="0/${EXPECTED}"
IUSE="debug static-libs"
REQUIRED_USE+=""
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
SRC_URI=""
S="${WORKDIR}/${P}"

src_unpack() {
	git-r3_fetch
	git-r3_checkout

	[[ -e "${S}/.github/workflows/main.yml" ]] || die "missing file"
	local actual=$(cat "${S}/.github/workflows/main.yml" \
		| sha512sum \
		| cut -f 1 -d " ")

	if [[ "${actual}" != "${EXPECTED}" ]] ; then
eerror
eerror "Expected fingerprint:  ${EXPECTED}"
eerror "Actual fingerprint:  ${actual}"
eerror
eerror "A change to the CI settings was detected."
eerror "This indicates that possibly the *DEPENDs has changed"
eerror
		die
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

src_configure() { :; }

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
