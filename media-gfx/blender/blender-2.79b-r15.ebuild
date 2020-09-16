# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Based on blender-2.79b-r2 from the gentoo overlay.

EAPI=6
DESCRIPTION="3D Creation/Animation/Publishing System"
HOMEPAGE="https://www.blender.org"
KEYWORDS="amd64 ~x86"
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

PYTHON_COMPAT=( python3_6 )
HAS_PLAYER=1
LLVM_MAX_SLOT=9

inherit eapi7-ver
inherit blender check-reqs cmake-utils flag-o-matic llvm pax-utils \
	python-single-r1 toolchain-funcs xdg

# If you use git tarballs, you need to download the submodules listed in
# .gitmodules.  The download.blender.org are preferred because they bundle them.
SRC_URI="https://download.blender.org/source/${P}.tar.gz"

BLENDER_MAIN_SYMLINK_MODE=${BLENDER_MAIN_SYMLINK_MODE:=latest} # can be latest, latest-lts, custom-x.yy
BLENDER_MULTISLOT=${BLENDER_MULTISLOT:=1}

# Slotting is for scripting and plugin compatibility
if [[ -n "${BLENDER_MULTISLOT}" && "${BLENDER_MULTISLOT}" == "2" ]] ; then
SLOT="${PV}"
elif [[ -n "${BLENDER_MULTISLOT}" && "${BLENDER_MULTISLOT}" == "1" ]] ; then
SLOT="$(ver_cut 1-2)/${PV}"
else
SLOT="0/${PV}"
fi
SLOT_MAJ=${SLOT%/*}
# Platform defaults based on CMakeList.txt
#1234567890123456789012345678901234567890123456789012345678901234567890123456789
IUSE+=" X abi3-compat +abi4-compat abi5-compat abi6-compat abi7-compat +bullet \
+dds +elbeem +game-engine -openexr -collada -color-management +cuda +cycles \
-cycles-network -debug doc flac -ffmpeg -fftw +jack +jemalloc +jpeg2k -llvm \
-man +ndof +nls +nvcc +openal +opencl +openimageio +openmp -opensubdiv \
-openvdb -osl release -sdl -sndfile -test +tiff -valgrind X"
FFMPEG_IUSE+=" jpeg2k +mp3 +theora vorbis x264 xvid"
IUSE+=" ${FFMPEG_IUSE}"
RESTRICT="mirror !test? ( test )"
USE_LIBGLVND="N"
LLVM_V=9

# The release USE flag depends on platform defaults.
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}
	build_creator ( X )
	build_portable ( X game-engine )
	cuda? ( cycles nvcc )
	cycles? ( openexr tiff openimageio osl? ( llvm ) )
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
RDEPEND="${PYTHON_DEPS}
	>=dev-lang/python-3.6.2
	>=dev-libs/boost-1.60:=[nls?,threads(+)]
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
		dev-libs/boost:=[static-libs]
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
	openimageio? ( >=media-libs/openimageio-1.7.15[color-management?,jpeg2k?] )
	openexr? (
		>=media-libs/ilmbase-2.2.0:=
		>=media-libs/openexr-2.2.0:=
	)
	opensubdiv? ( >=media-libs/opensubdiv-3.1.1:=[cuda=,opencl=] )
	openvdb? (
		abi3-compat? (
			>=blender-libs/openvdb-3.1.0[${PYTHON_SINGLE_USEDEP},abi3-compat]
		)
		!abi3-compat? (
			>=blender-libs/openvdb-3.3.0\
[${PYTHON_SINGLE_USEDEP},abi4-compat?,abi5-compat?,abi6-compat?,abi7-compat?]
		)
		>=dev-cpp/tbb-2017.7
		>=dev-libs/c-blosc-1.7.1
	)
	osl? ( >=media-libs/osl-1.7.5:=
		<blender-libs/mesa-19.2 )
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

get_dest() {
	if [[ "${EBLENDER}" == "build_portable" ]] ; then
		echo "/usr/share/${PN}/${SLOT_MAJ}/${EBLENDER_NAME}"
	else
		echo "/usr/bin/.${PN}/${SLOT_MAJ}/${EBLENDER_NAME}"
	fi
}

blender_check_requirements() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp

	if use doc; then
		CHECKREQS_DISK_BUILD="4G" check-reqs_pkg_pretend
	fi
}

pkg_pretend() {
	blender_check_requirements
}

pkg_setup() {
	llvm_pkg_setup
	blender_check_requirements
	python-single-r1_pkg_setup
	if use openvdb ; then
		if ! grep -q -F -e "delta()" /usr/include/openvdb/util/CpuTimer.h ; then
			if use abi7-compat ; then
				# compatible as long as the function is present?
				die "OpenVDB delta() is missing try <=7.1.x only"
			fi
		fi
	fi
}

_src_prepare() {
	S="${BUILD_DIR}" \
	CMAKE_USE_DIR="${BUILD_DIR}" \
	BUILD_DIR="${WORKDIR}/${P}_${EBLENDER}" \
	cmake-utils_src_prepare

	eapply ${_PATCHES[@]}

	if [[ "${BLENDER_MULTISLOT}" == "2" ]] ; then
		eapply "${FILESDIR}/blender-2.79b-parent-datafiles-dir-change.patch"
	fi

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

src_prepare() {
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
	# Blender is compatible ABI 4 or less, so use ABI 4.
	append-cppflags -DOPENVDB_ABI_VERSION_NUMBER=4

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

	if use osl ; then
		if [[ "${USE_LIBGLVND}" == "Y" ]] ; then
			mycmakeargs+=( -DOpenGL_GL_PREFERENCE=GLVND )
			if [[ -e "${EROOT}/usr/$(get_libdir)/libGLX.so" ]] ; then
				mycmakeargs+=( -DOPENGL_gl_LIBRARY="${EROOT}/usr/$(get_libdir)/libGLX.so" )
			else
				die "Install media-libs/libglvnd or indirectly through mesa[libglvnd]."
			fi
			if [[ -e "${EROOT}/usr/$(get_libdir)/libOpenGL.so" ]] ; then
				mycmakeargs+=( -DOPENGL_opengl_LIBRARY="${EROOT}/usr/$(get_libdir)/libOpenGL.so" )
			else
				die "Install media-libs/libglvnd or indirectly through mesa[libglvnd]."
			fi
			if [[ -e "${EROOT}/usr/$(get_libdir)/libEGL.so" ]] ; then
				mycmakeargs+=( -DOPENGL_egl_LIBRARY="${EROOT}/usr/$(get_libdir)/libEGL.so" )
			fi
		else
			mycmakeargs+=( -DOpenGL_GL_PREFERENCE=LEGACY )
			if [[ -e "${EROOT}/usr/$(get_libdir)/blender/mesa/${LLVM_V}/usr/$(get_libdir)/libGL.so" ]] ; then
				# legacy
				mycmakeargs+=( -DOPENGL_gl_LIBRARY="${EROOT}/usr/$(get_libdir)/blender/mesa/${LLVM_V}/usr/$(get_libdir)/libGL.so" )
			else
				die "Use either blender-libs/mesa or media-libs/mesa[libglvnd] or media-libs/libglvnd"
			fi
			if [[ -e "${EROOT}/usr/$(get_libdir)/blender/mesa/${LLVM_V}/usr/$(get_libdir)/libEGL.so" ]] ; then
				mycmakeargs+=( -DOPENGL_egl_LIBRARY="${EROOT}/usr/$(get_libdir)/blender/mesa/${LLVM_V}/usr/$(get_libdir)/libEGL.so" )
			fi
			export CMAKE_LIBRARY_PATH="/usr/$(get_libdir)/blender/mesa/${LLVM_V}/usr/$(get_libdir)/:${CMAKE_LIBRARY_PATH}"
			export CMAKE_INCLUDE_PATH="/usr/$(get_libdir)/blender/mesa/${LLVM_V}/usr/include:${CMAKE_INCLUDE_PATH}"
		fi
	fi

	mycmakeargs+=(
		$(usex openvdb -DOPENVDB_ABI_VERSION_NUMBER=\
$(usex abi7-compat 7 $(usex abi6-compat 6 $(usex abi5-compat 5 $(usex abi4-compat 4 3)))) "")
		-DPYTHON_VERSION="${EPYTHON/python/}"
		-DPYTHON_LIBRARY="$(python_get_library_path)"
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DWITH_ASSERT_ABORT=$(usex debug)
		-DWITH_BOOST=ON
		-DWITH_BULLET=$(usex bullet)
		-DWITH_C11=ON
		-DWITH_CUDA_DYNLOAD=$(usex cuda $(usex nvcc ON OFF) ON)
		-DWITH_CXX11=ON
		-DWITH_CXX_GUARDEDALLOC=$(usex debug)
		-DWITH_CYCLES=$(usex cycles)
		-DWITH_CYCLES_CUDA_BINARIES=$(usex cuda)
		-DWITH_CYCLES_DEVICE_CUDA=$(usex cuda TRUE FALSE)
		-DWITH_CYCLES_DEVICE_OPENCL=$(usex opencl)
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
			-DWITH_X11=ON
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
		if has_version 'dev-libs/boost[icu]' ; then
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
		if use nvcc ; then
			if [[ -x "${EROOT}/opt/cuda/bin/nvcc" ]] ; then
				mycmakeargs+=(
			-DCUDA_NVCC_EXECUTABLE="${EROOT}/opt/cuda/bin/nvcc"
				)
			elif [[ -n "${BLENDER_NVCC_PATH}" \
			&& -x "${EROOT}/${BLENDER_NVCC_PATH}/bin/nvcc" ]] ; then
				mycmakeargs+=(
		-DCUDA_NVCC_EXECUTABLE="${EROOT}/${BLENDER_NVCC_PATH}/nvcc"
				)
			elif [[ -n "${BLENDER_NVCC_PATH}" \
		&& ! -x "${EROOT}/${BLENDER_NVCC_PATH}/bin/nvcc" ]] ; then
				die \
"\n\
nvcc is unreachable from BLENDER_NVCC_PATH.  It should be an absolute path\n\
like /opt/cuda/bin/nvcc.\n\
\n"
			else
				die \
"\n\
You need to define BLENDER_NVCC_PATH as a per-package environmental variable\n\
containing the absolute path to nvcc e.g. /opt/cuda/bin/nvcc.\n\
\n"
			fi
		fi
		if use nvrtc ; then
			if [[ -f "${EROOT}/opt/cuda/lib64/libnvrtc-builtins.so" ]] ; then
				mycmakeargs+=(
				-DCUDA_TOOLKIT_ROOT_DIR="${EROOT}/opt/cuda"
				)
			elif [[ -n "${BLENDER_CUDA_TOOLKIT_ROOT_DIR}" \
&& -f "${EROOT}/${BLENDER_CUDA_TOOLKIT_ROOT_DIR}/lib64/libnvrtc-builtins.so" ]] ; then
				mycmakeargs+=(
	-DCUDA_TOOLKIT_ROOT_DIR="${EROOT}/${BLENDER_CUDA_TOOLKIT_ROOT_DIR}"
				)
			elif [[ -n "${BLENDER_CUDA_TOOLKIT_ROOT_DIR}" \
&& ! -f "${EROOT}/${BLENDER_CUDA_TOOLKIT_ROOT_DIR}/lib64/libnvrtc-builtins.so" ]] ; then
				die \
"Cannot reach \$BLENDER_CUDA_TOOLKIT_ROOT_DIR/lib64/libnvrtc-builtins.so"
			else
				die \
"\n
libnvrtc-builtins.so is unreachable.  Define BLENDER_CUDA_TOOLKIT_ROOT_DIR\n\
as a per-package environmental variable (e.g. /opt/cuda).\n
\n"
			fi
		fi
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

src_configure() {
	blender_configure() {
		cd "${BUILD_DIR}" || die
		_src_configure
	}
	blender_foreach_impl blender_configure
}

_src_compile() {
	S="${BUILD_DIR}" \
	CMAKE_USE_DIR="${BUILD_DIR}" \
	BUILD_DIR="${WORKDIR}/${P}_${EBLENDER}" \
	cmake-utils_src_compile
}

_src_compile_docs() {
	if use doc; then
		# Workaround for binary drivers.
		addpredict /dev/ati
		addpredict /dev/dri
		addpredict /dev/nvidiactl

		einfo "Generating Blender C/C++ API docs ..."
		cd "${CMAKE_USE_DIR}"/doc/doxygen || die
		doxygen -u Doxyfile || die
		doxygen || die "doxygen failed to build API docs."

		cd "${CMAKE_USE_DIR}" || die
		einfo "Generating (BPY) Blender Python API docs ..."
		"${BUILD_DIR}"/bin/blender --background \
			--python doc/python_api/sphinx_doc_gen.py -noaudio \
			|| die "sphinx failed."

		cd "${CMAKE_USE_DIR}"/doc/python_api || die
		sphinx-build sphinx-in BPY_API || die "sphinx failed."
	fi
}

src_compile() {
	blender_compile() {
		cd "${BUILD_DIR}" || die
		_src_compile
		if [[ "${EBLENDER}" == "build_creator" ]] ; then
			_src_compile_docs
		fi
	}
	blender_foreach_impl blender_compile
}

_src_test() {
	if use test; then
		einfo "Running Blender Unit Tests for ${EBLENDER} ..."
		cd "${BUILD_DIR}"/bin/tests || die
		local f
		for f in *_test; do
			./"${f}" || die
		done
	fi
}

src_test() {
	blender_test() {
		cd "${BUILD_DIR}" || die
		_src_test
	}
	blender_foreach_impl blender_test
}

_src_install_cycles_network() {
	if use cycles-network ; then
		exeinto "${d_dest}"
		dosym "../../..${d_dest}/cycles_server" \
			"/usr/bin/cycles_server-${SLOT_MAJ}" || die
		doexe "${CMAKE_BUILD_DIR}${d_dest}/cycles_server"
	fi
}

_src_install_doc() {
	if use doc; then
		docinto "html/API/python"
		dodoc -r "${CMAKE_USE_DIR}"/doc/python_api/BPY_API/.

		docinto "html/API/blender"
		dodoc -r "${CMAKE_USE_DIR}"/doc/doxygen/html/.
	fi

	# fix doc installdir
	docinto "html"
	dodoc "${CMAKE_USE_DIR}"/release/text/readme.html
	rm -r "${ED%/}"/usr/share/doc/blender || die
}

install_licenses() {
	for f in $(find "${BUILD_DIR}" -iname "*license*" -type f \
	  -o -iname "*copyright*" \
	  -o -iname "*copying*" \
	  -o -path "*/license/*" \
	  -o -path "*/macholib/README.ctypes" \
	  -o -path "*/materials_library_vx/README.txt" ) ; \
	do
		if [[ -f "${f}" ]] ; then
			d=$(dirname "${f}" | sed -e "s|^${BUILD_DIR}||")
		else
			d=$(echo "${f}" | sed -e "s|^${BUILD_DIR}||")
		fi
		if [[ "${EBLENDER}" == "build_portable" ]] ; then
			insinto "${d_dest}/licenses/${d}"
			doins -r "${f}"
		elif [[ "${EBLENDER}" == "build_creator" \
		     || "${EBLENDER}" == "build_headless" ]] ; then
			docinto "licenses/${d}"
			dodoc -r "${f}"
		fi
	done
}

