# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-reqs cmake-utils desktop electron-app eutils user xdg

DESCRIPTION="GDevelop is an open-source, cross-platform game engine designed \
to be used by everyone."
HOMEPAGE="https://gdevelop-app.com/"
LICENSE="GDevelop MIT"
KEYWORDS="~amd64"
SLOT_MAJOR=$(ver_cut 1 ${PV})
SLOT="${SLOT_MAJOR}/${PV}"
IUSE+=" asmjs doc electron +extensions +html5 minimal native +wasm web-browser"
REQUIRED_USE+=" ^^ ( html5 native )
	|| ( electron web-browser )
	^^ ( asmjs wasm )
	asmjs? ( html5 )
	wasm? ( html5 )
	wasm" # building with asmjs is broken
#See https://github.com/4ian/GDevelop/blob/master/ExtLibs/installDeps.sh
DEPEND+=" native? (
		app-arch/p7zip
		media-libs/freetype
		media-libs/glew
		media-libs/libsndfile
		media-libs/mesa
		media-libs/openal
		net-libs/webkit-gtk
		virtual/jpeg
		virtual/udev
		x11-apps/xrandr
		x11-libs/gtk+:3
	)
	web-browser? ( x11-misc/xdg-utils )
	virtual/opengl"
RDEPEND="${DEPEND}"
# For the required emscripten version, \
# see https://github.com/4ian/GDevelop/blob/v5.0.0-beta102/.circleci/config.yml
# See also electron-app_src_compile about the wasm (llvm) vs \
# asmjs (emscripten-fastcomp) requirement.
EMSCRIPTEN_MIN_V="1.39.6"
BDEPEND+=" html5? (
		asmjs? (
			>=dev-util/emscripten-${EMSCRIPTEN_MIN_V}[asmjs]
			<dev-util/emscripten-2[asmjs]
		)
		wasm? ( >=dev-util/emscripten-${EMSCRIPTEN_MIN_V}[wasm(+)] )
		<net-libs/nodejs-14
		net-libs/nodejs[npm]
	)
	dev-vcs/git
	media-gfx/imagemagick[png]"
ELECTRON_APP_ELECTRON_V="8.2.5"
ELECTRON_APP_REACT_V="16.8.6"
MY_PN="GDevelop"
MY_PV="${PV//_/-}"
# For the SFML version, see
# https://github.com/4ian/GDevelop/blob/v5.0.0-beta102/ExtLibs/CMakeLists.txt
SFML_V="2.4.1"
SRC_URI=\
"https://github.com/4ian/GDevelop/archive/v${MY_PV}.tar.gz \
	-> ${P}.tar.gz
https://github.com/SFML/SFML/commit/87aaa9e145659d6a8fc193ab8540cf847d4d0def.patch \
	-> ${PV}-SFML-mesa-ge-20180525-compat.patch
https://github.com/SFML/SFML/archive/${SFML_V}.tar.gz \
	-> SFML-${SFML_V}.tar.gz"
S="${WORKDIR}/${MY_PN}-${MY_PV}"
S_BAK="${WORKDIR}/${MY_PN}-${MY_PV}"
RESTRICT="mirror"
CMAKE_BUILD_TYPE=Release
EMBUILD_DIR="${WORKDIR}/build"

_set_check_reqs_requirements() {
	if use html5 ; then
		CHECKREQS_DISK_BUILD="2752M"
		CHECKREQS_DISK_USR="2736M"
	fi
}

pkg_pretend() {
	_set_check_reqs_requirements
	check-reqs_pkg_setup
}

