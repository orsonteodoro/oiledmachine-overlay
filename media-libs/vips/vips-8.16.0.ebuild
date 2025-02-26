# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24
# For deps, see
# https://github.com/libvips/libvips/blob/v8.16.0/.github/workflows/ci.yml

# See CI logs for deps versioning.

# Auto defaults based on CI, but distro assumes auto means disabled.
# Going with the CI tested interpretation.
# CI disables deprecated but enabled by default in meson_options.txt

CPU_FLAGS_X86=(
	"cpu_flags_x86_avx"
	"cpu_flags_x86_avx512bw"
	"cpu_flags_x86_bf16_spr"
	"cpu_flags_x86_bf16_zen4"
	"cpu_flags_x86_ssse3"
)
GCC_PV="14"
LIBJPEG_TURBO_V="2.1.2"
LLVM_COMPAT=( 18 ) # CI uses 14
LLVM_MAX_SLOT="${LLVM_COMPAT[0]}"
PATENT_STATUS_IUSE=(
	"patent_status_nonfree"
)
PYTHON_COMPAT=( "python3_"{8..11} )
SO_C=60
SO_R=0
SO_A=18
SO_MAJOR=$((${SO_C} - ${SO_A})) # Currently 42

inherit flag-o-matic llvm meson-multilib multilib-minimal vala
inherit python-r1 toolchain-funcs

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/libvips-${PV}"
SRC_URI="
https://github.com/libvips/libvips/archive/v${PV}.tar.gz -> ${P}.tar.gz
"

