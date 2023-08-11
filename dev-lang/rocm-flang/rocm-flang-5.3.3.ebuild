# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Cuda compatibility:
# https://github.com/flang-compiler/classic-flang-llvm-project/blob/release_16x/clang/include/clang/Basic/Cuda.h
# https://github.com/flang-compiler/classic-flang-llvm-project/blob/llvmorg-15.0.3/clang/include/clang/Basic/Cuda.h#L37

AMDGPU_TARGETS_COMPAT=(
	gfx700
	gfx701
	gfx801
	gfx803
	gfx900
	gfx902
	gfx906
	gfx908
	gfx90a
	gfx90c
	gfx940
	gfx1010
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

inherit cmake llvm python-any-r1 rocm

SRC_URI="
https://github.com/ROCm-Developer-Tools/flang/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/RadeonOpenCompute/llvm-project/archive/refs/tags/rocm-${PV}.tar.gz
	-> llvm-project-rocm-${PV}.tar.gz
"
DESCRIPTION="ROCm's fork of Flang."
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
	(
		BSD
		ZLIB
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
# all-rights-reserved, Apache-2.0 - flang-rocm-5.6.0/runtime/libpgmath/LICENSE.txt
# The Apache-2.0 license template does not have all rights reserved in the distro
# template but all rights reserved is explicit in Apache-1.0 and BSD licenses.
# Apache-2.0 - llvm-project-rocm-5.6.0/third-party/benchmark/LICENSE
# Apache-2.0-with-LLVM-exceptions, UoI-NCSA - llvm-project-rocm-5.6.0/lldb/LICENSE.TXT
# Apache-2.0-with-LLVM-exceptions, BSD, MIT - llvm-project-rocm-5.6.0/libclc/LICENSE.TXT
# Apache-2.0-with-LLVM-exceptions, UoI-NCSA, MIT, custom - llvm-project-rocm-5.6.0/openmp/LICENSE.TXT
#   Keyword search:  "all right, title, and interest"
# BSD - llvm-project-rocm-5.6.0/third-party/unittest/googlemock/LICENSE.txt
# BSD - llvm-project-rocm-5.6.0/openmp/runtime/src/thirdparty/ittnotify/LICENSE.txt
# CC0-1.0, Apache-2.0 - llvm-project-rocm-5.6.0/llvm/lib/Support/BLAKE3/LICENSE
# ISC - llvm-project-rocm-5.6.0/lldb/third_party/Python/module/pexpect-4.6/LICENSE
# MIT - llvm-project-rocm-5.6.0/polly/lib/External/isl/LICENSE
# ZLIB, BSD - llvm-project-rocm-5.6.0/llvm/lib/Support/COPYRIGHT.regex
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2 ${PV})"
LLVM_TARGETS_COMPAT=(
	llvm_targets_AMDGPU
	llvm_targets_NVPTX
)
IUSE="
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${ROCM_IUSE}
${LLVM_TARGETS_COMPAT[@]}
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
gen_rocm_required_use() {
	local x
	for x in ${AMDGPU_TARGETS_COMPAT[@]} ; do
		echo "
			amdgpu_targets_${x}? (
				llvm_targets_AMDGPU
			)
		"
	done
}
REQUIRED_USE="
	$(gen_cuda_required_use)
	$(gen_rocm_required_use)
	cuda? (
		llvm_targets_NVPTX
	)
	llvm_targets_AMDGPU? (
		${ROCM_REQUIRED_USE}
	)
	llvm_targets_NVPTX? (
		cuda
		|| (
			${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
		)
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
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/cmake-3.9.0
	offload? (
		virtual/pkgconfig
	)
	doc? (
		app-doc/doxygen
		$(python_gen_any_dep '
			dev-python/sphinx[${PYTHON_USEDEP}]
		')
	)
"
S="${WORKDIR}/flang-rocm-${PV}"
S_LLVM="${WORKDIR}/llvm-project-rocm-${PV}"
PATCHES=(
)

gen_nvptx_list() {
	if use cuda_targets_auto ; then
		echo "auto"
	else
		local list
		local x
		for x in ${CUDA_TARGETS_COMPAT[@]} ; do
			if use "${x}" ; then
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
	local experimental_targets=";X86"
	if use llvm_targets_AMDGPU ; then
		experimental_targets+=";AMDGPU"
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
			-DLIBOMPTARGET_BUILD_AMDGPU_PLUGIN=$(usex llvm_targets_AMDGPU)
			-DLIBOMPTARGET_BUILD_CUDA_PLUGIN=$(usex llvm_targets_NVPTX)
			-DOPENMP_ENABLE_LIBOMPTARGET=ON
		)
		if use llvm_targets_NVPTX ; then
			mycmakeargs_+=(
				-DLIBOMPTARGET_NVPTX_COMPUTE_CAPABILITIES=$(gen_nvptx_list)
			)
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
		-DFLANG_INCLUDE_DOCS=$(usex doc ON oFF)
		-DLLVM_ENABLE_DOXYGEN=$(usex doc ON oFF)
	)
	if use offload && has "${CHOST%%-*}" aarch64 powerpc64le x86_64 ; then
		mycmakeargs_+=(
			-DFLANG_OPENMP_GPU_NVIDIA=$(usex cuda \
				$(usex offload ON OFF) \
				OFF \
			)
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
	python_setup
}

src_prepare() {
	cmake_src_prepare
	# Removed in >= 16.0.0-rc1
	sed -i -e "s|\"--src-root\"||g" \
		"${S}/CMakeLists.txt" \
		|| die
}

src_configure() {
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
	"${T}/hello.exe" || die
}

src_test() {
	hello_world_test
}

fix_file_permissions() {
	local path
einfo "Sanitizing file/folder permissions"
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
	local dest="/usr/lib/rocm-flang"
	insinto "${dest}"
	doins -r "${staging_prefix}/"*
	fix_file_permissions
	dosym \
		/usr/lib/rocm-flang/bin/flang \
		/usr/bin/rocm-flang
}

pkg_postinst() {
einfo "Switching /usr/bin/rocm-flang -> /usr/bin/flang"
	ln -sf \
		/usr/bin/rocm-flang \
		/usr/bin/flang
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
