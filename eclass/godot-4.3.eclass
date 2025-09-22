# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

STATUS="stable"

BROTLI_PV="1.1.0"
CA_CERTIFICATES_PV="20250311"
CLIPPER2_PV="1.3.0"
ENET_PV="1.3.18" # Upstream uses live
EMBREE_PV="4.3.1"
FREETYPE_PV="2.13.2"
GLSLANG_PV="1.3.283.0"
ICU_PV="75.1"
LIBOGG_PV="1.3.5"
LIBPCRE2_PV="10.43"
LIBPNG_PV="1.6.43"
LIBSQUISH_PV="1.15"
LIBTHEORA_PV="1.2.0_pre9999"
LIBVORBIS_PV="1.3.7"
LIBWEBP_PV="1.4.0"
LLVM_COMPAT=( {15..13} ) # See https://github.com/godotengine/godot/blob/4.3-stable/misc/hooks/pre-commit-clang-format#L79
LLVM_MAX_SLOT="${LLVM_COMPAT[0]}"
MBEDTLS_PV="3.6.0"
MINIUPNPC_PV="2.2.7"
MONO_PV="6.12.0.182" # same as godot-export-templates-bin # todo
MONO_PV_MIN="6.0.0.176" # todo
MSDFGEN_PV="1.11"
OPENXR_PV="1.0.34"
PKGCONF_PV="1.3.7" # skip
PYTHON_COMPAT=( python3_{8..11} )
RECASTNAVIGATION_PV="1.6.0"
SPEECH_DISPATCHER_PV="0.11.4-r1" # From past experience.  speech-dispatcher team noted a bug. # skip
SPEECH_DISPATCHER_PV_MIN="0.8.8" # skip
WSLAY_PV="1.1.1"
ZLIB_PV="1.3.1"
ZSTD_PV="1.5.6"