DESCRIPTION="VIPS Image Processing Library"
HOMEPAGE="https://jcupitt.github.io/libvips/"
LICENSE="LGPL-2.1+"
RESTRICT="mirror"
SLOT="0/${SO_MAJOR}"
IUSE+="
${CPU_FLAGS_X86[@]}
${LLVM_COMPAT[@]/#/llvm_slot_}
${PATENT_STATUS_IUSE[@]}
+analyze +archive +avif +cairo +cgif +cxx debug +deprecated -doxygen
+examples +exif +fftw +fits fuzz-testing +gif -graphicsmagick -gtk-doc +heic
+fontconfig +hdr -highway +imagemagick +imagequant -introspection +jpeg
+jpeg2k +jxl +lcms +matio -minimal -nifti +openexr +openslide +orc
+pangocairo +png +poppler +python +ppm -spng +svg test +tiff
+vala +webp +zlib
ebuild_revision_6
"
PATENT_STATUS_REQUIRED_USE="
	!patent_status_nonfree? (
		!heic
	)
"
REQUIRED_USE="
	${PATENT_STATUS_REQUIRED_USE}
	${PYTHON_REQUIRED_USE}
	?? (
		${LLVM_COMPAT[@]/#/llvm_slot_}
	)
	avif? (
		|| (
			aom
			dav1d
		)
		|| (
			aom
			rav1e
			svt-av1
		)
	)
	cgif? (
		imagequant
	)
	fuzz-testing? (
		test
	)
	heic? (
		|| (
			libde265
		)
		|| (
			x265
		)
	)
	imagequant? (
		png
	)
	poppler? (
		cairo
	)
	svg? (
		cairo
	)
	test? (
		|| (
			${LLVM_COMPAT[@]/#/llvm_slot_}
		)
	)
"
PATENT_STATUS_RDEPEND="
	virtual/patent-status[patent_status_nonfree=]
	!patent_status_nonfree? (
		avif? (
			!media-libs/libde265
			>=media-libs/libheif-1.12.0[${MULTILIB_USEDEP},aom?,dav1d?,-libde265,rav1e?,svt-av1?,-x265]
		)
		heic? (
			!media-libs/libde265
			>=media-libs/libheif-1.12.0[${MULTILIB_USEDEP},aom?,dav1d?,-libde265,rav1e?,svt-av1?,-x265]
		)
	)
	patent_status_nonfree? (
		avif? (
			>=media-libs/libheif-1.12.0[${MULTILIB_USEDEP},aom?,dav1d?,libde265?,rav1e?,svt-av1?,x265?]
			libde265? (
				>=media-libs/libde265-1.0.8[${MULTILIB_USEDEP}]
			)
		)
		heic? (
			>=media-libs/libheif-1.12.0[${MULTILIB_USEDEP},aom?,dav1d?,libde265?,rav1e?,svt-av1?,x265?]
			libde265? (
				>=media-libs/libde265-1.0.8[${MULTILIB_USEDEP}]
			)
		)
	)
"
RDEPEND+="
	${PATENT_STATUS_RDEPEND}
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		>=dev-libs/gobject-introspection-1.72.0[${PYTHON_SINGLE_USEDEP}]
	')
	>=dev-libs/glib-2.72.4:2[${MULTILIB_USEDEP}]
	>=dev-libs/expat-2.4.7[${MULTILIB_USEDEP}]
	>=dev-libs/libffi-3.4.2[${MULTILIB_USEDEP}]
	>=sci-libs/gsl-2.7.1
	llvm-runtimes/openmp:14[${MULTILIB_USEDEP}]
	archive? (
		>=app-arch/libarchive-3.6.0[${MULTILIB_USEDEP}]
	)
	cairo? (
		>=x11-libs/cairo-1.16.0[${MULTILIB_USEDEP}]
	)
	cgif? (
		>=media-libs/cgif-0.2.0[${MULTILIB_USEDEP}]
	)
	exif? (
		>=media-libs/libexif-0.6.24[${MULTILIB_USEDEP}]
	)
	fftw? (
		>=sci-libs/fftw-3.3.8:3.0=[${MULTILIB_USEDEP}]
	)
	fits? (
		>=sci-libs/cfitsio-4.0.0[${MULTILIB_USEDEP}]
	)
	fontconfig? (
		>=media-libs/fontconfig-2.13.1[${MULTILIB_USEDEP}]
	)
	gif? (
		media-libs/libnsgif[${MULTILIB_USEDEP}]
	)
	highway? (
		>=dev-cpp/highway-0.16.0[${MULTILIB_USEDEP},cpu_flags_x86_avx=,cpu_flags_x86_avx512bw=,cpu_flags_x86_bf16_spr=,cpu_flags_x86_bf16_zen4=,cpu_flags_x86_ssse3=]
	)
	imagemagick? (
		!graphicsmagick? (
			>=media-gfx/imagemagick-6.9.11.60
		)
		graphicsmagick? (
			>=media-gfx/graphicsmagick-1.4
		)
	)
	imagequant? (
		>=media-gfx/libimagequant-2.17.0
	)
	jpeg? (
		virtual/jpeg:0=[${MULTILIB_USEDEP}]
	)
	jpeg2k? (
		>=media-libs/openjpeg-2.4.0[${MULTILIB_USEDEP}]
	)
	jxl? (
		>=media-libs/libjxl-0.7.0[${MULTILIB_USEDEP}]
	)
	lcms? (
		>=media-libs/lcms-2.12[${MULTILIB_USEDEP}]
	)
	matio? (
		>=sci-libs/matio-1.5.21[${MULTILIB_USEDEP}]
	)
	openexr? (
		>=media-libs/openexr-2.5.7[${MULTILIB_USEDEP}]
	)
	openslide? (
		>=media-libs/openslide-3.4.1[${MULTILIB_USEDEP}]
	)
	orc? (
		>=dev-lang/orc-0.4.32[${MULTILIB_USEDEP}]
	)
	png? (
		>=media-libs/libpng-1.6.37:0=[${MULTILIB_USEDEP}]
	)
	spng? (
		>=media-libs/libspng-0.7[${MULTILIB_USEDEP}]
	)
	pangocairo? (
		>=x11-libs/pango-1.50.6[${MULTILIB_USEDEP}]
	)
	poppler? (
		>=app-text/poppler-22.02.0[${MULTILIB_USEDEP},cairo,introspection]
	)
	svg? (
		>=gnome-base/librsvg-2.52.5[${MULTILIB_USEDEP}]
	)
	tiff? (
		>=media-libs/tiff-4.3.0:0=[${MULTILIB_USEDEP}]
	)
	vala? (
		>=dev-lang/vala-0.56.0
	)
	webp? (
		>=media-libs/libwebp-1.2.2[${MULTILIB_USEDEP}]
	)
	zlib? (
		>=sys-libs/zlib-1.2.11[${MULTILIB_USEDEP}]
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-8.16.0-simd-options.patch"
)

get_configurations() {
	use test && echo "test"
	echo "release"
}

gen_llvm_bdepend()
{
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				llvm-core/clang:${s}[${MULTILIB_USEDEP}]
				llvm-core/lld:${s}
				llvm-core/llvm:${s}[${MULTILIB_USEDEP}]
				llvm-runtimes/openmp:${s}[${MULTILIB_USEDEP}]
			)
		"
	done
}

gen_llvm_test_bdepend()
{
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				!fuzz-testing? (
					=llvm-core/clang-runtime-${s}*[${MULTILIB_USEDEP},compiler-rt]
				)
				llvm-core/clang:${s}[${MULTILIB_USEDEP}]
				llvm-core/lld:${s}
				llvm-core/llvm:${s}[${MULTILIB_USEDEP}]
				llvm-runtimes/openmp:${s}[${MULTILIB_USEDEP}]
				fuzz-testing? (
					=llvm-core/clang-runtime-${s}*[${MULTILIB_USEDEP},compiler-rt,sanitize]
					=llvm-runtimes/compiler-rt-sanitizers-${s}*:=[libfuzzer,asan,ubsan]
				)
			)
		"
	done
}

BDEPEND+="
	${PYTHON_DEPS}
	>=dev-build/gtk-doc-am-1.32
	>=dev-build/meson-0.61.2
	>=dev-build/ninja-1.10.1
	virtual/pkgconfig
	doxygen? (
		>=app-text/doxygen-1.9.1
	)
	fuzz-testing? (
		|| (
			$(gen_llvm_bdepend)
		)
	)
	gtk-doc? (
		>=app-text/docbook-xml-dtd-4.5:4.5
		>=app-text/pandoc-2.9.2.1
		>=dev-util/gtk-doc-1.33.2
	)
	test? (
		$(gen_llvm_test_bdepend)
		$(python_gen_any_dep '
			>=dev-python/pip-22.0.2[${PYTHON_USEDEP}]
			>=dev-python/pytest-6.2.5[${PYTHON_USEDEP}]
			>=dev-python/setuptools-59.6.0[${PYTHON_USEDEP}]
			>=dev-python/wheel-0.37.1[${PYTHON_USEDEP}]
			dev-python/pyvips[${PYTHON_USEDEP}]
		')
	)
	|| (
		$(gen_llvm_bdepend)
		>=sys-devel/gcc-${GCC_PV}
	)
"
PDEPEND+="
	python? (
		dev-python/pyvips[${PYTHON_USEDEP}]
	)
"
DOCS=( "ChangeLog" "README.md" )

pkg_setup() {
	use test && python_setup
	use vala && vala_setup
	if use test ; then
ewarn
ewarn "The test USE flag may find \"LeakSanitizer: detected memory leaks\" for"
ewarn "dependencies but not directly to prevent tests from passing"
ewarn "successfully."
ewarn
	fi

	if use fuzz-testing && use test ; then
		if ! [[ "${VIPS_LD_PRELOAD_SANDBOX_DISABLE}" =~ ("accept"|"permit") ]] ; then
eerror
eerror "Using the test USE flag may disable the ebuild sandbox for fuzz test."
eerror "Set one the environment variables below:"
eerror
eerror "VIPS_LD_PRELOAD_SANDBOX_DISABLE=\"accept\"  # to disable ebuild sandboxing"
eerror "VIPS_LD_PRELOAD_SANDBOX_DISABLE=\"reject\"  # to enable ebuild sandboxing (default)"
eerror
			die
		fi
	fi

	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	export CPP=$(tc-getCPP)

	if [[ "${CXX}" =~ 'g++' ]] ; then
		if ver_test $(gcc-version) -lt ${GCC_PV} ; then
ewarn
ewarn "Upstream tests with GCC >= ${GCC_PV} only.  Switch to version >= ${GCC_PV} if it"
ewarn "breaks."
ewarn
		fi
	elif [[ "${CXX}" =~ 'clang++' ]] ; then
		if ver_test $(clang-version) -ne ${LLVM_MAX_SLOT} ; then
ewarn
ewarn "Upstream tests with clang++ == ${LLVM_MAX_SLOT} only.  Switch to version == ${LLVM_MAX_SLOT} if it"
ewarn "breaks."
ewarn
		fi
	fi

	if use jpeg \
	&& has_version "<media-libs/libjpeg-turbo-${LIBJPEG_TURBO_V}" ; then
eerror
eerror "Update to >=media-libs/libjpeg-turbo-${LIBJPEG_TURBO_V}"
eerror
		die
	fi

	setup_abi() {
		# `emerge -1 vips` is not good enough to make
		# the fuzzer test happy.
		if ! has_version "llvm-core/clang[${MULTILIB_ABI_FLAG}]" ; then
eerror
eerror "Inconsistency with llvm-core/clang[${MULTILIB_ABI_FLAG}].  Run emerge"
eerror "with --deep or -D."
eerror
			die
		fi
	}
	if use test || tc-is-clang ; then
		multilib_foreach_abi setup_abi
	fi
}

_remove_avx() {
	if ! use cpu_flags_x86_avx ; then
		local x
		for x in $(grep -r -l "default,avx" "${S}") ; do
einfo "Patching ${x} without AVX"
			sed -i -e "s|default,avx|default|g" "${x}" || die
		done
	fi
}

src_prepare() {
	default
	cd "${S}" || die

	_remove_avx

	local configuration
	for configuration in $(get_configurations) ; do
		src_prepare_abi() {
			export EMESON_SOURCE="${S}_${configuration}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${configuration}"
			cp -a "${S}" "${EMESON_SOURCE}" || die
		}
		multilib_foreach_abi src_prepare_abi
	done
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
	use fuzz-testing || return
	local detect_leaks="${1}"
	if [[ "${configuration}" == "release" ]] ; then
		:;
	elif [[ "${configuration}" == "test" ]] ; then
		export ASAN_OPTIONS=\
"suppressions=${S}/suppressions/asan.supp:fast_unwind_on_malloc=0:allocator_may_return_null=1:intercept_tls_get_addr=0:detect_leaks=${detect_leaks}"
		export ASAN_SYMBOLIZER_PATH=\
"$(get_llvm_prefix)/bin/llvm-symbolizer"
		export LDSHARED=\
"${CC} -shared"
		export LSAN_OPTIONS=\
"suppressions=${S}/suppressions/lsan.supp:fast_unwind_on_malloc=0"
		export TSAN_OPTIONS=\
"suppressions=${S}/suppressions/tsan.supp"
		export UBSAN_OPTIONS=\
"suppressions=${S}/suppressions/ubsan.supp:halt_on_error=1:abort_on_error=1:print_stacktrace=1"
		local asan_dso_path=$(dirname ${ASAN_DSO} 2>/dev/null)
		export LD_LIBRARY_PATH=\
"$(get_llvm_prefix)/lib:${asan_dso_path}:${LD_LIBRARY_PATH}"
		preload_libsan
	fi
einfo "ASAN_DSO:\t${ASAN_DSO}"
einfo "LDSHARED:\t${LDSHARED}"
einfo "ASAN_OPTIONS:\t${ASAN_OPTIONS}"
einfo "LSAN_OPTIONS:\t${LSAN_OPTIONS}"
einfo "TSAN_OPTIONS:\t${TSAN_OPTIONS}"
einfo "UBSAN_OPTIONS:\t${UBSAN_OPTIONS}"
einfo "DLCLOSE_PRELOAD:\t${DLCLOSE_PRELOAD}"
einfo "LD_LIBRARY_PATH:\t${LD_LIBRARY_PATH}"
einfo "LD_PRELOAD:\t${LD_PRELOAD}"
}

_strip_flags() {
	strip-unsupported-flags
	# Sync below
	filter-flags \
		-g \
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
	if [[ "${configuration}" == "release" ]] ; then
		:;
	elif use fuzz-testing && [[ "${configuration}" == "test" ]] ; then
		append-cppflags \
			-g \
			-fsanitize=address,undefined \
			-fno-omit-frame-pointer \
			-I"${ESYSROOT}/usr/lib/llvm/${LLVM_MAX_SLOT}/include" \
			-fopenmp=libomp \
			-DFUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION
		append-ldflags \
			-g \
			-fsanitize=address,undefined \
			-shared-libsan \
			"${ESYSROOT}/usr/lib/llvm/${LLVM_MAX_SLOT}/$(get_libdir)/libomp.so.${LLVM_MAX_SLOT}"
	fi
einfo "CPPFLAGS:\t${CPPFLAGS}"
einfo "LDFLAGS:\t${LDFLAGS}"
}

is_flagq_last() {
	local flag="${1}"
	local olast=$(echo "${CFLAGS}" \
		| grep -o -E -e "-O(0|1|z|s|2|3|4|fast)" \
		| tr " " "\n" \
		| tail -n 1)
einfo "CFLAGS:\t${CFLAGS}"
einfo "olast:\t${olast}"
	[[ "${flag}" == "${olast}" ]] && return 0
	return 1
}

src_configure_abi() {
	export EMESON_SOURCE="${S}_${configuration}"
	export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${configuration}"
	mkdir -p "${BUILD_DIR}" || die
	cd "${EMESON_SOURCE}" || die
	if [[ "${configuration}" == "release" ]] ; then
		_clear_env
		_strip_flags
		_apply_flags
		_apply_env
	elif [[ "${configuration}" == "test" ]] ; then
		_clear_env

		LLVM_MAX_SLOT=
		local s
		for s in ${LLVM_COMPAT[@]} ; do
			if has_version  "llvm-core/clang:${s}" \
			&& has_version "=llvm-core/clang-runtime-${s}*" \
			&& has_version "=llvm-runtimes/compiler-rt-sanitizers-${s}*" \
				; then
einfo
einfo "Using clang:${s}"
einfo
				LLVM_MAX_SLOT="${s}"
				LLVM_SLOT="${s}"
				llvm_pkg_setup
				break
			fi
		done

		if [[ -z "${LLVM_MAX_SLOT}" ]] ; then
eerror
eerror "Fix the clang toolchain.  It requires:"
eerror
eerror "  llvm-core/clang:\${SLOT}"
eerror "  =llvm-core/clang-runtime-\${SLOT}*"
eerror "  =llvm-runtimes/compiler-rt-sanitizers-*\${SLOT}"
eerror
eerror "where \${SLOT} = 14."
eerror
			die
		fi

		if use test && ! multilib_is_native_abi ; then
eerror
eerror "Testing with the test USE flag can only be preformed on native"
eerror "unilib profiles."
eerror
			die
		fi
		export CC="${CHOST}-clang"
		export CXX="${CHOST}-clang++"
		export CPP="${CC} -E"
		strip-unsupported-flags
		_strip_flags
		_apply_flags
		if use fuzz-testing ; then
			mkdir -p "${BUILD_DIR}" || die
			echo -e '#include <stdio.h>\nint dlclose(void*handle){return 0;}' \
				| ${CC} -shared -xc -o "${BUILD_DIR}/dlclose.so" - || die
		fi
		_apply_env 0
	fi

	if use highway ; then
# The highway automagic for cpu flags could be broken.
ewarn "Please use the dev-cpp/highway::oiledmachine-overlay ebuild instead."
	fi

	if ! use cpu_flags_x86_avx ; then
		append-flags -mno-avx
	fi

	local emesonargs=(
		-Dmodules=enabled
		-Dpdfium=disabled
		-Dquantizr=disabled
		$(meson_feature archive)
		$(meson_feature fits cfitsio)
		$(meson_feature exif)
		$(meson_feature fftw)
		$(meson_feature fontconfig)
#		$(meson_feature heif-module)
		$(meson_feature imagequant)
		$(meson_feature highway)
		$(meson_feature jpeg)
		$(meson_feature jxl jpeg-xl)
#		$(meson_feature jpeg-xl-module)
		$(meson_feature lcms)
		$(meson_feature matio)
		$(meson_feature nifti)
		$(meson_feature openexr)
		$(meson_feature jpeg2k openjpeg)
		$(meson_feature openslide)
		$(meson_feature orc)
		$(meson_feature pangocairo)
		$(meson_feature png)
		$(meson_feature poppler)
#		$(meson_feature poppler-module)
		$(meson_feature svg rsvg)
		$(meson_feature spng)
		$(meson_feature tiff)
		$(meson_feature webp)
		$(meson_feature zlib)
		$(meson_native_use_bool doxygen)
		$(meson_native_use_bool gtk-doc gtk_doc)
		$(meson_native_use_feature introspection)
		$(meson_use analyze)
		$(meson_use cpu_flags_x86_avx avx)
		$(meson_use cpu_flags_x86_avx512bw avx512bw)
		$(meson_use cpu_flags_x86_bf16_spr bf16_spr)
		$(meson_use cpu_flags_x86_bf16_zen4 bf16_zen4)
		$(meson_use cpu_flags_x86_ssse3 ssse3)
		$(meson_use cxx cplusplus)
		$(meson_use debug)
		$(meson_use deprecated)
		$(meson_use examples)
		$(meson_use gif nsgif)
		$(meson_use ppm)
		$(meson_use hdr radiance)
		$(meson_use vala vapi)
		$(usex nifti '-Dnifti-prefix-dir=/usr' '')
	)

	if use avif || use heic ; then
		emesonargs+=(
			-Dheif=enabled
		)
	else
		emesonargs+=(
			-Dheif=disabled
		)
	fi

	if use imagemagick ; then
		emesonargs+=(
			-Dmagick-package="MagickCore"
			-Dmagick=enabled
		)
	elif use graphicsmagick ; then
		emesonargs+=(
			-Dmagick-package="GraphicsMagick"
			-Dmagick=enabled
		)
	else
		emesonargs+=(
			-Dmagick=disabled
		)
	fi

	if is_flagq_last '-O3' ; then
		emesonargs+=(
			-Doptimization=3
		)
	elif is_flagq_last '-O2' ; then
		emesonargs+=(
			-Doptimization=2
		)
	elif is_flagq_last '-Os' ; then
		emesonargs+=(
			-Doptimization=s
		)
	fi
	meson_src_configure
}

src_configure() {
	local configuration
	for configuration in $(get_configurations) ; do
		multilib_foreach_abi src_configure_abi
	done
}

src_compile_abi() {
	export EMESON_SOURCE="${S}_${configuration}"
	export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${configuration}"
	cd "${BUILD_DIR}" || die
	_clear_env
	_apply_env 0
	_strip_flags
	_apply_flags
	meson_src_compile
}

src_compile() {
	local configuration
	for configuration in $(get_configurations) ; do
		multilib_foreach_abi src_compile_abi
	done
}

preload_libsan() {
	if use test ; then
		case ${ABI} in
			amd64)
		export ASAN_DSO=$(realpath \
			$(${CC} -print-file-name=libclang_rt.asan-x86_64.so))
				;;
			x86)
		export ASAN_DSO=$(realpath \
			$(${CC} -print-file-name=libclang_rt.asan-i386.so))
				;;
			arm64)
		export ASAN_DSO=$(realpath \
			$(${CC} -print-file-name=libclang_rt.asan-aarch64.so))
				;;
			arm)
		export ASAN_DSO=$(realpath \
			$(${CC} -print-file-name=libclang_rt.asan-arm.so))
				;;
			*)
