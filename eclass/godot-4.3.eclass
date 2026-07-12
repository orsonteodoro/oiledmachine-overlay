# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# U20

# Versioning stored here to dedupe requirements in both godot-editor and export template ebuilds.

STATUS="stable"

inherit secure-version

CLIPPER2_PV="1.3.0"
DOTNET_SDK_PV="8.0"
DOTNET_SDK_SLOT="8.0"
EMSCRIPTEN_PV="3.1.64"
EMSCRIPTEN_SLOT="19-3.1" # ${LLVM_SLOT}-$(ver_cut 1-2 ${EMSCRIPTEN_PV})
GCC_PV="11.4.0" # Unverified because logs deleted
GCC_COMPAT=(
	"gcc_slot_11_5" # Same default slot as U22, forced for compatibility with prebuilt export template
)
GLSLANG_PV="1.3.283.0"
LIBSQUISH_PV="1.15"
LLVM_COMPAT=( 18 ) # U22 uses 14 (as default), but oiledmachine-overlay only has >= 18
LLVM_MAX_SLOT="18"
MINIUPNPC_PV="2.2.7"
MSDFGEN_PV="1.11"
OPENXR_PV="1.0.34"
PKGCONF_PV="1.3.7" # skip

# CI uses the latest Python 3.x (3.12) in https://github.com/actions/runner-images/blob/ubuntu20/20240811.1/images/ubuntu/Ubuntu2004-Readme.md#python
# U20 - 3.8, 3.9
PYTHON_COMPAT=( "python3_"{8,9,12} ) # Override for bytecode compatiblity with U20

WSLAY_PV="1.1.1"

