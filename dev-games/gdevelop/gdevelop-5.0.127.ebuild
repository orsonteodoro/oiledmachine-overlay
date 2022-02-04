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
IUSE+=" doc electron +extensions +html5 minimal native openrc web-browser"
REQUIRED_USE+="
	^^ ( html5 native )
	|| ( electron web-browser )
	openrc
"
# See https://github.com/4ian/GDevelop/blob/v5.0.127/ExtLibs/installDeps.sh
# See raw log of https://app.travis-ci.com/github/4ian/GDevelop
# U 16.04
# Dependencies in native are not installed in CI
UDEV_V="229"
DEPEND+="
	virtual/opengl
	>=app-arch/p7zip-9.20.1
	>=media-libs/freetype-2.6.1
	>=media-libs/glew-1.13
	>=media-libs/libsndfile-1.0.25
	>=media-libs/mesa-18.0.5
	>=media-libs/openal-1.16.0
	>=virtual/jpeg-80
	(
		virtual/udev
		|| (
			>=sys-fs/udev-${UDEV_V}
			>=sys-fs/eudev-3.1.5
			>=sys-apps/systemd-${UDEV_V}
		)
	)
	>=x11-apps/xrandr-1.5.0
	native? (
		>=net-libs/webkit-gtk-2.4.11
		>=x11-libs/gtk+-3.22.30:3
	)
	openrc? ( sys-apps/openrc[bash] )
	web-browser? ( x11-misc/xdg-utils )
"
RDEPEND+=" ${DEPEND}"
EMSCRIPTEN_MIN_V="1.39.6" # Based on CI
NODEJS_V="16.13.2" # Based on CI
# >=dev-vcs/git-2.35.0 is used by CI but relaxed
BDEPEND+="
	>=dev-util/cmake-3.12.4
	dev-vcs/git
	>=media-gfx/imagemagick-6.8.9[png]
	>=sys-devel/clang-7
	>=sys-devel/gcc-5.4
	html5? (
		>=dev-util/emscripten-${EMSCRIPTEN_MIN_V}[wasm(+)]
		>=net-libs/nodejs-${NODEJS_V}[npm]
	)
"
ELECTRON_APP_ELECTRON_V="8.2.5" # See \
# https://github.com/4ian/GDevelop/blob/v5.0.127/newIDE/electron-app/package.json
ELECTRON_APP_REACT_V="16.8.6" # See \
# https://github.com/4ian/GDevelop/blob/v5.0.127/newIDE/app/package.json
MY_PN="GDevelop"
MY_PV="${PV//_/-}"
# For the SFML version, see \
# https://github.com/4ian/GDevelop/blob/v5.0.127/ExtLibs/CMakeLists.txt
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
eerror ">=sys-devel/llvm-10.  See \`eselect emscripten\` for details.  (1)"
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

	if ver_test ${em_v} -ge "${EMSCRIPTEN_MIN_V}" \
		&& ver_test ${llvm_v} -ge 10 ; then
einfo
einfo "Using emscripten-${em_v} and llvm-${llvm_v}"
einfo
	else
eerror
eerror "You need to set your >=emscripten-${EMSCRIPTEN_MIN_V} and >=llvm-10."
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
	if ver_test ${ACTIVE_VERSION} -lt ${NODEJS_V} ; then
eerror
eerror "Please switch Node.js to >=${NODEJS_V}"
eerror
		die
	fi
}

check_lld() {
	export HIGHEST_LLVM_SLOT=$(basename $(find \
		"${EROOT}/usr/lib/llvm" \
		-maxdepth 1 \
		-regextype 'posix-extended' -regex ".*[0-9]+.*" \
		| sort -V \
		| tail -n 1))
	for llvm_slot in $(seq $(ver_cut 1 ${LLVM_V}) ${HIGHEST_LLVM_SLOT}) ; do
		if has_version "sys-devel/clang:${llvm_slot}[llvm_targets_WebAssembly]" \
		&& has_version "sys-devel/llvm:${llvm_slot}[llvm_targets_WebAssembly]" ; then
			export LLVM_SLOT="${llvm_slot}"
			export CXX="${EROOT}/usr/lib/llvm/${llvm_slot}/bin/clang++"
			einfo "CXX=${CXX}"
			if [[ ! -f "${CXX}" ]] ; then
eerror
eerror "CXX path is wrong and doesn't exist"
eerror
				die
			fi
			local lld_slot=$(ver_cut 1 $(wasm-ld --version \
					| sed -e "s|LLD ||"))
# The lld slotting is broken.  See https://bugs.gentoo.org/691900
# ldd lld shows that libLLVM-10.so => /usr/lib64/llvm/10/lib64/libLLVM-10.so but
# but slot 10 doesn't have wasm and one of the other >=${LLVM_V} do have it and
# tricking the RDEPENDs.  We need to make sure that =lld-${lld_slot}*
# with =llvm-${lld_slot}*[llvm_targets_WebAssembly].
			if ! has_version "sys-devel/clang:${lld_slot}[llvm_targets_WebAssembly]" \
			|| ! has_version "sys-devel/llvm:${lld_slot}[llvm_targets_WebAssembly]" ; then
eerror
eerror "LLD's corresponding version to Clang and LLVM versions must have"
eerror "llvm_targets_WebAssembly.  Either upgrade LLD to version ${LLVM_SLOT}"
eerror "or rebuild with sys-devel/llvm:${lld_slot}[llvm_targets_WebAssembly] and"
eerror "sys-devel/clang:${lld_slot}[llvm_targets_WebAssembly]"
eerror
				die
			fi
			break
		fi
	done
}

