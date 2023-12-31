# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO: Mod godot to not hardcode locations.

inherit godot-4.2
inherit flag-o-matic

DESCRIPTION="Godot crossdev dependencies for macOS"
# U 20.04
#KEYWORDS="" # Ebuild not finished

SANITIZERS=(
	asan
	lsan
	tsan
	ubsan
)
IUSE+="
	${SANITIZERS[@]}
	+sdk_10_6_or_newer
	sdk_10_5_or_less
"
REQUIRED_USE="
	^^ (
		sdk_10_5_or_less
		sdk_10_6_or_newer
	)
	!lsan
	!tsan
"

GODOT_OSX_=(arm64 x86_64)
GODOT_OSX="${GODOT_OSX_[@]/#/godot_osx_}"

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

gen_clang_sanitizer() {
	local san_type="${1}"
	local s
	local o=""
	for s in ${LLVM_SLOTS[@]} ; do
		o+="
			(
				=sys-devel/clang-runtime-${s}[compiler-rt,sanitize]
				=sys-libs/compiler-rt-sanitizers-${s}*:=[${san_type}]
				sys-devel/clang:${s}
				sys-devel/llvm:${s}
			)
		"
	done
	echo "${o}"
}
gen_cdepend_sanitizers() {
	local a
	for a in ${SANITIZERS[@]} ; do
		echo "
	${a}? (
		|| (
			$(gen_clang_sanitizer ${a})
		)
	)

		"
	done
}

CDEPEND_SANITIZER="
	$(gen_cdepend_sanitizers)
"

RDEPEND="
	${CDEPEND_SANITIZER}
	sdk_10_5_or_less? (
		~sys-devel/osxcross-1.1
	)
	sdk_10_6_or_newer? (
		>=sys-devel/osxcross-1.4
	)
	|| (
		$(gen_depend_llvm)
	)
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
	export OSXCROSS_ROOT="${OSXCROSS_ROOT:-/opt/osxcross}"
	einfo "OSXCROSS_ROOT=${OSXCROSS_ROOT}"
	einfo "PATH=${PATH}"

	local found_cc=0
	local found_cxx=0
	local arch
	for arch in ${GODOT_OSX_[@]} ; do
		if use "godot_osx_${arch}" ; then
			test_path "${ESYSROOT}/${OSXCROSS_ROOT}/target/bin/${arch}-*-*-cc"
			test_path "${ESYSROOT}/${OSXCROSS_ROOT}/target/bin/${arch}-*-*-c++"
			test_path "${ESYSROOT}/${OSXCROSS_ROOT}/target/bin/${arch}-*-*-ar"
			test_path "${ESYSROOT}/${OSXCROSS_ROOT}/target/bin/${arch}-*-*-ranlib"
			test_path "${ESYSROOT}/${OSXCROSS_ROOT}/target/bin/${arch}-*-*-as"
		fi
	done
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
