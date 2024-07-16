# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=17
PYTHON_COMPAT=( "python3_10" ) # U 20/22
RAPIDJSON_COMMIT="f9d53419e912910fd8fa57d5705fa41425428c35" # committer-date:<=2024-03-08
RRAWTHER_LIBJPEG_TURBO_COMMIT="ae4e2a24e54514d1694d058650c929e6086cc4bb"
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake python-single-r1 rocm toolchain-funcs

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/GPUOpen-ProfessionalCompute-Libraries/MIVisionX/"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-rocm-${PV}"
	S_RAPIDJSON="${WORKDIR}/rapidjson-${RAPIDJSON_COMMIT}"
	SRC_URI="
https://github.com/GPUOpen-ProfessionalCompute-Libraries/MIVisionX/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/rrawther/libjpeg-turbo/archive/${RRAWTHER_LIBJPEG_TURBO_COMMIT}.tar.gz
	-> rrawther-libjpeg-turbo-${RRAWTHER_LIBJPEG_TURBO_COMMIT:0:7}.tar.gz
	!system-rapidjson? (
https://github.com/Tencent/rapidjson/archive/${RAPIDJSON_COMMIT}.tar.gz -> rapidjson-${RAPIDJSON_COMMIT:0:7}.tar.gz
	)
	"
fi

DESCRIPTION="MIVisionX toolkit is a set of comprehensive computer vision and \
machine intelligence libraries, utilities, and applications bundled into a \
single toolkit."
HOMEPAGE="https://github.com/GPUOpen-ProfessionalCompute-Libraries/MIVisionX"
LICENSE="MIT"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
cpu +enhanced-message ffmpeg -fp16 +loom +migraphx +neural-net opencl
opencv +rocal +rocal-python +rocm +rpp system-rapidjson
ebuild-revision-14
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	opencl? (
		!rocal-python
	)
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
PROTOBUF_PV="3.12.0" # The version is behind the 3.21 offered.
RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=dev-python/pybind11-2.4[${PYTHON_USEDEP}]
	')
	dev-libs/openssl
	~dev-util/hip-${PV}:${ROCM_SLOT}
	ffmpeg? (
		>=media-video/ffmpeg-4.4.2:0/56.58.58[fdk,gpl,libass,x264,x265,nonfree]
	)
	neural-net? (
		>=dev-libs/protobuf-${PROTOBUF_PV}:0/3.21
	)
	opencl? (
		virtual/opencl
		~sci-libs/miopengemm-${PV}:${ROCM_SLOT}
	)
	opencv? (
		>=media-libs/opencv-4.6.0[features2d,jpeg]
	)
	rocal? (
		>=dev-libs/protobuf-${PROTOBUF_PV}:0/3.21
		media-libs/libjpeg-turbo
		~dev-libs/rocm-opencl-runtime-${PV}:${ROCM_SLOT}
		~sys-libs/llvm-roc-libomp-${PV}:${ROCM_SLOT}
		!ffmpeg? (
			>=dev-libs/boost-${BOOST_PV}:=
		)
	)
	rocm? (
		~sci-libs/rocBLAS-${PV}:${ROCM_SLOT}
		~dev-libs/rocm-opencl-runtime-${PV}:${ROCM_SLOT}
		~sys-libs/llvm-roc-libomp-${PV}:${ROCM_SLOT}
	)
	rpp? (
		>=dev-libs/boost-${BOOST_PV}:=
		>=sci-libs/rpp-1.1.0:${ROCM_SLOT}
		sci-libs/rpp:=
	)
"
DEPEND="
	${RDEPEND}
	>=dev-cpp/eigen-3:=
	system-rapidjson? (
		=dev-libs/rapidjson-9999
	)
"
BDEPEND="
	${PYTHON_DEPS}
	${ROCM_CLANG_DEPEND}
	>=dev-build/cmake-3.5
	dev-util/patchelf
	virtual/pkgconfig
"
PATCHES=(
#	"${FILESDIR}/${PN}-5.6.0-use-system-pybind11.patch"
	"${FILESDIR}/${PN}-6.0.2-hardcoded-paths.patch"
)

pkg_setup() {
	python-single-r1_pkg_setup
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	sed \
		-i \
		-e "s|Python3 REQUIRED|Python3 ${EPYTHON/python/} EXACT REQUIRED|g" \
		-e "s|Python3 QUIET|Python3 ${EPYTHON/python/} EXACT QUIET|g" \
		"rocAL/rocAL_pybind/CMakeLists.txt" \
		|| die
	rocm_src_prepare
}

