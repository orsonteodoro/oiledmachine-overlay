#!/bin/bash

# Motivation:  There is a bug which you cannot use the USE variable with the
# ebuild command inside the .ebuild even within a wrapper script in the ebuild.
# This script fixes that.

_src_train() {
	export LLVM_ROC_PGO_TRAINING=1

	export CFLAGS_ORIG="${CFLAGS}"
	export CXXFLAGS_ORIG="${CXXFLAGS}"

	# Pass configure time tests
	export CFLAGS="${CFLAGS} -Wl,-lgcov"
	export CXXFLAGS="${CXXFLAGS} -Wl,-lgcov"

	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/composable_kernel" && "${LLVM_ROC_TRAINERS}" =~ "composable_kernel" ]] ; then
		pushd "${ROCM_OVERLAY_DIR}/sci-libs/composable_kernel"
			ebuild composable_kernel-${ROCM_SLOT}*.ebuild digest clean unpack prepare compile
		popd
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocBLAS" && "${LLVM_ROC_TRAINERS}" =~ "rocBLAS" ]] ; then
		pushd "${ROCM_OVERLAY_DIR}/sci-libs/rocBLAS"
			ebuild rocBLAS-${ROCM_SLOT}*.ebuild digest clean unpack prepare compile
		popd
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocMLIR" && "${LLVM_ROC_TRAINERS}" =~ "rocMLIR" ]] ; then
		pushd "${ROCM_OVERLAY_DIR}/sci-libs/rocMLIR"
			ebuild rocMLIR-${ROCM_SLOT}*.ebuild digest clean unpack prepare compile
		popd
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocPRIM" && "${LLVM_ROC_TRAINERS}" =~ "rocPRIM" ]] ; then
		pushd "${ROCM_OVERLAY_DIR}/sci-libs/rocPRIM"
			ebuild rocPRIM-${ROCM_SLOT}*.ebuild digest clean unpack prepare compile
		popd
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocSPARSE" && "${LLVM_ROC_TRAINERS}" =~ "rocSPARSE" ]] ; then
		pushd "${ROCM_OVERLAY_DIR}/sci-libs/rocSPARSE"
			ebuild rocSPARSE-${ROCM_SLOT}*.ebuild digest clean unpack prepare compile
		popd
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocRAND" && "${LLVM_ROC_TRAINERS}" =~ "rocRAND" ]] ; then
		pushd "${ROCM_OVERLAY_DIR}/sci-libs/rocRAND"
			ebuild rocRAND-${ROCM_SLOT}*.ebuild digest clean unpack prepare compile
		popd
	fi
	unset LLVM_ROC_PGO_TRAINING
	export CFLAGS="${CFLAGS_ORIG}"
	export CXXFLAGS="${CXXFLAGS_ORIG}"
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
	["5.7"]="5.7"
)

