# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Wayland error:
#16:40:31.141 › GDevelop Electron app starting...
#[1499650:0604/164031.146935:ERROR:ozone_platform_x11.cc(248)] Missing X server or $DISPLAY
#[1499650:0604/164031.146985:ERROR:env.cc(225)] The platform failed to initialize.  Exiting.
#The futex facility returned an unexpected error code.

MY_PN="GDevelop"
MY_PV="${PV//_/-}"

CHECKREQS_DISK_BUILD="2752M"
CHECKREQS_DISK_USR="2736M"
CHECKREQS_MEMORY="8192M"
CMAKE_BUILD_TYPE="Release"
export NPM_INSTALL_PATH="/opt/${PN}/${SLOT_MAJOR}"
#ELECTRON_APP_APPIMAGE="1"
ELECTRON_APP_APPIMAGE_ARCHIVE_NAME="${MY_PN}-${PV%%.*}-${PV}.AppImage"
ELECTRON_APP_ELECTRON_PV="18.2.2" # See \
# https://raw.githubusercontent.com/4ian/GDevelop/v5.3.195/newIDE/electron-app/package-lock.json \
# and \
# strings /var/tmp/portage/dev-games/gdevelop-5.3.195/work/GDevelop-5.3.195/newIDE/electron-app/dist/linux-unpacked/* | grep -E "Chrome/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+"
ELECTRON_APP_REACT_PV="16.14.0" # See \
# The last supported for react 16.14.0 is node 14.0. \
# https://github.com/facebook/react/blob/v16.14.0/package.json#L100 \
# https://raw.githubusercontent.com/4ian/GDevelop/v5.3.195/newIDE/app/package-lock.json
ELECTRON_APP_REACT_PV="ignore" # The lock file says >=0.10.0 but it is wrong.  We force it because CI tests passed.
EMBUILD_DIR="${WORKDIR}/build"
EMSCRIPTEN_PV="3.1.21" # Based on CI.  EMSCRIPTEN_PV == EMSDK_PV
# Emscripten 3.1.21 requires llvm 16 for wasm, 4.1.1 nodejs
LLVM_COMPAT=( 16 ) # Deleted 9 8 7 because asm.js support was dropped.
LLVM_SLOT="${LLVM_COMPAT[0]}"
EMSCRIPTEN_SLOT="${LLVM_SLOT}-${EMSCRIPTEN_PV%.*}"
GDEVELOP_JS_NODEJS_PV="16.20.0" # Based on CI, For building GDevelop.js.
# The CI uses Clang 7.
# Emscripten expects either LLVM 10 for wasm, or LLVM 6 for asm.js.
NODE_ENV="development"
NODE_VERSION="${GDEVELOP_JS_NODEJS_PV%%.*}"
NPM_MULTI_LOCKFILE=1
# Set to partial offline to avoid error:
# npm ERR! request to https://registry.npmjs.org/cors failed: cache mode is 'only-if-cached' but no cached response is available.
NPM_OFFLINE=1 # Completely offline (2) is broken.
# If missing tarball, the misdiagnosed error gets produced:
# tarball data for ... seems to be corrupted. Trying again.
NPM_AUDIT_FIX=0 # 1 -> 0 After we generate the lockfiles, we do a audit fix without --force.  Then, we ship out the fixed lockfiles.
NPM_AUDIT_FIX_ARGS=(
# There is a tradeoff:
# With --force, completely broken, less reported vulerabilities, longer install time.
# Without --force, less bugs and more reported vulnerabilies, resonably shorter install time.
	#"--force"
)
PYTHON_COMPAT=( python3_{10,11} ) # CI uses 3.8, 3.9
UDEV_PV="245.4"

inherit check-reqs desktop electron-app evar_dump flag-o-matic llvm-r1 npm
inherit python-r1 toolchain-funcs xdg

# UPDATER_START_NPM_EXTERNAL_URIS
NPM_EXTERNAL_URIS="
"
# UPDATER_END_NPM_EXTERNAL_URIS
SRC_URI="
$(electron-app_gen_electron_uris)
${NPM_EXTERNAL_URIS}
https://github.com/4ian/${MY_PN}/archive/v${MY_PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${MY_PN}-${MY_PV}"
S_BAK="${WORKDIR}/${MY_PN}-${MY_PV}"

