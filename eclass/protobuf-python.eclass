# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS:  protobuf-python.eclass
# @MAINTAINER:  Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS:  8
# @BLURB:  set multislot protobuf-python pythonpath
# @DESCRIPTION:
# Helper to set the PYTHONPATH for multislot protobuf-python.

#
# Keep version/slot aligned
#
# LTS D11/U22 - grpc:3/1.30 - protobuf-cpp:3/3.12 - protobuf-python:3/3.12 - abseil-cpp:20200225 - re2:20220623 # PyTorch 2.9
# LTS D12/U24 - grpc:3/1.51 - protobuf-cpp:3/3.21 - protobuf-python:4/4.21 - abseil-cpp:20220623 - re2:20220623 # Tensorflow 2.17, JAX
# Rolling G23 - grpc:4/1.62 - protobuf-cpp:4/4.25 - protobuf-python:4/4.25 - abseil-cpp:20240116 - re2:20220623 # Apache Arrow
# Rolling G23 - grpc:5/1.71 - protobuf-cpp:5/5.29 - protobuf-python:5/5.29 - abseil-cpp:20240722 - re2:20240116 # TensorFlow 2.20, LocalAI
# Rolling G23 - grpc:6/1.75 - protobuf-cpp:6/6.33 - protobuf-python:6/6.33 - abseil-cpp:20250512 - re2:20240116
#

case ${EAPI:-0} in
	[8]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_PROTOBUF_PYTHON_ECLASS} ]] ; then
_PROTOBUF_PYTHON_ECLASS=1

# @ECLASS_VARIABLE:  PROTOBUF_PYTHON_SLOTS_3
# @DESCRIPTION:
# Adds all protobuf-python 3.x slots
PROTOBUF_PYTHON_SLOTS_3=(
	"3.12"
)

# @ECLASS_VARIABLE:  PROTOBUF_PYTHON_SLOTS_4
# @DESCRIPTION:
# Adds all protobuf-python 4.x slots for any protobuf-cpp
PROTOBUF_PYTHON_SLOTS_4=(
	"4.21" # For python-cpp:3
	"4.25" # For python-cpp:4
)

# @ECLASS_VARIABLE:  PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_3
# @DESCRIPTION:
# Adds all protobuf-python 4.x slots compatible with protobuf-cpp:3
PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_3=(
	"4.21" # For python-cpp:3
)

# @ECLASS_VARIABLE:  PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_4
# @DESCRIPTION:
# Adds all protobuf-python 4.x slots compatible with protobuf-cpp:4
PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_4=(
	"4.25" # For python-cpp:4
)

# @ECLASS_VARIABLE:  PROTOBUF_PYTHON_SLOTS_5
# @DESCRIPTION:
# Adds all protobuf-python 5.x slots
PROTOBUF_PYTHON_SLOTS_5=(
	"5.29"
)

# @ECLASS_VARIABLE:  PROTOBUF_PYTHON_SLOTS_6
# @DESCRIPTION:
# Adds all protobuf-python 6.x slots
PROTOBUF_PYTHON_SLOTS_6=(
	"6.33"
)

# @FUNCTION:  protobuf-python_set_pythonpath
# @DESCRIPTION:
# Set the PYTHONPATH for protobuf python bindings.
#
# python_configure() {
#   local PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_4[@]}" )
#   protobuf_python_set_pythonpath
# }
#
protobuf-python_set_pythonpath() {
	if [[ -z "${PROTOBUF_PYTHON_SLOTS[@]}" ]] ; then
eerror "QA:  PROTOBUF_PYTHON_SLOTS needs to be populated"
		die
	fi
	local x=""
	local s=""
	for x in "${PROTOBUF_PYTHON_SLOTS[@]}" ; do
		if has_version "dev-python/protobuf:${x}" ; then
			s="${x}"
			break
		fi
	done
	if [[ -z "${x}" ]] ; then
eerror "Protobuf slot not found.  Emerge protobuf:<slot>, where <slot> is ${PROTOBUF_PYTHON_SLOTS[@]}"
		die
	fi

	# Sanitize/isolate paths
	export PYTHONPATH=$(echo "${PYTHONPATH}" | tr ":" $'\n' | sed -e "\|/usr/lib/protobuf-python|d" | tr $'\n' ":")

	export PYTHONPATH="/usr/lib/protobuf-python/${s}/lib/${EPYTHON}/site-packages:${PYTHONPATH}"
}

fi
