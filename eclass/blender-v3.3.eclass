# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: blender-v3.3.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: blender implementation
# @DESCRIPTION:
# The blender-v3.3.eclass helps reduce code duplication across ebuilds
# using the same major.minor version.

# Upstream uses LLVM 12.0.0 for Linux.  For prebuilt binary only addons, this may be
# problematic so avoid them.

# The ebuild uses the same matching LLVM version used with Mesa to prevent
# the multiple LLVM bug.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

ARM_CPU_FLAGS_3_3=(
	neon2x:neon2x
)

CPU_FLAGS_3_3=(
	${ARM_CPU_FLAGS_3_3[@]/#/cpu_flags_arm_}
)

CXXABI_VER=17 # Linux builds should be gnu11, but in Win builds it is c++17

# For max and min package versions see link below. \
# https://github.com/blender/blender/blob/v3.3.8/build_files/build_environment/install_deps.sh#L488
FFMPEG_IUSE+="
	+aom +jpeg2k +mp3 +opus +theora +vorbis +vpx webm +webp +x264 +xvid
"

LLVM_MAX_UPSTREAM=13 # (inclusive)

# FAIL!  Distro only has >= 14.
LLVM_SLOTS=( 14 13 12 11 ) # Upstream says 13 inclusive is max

# For the max exclusive Python supported (and others), see \
# https://github.com/blender/blender/blob/v3.3.8/build_files/build_environment/install_deps.sh#L382
PYTHON_COMPAT=( python3_{10,11} ) # <= 3.11.

OPENVDB_ABIS_MAJOR_VERS=9
OPENVDB_ABIS=(
	${OPENVDB_ABIS_MAJOR_VERS/#/abi}
)
OPENVDB_ABIS=(
	${OPENVDB_ABIS[@]/%/-compat}
)

BOOST_PV="1.78"
CLANG_MIN="8.0"
GCC_MIN="9.3"
FREETYPE_PV="2.12.1"
LEGACY_TBB_SLOT="2"
ONETBB_SLOT="0"
OPENEXR_V3_PV="3.1.9 3.1.8 3.1.7 3.1.5"
LIBOGG_PV="1.3.5"
LIBSNDFILE_PV="1.1.0"
OSL_PV="1.11.17.0"
PUGIXML_PV="1.10"
THEORA_PV="1.1.1"

# gen_llvm_iuse is same as Mesa and LLVM latest stable keyword.
gen_llvm_iuse()
{
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		echo " llvm-${s}"
	done
}

IUSE+="
$(gen_llvm_iuse)
${CPU_FLAGS_3_3[@]%:*}
${FFMPEG_IUSE}
${OPENVDB_ABIS[@]}
+X +abi9-compat +alembic -asan +boost +bullet +collada -cycles-hip
+color-management -cpudetection +cuda +cycles -cycles-device-oneapi +dds -debug
doc +draco +elbeem +embree +ffmpeg +fftw flac +gmp +hdr +jack +jemalloc +jpeg2k
-llvm -man +nanovdb +ndof +nls +nvcc -nvrtc +openal +opencl +openexr
+openimagedenoise +openimageio +openmp +opensubdiv +openvdb +openxr -optix +osl
+pdf +potrace +pulseaudio release +sdl +sndfile +tbb test +tiff +usd -valgrind
r1
"

inherit blender

# See the blender.eclass for the LICENSE variable.
LICENSE+=" CC-BY-4.0" # The splash screen is CC-BY stated in https://www.blender.org/download/demo-files/ )

# The below are hardcoded enabled in the dependency builder but no explicit option
IMPLIED_RELEASE_BUILD_REQUIRED_USE="
	aom
	mp3
	opus
	theora
	vorbis
	vpx
	xvid
"
REQUIRED_USE+="
	!boost? (
		!alembic
		!cycles
		!nls
		!openvdb
		!color-management
	)
	!tbb? (
		!cycles
		!elbeem
		!openimagedenoise
		!openvdb
	)
	^^ (
		${LLVM_SLOTS[@]/#/llvm-}
	)
	^^ (
		${OPENVDB_ABIS[@]}
	)
	aom? (
		ffmpeg
	)
	build_creator? (
		X
	)
	cuda? (
		^^ (
			nvcc
			nvrtc
		)
		cycles
	)
	cycles? (
		tbb
	)
	cycles-device-oneapi? (
		cycles
	)
	cycles-hip? (
		cycles
	)
	embree? (
		cycles
	)
	mp3? (
		ffmpeg
	)
	nanovdb? (
		cycles
		openvdb
		|| (
			opencl
			cuda
		)
	)
	nvcc? (
		|| (
			cuda
			optix
		)
	)
	nvrtc? (
		|| (
			cuda
			optix
		)
	)
	opencl? (
		cycles
	)
	openimagedenoise? (
		tbb
	)
	openvdb? (
		openexr
		tbb
		|| (
			${OPENVDB_ABIS[@]}
		)
	)
	optix? (
		cuda
		cycles
		nvcc
	)
	opus? (
		ffmpeg
	)
	osl? (
		cycles
		llvm
	)
	release? (
		!debug
		!test
		!valgrind
		alembic
		boost
		build_creator
		bullet
		collada
		color-management
		cycles
		dds
		draco
		elbeem
		embree
		ffmpeg
		fftw
		gmp
		jack
		jemalloc
		jpeg2k
		man
		nanovdb
		ndof
		nls
		openal
		openexr
		openimageio
		openmp
		openimagedenoise
		opensubdiv
		openvdb
		openxr
		osl
		pdf
		potrace
		sdl
		sndfile
		tbb
		tiff
		usd
		webp
		cuda? (
			nvcc
		)
	)
	theora? (
		ffmpeg
	)
	usd? (
		tbb
	)
	vorbis? (
		ffmpeg
	)
	vpx? (
		ffmpeg
	)
	webm? (
		ffmpeg
		opus
		vpx
	)
	x264? (
		ffmpeg
	)
	xvid? (
		ffmpeg
	)
"

# Keep dates and links updated to speed up releases and decrease maintenance time cost.
# no need to look past those dates.

# Last change was Jul 29, 2022 for:
# https://github.com/blender/blender/commits/v3.3.8/build_files/build_environment/install_deps.sh

# Last change was Aug 24, 2021 for:
# https://github.com/blender/blender/commits/v3.3.8/build_files/cmake/config/blender_release.cmake
# used for REQUIRED_USE section.

# Last change was Nov 2, 2023 for:
# https://github.com/blender/blender/commits/v3.3.8/build_files/build_environment/cmake/versions.cmake
# used for *DEPENDs.

# dependency version requirements see
# build_files/build_environment/cmake/versions.cmake
# doc/python_api/requirements.txt
# extern/Eigen3/eigen-update.sh
# Track OPENVDB_LIBRARY_MAJOR_VERSION_NUMBER for changes.
# Track build_files/build_environment/dependencies.dot for ffmpeg dependencies
#
# Mentioned in versions.cmake but missing in (R)DEPENDS freeglut,
# glfw, clew, cuew, webp, xml2, tinyxml, yaml, flexbison,
# bzip2, libffi, lzma, openssl, sqlite, nasm, ispc for oidn,
# faad (added in 0.6 ffmpeg but removed in 0.7+)
#
# The LLVM linked to Blender should match mesa's linked llvm version to avoid
# multiple version problem if using system's mesa.

gen_asan_bdepend() {
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
			llvm-${s}? (
				=sys-devel/clang-runtime-${s}[compiler-rt,sanitize]
				=sys-libs/compiler-rt-sanitizers-${s}*[asan]
				sys-devel/clang:${s}
			)
		"
	done
}

gen_llvm_depends()
{
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
			llvm-${s}? (
				>=sys-devel/llvm-${s}:${s}=
			)
		"
	done
}

gen_oidn_depends() {
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
		llvm-${s}? (
			<media-libs/oidn-1.5[llvm-${s}]
			>=media-libs/oidn-1.4.3[llvm-${s}]
		)
		"
	done
}

gen_oiio_depends() {
	local s
	for s in ${OPENVDB_ABIS[@]} ; do
		echo "
			${s}? (
				<media-libs/openimageio-2.4[${s}(+),color-management?,jpeg2k?,png,webp?]
				>=dev-cpp/robin-map-0.6.2
				>=dev-libs/libfmt-8
				>=media-libs/openimageio-2.3.20.0[${s}(+),color-management?,jpeg2k?,png,webp?]
			)
		"
	done
}

gen_openexr_pairs() {
	local pv
	for pv in ${OPENEXR_V3_PV} ; do
		echo "
			(
				~media-libs/openexr-${pv}:=
				~dev-libs/imath-${pv}:=
			)
		"
	done
}

gen_openvdb_depends() {
	local s=${OPENVDB_ABIS_MAJOR_VERS}
	echo "
		abi${s}-compat? (
			=media-gfx/openvdb-${s}.0*[${PYTHON_SINGLE_USEDEP},abi${s}-compat,blosc]
		)
	"
}

gen_osl_depends()
{
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
			llvm-${s}? (
				<media-libs/osl-2:=[llvm-${s},static-libs]
				>=media-libs/osl-${OSL_PV}:=[llvm-${s},static-libs]
			)
		"
	done
}

# The ffplay contradicts in
# build_files/build_environment/cmake/ffmpeg.cmake : --enable-ffplay
# build_files/build_environment/install_deps.sh : --disable-ffplay
CODECS="
	aom? (
		>=media-libs/libaom-3.3.0
	)
	mp3? (
		>=media-sound/lame-3.100[sndfile]
	)
	opus? (
		>=media-libs/opus-1.3.1
	)
	theora? (
		>=media-libs/libogg-${LIBOGG_PV}
		>=media-libs/libtheora-${THEORA_PV}
		vorbis? (
			>=media-libs/libtheora-${THEORA_PV}[encode]
		)
	)
	vorbis? (
		>=media-libs/libogg-${LIBOGG_PV}
		>=media-libs/libvorbis-1.3.7
	)
	vpx? (
		>=media-libs/libvpx-1.11
	)
	x264? (
		>=media-libs/x264-0.0.20220221
	)
	xvid? (
		>=media-libs/xvid-1.3.7
	)
"

# The distro's llvm 14 for mesa is 22.05.
# The required openjpeg version is different for security update.  It is not tagged but newer commit.

RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/certifi-2021.10.8[${PYTHON_USEDEP}]
		>=dev-python/charset-normalizer-2.0.6[${PYTHON_USEDEP}]
		>=dev-python/idna-3.2[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.21.2[${PYTHON_USEDEP}]
		>=dev-python/requests-2.26.0[${PYTHON_USEDEP}]
		>=dev-python/urllib3-1.26.7[${PYTHON_USEDEP}]
		>=dev-python/zstandard-0.16.0[${PYTHON_USEDEP}]
	')
	${CODECS}
	${PYTHON_DEPS}
	>=dev-cpp/pystring-1.1.3
	>=dev-lang/python-3.10.9
	>=media-libs/freetype-${FREETYPE_PV}
	>=media-libs/glew-1.13.0:*
	>=media-libs/libpng-1.6.37:0=
	>=sys-libs/zlib-1.2.13
	dev-libs/lzo:2
	media-libs/libglvnd
	media-libs/libsamplerate
	virtual/libintl
	alembic? (
		>=media-gfx/alembic-1.8.3[boost(+),hdf(+)]
	)
	boost? (
		>=dev-libs/boost-${BOOST_PV}:=[nls?,threads(+)]
		usd? (
			>=dev-libs/boost-${BOOST_PV}:=[nls?,threads(+),python]
		)
	)
	collada? (
		dev-libs/libpcre:=[static-libs]
		>=media-libs/opencollada-1.6.68:=
	)
	color-management? (
		>=dev-libs/expat-2.5.0
		>=media-libs/opencolorio-2.1.1[cpu_flags_x86_sse2?]
	)
	cuda? (
		>=dev-util/nvidia-cuda-toolkit-10.1:=
		>=x11-drivers/nvidia-drivers-418.39
	)
	cycles? (
		osl? (
			>=dev-libs/pugixml-${PUGIXML_PV}
		)
	)
	cycles-device-oneapi? (
		<dev-libs/level-zero-2
		>=dev-libs/level-zero-1.7.15
	)
	cycles-hip? (
		|| (
			dev-util/hip
			dev-libs/rocm-bin[hip-devel,hip-runtime-amd]
		)
	)
	embree? (
		>=media-libs/embree-3.13.4:=\
[-backface-culling(-),-compact-polys(-),cpu_flags_arm_neon2x?,\
cpu_flags_x86_sse4_2?,\
cpu_flags_x86_avx?,cpu_flags_x86_avx2?,filter-function(+),raymask,static-libs,tbb?]
	)
	ffmpeg? (
		<media-video/ffmpeg-6:=\
[encode,jpeg2k?,mp3?,opus?,sdl,theora?,vorbis?,vpx?,x264,xvid?,zlib]
		>=media-video/ffmpeg-4:=\
[encode,jpeg2k?,mp3?,opus?,sdl,theora?,vorbis?,vpx?,x264,xvid?,zlib]
	)
	fftw? (
		>=sci-libs/fftw-3.3.10:3.0=
	)
	flac? (
		>=media-libs/flac-1.4.2
	)
	gmp? (
		>=dev-libs/gmp-6.2.1[cxx]
	)
	jack? (
		virtual/jack
	)
	jemalloc? (
		>=dev-libs/jemalloc-5.2.1:=
	)
	jpeg2k? (
		>=media-libs/openjpeg-2.5.0:2
	)
	llvm? (
		$(gen_llvm_depends)
	)
	llvm-11? (
		>=media-libs/mesa-20.3.5[X?]
		>=sys-libs/libomp-11
	)
	llvm-12? (
		>=media-libs/mesa-20.1.5[X?]
		>=sys-libs/libomp-12
	)
	llvm-13? (
		>=media-libs/mesa-21.2.5[X?]
		>=sys-libs/libomp-13
	)
	llvm-14? (
		<media-libs/mesa-22.2.0[X?]
		>=media-libs/mesa-21.1.0[X?]
		>=sys-libs/libomp-14
	)
	ndof? (
		>=dev-libs/libspnav-0.2.3
		app-misc/spacenavd
	)
	nls? (
		|| (
			virtual/libiconv
			>=dev-libs/libiconv-1.16
		)
	)
	openal? (
		!pulseaudio? (
			>=media-libs/openal-1.21.1[alsa]
		)
		>=media-libs/openal-1.21.1[pulseaudio?]
	)
	opencl? (
		virtual/opencl
	)
	openimagedenoise? (
		$(gen_oidn_depends)
	)
	openimageio? (
		$(gen_oiio_depends)
		>=dev-libs/pugixml-${PUGIXML_PV}
	)
	openexr? (
		!<media-libs/openexr-3
		|| (
			$(gen_openexr_pairs)
		)
	)
	opensubdiv? (
		>=media-libs/opensubdiv-3.4.4:=[cuda=,opencl=,tbb?]
	)
	openvdb? (
		$(gen_openvdb_depends)
		>=dev-libs/c-blosc-1.21.1[zlib]
		nanovdb? (
			~media-gfx/nanovdb-32.3.3_p20211029:0=
		)
	)
	openxr? (
		>=media-libs/openxr-1.0.17
	)
	optix? (
		>=dev-libs/optix-7
	)
	osl? (
		$(gen_osl_depends)
	)
	pdf? (
		>=media-libs/libharu-2.3.0
	)
	potrace? (
		>=media-gfx/potrace-1.16
	)
	pulseaudio? (
		media-sound/pulseaudio
	)
	release? (
		>=media-libs/freetype-${FREETYPE_PV}[brotli,bzip2,harfbuzz,png]
	)
	sdl? (
		!pulseaudio? (
			>=media-libs/libsdl2-2.0.20[alsa,opengl,sound]
		)
		>=media-libs/libsdl2-2.0.20[opengl,pulseaudio?,sound]
	)
	sndfile? (
		>=media-libs/libsndfile-${LIBSNDFILE_PV}
		flac? (
			>=media-libs/libsndfile-${LIBSNDFILE_PV}[-minimal]
		)
	)
	tbb? (
		>=dev-cpp/tbb-2021:${ONETBB_SLOT}[tbbmalloc]
		usd? (
			!<dev-cpp/tbb-2021:0=
			<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}=[tbbmalloc(+)]
		)
	)
	tiff? (
		>=media-libs/tiff-4.5.0:0[jpeg,zlib]
	)
	usd? (
		<media-libs/openusd-23[imaging,monolithic]
		>=media-libs/openusd-22.03[imaging,monolithic]
	)
	valgrind? (
		dev-util/valgrind
	)
	webp? (
		>=media-libs/libwebp-1.2.2
	)
	X? (
		x11-libs/libX11
		x11-libs/libXi
		x11-libs/libXxf86vm
	)
	|| (
		virtual/glu
		>=media-libs/glu-9.0.1
	)
	|| (
		virtual/jpeg:0=
		>=media-libs/libjpeg-turbo-2.1.3
	)
"
DEPEND+="
	${RDEPEND}
	>=dev-cpp/eigen-3.3.7:3=
"
BDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/setuptools-63.2.0[${PYTHON_USEDEP}]
		>=dev-python/cython-0.29.26[${PYTHON_USEDEP}]
	')
	>=dev-cpp/yaml-cpp-0.6.3
	>=dev-util/cmake-3.10
	dev-util/patchelf
	virtual/pkgconfig
	asan? (
		|| (
			$(gen_asan_bdepend)
			(
				>=sys-devel/gcc-${GCC_MIN}[sanitizer]
			)
		)
	)
	cycles? (
		x86? (
			|| (
				>=sys-devel/clang-${CLANG_MIN}
				dev-lang/icc
			)
		)
	)
	doc? (
		>=dev-python/sphinx-3.3.1[latex]
		>=dev-python/sphinx_rtd_theme-0.5.0
		app-doc/doxygen[dot]
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
	nls? (
		sys-devel/gettext
	)
	|| (
		>=sys-devel/gcc-${GCC_MIN}
		>=sys-devel/clang-${CLANG_MIN}
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-2.82a-fix-install-rules.patch"
	"${FILESDIR}/${PN}-3.0.0-install-paths-change.patch"
	"${FILESDIR}/${PN}-3.0.0-openusd-21.11-python.patch"
#	"${FILESDIR}/${PN}-3.0.0-openusd-21-ConnectToSource.patch"
#	"${FILESDIR}/${PN}-3.0.0-openusd-21.11-lightapi.patch"
	"${FILESDIR}/${PN}-2.93.7-build-draco.patch"
#	"${FILESDIR}/${PN}-3.0.0-intern-ghost-fix-typo-in-finding-XF86VMODE.patch"
	"${FILESDIR}/${PN}-3.0.0-boost_python.patch"
#	"${FILESDIR}/${PN}-3.0.0-oiio-util.patch"
	"${FILESDIR}/${PN}-3.3.7-tbb-rpath.patch"
)

check_multiple_llvm_versions_in_native_libs() {
	# Checks to avoid loading multiple versions of LLVM.

	local llvm_slot
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		use "llvm-${s}" && llvm_slot=${s}
	done

	if ldd "${ESYSROOT}/usr/$(get_libdir)/dri/"*".so" 2>/dev/null 1>/dev/null ; then
		local llvm_ret=$(ldd "${ESYSROOT}/usr/$(get_libdir)/dri/"*".so" \
			| grep -q -e "LLVM-${llvm_slot}")
		if [[ "${llvm_ret}" != "0" ]] ; then
ewarn
ewarn "Prebuilt binary video card drivers users:"
ewarn
ewarn "You need link media-libs/mesa with LLVM ${llvm_slot}.  See"
ewarn "media-libs/mesa ebuilds for compatibility details."
ewarn
		fi
	fi

	if use osl && [[ -e "${ESYSROOT}/usr/$(get_libdir)/liboslexec.so" ]] ; then
		osl_llvm=
		if ldd "${ESYSROOT}/usr/$(get_libdir)/liboslexec.so" \
			| grep -q -F "libLLVMAnalysis.so.9" ; then
			# split llvm
			osl_llvm=9
		else
			# monolithic llvm
			osl_llvm=$(ldd "${ESYSROOT}/usr/$(get_libdir)/liboslexec.so" \
				| grep -F -i -e "LLVM" | head -n 1 \
				| grep -o -E -e "libLLVM-[0-9]+.so" \
				| head -n 1 | grep -o -E -e "[0-9]+")
		fi
		if [[ -n "${osl_llvm}" ]] \
			&& ver_test "${osl_llvm}" -ne "${llvm_slot}" ; then
eerror
eerror "media-libs/osl must be linked to LLVM ${llvm_slot}"
eerror
			die
		fi
	fi
}

_blender_pkg_setup() {
	# TODO: ldd oiio for webp and warn user if missing
	# Needs OpenCL 1.2 (GCN 2)
	check_multiple_llvm_versions_in_native_libs
einfo
einfo "This version a Long Term Support (LTS) version till Sep 2024."
einfo

	local found=0
	for s in ${LLVM_SLOTS[@]} ; do
		if (( "${s}" > ${LLVM_MAX_UPSTREAM} )) ; then
			use "llvm-${s}" && found=${s}
		fi
	done

	if (( ${found} != 0 )) ; then
ewarn
ewarn "Upstream supports <= LLVM-${LLVM_MAX_UPSTREAM}.x only."
ewarn "sys-devel/llvm:${found} compatibility is still in testing in this"
ewarn "overlay and made available to resolve the multiple LLVM libraries"
ewarn "loaded bug which includes (proprietary) GPU driver parts linked with a"
ewarn "different version of LLVM.  To avoid this bug, use the same LLVM"
ewarn "version from the driver to this package in the dependency chain"
ewarn "including all dependencies of this package."
ewarn
	fi

	if use cycles-device-oneapi ; then
ewarn
ewarn "Support for the cycles-device-oneapi may be incomplete because distro"
ewarn "may be missing several packages."
ewarn
	fi
}

show_tbb_error() {
eerror
eerror "You can only choose one adventure:"
eerror
eerror "  (1) disable the usd USE flag"
eerror "  (2) use the tbb:${LEGACY_TBB_SLOT} from the oiledmachine-overlay"
eerror "  (3) use the <tbb-2021:0::gentoo and hardmask tbb >= 2021"
eerror
eerror "Any downgrade or upgrade may require a rebuild of those packages"
eerror "depending on them."
eerror
	die
}

_src_prepare_patches() {
	eapply "${FILESDIR}/blender-3.2.2-findtbb2.patch"
	eapply "${FILESDIR}/blender-3.2.0-parent-datafiles-dir-change.patch"
	if \
		( \
			has_version "<dev-cpp/tbb-2021:0" \
				|| \
			has_version "<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}" \
		) \
		&& \
		use usd ; then
		:;
	elif \
		! has_version "<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}" && \
		has_version ">=dev-cpp/tbb-2021:${ONETBB_SLOT}" && \
		use usd ; then
		show_tbb_error
	fi
	if \
		has_version ">=dev-cpp/tbb-2021:${ONETBB_SLOT}" && \
		has_version "<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}" && \
		use usd ; then
		eapply "${FILESDIR}/blender-2.93.10-tbb2-usd.patch"
	elif use usd ;then
ewarn
ewarn "Untested tbb configuration.  It is assumed"
ewarn ">=dev-cpp/tbb-2021:${ONETBB_SLOT} and"
ewarn "<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT} are both installed."
ewarn
ewarn "Install both if build fails."
ewarn
	fi
}

_src_configure() {
	export CMAKE_USE_DIR="${S}"
	export BUILD_DIR="${S}_${impl}_build"
	cd "${CMAKE_USE_DIR}" || die

	# FIX: forcing '-funsigned-char' fixes an anti-aliasing issue with menu
	# shadows, see bug #276338 for reference
	append-flags -funsigned-char
	append-lfs-flags

	local s=${OPENVDB_ABIS_MAJOR_VERS}
	if use abi${s}-compat ; then
		append-cppflags -DOPENVDB_ABI_VERSION_NUMBER=${s}
	fi

	local mycmakeargs=()
	mycmakeargs+=( -DCMAKE_INSTALL_BINDIR:PATH="${EPREFIX}$(get_dest)" )

	unset CMAKE_INCLUDE_PATH
	unset CMAKE_LIBRARY_PATH
	unset CMAKE_PREFIX_PATH

	blender_configure_simd_cycles
	blender_configure_eigen

	# TODO: migrate blender-libs changes from blender-v2.83 once LLVM-10 is deprecated

	# WITH_INPUT_IME is default ON upstream but only supports non-linux
	mycmakeargs+=(
# Fixes
#CMake Error: The inter-target dependency graph contains the following strongly connected component (cycle):
#  "cycles_bvh" of type SHARED_LIBRARY
		-DBUILD_SHARED_LIBS=OFF

		-DPYTHON_VERSION="${EPYTHON/python/}"
		-DPYTHON_LIBRARY="$(python_get_library_path)"
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DSUPPORT_SSE_BUILD=$(usex cpu_flags_x86_sse)
		-DSUPPORT_SSE2_BUILD=$(usex cpu_flags_x86_sse2)
		-DWITH_ALEMBIC=$(usex alembic)
		-DWITH_ASSERT_ABORT=$(usex debug)
		-DWITH_BOOST=$(usex boost)
		-DWITH_BULLET=$(usex bullet)
		-DWITH_COMPILER_ASAN=$(usex asan)
		-DWITH_CPU_SSE=$(usex cpu_flags_x86_sse2)
		-DWITH_CUDA_DYNLOAD=$(usex cuda $(usex nvcc ON OFF) ON)
		-DWITH_CXX_GUARDEDALLOC=$(usex debug)
		-DWITH_CXX11_ABI=ON
		-DWITH_CYCLES_HIP_BINARIES=$(usex cycles-hip)
		-DWITH_DOC_MANPAGE=$(usex man)
		-DWITH_DRACO=$(usex draco)
		-DWITH_GHOST_WAYLAND_DYNLOAD=OFF
		-DWITH_GMP=$(usex gmp)
		-DWITH_IK_SOLVER=ON
		-DWITH_INPUT_IME=OFF
		-DWITH_IMAGE_DDS=$(usex dds)
		-DWITH_IMAGE_HDR=$(usex hdr)
		-DWITH_IMAGE_OPENEXR=$(usex openexr)
		-DWITH_IMAGE_OPENJPEG=$(usex jpeg2k)
		-DWITH_IMAGE_TIFF=$(usex tiff)
		-DWITH_INTERNATIONAL=$(usex nls)
		-DWITH_HARU=$(usex pdf)
		-DWITH_LLVM=$(usex llvm)
		-DWITH_MEM_JEMALLOC=$(usex jemalloc)
		-DWITH_MEM_VALGRIND=$(usex valgrind)
		-DWITH_MOD_FLUID=$(usex elbeem)
		-DWITH_NANOVDB=$(usex nanovdb)
		-DWITH_OPENCOLLADA=$(usex collada)
		-DWITH_OPENCOLORIO=$(usex color-management)
		-DWITH_OPENIMAGEDENOISE=$(usex openimagedenoise)
		-DWITH_OPENIMAGEIO=$(usex openimageio)
		-DWITH_OPENMP=$(usex openmp)
		-DWITH_OPENSUBDIV=$(usex opensubdiv)
		-DWITH_OPENVDB=$(usex openvdb)
		-DWITH_OPENVDB_BLOSC=$(usex openvdb)
		-DWITH_POTRACE=$(usex potrace)
		-DWITH_PUGIXML=$(usex openimageio ON $(usex osl ON OFF))
		-DWITH_PULSEAUDIO=$(usex pulseaudio)
		-DWITH_PYTHON_INSTALL=OFF
		-DWITH_PYTHON_INSTALL_NUMPY=OFF
		-DWITH_USD=$(usex usd)
		-DWITH_TBB=$(usex tbb)
		-DWITH_XR_OPENXR=$(usex openxr)
	)

	blender_configure_linker_flags

	if use usd ; then
		blender_configure_openusd
	fi

	if [[ "${impl}" == "build_creator" ]] ; then
		if use jack || use openal || use pulseaudio ; then
			mycmakeargs+=(
				-DWITH_AUDASPACE=ON
			)
		fi

		mycmakeargs+=(
			-DWITH_CODEC_FFMPEG=$(usex ffmpeg)
			-DWITH_CODEC_SNDFILE=$(usex sndfile)
			-DWITH_FFTW3=$(usex fftw)
			-DWITH_GTESTS=$(usex test)
			-DWITH_INPUT_NDOF=$(usex ndof)
			-DWITH_JACK=$(usex jack)
			-DWITH_MOD_OCEANSIM=$(usex fftw)
			-DWITH_OPENAL=$(usex openal)
			-DWITH_SDL=$(usex sdl)
		)
	fi

# For details see,
# https://github.com/blender/blender/tree/v3.3.8/build_files/cmake/config
	if [[ "${impl}" == "build_creator" \
		|| "${impl}" == "build_headless" ]] ; then
		mycmakeargs+=(
			-DWITH_CYCLES=$(usex cycles)
			-DWITH_CYCLES_CUBIN_COMPILER=$(usex nvrtc)
			-DWITH_CYCLES_CUDA_BINARIES=$(usex cuda)
			-DWITH_CYCLES_DEVICE_CUDA=$(usex cuda TRUE FALSE)
			-DWITH_CYCLES_DEVICE_ONEAPI=$(usex cycles-device-oneapi)
			-DWITH_CYCLES_DEVICE_OPENCL=$(usex opencl)
			-DWITH_CYCLES_DEVICE_OPTIX=$(usex optix)
			-DWITH_CYCLES_EMBREE=$(usex embree)
			-DWITH_CYCLES_KERNEL_ASAN=$(usex asan)
			-DWITH_CYCLES_NATIVE_ONLY=$(usex cpudetection)
			-DWITH_CYCLES_OSL=$(usex osl)
			-DWITH_STATIC_LIBS=OFF
			-DWITH_SYSTEM_EIGEN3=ON
			-DWITH_SYSTEM_GLEW=ON
			-DWITH_SYSTEM_LZO=ON
		)
	fi

	mycmakeargs+=(
		-DWITH_INSTALL_PORTABLE=OFF
	)

	if [[ "${impl}" == "build_headless" ]] ; then
		# For render farms
		mycmakeargs+=(
			-DWITH_AUDASPACE=OFF
			-DWITH_CODEC_FFMPEG=OFF
			-DWITH_CODEC_SNDFILE=OFF
			-DWITH_FFTW3=OFF
			-DWITH_HEADLESS=ON
			-DWITH_INPUT_NDOF=OFF
			-DWITH_JACK=OFF
			-DWITH_MOD_OCEANSIM=OFF
			-DWITH_OPENAL=OFF
			-DWITH_SDL=OFF
			-DWITH_SYSTEM_GLEW=ON
			-DWITH_X11_XINPUT=OFF
			-DWITH_X11=OFF
		)
	fi

	if [[ -n "${BLENDER_DISABLE_CUDA_AUTODETECT}" \
		&& "${BLENDER_DISABLE_CUDA_AUTODETECT}" == "1" ]] ; then
		:;
	else
		if use cuda ; then
			blender_configure_nvcc
			blender_configure_nvrtc
			blender_configure_optix
		fi
	fi

	if (( ${#BLENDER_CMAKE_ARGS[@]} > 0 )) ; then
		# Set as per-package environmental variable
		# For setting up optix/cuda
		mycmakeargs+=( ${BLENDER_CMAKE_ARGS[@]} )
	fi

	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
