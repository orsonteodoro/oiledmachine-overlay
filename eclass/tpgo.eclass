# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: tpgo.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: traditional 3 step PGO in one emerge
# @DESCRIPTION:
# This ebuild is to perform a traditional 3 step PGO per emerge.
# It exists to increase the deployment of PGO and to educate about
# mysterious PGO support.

# When to use this eclass?
#
# Only use if the build times are short like in 1 hr and the package has
# benchmarks, demos, examples.
#
# If the package doesn't contain benchmarks, demos, examples or has
# hours build times use the epgo eclass instead.
#
# If the app uses a GUI but doesn't require X but wayland, use the epgo eclass
# instead.

# The current EAPI is not designed for traditional 3 step PGO.
# Certain things should be disabled or be changed in order for it to work
# properly.

# Required
#
# These are required to prevent calling the default handler.
#
# Any event based *configure() needs to be disabled/converted.
#
# src_configure() {
#	...
# }
#	to
#
# _src_configure() { ... }  # Rename
# src_configure() { :; }    # Added
#
#
# multilib_src_configure {
#	...
# }
#
#	to
#
# _src_configure() {
#	configure_abi {
#		tpgo_src_configure
#		...
#	}
#	foreach_multilib_abi
#	configure_abi
# }                      # Renamed
# src_configure) { :; }  # Added
#
#
# Any *prepare() with sed edits needs to be converted
#
# src_prepare() {
#	...
# }
#	to
#
# _src_prepare() { ... }  # Renamed
# src_prepare() { :; }    # Added
#
#
# Any *compile() needs needs to be converted
#
# src_compile() {
#	...
# }
#	to
#
# _src_compile() { :; }              # Renamed
# src_compile() { src_compile ... }  # Changed
#
#
# multilib_src_compile {
#	...
# }
#
#	to
#
# src_compile() {
#	compile_abi {
#               tpgo_src_compile
#		...
#	}
#	foreach_multilib_abi compile_abi
# }                                       # Renamed and changed
#
# If an ebuild uses multiple multibuild derivatives, it should be converted into
# nested loops.
# Reason why is because multibuild and derivatives are broken by design.
# It is trying to cover up the n^k design (aka antipattern).

# @ECLASS_VARIABLE: TPGO_USE_X
# @DESCRIPTION:
# Runs GUI in X.  You can use console apps in this also.

# @ECLASS_VARIABLE: TPGO_NO_X_DEPENDS
# @DESCRIPTION:
# Disables X depends

# @ECLASS_VARIABLE: TPGO_SANDBOX_EXCEPTION_GLSL
# @DESCRIPTION:
# Add sandbox exceptions for GLSL.

# @ECLASS_VARIABLE: TPGO_SANDBOX_EXCEPTION_INPUT
# @DESCRIPTION:
# Add sandbox exceptions for input.

# @ECLASS_VARIABLE: TPGO_CONFIGURE_DONT_SET_FLAGS
# @DESCRIPTION:
# Lets the project decide how to add PGO flags and merge profile.
TPGO_CONFIGURE_DONT_SET_FLAGS=${TPGO_CONFIGURE_DONT_SET_FLAGS:-0}

# @FUNCTION: tpgo_meets_requirements
# @RETURN:
# 0 - as the exit code if it has installed assets and training dependencies
# 1 - as the exit code if it did not install assets or did not install dependencies
# @DESCRIPTION:
# Reports if the prerequisites to train are met.  The implication is that if it
# doesn't have the assets, or doesn't have the training tool, or doesn't have
# the dependency to that training tool, it will fall back to as if PGO=-pgo.
# Example scenario:  dynamic linking to be train with a separate package with
# app that uses the dynamic library.  If the app is not installed, then
# we skip both PGI and PGO and fallback to normal merging sequence.
#
# This function is actually a user defined event handler and optional.
#

# TIPS:

# If a library package is disjoint from the app package and the library package
# doesn't contain a trainer app, then use LD_LIBRARY_PATH to load the PGIed
# library in _src_pre_train to priorize the PGI library before the system
# library, but the app should be prebuilt with the matching depending library
# so the symbols are consistent.  Also, use the tpgo_meets_requirements and
# PDEPEND to prevent disruption of user work.  If this is too difficult to sort
# out, use the epgo eclass instead.

# If using GCC PGO, you may need to add -lgcov to LIBS or modify the build
# files but only in PGI phase.

