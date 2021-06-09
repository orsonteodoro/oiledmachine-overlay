# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

# This ebuild exists to prevent:
# ImportError: /usr/lib64/libjemalloc.so.2: cannot allocate memory in static TLS block
# for openusd ebuild-package.

# Same as jemalloc-usd-5.2.1-r1 ebuild from gentoo-overlay but
# with mtls-dialect-gnu patch.

inherit autotools multilib-minimal

MY_PN="jemalloc"
DESCRIPTION="Jemalloc is a general-purpose scalable concurrent allocator"
HOMEPAGE="http://jemalloc.net/ https://github.com/jemalloc/jemalloc"
SRC_URI="https://github.com/jemalloc/jemalloc/releases/download/${PV}/${MY_PN}-${PV}.tar.bz2
"

LICENSE="BSD"
SLOT="0/2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"
IUSE="debug lazy-lock prof static-libs stats xmalloc"
HTML_DOCS=( doc/jemalloc.html )
PATCHES=(
	"${FILESDIR}/${MY_PN}-5.2.0-gentoo-fixups.patch"
	"${FILESDIR}/${MY_PN}-5.2.1-mtls-dialect-gnu2-7036e64.patch"
)
S="${WORKDIR}/${MY_PN}-${PV}"

MULTILIB_WRAPPED_HEADERS=( /usr/include/jemalloc/jemalloc.h )

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
#		--libdir=/usr/$(get_libdir)/openusd/$(get_libdir)
	ECONF_SOURCE="${S}" \
	econf  \
		--prefix=/usr/$(get_libdir)/openusd \
		$(use_enable debug) \
		$(use_enable lazy-lock) \
		$(use_enable prof) \
		$(use_enable stats) \
		$(use_enable xmalloc)
}

multilib_src_install() {
	# Copy man file which the Makefile looks for
	cp "${S}/doc/jemalloc.3" "${BUILD_DIR}/doc" || die
	emake DESTDIR="${D}" install
}

multilib_src_install_all() {
	if [[ ${CHOST} == *-darwin* ]] ; then
		# fixup install_name, #437362
		install_name_tool \
			-id "${EPREFIX}"/usr/$(get_libdir)/libjemalloc.2.dylib \
			"${ED}"/usr/$(get_libdir)/libjemalloc.2.dylib || die
	fi
	use static-libs || find "${ED}" -name '*.a' -delete
	rm -rf "${ED}/usr/share/man" || die
}
