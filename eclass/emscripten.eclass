# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS:  emscripten.eclass
# @MAINTAINER:  Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS:  8
# @BLURB:  set multislot emscripten config for build systems
# @DESCRIPTION:
# Helpers to support multislot Emscripten under parallel emerge.

case ${EAPI:-0} in
	[8]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_ABSEIL_CPP_ECLASS} ]] ; then
_ABSEIL_CPP_ECLASS=1

inherit edo

# @FUNCTION:  emscripten_gen_hello_world
# @DESCRIPTION:
# Generate A Hello World source code to test the Emscripten toolchain.
emscripten_gen_hello_world() {
cat <<EOF > "${T}/hello.cc"
#include <iostream>
int main(int argc, char ** argv) {
	std::cout << "Hello World!" << std::endl;
}
EOF
}

# @FUNCTION:  emscripten_test_hello_world
# @DESCRIPTION:
# Test hello world with Emscripten toolchain
emscripten_test_hello_world() {
einfo "Testing emcc"
	edo "/usr/lib/emscripten/${EMSCRIPTEN_SLOT}/bin/emcc" -v
einfo "Testing em++"
	edo "/usr/lib/emscripten/${EMSCRIPTEN_SLOT}/bin/em++" -v

einfo "Testing hello_world.cc"
	if [[ "${__EMCC_WASM_BACKEND__}" == "1" ]] ; then
		echo "Please wait.  Pre-generating a emscripten.config_sanity_wasm file."
	else
		echo "Please wait.  Pre-generating a emscripten.config_sanity file."
	fi
	local sandbox=$(mktemp -d -p "${T}")
	pushd "${sandbox}"
		cp "${T}/hello_world.cc" "./" || die
		export EM_CACHE="${sandbox}/cache"
		export EMCC_CFLAGS=" -fno-stack-protector"
		edo "/usr/share/emscripten-${PV}/em++" \
			-stdlib=libc++ \
			"${T}/hello_world.cpp" \
			-o "hello_world.js"
	popd
	rm -rf "${sandbox}"
}

# @FUNCTION:  emscripten_gen_symlinks
# @DESCRIPTION:
# Create symlinks
emscripten_gen_symlinks() {
	mkdir -p "${WORKDIR}/bin" || die
einfo "Setting up symlinks"
	local additional_tools=()
	if is_x_op_y $(echo "${PV}" | cut -f 1 -d "-") ">=" 1.39.13 ; then
		additional_tools+=( embuilder emsize )
	fi
	local tools=(
		"em++"
		"em-config"
		"emar"
		"emcc"
		"emcmake"
		"emconfigure"
		"emmake"
		"emranlib"
		"emrun"
		"emscons"
	)
	local tool
	for tool in "${tools[@]}" ; do
		if [[ ! -f "${EROOT}/usr/share/emscripten-${PV}/${tool}" ]] ; then
			echo "Missing ${EROOT}/usr/share/emscripten-${PV}/${tool}.  Failed to set toolchain."
			die
	        fi
		ln -sf \
			"${ESYSROOT}/usr/share/emscripten-${PV}/${tool}" \
			"${WORKDIR}/bin/${tool}" \
			|| die
	done

}

# @FUNCTION:  emscripten_get_node_slot
# @DESCRIPTION:
# Gets the closest compatible node slot
emscripten_get_node_slot() {
	local node_slot=""
	local x
	for x in $(eval "echo {${NODE_SLOT_MIN}..25}") ; do
		node_slot="${x}"
		break
	done
	if [[ -z "${node_slot}" ]] ; then
eerror "Missing net-libs/nodejs.  Slot minimum supported is ${NODE_SLOT_MIN}."
		die
	fi
	echo "${node_slot}"
}

