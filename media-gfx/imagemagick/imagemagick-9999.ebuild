# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BO CE CI DOS HO ID IO NPD OOBA OOBR OOBW SO UAF UVAL UB"
CXX_STANDARD=17
QA_PKGCONFIG_VERSION=$(ver_cut 1-3)

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

GENTOO_DEPEND_ON_PERL="no"
QA_PKGCONFIG_VERSION=$(ver_cut 1-3)

CHKL_TIMESTAMPS=(
	"app-arch/bzip2-9999"
	"app-arch/xz-utils-9999"
	"app-text/ghostscript-gpl-9999"
	"dev-libs/libxml2-9999"
	"gnome-base/librsvg-9999"
	"media-libs/freetype-9999"
	"media-libs/libheif-9999"
	"media-libs/libjpeg-turbo-9999"
	"media-libs/libjxl-9999"
	"media-libs/libpng-9999"
	"media-libs/libraw-9999"
	"media-libs/libwebp-9999"
	"dev-libs/libzip-9999"
	"media-libs/openexr-9999"
	"media-libs/tiff-9999"
)

inherit autotools cflags-hardened chkl flag-o-matic perl-module secure-version toolchain-funcs

DESCRIPTION="A collection of tools and libraries for many image formats"
HOMEPAGE="https://imagemagick.org"

if [[ ${PV} == 9999 ]] ; then
	FALLBACK_COMMIT="5a774ca17c5e25c16e54798876e85c03f8c5c033"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/ImageMagick/ImageMagick.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
	MY_P="imagemagick-9999"
else
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/imagemagick.asc
	inherit verify-sig

	MY_PV="$(ver_rs 3 '-')"
	MY_P="ImageMagick-${MY_PV}"
	SRC_URI="
		mirror://imagemagick/${MY_P}.tar.xz
		verify-sig? ( mirror://imagemagick/${MY_P}.tar.xz.asc )
	"

	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
	BDEPEND="verify-sig? ( sec-keys/openpgp-keys-imagemagick )"
fi

S="${WORKDIR}/${MY_P}"

LICENSE="imagemagick"
# Please check this on bumps, SONAME is often not updated! Use abidiff on old/new.
# If ABI is broken, change the bit after the '-'.
SLOT="0/$(ver_cut 1-3)-18"
IUSE+=" bzip2 corefonts +cxx djvu fftw fontconfig fpx graphviz hardened hdri heif"
IUSE+=" jbig jpeg jpeg2k jpegxl lcms lqr lzma opencl openexr openmp pango perl ${GENTOO_PERL_USESTRING}"
IUSE+=" +png postscript q32 q8 raw static-libs svg test tiff truetype webp wmf"
IUSE+=" X xml zip zlib"
IUSE+=" ebuild_revision_3"

REQUIRED_USE="
	corefonts? ( truetype )
	svg? ( xml )
	test? ( corefonts )
"

RESTRICT="!test? ( test )"

RDEPEND="
	!media-gfx/graphicsmagick[imagemagick]
	dev-libs/libltdl:=
	bzip2? ( >=app-arch/bzip2-${BZIP2_PV}:= )
	corefonts? ( media-fonts/corefonts:= )
	djvu? ( app-text/djvu:= )
	fftw? ( sci-libs/fftw:= )
	fontconfig? ( >=media-libs/fontconfig-${FONTCONFIG_PV}:= )
	fpx? ( >=media-libs/libfpx-1.3.0-r1:= )
	graphviz? ( media-gfx/graphviz:= )
	heif? ( >=media-libs/libheif-${LIBHEIF_PV}:=[x265] )
	jbig? ( >=media-libs/jbigkit-2:= )
	jpeg? ( >=media-libs/libjpeg-turbo-${LIBJPEG_TURBO_PV}:= )
	jpeg2k? ( >=media-libs/openjpeg-${OPENJPEG_PV}:= )
	jpegxl? ( >=media-libs/libjxl-${LIBJXL_PV}:= )
	lcms? ( >=media-libs/lcms-${LCMS_PV}:= )
	lqr? ( media-libs/liblqr:= )
	opencl? ( virtual/opencl:* )
	openexr? ( >=media-libs/openexr-${OPENEXR_PV}:= )
	pango? ( >=x11-libs/pango-${PANGO_PV}:= )
	perl? (
		${GENTOO_PERL_DEPSTRING}
		>=dev-lang/perl-${PERL_PV}:=
	)
	png? ( >=media-libs/libpng-${LIBPNG_PV}:= )
	postscript? ( >=app-text/ghostscript-gpl-${GHOSTSCRIPT_GPL_PV}:= )
	raw? ( >=media-libs/libraw-${LIBRAW_PV}:= )
	svg? (
		>=gnome-base/librsvg-${LIBRSVG_PV}:=
		media-gfx/potrace:=
	)
	tiff? ( >=media-libs/tiff-${TIFF_PV}:= )
	truetype? (
		media-fonts/urw-fonts:=
		>=media-libs/freetype-${FREETYPE_PV}:=
	)
	webp? ( >=media-libs/libwebp-${LIBWEBP_PV}:= )
	wmf? ( media-libs/libwmf:= )
	X? (
		>=x11-libs/libICE-${LIBICE_PV}:=
		>=x11-libs/libSM-${LIBSM_PV}:=
		>=x11-libs/libXext-${LIBXEXT_PV}:=
		>=x11-libs/libXt-${LIBXT_PV}:=
	)
	xml? ( >=dev-libs/libxml2-${LIBXML2_PV}:= )
	lzma? ( >=app-arch/xz-utils-${XZ_UTILS_PV}:= )
	zip? ( >=dev-libs/libzip-${LIBZIP_PV}:= )
	zlib? ( >=virtual/zlib-${ZLIB_PV}:= )
"
DEPEND="
	${RDEPEND}
	X? ( x11-base/xorg-proto:= )
"
BDEPEND+=" virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-9999-nocputuning.patch"
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
	# TODO: add verify
		unpack ${A}
	fi
}

