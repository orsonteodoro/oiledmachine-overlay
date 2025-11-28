#!/bin/bash
echo "Running RPATH verification"
main() {
	IFS=$'\n'
	L=(
		$(find \
			"/lib64" \
			"/lib" \
			"/usr/lib64" \
			"/usr/lib" \
			"/usr/bin" \
			"/usr/libexec" \
			"/opt/rocm" \
			-type f)
	)
	IFS=$' \t\n'
	for x in "${L[@]}" ; do
		[[ -L "${x}" ]] && continue
		if ldd "${x}" 2>/dev/null | grep -q "re2" ; then
			ldd "${x}" 2>/dev/null | grep -q "/usr/lib/re2" || echo "RPATH is broken for ${x}"
		fi
		if ldd "${x}" 2>/dev/null | grep -q "libabsl_" ; then
			ldd "${x}" 2>/dev/null | grep -q "/usr/lib/abseil-cpp" || echo "RPATH is broken for ${x}"
		fi
		if ldd "${x}" 2>/dev/null | grep -q "grpc" ; then
			ldd "${x}" 2>/dev/null | grep -q "/usr/lib/grpc" || echo "RPATH is broken for ${x}"
		fi
		if ldd "${x}" 2>/dev/null | grep -q "libavcodec.so" ; then
			ldd "${x}" 2>/dev/null | grep -q "/usr/lib/ffmpeg" || echo "RPATH is possibily missing or would benefit with multislot ffmpeg for ${x}"
		fi
		if ldd "${x}" 2>/dev/null | grep -q "libamdhip64.so" && ldd "${x}" 2>/dev/null | grep -q "libLLVMCore.so" ; then
			ldd "${x}" 2>/dev/null | grep -q "/opt/rocm" || echo "HIP-Clang RPATH is missing for ${x}"
		fi
		if ldd "${x}" 2>/dev/null | grep -q "libamdhip64.so" ; then
			ldd "${x}" 2>/dev/null | grep -q "/opt/rocm" || echo "RPATH is missing for ${x}"
		fi
		if ldd "${x}" 2>/dev/null | grep -q "not found" ; then
			echo "RPATH missing for ${x}"
		fi
	done
}

main
