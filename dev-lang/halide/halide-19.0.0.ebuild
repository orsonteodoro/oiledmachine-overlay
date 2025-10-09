# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="Halide"

CFLAGS_HARDENED_BUILDFILES_SANITIZERS="asan tsan"
CFLAGS_HARDENED_USE_CASES="jit"
CMAKE_MAKEFILE_GENERATOR="emake"
FLATBUFFERS_PV="23.5.26"
inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX17[@]}
)
GTEST_COMMIT="703bd9caab50b139428cea1aaff9974ebee5742e"
LLVM_COMPAT=( {20..17} )
MUNIT_COMMIT="da8f73412998e4f1adf1100dc187533a51af77fd"
PICOSHA2_COMMIT="27fcf6979298949e8a462e16d09a0351c18fcaf2"
PYBIND11_PV="2.10.4"
PLY_COMMIT="d776a2ece6c12bf8f8b6a0e65b48546ac6078765"
PYTHON_COMPAT=( "python3_"{10..12} )
SIMDE_COMMIT="71fd833d9666141edcd1d3c109a80e228303d8d7"
UVWASI_COMMIT="55eff19f4c7e69ec151424a037f951e0ad006ed6"
VULKAN_HEADERS_PV="1.3.296"
WASM_C_API_COMMIT="b6dd1fb658a282c64b029867845bc50ae59e1497"
WABT_PV="1.0.36"
WEBASSEMBLY_TESTSUITE_COMMIT="f3f048661dc1686d556a27d522df901cb747ab4a"

inherit cmake-multilib dep-prepare libstdcxx-slot llvm multilib-build python-single-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/halide/Halide.git"
	FALLBACK_COMMIT="ac2fc94af3edf97a8aca6ef68a5e8c53c1be0844" # Dec 16, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm64 ~arm64-macos ~ppc64 ~riscv ~x86-macos"
	S="${WORKDIR}/${MY_PN}-${PV}"
	SRC_URI="
https://github.com/dabeaz/ply/archive/${PLY_COMMIT}.tar.gz
	-> ply-${PLY_COMMIT:0:7}.tar.gz
https://github.com/google/flatbuffers/archive/refs/tags/v${FLATBUFFERS_PV}.tar.gz
	-> flatbuffers-${FLATBUFFERS_PV}.tar.gz
https://github.com/google/googletest/archive/${GTEST_COMMIT}.tar.gz
	-> gtest-${GTEST_COMMIT:0:7}.tar.gz
https://github.com/halide/Halide/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/nemequ/munit/archive/${MUNIT_COMMIT}.tar.gz
	-> munit-${MUNIT_COMMIT:0:7}.tar.gz
https://github.com/nodejs/uvwasi/archive/${UVWASI_COMMIT}.tar.gz
	-> uvwasi-${UVWASI_COMMIT:0:7}.tar.gz
https://github.com/okdshin/PicoSHA2/archive/${PICOSHA2_COMMIT}.tar.gz
	-> picosha2-${PICOSHA2_COMMIT:0:7}.tar.gz
https://github.com/pybind/pybind11/archive/refs/tags/v${PYBIND11_PV}.tar.gz
	-> pybind11-${PYBIND11_PV}.tar.gz
https://github.com/simd-everywhere/simde/archive/${SIMDE_COMMIT}.tar.gz
	-> simde-${SIMDE_COMMIT:0:7}.tar.gz
https://github.com/WebAssembly/testsuite/archive/${WEBASSEMBLY_TESTSUITE_COMMIT}.tar.gz
	-> WebAssembly-testsuite-${WEBASSEMBLY_TESTSUITE_COMMIT:0:7}.tar.gz
https://github.com/WebAssembly/wabt/archive/refs/tags/${WABT_PV}.tar.gz
	-> wabt-${WABT_PV}.tar.gz
https://github.com/WebAssembly/wasm-c-api/archive/${WASM_C_API_COMMIT}.tar.gz
	-> wasm-c-api-${WASM_C_API_COMMIT:0:7}.tar.gz
	"
