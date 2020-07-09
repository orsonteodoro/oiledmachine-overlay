# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{7,8} )

inherit check-reqs cmake-utils xdg-utils flag-o-matic xdg-utils \
	pax-utils python-single-r1 toolchain-funcs eapi7-ver

DESCRIPTION="3D Creation/Animation/Publishing System"
HOMEPAGE="https://www.blender.org"

# If you use git tarballs, you need to download the submodules listed in
# .gitmodules.  The download.blender.org are preferred because they bundle them.
SRC_URI="https://download.blender.org/source/blender-${PV}.tar.xz"

# Blender can have letters in the version string,
# so strip off the letter if it exists.
MY_PV="$(ver_cut 1-2)"

# Slotting is for scripting and plugin compatibility
if [[ -n "${BLENDER_MULTISLOT}" && "${BLENDER_MULTISLOT}" == "1" ]] ; then
SLOT="${MY_PV}"
else
SLOT="0"
fi
LICENSE="|| ( GPL-2 BL )"
KEYWORDS="amd64 ~x86"
# Platform defaults based on CMakeList.txt
IUSE="-asan +bullet -collada -color-management +cuda +cycles -cycles-network +dds \
-debug doc +elbeem -embree -ffmpeg -fftw -headless -jack +jemalloc +jpeg2k \
-llvm -man +ndof +nls +nvcc -nvrtc +openal +opencl -openexr -openimagedenoise \
-openimageio +openmp -opensubdiv -openvdb -optix -osl -sdl -sndfile test \
+tiff -valgrind"
RESTRICT="mirror !test? ( test )"

