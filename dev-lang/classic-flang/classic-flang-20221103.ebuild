# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Cuda compatibility:
# https://github.com/flang-compiler/classic-flang-llvm-project/blob/release_16x/clang/include/clang/Basic/Cuda.h
# https://github.com/flang-compiler/classic-flang-llvm-project/blob/llvmorg-15.0.3/clang/include/clang/Basic/Cuda.h#L37

CUDA_TARGETS_COMPAT=(
	sm_35
	sm_37
	sm_50
	sm_52
	sm_53
	sm_60
	sm_61
	sm_62
	sm_70
	sm_72
	sm_75
	sm_80
	sm_86
	sm_89
	sm_90
	auto
)
CMAKE_MAKEFILE_GENERATOR="emake"
EGIT_CLASSIC_FLANG_LLVM_PROJECT_COMMIT="5c04f282bab1b2e24c3eccab15fe9ff6be7c8f62"
EGIT_CLASSIC_FLANG_LLVM_PROJECT_LLVM_PV="16.0.4" # See https://github.com/flang-compiler/classic-flang-llvm-project/blob/release_16x/llvm/CMakeLists.txt#L18
LLVM_MAX_SLOT=16 # Same as classic-flang-llvm-project llvm version
PYTHON_COMPAT=( python3_{10..11} )

inherit cmake llvm python-any-r1

SRC_URI="
https://github.com/flang-compiler/flang/archive/refs/tags/flang_${PV}.tar.gz
	-> classic-flang-${PV}.tar.gz
https://github.com/flang-compiler/classic-flang-llvm-project/archive/${EGIT_CLASSIC_FLANG_LLVM_PROJECT_COMMIT}.tar.gz
	-> classic-flang-llvm-project-${EGIT_CLASSIC_FLANG_LLVM_PROJECT_COMMIT:0:7}.tar.gz
https://github.com/flang-compiler/flang/pull/1381/commits/05a1be6663f43caad40e982c8501c6b6ea2ece27.patch
	-> flang-pr1381-05a1be6.patch
"
# 05a1be6 - [LLVM16][flang1] Suppress -Wsingle-bit-bitfield-constant-conversion warnings
#   Fixes:
#   tools/flang1/flang1exe/commopt.c:389:23: error: implicit truncation from 'int' to a one-bit wide bit-field changes value from 1 to -1 [-Werror,-Wsingle-bit-bitfield-constant-conversion]
#          FT_FUSED(nd1) = 1;
#                        ^ ~

DESCRIPTION="Flang is a Fortran language front-end designed for integration \
with LLVM."
HOMEPAGE="https://github.com/flang-compiler/flang"
THIRD_PARTY_LICENSES="
	(
		all-rights-reserved
		Apache-2.0
	)
	(
		Apache-2.0
		CC0-1.0
	)
	(
		Apache-2.0-with-LLVM-exceptions
		BSD
		MIT
	)
	(
		Apache-2.0-with-LLVM-exceptions
		custom
		MIT
		UoI-NCSA
	)
	(
		Apache-2.0-with-LLVM-exceptions
		UoI-NCSA
	)
	Apache-2.0
	BSD
	ISC
	MIT
"
LICENSE="
	${THIRD_PARTY_LICENSES}
	Apache-2.0-with-LLVM-exceptions
