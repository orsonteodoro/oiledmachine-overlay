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

MONO_LICENSE="MIT LGPL-2.1 GPL-2 BSD-4 NPL-1.1 Ms-PL GPL-2-with-linking-exception IDPL"
LICENSE+=" ${MONO_LICENSE}"

#KEYWORDS=""
SLOT="0/${PV}"
RUNTIME_TARGETS=" armv7 arm64v8 x86 x86_64"
AOT_CROSS_TARGETS=" cross-arm cross-arm64 cross-x86 cross-x86_64"
AOT_CROSS_MXE_TARGETS=" cross-arm-win cross-arm64-win cross-x86-win cross-x86_64-win"
TARGETS=" ${RUNTIME_TARGETS} ${AOT_CROSS_TARGETS} ${AOT_CROSS_MXE_TARGETS}"
IUSE+=" ${TARGETS}"
REQUIRED_USE+="
	|| ( ${TARGETS} )
"
DEPEND+=""
BDEPEND+="
	${PYTHON_DEPS}
	  dev-util/android-sdk-update-manager
	>=dev-util/android-ndk-23
	>=dev-util/cmake-3.18.1
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
	# ANDROID_HOME set by dev-util/android-sdk-update-manager
	export ANDROID_SDK_ROOT=${ANDROID_HOME}

	local x
	for x in ${TARGETS} ; do
		build_targets+=( --target=${x} )
	done

	${EPYTHON} android.py configure ${build_targets[@]} || die
	${EPYTHON} android.py make ${build_targets[@]} || die

	${EPYTHON} bcl.py make --product=android || die
}

src_install() {
	ewarn "TODO: src_install()"
	die
}
