#!/bin/bash
echo "Running RPATH verification"
main() {
	IFS=$'\n'
	DIRS=(
		"/lib64"
		"/lib"
		"/usr/lib64"
		"/usr/lib"
		"/usr/bin"
		"/usr/libexec"
		"/opt/rocm"
	)
	L=(
		$(find "${DIRS[@]}" -type f)
	)
	IFS=$' \t\n'
	for x in "${L[@]}" ; do
		[[ -L "${x}" ]] && continue
		if ldd "${x}" 2>/dev/null | grep -q "re2.so" ; then
			ldd "${x}" 2>/dev/null | grep -q "/usr/lib/re2" || echo "RPATH is broken for ${x} (1)"
		fi
		if ldd "${x}" 2>/dev/null | grep -q "libabsl_" ; then
			ldd "${x}" 2>/dev/null | grep -q "/usr/lib/abseil-cpp" || echo "RPATH is broken for ${x} (2)"
		fi
		if ldd "${x}" 2>/dev/null | grep -q "grpc.so" || ldd "${x}" 2>/dev/null | grep -F -q "grpc++.so" ; then
			ldd "${x}" 2>/dev/null | grep -q "/usr/lib/grpc" || echo "RPATH is broken for ${x} (3)"
		fi
		if ldd "${x}" 2>/dev/null | grep -q "libavcodec.so" ; then
			ldd "${x}" 2>/dev/null | grep -q "/usr/lib/ffmpeg" || echo "RPATH is possibily missing or would benefit with multislot ffmpeg for ${x} (4)"
		fi
		if ldd "${x}" 2>/dev/null | grep -q "libamdhip64.so" && ldd "${x}" 2>/dev/null | grep -q "libLLVMCore.so" ; then
			ldd "${x}" 2>/dev/null | grep -q "/opt/rocm/lib/llvm" || echo "HIP-Clang RPATH is missing for ${x} (5)"
		fi
		if ldd "${x}" 2>/dev/null | grep -q "libamdhip64.so" ; then
			ldd "${x}" 2>/dev/null | grep -q "/opt/rocm" || echo "RPATH is missing for ${x} (6)"
		fi
		if ldd "${x}" 2>/dev/null | grep -q "not found" ; then
			echo "RPATH missing for ${x} (7)"
		fi
	done
}

main
