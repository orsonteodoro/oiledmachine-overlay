#!/bin/bash

# Motivation:  There is a bug which you cannot use the USE variable with the
# ebuild command inside the .ebuild even within a wrapper script in the ebuild.
# This script fixes that.

# For system-llvm USE flag
_get_rocm_slot() {
	local clang_slot="${1}"
	local rocm_slot=""
	local ROCM_SLOTS=(5_1 5_2 5_3 5_4 5_5 5_6 5_7)
	local s
	for s in ${ROCM_SLOTS[@]} ; do
		if grep "rocm_${s}" /var/db/pkg/sys-devel/clang-${clang_slot}*/USE ; then
			rocm_slot="${s}"
			break
		fi
	done
	echo "${rocm_slot}"
}

ver_eq() {
	local a="${1}"
	local b="${2}"
	[[ "${a}" -eq "${b}" ]] && return 0
	return 1
}

ver_ne() {
	local a="${1}"
	local b="${2}"
	[[ "${a}" -ne "${b}" ]] && return 0
	return 1
}

ver_lt() {
	local a="${1}"
	local b="${2}"
	local r=$(echo -e "${a}\n${b}" | sort -V | tail -n 1)
	[[ "${a}" -eq "${b}" ]] && return 1
	[[ "${r}" -eq "${b}" ]] && return 0
	return 1
}

ver_lt() {
	local a="${1}"
	local b="${2}"
	local r=$(echo -e "${a}\n${b}" | sort -V | tail -n 1)
	[[ "${a}" -eq "${b}" ]] && return 0
	[[ "${r}" -eq "${b}" ]] && return 0
	return 1
}

ver_gt() {
	local a="${1}"
	local b="${2}"
	local r=$(echo -e "${a}\n${b}" | sort -V | tail -n 1)
	[[ "${a}" -eq "${b}" ]] && return 1
	[[ "${r}" -eq "${a}" ]] && return 0
	return 1
}

ver_ge() {
	local a="${1}"
	local b="${2}"
	local r=$(echo -e "${a}\n${b}" | sort -V | tail -n 1)
	[[ "${a}" -eq "${b}" ]] && return 0
	[[ "${r}" -eq "${a}" ]] && return 0
	return 1
}

