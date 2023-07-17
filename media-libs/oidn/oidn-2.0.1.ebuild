# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE=Release
PYTHON_COMPAT=( python3_{10..11} )

inherit cmake flag-o-matic llvm python-single-r1 toolchain-funcs

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
COMPOSABLE_KERNEL_COMMIT="e85178b4ca892a78344271ae64103c9d4d1bfc40"
CUTLASS_COMMIT="66d9cddc832c1cdc2b30a8755274f7f74640cfe6"
MKL_DNN_COMMIT="9bea36e6b8e341953f922ce5c6f5dbaca9179a86"
OIDN_WEIGHTS_COMMIT="4322c25e25a05584f65da1a4be5cef40a4b2e90b"
ORG_GH="https://github.com/OpenImageDenoise"
# SSE4.1 hardware was released in 2008.
# See scripts/build.py for release versioning.
# Clang is more smoother multitask-wise.
ROCM_VERSION="5.5.0"
MIN_CLANG_PV="3.3"
MIN_GCC_PV="4.8.1"
ONETBB_SLOT="0"
LEGACY_TBB_SLOT="2"
SLOT="0/$(ver_cut 1-2 ${PV})"
LLVM_SLOTS=( 16 15 14 13 12 11 10 )
AMD_GPU_TARGETS=(
	gfx1030
	gfx1031
	gfx1100
	gfx1101
	gfx1102
)
IUSE+="
${LLVM_SLOTS[@]/#/llvm-}
${AMD_GPU_TARGETS[@]/#/amdgpu_targets_}
+apps +built-in-weights +clang cpu cuda custom-tc doc gcc hip openimageio
video_cards_nvidia
"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
	cuda? (
		video_cards_nvidia
	)
	hip? (
		|| (
			${AMD_GPU_TARGETS[@]/#/amdgpu_targets_}
		)
	)
	^^ (
		${LLVM_SLOTS[@]/#/llvm-}
	)
	^^ (
		clang
		gcc
	)
"
gen_clang_depends() {
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
			llvm-${s}? (
				=sys-devel/clang-runtime-${s}*
				>=sys-libs/libcxx-${s}
				sys-devel/clang:${s}
				sys-devel/llvm:${s}
				sys-devel/lld:${s}
			)
		"
	done
}

# See https://github.com/OpenImageDenoise/oidn/blob/v1.4.3/scripts/build.py
gen_ispc_depends() {
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
			llvm-${s}? (
				>=dev-lang/ispc-1.17.0[llvm-${s}]
			)
		"
	done
}

HIP_VERSIONS=(
	"5.5.1"
	"5.5.0"
) # 5.3.0 fails
gen_hip_depends() {
	local hip_version
	for hip_version in ${HIP_VERSIONS[@]} ; do
		# Needed because of build failures
		echo "
			(
			~dev-libs/rocm-comgr-${hip_version}
			~dev-libs/rocm-device-libs-${hip_version}
			~dev-libs/rocm-comgr-${hip_version}
			~dev-libs/rocr-runtime-${hip_version}
			~dev-libs/roct-thunk-interface-${hip_version}
			~dev-util/hip-${hip_version}
			~dev-util/rocminfo-${hip_version}
			)
		"
	done
}

RDEPEND+="
	${PYTHON_DEPS}
	virtual/libc
	hip? (
		|| (
			$(gen_hip_depends)
		)
	)
	video_cards_nvidia? (
		>=x11-drivers/nvidia-drivers-520.61.05
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
	$(gen_ispc_depends)
	${PYTHON_DEPS}
	>=dev-util/cmake-3.15
	hip? (
		>=dev-util/cmake-3.21
		|| (
			$(gen_hip_depends)
		)
	)
	video_cards_nvidia? (
		>=dev-util/nvidia-cuda-toolkit-11.8
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
RESTRICT="mirror"
DOCS=( CHANGELOG.md README.md readme.pdf )
PATCHES=(
	"${FILESDIR}/${PN}-1.4.1-findtbb-print-paths.patch"
	"${FILESDIR}/${PN}-1.4.1-findtbb-alt-lib-path.patch"
	"${FILESDIR}/${PN}-2.0.1-hip-buildfiles-changes.patch"
	"${FILESDIR}/${PN}-2.0.1-set-rocm-path.patch"
)

pkg_setup() {
	if [[ "${CHOST}" == "${CBUILD}" ]] && use kernel_linux ; then
		if [[ ! -e "${BROOT}/proc/cpuinfo" ]] ; then
ewarn
ewarn "Cannot find ${BROOT}/proc/cpuinfo.  Skipping CPU flag check."
ewarn
		elif ! grep -F -e "sse4_1" "${BROOT}/proc/cpuinfo" ; then
ewarn
ewarn "You need SSE4.1 to use this product."
ewarn
		fi
	fi

	if tc-is-clang || use clang ; then
		local s
		for s in ${LLVM_SLOTS[@]} ; do
			if use llvm-${s} ; then
				LLVM_MAX_SLOT=${s}
				llvm_pkg_setup
				break
			fi
		done
	fi

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

src_configure() {
	mycmakeargs=()

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
		-DOIDN_DEVICE_HIP=$(usex hip)
		-DOIDN_DEVICE_SYCL=OFF # no packages
	)

	if use hip ; then
		local llvm_slot=$(cat "/usr/$(get_libdir)/cmake/hip/hip-config.cmake" \
			| grep "/usr/lib/llvm" \
			| grep -E -o -e  "[0-9]+")
		einfo "${ESYSROOT}/usr/lib/llvm/${llvm_slot}"
		export CC="${CHOST}-clang-${llvm_slot}"
		export CXX="${CHOST}-clang++-${llvm_slot}"
		use llvm-${llvm_slot} || die "llvm-${llvm_slot} required for hip"
		mycmakeargs+=(
			-DHIP_COMPILER_PATH="${ESYSROOT}/usr/lib/llvm/${llvm_slot}"
		)
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

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  link-to-multislot-tbb
