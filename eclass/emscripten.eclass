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

# @FUNCTION:  emscripten_gen_hello_world
# @DESCRIPTION:
# Generate A Hello World source code to test the Emscripten toolchain.
emscripten_gen_hello_world() {
CAT <<EOF > "${T}/hello.cc"
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
	"/usr/bin/emcc" -v
	"/usr/bin/em++" -v

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
		"/usr/share/emscripten-${PV}/em++" \
			-stdlib=libc++ \
			"${T}/hello_world.cpp" \
			-o "hello_world.js" \
			|| die
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

emscripten_src_configure() {
	if [[ -z "${EMSCRIPTEN_SLOT}" ]] ; then
eerror "QA:  EMSCRIPTEN_SLOT must be defined"
		die
	fi
	local emscripten_root="${EROOT}/usr/share/emscripten-${PV}"
	export BINARYEN="${EMSDK_BINARYEN_BASE_PATH}"
	export CLOSURE_COMPILER="${EMSDK_CLOSURE_COMPILER}"
	export EM_BINARYEN_ROOT="${EMSDK_BINARYEN_BASE_PATH}"
	export EM_CONFIG="${EROOT}/usr/share/emscripten-${PV}/emscripten.config"
	export EMCC_WASM_BACKEND=${__EMCC_WASM_BACKEND__}
	export LLVM_ROOT="${EMSDK_LLVM_ROOT}"

	export PATH="${usr}/share/emscripten-${EMSCRIPTEN_SLOT}:${PATH}"

	emscripten_test_hello_world

einfo
einfo "BINARYEN:  ${BINARYEN}"
einfo "CLOSURE_COMPILER:  ${EMSDK_CLOSURE_COMPILER}"
einfo "EM_BINARYEN_ROOT:  ${EM_BINARYEN_ROOT}"
einfo "EM_CONFIG:  ${T}/emscripten-${ABI}.config"
einfo "EMCC_WASM_BACKEND:  ${__EMCC_WASM_BACKEND__}"
einfo "EROOT:  ${EROOT}"
einfo "LLVM_ROOT:  ${EMSDK_LLVM_ROOT}"
einfo "PYTHON_EXE_ABSPATH:  ${PYTHON_EXE_ABSPATH}"
einfo

}


fi
