# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DESCRIPTION="3D Creation/Animation/Publishing System"
HOMEPAGE="https://www.blender.org"
KEYWORDS="amd64 ~x86"
LICENSE="|| ( GPL-2 BL )
all-rights-reserved
LGPL-2.1+
MPL-2.0
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
cycles? (
	Apache-2.0
	Boost-1.0
	BSD
	MIT
)
"
# intern/mikktspace contains ZLIB
# intern/CMakeLists.txt contains GPL+ with all-rights-reserved ; there is no all rights reserved in the vanilla GPL-2

PYTHON_COMPAT=( python3_{7,8} )

inherit blender check-reqs cmake-utils xdg-utils flag-o-matic xdg-utils \
	pax-utils python-single-r1 toolchain-funcs eapi7-ver


# If you use git tarballs, you need to download the submodules listed in
# .gitmodules.  The download.blender.org are preferred because they bundle them.
SRC_URI="https://download.blender.org/source/blender-${PV}.tar.xz"

# Blender can have letters in the version string,
# so strip off the letter if it exists.
MY_PV="$(ver_cut 1-2)"

BLENDER_MAIN_SYMLINK_MODE=${BLENDER_MAIN_SYMLINK_MODE:=latest}
BLENDER_MULTISLOT=${BLENDER_MULTISLOT:=1}

# Slotting is for scripting and plugin compatibility
if [[ -n "${BLENDER_MULTISLOT}" && "${BLENDER_MULTISLOT}" == "1" ]] ; then
SLOT="${MY_PV}"
else
SLOT="0"
fi
# Platform defaults based on CMakeList.txt
IUSE+=" X -asan +bullet -collada -color-management +cuda +cycles -cycles-network \
+dds -debug doc +elbeem -embree -ffmpeg -fftw -jack +jemalloc \
+jpeg2k -llvm -man +ndof +nls +nvcc -nvrtc +openal +opencl -openexr \
-openimagedenoise -openimageio +openmp -opensubdiv -openvdb -optix -osl \
release -sdl -sndfile test +tiff -valgrind"
RESTRICT="mirror !test? ( test )"

# The release USE flag depends on platform defaults.
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}
	build_creator ( X )
	cuda? ( cycles ^^ ( nvcc nvrtc ) )
	cycles? ( openexr tiff openimageio osl? ( llvm ) )
	embree? ( cycles )
	nvcc? ( || ( cuda optix ) )
	nvrtc? ( || ( cuda optix ) )
	opencl? ( cycles )
	optix? ( cuda cycles nvcc )
	osl? ( cycles llvm )
	release? (
		build_creator
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
		openimagedenoise
		opensubdiv
		openvdb
		osl
		sdl
		sndfile
		!test
		tiff
		!valgrind
	)"

