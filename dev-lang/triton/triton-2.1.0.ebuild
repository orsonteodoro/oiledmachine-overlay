# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( "python3_"{10..12} )
INTEL_XPU_BACKEND_COMMIT="0bcc485f82b34d49494bd0264bacc24a20aafb7a"

inherit dep-prepare cmake

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/triton-lang/triton.git"
	FALLBACK_COMMIT="da40a1e984bf57c4708daf603eb427442025f99b" # Aug 31, 2023
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	#KEYWORDS="~amd64" # Ebuild still in development.
	S="${WORKDIR}/${P}"
	SRC_URI="
https://github.com/triton-lang/triton/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/intel/intel-xpu-backend-for-triton/archive/${INTEL_XPU_BACKEND_COMMIT}.tar.gz
	-> intel-xpu-backend-for-triton-${INTEL_XPU_BACKEND_COMMIT:0:7}.tar.gz
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
LLVM_COMPAT=( {17..7} )
ROCM_SLOTS=(
	rocm_6_1
	rocm_6_0
	rocm_5_7
	rocm_5_6
	rocm_5_5
	rocm_5_4
	rocm_5_3
	rocm_5_2
	rocm_5_1
	rocm_4_5
	rocm_4_1
)
IUSE+="
${LLVM_COMPAT[@]/#/llvm_slot_}
${ROCM_SLOTS[@]}
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
		rocm_6_1? (
			sys-devel/llvm-roc:6.1[mlir]
		)
		rocm_6_0? (
			sys-devel/llvm-roc:6.0[mlir]
		)
		rocm_5_7? (
			sys-devel/llvm-roc:5.7[mlir]
		)
		rocm_5_6? (
			sys-devel/llvm-roc:5.6[mlir]
		)
		rocm_5_5? (
			sys-devel/llvm-roc:5.5[mlir]
		)
		rocm_5_4? (
			sys-devel/llvm-roc:5.4[mlir]
		)
		rocm_5_3? (
			sys-devel/llvm-roc:5.3[mlir]
		)
		rocm_5_2? (
			sys-devel/llvm-roc:5.2[mlir]
		)
		rocm_5_1? (
			sys-devel/llvm-roc:5.1[mlir]
		)
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
	"${FILESDIR}/${PN}-2.1.0-dynlib.patch"
)

pkg_setup() {
	ewarn "This ebuild is still in development"
	:
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
		dep_prepare_mv "${WORKDIR}/intel-xpu-backend-for-triton-${INTEL_XPU_BACKEND_COMMIT}" "${S}/third_party/intel_xpu_backend"
	fi
}

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local dynlib=0
	local llvm_root_dir
	if use rocm_6_1 && has_version "~sys-devel/llvm-roc-6.1.2" ; then
		llvm_root_dir="/opt/rocm-6.1.2/llvm"
	elif use rocm_6_0 && has_version "~sys-devel/llvm-roc-6.0.2" ; then
		llvm_root_dir="/opt/rocm-6.0.2/llvm"
	elif use rocm_5_7 && has_version "~sys-devel/llvm-roc-5.7.1" ; then
		llvm_root_dir="/opt/rocm-5.7.1/llvm"
	elif use rocm_5_6 && has_version "~sys-devel/llvm-roc-5.6.1" ; then
		llvm_root_dir="/opt/rocm-5.6.1/llvm"
	elif use rocm_5_5 && has_version "~sys-devel/llvm-roc-5.5.1" ; then
		llvm_root_dir="/opt/rocm-5.5.1/llvm"
	elif use rocm_5_4 && has_version "~sys-devel/llvm-roc-5.4.3" ; then
		llvm_root_dir="/opt/rocm-5.4.3/llvm"
	elif use rocm_5_3 && has_version "~sys-devel/llvm-roc-5.3.3" ; then
		llvm_root_dir="/opt/rocm-5.3.3/llvm"
	elif use rocm_5_2 && has_version "~sys-devel/llvm-roc-5.2.3" ; then
		llvm_root_dir="/opt/rocm-5.2.3/llvm"
	elif use rocm_5_1 && has_version "~sys-devel/llvm-roc-5.1.3" ; then
		llvm_root_dir="/opt/rocm-5.1.3/llvm"
	elif use rocm_4_5 && has_version "~sys-devel/llvm-roc-4.5.2" ; then
		llvm_root_dir="/opt/rocm-4.5.2/llvm"
	elif use rocm_4_1 && has_version "~sys-devel/llvm-roc-4.1.0" ; then
		llvm_root_dir="/opt/rocm-4.1.0/llvm"
	elif use llvm_slot_17 && has_version "sys-devel/llvm:17" && has_version "sys-devel/mlir:17" ; then
		llvm_root_dir="/usr/lib/llvm/17"
		dynlib=1
	elif use llvm_slot_16 && has_version "sys-devel/llvm:16" && has_version "sys-devel/mlir:16" ; then
		llvm_root_dir="/usr/lib/llvm/16"
		dynlib=1
	elif use llvm_slot_15 && has_version "sys-devel/llvm:15" && has_version "sys-devel/mlir:15"; then
		llvm_root_dir="/usr/lib/llvm/15"
		dynlib=1
	elif use llvm_slot_14 && has_version "sys-devel/llvm:14" && has_version "sys-devel/mlir:14"; then
		llvm_root_dir="/usr/lib/llvm/14"
		dynlib=1
	elif use llvm_slot_13 && has_version "sys-devel/llvm:13" && has_version "sys-devel/mlir:13"; then
		llvm_root_dir="/usr/lib/llvm/13"
		dynlib=1
	elif use llvm_slot_12 && has_version "sys-devel/llvm:12" && has_version "sys-devel/mlir:12"; then
		llvm_root_dir="/usr/lib/llvm/12"
		dynlib=1
	elif use llvm_slot_11 && has_version "sys-devel/llvm:11" && has_version "sys-devel/mlir:11"; then
		llvm_root_dir="/usr/lib/llvm/11"
		dynlib=1
	elif use llvm_slot_10 && has_version "sys-devel/llvm:10" && has_version "sys-devel/mlir:10" ; then
		llvm_root_dir="/usr/lib/llvm/10"
		dynlib=1
	elif use llvm_slot_9 && has_version "sys-devel/llvm:9" && has_version "sys-devel/mlir:9" ; then
		llvm_root_dir="/usr/lib/llvm/9"
	elif use llvm_slot_8 && has_version "sys-devel/llvm:8" && has_version "sys-devel/mlir:8" ; then
		llvm_root_dir="/usr/lib/llvm/8"
	elif use llvm_slot_7 && has_version "sys-devel/llvm:7" && has_version "sys-devel/mlir:7" ; then
		llvm_root_dir="/usr/lib/llvm/7"
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
	)

	if use rocm ; then
# FIXME:  still tries to find static lib
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
