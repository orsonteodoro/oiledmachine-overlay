# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ELECTRON_APP_ELECTRON_PV="18.2.2" # See \
# https://raw.githubusercontent.com/4ian/GDevelop/v5.1.155/newIDE/electron-app/package-lock.json
ELECTRON_APP_REACT_PV="16.14.0" # See \
# https://raw.githubusercontent.com/4ian/GDevelop/v5.1.155/newIDE/app/package-lock.json

inherit check-reqs desktop electron-app eutils flag-o-matic user-info
inherit toolchain-funcs xdg

MY_PN="GDevelop"
MY_PV="${PV//_/-}"

DESCRIPTION="GDevelop is an open-source, cross-platform game engine designed
to be used by everyone."
HOMEPAGE="https://gdevelop-app.com/"
THIRD_PARTY_LICENSES_ELECTRON="
	custom
	( custom ISC all-rights-reserved )
	( fping all-rights-reserved )
	( LGPL-2.1 LGPL-2.1+ )
	|| ( MPL-2 GPL-2+ LGPL-2.1+ )
	|| ( MPL-1.1 GPL-2+ LGPL-2.1+ )
	android
	Apache-2.0
	Apache-2.0-with-LLVM-exceptions
	APSL-2
	AFL-2.0
	BitstreamVera
	Boost-1.0
	BSD
	BSD-2
	BSD-4
	BSD-Protection
	CC-BY-SA-3.0
	CPL-1.0
	curl
	EPL-1.0
	GPL-2
	GPL-2-with-classpath-exception
	GPL-3
	GPL-3+
	MIT
	MPL-2.0
	FTL
	icu-70.1
	IJG
	ISC
	HPND
	Khronos-CLHPP
	LGPL-2.1
	LGPL-2.1+
	LGPL-3
	LGPL-3+
	libpng
	libpng2
	libstdc++
	NEWLIB
	MPL-1.1
	MPL-2.0
	Ms-PL
	OFL-1.1
	minpack
	openssl
	SunPro
	Unicode-DFS-2016
	unicode
	unRAR
	UoI-NCSA
	WEBp-patent-license
	ZLIB
	|| ( public-domain MIT ( public-domain MIT ) )
" # The ^^ (mutually exclusion) does not work.  It is assumed the user will choose
# outside the computer.

THIRD_PARTY_LICENSES="
	custom
	all-rights-reserved
	( Apache-2.0 all-rights-reserved )
	( MIT all-rights-reserved )
	0BSD
	Apache-2.0
	BSD
	BSD-2
	ISC
	MIT
	CC-BY-4.0
	Unicode-DFS-2016
	W3C
	W3C-Community-Final-Specification-Agreement
	W3C-Document-License
	W3C-Software-and-Document-Notice-and-License-2015
	W3C-Software-Notice-and-License
"
LICENSE="
	GDevelop MIT
	${THIRD_PARTY_LICENSES}
	${THIRD_PARTY_LICENSES_ELECTRON}
"
# custom, (MIT all-rights-reserved), MIT, Apache-2.0, \
#   (W3C [ipr-legal-disclaimer, ipr-trademarks], W3C-Document-License, \
#   http://www.w3.org/TR/2015/WD-html51-20151008/), \
#   (Apache-2.0 all-rights-reserved) - \
#   newIDE/app/node_modules/monaco-editor/ThirdPartyNotices.txt
# all-rights-reserved - newIDE/app/node_modules/style-dictionary/NOTICE
# 0BSD - newIDE/app/node_modules/camel-case/node_modules/tslib/CopyrightNotice.txt
# Apache-2.0 - newIDE/app/node_modules/lazy-universal-dotenv/license
# Apache-2.0, all-rights-reserved - newIDE/app/node_modules/typescript/CopyrightNotice.txt
# BSD
# BSD-2 - newIDE/electron-app/node_modules/configstore/license
# ISC
# MIT, Unicode-DFS-2016, W3C-Software-and-Document-Notice-and-License-2015, \
#   CC-BY-4.0, W3C-Community-Final-Specification-Agreement - \
#   newIDE/app/node_modules/typescript/ThirdPartyNoticeText.txt
# MIT
# W3C-Software-Notice-and-License - newIDE/electron-app/app/node_modules/sax/LICENSE-W3C.html

