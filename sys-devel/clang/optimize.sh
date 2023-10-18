#!/bin/bash

# Motivation:  There is a bug which you cannot use the USE variable with the
# ebuild command inside the .ebuild even within a wrapper script in the ebuild.
# This script fixes that.

_src_train() {
	export CLANG_PGO_TRAINING=1
	export CC="clang-${CLANG_SLOT}"
	export CXX="clang++${CLANG_SLOT}"
# TODO:  Add more ebuilds
	if [[ -e "${OVERLAY_DIR}/sys-devel/lld" && "${CLANG_TRAINERS}" =~ "lld" ]] ; then
		pushd "${OVERLAY_DIR}/sys-devel/lld"
			ebuild lld-${CLANG_SLOT}*.ebuild digest clean unpack prepare compile
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

	if [[ "${CLANG_PHASES}" == "PGI" ]] ; then
echo "PGI Phase (1/3)"
		USE="epgo -ebolt" emerge -1vO llvm:${CLANG_SLOT} || die "Encountered build failure.  PGI failed for llvm"
		USE="epgo -ebolt" emerge -1vO clang:${CLANG_SLOT} || die "Encountered build failure.  PGI failed for clang"
		USE="epgo -ebolt" emerge -1vO lld:${CLANG_SLOT} || die "Encountered build failure.  PGI failed for lld"
	fi

	if [[ "${CLANG_PHASES}" == "PGT" ]] ; then
echo "PGT Phase (2/3)"
		_src_train
	fi

	if [[ "${CLANG_PHASES}" == "PGO" ]] ; then
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
	if [[ -e "${llvm_bolt_path}" ]] ; then

		if [[ "${CLANG_PHASES}" == "BGI" ]] ; then
echo "BGI Phase (1/3)"
# For those who are still confused, it will rebuild with the PGO profile plus
# BOLT flags.  Then, it will attach BOLT instrumentation to .so/exe.
			USE="epgo ebolt" emerge -1vO llvm:${CLANG_SLOT} || die "Encountered build failure.  BGI failed for llvm"
			USE="epgo ebolt" emerge -1vO clang:${CLANG_SLOT} || die "Encountered build failure.  BGI failed for clang"
			USE="epgo ebolt" emerge -1vO lld:${CLANG_SLOT} || die "Encountered build failure.  BGI failed for lld"
		fi

		if [[ "${CLANG_PHASES}" == "BGT" ]] ; then
echo "BGT Phase (2/3)"
			_src_train
		fi

		if [[ "${CLANG_PHASES}" == "BGO" ]] ; then
echo "BGO Phase (3/3)"
			USE="epgo ebolt" emerge -1vO llvm:${CLANG_SLOT} || die "Encountered build failure.  BGO failed for llvm"
			USE="epgo ebolt" emerge -1vO clang:${CLANG_SLOT} || die "Encountered build failure.  BGO failed for clang"
			USE="epgo ebolt" emerge -1vO lld:${CLANG_SLOT} || die "Encountered build failure.  BGO failed for lld"
		fi
	fi

}

_install_prereqs() {
echo "Checking if *DEPENDs was installed for llvm, clang, lld"
	emerge -1vo llvm:${CLANG_SLOT} || die "Encountered build failure.  Prereq check/install failed for llvm"
	emerge -1vo clang:${CLANG_SLOT} || die "Encountered build failure.  Prereq check/install failed for clang"
	emerge -1vo lld:${CLANG_SLOT} || die "Encountered build failure.  Prereq check/install failed for lld"
}

main() {
	if [[ "${CLANG_WIPE_PGO_PROFILES}" == "1" ]] ; then
		rm -rf /var/lib/pgo-profiles/sys-devel/llvm*
		rm -rf /var/lib/pgo-profiles/sys-devel/clang*
		rm -rf /var/lib/pgo-profiles/sys-devel/lld*
	fi

	CLANG_PGO_TRAINING_ENV_PATH=${CLANG_PGO_TRAINING_ENV_PATH:-"/etc/portage/env/clang-pgo-training.conf"}
	source "${CLANG_PGO_TRAINING_ENV_PATH}"
	CLANG_TRAINERS=${CLANG_TRAINERS:-"lld"}
	CLANG_SLOTS=${CLANG_SLOTS:-"14 15 16 17 18"}
	CLANG_PHASES=${CLANG_PHASES:-"PGI PGT PGO"}

	if [[ -z "${OVERLAY_DIR}" ]] ; then
echo "OVERLAY_DIR must be defined as an environment variable."
		exit 1
	fi

	local s
	for s in ${CLANG_SLOTS} ; do
		CLANG_SLOT="${s}"
		_install_prereqs
	done

	local s
	for s in ${CLANG_SLOTS} ; do
		CLANG_SLOT="${s}"
		_build_one_slot
	done
}

main
