# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# U22

# Versioning stored here to dedupe requirements in both godot-editor and export template ebuilds.

STATUS="stable"

inherit secure-version

CLIPPER2_PV="1.4.0"
DOTNET_SDK_PV="8.0"
DOTNET_SDK_SLOT="8.0"
ENET_PV="1.3.18" # Upstream uses live
EMBREE_PV="4.3.1"
EMSCRIPTEN_PV="3.1.64"
EMSCRIPTEN_SLOT="19-3.1" # ${LLVM_SLOT}-$(ver_cut 1-2 ${EMSCRIPTEN_PV})
GCC_PV="11.4.0"
GCC_COMPAT=(
	"gcc_slot_11_5" # Same default slot as U22, forced for compatibility with prebuilt export template
)
GLSLANG_PV="1.3.283.0"
LLVM_COMPAT=( 18 ) # U22 uses 14 (as default), but oiledmachine-overlay only has >= 18
LLVM_MAX_SLOT="18"
MINIUPNPC_PV="2.2.8"
MSDFGEN_PV="1.12"
OPENXR_PV="1.1.41"
PKGCONF_PV="1.3.7" # skip

# Upstream builds with 3.13 or 3.8.
# CI uses the latest Python 3.x (3.13) in https://github.com/actions/runner-images/blob/ubuntu22/20250323.1/images/ubuntu/Ubuntu2204-Readme.md#python
# U22 - 3.10, 3.11
PYTHON_COMPAT=( "python3_"{10,11,13} ) # Override for bytecode compatiblity U22

WSLAY_PV="1.1.1"