# For Electron: \
# custom \
#   search: "grants an immunity from suit" \
#   custom-font-license \
#     search: "removed from any derivative versions" \
#   ( custom ISC with no advertising clause all-rights-reserved ) \
#   ( fping all-rights-reserved ) \
#   ( LGPL-2.1 LGPL-2.1+ ) \
#   ^^ ( MPL-2 GPL-2+ LGPL-2.1+ ) \
#   ^^ ( MPL-1.1 GPL-2+ LGPL-2.1+ ) \
#   android \
#   Apache-2.0 \
#   Apache-2.0-with-LLVM-exceptions \
#   APSL-2 \
#   AFL-2.0 \
#   BitstreamVera \
#   BSD \
#   BSD-2 \
#   BSD-4 \
#   BSD-Protection \
#   CC-BY-SA-3.0 \
#   CPL-1.0 \
#   curl \
#   GPL-2 \
#   GPL-2-with-classpath-exception \
#   GPL-3 \
#   GPL-3+ \
#   MIT \
#   MPL-2.0 \
#   FTL \
#   icu-70.1 \
#   icu (58) \
#   icu (1.8.1+) \
#   IJG \
#   ISC \
#   HPND \
#   Khronos-CLHPP \
#   LGPL-2.1 \
#   LGPL-2.1+ \
#   LGPL-3 \
#   LGPL-3+ \
#   libpng \
#   libpng2 \
#   libstdc++ \
#   NEWLIB \
#   MPL-1.1 \
#   MPL-2.0 \
#   Ms-PL \
#   OFL-1.1 \
#   PCRE8 (BSD) \
#   minpack \
#   openssl \
#   SunPro \
#   Unicode-DFS-2016 \
#   unicode \
#   unRAR \
#   UoI-NCSA \
#   WEBp-patent-license \
#   ZLIB \
#   || ( public-domain MIT ( public-domain MIT ) ) - \
#   newIDE/electron-app/node_modules/electron/dist/LICENSES.chromium.html

# For Electron: \
#   (Similar to newIDE/electron-app/node_modules/electron/dist/LICENSES.chromium.html) with changes \
#   EPL-1.1 \
#   Boost-1.0 - \
#   newIDE/electron-app/app/node_modules/electron/dist/LICENSES.chromium.html
#
# IANAL:
# This list appears auto generated (99.4k line html license file), but some of
# these modules or files may not be present in the Chromium source code tarball.
# The license compatibility may be better explained in the headers or usage
# (build files versus redistributed).
#

#KEYWORDS="~amd64" # ebuild still in development
# It should work in emscripten 1.x.
# Last bug related to >= emscripten 3.0:

#Unhandled Rejection (ReferenceError): addOnPreMain is not defined
#(anonymous function)
#http://localhost:3000/libGD.js?cache-buster=5.1.155-unknown-hash:11498:26
#(anonymous function)
#src/index.js:88
#  85 |   return;
#  86 | }
#  87 | 
#> 88 | initializeGDevelopJs({
#     | ^  89 |   // Override the resolved URL for the .wasm file,
#  90 |   // to ensure a new version is fetched when the version changes.
#  91 |   locateFile: (path: string, prefix: string) => {