# @FUNCTION:  emscripten_set_env
# @DESCRIPTION:
# Generate the 99emscripten environment
emscripten_set_env() {
	if [[ -z "${EMSCRIPTEN_SLOT}" ]] ; then
eerror "QA:  EMSCRIPTEN_SLOT must be defined"
		die
	fi
	local node_slot=$(emscripten_get_node_slot)
	export EM_BINARYEN_ROOT="/usr/lib/binaryen/${BINARYEN_SLOT}"
	export EM_CACHE="${sandbox}/cache"
	export EM_CONFIG="${T}/emscripten-${ABI}.config"
	export EMCC_CFLAGS=" -fno-stack-protector"
	export CLOSURE_COMPILER="${CLOSURE_COMPILER_EXE}"
	export BINARYEN="/usr/lib/binaryen/${BINARYEN_SLOT}"
	export EMSCRIPTEN="${EPREFIX}/usr/lib/emscripten/${EMSCRIPTEN_SLOT}"
	export EMSDK_BINARYEN_BASE_PATH="/usr/lib/binaryen/${BINARYEN_SLOT}"
	export EMSDK_BINARYEN_LIB_PATH="/usr/lib/binaryen/${BINARYEN_SLOT}/lib"
	export EMSDK_BINARYEN_VERSION="${BINARYEN_SLOT}"
	export EMSDK_CLOSURE_COMPILER="${CLOSURE_COMPILER_EXE}"
	export EMSDK_LLVM_SLOT="${LLVM_SLOT}"
	export EMSDK_LLVM_ROOT="/usr/lib/llvm/${LLVM_SLOT}/bin"
	export EMSDK_NODE="${EPREFIX}/usr/lib/node/${node_slot}/bin/node"
	export EMSDK_NODE_VERSION_MIN="${NODE_SLOT_MIN}"
	export EMSDK_PYTHON="/usr/bin/python${PYTHON_SLOT}"
	if has_version "dev-util/emscripten:${EMSCRIPTEN_SLOT}[native-optimizer]" ; then
		export EMSCRIPTEN_NATIVE_OPTIMIZER="${EPREFIX}/usr/lib/emscripten/${EMSCRIPTEN_SLOT}/optimizer"
	else
		export EMSCRIPTEN_NATIVE_OPTIMIZER=""
	fi
	export PATH="${EPREFIX}/usr/lib/emscripten/${EMSCRIPTEN_SLOT}:${PATH}"
	export EMCC_WASM_BACKEND=${EMCC_WASM_BACKEND:-1} # 1=wasm, 0=emscripten-fastcomp
	export EMTEST_LACKS_NATIVE_CLANG="1"
	export LLVM_ROOT="/usr/lib/llvm/${LLVM_SLOT}/bin"
	export PATH="${ESYSROOT}/usr/lib/emscripten/${EMSCRIPTEN_SLOT}/bin:${PATH}"
einfo "BINARYEN:  ${BINARYEN}"
einfo "CLOSURE_COMPILER:  ${CLOSURE_COMPILER}"
einfo "EM_BINARYEN_ROOT:  ${EM_BINARYEN_ROOT}"
einfo "EM_CONFIG:  ${EM_CONFIG}"
einfo "EMCC_WASM_BACKEND:  ${EMCC_WASM_BACKEND}"
einfo "EMSDK_PYTHON:  ${EMSDK_PYTHON}"
einfo "LLVM_ROOT:  ${EMSDK_LLVM_ROOT}"
}

# @FUNCTION:  emscripten_set_config
# @DESCRIPTION:
# Generate the emscripten.config
emscripten_set_config() {
	source "${ESYSROOT}/usr/lib/emscripten/${EMSCRIPTEN_SLOT}/etc/slot.metadata"
	local node_slot=$(emscripten_get_node_slot)

cat <<EOF > "${T}/emscripten-${ABI}.config"
import os
EMSCRIPTEN_ROOT = os.path.expanduser('/usr/lib/emscripten/${EMSCRIPTEN_SLOT}')
LLVM_ROOT = os.path.expanduser('/usr/lib/llvm/${LLVM_SLOT}/bin')
BINARYEN_ROOT = os.path.expanduser('/usr/lib/binaryen/${BINARYEN_SLOT}')
NODE_JS = os.path.expanduser('/usr/lib/node/${node_slot}/bin/node')
JAVA = 'java'
TEMP_DIR = '/tmp'
EOF
}

# @FUNCTION:  emscripten_src_configure
# @DESCRIPTION:
# Setup emscripten flags and paths
emscripten_src_configure() {
	if [[ -z "${EMSCRIPTEN_SLOT}" ]] ; then
eerror "QA:  EMSCRIPTEN_SLOT must be defined"
		die
	fi

source "${ESYSROOT}/usr/lib/emscripten/${EMSCRIPTEN_SLOT}/etc/slot.metadata"
	emscripten_set_config
	emscripten_set_env

	local emscripten_root="${EROOT}/usr/lib/emscripten/${EMSCRIPTEN_SLOT}"

	emscripten_test_hello_world
}

fi
