# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
PYTHON_COMPAT=( "python3_"{10..12} )

inherit dep-prepare distutils-r1 flag-o-matic

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
LLVM_COMPAT=( {13..12} ) # Build time failure with LLVM 14, LLVM 11 untested but offered by setup.py.
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
# You need a local copy of dev-util/nvidia-cuda-toolkit if you want to use
# llvm_targets_NVPTX on llvm:13 or llvm:12.
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
gen_llvm_rdepend() {
	local u
	for u in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${u}? (
				amd64? (
					sys-devel/llvm:${u}[llvm_targets_X86,llvm_targets_NVPTX?]
					sys-devel/mlir:${u}[llvm_targets_X86,llvm_targets_NVPTX?]
				)
				arm? (
					sys-devel/llvm:${u}[llvm_targets_ARM]
					sys-devel/mlir:${u}[llvm_targets_ARM]
				)
				arm64? (
					sys-devel/llvm:${u}[llvm_targets_AArch64]
					sys-devel/mlir:${u}[llvm_targets_AArch64]
				)
				mips? (
					sys-devel/llvm:${u}[llvm_targets_Mips]
					sys-devel/mlir:${u}[llvm_targets_Mips]
				)
				ppc? (
					sys-devel/llvm:${u}[llvm_targets_PowerPC]
					sys-devel/mlir:${u}[llvm_targets_PowerPC]
				)
				ppc64? (
					sys-devel/llvm:${u}[llvm_targets_PowerPC]
					sys-devel/mlir:${u}[llvm_targets_PowerPC]
				)
				sparc? (
					sys-devel/llvm:${u}[llvm_targets_Sparc]
					sys-devel/mlir:${u}[llvm_targets_Sparc]
				)
				x86? (
					sys-devel/llvm:${u}[llvm_targets_X86,llvm_targets_NVPTX?]
					sys-devel/mlir:${u}[llvm_targets_X86,llvm_targets_NVPTX?]
				)
			)
		"
	done
}
RDEPEND+="
	!rocm? (
		$(gen_llvm_rdepend)
	)
	rocm? (
		rocm_4_5? (
			sys-devel/llvm-roc:4.5[llvm_targets_X86,llvm_targets_AMDGPU,mlir]
		)
		rocm_4_1? (
			sys-devel/llvm-roc:4.1[llvm_targets_X86,llvm_targets_AMDGPU,mlir]
		)
	)
	llvm_targets_NVPTX? (
		llvm_slot_12? (
			|| (
				=dev-util/nvidia-cuda-toolkit-11.0*
				=dev-util/nvidia-cuda-toolkit-10.1*
			)
		)
		llvm_slot_13? (
			|| (
				=dev-util/nvidia-cuda-toolkit-11.2*
				=dev-util/nvidia-cuda-toolkit-10.1*
			)
		)
		dev-util/nvidia-cuda-toolkit:=
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
_PATCHES=(
	"${FILESDIR}/${PN}-1.1.2-optionalize-gpu-targets-and-dynlib.patch"
	"${FILESDIR}/${PN}-1.1.2-llvm-static-linking.patch"
	"${FILESDIR}/${PN}-1.1.2-optionalize-gpu-init-llvm_cc.patch"
	"${FILESDIR}/${PN}-1.1.2-customize-setup_py.patch"
	"${FILESDIR}/${PN}-1.1.2-cuda-path.patch"
	"${FILESDIR}/${PN}-1.1.2-llvm-path.patch"
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
	default
	eapply ${_PATCHES[@]}
	S="${WORKDIR}/${P}/python"
	distutils-r1_src_prepare
}

python_configure() {
einfo "Called python_configure"
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

	if [[ "${PV}" == *"9999" ]] ; then
		export OFFLINE_INSTALL=0
	else
		export OFFLINE_INSTALL=1
	fi
	if use rocm ; then
		export LLVM_INCLUDE_DIR="${llvm_root_dir}/include"
		export LLVM_LIBRARY_DIR="${llvm_root_dir}/lib"
	else
		export LLVM_INCLUDE_DIR="${llvm_root_dir}/include"
		export LLVM_LIBRARY_DIR="${llvm_root_dir}/$(get_libdir)"
	fi

	export LLVM_ROOT_DIR="${llvm_root_dir}"
	if use rocm ; then
		export USE_ROCM=1
	else
		export USE_ROCM=0
	fi
	if (( ${dynlib} == 1 )) ; then
		export USE_DYNLIB=1
	else
		export USE_DYNLIB=0
	fi

	if use llvm_targets_AMDGPU ; then
		append-cxxflags -DUSE_AMDGPU
		export USE_AMDGPU=1
	else
		export USE_AMDGPU=0
	fi
	if use llvm_targets_NVPTX ; then
		append-cxxflags -DUSE_NVPTX
		export USE_NVPTX=1
	else
		export USE_NVPTX=0
	fi
}

src_compile() {
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install
	cd "${WORKDIR}/${P}" || die
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