SLOT_MAJOR=$(ver_cut 1 ${PV})
SLOT="${SLOT_MAJOR}/${PV}"
IUSE+=" +extensions openrc"
# Dependency lists:
# https://github.com/4ian/GDevelop/blob/v5.1.155/.circleci/config.yml#L85
# https://github.com/4ian/GDevelop/blob/v5.1.155/.travis.yml
# https://github.com/4ian/GDevelop/blob/v5.1.155/ExtLibs/installDeps.sh
# https://app.travis-ci.com/github/4ian/GDevelop (raw log)
# U 16.04
# Dependencies for the native build are not installed in CI
EMSCRIPTEN_PV="1.39.6" # Based on CI.  EMSCRIPTEN_PV == EMSDK_PV
GDCORE_TESTS_NODEJS_PV="16.15.1" # Based on CI, For building GDCore tests
GDEVELOP_JS_NODEJS_PV="14.18.2" # Based on CI, For building GDevelop.js.
# emscripten 1.36.6 requires llvm10 for wasm, 4.1.1 nodejs
NODEJS_PV_TARGET="13"
UDEV_PV="229"

LLVM_SLOTS=(13) # Deleted 9 8 7 because asm.js support was dropped.
# The CI uses Clang 7.
# Emscripten expects either LLVM 10 for wasm, or LLVM 6 for asm.js.

gen_llvm_depends() {
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
		(
			>=dev-util/emscripten-${EMSCRIPTEN_PV}:${s}[wasm(+)]
			=sys-devel/lld-${s}*
			sys-devel/clang:${s}
			sys-devel/llvm:${s}
		)
		"
	done
}

DEPEND_NOT_USED_IN_CI="
	>=media-libs/freetype-2.10.1
	>=media-libs/glew-1.13
	>=media-libs/libsndfile-1.0.25
	>=media-libs/mesa-18.0.5
	>=media-libs/openal-1.16.0
	>=virtual/jpeg-80
	>=x11-apps/xrandr-1.5.0
	virtual/opengl
	virtual/udev
	x11-misc/xdg-utils
	openrc? (
		sys-apps/openrc[bash]
	)
"
DEPEND_NOT_USED_IN_CI2="
	>=sys-fs/udev-${UDEV_PV}
	>=sys-fs/eudev-3.1.5
"
DEPEND+="
	${DEPEND_NOT_USED_IN_CI}
	>=app-arch/p7zip-9.20.1
	>=net-libs/nodejs-${NODEJS_PV_TARGET}:16
	|| (
		${DEPEND_NOT_USED_IN_CI2}
		>=sys-apps/systemd-${UDEV_PV}
	)
"
RDEPEND+="
	${DEPEND}
"
#
# The package actually uses two nodejs, but the current multislot nodejs
# package cannot switch in the middle of emerge.  From experience, the
# highest nodejs works.
#
# acorn not used in CI
BDEPEND+="
	|| (
		$(gen_llvm_depends)
	)
	>=dev-util/cmake-3.12.4
	>=dev-vcs/git-2.37.3
	>=media-gfx/imagemagick-6.8.9[png]
	>=net-libs/nodejs-${NODEJS_PV_TARGET}:${NODEJS_PV_TARGET%%.*}[acorn]
	>=net-libs/nodejs-${NODEJS_PV_TARGET}[acorn,npm]
	>=sys-devel/gcc-5.4
	dev-util/emscripten:16[wasm(+)]
"
# Emscripten 3.1.3 used because of node 14.
SRC_URI="
https://github.com/4ian/${MY_PN}/archive/v${MY_PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${MY_PN}-${MY_PV}"
S_BAK="${WORKDIR}/${MY_PN}-${MY_PV}"
RESTRICT="mirror"
CHECKREQS_DISK_BUILD="2752M"
CHECKREQS_DISK_USR="2736M"
CMAKE_BUILD_TYPE=Release
EMBUILD_DIR="${WORKDIR}/build"

pkg_pretend() {
	check-reqs_pkg_setup
}

