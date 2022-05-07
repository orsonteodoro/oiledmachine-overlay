# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit check-reqs cmake-utils desktop electron-app eutils user \
	toolchain-funcs xdg

DESCRIPTION="GDevelop is an open-source, cross-platform game engine designed
to be used by everyone."
HOMEPAGE="https://gdevelop-app.com/"
LICENSE="GDevelop MIT"
#KEYWORDS="~amd64" # ebuild still in development
SLOT_MAJOR=$(ver_cut 1 ${PV})
SLOT="${SLOT_MAJOR}/${PV}"
IUSE+=" electron +extensions openrc"
# See https://github.com/4ian/GDevelop/blob/v5.0.131/ExtLibs/installDeps.sh
# See *raw log* of https://app.travis-ci.com/github/4ian/GDevelop
# U 16.04
# Dependencies in native are not installed in CI
UDEV_V="229"
DEPEND+="
	|| (
		>=sys-fs/udev-${UDEV_V}
		>=sys-fs/eudev-3.1.5
		>=sys-apps/systemd-${UDEV_V}
	)
	>=app-arch/p7zip-9.20.1
	>=media-libs/freetype-2.6.1
	>=media-libs/glew-1.13
	>=media-libs/libsndfile-1.0.25
	>=media-libs/mesa-18.0.5
	>=media-libs/openal-1.16.0
	>=virtual/jpeg-80
	  virtual/opengl
	  virtual/udev
	>=x11-apps/xrandr-1.5.0
	!electron? ( x11-misc/xdg-utils )
	 openrc? ( sys-apps/openrc[bash] )
"
RDEPEND+=" ${DEPEND}"
EMSCRIPTEN_MIN_V="1.39.6" # Based on CI
NODEJS_V="16.15.0" # Based on CI
MAX_NODEJS_V="16.15.0" # Based on CI, For building SFML/GDCore
MIN_NODEJS_V="14.18.2" # Based on CI, For building GDevelop.js
#
# The package actually uses two nodejs, but the current multislot nodejs
# package cannot switch in the middle of emerge.  From experience, the
# highest nodejs works.
#
# >=dev-vcs/git-2.35.0 is used by CI but relaxed
LLVM_SLOTS=(15 14 13 12 11 10) # Deleted 9 8 7 because asm.js support was dropped.
# The CI uses Clang 7.
# Emscripten expects either LLVM 10 for wasm, or LLVM 6 for asm.js.
MIN_LLVM="10"

gen_llvm_depends() {
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
		(
			sys-devel/llvm:${s}
			sys-devel/clang:${s}
			=sys-devel/lld-${s}*
		)
		"
	done
}

BDEPEND+="
	|| ( $(gen_llvm_depends) )
	>=dev-util/cmake-3.12.4
	>=dev-util/emscripten-${EMSCRIPTEN_MIN_V}[wasm(+)]
	>=dev-vcs/git-2.35.1
	>=media-gfx/imagemagick-6.8.9[png]
	>=sys-devel/gcc-5.4
	>=net-libs/nodejs-${NODEJS_V}:${NODEJS_V%%.*}
	>=net-libs/nodejs-${NODEJS_V}[npm]
"
ELECTRON_APP_ELECTRON_V="8.2.5" # See \
# https://raw.githubusercontent.com/4ian/GDevelop/v5.0.131/newIDE/electron-app/package-lock.json
ELECTRON_APP_REACT_V="16.8.6" # See \
# https://raw.githubusercontent.com/4ian/GDevelop/v5.0.131/newIDE/app/package-lock.json
MY_PN="GDevelop"
MY_PV="${PV//_/-}"
# For the SFML version, see \
# https://github.com/4ian/GDevelop/blob/v5.0.131/ExtLibs/CMakeLists.txt
SFML_V="2.4.1"
SRC_URI="
https://github.com/4ian/GDevelop/archive/v${MY_PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/SFML/SFML/commit/87aaa9e145659d6a8fc193ab8540cf847d4d0def.patch
	-> ${PV}-SFML-mesa-ge-20180525-compat.patch
