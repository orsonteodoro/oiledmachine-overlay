# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# The AppImageKit project currently is just the non Go version of appimagetool.
# AppImageKit is the set of utils and assets used for appimagetool.

MAKEOPTS="-j1"

inherit cmake flag-o-matic git-r3

DESCRIPTION="appimagetool -- Generate, extract, and inspect AppImages"
HOMEPAGE="https://github.com/AppImage/AppImageKit"
LICENSE="MIT" # project's default license
LICENSE+=" all-rights-reserved" # src/appimagetool.c ; The vanilla MIT license doesn't have all-rights-reserved

# live ebuilds do not get keyworded

IUSE+="
additional-tools appimagetool appstream runtime

r1
"
REQUIRED_USE+="
	|| ( appimagetool runtime )
"
SLOT="0/9999"
RDEPEND+="
	>=app-arch/libarchive-3.3.1
	>=app-arch/xz-utils-5.2.3:=[static-libs]
	>=sys-fs/squashfs-tools-4.4:=[lz4,lzma]
	>=sys-fs/squashfuse-0.1.101:=[lzma,zlib]
	dev-libs/libappimage:=[static-libs]
	dev-libs/libffi:=
	additional-tools? (
		dev-libs/openssl
	)
	appimagetool? (
		app-arch/go-appimage[-appimagetool]
	)
	appstream? (
		dev-libs/appstream:=
	)
	|| (
		net-misc/zsync2:=
		net-misc/zsync:=
	)
"
DEPEND+="
	${RDEPEND}
	dev-util/sanitizers-cmake
	sys-devel/binutils
"
if [[ ${PV} =~ 9999 ]] ; then
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${PN}-9999"
else
	EGIT_COMMIT="08800854de05f4f6f7c1f3901dc165b8518822e1"
	SRC_URI="
https://github.com/AppImage/AppImageKit/archive/${EGIT_COMMIT}.tar.gz
	 -> ${P}-${EGIT_COMMIT:0:7}.tar.gz
	"
	S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
fi
RESTRICT="mirror strip"
PATCHES=(
	"${FILESDIR}/${PN}-9999_p20200707-set-commit.patch"
	"${FILESDIR}/${PN}-9999_p20220929-use-system-libs-and-headers.patch"
	"${FILESDIR}/${PN}-9999_p20200707-extern-appimage_get_elf_size.patch"
	"${FILESDIR}/${PN}-9999_p20220929-gentooize-build-scripts.patch"
)
CMAKE_MAKEFILE_GENERATOR="emake"

pkg_setup() {
	if has network-sandbox $FEATURES ; then
eerror
eerror "${PN} requires network-sandbox to be disabled in FEATURES in order to"
eerror "download internal dependencies."
eerror
		die
	fi
}

src_unpack() {
	if [[ ${PV} =~ 9999 ]] ; then
		use fallback-commit && EGIT_COMMIT="b719a7f0cda9eedbb4a86d155a44fac973ca1309" # Sep 29, 2022
		EGIT_REPO_URI="https://github.com/AppImage/AppImageKit.git"
		EGIT_BRANCH="master"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_prepare() {
	cmake_src_prepare
	sed -i -e "s|\
/usr/lib64/cmake/sanitizers-cmake|\
/usr/$(get_libdir)/cmake/sanitizers-cmake|g" \
		src/CMakeLists.txt || die
	if [[ ${PV} =~ 9999 ]] ; then
		local c=""
		if use fallback-commit ; then
			c="${EGIT_COMMIT}"
		else
			c=$(git ls-remote https://github.com/AppImage/AppImageKit.git \
				| grep HEAD \
				| cut -c 1-40)
		fi
		local old_c=$(grep -F -e "(GIT_COMMIT" CMakeLists.txt \
			| cut -f 2 -d '"')
		sed -i -e "s|${old_c}|${c}|g" CMakeLists.txt || die
	fi
	if has_version "net-misc/zsync2" ; then
		sed -i -e "s|zsyncmake|zsyncmake2|g" src/appimagetool.c || die
		sed -i -e "s|zsyncmake|zsyncmake2|g" ci/build-appdir.sh || die
	fi
}

src_configure() {
	:;
}

get_arch() {
	case ${ARCH} in
		amd64)
			echo "x86_64"
			;;
		x86)
			echo "i686"
			;;
		arm64)
			echo "aarch64"
			;;
		arm)
			echo "armhf"
			;;
		*)
			echo "${ARCH}"
			;;
	esac
}

src_compile() {
	addwrite /dev/fuse
	cd ci || die
	ARCH=$(get_arch) ./build.sh || die
}

src_install() {
	docinto licenses
	dodoc LICENSE
	docinto readmes
	dodoc README.md
	exeinto /usr/bin
	local arch=$(get_arch)
	if use appimagetool ; then
		doexe "${WORKDIR}/out/appimagetool-${arch}.AppImage"
		dosym /usr/bin/appimagetool-${arch}.AppImage /usr/bin/appimagetool
	fi
	# Already embedded
	#doexe "${WORKDIR}/out/AppRun-${arch}"
	if use runtime ; then
		exeinto /usr/$(get_libdir)/${PN}
		# exposed for go-appimage
		doexe "${WORKDIR}/out/runtime-${arch}"
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