pkg_setup_html5() {
	if [[ -z "${EMSCRIPTEN}" ]] ; then
eerror
eerror "EMSCRIPTEN is empty.  Did you install the emscripten package or forget"
eerror "to \`source /etc/profile\`"
eerror
		die
	else
		if [[ ! -d "${EMSCRIPTEN}" ]] ; then
eerror
eerror "EMSCRIPTEN should point to a directory.  Your emscripten package is"
eerror "broken.  Use the one from oiledmachine-overlay.  Also try to"
eerror "\`source /etc/profile\`."
eerror
			die
		fi
	fi

	electron-app_pkg_setup
	if [[ -z "${EM_CONFIG}" ]] ; then
eerror
eerror "EM_CONFIG is empty.  Did you install the emscripten package?"
eerror
		die
	fi
	export ACTIVE_VERSION=$(grep -F \
		-e "#define NODE_MAJOR_VERSION" \
		"${EROOT}/usr/include/node/node_version.h" \
		| cut -f 3 -d " ")
	if ver_test ${ACTIVE_VERSION%%.*} -ne ${NODEJS_PV_TARGET%%.*} ; then
eerror
eerror "Please switch Node.js to ${NODEJS_PV_TARGET%%.*}"
eerror
		die
	fi
}

pkg_setup() {
	pkg_setup_html5
	check-reqs_pkg_setup

	if ! egetent group ${PN} ; then
eerror
eerror "You must add the ${PN} group to the system."
eerror
eerror "  groupadd ${PN}"
eerror
		die
	fi
	if ! egetent passwd ${PN} ; then
eerror
eerror "You must add the ${PN} user to the system."
eerror
eerror "  useradd ${PN} -g ${PN} -d /var/lib/${PN}"
eerror
		die
	fi

ewarn
ewarn "Consider using the web-browser only version instead which the browser"
ewarn "itself which is updated frequently and consistently.  It is more secure"
ewarn "than the Electron version which is based on an outdated parts of"
ewarn "Chromium and Node.js."
ewarn
ewarn "There is also a responsiblity to notify all users of wrapping your games"
ewarn "in vulnerable versions of Electron and to update them with non defective"
ewarn "versions of Electron, internal Chromium, internal Node.js."
ewarn
ewarn "Details about chrome security can be found at:"
ewarn "https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=chrome&search_type=all"
ewarn "https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=v8%20chrome&search_type=all"
ewarn "https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=node.js&search_type=all"
ewarn
	if [[ "${NPM_UTILS_ALLOW_AUDIT}" != "0" ]] ; then
eerror
eerror "NPM_UTILS_ALLOW_AUDIT=0 needs to be added as a per-package envvar"
eerror
		die
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}" || die
	eapply \
"${FILESDIR}/${PN}-5.0.0_beta97-use-emscripten-envvar-for-webidl_binder_py.patch"
	eapply \
"${FILESDIR}/${PN}-5.0.0_beta108-unix-make.patch"
	eapply \
"${FILESDIR}/${PN}-5.0.127-fix-cmake-cxx-tests.patch"
	eapply --binary \
"${FILESDIR}/${PN}-5.0.127-SFML-define-linux-00.patch"
	eapply \
"${FILESDIR}/${PN}-5.0.127-SFML-define-linux-01.patch"

	einfo "ELECTRON_APP_ELECTRON_PV=${ELECTRON_APP_ELECTRON_PV}"
	einfo "EMSCRIPTEN=${EMSCRIPTEN}"
	addpredict "${EMSCRIPTEN}"
	export TEMP_DIR='/tmp'
	export LLVM_ROOT="${EMSDK_LLVM_ROOT}"
	export CLOSURE_COMPILER="${EMSDK_CLOSURE_COMPILER}"
	mkdir -p "${EMBUILD_DIR}" || die
	if ! [[ -e "${EM_CONFIG}" ]] ; then
		local em_pv=$(best_version "dev-util/emscripten:16")
		em_pv=$(echo "${em_pv}" | sed -e "s|dev-util/emscripten-||g")
		em_pv=$(ver_cut 1-3 ${em_pv})