# @ECLASS_VARIABLE: TPGO_PROFILES_DIR
# @DESCRIPTION:
# Sets the location to dump PGO profiles.
TPGO_PROFILES_DIR=${TPGO_PROFILES_DIR:-"/var/lib/pgo-profiles"}

# @ECLASS_VARIABLE: _TPGO_PV
# @INTERNAL
# @DESCRIPTION:
# Default PV with breaking changes when bumped.
_TPGO_PV=$(ver_cut 1-2 ${PV}) # default

# @ECLASS_VARIABLE: TPGO_PV
# @DESCRIPTION:
# Set to the PV range which can cause breakage when bumped.  Excludes non
# breaking patch versions.
TPGO_PV=${TPGO_PV:-${_TPGO_PV}}

# @ECLASS_VARIABLE: _TPGO_CATPN_DATA_DIR
# @INTERNAL
# @DESCRIPTION:
# The path to the program PGO profile with general package id specificity.
_TPGO_CATPN_DATA_DIR=${_TPGO_CATPN_DATA_DIR:-"${TPGO_PROFILES_DIR}/${CATEGORY}/${PN}"}

# @ECLASS_VARIABLE: _TPGO_DATA_DIR
# @INTERNAL
# @DESCRIPTION:
# The path to the program PGO profile with version specificity.
_TPGO_DATA_DIR=${_TPGO_DATA_DIR:-"${TPGO_PROFILES_DIR}/${CATEGORY}/${PN}/${EPGO_PV}"}

# @ECLASS_VARIABLE: TPGO_PROFILES_REUSE
# @DESCRIPTION:
# Allow to enable or disable profile reuse.
# 1 for reuse, 0 for no reuse
# Only the user can decide.  Do not set it in the ebuild.

# @ECLASS_VARIABLE: TPGO_IMPLS (OPTIONAL)
# @DESCRIPTION:
# This sets the suffix for multilib or different implementations.  It should be
# explicitly be set just before every tpgo_src_prepare, tpgo_src_configure,
# tpgo_src_compile, tpgo_src_install.
# Examples:
#
# impl="headless"
# TPGO_IMPLS="_${impl}"
# tpgo_src_prepare
#
# impl="simd"
# TPGO_IMPLS="_${impl}"
# tpgo_src_prepare
#

inherit flag-o-matic toolchain-funcs
if [[ "${TPGO_USE_X}" == "1" ]] ;then
	inherit virtualx
fi
if [[ "${TPGO_MULTILIB}" == "1" ]] ; then
	inherit multilib-build
fi

__VIRTX_BDEPENDS="
	x11-base/xorg-server[xvfb]
	x11-apps/xhost
"

IUSE+=" pgo"
if [[ "${TPGO_USE_X}" == "1" && "${TPGO_NO_X_DEPENDS}" != "1" ]] ;then
	BDEPEND+="
		pgo? (
			${__VIRTX_BDEPENDS}
		)
	"
fi

tpgo-check-x() {
	local pkg
	for pkg in ${__VIRTX_BDEPENDS[@]} ; do
		if ! has_version "${pkg}" ; then
ewarn
ewarn "${pkg} is required for PGO"
ewarn
		fi
	done
}

# @ECLASS_VARIABLE: TPGO_TEST_DURATION
# @DESCRIPTION:
# The timebox in seconds for a trainer.
TPGO_TEST_DURATION=${TPGO_TEST_DURATION:-120} # 2 min

# @FUNCTION: tpgo_get_trainer_exe
# @DESCRIPTION:
# Performs checks and recommend workarounds to broken EAPI to unbreak PGO
tpgo_setup() {
	if ! declare -f tpgo_train_custom > /dev/null ; then
		declare -f tpgo_get_trainer_exe > /dev/null \
			|| die "tpgo_get_trainer_exe must be defined"
		declare -f tpgo_trainer_list > /dev/null \
			|| die "tpgo_trainer_list must be defined"
	fi

	if (( $(declare -f src_configure | wc -c) > 29 )) ; then
eerror
eerror "src_configure must be nop and renamed."
eerror
eerror "Rename src_configure -> _src_configure()."
eerror "Add src_configure() { :; }"
eerror
		die
	fi

	if (( $(declare -f multilib_src_configure | wc -c) > 38 )) ; then
eerror
eerror "multilib_src_configure must be renamed."
eerror
eerror "Rename multilib_src_configure -> _src_configure()."
eerror "Add src_configure() { :; }"
eerror
#		die
	fi
	if (( $(declare -f _src_configure | wc -c) == 0 )) ; then
ewarn
ewarn "_src_configure should be defined"
ewarn
	fi
	if (( $(declare -f _src_compile | wc -c) == 0 )) ; then
ewarn
ewarn "_src_configure should be defined"
ewarn
	fi
}