https://github.com/SFML/SFML/archive/${SFML_V}.tar.gz
	-> SFML-${SFML_V}.tar.gz
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

	if eselect emscripten list \
		| grep -q -E -e "llvm-[0-9]+ \*" ; then
		:;
	else
eerror
eerror "You need to set your >=emscripten-${EMSCRIPTEN_MIN_V} and"
eerror ">=sys-devel/llvm-${MIN_LLVM}.  See \`eselect emscripten\` for details.  (1)"
eerror
		die
	fi
	local line=$(eselect emscripten list \
		| grep -E -e "llvm-[0-9]+ \*")
	local em_v=$(echo "${line}" \
		| grep -E -e "llvm-[0-9]+ \*" \
		| grep -E -o -e "emscripten-[0-9.]+" \
		| sed -e "s|emscripten-||")
	local llvm_v=$(echo "${line}" \
		| grep -E -e "llvm-[0-9]+ \*" \
		| grep -E -o -e "llvm-[0-9.]+" \
		| sed -e "s|llvm-||")

	if ver_test ${em_v}   -ge ${EMSCRIPTEN_MIN_V} \
	&& ver_test ${llvm_v} -ge ${MIN_LLVM} ; then
einfo
einfo "Using emscripten-${em_v} and >=llvm-${llvm_v}"
einfo
	else
eerror
eerror "You need to set your >=emscripten-${EMSCRIPTEN_MIN_V} and >=llvm-${MIN_LLVM}."
eerror "See \`eselect emscripten\` for details.  (2)"
eerror
		die
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
	if ver_test ${ACTIVE_VERSION%%.*} -ne ${NODEJS_V%%.*} ; then
eerror
eerror "Please switch Node.js to ${NODEJS_V%%.*}"
eerror
		die
	fi
}

get_lld_slot() {
	echo $(ver_cut 1 $(wasm-ld --version | sed -e "s|LLD ||"))
}

check_lld() {
	export LLVM_SLOT=$(get_lld_slot)
	export CXX="clang++-${LLVM_SLOT}"
	einfo "CXX=${CXX}"
	if has_version "sys-devel/clang:${LLVM_SLOT}[llvm_targets_WebAssembly]" &&
	   has_version "sys-devel/llvm:${LLVM_SLOT}[llvm_targets_WebAssembly]" ; then
		echo "Passed same slot test for lld, clang, llvm."
	else
eerror
eerror "LLD's corresponding version to Clang and LLVM versions must have"
eerror "llvm_targets_WebAssembly.  Either upgrade LLD to version ${LLVM_SLOT}"
eerror "or rebuild with sys-devel/llvm:${LLVM_SLOT}[llvm_targets_WebAssembly] and"
eerror "sys-devel/clang:${LLVM_SLOT}[llvm_targets_WebAssembly]"
eerror
		die
	fi
}

pkg_setup() {
	pkg_setup_html5
	check-reqs_pkg_setup
	check_lld

	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}
	if use electron ; then
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
	fi
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
	rm -rf ExtLibs/SFML || die
	ln -s "${WORKDIR}/SFML-${SFML_V}" ExtLibs/SFML || die
	cat "${DISTDIR}/${PV}-SFML-mesa-ge-20180525-compat.patch" \
		> ExtLibs/SFML-patches/${PV}-SFML-mesa-ge-20180525-compat.patch \
		|| die
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

	einfo "ELECTRON_APP_ELECTRON_V=${ELECTRON_APP_ELECTRON_V}"
	einfo "EMSCRIPTEN=${EMSCRIPTEN}"
	addpredict "${EMSCRIPTEN}"
	export TEMP_DIR='/tmp'
	export LLVM_ROOT="${EMSDK_LLVM_ROOT}"
	export CLOSURE_COMPILER="${EMSDK_CLOSURE_COMPILER}"
	mkdir -p "${EMBUILD_DIR}" || die
	cp "${EM_CONFIG}" \
		"${EMBUILD_DIR}/emscripten.config" || die
