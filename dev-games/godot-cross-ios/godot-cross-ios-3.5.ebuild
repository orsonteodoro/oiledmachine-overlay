# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit godot-3.5
inherit flag-o-matic

DESCRIPTION="Godot crossdev dependencies for iOS"
# U 20.04
#KEYWORDS="" # Ebuild not finished
SLOT_MAJ="$(ver_cut 1 ${PV})"
SLOT="${SLOT_MAJ}/$(ver_cut 1-2 ${PV})"

gen_depend_llvm() {
	local o=""
	for s in ${LLVM_SLOTS[@]} ; do
		o+="
		(
			sys-devel/clang:${s}
			sys-devel/lld:${s}
			sys-devel/llvm:${s}
		)
		"
	done
	echo -e "${o}"
}

RDEPEND="
	sys-devel/osxcross
	|| (
		$(gen_depend_llvm)
	)
"

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
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