DESCRIPTION="GDevelop is an open-source, cross-platform game engine designed \
to be used by everyone."
HOMEPAGE="
https://gdevelop-app.com/
https://github.com/4ian/GDevelop
"
THIRD_PARTY_LICENSES="
	(
		all-rights-reserved
		Apache-2.0
	)
	(
		all-rights-reserved
		MIT
	)
	0BSD
	all-rights-reserved
	Apache-2.0
	BSD
	BSD-2
	CC-BY-4.0
	custom
	ISC
	MIT
	Unicode-DFS-2016
	W3C
	W3C-Community-Final-Specification-Agreement
	W3C-Document-License
	W3C-Software-and-Document-Notice-and-License-2015
	W3C-Software-Notice-and-License
"
LICENSE="
	${ELECTRON_APP_LICENSES}
	${THIRD_PARTY_LICENSES}
	electron-18.2.2-chromium.html
	MIT
	GDevelop
"

# For ELECTRON_APP_LICENSES, see
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/electron-app.eclass#L67

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

KEYWORDS="~amd64 ~arm64"
SLOT_MAJOR=$(ver_cut 1 ${PV})
SLOT="${SLOT_MAJOR}/${PV}"
IUSE+="
	${LLVM_COMPAT[@]/#/llvm_slot_}
	ebuild-revision-4
"
REQUIRED_USE+="
	!wayland
	${LLVM_COMPAT[@]/#/llvm_slot_}
	${PYTHON_REQUIRED_USE}
	X
"
# Dependency lists:
# https://github.com/4ian/GDevelop/blob/v5.3.195/.circleci/config.yml#L85
# https://github.com/4ian/GDevelop/blob/v5.3.195/.travis.yml
# https://github.com/4ian/GDevelop/blob/v5.3.195/ExtLibs/installDeps.sh
# https://app.travis-ci.com/github/4ian/GDevelop (raw log)
# U 20.04.6 LTS
# Dependencies for the native build are not installed in CI
gen_llvm_depends() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				sys-devel/clang:${s}
				sys-devel/lld:${s}
				sys-devel/llvm:${s}
			)
		"
	done
}
# Some from ExtLibs/installDeps.sh
DEPEND_NOT_USED_IN_CI="
	>=media-libs/freetype-2.10.1
	>=media-libs/glew-2.1.0
	>=media-libs/libsndfile-1.0.28
	>=media-libs/mesa-20.0.4
	>=media-libs/openal-1.19.1
	>=virtual/jpeg-80
	>=x11-apps/xrandr-1.5.2
	virtual/opengl
	virtual/udev
	x11-misc/xdg-utils
"
DEPEND_UDEV_NOT_USED_IN_CI="
	>=sys-fs/eudev-3.1.5
	>=sys-fs/udev-${UDEV_PV}
"
RDEPEND+="
	${PYTHON_DEPS}
	${DEPEND_NOT_USED_IN_CI}
	>=app-arch/p7zip-16.02
	>=net-libs/nodejs-${GDEVELOP_JS_NODEJS_PV}:${GDEVELOP_JS_NODEJS_PV%%.*}
	|| (
		${DEPEND_UDEV_NOT_USED_IN_CI}
		>=sys-apps/systemd-${UDEV_PV}
	)
"
DEPEND+="
	${DEPEND}
"
#
# The package actually uses two nodejs, but the current multislot nodejs
# package cannot switch in the middle of emerge.  From experience, the
# highest nodejs works.
#
# acorn not used in CI
BDEPEND+="
	${PYTHON_DEPS}
	>=dev-build/cmake-3.16.3
	>=dev-vcs/git-2.25.1
	>=media-libs/libicns-0.8.1
	>=net-libs/nodejs-${GDEVELOP_JS_NODEJS_PV}:${GDEVELOP_JS_NODEJS_PV%%.*}[acorn]
	>=net-libs/nodejs-${GDEVELOP_JS_NODEJS_PV}[npm]
	>=sys-devel/gcc-9.3.0
	dev-util/emscripten:${EMSCRIPTEN_SLOT}[wasm(+)]
	$(gen_llvm_depends)
	|| (
		>=media-gfx/graphicsmagick-1.4[png]
		>=media-gfx/imagemagick-6.9.10.23[png]
	)
