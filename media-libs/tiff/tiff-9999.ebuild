# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BO BOR CRSH DOS CE DF HO ID IO MC ML NPD OOBA OOBR OOBW SO UAF UB UM"

# Release signer can vary per version but not clear if others will be doing
# them in future, so gone with Even Rouault for now as he does other geosci
# stuff too like PROJ, GDAL. Previous release manager of TIFF was
# GraphicsMagick maintainer Bob Friesenhahn. Please be careful when verifying
# who made releases.
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/evenrouault.asc

CHKL_TIMESTAMPS=(
	"app-arch/libdeflate-9999"
	"app-arch/xz-utils-9999"
	"app-arch/zstd-9999"
	"media-libs/lerc-9999"
	"media-libs/libjpeg-turbo-9999"
	"media-libs/libwebp-9999"
)

inherit autotools cflags-hardened chkl libtool multilib-minimal secure-version verify-sig flag-o-matic

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="d01a94be176f5f6a87f7ee1c0b32e65416aa2b4d"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://gitlab.com/libtiff/libtiff.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	S="${WORKDIR}/${PN}-$(ver_cut 1-3)"
	SRC_URI="https://download.osgeo.org/libtiff/${MY_P}.tar.xz"
	SRC_URI+=" verify-sig? ( https://download.osgeo.org/libtiff/${MY_P}.tar.xz.sig )"
fi

MY_P="${P/_rc/rc}"
DESCRIPTION="Tag Image File Format (TIFF) library"
HOMEPAGE="
	http://www.simplesystems.org/libtiff/
	https://libtiff.gitlab.io/libtiff/
	http://libtiff.maptools.org/
	https://gitlab.com/libtiff/libtiff
"

LICENSE="libtiff"
SOVER="6"
SLOT="0/${SOVER}"
if [[ ${PV} != *_rc* ]] ; then
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
fi
IUSE+="
+cxx jbig jpeg lerc libdeflate lzma opengl static-libs test webp zlib zstd
ebuild_revision_2
"
RESTRICT="!test? ( test )"

# lerc?( zlib ): bug #953883
# test? ( jpeg ): bug #483132
# Disabled jbigkit because it is missing DoS patches
REQUIRED_USE="
	!jbig
	lerc? ( zlib )
	libdeflate? ( zlib )
	test? ( jpeg )
"

RDEPEND="
	jbig? (
		>=media-libs/jbigkit-2.1:=[${MULTILIB_USEDEP}]
	)
	jpeg? (
		>=media-libs/libjpeg-turbo-${LIBJPEG_TURBO_PV}:=[${MULTILIB_USEDEP}]
	)
	lerc? (
		>=media-libs/lerc-${LERC_PV}:=[${MULTILIB_USEDEP}]
	)
	libdeflate? (
		>=app-arch/libdeflate-${LIBDEFLATE_PV}:=[${MULTILIB_USEDEP}]
	)
	lzma? (
		>=app-arch/xz-utils-${XZ_UTILS_PV}:=[${MULTILIB_USEDEP}]
	)
	opengl? (
		>=media-libs/freeglut-${FREEGLUT_PV}:=[${MULTILIB_USEDEP}]
		virtual/opengl:*[${MULTILIB_USEDEP}]
	)
	webp? (
		>=media-libs/libwebp-${LIBWEBP_PV}:=[${MULTILIB_USEDEP}]
	)
	zlib? (
		>=virtual/zlib-${ZLIB_PV}:=[${MULTILIB_USEDEP}]
	)
	zstd? (
		>=app-arch/zstd-${ZSTD_PV}:=[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}"
BDEPEND="verify-sig? ( >=sec-keys/openpgp-keys-evenrouault-20250913:* )"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/tiffconf.h
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
}

src_prepare() {
	default

	eautoreconf

	# Added to fix cross-compilation
	elibtoolize
}

multilib_src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	append-lfs-flags

	local myeconfargs=(
		--disable-sphinx
		--with-docdir="${EPREFIX}"/usr/share/doc/${PF}
		$(use_enable cxx)
		$(use_enable jbig)
		$(use_enable jpeg)
		$(multilib_native_use_enable opengl)
		$(use_enable lerc)
		$(use_enable libdeflate)
		$(use_enable lzma)
		$(use_enable static-libs static)
		$(use_enable test tests)
		$(use_enable webp)
		$(use_enable zlib)
		$(use_enable zstd)

		$(multilib_native_enable docs)
		$(multilib_native_enable contrib)
		$(multilib_native_enable tools)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	find "${ED}" -type f -name '*.la' -delete || die
	rm "${ED}"/usr/share/doc/${PF}/{README*,RELEASE-DATE,TODO,VERSION} || die
}
