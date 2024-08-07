# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( "python3_"{10..12} )

inherit dep-prepare cmake flag-o-matic

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/triton-lang/triton.git"
	FALLBACK_COMMIT="da40a1e984bf57c4708daf603eb427442025f99b" # Aug 31, 2023
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${P}"
	SRC_URI="
https://github.com/triton-lang/triton/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Development repository for the Triton language and compiler"
HOMEPAGE="
	https://triton-lang.org/
	https://github.com/triton-lang/triton
"
LICENSE="
	MIT
"
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
LLVM_COMPAT=( {13,12} ) # Build time failure with LLVM 14, LLVM 11 untested.
ROCM_SLOTS=(
	rocm_4_5
	rocm_4_1
)
LLVM_TARGETS=(
	AMDGPU
	NVPTX
)
IUSE+="
${LLVM_COMPAT[@]/#/llvm_slot_}
${ROCM_SLOTS[@]}
${LLVM_TARGETS[@]/#/llvm_targets_}
rocm
"
gen_rocm_required_use() {
	local u
	for u in ${ROCM_SLOTS[@]} ; do
		echo "
			${u}? (
				rocm
			)
		"
	done
}
REQUIRED_USE="
	!rocm? (
		^^ (
			${LLVM_COMPAT[@]/#/llvm_slot_}
		)
	)
	rocm? (
		^^ (
			$(gen_rocm_required_use)
		)
	)
"
gen_llvm_triton_rdepend() {
	local u
	for u in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${u}? (
				sys-devel/llvm:${u}
				sys-devel/mlir:${u}
			)
		"
	done
}
RDEPEND+="
	!rocm? (
		$(gen_llvm_triton_rdepend)
	)
	rocm? (
		rocm_4_5? (
			sys-devel/llvm-roc:4.5[mlir]
		)
		rocm_4_1? (
			sys-devel/llvm-roc:4.1[mlir]
		)
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-build/cmake-3.18
	>=dev-build/ninja-1.11.1
"
DOCS=( "README.md" )
PATCHES=(
	"${FILESDIR}/${PN}-1.1.2-optionalize-gpu-targets-and-dynlib.patch"
	"${FILESDIR}/${PN}-1.1.2-llvm-static-linking.patch"
	"${FILESDIR}/${PN}-1.1.2-optionalize-gpu-init-llvm_cc.patch"
)

pkg_setup() {
	:
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

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local dynlib=0
	local llvm_root_dir
	if use rocm_4_5 && has_version "~sys-devel/llvm-roc-4.5.2" ; then
		llvm_root_dir="/opt/rocm-4.5.2/llvm" # LLVM 13.0.0git
	elif use rocm_4_1 && has_version "~sys-devel/llvm-roc-4.1.0" ; then
		llvm_root_dir="/opt/rocm-4.1.0/llvm" # LLVM 12.0.0git
	elif use llvm_slot_13 && has_version "sys-devel/llvm:13" && has_version "sys-devel/mlir:13"; then
		llvm_root_dir="/usr/lib/llvm/13"
		dynlib=1
	elif use llvm_slot_12 && has_version "sys-devel/llvm:12" && has_version "sys-devel/mlir:12"; then
		llvm_root_dir="/usr/lib/llvm/12"
		dynlib=1
	else
eerror "Cannot find a LLVM installation."
		die
	fi

	export PATH=$(echo "${PATH}" \
		| tr ":" "\n" \
		| sed -E -e "/llvm\/[0-9]+/d" \
		| tr "\n" ":" \
		| sed -e "s|/opt/bin|/opt/bin:${llvm_root_dir}/bin|g")
einfo "PATH:  ${PATH}"

	local mycmakeargs=(
		-DLLVM_ROOT_DIR="${llvm_root_dir}"
		-DLLVM_STATIC_LINKING=OFF
		-DUSE_AMDGPU=$(usex llvm_targets_AMDGPU)
		-DUSE_NVPTX=$(usex llvm_targets_NVPTX)
		-DLLVM_STATIC=OFF
	)

	if use rocm ; then
		# For sys-devel/llvm-roc
		mycmakeargs+=(
			-DLLVM_SHARED_MODE="shared"
			-DLLVM_IS_SHARED=ON
			-DLLVM_DYNLIB=OFF
			-DMLIR_DYNLIB=OFF
		)
	else
		# For sys-devel/llvm and sys-devel/mlir
		if (( ${dynlib} == 1 )) ; then
			mycmakeargs+=(
				-DLLVM_SHARED_MODE="shared"
				-DLLVM_IS_SHARED=ON
				-DLLVM_DYNLIB=ON
				-DMLIR_DYNLIB=OFF
			)
		else
			mycmakeargs+=(
				-DLLVM_SHARED_MODE="shared"
				-DLLVM_IS_SHARED=ON
				-DLLVM_DYNLIB=OFF
				-DMLIR_DYNLIB=OFF
			)
		fi
	fi

	if use llvm_targets_AMDGPU ; then
		append-cxxflags -DUSE_AMDGPU
	fi
	if use llvm_targets_NVPTX ; then
		append-cxxflags -DUSE_NVPTX
	fi

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
