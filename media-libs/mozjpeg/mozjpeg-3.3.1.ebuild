# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Improved JPEG encoder based on libjpeg-turbo"
HOMEPAGE="https://github.com/mozilla/mozjpeg"
LICENSE="BSD IJG ZLIB"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
IUSE=""
RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"
inherit eutils autotools multilib-minimal multilib-build
SRC_URI="\
https://github.com/mozilla/mozjpeg/archive/v${PV}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"
JPEGLIB_V_TRIPLE="62.2.0" # jpeg6b ABI, default
JPEGLIB_V=$(ver_cut 1 ${JPEGLIB_V_TRIPLE})
JPEGLIB_V_MAJOR=$(ver_cut 2 ${JPEGLIB_V_TRIPLE})
JPEGLIB_V_MINOR=$(ver_cut 3 ${JPEGLIB_V_TRIPLE})

src_prepare() {
	default
	eautoreconf || die
	multilib_copy_sources
}

_newbin() {
	newbin wrapper moz$1
	mv "${D}"/usr/bin/$1 "${D}"/usr/bin/.moz$1 || die
}

multilib_src_install() {
	emake install DESTDIR="$D"

	# wrapper to use renamed libjpeg.so (allows coexistence with
	# libjpeg-turbo)
	echo -e '#!/bin/sh\nLD_PRELOAD=libmozjpeg.so .$(basename $0) "$@"' \
		> wrapper

	if multilib_is_native_abi ; then
		_newbin cjpeg
		_newbin djpeg
		_newbin rdjpgcom
		_newbin tjbench
		_newbin jpegtran
		_newbin wrjpgcom

		dodoc README.md README-mozilla.txt usage.txt wizard.txt

		# remove / resolve conflicts between libjpeg-turbo
		rm "${D}"/usr/share/man/man1/{wrjpgcom,cjpeg,djpeg}.1 || die
		rm "${D}"/usr/share/man/man1/{jpegtran,rdjpgcom}.1 || die
		mkdir -p "${D}/usr/include/libmozjpeg" || die
		mv "${D}"/usr/include/*.h "${D}"/usr/include/libmozjpeg || die
	fi

	# remove / resolve conflicts between libjpeg-turbo
	rm "${D}"/usr/$(get_libdir)/libturbojpeg* || die
	rm "${D}"/usr/$(get_libdir)/pkgconfig/libturbojpeg.pc || die
	rm "${D}"/usr/$(get_libdir)/libjpeg.so{,.${JPEGLIB_V}} || die
	mv "${D}"/usr/$(get_libdir)/pkgconfig/lib{,moz}jpeg.pc || die
	mv "${D}"/usr/$(get_libdir)/lib{,moz}jpeg.so.${JPEGLIB_V_TRIPLE} || die
	mv "${D}"/usr/$(get_libdir)/lib{,moz}jpeg.a || die
	mv "${D}"/usr/$(get_libdir)/lib{,moz}jpeg.la || die

	sed -i -e "s|\${prefix}/include|\${prefix}/include/libmozjpeg|" \
		"${D}"/usr/$(get_libdir)/pkgconfig/libmozjpeg.pc || die
	sed -i -e "s|-ljpeg|-lmozjpeg|" \
		"${D}"/usr/$(get_libdir)/pkgconfig/libmozjpeg.pc || die

	cd "${D}"/usr/$(get_libdir)/
	ln -s libmozjpeg.so.${JPEGLIB_V_TRIPLE} libmozjpeg.so.${JPEGLIB_V}
	ln -s libmozjpeg.so.${JPEGLIB_V_TRIPLE} libmozjpeg.so
}
