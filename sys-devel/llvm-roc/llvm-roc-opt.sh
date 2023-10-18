#!/bin/bash

# Motivation:  There is a bug which you cannot use the USE flag to call ebuild
# even within a wrapper script in the ebuild.  This script fixes that.

_src_train() {
	export LLVM_ROC_PGO_TRAINING=1
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/composable_kernel" && "${LLVM_ROC_TRAINERS}" =~ "composable_kernel" && -n "${COMPOSABLE_KERNEL_PGO_TRAINING_USE}" ]] ; then
		pushd "${ROCM_OVERLAY_DIR}/sci-libs/composable_kernel"
			USE="${COMPOSABLE_KERNEL_PGO_TRAINING_USE}" ebuild composable_kernel-${ROCM_SLOT}*.ebuild digest clean unpack prepare compile
		popd
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocBLAS" && "${LLVM_ROC_TRAINERS}" =~ "rocBLAS" && -n "${ROCBLAS_PGO_TRAINING_USE}" ]] ; then
		pushd "${ROCM_OVERLAY_DIR}/sci-libs/rocBLAS"
			USE="${ROCBLAS_PGO_TRAINING_USE}" ebuild rocBLAS-${ROCM_SLOT}*.ebuild digest clean unpack prepare compile
		popd
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocMLIR" && "${LLVM_ROC_TRAINERS}" =~ "rocMLIR" && -n "${ROCMLIR_PGO_TRAINING_USE}" ]] ; then
		pushd "${ROCM_OVERLAY_DIR}/sci-libs/rocMLIR"
			USE="${ROCMLIR_PGO_TRAINING_USE}" ebuild rocMLIR-${ROCM_SLOT}*.ebuild digest clean unpack prepare compile
		popd
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocPRIM" && "${LLVM_ROC_TRAINERS}" =~ "rocPRIM" && -n "${ROCPRIM_PGO_TRAINING_USE}" ]] ; then
		pushd "${ROCM_OVERLAY_DIR}/sci-libs/rocPRIM"
			USE="${ROCPRIM_PGO_TRAINING_USE}" ebuild rocPRIM-${ROCM_SLOT}*.ebuild digest clean unpack prepare compile
		popd
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocSPARSE" && "${LLVM_ROC_TRAINERS}" =~ "rocSPARSE" && -n "${ROCSPARSE_PGO_TRAINING_USE}" ]] ; then
		pushd "${ROCM_OVERLAY_DIR}/sci-libs/rocSPARSE"
			USE="${ROCSPARSE_PGO_TRAINING_USE}" ebuild rocSPARSE-${ROCM_SLOT}*.ebuild digest clean unpack prepare compile
		popd
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocRAND" && "${LLVM_ROC_TRAINERS}" =~ "rocRAND" && -n "${ROCRAND_PGO_TRAINING_USE}" ]] ; then
		pushd "${ROCM_OVERLAY_DIR}/sci-libs/rocRAND"
			USE="${ROCRAND_PGO_TRAINING_USE}" ebuild rocRAND-${ROCM_SLOT}*.ebuild digest clean unpack prepare compile
		popd
	fi
	unset LLVM_ROC_PGO_TRAINING
}

die() {
	msg="${@}"
	echo "error:  ${msg}"
	exit 1
}

declare -A GET_LLVM_SLOT_FROM_ROCM_SLOT=(
	["5.1"]="14"
	["5.2"]="14"
	["5.3"]="15"
	["5.4"]="15"
	["5.5"]="16"
	["5.6"]="16"
	["5.7"]="17"
)

# PV = Package Version
declare -A GET_ROCM_COMPILER_PV_SUFFIX_FROM_ROCM_SLOT=(
	["5.1"]="_p501"
	["5.2"]="_p502"
	["5.3"]="_p503"
	["5.4"]="_p504"
	["5.5"]="_p505"
	["5.6"]="_p506"
	["5.7"]="_p507"
)