pkg_setup_html5() {
	if [[ -z "${EMSCRIPTEN}" ]] ; then
		die \
"EMSCRIPTEN is empty.  Did you install the emscripten package or forget to \`source /etc/profile\`"
	else
		if [[ ! -d "${EMSCRIPTEN}" ]] ; then
			die \
"EMSCRIPTEN should point to a directory.  Your emscripten package is broken.\n\
Use the one from oiledmachine-overlay.  Also try to \`source /etc/profile\`."
		fi
	fi

	if use wasm ; then
		if eselect emscripten list | grep -q -E -e "llvm-[0-9]+ \*" ; then
			:;
		else
			die \
"You need to set your >=emscripten-${EMSCRIPTEN_MIN_V} and >=llvm-10.\n\
See \`eselect emscripten\` for details.  (1)"
		fi
		local line=$(eselect emscripten list | grep -E -e "llvm-[0-9]+ \*")
		local em_v=$(echo "${line}" | grep -E -e "llvm-[0-9]+ \*" \
			| grep -E -o -e "emscripten-[0-9.]+" \
			| sed -e "s|emscripten-||")
		local llvm_v=$(echo "${line}" \
			| grep -E -e "llvm-[0-9]+ \*" \
			| grep -E -o -e "llvm-[0-9.]+" | sed -e "s|llvm-||")

		if ver_test ${em_v} -ge "${EMSCRIPTEN_MIN_V}" \
			&& ver_test ${llvm_v} -ge 10 ; then
			einfo "Using emscripten-${em_v} and llvm-${llvm_v}"
		else
			die \
"You need to set your >=emscripten-${EMSCRIPTEN_MIN_V} and >=llvm-10.\n\
See \`eselect emscripten\` for details.  (2)"
		fi
	else
		if eselect emscripten list \
			| grep -q -E -e "emscripten-fastcomp-[0-9]+ \*" ; then
			:;
		else
			die \
"You need to set your >=emscripten-${EMSCRIPTEN_MIN_V} and\n\
>=emscripten-fastcomp-${EMSCRIPTEN_MIN_V} and both same version.\n\
See \`eselect emscripten\` for details.  (1)"
		fi
		local line=$(eselect emscripten list \
			| grep -E -e "emscripten-fastcomp-[0-9]+ \*")
		local em_v=$(echo "${line}" | grep -E -e "llvm-[0-9]+ \*" \
			| grep -E -o -e "emscripten-[0-9.]+" \
			| sed -e "s|emscripten-||")
		local fc_v=$(echo "${line}" | grep -E -e "llvm-[0-9]+ \*" \
			| grep -E -o -e "emscripten-fastcomp-[0-9.]+" \
			| sed -e "s|emscripten-fastcomp-||")

		if ver_test ${em_v} -ge "${EMSCRIPTEN_MIN_V}" \
			&& ver_test ${fc_v} -ge ${EMSCRIPTEN_MIN_V} \
			&& ver_test ${em_v} -eq ${fc_v} ; then
			einfo "Using emscripten-${em_v} and emscripten-fastcomp-${fc_v}"
		else
			die \
"You need to set your >=emscripten-${EMSCRIPTEN_MIN_V} and\n\
>=emscripten-fastcomp-${EMSCRIPTEN_MIN_V} and both same version.\n\
See \`eselect emscripten\` for details.  (2)"
		fi
	fi

	electron-app_pkg_setup
	if [[ -z "${EM_CONFIG}" ]] ; then
		die \
"EM_CONFIG is empty.  Did you install the emscripten package?"
	fi
	export ACTIVE_VERSION=$(grep -F -e "#define NODE_MAJOR_VERSION" \
        "${EROOT}/usr/include/node/node_version.h" | cut -f 3 -d " ")
	if ver_test "${ACTIVE_VERSION}" -ge 14 ; then
		die \
"Node.js 14 is not supported.  You must run \`eselect nodejs set node12\` or\n\
less.  Those versions are only supported"
	fi
}

pkg_setup() {
	if use html5 ; then
		pkg_setup_html5
		_set_check_reqs_requirements
		check-reqs_pkg_setup
	fi

	if use native ; then
		ewarn \
"The native USE flag has not been developed in the ebuild level and is not\n\
used in GDevelop 5.  Use gdevelop:4 instead."
	fi

	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}
	if use electron ; then
		ewarn \
