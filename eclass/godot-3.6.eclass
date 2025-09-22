# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Versioning stored here to dedupe requirements in both godot-editor and export template ebuilds.

STATUS="stable"

BROTLI_PV="1.1.0"
BULLET_PV="3.25"
CA_CERTIFICATES_PV="20250408"
ENET_PV="1.3.17" # Upstream uses live
EMBREE_PV="3.13.5"
FREETYPE_PV="2.12.1"
LIBOGG_PV="1.3.5"
LIBPCRE2_PV="10.42"
LIBPNG_PV="1.6.43"
LIBSQUISH_PV="1.15"
LIBTHEORA_PV="1.1.1"
LIBVORBIS_PV="1.3.7"
LIBVPX_PV="1.6.0"
LIBWEBP_PV="1.3.2"
LLVM_COMPAT=( {14..13} ) # See https://github.com/godotengine/godot/blob/3.6-stable/misc/hooks/pre-commit-clang-format#L79
LLVM_MAX_SLOT="${LLVM_COMPAT[0]}"
MBEDTLS_PV="2.28.10"
MONO_PV="6.12.0.182" # same as godot-export-templates-bin
MONO_PV_MIN="6.0.0.176"
MINIUPNPC_PV="2.2.7"
OPUS_PV="1.1.5"
OPUSFILE_PV="0.8"
PKGCONF_PV="1.3.7"
PYTHON_COMPAT=( python3_{8..11} )
RECASTNAVIGATION_PV="1.6.0"
WSLAY_PV="1.1.1"
ZLIB_PV="1.3.1"
ZSTD_PV="1.5.5"
