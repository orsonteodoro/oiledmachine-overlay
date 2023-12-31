# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib-minimal

DESCRIPTION="Oggz provides a simple programming interface for reading and \
writing Ogg files and streams"
HOMEPAGE="https://www.xiph.org/oggz/"
SRC_URI="https://downloads.xiph.org/releases/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/$(ver_cut 1-2 ${PV})"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 sparc x86"
IUSE+=" doc static-libs test"
RESTRICT="!test? ( test )"

RDEPEND+=" >=media-libs/libogg-1.2.0[${MULTILIB_USEDEP}]"
DEPEND+=" ${RDEPEND}"
BDEPEND+="
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	doc? ( app-doc/doxygen )
	test? ( app-text/docbook-sgml-utils )"

PATCHES=( "${FILESDIR}/${P}-destdir.patch" )

src_prepare() {
	default

	if ! use doc; then
		sed -i -e '/AC_CHECK_PROG/s:doxygen:dIsAbLe&:' \
			configure.ac || die
	fi

	AT_M4DIR="m4" eautoreconf
	multilib_copy_sources
}

multilib_src_configure() {
	econf \
		$(use_enable static-libs static)
	if ! multilib_is_native_abi ; then
		sed -i -e "s|bin_PROGRAMS|#bin_PROGRAMS|" \
			src/tools/Makefile.am || die
		sed -i -e "s|install-exec-local|noinstall-exec-local|" \
			src/tools/Makefile.am || die
	fi
}

multilib_src_install() {
	default
	# fix the header conflict by putting the define in the pc file
	local off_t=$(grep -e "PRI_OGGZ_OFF_T" \
		include/oggz/oggz_off_t_generated.h \
		| sed -r -e "s|#define PRI_OGGZ_OFF_T \"([l]+)\"|\1|")
	sed -i -e "s|\
Cflags: -I\${includedir}|\
Cflags: -I\${includedir} -DPRI_OGGZ_OFF_T='\"${off_t}\"'|" \
		"${D}/usr/$(get_libdir)/pkgconfig/oggz.pc" || die
	sed -i -r -e "/#define PRI_OGGZ_OFF_T \"([l]+)\"/d" \
		"${D}/usr/include/oggz/oggz_off_t_generated.h" || die
	find "${D}" -name '*.la' -delete || die "Pruning failed"
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multiabi
