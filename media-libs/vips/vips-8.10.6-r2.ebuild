# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit autotools eutils flag-o-matic llvm multilib multilib-minimal \
python-any-r1 toolchain-funcs

DESCRIPTION="VIPS Image Processing Library"
HOMEPAGE="https://jcupitt.github.io/libvips/"
LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~x86"
SO_C=54
SO_R=7
SO_A=12
SO_MAJOR=$((${SO_C} - ${SO_A})) # Currently 42
SLOT="1/${PV}-${SO_MAJOR}"
IUSE+=" +analyze aom cairo cxx debug exif fftw fits gif graphicsmagick gsf
-gtk-doc +hdr heif imagemagick imagequant jpeg lcms libde265 matio -minimal
openexr openslide orc pangoft2 png poppler +ppm python rav1e spng static-libs
svg test tiff webp x265 zlib"
REQUIRED_USE="
	imagequant? ( png )
	poppler? ( cairo )
	svg? ( cairo )"
# Assumed U 18.04
# See also https://github.com/libvips/libvips/blob/v8.10.6/.travis.yml
# libnifti missing
LIBJPEG_TURBO_V="1.5.2"
RDEPEND+="
	$(python_gen_any_dep '>=dev-libs/gobject-introspection-1.56.1[${PYTHON_SINGLE_USEDEP}]')
	>=dev-libs/glib-2.56.1:2[${MULTILIB_USEDEP}]
	>=dev-libs/expat-2.2.5[${MULTILIB_USEDEP}]
	>=dev-libs/libffi-3.2.1[${MULTILIB_USEDEP}]
	>=sci-libs/gsl-2.4
	>=sys-libs/libomp-10.0.0[${MULTILIB_USEDEP}]
	cairo? ( >=x11-libs/cairo-1.15.10[${MULTILIB_USEDEP}] )
	debug? ( >=dev-libs/dmalloc-5.5.2 )
	exif? ( >=media-libs/libexif-0.6.21[${MULTILIB_USEDEP}] )
	fftw? ( >=sci-libs/fftw-3.3.7:3.0=[${MULTILIB_USEDEP}] )
	fits? ( >=sci-libs/cfitsio-3.430[${MULTILIB_USEDEP}] )
	gif? ( >=media-libs/giflib-5.1.4[${MULTILIB_USEDEP}] )
	gsf? ( >=gnome-extra/libgsf-1.14.41 )
	heif? ( libde265? ( >=media-libs/libde265-1.0.2[${MULTILIB_USEDEP}] )
		>=media-libs/libheif-1.1.0[aom?,libde265?,rav1e?,x265?,${MULTILIB_USEDEP}] )
	imagemagick? (
		graphicsmagick? ( >=media-gfx/graphicsmagick-1.3.28 )
		!graphicsmagick? ( >=media-gfx/imagemagick-6.9.7.4 )
	)
	imagequant? ( >=media-gfx/libimagequant-2.12.2 )
	jpeg? ( || (   virtual/jpeg:0=[${MULTILIB_USEDEP}]
			>=media-libs/libjpeg-turbo-${LIBJPEG_TURBO_V}[${MULTILIB_USEDEP}] ) )
	lcms? ( >=media-libs/lcms-2.9[${MULTILIB_USEDEP}] )
	matio? ( >=sci-libs/matio-1.5.11[${MULTILIB_USEDEP}] )
	openexr? ( >=media-libs/openexr-2.2.0[${MULTILIB_USEDEP}] )
	openslide? ( >=media-libs/openslide-3.4.1[${MULTILIB_USEDEP}] )
	orc? ( >=dev-lang/orc-0.4[${MULTILIB_USEDEP}] )
	png? ( >=media-libs/libpng-1.6.34:0=[${MULTILIB_USEDEP}] )
	spng? ( >=media-libs/libspng-0.6.1[${MULTILIB_USEDEP}] )
	pangoft2? ( >=x11-libs/pango-1.40.14[${MULTILIB_USEDEP}] )
	poppler? ( >=app-text/poppler-0.62.0[cairo,introspection] )
	svg? ( >=gnome-base/librsvg-2.40.20[${MULTILIB_USEDEP}] )
	tiff? ( >=media-libs/tiff-4.0.9:0=[${MULTILIB_USEDEP}] )
	webp? ( >=media-libs/libwebp-0.6.1[${MULTILIB_USEDEP}] )
	zlib? ( >=sys-libs/zlib-1.2.11[${MULTILIB_USEDEP}] )"
