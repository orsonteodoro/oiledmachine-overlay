# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools edos2unix flag-o-matic multilib-minimal

MY_PN="MediaInfo"
DESCRIPTION="MediaInfo libraries"
HOMEPAGE="https://mediaarea.net/mediainfo/ https://github.com/MediaArea/MediaInfoLib"
LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
IUSE+=" curl doc mms static-libs"
# U 20.04
DEPEND+="
	>=dev-libs/tinyxml2-7.0.0:=[${MULTILIB_USEDEP}]
	>=dev-util/desktop-file-utils-0.24
	>=media-libs/libzen-0.4.39:=[static-libs=,${MULTILIB_USEDEP}]
	>=net-libs/webkit-gtk-2.28.1:4[${MULTILIB_USEDEP}]
	>=sys-apps/bubblewrap-0.4.0
	>=sys-libs/zlib-1.2.11[${MULTILIB_USEDEP}]
	>=x11-libs/libSM-1.2.3[${MULTILIB_USEDEP}]
	>=x11-libs/wxGTK-3.0.4:3.0-gtk3[${MULTILIB_USEDEP}]
	curl? ( >=net-misc/curl-7.68.0[${MULTILIB_USEDEP}] )
	mms? ( >=media-libs/libmms-0.6.4:=[static-libs=,${MULTILIB_USEDEP}] )
"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	>=dev-util/pkgconf-1.6.3[${MULTILIB_USEDEP},pkg-config(+)]
	doc? ( >=app-doc/doxygen-1.8.17 )
"
SRC_URI="https://mediaarea.net/download/source/${PN}/${PV}/${P/-/_}.tar.xz"
# tests try to fetch data from online sources
RESTRICT="test"
S="${WORKDIR}/${MY_PN}Lib"

PATCHES=(
	"${FILESDIR}"/${P}-link-fix.patch
)

src_prepare() {
	cd "${S}/Project/GNU/Library" || die
	eapply ${PATCHES[@]}
	eapply_user

	sed -i 's:-O2::' configure.ac || die
	append-cppflags -DMEDIAINFO_LIBMMS_DESCRIBE_SUPPORT=0

	multilib_copy_sources
}

multilib_src_configure() {
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
		local HTML_DOCS=( "${WORKDIR}"/${MY_PN}Lib/Doc/*.html )
	fi

	default

	edos2unix ${PN}.pc #414545
	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc

	for x in ./ Archive Audio Duplicate Export Image Multiple Reader Tag Text Video; do
		insinto /usr/include/${MY_PN}/${x}
		doins "${WORKDIR}"/${MY_PN}Lib/Source/${MY_PN}/${x}/*.h
	done

	insinto /usr/include/${MY_PN}DLL
	doins "${WORKDIR}"/${MY_PN}Lib/Source/${MY_PN}DLL/*.h

	dodoc "${WORKDIR}"/${MY_PN}Lib/*.txt

	find "${ED}" -name '*.la' -delete || die
}