"
RESTRICT="mirror"

check_network_sandbox() {
	if has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"-network-sandbox\" must be added per-package env to be able"
eerror "to download micropackages."
eerror
		die
	fi
}

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
	if ver_test ${ACTIVE_VERSION%%.*} -ne ${GDEVELOP_JS_NODEJS_PV%%.*} ; then
eerror
eerror "Please switch to Node.js to ${GDEVELOP_JS_NODEJS_PV%%.*}."
eerror
eerror "Try:"
eerror
eerror "  eselect nodejs list"
eerror "  eselect nodejs set node${GDEVELOP_JS_NODEJS_PV%%.*}"
eerror
		die
	fi
}

pkg_setup() {
	pkg_setup_html5
	check-reqs_pkg_setup
	npm_pkg_setup
	python_setup

	# It still breaks when NPM_OFFLINE=1.
	check_network_sandbox

	llvm-r1_pkg_setup

# Addresses:
# FATAL ERROR: Reached heap limit Allocation failed - JavaScript heap out of memory
	export NODE_OPTIONS="--max-old-space-size=8192"

# Addresses:
# Failed to parse source map
# Issue #5270
	export GENERATE_SOURCEMAP=false
}

# @FUNCTION: __npm_src_unpack_default
# @DESCRIPTION:
# Unpacks a npm application.
__npm_src_unpack_default() {
evar_dump "NPM_PROJECT_ROOT" "${NPM_PROJECT_ROOT}"
	local offline="${NPM_OFFLINE:-1}"
	local args=()
	if declare -f npm_unpack_install_pre > /dev/null ; then
		npm_unpack_install_pre
	fi
	local extra_args=()
	local offline="${NPM_OFFLINE:-1}"
	if [[ "${offline}" == "2" ]] ; then
		extra_args+=( "--offline" )
	elif [[ "${offline}" == "1" ]] ; then
		extra_args+=( "--prefer-offline" )
	fi
	enpm install \
		${extra_args[@]} \
		${NPM_INSTALL_ARGS[@]}
	if declare -f npm_unpack_install_post > /dev/null ; then
		npm_unpack_install_post
	fi

	# Audit fix already done with NPM_UPDATE_LOCK=1
}

# @FUNCTION: __npm_src_unpack
# @DESCRIPTION:
# Unpacks a npm application.
__npm_src_unpack() {
	export PATH="${S}/node_modules/.bin:${PATH}"
	if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
		if [[ ${PV} =~ 9999 ]] ; then
			:;
		elif [[ -n "${NPM_TARBALL}" ]] ; then
			unpack ${NPM_TARBALL}
		else
			unpack ${P}.tar.gz
		fi
		cd "${S}" || die
		rm -f package-lock.json

		if declare -f \
			npm_update_lock_install_pre > /dev/null ; then
			npm_update_lock_install_pre
		fi
		enpm install \
			${NPM_INSTALL_ARGS[@]}
		if declare -f \
			npm_update_lock_install_post > /dev/null ; then
			npm_update_lock_install_post
		fi
		if declare -f \
			npm_update_lock_audit_pre > /dev/null ; then
			npm_update_lock_audit_pre
		fi

		# Audit fix is broken because of
		# npm ERR! Invalid Version:
		# in newIDE/app/package*.json
		enpm audit fix \
			${NPM_AUDIT_FIX_ARGS[@]}
		if declare -f \
			npm_update_lock_audit_post > /dev/null ; then
			npm_update_lock_audit_post
		fi
		_npm_check_errors
einfo "Finished lockfile update."
		exit 0
	else
		export ELECTRON_BUILDER_CACHE="${HOME}/.cache/electron-builder"
		export ELECTRON_CACHE="${HOME}/.cache/electron"

		if [[ ${PV} =~ 9999 ]] ; then
			:;
		elif [[ -n "${NPM_TARBALL}" ]] ; then
			unpack ${NPM_TARBALL}
		else
			unpack ${P}.tar.gz
		fi

		local offline="${NPM_OFFLINE:-1}"
		if [[ "${offline}" == "1" || "${offline}" == "2" ]] ; then
			export ELECTRON_SKIP_BINARY_DOWNLOAD=1
			_npm_cp_tarballs

			if [[ -e "${FILESDIR}/${PV}" ]] ; then
				cp -aT "${FILESDIR}/${PV}" "${S}" || die
			fi
		fi

		local lockfiles=(
			"newIDE/app/package-lock.json"			# Required step #2
			"GDevelop.js/package-lock.json"			# Required step #1
			"GDJS/package-lock.json"			# Required step #2a
			"newIDE/electron-app/package-lock.json"		# Required step #3
			"newIDE/electron-app/app/package-lock.json"	# Required step #3a
#			"newIDE/web-app/package-lock.json"
#			"GDJS/tests/package-lock.json"
		)

		local lockfile
		for lockfile in ${lockfiles[@]} ; do
			local dirpath=$(dirname "${S}/${lockfile}")
			NPM_PROJECT_ROOT="${dirpath}"
			pushd "${NPM_PROJECT_ROOT}" >/dev/null 2>&1 || die
				__npm_src_unpack_default
			popd >/dev/null 2>&1 || die
		done
	fi
}

