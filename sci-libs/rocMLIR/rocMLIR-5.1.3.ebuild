# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO:
# backport 5.5.0 patches to _LLVM_SYSTEM_PATCHES set after use-system-mlir

LLVM_MAX_SLOT=14
PYTHON_COMPAT=( python3_{10..11} )

inherit cmake llvm python-r1

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
IUSE="-system-mlir"
RDEPEND="
	${PYTHON_DEPS}
	>=dev-db/sqlite-3:3
	>=dev-python/pybind11-2.6[${PYTHON_USEDEP}]
	media-libs/vulkan-loader
	system-mlir? (
		sys-devel/llvm:${LLVM_MAX_SLOT}[llvm_targets_AMDGPU]
		sys-devel/mlir:${LLVM_MAX_SLOT}[llvm_targets_AMDGPU]
	)
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
	system-mlir? (
		sys-devel/clang:${LLVM_MAX_SLOT}
		sys-devel/llvm:${LLVM_MAX_SLOT}
		sys-devel/mlir:${LLVM_MAX_SLOT}[llvm_targets_AMDGPU]
	)
"
RESTRICT="test"
_LLVM_VENDORED_PATCHES=(
	"${FILESDIR}/rocMLIR-5.5.0-fix-sover.patch"
	"${FILESDIR}/rocMLIR-5.1.3-fix-install.patch"
	"${FILESDIR}/rocMLIR-5.5.0-rpath-to-vendored-llvm.patch"
)
_LLVM_SYSTEM_PATCHES=(
	"${FILESDIR}/rocMLIR-5.1.3-fix-bin-linking.patch"
	"${FILESDIR}/rocMLIR-5.5.0-fix-sover-and-rpath.patch"
	"${FILESDIR}/rocMLIR-5.1.3-use-system-mlir.patch"
)

pkg_setup() {
	python_setup
}

src_prepare() {
	if use system-mlir ;then
ewarn "USE=system-mlir is unfinished.  USE=-system-mlir instead."
		sed -i -e "s|LLVM_VERSION_SUFFIX git|LLVM_VERSION_SUFFIX|g" \
			external/llvm-project/llvm/CMakeLists.txt \
			|| die
		rm -rf external || die
		eapply ${_LLVM_SYSTEM_PATCHES[@]}
	else
		eapply ${_LLVM_VENDORED_PATCHES[@]}
		sed -i -e "s|LLVM_VERSION_SUFFIX git|LLVM_VERSION_SUFFIX roc|g" \
			external/llvm-project/llvm/CMakeLists.txt \
			|| die
	fi
	cmake_src_prepare
}

src_configure() {
	# FIXME:  The unislot conflicts with the multislot rocm-llvm
	export ROCM_PATH="${ESYSROOT}/usr"
	export HIP_PLATFORM="amd"
	local mycmakeargs=(
		-DELLVM_VERSION_MAJOR=${LLVM_MAX_SLOT}
		-DELLVM_VERSION_MINOR=0
		-DELLVM_VERSION_PATCH=0

		-DHIP_COMPILER="clang"
		-DHIP_PLATFORM="amd"
		-DHIP_RUNTIME="rocclr"

		# From additional settings in HEAD
		-DLLVM_ENABLE_ZLIB=OFF
		-DLLVM_ENABLE_ZSTD=OFF

		-DMLIR_BINARY_DIR="${WORKDIR}/mlir_build"

		-DMLIR_INCLUDE_TESTS=OFF

		-DROCMLIR_DRIVER_ENABLED=OFF
	)
	if use system-mlir ; then
		mycmakeargs+=(
			-DELLVM_VERSION_SUFFIX=
			-DLLVM_CMAKE_DIR="${ESYSROOT}/usr/lib/llvm/${LLVM_MAX_SLOT}/$(get_libdir)/cmake/llvm"
			-DMLIR_CMAKE_DIR="${ESYSROOT}/usr/lib/llvm/${LLVM_MAX_SLOT}/$(get_libdir)/cmake/mlir"
			-DMLIR_MAIN_INCLUDE_DIR="${ESYSROOT}/usr/lib/llvm/${LLVM_MAX_SLOT}/include"
		)
	else
		mycmakeargs+=(
			-DELLVM_VERSION_SUFFIX=roc
			-DLLVM_CMAKE_DIR="${ESYSROOT}/opt/rocm-${PV}/llvm/$(get_libdir)/cmake/llvm"
			-DMLIR_CMAKE_DIR="${ESYSROOT}/opt/rocm-${PV}/llvm/$(get_libdir)/cmake/mlir"
			-DMLIR_MAIN_INCLUDE_DIR="${ESYSROOT}/opt/rocm-${PV}/llvm/include"
		)
	fi
	if [[ "${HIP_CXX}" =~ "g++" ]] ; then
ewarn "Using clang may result in symbol error."
	fi
	CXX="${HIP_CXX:-g++}"
	cmake_src_configure
}

src_install() {
	cmake_src_install
	IFS=$'\n'
	if ! use system-mlir ; then
	# It turns out the vendored copy of the llvm tree in this ebuild is not
	# the same as the ~sys-devel/llvm-roc-${PV}:${PV} tarball.
		local src
		local dest
		src="${BUILD_DIR}/external/llvm-project/llvm/lib"
		dest="/usr/$(get_libdir)/${PN}/$(get_libdir)"
		dodir "${dest}"
		cp -aT \
			"${src}" \
			"${ED}/${dest}" \
			|| die

		src="${BUILD_DIR}/external/llvm-project/llvm/bin"
		dest="/usr/$(get_libdir)/${PN}/bin"
		dodir "${dest}"
		cp -aT \
			"${src}" \
			"${ED}/${dest}" \
			|| die

		src="${BUILD_DIR}/external/llvm-project/llvm/include"
		dest="/usr/$(get_libdir)/${PN}/include"
		dodir "${dest}"
		cp -aT \
			"${src}" \
			"${ED}/${dest}" \
			|| die

		find "${ED}" \
			\( \
				-name "cmake_install.cmake" \
				-o -name "*.d" \
				-o -name "*.o" \
			\) \
			-delete
		local tries
		for tries in $(seq 1 5) ; do
			find "${ED}" -type d -empty -delete
		done

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

		# The build scripts mess up the rpath
		local rpath_path="${EPREFIX}/usr/$(get_libdir)/rocMLIR/$(get_libdir)"
		for path in $(find "${ED}" -type f) ; do
			if file "${path}" \
				| grep -q -E -e "ELF.*(shared object|executable)" ; then
einfo "Changing RPATH for ${path}"
				patchelf \
					--set-rpath "${rpath_path}" \
					"${path}" \
					|| die
			fi
		done

	fi
	IFS=$' \t\n'
}

# OILEDMACHINE-OVERLAY-STATUS:  build-failure
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