"
# all-rights-reserved Apache-2.0 - flang-flang_20221103/runtime/libpgmath/LICENSE.txt
# The Apache-2.0 license template does not have all rights reserved in the distro
# template but all rights reserved is explicit in Apache-1.0 and BSD licenses.
# Apache-2.0 - classic-flang-llvm-project/third-party/benchmark/LICENSE
# Apache-2.0-with-LLVM-exceptions, UoI-NCSA - classic-flang-llvm-project/lldb/LICENSE.TXT
# Apache-2.0-with-LLVM-exceptions, BSD, MIT - classic-flang-llvm-project/libclc/LICENSE.TXT
# Apache-2.0-with-LLVM-exceptions, UoI-NCSA, MIT, custom  - classic-flang-llvm-project/openmp/LICENSE.TXT
#   Keywords:  "all right, title, and interest"
# BSD - classic-flang-llvm-project/third-party/unittest/googlemock/LICENSE.txt
# CC0-1.0, Apache-2.0 - classic-flang-llvm-project/llvm/lib/Support/BLAKE3/LICENSE
# ISC - classic-flang-llvm-project/lldb/third_party/Python/module/pexpect-4.6/LICENSE
# MIT - classic-flang-llvm-project/llvm/test/YAMLParser/LICENSE.txt
KEYWORDS="~arm64 ~amd64 ~ppc64"
SLOT="${LLVM_MAX_SLOT}/${EGIT_CLASSIC_FLANG_LLVM_PROJECT_LLVM_PV}"
LLVM_TARGETS_CPU_COMPAT=(
	llvm_targets_AArch64
	llvm_targets_PowerPC
	llvm_targets_X86
)
LLVM_TARGETS_GPU_COMPAT=(
	llvm_targets_NVPTX
)
IUSE="
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${LLVM_TARGETS_CPU_COMPAT[@]}
${LLVM_TARGETS_GPU_COMPAT[@]}
cuda doc offload test
"
gen_cuda_required_use() {
	local x
	for x in ${CUDA_TARGETS_COMPAT[@]} ; do
		echo "
			cuda_targets_${x}? (
				llvm_targets_NVPTX
			)
		"
	done
}
REQUIRED_USE="
	$(gen_cuda_required_use)
	arm64? (
		llvm_targets_AArch64
	)
	amd64? (
		llvm_targets_X86
	)
	cuda? (
		llvm_targets_NVPTX
	)
	offload? (
		cuda
		llvm_targets_NVPTX
	)
	llvm_targets_NVPTX? (
		offload
		cuda
		|| (
			${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
		)
	)
	ppc64? (
		llvm_targets_PowerPC
	)
	^^ (
		${LLVM_TARGETS_CPU_COMPAT[@]}
	)
"
RDEPEND="
	cuda_targets_sm_35? (
		=dev-util/nvidia-cuda-toolkit-11*:=
	)
	cuda_targets_sm_37? (
		=dev-util/nvidia-cuda-toolkit-11*:=
	)
	cuda_targets_sm_50? (
		|| (
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_52? (
		|| (
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_53? (
		|| (
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_60? (
		|| (
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_61? (
		|| (
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_62? (
		|| (
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_70? (
		|| (
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_72? (
		|| (
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_75? (
		|| (
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_80? (
		|| (
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_86? (
		|| (
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_89? (
		|| (
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
	)
	cuda_targets_sm_90? (
		|| (
			=dev-util/nvidia-cuda-toolkit-11.8*:=
		)
	)
	llvm_targets_NVPTX? (
		<dev-util/nvidia-cuda-toolkit-11.9:=
	)
	offload? (
		dev-libs/libffi:=
		virtual/libelf:=
		cuda? (
			=dev-util/nvidia-cuda-toolkit-11.8*:=
		)
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/cmake-3.9.0
	offload? (
		virtual/pkgconfig
	)
	doc? (
		app-text/doxygen
		$(python_gen_any_dep '
			dev-python/sphinx[${PYTHON_USEDEP}]
		')
	)
"
S="${WORKDIR}/flang-flang_${PV}"
S_LLVM="${WORKDIR}/classic-flang-llvm-project-${EGIT_CLASSIC_FLANG_LLVM_PROJECT_COMMIT}"
PATCHES=(
	"${DISTDIR}/flang-pr1381-05a1be6.patch"
)

gen_nvptx_list() {
	if use cuda_targets_auto ; then
		echo "auto"
	else
		local list
		local x
		for x in ${CUDA_TARGETS_COMPAT[@]} ; do
			if use "cuda_targets_${x}" ; then
				list+=";${x/sm_}"
			fi
		done
		list="${list:1}"
		echo "${list}"
	fi
}

build_llvm() {
einfo "Building LLVM"
	cd "${S_LLVM}" || die
	mkdir -p build || die
	cd build || die
	local experimental_targets
	if use amd64 ; then
		experimental_targets=";X86"
	fi
	if use arm64 ; then
		experimental_targets=";AArch64"
	fi
	if use ppc64 ; then
		experimental_targets=";PowerPC"
	fi
	if use llvm_targets_NVPTX ; then
		experimental_targets+=";NVPTX"
	fi
	experimental_targets="${experimental_targets:1}"
	local mycmakeargs_=(
		${mycmakeargs[@]}
		-DCMAKE_C_COMPILER="${CHOST}-gcc"
		-DCMAKE_CXX_COMPILER="${CHOST}-g++"
		-DLLVM_ENABLE_CLASSIC_FLANG=ON
		-DLLVM_ENABLE_PROJECTS="clang;openmp"
		-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD="${experimental_targets}"
		-DLLVM_TARGETS_TO_BUILD=""
		-DOPENMP_ENABLE_LIBOMPTARGET=$(usex offload ON OFF)
	)
	if use offload && has "${CHOST%%-*}" aarch64 powerpc64le x86_64 ; then
		mycmakeargs_+=(
			-DLIBOMPTARGET_BUILD_AMDGPU_PLUGIN=OFF
			-DLIBOMPTARGET_BUILD_CUDA_PLUGIN=$(usex cuda ON OFF)
			-DOPENMP_ENABLE_LIBOMPTARGET=ON
		)
		if use llvm_targets_NVPTX ; then
			mycmakeargs_+=(
				-DLIBOMPTARGET_NVPTX_COMPUTE_CAPABILITIES=$(gen_nvptx_list)
			)
		fi
		if use ppc64 && ( use llvm_targets_NVPTX ) ; then
			if ! [[ "${CHOST}" =~ "powerpc64le" ]] ; then
eerror
eerror "Big endian is not supported for ppc64 for offload.  Disable either the"
eerror "offload, llvm_targets_NVPTX USE flag(s) to continue."
eerror
				die
			fi
		fi
	else
		mycmakeargs_+=(
			-DCMAKE_DISABLE_FIND_PACKAGE_CUDA=ON
			-DLIBOMPTARGET_BUILD_AMDGPU_PLUGIN=OFF
			-DLIBOMPTARGET_BUILD_CUDA_PLUGIN=OFF
			-DOPENMP_ENABLE_LIBOMPTARGET=OFF
		)
	fi
	ccmake \
		${mycmakeargs_[@]} \
		../llvm
	emake
	emake install
}

build_libpgmath() {
einfo "Building libpgmath"
	cd "${S}/runtime/libpgmath" || die
	mkdir -p build || die
	cd build || die
	ccmake \
		${mycmakeargs[@]} \
		..
	emake
	emake install
}

ccmake() {
einfo "Running:  cmake ${@}"
	cmake "${@}" || die
}

build_flang() {
einfo "Building flang"
	cd "${S}" || die
	mkdir -p build || die
	cd build || die
	local mycmakeargs_=(
		${mycmakeargs[@]}
		-DFLANG_LLVM_EXTENSIONS=ON
		-DFLANG_INCLUDE_DOCS=$(usex doc ON OFF)
		-DLLVM_ENABLE_DOXYGEN=$(usex doc ON OFF)
	)
	if use offload && has "${CHOST%%-*}" aarch64 powerpc64le x86_64 ; then
		mycmakeargs_+=(
			-DFLANG_OPENMP_GPU_NVIDIA=$(usex cuda ON OFF)
		)
	else
		mycmakeargs_+=(
			-DFLANG_OPENMP_GPU_NVIDIA=OFF
		)
	fi
	ccmake \
		${mycmakeargs_[@]} \
		..
	emake
	emake install
}

pkg_setup() {
	llvm_pkg_setup
	python-any-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	# Removed in >= 16.0.0-rc1
	sed -i -e "s|\"--src-root\"||g" \
		"${S}/CMakeLists.txt" \
		|| die
}

src_configure() {
ewarn
ewarn "This is \"Classic Flang\"."
ewarn "For \"LLVM Flang\", see dev-lang/llvm-flang."
ewarn
	# Removed all clangs from path except for this vendored one.
	einfo "LLVM_SLOT=${LLVM_SLOT}"
	einfo "PATH=${PATH} (before)"
	export PATH=$(echo "${PATH}" \
		| tr ":" "\n" \
		| sed -E -e "/llvm\/[0-9]+/d" \
		| tr "\n" ":" \
		| sed -e "s|/opt/bin|/opt/bin:${PWD}/install/bin|g")
	einfo "PATH=${PATH} (after)"
}

src_compile() {
	local staging_prefix="${PWD}/install"
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE="Release"
		-DCMAKE_C_COMPILER="${staging_prefix}/bin/clang"
		-DCMAKE_CXX_COMPILER="${staging_prefix}/bin/clang++"
		-DCMAKE_Fortran_COMPILER="${staging_prefix}/bin/flang"
		-DCMAKE_Fortran_COMPILER_ID="Flang"
		-DCMAKE_INSTALL_PREFIX="${staging_prefix}"
	)
	build_llvm
	build_libpgmath
	build_flang
}

hello_world_test() {
	local staging_prefix="${PWD}/install"
cat <<EOF > "${T}/hello.f90" || die
program hello
  print *, "hello world"
end program
EOF
	"${staging_prefix}/bin/flang" \
		"${T}/hello.f90" \
		-o "${T}/hello.exe" \
		|| die
	LD_LIBRARY_PATH="${staging_prefix}/lib:${LD_LIBRARY_PATH}" \
	"${T}/hello.exe" || die
}

src_test() {
	hello_world_test
}

fix_file_permissions() {
	local path
einfo "Fixing file/folder permissions"
	IFS=$'\n'
	for path in $(find "${ED}") ; do
		chown root:root "${path}" || die
		if file "${path}" | grep -q -e "directory" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "ELF .* shared object" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "ELF .* executable" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "symbolic link" ; then
			:;
		elif file "${path}" | grep -q -e "Python script" ; then
			chmod 0755 "${path}" || die
		elif [[ "${path}" =~ \.sh$ ]] ; then
			chmod 0755 "${path}" || die
		else
			chmod 0644 "${path}" || die
		fi
	done
	IFS=$' \t\n'
}

src_install() {
	local staging_prefix="${PWD}/install"
	local dest="/usr/lib/classic-flang/${LLVM_MAX_SLOT}"
	insinto "${dest}"
	doins -r "${staging_prefix}/"*
	fix_file_permissions
	dosym \
		"/usr/lib/classic-flang/${LLVM_MAX_SLOT}/bin/flang" \
		"/usr/bin/classic-flang-${LLVM_MAX_SLOT}"
}

pkg_postinst() {
einfo "Switching ${EROOT}/usr/bin/flang-${LLVM_MAX_SLOT} -> ${EROOT}/usr/bin/flang"
	ln -sf \
		"${EROOT}/usr/bin/classic-flang-${LLVM_MAX_SLOT}" \
		"${EROOT}/usr/bin/flang"
ewarn
ewarn "You must use LD_LIBRARY_PATH or rpath changes to run the output created"
ewarn "by flang."
ewarn
ewarn "Example:"
ewarn
ewarn "  LD_LIBRARY_PATH=\"${EPREFIX}/usr/lib/classic-flang/${LLVM_MAX_SLOT}/lib\" ./hello.exe"
ewarn
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
