# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# SSE4.1 hardware was released in 2008.
# See scripts/build.py for release versioning.
# Clang is more smoother multitask-wise.

AMDGPU_TARGETS_COMPAT=(
	gfx902
	gfx909
	gfx90c
	gfx1030
	gfx1031
	gfx1032
	gfx1033
	gfx1034
	gfx1035
	gfx1036
	gfx1100
	gfx1101
	gfx1102
	gfx1103
)
CMAKE_BUILD_TYPE=Release
COMPOSABLE_KERNEL_COMMIT="e85178b4ca892a78344271ae64103c9d4d1bfc40"
CUTLASS_COMMIT="66d9cddc832c1cdc2b30a8755274f7f74640cfe6"
CUDA_TARGETS_COMPAT=(
	sm_70
	sm_75
	sm_80
	sm_90
)
FLAG_O_MATIC_STRIP_UNSUPPORTED_FLAGS=1
inherit hip-versions
HIP_VERSIONS=(
	"${HIP_5_5_VERSION}"
	"${HIP_5_6_VERSION}"
	"${HIP_5_7_VERSION}"
	"${HIP_6_0_VERSION}"
	"${HIP_6_1_VERSION}"
)
ROCM_SLOTS=(
	rocm_5_5
	rocm_5_6
	rocm_5_7
	rocm_6_0
	rocm_6_1
)
LEGACY_TBB_SLOT="2"
LLVM_COMPAT=( {18..10} ) # Based on DPC++ (sycl-nightly)
LLVM_SLOT="${LLVM_COMPAT[0]}"
MIN_CLANG_PV="3.3"
MIN_GCC_PV="4.8.1"
MKL_DNN_COMMIT="9bea36e6b8e341953f922ce5c6f5dbaca9179a86"
OIDN_WEIGHTS_COMMIT="28883d1769d5930e13cf7f1676dd852bd81ed9e7"
ONETBB_SLOT="0"
ORG_GH="https://github.com/OpenImageDenoise"
PYTHON_COMPAT=( "python3_"{10..11} )

inherit check-compiler-switch cmake cuda flag-o-matic llvm python-single-r1 rocm toolchain-funcs

