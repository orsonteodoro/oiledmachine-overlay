# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=15
PYTHON_COMPAT=( python3_{10..11} )

inherit cmake llvm python-r1 rocm

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/rocMLIR/"
	inherit git-r3
else
	SRC_URI="
https://github.com/ROCmSoftwarePlatform/rocMLIR/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-rocm-${PV}"
fi

DESCRIPTION="MLIR-based convolution and GEMM kernel generator for ROCm"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocMLIR"
LICENSE="
	Apache-2.0-with-LLVM-exceptions
	MIT
"
# Apache-2.0-with-LLVM-exceptions - mlir/LICENSE.TXT
# all rights reserved with MIT - mlir/tools/rocmlir-lib/LICENSE
# The distro MIT license template does not have all rights reserved
SLOT="0/$(ver_cut 1-2)"
IUSE="r4"
RDEPEND="
	${PYTHON_DEPS}
	>=dev-db/sqlite-3:3
	>=dev-python/pybind11-2.8[${PYTHON_USEDEP}]
	media-libs/vulkan-loader
	~dev-util/hip-${PV}:${SLOT}
"
DEPEND="
	${RDEPEND}
	dev-util/vulkan-headers
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-util/cmake-3.15.1
	dev-util/patchelf
	virtual/pkgconfig
"
RESTRICT="test"
PATCHES=(
	"${FILESDIR}/${PN}-5.3.3-path-changes.patch"
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
	python_setup
	rocm_pkg_setup
}

src_prepare() {
	sed -i -e "s|LLVM_VERSION_SUFFIX git|LLVM_VERSION_SUFFIX roc|g" \
		external/llvm-project/llvm/CMakeLists.txt \
		|| die
	cmake_src_prepare

        IFS=$'\n'
        sed \
                -i \
                -e "s|/lib64)|/@LIBDIR@)|g" \
                -e "s|BINARY_DIR}/lib/|BINARY_DIR}/@LIBDIR@/|g" \
                -e "s|BINARY_DIR}/lib64/|BINARY_DIR}/@LIBDIR@/|g" \
                -e "s|DESTINATION lib/|DESTINATION @LIBDIR@/|g" \
                -e "s|DESTINATION lib64/|DESTINATION @LIBDIR@/|g" \
		-e "s|INSTALL_PATH}/lib$|INSTALL_PATH}/@LIBDIR@$|g" \
                $(find . \
			\( \
				   -name "CMakeLists.txt" \
				-o -name "*.cmake" \
			\) \
		) \
                || true
        sed \
                -i \
		-e "s|/lib)|/@LIBDIR@)|g" \
                $(find . \
			\( \
				\( \
					   -name "CMakeLists.txt" \
					-o -name "*.cmake" \
				\) \
				-a -not -path "*/external/llvm-project/clang-tools-extra/include-cleaner/unittests/CMakeLists.txt" \
			\) \
		) \
                || true
        IFS=$' \t\n'

	rocm_src_prepare
}

# DO NOT REMOVE/CHANGE
src_configure() { :; }

build_rocmlir() {
	# FIXME:  The unislot conflicts with the multislot rocm-llvm
	export ROCM_PATH="${ESYSROOT}/usr"
	export HIP_CLANG_PATH=$(get_llvm_prefix ${LLVM_SLOT})"/bin"
	export HIP_PLATFORM="amd"
	SOURCE_DIR="${S}"
	cd "${S}" || die
	mkdir -p "build_rocMLIR" || die
	cd "build_rocMLIR" || die
	declare -A _cmake_generator=(
		["emake"]="Unix Makefiles"
	        ["ninja"]="Ninja"
	)
	local libdir_suffix=$(get_libdir)
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
		-DCMAKE_INSTALL_PREFIX="${staging_prefix}/${EPREFIX}/usr"

		-DROCMLIR_DRIVER_ENABLED=OFF
		-DLLVM_INSTALL_TOOLCHAIN_ONLY=OFF

		-DELLVM_VERSION_SUFFIX=roc
		-DMLIR_MAIN_INCLUDE_DIR="${ESYSROOT}/opt/rocm-${PV}/llvm/include"
		-DLLVM_LIBDIR_SUFFIX="${libdir_suffix}"
	)
	export CXX="${HIP_CXX:-clang++}"
	ccmake \
		"${mycmakeargs[@]}" \
		..
	mmake
	mmake install
}

src_compile() {
	# Removed all clangs
	einfo "LLVM_SLOT=${LLVM_SLOT}"
	einfo "PATH=${PATH} (before)"
	export PATH=$(echo "${PATH}" \
		| tr ":" "\n" \
		| sed -E -e "/llvm\/[0-9]+/d" \
		| tr "\n" ":" \
		| sed -e "s|/opt/bin|/opt/bin:${PWD}/install/bin|g")
	einfo "PATH=${PATH} (after)"

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
			:;
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
	cd "${ED}/usr" || die
	sanitize_permissions
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
