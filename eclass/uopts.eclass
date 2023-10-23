# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: uopts.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: unified and stackable 3 stage optimizations
# @DESCRIPTION:
# This eclass unifies tpgo, tbolt, epgo, ebolt under one eclass.  This means you
# do not need to add each separate eclass.  However, some parts are still
# require specificity.  At the moment, only phases and inherits are unified.

# Flexible for future expansion

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

_UOPTS_ECLASS=1

_UOPTS_LLVM_SLOTS=(16 15 14)


UOPTS_SUPPORT_EPGO=${UOPTS_SUPPORT_EPGO:-1}
UOPTS_SUPPORT_EBOLT=${UOPTS_SUPPORT_EBOLT:-1}
UOPTS_SUPPORT_TPGO=${UOPTS_SUPPORT_TPGO:-1}
UOPTS_SUPPORT_TBOLT=${UOPTS_SUPPORT_TBOLT:-1}

if [[ "${UOPTS_SUPPORT_TPGO}" == "1" \
	|| "${UOPTS_SUPPORT_TBOLT}" == "1" ]] ; then
	inherit train
fi

if [[ "${UOPTS_SUPPORT_EPGO}" == "1" ]] ; then
	inherit epgo
fi
if [[ "${UOPTS_SUPPORT_EBOLT}" == "1" ]] ; then
	inherit ebolt
fi
if [[ "${UOPTS_SUPPORT_TPGO}" == "1" ]] ; then
	inherit tpgo
fi
if [[ "${UOPTS_SUPPORT_TBOLT}" == "1" ]] ; then
	inherit tbolt
fi

# @FUNCTION: uopts_setup
# @DESCRIPTION:
# Preforms checks for optimization compatibility
uopts_setup() {
	[[ "${UOPTS_SUPPORT_EPGO}" == "1" ]] && epgo_setup
	[[ "${UOPTS_SUPPORT_EBOLT}" == "1" ]] && ebolt_setup
	[[ "${UOPTS_SUPPORT_TPGO}" == "1" ]] && tpgo_setup
	[[ "${UOPTS_SUPPORT_TBOLT}" == "1" ]] && tbolt_setup

	local instr_vars=""
	if ( has ebolt ${IUSE} && use ebolt ) || ( has bolt ${IUSE} && use bolt ) ; then
		instr_vars+=" UOPTS_BOLT_FORCE_INST=1"
	fi

	if ( has epgo ${IUSE} && use epgo ) || ( has pgo ${IUSE} && use pgo ) ; then
		instr_vars+=" UOPTS_PGO_FORCE_PGI=1"
	fi

	if [[ -n "${instr_vars}" ]] ; then
einfo
einfo "If the build fails, try \`${instr_vars} emerge -1 =${CATEGORY}/${PN}-${PVR}\`"
einfo
	fi

	if \
		has epgo ${IUSE} && use epgo \
		&& has pgo ${IUSE} && use pgo \
		&& [[ -n "${_EPGO_ECLASS}" && -n "${_TPGO_ECLASS}" ]] ; then
eerror
eerror "You cannot use epgo and pgo at the same time."
eerror
		die
	fi
	if \
		has ebolt ${IUSE} && use ebolt \
		&& has bolt ${IUSE} && use bolt \
		&& [[ -n "${_EBOLT_ECLASS}" && -n "${_TBOLT_ECLASS}" ]] ; then
# You are allow to use ebolt and bolt in llvm ebuilds.
eerror
eerror "You cannot use ebolt and bolt at the same time."
eerror
		die
	fi
	export _UOPTS_REQUIRE_TRAINING=1
}

# @FUNCTION: uopts_src_prepare
# @DESCRIPTION:
# Transfers all instrumented profiles into all staging areas.
uopts_src_prepare() {
	[[ "${UOPTS_SUPPORT_EPGO}" == "1" ]] && epgo_src_prepare
	[[ "${UOPTS_SUPPORT_EBOLT}" == "1" ]] && ebolt_src_prepare
	[[ "${UOPTS_SUPPORT_TPGO}" == "1" ]] && tpgo_src_prepare
	[[ "${UOPTS_SUPPORT_TBOLT}" == "1" ]] && tbolt_src_prepare
}

