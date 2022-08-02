# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Live was chosen because it didn't specify ndk version in tagged

# TODO: check each compiler flag for GODOT_IOS_

MY_PV="fcf205c"
MY_PN="godot-mono-builds"
MY_P="${MY_PN}-${PV}"
STATUS="stable"

EGIT_REPO_URI="https://github.com/godotengine/godot-mono-builds.git"
EGIT_BRANCH="master"

PYTHON_COMPAT=( python3_{8..10} )
inherit eutils flag-o-matic python-any-r1
if [[ ${PV} =~ 9999 ]] ; then
	inherit git-r3
fi

DESCRIPTION="Mono build scripts for Godot (monodroid)"
HOMEPAGE="https://github.com/godotengine/godot-mono-builds"
# Many licenses because of assets (e.g. artwork, fonts) and third party libraries
LICENSE="MIT"
#KEYWORDS=""
SLOT="0/${PV}"
AOT_CROSS_TARGETS=" cross-armv7 cross-arm64"
DEV_TARGETS=" armv7 arm64"
SIM_TARGETS=" i386 x86_64 arm64-sim"
TARGETS=" ${AOT_CROSS_TARGETS} ${DEV_TARGETS} ${SIM_TARGETS}"
IUSE+=" ${TARGETS}"
REQUIRED_USE+="
	|| ( ${TARGETS} )
"
DEPEND+=""
BDEPEND+="
	${PYTHON_DEPS}
	sys-devel/osxcross
"
S="${WORKDIR}/${MY_PN}-release-${MY_PV}"
PROPERTIES="live"
MONO_PV=$(ver_cut 1-4 "${PV}")
SRC_URI="
https://download.mono-project.com/sources/mono/mono-${MONO_PV}.tar.xz
"
if [[ ! ( ${PV} =~ 9999 ) ]] ; then
	SRC_URI+="
https://github.com/godotengine/godot-mono-builds/archive/refs/tags/release-${MY_PV}.tar.gz
	-> ${MY_PN}-${MY_PV}.tar.gz
	"
fi

src_unpack() {
	unpack ${A}
	if [[ ${PV} =~ 9999 ]] ; then
		git-r3_fetch
		git-r3_checkout
	fi
	local expected_mono_pv=$(grep "Mono:" "${S}/README.md" \
		| grep -o -E -e"[0-9.]+" \
		| sed -e "s|\.$||g")
	local actual_mono_pv="${MONO_PV}"
	if ver_test ${expected_mono_pv} -ne ${actual_mono_pv} ; then
eerror
eerror "Expected Mono version:  ${expected_mono_pv}"
eerror "Actual Mono version:  ${actual_mono_pv}"
eerror
eerror "Bump the ebuild package version"
eerror
		die
	fi
}

src_prepare() {
	export MONO_SOURCE_ROOT="${WORKDIR}/mono-${MONO_PV}"
	[[ -e "${MONO_SOURCE_ROOT}" ]] || die
	${EPYTHON} patch_mono.py || die
}

src_compile() {
	local build_targets=()
	local x
	for x in ${TARGETS} ; do
		if use "${x}" ; then
			build_targets+=( --target=${x}  )
		fi
	done

	${EPYTHON} ios.py configure ${build_targets[@]} || die
	${EPYTHON} ios.py make ${build_targets[@]} || die

	${EPYTHON} bcl.py make --product=ios || die
}

src_install() {
	ewarn "TODO: src_install()"
	die
}
