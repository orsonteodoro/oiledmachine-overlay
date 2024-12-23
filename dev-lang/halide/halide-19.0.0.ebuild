# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="Halide"

LLVM_COMPAT=( {20..17} )
PYTHON_COMPAT=( "python3_"{10..12} )

inherit cmake-multilib llvm python-r1 pypi

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
https://github.com/halide/Halide/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
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
cuda -doc -serialization tutorials +python test +utils
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
				llvm-core/clang:${s}[llvm_targets_WebAssembly,llvm_targets_X86]
				llvm-core/lld:${s}[llvm_targets_WebAssembly,llvm_targets_X86]
				llvm-core/llvm:${s}[llvm_targets_WebAssembly,llvm_targets_X86]
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
	dev-python/pybind11[${PYTHON_USEDEP}]
	python? (
		${PYTHON_DEPS}
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
	serialization? (
		>=dev-libs/flatbuffers-23.5.26
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	>=dev-build/cmake-3.28
	doc? (
		app-text/doxygen
	)
"
DOCS=( "README.md" )

pkg_setup() {
einfo "PATH=${PATH} (before)"
	export PATH=$(echo "${PATH}" \
		| tr ":" "\n" \
		| sed -E -e "/llvm\/[0-9]+/d" \
		| tr "\n" ":" \
		| sed -e "s|/opt/bin|/opt/bin:${ESYSROOT}/usr/lib/llvm/${LLVM_SLOT}/bin|g")
einfo "PATH=${PATH} (after)"
	python_setup
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_configure() {
	local mycmakeargs=(
		-DHalide_WASM_BACKEND="OFF"
		-DWITH_AUTOSCHEDULERS=ON
		-DWITH_DOCS=$(usex doc)
		-DWITH_PACKAGING=OFF
		-DWITH_PYTHON_BINDINGS=$(multilib_native_use python)
		-DWITH_SERIALIZATION=$(usex serialization)
		-DWITH_SERIALIZATION_JIT_ROUNDTRIP_TESTING=$(usex test $(usex serialization) OFF)
		-DWITH_TESTS=$(usex test)
		-DWITH_TUTORIALS=$(usex tutorials)
		-DWITH_UTILS=$(usex utils)
		-DWITH_WABT=OFF
	)
	cmake-multilib_src_configure
}

src_install() {
	cmake-multilib_src_install
	docinto "licenses"
	dodoc "LICENSE.txt"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
