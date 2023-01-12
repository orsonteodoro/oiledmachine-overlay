# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# The AppImageKit project currently is just the non Go version of appimagetool.
# AppImageKit is the set of utils and assets used for appimagetool.

inherit cmake git-r3

DESCRIPTION="appimagetool -- Generate, extract, and inspect AppImages"
HOMEPAGE="https://github.com/AppImage/AppImageKit"
LICENSE="MIT" # project's default license
LICENSE+=" all-rights-reserved" # src/appimagetool.c ; The vanilla MIT license doesn't have all-rights-reserved

# live ebuilds do not get keyworded

IUSE+=" additional-tools appstream appimagetool runtime"
SLOT="0/9999"
RDEPEND+="
	additional-tools? ( dev-libs/openssl )
	app-arch/xz-utils:=[static-libs]
	appimagetool? ( app-arch/go-appimage[-appimagetool] )
	appstream? ( dev-libs/appstream:= )
	dev-libs/libffi:=
	net-misc/zsync2:=
	sys-fs/squashfuse:=
	sys-fs/squashfs-tools:=
	dev-libs/libappimage:=[static-libs]
"
DEPEND+="
	${RDEPEND}
	dev-util/sanitizers-cmake
	sys-devel/binutils
"
if false && [[ ${PV} =~ 9999 ]] ; then
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
	"${FILESDIR}/${PN}-9999_p20200707-use-system-libs-and-headers.patch"
	"${FILESDIR}/${PN}-9999_p20200707-extern-appimage_get_elf_size.patch"
	"${FILESDIR}/${PN}-9999_p20200707-gentooize-build-scripts.patch"
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
	if false && [[ ${PV} =~ 9999 ]] ; then
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
}

src_configure() {
	:;
}

src_compile() {
	addwrite /dev/fuse
	cd travis
	./travis-build.sh
}

src_install() {
	docinto licenses
	dodoc LICENSE
	docinto readmes
	dodoc README.md
	exeinto /usr/bin
	if use appimagetool ; then
		doexe "build/out/appimagetool-${ABI}.AppImage"
		dosym /usr/bin/appimagetool-${ABI}.AppImage /usr/bin/appimagetool
	fi
	# Already embedded
	#doexe "${WORKDIR}/out/AppRun-${ABI}"
	if use runtime ; then
		exeinto /usr/$(get_libdir)/${PN}
		# exposed for go-appimage
		doexe "build/out/runtime-${ABI}"
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