#	export EMMAKEN_CFLAGS='-std=gnu++11'
#	export EMCC_CFLAGS='-std=gnu++11'
	export CC=emcc
	export CXX=em++
	strip-unsupported-flags
#	export CC=gcc
#	export CXX=g++
	export NODE_VERSION=${ACTIVE_VERSION}
	export EM_CACHE="${T}/emscripten/cache"
	emconfig_path=$(cat ${EM_CONFIG})
	BINARYEN_LIB_PATH=$(echo \
		-e "${emconfig_path}\nprint (BINARYEN_ROOT)" \
		| python3)"/lib"
	export LD_LIBRARY_PATH="${BINARYEN_LIB_PATH}:${LD_LIBRARY_PATH}"
einfo "CC=${CC}"
einfo "CXX=${CXX}"
einfo "CFLAGS=${CFLAGS}"
einfo "CXXFLAGS=${CXXFLAGS}"
einfo "LDFLAGS=${LDFLAGS}"
einfo "NODE_VERSION=${NODE_VERSION}"

einfo
einfo "Building GDevelop.js"
einfo
	export STEP="BUILDING_GDEVELOPJS"
	S="${WORKDIR}/${MY_PN}-${MY_PV}/GDevelop.js" \
	electron-app_src_unpack

einfo
einfo "Building GDevelop IDE"
einfo
	export STEP="BUILDING_GDEVELOP_IDE"
	S="${WORKDIR}/${MY_PN}-${MY_PV}/newIDE/app" \
	electron-app_src_unpack

	if use electron ; then
einfo
einfo "Building GDevelop$(ver_cut 1 ${PV}) on the Electron runtime"
einfo
		export STEP="BUILDING_GDEVELOP_IDE_ELECTRON"
		S="${WORKDIR}/${MY_PN}-${MY_PV}/newIDE/electron-app" \
		electron-app_src_unpack
	fi
	xdg_src_prepare
}

src_prepare() {
	# Patches have already have been applied.
	# You need to fork to apply custom changes instead.
	touch "${T}/.portage_user_patches_applied"
	touch "${PORTAGE_BUILDDIR}/.user_patches_applied"
	export _CMAKE_UTILS_SRC_PREPARE_HAS_RUN=1
}

src_configure() { :; }
src_compile() { :; }

