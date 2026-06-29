# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: secure-versions.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 8 9
# @BLURB: secure versions for node/electron
# @DESCRIPTION:
# Install *only* secure versions for node/electron micropackages.

case ${EAPI:-0} in
	[89]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z "${_SECURE_VERSION_NODE_ECLASS}" ]] ; then
_SECURE_VERSION_NODE_ECLASS=1

# Entries below must have a NODE_ or NODE_<SLOT>_ prefix to prevent clobbering.
# Use NODE_<SLOT>_ for multislot version sensitive (See engines.node)
# Use NODE_ for version agnostic

# Multislot
# aws-sdk
# bcrypt
# eslint
# express
# firebase-admin
# jest
# mongoose
# mongodb
# node-sass
# npm
# pg
# sharp
# typescript
# uuid
NODE_24_GRPC_GRPC_JS_PV="1.9.16" # typescript@^5.1.x uses @types/node@20
NODE_24_PROTOBUFJS_PV="7.6.3" # @types/node@18
NODE_24_PROTOBUFJS_UTF8_PV="1.1.1"

# Unislot
NODE_DOMPURIFY_PV="3.4.11"
NODE_FORM_DATA_PV="4.0.6"
NODE_JS_YAML_PV="4.2.0"
NODE_NEXT_PV="15.5.16"
NODE_OPENTELEMETRY_CORE_PV="2.8.0"
NODE_TMP_PV="0.2.6"
NODE_UNDICI_PV="6.27.0"

fi
