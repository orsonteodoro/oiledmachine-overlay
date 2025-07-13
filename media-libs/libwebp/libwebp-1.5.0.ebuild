# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${P/_/-}"

CFLAGS_HARDENED_USE_CASES="sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="DF HO IO UAF UM"

inherit autotools cflags-hardened check-compiler-switch multilib-minimal

DESCRIPTION="A lossy image compression format"
HOMEPAGE="https://developers.google.com/speed/webp/download"
SRC_URI="https://storage.googleapis.com/downloads.webmproject.org/releases/webp/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0/7" # subslot = libwebp soname version
if [[ ${PV} != *_rc* ]] ; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi
IUSE="cpu_flags_arm_neon cpu_flags_x86_sse2 cpu_flags_x86_sse4_1 gif +jpeg opengl +png static-libs swap-16bit-csp tiff"

# TODO: dev-lang/swig bindings in swig/ subdirectory
RDEPEND="gif? ( media-libs/giflib:= )
	jpeg? ( media-libs/libjpeg-turbo:= )
	opengl? (
		media-libs/freeglut
		virtual/opengl
	)
	png? ( media-libs/libpng:= )
	tiff? ( media-libs/tiff:= )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.3-libpng-pkg-config.patch
)

pkg_setup() {
	check-compiler-switch_start
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

		$(use_enable cpu_flags_x86_sse2 sse2)
		$(use_enable cpu_flags_x86_sse4_1 sse4.1)
		$(use_enable cpu_flags_arm_neon neon)

		# Only used for gif2webp binary wrt bug #486646
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
