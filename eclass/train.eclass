# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: train.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: train eclass for three step optimizations
# @DESCRIPTION:
# Universalizes three step training across different three step optimizations.

# DO NOT INHERIT THIS ECLASS IN THE EBUILD LEVEL.  FOR ECLASSES ONLY.
# You may, however, use some event handlers such as train_trainer_custom
# in the ebuild context.

# Only one train instance allowed.
TRAIN_MUX="none" # It can only be tpgo, tbolt, ebolt, epgo, none.

if [[ "${TRAIN_USE_X}" == "1" ]] ;then
	inherit virtualx
fi

__VIRTX_BDEPENDS="
	x11-base/xorg-server[xvfb]
	x11-apps/xhost
"

if [[ "${TRAIN_USE_X}" == "1" && "${TRAIN_NO_X_DEPENDS}" != "1" ]] ;then
	BDEPEND+="
		pgo? (
			${__VIRTX_BDEPENDS}
		)
	"
fi

# @FUNCTION: _src_train
# Defines

# @ECLASS_VARIABLE: TRAIN_USE_X
# @DESCRIPTION:
# Runs GUI in X.  You can use console apps in this also.

# @ECLASS_VARIABLE: TRAIN_NO_X_DEPENDS
# @DESCRIPTION:
# Disables X depends

# @ECLASS_VARIABLE: TRAIN_TEST_DURATION
# @DESCRIPTION:
# The timebox in seconds for a trainer.
TRAIN_TEST_DURATION=${TRAIN_TEST_DURATION:-120} # 2 min

# @ECLASS_VARIABLE: TRAIN_SANDBOX_EXCEPTION_GLSL
# @DESCRIPTION:
# Add sandbox exceptions for GLSL.

# @ECLASS_VARIABLE: TRAIN_SANDBOX_EXCEPTION_INPUT
# @DESCRIPTION:
# Add sandbox exceptions for input.

# @FUNCTION: train_meets_requirements
# @RETURN:
# 0 - as the exit code if it has installed assets and training dependencies
# 1 - as the exit code if it did not install assets or did not install dependencies
# @DESCRIPTION:
# Reports if the prerequisites to train are met.  The implication is that if it
# doesn't have the assets, or doesn't have the training tool, or doesn't have
# the dependency to that training tool, it will fall back to as if USE="-pgo -bolt".
# Example scenario:  dynamic linking to be train with a separate package with
# app that uses the dynamic library.  If the app is not installed, then
# fallback to normal merging sequence.
#
# This function is actually a user defined event handler and optional.

# @FUNCTION: train_setup
# @DESCRIPTION:
# Checks for ebuild flaws or if prereqs are met
train_setup() {
	if ! declare -f train_trainer_custom > /dev/null ; then
		declare -f train_get_trainer_exe > /dev/null \
			|| die "train_get_trainer_exe must be defined"
		declare -f train_trainer_list > /dev/null \
			|| die "train_trainer_list must be defined"
	fi

}