install_readmes() {
	for f in $(find "${BUILD_DIR}" -iname "*readme*") ; \
	do
		if [[ -f "${f}" ]] ; then
			d=$(dirname "${f}" | sed -e "s|^${BUILD_DIR}||")
		else
			d=$(echo "${f}" | sed -e "s|^${BUILD_DIR}||")
		fi
		if [[ "${EBLENDER}" == "build_portable" ]] ; then
			insinto "${d_dest}/readmes/${d}"
			doins -r "${f}"
		elif [[ "${EBLENDER}" == "build_creator" \
		     || "${EBLENDER}" == "build_headless" ]] ; then
			docinto "readmes/${d}"
			dodoc -r "${f}"
		fi
	done
}

_src_install() {
	# Pax mark blender for hardened support.
	pax-mark m "${CMAKE_BUILD_DIR}"/bin/blender

	S="${BUILD_DIR}" \
	CMAKE_USE_DIR="${BUILD_DIR}" \
	BUILD_DIR="${WORKDIR}/${P}_${EBLENDER}" \
	cmake-utils_src_install
	if [[ "${EBLENDER}" == "build_creator" ]] ; then
		CMAKE_USE_DIR="${BUILD_DIR}" \
		_src_install_doc
	fi

	local d_dest=$(get_dest)
	if [[ "${EBLENDER}" == "build_creator" ]] ; then
		python_fix_shebang "${ED%/}${d_dest}/blender-thumbnailer.py"
		python_optimize "${ED%/}/usr/share/blender/${SLOT_MAJ}/scripts"
	fi

	if [[ "${EBLENDER}" == "build_creator" \
		|| "${EBLENDER}" == "build_headless" ]] ; then
		_src_install_cycles_network
	fi

	local ed_icon_hc="${ED}/usr/share/icons/hicolor"
	if [[ "${EBLENDER}" == "build_creator" ]] ; then
		cp "${ED}/usr/share/applications"/blender{,-${SLOT_MAJ}}.desktop || die
		local menu_file="${ED}/usr/share/applications/blender-${SLOT_MAJ}.desktop"
		sed -i -e "s|Name=Blender|Name=Blender ${PV}|g" "${menu_file}" || die
		sed -i -e "s|Exec=blender|Exec=/usr/bin/${PN}-${SLOT_MAJ}|g" "${menu_file}" || die
		sed -i -e "s|Icon=blender|Icon=blender-${SLOT_MAJ}|g" "${menu_file}" || die
		for size in 16x16 22x22 24x24 256x256 32x32 48x48 ; do
			mv "${ed_icon_hc}/"${size}"/apps/blender"{,-${SLOT_MAJ}}".png" || die
		done
		mv "${ed_icon_hc}/scalable/apps/blender"{,-${SLOT_MAJ}}".svg" || die
		cp "${FILESDIR}/blender-wrapper" \
			"${T}/${PN}-${SLOT_MAJ}" || die
		sed -i -e "s|\$(get_libdir)|$(get_libdir)|g" \
			-e "s|\${LLVM_V}|${LLVM_V}|g" \
			-e "s|\${BLENDER_EXE}|${d_dest}/blender|g" \
			"${T}/${PN}-${SLOT_MAJ}" || die
		if use osl ; then
			sed -i -e "s|#LD_LIBRARY_PATH|LD_LIBRARY_PATH|g" \
				"${T}/${PN}-${SLOT_MAJ}" || die
		fi
		exeinto /usr/bin
		doexe "${T}/${PN}-${SLOT_MAJ}"
	elif [[ "${EBLENDER}" == "build_headless" ]] ; then
		cp "${FILESDIR}/blender-wrapper" \
			"${T}/${PN}-headless-${SLOT_MAJ}" || die
		sed -i -e "s|\$(get_libdir)|$(get_libdir)|g" \
			-e "s|\${LLVM_V}|${LLVM_V}|g" \
			-e "s|\${BLENDER_EXE}|${d_dest}/blender|g" \
			"${T}/${PN}-headless-${SLOT_MAJ}" || die
		if use osl ; then
			sed -i -e "s|#LD_LIBRARY_PATH|LD_LIBRARY_PATH|g" \
				"${T}/${PN}-headless-${SLOT_MAJ}" || die
		fi
		exeinto /usr/bin
		doexe "${T}/${PN}-${SLOT_MAJ}"
	fi
	if [[ -n "${BLENDER_MULTISLOT}" && "${BLENDER_MULTISLOT}" =~ (1|2) ]] ; then
		dodir "${d_dest}"
		# metainfo
		echo "${BLENDER_MULTISLOT}" > "${ED}${d_dest}/.multislot"
	fi
	install_licenses
	if use doc ; then
		install_readmes
	fi
}

