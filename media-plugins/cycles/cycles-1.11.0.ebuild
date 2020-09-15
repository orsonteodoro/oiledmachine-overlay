# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Corresponds to Blender 2.81

EAPI=7
DESCRIPTION="Cycles is a ray tracing renderer focused on interactivity and \
ease of use, while still supporting many production features."
HOMEPAGE="https://developer.blender.org/tag/cycles/"
KEYWORDS="amd64 ~x86"
LICENSE="Apache-2.0
	 Boost-1.0
	 BSD
	 MIT"
SLOT="0/${PV}"
RESTRICT="fetch mirror"
INSTR_SET=( avx avx2 sse sse2 sse3 sse4_1 )
IUSE=" ${INSTR_SET[@]/#/cpu_flags_x86_}"
IUSE+=" asan cuda debug embree gui network nvcc nvrtc opencl opensubdiv optix osl"
# Same dependency versions as Blender 2.81
RDEPEND="cuda? ( >=x11-drivers/nvidia-drivers-418.39
		 >=dev-util/nvidia-cuda-toolkit-10.1:= )
	>=dev-libs/boost-1.68[threads]
	>=dev-libs/pugixml-1.9
	embree? ( >=media-libs/embree-3.2.4 )
	media-libs/mesa
	>=media-libs/glew-1.13.0
	>=media-libs/openimageio-1.8.13
	opensubdiv? ( >=media-libs/opensubdiv-3.4.0_rc2[cuda=,opencl=] )
	optix? ( >=dev-libs/optix-7 )
	osl? ( >=media-libs/osl-1.9.9 )
	virtual/opencl"
DEPEND="${RDEPEND}
	asan? ( || ( sys-devel/clang
		     sys-devel/gcc ) )"
REQUIRED_USE="
	cuda? ( ^^ ( nvcc nvrtc ) )
	nvcc? ( || ( cuda optix ) )
	nvrtc? ( || ( cuda optix ) )
	optix? ( cuda nvcc )"
EGIT_REPO_URI="git://git.blender.org/cycles.git"
EGIT_COMMIT="v${PV}"
CMAKE_MAKEFILE_GENERATOR="ninja"
CMAKE_BUILD_TYPE="Release"
inherit cmake-utils desktop git-r3 xdg
SRC_URI=""
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"
PATCHES=(
	"${FILESDIR}/cycles-1.11.0-network-fixes.patch"
	"${FILESDIR}/cycles-1.11.0-device_network_h-fixes.patch"
	"${FILESDIR}/cycles-1.11.0-device_network_h-add-device-header.patch"
	"${FILESDIR}/cycles-1.11.0-update-acquire_tile-for-cycles-networking.patch"
	"${FILESDIR}/cycles-1.11.0-change-prefix-install.patch"
)

src_unpack() {
	git-r3_fetch
	git-r3_checkout
}

src_prepare() {
	local jobs=$(echo "${MAKEOPTS}" | grep -P -o -e "(-j|--jobs=)\s*[0-9]+" \
			| sed -r -e "s#(-j|--jobs=)\s*##g")
	local cores=$(nproc)
	if (( ${jobs} > $((${cores}/2)) )) ; then
		ewarn \
"${PN} may lock up or freeze the computer if the N value in MAKEOPTS=\"-jN\" \
is greater than \$(nproc)/2"
	fi

	cmake-utils_src_prepare
	if use network ; then
		ewarn \
"Cycles Networking support does not work at all even for CPU rendering.  For \
ebuild/upstream developers only."
	fi

	sed -i -e "s|bf_intern_glew_mx|bf_intern_glew_mx \${GLEW_LIBRARY}|g" \
		src/app/CMakeLists.txt || die

}

src_configure() {
	local simd=OFF
	if use cpu_flags_x86_avx || use cpu_flags_x86_avx2 \
		|| use cpu_flags_x86_sse || use cpu_flags_x86_sse2 \
		|| use cpu_flags_x86_sse3 || use cpu_flags_x86_sse4_1 ; then
		simd=ON
	fi


	mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=/usr/$(get_libdir)/cycles
		-DBUILD_SHARED_LIBS=OFF
		-DWITH_BLENDER=FALSE
		-DWITH_CPU_SSE=${simd}
		-DWITH_CUDA_DYNLOAD=$(usex cuda $(usex nvcc ON OFF) ON)
		-DWITH_CYCLES_CUBIN_COMPILER=$(usex nvrtc)
		-DWITH_CYCLES_CUDA_BINARIES=$(usex cuda)
		-DWITH_CYCLES_DEBUG=$(usex debug)
		-DWITH_CYCLES_DEVICE_CUDA=$(usex cuda TRUE FALSE)
		-DWITH_CYCLES_DEVICE_OPENCL=$(usex opencl)
		-DWITH_CYCLES_DEVICE_OPTIX=$(usex optix)
		-DWITH_CYCLES_EMBREE=$(usex embree)
		-DWITH_CYCLES_KERNEL_ASAN=$(usex asan)
		-DWITH_CYCLES_LOGGING=OFF
		-DWITH_CYCLES_NETWORK=$(usex network)
		-DWITH_CYCLES_OPENSUBDIV=$(usex opensubdiv)
		-DWITH_CYCLES_OSL=$(usex osl)
		-DWITH_CYCLES_STANDALONE=TRUE
		-DWITH_CYCLES_STANDALONE_GUI=$(usex gui)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	exeinto /usr/$(get_libdir)/cycles/bin
	doexe "${BUILD_DIR}/bin/cycles"
	if use network ; then
		doexe "${BUILD_DIR}/bin/cycles_server"
	fi
	if use nvrtc ; then
		if [[ -e "${BUILD_DIR}/bin/cycles_cubin_cc" ]] ; then
			doexe "${BUILD_DIR}/bin/cycles_cubin_cc"
		fi
	fi
	insinto /usr/$(get_libdir)/cycles/$(get_libdir)
	doins "${BUILD_DIR}/lib/"*
}

pkg_postinst() {
	if use network ; then
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
}