if [[ ${PV} = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${ORG_GH}/oidn.git"
	EGIT_BRANCH="master"
else
	KEYWORDS="~amd64 ~arm64"
	SRC_URI="
${ORG_GH}/${PN}/releases/download/v${PV}/${P}.src.tar.gz
	-> ${P}.tar.gz
${ORG_GH}/mkl-dnn/archive/${MKL_DNN_COMMIT}.tar.gz
	-> ${PN}-mkl-dnn-${MKL_DNN_COMMIT:0:7}.tar.gz
	built-in-weights? (
${ORG_GH}/oidn-weights/archive/${OIDN_WEIGHTS_COMMIT}.tar.gz
	-> ${PN}-weights-${OIDN_WEIGHTS_COMMIT:0:7}.tar.gz
	)
https://github.com/ROCmSoftwarePlatform/composable_kernel/archive/${COMPOSABLE_KERNEL_COMMIT}.tar.gz
	-> composable_kernel-${COMPOSABLE_KERNEL_COMMIT:0:7}.tar.gz
https://github.com/NVIDIA/cutlass/archive/${CUTLASS_COMMIT}.tar.gz
	-> cutlass-${CUTLASS_COMMIT:0:7}.tar.gz
	"
fi

DESCRIPTION="Intel® Open Image Denoise library"
HOMEPAGE="http://www.openimagedenoise.org/"
LICENSE="
	Apache-2.0
	BSD
	MIT
"
# MIT - composable_kernel
# BSD - cutlass
# MKL_DNN is oneDNN 2.2.4 with additional custom commits.
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${LLVM_COMPAT[@]/#/llvm_slot_}
${ROCM_SLOTS[@]}
aot +apps +built-in-weights +clang cpu cuda doc gcc openimageio rocm sycl
ebuild_revision_4
"
gen_required_use_cuda_targets() {
	local x
	for x in ${CUDA_TARGETS_COMPAT[@]} ; do
		echo "
			cuda_targets_${x}? (
				cuda
			)
		"
	done
}
gen_required_use_hip_targets() {
	local x
	for x in ${AMDGPU_TARGETS_COMPAT[@]} ; do
		echo "
			amdgpu_targets_${x}? (
				rocm
			)
		"
	done
}
REQUIRED_USE+="
	$(gen_required_use_cuda_targets)
	$(gen_required_use_hip_targets)
	${PYTHON_REQUIRED_USE}
	^^ (
		${LLVM_COMPAT[@]/#/llvm_slot_}
	)
	^^ (
		clang
		gcc
		rocm
	)
	aot? (
		sycl
	)
	cuda? (
		gcc
		|| (
			${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
		)
	)
	rocm? (
		${ROCM_REQUIRED_USE}
		^^ (
			${ROCM_SLOTS[@]}
		)
	)
	rocm_5_5? (
		llvm_slot_16
	)
	rocm_5_6? (
		llvm_slot_16
	)
	rocm_5_7? (
		llvm_slot_17
	)
	rocm_6_0? (
		llvm_slot_17
	)
	rocm_6_1? (
		llvm_slot_17
	)
"
gen_clang_depends() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				=llvm-core/clang-runtime-${s}*
				llvm-core/clang:${s}
				llvm-core/llvm:${s}
				llvm-core/lld:${s}
			)
		"
	done
}

gen_hip_depends() {
	local hip_version
	for hip_version in ${HIP_VERSIONS[@]} ; do
		# Needed because of build failures
		local s=$(ver_cut 1-2 ${hip_version})
		local u="${s}"
		u="${u/./_}"
		echo "
			rocm_${u}? (
				~dev-libs/rocm-comgr-${hip_version}:${s}
				~dev-libs/rocm-device-libs-${hip_version}${s}
				~dev-libs/rocr-runtime-${hip_version}:${s}
				~dev-libs/roct-thunk-interface-${hip_version}${s}
				~dev-util/hip-${hip_version}:${s}[rocm]
				~dev-util/rocminfo-${hip_version}:${s}
			)
		"
	done
}

# See https://github.com/OpenImageDenoise/oidn/blob/v1.4.3/scripts/build.py
RDEPEND+="
	${PYTHON_DEPS}
	virtual/libc
	cuda? (
		>=dev-util/nvidia-cuda-toolkit-11.8:=
	)
	rocm? (
		$(gen_hip_depends)
		dev-util/hip:=[rocm]
	)
	sycl? (
		>=sys-devel/DPC++-2023.10.26:0/7[aot?]
		dev-libs/level-zero
		sys-devel/DPC++:=
	)
	|| (
		(
			!<dev-cpp/tbb-2021:0=
			<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}=
		)
		>=dev-cpp/tbb-2021.5:${ONETBB_SLOT}=
	)
"
DEPEND+="
	${RDEPEND}
	media-libs/openimageio[cuda?]
"
BDEPEND+="
	${PYTHON_DEPS}
	>=dev-lang/ispc-1.21.0
	>=dev-build/cmake-3.15
	clang? (
		$(gen_clang_depends)
	)
	cuda? (
		>=dev-util/nvidia-cuda-toolkit-11.8
		sys-devel/binutils[gold,plugins]
	)
	gcc? (
		>=sys-devel/gcc-${MIN_GCC_PV}
	)
	rocm? (
		rocm_5_5? (
			~sys-devel/llvm-roc-${HIP_5_5_VERSION}:5.5
		)
		rocm_5_6? (
			~sys-devel/llvm-roc-${HIP_5_6_VERSION}:5.6
		)
		rocm_5_7? (
			~sys-devel/llvm-roc-${HIP_5_7_VERSION}:5.7
		)
		rocm_6_0? (
			~sys-devel/llvm-roc-${HIP_6_0_VERSION}:6.0
		)
		rocm_6_1? (
			~sys-devel/llvm-roc-${HIP_6_1_VERSION}:6.1
		)
		sys-devel/llvm-roc:=
		$(gen_hip_depends)
		>=dev-build/cmake-3.21
	)
"
DOCS=( "CHANGELOG.md" "README.md" "readme.pdf" )
PATCHES=(
	"${FILESDIR}/${PN}-1.4.1-findtbb-print-paths.patch"
	"${FILESDIR}/${PN}-2.2.1-findtbb-alt-lib-path.patch"
)
HIP_PATCHES=(
	"${FILESDIR}/${PN}-2.2.1-hip-buildfiles-changes.patch"
	"${FILESDIR}/${PN}-2.0.1-set-rocm-path.patch"
)

check_cpu() {
	if [[ ! -e "${BROOT}/proc/cpuinfo" ]] ; then
ewarn
ewarn "Cannot find ${BROOT}/proc/cpuinfo.  Skipping CPU flag check."
ewarn
	elif ! grep -F -e "sse4_1" "${BROOT}/proc/cpuinfo" ; then
ewarn
ewarn "You need SSE4.1 to use this product."
ewarn
	fi
}

pkg_setup() {
	check-compiler-switch_start
	if [[ "${CHOST}" == "${CBUILD}" ]] && use kernel_linux ; then
		use cpu && check_cpu
	fi

	if use rocm_6_1 ; then
		LLVM_SLOT=17
		ROCM_SLOT="6.1"
		ROCM_VERSION="${HIP_6_1_VERSION}"
	elif use rocm_6_0 ; then
		LLVM_SLOT=17
		ROCM_SLOT="6.0"
		ROCM_VERSION="${HIP_6_0_VERSION}"
	elif use rocm_5_7 ; then
		LLVM_SLOT=17
		ROCM_SLOT="5.7"
		ROCM_VERSION="${HIP_5_7_VERSION}"
	elif use rocm_5_6 ; then
		LLVM_SLOT=16
		ROCM_SLOT="5.6"
		ROCM_VERSION="${HIP_5_6_VERSION}"
	elif use rocm_5_5 ; then
		LLVM_SLOT=16
		ROCM_SLOT="5.5"
		ROCM_VERSION="${HIP_5_5_VERSION}"
	fi

	if use rocm ; then
		rocm_pkg_setup
	else
		LLVM_MAX_SLOT="${LLVM_SLOT}"
		llvm_pkg_setup
	fi

	# This needs to be placed here to avoid this error:
	# python: no python-exec wrapped executable found in /opt/rocm-5.5.1/lib/python-exec.
	python-single-r1_pkg_setup
	if use cuda ; then
		cuda_add_sandbox
	fi
}

src_unpack() {
	unpack ${A}
	rm -rf "${S}/external/composable_kernel" || die
	rm -rf "${S}/external/cutlass" || die
	rm -rf "${S}/external/mkl-dnn" || die
	ln -s \
		"${WORKDIR}/mkl-dnn-${MKL_DNN_COMMIT}" \
		"${S}/external/mkl-dnn" \
		|| die
	ln -s \
		"${WORKDIR}/cutlass-${CUTLASS_COMMIT}" \
		"${S}/external/cutlass" \
		|| die
	ln -s \
		"${WORKDIR}/composable_kernel-${COMPOSABLE_KERNEL_COMMIT}" \
		"${S}/external/composable_kernel" \
		|| die
	if use built-in-weights ; then
		ln -s "${WORKDIR}/oidn-weights-${OIDN_WEIGHTS_COMMIT}" \
			"${S}/weights" || die
	else
		rm -rf "${WORKDIR}/oidn-weights-${OIDN_WEIGHTS_COMMIT}" || die
	fi
}

src_prepare() {
	cmake_src_prepare
	if use rocm ; then
		eapply ${HIP_PATCHES[@]}
	fi
	pushd "${S}/external/composable_kernel" || die
		eapply "${FILESDIR}/composable_kernel-1.0.0_p9999-fix-missing-libstdcxx-expf.patch"
	popd
	if use cuda ; then
		cuda_src_prepare
		addpredict "/proc/self/task/"
	fi
	if use rocm ; then
		rocm_src_prepare
	fi
}

get_cuda_targets() {
	local targets=""
	local cuda_target
	for cuda_target in ${CUDA_TARGETS_COMPAT[@]} ; do
		if use "${cuda_target/#/cuda_targets_}" ; then
			targets+=";${cuda_target}"
		fi
	done
	targets=$(echo "${targets}" \
		| sed -e "s|^;||g")
	echo "${targets}"
}

cuda_host_cc_check() {
	local required_gcc_slot="${1}"
        local gcc_current_profile=$(gcc-config -c)
        local gcc_current_profile_slot=${gcc_current_profile##*-}
        if ver_test "${gcc_current_profile_slot}" -ne "${required_gcc_slot}" ; then
eerror
eerror "You must switch to =sys-devel/gcc-${required_gcc_slot}.  Do"
eerror
eerror "  eselect gcc set ${CHOST}-${required_gcc_slot}"
eerror "  source /etc/profile"
eerror
                die
        fi
}

src_configure() {
	mycmakeargs=()

	append-ldflags -fuse-ld=gold

	if use sycl ; then
		local LLVM_INTEL_DIR="/usr/lib/llvm/intel"
		PATH="${EPREFIX}${LLVM_INTEL_DIR}/bin"
		ROOTPATH="${EPREFIX}${LLVM_INTEL_DIR}/bin"
		MANPATH="${EPREFIX}${LLVM_INTEL_DIR}/share/man"
		LDPATH="${EPREFIX}${LLVM_INTEL_DIR}/lib:${EPREFIX}${LLVM_INTEL_DIR}/lib64"
	fi

	if use cuda && use openimageio ; then
ewarn "media-libs/openimageio must be built with the same gcc for cuda support."
	fi

	if use cuda && has_version "=dev-util/nvidia-cuda-toolkit-12*" && has_version "=sys-devel/gcc-13*" ; then
		export CC="${CHOST}-gcc-13"
		export CXX="${CHOST}-g++-13"
		export CPP="${CC} -E"
		cuda_host_cc_check 13
	elif use cuda && has_version "=dev-util/nvidia-cuda-toolkit-12*" && has_version "=sys-devel/gcc-12*" ; then
		export CC="${CHOST}-gcc-12"
		export CXX="${CHOST}-g++-12"
		export CPP="${CC} -E"
		cuda_host_cc_check 12
	elif use cuda && has_version "=dev-util/nvidia-cuda-toolkit-12*" && has_version "=sys-devel/gcc-11*" ; then
		export CC="${CHOST}-gcc-11"
		export CXX="${CHOST}-g++-11"
		export CPP="${CC} -E"
		cuda_host_cc_check 11
	elif use cuda && has_version "=dev-util/nvidia-cuda-toolkit-11.8*" && has_version "=sys-devel/gcc-11*" ; then
		export CC="${CHOST}-gcc-11"
		export CXX="${CHOST}-g++-11"
		export CPP="${CC} -E"
		cuda_host_cc_check 11
	elif use cuda ; then
eerror
eerror "If using"
eerror
eerror "CUDA 12 - install and switch via eselect gcc to either gcc 11, 12, 13"
eerror "CUDA 11 - install and switch via eselect gcc to either gcc 11"
eerror
		die
	elif use gcc ; then
		export CC="${CHOST}-gcc"
		export CXX="${CHOST}-g++"
		export CPP="${CC} -E"
		# Prevent lock up
		export MAKEOPTS="-j1"
	elif use clang ; then
		export CC="${CHOST}-clang"
		export CXX="${CHOST}-clang++"
		export CPP="${CC} -E"
	elif use rocm ; then
		rocm_set_default_clang
	else
		export CC=$(tc-getCC)
		export CXX=$(tc-getCXX)
		export CPP=$(tc-getCPP)
	fi

	strip-unsupported-flags
	test-flags-CXX "-std=c++17" 2>/dev/null 1>/dev/null \
                || die "Switch to a c++17 compatible compiler."

	# Prevent possible
	# error: Illegal instruction detected: Operand has incorrect register class.
	replace-flags '-O0' '-O1'

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

einfo "CC:\t${CC}"
einfo "CXX:\t${CXX}"
einfo "CHOST:\t${CHOST}"

	mycmakeargs+=(
		-DCMAKE_CXX_COMPILER="${CXX}"
		-DCMAKE_C_COMPILER="${CC}"
		-DOIDN_APPS=$(usex apps)
		-DOIDN_APPS=$(usex apps)
		-DOIDN_APPS_OPENIMAGEIO=$(usex openimageio)
		-DOIDN_DEVICE_CPU=$(usex cpu)
		-DOIDN_DEVICE_CUDA=$(usex cuda)
		-DOIDN_DEVICE_HIP=$(usex rocm)
		-DOIDN_DEVICE_SYCL=$(usex sycl)
	)

	if use rocm ; then
ewarn
ewarn "All APU + GPU HIP targets on the device must be built/installed to avoid"
ewarn "a crash."
ewarn
		einfo "${ESYSROOT}/usr/lib/llvm/${LLVM_SLOT}"
		mycmakeargs+=(
			-DHIP_COMPILER_PATH="${ESYSROOT}${EROCM_LLVM_PATH}"
		)

		local targets="$(get_amdgpu_flags)"
		mycmakeargs+=(
			-DGPU_TARGETS="${targets}"
		)
einfo "AMDGPU_TARGETS:  ${targets}"
	fi

	if use cuda ; then
		local targets="$(get_cuda_targets)"
einfo "CUDA_TARGETS:  ${targets}"
		if use cuda_targets_sm_80 || use cuda_targets_sm_90 ; then
			:;
		else
			sed -i -e "/cutlass_conv_sm80.cu/d" devices/cuda/CMakeLists.txt || die
		fi
		if use cuda_targets_sm_70 ; then
			sed -i -e "/cutlass_conv_sm70.cu/d" devices/cuda/CMakeLists.txt || die
		fi
		if use cuda_targets_sm_75 ; then
			sed -i -e "/cutlass_conv_sm75.cu/d" devices/cuda/CMakeLists.txt || die
		fi
	fi

	if has_version ">=dev-cpp/tbb-2021:${ONETBB_SLOT}" ; then
		mycmakeargs+=(
			-DTBB_INCLUDE_DIR="${ESYSROOT}/usr/include"
			-DTBB_LIBRARY_DIR="${ESYSROOT}/usr/$(get_libdir)"
			-DTBB_SOVER=$(echo $(basename $(realpath "${ESYSROOT}/usr/$(get_libdir)/libtbb.so")) | cut -f 3 -d ".")
		)
	elif has_version "<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}" ; then
		mycmakeargs+=(
			-DTBB_INCLUDE_DIR="${ESYSROOT}/usr/include/tbb/${LEGACY_TBB_SLOT}"
			-DTBB_LIBRARY_DIR="${ESYSROOT}/usr/$(get_libdir)/tbb/${LEGACY_TBB_SLOT}"
			-DTBB_SOVER="${LEGACY_TBB_SLOT}"
		)
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install
	if ! use doc ; then
		rm -vrf "${ED}/usr/share/doc/oidn-${PV}/readme.pdf" || die
	fi
	use doc && einstalldocs
	docinto licenses
	dodoc \
		LICENSE.txt \
		third-party-programs.txt \
		third-party-programs-oneDNN.txt \
		third-party-programs-oneTBB.txt
	if has_version ">=dev-cpp/tbb-2021:${ONETBB_SLOT}" ; then
		:;
	elif has_version "<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}" ; then
		for f in $(find "${ED}") ; do
			test -L "${f}" && continue
			if ldd "${f}" 2>/dev/null | grep -q -F -e "libtbb" ; then
				einfo "Old rpath for ${f}:"
				patchelf --print-rpath "${f}" || die
				einfo "Setting rpath for ${f}"
				patchelf --set-rpath "${EPREFIX}/usr/$(get_libdir)/tbb/${LEGACY_TBB_SLOT}" \
					"${f}" || die
			fi
		done
	fi

	# Generated when hip is enabled.
	rm -rf "${ED}/var"
}

src_test() {
	"${BUILD_DIR}/oidnTest" || die "There were test faliures!"
}

pkg_postinst() {
	if use rocm ; then
ewarn
ewarn "All APU + GPU HIP targets on the device must be built/installed to avoid"
ewarn "a crash."
ewarn
	fi
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  link-to-multislot-tbb