fi

DESCRIPTION="A language for fast, portable data-parallel computation"
HOMEPAGE="
	https://github.com/halide/Halide
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
# Upstream makes USE=serialization default ON but OFF here to avoid verson sensitive flatbuffers
IUSE+="
${LLVM_COMPAT[@]/#/llvm_slot_}
cuda -doc +serialization tutorials +python test +utils +wabt
ebuild_revision_2
"
REQUIRED_USE="
	python? (
		${PYTHON_REQUIRED_USE}
	)
	^^ (
		${LLVM_COMPAT[@]/#/llvm_slot_}
	)
"
gen_llvm_rdepend() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				llvm-core/clang:${s}[${LIBSTDCXX_USEDEP},llvm_targets_WebAssembly,llvm_targets_X86]
				llvm-core/clang:=
				llvm-core/lld:${s}[${LIBSTDCXX_USEDEP},llvm_targets_WebAssembly,llvm_targets_X86]
				llvm-core/lld:=
				llvm-core/llvm:${s}[${LIBSTDCXX_USEDEP},llvm_targets_WebAssembly,llvm_targets_X86]
				llvm-core/llvm:=
				llvm-runtimes/compiler-rt:${s}
				arm? (
					llvm-core/clang:${s}[llvm_targets_ARM]
					llvm-core/lld:${s}[llvm_targets_ARM]
					llvm-core/llvm:${s}[llvm_targets_ARM]
				)
				arm64? (
					llvm-core/clang:${s}[llvm_targets_AArch64]
					llvm-core/lld:${s}[llvm_targets_AArch64]
					llvm-core/llvm:${s}[llvm_targets_AArch64]
				)
				cuda? (
					llvm-core/clang:${s}[llvm_targets_NVPTX]
					llvm-core/lld:${s}[llvm_targets_NVPTX]
					llvm-core/llvm:${s}[llvm_targets_NVPTX]
				)
				ppc64? (
					llvm-core/clang:${s}[llvm_targets_PowerPC]
					llvm-core/lld:${s}[llvm_targets_PowerPC]
					llvm-core/llvm:${s}[llvm_targets_PowerPC]
				)
				riscv? (
					llvm-core/clang:${s}[llvm_targets_RISCV]
					llvm-core/lld:${s}[llvm_targets_RISCV]
					llvm-core/llvm:${s}[llvm_targets_RISCV]
				)
			)
		"
	done
}
RDEPEND+="
	$(python_gen_cond_dep '
		dev-python/pybind11[${PYTHON_USEDEP}]
		python? (
			>=dev-python/pybind11-2.10.4[${PYTHON_USEDEP}]
			>=dev-python/scikit-build-core-0.10.5[${PYTHON_USEDEP}]
			>=dev-python/setuptools-43[${PYTHON_USEDEP}]
			>=dev-util/tbump-6.11.0[${PYTHON_USEDEP}]
			dev-python/build[${PYTHON_USEDEP}]
			dev-python/imageio[${PYTHON_USEDEP}]
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/scipy[${PYTHON_USEDEP}]
			dev-python/wheel[${PYTHON_USEDEP}]
			virtual/pillow[${PYTHON_USEDEP}]
		)
	')
	>=media-libs/vulkan-loader-${VULKAN_HEADERS_PV}
	media-libs/vulkan-drivers
	serialization? (
		>=dev-libs/flatbuffers-23.5.26[${LIBSTDCXX_USEDEP}]
		dev-libs/flatbuffers:=
	)
"
DEPEND+="
	${RDEPEND}
	>=dev-util/vulkan-headers-${VULKAN_HEADERS_PV}
"
BDEPEND+="
	>=dev-build/cmake-3.28
	doc? (
		app-text/doxygen
	)
"
DOCS=( "README.md" )
PATCHES=(
	"${FILESDIR}/${PN}-19.0.0-install-paths.patch"
	"${FILESDIR}/${PN}-19.0.0-fetchcontent-always-find_package.patch"
)

pkg_setup() {
einfo "PATH=${PATH} (before)"
	export PATH=$(echo "${PATH}" \
		| tr ":" "\n" \
		| sed -E -e "/llvm\/[0-9]+/d" \
		| tr "\n" ":" \
		| sed -e "s|/opt/bin|/opt/bin:${ESYSROOT}/usr/lib/llvm/${LLVM_SLOT}/bin|g")
einfo "PATH=${PATH} (after)"
	python-single-r1_pkg_setup
	libstdcxx-slot_verify
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
		mkdir -p "${S}/cmake/external"
		dep_prepare_mv "${WORKDIR}/flatbuffers-${FLATBUFFERS_PV}" "${S}/cmake/external/flatbuffers"

		dep_prepare_mv "${WORKDIR}/pybind11-${PYBIND11_PV}" "${S}/cmake/external/pybind11"

		dep_prepare_mv "${WORKDIR}/wabt-${WABT_PV}" "${S}/cmake/external/wabt"
		dep_prepare_mv "${WORKDIR}/googletest-${GTEST_COMMIT}" "${S}/cmake/external/wabt/third_party/gtest"
		dep_prepare_mv "${WORKDIR}/PicoSHA2-${PICOSHA2_COMMIT}" "${S}/cmake/external/wabt/third_party/picosha2"
		dep_prepare_mv "${WORKDIR}/ply-${PLY_COMMIT}" "${S}/cmake/external/wabt/third_party/ply"

		dep_prepare_mv "${WORKDIR}/simde-${SIMDE_COMMIT}" "${S}/cmake/external/wabt/third_party/simde"
		dep_prepare_mv "${WORKDIR}/munit-${MUNIT_COMMIT}" "${S}/cmake/external/wabt/third_party/simde/test/munit"

		dep_prepare_mv "${WORKDIR}/testsuite-${WEBASSEMBLY_TESTSUITE_COMMIT}" "${S}/cmake/external/wabt/third_party/testsuite"
		dep_prepare_mv "${WORKDIR}/uvwasi-${UVWASI_COMMIT}" "${S}/cmake/external/wabt/third_party/uvwasi"
		dep_prepare_mv "${WORKDIR}/wasm-c-api-${WASM_C_API_COMMIT}" "${S}/cmake/external/wabt/third_party/wasm-c-api"
	fi
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="$(get_libdir)"
		-DFETCHCONTENT_SOURCE_DIR_FLATBUFFERS="${S}/cmake/external/flatbuffers"
		-DFETCHCONTENT_SOURCE_DIR_PYBIND11="${S}/cmake/external/pybind11"
		-DFETCHCONTENT_SOURCE_DIR_WABT="${S}/cmake/external/wabt"
		-DHalide_INSTALL_PYTHONDIR="/usr/lib/${EPYTHON}/site-packages/halide"
		-DPYTHON_EXECUTABLE="${EPYTHON}"
		-DPython_EXECUTABLE="${EPYTHON}"
		-DWITH_AUTOSCHEDULERS=ON
		-DWITH_DOCS=$(usex doc)
		-DWITH_PACKAGING=ON
		-DWITH_PYTHON_BINDINGS=$(multilib_native_usex python)
		-DWITH_SERIALIZATION=$(usex serialization)
		-DWITH_SERIALIZATION_JIT_ROUNDTRIP_TESTING=$(usex test $(usex serialization) OFF)
		-DWITH_TESTS=$(usex test)
		-DWITH_TUTORIALS=$(usex tutorials)
		-DWITH_UTILS=$(usex utils)
		-DWITH_WABT=OFF
	)

	if use wabt ; then
		mycmakeargs+=(
			-DHalide_WASM_BACKEND="wabt"
			-DWITH_WABT=ON
		)
	else
		mycmakeargs+=(
			-DHalide_WASM_BACKEND="OFF"
			-DWITH_WABT=OFF
		)
	fi

	cmake-multilib_src_configure
}

src_install() {
	cmake-multilib_src_install
	docinto "licenses"
	dodoc "LICENSE.txt"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