"Consider using the web-browser only version instead which the browser itself\n\
which is updated frequently and consistently.  It is more secure than the\n\
Electron version which is based on an outdated Chromium 80.0.3987.165\n\
internally with several high vulnerabilties and possibly critical ones.\n\
There is also a responsiblity to notify all users of wrapping your games in\n\
vulnerable versions of Electron and to update them with non defective\n\
versions of Electron and internal Chromium.  The internal v8 is\n\
8.0.426.27-electron.0.\n\
\n\
Details about chrome security can be found at:\n\
https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=chrome&search_type=all\n\
https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=v8%20chrome&search_type=all"
	fi
}

_patch() {
	eapply "${FILESDIR}/gdevelop-5.0.0_beta97-patch-sfml-if-downloaded.patch"
	eapply \
"${FILESDIR}/gdevelop-5.0.0_beta97-use-emscripten-envvar-for-webidl_binder_py.patch"
	sed -i -e "s|emconfigure cmake|emcmake cmake|" GDevelop.js/Gruntfile.js || die
}

src_unpack() {
	unpack ${A}
	cd "${S}" || die
	rm -rf ExtLibs/SFML || die
	ln -s "${WORKDIR}/SFML-${SFML_V}" ExtLibs/SFML || die
	cat "${DISTDIR}/${PV}-SFML-mesa-ge-20180525-compat.patch" \
		> ExtLibs/SFML-patches/${PV}-SFML-mesa-ge-20180525-compat.patch || die
	_patch
	if use html5 ; then
		einfo "ELECTRON_APP_ELECTRON_V=${ELECTRON_APP_ELECTRON_V}"
		einfo "EMSCRIPTEN=${EMSCRIPTEN}"
		addpredict "${EMSCRIPTEN}"
		export TEMP_DIR='/tmp'
		export LLVM_ROOT="${EMSDK_LLVM_ROOT}"
		export CLOSURE_COMPILER="${EMSDK_CLOSURE_COMPILER}"
		mkdir -p "${EMBUILD_DIR}" || die
		cp "${EM_CONFIG}" \
			"${EMBUILD_DIR}/emscripten.config" || die
		export CC=emcc
		export CXX=em++
		export NODE_VERSION=${ACTIVE_VERSION}
		export EM_CACHE="${T}/emscripten/cache"
		BINARYEN_LIB_PATH=$(echo -e "${A}\nprint (BINARYEN_ROOT)" | python3)"/lib"
		export LD_LIBRARY_PATH="${BINARYEN_LIB_PATH}:${LD_LIBRARY_PATH}"
		einfo "CC=${CC} CXX=${CXX}"
		einfo "NODE_VERSION=${NODE_VERSION}"

		einfo "Building GDevelop.js"
		STEP="BUILDING_GDEVELOPJS" \
		S="${WORKDIR}/${MY_PN}-${MY_PV}/GDevelop.js" \
		electron-app_src_unpack

		einfo "Building GDevelop IDE"
		STEP="BUILDING_GDEVELOP_IDE" \
		S="${WORKDIR}/${MY_PN}-${MY_PV}/newIDE/app" \
		electron-app_src_unpack

		if use electron ; then
			einfo "Building GDevelop$(ver_cut 1 ${PV}) on the Electron runtime"
			STEP="BUILDING_GDEVELOP_IDE_ELECTRON" \
			S="${WORKDIR}/${MY_PN}-${MY_PV}/newIDE/electron-app" \
			electron-app_src_unpack
		fi
	fi
	xdg_src_prepare
}