eerror
eerror "Do:"
eerror
eerror "  eselect emscripten list"
eerror "  eselect emscripten set \"emscripten-${em_pv},llvm-16\""
eerror "  etc-update"
eerror "  . /etc/profile"
eerror
		die
	fi
	cp "${EM_CONFIG}" \
		"${EMBUILD_DIR}/emscripten.config" || die
#	export EMMAKEN_CFLAGS='-std=gnu++11'
#	export EMCC_CFLAGS='-std=gnu++11'
	export EMCC_CFLAGS="-stdlib=libc++"
        export BINARYEN="${EMSDK_BINARYEN_BASE_PATH}"
	export CC="emcc"
	export CXX="em++"
	strip-unsupported-flags
#	export CC=gcc
#	export CXX=g++
        export CLOSURE_COMPILER="${EMSDK_CLOSURE_COMPILER}"
	export EM_CACHE="${T}/emscripten/cache"
	emconfig_path=$(cat ${EM_CONFIG})
	export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}"
        export LLVM_ROOT="${EMSDK_LLVM_ROOT}"
	export NODE_VERSION=${ACTIVE_VERSION}


einfo "CC=${CC}"
einfo "CXX=${CXX}"
einfo "CFLAGS=${CFLAGS}"
einfo "CXXFLAGS=${CXXFLAGS}"
einfo "LDFLAGS=${LDFLAGS}"
einfo "BINARYEN=${EMSDK_BINARYEN_BASE_PATH}"
einfo "CLOSURE_COMPILER=${EMSDK_CLOSURE_COMPILER}"
einfo "EMCC_CFLAGS=${EMCC_CFLAGS}"
einfo "LLVM_ROOT=${EMSDK_LLVM_ROOT}"
einfo "NODE_VERSION=${NODE_VERSION}"
	export PATH="/usr/$(get_libdir)/node_modules/acorn/bin:${PATH}"
	export NODE_PATH="/usr/$(get_libdir)/node_modules:${NODE_PATH}"
einfo "NODE_PATH=${NODE_PATH}"
einfo "PATH=${PATH}"

einfo
einfo "Building ${MY_PN}.js"
einfo
	export STEP="BUILDING_GDEVELOP_JS"
	S="${WORKDIR}/${MY_PN}-${MY_PV}/${MY_PN}.js" \
	electron-app_src_unpack

einfo
einfo "Building ${MY_PN} IDE"
einfo
	export STEP="BUILDING_GDEVELOP_IDE"
	S="${WORKDIR}/${MY_PN}-${MY_PV}/newIDE/app" \
	electron-app_src_unpack

einfo
einfo "Building ${MY_PN} $(ver_cut 1 ${PV}) on the Electron runtime"
einfo
	export STEP="BUILDING_GDEVELOP_IDE_ELECTRON"
	S="${WORKDIR}/${MY_PN}-${MY_PV}/newIDE/electron-app" \
	electron-app_src_unpack
	xdg_src_prepare
}

src_prepare() {
	default
	# Patches have already have been applied.
	# You need to fork to apply custom changes instead.
	touch "${T}/.portage_user_patches_applied"
	touch "${PORTAGE_BUILDDIR}/.user_patches_applied"
	export _CMAKE_UTILS_SRC_PREPARE_HAS_RUN=1
}

src_configure() { :; }
src_compile() { :; }

