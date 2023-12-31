# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See profiles/desc/godot* for more related files.
# Keep profiles/make.defaults up to date.

EAPI=7

# TODO: check each compiler flag for GODOT_IOS_

MY_PN="godot-ios-plugins"
MY_P="${MY_PN}-${PV}"

GODOT_PN="godot"
GODOT_PV="$(ver_cut 1-2 ${PV})"
GODOT_P="${GODOT_PN}-${GODOT_PV}"

inherit godot-3.5
inherit desktop flag-o-matic multilib-build python-any-r1 scons-utils

if [[ "${AUPDATE}" == "1" ]] ; then
	SRC_URI="
https://github.com/godotengine/${MY_PN}/archive/refs/tags/${PV}-${STATUS}.tar.gz
	-> ${MY_P}.tar.gz
https://github.com/godotengine/${MY_PN}/releases/download/${PV}-${STATUS}/${PV}-${STATUS}.tar.gz
	-> godot-extracted-headers-${PV}.zip
https://github.com/godotengine/${GODOT_PN}/archive/${PV}-${STATUS}.tar.gz
	-> ${GODOT_P}.tar.gz
	"
else
	SRC_URI="
https://github.com/godotengine/${MY_PN}/archive/refs/tags/${PV}-${STATUS}.tar.gz
	-> ${MY_P}.tar.gz
	pregenerated-headers? (
https://github.com/godotengine/${MY_PN}/releases/download/${PV}-${STATUS}/${PV}-${STATUS}.tar.gz
	-> godot-extracted-headers-${PV}.zip
	)
	!pregenerated-headers? (
https://github.com/godotengine/${GODOT_PN}/archive/${PV}-${STATUS}.tar.gz
	-> ${GODOT_P}.tar.gz
	)
	"
fi
RESTRICT="mirror"
S="${WORKDIR}/godot-ios-plugins-${PV}-${STATUS}"

DESCRIPTION="Godot export template for iOS"
HOMEPAGE="http://godotengine.org"
# Many licenses because of assets (e.g. artwork, fonts) and third party libraries
LICENSE="
	all-rights-reserved
	Apache-2.0
	BitstreamVera
	Boost-1.0
	BSD
	BSD-2
	CC-BY-3.0
	CC-BY-4.0
	FTL
	ISC
	LGPL-2.1
	MIT
	MPL-2.0
	OFL-1.1
	openssl
	Unlicense
	ZLIB
"
#KEYWORDS="" # Ebuild not finished

# See https://github.com/godotengine/godot/blob/3.5.2-stable/thirdparty/README.md for Apache-2.0 licensed third party.

# thirdparty/misc/curl_hostcheck.c - all-rights-reserved MIT # \
#   The MIT license does not have all rights reserved but the source does

# thirdparty/bullet/BulletCollision - zlib all-rights-reserved # \
#   The ZLIB license does not have all rights reserved but the source does

# thirdparty/bullet/BulletDynamics - all-rights-reserved || ( LGPL-2.1 BSD )

# thirdparty/libpng/arm/palette_neon_intrinsics.c - all-rights-reserved libpng # \
#   libpng license does not contain all rights reserved, but this source does

#KEYWORDS=""

SLOT_MAJ="$(ver_cut 1 ${PV})"
SLOT="${SLOT_MAJ}/$(ver_cut 1-2 ${PV})"

IUSE+=" debug pregenerated-headers"

GODOT_IOS_=(
	armv7
	armv64
	x86_64
)

GODOT_IOS="${GODOT_IOS_[@]/#/godot_ios_}"
GODOT_IOS_PLUGINS_=(apn arkit camera gamecenter icloud inappstore photo_picker)
GODOT_IOS_PLUGINS="${GODOT_IOS_PLUGINS_[@]/#/godot_ios_plugins_}"
IUSE+="
	${GODOT_IOS}
	${GODOT_IOS_PLUGINS}
"
# See https://github.com/godotengine/godot/tree/3.4-stable/thirdparty for versioning
# See https://github.com/tpoechtrager/osxcross/blob/master/build.sh#L36      ; for XCODE VERSION <-> EOSXCROSS_SDK
# See https://developer.apple.com/ios/submit/ for app store requirement
# Some are repeated because they were shown to be in the ldd list
REQUIRED_USE+="
	pregenerated-headers
	|| (
		${GODOT_IOS}
	)
	|| (
		${GODOT_IOS_PLUGINS}
	)
"
# See https://developer.apple.com/ios/submit/ for app store requirement
APST_REQ_STORE_DATE="April 2022"
IOS_SDK_MIN_STORE="15"
XCODE_SDK_MIN_STORE="13"
EXPECTED_XCODE_SDK_MIN_VERSION_IOS="10"
EXPECTED_IOS_SDK_MIN_VERSION="10"

# Optional
BDEPEND+="
	${PYTHON_DEPS}
	dev-util/scons
	!pregenerated-headers? (
		net-misc/rsync
	)
"
PATCHES=(
)

test_path() {
	local p="${1}"
	if ! realpath -e "${p}" ; then
eerror
eerror "${p} is unreachable"
eerror
		die
	fi
}

