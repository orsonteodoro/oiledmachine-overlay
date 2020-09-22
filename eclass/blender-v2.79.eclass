# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: blender-v2.79.eclass
# @MAINTAINER: orsonteodoro@hotmail.com
# @BLURB: blender implementation
# @DESCRIPTION:
# The blender eclass helps reduce code duplication across ebuilds
# using the same major.minor version.

# Based on blender-2.79b-r2 from the gentoo overlay.

inherit blender-vx.xx-common

LICENSE="|| ( GPL-2 BL )
all-rights-reserved
LGPL-2.1+
MPL-2.0
NTP
s_cbrt.c
build_creator? (
	Apache-2.0
	AFL-3.0
	BitstreamVera
	CC-BY-SA-3.0
	color-management? ( BSD )
	jemalloc? ( BSD-2 )
	GPL-2
	GPL-3
	GPL-3-with-font-exception
	LGPL-2.1+
	PSF-2
	ZLIB
)
build_headless? (
	Apache-2.0
	AFL-3.0
	BitstreamVera
	CC-BY-SA-3.0
	color-management? ( BSD )
	jemalloc? ( BSD-2 )
	GPL-2
	GPL-3
	GPL-3-with-font-exception
	LGPL-2.1+
	PSF-2
	ZLIB
)
build_portable? (
	Boost-1.0
	BSD-2
	jemalloc? ( BSD-2 )
)
cycles? (
	Apache-2.0
	Boost-1.0
	BSD
	MIT
)
game-engine? (
	GPL-2+
	ZLIB
)
"

# intern/mikktspace contains ZLIB
# intern/CMakeLists.txt contains GPL+ with all-rights-reserved ; there is no
#   all rights reserved in the vanilla GPL-2
# extern/carve/include/carve/win32.h all-rights-reserved
# extern/carve/ || (GPL-2 GPL-3) ; could be reason why GPL-3 is bundled
# source/gameengine/Expressions/intern/Value.cpp NTP
# extern/carve/include/carve/cbrt.h s_cbrt.c
# release/scripts/addons/render_povray/templates_pov/chess2.pov AFL-3.0
# release/scripts/addons/render_povray/templates_pov/abyss.pov CC-BY-SA-3.0

CXXABI_V=11
HAS_PLAYER=1
LLVM_V=9
LLVM_MAX_SLOT=${LLVM_V}
PYTHON_COMPAT=( python3_6 )

inherit eapi7-ver
inherit blender check-reqs cmake-utils flag-o-matic llvm pax-utils \
	python-single-r1 toolchain-funcs xdg

# If you use git tarballs, you need to download the submodules listed in
# .gitmodules.  The download.blender.org tarball is preferred because they
# bundle all the dependencies.
SRC_URI="https://download.blender.org/source/${P}.tar.gz"

BLENDER_MAIN_SYMLINK_MODE=${BLENDER_MAIN_SYMLINK_MODE:=latest} # can be latest, latest-lts, custom-x.yy

