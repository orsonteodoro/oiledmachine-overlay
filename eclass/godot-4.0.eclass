# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

STATUS="stable"
LLVM_SLOTS=(15 14 13) # See https://github.com/godotengine/godot/blob/4.0-stable/misc/hooks/pre-commit-clang-format#L79
PYTHON_COMPAT=( python3_{8..11} )

CA_CERTIFICATES_PV="20230602"
ENET_PV="1.3.17" # Upstream uses live
EMBREE_PV="3.13.5"
FREETYPE_PV="2.12.1"
GLSLANG_PV="1.3.231.1"
ICU_PV="72.1"
LIBOGG_PV="1.3.5"
LIBPCRE2_PV="10.40"
LIBPNG_PV="1.6.38"
LIBSQUISH_PV="1.15"
LIBTHEORA_PV="1.2.0_pre9999"
LIBVORBIS_PV="1.3.7"
LIBWEBP_PV="1.3.0"
MBEDTLS_PV="2.18.2"
MINIUPNPC_PV="2.2.4"
MONO_PV="6.12.0.182" # same as godot-export-templates-bin
MONO_PV_MIN="6.0.0.176"
MSDFGEN_PV="1.10"
PKGCONF_PV="1.3.7"
RECASTNAVIGATION_PV="1.6.0"
SPEECH_DISPATCHER_PV="0.11.4-r1" # From past experience.  speech-dispatcher team noted a bug.
SPEECH_DISPATCHER_PV_MIN="0.8.8"
WSLAY_PV="1.1.1"
ZLIB_PV="1.2.13"
ZSTD_PV="1.5.5"
