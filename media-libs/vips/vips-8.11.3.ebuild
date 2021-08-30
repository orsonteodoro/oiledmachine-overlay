# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EMTRS="release test"
PYTHON_COMPAT=( python3_{8..10} )
inherit autotools eutils flag-o-matic llvm multilib multilib-minimal \
mutex-test-release python-any-r1 toolchain-funcs

DESCRIPTION="VIPS Image Processing Library"
HOMEPAGE="https://jcupitt.github.io/libvips/"
LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~x86"
SO_C=55
SO_R=2
SO_A=13
SO_MAJOR=$((${SO_C} - ${SO_A})) # Currently 42
SLOT="1/${PV}-${SO_MAJOR}"
IUSE+=" +analyze aom cairo cxx debug doxygen exif fftw fits gif graphicsmagick
gsf -gtk-doc fontconfig +hdr heif imagemagick imagequant jpeg jpeg2k jxl lcms
libde265 matio -minimal openexr openslide orc pangocairo png poppler python
rav1e +ppm spng static-libs svg test tiff webp x265 zlib"
REQUIRED_USE="
	imagequant? ( png )
	poppler? ( cairo )
	svg? ( cairo )"
# Assumed U 20.04
# See also https://github.com/libvips/libvips/blob/v8.11.0/.github/workflows/ci.yml
# libnifti missing
LIBJPEG_TURBO_V="2.0.3"
RDEPEND+="
	$(python_gen_any_dep '>=dev-libs/gobject-introspection-1.64.0[${PYTHON_SINGLE_USEDEP}]')
	>=dev-libs/glib-2.64.2:2[${MULTILIB_USEDEP}]
	>=dev-libs/expat-2.2.9[${MULTILIB_USEDEP}]
	>=dev-libs/libffi-0.9.9.9[${MULTILIB_USEDEP}]
	>=sci-libs/gsl-2.5
	>=sys-libs/libomp-10.0.0[${MULTILIB_USEDEP}]
	cairo? ( >=x11-libs/cairo-1.16.0[${MULTILIB_USEDEP}] )
	exif? ( >=media-libs/libexif-0.6.21[${MULTILIB_USEDEP}] )
	fftw? ( >=sci-libs/fftw-3.3.8:3.0=[${MULTILIB_USEDEP}] )
	fits? ( >=sci-libs/cfitsio-3.470[${MULTILIB_USEDEP}] )
	fontconfig? ( >=media-libs/fontconfig-2.13.1[${MULTILIB_USEDEP}] )
	gif? ( media-libs/libnsgif[${MULTILIB_USEDEP}] )
	gsf? ( >=gnome-extra/libgsf-1.14.46 )
	heif? ( libde265? ( >=media-libs/libde265-1.0.4[${MULTILIB_USEDEP}] )
		>=media-libs/libheif-1.6.1[aom?,libde265?,rav1e?,x265?,${MULTILIB_USEDEP}] )
	imagemagick? (
		graphicsmagick? ( >=media-gfx/graphicsmagick-1.3.35 )
		!graphicsmagick? ( >=media-gfx/imagemagick-6.9.10.23 )
	)
	imagequant? ( media-gfx/libimagequant )
	jpeg? ( || (   virtual/jpeg:0=[${MULTILIB_USEDEP}]
			>=media-libs/libjpeg-turbo-${LIBJPEG_TURBO_V}[${MULTILIB_USEDEP}] ) )
	jpeg2k? (
		>=media-libs/openjpeg-2.3.1[${MULTILIB_USEDEP}]
	)
	jxl? ( >=media-libs/libjxl-0.3.7 )
	lcms? ( >=media-libs/lcms-2.9[${MULTILIB_USEDEP}] )
	matio? ( >=sci-libs/matio-1.5.17[${MULTILIB_USEDEP}] )
	openexr? ( >=media-libs/openexr-2.3.0[${MULTILIB_USEDEP}] )
	openslide? ( >=media-libs/openslide-3.4.1[${MULTILIB_USEDEP}] )
	orc? ( >=dev-lang/orc-0.4.31[${MULTILIB_USEDEP}] )
	png? ( >=media-libs/libpng-1.6.37:0=[${MULTILIB_USEDEP}] )
	spng? ( >=media-libs/libspng-0.6.1[${MULTILIB_USEDEP}] )
	pangocairo? ( >=x11-libs/pango-1.44.7[${MULTILIB_USEDEP}] )
	poppler? ( >=app-text/poppler-0.86.1[cairo,introspection] )
	svg? ( >=gnome-base/librsvg-2.48.2[${MULTILIB_USEDEP}] )
	tiff? ( >=media-libs/tiff-4.1.0:0=[${MULTILIB_USEDEP}] )
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
	>=dev-util/gtk-doc-am-1.32
	doxygen? (
		>=app-doc/doxygen-1.8.17
	)
	gtk-doc? (
		>=app-text/docbook-xml-dtd-4.5:4.5
		>=app-text/pandoc-2.5
		>=dev-util/gtk-doc-1.32
	)
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '>=dev-python/pip-9.0.1[${PYTHON_USEDEP}]')
		$(python_gen_any_dep '>=dev-python/pytest-3.3.2[${PYTHON_USEDEP}]')
		$(python_gen_any_dep 'dev-python/pyvips[${PYTHON_USEDEP}]')
		$(python_gen_any_dep '>=dev-python/setuptools-45.2.0[${PYTHON_USEDEP}]')
		$(python_gen_any_dep '>=dev-python/wheel-0.34.2[${PYTHON_USEDEP}]')
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
dependencies but not directly to prevent tests from passing successfully."
	fi

	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)

	if [[ "${CXX}" =~ 'g++' ]] ; then
		if ver_test $(gcc-version) -lt 9 ; then
			ewarn \
