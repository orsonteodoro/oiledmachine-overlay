# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"
LLVM_SLOT=19
PYTHON_COMPAT=( "python3_12" )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit check-compiler-switch cmake flag-o-matic python-r1 rocm

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/rocMLIR/"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-rocm-${PV}"
	SRC_URI="
https://github.com/ROCmSoftwarePlatform/rocMLIR/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="MLIR-based convolution and GEMM kernel generator for ROCm"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocMLIR"
LICENSE="
	(
		all-rights-reserved
		Apache-2.0
	)
	(
		all-rights-reserved
		MIT
	)
	Apache-2.0-with-LLVM-exceptions
	BSD
	BSD-2
	CC0-1.0
	custom
	GPL-2+-with-autoconf-exception
	ISC
	LGPL-3+
	MIT
	NCSA-AMD
	rc
	UoI-NCSA
"
# Apache-2.0-with-LLVM-exceptions - mlir/LICENSE.TXT
# Apache-2.0-with-LLVM-exceptions BSD MIT UoI-NCSA - external/llvm-project/pstl/LICENSE.TXT
# Apache-2.0-with-LLVM-exceptions custom MIT UoI-NCSA - external/llvm-project/openmp/LICENSE.TXT
#   custom license keywords:  2. Grant of Patent License
# all-rights-reserved Apache-2.0 external/llvm-project/libcxx/utils/google-benchmark/include/benchmark/benchmark.h
# all-rights-reserved MIT - mlir/tools/rocmlir-lib/LICENSE
# BSD rc - external/llvm-project/llvm/lib/Support/COPYRIGHT.regex
# BSD-2 - external/llvm-project/llvm/include/llvm/Support/xxhash.h
# CC0-1.0 - external/llvm-project/llvm/lib/Support/BLAKE3/LICENSE
# custom - external/llvm-project/clang-tools-extra/clang-tidy/cert/LICENSE.TXT
# GPL-2+-with-autoconf-exception - external/llvm-project/llvm/cmake/config.guess
# ISC - external/llvm-project/lldb/third_party/Python/module/pexpect-4.6/LICENSE
# LGPL-3+ - external/llvm-project/polly/www/video-js/video.js
# NCSA-AMD - external/llvm-project/amd/device-libs/LICENSE.TXT
# The distro Apache-2.0 license template does not have all rights reserved
# The distro MIT license template does not have all rights reserved
SLOT="${ROCM_SLOT}/${PV}"
IUSE="ebuild_revision_16"
RDEPEND="
	${PYTHON_DEPS}
	>=dev-db/sqlite-3:3
	>=dev-python/pybind11-2.8[${PYTHON_USEDEP}]
	media-libs/vulkan-drivers
	media-libs/vulkan-loader
	virtual/libc
	|| (
		(
			~dev-util/hip-${PV}:${SLOT}
			dev-util/hip:=
			~sci-libs/rocBLAS-${PV}:${SLOT}
			sci-libs/rocBLAS:=
		)
		(
			>=dev-util/hip-${PV}:${SLOT}
			dev-util/hip:=
			>=sci-libs/rocBLAS-${PV}:${SLOT}
			sci-libs/rocBLAS:=
		)
	)
"
DEPEND="
	${RDEPEND}
	dev-util/vulkan-headers
"
BDEPEND="
	${PYTHON_DEPS}
	${ROCM_CLANG_DEPEND}
	>=dev-build/cmake-3.15.1
	dev-util/patchelf
	virtual/pkgconfig
"
RESTRICT="test"
PATCHES=(
	"${FILESDIR}/${PN}-5.5.0-fix-so-suffix.patch"
)

ccmake() {
einfo "Running:  cmake ${@}"
	cmake "${@}" || die
}

mmake() {
	if [[ "${CMAKE_MAKEFILE_GENERATOR}" == "ninja" ]] ; then
einfo "Running:  ninja $@"
		eninja "$@"
	else
einfo "Running:  emake $@"
		emake "$@"
	fi
}

pkg_setup() {
	check-compiler-switch_start
	python_setup
	rocm_pkg_setup
}

src_prepare() {
ewarn "Patching may take a long time.  Please wait..."
	sed -i -e "s|LLVM_VERSION_SUFFIX git|LLVM_VERSION_SUFFIX roc|g" \
		"external/llvm-project/llvm/CMakeLists.txt" \
		|| die
	cmake_src_prepare

	rocm_src_prepare

	# Fix for:
	# python3: no python-exec wrapped executable found in /opt/rocm-6.0.2/lib/python-exec.
	python_fix_shebang ./
}

# DO NOT REMOVE/CHANGE
src_configure() { :; }

build_rocmlir() {
	export HIP_PLATFORM="amd"
	SOURCE_DIR="${S}"
	cd "${S}" || die
	mkdir -p "build_rocMLIR" || die
	cd "build_rocMLIR" || die
	declare -A _cmake_generator=(
		["emake"]="Unix Makefiles"
	        ["ninja"]="Ninja"
	)
	local libdir_suffix=$(rocm_get_libdir)
	libdir_suffix="${libdir_suffix/lib}"
	local mycmakeargs=(
		-G "${_cmake_generator[${CMAKE_MAKEFILE_GENERATOR}]}"
		-DBUILD_FAT_LIBROCKCOMPILER=ON # DO NOT CHANGE.  Static produces rocMLIR folder while shared does not.

		-DHIP_COMPILER="clang"
		-DHIP_PLATFORM="amd"
		-DHIP_RUNTIME="rocclr"

		# From additional settings in HEAD
		-DLLVM_ENABLE_ZLIB=OFF
		-DLLVM_ENABLE_ZSTD=OFF

		-DMLIR_INCLUDE_TESTS=OFF
		-DCMAKE_INSTALL_PREFIX="${staging_prefix}/${EPREFIX}/${EROCM_PATH}"

		-DROCMLIR_DRIVER_ENABLED=OFF
		-DLLVM_INSTALL_TOOLCHAIN_ONLY=OFF

		-DELLVM_VERSION_SUFFIX=roc
		# -DMLIR_MAIN_INCLUDE_DIR="${ESYSROOT}/opt/rocm/llvm/include" # Originally this
		-DMLIR_MAIN_INCLUDE_DIR="${ESYSROOT}/${EROCM_LLVM_PATH}/llvm/include"
		#-DLLVM_LIBDIR_SUFFIX="${libdir_suffix}"

		-DLLVM_CMAKE_DIR="${WORKDIR}/${PN}-rocm-${PV}/external/llvm-project"
		-DLIB_INSTALL_DIR="$(rocm_get_libdir)"
	)

	rocm_set_default_clang

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if ! check-compiler-switch_is_system_flavor ; then
einfo "Detected GPU compiler switch.  Disabling LTO."
		filter-lto
	fi

	# Just a precaution.  llvm/clang is broken at -O3.
	replace-flags '-O*' '-O2'

	ccmake \
		"${mycmakeargs[@]}" \
		..
	mmake
	mmake install
}

src_compile() {
	local staging_prefix="${PWD}/install"
	build_rocmlir
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
			:
		else
			chmod 0644 "${path}" || die
		fi
	done
	IFS=$' \t\n'
}

src_install() {
	local staging_prefix="${PWD}/install"
	mv \
		"${staging_prefix}/"* \
		"${ED}" \
		|| die
	sanitize_permissions
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs test