electron-app_src_compile() {
	if [[ "${STEP}" == "BUILDING_GDEVELOPJS" ]] ; then
		einfo
		einfo "Compiling GDevelop.js"
		einfo
# In https://github.com/4ian/GDevelop/blob/v5.0.0-beta98/GDevelop.js/Gruntfile.js#L88
		npm run build -- --force --dev || die
		if [[ ! -f "${S_BAK}/Binaries/embuild/GDevelop.js/libGD.wasm" ]]
		then
eerror
eerror "Missing libGD.wasm from ${S_BAK}/Binaries/embuild/GDevelop.js"
eerror
			die
		fi

		if [[ ! -f "${S_BAK}/Binaries/embuild/GDevelop.js/libGD.js" ]]
		then
eerror
eerror "Missing libGD.js from ${S_BAK}/Binaries/embuild/GDevelop.js"
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
# Cannot finish emerge or testing if micropackage servers are flaky and unreliable.
# The patch just sets the PID file of the gdevelop-server, so it is easier to
# shut down.
ewarn
ewarn "The ${FILESDIR}/gdevelop-5.0.0_beta97-wrapper-file-signal.patch has not"
ewarn "been tested in recent point releases."
ewarn
ewarn "Add SKIP_WRAPPER_FILE_SIGNAL=1 to bypass and manually patch if it fails."
ewarn
		if [[ "${Add SKIP_WRAPPER_FILE_SIGNAL}" == "1" ]] ; then
			:
		else
			eapply "${FILESDIR}/gdevelop-5.0.0_beta97-wrapper-file-signal.patch"
		fi
	fi
	export ELECTRON_APP_INSTALL_PATH="/usr/$(get_libdir)/node/${PN}/${SLOT_MAJOR}"
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
		"/usr/bin/gdevelop"

	rm "${ED}/usr/bin/gdevelop" || die # Replace wrapper with the one below
	cp "${FILESDIR}/${PN}" "${T}/${PN}" || die
	sed -i  -e "s|\$(get_libdir)|$(get_libdir)|g" \
		-e "s|\${PN}|${PN}|g" \
		-e "s|\${SLOT_MAJOR}|${SLOT_MAJOR}|g" \
		"${T}/${PN}" || die
	exeinto /usr/bin
	doexe "${T}/${PN}"

	if use openrc ; then
		cp "${FILESDIR}/${PN}-server-openrc" "${T}/${PN}-server" || die
		sed -i  -e "s|\$(get_libdir)|$(get_libdir)|g" \
			-e "s|\${PN}|${PN}|g" \
			-e "s|\${SLOT_MAJOR}|${SLOT_MAJOR}|g" \
			"${T}/${PN}-server" || die
		exeinto /etc/init.d
		doexe "${T}/${PN}-server"
	fi

	fowners gdevelop:gdevelop \
		"${ELECTRON_APP_INSTALL_PATH}/newIDE/app/node_modules" \
		"${ELECTRON_APP_INSTALL_PATH}/newIDE/app/node_modules/libGD.js-for-tests-only" \
		"${ELECTRON_APP_INSTALL_PATH}/newIDE/app/node_modules/libGD.js-for-tests-only/index.js" \
		"${ELECTRON_APP_INSTALL_PATH}/newIDE/app/node_modules/libGD.js-for-tests-only/libGD.wasm" \
		"${ELECTRON_APP_INSTALL_PATH}/newIDE/app/public" \
		"${ELECTRON_APP_INSTALL_PATH}/newIDE/app/public/libGD.js" \
		"${ELECTRON_APP_INSTALL_PATH}/newIDE/app/public/libGD.wasm" \
		"${ELECTRON_APP_INSTALL_PATH}/newIDE/app/src/Version/VersionMetadata.js"
        fowners -R gdevelop:gdevelop \
		"${ELECTRON_APP_INSTALL_PATH}/newIDE/app/node_modules/GDJS-for-web-app-only/Runtime" \
		"${ELECTRON_APP_INSTALL_PATH}/newIDE/app/resources/GDJS/Runtime" \
		"${ELECTRON_APP_INSTALL_PATH}/newIDE/app/public/external"
}

pkg_postinst() {
	electron-app_pkg_postinst
	xdg_pkg_postinst
einfo
	if use openrc ; then
einfo "The OpenRC init script is called gdevelop-server.  The gdevelop-server"
einfo "must be started before running the gdevelop wrapper."
	else
ewarn "You must write an init script to start the server or launch the server"
ewarn "manually."
	fi
einfo
einfo "Do not add users to ${PN} group.  It is for server use only."
einfo
einfo "Your projects are saved in"
einfo
einfo "  \"\$(xdg-user-dir DOCUMENTS)/GDevelop projects\""
einfo
einfo "if using the Electron version."
einfo
einfo "You can set the IDE_MODE by either Electron or Web_Browser before running"
einfo "gdevelop."
einfo
einfo "Example:"
einfo
einfo "  IDE_MODE=\"Web_Browser\" gdevelop"
einfo
einfo "Or, you can set it in ~/.config/gdevelop/gdevelop.conf.  The contents of"
einfo "gdevelop.conf are as follows:"
einfo
einfo "  IDE_MODE=\"Web_Browser\""
einfo
einfo "After saving IDE_MODE in gdevelop.conf, make sure that you:"
einfo
einfo "  chown \${USER}:\${USER} ~/.config/gdevelop/gdevelop.conf"
einfo "  chmod go-w ~/.config/gdevelop/gdevelop.conf"
ewarn
ewarn
ewarn "Games may send anonymous statistics.  See the following commits for details:"
ewarn "https://github.com/4ian/GDevelop/commit/5d62f0c92655a3d83b8d5763c87d0226594478d1"
ewarn "https://github.com/4ian/GDevelop/commit/f650a6aa9cf5d123f1e5fe632a2523f2ac2faaaf"
ewarn
}
