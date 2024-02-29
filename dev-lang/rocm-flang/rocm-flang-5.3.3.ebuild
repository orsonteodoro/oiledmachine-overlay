# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AOCC_SLOT=16
CMAKE_MAKEFILE_GENERATOR="emake"
LLVM_MAX_SLOT=15 # Same as llvm-roc
PYTHON_COMPAT=( python3_{10..11} )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake flag-o-matic llvm python-any-r1 rocm toolchain-funcs

SRC_URI="
https://github.com/ROCm-Developer-Tools/flang/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
"
DESCRIPTION="ROCm's fork of Classic Flang with GPU offload support"
HOMEPAGE="https://github.com/flang-compiler/flang"
THIRD_PARTY_LICENSES="
	(
		all-rights-reserved
		Apache-2.0
	)
"
LICENSE="
	${THIRD_PARTY_LICENSES}
	Apache-2.0-with-LLVM-exceptions
"
# all-rights-reserved, Apache-2.0 - flang-rocm-5.6.0/runtime/libpgmath/LICENSE.txt
# The Apache-2.0 license template does not have all rights reserved in the distro
# template but all rights reserved is explicit in Apache-1.0 and BSD licenses.
KEYWORDS="~amd64"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
aocc doc test r2
"
REQUIRED_USE="
"
RDEPEND="
	!dev-lang/rocm-flang:0
	dev-util/rocm-compiler[-system-llvm]
	sys-devel/gcc
	~sys-devel/llvm-roc-${PV}:${ROCM_SLOT}[llvm_targets_AMDGPU,llvm_targets_X86]
	~sys-libs/llvm-roc-libomp-${PV}:${ROCM_SLOT}[llvm_targets_AMDGPU,llvm_targets_X86,offload]
	aocc? (
		sys-devel/aocc:${AOCC_SLOT}
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/cmake-3.9.0
	sys-devel/gcc-config
	doc? (
		app-text/doxygen
		$(python_gen_any_dep '
			dev-python/sphinx[${PYTHON_USEDEP}]
		')
	)
"
RESTRICT="
	test
"
S="${WORKDIR}/flang-rocm-${PV}"
PATCHES=(
	"${FILESDIR}/rocm-flang-5.6.0-rt-flang2-no-rule-fix.patch"
	"${FILESDIR}/rocm-flang-5.3.3-path-changes.patch"
)

fmake() {
	if [[ "${CMAKE_MAKEFILE_GENERATOR}" == "ninja" ]] ; then
einfo "Running:  ninja $@"
		eninja "$@"
	else
einfo "Running:  emake $@"
		emake "$@"
	fi
}

ccmake() {
einfo "Running:  cmake ${@}"
	cmake "${@}" || die
}

build_libpgmath() {
einfo "Building libpgmath"
	cd "${S}/runtime/libpgmath" || die
	mkdir -p build || die
	cd build || die
	ccmake \
		"${mycmakeargs[@]}" \
		..
	fmake
	fmake install
}

# Produces flang1, flang2, libflangADT.a, libflangArgParser.a, omp_lib.h
build_flang_lib() {
einfo "Building Flang lib"
	cd "${S}" || die
	mkdir -p build || die
	cd build || die
	local mycmakeargs_=(
		"${mycmakeargs[@]}"
		-DFLANG_LLVM_EXTENSIONS=OFF
		-DFLANG_INCLUDE_DOCS=$(usex doc ON OFF)
		-DLIBQUADMATH_LOC="${ESYSROOT}/usr/lib/gcc/${CHOST}/${gcc_slot}/libquadmath.so"
		-DLLVM_ENABLE_DOXYGEN=$(usex doc ON OFF)
		-DLLVM_INSTALL_RUNTIME=OFF
		-DOPENMP_BUILD_DIR="${ESYSROOT}${EROCM_LLVM_PATH}/$(get_libdir)"
	)
einfo "GCC major version:  ${gcc_slot}"
	append-flags -I"${ESYSROOT}/usr/lib/gcc/${CHOST}/${gcc_slot}/include"
	append-ldflags -L"${ESYSROOT}/usr/lib/gcc/${CHOST}/${gcc_slot}" -lquadmath
	filter-flags -Wl,--as-needed
	if has "${CHOST%%-*}" aarch64 powerpc64le x86_64 ; then
		:;
	else
eerror
eerror "64-bit only supported."
eerror
		die
	fi
	mycmakeargs_+=(
# OMP_OFFLOAD_AMD is nested in OMP_OFFLOAD_LLVM for target_ast
# Fixes:
# semsmp.c:(.text.begin_combine_constructs+0x1d): undefined reference to `get_omp_combined_mode'
		-DFLANG_OPENMP_GPU_AMD=ON
		-DFLANG_OPENMP_GPU_NVIDIA=ON
	)
	ccmake \
		"${mycmakeargs_[@]}" \
		..
	fmake
	fmake install
}

# Should produce flangrti, flangmain for flang frontend
build_flang_rt() {
einfo "Building Flang runtime"
	cd "${S}" || die
	mkdir -p build || die
	cd build || die
# Setting -DFLANG_LLVM_EXTENSIONS=ON causes:
# /var/tmp/portage/dev-lang/rocm-flang-5.6.0/temp/gather_cmplx32-0b0f56.ll:409:7: error: expected metadata type
# !14 = !DIFortranSubrange(constLowerBound: 1, upperBound: !12, upperBoundExpression: !13)
#       ^
	local mycmakeargs_=(
		"${mycmakeargs[@]}"
		-DFLANG_LLVM_EXTENSIONS=OFF
		-DFLANG_INCLUDE_DOCS=$(usex doc ON OFF)
		-DLIBQUADMATH_LOC="${ESYSROOT}/usr/lib/gcc/${CHOST}/${gcc_slot}/libquadmath.so"
		-DLLVM_ENABLE_DOXYGEN=$(usex doc ON OFF)
		-DLLVM_INSTALL_RUNTIME=ON
		-DOPENMP_BUILD_DIR="${ESYSROOT}${EROCM_LLVM_PATH}/$(get_libdir)"
	)
einfo "GCC major version:  ${gcc_slot}"
	append-flags -I"${ESYSROOT}/usr/lib/gcc/${CHOST}/${gcc_slot}/include"
	append-ldflags -L"${ESYSROOT}/usr/lib/gcc/${CHOST}/${gcc_slot}" -lquadmath
	filter-flags -Wl,--as-needed
	if has "${CHOST%%-*}" aarch64 powerpc64le x86_64 ; then
		:;
	else
eerror
eerror "64-bit only supported."
eerror
		die
	fi
	mycmakeargs_+=(
# OMP_OFFLOAD_AMD is nested in OMP_OFFLOAD_LLVM for target_ast
		-DFLANG_OPENMP_GPU_AMD=ON
		-DFLANG_OPENMP_GPU_NVIDIA=ON
	)
	ccmake \
		"${mycmakeargs_[@]}" \
		..
	fmake
	fmake install
}

pkg_setup() {
	llvm_pkg_setup
	python_setup
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	# Removed in >= 16.0.0-rc1
	sed -i -e "s|\"--src-root\"||g" \
		"${S}/CMakeLists.txt" \
		|| die
	# Speed up symbol replacmenet for @...@ by reducing the search space
	# Generated from below one liner ran in the same folder as this file:
	# grep -F -r -e "+++" | cut -f 2 -d " " | cut -f 1 -d $'\t' | sort | uniq | cut -f 2- -d $'/' | sort | uniq
	PATCH_PATHS=(
		"${S}/CMakeLists.txt"
		"${S}/flang-legacy/CMakeLists.txt"
		"${S}/runtime/flang/CMakeLists.txt"
		"${S}/runtime/flangrti/CMakeLists.txt"
		"${S}/runtime/libpgmath/CMakeLists.txt"
		"${S}/runtime/libpgmath/cmake/modules/HandleOutOfTreeLLVM.cmake"
		"${S}/runtime/libpgmath/lib/CMakeLists.txt"
	)
	rocm_src_prepare
}

src_configure() {
	# Removed all clangs except for one used for building.
	local compiler_path=""
	if use aocc ; then
		compiler_path="${ESYSROOT}/opt/aocc/${AOCC_SLOT}/bin"
	else
		compiler_path="${ESYSROOT}${EROCM_LLVM_PATH}/bin"
	fi
	einfo "LLVM_SLOT=${LLVM_SLOT}"
	einfo "PATH=${PATH} (before)"
	export PATH=$(echo "${PATH}" \
		| tr ":" "\n" \
		| sed -E -e "/llvm\/[0-9]+/d" \
		| tr "\n" ":" \
		| sed -e "s|/opt/bin|/opt/bin:${PWD}/install/bin:${compiler_path}|g")
	einfo "PATH=${PATH} (after)"
}

src_compile() {
	local gcc_slot=$(gcc-major-version)
	local gcc_current_profile=$(gcc-config -c)
	local gcc_current_profile_slot=${gcc_current_profile##*-}
	if [[ "${gcc_current_profile_slot}" != "${gcc_slot}" ]] ; then
eerror
eerror "libquadmath must be ${gcc_slot}.  Do"
eerror
eerror "  eselect gcc set ${CHOST}-${gcc_slot}"
eerror "  source /etc/profile"
eerror
eerror "libquadmath slot:   ${gcc_current_profile_slot}"
eerror "GCC compiler slot:  ${gcc_slot}"
eerror
		die
	fi

	append-flags -Wno-incompatible-function-pointer-types # Same as 8ff4926 061a0fc

	local staging_prefix="${PWD}/install"
	declare -A _cmake_generator=(
		["emake"]="Unix Makefiles"
		["ninja"]="Ninja"
	)
	mycmakeargs=(
		-G "${_cmake_generator[${CMAKE_MAKEFILE_GENERATOR}]}"
		-DCMAKE_BUILD_TYPE="Release"
		-DCMAKE_Fortran_COMPILER_ID="Flang"
		-DCMAKE_INSTALL_LIBDIR="$(get_libdir)"
		-DCMAKE_INSTALL_PREFIX="${staging_prefix}"
		-DENABLE_DEVEL_PACKAGE=OFF
		-DENABLE_RUN_PACKAGE=OFF
	)
	if use aocc ; then
		export PATH="${ESYSROOT}/opt/aocc/${AOCC_SLOT}/bin:${PATH}"
		export LD_LIBRARY_PATH="${ED}${EROCM_LLVM_PATH}/lib"
		mycmakeargs+=(
			-DCMAKE_C_COMPILER="${ESYSROOT}/opt/aocc/${AOCC_SLOT}/bin/clang"
			-DCMAKE_CXX_COMPILER="${ESYSROOT}/opt/aocc/${AOCC_SLOT}/bin/clang++"
			-DCMAKE_Fortran_COMPILER="${ESYSROOT}/opt/aocc/${AOCC_SLOT}/bin/flang"
			-DUSE_AAOC=1
		)
	else
		export PATH="${ESYSROOT}${EROCM_LLVM_PATH}/bin:${PATH}"
		export LD_LIBRARY_PATH="${ED}${EROCM_LLVM_PATH}/$(get_libdir)"
		mycmakeargs+=(
			-DCMAKE_C_COMPILER="${ESYSROOT}${EROCM_LLVM_PATH}/bin/clang"
			-DCMAKE_CXX_COMPILER="${ESYSROOT}${EROCM_LLVM_PATH}/bin/clang++"
			-DCMAKE_Fortran_COMPILER="${ESYSROOT}${EROCM_LLVM_PATH}/bin/flang"
			-DUSE_AAOC=0
		)
	fi
	export VERBOSE=1
	build_libpgmath
	build_flang_lib
	build_flang_rt
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
	local dest="${EROCM_LLVM_PATH}"
	insinto "${dest}"
	doins -r "${staging_prefix}/"*
	fix_file_permissions
	# Flang symlink frontend is already installed by sys-devel/llvm-roc.
	dosym \
		"${EROCM_LLVM_PATH}/bin/flang" \
		"${EROCM_PATH}/bin/flang"
	rocm_fix_rpath
}

pkg_postinst() {
einfo "Switching ${EROOT}/usr/bin/rocm-flang -> ${EROOT}/usr/bin/flang"
	ln -sf \
		"${EROOT}${EROCM_LLVM_PATH}/bin/flang" \
		"${EROOT}/usr/bin/flang"
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