pkg_setup() {
	if use html5 ; then
		pkg_setup_html5
		_set_check_reqs_requirements
		check-reqs_pkg_setup
		check_lld
	fi

	if use native ; then
ewarn
ewarn "The native USE flag has not been developed in the ebuild level and is"
ewarn "not used in GDevelop 5.  Use gdevelop:4 instead."
ewarn
	fi

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
}

_patch() {
	eapply \
"${FILESDIR}/gdevelop-5.0.0_beta97-use-emscripten-envvar-for-webidl_binder_py.patch"
	eapply \
"${FILESDIR}/gdevelop-5.0.0_beta108-unix-make.patch"
}

src_unpack() {
	unpack ${A}
	cd "${S}" || die
	rm -rf ExtLibs/SFML || die
	ln -s "${WORKDIR}/SFML-${SFML_V}" ExtLibs/SFML || die
	cat "${DISTDIR}/${PV}-SFML-mesa-ge-20180525-compat.patch" \
		> ExtLibs/SFML-patches/${PV}-SFML-mesa-ge-20180525-compat.patch \
		|| die
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
#		export EMMAKEN_CFLAGS='-std=gnu++11'
#		export EMCC_CFLAGS='-std=gnu++11'
#		export CC=emcc
#		export CXX=em++
		export CC=gcc
		export CXX=g++
		export NODE_VERSION=${ACTIVE_VERSION}
		export EM_CACHE="${T}/emscripten/cache"
		emconfig_path=$(cat ${EM_CONFIG})
		BINARYEN_LIB_PATH=$(echo \
			-e "${emconfig_path}\nprint (BINARYEN_ROOT)" \
			| python3)"/lib"
		export LD_LIBRARY_PATH="${BINARYEN_LIB_PATH}:${LD_LIBRARY_PATH}"
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
		einfo
		einfo "Compiling GDevelop.js"
		einfo
# In https://github.com/4ian/GDevelop/blob/v5.0.0-beta98/GDevelop.js/Gruntfile.js#L88
		npm run build -- --dev --ninja || die
		if [[ ! \
-f "${S_BAK}/Binaries/embuild/GDevelop.js/libGD.wasm" \
		]] ; then
eerror
eerror "Missing libGD.wasm from ${S_BAK}/Binaries/embuild/GDevelop.js"
eerror
			die
		fi

		if [[ ! \
-f "${S_BAK}/Binaries/embuild/GDevelop.js/libGD.js" \
		]] ; then
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
		eerror
		eerror "Missing GDJS/Runtime"
		eerror
		die
	fi
	if [[ ! -d "Core/GDCore" ]] ; then
		eerror
		eerror "Missing Core/GDCore"
		eerror
		die
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
	sed -i  -e "s|\$(get_libdir)|$(get_libdir)|g" \
		-e "s|\${PN}|${PN}|g" \
		-e "s|\${SLOT_MAJOR}|${SLOT_MAJOR}|g" \
		"${T}/${PN}" || die
	exeinto /usr/bin
	doexe "${T}/${PN}"

	# We just daemonize it.
	cp "${FILESDIR}/${PN}-server-openrc" \
		"${T}/${PN}-server" || die
	sed -i  -e "s|\$(get_libdir)|$(get_libdir)|g" \
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
einfo
einfo "Currently OpenRC is supported.  The init script is called gdevelop-server."
einfo "It must be started before running the gdevelop wrapper."
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
