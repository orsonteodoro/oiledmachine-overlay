# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# U22

# Versioning stored here to dedupe requirements in both godot-editor and export template ebuilds.

STATUS="stable"

inherit secure-version

BULLET_PV="3.25"
DOTNET_SDK_PV="9.0" # Relaxed, originally 9.0.200
DOTNET_SDK_SLOT="9.0"
EMSCRIPTEN_PV="3.1.39"
EMSCRIPTEN_SLOT="17-3.1" # ${LLVM_SLOT}-$(ver_cut 1-2 ${EMSCRIPTEN_PV})
GCC_PV="11.4.0"
GCC_COMPAT=(
	"gcc_slot_11_5" # Same default slot as U22, forced for compatibility with prebuilt export template
)
LIBSQUISH_PV="1.15"
LLVM_COMPAT=( 18 ) # U22 uses 14 (as default), but oiledmachine-overlay only has >= 18
LLVM_MAX_SLOT="18"
MINIUPNPC_PV="2.2.7"
MONO_PV="6.12.0"
OPUSFILE_PV="0.8"
PKGCONF_PV="1.3.7"

# CI uses the latest Python 3.x (3.14) in https://github.com/actions/runner-images/blob/ubuntu22/20251021.115/images/ubuntu/Ubuntu2204-Readme.md#python
# U22 - 3.10, 3.11
PYTHON_COMPAT=( "python3_"{10,11,14} ) # Override for bytecode compatiblity with U22

SQUISH_PV="1.15"
WSLAY_PV="1.1.1"