src_install() {
	blender_install() {
		cd "${BUILD_DIR}" || die
		_src_install
	}
	blender_foreach_impl blender_install
	local ed_icon_hc="${ED}/usr/share/icons/hicolor"
	local ed_icon_scale="${ed_icon_hc}/scalable"
	local ed_icon_sym="${ed_icon_hc}/symbolic"
	if [[ -d "${ed_icon_hc}" ]] ; then
		for size in 16x16 22x22 24x24 256x256 32x32 48x48 ; do
			mv "${ed_icon_hc}/"${size}"/apps/blender"{,-${SLOT_MAJ}}".png" || die
		done
	fi
	if [[ -e "${ed_icon_scale}/apps/blender.svg" ]] ; then
		mv "${ed_icon_scale}/apps/blender"{,-${SLOT_MAJ}}".svg" || die
	fi
	rm -rf "${ED}/usr/share/applications/blender.desktop" || die
	if [[ -d "${ED}/usr/share/doc/blender" ]] ; then
		mv "${ED}/usr/share/doc/blender"{,-${SLOT_MAJ}} || die
	fi
}

pkg_postinst() {
	elog
	elog "Blender uses python integration. As such, may have some"
	elog "inherit risks with running unknown python scripts."
	elog
	elog "It is recommended to change your blender temp directory"
	elog "from /tmp to /home/user/tmp or another tmp file under your"
	elog "home directory. This can be done by starting blender, then"
	elog "dragging the main menu down do display all paths."
	elog
	ewarn
	ewarn "This ebuild does not unbundle the massive amount of 3rd party"
	ewarn "libraries which are shipped with blender. Note that"
	ewarn "these have caused security issues in the past."
	ewarn "If you are concerned about security, file a bug upstream:"
	ewarn "  https://developer.blender.org/"
	ewarn
	if use cycles-network ; then
		einfo
		ewarn "The Cycles Networking support is experimental and"
		ewarn "incomplete."
		einfo
		einfo "To make a OpenCL GPU available do:"
		einfo "cycles_server --device OPENCL"
		einfo
		einfo "To make a CUDA GPU available do:"
		einfo "cycles_server --device CUDA"
		einfo
		einfo "To make a CPU available do:"
		einfo "cycles_server --device CPU"
		einfo
		einfo "Only one instance of a cycles_server can be used on a host."
		einfo
		einfo "You may want to run cycles_server on the client too, but"
		einfo "it is not necessary."
		einfo
		einfo "Clients need to set the Rendering Engine to Cycles and"
		einfo "Device to Networked Device.  Finding the server is done"
		einfo "automatically."
		einfo
	fi
	xdg_pkg_postinst
	local d_src="${EROOT}/usr/bin/.${PN}"
	local V=""
	if [[ -n "${BLENDER_MAIN_SYMLINK_MODE}" \
	&& "${BLENDER_MAIN_SYMLINK_MODE}" == "latest-lts" ]] ; then
		# highest lts
		V=$(ls "${d_src}"/*/creator/.lts | sort -V | tail -n 1 \
			| cut -f 5 -d "/")
	elif [[ -n "${BLENDER_MAIN_SYMLINK_MODE}" \
	&& "${BLENDER_MAIN_SYMLINK_MODE}" == "latest" ]] ; then
		# highest v
		V=$(ls "${EROOT}${d_src}/" | sort -V | tail -n 1)
	elif [[ -n "${BLENDER_MAIN_SYMLINK_MODE}" \
	&& "${BLENDER_MAIN_SYMLINK_MODE}" =~ ^custom-[0-9]\.[0-9]+$ ]] ; then
		# custom v
		V=$(echo "${BLENDER_MAIN_SYMLINK_MODE}" | cut -f 2 -d "-")
	fi
	if [[ -n "${V}" ]] ; then
		if use build_creator ; then
			ln -sf "${EROOT}${d_src}/${V}/creator/blender" \
				"${EROOT}/usr/bin/blender" || die
		fi
		if use build_headless ; then
			ln -sf "${EROOT}${d_src}/${V}/headless/blender" \
				"${EROOT}/usr/bin/blender-headless" || die
		fi
		if [[ -e "${EROOT}${d_src}/${V}/creator/cycles_server" ]] \
			&& use cycles-network ; then
			ln -sf "${EROOT}${d_src}/${V}/creator/cycles_server" \
				"${EROOT}/usr/bin/cycles_server" || die
		elif [[ -e "${EROOT}${d_src}/${V}/headless/cycles_server" ]] \
			&& use cycles-network ; then
			ln -sf "${EROOT}${d_src}/${V}/headless/cycles_server" \
				"${EROOT}/usr/bin/cycles_server" || die
		fi
	fi
}

pkg_postrm() {
	xdg_pkg_postrm

	ewarn ""
	ewarn "You may want to remove the following directory."
	ewarn "~/.config/${PN}/${SLOT_MAJ}/cache/"
	ewarn "It may contain extra render kernels not tracked by portage"
	ewarn ""
	if [[ -n "${BLENDER_MULTISLOT}" && "${BLENDER_MULTISLOT}" == "1" ]] ; then
		if [[ ! -d "${EROOT}/usr/bin/.blender" ]] ; then
			if [[ -e "${EROOT}/usr/bin/blender" ]] ; then
				rm -rf "${EROOT}/usr/bin/blender" || die
			fi
			if [[ -e "${EROOT}/usr/bin/blender-headless" ]] ; then
				rm -rf "${EROOT}/usr/bin/blender-headless" || die
			fi
			if [[ -e "${EROOT}/usr/bin/cycles_server" ]] ; then
				rm -rf "${EROOT}/usr/bin/cycles_server" || die
			fi
		fi
	fi
}
