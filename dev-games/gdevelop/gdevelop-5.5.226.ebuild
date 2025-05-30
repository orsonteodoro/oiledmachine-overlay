# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Wayland error:
#16:40:31.141 › GDevelop Electron app starting...
#[1499650:0604/164031.146935:ERROR:ozone_platform_x11.cc(248)] Missing X server or $DISPLAY
#[1499650:0604/164031.146985:ERROR:env.cc(225)] The platform failed to initialize.  Exiting.
#The futex facility returned an unexpected error code.

# For supported electron version see:
# https://www.electronjs.org/docs/latest/tutorial/electron-timelines
# For latest for the milestone see:
# https://github.com/electron/electron/tags
# For the corresponding chromium version see:
# https://github.com/electron/electron/blob/v22.3.25/DEPS#L5C6-L5C15

MY_PN="GDevelop"
MY_PV="${PV//_/-}"

CR_LATEST_STABLE="132.0.6834.83"
CR_LATEST_STABLE_DATE="Jan 14, 2025"
CR_ELECTRON="108.0.5359.215"
CR_ELECTRON_DATE="Jan 23, 2023"

CHECKREQS_DISK_BUILD="2752M"
CHECKREQS_DISK_USR="2736M"
CHECKREQS_MEMORY="8192M"
CMAKE_BUILD_TYPE="Release"
export NPM_INSTALL_PATH="/opt/${PN}/${SLOT_MAJOR}"
#ELECTRON_APP_APPIMAGE="1"
ELECTRON_APP_APPIMAGE_ARCHIVE_NAME="${MY_PN}-${PV%%.*}-${PV}.AppImage"
_ELECTRON_DEP_ROUTE="secure" # reproducible or secure
if [[ "${_ELECTRON_DEP_ROUTE}" == "secure" ]] ; then
	# Ebuild maintainer preference
	#ELECTRON_APP_ELECTRON_PV="31.1.0" # Chromium 126.0.6478.114, node 20.14.0 ; Runtime breakage
	ELECTRON_APP_ELECTRON_PV="22.3.27" # Chromium 108.0.5359.215, node 16.17.1 ; It works.
else
	# Upstream preference
	ELECTRON_APP_ELECTRON_PV="18.2.2" # Chromium 100.0.4896.143, node 16.13.2 ; It works.
fi
# For ELECTRON_APP_ELECTRON_PV, see \
# https://github.com/4ian/GDevelop/blob/v5.5.226/newIDE/electron-app/package-lock.json#L1440 \
# and \
# strings /var/tmp/portage/dev-games/gdevelop-5.5.226/work/GDevelop-5.5.226/newIDE/electron-app/dist/linux-unpacked/* | grep -E "Chrome/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+"
ELECTRON_APP_REACT_PV="16.14.0" #  \
# The last supported for react 16.14.0 is node 14.0. \
# https://github.com/facebook/react/blob/v16.14.0/package.json#L100 \
# https://github.com/4ian/GDevelop/blob/v5.5.226/newIDE/app/package-lock.json#L27009
ELECTRON_APP_REACT_PV="ignore" # The lock file says >=0.10.0 but it is wrong.  We force it because CI tests passed.
EMBUILD_DIR="${WORKDIR}/build"
EMSCRIPTEN_PV="1.39.20"
# Emscripten 3.1.21 requires llvm 16 for wasm, 4.1.1 nodejs
FLAG_O_MATIC_STRIP_UNSUPPORTED_FLAGS=1
# For LLVM_COMPAT; 9, 8, and 7 was deleted because asm.js support was dropped.
#LLVM_COMPAT=( 16 ) # For Emscripten 3.1.30.
LLVM_COMPAT=( 14 ) # For Emscripten 1.39.20.
LLVM_SLOT="${LLVM_COMPAT[0]}"
EMSCRIPTEN_SLOT="${LLVM_SLOT}-${EMSCRIPTEN_PV%.*}"
GDEVELOP_JS_NODEJS_PV="16.20.0" # Based on CI, For building GDevelop.js.
# The CI uses Clang 7.
# Emscripten expects either LLVM 10 for wasm, or LLVM 6 for asm.js.
NODE_ENV="development"
NODE_VERSION="${GDEVELOP_JS_NODEJS_PV%%.*}"
NPM_DEDUPE=1
NPM_MULTI_LOCKFILE=1
# Set to partial offline to avoid error:
# npm ERR! request to https://registry.npmjs.org/cors failed: cache mode is 'only-if-cached' but no cached response is available.
NPM_OFFLINE=1 # Completely offline (2) is broken.
# If missing tarball, the misdiagnosed error gets produced:
# tarball data for ... seems to be corrupted. Trying again.
NPM_AUDIT_FIX=0 # Audit fix is broken.  Triage conditionally.
NPM_AUDIT_FIX_ARGS=(
	"--legacy-peer-deps"
	"--prefer-offline"
)
NPM_DEDUPE_ARGS=(
	"--legacy-peer-deps"
)
NPM_INSTALL_ARGS=(
	"--legacy-peer-deps"
	"--prefer-offline"
)
NPM_UNINSTALL_ARGS=(
	"--legacy-peer-deps"
	"--prefer-offline"
)
PYTHON_COMPAT=( python3_{10,11} ) # CI uses 3.8, 3.9
RUST_MAX_VER="1.71.1" # Inclusive
RUST_MIN_VER="1.71.1" # rust 1.70.0, llvm 16.0, required by @swc/core.  Distro does not have 1.70.0 so rust bumped to 1.71.1 with the same corresponding llvm slot.
RUST_PV="${RUST_MIN_VER}"

# Using yarn results in failures.
inherit check-reqs desktop electron-app evar_dump flag-o-matic llvm npm
inherit python-r1 rust toolchain-funcs xdg

SRC_URI="
$(electron-app_gen_electron_uris)
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
	electron-22.3.25-chromium.html
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