# @FUNCTION: _train_run_trainer
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
# train_get_trainer_exe (REQUIRED)
#
#   Summary:
#
#     The executable to use for training echoed as a string using the first
#     arg as
#
#   Args:
#
#     trainer - produced from train_trainer_list
#
#   Returns:
#
#     string - The echoed relpath relative to BUILD_DIR or abspath of the program.
#
# train_get_trainer_args (optional)
#
#  Summary:
#
#   Outputs the trainer args that correspond to the trainer provided as the
#   first arg.
#
#   Args:
#
#     trainer - produced from train_trainer_list
#
#   Returns:
#
#     strings - list of arguments to be collected by a bash array
#
_train_run_trainer() {
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
	declare -f train_get_trainer_exe > /dev/null \
		|| die "train_get_trainer_exe must be defined"
	local trainer_exe=$(train_get_trainer_exe "${trainer}")

	local trainer_args=()

	if declare -f train_get_trainer_args > /dev/null ; then
		trainer_args=(
			$(train_get_trainer_args "${trainer}")
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
	if [[ "${TRAIN_USE_X}" == "1" ]] ; then
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

# @FUNCTION: _train_trainer_default
# @INTERNAL
# @DESCRIPTION:
# Runs the default trainer program
# The default trainer will just run all the programs in a timebox
# When the timebox expires, it moves on the next one.
#
# User definable event handlers:
#
#  train_trainer_list (REQUIRED)
#
#    Summary:
#
#      Echos all programs to be run.
#
#    Returns:
#
#      A newline separated list of names
#
#  train_pre_trainer (optional)
#
#    Summary:
#
#      Pre setup before executing the training session
#
#    Arg:
#
#      trainer - name of a trainer produced by train_trainer_list
#
#  train_post_trainer (optional)
#
#    Summary:
#
#      Cleanup function immediately after the training session
#
#    Arg:
#
#      trainer - name of a trainer produced by train_trainer_list
#
#
# Call tree:
#
# _src_pre_train
# _src_train:
#   _train_trainer_default
#     trainer0:
#       train_pre_trainer
#       _train_run_trainer
#       train_post_trainer
#     trainer1:
#       train_pre_trainer
#       _train_run_trainer
#       train_post_trainer
#     ...
#     trainerN:
#       train_pre_trainer
#       _train_run_trainer
#       train_post_trainer
# _src_post_train
#

VERIFY_FUNCTIONS_WARN=()
VERIFY_FUNCTIONS_FATAL=()

# @FUNCTION: subscribe_verify_profile_warn
# @DESCRIPTION:
# Subscribes the event handler function to the verify missing profile warn event.
# The event handler function should never call die.
subscribe_verify_profile_warn() {
	local f="${1}"
	VERIFY_FUNCTIONS_WARN+=( "${f}" )
}


# @FUNCTION: subscribe_verify_profile_fatal
# @DESCRIPTION:
# Subscribes the event handler function to the verify missing profile fatal event.
# The event handler function is responsible to call the die function.
subscribe_verify_profile_fatal() {
	local f="${1}"
	VERIFY_FUNCTIONS_FATAL+=( "${f}" )
}

# @FUNCTION: _train_trainer_default
# @DESCRIPTION:
# The default trainer function manager
_train_trainer_default() {
	# Sandbox violation prevention
	if [[ "${TRAIN_SANDBOX_EXCEPTION_GLSL}" == "1" ]] ; then
		export MESA_GLSL_CACHE_DIR="${HOME}/mesa_shader_cache"
		export MESA_SHADER_CACHE_DIR="${HOME}/mesa_shader_cache"
	fi
	if [[ "${TRAIN_SANDBOX_EXCEPTION_INPUT}" == "1" ]] ; then
		for x in $(find "${BROOT}/dev/input" "${ESYSROOT}/dev/input" -name "event*") ; do
			einfo "Adding \`addwrite ${x}\` sandbox rule"
			addwrite "${x}"
		done
	fi

	declare -f train_trainer_list > /dev/null \
		|| die "train_trainer_list must be defined"

	IFS=$'\n'
	local trainer
	for trainer in $(train_trainer_list) ; do
		duration=${TRAIN_TEST_DURATION}
		declare -f train_override_duration > /dev/null \
			&& duration=$(train_override_duration "${trainer}")
		declare -f train_pre_trainer > /dev/null \
			&& train_pre_trainer "${trainer}"
		_train_run_trainer "${duration}" "${trainer}"
		declare -f train_post_trainer > /dev/null \
			&& train_post_trainer "${trainer}"
		# We would like to use tc-is-clang tc-is-gcc but it is broken.
		# Even after inspecting the log, it is over-engineered and
		# gross.
		if (( ${#VERIFY_FUNCTIONS_WARN[@]} > 0 )) ; then
			for f in ${VERIFY_FUNCTIONS_WARN[@]} ; do
				if [[ "${f}" =~ ^"${TRAIN_MUX}" ]] ; then
					"${f}"
				fi
			done
		fi
	done
	IFS=$' \t\n'
	if (( ${#VERIFY_FUNCTIONS_FATAL[@]} > 0 )) ; then
		for f in ${VERIFY_FUNCTIONS_FATAL[@]} ; do
			if [[ "${f}" =~ ^"${TRAIN_MUX}" ]] ; then
				"${f}"
			fi
		done
	fi
}

# @FUNCTION: _src_train
# @INTERNAL
# @DESCRIPTION:
# Runs the PGO training program.
# You may define _train_trainer_custom handler to perform your
# own training in the eclass.
#
# _src_train should only be called in the eclass context.
#
# User defined event handlers:
#
#   train_trainer_custom (optional)
#
_src_train() {
	if declare -f train_trainer_custom > /dev/null ; then
		train_trainer_custom
	else
		_train_trainer_default
	fi
}