src_configure() {
	# Fix libhsa-runtime64.so: undefined reference to `hsaKmtReplaceAsanHeaderPage'
#        append-flags -Wl,-fuse-ld=gold
#        append-ldflags -fuse-ld=gold

	append-cppflags -D__STDC_CONSTANT_MACROS

	if use rocal && ! use system-rapidjson ; then
		append-cppflags -I"${WORKDIR}/install/${EPREFIX}${EROCM_PATH}/$(rocm_get_libdir)/rapidjson/include"
		append-ldflags -L"${WORKDIR}/install/${EPREFIX}${EROCM_PATH}/$(rocm_get_libdir)/rapidjson/lib"
	fi

# Avoid
# ModuleNotFoundError: No module named 'setuptools'
	export PYTHONPATH="${ESYSROOT}/usr/lib/${EPYTHON}/site-packages/:${PYTHONPATH}"
	export PYTHONPATH="${ESYSROOT}/${EROCM_PATH}/lib/${EPYTHON}/site-packages:${PYTHONPATH}"

	build_libjpeg_turbo
	build_rapidjson
	cd "${S}" || die
	local mycmakeargs=(
		-DAMD_FP16_SUPPORT=$(usex fp16 ON OFF)
		-DBUILD_DEV=ON # Install vx.h (OpenVX dev support)
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DENHANCED_MESSAGE=$(usex enhanced-message ON OFF)
		-DGPU_SUPPORT=$(usex cpu OFF ON)
		-DLOOM=$(usex loom ON OFF)
		-DMIGRAPHX=$(usex migraphx ON OFF)
		-DNEURAL_NET=$(usex neural-net ON OFF)
		-DPYTHON_EXECUTABLE="/usr/bin/${EPYTHON}"
		-DROCAL=$(usex rocal ON OFF)
		-DROCAL_PYTHON=$(usex rocal-python ON OFF)
	)

	rocm_set_default_clang

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
			# FIXME: fix prefix in TURBO_JPEG_PATH.
			local staging_dir="${WORKDIR}/install"
			export TURBO_JPEG_PATH="${staging_dir}/${EPREFIX}${EROCM_PATH}/$(rocm_get_libdir)/libjpeg-turbo"
			mycmakeargs+=(
				-DTURBO_JPEG_PATH="${staging_dir}/${EPREFIX}${EROCM_PATH}/$(rocm_get_libdir)/libjpeg-turbo"
				-DPYBIND11_INCLUDES="${ESYSROOT}/usr/include"
			)
		fi

		if use rocal-python ; then
			mycmakeargs+=(
				-DCMAKE_INSTALL_PREFIX_PYTHON="${EPREFIX}${EROCM_PATH}/lib/${EPYTHON}/site-packages"
			)
		fi

		if use rpp ; then
			mycmakeargs+=(
				-DAMDRPP_PATH="${ESYSROOT}/usr"
			)
		fi

		mycmakeargs+=(
			-DOpenMP_CXX_FLAGS="-I${ESYSROOT}${EROCM_LLVM_PATH}/include -fopenmp=libomp"
			-DOpenMP_CXX_LIB_NAMES="libomp"
			-DOpenMP_libomp_LIBRARY="${ESYSROOT}${EROCM_LLVM_PATH}/$(rocm_get_libdir)/libomp.so"
		)
		IFS=$'\n'
		sed \
			-i \
			-e "s|-DNDEBUG -fPIC|-DNDEBUG -fPIC --rocm-path='${ESYSROOT}${EROCM_PATH}' --rocm-device-lib-path='${ESYSROOT}${EROCM_PATH}/$(rocm_get_libdir)/amdgcn/bitcode'|g" \
			$(grep -l -r -e "-DNDEBUG -fPIC" "${WORKDIR}") \
			|| die
		IFS=$' \t\n'
	fi

	rocm_src_configure
}

build_libjpeg_turbo() {
	local staging_dir="${WORKDIR}/install"
	cd "${WORKDIR}/libjpeg-turbo-${RRAWTHER_LIBJPEG_TURBO_COMMIT}" || die
	mkdir -p "build" || die
	cd "build" || die
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${staging_dir}/${EPREFIX}${EROCM_PATH}/$(rocm_get_libdir)/libjpeg-turbo"
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

build_rapidjson() {
	local staging_dir="${WORKDIR}/install"
	use system-rapidjson && return
	pushd "${S_RAPIDJSON}" || die
		mkdir build || die
		cd build || die
		local mycmakeargs=(
			-DCMAKE_INSTALL_PREFIX="${staging_dir}/${EPREFIX}${EROCM_PATH}/$(rocm_get_libdir)/rapidjson"
		)
		cmake \
			"${mycmakeargs[@]}" \
			.. \
			|| die
		emake
		emake install || die
	popd
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
			:
		else
			chmod 0644 "${path}" || die
		fi
	done
	IFS=$' \t\n'
}

fix_rpath() {
	local rpath
	local file_path
	if use rocal ; then
		rpath=$(patchelf --print-rpath "${ED}/${EPREFIX}${EROCM_PATH}/$(rocm_get_libdir)/librocal.so")
		rpath="${EPREFIX}${EROCM_PATH}/$(rocm_get_libdir)/libjpeg-turbo/lib:${rpath}"
		file_path="${ED}/${EPREFIX}${EROCM_PATH}/$(rocm_get_libdir)/librocal.so"
		patchelf \
			--set-rpath "${rpath}" \
			"${file_path}" \
			|| die
	fi
	if use rocal-python ; then
		rpath="${EPREFIX}${EROCM_PATH}/$(rocm_get_libdir)/libjpeg-turbo/lib"
		file_path=$(realpath "${ED}/${EPREFIX}${EROCM_PATH}/lib/${EPYTHON}/site-packages/rocal_pybind.cpython-"*"-linux-gnu.so")
		patchelf \
			--set-rpath "${rpath}" \
			"${file_path}" \
			|| die
	fi
}

src_install() {
	cmake_src_install
	local staging_dir="${WORKDIR}/install"
	insinto /
	doins -r "${staging_dir}/"*
	sanitize_permissions
	fix_rpath
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
