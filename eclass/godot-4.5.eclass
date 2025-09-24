# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# U22

# Versioning stored here to dedupe requirements in both godot-editor and export template ebuilds.

STATUS="stable"

BROTLI_PV="1.1.9"
CA_CERTIFICATES_PV="20250408"
CLIPPER2_PV="1.5.4"
DOTNET_SDK_PV="8.0.100"
DOTNET_SDK_SLOT="8.0"
ENET_PV="1.3.18" # Upstream uses live
EMBREE_PV="4.4.0"
EMSCRIPTEN_PV="4.0.11"
EMSCRIPTEN_SLOT="21-4.0" # ${LLVM_SLOT}-$(ver_cut 1-2 ${EMSCRIPTEN_PV})
FREETYPE_PV="2.13.3"
GCC_PV="11.4.0"
GLSLANG_PV="1.3.283.0"
GRAPHITE2_PV="1.3.14"
HARFBUZZ_PV="11.3.2"
ICU_PV="77.1"
LIBJPEG_TURBO_PV="3.1.0"
LIBOGG_PV="1.3.5"
LIBPCRE2_PV="10.45"
LIBPNG_PV="1.6.48"
LIBSDL3_PV="3.2.14"
LIBTHEORA_PV="1.2.0_pre9999"
LIBVORBIS_PV="1.3.7"
LIBWEBP_PV="1.5.0"
LLVM_COMPAT=( 18 ) # U22 uses 14 (as default), but oiledmachine-overlay only has >= 18
LLVM_MAX_SLOT="${LLVM_COMPAT[0]}"
MBEDTLS_PV="3.6.4"
MINIUPNPC_PV="2.3.3"
MSDFGEN_PV="1.12.1"
OPENXR_PV="1.1.49"
PKGCONF_PV="1.3.7" # skip
PYTHON_COMPAT=( "python3_13" ) # Upstream builds with 3.13 or 3.8
RECASTNAVIGATION_PV="1.6.0"
SPEECH_DISPATCHER_PV="0.11.4-r1" # From past experience.  speech-dispatcher team noted a bug. # skip
SPEECH_DISPATCHER_PV_MIN="0.8.8" # skip
WSLAY_PV="1.1.1"
ZLIB_PV="1.3.1"
ZSTD_PV="1.5.7"