src_prepare() {
	if use native ; then
		cmake-utils_src_prepare
	else
		# Patches have already have been applied.
		# You need to fork to apply custom changes instead.
		touch "${T}/.portage_user_patches_applied"
		touch "${PORTAGE_BUILDDIR}/.user_patches_applied"
		export _CMAKE_UTILS_SRC_PREPARE_HAS_RUN=1
	fi
}

src_configure() {
	if use native ; then
		local mycmakeargs=(
			-DBUILD_GDCPP=$(usex native)
			-DBUILD_GDJS=OFF
			-DBUILD_EXTENSIONS=$(usex extensions)
			-DBUILD_TESTS=FALSE
			-DGD_INSTALL_PREFIX=/usr/$(get_libdir)/gdevelop
		)
		cmake-utils_src_configure
	fi
}

src_compile() {
	if use native ; then
		cmake-utils_src_compile
	fi
}

electron-app_src_compile() {
	if [[ "${STEP}" == "BUILDING_GDEVELOPJS" ]] ; then
		einfo "Compiling GDevelop.js"
# In https://github.com/4ian/GDevelop/blob/v5.0.0-beta98/GDevelop.js/Gruntfile.js#L88
		if use wasm ; then
			npm run build -- --dev || die
			if [[ ! \
-f "${S_BAK}/Binaries/embuild/GDevelop.js/libGD.wasm" ]] ; then
				die \
"Missing libGD.wasm from ${S_BAK}/Binaries/embuild/GDevelop.js"
			fi
		else
			npm run build || die
		fi

		if [[ ! -f "${S_BAK}/Binaries/embuild/GDevelop.js/libGD.js" ]] ; then
			die "Missing libGD.js from ${S_BAK}/Binaries/embuild/GDevelop.js"
		fi
	elif [[ "${STEP}" == "BUILDING_GDEVELOP_IDE" ]] ; then
		einfo "Compiling app"
		#PATH="${S}/node_modules/.bin:${PATH}" \
		S="${WORKDIR}/${MY_PN}-${MY_PV}/newIDE/app" \
		electron-app_src_compile_default
	elif [[ "${STEP}" == "BUILDING_GDEVELOP_IDE_ELECTRON" ]] ; then
		einfo "Compiling electron-app"
		#PATH="${S}/node_modules/.bin:${PATH}" \
		S="${WORKDIR}/${MY_PN}-${MY_PV}/newIDE/electron-app" \
		electron-app_src_compile_default
	fi
}

