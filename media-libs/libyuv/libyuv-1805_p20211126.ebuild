# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See README.chromium or include/libyuv/version.h for lib version

EAPI=7

inherit cmake-utils multilib-minimal

DESCRIPTION="libyuv is an open source project that includes YUV scaling and \
conversion functionality."
HOMEPAGE="https://chromium.googlesource.com/libyuv/libyuv/"
LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
SLOT="0/${PV}"
IUSE+=" static system-gflags test"
BDEPEND+=" >=dev-util/cmake-2.8"
CDEPEND="virtual/jpeg"
DEPEND+=" ${CDEPEND}
	test? ( dev-cpp/gtest[${MULTILIB_USEDEP}]
		dev-cpp/gflags[${MULTILIB_USEDEP}] )"
RDEPEND+=" ${CDEPEND}"
EGIT_COMMIT="63ce1d058533f2b783eb82a96084443e2cd0a081"
EGIT_REPO_URI="https://chromium.googlesource.com/libyuv/libyuv"
FN_DEST="${P}.tar.gz"
FN_SRC="${EGIT_COMMIT}.tar.gz"
SRC_URI=\
"https://chromium.googlesource.com/libyuv/libyuv/+archive/${FN_SRC}\
	 -> ${P}-${EGIT_COMMIT:0:7}.tar.gz"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
DOCS=( AUTHORS LICENSE PATENTS README.chromium README.md )
REPO_DL_PAGE="https://chromium.googlesource.com/libyuv/libyuv/+/${EGIT_COMMIT}"

src_unpack() {
	mkdir -p "${S}"
	cd "${S}"
	unpack ${A}
}

src_prepare() {
	default
	eapply "${FILESDIR}/${PN}-1741-cmake-libdir.patch"
	cmake-utils_src_prepare
	multilib_copy_sources
}

multilib_src_configure() {
	local mycmakeargs=( )
	if use test ; then
		mycmakeargs+=( -DTEST=ON )
	fi
	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile
}

multilib_src_install() {
	cmake-utils_src_install
	einstalldocs
	insinto /usr/$(get_libdir)/pkgconfig
	cat "${FILESDIR}/${PN}.pc.in" | \
	sed -e "s|@prefix@|/usr|" \
	    -e "s|@exec_prefix@|\${prefix}|" \
	    -e "s|@libdir@|/usr/$(get_libdir)|" \
	    -e "s|@includedir@|\${prefix}/include|" \
	    -e "s|@version@|${PV}|" > "${T}/${PN}.pc" || die
	doins "${T}/${PN}.pc"
}
