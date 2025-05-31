# Copyright 2012-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FLAG_O_MATIC_STRIP_UNSUPPORTED_FLAGS=1
IMPLS=(
	"cuda"
	"opencl"
	"rocm"
	"sycl"
)
ROCM_SLOTS=(
	rocm_4_5
	rocm_5_1
	rocm_5_2
	rocm_5_3
	rocm_5_4
	rocm_5_5
	rocm_5_6
	rocm_5_7
	rocm_6_0
	rocm_6_1
)

inherit check-compiler-switch cmake flag-o-matic rocm

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="440a133a6423840ce613d1eaab43cd586effd389" # Feb 23, 2024
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
cuda doc rocm opencl sycl
ebuild_revision_3
"
REQUIRED_USE="
	rocm? (
		^^ (
			${ROCM_SLOTS[@]}
		)
	)
	|| (
		${IMPLS[@]}
	)
"
RDEPEND="
	cuda? (
		dev-util/nvidia-cuda-toolkit:=
	)
	opencl? (
		dev-util/opencl-headers
		virtual/opencl
	)
	rocm? (
		rocm_4_5? (
			~dev-util/hip-${HIP_4_5_VERSION}:4.5[rocm]
		)
		rocm_5_1? (
			~dev-util/hip-${HIP_5_1_VERSION}:5.1[rocm]
		)
		rocm_5_2? (
			~dev-util/hip-${HIP_5_2_VERSION}:5.2[rocm]
		)
		rocm_5_3? (
			~dev-util/hip-${HIP_5_3_VERSION}:5.3[rocm]
		)
		rocm_5_4? (
			~dev-util/hip-${HIP_5_4_VERSION}:5.4[rocm]
		)
		rocm_5_5? (
			~dev-util/hip-${HIP_5_5_VERSION}:5.5[rocm]
		)
		rocm_5_6? (
			~dev-util/hip-${HIP_5_6_VERSION}:5.6[rocm]
		)
		rocm_5_7? (
			~dev-util/hip-${HIP_5_7_VERSION}:5.7[rocm]
		)
		rocm_6_0? (
			~dev-util/hip-${HIP_6_0_VERSION}:6.0[rocm]
		)
		rocm_6_1? (
			~dev-util/hip-${HIP_6_1_VERSION}:6.1[rocm]
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
"
BDEPEND="
	>=dev-build/cmake-3.8
"
DOCS=( "README.md" )
_PATCHES=(
	"${FILESDIR}/${PN}-0.04-hip-hardcoded-paths.patch"
	"${FILESDIR}/${PN}-0.04-hip-cmake-module-path.patch"
	"${FILESDIR}/${PN}-0.04-hip-architectures.patch"
)

pkg_setup() {
	check-compiler-switch_start
	if use rocm ; then
		if use rocm_4_5 ; then
			LLVM_SLOT="${HIP_4_5_LLVM_SLOT}"
			export ROCM_SLOT="4.5"
			ROCM_VERSION="${HIP_4_5_VERSION}"
		elif use rocm_5_1 ; then
			LLVM_SLOT="${HIP_5_1_LLVM_SLOT}"
			export ROCM_SLOT="5.1"
			ROCM_VERSION="${HIP_5_1_VERSION}"
		elif use rocm_5_2 ; then
			LLVM_SLOT="${HIP_5_2_LLVM_SLOT}"
			export ROCM_SLOT="5.2"
			ROCM_VERSION="${HIP_5_2_VERSION}"
		elif use rocm_5_3 ; then
			LLVM_SLOT="${HIP_5_3_LLVM_SLOT}"
			export ROCM_SLOT="5.3"
			ROCM_VERSION="${HIP_5_3_VERSION}"
		elif use rocm_5_4 ; then
			LLVM_SLOT="${HIP_5_4_LLVM_SLOT}"
			export ROCM_SLOT="5.4"
			ROCM_VERSION="${HIP_5_4_VERSION}"
		elif use rocm_5_5 ; then
			LLVM_SLOT="${HIP_5_5_LLVM_SLOT}"
			export ROCM_SLOT="5.5"
			ROCM_VERSION="${HIP_5_5_VERSION}"
		elif use rocm_5_6 ; then
			LLVM_SLOT="${HIP_5_6_LLVM_SLOT}"
			export ROCM_SLOT="5.6"
			ROCM_VERSION="${HIP_5_6_VERSION}"
		elif use rocm_5_7 ; then
			LLVM_SLOT="${HIP_5_7_LLVM_SLOT}"
			export ROCM_SLOT="5.7"
			ROCM_VERSION="${HIP_5_7_VERSION}"
		elif use rocm_6_0 ; then
			LLVM_SLOT="${HIP_6_0_LLVM_SLOT}"
			export ROCM_SLOT="6.0"
			ROCM_VERSION="${HIP_6_0_VERSION}"
		elif use rocm_6_1 ; then
			LLVM_SLOT="${HIP_6_1_LLVM_SLOT}"
			export ROCM_SLOT="6.1"
			ROCM_VERSION="${HIP_6_1_VERSION}"
		fi
einfo "LLVM_SLOT:  ${LLVM_SLOT}"
einfo "ROCM_SLOT:  ${ROCM_SLOT}"
einfo "ROCM_VERSION:  ${ROCM_VERSION}"
		rocm_pkg_setup
	fi
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
			local x2="${x}"
			if [[ "${x}" == "rocm" ]] ; then
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
			"/opt/rocm-${ROCM_VERSION}/lib/cmake/hip/FindHIP"* \
			"${S}/mixbench-hip/cmake" \
			|| die
	fi
}

_check_libstdcxx() {
	local gcc_slot="${1}"
	local gcc_current_profile=$(gcc-config -c)
	local gcc_current_profile_slot=${gcc_current_profile##*-}

	if ver_test "${gcc_current_profile_slot}" -ne "${gcc_slot}" ; then
eerror
eerror "Current slot:  ${gcc_current_profile_slot}"
eerror
eerror "You must switch to GCC ${gcc_slot}.  Do"
eerror
eerror "  eselect gcc set ${CHOST}-${gcc_slot}"
eerror "  source /etc/profile"
eerror
eerror "This is a temporary for ${PN}:${SLOT}.  You must restore it back"
eerror "to the default immediately after this package has been merged."
eerror
		die
	fi
}

src_configure() {
	local x
	for x in ${IMPLS[@]} ; do
		if use "${x}" ; then
			local x2
			if [[ "${x}" == "rocm" ]] ; then
				x2="hip"
			else
				x2="${x}"
			fi
			pushd "mixbench-${x2}" >/dev/null 2>&1 || die
				local mycmakeargs=()
				if [[ "${x2}" == "cuda" ]] ; then
					local s="11"
					if has_version "=dev-util/nvidia-cuda-toolkit-11.8*" ; then
						s="11"
					elif has_version "=dev-util/nvidia-cuda-toolkit-12*" ; then
						s="12"
					fi
					_check_libstdcxx "${s}"
					export CC="${CHOST}-gcc-${s}"
					export CXX="${CHOST}-gcc-${s}"
					export CPP="${CC} -E"
					strip-unsupported-flags
					addpredict "/proc/self/task/"
				elif [[ "${x2}" == "hip" ]] ; then
					rocm_set_default_hipcc
					append-ldflags -lhsa-runtime64
					filter-flags '-Wl,--as-needed' # Fix for undefined symbol: hsa_init
					mycmakeargs+=(
						-DHIP_PATH="${ESYSROOT}/opt/rocm-${ROCM_VERSION}"
					)
				elif [[ "${x2}" == "opencl" ]] ; then
					mycmakeargs+=(
						-DOpenCL_LIBRARY="${ESYSROOT}/usr/$(get_libdir)/libOpenCL.so"
						-DOpenCL_INCLUDE_DIR="${ESYSROOT}/usr/include"
					)
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
			if [[ "${x}" == "rocm" ]] ; then
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
			if [[ "${x}" == "rocm" ]] ; then
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
				if [[ -e "${BUILD_DIR}/mixbench-${x3}-ro" ]] ; then
					doexe "${BUILD_DIR}/mixbench-${x3}-ro"
				fi
				if [[ -e "${BUILD_DIR}/mixbench-${x3}-alt" ]] ; then
					doexe "${BUILD_DIR}/mixbench-${x3}-alt"
				fi
				if [[ -e "${BUILD_DIR}/mixbench-${x3}" ]] ; then
					doexe "${BUILD_DIR}/mixbench-${x3}"
				fi
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