# @FUNCTION: _tpgo_prepare_pgo
# @INTERNAL
# @DESCRIPTION:
# Copies an existing profile snapshot into build space.
_tpgo_prepare_pgo() {
	local pgo_data_suffix_dir="${EPREFIX}${_TPGO_DATA_DIR}/${_TPGO_SUFFIX}"
	local pgo_data_staging_dir="${T}/pgo-${_TPGO_SUFFIX}"

	mkdir -p "${pgo_data_staging_dir}" || die
	if [[ -e "${pgo_data_suffix_dir}" ]] ; then
		cp -aT "${pgo_data_suffix_dir}" "${pgo_data_staging_dir}" || die
	fi
	touch "${pgo_data_staging_dir}/compiler_fingerprint" || die
}

# @FUNCTION: tpgo_src_prepare
# @DESCRIPTION:
# You must call this inside the multibuild loop in src_prepare or in a
# *src_prepare multibuild variant.  It has to be inside the loop so that the
# TPGO_IMPL can divide the pgo profile per ABI or module.  You must define
# TPGO_IMPL to divide PGO profiles if impl exists for example headless and
# non-headless builds.
tpgo_src_prepare() {
	_TPGO_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}${TPGO_IMPLS}"
	_tpgo_prepare_pgo
}

# @FUNCTION: _tpgo_configure
# @INTERNAL
# @DESCRIPTION:
# Sets up PGO flags
_tpgo_configure() {
	if use pgo && [[ "${PGO_PHASE}" == "PGI" ]] ; then
		einfo "Setting up PGI"
		if tc-is-clang ; then
			append-flags \
				-fprofile-generate="${pgo_data_staging_dir}"
		else
			append-flags \
				-fprofile-generate \
				-fprofile-dir="${pgo_data_staging_dir}"
		fi
	elif use pgo && [[ "${PGO_PHASE}" == "PGO" ]] ; then
		einfo "Setting up PGO"
		if tc-is-clang ; then
			llvm-profdata \
				merge \
				-output="${pgo_data_staging_dir}/pgo-custom.profdata" \
				"${pgo_data_staging_dir}" || die
			append-flags \
				-fprofile-use="${pgo_data_staging_dir}/pgo-custom.profdata"
		else
			append-flags \
				-fprofile-correction \
				-fprofile-use \
				-fprofile-dir="${pgo_data_staging_dir}"
		fi
	fi
}

# @FUNCTION: _tpgo_cmake_clean
# @INTERNAL
# @DESCRIPTION:
# Clears the build directory for a cmake based project.
# You must add this before cmake_src_configure
# The _pre_tpgo_set_clean hook can be used to override BUILD_DIR
_tpgo_cmake_clean() {
	[[ -n ${_CMAKE_ECLASS} || -n ${_CMAKE_UTILS_ECLASS} ]] || return
	declare -f _pre_tpgo_set_clean > /dev/null \
		|| ewarn "_pre_tpgo_set_clean should be defined if BUILD_DIR is changed"
	declare -f _pre_tpgo_set_clean > /dev/null && _pre_tpgo_set_clean
	[[ -e "${BUILD_DIR}" ]] || return

	if [[ -n "${CMAKE_IN_SOURCE_BUILD}" \
		|| "${CMAKE_USE_DIR}" == "${BUILD_DIR}" ]] ; then
		# TODO:  test
		eninja -t clean
		find "${BUILD_DIR}" -name "CMakeCache.txt" -delete || true
	else
		cd "${CMAKE_USE_DIR}" || die
		rm -rf "${BUILD_DIR}" || die
	fi
}

# @FUNCTION: _tpgo_autotools_clean
# @INTERNAL
# @DESCRIPTION:
# Clears the build directory for autotools based project.
# It assumes the current directory is the build directory
# The _pre_tpgo_set_clean can be used to change into the build directory.
_tpgo_autotools_clean() {
	declare -f _pre_tpgo_set_clean > /dev/null && _pre_tpgo_set_clean
	emake clean
}