ewarn
ewarn "Guessing ABI for libclang_rt.asan-${ABI}.so, may likely fail."
ewarn
		export ASAN_DSO=$(realpath \
			$(${CC} -print-file-name=libclang_rt.asan-${ABI}.so))
				;;
		esac
		if [[ ! -f "${ASAN_DSO}" ]] ; then
			# This may be OS dependent
eerror
eerror "Report to ebuild maintainer about the correct"
eerror "libclang_rt.asan-\${ABI}.so to use."
eerror
			die
		fi
		export DLCLOSE_PRELOAD="${BUILD_DIR}/dlclose.so"
		 # The ebuild sandbox is disabled because libsandbox.so is loaded via LD_PRELOAD.
		export LD_PRELOAD="${ASAN_DSO} ${DLCLOSE_PRELOAD}"
		export SANDBOX_ON=0 # \
		# Restated from the toolchain.eclass:
		# libsandbox.so wants to be loaded first in LD_PRELOAD but so
		# does libasan.  We must disable the sandbox in order to preform
		# asan tests.
	fi
}

src_test_abi() {
einfo "Running test for ${configuration}"
	export EMESON_SOURCE="${S}_${configuration}"
	export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${configuration}"
	cd "${BUILD_DIR}" || die
	export CC="${CHOST}-clang"
	export CXX="${CHOST}-clang++"
	_clear_env
	_apply_env 1
	${EPYTHON} -m pytest -sv --log-cli-level=WARNING test/test-suite || die
}

