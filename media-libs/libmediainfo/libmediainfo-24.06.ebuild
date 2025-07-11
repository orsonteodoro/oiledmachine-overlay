# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="MediaInfo"

inherit autotools check-compiler-switch edos2unix flag-o-matic multilib-minimal

SRC_URI="https://mediaarea.net/download/source/${PN}/${PV}/${P/-/_}.tar.xz"
S="${WORKDIR}/${MY_PN}Lib"

DESCRIPTION="MediaInfo libraries"
HOMEPAGE="
https://mediaarea.net/mediainfo/
https://github.com/MediaArea/MediaInfoLib
"
LICENSE="BSD-2"
KEYWORDS="~amd64 ~arm64"
# Tests try to fetch data from online sources.
RESTRICT="test"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" curl doc mms static-libs"
# U 22.04
# See MediaInfoLib/Project/GNU/libmediainfo.dsc
DEPEND+="
	>=dev-libs/glib-2.72.1[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.13:=[${MULTILIB_USEDEP}]
	>=media-libs/libzen-0.4.41:=[${MULTILIB_USEDEP},static-libs=]
	>=sys-libs/zlib-1.2.11[${MULTILIB_USEDEP}]
	curl? (
		>=net-misc/curl-7.81.0[${MULTILIB_USEDEP}]
	)
	mms? (
		>=media-libs/libmms-0.6.4:=[${MULTILIB_USEDEP},static-libs=]
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=app-text/tofrodos-1.7.13
	>=dev-util/pkgconf-1.8.0[${MULTILIB_USEDEP},pkg-config(+)]
	doc? (
		>=app-text/doxygen-1.9.1
	)
"

pkg_setup() {
	check-compiler-switch_start
}

src_prepare() {
	cd "${S}/Project/GNU/Library" || die
	eapply_user

	sed -i 's:-O2::' configure.ac || die

	append-cppflags -DMEDIAINFO_LIBMMS_DESCRIBE_SUPPORT=0

	eautoreconf
	multilib_copy_sources
}

multilib_src_configure() {
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	cd "${BUILD_DIR}/Project/GNU/Library" || die
	eautoreconf
	econf \
		--enable-shared \
		--with-libtinyxml2 \
		$(use_with curl libcurl) \
		$(use_with mms libmms) \
		$(use_enable static-libs static) \
		$(use_enable static-libs staticlibs)
}

multilib_src_compile() {
	cd "${BUILD_DIR}/Project/GNU/Library" || die
	default

	if use doc; then
		cd "${WORKDIR}"/${MY_PN}Lib/Source/Doc
		doxygen Doxyfile || die
	fi
}

multilib_src_install() {
	cd "${BUILD_DIR}/Project/GNU/Library" || die
	if use doc; then
		local HTML_DOCS=(
			"${WORKDIR}"/${MY_PN}Lib/Doc/*.html
		)
	fi

	default

	edos2unix ${PN}.pc #414545
	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc

	for x in ./ Archive Audio Duplicate Export Image \
		Multiple Reader Tag Text Video; do
		insinto /usr/include/${MY_PN}/${x}
		doins "${WORKDIR}"/${MY_PN}Lib/Source/${MY_PN}/${x}/*.h
	done

	insinto /usr/include/${MY_PN}DLL
	doins "${WORKDIR}"/${MY_PN}Lib/Source/${MY_PN}DLL/*.h

	dodoc "${WORKDIR}"/${MY_PN}Lib/*.txt

	find "${ED}" -name '*.la' -delete || die
}