# @FUNCTION: tpgo_meson_src_configure
# @DESCRIPTION:
# Add this in emesonargs
# Example:
# emesonargs=(
#	....
#	$(tpgo_meson_src_configure)
# )
# emesonargs+=( $(tpgo_meson_src_configure) )
#
# You still need to call tpgo_src_configure before meson_src_configure.
#
tpgo_meson_src_configure() {
	if [[ "${PGO_PHASE}" == "PGO" ]] ; then
		echo "--wipe"
	fi
}

# @FUNCTION: tpgo_src_configure
# @DESCRIPTION:
# You must call in _src_configure before cmake_src_configure
# It will wipe the build directory if out of source build for PGO and setup
# flags. The idea is to remove all .o files or .a files before building the
# final.  This is to prevent the possibility of already built skips when
# building PGO image.
#
tpgo_src_configure() {
	_TPGO_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}${TPGO_IMPLS}"
	if [[ "${PGO_PHASE}" == "PGO" ]] ; then
		if declare -f _tpgo_custom_clean > /dev/null ; then
			_tpgo_custom_clean
		elif [[ -n ${_CMAKE_ECLASS} || -n ${_CMAKE_UTILS_ECLASS} ]] ; then
			_tpgo_cmake_clean
		elif [[ -n ${_AUTOTOOLS_ECLASS} ]] ; then
			_tpgo_autotools_clean
		fi
	fi

	filter-flags -fprofile*
	local pgo_data_staging_dir="${T}/pgo-${_TPGO_SUFFIX}"
	mkdir -p "${pgo_data_staging_dir}" || die # Make first demo produce a PGO profile?

	if [[ "${TPGO_CONFIGURE_DONT_SET_FLAGS}" != "1" ]] ; then
		_tpgo_configure
	fi
}

# @FUNCTION: _tpgo_run_trainer
# @INTERNAL
# @DESCRIPTION:
# Runs the trainer executable
#
# A PGO trainer is a program that is either a benchmark, a demo, or a sample
# program.  This program will generate a PGO profile but doesn't have to be
# designed to generate PGO profiles.
#
# User defined event handlers:
#
# tpgo_get_trainer_exe (REQUIRED)
#
#   Summary:
#
#     The executable to use for training echoed as a string using the first
#     arg as
#
#   Args:
#
#     trainer - produced from tpgo_trainer_list
#
#   Returns:
#
#     string - The echoed relpath relative to BUILD_DIR or abspath of the program.
#
# tpgo_get_trainer_args (optional)
#
#  Summary:
#
#   Outputs the trainer args that correspond to the trainer provided as the
#   first arg.
#
#   Args:
#
#     trainer - produced from tpgo_trainer_list
#
#   Returns:
#
#     strings - list of arguments to be collected by a bash array
#
_tpgo_run_trainer() {
	local duration="${1}"
	shift 1
	local trainer="${@}"
	local now=$(date +"%s")
	local done_at=$((${now} + ${duration}))
	local done_at_s=$(date --date="@${done_at}")
einfo
einfo "Running '${trainer}' trainer for ${duration}s to be completed at"
einfo "${done_at_s}"
einfo
	declare -f tpgo_get_trainer_exe > /dev/null \
		|| die "tpgo_get_trainer_exe must be defined"
	local trainer_exe=$(tpgo_get_trainer_exe "${trainer}")

	local trainer_args=()

	if declare -f tpgo_get_trainer_args > /dev/null ; then
		trainer_args=(
			$(tpgo_get_trainer_args "${trainer}")
		)
	fi

cat > "run.sh" <<EOF
#!${EPREFIX}/bin/sh

# Using & will prevent stall
echo "cmd:  \"${trainer_exe}\" ${trainer_args[@]}"
"${trainer_exe}" ${trainer_args[@]} &
pid=\$!

now=\$(date +"%s")
while (( \${now} < ${done_at} )) \
	&& ps -p \${pid} 2>/dev/null 1>/dev/null ; do
	sleep 1
	now=\$(date +"%s")
done
ps -p \${pid} 2>/dev/null 1>/dev/null \
	&& kill -9 \${pid}
true
EOF
	chmod +x "run.sh" || die
	if [[ "${TPGO_USE_X}" == "1" ]] ; then
		virtx ./run.sh

		if grep -q -r -e "cannot connect to X server" \
			"${T}/build.log" ; then
eerror
eerror "Detected cannot connect to the X server."
eerror
			die
		fi
	else
		./run.sh
	fi
	rm run.sh || die
}