src_unpack() {
einfo "ELECTRON_APP_ELECTRON_PV=${ELECTRON_APP_ELECTRON_PV}"
einfo "EMSCRIPTEN=${EMSCRIPTEN}"
	addpredict "${EMSCRIPTEN}"
	export TEMP_DIR='/tmp'
	export LLVM_ROOT="${EMSDK_LLVM_ROOT}"
	export CLOSURE_COMPILER="${EMSDK_CLOSURE_COMPILER}"
	mkdir -p "${EMBUILD_DIR}" || die
	local em_pv=$(best_version "dev-util/emscripten:${EMSCRIPTEN_SLOT}")
	em_pv=$(echo "${em_pv}" | sed -e "s|dev-util/emscripten-||g")
	em_pv=$(ver_cut 1-3 ${em_pv})
	if ! [[ -e "${EM_CONFIG}" ]] ; then
eerror
eerror "Do:"
eerror
eerror "  eselect emscripten list"
eerror "  eselect emscripten set \"emscripten-${em_pv},llvm-${EMSCRIPTEN_SLOT%-*}\""
eerror "  etc-update"
eerror "  . /etc/profile"
eerror "  export BINARYEN=\"\${EMSDK_BINARYEN_BASE_PATH}\""
eerror "  export CLOSURE_COMPILER=\"\${EMSDK_CLOSURE_COMPILER}\""
eerror "  export LLVM_ROOT=\"\${EMSDK_LLVM_ROOT}\""
eerror
		die
	fi
	cp "${EM_CONFIG}" \
		"${EMBUILD_DIR}/emscripten.config" || die
#	export EMMAKEN_CFLAGS='-std=gnu++11'
#	export EMCC_CFLAGS='-std=gnu++11'
#	if ver_test ${em_pv} -ge 3 ; then
#		export EMCC_CFLAGS=" -stdlib=libc++"
#	fi
	export EMCC_CFLAGS+=" -fno-stack-protector"
        export BINARYEN="${EMSDK_BINARYEN_BASE_PATH}"
	export CC="emcc"
	export CXX="em++"
	strip-unsupported-flags
        export CLOSURE_COMPILER="${EMSDK_CLOSURE_COMPILER}"
	export EM_BINARYEN_ROOT="${BINARYEN}"
	export EM_CACHE="${T}/emscripten/cache"
	export EM_NODE_JS="/usr/bin/node"
	export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}"
        export LLVM_ROOT="${EMSDK_LLVM_ROOT}"
	export NODE_VERSION=${ACTIVE_VERSION}
	export PATH="/usr/$(get_libdir)/node_modules/acorn/bin:${PATH}"
	export NODE_PATH="/usr/$(get_libdir)/node_modules:${NODE_PATH}"