check_cross_compiler_paths() {
	if [[ -z "${IPHONEPATH}" ]] ; then
eerror
eerror "IPHONEPATH must be defined as per-package environment variable."
eerror "It is the path to the toolchain"
eerror
		die
	fi
	if [[ -z "${IOS_SDK_PATH}" ]] ; then
eerror
eerror "IOS_SDK_PATH must be defined as per-package environment variable."
eerror "It is the path to the sdk"
eerror
		die
	fi
	export OSXCROSS_IOS="${IPHONEPATH}"

	test_path "${IPHONEPATH}/usr/bin"
	test_path "${IPHONEPATH}/usr/bin/*/clang"
	test_path "${IPHONEPATH}/usr/bin/*/clang++"
	test_path "${IPHONEPATH}/usr/bin/*/ar"
	test_path "${IPHONEPATH}/usr/bin/*/ranlib"
	test_path "${IPHONEPATH}/usr/include"
	test_path "${IOS_SDK_PATH}/System/Library/Frameworks/OpenGLES.framework/Headers"
	test_path "${IOS_SDK_PATH}/System/Library/Frameworks/AudioUnit.framework/Headers"

	if [[ -z "${OSXCROSS_IOS}" ]] ; then
ewarn
ewarn "OSXCROSS_IOS must be defined as per-package environment variable."
ewarn "It is set to 1 if you are using OSXCross."
ewarn
	fi
}

check_store_apl()
{
	if ver_test ${IOS_SDK_VERSION} -lt ${IOS_SDK_MIN_STORE} ; then
ewarn
ewarn "Your IOS SDK does not meet minimum store requirements of"
ewarn ">=${IOS_SDK_MIN_STORE} as of ${APLST_REQ_STORE_DATE}."
ewarn
	fi

	if [[ -n "${XCODE_SDK_VERSION}" ]] \
		&& ver_test ${XCODE_SDK_VERSION} -lt ${APST_REQ_STORE_DATE} ; then
ewarn
ewarn "Your Xcode SDK does not meet minimum store requirements of"
ewarn ">=${XCODE_SDK_MIN_STORE} as of ${APLST_REQ_STORE_DATE}."
ewarn
	fi
}

check_sdk_versions() {
	if ver_test ${IOS_SDK_VERSION} -lt ${EXPECTED_IOS_SDK_MIN_VERSION} ; then
eerror
eerror "Your iOS SDK version must be >= ${EXPECTED_IOS_SDK_MIN_VERSION}"
eerror
		die
	fi
}

pkg_setup() {
ewarn
ewarn "Do not emerge this directly use dev-games/godot-meta instead."
ewarn
ewarn
ewarn "This ebuild is still a Work In Progress (WIP) as of 2022"
ewarn
	check_cross_compiler_paths
	check_store_apl
	check_sdk_versions

	python-any-r1_pkg_setup
}

src_unpack() {
	unpack ${A}
	rm -rf "${S}/godot" || die
	if use pregenerated-headers ; then
		mv "extracted_headers/godot" \
			"${S}/godot" || die
	else
		mv "${WORKDIR}/godot-${GODOT_PV}-${STATUS}" \
			"${S}/godot" || die
	fi
}

src_configure() {
	default
	strip-flags
	filter-flags -march=*
	# CCACHE disabled for cross-compile
	unset CCACHE
}

get_configuration2() {
	[[ "${configuration}" == "release" ]] && echo "opt"
	[[ "${configuration}" == "release_debug" ]] && echo "opt.debug"
}

get_configuration3() {
	if [[ "${configuration}" =~ "debug" ]] ; then
		echo "debug"
	elif [[ "${configuration}" =~ "release" ]] ; then
		echo "release"
	else
		echo ""
	fi
}

_compile() {
	local enabled_arches=()
	local enabled_plugins=()
	local configuration2=$(get_configuration2)
	local plugin
	ewarn "Plugin support is WIP"

	local arch
	if ! use pregenerated-headers ; then
		./scripts/generate_headers.sh || true # Runs for 90s
		./scripts/extract_headers.sh || die
		rm -rf godot || die
		mv bin/extracted_headers/godot \
			godot || die
	fi

	for a in ${GODOT_IOS} ; do
		if use ${a} ; then
			arch="${a/godot_ios_}"

			for plugin in ${GODOT_IOS_PLUGINS[@]} ; do
				local simulator="off"
				if use godot_ios_x86_64 ; then
					local simulator="on"
				fi
				if use ${plugin} ; then
					local plugin_name=${plugin/godot_ios_plugins_}

					scons \
						arch=${arch} \
						plugin=${plugin_name} \
						simulator=${simulator} \
						target=${configuration} \
						version=3.x \
						|| die
				fi
			done

			for plugin in ${GODOT_IOS_PLUGINS[@]} ; do
				local plugin_name=${plugin/godot_ios_plugins_}
				./scripts/generate_static_library.sh ${plugin_name} ${configuration}
			done
		fi
	done

}

_src_compile_plugins() {
	local options_extra=(
	)
	_compile
}

src_compile_plugins() {
	local configuration
	for configuration in release release_debug ; do
		einfo "Creating plugins"
		if ! use debug && [[ "${configuration}" == "release_debug" ]] ; then
			continue
		fi
		_src_compile_plugins
	done
}

src_compile() {
	local myoptions=()
	src_compile_plugins
}

_install_plugins() {
	local prefix
	prefix="/usr/share/godot/${SLOT_MAJ}/ios-plugins"
	insinto "${prefix}"
	exeinto "${prefix}"
	einfo "Installing export templates"

	doins bin/*.a

	insinto docs
	for plugin in ${GODOT_IOS_PLUGINS[@]} ; do
		if use "godot_ios_plugins_${plugin}" ; then
			newins plugins/${plugin}/README.md \
				README-${plugin}.md
		fi
	done
}

src_install() {
	use debug && export STRIP="true" # Don't strip debug builds
	_install_plugins
}

pkg_postinst() {
	einfo "This plugin can only used within an iOS device or simulator."
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
