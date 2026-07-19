# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical untrusted-data sensitive-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CRSH DF DOS HO ID IO NPD OOBR OOBW SO"

CHKL_TIMESTAMPS=(
	"media-libs/libavif-9999"
	"media-libs/libjpeg-turbo-9999"
	"media-libs/libpng-9999"
	"media-libs/tiff-9999"
	"media-libs/freetype-9999"
	"media-libs/libwebp-9999"
)

inherit autotools cflags-hardened chkl flag-o-matic multilib-minimal secure-version

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="ab9e2a2b7ff19e65f99ae39ffda29f9b9c9ea2f5"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/lib${P}"
	EGIT_REPO_URI="https://github.com/libgd/libgd.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="https://github.com/libgd/libgd/releases/download/${P}/lib${P}.tar.xz"
fi

DESCRIPTION="Graphics library for fast image creation"
HOMEPAGE="https://libgd.org/ https://www.boutell.com/gd/"
S="${WORKDIR}/lib${P}"

LICENSE="gd IJG HPND BSD"
PV_MAJOR="2"
SOVER="3"
SLOT="${PV_MAJOR}/${SOVER}"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE+="
avif cpu_flags_x86_sse fontconfig +jpeg heif +png static-libs test tiff truetype webp xpm zlib
ebuild_revision_1
"
RESTRICT="!test? ( test )"

# fontconfig has prefixed font paths, details see bug #518970
REQUIRED_USE="
	prefix? ( fontconfig )
	test? ( png )
"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	avif? ( >=media-libs/libavif-${LIBAVIF_PV}:=[${MULTILIB_USEDEP}] )
	fontconfig? ( >=media-libs/fontconfig-${FONTCONFIG_PV}:=[${MULTILIB_USEDEP}] )
	jpeg? ( >=media-libs/libjpeg-turbo-${LIBJPEG_TURBO_PV}:=[${MULTILIB_USEDEP}] )
	heif? ( >=media-libs/libheif-${LIBHEIF_PV}:=[${MULTILIB_USEDEP}] )
	png? ( >=media-libs/libpng-${LIBPNG_PV}:=[${MULTILIB_USEDEP}] )
	tiff? ( >=media-libs/tiff-${TIFF_PV}:=[${MULTILIB_USEDEP}] )
	truetype? ( >=media-libs/freetype-${FREETYPE_PV}:=[${MULTILIB_USEDEP}] )
	webp? ( >=media-libs/libwebp-${LIBWEBP_PV}:=[${MULTILIB_USEDEP}] )
	xpm? (
		>=x11-libs/libXpm-3.5.10-r1:=[${MULTILIB_USEDEP}]
		>=x11-libs/libXt-${LIBXT_PV}:=[${MULTILIB_USEDEP}]
	)
	zlib? ( >=virtual/zlib-${ZLIB_PV}:=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-2.3.0-disable-flaky-tests.patch"
)

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
	local actual_pv=$(grep -E -e "define GD_MAJOR_VERSION" "${S}/src/gd.h" | cut -f 3 -d " ")
	local expected_pv="${PV_MAJOR}"
	if ver_test "${actual_pv}" "-ne" "${expected_pv}" ; then
eerror "QA:  Update PV_MAJOR in ebuild"
eerror "Actual PV_MAJOR:  ${actual_pv}"
eerror "Expected PV_MAJOR:  ${expected_pv}"
		die
	fi

	local c=$(grep -E "GDLIB_LT_CURRENT" "${S}/config/getlib.sh" | head -n 1 | cut -f 2 -d "=")
	local a=$(grep -E "GDLIB_LT_AGE" "${S}/config/getlib.sh" | head -n 1 | cut -f 2 -d "=")
	local actual_sover=$(( ${c} - ${a} ))
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Update SOVER in ebuild"
eerror "Actual SOVER:  ${actual_sover}"
eerror "Expected SOVER:  ${expected_sover}"
		die
	fi
}

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append

	# bug 603360, https://github.com/libgd/libgd/blob/fd06f7f83c5e78bf5b7f5397746b4e5ee4366250/docs/README.TESTING#L65
	if use cpu_flags_x86_sse ; then
		append-cflags -msse -mfpmath=sse
	else
		append-cflags -ffloat-store
	fi

	# bug 632076, https://github.com/libgd/libgd/issues/278
	if use arm64 || use ppc64 || use s390 ; then
		append-cflags -ffp-contract=off
	fi

	# we aren't actually {en,dis}abling X here ... the configure
	# script uses it just to add explicit -I/-L paths which we
	# don't care about on Gentoo systems.
	local myeconfargs=(
		--disable-werror
		--without-x
		--without-liq
		$(use_enable static-libs static)
		$(use_with avif)
		$(use_with fontconfig)
		$(use_with png)
		$(use_with tiff)
		$(use_with truetype freetype)
		$(use_with heif)
		$(use_with jpeg)
		$(use_with webp)
		$(use_with xpm)
		$(use_with zlib)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_test() {
	# See https://github.com/libgd/libgd/issues/763 (although it still passed without it here?)
	TMPDIR="${T}" default
}

multilib_src_install_all() {
	dodoc README.md
	find "${ED}" -name '*.la' -delete || die
}