# @FUNCTION: _tpgo_train_default
# @INTERNAL
# @DESCRIPTION:
# Runs the default trainer program
# The default trainer will just run all the programs in a timebox
# When the timebox expires, it moves on the next one.
#
# User definable event handlers:
#
#  tpgo_trainer_list (REQUIRED)
#
#    Summary:
#
#      Echos all programs to be run.
#
#    Returns:
#
#      A newline separated list of names
#
#  tpgo_pre_trainer (optional)
#
#    Summary:
#
#      Pre setup before executing trainer
#
#    Arg:
#
#      trainer - name of a trainer produced by tpgo_trainer_list
#
#  tpgo_post_trainer (optional)
#
#    Summary:
#
#      Cleanup function immediately after trainer
#
#    Arg:
#
#      trainer - name of a trainer produced by tpgo_trainer_list
#
_tpgo_train_default() {
	# Sandbox violation prevention
	if [[ "${TPGO_SANDBOX_EXCEPTION_GLSL}" == "1" ]] ; then
		export MESA_GLSL_CACHE_DIR="${HOME}/mesa_shader_cache"
		export MESA_SHADER_CACHE_DIR="${HOME}/mesa_shader_cache"
	fi
	if [[ "${TPGO_SANDBOX_EXCEPTION_INPUT}" == "1" ]] ; then
		for x in $(find "${BROOT}/dev/input" "${ESYSROOT}/dev/input" -name "event*") ; do
			einfo "Adding \`addwrite ${x}\` sandbox rule"
			addwrite "${x}"
		done
	fi

	_TPGO_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}${TPGO_IMPLS}"
	local pgo_data_staging_dir="${T}/pgo-${_TPGO_SUFFIX}"

	declare -f tpgo_trainer_list > /dev/null \
		|| die "tpgo_trainer_list must be defined"

	IFS=$'\n'
	local trainer
	for trainer in $(tpgo_trainer_list) ; do
		duration=${TPGO_TEST_DURATION}
		declare -f tpgo_override_duration > /dev/null \
			&& duration=$(tpgo_override_duration "${trainer}")
		declare -f tpgo_pre_trainer > /dev/null \
			&& tpgo_pre_trainer "${trainer}"
		_tpgo_run_trainer "${duration}" "${trainer}"
		declare -f tpgo_post_trainer > /dev/null \
			&& tpgo_post_trainer "${trainer}"
		# We would like to use tc-is-clang tc-is-gcc but it is broken.
		# Even after inspecting the log, it is over-engineered and
		# gross.
		if use pgo && [[ -z "${CC}" || "${CC}" =~ "gcc" ]] ; then
			if ! find "${pgo_data_staging_dir}" -name "*.gcda" \
				2>/dev/null 1>/dev/null ; then
ewarn
ewarn "Didn't generate a PGO profile"
ewarn
			fi
		elif use pgo && [[ "${CC}" =~ "clang" ]] ; then
			if ! find "${pgo_data_staging_dir}" -name "*.profraw" \
				2>/dev/null 1>/dev/null ; then
ewarn
ewarn "Didn't generate a PGO profile"
ewarn
			fi
		fi
	done
	IFS=$' \t\n'
	if use pgo && [[ -z "${CC}" || "${CC}" =~ "gcc" ]] ; then
		if ! find "${pgo_data_staging_dir}" -name "*.gcda" ; then
eerror
eerror "Didn't generate a PGO profile"
eerror
			die
		fi
	elif use pgo && [[ "${CC}" =~ "clang" ]] ; then
		if ! find "${pgo_data_staging_dir}" -name "*.profraw" ; then
eerror
eerror "Didn't generate a PGO profile"
eerror
			die
		fi
	fi
}

# @FUNCTION: _tpgo_train
# @INTERNAL
# @DESCRIPTION:
# Runs the PGO training program.
# You may define _tpgo_train_custom handler to perform your
# own training.
#
# User defined event handlers:
#
#   tpgo_train_custom (optional)
#
_tpgo_train() {
	if declare -f tpgo_train_custom > /dev/null ; then
		tpgo_train_custom
	else
		_tpgo_train_default
	fi
}

