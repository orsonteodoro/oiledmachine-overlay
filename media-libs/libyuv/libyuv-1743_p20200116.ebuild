# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See README.chromium or include/libyuv/version.h for lib version

EAPI=7
DESCRIPTION="libyuv is an open source project that includes YUV scaling and \
conversion functionality."
HOMEPAGE="https://chromium.googlesource.com/libyuv/libyuv/"
LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
inherit multilib-minimal
IUSE="static system-gflags test"
RDEPEND="virtual/jpeg"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest
		dev-cpp/gflags )
	dev-util/cmake"
SLOT="0/${PV}"
inherit cmake-utils
EGIT_COMMIT="1cea4235af9a424023f439a412e77303680acbd6"
EGIT_REPO_URI="https://chromium.googlesource.com/libyuv/libyuv"
SRC_URI=\
"https://chromium.googlesource.com/libyuv/libyuv/+archive/${EGIT_COMMIT}.tar.gz\
	 -> ${P}.tar.gz"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
DOCS=( AUTHORS LICENSE PATENTS README.chromium README.md )

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
	insinto /usr/$(get_libdir)/pkgconfig
	cat "${FILESDIR}/${PN}.pc.in" | \
	sed -e "s|@prefix@|/usr|" \
	    -e "s|@exec_prefix@|\${prefix}|" \
	    -e "s|@libdir@|/usr/$(get_libdir)|" \
	    -e "s|@includedir@|\${prefix}/include|" \
	    -e "s|@version@|${PV}|" > "${T}/${PN}.pc" || die
	doins "${T}/${PN}.pc"
}
