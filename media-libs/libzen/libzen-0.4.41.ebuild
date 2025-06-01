# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools check-compiler-switch flag-o-matic multilib-minimal

MY_PN="ZenLib"
DESCRIPTION="Shared library for libmediainfo and mediainfo"
HOMEPAGE="https://github.com/MediaArea/ZenLib"
LICENSE="all-rights-reserved ZLIB"
# The vanilla ZLIB does not have all rights reserved but stated explictly in the
# README.md
SLOT="0/$(ver_cut 1-2 ${PV})"
KEYWORDS="~amd64 ~arm64"
IUSE+=" doc static-libs"
BDEPEND+="
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	doc? (
		app-text/doxygen
	)
"
SRC_URI="https://mediaarea.net/download/source/${PN}/${PV}/${P/-/_}.tar.bz2"
S="${WORKDIR}/${MY_PN}"

pkg_setup() {
	check-compiler-switch_start
}

src_prepare() {
	default
	pushd "Project/GNU/Library" || die
		sed -i 's:-O2::' configure.ac || die
		eautoreconf
	popd
	multilib_copy_sources
}

multilib_src_configure() {
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	cd "Project/GNU/Library" || die
	econf \
		--enable-unicode \
		--enable-shared \
		$(use_enable static-libs static)
}

multilib_src_compile() {
	cd "${BUILD_DIR}/Project/GNU/Library" || die
	default

	if use doc ; then
		cd "${WORKDIR}/${MY_PN}/Source/Doc" || die
		doxygen Doxyfile || die
	fi
}

multilib_src_install() {
	cd "${BUILD_DIR}/Project/GNU/Library" || die
	default

	insinto "/usr/$(get_libdir)/pkgconfig"
	doins "${PN}.pc"

	for x in ./ Format/Html Format/Http HTTP_Client ; do
		insinto "/usr/include/${MY_PN}/${x}"
		doins "${WORKDIR}/${MY_PN}/Source/${MY_PN}/${x}/"*.h
	done

	dodoc "${WORKDIR}/${MY_PN}/History.txt"
	if use doc ; then
		docinto html
		dodoc "${WORKDIR}/${MY_PN}/Doc/"*
	fi

	find "${ED}" -name '*.la' -delete || die
	cd "${S}" || die
	dodoc License.txt
	dodoc ReadMe.txt
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multilib
# OILEDMACHINE-OVERLAY-META-REVDEP:  libmediainfo -> tizonia
