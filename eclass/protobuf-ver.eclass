# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: protobuf-ver.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass for protobuf version control
# @DESCRIPTION:
# Eclass for protobuf version tables.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z "${_PROTOBUF_VER_ECLASS}" ]]; then
_PROTOBUF_VER_ECLASS=1

# @ECLASS_VARIABLE: PROTOBUF_SLOTS
# @DESCRIPTION:
# All active protobuf slots
export PROTOBUF_SLOTS=(
	"5.27"
	"5.26"
	"4.25"
	"4.24"
	"4.23"
	"3.21"
)

# @ECLASS_VARIABLE: PROTOBUF_3_SLOTS
# @DESCRIPTION:
# Protobuf 3 slots only
export PROTOBUF_3_SLOTS=(
	"3.21"
)

# @ECLASS_VARIABLE: PROTOBUF_4_SLOTS
# @DESCRIPTION:
# Protobuf 4 slots only
export PROTOBUF_4_SLOTS=(
	"4.25"
	"4.24"
	"4.23"
)

# @ECLASS_VARIABLE: PROTOBUF_5_SLOTS
# @DESCRIPTION:
# Protobuf 5 slots only
export PROTOBUF_5_SLOTS=(
	"5.27"
	"5.26"
)

fi
