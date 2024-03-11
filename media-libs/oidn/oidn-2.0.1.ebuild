# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# SSE4.1 hardware was released in 2008.
# See scripts/build.py for release versioning.
# Clang is more smoother multitask-wise.

AMDGPU_TARGETS_COMPAT=(
	gfx1030
	gfx1031
	gfx1032
#	gfx1033
	gfx1034
	gfx1035
#	gfx1036
	gfx1100
	gfx1101
	gfx1102
#	gfx1103
)
CMAKE_BUILD_TYPE=Release
CUDA_TARGETS_COMPAT=(
	sm_70
	sm_75
	sm_80
	sm_90
)
HIP_VERSIONS=(
	"5.5.1"
	"5.6.1"
) # 5.3.0 fails
ROCM_SLOTS=(
	rocm_5_5
	rocm_5_6
)
LEGACY_TBB_SLOT="2"
LLVM_COMPAT=( {16..10} )
LLVM_MAX_SLOT="${LLVM_COMPAT[0]}"
MIN_CLANG_PV="3.3"
MIN_GCC_PV="4.8.1"
ONETBB_SLOT="0"
PYTHON_COMPAT=( python3_{10..11} )
ROCM_VERSION="5.5.1"

inherit cmake cuda flag-o-matic llvm python-single-r1 rocm toolchain-funcs

COMPOSABLE_KERNEL_COMMIT="e85178b4ca892a78344271ae64103c9d4d1bfc40"
CUTLASS_COMMIT="66d9cddc832c1cdc2b30a8755274f7f74640cfe6"
MKL_DNN_COMMIT="9bea36e6b8e341953f922ce5c6f5dbaca9179a86"
OIDN_WEIGHTS_COMMIT="4322c25e25a05584f65da1a4be5cef40a4b2e90b"
ORG_GH="https://github.com/OpenImageDenoise"

if [[ ${PV} = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${ORG_GH}/oidn.git"
	EGIT_BRANCH="master"
else
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

DESCRIPTION="Intel(R) Open Image Denoise library"
HOMEPAGE="http://www.openimagedenoise.org/"
KEYWORDS="~amd64"
LICENSE="
	Apache-2.0
	BSD
	MIT
"
# MIT - composable_kernel
# BSD - cutlass
# MKL_DNN is oneDNN 2.2.4 with additional custom commits.
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${LLVM_COMPAT[@]/#/llvm_slot_}
${ROCM_SLOTS[@]}
+apps +built-in-weights +clang cpu cuda doc gcc openimageio rocm sycl
r1
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
	cuda? (
		|| (
			${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
		)
	)
	rocm? (
		${ROCM_REQUIRED_USE}
		llvm_slot_16
		|| (
			${ROCM_SLOTS[@]}
		)
	)
	^^ (
		${LLVM_COMPAT[@]/#/llvm_slot_}
	)
	^^ (
		clang
		gcc
	)
"
gen_clang_depends() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				=sys-devel/clang-runtime-${s}*
				sys-devel/clang:${s}
				sys-devel/llvm:${s}
				sys-devel/lld:${s}
			)
		"
	done
}
gen_hip_depends() {
	local hip_version
	for hip_version in ${HIP_VERSIONS[@]} ; do
		# Needed because of build failures
		local s=$(ver_cut 1-2 ${hip_version})
		echo "
			(
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
		|| (
			$(gen_hip_depends)
		)
		dev-util/hip:=[rocm]
	)
	sycl? (
		>=sys-devel/DPC++-2022.12.15:0/6
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
"
BDEPEND+="
	${PYTHON_DEPS}
	>=dev-lang/ispc-1.17.0
	>=dev-build/cmake-3.15
	cuda? (
		>=dev-util/nvidia-cuda-toolkit-11.8
	)
	rocm? (
		>=dev-build/cmake-3.21
		|| (
			$(gen_hip_depends)
		)
	)
	|| (
		clang? (
			$(gen_clang_depends)
		)
		gcc? (
			>=sys-devel/gcc-${MIN_GCC_PV}
		)
	)
"
RESTRICT="mirror"
DOCS=( CHANGELOG.md README.md readme.pdf )
PATCHES=(
	"${FILESDIR}/${PN}-1.4.1-findtbb-print-paths.patch"
	"${FILESDIR}/${PN}-1.4.1-findtbb-alt-lib-path.patch"
	"${FILESDIR}/${PN}-2.0.1-hip-buildfiles-changes.patch"
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
	if [[ "${CHOST}" == "${CBUILD}" ]] && use kernel_linux ; then
		use cpu && check_cpu
	fi

	if use rocm_5_6 ; then
		ROCM_SLOT="5.6"
		LLVM_MAX_SLOT=16
	elif use rocm_5_5 ; then
		ROCM_SLOT="5.5"
		LLVM_MAX_SLOT=16
	fi

	if tc-is-clang || use clang ; then
		llvm_pkg_setup
	fi

	if use rocm ; then
		rocm_pkg_setup
	fi

	# This needs to be placed here to avoid this error:
	# python: no python-exec wrapped executable found in /usr/lib64/rocm/5.5/lib/python-exec.
	python-single-r1_pkg_setup
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
	pushd "${S}/external/composable_kernel" || die
		eapply "${FILESDIR}/composable_kernel-1.0.0_p9999-fix-missing-libstdcxx-expf.patch"
	popd
	use cuda && cuda_src_prepare
	rocm_src_prepare
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

src_configure() {
	mycmakeargs=()

	if use sycl ; then
		local LLVM_INTEL_DIR="/usr/lib/llvm/intel"
		PATH="${EPREFIX}${LLVM_INTEL_DIR}/bin"
		ROOTPATH="${EPREFIX}${LLVM_INTEL_DIR}/bin"
		MANPATH="${EPREFIX}${LLVM_INTEL_DIR}/share/man"
		LDPATH="${EPREFIX}${LLVM_INTEL_DIR}/lib:${EPREFIX}${LLVM_INTEL_DIR}/lib64"
	fi

	if use gcc ; then
		export CC="${CHOST}-gcc"
		export CXX="${CHOST}-g++"
		# Prevent lock up
		export MAKEOPTS="-j1"
	elif use clang ; then
		export CC="${CHOST}-clang"
		export CXX="${CHOST}-clang++"
	else
		export CC=$(tc-getCC)
		export CXX=$(tc-getCXX)
	fi

	strip-unsupported-flags
	test-flags-CXX "-std=c++17" 2>/dev/null 1>/dev/null \
                || die "Switch to a c++17 compatible compiler."

	# Prevent possible
	# error: Illegal instruction detected: Operand has incorrect register class.
	replace-flags '-O0' '-O1'

einfo
einfo "CC:\t${CC}"
einfo "CXX:\t${CXX}"
einfo "CHOST:\t${CHOST}"
einfo

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
		einfo "${ESYSROOT}/usr/lib/llvm/${LLVM_MAX_SLOT}"
		if has_version "dev-util/hip[system-llvm]" ; then
			export CC="${CHOST}-clang-${LLVM_MAX_SLOT}"
			export CXX="${CHOST}-clang++-${LLVM_MAX_SLOT}"
		else
			export CC="clang"
			export CXX="clang++"
		fi
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

pkg_postinst() {
	if use rocm ; then
ewarn
ewarn "All APU + GPU HIP targets on the device must be built/installed to avoid"
ewarn "a crash."
ewarn
	fi
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  link-to-multislot-tbb
