# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils git-r3 multilib-build multilib-minimal

DESCRIPTION="libyuv is an open source project that includes YUV scaling and conversion functionality."
HOMEPAGE="https://chromium.googlesource.com/libyuv/libyuv/"
LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
RESTRICT="fetch"
RDEPEND="virtual/jpeg"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest
		dev-cpp/gflags )
	dev-util/cmake"
SLOT="0"
IUSE="static system-gflags test"
S="${WORKDIR}/${PN}-${PV}"
DOCS=( AUTHORS LICENSE PATENTS README.chromium README.md )
EGIT_COMMIT="e278d4617fe0fd709bef52ef10137edcd85026f6"
EGIT_REPO_URI="https://chromium.googlesource.com/libyuv/libyuv"

src_unpack() {
	git-r3_fetch
	git-r3_checkout
}

src_prepare() {
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
	dodir /usr/$(get_libdir)
	mv "${D}/usr/lib/libyuv."* "${D}/usr/$(get_libdir)" || die
	if ! use static ; then
		rm "${D}/usr/$(get_libdir)/libyuv.a" || die
	fi
	insinto /usr/$(get_libdir)/pkgconfig
	cat "${FILESDIR}/${PN}.pc.in" | \
	sed -e "s|@prefix@|/usr|" \
	    -e "s|@exec_prefix@|\${prefix}|" \
	    -e "s|@libdir@|/usr/$(get_libdir)|" \
	    -e "s|@includedir@|\${prefix}/include|" \
	    -e "s|@version@|${PV}|" > "${T}/${PN}.pc" || die
	doins "${T}/${PN}.pc"
}