evar_dump "CC" "${CC}"
evar_dump "CXX" "${CXX}"
evar_dump "CFLAGS" "${CFLAGS}"
evar_dump "CXXFLAGS" "${CXXFLAGS}"
evar_dump "LDFLAGS" "${LDFLAGS}"
evar_dump "BINARYEN" "${EMSDK_BINARYEN_BASE_PATH}"
evar_dump "CLOSURE_COMPILER" "${EMSDK_CLOSURE_COMPILER}"
evar_dump "em_pv" "${em_pv}"
evar_dump "EM_BINARYEN_ROOT" "${EM_BINARYEN_ROOT}"
evar_dump "EM_CONFIG" "${EM_CONFIG}"
evar_dump "EM_NODE_JS" "${EM_NODE_JS}"
evar_dump "EMCC_CFLAGS" "${EMCC_CFLAGS}"
evar_dump "LLVM_ROOT" "${EMSDK_LLVM_ROOT}"
evar_dump "NODE_VERSION" "${NODE_VERSION}"
evar_dump "NODE_PATH" "${NODE_PATH}"
evar_dump "PATH" "${PATH}"
einfo "Building ${MY_PN}.js"

	npm_hydrate
	if [[ -n "${NPM_UPDATE_LOCK}" ]] ; then
		if [[ ${PV} =~ 9999 ]] ; then
			:;
		elif [[ -n "${NPM_TARBALL}" ]] ; then
			unpack ${NPM_TARBALL}
		else
			unpack ${P}.tar.gz
		fi

		mkdir -p "${WORKDIR}/lockfile-image" || die

# Reduce version constriants caused by lockfiles.
		rm -vf ${lockfiles[@]}

		local lockfiles=(
			"GDevelop.js/package-lock.json"			# Required step #1
			"newIDE/app/package-lock.json"			# Required step #2
			"GDJS/package-lock.json"			# Required step #2a
			"newIDE/electron-app/package-lock.json"		# Required step #3
			"newIDE/electron-app/app/package-lock.json"	# Required step #3a
			"newIDE/web-app/package-lock.json"		# Optional
			"GDJS/tests/package-lock.json"			# Optional
		)

einfo "Running \`npm install ${NPM_INSTALL_ARGS[@]}\` per each lockfile"
		local lockfile
		for lockfile in ${lockfiles[@]} ; do
			local d="$(dirname ${lockfile})"
			pushd "${S}/${d}" >/dev/null 2>&1 || die
				enpm install \
					${NPM_INSTALL_ARGS[@]}
			popd >/dev/null 2>&1 || die
		done

einfo "Running \`npm audit fix ${NPM_AUDIT_FIX_ARGS[@]}\` per each lockfile"
		if [[ "${NPM_AUDIT_FIX}" == "1" ]] ; then
			for lockfile in ${lockfiles[@]} ; do
				local d="$(dirname ${lockfile})"
				pushd "${S}/${d}" >/dev/null 2>&1 || die
					enpm audit fix \
						${NPM_AUDIT_FIX_ARGS[@]}
				popd >/dev/null 2>&1 || die
			done
		fi

einfo "Saving lockfiles"
		lockfiles_disabled=(
# It is possible to save all the lockfiles but it causes portage to complain
# because too many tarballs.
			$(find . -name "package-lock.json")
		)
		for lockfile in ${lockfiles[@]} ; do
			local d="$(dirname ${lockfile})"
			local dest="${WORKDIR}/lockfile-image/${d}"
			mkdir -p "${dest}"
einfo "Copying ${d}/package.json -> ${dest}"
			cp -a "${S}/${d}/package.json" "${dest}"
einfo "Copying ${d}/package-lock.json -> ${dest}"
			cp -a "${S}/${d}/package-lock.json" "${dest}"
		done

		_npm_check_errors
einfo "Finished updating lockfiles."
		exit 0
	else
		__npm_src_unpack
	fi
	grep -e "Error while copying @electron/remote" "${T}/build.log" && die
}