# For build configurations, see
# https://github.com/blender/blender/blob/v2.81/build_files/cmake/config/
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	cuda? ( cycles ^^ ( nvcc nvrtc ) )
	cycles? ( openexr tiff openimageio )
	embree? ( cycles )
	nvcc? ( || ( cuda optix ) )
	nvrtc? ( || ( cuda optix ) )
	opencl? ( cycles )
	optix? ( cycles ^^ ( nvcc nvrtc ) )
	osl? ( cycles llvm )"

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
	embree? ( >=media-libs/embree-3.2.4 )
	ffmpeg? ( >=media-video/ffmpeg-4.0.2:=[x264,mp3,encode,theora,jpeg2k?] )
	fftw? ( >=sci-libs/fftw-3.3.8:3.0= )
	!headless? (
		x11-libs/libX11
		x11-libs/libXi
		x11-libs/libXxf86vm
	)
	jack? ( virtual/jack )
	jemalloc? ( >=dev-libs/jemalloc-5.0.1:= )
	jpeg2k? ( >=media-libs/openjpeg-2.3.0:0 )
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
	nvcc? (
		>=x11-drivers/nvidia-drivers-418.39
		>=dev-util/nvidia-cuda-toolkit-10.1:=
	)
	nvrtc? (
		>=x11-drivers/nvidia-drivers-418.39
		>=dev-util/nvidia-cuda-toolkit-10.1:=
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
	valgrind? ( dev-util/valgrind )"

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

src_prepare() {
	ewarn
	ewarn "This version is not Long Term Support (LTS) version."
	ewarn "Use 2.83.x series instead."
	ewarn
	cmake-utils_src_prepare

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

	# Disable MS Windows help generation. The variable doesn't do what it
	# it sounds like.
	sed -e "s|GENERATE_HTMLHELP      = YES|GENERATE_HTMLHELP      = NO|" \
	    -i doc/doxygen/Doxyfile || die
}

src_configure() {
	# FIX: forcing '-funsigned-char' fixes an anti-aliasing issue with menu
	# shadows, see bug #276338 for reference
	append-flags -funsigned-char
	append-lfs-flags
	# Blender is compatible ABI 4 or less, so use ABI 4.
	append-cppflags -DOPENVDB_ABI_VERSION_NUMBER=4

	local mycmakeargs=()
	if [[ -n "${BLENDER_MULTISLOT}" && "${BLENDER_MULTISLOT}" == "1" ]] ; then
		mycmakeargs+=( -DCMAKE_INSTALL_BINDIR:PATH=/usr/bin/${PN}/${SLOT} )
	fi

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
		-DWITH_CODEC_FFMPEG=$(usex ffmpeg)
		-DWITH_CODEC_SNDFILE=$(usex sndfile)
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
		-DWITH_CYCLES_NETWORK=$(usex cycles-network)
		-DWITH_CYCLES_OSL=$(usex osl)
		-DWITH_DOC_MANPAGE=$(usex man)
		-DWITH_FFTW3=$(usex fftw)
		-DWITH_GTESTS=$(usex test)
		-DWITH_HEADLESS=$(usex headless)
		-DWITH_IMAGE_DDS=$(usex dds)
		-DWITH_IMAGE_OPENEXR=$(usex openexr)
		-DWITH_IMAGE_OPENJPEG=$(usex jpeg2k)
		-DWITH_IMAGE_TIFF=$(usex tiff)
		-DWITH_INPUT_NDOF=$(usex ndof)
		-DWITH_INSTALL_PORTABLE=OFF
		-DWITH_INTERNATIONAL=$(usex nls)
		-DWITH_JACK=$(usex jack)
		-DWITH_LLVM=$(usex llvm)
		-DWITH_MEM_JEMALLOC=$(usex jemalloc)
		-DWITH_MEM_VALGRIND=$(usex valgrind)
		-DWITH_MOD_FLUID=$(usex elbeem)
		-DWITH_MOD_OCEANSIM=$(usex fftw)
		-DWITH_OPENAL=$(usex openal)
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
		-DWITH_SDL=$(usex sdl)
		-DWITH_STATIC_LIBS=OFF
		-DWITH_SYSTEM_EIGEN3=ON
		-DWITH_SYSTEM_GLEW=ON
		-DWITH_SYSTEM_LZO=ON
		-DWITH_X11=$(usex !headless)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

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

src_test() {
	if use test; then
		einfo "Running Blender Unit Tests ..."
		cd "${BUILD_DIR}"/bin/tests || die
		local f
		for f in *_test; do
			./"${f}" || die
		done
	fi
}

src_install() {
	# Pax mark blender for hardened support.
	pax-mark m "${CMAKE_BUILD_DIR}"/bin/blender

	if use doc; then
		docinto "html/API/python"
		dodoc -r "${CMAKE_USE_DIR}"/doc/python_api/BPY_API/.

		docinto "html/API/blender"
		dodoc -r "${CMAKE_USE_DIR}"/doc/doxygen/html/.
	fi

	cmake-utils_src_install

	# fix doc installdir
	docinto "html"
	dodoc "${CMAKE_USE_DIR}"/release/text/readme.html
	rm -r "${ED%/}"/usr/share/doc/blender || die

	if [[ -n "${BLENDER_MULTISLOT}" && "${BLENDER_MULTISLOT}" == "1" ]] ; then
		python_fix_shebang "${ED%/}/usr/bin/${PN}/${SLOT}/blender-thumbnailer.py"
	else
		python_fix_shebang "${ED%/}/usr/bin/blender-thumbnailer.py"
	fi
	python_optimize "${ED%/}/usr/share/blender/${MY_PV}/scripts"

	if use cycles-network ; then
		if [[ -n "${BLENDER_MULTISLOT}" && "${BLENDER_MULTISLOT}" == "1" ]] ; then
			exeinto "/usr/bin/${PN}/${SLOT}"
			doexe "${CMAKE_BUILD_DIR}/usr/bin/${PN}/${SLOT}/cycles_server"
		else
			exeinto /usr/bin
			doexe "${CMAKE_BUILD_DIR}/bin/cycles_server"
		fi
	fi

	if [[ -n "${BLENDER_MULTISLOT}" && "${BLENDER_MULTISLOT}" == "1" ]] ; then
		mv "${ED}/usr/share/applications"/blender{,-${SLOT}}.desktop || die
		local menu_file="${ED}/usr/share/applications/blender-${SLOT}.desktop"
		sed -i -e "s|Name=Blender|Name=Blender ${PV}|g" "${menu_file}" || die
		sed -i -e "s|Exec=blender|Exec=/usr/bin/${PN}/${SLOT}/blender|g" "${menu_file}" || die
		sed -i -e "s|Icon=blender|Icon=blender-${SLOT}|g" "${menu_file}" || die
		for size in 16x16 22x22 24x24 256x256 32x32 48x48 ; do
			mv "${ED}/usr/share/icons/hicolor/"${size}"/apps/blender"{,-${SLOT}}".png" || die
		done
		mv "${ED}/usr/share/icons/hicolor/scalable/apps/blender"{,-${SLOT}}".svg" || die
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
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_mimeinfo_database_update

	ewarn ""
	ewarn "You may want to remove the following directory."
	ewarn "~/.config/${PN}/${MY_PV}/cache/"
	ewarn "It may contain extra render kernels not tracked by portage"
	ewarn ""
}