# Slotting is for scripting and plugin compatibility
SLOT="${PV}"
SLOT_MAJ=${SLOT%/*}
# Platform defaults based on CMakeList.txt
#1234567890123456789012345678901234567890123456789012345678901234567890123456789
X86_CPU_FLAGS=( mmx:mmx sse:sse sse2:sse2 sse3:sse3 ssse3:ssse3 sse4_1:sse4_1 \
sse4_2:sse4_2 avx:avx avx2:avx2 avx512f:avx512f avx512dq:avx512dq \
avx512er:avx512er fma:fma lzcnt:lzcnt bmi:bmi f16c:f16c )
CPU_FLAGS=( ${X86_CPU_FLAGS[@]/#/cpu_flags_x86_} )
IUSE+=" ${CPU_FLAGS[@]%:*}"
IUSE="${IUSE/cpu_flags_x86_mmx/+cpu_flags_x86_mmx}"
IUSE="${IUSE/cpu_flags_x86_sse /+cpu_flags_x86_sse }"
IUSE="${IUSE/cpu_flags_x86_sse2/+cpu_flags_x86_sse2}"
IUSE+=" X abi3-compat +abi4-compat abi5-compat abi6-compat abi7-compat +bullet \
+dds +elbeem +game-engine -openexr -collada -color-management -cpudetection \
+cuda +cycles -cycles-network -debug doc flac -ffmpeg -fftw +jack +jemalloc \
+jpeg2k -llvm -man +ndof +nls +nvcc +openal +opencl +openimageio +openmp \
-opensubdiv -openvdb -osl release -sdl -sndfile -test +tiff -valgrind X"
FFMPEG_IUSE+=" jpeg2k +mp3 +theora vorbis x264 xvid"
IUSE+=" ${FFMPEG_IUSE}"
RESTRICT="mirror !test? ( test )"

# The release USE flag depends on platform defaults.
# Disabled dead code optimization flags introduced by
#   cd5e1ff74e4f6443f3e4b836dd23fe46b56cb7ed
# At the source code level, they mix the sse2 intrinsics functions up with the
#   __KERNEL_SSE__.
# See https://gitlab.com/libeigen/eigen/-/blob/3.3.7/Eigen/Core
REQUIRED_USE_EIGEN="
	cpu_flags_x86_avx? (
		cpu_flags_x86_sse3
		cpu_flags_x86_ssse3
		cpu_flags_x86_sse4_1
		cpu_flags_x86_sse4_2
	)
	cpu_flags_x86_avx512er? ( cpu_flags_x86_avx512f )
	cpu_flags_x86_avx512dq? ( cpu_flags_x86_avx512f )
	cpu_flags_x86_avx512f? (
		cpu_flags_x86_fma
		cpu_flags_x86_avx
		cpu_flags_x86_avx2
	)"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}
	${REQUIRED_USE_EIGEN}
	!cpu_flags_x86_mmx? ( !cpu_flags_x86_sse !cpu_flags_x86_sse2 )
	build_creator? ( X )
	build_portable? ( X game-engine )
	cpu_flags_x86_sse2? ( !cpu_flags_x86_sse? ( cpu_flags_x86_mmx ) )
	cuda? ( cycles nvcc )
	cycles? (
		openexr tiff openimageio osl? ( llvm )
		amd64? ( cpu_flags_x86_sse2 )
		x86? ( cpu_flags_x86_sse2 )
		cpu_flags_x86_sse? ( cpu_flags_x86_sse2 )
		cpu_flags_x86_sse2? ( cpu_flags_x86_sse )
		cpudetection? (
			cpu_flags_x86_avx? ( cpu_flags_x86_sse )
			cpu_flags_x86_avx2? ( cpu_flags_x86_sse )
		)
		!cpudetection? (
			amd64? (
				cpu_flags_x86_sse4_1? ( cpu_flags_x86_sse3 )
				cpu_flags_x86_avx? ( cpu_flags_x86_sse4_1 )
				cpu_flags_x86_avx2? ( cpu_flags_x86_avx
							cpu_flags_x86_sse4_1
							cpu_flags_x86_fma
							cpu_flags_x86_lzcnt
							cpu_flags_x86_bmi
							cpu_flags_x86_f16c )
			)
			cpu_flags_x86_sse3? ( cpu_flags_x86_sse2
						cpu_flags_x86_ssse3 )
			cpu_flags_x86_ssse3? ( cpu_flags_x86_sse3 )
		)
	)
	mp3? ( ffmpeg )
	nvcc? ( cuda )
	opencl? ( cycles )
	openvdb? ( ^^ ( abi3-compat abi4-compat abi5-compat abi6-compat abi7-compat ) )
	osl? ( cycles llvm )
	release? (
		!abi3-compat
		build_creator
		build_portable
		bullet
		collada
		color-management
		cuda? ( nvcc )
		cycles
		!cycles-network
		dds
		!debug
		elbeem
		ffmpeg
		fftw
		game-engine
		jack
		jemalloc
		jpeg2k
		man
		ndof
		nls
		openal
		openexr
		openimageio
		openmp
		opensubdiv
		openvdb
		osl
		sdl
		sndfile
		!test
		tiff
		!valgrind
	)
	theora? ( ffmpeg )
	vorbis? ( ffmpeg )
	x264? ( ffmpeg )
	xvid? ( ffmpeg )"

#REQUIRED_USE=" !cycles-network" # Fails for CPU and OPENCL

# dependency version requirements see
# 2.79b tagged on Mar 22, 2018

# The below link is from blender2.7b branch with same patch subject.
# https://github.com/blender/blender/blob/cfe43f8d1af2183a115414abd56a899d116be27d/build_files/build_environment/cmake/versions.cmake

# https://github.com/blender/blender/blob/cfe43f8d1af2183a115414abd56a899d116be27d/extern/Eigen3/eigen-update.sh
# Track OPENVDB_LIBRARY_MAJOR_VERSION_NUMBER for changes.
# They use OpenVDB 3.1.0 but disable abi3-compat but copyGridWithNewTree appears in 3.3.0.
# The pugixml version was not declared in versions.cmake but based on 2.80.
# openimageio is subslot triggered to apply oiio compat patch.
RDEPEND="${PYTHON_DEPS}
	>=dev-lang/python-3.6.2
	dev-libs/lzo:2
	$(python_gen_cond_dep '
		>=dev-python/certifi-2017.7.27.1[${PYTHON_MULTI_USEDEP}]
		>=dev-python/chardet-3.0.2[${PYTHON_MULTI_USEDEP}]
		>=dev-python/idna-2.6[${PYTHON_MULTI_USEDEP}]
		>=dev-python/numpy-1.15.0[${PYTHON_MULTI_USEDEP}]
		>=dev-python/requests-2.18.4[${PYTHON_MULTI_USEDEP}]
		>=dev-python/urllib3-1.22[${PYTHON_MULTI_USEDEP}]
	')
	>=media-libs/freetype-2.6.3
	>=media-libs/glew-1.13.0:*
	>=media-libs/libpng-1.6.21:0=
	media-libs/libsamplerate
	>=sys-libs/zlib-1.2.8
	|| (
		virtual/glu
		>=media-libs/glu-3.0.0
	)
	|| (
		virtual/jpeg:0=
		>=media-libs/libjpeg-turbo-1.4.2
	)
	virtual/libintl
	virtual/opengl
	build_portable? (
		blender-libs/boost:${CXXABI_V}=[static-libs]
		media-libs/openjpeg:=[static-libs]
	)
	collada? ( >=media-libs/opencollada-1.6.51:= )
	color-management? ( >=media-libs/opencolorio-1.0.9 )
	cuda? (
		>=x11-drivers/nvidia-drivers-367.48
		>=dev-util/nvidia-cuda-toolkit-8.0:=
	)
	cycles? ( >=dev-libs/pugixml-1.9 )
	ffmpeg? ( >=media-video/ffmpeg-3.2.1:=\
[encode,jpeg2k?,mp3?,theora?,vorbis?,x264,xvid?,zlib] )
	fftw? ( >=sci-libs/fftw-3.3.4:3.0= )
	flac? ( >=media-libs/flac-1.3.1 )
	jack? ( virtual/jack )
	jemalloc? ( >=dev-libs/jemalloc-5.0.1:= )
	jpeg2k? ( >=media-libs/openjpeg-1.5.2:0 )
	llvm? ( >=sys-devel/llvm-6.0.1:=
		 <sys-devel/llvm-10 )
	ndof? (
		app-misc/spacenavd
		>=dev-libs/libspnav-0.2.3
	)
	nls? (
		|| (
			virtual/libiconv
			>=dev-libs/libiconv-1.14
		)
	)
	openal? ( >=media-libs/openal-1.17.2 )
	opencl? ( virtual/opencl )
	openimageio? (
		>=blender-libs/openimageio-1.7.15:=[color-management?,jpeg2k?]
		 <blender-libs/openimageio-2
	)
	openexr? (
		>=media-libs/ilmbase-2.2.0:=
		>=media-libs/openexr-2.2.0:=
	)
	opensubdiv? ( >=media-libs/opensubdiv-3.1.1:=[cuda=,opencl=] )
	!openvdb? (
		|| (
			>=blender-libs/boost-1.60:${CXXABI_V}=[nls?,threads(+)]
			>=dev-libs/boost-1.60:=[nls?,threads(+)]
		)
	)
	openvdb? (
		!abi3-compat? (
abi4-compat? ( >=blender-libs/openvdb-3.3.0:4[${PYTHON_SINGLE_USEDEP},abi4-compat(+)] )
abi5-compat? ( >=blender-libs/openvdb-3.3.0:5[${PYTHON_SINGLE_USEDEP},abi5-compat(+)]
	        <blender-libs/openvdb-7.1:5[${PYTHON_SINGLE_USEDEP},abi5-compat(+)] )
abi6-compat? ( >=blender-libs/openvdb-3.3.0:6[${PYTHON_SINGLE_USEDEP},abi6-compat(+)]
	        <blender-libs/openvdb-7.1:6[${PYTHON_SINGLE_USEDEP},abi6-compat(+)] )
abi7-compat? ( >=blender-libs/openvdb-3.3.0:7-${CXXABI_V}[${PYTHON_SINGLE_USEDEP},abi7-compat(+)]
	        <blender-libs/openvdb-7.1:7-${CXXABI_V}[${PYTHON_SINGLE_USEDEP},abi7-compat(+)] )
		)
		abi3-compat? (
			>=blender-libs/openvdb-3.1.0:3[${PYTHON_SINGLE_USEDEP},abi3-compat(+)]
			 <blender-libs/openvdb-7.1:3[${PYTHON_SINGLE_USEDEP},abi3-compat(+)]
		)
		>=blender-libs/boost-1.60:${CXXABI_V}=[nls?,threads(+)]
		>=dev-cpp/tbb-2017.7
		>=dev-libs/c-blosc-1.7.1
	)
	osl? ( >=blender-libs/osl-1.7.5:${LLVM_V}=[static-libs]
		blender-libs/mesa:${LLVM_V}= )
	sdl? ( >=media-libs/libsdl2-2.0.4[sound,joystick] )
	sndfile? ( >=media-libs/libsndfile-1.0.28 )
	tiff? ( >=media-libs/tiff-4.0.6:0[zlib] )
	valgrind? ( dev-util/valgrind )
	X? (
		x11-libs/libX11
		x11-libs/libXi
		x11-libs/libXxf86vm
	)"

DEPEND="${RDEPEND}
	>=dev-cpp/eigen-3.2.7:3
	>=dev-util/cmake-3.5
	cycles? (
		x86? ( || (
			sys-devel/clang
			dev-lang/icc
		) )
	)
	doc? (
		app-doc/doxygen[dot]
		dev-python/sphinx[latex]
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
	nls? ( sys-devel/gettext )
	virtual/pkgconfig"

_PATCHES=(
	"${FILESDIR}/${PN}-2.79b-fix-install-rules.patch"
	"${FILESDIR}/${PN}-2.79b-gcc-8.patch"
	"${FILESDIR}/${PN}-2.79b-ffmpeg-4-compat.patch"
	"${FILESDIR}/${PN}-2.79b-fix-for-gcc9-new-openmp-data-sharing.patch"
	"${FILESDIR}/${PN}-2.79b-fix-opencollada.patch"
	"${FILESDIR}/${PN}-2.79b-install-paths-change.patch"
	"${FILESDIR}/${PN}-2.79b-bundled-lib-search-path.patch"
	"${FILESDIR}/${PN}-2.79b-portable-dest.patch"
)

blender_pkg_setup() {
	blender_pkg_setup_common
	export OPENVDB_V=\
$(usex openvdb $(usex abi7-compat 7 $(usex abi6-compat 6 $(usex abi5-compat 5 $(usex abi4-compat 4 3)))) "")
	export OPENVDB_V_DIR=\
$(usex openvdb $(usex abi7-compat 7-${CXXABI_V} $(usex abi6-compat 6 $(usex abi5-compat 5 $(usex abi4-compat 4 3)))) "")
	if use openvdb ; then
		if ! grep -q -F -e "delta()" \
"$(erdpfx)/openvdb/${OPENVDB_V_DIR}/usr/include/openvdb/util/CpuTimer.h" ; then
			if use abi7-compat ; then
				# compatible as long as the function is present?
				die "OpenVDB delta() is missing try <=7.1.x only"
			fi
		fi
	fi
}

_src_prepare() {
	eapply ${_PATCHES[@]}

	S="${BUILD_DIR}" \
	CMAKE_USE_DIR="${BUILD_DIR}" \
	BUILD_DIR="${WORKDIR}/${P}_${EBLENDER}" \
	cmake-utils_src_prepare

	eapply "${FILESDIR}/blender-2.79b-parent-datafiles-dir-change.patch"

	if [[ "${EBLENDER}" == "build_creator" || "${EBLENDER}" == "build_headless" ]] ; then
		# we don't want static glew, but it's scattered across
		# multiple files that differ from version to version
		# !!!CHECK THIS SED ON EVERY VERSION BUMP!!!
		local file
		while IFS="" read -d $'\0' -r file ; do
			if grep -q -F -e "-DGLEW_STATIC" "${file}" ; then
				einfo "Removing -DGLEW_STATIC from ${file}"
				sed -i -e '/-DGLEW_STATIC/d' "${file}"
			fi
		done < <(find . -type f -name "CMakeLists.txt" -print0)

		sed -i -e "s|bf_intern_glew_mx|bf_intern_glew_mx \${GLEW_LIBRARY}|g" \
			intern/cycles/app/CMakeLists.txt || die
	fi

	if [[ "${EBLENDER}" == "build_portable" ]] ; then
		sed -i -e "s|bf_intern_glew_mx|bf_intern_glew_mx ${BUILD_DIR}/lib/|g" \
			intern/cycles/app/CMakeLists.txt || die
	fi

	# Disable MS Windows help generation. The variable doesn't do what it
	# it sounds like.
	sed -e "s|GENERATE_HTMLHELP      = YES|GENERATE_HTMLHELP      = NO|" \
	    -i doc/doxygen/Doxyfile || die

	if [[ "${EBLENDER}" == "build_portable" ]] ; then
		sed -i -e "/add_subdirectory(tests)/d" CMakeLists.txt || die
	fi
}

blender_src_prepare() {
	ewarn
	ewarn "This version is not a Long Term Support (LTS) version."
	ewarn "Use 2.83.x series instead."
	ewarn
	xdg_src_prepare
	blender_prepare() {
		cd "${BUILD_DIR}" || die
		_src_prepare
	}
	blender_copy_sources
	blender_foreach_impl blender_prepare
}

_src_configure() {
	if [[ "${EBLENDER}" == "build_portable" ]] ; then
		strip-flags
		filter-flags -march=* -mtune=*

		BLENDER_CXXFLAGS_ARCH="BLENDER_CXXFLAGS_${ARCH}"
		if [[ -n "${!BLENDER_CXXFLAGS_ARCH}" ]] ; then
			append-cxxflags ${!BLENDER_CXXFLAGS_ARCH}
		elif [[ "${ABI}" == "amd64" && -z "${BLENDER_CXXFLAGS_X86_64}" ]] ; then
			export CXXFLAGS=$(test-flags-CXX -march=x86-64 -mtune=generic)" ${CXXFLAGS}"
		elif [[ "${ABI}" == "x86" && -z "${BLENDER_CXXFLAGS_X86}" ]] ; then
			export CXXFLAGS=$(test-flags-CXX -march=i686 -mtune=generic)" ${CXXFLAGS}"
		else
			ewarn "Unknown ARCH.  Not setting -march"
		fi
	fi

	# FIX: forcing '-funsigned-char' fixes an anti-aliasing issue with menu
	# shadows, see bug #276338 for reference
	append-flags -funsigned-char
	append-lfs-flags
	append-cppflags -DOPENVDB_ABI_VERSION_NUMBER=${OPENVDB_V}

	local mycmakeargs=()
	mycmakeargs+=( -DCMAKE_INSTALL_BINDIR:PATH=$(get_dest) )
	if [[ "${EBLENDER}" == "build_portable" ]] ; then
		mycmakeargs+=( -DPORTABLE_DEST:PATH=$(get_dest) )
	fi

	if use cycles-network ; then
		ewarn \
"Cycles Networking support does not work at all even for CPU rendering.  For \
ebuild/upstream developers only."
	fi

	unset _LD_LIBRARY_PATH
	unset CMAKE_INCLUDE_PATH
	unset CMAKE_LIBRARY_PATH
	unset CMAKE_PREFIX_PATH

	blender_configure_simd_cycles
	blender_configure_eigen
	blender_configure_boost_cxxyy
	blender_configure_openvdb_cxxyy
	blender_configure_osl_match_llvm

	if use osl ; then
		blender_configure_mesa_match_llvm
	fi

	if [[ -n "${_LD_LIBRARY_PATH}" ]] ; then
		sed -i -e "s|\[blender_bin|['env', \"LD_LIBRARY_PATH=${_LD_LIBRARY_PATH}\", blender_bin|" \
			doc/manpage/blender.1.py || die
	fi

	mycmakeargs+=(
		-DPYTHON_VERSION="${EPYTHON/python/}"
		-DPYTHON_LIBRARY="$(python_get_library_path)"
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DSUPPORT_SSE_BUILD=$(usex cpu_flags_x86_sse)
		-DSUPPORT_SSE2_BUILD=$(usex cpu_flags_x86_sse2)
		-DWITH_ASSERT_ABORT=$(usex debug)
		-DWITH_BOOST=ON
		-DWITH_BULLET=$(usex bullet)
		-DWITH_C11=ON
		-DWITH_CPU_SSE=$(usex cpu_flags_x86_sse2)
		-DWITH_CUDA_DYNLOAD=$(usex cuda $(usex nvcc ON OFF) ON)
		-DWITH_CXX11=ON
		-DWITH_CXX_GUARDEDALLOC=$(usex debug)
		-DWITH_CYCLES=$(usex cycles)
		-DWITH_CYCLES_CUDA_BINARIES=$(usex cuda)
		-DWITH_CYCLES_DEVICE_CUDA=$(usex cuda TRUE FALSE)
		-DWITH_CYCLES_DEVICE_OPENCL=$(usex opencl)
		-DWITH_CYCLES_NATIVE_ONLY=$(usex cpudetection)
		-DWITH_CYCLES_OPENSUBDIV=$(usex opensubdiv)
		-DWITH_CYCLES_OSL=$(usex osl)
		-DWITH_DOC_MANPAGE=$(usex man)
		-DWITH_GAMEENGINE=$(usex game-engine)
		-DWITH_IMAGE_DDS=$(usex dds)
		-DWITH_IMAGE_OPENEXR=$(usex openexr)
		-DWITH_IMAGE_OPENJPEG=$(usex jpeg2k)
		-DWITH_IMAGE_TIFF=$(usex tiff)
		-DWITH_INTERNATIONAL=$(usex nls)
		-DWITH_LLVM=$(usex llvm)
		-DWITH_MEM_JEMALLOC=$(usex jemalloc)
		-DWITH_MEM_VALGRIND=$(usex valgrind)
		-DWITH_MOD_FLUID=$(usex elbeem)
		-DWITH_OPENCOLLADA=$(usex collada)
		-DWITH_OPENCOLORIO=$(usex color-management)
		-DWITH_OPENIMAGEIO=$(usex openimageio)
		-DWITH_OPENMP=$(usex openmp)
		-DWITH_OPENSUBDIV=$(usex opensubdiv)
		-DWITH_OPENVDB=$(usex openvdb)
		-DWITH_OPENVDB_BLOSC=$(usex openvdb)
		-DWITH_OPENVDB_3_ABI_COMPATIBLE=$(use abi3-compat)
		-DWITH_PYTHON_INSTALL=OFF
		-DWITH_PYTHON_INSTALL_NUMPY=OFF
	)

	if [[ "${EBLENDER}" == "build_creator" \
		|| "${EBLENDER}" == "build_portable" ]] ; then
		if use game-engine || use jack || use openal ; then
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
# https://github.com/blender/blender/tree/v2.79b/build_files/cmake/config
	if [[ "${EBLENDER}" == "build_creator" \
		|| "${EBLENDER}" == "build_headless" ]] ; then
		mycmakeargs+=(
			-DWITH_CYCLES_NETWORK=$(usex cycles-network)
			-DWITH_INSTALL_PORTABLE=OFF
			-DWITH_STATIC_LIBS=OFF
			-DWITH_SYSTEM_EIGEN3=ON
			-DWITH_SYSTEM_GLEW=ON
			-DWITH_SYSTEM_LZO=ON
			-DWITH_SYSTEM_OPENJPEG=ON
		)
	fi

	if [[ "${EBLENDER}" == "build_headless" ]] ; then
		# for render farms
		mycmakeargs+=(
			-DWITH_AUDASPACE=OFF
			-DWITH_CODEC_FFMPEG=OFF
			-DWITH_CODEC_SNDFILE=OFF
			-DWITH_FFTW3=OFF
			-DWITH_HEADLESS=ON
			-DWITH_GAMEENGINE=OFF
			-DWITH_INPUT_NDOF=OFF
			-DWITH_JACK=OFF
			-DWITH_MOD_OCEANSIM=OFF
			-DWITH_OPENAL=OFF
			-DWITH_SDL=OFF
			-DWITH_SYSTEM_GLEW=ON
			-DWITH_X11_XINPUT=OFF
			-DWITH_X11=OFF
		)
	elif [[ "${EBLENDER}" == "build_portable" ]] ; then
		# for redistributable games, implies building player
		mycmakeargs+=(
			-DLLVM_STATIC=$(usex llvm)
			-DWITH_BLENDER=OFF
			-DWITH_GTESTS=OFF
			-DWITH_INSTALL_PORTABLE=ON
			-DWITH_OPENGL_TESTS=OFF
			-DWITH_OPENMP_STATIC=$(usex openmp)
			-DWITH_PLAYER=ON
			-DWITH_STATIC_LIBS=ON
			-DWITH_SYSTEM_GLEW=OFF
		)
		if has_version 'blender-libs/boost:'${CXXABI_V}'[icu]' ; then
			mycmakeargs+=(
				-DWITH_BOOST_ICU=$(usex nls)
			)
		fi
	fi

	if [[ -n "${BLENDER_DISABLE_CUDA_AUTODETECT}" \
		&& "${BLENDER_DISABLE_CUDA_AUTODETECT}" == "1" ]] ; then
		:;
	else
		if use cuda ; then
			blender_configure_nvcc
		fi
	fi

	if (( ${#BLENDER_CMAKE_ARGS[@]} > 0 )) ; then
		# Set as per-package environmental variable
		# For setting up cuda
		mycmakeargs+=( ${BLENDER_CMAKE_ARGS[@]} )
	fi
	S="${BUILD_DIR}" \
	CMAKE_USE_DIR="${BUILD_DIR}" \
	BUILD_DIR="${WORKDIR}/${P}_${EBLENDER}" \
	cmake-utils_src_configure
}

blender_src_configure() {
	blender_configure() {
		cd "${BUILD_DIR}" || die
		_src_configure
	}
	blender_foreach_impl blender_configure
}

blender_set_wrapper_deps() {
	if use openvdb ; then
		_LD_LIBRARY_PATH+=( "$(dpfx)/openvdb/${OPENVDB_V_DIR}/usr/$(get_libdir)\n" )
	fi
	if use osl ; then
		_LD_LIBRARY_PATH+=( "$(dpfx)/mesa/${LLVM_V}/usr/$(get_libdir)\n" )
		_LD_LIBRARY_PATH+=( "$(dpfx)/osl/${LLVM_V}/usr/$(get_libdir)\n" )
		_PATH+=( "$(dpfx)/osl/${LLVM_V}/usr/$(get_libdir)/osl/bin\n" )
	fi
	if [[ -d "$(erdpfx)/boost/${CXXABI_V}/usr/$(get_libdir)" ]] ; then
		_LD_LIBRARY_PATH+=( "$(dpfx)/boost/${CXXABI_V}/usr/$(get_libdir)\n" )
	fi
}