# dependency version requirements see
# build_files/build_environment/cmake/versions.cmake
# doc/python_api/requirements.txt
# extern/Eigen3/eigen-update.sh
RDEPEND="${PYTHON_DEPS}
	>=dev-lang/python-3.7.4
	>=dev-libs/boost-1.68:=[nls?,threads(+)]
	dev-libs/lzo:2
	$(python_gen_cond_dep '
		>=dev-python/certifi-2019.6.16[${PYTHON_MULTI_USEDEP}]
		>=dev-python/chardet-3.0.4[${PYTHON_MULTI_USEDEP}]
		>=dev-python/idna-2.8[${PYTHON_MULTI_USEDEP}]
		>=dev-python/numpy-1.17.0[${PYTHON_MULTI_USEDEP}]
		>=dev-python/requests-2.22.0[${PYTHON_MULTI_USEDEP}]
		>=dev-python/urllib3-1.25.3[${PYTHON_MULTI_USEDEP}]
	')
	>=media-libs/freetype-2.9.1
	>=media-libs/glew-1.13.0:*
	>=media-libs/libpng-1.6.35:0=
	media-libs/libsamplerate
	>=sys-libs/zlib-1.2.11
	|| (
		virtual/glu
		>=media-libs/glu-9.0.1
	)
	|| (
		virtual/jpeg:0=
		>=media-libs/libjpeg-turbo-1.5.3
	)
	virtual/libintl
	virtual/opengl
	collada? ( >=media-libs/opencollada-1.6.68:= )
	color-management? ( >=media-libs/opencolorio-1.1.0 )
	cuda? (
		>=x11-drivers/nvidia-drivers-418.39
		>=dev-util/nvidia-cuda-toolkit-10.1:=
	)
	embree? ( >=media-libs/embree-3.2.4 )
	ffmpeg? ( >=media-video/ffmpeg-4.0.2:=[x264,mp3,encode,theora,jpeg2k?] )
	fftw? ( >=sci-libs/fftw-3.3.8:3.0= )
	jack? ( virtual/jack )
	jemalloc? ( >=dev-libs/jemalloc-5.0.1:= )
	jpeg2k? ( >=media-libs/openjpeg-2.3.0:2 )
	llvm? ( >=sys-devel/llvm-6.0.1:= )
	ndof? (
		app-misc/spacenavd
		>=dev-libs/libspnav-0.2.3
	)
	nls? (
		|| (
			virtual/libiconv
			>=dev-libs/libiconv-1.15
		)
	)
	openal? ( >=media-libs/openal-1.18.2 )
	opencl? ( virtual/opencl )
	openimagedenoise? ( >=media-libs/oidn-1.0.0 )
	openimageio? ( >=media-libs/openimageio-1.8.13 )
	openexr? (
		>=media-libs/ilmbase-2.3.0:=
		>=media-libs/openexr-2.3.0:=
	)
	opensubdiv? ( >=media-libs/opensubdiv-3.4.0_rc2:=[cuda=,opencl=] )
	openvdb? (
		>=media-gfx/openvdb-5.1.0[${PYTHON_SINGLE_USEDEP},-abi3-compat(-),abi4-compat(+)]
		>=dev-cpp/tbb-2018.5
		>=dev-libs/c-blosc-1.14.4
	)
	optix? ( >=dev-libs/optix-7 )
	osl? ( >=media-libs/osl-1.9.9:= )
	sdl? ( >=media-libs/libsdl2-2.0.8[sound,joystick] )
	sndfile? ( >=media-libs/libsndfile-1.0.28 )
	tiff? ( >=media-libs/tiff-4.0.9:0 )
	valgrind? ( dev-util/valgrind )
	X? (
		x11-libs/libX11
		x11-libs/libXi
		x11-libs/libXxf86vm
	)"

DEPEND="${RDEPEND}
	>=dev-cpp/eigen-3.3.7:3
	virtual/pkgconfig
	doc? (
		app-doc/doxygen[dot]
		>=dev-python/sphinx-1.8.5[latex]
		>=dev-python/sphinx_rtd_theme-0.4.3
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}/${PN}-2.82a-fix-install-rules.patch"
	"${FILESDIR}/${PN}-2.82a-cycles-network-fixes.patch"
	"${FILESDIR}/${PN}-2.80-install-paths-change.patch"
)

get_dest() {
	echo "/usr/bin/.${PN}/${SLOT}/${EBLENDER_NAME}"
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
	blender_check_requirements
	python-single-r1_pkg_setup
	# Needs OpenCL 1.2 (GCN 2)
}

_src_prepare() {
	ewarn
	ewarn "This version is not Long Term Support (LTS) version."
	ewarn "Use 2.83.x series instead."
	ewarn
	S="${BUILD_DIR}" \
	CMAKE_USE_DIR="${BUILD_DIR}" \
	BUILD_DIR="${WORKDIR}/${P}_${EBLENDER}" \
	cmake-utils_src_prepare

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

	# Disable MS Windows help generation. The variable doesn't do what it
	# it sounds like.
	sed -e "s|GENERATE_HTMLHELP      = YES|GENERATE_HTMLHELP      = NO|" \
	    -i doc/doxygen/Doxyfile || die
}

src_prepare() {
	blender_prepare() {
		cd "${BUILD_DIR}" || die
		_src_prepare
	}
	blender_copy_sources
	blender_foreach_impl blender_prepare
}