# @FUNCTION: uopts_src_prepare
# @DESCRIPTION:
# Sets up cflags or wipes BUILD_DIR.  It should be placed after flag strips
# but before call to econf, cmake_src_configure, etc.
uopts_src_configure() {
	[[ "${UOPTS_SUPPORT_EPGO}" == "1" ]] && epgo_src_configure
	[[ "${UOPTS_SUPPORT_EBOLT}" == "1" ]] && ebolt_src_configure
	[[ "${UOPTS_SUPPORT_TPGO}" == "1" ]] && tpgo_src_configure
	[[ "${UOPTS_SUPPORT_TBOLT}" == "1" ]] && tbolt_src_configure
}

# @FUNCTION: uopts_y_training
# @DESCRIPTION:
# Mark the build as requiring PGI and PGO training.
# This is to mark shared libs or exe builds as trainable.
uopts_y_training() {
	export _UOPTS_REQUIRE_TRAINING=1
}

# @FUNCTION: uopts_n_training
# @DESCRIPTION:
# Mark the build as requiring PGI and PGO training.
# This is to mark static libs builds as untrainable.
uopts_n_training() {
	export _UOPTS_REQUIRE_TRAINING=0
}

# @FUNCTION: uopts_src_compile
# @DESCRIPTION:
# Builds the package using all 3 stage optimizations one optimization after the
# other.
uopts_src_compile() {
	local is_pgoable=1
	local skip_pgi="no"
	if has pgo ${IUSE} && [[ -n "${_TPGO_ECLASS}" ]] ; then
		_UOPTS_PGO_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}${UOPTS_PGO_IMPLS}"
		if declare -f train_meets_requirements > /dev/null ; then
			if train_meets_requirements ; then
				is_pgoable=1
			else
				is_pgoable=0
			fi
		fi
einfo "is_pgoable=${is_pgoable}"

		_tpgo_is_profile_reusable
		local ret_reuse="$?" # 0 = yes, 1 = no, 2 = unsupported_compiler
		if [[ "${UOPTS_PGO_FORCE_PGI:-0}" == "1" ]] ; then
			:;
		elif [[ "${ret_reuse}" == "0" ]] ; then
			skip_pgi="yes"
		fi

einfo "is_tpgo_profile_reusable=${skip_pgi} "
	fi

	local is_boltable=1
	local skip_inst="no"
	if has bolt ${IUSE} && [[ -n "${_TBOLT_ECLASS}" ]] ; then
		_TBOLT_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}${UOPTS_BOLT_IMPLS}"
		if declare -f train_meets_requirements > /dev/null ; then
			if train_meets_requirements ; then
				is_boltable=1
			else
				is_boltable=0
			fi
		fi
einfo "is_boltable=${is_boltable}"

		_tbolt_is_profile_reusable
		local ret_reuse="$?" # 0 = yes, 1 = no, 2 = unsupported_compiler
		if [[ "${UOPTS_BOLT_FORCE_INST:-0}" == "1" ]] ; then
			:;
		elif [[ "${ret_reuse}" == "0" ]] ; then
			skip_inst="yes"
		fi

