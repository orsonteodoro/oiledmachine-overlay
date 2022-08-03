# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="Godot crossdev dependencies for iOS"
# U 20.04

LLVM_SLOTS=(14 13) # See https://github.com/godotengine/godot/blob/3.4.5-stable/misc/hooks/pre-commit-clang-format#L79
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

RDEPEND="
	|| ( $(gen_depend_llvm) )
	sys-devel/osxcross
"
SLOT_MAJ="$(ver_cut 1 ${PV})"
SLOT="${SLOT_MAJ}/$(ver_cut 1-2 ${PV})"

pkg_setup() {
ewarn
ewarn "This ebuild is still a Work In Progress (WIP) as of 2022"
ewarn
	if [[ -z "${EGODOT_IOS_SYSROOT}" ]] ; then
eerror
eerror "The environment variable EGODOT_IOS_SYSROOT needs to be defined"
eerror
		die
	fi
	if [[ -z "${EGODOT_IOS_CTARGET}" ]] ; then
eerror
eerror "The environment variable EGODOT_IOS_CTARGET needs to be defined"
eerror
		die
	fi

	export CC="/usr/bin/${EGODOT_IOS_CTARGET}-clang"
	export CXX="/usr/bin/${EGODOT_IOS_CTARGET}-clang++"

	if [[ ! -e "${CC}" ]] ; then
eerror
eerror "CC=${CC} is missing"
eerror
		die
	fi
	if [[ ! -e "${CXX}" ]] ; then
eerror
eerror "CXX=${CXX} is missing"
eerror
		die
	fi

	export CC="/Developer/usr/bin/${EGODOT_IOS_CTARGET}-gcc"

	if [[ ! -e "${CC}" ]] ; then
eerror
eerror "CC=${CC} is missing"
eerror
		die
	fi
}