src_prepare() {
	default

	#elibtoolize # for Darwin modules
	eautoreconf

	# For testsuite, see bug #500580#c3
	shopt -s nullglob
	for card in /dev/{{ati,dri}/card,nvidia,dri/renderD128}*; do
		addpredict "${card}"
	done
	shopt -u nullglob
	addpredict /dev/nvidiactl

	if use hardened ; then
		# https://github.com/ImageMagick/ImageMagick/issues/8646 (bug #971784)
		sed -i -e 's:not ok:ok:' tests/cli-svg.tap || die
	fi
}

src_configure() {
	chkl_check_many_timestamps

	local depth=16
	use q8 && depth=8
	use q32 && depth=32

	use perl && perl_check_env

	cflags-hardened_append

	[[ ${CHOST} == *-solaris* ]] && append-ldflags -lnsl -lsocket

	# Workaround for bug #941208 (gcc PR117100)
	tc-is-gcc && [[ $(gcc-major-version) == 13 ]] && append-flags -fno-unswitch-loops

	local myeconfargs=(
		$(use_enable static-libs static)
		$(use_enable hdri)
		$(use_enable opencl)
		$(use_enable openmp)
		--with-threads
		--with-modules
		--with-quantum-depth=${depth}
		$(use_with cxx magick-plus-plus)
		$(use_with perl)
		--with-perl-options='INSTALLDIRS=vendor'
		--with-gs-font-dir="${EPREFIX}"/usr/share/fonts/urw-fonts
		$(use_with bzip2 bzlib)
		$(use_with X x)
		$(use_with zip)
		$(use_with zlib)
		--without-autotrace
		--with-uhdr
		$(use_with postscript dps)
		$(use_with djvu)
		--with-dejavu-font-dir="${EPREFIX}"/usr/share/fonts/dejavu
		$(use_with fftw)
		$(use_with fpx)
		$(use_with fontconfig)
		$(use_with truetype freetype)
		$(use_with postscript gslib)
		$(use_with graphviz gvc)
		$(use_with heif heic)
		$(use_with jbig)
		$(use_with jpeg)
		$(use_with jpeg2k openjp2)
		$(use_with jpegxl jxl)
		$(use_with lcms)
		$(use_with lqr)
		$(use_with lzma)
		$(use_with openexr)
		$(use_with pango)
		$(use_with png)
		$(use_with raw)
		$(use_with svg rsvg)
		$(use_with tiff)
		$(use_with webp)
		$(use_with corefonts windows-font-dir "${EPREFIX}"/usr/share/fonts/corefonts)
		$(use_with wmf)
		$(use_with xml)

		# Default upstream (as of 6.9.12.96/7.1.1.18 anyway) is open
		# For now, let's make USE=hardened do 'limited', and have USE=-hardened
		# reflect the upstream default of 'open'.
		#
		# We might change it to 'secure' and 'limited' at some point.
		# See also bug #716674.
		--with-security-policy=$(usex hardened limited open)
	)

	CONFIG_SHELL="${BROOT}"/bin/bash econf "${myeconfargs[@]}"
}

