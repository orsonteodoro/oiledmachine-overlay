# Copyright 2012-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=17

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX17[@]}
)

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX17[@]/llvm_slot_}
)

IMPLS=(
	"cuda"
	"opencl"
	"openmp"
	"rocm"
	"sycl"
)
ROCM_SLOTS=(
	rocm_7_2
)

inherit check-compiler-switch cmake flag-o-matic libstdcxx-slot rocm

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="3dc1cdc27a68680caa4bdab7d89c45543d71363d" # Jan 13, 2025
	EGIT_REPO_URI="https://github.com/ekondis/mixbench.git"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/ekondis/mixbench/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A GPU benchmark tool for evaluating GPUs and CPUs on mixed \
operational intensity kernels (CUDA, OpenCL, HIP, SYCL, OpenMP)"
HOMEPAGE="https://github.com/ekondis/mixbench"
LICENSE="GPL-2"
SLOT="0"
IUSE+="
${ROCM_SLOTS[@]}
cuda doc rocm opencl openmp sycl
ebuild_revision_5
"
REQUIRED_USE="
	rocm? (
		^^ (
			${ROCM_SLOTS[@]}
		)
	)
	^^ (
		${IMPLS[@]}
	)
"
RDEPEND="
	cuda? (
		dev-util/nvidia-cuda-toolkit:=
	)
	opencl? (
		virtual/opencl:=
	)
	openmp? (
		sys-devel/gcc:=[openmp]
	)
	rocm? (
		rocm_7_2? (
			~dev-util/hip-${HIP_7_2_VERSION}:=[rocm]
		)
		dev-util/hip:=
	)
	sycl? (
		|| (
			sys-devel/DPC++:=
		)
	)
"
DEPEND="
	${RDEPEND}
	opencl? (
		dev-util/opencl-headers:=
	)
"
BDEPEND="
	>=dev-build/cmake-3.8
	openmp? (
		sys-devel/gcc:=[openmp]
	)
"
DOCS=( "README.md" )
_PATCHES=(
	"${FILESDIR}/${PN}-9999-hip-cmake-module-path.patch"
)