# @FUNCTION: _tpgo_is_profile_reusable
# @INTERNAL
# @DESCRIPTION:
# Checks if requirements are met for profile reuse, skipping PGI and PGT
_tpgo_is_profile_reusable() {
	if use pgo ; then
		local pgo_data_staging_dir="${T}/pgo-${_TPGO_SUFFIX}"

		if [[ -z "${CC}" ]] ; then
# This shouldn't set the CC but we have to for -dumpmachine.
			export CC=$(tc-getCC)
			export CXX=$(tc-getCXX)
		fi
einfo
einfo "CC=${CC}"
einfo "CXX=${CXX}"
einfo

		touch "${pgo_data_staging_dir}/compiler_fingerprint" \
			|| die "You must call tpgo_src_prepare before calling tpgo_src_compile"
		# Has same compiler?
		if tc-is-gcc ; then
			local actual=$("${CC}" -dumpmachine | sha512sum | cut -f 1 -d " ")
			local expected=$(cat "${pgo_data_staging_dir}/compiler_fingerprint")
			if [[ "${actual}" != "${expected}" ]] ; then
ewarn
ewarn "GCC incompatable:"
ewarn
ewarn "actual: ${actual}"
ewarn "expected: ${expected}"
ewarn
				return 1
			fi
		elif tc-is-clang ; then
			local actual=$("${CC}" -dumpmachine | sha512sum | cut -f 1 -d " ")
			local expected=$(cat "${pgo_data_staging_dir}/compiler_fingerprint")
			if [[ "${actual}" != "${expected}" ]] ; then
ewarn
ewarn "Clang incompatable:"
ewarn
ewarn "actual: ${actual}"
ewarn "expected: ${expected}"
ewarn
				return 1
			fi
		else
			return 2
ewarn
ewarn "Compiler is not supported."
ewarn
		fi

		# Has profile?
		if tc-is-gcc && find "${pgo_data_staging_dir}" -name "*.gcda" \
			2>/dev/null 1>/dev/null ; then
			:; # pass
		elif tc-is-clang && find "${pgo_data_staging_dir}" -name "*.profraw" \
			2>/dev/null 1>/dev/null ; then
			:; # pass
		else
ewarn
ewarn "NO PGO PROFILE"
ewarn
			return 1
		fi

		return 0
	fi
	return 1
}


# It is recommended to use (nested) loops instead of event handlers.
# The event handlers/eclass hide the information away from you.

# @FUNCTION: tpgo_src_compile
# @DESCRIPTION:
# The compile phase.  If using cmake, you must explicitly assign
# CMAKE_USE_DIR and BUILD_DIR within each _src_* since tpgo_compile
# will decide which ones to call.
#
# Overriding _src_prepare is optional and not recommended.  You may just stick
# to src_prepare() instead.
#
# This creates a hook system for PGO.  You must call this within src_compile()
# You can use _src_pre_pgi, _src_post_pgi to add additional pgi steps for internal dependencies.
# You can use _src_pre_pgo, _src_post_pgo to add additional pgo steps for internal dependencies.
# Examples:
#
# _src_configure() {
#	CMAKE_USE_DIR="${S}"
#	BUILD_DIR="${S}"
#	cd "${CMAKE_USE_DIR}" || die
#	tpgo_src_configure
#	echo "hello prepare world";
#	cmake_src_configure
# }
#
# _src_compile() {
#	CMAKE_USE_DIR="${S}"
#	BUILD_DIR="${S}"
#	cd "${BUILD_DIR}" || die
#	echo "hello compile world";
#	cmake_src_compile
# }
#
# src_compile() {
#	compile_abi() {
#		tpgo_src_compile
#	}
#	multilib_foreach_abi compile_abi
# }
#
# src_compile() {
#	tpgo_compile
# }
#
# The _src_pre_train is intended for LD_LIBRARY_PATH linker overrides
# and staged installs into ED.
#
# The _src_post_train is intended to wipe the staged installs in ED
# or to clear the LD_LIBRARY_PATH.
#
tpgo_src_compile() {
	_TPGO_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}${TPGO_IMPLS}"
	local is_pgoable=1
	if declare -f tpgo_meets_requirements > /dev/null ; then
		if tpgo_meets_requirements ; then
			is_pgoable=1
		else
			is_pgoable=0
		fi
	fi