BDEPEND+="
	|| (	>=sys-devel/gcc-10
		|| (
			(
				sys-devel/clang:13[${MULTILIB_USEDEP}]
				sys-devel/llvm:13[${MULTILIB_USEDEP}]
				>=sys-devel/lld-13
				>=sys-libs/libomp-13[${MULTILIB_USEDEP}]
			)
			(
				sys-devel/clang:12[${MULTILIB_USEDEP}]
				sys-devel/llvm:12[${MULTILIB_USEDEP}]
				>=sys-devel/lld-12
				>=sys-libs/libomp-12[${MULTILIB_USEDEP}]
			)
			(
				sys-devel/clang:11[${MULTILIB_USEDEP}]
				sys-devel/llvm:11[${MULTILIB_USEDEP}]
				>=sys-devel/lld-11
				>=sys-libs/libomp-11[${MULTILIB_USEDEP}]
			)
			(
				sys-devel/clang:10[${MULTILIB_USEDEP}]
				sys-devel/llvm:10[${MULTILIB_USEDEP}]
				>=sys-devel/lld-10
				>=sys-libs/libomp-10[${MULTILIB_USEDEP}]
			)
		)
	)
	>=dev-util/gtk-doc-am-1.27
	gtk-doc? (
		>=app-text/docbook-xml-dtd-4.5:4.5
		>=app-text/pandoc-1.19.2.4
		>=dev-util/gtk-doc-1.27
	)
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '>=dev-python/pip-20.0.2[${PYTHON_USEDEP}]')
		$(python_gen_any_dep '>=dev-python/pytest-4.6.9[${PYTHON_USEDEP}]')
		$(python_gen_any_dep 'dev-python/pyvips[${PYTHON_USEDEP}]')
		$(python_gen_any_dep '>=dev-python/setuptools-39.0.1[${PYTHON_USEDEP}]')
		$(python_gen_any_dep '>=dev-python/wheel-0.30.0[${PYTHON_USEDEP}]')
		|| (
			(
	sys-devel/clang:13[${MULTILIB_USEDEP}]
	=sys-devel/clang-runtime-13*[${MULTILIB_USEDEP},compiler-rt,sanitize]
	sys-devel/llvm:13[${MULTILIB_USEDEP}]
	>=sys-devel/lld-13
	=sys-libs/compiler-rt-sanitizers-13*[libfuzzer,asan,ubsan]
	>=sys-libs/libomp-13[${MULTILIB_USEDEP}]
			)
			(
	sys-devel/clang:12[${MULTILIB_USEDEP}]
	=sys-devel/clang-runtime-12*[${MULTILIB_USEDEP},compiler-rt,sanitize]
	sys-devel/llvm:12[${MULTILIB_USEDEP}]
	>=sys-devel/lld-12
	=sys-libs/compiler-rt-sanitizers-12*[libfuzzer,asan,ubsan]
	>=sys-libs/libomp-12[${MULTILIB_USEDEP}]
			)
			(
	sys-devel/clang:11[${MULTILIB_USEDEP}]
	=sys-devel/clang-runtime-11*[${MULTILIB_USEDEP},compiler-rt,sanitize]
	sys-devel/llvm:11[${MULTILIB_USEDEP}]
	>=sys-devel/lld-11
	=sys-libs/compiler-rt-sanitizers-11*[libfuzzer,asan,ubsan]
	>=sys-libs/libomp-11[${MULTILIB_USEDEP}]
			)
			(
	sys-devel/clang:10[${MULTILIB_USEDEP}]
	=sys-devel/clang-runtime-10*[${MULTILIB_USEDEP},compiler-rt,sanitize]
	sys-devel/llvm:10[${MULTILIB_USEDEP}]
	>=sys-devel/lld-10
	=sys-libs/compiler-rt-sanitizers-10*[libfuzzer,asan,ubsan]
	>=sys-libs/libomp-10[${MULTILIB_USEDEP}]
			)
		)
	)"
PDEPEND+=" python? ( dev-python/pyvips )"
RESTRICT="mirror"
SRC_URI="https://github.com/libvips/libvips/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/libvips-${PV}"
DOCS=( AUTHORS ChangeLog NEWS README.md THANKS )

pkg_setup() {
	use test && python-any-r1_pkg_setup
	if use test ; then
		ewarn \
"The test USE flag may find \"LeakSanitizer: detected memory leaks\" for\n\
dependencies but not directly to prevent tests from passing successfully.\n\
\n\
Remove the test USE flag in order to emerge successfully."
	fi

	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)

	if [[ "${CXX}" =~ 'g++' ]] ; then
		if ver_test $(gcc-version) -lt 9 ; then
			ewarn \
"Upstream tests with GCC >= 9 only.  Switch to version >= 9 if it breaks."
		fi
	elif [[ "${CXX}" =~ 'clang++' ]] ; then
		if ver_test $(clang-version) -lt 10 ; then
			ewarn \
