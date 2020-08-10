# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="AppImageUpdate lets you update AppImages in a decentral way using \
information embedded in the AppImage itself. "
HOMEPAGE="https://github.com/AppImage/AppImageUpdate/"
LICENSE="MIT" # project's default license
KEYWORDS="~amd64 ~x86"
RDEPEND="
	dev-libs/libappimage
	dev-libs/libdesktopenvironments
	net-misc/zsync2
	>=x11-libs/fltk-1.3.4"
DEPEND="${RDEPEND}
	dev-misc/sanitizers-cmake"
SLOT="0/${PV}"
EGIT_COMMIT="9ea5b15dde7fd659cfee5bbba16a82a304671494"
SRC_URI=\
"https://github.com/AppImage/AppImageUpdate/archive/${EGIT_COMMIT}.tar.gz
	 -> ${P}.tar.gz"
MY_PN="AppImageUpdate"
S="${WORKDIR}/${MY_PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
inherit cmake-utils
PATCHES=(
	"${FILESDIR}/${PN}-1_alpha_p20200523-set-git-commit-for-tarball.patch"
	"${FILESDIR}/${PN}-1_alpha_p20200523-use-system-zsync2.patch"
	"${FILESDIR}/${PN}-1_alpha_p20200523-use-system-zsync2-and-libappimage.patch"
	"${FILESDIR}/${PN}-1_alpha_p20200523-use-system-sanitizers-cmake.patch"
	"${FILESDIR}/${PN}-1_alpha_p20200523-link-to-system-zsync2-and-appimage_shared.patch"
	"${FILESDIR}/${PN}-1_alpha_p20200523-remove-linking-to-args.patch"
	"${FILESDIR}/${PN}-1_alpha_p20200523-change-libdir.patch"
)

src_prepare() {
	cmake-utils_src_prepare
	sed -i -e "s|\
/usr/lib64/cmake/sanitizers-cmake|\
/usr/$(get_libdir)/cmake/sanitizers-cmake|g" \
		src/CMakeLists.txt || die
}

src_install() {
	cmake-utils_src_install
	docinto licenses
	dodoc LICENSE.txt
	docinto readmes
	dodoc README.md
}