pkg_setup() {
	check-compiler-switch_start
	if use rocm ; then
		if use rocm_7_2 ; then
			LLVM_SLOT="${HIP_7_2_LLVM_SLOT}"
			export ROCM_SLOT="7.2"
			ROCM_VERSION="${HIP_7_2_VERSION}"
		fi
einfo "LLVM_SLOT:  ${LLVM_SLOT}"
einfo "ROCM_SLOT:  ${ROCM_SLOT}"
einfo "ROCM_VERSION:  ${ROCM_VERSION}"
		rocm_pkg_setup
	fi
	if ! use rocm ; then
		libcxx-slot_verify
	fi
	libstdcxx-slot_verify
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_prepare() {
	default
	eapply ${_PATCHES[@]}
	local x
	for x in ${IMPLS[@]} ; do
		if use "${x}" ; then
			local x2
			if [[ "${x}" == "openmp" ]] ; then
				x2="cpu"
			elif [[ "${x}" == "rocm" ]] ; then
				x2="hip"
			else
				x2="${x}"
			fi
			pushd "mixbench-${x2}" >/dev/null 2>&1 || die
				CMAKE_USE_DIR="${S}/mixbench-${x2}" \
				BUILD_DIR="${S}_${x2}_build" \
				cmake_src_prepare
				if [[ "${x}" == "rocm" ]] ; then
					rocm_src_prepare
				fi
			popd >/dev/null 2>&1 || die
		fi
	done
	if use rocm ; then
		mkdir -p "${S}/mixbench-hip/cmake"
		cp -a \
			"/opt/rocm/lib/cmake/hip/FindHIP"* \
			"${S}/mixbench-hip/cmake" \
			|| die
	fi
}

src_configure() {
	local x
	for x in ${IMPLS[@]} ; do
		if use "${x}" ; then
			local x2
			if [[ "${x}" == "openmp" ]] ; then
				x2="cpu"
			elif [[ "${x}" == "rocm" ]] ; then
				x2="hip"
			else
				x2="${x}"
			fi
			pushd "mixbench-${x2}" >/dev/null 2>&1 || die
				local mycmakeargs=()
				if [[ "${x2}" == "cuda" ]] ; then
					export CC="${CHOST}-gcc"
					export CXX="${CHOST}-g++"
					export CPP="${CC} -E"
					strip-unsupported-flags
					addpredict "/proc/self/task/"
				elif [[ "${x2}" == "hip" ]] ; then
					rocm_set_default_hipcc
					append-ldflags -lhsa-runtime64
					filter-flags '-Wl,--as-needed' # Fix for undefined symbol: hsa_init
					mycmakeargs+=(
						-DHIP_PATH="${ESYSROOT}/opt/rocm"
					)
				elif [[ "${x2}" == "opencl" ]] ; then
					mycmakeargs+=(
						-DOpenCL_LIBRARY="${ESYSROOT}/usr/$(get_libdir)/libOpenCL.so"
						-DOpenCL_INCLUDE_DIR="${ESYSROOT}/usr/include"
					)
				elif [[ "${x2}" == "openmp" ]] ; then
					export CC="${CHOST}-gcc"
					export CXX="${CHOST}-g++"
					export CPP="${CC} -E"
					strip-unsupported-flags
				elif [[ "${x2}" == "sycl" ]] ; then
					export CC="${CHOST}-clang-${s}"
					export CXX="${CHOST}-clang++-${s}"
					export CPP="${CC} -E"
					strip-unsupported-flags
					local sycl_targets="${MIXBENCH_SYCL_TARGETS:-nvptx64-nvidia-cuda}"
					mycmakeargs+=(
						-DCMAKE_CXX_COMPILER="${CXX}"
						-DCMAKE_CXX_FLAGS="-fsycl -std=c++17 -fsycl-targets=${sycl_targets}"
					)
				fi

				check-compiler-switch_end
				if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
					filter-lto
				fi

				if [[ "${x}" == "rocm" ]] ; then
					CMAKE_USE_DIR="${S}/mixbench-${x2}" \
					BUILD_DIR="${S}_${x2}_build" \
					rocm_src_configure
				else
					CMAKE_USE_DIR="${S}/mixbench-${x2}" \
					BUILD_DIR="${S}_${x2}_build" \
					cmake_src_configure
				fi
			popd >/dev/null 2>&1 || die
		fi
	done
}

src_compile() {
	local x
	for x in ${IMPLS[@]} ; do
		if use "${x}" ; then
			local x2
			if [[ "${x}" == "openmp" ]] ; then
				x2="cpu"
			elif [[ "${x}" == "rocm" ]] ; then
				x2="hip"
			else
				x2="${x}"
			fi
			pushd "mixbench-${x2}" >/dev/null 2>&1 || die
				CMAKE_USE_DIR="${S}/mixbench-${x2}" \
				BUILD_DIR="${S}_${x2}_build" \
				cmake_src_compile
			popd >/dev/null 2>&1 || die
		fi
	done
}

src_install() {
	local x
	for x in ${IMPLS[@]} ; do
		if use "${x}" ; then
			local x2
			if [[ "${x}" == "openmp" ]] ; then
				x2="cpu"
			elif [[ "${x}" == "rocm" ]] ; then
				x2="hip"
			else
				x2="${x}"
			fi
			local x3
			if [[ "${x}" == "opencl" ]] ; then
				x3="ocl"
			else
				x3="${x2}"
			fi
			pushd "mixbench-${x2}" >/dev/null 2>&1 || die
				local BUILD_DIR="${S}_${x2}_build"
				exeinto "/usr/bin"
				doexe "${BUILD_DIR}/mixbench-${x3}"
				if use doc && [[ -e "README.md" ]] ; then
					docinto "readmes/mixbench-${x2}"
					dodoc "README.md"
				fi
			popd >/dev/null 2>&1 || die
		fi
	done

	if use rocm ; then
		rocm_fix_rpath
	fi

	docinto "licenses"
	dodoc "LICENSE"
}