"Upstream tests with clang++ >= 10 only.  Switch to version >= 10 if it breaks."
		fi
	fi

	if use jpeg \
	&& has_version "<media-libs/libjpeg-turbo-${LIBJPEG_TURBO_V}" ; then
		die "Update to >=media-libs/libjpeg-turbo-${LIBJPEG_TURBO_V}"
	fi

	if use test ; then
		ewarn \
"Please disable tests after testing to remove unsafe flags."
	fi

	local abis=( $(multilib_get_enabled_abis) )
	for a in ${abis[@]} ; do
		for p in ${_MULTILIB_FLAGS[@]} ; do
			if [[ "${p}" =~ "${a}" ]] ; then
				local u=$(echo "${p}" | cut -f 1 -d ":")
				if ! use ${u} ; then
					einfo "Skipped sys-devel/clang[${u}]"
					continue
				fi
				einfo "Checking sys-devel/clang[${u}]"
				# `emerge -1 vips` is not good enough to make
				# the fuzzer test happy.
				if has_version "sys-devel/clang[${u}]" ; then
					einfo "sys-devel/clang[${u}] found"
				else
					die \
"Inconsistency with sys-devel/clang[${u}].  Run emerge with --deep or -D."
				fi
			fi
		done
	done
}

src_prepare() {
	default
#	cd "${S}" || die
	sed -i -r \
-e '/define VIPS_VERSION_STRING/s#@VIPS_VERSION_STRING@#@VIPS_VERSION@#' \
		libvips/include/vips/version.h.in || die

	if use gtk-doc ; then
		gtkdocize --copy --docdir doc --flavour no-tmpl || die
	else
#		sed -i -e "\/doc\/Makefile/d" \
#			-e "\/doc\/libvips-docs.xml/d" \
#			configure.ac || die
		sed -i -e "/gtk-doc.make/d" \
			-e "s|EXTRA_DIST +=|EXTRA_DIST =|g" \
			doc/Makefile.am || die
	fi

	eautoreconf

	multilib_copy_sources
}

