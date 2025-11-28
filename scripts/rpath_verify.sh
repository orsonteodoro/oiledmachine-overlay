#!/bin/bash
echo "Running RPATH verification"
IFS=$'\n'
L=(
	$(find /lib /usr/lib64 /usr/lib /usr/lib64 /usr/bin /usr/libexec -type f)
)
IFS=$' \t\n'
for x in "${L[@]}" ; do
	[[ -L "${x}" ]] && continue
	if ldd "${x}" 2>/dev/null | grep -q "re2" ; then
		ldd "${x}" 2>/dev/null | grep "/usr/lib/re2" || echo "RPATH broken for ${x}"
	fi
	if ldd "${x}" 2>/dev/null | grep -q "libabsl_" ; then
		ldd "${x}" 2>/dev/null | grep "/usr/lib/abseil-cpp" || echo "RPATH broken for ${x}"
	fi
	if ldd "${x}" 2>/dev/null | grep -q "grpc" ; then
		ldd "${x}" 2>/dev/null | grep "/usr/lib/grpc" || echo "RPATH broken for ${x}"
	fi
	if ldd "${x}" 2>/dev/null | grep -q "not found" ; then
		echo "RPATH missing for ${x}"
	fi
done
