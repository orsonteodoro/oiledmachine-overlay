# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${P/_/-}"

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="DF HO IO UAF UM"

CHKL_TIMESTAMPS=(
	"media-libs/giflib-9999"
	"media-libs/libjpeg-turbo-9999"
	"media-libs/libpng-9999"
	"media-libs/tiff-9999"
)

inherit autotools cflags-hardened check-compiler-switch chkl multilib-minimal secure-version

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="add5156cb23d8c2742ced4198be578b570f50c88"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://chromium.googlesource.com/webm/libwebp"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	if [[ ${PV} != *_rc* ]] ; then
		KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
	fi
	S="${WORKDIR}/${MY_P}"
	SRC_URI="https://storage.googleapis.com/downloads.webmproject.org/releases/webp/${MY_P}.tar.gz"
fi

DESCRIPTION="A lossy image compression format"
HOMEPAGE="https://developers.google.com/speed/webp/download"

LICENSE="BSD"
SLOT="0/7" # subslot = libwebp soname version
IUSE+="
cpu_flags_arm_neon cpu_flags_x86_avx2 cpu_flags_x86_sse2 cpu_flags_x86_sse4_1 gif +jpeg opengl +png static-libs swap-16bit-csp tiff
ebuild_revision_10
"

# TODO: dev-lang/swig bindings in swig/ subdirectory
RDEPEND="
	gif? (
		>=media-libs/giflib-${GIFLIB_PV}:=
	)
	jpeg? (
		>=media-libs/libjpeg-turbo-${LIBJPEG_TURBO_PV}:=
	)
	opengl? (
		>=media-libs/freeglut-${FREEGLUT_PV}:=
		virtual/opengl:*
	)
	png? (
		>=media-libs/libpng-${LIBPNG_PV}:=
	)
	tiff? (
		>=media-libs/tiff-${TIFF_PV}:=
	)
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.3-libpng-pkg-config.patch
	"${FILESDIR}"/${PN}-1.6.0-configure-typo.patch
)

pkg_setup() {
	check-compiler-switch_start
}

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
	# Needed for pkg-config patch; use elibtoolize instead if that's ever dropped
	eautoreconf
}

multilib_src_configure() {
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	chkl_check_many_timestamps
	cflags-hardened_append

	local args=(
		--enable-libwebpmux
		--enable-libwebpdemux
		--enable-libwebpdecoder
		$(use_enable static-libs static)
		$(use_enable swap-16bit-csp)
		$(use_enable jpeg)
		$(use_enable png)
		$(use_enable opengl gl)
		$(use_enable tiff)

		$(use_enable cpu_flags_x86_avx2 avx2)
		$(use_enable cpu_flags_x86_sse2 sse2)
		$(use_enable cpu_flags_x86_sse4_1 sse4.1)
		$(use_enable cpu_flags_arm_neon neon)

		# Only used for gif2webp binary (bug #486646)
		$(multilib_native_use_enable gif)
	)

	ECONF_SOURCE="${S}" econf "${args[@]}"
}

multilib_src_install() {
	emake DESTDIR="${D}" install
}

multilib_src_install_all() {
	find "${ED}" -type f -name "*.la" -delete || die
	dodoc AUTHORS ChangeLog doc/*.txt NEWS README.md
}