_src_train() {
	export CLANG_PGO_TRAINING=1
	export CC="clang-${CLANG_SLOT}"
	export CXX="clang++${CLANG_SLOT}"
	local pn
# TODO:  Add more ebuilds
	if [[ -e "${ROCM_OVERLAY_DIR}/sys-devel/lld" && "${CLANG_TRAINERS}" =~ "lld" ]] ; then
		pushd "${ROCM_OVERLAY_DIR}/sys-devel/lld"
			ebuild lld-${CLANG_SLOT}*.ebuild digest clean unpack prepare compile
		popd
	fi
	if [[ -e "${PORTAGE_OVERLAY_DIR}/media-video/ffmpeg" && "${CLANG_TRAINERS}" =~ "ffmpeg" ]] ; then
		pushd "${PORTAGE_OVERLAY_DIR}/media-video/ffmpeg"
			local fn=$(ls 6.0* | sort -V | tail -n 1)
			if [[ -e "${fn}" ]] ; then
				ebuild ${fn} digest clean unpack prepare compile
			fi
		popd
	fi

	if [[ -e "${PORTAGE_OVERLAY_DIR}/media-libs/mesa" && "${CLANG_TRAINERS}" =~ "mesa" ]] && ver_le "${CLANG_SLOT}" "16" ; then
		pushd "${PORTAGE_OVERLAY_DIR}/media-libs/mesa"
			local fn=$(ls 23.2* | sort -V | tail -n 1)
			if [[ -e "${fn}" ]] ; then
				ebuild ${fn} digest clean unpack prepare compile
			fi
		popd
	fi

	if [[ -e "${PORTAGE_OVERLAY_DIR}/x11-base/xorg-server" && "${CLANG_TRAINERS}" =~ "xorg-server" ]] ; then
		pushd "${PORTAGE_OVERLAY_DIR}/x11-base/xorg-server"
			local fn=$(ls 21* | sort -V | tail -n 1)
			if [[ -e "${fn}" ]] ; then
				ebuild ${fn} digest clean unpack prepare compile
			fi
		popd
	fi

	local ROCM_SLOT=$(_get_rocm_slot "${CLANG_SLOT}")
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/composable_kernel" && "${CLANG_TRAINERS}" =~ "composable_kernel" ]] ; then
		pushd "${ROCM_OVERLAY_DIR}/sci-libs/composable_kernel"
			local fn=$(ls *6.0* | sort -V | tail -n 1)
			if [[ -e "${fn}" ]] ; then
				ebuild composable_kernel-${ROCM_SLOT}*.ebuild digest clean unpack prepare compile
			fi
		popd
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocBLAS" && "${CLANG_TRAINERS}" =~ "rocBLAS" ]] ; then
		pushd "${ROCM_OVERLAY_DIR}/sci-libs/rocBLAS"
			ebuild rocBLAS-${ROCM_SLOT}*.ebuild digest clean unpack prepare compile
		popd
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocMLIR" && "${CLANG_TRAINERS}" =~ "rocMLIR" ]] ; then
		pushd "${ROCM_OVERLAY_DIR}/sci-libs/rocMLIR"
			ebuild rocMLIR-${ROCM_SLOT}*.ebuild digest clean unpack prepare compile
		popd
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocPRIM" && "${CLANG_TRAINERS}" =~ "rocPRIM" ]] ; then
		pushd "${ROCM_OVERLAY_DIR}/sci-libs/rocPRIM"
			ebuild rocPRIM-${ROCM_SLOT}*.ebuild digest clean unpack prepare compile
		popd
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocRAND" && "${CLANG_TRAINERS}" =~ "rocRAND" ]] ; then
		pushd "${ROCM_OVERLAY_DIR}/sci-libs/rocRAND"
			ebuild rocRAND-${ROCM_SLOT}*.ebuild digest clean unpack prepare compile
		popd
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocSPARSE" && "${CLANG_TRAINERS}" =~ "rocSPARSE" ]] ; then
		pushd "${ROCM_OVERLAY_DIR}/sci-libs/rocSPARSE"
			ebuild rocSPARSE-${ROCM_SLOT}*.ebuild digest clean unpack prepare compile
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
	local ROCM_SLOT=$(_get_rocm_slot "${CLANG_SLOT}")
	if [[ -e "${PORTAGE_OVERLAY_DIR}/media-video/ffmpeg" && "${CLANG_TRAINERS}" =~ "ffmpeg" ]] ; then
		emerge -1vo =ffmpeg-6.0* || die "Encountered build failure.  Prereq check/install failed for ffmpeg"
	fi
	if [[ -e "${PORTAGE_OVERLAY_DIR}/media-libs/mesa" && "${CLANG_TRAINERS}" =~ "mesa" ]] ; then
		emerge -1vo =mesa-23.2* || die "Encountered build failure.  Prereq check/install failed for mesa"
	fi
	if [[ -e "${PORTAGE_OVERLAY_DIR}/x11-base/xorg-server" && "${CLANG_TRAINERS}" =~ "xorg-server" ]] ; then
		emerge -1vo =xorg-server-21* || die "Encountered build failure.  Prereq check/install failed for xorg-server"
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/composable_kernel" && "${CLANG_TRAINERS}" =~ "composable_kernel" ]] ; then
		emerge -1vo composable_kernel:${ROCM_SLOT} || die "Encountered build failure.  Prereq check/install failed for composable_kernel:${ROCM_SLOT}"
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocBLAS" && "${CLANG_TRAINERS}" =~ "rocBLAS" ]] ; then
		emerge -1vo rocBLAS:${ROCM_SLOT} || die "Encountered build failure.  Prereq check/install failed for rocBLAS:${ROCM_SLOT}"
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocMLIR" && "${CLANG_TRAINERS}" =~ "rocMLIR" ]] ; then
		emerge -1vo rocMLIR:${ROCM_SLOT} || die "Encountered build failure.  Prereq check/install failed for rocMLIR:${ROCM_SLOT}"
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocPRIM" && "${CLANG_TRAINERS}" =~ "rocPRIM" ]] ; then
		emerge -1vo rocPRIM:${ROCM_SLOT} || die "Encountered build failure.  Prereq check/install failed for rocPRIM:${ROCM_SLOT}"
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocRAND" && "${CLANG_TRAINERS}" =~ "rocRAND" ]] ; then
		emerge -1vo rocRAND:${ROCM_SLOT} || die "Encountered build failure.  Prereq check/install failed for rocRAND:${ROCM_SLOT}"
	fi
	if [[ -e "${ROCM_OVERLAY_DIR}/sci-libs/rocSPARSE" && "${CLANG_TRAINERS}" =~ "rocSPARSE" ]] ; then
		emerge -1vo rocSPARSE:${ROCM_SLOT} || die "Encountered build failure.  Prereq check/install failed for rocSPARSE:${ROCM_SLOT}"
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
	CLANG_TRAINERS=${CLANG_TRAINERS:-"lld"}
	CLANG_SLOTS=${CLANG_SLOTS:-"14 15 16 17 18"}
	CLANG_PHASES=${CLANG_PHASES:-"PGI PGT PGO"}

	if [[ -z "${ROCM_OVERLAY_DIR}" ]] ; then
echo "ROCM_OVERLAY_DIR must be defined as an environment variable."
		exit 1
	fi

	if [[ -z "${PORTAGE_OVERLAY_DIR}" ]] ; then
echo "PORTAGE_OVERLAY_DIR must be defined as an environment variable."
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