"Upstream tests with GCC >= 10 only.  Switch to version >= 10 if it breaks."
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
	cd "${S}" || die
	sed -i -r \
-e '/define VIPS_VERSION_STRING/s#@VIPS_VERSION_STRING@#@VIPS_VERSION@#' \
		libvips/include/vips/version.h.in || die

	if use gtk-doc ; then
		gtkdocize --copy --docdir doc --flavour no-tmpl
	else
#		sed -i -e "\/doc\/Makefile/d" \
#			-e "\/doc\/libvips-docs.xml/d" \
#			configure.ac || die
		sed -i -e "/gtk-doc.make/d" \
			-e "s|EXTRA_DIST +=|EXTRA_DIST =|g" \
			doc/Makefile.am || die
	fi
	eautoreconf

	src_prepare_mtr() {
		cd "${BUILD_DIR}" || die
		multilib_copy_sources
	}
	mutex-test-release_copy_sources
	mutex-test-release_foreach_impl src_prepare_mtr
}

_clear_env()
{
	unset ASAN_DSO
	unset ASAN_OPTIONS
	unset ASAN_SYMBOLIZER_PATH
	unset DLCLOSE_PRELOAD
	unset LD_LIBRARY_PATH
	unset LD_PRELOAD
	unset LDSHARED
	unset LSAN_OPTIONS
	unset TSAN_OPTIONS
	unset UBSAN_OPTIONS
}

_apply_env()
{
	local detect_leaks="${1}"
	if [[ "${EMTR}" == "release" ]] ; then
		:;
	elif [[ "${EMTR}" == "test" ]] ; then
		export ASAN_OPTIONS="suppressions=${S}/suppressions/asan.supp:detect_leaks=${detect_leaks}"
		export ASAN_SYMBOLIZER_PATH="$(get_llvm_prefix)/bin/llvm-symbolizer"
		export LDSHARED="${CC} -shared"
		export LSAN_OPTIONS="suppressions=${S}/suppressions/lsan.supp"
		export TSAN_OPTIONS="suppressions=${S}/suppressions/tsan.supp"
		export UBSAN_OPTIONS=\
"suppressions=${S}/suppressions/ubsan.supp:print_stacktrace=1"
		export LD_LIBRARY_PATH=\
"$(get_llvm_prefix)/lib:$(dirname ${ASAN_DSO}):${LD_LIBRARY_PATH}"
		preload_libsan
	fi
	einfo "ASAN_DSO=${ASAN_DSO}"
	einfo "LDSHARED=${LDSHARED}"
	einfo "ASAN_OPTIONS=${ASAN_OPTIONS}"
	einfo "LSAN_OPTIONS=${LSAN_OPTIONS}"
	einfo "TSAN_OPTIONS=${TSAN_OPTIONS}"
	einfo "UBSAN_OPTIONS=${UBSAN_OPTIONS}"
	einfo "DLCLOSE_PRELOAD=${DLCLOSE_PRELOAD}"
	einfo "LD_LIBRARY_PATH=${LD_LIBRARY_PATH}"
	einfo "LD_PRELOAD=${LD_PRELOAD}"
}

_strip_flags() {
	if tc-is-clang ; then
		filter-flags -frename-registers
	fi
	# sync below
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
}

_apply_flags() {
	if [[ "${EMTR}" == "release" ]] ; then
		:;
	elif [[ "${EMTR}" == "test" ]] ; then
		append-cppflags -g \
				-fsanitize=address,undefined \
				-fno-omit-frame-pointer \
				-fopenmp \
				-DFUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION
		append-ldflags -g \
				-fsanitize=address,undefined \
				-shared-libsan \
				-fopenmp=libomp
	fi
	einfo "CPPFLAGS=${CPPFLAGS}"
	einfo "LDFLAGS=${LDFLAGS}"
}

