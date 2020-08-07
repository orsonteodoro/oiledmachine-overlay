# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="GDevelop is an open-source, cross-platform game engine designed \
to be used by everyone."
HOMEPAGE="https://gdevelop-app.com/"
LICENSE="MIT GDevelop"
KEYWORDS="~amd64"
SLOT_MAJOR=$(ver_cut 1 ${PV})
SLOT="${SLOT_MAJOR}/${PV}"
IUSE="doc electron +extensions +html5 kdialog minimal native web-browser zenity"
REQUIRED_USE="^^ ( html5 native )
	|| ( kdialog zenity )
	|| ( electron web-browser )"
#See https://github.com/4ian/GDevelop/blob/master/ExtLibs/installDeps.sh
RDEPEND="${RDEPEND}
	native? (
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
	kdialog? ( kde-apps/kdialog )
	zenity? ( gnome-extra/zenity )
	web-browser? ( x11-misc/xdg-utils )
	virtual/opengl
"
# For the required emscripten version, \
# see https://github.com/4ian/GDevelop/blob/v5.0.0-beta98/.circleci/config.yml
# See also electron-app_src_compile about the wasm (llvm) vs asmjs (emscripten-fastcomp) requirement.
DEPEND="${RDEPEND}
	html5? (
		>=dev-util/emscripten-1.39.6[wasm]
		<net-libs/nodejs-14[npm]
	)
	dev-vcs/git"
ELECTRON_APP_ELECTRON_V="8.2.5"
ELECTRON_APP_REACT_V="16.8.6"
inherit cmake-utils desktop electron-app eutils
MY_PN="GDevelop"
MY_PV="${PV//_/-}"
SFML_V="2.4.1"
SRC_URI=\
"https://github.com/4ian/GDevelop/archive/v${MY_PV}.tar.gz \
	-> ${P}.tar.gz
https://github.com/SFML/SFML/commit/87aaa9e145659d6a8fc193ab8540cf847d4d0def.patch \
	-> ${PV}-SFML-mesa-ge-20180525-compat.patch
https://github.com/SFML/SFML/archive/${SFML_V}.tar.gz \
	-> SFML-${SFML_V}.tar.gz
"
S="${WORKDIR}/${MY_PN}-${MY_PV}"
RESTRICT="mirror"
CMAKE_BUILD_TYPE=Release
EMBUILD_DIR="${WORKDIR}/build"

pkg_setup() {
	ewarn "This package is a Work In Progress (WIP) and will not work because of a broken dependency toolchain."
	ewarn "TODO: add new group call gdevelop for server."
	electron-app_pkg_setup
	if use html5 ; then
		if [[ -z "${EM_CONFIG}" ]] ; then
			die \
"EM_CONFIG is empty.  Did you install the emscripten package?"
		fi
		if [[ -z "${EMSCRIPTEN}" ]] ; then
			die "EMSCRIPTEN is empty.  Did you install the emscripten package?"
			if [[ ! -d "${EMSCRIPTEN}" ]] ; then
				die \
"EMSCRIPTEN should point to a directory.  Your emscripten package is broken.\n\
Use the one from oiledmachine-overlay."
			fi
		fi
	fi
	export ACTIVE_VERSION=$(grep -r -e "#define NODE_MAJOR_VERSION" \
        "${EROOT}/usr/include/node/node_version.h" | cut -f 3 -d " ")
	if ver_test "${ACTIVE_VERSION}" -ge 14 ; then
		die \
"Node.js 14 is not supported.  You must run \`eselect nodejs set node12\` or\n\
less.  Those versions are only supported"
	fi
}

_patch() {
	eapply "${FILESDIR}/gdevelop-5.0.0_beta97-patch-sfml-if-downloaded.patch"
	eapply "${FILESDIR}/gdevelop-5.0.0_beta97-use-emscripten-envvar-for-webidl_binder_py.patch"
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

src_install() {
	if use native ; then
		cmake-utils_src_install
	fi
}

electron-app_src_compile() {
	if [[ "${STEP}" == "BUILDING_GDEVELOPJS" ]] ; then
		einfo "Compiling GDevelop.js"
		# --dev requires emscripten[wasm]
		# not --dev requires emscripten[asmjs]
		npm run build -- --dev || die
	elif [[ "${STEP}" == "BUILDING_GDEVELOP_IDE" ]] ; then
		einfo "Compiling app"
		#PATH="${S}/node_modules/.bin:${PATH}" \
		S="${WORKDIR}/${MY_PN}-${MY_PV}/newIDE/app" \
		electron-app_src_compile_default
	elif [[ "${STEP}" == "BUILDING_GDEVELOP_IDE_ELECTRON" ]] ; then
		einfo "Compiling app"
		#PATH="${S}/node_modules/.bin:${PATH}" \
		S="${WORKDIR}/${MY_PN}-${MY_PV}/newIDE/electron-app" \
		electron-app_src_compile_default
	fi
}

src_install() {
	eapply "${FILESDIR}/gdevelop-5.0.0_beta97-wrapper-file-signal.patch"
	export ELECTRON_APP_INSTALL_PATH="/usr/$(get_libdir)/node/${PN}/${SLOT_MAJOR}"

	if ! use electron ; then
		rm -rf "${ED}/${ELECTRON_APP_INSTALL_PATH}/electron-app"
	#else
	#keep Binaries, GDJS/Binaries, scripts, Core/GDCore, Extensions
	#keep GDJS/Runtime
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
	MY_PN="${MY_PN} "$(ver_cut 1 ${PV}) \
	electron-app_desktop_install "*" "newIDE/electron-app/build/icon.ico" "${MY_PN}" \
	"Development;IDE" "/usr/bin/gdevelop"
	npm-utils_install_readmes
	npm-utils_install_licenses
	# Dedupe.  The newIDE folder has already been copied but not the parent
	rm -rf "${ED}"/usr/share/doc/${PF}/{licenses,readmes}/newIDE || die
	# False positive
	rm -rf $(find "${ED}/usr/share/" -name "docNoticeRole.js*") || die

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
}

pkg_postinst() {
	electron-app_pkg_postinst
	einfo "You must start the daemon process from /etc/init.d/gdevelop-server"
}