_build_one_slot() {
	if [[ -z "${ROCM_SLOT}" ]] ; then
echo "ROCM_SLOT must be defined as an environment variable."
		exit 1
	fi
echo "Building sys-devel/llvm-roc:${ROCM_SLOT}"

	if [[ "${LLVM_ROC_EPGO}" == "1" ]] ; then
echo "PGI Phase (1/3)"
		USE="epgo -ebolt" emerge -v llvm-roc:${ROCM_SLOT} || die "Encountered build failure.  PGI failed"

echo "PGT Phase (2/3)"
		_src_train

echo "PGO Phase (3/3)"
		USE="epgo -ebolt" emerge -v llvm-roc:${ROCM_SLOT} || die "Encountered build failure.  PGO failed"
	fi

	is_system_llvm=0
	if grep "system-llvm" /var/db/pkg/dev-util/rocm-compiler*${GET_ROCM_COMPILER_PV_SUFFIX_FROM_ROCM_SLOT[${ROCM_SLOT}]}*/USE ; then
		is_system_llvm=1
	fi

	llvm_bolt_path=""
	if [[ -e "/usr/lib64/rocm/${ROCM_SLOT}/bin/llvm-bolt" ]] && (( ${is_system_llvm} == 0 )) ; then
		llvm_bolt_path="/usr/lib64/rocm/${ROCM_SLOT}/bin/llvm-bolt"
		export UOPTS_BOLT_PATH="/usr/lib64/rocm/${ROCM_SLOT}/bin"
	elif [[ -e "/usr/lib/llvm/${GET_LLVM_SLOT_FROM_ROCM_SLOT[${ROCM_SLOT}]}/bin/llvm-bolt" ]] && (( ${is_system_llvm} == 1 )); then
		llvm_bolt_path="/usr/lib/llvm/${GET_LLVM_SLOT_FROM_ROCM_SLOT[${ROCM_SLOT}]}/bin/llvm-bolt"
		export UOPTS_BOLT_PATH="/usr/lib/llvm/${GET_LLVM_SLOT_FROM_ROCM_SLOT[${ROCM_SLOT}]}/bin"
	fi
	if [[ "${LLVM_ROC_EBOLT}" == "1" && -e "${llvm_bolt_path}" ]] ; then

echo "BGI Phase (1/3)"
		USE="epgo ebolt" emerge -v llvm-roc:${ROCM_SLOT} || die "Encountered build failure.  BGI failed"

echo "BGT Phase (2/3)"
		_src_train

echo "BGO Phase (3/3)"
		USE="epgo ebolt" emerge -v llvm-roc:${ROCM_SLOT} || die "Encountered build failure.  BGO failed"
	fi

}

_check_prereqs() {
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/composable_kernel" && "${LLVM_ROC_TRAINERS}" =~ "composable_kernel" && -n "${COMPOSABLE_KERNEL_PGO_TRAINING_USE}" ]] ; then
		USE="${COMPOSABLE_KERNEL_PGO_TRAINING_USE}" emerge -1vo composable_kernel:${ROCM_SLOT} || die "Prereq check/install failed"
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocBLAS" && "${LLVM_ROC_TRAINERS}" =~ "rocBLAS" && -n "${ROCBLAS_PGO_TRAINING_USE}" ]] ; then
		USE="${ROCBLAS_PGO_TRAINING_USE}" emerge -1vo rocBLAS:${ROCM_SLOT} || die "Prereq check/install failed"
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocMLIR" && "${LLVM_ROC_TRAINERS}" =~ "rocMLIR" && -n "${ROCMLIR_PGO_TRAINING_USE}" ]] ; then
		USE="${ROCMLIR_PGO_TRAINING_USE}" emerge -1vo rocMLIR:${ROCM_SLOT} || die "Prereq check/install failed"
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocPRIM" && "${LLVM_ROC_TRAINERS}" =~ "rocPRIM" && -n "${ROCPRIM_PGO_TRAINING_USE}" ]] ; then
		USE="${ROCPRIM_PGO_TRAINING_USE}" emerge -1vo rocPRIM:${ROCM_SLOT} || die "Prereq check/install failed"
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocSPARSE" && "${LLVM_ROC_TRAINERS}" =~ "rocSPARSE" && -n "${ROCSPARSE_PGO_TRAINING_USE}" ]] ; then
		USE="${ROCSPARSE_PGO_TRAINING_USE}" emerge -1vo rocSPARSE:${ROCM_SLOT} || die "Prereq check/install failed"
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocRAND" && "${LLVM_ROC_TRAINERS}" =~ "rocRAND" && -n "${ROCRAND_PGO_TRAINING_USE}" ]] ; then
		USE="${ROCRAND_PGO_TRAINING_USE}" emerge -1vo rocRAND:${ROCM_SLOT} || die "Prereq check/install failed"
	fi
}

main() {
	if [[ "${LLVM_ROC_WIPE_PGO_PROFILES}" == "1" ]] ; then
                rm -rf /var/lib/pgo-profiles/sys-devel/llvm-roc
	fi
	LLVM_ROC_ENV_PATH=${LLVM_ROC_ENV_PATH:-"/etc/portage/env/llvm-roc.conf"}
	source "${LLVM_ROC_ENV_PATH}"
	LLVM_ROC_EPGO=${LLVM_ROC_EPGO:-"1"}
	LLVM_ROC_EBOLT=${LLVM_ROC_EBOLT:-"0"}
	LLVM_ROC_TRAINERS=${LLVM_ROC_TRAINERS:-"rocPRIM rocRAND rocSPARSE"}
	ROCM_SLOTS=${ROCM_SLOTS:-"5.1 5.2 5.3 5.4 5.5 5.6 5.7"}

	if [[ -z "${ROCM_OVERLAY_DIR}" ]] ; then
echo "ROCM_OVERLAY_DIR must be defined as an environment variable."
		exit 1
	fi

	local s
	for s in ${ROCM_SLOTS} ; do
		ROCM_SLOT="${s}"
		_check_prereqs
	done

	local s
	for s in ${ROCM_SLOTS} ; do
		ROCM_SLOT="${s}"
		_build_one_slot
	done
}

main