einfo
einfo "is_pgoable=${is_pgoable}"
einfo

	local skip_pgi="no"
	_tpgo_is_profile_reusable
	local ret_reuse="$?" # 0 = yes, 1 = no, 2 = unsupported_compiler
	if [[ "${TPGO_PROFILES_REUSE:-1}" != "1" ]] ; then
		:;
	elif [[ "${ret_reuse}" == "0" ]] ; then
		skip_pgi="yes"
	fi

einfo
einfo "is_profile_reusable=${skip_pgi} "
einfo

	if use pgo && (( ${is_pgoable} == 1 )) ; then
		if [[ "${skip_pgi}" == "no" ]] ; then
			PGO_PHASE="PGI"
			declare -f _src_pre_pgi > /dev/null && _src_pre_pgi
			declare -f _src_prepare > /dev/null && _src_prepare
			declare -f _src_configure > /dev/null && _src_configure
			declare -f _src_compile > /dev/null && _src_compile
			declare -f _src_post_pgi > /dev/null && _src_post_pgi
			declare -f _src_pre_train > /dev/null && _src_pre_train
			_tpgo_train
			declare -f _src_post_train > /dev/null && _src_post_train
		fi
		PGO_PHASE="PGO"
		declare -f _src_pre_pgo > /dev/null && _src_pre_pgo
		declare -f _src_prepare > /dev/null && _src_prepare
		declare -f _src_configure > /dev/null && _src_configure
		declare -f _src_compile > /dev/null && _src_compile
		declare -f _src_post_pgo > /dev/null && _src_post_pgo
	else
		PGO_PHASE="NO_PGO"
		declare -f _src_prepare > /dev/null && _src_prepare
		declare -f _src_configure > /dev/null && _src_configure
		declare -f _src_compile > /dev/null && _src_compile
	fi
}

if [[ "${TPGO_MULTILIB}" == "1" ]] ; then
# @FUNCTION: tpgo_multilib_src_compile
# @DESCRIPTION:
# This is for simple ebuilds.  For more advanced ebuilds
# use tpgo_compile instead.
# Example:
#
# TPGO_MULTILIB=1
# inherit autotools tpgo
#
# src_prepare() {
#	prepare_abi() {
#		cp -a "${S}" "${S}-${MULTILIB_ABI_FLAG}.${ABI}" || die
#	}
#	multilib_foreach_prepare prepare_abi
# }
#
# _src_configure() {
#	BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}"
#	cd "${BUILD_DIR}" || die
#	tpgo_src_configure
#	echo "hello prepare world";
#	local myconf=( ... )
#	econf ${myconf[@]}
# }
#
# _src_compile() {
#	BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}"
#	cd "${BUILD_DIR}" || die
#	echo "hello compile world";
#	emake
# }
#
# src_compile() {
#	tpgo_multilib_compile
# }
tpgo_multilib_src_compile() {
	tpgo_compile_abi() {
		tpgo_src_compile
	}
	multilib_foreach_abi tpgo_compile_abi
}
fi

# @FUNCTION: tpgo_src_install
# @DESCRIPTION:
# Saves the profile to skip instrumentation on patch releases
tpgo_src_install() {
	if use pgo && [[ "${TPGO_PROFILES_REUSE:-1}" == "1" ]] ; then
		_TPGO_SUFFIX="${MULTILIB_ABI_FLAG}.${ABI}${TPGO_IMPLS}"
		local pgo_data_suffix_dir="${_EPGO_DATA_DIR}/${_TPGO_SUFFIX}"
		keepdir "${pgo_data_suffix_dir}"

		if [[ -z "${CC}" ]] ; then
			# It should be done earlier.
			export CC=$(tc-getCC)
			export CXX=$(tc-getCXX)
		fi

		cp -aT \
			"${pgo_data_staging_dir}" \
			"${pgo_data_suffix_dir}" \
			|| die

		if tc-is-gcc ; then
			"${CC}" -dumpmachine \
				> "${ED}/${pgo_data_suffix_dir}/compiler" || die
			"${CC}" -dumpmachine | sha512sum | cut -f 1 -d " " \
				> "${ED}/${pgo_data_suffix_dir}/compiler_fingerprint" || die
		elif tc-is-clang ; then
			"${CC}" -dumpmachine \
				> "${ED}/${pgo_data_suffix_dir}/compiler" || die
			"${CC}" -dumpmachine | sha512sum | cut -f 1 -d " " \
				> "${ED}/${pgo_data_suffix_dir}/compiler_fingerprint" || die
		fi
	fi
}