src_configure_abi() {
	cd "${BUILD_DIR}" || die
	if [[ "${EMTR}" == "release" ]] ; then
		_clear_env
		_strip_flags
		_apply_flags
		_apply_env
	elif [[ "${EMTR}" == "test" ]] ; then
		_clear_env
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
		_strip_flags
		_apply_flags
		echo -e '#include <stdio.h>\nint dlclose(void*handle){return 0;}' \
			| ${CC} -shared -xc -o "${BUILD_DIR}/dlclose.so" - || die
		_apply_env 0
	fi

	local magick="--without-magick";
	use graphicsmagick && magick="--with-magickpackage=GraphicsMagick"
	use imagemagick && magick="--with-magickpackage=MagickCore"
	econf ${magick} \
		--host=${chost} \
		--build=${ctarget} \
		--without-nifti \
		--without-pdfium \
		$(multilib_native_use_enable gtk-doc) \
		$(use_enable debug) \
		$(use_enable static-libs static) \
		$(use_with analyze) \
		$(use_with doxygen) \
		$(use_with exif libexif) \
		$(use_with jpeg) \
		$(use_with fits cfitsio) \
		$(use_with fftw) \
		$(use_with gif nsgif) \
		$(use_with gsf) \
		$(use_with hdr radiance) \
		$(use_with heif) \
		$(use_with imagequant) \
		$(use_with lcms) \
		$(use_with matio ) \
		$(use_with openexr OpenEXR) \
		$(use_with openslide) \
		$(use_with orc) \
		$(use_with pangocairo) \
		$(use_with png) \
		$(use_with poppler) \
		$(use_with ppm) \
		$(use_with spng libspng ) \
		$(use_with svg rsvg) \
		$(use_with tiff) \
		$(use_with webp libwebp) \
		$(use_with zlib) \
		--with-html-dir="/usr/share/gtk-doc/html"
}

src_configure() {
	src_configure_mtr() {
		cd "${BUILD_DIR}" || die
		multilib_foreach_abi src_configure_abi
	}
	mutex-test-release_foreach_impl src_configure_mtr
}

src_compile_abi() {
	cd "${BUILD_DIR}" || die
	_clear_env
	_apply_env 0
	_strip_flags
	_apply_flags
	emake
}

src_compile() {
	src_compile_mtr() {
		cd "${BUILD_DIR}" || die
		multilib_foreach_abi src_compile_abi
	}
	mutex-test-release_foreach_impl src_compile_mtr
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
			arm64)
		export ASAN_DSO=$(realpath $(${CC} -print-file-name=libclang_rt.asan-aarch64.so))
				;;
			arm)
		export ASAN_DSO=$(realpath $(${CC} -print-file-name=libclang_rt.asan-arm.so))
				;;
			*)
			ewarn "Guessing ABI for libclang_rt.asan-${ABI}.so, may likely fail."
		export ASAN_DSO=$(realpath $(${CC} -print-file-name=libclang_rt.asan-${ABI}.so))
				;;
		esac
		if [[ ! -f "${ASAN_DSO}" ]] ; then
			# This may be OS dependent
			die \
"Report to ebuild maintainer about the correct libclang_rt.asan-\${ABI}.so to use."
		fi
		export DLCLOSE_PRELOAD="${BUILD_DIR}/dlclose.so"
		export LD_PRELOAD="${ASAN_DSO} ${DLCLOSE_PRELOAD}"
		export SANDBOX_ON=0 # \
		# Restated from the toolchain.eclass:
		# libsandbox.so wants to be loaded first in LD_PRELOAD but so
		# does libasan.  We must disable the sandbox in order to
		# preform asan tests.
	fi
}

src_test_abi() {
	cd "${BUILD_DIR}" || die
	local ctarget=$(get_abi_CTARGET ${ABI})
	[[ -z "${ctarget}" ]] && ctarget=$(get_abi_CHOST ${ABI})
	export CC=${ctarget}-clang
	export CXX=${ctarget}-clang++
	_clear_env
	_apply_env 1
	python3 -m pytest -sv --log-cli-level=WARNING test/test-suite || die
}

src_test() {
	src_test_mtr() {
		cd "${BUILD_DIR}" || die
		multilib_foreach_abi src_test_abi
	}
	mutex-test-release_foreach_impl src_test_mtr
	SANDBOX_ON=1
}

src_install_abi() {
	cd "${BUILD_DIR}" || die
	emake DESTDIR="${D}" install
}

src_install() {
	src_install_mtr() {
		cd "${BUILD_DIR}" || die
		multilib_foreach_abi src_install_abi
	}
	mutex-test-release_foreach_impl src_install_mtr

	# Verify that release is only installed
	grep -r -e "png_set_crc_action" $(find "${ED}" -name "*.so*") \
		&& die "Detected fuzzed libs."
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
	docinto licenses
	dodoc COPYING
}
