# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# U22

# Versioning stored here to dedupe requirements in both godot-editor and export template ebuilds.

STATUS="stable"

BULLET_PV="3.25"
CA_CERTIFICATES_PV="20250408"
DOTNET_SDK_PV="9.0" # Relaxed, originally 9.0.200
DOTNET_SDK_SLOT="9.0"
ENET_PV="1.3.17" # Upstream uses live
EMBREE_PV="3.13.5"
FREETYPE_PV="2.12.1"
GCC_PV="11.4.0"
LIBOGG_PV="1.3.5"
LIBPCRE2_PV="10.42"
LIBPNG_PV="1.6.43"
LIBSQUISH_PV="1.15"
LIBTHEORA_PV="1.1.1"
LIBVORBIS_PV="1.3.7"
LIBVPX_PV="1.6.0"
LIBWEBP_PV="1.3.2"
LLVM_COMPAT=( 20 19 ) # Limited by dotnet-sdk ebuild.
LLVM_MAX_SLOT="${LLVM_COMPAT[0]}"
MBEDTLS_PV="2.28.10"
MINIUPNPC_PV="2.2.7"
OPUS_PV="1.1.5"
OPUSFILE_PV="0.8"
PKGCONF_PV="1.3.7"
PYTHON_COMPAT=( "python3_13" )
RECASTNAVIGATION_PV="1.6.0"
SPEECH_DISPATCHER_PV="0.11.4-r1" # From past experience.  speech-dispatcher team noted a bug. # skip
SPEECH_DISPATCHER_PV_MIN="0.8.8" # skip
SQUISH_PV="1.15"
WSLAY_PV="1.1.1"
ZLIB_PV="1.3.1"
ZSTD_PV="1.5.5"