_build_one_slot() {
	if [[ -z "${ROCM_SLOT}" ]] ; then
echo "ROCM_SLOT must be defined as an environment variable."
		exit 1
	fi
echo "Building sys-devel/llvm-roc:${ROCM_SLOT}"

	if [[ "${LLVM_ROC_PHASES}" =~ "PGI" ]] ; then
echo "PGI Phase (1/3)"
		USE="epgo -ebolt" emerge -1vO llvm-roc:${ROCM_SLOT} || die "Encountered build failure.  PGI failed"
	fi

	if [[ "${LLVM_ROC_PHASES}" =~ "PGT" ]] ; then
echo "PGT Phase (2/3)"
		_src_train
	fi

	if [[ "${LLVM_ROC_PHASES}" =~ "PGO" ]] ; then
echo "PGO Phase (3/3)"
		USE="epgo -ebolt" emerge -1vO llvm-roc:${ROCM_SLOT} || die "Encountered build failure.  PGO failed"
	fi

	is_system_llvm=0
	if grep "system-llvm" /var/db/pkg/dev-util/rocm-compiler*${GET_ROCM_COMPILER_PV_SUFFIX_FROM_ROCM_SLOT[${ROCM_SLOT}]}*/USE ; then
		is_system_llvm=1
	fi

	llvm_bolt_path=""
	if [[ -e "/usr/lib64/rocm/${ROCM_SLOT}/llvm/bin/llvm-bolt" ]] && (( ${is_system_llvm} == 0 )) ; then
		llvm_bolt_path="/usr/lib64/rocm/${ROCM_SLOT}/llvm/bin/llvm-bolt"
		export UOPTS_BOLT_PATH="/usr/lib64/rocm/${ROCM_SLOT}/llvm/bin"
	elif [[ -e "/usr/lib/llvm/${GET_LLVM_SLOT_FROM_ROCM_SLOT[${ROCM_SLOT}]}/bin/llvm-bolt" ]] && (( ${is_system_llvm} == 1 )); then
		llvm_bolt_path="/usr/lib/llvm/${GET_LLVM_SLOT_FROM_ROCM_SLOT[${ROCM_SLOT}]}/bin/llvm-bolt"
		export UOPTS_BOLT_PATH="/usr/lib/llvm/${GET_LLVM_SLOT_FROM_ROCM_SLOT[${ROCM_SLOT}]}/bin"
	fi
	if [[ -e "${llvm_bolt_path}" ]] ; then

		if [[ "${LLVM_ROC_PHASES}" =~ "BGI" ]] ; then
echo "BGI Phase (1/3)"
# For those who are still confused, it will rebuild with the PGO profile plus
# BOLT flags.  Then, it will attach BOLT instrumentation to .so/exe.
			USE="epgo ebolt" emerge -1vO llvm-roc:${ROCM_SLOT} || die "Encountered build failure.  BGI failed"
		fi

		if [[ "${LLVM_ROC_PHASES}" =~ "BGT" ]] ; then
echo "BGT Phase (2/3)"
			_src_train
		fi

		if [[ "${LLVM_ROC_PHASES}" =~ "BGO" ]] ; then
echo "BGO Phase (3/3)"
			USE="epgo ebolt" emerge -1vO llvm-roc:${ROCM_SLOT} || die "Encountered build failure.  BGO failed"
		fi
	fi
}

_check_prereqs() {
echo "Checking if *DEPENDs was installed for slot :${ROCM_SLOT} trainers"
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/composable_kernel" && "${LLVM_ROC_TRAINERS}" =~ "composable_kernel" ]] ; then
		emerge -1vo composable_kernel:${ROCM_SLOT} || die "Prereq check/install failed"
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocBLAS" && "${LLVM_ROC_TRAINERS}" =~ "rocBLAS" ]] ; then
		emerge -1vo rocBLAS:${ROCM_SLOT} || die "Prereq check/install failed"
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocMLIR" && "${LLVM_ROC_TRAINERS}" =~ "rocMLIR" ]] ; then
		emerge -1vo rocMLIR:${ROCM_SLOT} || die "Prereq check/install failed"
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocPRIM" && "${LLVM_ROC_TRAINERS}" =~ "rocPRIM" ]] ; then
		emerge -1vo rocPRIM:${ROCM_SLOT} || die "Prereq check/install failed"
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocSPARSE" && "${LLVM_ROC_TRAINERS}" =~ "rocSPARSE" ]] ; then
		emerge -1vo rocSPARSE:${ROCM_SLOT} || die "Prereq check/install failed"
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocRAND" && "${LLVM_ROC_TRAINERS}" =~ "rocRAND" ]] ; then
		emerge -1vo rocRAND:${ROCM_SLOT} || die "Prereq check/install failed"
	fi
}

main() {
echo
echo "WARN:  You may need to disable ebolt/epgo if the 3 step process is not"
echo "WARN:  complete and want to merge normally."
echo
echo "WARN:  Not doing so may result in emerge sandbox violations."
echo
	if [[ "${LLVM_ROC_WIPE_PGO_PROFILES}" == "1" ]] ; then
                rm -rf /var/lib/pgo-profiles/sys-devel/llvm-roc
	fi
	LLVM_ROC_ENV_PATH=${LLVM_ROC_ENV_PATH:-"/etc/portage/env/llvm-roc.conf"}
	source "${LLVM_ROC_ENV_PATH}"
	LLVM_ROC_TRAINERS=${LLVM_ROC_TRAINERS:-"rocPRIM rocRAND rocSPARSE"}
	ROCM_SLOTS=${ROCM_SLOTS:-"5.1 5.2 5.3 5.4 5.5 5.6 5.7"}
	LLVM_ROC_PHASES=${LLVM_ROC_PHASES:-"PGI PGT PGO"}

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
