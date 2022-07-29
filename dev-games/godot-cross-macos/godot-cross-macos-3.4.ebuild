# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO: Mod godot to not hardcode locations.

inherit flag-o-matic

DESCRIPTION="Godot crossdev dependencies for macOS"
# U 20.04

SANITIZERS=" asan lsan tsan ubsan"
IUSE+="
	${SANITIZERS}
	sdk_10_5_or_less
	+sdk_10_6_or_newer
"
REQUIRED_USE="
	^^ ( sdk_10_5_or_less sdk_10_6_or_newer	)
"

GODOT_OSX_=(arm64 x86_64)
GODOT_OSX="${GODOT_OSX_[@]/#/godot_osx_}"

LLVM_SLOTS=(12 13) # See https://github.com/godotengine/godot/blob/3.4-stable/misc/hooks/pre-commit-clang-format#L79
gen_depend_llvm() {
	local o=""
	for s in ${LLVM_SLOTS[@]} ; do
		o+="
		(
			sys-devel/clang:${s}
			sys-devel/llvm:${s}
			>=sys-devel/lld-${s}
		)
		"
	done
	echo -e "${o}"
}

gen_clang_sanitizer() {
	local san_type="${1}"
	local s
	local o=""
	for s in ${LLVM_SLOTS[@]} ; do
		o+="
			(
				 sys-devel/clang:${s}
				=sys-devel/clang-runtime-${s}[compiler-rt,sanitize]
				 sys-devel/llvm:${s}
				=sys-libs/compiler-rt-sanitizers-${s}*[${san_type}]
			)
		"
	done
	echo "${o}"
}
gen_cdepend_sanitizers() {
	local a
	for a in ${SANITIZERS} ; do
		echo "
	${a}? (
		|| ( $(gen_clang_sanitizer ${a}) )
	)

		"
	done
}

CDEPEND_SANITIZER="
	$(gen_cdepend_sanitizers)
"

RDEPEND="
	${CDEPEND_SANITIZER}
	|| ( $(gen_depend_llvm) )
	sdk_10_5_or_less? (
		~sys-devel/osxcross-1.1
	)
	sdk_10_6_or_newer? (
		>=sys-devel/osxcross-1.4
	)
"
SLOT_MAJ="$(ver_cut 1 ${PV})"
SLOT="${SLOT_MAJ}/$(ver_cut 1-2 ${PV})"

pkg_setup() {
ewarn
ewarn "This ebuild is still a Work In Progress (WIP) as of 2022"
ewarn
	if [[ -z "${EGODOT_MACOS_SYSROOT}" ]] ; then
eerror
eerror "The environment variable EGODOT_MACOS_SYSROOT needs to be defined"
eerror
		die
	fi

	if [[ -z "${EGODOT_MACOS_SDK_VERSION}" ]] ; then
eerror
eerror "The environment variable EGODOT_MACOS_SDK_VERSION needs to be defined"
eerror
		die
	fi

	export OSXCROSS_ROOT="${EGODOT_MACOS_SYSROOT}"

	local found_cc=0
	local found_cxx=0
	local arch
	for arch in ${GODOT_OSX_[@]} ; do
		if use "godot_osx_${arch}" ; then
			# Modify project instead?
			export CC="${OSXCROSS_ROOT}/target/bin/${arch}-apple-${EGODOT_MACOS_SDK_VERSION}-cc"
			export CXX="${OSXCROSS_ROOT}/target/bin/${arch}-apple-${EGODOT_MACOS_SDK_VERSION}-c++"
			if [[ -e "${CC}" ]] ; then
einfo
einfo "Found CC=${CC}"
einfo
				found_cc=1
			else
ewarn
ewarn "CC=${CC} is missing.  It requires either symlinks, or a ebuild & project"
ewarn "mod."
ewarn
			fi
			if [[ -e "${CXX}" ]] ; then
einfo
einfo "Found CC=${CC}"
einfo
				found_cxx=1
			else
ewarn
ewarn "CC=${CC} is missing.  It requires either symlinks, or a ebuild & project"
ewarn "mod."
ewarn
			fi
		fi
	done
	if (( ${found_cc} > 0 && ${found_cxx} > 0 )) ; then
eerror
eerror "The cross toolchain is not ready.  It requires either symlinks, or"
eerror "ebuild and project modding."
eerror
		die
	fi
}
