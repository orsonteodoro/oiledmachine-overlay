#!/bin/bash

_src_train() {
	export LLVM_ROC_PGO_TRAINING=1
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/composable_kernel" && "${LLVM_ROC_TRAINERS}" =~ "composable_kernel" && -n "${COMPOSABLE_KERNEL_PGO_TRAINING_USE}" ]] ; then
		pushd "${ROCM_OVERLAY_DIR}/sci-libs/composable_kernel"
			USE="${ROCBLAS_PGO_TRAINING_USE}" ebuild composable_kernel-${ROCM_SLOT}*.ebuild digest clean unpack prepare compile
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

_build_one_slot() {
	if [[ -z "${ROCM_SLOT}" ]] ; then
echo "ROCM_SLOT must be defined as an environment variable."
		exit 1
	fi
echo "Building sys-devel/llvm-roc:${ROCM_SLOT}"

	if [[ "${LLVM_ROC_EPGO}" == "1" ]] ; then
echo "PGI Phase (1/3)"
		USE="epgo" emerge llvm-roc:${ROCM_SLOT} || die "Encountered build failure.  PGI failed"

echo "PGT Phase (2/3)"
		_src_train

echo "PGO Phase (3/3)"
		USE="epgo" emerge llvm-roc:${ROCM_SLOT} || die "Encountered build failure.  PGO failed"
	fi

	if [[ "${LLVM_ROC_EBOLT}" == "1" ]] ; then

echo "BGI Phase (1/3)"
		USE="epgo ebolt" emerge llvm-roc:${ROCM_SLOT} || die "Encountered build failure.  BGI failed"

echo "BGT Phase (2/3)"
		_src_train

echo "BGO Phase (3/3)"
		USE="epgo ebolt" emerge llvm-roc:${ROCM_SLOT} || die "Encountered build failure.  BGO failed"
	fi

}

main() {
	LLVM_ROC_ENV_PATH=${LLVM_ROC_ENV_PATH:-"/etc/portage/env/llvm-roc.conf"}
	source "${LLVM_ROC_ENV_PATH}"
	LLVM_ROC_EPGO=${LLVM_ROC_EPGO:-"1"}
	LLVM_ROC_EBOLT=${LLVM_ROC_EBOLT:-"0"}
	ROCM_SLOTS=${ROCM_SLOTS:-"5.1 5.2 5.3 5.4 5.5 5.6 5.7"}

	if [[ -z "${ROCM_OVERLAY_DIR}" ]] ; then
echo "ROCM_OVERLAY_DIR must be defined as an environment variable."
		exit 1
	fi

	local s
	for s in ${ROCM_SLOTS} ; do
		ROCM_SLOT="${s}"
		_build_one_slot
	done
}

main
