# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Live was chosen because it didn't specify ndk version in tagged

# TODO: check each compiler flag for GODOT_IOS_

MY_PV="df330ce"
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

# Pulled by EMSDK (nodejs, wasm-binaries [emscripten with third party, emscripten-fastcomp fork of clang])
CLOSURE_COMPILER_LICENSE="
		Apache-2.0
		BSD
		CPL-1.0
		GPL-2+
		LGPL-2.1+
		MIT
		MPL-2.0
		NPL-1.1
"
EMSCRIPTEN_LICENSE="
	all-rights-reserved
	UoI-NCSA
	Apache-2.0
	Apache-2.0-with-LLVM-exceptions
	BSD
	BSD-2
	CC-BY-SA-3.0
	|| ( FTL GPL-2 )
	GPL-2+
	LGPL-2.1
	LGPL-3
	MIT
	MPL-2.0
	OFL-1.1
	PSF-2.4
	Unlicense
	ZLIB
		${CLOSURE_COMPILER_LICENSE}
"
LICENSE+=" ${EMSCRIPTEN_LICENSE}"

NODEJS_LICENSE="Apache-1.1 Apache-2.0 BSD BSD-2 icu ISC MIT openssl unicode ZLIB"
LICENSE+=" ${NODEJS_LICENSE}"

MONO_LICENSE="MIT LGPL-2.1 GPL-2 BSD-4 NPL-1.1 Ms-PL GPL-2-with-linking-exception IDPL"
LICENSE+=" ${MONO_LICENSE}"

#KEYWORDS=""
SLOT="0/${PV}"
DEPEND+=""
BDEPEND+="
	${PYTHON_DEPS}
"
S="${WORKDIR}/${MY_PN}-release-${MY_PV}"
PROPERTIES="live"
EMSDK_PV="1.39.9"
MONO_PV=$(ver_cut 1-4 "${PV}")
SRC_URI="
https://download.mono-project.com/sources/mono/mono-${MONO_PV}.tar.xz
https://github.com/emscripten-core/emsdk/archive/refs/tags/${EMSDK_PV}.tar.gz
	-> emsdk-${EMSDK_PV}.tar.gz
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

	local expected_emsdk_pv=$(grep "Emscripten:" "${S}/README.md" \
		| grep -o -E -e"[0-9.]+" \
		| sed -e "s|\.$||g")
	local actual_emsdk_pv="${EMSDK_PV}"
	if ver_test ${expected_emsdk_pv} -ne ${actual_emsdk_pv} ; then
eerror
eerror "Expected EMSDK version:  ${expected_emsdk_pv}"
eerror "Actual EMSDK version:  ${actual_emsdk_pv}"
eerror
eerror "Bump the EMSDK_PV package version"
eerror
		die
	fi
}

src_prepare() {
	export EMSDK_ROOT="${WORKDIR}/emsdk-${EMSDK_PV}"
	[[ -e "${EMDSK_ROOT}" ]] || die

	export MONO_SOURCE_ROOT="${WORKDIR}/mono-${MONO_PV}"
	[[ -e "${MONO_SOURCE_ROOT}" ]] || die
	${EPYTHON} patch_mono.py || die
}

src_compile() {
	local build_targets=()
	# Build the runtime for WebAssembly.
	${EPYTHON} wasm.py configure --target=runtime || die
	${EPYTHON} wasm.py make --target=runtime || die

	${EPYTHON} bcl.py make --product=wasm || die
}

src_install() {
	ewarn "TODO: src_install()"
	die
}