electron-app_src_compile() {
	if [[ "${STEP}" == "BUILDING_GDEVELOP_JS" ]] ; then
		einfo
		einfo "Compiling ${MY_PN}.js"
		einfo
# In https://github.com/4ian/GDevelop/blob/v5.1.155/GDevelop.js/Gruntfile.js#L88
		npm run build -- --force --dev || die
		if [[ ! -f "${S_BAK}/Binaries/embuild/${MY_PN}.js/libGD.wasm" ]]
		then
eerror
eerror "Missing libGD.wasm from ${S_BAK}/Binaries/embuild/${MY_PN}.js"
eerror
			die
		fi

		if [[ ! -f "${S_BAK}/Binaries/embuild/${MY_PN}.js/libGD.js" ]]
		then
eerror
eerror "Missing libGD.js from ${S_BAK}/Binaries/embuild/${MY_PN}.js"
eerror
			die
		fi
	elif [[ "${STEP}" == "BUILDING_GDEVELOP_IDE" ]] ; then
einfo
einfo "Compiling app"
einfo
		#PATH="${S}/node_modules/.bin:${PATH}" \
		S="${WORKDIR}/${MY_PN}-${MY_PV}/newIDE/app" \
		electron-app_src_compile_default
	elif [[ "${STEP}" == "BUILDING_GDEVELOP_IDE_ELECTRON" ]] ; then
einfo
einfo "Compiling electron-app"
einfo
		#PATH="${S}/node_modules/.bin:${PATH}" \
		S="${WORKDIR}/${MY_PN}-${MY_PV}/newIDE/electron-app" \
		electron-app_src_compile_default
	fi
}

src_install() {
	if use openrc ; then
		if [[ "${SKIP_WRAPPER_FILE_SIGNAL}" == "1" ]] ; then
			:
		else
# The patch just sets the PID file of the ${PN}-server, so it is easier to
# shut down.
ewarn
ewarn "Add SKIP_WRAPPER_FILE_SIGNAL=1 to bypass and manually patch if it fails."
ewarn
			eapply "${FILESDIR}/${PN}-5.1.555-wrapper-file-signal.patch"
		fi
	fi
	export ELECTRON_APP_INSTALL_PATH="/opt/${PN}/${SLOT_MAJOR}"

	#
	# We can't use .ico because of XDG icon standards.  .ico is not
	# interoperable with the Linux desktop.
	#
	pushd "${S}/newIDE/electron-app/build/" || die
		convert icon.ico[0] icon-256x256.png
		convert icon.ico[1] icon-128x128.png
		convert icon.ico[2] icon-64x64.png
		convert icon.ico[3] icon-48x48.png
		convert icon.ico[4] icon-32x32.png
		convert icon.ico[5] icon-16x16.png
		newicon -s 256 icon-256x256.png ${PN}.png
		newicon -s 128 icon-128x128.png ${PN}.png
		newicon -s 64 icon-64x64.png ${PN}.png
		newicon -s 48 icon-48x48.png ${PN}.png
		newicon -s 32 icon-32x32.png ${PN}.png
		newicon -s 16 icon-16x16.png ${PN}.png
	popd
	electron-app_desktop_install \
		"*" \
		"newIDE/electron-app/build/icon-256x256.png" \
		"${MY_PN} $(ver_cut 1 ${PV})" "Development;IDE" \
		"/usr/bin/${PN}"

	if [[ -e "${ED}/usr/bin/${PN}" ]] ; then
		rm "${ED}/usr/bin/${PN}" || die # Replace wrapper with the one below
	fi
	cp "${FILESDIR}/${PN}" "${T}/${PN}" || die
	sed -i  -e "s|\$(get_libdir)|$(get_libdir)|g" \
		-e "s|\${PN}|${PN}|g" \
		-e "s|\${SLOT_MAJOR}|${SLOT_MAJOR}|g" \
		"${T}/${PN}" || die
	exeinto /usr/bin
	doexe "${T}/${PN}"

	fperms 0755 "/opt/${PN}/${SLOT_MAJOR}/GDJS/node_modules/esbuild-linux-64/bin/esbuild"

	if use openrc ; then
		cp "${FILESDIR}/${PN}-server-openrc" "${T}/${PN}-server" || die
		sed -i  -e "s|\$(get_libdir)|$(get_libdir)|g" \
			-e "s|\${PN}|${PN}|g" \
			-e "s|\${MY_PN}|${MY_PN}|g" \
			-e "s|\${SLOT_MAJOR}|${SLOT_MAJOR}|g" \
			"${T}/${PN}-server" || die
		exeinto /etc/init.d
		doexe "${T}/${PN}-server"
	fi

	fowners ${PN}:${PN} \
		"${ELECTRON_APP_INSTALL_PATH}/newIDE/app/node_modules" \
		"${ELECTRON_APP_INSTALL_PATH}/newIDE/app/node_modules/libGD.js-for-tests-only" \
		"${ELECTRON_APP_INSTALL_PATH}/newIDE/app/node_modules/libGD.js-for-tests-only/index.js" \
		"${ELECTRON_APP_INSTALL_PATH}/newIDE/app/node_modules/libGD.js-for-tests-only/libGD.wasm" \
		"${ELECTRON_APP_INSTALL_PATH}/newIDE/app/public" \
		"${ELECTRON_APP_INSTALL_PATH}/newIDE/app/public/libGD.js" \
		"${ELECTRON_APP_INSTALL_PATH}/newIDE/app/public/libGD.wasm" \
		"${ELECTRON_APP_INSTALL_PATH}/newIDE/app/src/Version/VersionMetadata.js"
	keepdir "${ELECTRON_APP_INSTALL_PATH}/.cache/.eslintcache"
        fowners -R ${PN}:${PN} \
		"${ELECTRON_APP_INSTALL_PATH}/newIDE/app/node_modules/.cache/.eslintcache"
		"${ELECTRON_APP_INSTALL_PATH}/newIDE/app/node_modules/GDJS-for-web-app-only/Runtime" \
		"${ELECTRON_APP_INSTALL_PATH}/newIDE/app/node_modules/GDJS-for-web-app-only/Runtime-sources" \
		"${ELECTRON_APP_INSTALL_PATH}/newIDE/app/public/external" \
		"${ELECTRON_APP_INSTALL_PATH}/newIDE/app/resources/GDJS" \
		"${ELECTRON_APP_INSTALL_PATH}/newIDE/app/resources/GDJS/Runtime" \
		"${ELECTRON_APP_INSTALL_PATH}/newIDE/app/resources/GDJS/Runtime-sources" \
		"${ELECTRON_APP_INSTALL_PATH}/newIDE/app/src/UI/Theme/"
}