KEYWORDS="~amd64"
SLOT_MAJOR=$(ver_cut 1 ${PV})
SLOT="${SLOT_MAJOR}/${PV}"
IUSE+="
	${LLVM_COMPAT[@]/#/llvm_slot_}
	-analytics
	ebuild_revision_11
"
REQUIRED_USE+="
	!wayland
	${LLVM_COMPAT[@]/#/llvm_slot_}
	${PYTHON_REQUIRED_USE}
	X
"
# Dependency lists:
# https://github.com/4ian/GDevelop/blob/v5.5.226/.circleci/config.yml#L85
# https://github.com/4ian/GDevelop/blob/v5.5.226/.travis.yml
# https://github.com/4ian/GDevelop/blob/v5.5.226/ExtLibs/installDeps.sh
# https://app.travis-ci.com/github/4ian/GDevelop (raw log)
# U 20.04.6 LTS
# Dependencies for the native build are not installed in CI
gen_llvm_depends() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				llvm-core/clang:${s}
				llvm-core/lld:${s}
				llvm-core/llvm:${s}
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
	x11-misc/xdg-utils
"
RDEPEND+="
	${PYTHON_DEPS}
	${DEPEND_NOT_USED_IN_CI}
	>=app-arch/p7zip-16.02
	>=net-libs/nodejs-${GDEVELOP_JS_NODEJS_PV}:${GDEVELOP_JS_NODEJS_PV%%.*}[webassembly(+)]
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
	|| (
		dev-lang/rust:${RUST_PV}
		dev-lang/rust-bin:${RUST_PV}
	)
"
RESTRICT="mirror"

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
	# Reduce download times
	local EDISTDIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	export NPM_CACHE_FOLDER="${EDISTDIR}/npm-download-cache-${NPM_SLOT}/${CATEGORY}/${PN}"

	pkg_setup_html5
	check-reqs_pkg_setup
	npm_pkg_setup
	python_setup

	llvm_pkg_setup

	rust_pkg_setup
	if has_version "dev-lang/rust-bin:${RUST_PV}" ; then
		rust_prepend_path "${RUST_PV}" "binary"
	elif has_version "dev-lang/rust:${RUST_PV}" ; then
		rust_prepend_path "${RUST_PV}" "source"
	fi

# Addresses:
# FATAL ERROR: Reached heap limit Allocation failed - JavaScript heap out of memory
	export NODE_OPTIONS="--max-old-space-size=8192"

# Addresses:
# Failed to parse source map
# Issue #5270
	export GENERATE_SOURCEMAP=false
}

# @FUNCTION: __src_unpack_one_lockfile
# @DESCRIPTION:
# Unpacks a single lockfile.
__src_unpack_one_lockfile() {
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

npm_unpack_post() {
einfo "Copying custom patches"
	mkdir -p "${S}/newIDE/app/patches" || die
	cp -a "${FILESDIR}/storybook-core-server-7.4.6.patch" "${S}/newIDE/app/patches/@storybook+core-server+7.4.6.patch" || die
}

# @FUNCTION: __src_unpack_all_production
# @DESCRIPTION:
# Unpacks a npm application.
__src_unpack_all_production() {
	local offline="${NPM_OFFLINE:-1}"
	export PATH="${S}/node_modules/.bin:${PATH}"
	export ELECTRON_BUILDER_CACHE="${HOME}/.cache/electron-builder"
	export ELECTRON_CACHE="${HOME}/.cache/electron"

	if [[ "${PV}" =~ "9999" ]] ; then
		:
	elif [[ -n "${NPM_TARBALL}" ]] ; then
		unpack "${NPM_TARBALL}"
	else
		unpack "${P}.tar.gz"
	fi

	if declare -f npm_unpack_post >/dev/null 2>&1 ; then
		npm_unpack_post
	fi

	if [[ "${offline}" == "1" || "${offline}" == "2" ]] ; then
		export ELECTRON_SKIP_BINARY_DOWNLOAD=1
		_npm_setup_offline_cache
		if [[ -e "${FILESDIR}/${PV}" ]] ; then
			cp -aT "${FILESDIR}/${PV}" "${S}" || die
		fi
	fi

	local lockfiles=(
		"newIDE/app/package-lock.json"			# Required step #2		# yarn import does not work.
		"GDevelop.js/package-lock.json"			# Required step #1		# yarn import does not work.
		"GDJS/package-lock.json"			# Required step #2_postinstall
		"newIDE/electron-app/package-lock.json"		# Required step #3
		"newIDE/electron-app/app/package-lock.json"	# Required step #3_postinstall
#		"newIDE/web-app/package-lock.json"
#		"GDJS/tests/package-lock.json"
	)

	local lockfile
	for lockfile in ${lockfiles[@]} ; do
		local dirpath=$(dirname "${S}/${lockfile}")
		NPM_PROJECT_ROOT="${dirpath}"
		pushd "${NPM_PROJECT_ROOT}" >/dev/null 2>&1 || die
			__src_unpack_one_lockfile
		popd >/dev/null 2>&1 || die
	done
}

_dedupe_lockfiles() {
	if [[ "${NPM_DEDUPE}" != "1" ]] ; then
		return
	fi
einfo "Running \`npm dedupe ${NPM_DEDUPE_ARGS[@]}\` per each lockfile"
	local lockfile
	for lockfile in ${lockfiles[@]} ; do
		local d="$(dirname ${lockfile})"
		pushd "${S}/${d}" >/dev/null 2>&1 || die
			enpm dedupe ${NPM_DEDUPE_ARGS[@]}
		popd >/dev/null 2>&1 || die
	done
}

# Currently broken
_gen_lockfiles() {
	rm -vf ${lockfiles[@]}
einfo "Running \`npm install ${NPM_INSTALL_ARGS[@]}\` per each lockfile"
	local lockfile
	for lockfile in ${lockfiles[@]} ; do
		local d="$(dirname ${lockfile})"
		pushd "${S}/${d}" >/dev/null 2>&1 || die
			enpm install ${NPM_INSTALL_ARGS[@]}
		popd >/dev/null 2>&1 || die
	done
einfo "Running \`npm audit fix ${NPM_AUDIT_FIX_ARGS[@]}\` per each lockfile"
	if [[ "${NPM_DEDUPE}" == "1" ]] ; then
einfo "Running \`npm dedupe ${NPM_DEDUPE_ARGS[@]}\` per each lockfile"
	fi
	local lockfile
	for lockfile in ${lockfiles[@]} ; do
		local d="$(dirname ${lockfile})"
		pushd "${S}/${d}" >/dev/null 2>&1 || die
			enpm audit fix ${NPM_AUDIT_FIX_ARGS[@]}
			if [[ "${NPM_DEDUPE}" == "1" ]] ; then
				enpm dedupe ${NPM_DEDUPE_ARGS[@]}
			fi
		popd >/dev/null 2>&1 || die
	done
}

_save_lockfiles() {
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
eerror "  export EM_BINARYEN_ROOT=\"\${EMSDK_BINARYEN_BASE_PATH}\""
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
	export CPP="${CC} -E"
	strip-unsupported-flags
        export CLOSURE_COMPILER="${EMSDK_CLOSURE_COMPILER}"
        export EM_BINARYEN_ROOT="${EMSDK_BINARYEN_BASE_PATH}"
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
	local offline="${NPM_OFFLINE:-1}"
	if [[ -n "${NPM_UPDATE_LOCK}" ]] ; then
		if [[ "${PV}" =~ "9999" ]] ; then
			:
		elif [[ -n "${NPM_TARBALL}" ]] ; then
			unpack "${NPM_TARBALL}"
		else
			unpack "${P}.tar.gz"
		fi

		if declare -f npm_unpack_post >/dev/null 2>&1 ; then
			npm_unpack_post
		fi

		if [[ "${offline}" == "1" || "${offline}" == "2" ]] ; then
			_npm_setup_offline_cache
		fi

		mkdir -p "${WORKDIR}/lockfile-image" || die

		local lockfiles=(
			"GDevelop.js/package-lock.json"			# Required step #1		# yarn import does not work.
			"newIDE/app/package-lock.json"			# Required step #2		# yarn import does not work.
			"GDJS/package-lock.json"			# Required step #2_postinstall
			"newIDE/electron-app/package-lock.json"		# Required step #3
			"newIDE/electron-app/app/package-lock.json"	# Required step #3_postinstall
#			"newIDE/web-app/package-lock.json"		# Optional
#			"GDJS/tests/package-lock.json"			# Optional
		)

		local pkgs

		# Add deps before audit:
		pushd "${S}/newIDE/app" || die
			pkgs=(
				"@lingui/core@2.7.3"
			)
			enpm install ${pkgs[@]} -P ${NPM_INSTALL_ARGS[@]}
		popd || die

		if [[ "${NPM_AUDIT_FIX}" == 0 ]] ; then
einfo "Fixing vulnerabilities"
			patch_edits() {
	# 4ian/webidl-tools (vendored) -> cheerio -> requests (CVE-2023-28155; DT, ID; Medium).  It can't be bumped because Node 16 is a hard dependency.  Node 16 is EOL.
ewarn "QA:  ip must be manually removed in ${S}/newIDE/app/package-lock.json"
ewarn "QA:  node_modules/cheerio/node_modules/tough-cookie must be manually removed in ${S}/GDevelop.js/package-lock.json."
ewarn "QA:  node_modules/micromatch/node_modules/braces must be manually removed in ${S}/GDevelop.js/package-lock.json."
				pushd "${S}/GDevelop.js" || die
					sed -i -e "s|\"bl\": \"^1.0.0\"|\"bl\": \"^1.0.0\"|g" "package-lock.json" || die
					sed -i -e "s|\"braces\": \"^1.8.2\"|\"braces\": \"^3.0.3\"|g" "package-lock.json" || die
					sed -i -e "s|\"ejs\": \"^2.4.1\"|\"ejs\": \"^3.1.10\"|g" "package-lock.json" || die
					sed -i -e "s|\"getobject\": \"~0.1.0\"|\"getobject\": \"~1.0.0\"|g" "package-lock.json" || die
					sed -i -e "s|\"js-yaml\": \"~3.5.2\"|\"js-yaml\": \"~3.13.1\"|g" "package-lock.json" || die
					sed -i -e "s|\"jsdom\": \"^16.5.0\"|\"jsdom\": \"^16.6.0\"|g" "package-lock.json" || die
					sed -i -e "s|\"json-schema\": \"0.2.3\"|\"json-schema\": \"^0.4.0\"|g" "package-lock.json" || die
					sed -i -e "s|\"lodash\": \"~1.3.1\"|\"lodash\": \"~4.17.21\"|g" "package-lock.json" || die
					sed -i -e "s|\"lodash\": \"~3.10.1\"|\"lodash\": \"~4.17.21\"|g" "package-lock.json" || die
					sed -i -e "s|\"lodash\": \"~4.3.0\"|\"lodash\": \"~4.17.21\"|g" "package-lock.json" || die
					sed -i -e "s|\"lodash\": \"^4.1.0\"|\"lodash\": \"^4.17.21\"|g" "package-lock.json" || die
					sed -i -e "s|\"lodash\": \"^4.7.0\"|\"lodash\": \"^4.17.21\"|g" "package-lock.json" || die
					sed -i -e "s|\"lodash\": \"^4.8.0\"|\"lodash\": \"^4.17.21\"|g" "package-lock.json" || die
					sed -i -e "s|\"lodash\": \"~4.17.12\"|\"lodash\": \"~4.17.21\"|g" "package-lock.json" || die
					sed -i -e "s|\"tar\": \"^2.0.0\"|\"tar\": \"^4.4.18\"|g" "package-lock.json" || die
					sed -i -e "s|\"tough-cookie\": \"^2.2.0\"|\"tough-cookie\": \"^4.1.3\"|g" "package-lock.json" || die
					sed -i -e "s|\"tough-cookie\": \"^2.3.3\"|\"tough-cookie\": \"^4.1.3\"|g" "package-lock.json" || die
					sed -i -e "s|\"tough-cookie\": \"~2.5.0\"|\"tough-cookie\": \"^4.1.3\"|g" "package-lock.json" || die
					sed -i -e "s|\"tough-cookie\": \"^4.0.0\"|\"tough-cookie\": \"^4.1.3\"|g" "package-lock.json" || die
				popd || die

	# storybook (7.4.6) -> @storybook/core-server (7.4.6) -> ip (CVE-2024-29415; DoS, DT, ID; High).  The fix relies on bumping storybook to >= 8.1.6 which is Node >= 18.  Node 16 is a hard dependency.
				pushd "${S}/newIDE/app" || die
					sed -i -e "s|\"@grpc/grpc-js\": \"^1.0.0\"|\"@grpc/grpc-js\": \"^1.8.22\"|g" "package-lock.json" || die
					sed -i -e "s|\"axios\": \"^0.21.2\"|\"axios\": \"^1.8.2\"|g" "package-lock.json" || die
					sed -i -e "s|\"axios\": \"^0.28.0\"|\"axios\": \"^1.8.2\"|g" "package-lock.json" || die
					sed -i -e "s|\"axios\": \">= 0.17.0\"|\"axios\": \"^1.8.2\"|g" "package-lock.json" || die
					sed -i -e "s|\"cookie\": \"0.6.0\"|\"cookie\": \"0.7.0\"|g" "package-lock.json" || die
					sed -i -e "s|\"body-parser\": \"1.20.2\"|\"body-parser\": \"1.20.3\"|g" "package-lock.json" || die
					sed -i -e "s|\"d3-color\": \"1 - 2\"|\"d3-color\": \"^3.1.0\"|g" "package-lock.json" || die
					sed -i -e "s|\"esbuild\": \"^0.18.0\"|\"esbuild\": \"^0.25.0\"|g" "package-lock.json" || die
					sed -i -e "s|\"esbuild\": \">=0.10.0\"|\"esbuild\": \"^0.25.0\"|g" "package-lock.json" || die
					sed -i -e "s|\"esbuild\": \">=0.12 <1\"|\"esbuild\": \"^0.25.0\"|g" "package-lock.json" || die
					sed -i -e "s|\"express\": \"^4.17.3\"|\"express\": \"^4.20.0\"|g" "package-lock.json" || die
					sed -i -e "s|\"firebase\": \"9.0.0-beta.2\"|\"firebase\": \"^10.9.0\"|g" "package-lock.json" || die
					sed -i -e "s|\"follow-redirects\": \"^1.0.0\"|\"follow-redirects\": \"^1.15.6\"|g" "package-lock.json" || die
					sed -i -e "s|\"follow-redirects\": \"^1.14.0\"|\"follow-redirects\": \"^1.15.6\"|g" "package-lock.json" || die
					sed -i -e "s|\"follow-redirects\": \"^1.14.7\"|\"follow-redirects\": \"^1.15.6\"|g" "package-lock.json" || die
					sed -i -e "s|\"jsdom\": \"^16.5.0\"|\"jsdom\": \"^16.6.0\"|g" "package-lock.json" || die
					sed -i -e "s|\"markdown-to-jsx\": \"^7.1.8\"|\"markdown-to-jsx\": \"^7.4.0\"|g" "package-lock.json" || die
					sed -i -e "s|\"minimist\": \"0.0.8\"|\"minimist\": \"0.2.4\"|g" "package-lock.json" || die
					sed -i -e "s|\"node-fetch\": \"^1.0.1\"|\"node-fetch\": \"^2.6.7\"|g" "package-lock.json" || die
					sed -i -e "s|\"node-fetch\": \"^2.0.0\"|\"node-fetch\": \"^2.6.7\"|g" "package-lock.json" || die
					sed -i -e "s|\"node-fetch\": \"2.6.1\"|\"node-fetch\": \"^2.6.7\"|g" "package-lock.json" || die
					sed -i -e "s#\"postcss\": \"^7.0.0 || ^8.0.1\"#\"postcss\": \"^8.4.31\"#g" "package-lock.json" || die
					sed -i -e "s|\"postcss\": \"^7.0.35\"|\"postcss\": \"^8.4.31\"|g" "package-lock.json" || die
					sed -i -e "s|\"postcss\": \"^8.0.0\"|\"postcss\": \"^8.4.31\"|g" "package-lock.json" || die
					sed -i -e "s|\"postcss\": \"^8.0.3\"|\"postcss\": \"^8.4.31\"|g" "package-lock.json" || die
					sed -i -e "s|\"postcss\": \">=8.0.9\"|\"postcss\": \"^8.4.31\"|g" "package-lock.json" || die
					sed -i -e "s|\"postcss\": \"^8.1.0\"|\"postcss\": \"^8.4.31\"|g" "package-lock.json" || die
					sed -i -e "s|\"postcss\": \"^8.1.4\"|\"postcss\": \"^8.4.31\"|g" "package-lock.json" || die
					sed -i -e "s|\"postcss\": \"^8.2\"|\"postcss\": \"^8.4.31\"|g" "package-lock.json" || die
					sed -i -e "s|\"postcss\": \"^8.2.2\"|\"postcss\": \"^8.4.31\"|g" "package-lock.json" || die
					sed -i -e "s|\"postcss\": \"^8.2.14\"|\"postcss\": \"^8.4.31\"|g" "package-lock.json" || die
					sed -i -e "s|\"postcss\": \"^8.2.15\"|\"postcss\": \"^8.4.31\"|g" "package-lock.json" || die
					sed -i -e "s|\"postcss\": \"^8.3\"|\"postcss\": \"^8.4.31\"|g" "package-lock.json" || die
					sed -i -e "s#\"rollup\": \"^1.20.0 || ^2.0.0\"#\"rollup\": \"^2.79.2\"#g" "package-lock.json" || die
					sed -i -e "s#\"rollup\": \"^1.20.0||^2.0.0\"#\"rollup\": \"^2.79.2\"#g" "package-lock.json" || die
					sed -i -e "s#\"rollup\": \"^2.0.0||^3.0.0||^4.0.0\"#\"rollup\": \"^2.79.2\"#g" "package-lock.json" || die
					sed -i -e "s|\"rollup\": \"^2.43.1\"|\"rollup\": \"^2.79.2\"|g" "package-lock.json" || die
					sed -i -e "s#\"rollup\": \"^2.78.0||^3.0.0||^4.0.0\"#\"rollup\": \"^2.79.2\"#g" "package-lock.json" || die
					sed -i -e "s#\"semver\": \"2 || 3 || 4 || 5\"#\"semver\": \"^7.5.2\"#g" "package-lock.json" || die
					sed -i -e "s|\"semver\": \"^5.1.0\"|\"semver\": \"^7.5.2\"|g" "package-lock.json" || die
					sed -i -e "s|\"semver\": \"^5.5.0\"|\"semver\": \"^7.5.2\"|g" "package-lock.json" || die
					sed -i -e "s|\"semver\": \"^5.6.0\"|\"semver\": \"^7.5.2\"|g" "package-lock.json" || die
					sed -i -e "s|\"semver\": \"^6.0.0\"|\"semver\": \"^7.5.2\"|g" "package-lock.json" || die
					sed -i -e "s|\"semver\": \"^6.1.1\"|\"semver\": \"^7.5.2\"|g" "package-lock.json" || die
					sed -i -e "s|\"semver\": \"^6.1.2\"|\"semver\": \"^7.5.2\"|g" "package-lock.json" || die
					sed -i -e "s|\"semver\": \"^6.3.0\"|\"semver\": \"^7.5.2\"|g" "package-lock.json" || die
					sed -i -e "s|\"semver\": \"^6.3.1\"|\"semver\": \"^7.5.2\"|g" "package-lock.json" || die
					sed -i -e "s|\"semver\": \"7.0.0\"|\"semver\": \"^7.5.2\"|g" "package-lock.json" || die
					sed -i -e "s|\"semver\": \"^7.3.2\"|\"semver\": \"^7.5.2\"|g" "package-lock.json" || die
					sed -i -e "s|\"semver\": \"^7.3.5\"|\"semver\": \"^7.5.2\"|g" "package-lock.json" || die
					sed -i -e "s|\"semver\": \"^7.3.7\"|\"semver\": \"^7.5.2\"|g" "package-lock.json" || die
					sed -i -e "s|\"semver\": \"^7.3.8\"|\"semver\": \"^7.5.2\"|g" "package-lock.json" || die
					sed -i -e "s|\"send\": \"0.18.0\"|\"send\": \"0.19.0\"|g" "package-lock.json" || die
					sed -i -e "s|\"serve-static\": \"1.15.0\"|\"serve-static\": \"1.16.0\"|g" "package-lock.json" || die
					sed -i -e "s|\"store2\": \"^2.14.2\"|\"store2\": \"^2.14.4\"|g" "package-lock.json" || die
					sed -i -e "s|\"undici\": \"5.28.3\"|\"undici\": \"5.28.5\"|g" "package-lock.json" || die
					sed -i -e "s|\"webpack\": \">=4.43.0 <6.0.0\"|\"webpack\": \"^5.94.0\"|g" "package-lock.json" || die
					sed -i -e "s#\"webpack\": \"^4.0.0 || ^5.0.0\"#\"webpack\": \"^5.94.0\"#g" "package-lock.json" || die
					sed -i -e "s#\"webpack\": \"^4.4.0 || ^5.91.0\"#\"webpack\": \"^5.94.0\"#g" "package-lock.json" || die
					sed -i -e "s#\"webpack\": \"^4.44.2 || ^5.47.0\"#\"webpack\": \"^5.94.0\"#g" "package-lock.json" || die
					sed -i -e "s#\"webpack\": \"^4.37.0 || ^5.0.0\"#\"webpack\": \"^5.94.0\"#g" "package-lock.json" || die
					sed -i -e "s|\"webpack\": \"^5.0.0\"|\"webpack\": \"^5.94.0\"|g" "package-lock.json" || die
					sed -i -e "s|\"webpack\": \"^5.1.0\"|\"webpack\": \"^5.94.0\"|g" "package-lock.json" || die
					sed -i -e "s|\"webpack\": \"^5.11.0\"|\"webpack\": \"^5.94.0\"|g" "package-lock.json" || die
					sed -i -e "s|\"webpack\": \"^5.20.0\"|\"webpack\": \"^5.94.0\"|g" "package-lock.json" || die
					sed -i -e "s|\"webpack\": \"^5.64.4\"|\"webpack\": \"^5.94.0\"|g" "package-lock.json" || die
					sed -i -e "s|\"webpack\": \">=2\"|\"webpack\": \"^5.94.0\"|g" "package-lock.json" || die
					sed -i -e "s|\"webpack\": \">=5\"|\"webpack\": \"^5.94.0\"|g" "package-lock.json" || die
					sed -i -e "s|\"webpack\": \">= 4\"|\"webpack\": \"^5.94.0\"|g" "package-lock.json" || die
					sed -i -e "s|\"webpack\": \">=4.43.0 <6.0.0\"|\"webpack\": \"^5.94.0\"|g" "package-lock.json" || die
					sed -i -e "s|\"webpack\": \"5\"|\"webpack\": \"^5.94.0\"|g" "package-lock.json" || die
					sed -i -e "s|\"webpack\": \"5.88.2\"|\"webpack\": \"^5.94.0\"|g" "package-lock.json" || die
					sed -i -e "s|\"yargs-parser\": \"^7.0.0\"|\"yargs-parser\": \"^13.1.2\"|g" "package-lock.json" || die
					sed -i -e "s|\"workbox-webpack-plugin\": \"^6.4.1\"|\"workbox-webpack-plugin\": \"7.1.0\"|g" "package-lock.json" || die
					sed -i -e "s|\"workbox-build\": \"^4.3.1\"|\"workbox-build\": \"7.1.1\"|g" "package-lock.json" || die

					sed -i -e "s|\"@babel/runtime\": \"^7.0.0\"|\"@babel/runtime\": \"^7.26.10\"|g" "package-lock.json" || die
					sed -i -e "s|\"@babel/runtime\": \"^7.1.2\"|\"@babel/runtime\": \"^7.26.10\"|g" "package-lock.json" || die
					sed -i -e "s|\"@babel/runtime\": \"^7.2.0\"|\"@babel/runtime\": \"^7.26.10\"|g" "package-lock.json" || die
					sed -i -e "s|\"@babel/runtime\": \"^7.3.1\"|\"@babel/runtime\": \"^7.26.10\"|g" "package-lock.json" || die
					sed -i -e "s|\"@babel/runtime\": \"^7.4.4\"|\"@babel/runtime\": \"^7.26.10\"|g" "package-lock.json" || die
					sed -i -e "s|\"@babel/runtime\": \"^7.5.5\"|\"@babel/runtime\": \"^7.26.10\"|g" "package-lock.json" || die
					sed -i -e "s|\"@babel/runtime\": \"^7.7.6\"|\"@babel/runtime\": \"^7.26.10\"|g" "package-lock.json" || die
					sed -i -e "s|\"@babel/runtime\": \"^7.8.3\"|\"@babel/runtime\": \"^7.26.10\"|g" "package-lock.json" || die
					sed -i -e "s|\"@babel/runtime\": \"^7.8.4\"|\"@babel/runtime\": \"^7.26.10\"|g" "package-lock.json" || die
					sed -i -e "s|\"@babel/runtime\": \"^7.8.7\"|\"@babel/runtime\": \"^7.26.10\"|g" "package-lock.json" || die
					sed -i -e "s|\"@babel/runtime\": \"^7.11.2\"|\"@babel/runtime\": \"^7.26.10\"|g" "package-lock.json" || die
					sed -i -e "s|\"@babel/runtime\": \"^7.12.5\"|\"@babel/runtime\": \"^7.26.10\"|g" "package-lock.json" || die
					sed -i -e "s|\"@babel/runtime\": \"^7.13.10\"|\"@babel/runtime\": \"^7.26.10\"|g" "package-lock.json" || die
					sed -i -e "s|\"@babel/runtime\": \"^7.16.3\"|\"@babel/runtime\": \"^7.26.10\"|g" "package-lock.json" || die
					sed -i -e "s|\"@babel/runtime\": \"^7.17.8\"|\"@babel/runtime\": \"^7.26.10\"|g" "package-lock.json" || die
					sed -i -e "s|\"@babel/runtime\": \"^7.20.7\"|\"@babel/runtime\": \"^7.26.10\"|g" "package-lock.json" || die
				popd || die

				pushd "${S}/newIDE/electron-app/app" || die
					sed -i -e "s|\"axios\": \"^0.21.2\"|\"axios\": \"^1.8.2\"|g" "package-lock.json" || die
					sed -i -e "s|\"axios\": \"^0.28.0\"|\"axios\": \"^1.8.2\"|g" "package-lock.json" || die
					sed -i -e "s|\"bl\": \"^1.0.0\"|\"bl\": \"^1.0.0\"|g" "package-lock.json" || die
					sed -i -e "s|\"braces\": \"^1.8.2\"|\"braces\": \"^3.0.3\"|g" "package-lock.json" || die
					sed -i -e "s|\"braces\": \"^2.3.1\"|\"braces\": \"^3.0.3\"|g" "package-lock.json" || die
					sed -i -e "s|\"braces\": \"^2.3.2\"|\"braces\": \"^3.0.3\"|g" "package-lock.json" || die
					sed -i -e "s|\"braces\": \"~3.0.2\"|\"braces\": \"^3.0.3\"|g" "package-lock.json" || die
					sed -i -e "s|\"braces\": \"~3.0.3\"|\"braces\": \"^3.0.3\"|g" "package-lock.json" || die
					sed -i -e "s|\"debug\": \"~2.2.0\"|\"debug\": \"~2.6.9\"|g" "package-lock.json" || die
					sed -i -e "s|\"electron-updater\": \"4.2.0\"|\"electron-updater\": \"6.3.0-alpha.6\"|g" "package-lock.json" || die
					sed -i -e "s|\"follow-redirects\": \"^1.14.0\"|\"follow-redirects\": \"^1.15.6\"|g" "package-lock.json" || die
					sed -i -e "s|\"follow-redirects\": \"^1.14.7\"|\"follow-redirects\": \"^1.15.6\"|g" "package-lock.json" || die
					sed -i -e "s|\"glob-parent\": \"^2.0.0\"|\"glob-parent\": \"^5.1.2\"|g" "package-lock.json" || die
					sed -i -e "s|\"micromatch\": \"^3.1.4\"|\"micromatch\": \"^4.0.8\"|g" "package-lock.json" || die
					sed -i -e "s|\"micromatch\": \"^3.1.10\"|\"micromatch\": \"^4.0.8\"|g" "package-lock.json" || die
					sed -i -e "s|\"node-fetch\": \"2.6.0\"|\"node-fetch\": \"^2.6.7\"|g" "package-lock.json" || die
					sed -i -e "s|\"send\": \"latest\"|\"send\": \"0.19.0\"|g" "package-lock.json" || die
					sed -i -e "s|\"ws\": \"7.1.2\"|\"ws\": \"^7.5.10\"|g" "package-lock.json" || die
				popd || die

				pushd "${S}/newIDE/electron-app" || die
					sed -i -e "s|\"app-builder-lib\": \"24.9.1\"|\"app-builder-lib\": \"^24.13.2\"|g" "package-lock.json" || die
				popd || die

				pushd "${S}/GDJS" || die
					sed -i -e "s|\"esbuild\": \"^0.13.12\"|\"esbuild\": \"^0.25.0\"|g" "package-lock.json" || die
				popd || die
			}
			patch_edits

	# Those marked with * need testing.
	# Lines begining with # or have * are still undergoing testing.

	# CE = Code Execution
	# DoS = Denial of Service
	# DT = Data Tampering
	# ID = Information Disclosure

	# DoS, DT, ID	[7] Command Injection
	# DoS		[8] Denial of Service (DoS) or Regular Expression Denial of Service (ReDoS)
	# DoS, DT, ID	[11] Insufficient Entropy
	# DoS, DT, ID	[12] Prototype pollution [which could lead to DoS or Remote Code Execution]
	# DT, ID	[14] Server-side request forgery (SSRF)

			pushd "${S}/GDevelop.js" || die
				pkgs=(
					"cryptiles"				# DoS, DT, ID           # CVE-2018-1000620
				)
				enpm uninstall ${pkgs[@]} ${NPM_UNINSTALL_ARGS[@]}
				pkgs=(
					"@hapi/cryptiles@5.1.0"
					"bl@1.2.3"				# DoS, ID		# CVE-2020-8244
					"ejs@3.1.10"				# DoS, DT, ID		# CVE-2022-29078, CVE-2024-33883
					"getobject@1.0.0"			# DoS, DT, ID		# CVE-2020-28282
					"grunt@1.6.1"				# DoS, DT, ID, CE	# CVE-2022-1537, CVE-2020-7729, CVE-2022-0436
						"grunt-contrib-clean@2.0.1"
						"grunt-contrib-compress@2.0.0"
						"grunt-contrib-concat@2.1.0"
						"grunt-contrib-copy@1.0.0"
						"grunt-contrib-uglify@5.2.2"
						"grunt-mkdir@1.1.0"
						"grunt-newer@1.3.0"
						"grunt-shell@4.0.0"
						"grunt-string-replace@1.3.3"
					"js-yaml@3.13.1"			# DoS, CE		# GHSA-8j8c-7jfh-h6hx, GHSA-2pr6-76vf-7546
					"jsdom@16.6.0"				# DT, ID													# [14] contained in requests dep
					"json-schema@0.4.0"			# DoS, DT, ID		# CVE-2021-3918
					"lodash@4.17.21"			# DoS, DT		# CVE-2019-10744, CVE-2020-8203, CVE-2021-23337, CVE-2020-28500, CVE-2018-3721
					"minimist@0.2.4"			# DoS, DT, ID		# CVE-2021-44906, CVE-2020-7598
					"minimist@1.2.6"			# DoS, DT, ID           # CVE-2021-44906, CVE-2020-7598
					"shelljs@0.8.5"				# DoS, ID		# CVE-2022-0144, GHSA-64g7-mvw6-v9qj
					"tar@4.4.18"				# DT, ID		# CVE-2021-37713, CVE-2021-32804, CVE-2021-32803, CVE-2018-20834
					"tough-cookie@4.1.3"			# DT, ID		# CVE-2023-26136

					"patch-package@^6.4.7"																	# For fixing vulnerability
				)
				enpm install ${pkgs[@]} -D ${NPM_INSTALL_ARGS[@]}
				pkgs=(
					"braces@3.0.3"				# DoS			# CVE-2024-4068, CVE-2018-1109, GHSA-g95f-p29q-9xw4
				)
				enpm install ${pkgs[@]} -D ${NPM_INSTALL_ARGS[@]}
			popd || die
			pushd "${S}/GDJS" || die
				pkgs=(
					"braces@3.0.3"				# DoS			# CVE-2024-4068
					"esbuild@0.25.0"			# ID			# GHSA-67mh-4wv8-2f99
					"lodash@4.17.21"			# DoS, DT, ID		# CVE-2021-23337, CVE-2020-28500
					"minimist@1.2.6"			# DoS, DT, ID		# CVE-2021-44906
					"shelljs@0.8.5"				# DoS, ID		# CVE-2022-0144, GHSA-64g7-mvw6-v9qj
				)
				enpm install ${pkgs[@]} -D ${NPM_INSTALL_ARGS[@]}
			popd || die
			pushd "${S}/newIDE/app" || die
ewarn "QA:  Manually remove ip references in ${S}/newIDE/app/package-lock.json"
				pkgs=(
					"cryptiles"
					"ip"					# DoS, DT, ID		# CVE-2024-29415, CVE-2023-42282, GHSA-2p57-rm9w-gvfp					# Backported patch from storybook pull request #27529
				)
				# --prefer-offline is bugged
				enpm uninstall ${pkgs[@]} --legacy-peer-deps #${NPM_UNINSTALL_ARGS[@]}
				pkgs=(
					"@babel/traverse@7.23.2"		# DoS, DT, ID		# CVE-2023-45133
					"@babel/runtime@7.26.10"		# DoS			# CVE-2025-27789
					"@hapi/cryptiles@5.1.0"			# DoS, DT, ID													# [11]
					"braces@3.0.3"				# DoS			# CVE-2024-4068, CVE-2024-4067
					"body-parser@1.20.3"			# DoS			# CVE-2024-45590
					"cookie@0.7.0"				# DT			# CVE-2024-47764
					"ejs@3.1.10"				# DoS			# CVE-2024-33883
					"esbuild@0.25.0"			# ID			# GHSA-67mh-4wv8-2f99
					"express@4.20.0"			# DoS, DT, ID		# CVE-2024-43796, CVE-2024-29041
					"follow-redirects@1.14.8"		# DoS, DT, ID		# CVE-2022-0155, CVE-2024-28849, CVE-2023-26159, CVE-2022-0536
					"getobject@1.0.0"
					"ini@1.3.6"				# DoS, DT, ID		# CVE-2020-7788
					"jsdom@16.6.0"				# DoS, DT, ID													# [12]
					"json-schema@0.4.0"
					#"lodash@4.17.21"			# DoS, DT, ID													# * [7] ; No fix for lodash.template
					"markdown-to-jsx@7.4.0"			# DT, ID		# CVE-2024-21535
					"minimatch@3.0.5"			# DoS			# CVE-2022-3517
					"minimist@0.2.4"			# DoS, DT, ID		# CVE-2021-44906, CVE-2020-7598
					"minimist@1.2.6"			# DoS, DT, ID		# CVE-2021-44906, CVE-2020-7598
					"postcss@8.4.31"			# DT			# CVE-2023-44270
					"rollup@2.79.2"				# DoS, DT, ID		# CVE-2024-47068
					"send@0.19.0"				# DoS, DT, ID		# CVE-2024-43799
					"shelljs@0.8.5"				# DoS, ID		# CVE-2022-0144, GHSA-64g7-mvw6-v9qj
					"serve-static@1.16.0"			# DoS, DT, ID		# CVE-2024-43800
					"store2@2.14.4"				# DT, ID		# CVE-2024-57556
					"webpack@5.94.0"			# DT, ID		# CVE-2024-43788
					"workbox-webpack-plugin@7.1.0"																# Updated for version correspondance with workbox-build
					"workbox-build@7.1.1"			# DoS, DT, ID													# [7 contained in lodash.template dep]
					"ws@7.5.10"				# DoS			# CVE-2024-37890
					"yargs-parser@13.1.2"			# DoS, DT, ID		# CVE-2020-7608

					"babel-plugin-macros@^3.1.0"																# Missing

					"patch-package@^6.4.7"																	# For fixing vulnerability
				)
				enpm install ${pkgs[@]} -D ${NPM_INSTALL_ARGS[@]}
				pkgs=(
					"@grpc/grpc-js@1.8.22"			# DoS			# CVE-2024-37168
					"axios@1.8.2"				# DoS, ID		# CVE-2021-3749, CVE-2023-45857, CVE-2020-28168, CVE-2025-27152
					"d3-color@3.1.0"			# DoS			# GHSA-36jr-mh4h-2g58
					"firebase@10.9.0"			# DoS, DT, ID		# CVE-2024-11023
					"follow-redirects@1.15.6"		# DoS, DT, ID		# CVE-2022-0155, CVE-2024-28849, CVE-2023-26159, CVE-2022-0536
					"lodash@4.17.21"			# DoS, DT, ID		# CVE-2019-10744, CVE-2019-1010266, CVE-2021-23337, CVE-2020-28500
					"node-fetch@2.6.7"			# DoS, DT, ID		# CVE-2022-0235
					"protobufjs@6.11.4"			# DoS, DT, ID		# CVE-2023-36665, CVE-2022-25878
					"semver@7.5.2"				# DoS			# CVE-2022-25883
					"ua-parser-js@0.7.33"			# DoS			# CVE-2022-25927, CVE-2020-7793, CVE-2021-27292
					"undici@5.28.5"				# DoS, DT, ID		# CVE-2025-22150, CVE-2024-30261, CVE-2024-30260
				)
				enpm install ${pkgs[@]} -P ${NPM_INSTALL_ARGS[@]}
				# [24]
			popd || die
			pushd "${S}/newIDE/electron-app" || die
				pkgs=(
					"app-builder-lib@24.13.2"		# DoS, DT, ID		# CVE-2024-27303
					"ejs@3.1.10"				# DoS			# CVE-2024-33883
					"electron@${ELECTRON_APP_ELECTRON_PV}"	# DoS, DT, ID		# CVE-2023-5217, CVE-2023-44402, CVE-2023-39956, CVE-2023-29198, CVE-2022-36077
					"http-cache-semantics@4.1.1"		# DoS			# CVE-2022-25881									# Depends on electron
					"shelljs@0.8.5"				# DoS, ID		# CVE-2022-0144, GHSA-64g7-mvw6-v9qj
				)
				enpm install ${pkgs[@]} -D ${NPM_INSTALL_ARGS[@]}

			popd || die

			pushd "${S}/newIDE/electron-app/app" || die
				pkgs=(
					"bl@1.2.3"				# DoS, ID		# CVE-2020-8244
					"electron@${ELECTRON_APP_ELECTRON_PV}"	# DoS, DT, ID		# CVE-2023-5217, CVE-2023-44402, CVE-2023-39956, CVE-2023-29198
					"http-cache-semantics@4.1.1"		# DT, ID		# CVE-2022-25881									# Depends on electron
				)
				enpm install ${pkgs[@]} -D ${NPM_INSTALL_ARGS[@]}
				pkgs=(
					"async@2.6.4"				# DoS, DT, ID		# CVE-2021-43138
					"axios@1.8.2"				# DoS, ID		# CVE-2021-3749, CVE-2020-28168, CVE-2025-27152
					"braces@3.0.3"				# DoS			# CVE-2018-1109, GHSA-g95f-p29q-9xw4
					"debug@2.6.9"				# DoS			# CVE-2017-20165, CVE-2017-16137
					"decode-uri-component@0.2.1"		# DoS			# CVE-2022-38900
					"electron-updater@6.3.0-alpha.6"	# DoS, DT, ID		# CVE-2024-39698
					"follow-redirects@1.14.8"		# DoS, DT, ID		# CVE-2022-0155, CVE-2022-0536
					"follow-redirects@1.15.6"		# DoS, DT, ID		# CVE-2022-0155, CVE-2022-0536
					"glob-parent@5.1.2"			# DoS														# [8]
					"micromatch@4.0.8"			# DoS			# CVE-2024-4067
					"minimatch@3.0.5"			# DoS			# CVE-2022-3517
					"minimist@1.2.6"			# DoS, DT, ID		# CVE-2021-44906, CVE-2020-7598
					"morgan@1.9.1"				# DoS, DT, ID		# CVE-2019-5413
					"node-fetch@2.6.7"			# DoS, DT, ID		# CVE-2022-0235
					"send@0.19.0"				# DoS, DT, ID		# CVE-2024-43799
					"websocket-extensions@0.1.4"		# DT, ID		# CVE-2020-7662
					"ws@7.5.10"				# ID			# CVE-2021-32640
				)
				enpm install ${pkgs[@]} -P ${NPM_INSTALL_ARGS[@]}
			popd || die

			patch_edits
			_dedupe_lockfiles
			patch_edits
		else
			_gen_lockfiles
			_dedupe_lockfiles
		fi

		_save_lockfiles

		_npm_check_errors
einfo "Finished updating lockfiles."
		exit 0
	else
		__src_unpack_all_production
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

	if ! use analytics ; then
		eapply "${FILESDIR}/${PN}-5.4.221-disable-analytics.patch"
	fi
	eapply "${FILESDIR}/${PN}-5.0.0_beta97-use-emscripten-envvar-for-webidl_binder_py.patch"
	eapply "${FILESDIR}/${PN}-5.5.221-unix-make.patch"
#	eapply #"${FILESDIR}/${PN}-5.0.127-fix-cmake-cxx-tests.patch"
	eapply --binary "${FILESDIR}/${PN}-5.0.127-SFML-define-linux-00.patch"
	eapply "${FILESDIR}/${PN}-5.0.127-SFML-define-linux-01.patch"
	eapply "${FILESDIR}/${PN}-5.3.198-electron-builder-placeholder.patch"
	eapply "${FILESDIR}/${PN}-5.5.221-change-to-wb_manifest.patch"

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
# In https://github.com/4ian/GDevelop/blob/v5.5.226/GDevelop.js/Gruntfile.js#L88
	pushd "${WORKDIR}/${MY_PN}-${MY_PV}/${MY_PN}.js" >/dev/null 2>&1 || die
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
	build_gdevelop_js		#1
	build_gdevelop_ide		#2
	build_gdevelop_ide_electron	#3
	grep -q -e "Failed to compile." "${T}/build.log" && die
	grep -q -e "Error: Cannot find module" "${T}/build.log" && die "Detected error.  Retry." # Offline install bug
	grep -q -e "npm ERR! Invalid Version" "${T}/build.log" && die "Detected error.  Retry." # Indeterministic or random failure bug
	grep -q -e "Failed to compile." "${T}/build.log" && die "Detected error.  Retry."
	grep -q -e "Compiled successfully." "${T}/build.log" || die "Detected error.  Retry."
	grep -q -e "react-scripts: command not found" "${T}/build.log" && die "Detected error.  Retry."
	grep -q -e "Error: Unable to find a place to inject the manifest" "${T}/build.log" && die "Detected error.  Retry."
}

src_install() {
	insinto "${NPM_INSTALL_PATH}"
	doins -r "newIDE/electron-app/dist/linux-unpacked/"*
	electron-app_gen_wrapper \
		"${PN}" \
		"/opt/${PN}/${PN}"

	#
	# We can't use .ico because of XDG icon standards.  .ico is not
	# interoperable with the Linux desktop.
	#
	pushd "${S}/newIDE/electron-app/build/" >/dev/null 2>&1 || die
		if has_version "media-gfx/graphicsmagick" ; then
			gm convert "icon.ico[0]" "icon-256x256.png"
			gm convert "icon.ico[1]" "icon-128x128.png"
			gm convert "icon.ico[2]" "icon-64x64.png"
			gm convert "icon.ico[3]" "icon-48x48.png"
			gm convert "icon.ico[4]" "icon-32x32.png"
			gm convert "icon.ico[5]" "icon-16x16.png"
		else
			convert "icon.ico[0]" "icon-256x256.png"
			convert "icon.ico[1]" "icon-128x128.png"
			convert "icon.ico[2]" "icon-64x64.png"
			convert "icon.ico[3]" "icon-48x48.png"
			convert "icon.ico[4]" "icon-32x32.png"
			convert "icon.ico[5]" "icon-16x16.png"
		fi
		newicon -s 256 "icon-256x256.png" "${PN}.png"
		newicon -s 128 "icon-128x128.png" "${PN}.png"
		newicon -s 64 "icon-64x64.png" "${PN}.png"
		newicon -s 48 "icon-48x48.png" "${PN}.png"
		newicon -s 32 "icon-32x32.png" "${PN}.png"
		newicon -s 16 "icon-16x16.png" "${PN}.png"
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
		"resources/app.asar.unpacked/node_modules/steamworks.js/dist/linux64/libsteam_api.so"
	)
	local exe_path
	for exe_path in ${exe_file_list[@]} ; do
		fperms +x "${NPM_INSTALL_PATH}/${exe_path}"
	done
	electron-app_set_sandbox_suid "/opt/gdevelop/chrome-sandbox"
}

pkg_postinst() {
	xdg_pkg_postinst
einfo
einfo "Your projects are saved in"
einfo
einfo "  \"\$(xdg-user-dir DOCUMENTS)/${MY_PN} projects\""
einfo

# It is preferred that these features are disabled or hidden, but it cannot be
# done easily.
	local major_stable=
	if ver_test "${CR_ELECTRON%%.*}" -lt "${CR_LATEST_STABLE%%.*}" ; then
ewarn
ewarn "SECURITY NOTICE:"
ewarn
ewarn "Detected that the Chromium in Electron is less than Chromium latest stable."
ewarn
ewarn "Latest chromium stable:  ${CR_LATEST_STABLE%%.*} (${CR_LATEST_STABLE_DATE})"
ewarn "Electron chromium version:  ${CR_ELECTRON%%.*} (${CR_ELECTRON_DATE})"
ewarn
ewarn "Do not submit sensitive info if the versions differ."
ewarn
ewarn "It is assumed that you only use free features/assets and no registration."
ewarn
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 5.1.162 (20230520)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 5.1.163 (20230525)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 5.1.164 (20230604)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 5.1.185 (20231217) load test only
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 5.1.198 (20240408) platformer prototype only
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 5.4.204 (20240620) platformer prototype only (emscripten 3.1.30)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 5.4.204 (20240627) platformer demo, car-coin demo (emscripten 1.39.20)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 5.5.221 (20250119) platformer demo (emscripten 1.39.20, electron 22.3.27)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 5.5.224 (20250208) platformer demo (emscripten 1.39.20, electron 22.3.27)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 5.5.224 (20250214) platformer demo (emscripten 1.39.20, electron 22.3.27)
# wayland:                    failed
# X:                          passed
# command-line wrapper:       passed
# 2D platformer prototyping:  passed
# 3D platformer prototyping:  passed with transparency
