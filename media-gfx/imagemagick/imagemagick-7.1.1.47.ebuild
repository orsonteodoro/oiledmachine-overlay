# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BO CE CI DOS HO ID IO NPD OOBA OOBR OOBW SO UAF UV UB" # UV = Uninitalized Value
QA_PKGCONFIG_VERSION=$(ver_cut 1-3)
inherit autotools cflags-hardened flag-o-matic perl-functions toolchain-funcs

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ImageMagick/ImageMagick.git"
	inherit git-r3
	MY_P="imagemagick-9999"
else
	MY_PV="$(ver_rs 3 '-')"
	MY_P="ImageMagick-${MY_PV}"
	SRC_URI="mirror://imagemagick/${MY_P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi

S="${WORKDIR}/${MY_P}"

DESCRIPTION="A collection of tools and libraries for many image formats"
HOMEPAGE="https://imagemagick.org/index.php"

LICENSE="imagemagick"
# Please check this on bumps, SONAME is often not updated! Use abidiff on old/new.
# If ABI is broken, change the bit after the '-'.
SLOT="0/$(ver_cut 1-3)-18"
IUSE="bzip2 corefonts +cxx djvu fftw fontconfig fpx graphviz hardened hdri heif jbig jpeg jpeg2k jpegxl lcms lqr lzma opencl openexr openmp pango perl +png postscript q32 q8 raw static-libs svg test tiff truetype webp wmf X xml zip zlib"

REQUIRED_USE="
	corefonts? ( truetype )
	svg? ( xml )
	test? ( corefonts )
"

RESTRICT="!test? ( test )"

RDEPEND_DISABLED="
	heif? ( media-libs/libheif:=[x265] )
"
RDEPEND="
	!media-gfx/graphicsmagick[imagemagick]
	dev-libs/libltdl
	bzip2? ( app-arch/bzip2 )
	corefonts? ( media-fonts/corefonts )
	djvu? ( app-text/djvu )
	fftw? ( sci-libs/fftw:3.0 )
	fontconfig? ( media-libs/fontconfig )
	fpx? ( >=media-libs/libfpx-1.3.0-r1 )
	graphviz? ( media-gfx/graphviz )
	heif? ( media-libs/libheif:= )
	jbig? ( >=media-libs/jbigkit-2:= )
	jpeg? ( media-libs/libjpeg-turbo:= )
	jpeg2k? ( >=media-libs/openjpeg-2.1.0:2 )
	jpegxl? ( >=media-libs/libjxl-0.6:= )
	lcms? ( media-libs/lcms:2= )
	lqr? ( media-libs/liblqr )
	opencl? ( virtual/opencl )
	openexr? ( media-libs/openexr:0= )
	pango? ( x11-libs/pango )
	perl? ( >=dev-lang/perl-5.8.8:= )
	png? ( media-libs/libpng:= )
	postscript? ( app-text/ghostscript-gpl:= )
	raw? ( media-libs/libraw:= )
	svg? (
		gnome-base/librsvg
		media-gfx/potrace
	)
	tiff? ( media-libs/tiff:= )
	truetype? (
		media-fonts/urw-fonts
		>=media-libs/freetype-2
	)
	webp? ( media-libs/libwebp:= )
	wmf? ( media-libs/libwmf )
	X? (
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libXext
		x11-libs/libXt
	)
	xml? ( dev-libs/libxml2:= )
	lzma? ( app-arch/xz-utils )
	zip? ( dev-libs/libzip:= )
	zlib? ( sys-libs/zlib:= )
"
DEPEND="
	${RDEPEND}
	X? ( x11-base/xorg-proto )
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-9999-nocputuning.patch"
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	default

	#elibtoolize # for Darwin modules
	eautoreconf

	# For testsuite, see bug #500580#c3
	local ati_cards mesa_cards nvidia_cards render_cards
	shopt -s nullglob
	ati_cards=$(echo -n /dev/ati/card*)
	for card in ${ati_cards[@]} ; do
		addpredict "${card}"
	done
	mesa_cards=$(echo -n /dev/dri/card*)
	for card in ${mesa_cards[@]} ; do
		addpredict "${card}"
	done
	nvidia_cards=$(echo -n /dev/nvidia*)
	for card in ${nvidia_cards[@]} ; do
		addpredict "${card}"
	done
	render_cards=$(echo -n /dev/dri/renderD128*)
	for card in ${render_cards[@]} ; do
		addpredict "${card}"
	done
	shopt -u nullglob
	addpredict /dev/nvidiactl
}

src_configure() {
	local depth=16
	use q8 && depth=8
	use q32 && depth=32

	use perl && perl_check_env

	[[ ${CHOST} == *-solaris* ]] && append-ldflags -lnsl -lsocket

	# Workaround for bug #941208 (gcc PR117100)
	tc-is-gcc && [[ $(gcc-major-version) == 13 ]] && append-flags -fno-unswitch-loops

	cflags-hardened_append

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
		find "${ED}" -type f -name perllocal.pod -exec rm -f {} +
		find "${ED}" -depth -mindepth 1 -type d -empty -exec rm -rf {} +
	fi

	find "${ED}" -name '*.la' -exec sed -i -e "/^dependency_libs/s:=.*:='':" {} +
	# .la files in parent are not needed, keep plugin .la files
	find "${ED}"/usr/$(get_libdir)/ -maxdepth 1 -name "*.la" -delete || die

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
