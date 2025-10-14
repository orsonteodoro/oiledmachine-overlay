# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"
LLVM_SLOT=19 # Same as llvm-roc
PYTHON_COMPAT=( "python3_12" )
ROCM_CLANG_USEDEP="llvm_targets_AMDGPU,llvm_targets_X86"
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake flag-o-matic python-any-r1 rocm toolchain-funcs

KEYWORDS="~amd64"
S="${WORKDIR}/flang-rocm-${PV}"
SRC_URI="
https://github.com/ROCm-Developer-Tools/flang/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="ROCm's fork of Classic Flang with GPU offload support"
HOMEPAGE="https://github.com/flang-compiler/flang"
LICENSE="
	(
		all-rights-reserved
		Apache-2.0
	)
	Apache-2.0-with-LLVM-exceptions
	CC0-1.0
	UoI-NCSA
"
# all-rights-reserved, Apache-2.0 - flang-rocm-5.6.0/runtime/libpgmath/LICENSE.txt
# The Apache-2.0 license template does not have all rights reserved in the distro
# template but all rights reserved is explicit in Apache-1.0 and BSD licenses.
RESTRICT="
	strip
	test
"
SLOT="0/${ROCM_SLOT}"
IUSE="
doc test ebuild_revision_6
"
REQUIRED_USE="
"
RDEPEND="
	${ROCM_CLANG_DEPEND}
	sys-devel/gcc
	>=sys-libs/llvm-roc-libomp-${PV}:${SLOT}[llvm_targets_AMDGPU,llvm_targets_X86,offload]
	sys-libs/llvm-roc-libomp:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${ROCM_CLANG_DEPEND}
	>=dev-build/cmake-3.9.0
	sys-devel/gcc-config
	doc? (
		app-text/doxygen
		$(python_gen_any_dep '
			dev-python/sphinx[${PYTHON_USEDEP}]
		')
	)
"
PATCHES=(
	"${FILESDIR}/rocm-flang-5.6.0-rt-flang2-no-rule-fix.patch"
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
		-DOPENMP_BUILD_DIR="${ESYSROOT}${EROCM_LLVM_PATH}/$(rocm_get_libdir)"
	)
einfo "GCC major version:  ${gcc_slot}"
	append-flags -I"${ESYSROOT}/usr/lib/gcc/${CHOST}/${gcc_slot}/include"
	append-ldflags -L"${ESYSROOT}/usr/lib/gcc/${CHOST}/${gcc_slot}" -lquadmath
	filter-flags -Wl,--as-needed
	if has "${CHOST%%-*}" aarch64 powerpc64le x86_64 ; then
		:
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
		-DOPENMP_BUILD_DIR="${ESYSROOT}${EROCM_LLVM_PATH}/$(rocm_get_libdir)"
	)
einfo "GCC major version:  ${gcc_slot}"
	append-flags -I"${ESYSROOT}/usr/lib/gcc/${CHOST}/${gcc_slot}/include"
	append-ldflags -L"${ESYSROOT}/usr/lib/gcc/${CHOST}/${gcc_slot}" -lquadmath
	filter-flags -Wl,--as-needed
	if has "${CHOST%%-*}" aarch64 powerpc64le x86_64 ; then
		:
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
	python-any-r1_pkg_setup
	ROCM_USE_LLVM_ROC=1
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
		"${S}/runtime/flang/CMakeLists.txt" # Placeholder
	)
	rocm_src_prepare
}

src_configure() {
	:
}

src_compile() {
	local gcc_slot="${HIP_6_2_GCC_SLOT}"
	gcc_slot="${gcc_slot%%.*}"
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

	local staging_prefix="${PWD}/install"
	declare -A _cmake_generator=(
		["emake"]="Unix Makefiles"
		["ninja"]="Ninja"
	)
	mycmakeargs=(
		-G "${_cmake_generator[${CMAKE_MAKEFILE_GENERATOR}]}"
		-DCMAKE_BUILD_TYPE="Release"
		-DCMAKE_Fortran_COMPILER_ID="Flang"
		-DCMAKE_INSTALL_LIBDIR="$(rocm_get_libdir)"
		-DCMAKE_INSTALL_PREFIX="${staging_prefix}"
		-DENABLE_DEVEL_PACKAGE=OFF
		-DENABLE_RUN_PACKAGE=OFF
		-DPYTHON_EXECUTABLE="${ESYSROOT}/usr/bin/${EPYTHON}"
#		-DPYTHON_VERSION_STRING="${EPYTHON/python}"
	)
	export PATH="${ESYSROOT}${EROCM_LLVM_PATH}/bin:${PATH}"
	export LD_LIBRARY_PATH="${ED}${EROCM_LLVM_PATH}/$(rocm_get_libdir)"
	mycmakeargs+=(
		-DCMAKE_C_COMPILER="${ESYSROOT}${EROCM_LLVM_PATH}/bin/clang-${LLVM_SLOT}"
		-DCMAKE_CXX_COMPILER="${ESYSROOT}${EROCM_LLVM_PATH}/bin/clang++-${LLVM_SLOT}"
		-DCMAKE_Fortran_COMPILER="${ESYSROOT}${EROCM_LLVM_PATH}/bin/flang"
		-DUSE_AAOC=0
	)
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
			:
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

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs test
# OILEDMACHINE-OVERLAY-TEST:  passed (5.7.1, 20240324)
# Testing:
#cat <<EOF > "hello.f90"
#program hello
#  print *, "hello world"
#end program
#EOF
#/usr/lib64/rocm/5.7/bin/flang hello.f90 -L/usr/lib64/rocm/5.7/llvm/lib64 -o hello.exe
#LD_LIBRARY_PATH="/usr/lib64/rocm/5.7/llvm/lib64" ./hello.exe