src_install_html5() {
	eapply "${FILESDIR}/gdevelop-5.0.0_beta97-wrapper-file-signal.patch"
	export ELECTRON_APP_INSTALL_PATH="/usr/$(get_libdir)/node/${PN}/${SLOT_MAJOR}"

	if ! use electron ; then
		rm -rf "${ED}/${ELECTRON_APP_INSTALL_PATH}/electron-app" || die
	#else
	#	keep Binaries, GDJS/Binaries, scripts, Core/GDCore, Extensions
	#	keep GDJS/Runtime
	fi
	if ! use native ; then
		# todo
		rm -rf "GDCpp" || die
	fi
	if use minimal ; then
		rm -rf ".circleci" \
			".clang_complete" \
			".clang_format" \
			".eslintrc" \
			".github" \
			".gitignore" \
			".travis.yml" \
			".vscode" || die
	fi

	find GDJS -maxdepth 1 \
		 \( \
			-not -name "GDJS" \
			-and -not -path "GDJS/Binaries" \
			-and -not -path "GDJS/Runtime" \
			-and -not -path "GDJS/docs" \
			-and -not -name "README.md" \
			-and -not -name "Runtime" \
			-and -not -name "package.json" \
			-and -not -name "package-lock.json" \
		\) \
                -exec rm -vrf "{}" \;

	find Core -maxdepth 1 \
		\( \
			-not -path "Core" \
			-and -not -path "Core/GDCore" \
			-and -not -path "Core/docs/images/glogo.png" \
			-and -not -name "README.md" \
			-and -not -name "license.txt" \
			-and -not -name "docs" \
		\) \
			-exec rm -vrf "{}" \;
	if [[ ! -d "GDJS/Runtime" ]] ; then
		die "Missing GDJS/Runtime"
	fi
	if [[ ! -d "Core/GDCore" ]] ; then
		die "Missing Core/GDCore"
	fi
	# appimaged is still in testing
	#
	# We can't use .ico (image/vnd.microsoft.icon) because of XDG icon
	# standards.  Not interoperable with Linux desktop.
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
	electron-app_desktop_install "*" "newIDE/electron-app/build/icon-256x256.png" \
		"${MY_PN} $(ver_cut 1 ${PV})" "Development;IDE" \
		"/usr/bin/gdevelop"
	if use doc ; then
		npm-utils_install_readmes
		# Dedupe.  The newIDE folder has already been copied
		rm -rf "${ED}"/usr/share/doc/${PF}/readmes/newIDE || die
		# False positive
		rm -rf $(find "${ED}/usr/share/" -name "docNoticeRole.js*") || die
	fi
	npm-utils_install_licenses
	# Dedupe.  The newIDE folder has already been copied
	rm -rf "${ED}"/usr/share/doc/${PF}/licenses/newIDE || die

	rm "${ED}/usr/bin/gdevelop" || die # replace wrapper with the one below
	cp "${FILESDIR}/${PN}" "${T}/${PN}" || die
	sed -i -e "s|\$(get_libdir)|$(get_libdir)|g" \
		-e "s|\${PN}|${PN}|g" \
		-e "s|\${SLOT_MAJOR}|${SLOT_MAJOR}|g" \
		"${T}/${PN}" || die
	exeinto /usr/bin
	doexe "${T}/${PN}"

	# We just daemonize it.
	cp "${FILESDIR}/${PN}-server-openrc" \
		"${T}/${PN}-server" || die
	sed -i -e "s|\$(get_libdir)|$(get_libdir)|g" \
		-e "s|\${PN}|${PN}|g" \
		-e "s|\${SLOT_MAJOR}|${SLOT_MAJOR}|g" \
		"${T}/${PN}-server" || die
	exeinto /etc/init.d
	doexe "${T}/${PN}-server"

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

src_install() {
	if use native ; then
		cmake-utils_src_install
	fi
	if use html5 ; then
		src_install_html5
	fi
}

pkg_postinst() {
	electron-app_pkg_postinst
	xdg_pkg_postinst
	einfo \
"Currently OpenRC is supported.  The init script is called gdevelop-server.\n\
It must be started before running the gdevelop wrapper.\n\
\n\
Do not add users to ${PN} group.  It is for server use only.\n\
\n\
Your projects are saved in \"\$(xdg-user-dir DOCUMENTS)/GDevelop projects\" if\n\
using the Electron version.\n\
\n\
You can set the IDE_MODE by either Electron or Web_Browser before running\n\
gdevelop.\n\
\n\
Example:\n\
IDE_MODE=\"Web_Browser\" gdevelop\n\
\n\
Or,\n\
\n\
you can set it in ~/.config/gdevelop/gdevelop.conf.  The contents of\n\
gdevelop.conf are as follows:\n\
IDE_MODE=\"Web_Browser\"\n\
\n\
After saving IDE_MODE in gdevelop.conf, make sure that you:\n\
\`chown \${USER}:\${USER} ~/.config/gdevelop/gdevelop.conf\`\n\
\`chmod go-w ~/.config/gdevelop/gdevelop.conf\`."
	ewarn \
"\n\
Games may send anonymous statistics.  See the following commits for details:\n\
https://github.com/4ian/GDevelop/commit/5d62f0c92655a3d83b8d5763c87d0226594478d1\n\
https://github.com/4ian/GDevelop/commit/f650a6aa9cf5d123f1e5fe632a2523f2ac2faaaf\n\
\n"
	ewarn
}
