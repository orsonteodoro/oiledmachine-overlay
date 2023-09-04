# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=14
PYTHON_COMPAT=( python3_10 ) # U 18/20

inherit cmake llvm python-single-r1 toolchain-funcs rocm

RRAWTHER_LIBJPEG_TURBO_COMMIT="ae4e2a24e54514d1694d058650c929e6086cc4bb"
if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/GPUOpen-ProfessionalCompute-Libraries/MIVisionX/"
	inherit git-r3
else
	SRC_URI="
https://github.com/GPUOpen-ProfessionalCompute-Libraries/MIVisionX/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/rrawther/libjpeg-turbo/archive/${RRAWTHER_LIBJPEG_TURBO_COMMIT}.tar.gz
	-> rrawther-libjpeg-turbo-${RRAWTHER_LIBJPEG_TURBO_COMMIT:0:7}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-rocm-${PV}"
fi

DESCRIPTION="MIVisionX toolkit is a set of comprehensive computer vision and \
machine intelligence libraries, utilities, and applications bundled into a \
single toolkit."
HOMEPAGE="https://github.com/GPUOpen-ProfessionalCompute-Libraries/MIVisionX"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
IUSE="
cpu ffmpeg +loom +migraphx +neural-net opencl opencv +rocal +rocm +rpp
r1
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	rocal? (
		^^ (
			rocm
			opencl
		)
	)
	rpp? (
		^^ (
			rocm
			opencl
		)
	)
	^^ (
		rocm
		opencl
		cpu
	)
"
# GCC 12 (libstdcxx:12) required to fix:
# libhsa-runtime64.so.1: undefined reference to `std::condition_variable::wait(std::unique_lock<std::mutex>&)@GLIBCXX_3.4.30'
BOOST_PV="1.72.0"
PROTOBUF_PV="3.12.0"
RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=dev-python/pybind11-2.4[${PYTHON_USEDEP}]
	')
	dev-libs/openssl
	~dev-util/hip-${PV}:${SLOT}
	ffmpeg? (
		>=media-video/ffmpeg-4.0.4[fdk,gpl,libass,x264,x265,nonfree]
	)
	neural-net? (
		>=dev-libs/protobuf-${PROTOBUF_PV}
	)
	opencl? (
		virtual/opencl
		~sci-libs/miopengemm-${PV}:${SLOT}
	)
	opencv? (
		>=media-libs/opencv-4.5.5[features2d,jpeg]
	)
	rocal? (
		>=dev-libs/protobuf-${PROTOBUF_PV}
		>=sys-libs/libomp-${LLVM_MAX_SLOT}
		media-libs/libjpeg-turbo
		!ffmpeg? (
			>=dev-libs/boost-${BOOST_PV}:=
		)
	)
	rocm? (
		>=sys-libs/libomp-${LLVM_MAX_SLOT}
		~sci-libs/rocBLAS-${PV}:${SLOT}
	)
	rpp? (
		>=dev-libs/boost-${BOOST_PV}:=
		~sci-libs/rpp-${PV}:${SLOT}
	)
"
DEPEND="
	${RDEPEND}
	>=dev-cpp/eigen-3:=
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-util/cmake-3.5
	dev-util/patchelf
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}/${PN}-5.1.3-change-libjpeg-turbo-search-path.patch"
	"${FILESDIR}/${PN}-5.1.3-use-system-pybind11.patch"
	"${FILESDIR}/${PN}-5.1.3-path-changes.patch"
)

pkg_setup() {
	llvm_pkg_setup
	python-single-r1_pkg_setup
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	sed \
		-i \
		-e "s|Python3 REQUIRED|Python3 ${EPYTHON/python/} EXACT REQUIRED|g" \
		"rocAL/rocAL_pybind/CMakeLists.txt" \
		|| die
	rocm_src_prepare
}