gen_electron_builder_config() {
	# See https://github.com/4ian/GDevelop/blob/v5.3.198/newIDE/electron-app/electron-builder-config.js
	# https://www.electron.build/configuration/configuration
	if [[ "${ABI}" == "amd64" ]] ; then
cat <<EOF > "${T}/electron-builder-config.txt"
  linux: {
    target: [
      {
        target: 'dir',
        arch: ['x64'],
      },
    ],
  },
EOF
	elif [[ "${ABI}" == "arm64" ]] ; then
cat <<EOF > "${T}/electron-builder-config.txt"
  linux: {
    target: [
      {
        target: 'dir',
        arch: ['arm64'],
      },
    ],
  },
EOF
	else
eerror "ABI=${ABI} is not supported."
		die
	fi
	sed -i \
		-e "/__GDEVELOP_ELECTRON_BUILDER_CONFIG__/r ${T}/electron-builder-config.txt" \
		"newIDE/electron-app/electron-builder-config.js" \
		|| die
	sed -i \
		-e "/__GDEVELOP_ELECTRON_BUILDER_CONFIG__/d" \
		"newIDE/electron-app/electron-builder-config.js" \
		|| die
}

src_prepare() {
	default

	eapply \
"${FILESDIR}/${PN}-5.0.0_beta97-use-emscripten-envvar-for-webidl_binder_py.patch"
	eapply \
"${FILESDIR}/${PN}-5.0.0_beta108-unix-make.patch"
#	eapply \
#"${FILESDIR}/${PN}-5.0.127-fix-cmake-cxx-tests.patch"
	eapply --binary \
"${FILESDIR}/${PN}-5.0.127-SFML-define-linux-00.patch"
	eapply \
"${FILESDIR}/${PN}-5.0.127-SFML-define-linux-01.patch"
	eapply \
"${FILESDIR}/${PN}-5.3.198-electron-builder-placeholder.patch"

	gen_electron_builder_config

	#xdg_src_prepare # calls src_unpack
	# Patches have already have been applied.
	# You need to fork to apply custom changes instead.
	touch "${T}/.portage_user_patches_applied"
	touch "${PORTAGE_BUILDDIR}/.user_patches_applied"
	export _CMAKE_UTILS_SRC_PREPARE_HAS_RUN=1
}

src_configure() { :; }

build_gdevelop_js() {
einfo "Compiling ${MY_PN}.js"
	pushd "${WORKDIR}/${MY_PN}-${MY_PV}/newIDE/app" >/dev/null 2>&1 || die
		enpm install \
			"@lingui/core@2.7.3" \
			${NPM_INSTALL_ARGS[@]}

		# Audit fix already done with NPM_UPDATE_LOCK=1
	popd || die
# In https://github.com/4ian/GDevelop/blob/v5.3.195/GDevelop.js/Gruntfile.js#L88
	pushd "${WORKDIR}/${MY_PN}-${MY_PV}/${MY_PN}.js" >/dev/null 2>&1 || die
		pushd "node_modules/webidl-tools" >/dev/null 2>&1 || die
			enpm install \
				${NPM_INSTALL_ARGS[@]}

			# Audit fix already done with NPM_UPDATE_LOCK=1
		popd || die
		enpm run build -- --force --dev
	popd >/dev/null 2>&1 || die
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
}

build_gdevelop_ide() {
einfo "Building ${MY_PN} IDE"
	pushd "${WORKDIR}/${MY_PN}-${MY_PV}/newIDE/app" >/dev/null 2>&1 || die
		enpm run build
	popd >/dev/null 2>&1 || die
}

build_gdevelop_ide_electron() {
einfo "Building ${MY_PN} $(ver_cut 1 ${PV}) on the Electron runtime"
	local offline="${NPM_OFFLINE:-1}"
	pushd "${WORKDIR}/${MY_PN}-${MY_PV}/newIDE/electron-app" >/dev/null 2>&1 || die
		if [[ "${offline}" == "1" || "${offline}" == "2" ]] ; then
			electron-app_cp_electron
		fi
		enpm run build
	popd >/dev/null 2>&1 || die
}