src_compile() {
	# Avoid perl-module_src_compile
	default
}

src_test() {
	# Install default (unrestricted) policy in $HOME for test suite, bug #664238
	local _im_local_config_home="${HOME}/.config/ImageMagick"
	mkdir -p "${_im_local_config_home}" || \
		die "Failed to create IM config dir in '${_im_local_config_home}'"
	cp "${FILESDIR}"/policy.test.xml "${_im_local_config_home}/policy.xml" || \
		die "Failed to install default blank policy.xml in '${_im_local_config_home}'"

	local im_command= IM_COMMANDS=()
	if [[ ${PV} == 9999 ]] ; then
		IM_COMMANDS+=( "magick -version" ) # Show version we are using -- cannot verify because of live ebuild
	else
		IM_COMMANDS+=( "magick -version | grep -q -- \"${MY_PV}\"" ) # Verify that we are using version we just built
	fi
	IM_COMMANDS+=( "magick -list policy" ) # Verify that policy.xml is used
	IM_COMMANDS+=( "emake check" ) # Run tests

	for im_command in "${IM_COMMANDS[@]}"; do
		eval "${S}"/magick.sh \
			${im_command} || \
			die "Failed to run \"${im_command}\""
	done
}

src_install() {
	# Ensure documentation installation files and paths with each release!
	emake \
		DESTDIR="${D}" \
		DOCUMENTATION_PATH="${EPREFIX}"/usr/share/doc/${PF}/html \
		install

	einstalldocs

	if use perl; then
		find "${ED}" -type f -name perllocal.pod -exec rm -f {} + || die
		find "${ED}" -depth -mindepth 1 -type d -empty -exec rm -rf {} + || die
	fi

	# .la files in parent are not needed, keep plugin .la files
	find "${ED}"/usr/$(get_libdir)/ -maxdepth 1 -name "*.la" -delete || die

	# https://github.com/gentoo/gentoo/pull/37716#discussion_r1696713348
	find "${ED}" -name '*.la' -exec sed -i -e "/^dependency_libs/s:=.*:='':" {} + || die

	if use opencl; then
		cat <<-EOF > "${T}"/99${PN}
		SANDBOX_PREDICT="/dev/nvidiactl:/dev/nvidia-uvm:/dev/ati/card:/dev/dri/card:/dev/dri/card0:/dev/dri/renderD128"
		EOF

		insinto /etc/sandbox.d
		doins "${T}"/99${PN} #472766
	fi

	insinto /usr/share/${PN}
	doins config/*icm
}