src_configure() {
	build_libjpeg_turbo
	cd "${S}" || die
	local mycmakeargs=(
		-DGPU_SUPPORT=$(usex cpu OFF ON)
		-DLOOM=$(usex loom ON OFF)
		-DMIGRAPHX=$(usex migraphx ON OFF)
		-DNEURAL_NET=$(usex neural-net ON OFF)
		-DROCAL=$(usex rocal ON OFF)
	)

	export CC="${HIP_CC:-${CHOST}-clang-${LLVM_MAX_SLOT}}"
	export CXX="${HIP_CXX:-${CHOST}-clang++-${LLVM_MAX_SLOT}}"

	if use opencl ; then
		mycmakeargs+=(
			-DBACKEND="OPENCL"
		)
	elif use cpu ; then
		mycmakeargs+=(
			-DBACKEND="CPU"
		)
	elif use rocm ; then
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DBACKEND="HIP"
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
		)

		if use rocal ; then
			local staging_dir="${WORKDIR}/install"
			export TURBO_JPEG_PATH="${staging_dir}/usr/$(get_libdir)/${PN}/third_party/libjpeg-turbo"
			mycmakeargs+=(
				-DTURBO_JPEG_PATH="${staging_dir}/usr/$(get_libdir)/${PN}/third_party/libjpeg-turbo"
				-DPYBIND11_INCLUDES="${ESYSROOT}/usr/include"
			)
		fi

		if use rpp ; then
			mycmakeargs+=(
				-DAMDRPP_PATH="${ESYSROOT}/usr"
			)
		fi

		if [[ "${CXX}" =~ (^|-)"g++" ]] ; then
			mycmakeargs+=(
				-DOpenMP_CXX_FLAGS="-fopenmp"
				-DOpenMP_CXX_LIB_NAMES="libopenmp"
				-DOpenMP_libopenmp_LIBRARY="openmp"
			)
		else
			mycmakeargs+=(
				-DOpenMP_CXX_FLAGS="-fopenmp=libomp"
				-DOpenMP_CXX_LIB_NAMES="libomp"
				-DOpenMP_libomp_LIBRARY="omp"
			)
		fi
		IFS=$'\n'
		sed \
			-i \
			-e "s|-DNDEBUG -fPIC|-DNDEBUG -fPIC --rocm-path='${ESYSROOT}/usr' --rocm-device-lib-path='${ESYSROOT}/usr/$(get_libdir)/amdgcn/bitcode'|g" \
			$(grep -l -r -e "-DNDEBUG -fPIC" "${WORKDIR}") \
			|| die
		IFS=$' \t\n'
	fi

	cmake_src_configure
}

build_libjpeg_turbo() {
	local staging_dir="${WORKDIR}/install"
	cd "${WORKDIR}/libjpeg-turbo-${RRAWTHER_LIBJPEG_TURBO_COMMIT}" || die
	mkdir -p "build" || die
	cd "build" || die
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${staging_dir}/usr/$(get_libdir)/${PN}/third_party/libjpeg-turbo"
		-DCMAKE_BUILD_TYPE=RELEASE
		-DENABLE_STATIC=FALSE
		-DCMAKE_INSTALL_DEFAULT_LIBDIR=lib
	)
	cmake \
		"${mycmakeargs[@]}" \
		.. \
		|| die
	emake || die
	emake install || die
}

sanitize_permissions() {
	IFS=$'\n'
	local path
	for path in $(find "${ED}") ; do
		chown root:root "${path}" || die
		if file "${path}" | grep -q "directory" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q "ELF .* LSB shared object" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q "ELF .* LSB pie executable" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q "symbolic link" ; then
			:;
		else
			chmod 0644 "${path}" || die
		fi
	done
	IFS=$' \t\n'
}

fix_rpath() {
	local rpath
	local file_path
	rpath=$(patchelf --print-rpath "${ED}/${EPREFIX}/usr/$(get_libdir)/librocal.so")
	rpath="${EPREFIX}/usr/$(get_libdir)/${PN}/third_party/libjpeg-turbo/lib:${rpath}"
	file_path="${ED}/${EPREFIX}/usr/$(get_libdir)/librocal.so"
	patchelf \
		--set-rpath "${rpath}" \
		"${file_path}" \
		|| die
	rpath="${EPREFIX}/usr/$(get_libdir)/${PN}/third_party/libjpeg-turbo/lib"
	file_path=$(realpath "${ED}/${EPREFIX}/usr/lib/${EPYTHON}/site-packages/rocal_pybind.cpython-"*"-linux-gnu.so")
	patchelf \
		--set-rpath "${rpath}" \
		"${file_path}" \
		|| die
}

src_install() {
	cmake_src_install
	local staging_dir="${WORKDIR}/install"
	insinto /
	doins -r "${staging_dir}/"*
	sanitize_permissions
	fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
