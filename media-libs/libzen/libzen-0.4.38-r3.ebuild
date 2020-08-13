# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

MY_PN="ZenLib"
DESCRIPTION="Shared library for libmediainfo and mediainfo"
HOMEPAGE="https://github.com/MediaArea/ZenLib"
SRC_URI="https://mediaarea.net/download/source/${PN}/${PV}/${P/-/_}.tar.bz2"

LICENSE="all-rights-reserved ZLIB"
# the vanilla ZLIB does not have all rights reserved but stated explictly in the
# README.md
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs"

DEPEND="virtual/pkgconfig[${MULTILIB_USEDEP}]
	doc? ( app-doc/doxygen )"

#S=${WORKDIR}/${MY_PN}/Project/GNU/Library
S="${WORKDIR}/${MY_PN}"

src_prepare() {
	multilib_copy_sources
	default
}

multilib_src_configure() {
	cd "Project/GNU/Library" || die
	sed -i 's:-O2::' configure.ac || die
	eautoreconf
	econf \
		--enable-unicode \
		--enable-shared \
		$(use_enable static-libs static)
}

multilib_src_compile() {
	cd "${BUILD_DIR}/Project/GNU/Library" || die
	default

	if use doc ; then
		cd "${WORKDIR}"/${MY_PN}/Source/Doc
		doxygen Doxyfile || die
	fi
}

multilib_src_install() {
	cd "${BUILD_DIR}/Project/GNU/Library" || die
	default

	# remove since the pkgconfig file should be used instead
	rm "${D}"/usr/bin/libzen-config

	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc

	for x in ./ Format/Html Format/Http HTTP_Client ; do
		insinto /usr/include/${MY_PN}/${x}
		doins "${WORKDIR}"/${MY_PN}/Source/${MY_PN}/${x}/*.h
	done

	dodoc "${WORKDIR}"/${MY_PN}/History.txt
	if use doc ; then
		docinto html
		dodoc "${WORKDIR}"/${MY_PN}/Doc/*
	fi

	find "${ED}" -name '*.la' -delete || die
	dodoc License.txt
	dodoc ReadMe.txt
}
