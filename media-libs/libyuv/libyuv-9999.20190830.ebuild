# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3 multilib-build multilib-minimal

DESCRIPTION="libyuv is an open source project that includes YUV scaling and conversion functionality."
HOMEPAGE="https://chromium.googlesource.com/libyuv/libyuv/"

RESTRICT="fetch"

RDEPEND="virtual/jpeg"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest
		dev-cpp/gflags )
	dev-util/cmake"

LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
SLOT="0"
IUSE="system-gflags static test"

S="${WORKDIR}/${PN}-${PV}"
DOCS=( AUTHORS LICENSE PATENTS README.chromium README.md )

EGIT_COMMIT="43d37c05e5468855e412946dc6369d60a7849998"
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
	dodir /usr/lib/$(get_libdir)
	mv "${D}/usr/lib/libyuv.so" "${D}/usr/lib/$(get_libdir)" || die
	if use static ; then
		mv "${D}/usr/lib/libyuv.a" "${D}/usr/$(get_libdir)" || die
	else
		rm "${D}/usr/lib/libyuv.a" || die
	fi
	mkdir -p "${D}/usr/$(get_libdir)/pkgconfig" || die
	cat "${FILESDIR}/${PN}.pc.in" | \
	sed -e "s|@prefix@|/usr|" \
	    -e "s|@exec_prefix@|\${prefix}|" \
	    -e "s|@libdir@|/usr/$(get_libdir)|" \
	    -e "s|@includedir@|\${prefix}/include|" \
	    -e "s|@version@|${PV}|" > "${D}/usr/$(get_libdir)/pkgconfig/${PN}.pc" || die
}