src_compile() {
	npm_hydrate
	export PATH="${WORKDIR}/${MY_PN}-${MY_PV}/newIDE/app/node_modules/react-scripts/bin:${PATH}"
einfo "PATH:  ${PATH}"
	build_gdevelop_js
	build_gdevelop_ide
	build_gdevelop_ide_electron
	grep -q -e "Failed to compile." "${T}/build.log" && die
	grep -q -e "Error: Cannot find module" "${T}/build.log" && die "Detected error.  Retry." # Offline install bug
	grep -q -e "npm ERR! Invalid Version" "${T}/build.log" && die "Detected error.  Retry." # Indeterministic or random failure bug
	grep -q -e "Failed to compile." "${T}/build.log" && die "Detected error.  Retry."
	grep -q -e "Compiled successfully." "${T}/build.log" || die "Detected error.  Retry."
	grep -q -e "react-scripts: command not found" "${T}/build.log" && die "Detected error.  Retry."
}

src_install() {
	insinto "${NPM_INSTALL_PATH}"
	doins -r newIDE/electron-app/dist/linux-unpacked/*
	electron-app_gen_wrapper \
		"${PN}" \
		"${NPM_INSTALL_PATH}/${PN}"

	#
	# We can't use .ico because of XDG icon standards.  .ico is not
	# interoperable with the Linux desktop.
	#
	pushd "${S}/newIDE/electron-app/build/" >/dev/null 2>&1 || die
		if has_version "media-gfx/graphicsmagick" ; then
			gm convert icon.ico[0] icon-256x256.png
			gm convert icon.ico[1] icon-128x128.png
			gm convert icon.ico[2] icon-64x64.png
			gm convert icon.ico[3] icon-48x48.png
			gm convert icon.ico[4] icon-32x32.png
			gm convert icon.ico[5] icon-16x16.png
		else
			convert icon.ico[0] icon-256x256.png
			convert icon.ico[1] icon-128x128.png
			convert icon.ico[2] icon-64x64.png
			convert icon.ico[3] icon-48x48.png
			convert icon.ico[4] icon-32x32.png
			convert icon.ico[5] icon-16x16.png
		fi
		newicon -s 256 icon-256x256.png ${PN}.png
		newicon -s 128 icon-128x128.png ${PN}.png
		newicon -s 64 icon-64x64.png ${PN}.png
		newicon -s 48 icon-48x48.png ${PN}.png
		newicon -s 32 icon-32x32.png ${PN}.png
		newicon -s 16 icon-16x16.png ${PN}.png
	popd >/dev/null 2>&1 || die
	newicon "newIDE/electron-app/build/icon-256x256.png" "${PN}.png"

	make_desktop_entry \
		"/usr/bin/${PN}" \
		"${MY_PN}" \
		"${PN}.png" \
		"Development;IDE"
	local exe_file_list=(
		"chrome-sandbox"
		"chrome_crashpad_handler"
		"gdevelop"
		"libffmpeg.so"
		"libEGL.so"
		"libGLESv2.so"
		"libvulkan.so.1"
		"libvk_swiftshader.so"
		"swiftshader/libEGL.so"
		"swiftshader/libGLESv2.so"
	)
	local exe_path
	for exe_path in ${exe_file_list[@]} ; do
		fperms +x "${NPM_INSTALL_PATH}/${exe_path}"
	done
}

pkg_postinst() {
	xdg_pkg_postinst
einfo
einfo "Your projects are saved in"
einfo
einfo "  \"\$(xdg-user-dir DOCUMENTS)/${MY_PN} projects\""
einfo
ewarn
ewarn "Games may send anonymous statistics.  See the following commits for"
ewarn "details:"
ewarn
ewarn "  https://github.com/4ian/GDevelop/commit/5d62f0c92655a3d83b8d5763c87d0226594478d1"
ewarn "  https://github.com/4ian/GDevelop/commit/f650a6aa9cf5d123f1e5fe632a2523f2ac2faaaf"
ewarn
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 5.1.162 (20230520)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 5.1.163 (20230525)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 5.1.164 (20230604)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 5.1.185 (20231217) load test only
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 5.1.198 (20240408) platformer prototype only
# wayland:                    failed
# X:                          passed
# command-line wrapper:       passed
# 2D platformer prototyping:  passed
# 3D platformer prototyping:  passed with transparency