multilib_src_configure() {
	if use test ; then
		if has_version "sys-devel/clang:13" \
			&& has_version "=sys-devel/clang-runtime-13*" \
			&& has_version "=sys-libs/compiler-rt-sanitizers-13*" \
			; then
			einfo "Using clang:13"
			LLVM_MAX_SLOT=13
			llvm_pkg_setup
		elif has_version "sys-devel/clang:12" \
			&& has_version "=sys-devel/clang-runtime-12*" \
			&& has_version "=sys-libs/compiler-rt-sanitizers-12*" \
			; then
			einfo "Using clang:12"
			LLVM_MAX_SLOT=12
			llvm_pkg_setup
		elif has_version "sys-devel/clang:11" \
			&& has_version "=sys-devel/clang-runtime-11*" \
			&& has_version "=sys-libs/compiler-rt-sanitizers-11*" \
			; then
			einfo "Using clang:11"
			LLVM_MAX_SLOT=11
			llvm_pkg_setup
		elif has_version "sys-devel/clang:10" \
			&& has_version "=sys-devel/clang-runtime-10*" \
			&& has_version "=sys-libs/compiler-rt-sanitizers-10*" \
			; then
			einfo "Using clang:10"
			LLVM_MAX_SLOT=10
			llvm_pkg_setup
		else
			die \
"Fix the clang toolchain.  It requires \
sys-devel/clang:\${SLOT}, \
=sys-devel/clang-runtime-\${SLOT}*, \
=sys-libs/compiler-rt-sanitizers-\${SLOT}"
		fi

		local chost=$(get_abi_CHOST ${DEFAULT_ABI})
		local ctarget=$(get_abi_CTARGET)
		if use test && [[ -n "${ctarget}" ]] ; then
			die "Testing with the test USE flag can only be preformed on BDEPEND (CHOST or compat)."
		fi
		[[ -z "${ctarget}" ]] && ctarget=$(get_abi_CHOST ${ABI})
		einfo "chost=${chost}"
		einfo "ctarget=${ctarget}"
		export CC=${ctarget}-clang
		export CXX=${ctarget}-clang++
		filter-flags -frename-registers
		strip-flags
		filter-flags -g \
			-fsanitize=* \
			-fomit-frame-pointer \
			-fopt-* \
			-fno-omit-frame-pointer \
			-fopenmp \
			-fopenmp=* \
			-shared-libsan \
			-shared-libasan \
			-DFUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION
		append-cppflags -g \
				-fsanitize=address,undefined \
				-fno-omit-frame-pointer \
				-fopenmp \
				-DFUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION
		append-ldflags -g \
				-fsanitize=address,undefined \
				-shared-libsan \
				-fopenmp=libomp
		export ASAN_SYMBOLIZER_PATH="$(get_llvm_prefix)/bin/llvm-symbolizer"
		export LDSHARED="${CC} -shared"
		export ASAN_OPTIONS="suppressions=${S}/suppressions/asan.supp:detect_leaks=0"
		export LSAN_OPTIONS="suppressions=${S}/suppressions/lsan.supp"
		export TSAN_OPTIONS="suppressions=${S}/suppressions/tsan.supp"
		export UBSAN_OPTIONS=\
"suppressions=${S}/suppressions/ubsan.supp:print_stacktrace=1"
		echo -e '#include <stdio.h>\nint dlclose(void*handle){return 0;}' \
			| ${CC} -shared -xc -o "${BUILD_DIR}/dlclose.so" - || die
		preload_libsan
		export LD_LIBRARY_PATH=\
"$(get_llvm_prefix)/lib:$(dirname ${ASAN_DSO}):${LD_LIBRARY_PATH}"
		einfo "ASAN_DSO=${ASAN_DSO}"
		einfo "ASAN_SYMBOLIZER_PATH=${ASAN_SYMBOLIZER_PATH}"
		einfo "LDSHARED=${LDSHARED}"
		einfo "ASAN_OPTIONS=${ASAN_OPTIONS}"
		einfo "LSAN_OPTIONS=${LSAN_OPTIONS}"
		einfo "TSAN_OPTIONS=${TSAN_OPTIONS}"
		einfo "UBSAN_OPTIONS=${UBSAN_OPTIONS}"
		einfo "DLCLOSE_PRELOAD=${DLCLOSE_PRELOAD}"
		einfo "LD_LIBRARY_PATH=${LD_LIBRARY_PATH}"
		einfo "LD_PRELOAD=${LD_PRELOAD}"
	fi

	local magick="--without-magick";
	use graphicsmagick && magick="--with-magickpackage=GraphicsMagick"
	use imagemagick && magick="--with-magickpackage=MagickCore"
	econf ${magick} \
		--without-nifti \
		--without-pdfium \
		$(multilib_native_use_enable gtk-doc) \
		$(use cxx || echo "--disable-cxx") \
		$(use_enable debug) \
		$(use_enable static-libs static) \
		$(use_with analyze) \
		$(use_with debug dmalloc) \
		$(use_with exif libexif) \
		$(use_with jpeg) \
		$(use_with fits cfitsio) \
		$(use_with fftw) \
		$(use_with gif giflib) \
		$(use_with gsf) \
		$(use_with hdr radiance) \
		$(use_with heif) \
		$(use_with imagequant) \
		$(use_with lcms) \
		$(use_with matio ) \
		$(use_with openexr OpenEXR) \
		$(use_with openslide) \
		$(use_with orc) \
		$(use_with pangoft2) \
		$(use_with png) \
		$(use_with poppler) \
		$(use_with ppm) \
		$(use_with spng libspng ) \
		$(use_with svg rsvg) \
		$(use_with tiff) \
		$(use_with webp libwebp) \
		$(use_with zlib) \
		$(usex minimal "--without-deprecated" "--with-deprecated")
		--with-html-dir="/usr/share/gtk-doc/html"
}

multilib_src_compile() {
	preload_libsan
	emake
}

preload_libsan() {
	if use test ; then
		case ${ABI} in
			amd64)
		export ASAN_DSO=$(realpath $(${CC} -print-file-name=libclang_rt.asan-x86_64.so))
				;;
			x86)
		export ASAN_DSO=$(realpath $(${CC} -print-file-name=libclang_rt.asan-i386.so))
				;;
			*)
		export ASAN_DSO=$(realpath $(${CC} -print-file-name=libclang_rt.asan-${ABI}.so))
				;;
		esac
		export LD_PRELOAD="${ASAN_DSO} ${DLCLOSE_PRELOAD}"
		export DLCLOSE_PRELOAD="${BUILD_DIR}/dlclose.so"
		export SANDBOX_ON=0 # \
		# Restated from the toolchain.eclass:
		# libsandbox.so wants to be loaded first in LD_PRELOAD but so
		# does libasan.  We must disable the sandbox in order to
		# preform asan tests.
	fi
}

multilib_src_test() {
	local ctarget=$(get_abi_CTARGET ${ABI})
	[[ -z "${ctarget}" ]] && ctarget=$(get_abi_CHOST ${ABI})
	export CC=${ctarget}-clang
	export CXX=${ctarget}-clang++
	preload_libsan
	export ASAN_OPTIONS="suppressions=${S}/suppressions/asan.supp:detect_leaks=1"
	python3 -m pytest -sv --log-cli-level=WARNING test/test-suite || die
}

multilib_src_install() {
	use test && \
die "You need to rebuild vips without the test USE flag to install a working \
vips."
	emake DESTDIR="${D}" install
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
	docinto licenses
	dodoc COPYING
}