_src_configure() {
	# FIX: forcing '-funsigned-char' fixes an anti-aliasing issue with menu
	# shadows, see bug #276338 for reference
	append-flags -funsigned-char
	append-lfs-flags
	# Blender is compatible ABI 4 or less, so use ABI 4.
	append-cppflags -DOPENVDB_ABI_VERSION_NUMBER=4

	local mycmakeargs=()
	mycmakeargs+=( -DCMAKE_INSTALL_BINDIR:PATH=$(get_dest) )

	if use cycles-network ; then
		ewarn "Cycles Networking support does not work at all even for CPU rendering.  For ebuild/upstream developers only."
	fi

	mycmakeargs+=(
		-DPYTHON_VERSION="${EPYTHON/python/}"
		-DPYTHON_LIBRARY="$(python_get_library_path)"
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DWITH_ASSERT_ABORT=$(usex debug)
		-DWITH_BOOST=ON
		-DWITH_BULLET=$(usex bullet)
		-DWITH_COMPILER_ASAN=$(usex asan)
		-DWITH_CUDA_DYNLOAD=$(usex cuda $(usex nvcc ON OFF) ON)
		-DWITH_CXX_GUARDEDALLOC=$(usex debug)
		-DWITH_CXX11_ABI=ON
		-DWITH_CYCLES=$(usex cycles)
		-DWITH_CYCLES_CUBIN_COMPILER=$(usex nvrtc)
		-DWITH_CYCLES_CUDA_BINARIES=$(use cuda)
		-DWITH_CYCLES_DEVICE_CUDA=$(usex cuda TRUE FALSE)
		-DWITH_CYCLES_DEVICE_OPENCL=$(usex opencl)
		-DWITH_CYCLES_DEVICE_OPTIX=$(usex optix)
		-DWITH_CYCLES_EMBREE=$(usex embree)
		-DWITH_CYCLES_KERNEL_ASAN=$(usex asan)
		-DWITH_CYCLES_OSL=$(usex osl)
		-DWITH_DOC_MANPAGE=$(usex man)
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
		-DWITH_OPENIMAGEDENOISE=$(usex openimagedenoise)
		-DWITH_OPENIMAGEIO=$(usex openimageio)
		-DWITH_OPENMP=$(usex openmp)
		-DWITH_OPENSUBDIV=$(usex opensubdiv)
		-DWITH_OPENVDB=$(usex openvdb)
		-DWITH_OPENVDB_BLOSC=$(usex openvdb)
		-DWITH_PYTHON_INSTALL=OFF
		-DWITH_PYTHON_INSTALL_NUMPY=OFF
	)

	if [[ "${EBLENDER}" == "build_creator" ]] ; then
		if use jack || use openal ; then
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

	# For details see, https://github.com/blender/blender/tree/v2.81a/build_files/cmake/config
	if [[ "${EBLENDER}" == "build_creator" || "${EBLENDER}" == "build_headless" ]] ; then
		mycmakeargs+=(
			-DWITH_CYCLES_NETWORK=$(usex cycles-network)
			-DWITH_INSTALL_PORTABLE=OFF
			-DWITH_STATIC_LIBS=OFF
			-DWITH_SYSTEM_EIGEN3=ON
			-DWITH_SYSTEM_GLEW=ON
			-DWITH_SYSTEM_LZO=ON
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

if [[ -n "${BLENDER_DISABLE_CUDA_AUTODETECT}" && "${BLENDER_DISABLE_CUDA_AUTODETECT}" == "1" ]] ; then
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
		if use optix ; then
			if [[ -n "${BLENDER_OPTIX_ROOT_DIR}" \
		&& -f "${EROOT}/${BLENDER_OPTIX_ROOT_DIR}/include/optix.h" ]] ; then
				mycmakeargs+=(
			-DOPTIX_ROOT_DIR="${EROOT}/${BLENDER_OPTIX_ROOT_DIR}"
				)
			elif [[ -n "${BLENDER_OPTIX_ROOT_DIR}" \
		&& ! -f "${EROOT}/${BLENDER_OPTIX_ROOT_DIR}/include/optix.h" ]] ; then
				die \
"\n\
Cannot reach \$BLENDER_OPTIX_ROOT_DIR/include/optix.h.  Fix it?\n\
\n"
			elif [[ -n "${OPTIX_ROOT_DIR}" \
		&& -f "${EROOT}/${OPTIX_ROOT_DIR}/include/optix.h" ]] ; then
				:;
			elif [[ -n "${OPTIX_ROOT_DIR}" \
		&& ! -f "${EROOT}/${OPTIX_ROOT_DIR}/include/optix.h" ]] ; then
"\n\
Cannot reach \$OPTIX_ROOT_DIR/include/optix.h.  Fix it?\n\
\n"
			else
				die \
"\n\
You need to define BLENDER_OPTIX_ROOT_DIR to point to the Optix SDK folder.\n\
The build scripts expect BLENDER_OPTIX_ROOT_DIR/include/optix.h.\n\
\n"
			fi
		fi
	fi
fi

	if (( ${#BLENDER_CMAKE_ARGS[@]} > 0 )) ; then
		# Set as per-package environmental variable
		# For setting up optix/cuda
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
		"${BUILD_DIR}"/bin/blender --background --python doc/python_api/sphinx_doc_gen.py -noaudio || die "sphinx failed."

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
			"/usr/bin/cycles_server-${SLOT}" || die
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
			d=$(dirname "${f}" | sed -r -e "s|^${BUILD_DIR}||")
		else
			d=$(echo "${f}" | sed -r -e "s|^${BUILD_DIR}||")
		fi
		docinto "licenses/${d}"
		dodoc -r "${f}"
	done
}

install_readmes() {
	for f in $(find "${BUILD_DIR}" -iname "*readme*") ; \
	do
		if [[ -f "${f}" ]] ; then
			d=$(dirname "${f}" | sed -r -e "s|^${BUILD_DIR}||")
		else
			d=$(echo "${f}" | sed -r -e "s|^${BUILD_DIR}||")
		fi
		docinto "readmes/${d}"
		dodoc -r "${f}"
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
		python_optimize "${ED%/}/usr/share/blender/${MY_PV}/scripts"
	fi

	if [[ "${EBLENDER}" == "build_creator" || "${EBLENDER}" == "build_headless" ]] ; then
		_src_install_cycles_network
	fi

	if [[ "${EBLENDER}" == "build_creator" ]] ; then
		cp "${ED}/usr/share/applications"/blender{,-${SLOT}}.desktop || die
		local menu_file="${ED}/usr/share/applications/blender-${SLOT}.desktop"
		sed -i -e "s|Name=Blender|Name=Blender ${PV}|g" "${menu_file}" || die
		sed -i -e "s|Exec=blender|Exec=${d_dest}/blender|g" "${menu_file}" || die
		sed -i -e "s|Icon=blender|Icon=blender-${SLOT}|g" "${menu_file}" || die
		dosym "../../..${d_dest}/blender" \
			"/usr/bin/${PN}-${SLOT}" || die
	elif [[ "${EBLENDER}" == "build_headless" ]] ; then
		dosym "../../..${d_dest}/blender" \
			"/usr/bin/${PN}-headless-${SLOT}" || die
	fi
	if [[ -n "${BLENDER_MULTISLOT}" && "${BLENDER_MULTISLOT}" == "1" ]] ; then
		dodir "${d_dest}"
		touch "${ED}${d_dest}/.multislot"
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
	if [[ -e "${ED}/usr/share/icons/hicolor/scalable/apps/blender.svg" ]] ; then
		mv "${ED}/usr/share/icons/hicolor/scalable/apps/blender"{,-${SLOT}}".svg" || die
		mv "${ED}/usr/share/icons/hicolor/symbolic/apps/blender-symbolic"{,-${SLOT}}".svg"
	fi
	rm -rf "${ED}/usr/share/applications/blender.desktop" || die
	if [[ -d "/usr/share/doc/blender" ]] ; then
		mv /usr/share/doc/blender{,-${SLOT}} || die
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
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	local d_src="${EROOT}/usr/bin/.${PN}"
	local V=""
	if [[ -n "${BLENDER_MAIN_SYMLINK_MODE}" && "${BLENDER_MAIN_SYMLINK_MODE}" == "latest-lts" ]] ; then
		# highest lts
		V=$(ls "${d_src}"/*/creator/.lts | sort -V | tail -n 1 | cut -f 5 -d "/")
	elif [[ -n "${BLENDER_MAIN_SYMLINK_MODE}" && "${BLENDER_MAIN_SYMLINK_MODE}" == "latest" ]] ; then
		# highest v
		V=$(ls "${EROOT}${d_src}/" | sort -V | tail -n 1)
	elif [[ -n "${BLENDER_MAIN_SYMLINK_MODE}" && "${BLENDER_MAIN_SYMLINK_MODE}" =~ ^custom-[0-9]\.[0-9]+$ ]] ; then
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
		if [[ -e "${EROOT}${d_src}/${V}/creator/cycles_server" ]] && use cycles-network ; then
			ln -sf "${EROOT}${d_src}/${V}/creator/cycles_server" \
				"${EROOT}/usr/bin/cycles_server" || die
		elif [[ -e "${EROOT}${d_src}/${V}/headless/cycles_server" ]] && use cycles-network ; then
			ln -sf "${EROOT}${d_src}/${V}/headless/cycles_server" \
				"${EROOT}/usr/bin/cycles_server" || die
		fi
	fi
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_mimeinfo_database_update

	ewarn ""
	ewarn "You may want to remove the following directory."
	ewarn "~/.config/${PN}/${MY_PV}/cache/"
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