pkg_postinst() {
	electron-app_pkg_postinst
	xdg_pkg_postinst
einfo
	if use openrc ; then
einfo "The OpenRC init script is called ${PN}-server.  The ${PN}-server must be"
einfo "started before running the ${PN} wrapper."
	else
ewarn "You must write an init script to start the server or launch the server"
ewarn "manually."
	fi
einfo
einfo "Do not add users to ${PN} group.  It is for server use only."
einfo
einfo "Your projects are saved in"
einfo
einfo "  \"\$(xdg-user-dir DOCUMENTS)/${MY_PN} projects\""
einfo
einfo "if using the Electron version."
einfo
einfo "You can set the IDE_MODE by either Electron or Web_Browser before"
einfo "running ${PN}."
einfo
einfo "Example:"
einfo
einfo "  IDE_MODE=\"Web_Browser\" ${PN}"
einfo
einfo "Or, you can set it in ~/.config/${PN}/${PN}.conf.  The contents of"
einfo "${PN}.conf are as follows:"
einfo
einfo "  IDE_MODE=\"Web_Browser\""
einfo
einfo "After saving IDE_MODE in ${PN}.conf, make sure that you:"
einfo
einfo "  chown \${USER}:\${USER} ~/.config/${PN}/${PN}.conf"
einfo "  chmod go-w ~/.config/${PN}/${PN}.conf"
ewarn
ewarn
ewarn "Games may send anonymous statistics.  See the following commits for"
ewarn "details:"
ewarn
ewarn "https://github.com/4ian/GDevelop/commit/5d62f0c92655a3d83b8d5763c87d0226594478d1"
ewarn "https://github.com/4ian/GDevelop/commit/f650a6aa9cf5d123f1e5fe632a2523f2ac2faaaf"
ewarn
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