src_test() {
	local configuration
	for configuration in $(get_configurations) ; do
		multilib_foreach_abi src_test_abi
	done
	SANDBOX_ON=1
}

src_install_abi() {
	[[ "${configuration}" == "test" ]] && return
	export EMESON_SOURCE="${S}_${configuration}"
	export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${configuration}"
	cd "${BUILD_DIR}" || die
	meson_install
	multilib_check_headers
	if use examples && multilib_is_native_abi ; then
einfo "Inside src_install_abi ${ABI}"
		local EXAMPLES=(
			$(find "${BUILD_DIR}/examples" -maxdepth 1 -executable -type f)
		)
		exeinto "/usr/share/${PN}/examples/bin"
		local path
		for path in ${EXAMPLES[@]} ; do
			doexe "${path}"
		done
	fi
}

src_install() {
	local configuration
	for configuration in $(get_configurations) ; do
		multilib_foreach_abi src_install_abi
	done
	multilib_src_install_all
}

multilib_src_install_all() {
	# Verify that release is only installed
	#grep -r -e "png_set_crc_action" $(find "${ED}" -name "*.so*") \
	#	&& die "Detected fuzzed libs."
	cd "${S}" || die
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
	docinto "licenses"
	dodoc "LICENSE"
	if use examples ; then
		insinto "/usr/share/${PN}"
		doins -r "${S}/examples"
	fi
}

# OILEDMACHINE-OVERLAY-META-REVDEP:  texturelab[system-vips]
