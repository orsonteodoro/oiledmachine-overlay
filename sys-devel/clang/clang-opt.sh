#!/bin/bash

# Motivation:  There is a bug which you cannot use the USE flag to call ebuild
# even within a wrapper script in the ebuild.  This script fixes that.

_src_train() {
	export CLANG_PGO_TRAINING=1
	CC="clang-${CLANG_SLOT}"
	CC="clang++${CLANG_SLOT}"
# TODO:  Add more ebuilds
	if [[ -e "${OVERLAY_DIR}/sys-devel/lld" && "${CLANG_TRAINERS}" =~ "lld" && -n "${LLD_PGO_TRAINING_USE}" ]] ; then
		pushd "${OVERLAY_DIR}/sys-devel/lld"
			USE="${LLD_PGO_TRAINING_USE}" ebuild lld-${CLANG_SLOT}*.ebuild digest clean unpack prepare compile
		popd
	fi
	unset CLANG_PGO_TRAINING
}

die() {
	msg="${@}"
	echo "error:  ${msg}"
	exit 1
}

_build_one_slot() {
	if [[ -z "${CLANG_SLOT}" ]] ; then
echo "CLANG_SLOT must be defined as an environment variable."
		exit 1
	fi
echo "Building sys-devel/llvm:${CLANG_SLOT}, sys-devel/clang:${CLANG_SLOT}, sys-devel/lld:${CLANG_SLOT}"

	if [[ "${CLANG_EPGO}" == "1" ]] ; then
echo "PGI Phase (1/3)"
		USE="epgo -ebolt" emerge -1vO llvm:${CLANG_SLOT} || die "Encountered build failure.  PGI failed for llvm"
		USE="epgo -ebolt" emerge -1vO clang:${CLANG_SLOT} || die "Encountered build failure.  PGI failed for clang"
		USE="epgo -ebolt" emerge -1vO lld:${CLANG_SLOT} || die "Encountered build failure.  PGI failed for lld"

echo "PGT Phase (2/3)"
		_src_train

echo "PGO Phase (3/3)"
		USE="epgo -ebolt" emerge -1vO llvm:${CLANG_SLOT} || die "Encountered build failure.  PGO failed for llvm"
		USE="epgo -ebolt" emerge -1vO clang:${CLANG_SLOT} || die "Encountered build failure.  PGO failed for clang"
		USE="epgo -ebolt" emerge -1vO lld:${CLANG_SLOT} || die "Encountered build failure.  PGO failed for lld"
	fi

	llvm_bolt_path=""
	if [[ -e "/usr/lib/llvm/${CLANG_SLOT}/bin/llvm-bolt" ]] && (( ${is_system_llvm} == 1 )); then
		llvm_bolt_path="/usr/lib/llvm/${CLANG_SLOT}/bin/llvm-bolt"
		export UOPTS_BOLT_PATH="/usr/lib/llvm/${CLANG_SLOT}/bin"
	fi
	if [[ "${CLANG_EBOLT}" == "1" && -e "${llvm_bolt_path}" ]] ; then

echo "BGI Phase (1/3)"
		USE="epgo ebolt" emerge -1vO llvm:${CLANG_SLOT} || die "Encountered build failure.  BGI failed for llvm"
		USE="epgo ebolt" emerge -1vO clang:${CLANG_SLOT} || die "Encountered build failure.  BGI failed for clang"
		USE="epgo ebolt" emerge -1vO lld:${CLANG_SLOT} || die "Encountered build failure.  BGI failed for lld"

echo "BGT Phase (2/3)"
		_src_train

echo "BGO Phase (3/3)"
		USE="epgo ebolt" emerge -1vO llvm:${CLANG_SLOT} || die "Encountered build failure.  BGO failed for llvm"
		USE="epgo ebolt" emerge -1vO clang:${CLANG_SLOT} || die "Encountered build failure.  BGO failed for clang"
		USE="epgo ebolt" emerge -1vO lld:${CLANG_SLOT} || die "Encountered build failure.  BGO failed for lld"
	fi

}

main() {
	if [[ "${CLANG_WIPE_PGO_PROFILES}" == "1" ]] ; then
		rm -rf /var/lib/pgo-profiles/sys-devel/llvm*
		rm -rf /var/lib/pgo-profiles/sys-devel/clang*
		rm -rf /var/lib/pgo-profiles/sys-devel/lld*
	fi

	CLANG_PGO_TRAINING_ENV_PATH=${CLANG_PGO_TRAINING_ENV_PATH:-"/etc/portage/env/clang-pgo-training.conf"}
	source "${CLANG_PGO_TRAINING_ENV_PATH}"
	CLANG_EPGO=${CLANG_EPGO:-"1"}
	CLANG_EBOLT=${CLANG_EBOLT:-"0"}
	CLANG_TRAINERS=${CLANG_TRAINERS:-"lld"}
	CLANG_SLOTS=${CLANG_SLOTS:-"14 15 16 17 18"}

	if [[ -z "${OVERLAY_DIR}" ]] ; then
echo "OVERLAY_DIR must be defined as an environment variable."
		exit 1
	fi

	local s
	for s in ${CLANG_SLOTS} ; do
		CLANG_SLOT="${s}"
		_build_one_slot
	done
}

main
