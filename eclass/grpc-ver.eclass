# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: grpc-ver.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass for grpc version control
# @DESCRIPTION:
# Eclass for grpc version tables.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z "${_GRPC_VER_ECLASS}" ]]; then
_GRPC_VER_ECLASS=1

# @ECLASS_VARIABLE: GRPC_SLOTS
# @DESCRIPTION:
# All gRPC slots
export GRPC_SLOTS=(
	"1.49"
	"1.52"
	"1.53"
	"1.54"
	"1.55"
	"1.56"
	"1.57"
	"1.58"
	"1.59"
	"1.60"
	"1.61"
	"1.62"
	"1.63"
	"1.64"
	"1.65"
	"1.66"
	"1.67"

)

# @ECLASS_VARIABLE: GRPC_PROTOBUF_3_SLOTS
# @DESCRIPTION:
# gRPC slots corresponding to Protobuf 3 only.
export GRPC_PROTOBUF_3_SLOTS=(
	"1.49"
	"1.52"
	"1.53"
	"1.54"
)

# @ECLASS_VARIABLE: GRPC_PROTOBUF_4_SLOTS
# @DESCRIPTION:
# gRPC slots corresponding to Protobuf 4 only.
export GRPC_PROTOBUF_4_SLOTS=(
	"1.55"
	"1.56"
	"1.57"
	"1.58"
	"1.59"
	"1.60"
	"1.61"
	"1.62"

)

# @ECLASS_VARIABLE: GRPC_PROTOBUF_5_SLOTS
# @DESCRIPTION:
# gRPC slots corresponding to Protobuf 5 only.
export GRPC_PROTOBUF_5_SLOTS=(
	"1.63"
	"1.64"
	"1.65"
	"1.66"
	"1.67"
)

# @FUNCTION: grpc_get_protobuf_slot
# @DESCRIPTION:
# Return the protobuf major-minor version corresponding to the grpc major-minor version.
grpc_get_protobuf_slot(){
	local key="${1}"
	declare -A GRPC_TO_PROTOBUF=(
		["1.49"]="3.21"
		["1.52"]="3.21"
		["1.53"]="3.21"
		["1.54"]="3.21"
		["1.55"]="4.23"
		["1.56"]="4.23"
		["1.57"]="4.23"
		["1.58"]="4.23"
		["1.59"]="4.24"
		["1.60"]="4.25"
		["1.61"]="4.25"
		["1.62"]="4.25"
		["1.63"]="5.26"
		["1.64"]="5.26"
		["1.65"]="5.26"
		["1.66"]="5.27"
		["1.67"]="5.27"
	)
	echo "${GRPC_TO_PROTOBUF[${key}]}"
}

fi
