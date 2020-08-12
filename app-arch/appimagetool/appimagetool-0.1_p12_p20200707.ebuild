# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# versioning based on src/appimagetoolnoglib.c, tag release, and current commit date
# upstream uses the commit as the version.

# AppImageKit currently is just the non Go version of appimagetool.

EAPI=7
DESCRIPTION="appimagetool -- Generate, extract, and inspect AppImages"
HOMEPAGE="https://github.com/AppImage/AppImageKit"
LICENSE="MIT" # project's default license
LICENSE+=" all-rights-reserved" # src/appimagetool.c ; The vanilla MIT license doesn't have all-rights-reserved
KEYWORDS="~amd64 ~x86"
IUSE="additional-tools"
RDEPEND="additional-tools? ( dev-libs/openssl )
	app-arch/xz-utils:=[static-libs]
	sys-fs/squashfuse
	sys-fs/squashfs-tools
	dev-libs/libappimage:=[static-libs]
	dev-util/sanitizers-cmake"
DEPEND="${RDEPEND}
	sys-devel/binutils"
REQUIRED_USE=""
SLOT="0/${PV}"
EGIT_COMMIT="08800854de05f4f6f7c1f3901dc165b8518822e1"
SRC_URI=\
"https://github.com/AppImage/AppImageKit/archive/${EGIT_COMMIT}.tar.gz
	 -> ${P}.tar.gz
"
MY_PN="AppImageKit"
S="${WORKDIR}/${MY_PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
inherit cmake-utils
PATCHES=(
	"${FILESDIR}/${PN}-0.1_p12_p20200707-set-commit.patch"
	"${FILESDIR}/${PN}-0.1_p12_p20200707-use-system-libs-and-headers.patch"
	"${FILESDIR}/${PN}-0.1_p12_p20200707-extern-appimage_get_elf_size.patch"
)
MAKEOPTS="-j1"

pkg_setup() {
	if has network-sandbox $FEATURES ; then
		die \
"${PN} requires network-sandbox to be disabled in FEATURES in order to download\n\
internal dependencies."
	fi
}

src_prepare() {
	cmake-utils_src_prepare
	sed -i -e "s|\
/usr/lib64/cmake/sanitizers-cmake|\
/usr/$(get_libdir)/cmake/sanitizers-cmake|g" \
		src/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DUSE_SYSTEM_MKSQUASHFS=ON
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	docinto licenses
	dodoc LICENSE
	docinto readmes
	dodoc README.md
	if ! use additional-tools ; then
		rm -rf "${ED}/usr/bin/"{validate,digest}
	fi
}
