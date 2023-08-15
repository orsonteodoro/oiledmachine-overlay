# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=15
PYTHON_COMPAT=( python3_10 ) # U 20/22

inherit cmake llvm python-single-r1 toolchain-funcs

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
cpu +enhanced-message ffmpeg +loom +migraphx +neural-net opencl opencv
+rocal +rocm +rpp
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
PROTOBUF_PV="3.12.4"
RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=dev-python/pybind11-2.4[${PYTHON_USEDEP}]
	')
	>=sys-devel/gcc-12
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
		sys-devel/gcc[openmp]
		!ffmpeg? (
			>=dev-libs/boost-${BOOST_PV}:=
		)
	)
	rocm? (
		>=sys-libs/libomp-${LLVM_MAX_SLOT}
		sys-devel/gcc[openmp]
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
	"${FILESDIR}/MIVisionX-5.3.3-change-libjpeg-turbo-search-path.patch"
	"${FILESDIR}/MIVisionX-5.1.3-use-system-pybind11.patch"
)

pkg_setup() {
	llvm_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	IFS=$'\n'
	sed \
		-i \
		-e "s|\${ROCM_PATH}/llvm/bin/clang++|${ESYSROOT}/usr/lib/llvm/${LLVM_MAX_SLOT}/bin/clang++|g" \
		$(grep -l -r -e "/llvm/bin/clang++" "${WORKDIR}") \
		|| die
	sed \
		-i \
		-e "s|half/half.hpp|half.hpp|g" \
		$(grep -l -r -e "half/half.hpp" "${S}") \
		|| die
	IFS=$' \t\n'
}

src_configure() {
	build_libjpeg_turbo
	cd "${S}" || die
	local mycmakeargs=(
		-DENHANCED_MESSAGE=$(usex enhanced-message ON OFF)
		-DGPU_SUPPORT=$(usex cpu OFF ON)
		-DLOOM=$(usex loom ON OFF)
		-DMIGRAPHX=$(usex migraphx ON OFF)
		-DNEURAL_NET=$(usex neural-net ON OFF)
		-DROCAL=$(usex rocal ON OFF)
	)

	export CXX="${HIP_CXX:-clang++}"

	if ver_test $(gcc-major-version) -lt 12 ; then
eerror
eerror "You must switch to >= GCC 12.  Do"
eerror
eerror "  eselect gcc set ${CMAKE}-12"
eerror "  source /etc/profile"
eerror
		die
	fi

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
			-e "s|-DNDEBUG -fPIC|-DNDEBUG -fPIC --rocm-path='${ESYSROOT}/usr' --rocm-device-lib-path='${ESYSROOT}/usr/lib/amdgcn/bitcode'|g" \
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
	local rpath=$(patchelf --print-rpath "${ED}/usr/$(get_libdir)/librocal.so")
	patchelf \
		--set-rpath "${EPREFIX}/usr/$(get_libdir)/${PN}/third_party/libjpeg-turbo:${rpath}" \
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