einfo "is_tbolt_profile_reusable=${skip_inst} "
	fi

	local PGO_PHASE="NO_PGO"
	local BOLT_PHASE="NO_BOLT"
	if has ebolt ${IUSE} && use ebolt ; then
		BOLT_PHASE=$(epgo_get_phase)
	fi

	if has pgo ${IUSE} && use pgo && (( ${is_pgoable} == 1 )) && [[ -n "${_TPGO_ECLASS}" ]] ; then
		TRAIN_MUX="tpgo"
		if [[ "${skip_pgi}" == "no" ]] && (( ${_UOPTS_REQUIRE_TRAINING} == 1 )) ; then
			PGO_PHASE="PGI"
			declare -f _src_pre_pgi > /dev/null && _src_pre_pgi
			declare -f _src_prepare > /dev/null && _src_prepare
			declare -f _src_configure > /dev/null && _src_configure
			declare -f _src_compile > /dev/null && _src_compile
			declare -f _src_post_pgi > /dev/null && _src_post_pgi
			_tpgo_src_pre_train
			declare -f _src_pre_train > /dev/null && _src_pre_train
			_src_train
			declare -f _src_post_train > /dev/null && _src_post_train
		fi
		PGO_PHASE="PGO"
		declare -f _src_pre_pgo > /dev/null && _src_pre_pgo
		declare -f _src_prepare > /dev/null && _src_prepare
		declare -f _src_configure > /dev/null && _src_configure
		declare -f _src_compile > /dev/null && _src_compile
		declare -f _src_post_pgo > /dev/null && _src_post_pgo
	else
		# The Fallback
		PGO_PHASE="NO_PGO"
		BOLT_PHASE="NO_BOLT"
		if has epgo ${IUSE} && use epgo ; then
			PGO_PHASE=$(epgo_get_phase)
		fi
		if has ebolt ${IUSE} && use ebolt ; then
			BOLT_PHASE=$(epgo_get_phase)
		fi
		declare -f _src_prepare > /dev/null && _src_prepare
		declare -f _src_configure > /dev/null && _src_configure
		declare -f _src_compile > /dev/null && _src_compile
	fi

	if ! [[ "${ABI}" =~ ("arm64"|"amd64") ]] ; then
		:; # Skip trainer
	elif has bolt ${IUSE} && use bolt && (( ${is_boltable} == 1 )) && [[ -n "${_TBOLT_ECLASS}" ]] ; then
		TRAIN_MUX="tbolt"
		if [[ "${skip_inst}" == "no" ]] ; then
			BOLT_PHASE="INST"
			_tbolt_inst_tree "${BUILD_DIR}"
			declare -f _src_pre_train > /dev/null && _src_pre_train
			_tbolt_src_pre_train
			_src_train
			declare -f _src_post_train > /dev/null && _src_post_train
		fi
		BOLT_PHASE="OPT"
		_tbolt_opt_tree "${BUILD_DIR}"
	elif has ebolt ${IUSE} && use ebolt && [[ -n "${_EBOLT_ECLASS}" ]] ; then
		if has ebolt ${IUSE} && use ebolt ; then
			BOLT_PHASE=$(ebolt_get_phase)
		fi
		has ebolt ${IUSE} && use ebolt && _src_compile_bolt_inst
		has ebolt ${IUSE} && use ebolt && _src_compile_bolt_opt
	fi
}

# @FUNCTION: uopts_src_install
# @DESCRIPTION:
# Installs instrumented profiles for faster rebuilds
uopts_src_install() {
	[[ "${UOPTS_SUPPORT_EPGO}" == "1" ]] && epgo_src_install
	[[ "${UOPTS_SUPPORT_EBOLT}" == "1" ]] && ebolt_src_install
	[[ "${UOPTS_SUPPORT_TPGO}" == "1" ]] && tpgo_src_install
	[[ "${UOPTS_SUPPORT_TBOLT}" == "1" ]] && tbolt_src_install
}

# @FUNCTION: uopts_pkg_postinst
# @DESCRIPTION:
# Deletes all old profiles
uopts_pkg_postinst() {
	[[ "${UOPTS_SUPPORT_EPGO}" == "1" ]] && epgo_pkg_postinst
	[[ "${UOPTS_SUPPORT_EBOLT}" == "1" ]] && ebolt_pkg_postinst
	[[ "${UOPTS_SUPPORT_TPGO}" == "1" ]] && tpgo_pkg_postinst
	[[ "${UOPTS_SUPPORT_TBOLT}" == "1" ]] && tbolt_pkg_postinst

	if \
		( has bolt && use bolt ) \
		|| ( has ebolt && use ebolt ) \
		|| ( has epgo && use pgo ) \
		|| ( has pgo && use pgo ) \
	; then
einfo
einfo "Further training details can be found in:"
einfo
einfo "  The README.md of this overlay."
einfo "  The metadata.xml of this package (or \`epkginfo -x ${CATEGORY}/${PN}::oiledmachine-overlay\`)."
einfo
	fi
}

# @FUNCTION: uopts_pkg_config
# @DESCRIPTION:
# Optimizes all packages post install
uopts_pkg_config() {
	[[ "${UOPTS_SUPPORT_EPGO}" == "1" ]] && epgo_pkg_postinst
}

EXPORT_FUNCTIONS pkg_config
