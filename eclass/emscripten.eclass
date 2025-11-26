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
	local node_slot=$(emscripten_get_node_slot)

	# Official variables.  See
	# https://github.com/emscripten-core/emscripten/blob/4.0.20/docs/emcc.txt#L605
	# https://github.com/emscripten-core/emscripten/blob/4.0.20/tools/scons/site_scons/site_tools/emscripten/emscripten.py#L25
	export EM_CACHE="${sandbox}/cache"
	export EM_CONFIG="${T}/emscripten-${ABI}.config"
	export EMCC_CFLAGS=" -fno-stack-protector"
	export EMCC_TEMP_DIR="${T}"
	export EMCC_WASM_BACKEND=${EMCC_WASM_BACKEND:-1} # 1=wasm, 0=emscripten-fastcomp; deprecated/removed

	# Helper eclass variables to setup emscripten-${ABI}.config
	export EMSDK_BINARYEN_PREFIX="/usr/lib/binaryen/${EMSCRIPTEN_BINARYEN_SLOT}"
	export EMSDK_BINARYEN_LIB_PATH="/usr/lib/binaryen/${EMSCRIPTEN_BINARYEN_SLOT}/lib"
	export EMSDK_BINARYEN_SLOT="${EMSCRIPTEN_BINARYEN_SLOT}"
	export EMSDK_CLOSURE_COMPILER="${EMSCRIPTEN_CLOSURE_COMPILER_EXE}"
	export EMSDK_EMSCRIPTEN_PREFIX="${EMSCRIPTEN_EPREFIX}/usr/lib/emscripten/${EMSCRIPTEN_EMSCRIPTEN_SLOT}"
	export EMSDK_LLVM_PREFIX="/usr/lib/llvm/${EMSCRIPTEN_LLVM_SLOT}/bin"
	export EMSDK_LLVM_SLOT="${EMSCRIPTEN_LLVM_SLOT}"
	export EMSDK_NODE="/usr/lib/node/${node_slot}/bin/node"
	export EMSDK_NODE_VERSION_MIN="${EMSCRIPTEN_NODE_SLOT_MIN}"
	export EMSDK_PYTHON="/usr/bin/python${EMSCRIPTEN_PYTHON_SLOT}"
	export EMTEST_LACKS_NATIVE_CLANG="1"
	export PATH="${ESYSROOT}/usr/lib/binaryen/${EMSCRIPTEN_BINARYEN_SLOT}/bin:${PATH}"
	export PATH="${ESYSROOT}/${EMSCRIPTEN_EPREFIX}/usr/lib/emscripten/${EMSCRIPTEN_SLOT}/bin:${PATH}"

einfo "EM_CACHE:  ${EM_CACHE}"
einfo "EM_CONFIG:  ${EM_CONFIG}"
einfo "EMCC_CFLAGS:  ${EMCC_CFLAGS}"
einfo "EMCC_TEMP_DIR:  ${EMCC_TEMP_DIR}"
einfo "EMCC_WASM_BACKEND:  ${EMCC_WASM_BACKEND}"
einfo "EMSDK_BINARYEN_PREFIX:  ${EMSDK_BINARYEN_PREFIX}"
einfo "EMSDK_BINARYEN_LIB_PATH:  ${EMSDK_BINARYEN_LIB_PATH}"
einfo "EMSDK_BINARYEN_SLOT:  ${EMSDK_BINARYEN_SLOT}"
einfo "EMSDK_CLOSURE_COMPILER:  ${EMSDK_CLOSURE_COMPILER}"
einfo "EMSDK_EMSCRIPTEN_PREFIX:  ${EMSDK_EMSCRIPTEN_PREFIX}"
einfo "EMSDK_LLVM_PREFIX:  ${EMSDK_LLVM_PREFIX}"
einfo "EMSDK_LLVM_SLOT:  ${EMSDK_LLVM_SLOT}"
einfo "EMSDK_NODE:  ${EMSDK_NODE}"
einfo "EMSDK_NODE_VERSION_MIN:  ${EMSDK_NODE_VERSION_MIN}"
einfo "EMSDK_PYTHON:  ${EMSDK_PYTHON}"
einfo "EMTEST_LACKS_NATIVE_CLANG:  ${EMTEST_LACKS_NATIVE_CLANG}"
einfo "PATH:  ${PATH}"
}

# @FUNCTION:  emscripten_set_config
# @DESCRIPTION:
# Generate the emscripten.config
emscripten_set_config() {
	# See also https://github.com/emscripten-core/emscripten/blob/4.0.20/tools/config.py#L21
	# See also https://github.com/emscripten-core/emscripten/blob/4.0.20/tools/config_template.py

	local cc_str=""
	if [[ "${EMSDK_CLOSURE_COMPILER}" == "None" ]] ; then
		cc_str="None"
	else
		cc_str="'${EMSDK_CLOSURE_COMPILER}'"
	fi

cat <<EOF > "${T}/emscripten-${ABI}.config"
import os
BINARYEN_ROOT = os.path.expanduser('${EMSDK_BINARYEN_PREFIX}')
CLOSURE_COMPILER = ${cc_str}
EMSCRIPTEN_ROOT = os.path.expanduser('${EMSDK_EMSCRIPTEN_PREFIX}')
JAVA = 'java'
LLVM_ROOT = os.path.expanduser('${EMSDK_LLVM_PREFIX}/bin')
NODE_JS = os.path.expanduser('${EMSDK_NODE}')
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
	emscripten_set_env
	emscripten_set_config

	local emscripten_root="${EROOT}/usr/lib/emscripten/${EMSCRIPTEN_SLOT}"

	emscripten_test_hello_world
}

fi
