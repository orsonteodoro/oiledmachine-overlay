# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
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

test_path() {
	local p="${1}"
	if ! realpath -e "${p}" ; then
eerror
eerror "${p} is unreachable"
eerror
	fi
}

pkg_setup() {
ewarn
ewarn "This ebuild is still a Work In Progress (WIP) as of 2022"
ewarn
	if [[ -z "${OSXCROSS_IOS}" ]] ; then
eerror
eerror "The environment variable OSXCROSS_IOS needs to be defined"
eerror
		die
	fi

	test_path "${ESYSROOT}/${OSXCROSS_IOS}/usr/bin/*-clang"
	test_path "${ESYSROOT}/${OSXCROSS_IOS}/usr/bin/*-clang++"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
