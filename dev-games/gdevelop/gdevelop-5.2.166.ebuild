# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="GDevelop"
MY_PV="${PV//_/-}"

export NPM_INSTALL_PATH="/opt/${PN}/${SLOT_MAJOR}"
#ELECTRON_APP_APPIMAGE="1"
ELECTRON_APP_APPIMAGE_ARCHIVE_NAME="${MY_PN}-${PV%%.*}-${PV}.AppImage"
ELECTRON_APP_ELECTRON_PV="18.2.2" # See \
# https://raw.githubusercontent.com/4ian/GDevelop/v5.2.166/newIDE/electron-app/package-lock.json \
# and \
# strings /var/tmp/portage/dev-games/gdevelop-5.2.166/work/GDevelop-5.2.166/newIDE/electron-app/dist/linux-unpacked/* | grep -E "Chrome/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+"
ELECTRON_APP_REACT_PV="16.14.0" # See \
# https://raw.githubusercontent.com/4ian/GDevelop/v5.2.166/newIDE/app/package-lock.json
NODE_ENV="development"
NODE_VERSION=16
NPM_MULTI_LOCKFILE=1
NPM_OFFLINE=0 # Offline is broken.  It says that tarballs are corrupt.
NPM_AUDIT_FIX=0

inherit check-reqs desktop electron-app evar_dump flag-o-matic npm
inherit toolchain-funcs xdg

DESCRIPTION="GDevelop is an open-source, cross-platform game engine designed \
to be used by everyone."
HOMEPAGE="
https://gdevelop-app.com/
https://github.com/4ian/GDevelop
"
THIRD_PARTY_LICENSES="
	custom
	all-rights-reserved
	(
		all-rights-reserved
		Apache-2.0
	)
	(
		all-rights-reserved
		MIT
	)
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
	GDevelop
	MIT
	${THIRD_PARTY_LICENSES}
	${ELECTRON_APP_LICENSES}
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
IUSE+=" r4"
REQUIRED_USE+="
	!wayland
	X
"
# Wayland error:
#16:40:31.141 › GDevelop Electron app starting...
#[1499650:0604/164031.146935:ERROR:ozone_platform_x11.cc(248)] Missing X server or $DISPLAY
#[1499650:0604/164031.146985:ERROR:env.cc(225)] The platform failed to initialize.  Exiting.
#The futex facility returned an unexpected error code.

# Dependency lists:
# https://github.com/4ian/GDevelop/blob/v5.2.166/.circleci/config.yml#L85
# https://github.com/4ian/GDevelop/blob/v5.2.166/.travis.yml
# https://github.com/4ian/GDevelop/blob/v5.2.166/ExtLibs/installDeps.sh
# https://app.travis-ci.com/github/4ian/GDevelop (raw log)
# U 16.04
# Dependencies for the native build are not installed in CI

LLVM_SLOT=14
LLVM_SLOTS=( ${LLVM_SLOT} ) # Deleted 9 8 7 because asm.js support was dropped.
# The CI uses Clang 7.
# Emscripten expects either LLVM 10 for wasm, or LLVM 6 for asm.js.

EMSCRIPTEN_PV="1.39.6" # Based on CI.  EMSCRIPTEN_PV == EMSDK_PV
GDCORE_TESTS_NODEJS_PV="16.20.1" # Based on CI, For building GDCore tests
GDEVELOP_JS_NODEJS_PV="14.18.2" # Based on CI, For building GDevelop.js.
#GDEVELOP_JS_NODEJS_PV="${GDCORE_TESTS_NODEJS_PV}" # For temporarly retrieving tarballs for offline install
# emscripten 1.36.6 requires llvm10 for wasm, 4.1.1 nodejs
EMSCRIPTEN_SLOT="${LLVM_SLOT}-${EMSCRIPTEN_PV%.*}"
UDEV_PV="229"

gen_llvm_depends() {
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
		(
			sys-devel/clang:${s}
			sys-devel/lld:${s}
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
"
DEPEND_NOT_USED_IN_CI2="
	>=sys-fs/eudev-3.1.5
	>=sys-fs/udev-${UDEV_PV}
"
DEPEND+="
	${DEPEND_NOT_USED_IN_CI}
	>=app-arch/p7zip-9.20.1
	>=net-libs/nodejs-${GDCORE_TESTS_NODEJS_PV}:${GDCORE_TESTS_NODEJS_PV%%.*}
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
	>=dev-util/cmake-3.26.3
	>=dev-vcs/git-2.40.1
	>=media-gfx/imagemagick-6.8.9[png]
	>=net-libs/nodejs-${GDCORE_TESTS_NODEJS_PV}:${GDCORE_TESTS_NODEJS_PV%%.*}[acorn]
	>=net-libs/nodejs-${GDCORE_TESTS_NODEJS_PV}[npm]
	>=sys-devel/gcc-5.4
	dev-util/emscripten:${EMSCRIPTEN_SLOT}[wasm(+)]
	|| (
		$(gen_llvm_depends)
	)
"
# Emscripten 3.1.3 used because of node 14.
# UPDATER_START_NPM_EXTERNAL_URIS
NPM_EXTERNAL_URIS="
https://registry.npmjs.org/@babel/code-frame/-/code-frame-7.22.5.tgz -> npmpkg-@babel-code-frame-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-validator-identifier/-/helper-validator-identifier-7.22.5.tgz -> npmpkg-@babel-helper-validator-identifier-7.22.5.tgz
https://registry.npmjs.org/@babel/highlight/-/highlight-7.22.5.tgz -> npmpkg-@babel-highlight-7.22.5.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/js-tokens/-/js-tokens-4.0.0.tgz -> npmpkg-js-tokens-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/abab/-/abab-2.0.6.tgz -> npmpkg-abab-2.0.6.tgz
https://registry.npmjs.org/abbrev/-/abbrev-1.1.1.tgz -> npmpkg-abbrev-1.1.1.tgz
https://registry.npmjs.org/acorn/-/acorn-5.7.4.tgz -> npmpkg-acorn-5.7.4.tgz
https://registry.npmjs.org/acorn-globals/-/acorn-globals-4.3.4.tgz -> npmpkg-acorn-globals-4.3.4.tgz
https://registry.npmjs.org/acorn/-/acorn-6.4.2.tgz -> npmpkg-acorn-6.4.2.tgz
https://registry.npmjs.org/acorn-walk/-/acorn-walk-6.2.0.tgz -> npmpkg-acorn-walk-6.2.0.tgz
https://registry.npmjs.org/ajv/-/ajv-6.12.6.tgz -> npmpkg-ajv-6.12.6.tgz
https://registry.npmjs.org/align-text/-/align-text-0.1.4.tgz -> npmpkg-align-text-0.1.4.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/ansi-escapes/-/ansi-escapes-3.2.0.tgz -> npmpkg-ansi-escapes-3.2.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-2.1.1.tgz -> npmpkg-ansi-regex-2.1.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-2.2.1.tgz -> npmpkg-ansi-styles-2.2.1.tgz
https://registry.npmjs.org/anymatch/-/anymatch-2.0.0.tgz -> npmpkg-anymatch-2.0.0.tgz
https://registry.npmjs.org/braces/-/braces-2.3.2.tgz -> npmpkg-braces-2.3.2.tgz
https://registry.npmjs.org/fill-range/-/fill-range-4.0.0.tgz -> npmpkg-fill-range-4.0.0.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-1.0.1.tgz -> npmpkg-is-extendable-1.0.1.tgz
https://registry.npmjs.org/is-number/-/is-number-3.0.0.tgz -> npmpkg-is-number-3.0.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/micromatch/-/micromatch-3.1.10.tgz -> npmpkg-micromatch-3.1.10.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-3.0.2.tgz -> npmpkg-extend-shallow-3.0.2.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-2.1.1.tgz -> npmpkg-to-regex-range-2.1.1.tgz
https://registry.npmjs.org/append-transform/-/append-transform-0.4.0.tgz -> npmpkg-append-transform-0.4.0.tgz
https://registry.npmjs.org/aproba/-/aproba-1.2.0.tgz -> npmpkg-aproba-1.2.0.tgz
https://registry.npmjs.org/archiver/-/archiver-1.3.0.tgz -> npmpkg-archiver-1.3.0.tgz
https://registry.npmjs.org/archiver-utils/-/archiver-utils-1.3.0.tgz -> npmpkg-archiver-utils-1.3.0.tgz
https://registry.npmjs.org/async/-/async-2.6.4.tgz -> npmpkg-async-2.6.4.tgz
https://registry.npmjs.org/are-we-there-yet/-/are-we-there-yet-1.1.7.tgz -> npmpkg-are-we-there-yet-1.1.7.tgz
https://registry.npmjs.org/argparse/-/argparse-1.0.10.tgz -> npmpkg-argparse-1.0.10.tgz
https://registry.npmjs.org/arr-diff/-/arr-diff-4.0.0.tgz -> npmpkg-arr-diff-4.0.0.tgz
https://registry.npmjs.org/arr-flatten/-/arr-flatten-1.1.0.tgz -> npmpkg-arr-flatten-1.1.0.tgz
https://registry.npmjs.org/arr-union/-/arr-union-3.1.0.tgz -> npmpkg-arr-union-3.1.0.tgz
https://registry.npmjs.org/array-buffer-byte-length/-/array-buffer-byte-length-1.0.0.tgz -> npmpkg-array-buffer-byte-length-1.0.0.tgz
https://registry.npmjs.org/array-each/-/array-each-1.0.1.tgz -> npmpkg-array-each-1.0.1.tgz
https://registry.npmjs.org/array-equal/-/array-equal-1.0.0.tgz -> npmpkg-array-equal-1.0.0.tgz
https://registry.npmjs.org/array-find-index/-/array-find-index-1.0.2.tgz -> npmpkg-array-find-index-1.0.2.tgz
https://registry.npmjs.org/array-slice/-/array-slice-1.1.0.tgz -> npmpkg-array-slice-1.1.0.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.3.2.tgz -> npmpkg-array-unique-0.3.2.tgz
https://registry.npmjs.org/array.prototype.reduce/-/array.prototype.reduce-1.0.5.tgz -> npmpkg-array.prototype.reduce-1.0.5.tgz
https://registry.npmjs.org/arrify/-/arrify-1.0.1.tgz -> npmpkg-arrify-1.0.1.tgz
https://registry.npmjs.org/asn1/-/asn1-0.2.6.tgz -> npmpkg-asn1-0.2.6.tgz
https://registry.npmjs.org/assert-plus/-/assert-plus-1.0.0.tgz -> npmpkg-assert-plus-1.0.0.tgz
https://registry.npmjs.org/assign-symbols/-/assign-symbols-1.0.0.tgz -> npmpkg-assign-symbols-1.0.0.tgz
https://registry.npmjs.org/astral-regex/-/astral-regex-1.0.0.tgz -> npmpkg-astral-regex-1.0.0.tgz
https://registry.npmjs.org/async/-/async-1.5.2.tgz -> npmpkg-async-1.5.2.tgz
https://registry.npmjs.org/async-limiter/-/async-limiter-1.0.1.tgz -> npmpkg-async-limiter-1.0.1.tgz
https://registry.npmjs.org/asynckit/-/asynckit-0.4.0.tgz -> npmpkg-asynckit-0.4.0.tgz
https://registry.npmjs.org/atob/-/atob-2.1.2.tgz -> npmpkg-atob-2.1.2.tgz
https://registry.npmjs.org/available-typed-arrays/-/available-typed-arrays-1.0.5.tgz -> npmpkg-available-typed-arrays-1.0.5.tgz
https://registry.npmjs.org/aws-sign2/-/aws-sign2-0.7.0.tgz -> npmpkg-aws-sign2-0.7.0.tgz
https://registry.npmjs.org/aws4/-/aws4-1.12.0.tgz -> npmpkg-aws4-1.12.0.tgz
https://registry.npmjs.org/babel-code-frame/-/babel-code-frame-6.26.0.tgz -> npmpkg-babel-code-frame-6.26.0.tgz
https://registry.npmjs.org/babel-core/-/babel-core-6.26.3.tgz -> npmpkg-babel-core-6.26.3.tgz
https://registry.npmjs.org/babel-generator/-/babel-generator-6.26.1.tgz -> npmpkg-babel-generator-6.26.1.tgz
https://registry.npmjs.org/babel-helpers/-/babel-helpers-6.24.1.tgz -> npmpkg-babel-helpers-6.24.1.tgz
https://registry.npmjs.org/babel-jest/-/babel-jest-23.6.0.tgz -> npmpkg-babel-jest-23.6.0.tgz
https://registry.npmjs.org/babel-messages/-/babel-messages-6.23.0.tgz -> npmpkg-babel-messages-6.23.0.tgz
https://registry.npmjs.org/babel-plugin-istanbul/-/babel-plugin-istanbul-4.1.6.tgz -> npmpkg-babel-plugin-istanbul-4.1.6.tgz
https://registry.npmjs.org/babel-plugin-jest-hoist/-/babel-plugin-jest-hoist-23.2.0.tgz -> npmpkg-babel-plugin-jest-hoist-23.2.0.tgz
https://registry.npmjs.org/babel-plugin-syntax-object-rest-spread/-/babel-plugin-syntax-object-rest-spread-6.13.0.tgz -> npmpkg-babel-plugin-syntax-object-rest-spread-6.13.0.tgz
https://registry.npmjs.org/babel-preset-jest/-/babel-preset-jest-23.2.0.tgz -> npmpkg-babel-preset-jest-23.2.0.tgz
https://registry.npmjs.org/babel-register/-/babel-register-6.26.0.tgz -> npmpkg-babel-register-6.26.0.tgz
https://registry.npmjs.org/babel-runtime/-/babel-runtime-6.26.0.tgz -> npmpkg-babel-runtime-6.26.0.tgz
https://registry.npmjs.org/babel-template/-/babel-template-6.26.0.tgz -> npmpkg-babel-template-6.26.0.tgz
https://registry.npmjs.org/babel-traverse/-/babel-traverse-6.26.0.tgz -> npmpkg-babel-traverse-6.26.0.tgz
https://registry.npmjs.org/babel-types/-/babel-types-6.26.0.tgz -> npmpkg-babel-types-6.26.0.tgz
https://registry.npmjs.org/babylon/-/babylon-6.18.0.tgz -> npmpkg-babylon-6.18.0.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.2.tgz -> npmpkg-balanced-match-1.0.2.tgz
https://registry.npmjs.org/base/-/base-0.11.2.tgz -> npmpkg-base-0.11.2.tgz
https://registry.npmjs.org/define-property/-/define-property-1.0.0.tgz -> npmpkg-define-property-1.0.0.tgz
https://registry.npmjs.org/base64-js/-/base64-js-1.5.1.tgz -> npmpkg-base64-js-1.5.1.tgz
https://registry.npmjs.org/bcrypt-pbkdf/-/bcrypt-pbkdf-1.0.2.tgz -> npmpkg-bcrypt-pbkdf-1.0.2.tgz
https://registry.npmjs.org/bindings/-/bindings-1.5.0.tgz -> npmpkg-bindings-1.5.0.tgz
https://registry.npmjs.org/bl/-/bl-1.2.3.tgz -> npmpkg-bl-1.2.3.tgz
https://registry.npmjs.org/boolbase/-/boolbase-1.0.0.tgz -> npmpkg-boolbase-1.0.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/braces/-/braces-3.0.2.tgz -> npmpkg-braces-3.0.2.tgz
https://registry.npmjs.org/browser-process-hrtime/-/browser-process-hrtime-1.0.0.tgz -> npmpkg-browser-process-hrtime-1.0.0.tgz
https://registry.npmjs.org/browser-resolve/-/browser-resolve-1.11.3.tgz -> npmpkg-browser-resolve-1.11.3.tgz
https://registry.npmjs.org/browserify-zlib/-/browserify-zlib-0.1.4.tgz -> npmpkg-browserify-zlib-0.1.4.tgz
https://registry.npmjs.org/bser/-/bser-2.1.1.tgz -> npmpkg-bser-2.1.1.tgz
https://registry.npmjs.org/buffer/-/buffer-5.7.1.tgz -> npmpkg-buffer-5.7.1.tgz
https://registry.npmjs.org/buffer-alloc/-/buffer-alloc-1.2.0.tgz -> npmpkg-buffer-alloc-1.2.0.tgz
https://registry.npmjs.org/buffer-alloc-unsafe/-/buffer-alloc-unsafe-1.1.0.tgz -> npmpkg-buffer-alloc-unsafe-1.1.0.tgz
https://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.2.13.tgz -> npmpkg-buffer-crc32-0.2.13.tgz
https://registry.npmjs.org/buffer-fill/-/buffer-fill-1.0.0.tgz -> npmpkg-buffer-fill-1.0.0.tgz
https://registry.npmjs.org/buffer-from/-/buffer-from-1.1.2.tgz -> npmpkg-buffer-from-1.1.2.tgz
https://registry.npmjs.org/cache-base/-/cache-base-1.0.1.tgz -> npmpkg-cache-base-1.0.1.tgz
https://registry.npmjs.org/call-bind/-/call-bind-1.0.2.tgz -> npmpkg-call-bind-1.0.2.tgz
https://registry.npmjs.org/callsites/-/callsites-2.0.0.tgz -> npmpkg-callsites-2.0.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-4.1.0.tgz -> npmpkg-camelcase-4.1.0.tgz
https://registry.npmjs.org/camelcase-keys/-/camelcase-keys-2.1.0.tgz -> npmpkg-camelcase-keys-2.1.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-2.1.1.tgz -> npmpkg-camelcase-2.1.1.tgz
https://registry.npmjs.org/capture-exit/-/capture-exit-1.2.0.tgz -> npmpkg-capture-exit-1.2.0.tgz
https://registry.npmjs.org/caseless/-/caseless-0.12.0.tgz -> npmpkg-caseless-0.12.0.tgz
https://registry.npmjs.org/center-align/-/center-align-0.1.3.tgz -> npmpkg-center-align-0.1.3.tgz
https://registry.npmjs.org/chalk/-/chalk-1.1.3.tgz -> npmpkg-chalk-1.1.3.tgz
https://registry.npmjs.org/cheerio/-/cheerio-0.20.0.tgz -> npmpkg-cheerio-0.20.0.tgz
https://registry.npmjs.org/abab/-/abab-1.0.4.tgz -> npmpkg-abab-1.0.4.tgz
https://registry.npmjs.org/acorn/-/acorn-2.7.0.tgz -> npmpkg-acorn-2.7.0.tgz
https://registry.npmjs.org/acorn-globals/-/acorn-globals-1.0.9.tgz -> npmpkg-acorn-globals-1.0.9.tgz
https://registry.npmjs.org/cssstyle/-/cssstyle-0.2.37.tgz -> npmpkg-cssstyle-0.2.37.tgz
https://registry.npmjs.org/jsdom/-/jsdom-7.2.2.tgz -> npmpkg-jsdom-7.2.2.tgz
https://registry.npmjs.org/parse5/-/parse5-1.5.1.tgz -> npmpkg-parse5-1.5.1.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-2.0.1.tgz -> npmpkg-webidl-conversions-2.0.1.tgz
https://registry.npmjs.org/xml-name-validator/-/xml-name-validator-2.0.1.tgz -> npmpkg-xml-name-validator-2.0.1.tgz
https://registry.npmjs.org/chownr/-/chownr-1.1.4.tgz -> npmpkg-chownr-1.1.4.tgz
https://registry.npmjs.org/ci-info/-/ci-info-1.6.0.tgz -> npmpkg-ci-info-1.6.0.tgz
https://registry.npmjs.org/class-utils/-/class-utils-0.3.6.tgz -> npmpkg-class-utils-0.3.6.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz -> npmpkg-is-accessor-descriptor-0.1.6.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz -> npmpkg-is-data-descriptor-0.1.4.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.6.tgz -> npmpkg-is-descriptor-0.1.6.tgz
https://registry.npmjs.org/kind-of/-/kind-of-5.1.0.tgz -> npmpkg-kind-of-5.1.0.tgz
https://registry.npmjs.org/cliui/-/cliui-4.1.0.tgz -> npmpkg-cliui-4.1.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-3.0.1.tgz -> npmpkg-ansi-regex-3.0.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-2.1.1.tgz -> npmpkg-string-width-2.1.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-4.0.0.tgz -> npmpkg-strip-ansi-4.0.0.tgz
https://registry.npmjs.org/clone/-/clone-1.0.4.tgz -> npmpkg-clone-1.0.4.tgz
https://registry.npmjs.org/clone-stats/-/clone-stats-0.0.1.tgz -> npmpkg-clone-stats-0.0.1.tgz
https://registry.npmjs.org/co/-/co-4.6.0.tgz -> npmpkg-co-4.6.0.tgz
https://registry.npmjs.org/code-point-at/-/code-point-at-1.1.0.tgz -> npmpkg-code-point-at-1.1.0.tgz
https://registry.npmjs.org/collection-visit/-/collection-visit-1.0.0.tgz -> npmpkg-collection-visit-1.0.0.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/colors/-/colors-1.1.2.tgz -> npmpkg-colors-1.1.2.tgz
https://registry.npmjs.org/combined-stream/-/combined-stream-1.0.8.tgz -> npmpkg-combined-stream-1.0.8.tgz
https://registry.npmjs.org/commander/-/commander-2.20.3.tgz -> npmpkg-commander-2.20.3.tgz
https://registry.npmjs.org/component-emitter/-/component-emitter-1.3.0.tgz -> npmpkg-component-emitter-1.3.0.tgz
https://registry.npmjs.org/compress-commons/-/compress-commons-1.2.2.tgz -> npmpkg-compress-commons-1.2.2.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/concat-stream/-/concat-stream-1.6.2.tgz -> npmpkg-concat-stream-1.6.2.tgz
https://registry.npmjs.org/console-control-strings/-/console-control-strings-1.1.0.tgz -> npmpkg-console-control-strings-1.1.0.tgz
https://registry.npmjs.org/convert-source-map/-/convert-source-map-1.9.0.tgz -> npmpkg-convert-source-map-1.9.0.tgz
https://registry.npmjs.org/copy-descriptor/-/copy-descriptor-0.1.1.tgz -> npmpkg-copy-descriptor-0.1.1.tgz
https://registry.npmjs.org/core-js/-/core-js-2.6.12.tgz -> npmpkg-core-js-2.6.12.tgz
https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.3.tgz -> npmpkg-core-util-is-1.0.3.tgz
https://registry.npmjs.org/crc/-/crc-3.8.0.tgz -> npmpkg-crc-3.8.0.tgz
https://registry.npmjs.org/crc32-stream/-/crc32-stream-2.0.0.tgz -> npmpkg-crc32-stream-2.0.0.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-6.0.5.tgz -> npmpkg-cross-spawn-6.0.5.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/css-select/-/css-select-1.2.0.tgz -> npmpkg-css-select-1.2.0.tgz
https://registry.npmjs.org/css-what/-/css-what-2.1.3.tgz -> npmpkg-css-what-2.1.3.tgz
https://registry.npmjs.org/cssom/-/cssom-0.3.8.tgz -> npmpkg-cssom-0.3.8.tgz
https://registry.npmjs.org/cssstyle/-/cssstyle-1.4.0.tgz -> npmpkg-cssstyle-1.4.0.tgz
https://registry.npmjs.org/currently-unhandled/-/currently-unhandled-0.4.1.tgz -> npmpkg-currently-unhandled-0.4.1.tgz
https://registry.npmjs.org/cycle/-/cycle-1.0.3.tgz -> npmpkg-cycle-1.0.3.tgz
https://registry.npmjs.org/dashdash/-/dashdash-1.14.1.tgz -> npmpkg-dashdash-1.14.1.tgz
https://registry.npmjs.org/data-urls/-/data-urls-1.1.0.tgz -> npmpkg-data-urls-1.1.0.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-7.1.0.tgz -> npmpkg-whatwg-url-7.1.0.tgz
https://registry.npmjs.org/dateformat/-/dateformat-4.6.3.tgz -> npmpkg-dateformat-4.6.3.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/decamelize/-/decamelize-1.2.0.tgz -> npmpkg-decamelize-1.2.0.tgz
https://registry.npmjs.org/decode-uri-component/-/decode-uri-component-0.2.2.tgz -> npmpkg-decode-uri-component-0.2.2.tgz
https://registry.npmjs.org/decompress-response/-/decompress-response-4.2.1.tgz -> npmpkg-decompress-response-4.2.1.tgz
https://registry.npmjs.org/deep-extend/-/deep-extend-0.6.0.tgz -> npmpkg-deep-extend-0.6.0.tgz
https://registry.npmjs.org/deep-is/-/deep-is-0.1.4.tgz -> npmpkg-deep-is-0.1.4.tgz
https://registry.npmjs.org/default-require-extensions/-/default-require-extensions-1.0.0.tgz -> npmpkg-default-require-extensions-1.0.0.tgz
https://registry.npmjs.org/define-properties/-/define-properties-1.2.0.tgz -> npmpkg-define-properties-1.2.0.tgz
https://registry.npmjs.org/define-property/-/define-property-2.0.2.tgz -> npmpkg-define-property-2.0.2.tgz
https://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz -> npmpkg-delayed-stream-1.0.0.tgz
https://registry.npmjs.org/delegates/-/delegates-1.0.0.tgz -> npmpkg-delegates-1.0.0.tgz
https://registry.npmjs.org/detect-file/-/detect-file-1.0.0.tgz -> npmpkg-detect-file-1.0.0.tgz
https://registry.npmjs.org/detect-indent/-/detect-indent-4.0.0.tgz -> npmpkg-detect-indent-4.0.0.tgz
https://registry.npmjs.org/detect-libc/-/detect-libc-1.0.3.tgz -> npmpkg-detect-libc-1.0.3.tgz
https://registry.npmjs.org/detect-newline/-/detect-newline-2.1.0.tgz -> npmpkg-detect-newline-2.1.0.tgz
https://registry.npmjs.org/diff/-/diff-3.5.0.tgz -> npmpkg-diff-3.5.0.tgz
https://registry.npmjs.org/dom-serializer/-/dom-serializer-0.1.1.tgz -> npmpkg-dom-serializer-0.1.1.tgz
https://registry.npmjs.org/domelementtype/-/domelementtype-1.3.1.tgz -> npmpkg-domelementtype-1.3.1.tgz
https://registry.npmjs.org/domexception/-/domexception-1.0.1.tgz -> npmpkg-domexception-1.0.1.tgz
https://registry.npmjs.org/domhandler/-/domhandler-2.3.0.tgz -> npmpkg-domhandler-2.3.0.tgz
https://registry.npmjs.org/domutils/-/domutils-1.5.1.tgz -> npmpkg-domutils-1.5.1.tgz
https://registry.npmjs.org/duplexify/-/duplexify-3.7.1.tgz -> npmpkg-duplexify-3.7.1.tgz
https://registry.npmjs.org/ecc-jsbn/-/ecc-jsbn-0.1.2.tgz -> npmpkg-ecc-jsbn-0.1.2.tgz
https://registry.npmjs.org/ejs/-/ejs-2.7.4.tgz -> npmpkg-ejs-2.7.4.tgz
https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.4.4.tgz -> npmpkg-end-of-stream-1.4.4.tgz
https://registry.npmjs.org/entities/-/entities-1.1.2.tgz -> npmpkg-entities-1.1.2.tgz
https://registry.npmjs.org/error-ex/-/error-ex-1.3.2.tgz -> npmpkg-error-ex-1.3.2.tgz
https://registry.npmjs.org/es-abstract/-/es-abstract-1.21.2.tgz -> npmpkg-es-abstract-1.21.2.tgz
https://registry.npmjs.org/es-array-method-boxes-properly/-/es-array-method-boxes-properly-1.0.0.tgz -> npmpkg-es-array-method-boxes-properly-1.0.0.tgz
https://registry.npmjs.org/es-set-tostringtag/-/es-set-tostringtag-2.0.1.tgz -> npmpkg-es-set-tostringtag-2.0.1.tgz
https://registry.npmjs.org/es-to-primitive/-/es-to-primitive-1.2.1.tgz -> npmpkg-es-to-primitive-1.2.1.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/escodegen/-/escodegen-1.14.3.tgz -> npmpkg-escodegen-1.14.3.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/esprima/-/esprima-4.0.1.tgz -> npmpkg-esprima-4.0.1.tgz
https://registry.npmjs.org/estraverse/-/estraverse-4.3.0.tgz -> npmpkg-estraverse-4.3.0.tgz
https://registry.npmjs.org/esutils/-/esutils-2.0.3.tgz -> npmpkg-esutils-2.0.3.tgz
https://registry.npmjs.org/eventemitter2/-/eventemitter2-0.4.14.tgz -> npmpkg-eventemitter2-0.4.14.tgz
https://registry.npmjs.org/exec-sh/-/exec-sh-0.2.2.tgz -> npmpkg-exec-sh-0.2.2.tgz
https://registry.npmjs.org/execa/-/execa-1.0.0.tgz -> npmpkg-execa-1.0.0.tgz
https://registry.npmjs.org/exit/-/exit-0.1.2.tgz -> npmpkg-exit-0.1.2.tgz
https://registry.npmjs.org/expand-brackets/-/expand-brackets-2.1.4.tgz -> npmpkg-expand-brackets-2.1.4.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz -> npmpkg-is-accessor-descriptor-0.1.6.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz -> npmpkg-is-data-descriptor-0.1.4.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.6.tgz -> npmpkg-is-descriptor-0.1.6.tgz
https://registry.npmjs.org/kind-of/-/kind-of-5.1.0.tgz -> npmpkg-kind-of-5.1.0.tgz
https://registry.npmjs.org/expand-range/-/expand-range-1.8.2.tgz -> npmpkg-expand-range-1.8.2.tgz
https://registry.npmjs.org/fill-range/-/fill-range-2.2.4.tgz -> npmpkg-fill-range-2.2.4.tgz
https://registry.npmjs.org/is-number/-/is-number-2.1.0.tgz -> npmpkg-is-number-2.1.0.tgz
https://registry.npmjs.org/isobject/-/isobject-2.1.0.tgz -> npmpkg-isobject-2.1.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/expand-template/-/expand-template-2.0.3.tgz -> npmpkg-expand-template-2.0.3.tgz
https://registry.npmjs.org/expand-tilde/-/expand-tilde-2.0.2.tgz -> npmpkg-expand-tilde-2.0.2.tgz
https://registry.npmjs.org/expect/-/expect-23.6.0.tgz -> npmpkg-expect-23.6.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/extend/-/extend-2.0.2.tgz -> npmpkg-extend-2.0.2.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/extglob/-/extglob-2.0.4.tgz -> npmpkg-extglob-2.0.4.tgz
https://registry.npmjs.org/define-property/-/define-property-1.0.0.tgz -> npmpkg-define-property-1.0.0.tgz
https://registry.npmjs.org/extsprintf/-/extsprintf-1.3.0.tgz -> npmpkg-extsprintf-1.3.0.tgz
https://registry.npmjs.org/eyes/-/eyes-0.1.8.tgz -> npmpkg-eyes-0.1.8.tgz
https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz -> npmpkg-fast-deep-equal-3.1.3.tgz
https://registry.npmjs.org/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz -> npmpkg-fast-json-stable-stringify-2.1.0.tgz
https://registry.npmjs.org/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz -> npmpkg-fast-levenshtein-2.0.6.tgz
https://registry.npmjs.org/fb-watchman/-/fb-watchman-2.0.2.tgz -> npmpkg-fb-watchman-2.0.2.tgz
https://registry.npmjs.org/figures/-/figures-1.7.0.tgz -> npmpkg-figures-1.7.0.tgz
https://registry.npmjs.org/file-sync-cmp/-/file-sync-cmp-0.1.1.tgz -> npmpkg-file-sync-cmp-0.1.1.tgz
https://registry.npmjs.org/file-uri-to-path/-/file-uri-to-path-1.0.0.tgz -> npmpkg-file-uri-to-path-1.0.0.tgz
https://registry.npmjs.org/filename-regex/-/filename-regex-2.0.1.tgz -> npmpkg-filename-regex-2.0.1.tgz
https://registry.npmjs.org/fileset/-/fileset-2.0.3.tgz -> npmpkg-fileset-2.0.3.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.0.1.tgz -> npmpkg-fill-range-7.0.1.tgz
https://registry.npmjs.org/find-up/-/find-up-2.1.0.tgz -> npmpkg-find-up-2.1.0.tgz
https://registry.npmjs.org/findup-sync/-/findup-sync-5.0.0.tgz -> npmpkg-findup-sync-5.0.0.tgz
https://registry.npmjs.org/fined/-/fined-1.2.0.tgz -> npmpkg-fined-1.2.0.tgz
https://registry.npmjs.org/first-chunk-stream/-/first-chunk-stream-1.0.0.tgz -> npmpkg-first-chunk-stream-1.0.0.tgz
https://registry.npmjs.org/flagged-respawn/-/flagged-respawn-1.0.1.tgz -> npmpkg-flagged-respawn-1.0.1.tgz
https://registry.npmjs.org/for-each/-/for-each-0.3.3.tgz -> npmpkg-for-each-0.3.3.tgz
https://registry.npmjs.org/for-in/-/for-in-1.0.2.tgz -> npmpkg-for-in-1.0.2.tgz
https://registry.npmjs.org/for-own/-/for-own-1.0.0.tgz -> npmpkg-for-own-1.0.0.tgz
https://registry.npmjs.org/forever-agent/-/forever-agent-0.6.1.tgz -> npmpkg-forever-agent-0.6.1.tgz
https://registry.npmjs.org/form-data/-/form-data-2.3.3.tgz -> npmpkg-form-data-2.3.3.tgz
https://registry.npmjs.org/fragment-cache/-/fragment-cache-0.2.1.tgz -> npmpkg-fragment-cache-0.2.1.tgz
https://registry.npmjs.org/fs-constants/-/fs-constants-1.0.0.tgz -> npmpkg-fs-constants-1.0.0.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz -> npmpkg-fs.realpath-1.0.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-1.2.13.tgz -> npmpkg-fsevents-1.2.13.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.1.tgz -> npmpkg-function-bind-1.1.1.tgz
https://registry.npmjs.org/function.prototype.name/-/function.prototype.name-1.1.5.tgz -> npmpkg-function.prototype.name-1.1.5.tgz
https://registry.npmjs.org/functions-have-names/-/functions-have-names-1.2.3.tgz -> npmpkg-functions-have-names-1.2.3.tgz
https://registry.npmjs.org/gauge/-/gauge-2.7.4.tgz -> npmpkg-gauge-2.7.4.tgz
https://registry.npmjs.org/get-caller-file/-/get-caller-file-1.0.3.tgz -> npmpkg-get-caller-file-1.0.3.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.2.1.tgz -> npmpkg-get-intrinsic-1.2.1.tgz
https://registry.npmjs.org/get-stdin/-/get-stdin-4.0.1.tgz -> npmpkg-get-stdin-4.0.1.tgz
https://registry.npmjs.org/get-stream/-/get-stream-4.1.0.tgz -> npmpkg-get-stream-4.1.0.tgz
https://registry.npmjs.org/get-symbol-description/-/get-symbol-description-1.0.0.tgz -> npmpkg-get-symbol-description-1.0.0.tgz
https://registry.npmjs.org/get-value/-/get-value-2.0.6.tgz -> npmpkg-get-value-2.0.6.tgz
https://registry.npmjs.org/getobject/-/getobject-1.0.2.tgz -> npmpkg-getobject-1.0.2.tgz
https://registry.npmjs.org/getpass/-/getpass-0.1.7.tgz -> npmpkg-getpass-0.1.7.tgz
https://registry.npmjs.org/github-from-package/-/github-from-package-0.0.0.tgz -> npmpkg-github-from-package-0.0.0.tgz
https://registry.npmjs.org/glob/-/glob-7.1.7.tgz -> npmpkg-glob-7.1.7.tgz
https://registry.npmjs.org/glob-base/-/glob-base-0.3.0.tgz -> npmpkg-glob-base-0.3.0.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-2.0.0.tgz -> npmpkg-glob-parent-2.0.0.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-1.0.0.tgz -> npmpkg-is-extglob-1.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-2.0.1.tgz -> npmpkg-is-glob-2.0.1.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-3.1.0.tgz -> npmpkg-glob-parent-3.1.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-3.1.0.tgz -> npmpkg-is-glob-3.1.0.tgz
https://registry.npmjs.org/glob-stream/-/glob-stream-5.3.5.tgz -> npmpkg-glob-stream-5.3.5.tgz
https://registry.npmjs.org/arr-diff/-/arr-diff-2.0.0.tgz -> npmpkg-arr-diff-2.0.0.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.2.1.tgz -> npmpkg-array-unique-0.2.1.tgz
https://registry.npmjs.org/braces/-/braces-1.8.5.tgz -> npmpkg-braces-1.8.5.tgz
https://registry.npmjs.org/expand-brackets/-/expand-brackets-0.1.5.tgz -> npmpkg-expand-brackets-0.1.5.tgz
https://registry.npmjs.org/extend/-/extend-3.0.2.tgz -> npmpkg-extend-3.0.2.tgz
https://registry.npmjs.org/extglob/-/extglob-0.3.2.tgz -> npmpkg-extglob-0.3.2.tgz
https://registry.npmjs.org/glob/-/glob-5.0.15.tgz -> npmpkg-glob-5.0.15.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-1.0.0.tgz -> npmpkg-is-extglob-1.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-2.0.1.tgz -> npmpkg-is-glob-2.0.1.tgz
https://registry.npmjs.org/isarray/-/isarray-0.0.1.tgz -> npmpkg-isarray-0.0.1.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/micromatch/-/micromatch-2.3.11.tgz -> npmpkg-micromatch-2.3.11.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-1.0.34.tgz -> npmpkg-readable-stream-1.0.34.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-0.10.31.tgz -> npmpkg-string_decoder-0.10.31.tgz
https://registry.npmjs.org/through2/-/through2-0.6.5.tgz -> npmpkg-through2-0.6.5.tgz
https://registry.npmjs.org/global-modules/-/global-modules-1.0.0.tgz -> npmpkg-global-modules-1.0.0.tgz
https://registry.npmjs.org/global-prefix/-/global-prefix-1.0.2.tgz -> npmpkg-global-prefix-1.0.2.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/globals/-/globals-9.18.0.tgz -> npmpkg-globals-9.18.0.tgz
https://registry.npmjs.org/globalthis/-/globalthis-1.0.3.tgz -> npmpkg-globalthis-1.0.3.tgz
https://registry.npmjs.org/gopd/-/gopd-1.0.1.tgz -> npmpkg-gopd-1.0.1.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.11.tgz -> npmpkg-graceful-fs-4.2.11.tgz
https://registry.npmjs.org/growly/-/growly-1.3.0.tgz -> npmpkg-growly-1.3.0.tgz
https://registry.npmjs.org/grunt/-/grunt-1.6.1.tgz -> npmpkg-grunt-1.6.1.tgz
https://registry.npmjs.org/grunt-cli/-/grunt-cli-1.4.3.tgz -> npmpkg-grunt-cli-1.4.3.tgz
https://registry.npmjs.org/nopt/-/nopt-4.0.3.tgz -> npmpkg-nopt-4.0.3.tgz
https://registry.npmjs.org/grunt-contrib-clean/-/grunt-contrib-clean-1.1.0.tgz -> npmpkg-grunt-contrib-clean-1.1.0.tgz
https://registry.npmjs.org/grunt-contrib-compress/-/grunt-contrib-compress-1.6.0.tgz -> npmpkg-grunt-contrib-compress-1.6.0.tgz
https://registry.npmjs.org/grunt-contrib-concat/-/grunt-contrib-concat-1.0.1.tgz -> npmpkg-grunt-contrib-concat-1.0.1.tgz
https://registry.npmjs.org/grunt-contrib-copy/-/grunt-contrib-copy-1.0.0.tgz -> npmpkg-grunt-contrib-copy-1.0.0.tgz
https://registry.npmjs.org/grunt-contrib-uglify/-/grunt-contrib-uglify-2.3.0.tgz -> npmpkg-grunt-contrib-uglify-2.3.0.tgz
https://registry.npmjs.org/grunt-known-options/-/grunt-known-options-2.0.0.tgz -> npmpkg-grunt-known-options-2.0.0.tgz
https://registry.npmjs.org/grunt-legacy-log/-/grunt-legacy-log-3.0.0.tgz -> npmpkg-grunt-legacy-log-3.0.0.tgz
https://registry.npmjs.org/grunt-legacy-log-utils/-/grunt-legacy-log-utils-2.1.0.tgz -> npmpkg-grunt-legacy-log-utils-2.1.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/grunt-legacy-util/-/grunt-legacy-util-2.0.1.tgz -> npmpkg-grunt-legacy-util-2.0.1.tgz
https://registry.npmjs.org/async/-/async-3.2.4.tgz -> npmpkg-async-3.2.4.tgz
https://registry.npmjs.org/grunt-mkdir/-/grunt-mkdir-1.1.0.tgz -> npmpkg-grunt-mkdir-1.1.0.tgz
https://registry.npmjs.org/grunt-newer/-/grunt-newer-1.3.0.tgz -> npmpkg-grunt-newer-1.3.0.tgz
https://registry.npmjs.org/grunt-shell/-/grunt-shell-2.1.0.tgz -> npmpkg-grunt-shell-2.1.0.tgz
https://registry.npmjs.org/grunt-string-replace/-/grunt-string-replace-1.3.3.tgz -> npmpkg-grunt-string-replace-1.3.3.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/async/-/async-3.2.4.tgz -> npmpkg-async-3.2.4.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/gulp-sourcemaps/-/gulp-sourcemaps-1.6.0.tgz -> npmpkg-gulp-sourcemaps-1.6.0.tgz
https://registry.npmjs.org/gzip-size/-/gzip-size-1.0.0.tgz -> npmpkg-gzip-size-1.0.0.tgz
https://registry.npmjs.org/handlebars/-/handlebars-4.7.7.tgz -> npmpkg-handlebars-4.7.7.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/uglify-js/-/uglify-js-3.17.4.tgz -> npmpkg-uglify-js-3.17.4.tgz
https://registry.npmjs.org/har-schema/-/har-schema-2.0.0.tgz -> npmpkg-har-schema-2.0.0.tgz
https://registry.npmjs.org/har-validator/-/har-validator-5.1.5.tgz -> npmpkg-har-validator-5.1.5.tgz
https://registry.npmjs.org/has/-/has-1.0.3.tgz -> npmpkg-has-1.0.3.tgz
https://registry.npmjs.org/has-ansi/-/has-ansi-2.0.0.tgz -> npmpkg-has-ansi-2.0.0.tgz
https://registry.npmjs.org/has-bigints/-/has-bigints-1.0.2.tgz -> npmpkg-has-bigints-1.0.2.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/has-property-descriptors/-/has-property-descriptors-1.0.0.tgz -> npmpkg-has-property-descriptors-1.0.0.tgz
https://registry.npmjs.org/has-proto/-/has-proto-1.0.1.tgz -> npmpkg-has-proto-1.0.1.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.0.3.tgz -> npmpkg-has-symbols-1.0.3.tgz
https://registry.npmjs.org/has-tostringtag/-/has-tostringtag-1.0.0.tgz -> npmpkg-has-tostringtag-1.0.0.tgz
https://registry.npmjs.org/has-unicode/-/has-unicode-2.0.1.tgz -> npmpkg-has-unicode-2.0.1.tgz
https://registry.npmjs.org/has-value/-/has-value-1.0.0.tgz -> npmpkg-has-value-1.0.0.tgz
https://registry.npmjs.org/has-values/-/has-values-1.0.0.tgz -> npmpkg-has-values-1.0.0.tgz
https://registry.npmjs.org/is-number/-/is-number-3.0.0.tgz -> npmpkg-is-number-3.0.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/kind-of/-/kind-of-4.0.0.tgz -> npmpkg-kind-of-4.0.0.tgz
https://registry.npmjs.org/helmsman/-/helmsman-1.0.3.tgz -> npmpkg-helmsman-1.0.3.tgz
https://registry.npmjs.org/colors/-/colors-0.6.2.tgz -> npmpkg-colors-0.6.2.tgz
https://registry.npmjs.org/glob/-/glob-3.2.11.tgz -> npmpkg-glob-3.2.11.tgz
https://registry.npmjs.org/lodash/-/lodash-1.3.1.tgz -> npmpkg-lodash-1.3.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-0.3.0.tgz -> npmpkg-minimatch-0.3.0.tgz
https://registry.npmjs.org/underscore.string/-/underscore.string-2.3.3.tgz -> npmpkg-underscore.string-2.3.3.tgz
https://registry.npmjs.org/highland/-/highland-2.13.5.tgz -> npmpkg-highland-2.13.5.tgz
https://registry.npmjs.org/home-or-tmp/-/home-or-tmp-2.0.0.tgz -> npmpkg-home-or-tmp-2.0.0.tgz
https://registry.npmjs.org/homedir-polyfill/-/homedir-polyfill-1.0.3.tgz -> npmpkg-homedir-polyfill-1.0.3.tgz
https://registry.npmjs.org/hooker/-/hooker-0.2.3.tgz -> npmpkg-hooker-0.2.3.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-2.8.9.tgz -> npmpkg-hosted-git-info-2.8.9.tgz
https://registry.npmjs.org/html-encoding-sniffer/-/html-encoding-sniffer-1.0.2.tgz -> npmpkg-html-encoding-sniffer-1.0.2.tgz
https://registry.npmjs.org/htmlparser2/-/htmlparser2-3.8.3.tgz -> npmpkg-htmlparser2-3.8.3.tgz
https://registry.npmjs.org/entities/-/entities-1.0.0.tgz -> npmpkg-entities-1.0.0.tgz
https://registry.npmjs.org/isarray/-/isarray-0.0.1.tgz -> npmpkg-isarray-0.0.1.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-1.1.14.tgz -> npmpkg-readable-stream-1.1.14.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-0.10.31.tgz -> npmpkg-string_decoder-0.10.31.tgz
https://registry.npmjs.org/http-signature/-/http-signature-1.2.0.tgz -> npmpkg-http-signature-1.2.0.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.6.3.tgz -> npmpkg-iconv-lite-0.6.3.tgz
https://registry.npmjs.org/ieee754/-/ieee754-1.2.1.tgz -> npmpkg-ieee754-1.2.1.tgz
https://registry.npmjs.org/iltorb/-/iltorb-2.4.5.tgz -> npmpkg-iltorb-2.4.5.tgz
https://registry.npmjs.org/import-local/-/import-local-1.0.0.tgz -> npmpkg-import-local-1.0.0.tgz
https://registry.npmjs.org/imurmurhash/-/imurmurhash-0.1.4.tgz -> npmpkg-imurmurhash-0.1.4.tgz
https://registry.npmjs.org/indent-string/-/indent-string-2.1.0.tgz -> npmpkg-indent-string-2.1.0.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz -> npmpkg-inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz -> npmpkg-inherits-2.0.4.tgz
https://registry.npmjs.org/ini/-/ini-1.3.8.tgz -> npmpkg-ini-1.3.8.tgz
https://registry.npmjs.org/internal-slot/-/internal-slot-1.0.5.tgz -> npmpkg-internal-slot-1.0.5.tgz
https://registry.npmjs.org/interpret/-/interpret-1.1.0.tgz -> npmpkg-interpret-1.1.0.tgz
https://registry.npmjs.org/invariant/-/invariant-2.2.4.tgz -> npmpkg-invariant-2.2.4.tgz
https://registry.npmjs.org/invert-kv/-/invert-kv-2.0.0.tgz -> npmpkg-invert-kv-2.0.0.tgz
https://registry.npmjs.org/is-absolute/-/is-absolute-1.0.0.tgz -> npmpkg-is-absolute-1.0.0.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-1.0.0.tgz -> npmpkg-is-accessor-descriptor-1.0.0.tgz
https://registry.npmjs.org/is-array-buffer/-/is-array-buffer-3.0.2.tgz -> npmpkg-is-array-buffer-3.0.2.tgz
https://registry.npmjs.org/is-arrayish/-/is-arrayish-0.2.1.tgz -> npmpkg-is-arrayish-0.2.1.tgz
https://registry.npmjs.org/is-bigint/-/is-bigint-1.0.4.tgz -> npmpkg-is-bigint-1.0.4.tgz
https://registry.npmjs.org/is-boolean-object/-/is-boolean-object-1.1.2.tgz -> npmpkg-is-boolean-object-1.1.2.tgz
https://registry.npmjs.org/is-buffer/-/is-buffer-1.1.6.tgz -> npmpkg-is-buffer-1.1.6.tgz
https://registry.npmjs.org/is-callable/-/is-callable-1.2.7.tgz -> npmpkg-is-callable-1.2.7.tgz
https://registry.npmjs.org/is-ci/-/is-ci-1.2.1.tgz -> npmpkg-is-ci-1.2.1.tgz
https://registry.npmjs.org/is-core-module/-/is-core-module-2.12.1.tgz -> npmpkg-is-core-module-2.12.1.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-1.0.0.tgz -> npmpkg-is-data-descriptor-1.0.0.tgz
https://registry.npmjs.org/is-date-object/-/is-date-object-1.0.5.tgz -> npmpkg-is-date-object-1.0.5.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-1.0.2.tgz -> npmpkg-is-descriptor-1.0.2.tgz
https://registry.npmjs.org/is-dotfile/-/is-dotfile-1.0.3.tgz -> npmpkg-is-dotfile-1.0.3.tgz
https://registry.npmjs.org/is-equal-shallow/-/is-equal-shallow-0.1.3.tgz -> npmpkg-is-equal-shallow-0.1.3.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz -> npmpkg-is-extglob-2.1.1.tgz
https://registry.npmjs.org/is-finite/-/is-finite-1.1.0.tgz -> npmpkg-is-finite-1.1.0.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-1.0.0.tgz -> npmpkg-is-fullwidth-code-point-1.0.0.tgz
https://registry.npmjs.org/is-generator-fn/-/is-generator-fn-1.0.0.tgz -> npmpkg-is-generator-fn-1.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/is-negative-zero/-/is-negative-zero-2.0.2.tgz -> npmpkg-is-negative-zero-2.0.2.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/is-number-object/-/is-number-object-1.0.7.tgz -> npmpkg-is-number-object-1.0.7.tgz
https://registry.npmjs.org/is-plain-object/-/is-plain-object-2.0.4.tgz -> npmpkg-is-plain-object-2.0.4.tgz
https://registry.npmjs.org/is-posix-bracket/-/is-posix-bracket-0.1.1.tgz -> npmpkg-is-posix-bracket-0.1.1.tgz
https://registry.npmjs.org/is-primitive/-/is-primitive-2.0.0.tgz -> npmpkg-is-primitive-2.0.0.tgz
https://registry.npmjs.org/is-regex/-/is-regex-1.1.4.tgz -> npmpkg-is-regex-1.1.4.tgz
https://registry.npmjs.org/is-relative/-/is-relative-1.0.0.tgz -> npmpkg-is-relative-1.0.0.tgz
https://registry.npmjs.org/is-shared-array-buffer/-/is-shared-array-buffer-1.0.2.tgz -> npmpkg-is-shared-array-buffer-1.0.2.tgz
https://registry.npmjs.org/is-stream/-/is-stream-1.1.0.tgz -> npmpkg-is-stream-1.1.0.tgz
https://registry.npmjs.org/is-string/-/is-string-1.0.7.tgz -> npmpkg-is-string-1.0.7.tgz
https://registry.npmjs.org/is-symbol/-/is-symbol-1.0.4.tgz -> npmpkg-is-symbol-1.0.4.tgz
https://registry.npmjs.org/is-typed-array/-/is-typed-array-1.1.10.tgz -> npmpkg-is-typed-array-1.1.10.tgz
https://registry.npmjs.org/is-typedarray/-/is-typedarray-1.0.0.tgz -> npmpkg-is-typedarray-1.0.0.tgz
https://registry.npmjs.org/is-unc-path/-/is-unc-path-1.0.0.tgz -> npmpkg-is-unc-path-1.0.0.tgz
https://registry.npmjs.org/is-utf8/-/is-utf8-0.2.1.tgz -> npmpkg-is-utf8-0.2.1.tgz
https://registry.npmjs.org/is-valid-glob/-/is-valid-glob-0.3.0.tgz -> npmpkg-is-valid-glob-0.3.0.tgz
https://registry.npmjs.org/is-weakref/-/is-weakref-1.0.2.tgz -> npmpkg-is-weakref-1.0.2.tgz
https://registry.npmjs.org/is-windows/-/is-windows-1.0.2.tgz -> npmpkg-is-windows-1.0.2.tgz
https://registry.npmjs.org/is-wsl/-/is-wsl-1.1.0.tgz -> npmpkg-is-wsl-1.1.0.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz -> npmpkg-isexe-2.0.0.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/isstream/-/isstream-0.1.2.tgz -> npmpkg-isstream-0.1.2.tgz
https://registry.npmjs.org/istanbul-api/-/istanbul-api-1.3.7.tgz -> npmpkg-istanbul-api-1.3.7.tgz
https://registry.npmjs.org/async/-/async-2.6.4.tgz -> npmpkg-async-2.6.4.tgz
https://registry.npmjs.org/istanbul-lib-coverage/-/istanbul-lib-coverage-1.2.1.tgz -> npmpkg-istanbul-lib-coverage-1.2.1.tgz
https://registry.npmjs.org/istanbul-lib-hook/-/istanbul-lib-hook-1.2.2.tgz -> npmpkg-istanbul-lib-hook-1.2.2.tgz
https://registry.npmjs.org/istanbul-lib-instrument/-/istanbul-lib-instrument-1.10.2.tgz -> npmpkg-istanbul-lib-instrument-1.10.2.tgz
https://registry.npmjs.org/istanbul-lib-report/-/istanbul-lib-report-1.1.5.tgz -> npmpkg-istanbul-lib-report-1.1.5.tgz
https://registry.npmjs.org/has-flag/-/has-flag-1.0.0.tgz -> npmpkg-has-flag-1.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-3.2.3.tgz -> npmpkg-supports-color-3.2.3.tgz
https://registry.npmjs.org/istanbul-lib-source-maps/-/istanbul-lib-source-maps-1.2.6.tgz -> npmpkg-istanbul-lib-source-maps-1.2.6.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/istanbul-reports/-/istanbul-reports-1.5.1.tgz -> npmpkg-istanbul-reports-1.5.1.tgz
https://registry.npmjs.org/jest/-/jest-23.6.0.tgz -> npmpkg-jest-23.6.0.tgz
https://registry.npmjs.org/jest-changed-files/-/jest-changed-files-23.4.2.tgz -> npmpkg-jest-changed-files-23.4.2.tgz
https://registry.npmjs.org/jest-cli/-/jest-cli-23.6.0.tgz -> npmpkg-jest-cli-23.6.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-3.0.1.tgz -> npmpkg-ansi-regex-3.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/arr-diff/-/arr-diff-2.0.0.tgz -> npmpkg-arr-diff-2.0.0.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.2.1.tgz -> npmpkg-array-unique-0.2.1.tgz
https://registry.npmjs.org/braces/-/braces-1.8.5.tgz -> npmpkg-braces-1.8.5.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/expand-brackets/-/expand-brackets-0.1.5.tgz -> npmpkg-expand-brackets-0.1.5.tgz
https://registry.npmjs.org/extglob/-/extglob-0.3.2.tgz -> npmpkg-extglob-0.3.2.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-1.0.0.tgz -> npmpkg-is-extglob-1.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-2.0.1.tgz -> npmpkg-is-glob-2.0.1.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/micromatch/-/micromatch-2.3.11.tgz -> npmpkg-micromatch-2.3.11.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-4.0.0.tgz -> npmpkg-strip-ansi-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/jest-config/-/jest-config-23.6.0.tgz -> npmpkg-jest-config-23.6.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/arr-diff/-/arr-diff-2.0.0.tgz -> npmpkg-arr-diff-2.0.0.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.2.1.tgz -> npmpkg-array-unique-0.2.1.tgz
https://registry.npmjs.org/braces/-/braces-1.8.5.tgz -> npmpkg-braces-1.8.5.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/expand-brackets/-/expand-brackets-0.1.5.tgz -> npmpkg-expand-brackets-0.1.5.tgz
https://registry.npmjs.org/extglob/-/extglob-0.3.2.tgz -> npmpkg-extglob-0.3.2.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-1.0.0.tgz -> npmpkg-is-extglob-1.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-2.0.1.tgz -> npmpkg-is-glob-2.0.1.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/micromatch/-/micromatch-2.3.11.tgz -> npmpkg-micromatch-2.3.11.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/jest-diff/-/jest-diff-23.6.0.tgz -> npmpkg-jest-diff-23.6.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/jest-docblock/-/jest-docblock-23.2.0.tgz -> npmpkg-jest-docblock-23.2.0.tgz
https://registry.npmjs.org/jest-each/-/jest-each-23.6.0.tgz -> npmpkg-jest-each-23.6.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/jest-environment-jsdom/-/jest-environment-jsdom-23.4.0.tgz -> npmpkg-jest-environment-jsdom-23.4.0.tgz
https://registry.npmjs.org/jest-environment-node/-/jest-environment-node-23.4.0.tgz -> npmpkg-jest-environment-node-23.4.0.tgz
https://registry.npmjs.org/jest-get-type/-/jest-get-type-22.4.3.tgz -> npmpkg-jest-get-type-22.4.3.tgz
https://registry.npmjs.org/jest-haste-map/-/jest-haste-map-23.6.0.tgz -> npmpkg-jest-haste-map-23.6.0.tgz
https://registry.npmjs.org/arr-diff/-/arr-diff-2.0.0.tgz -> npmpkg-arr-diff-2.0.0.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.2.1.tgz -> npmpkg-array-unique-0.2.1.tgz
https://registry.npmjs.org/braces/-/braces-1.8.5.tgz -> npmpkg-braces-1.8.5.tgz
https://registry.npmjs.org/expand-brackets/-/expand-brackets-0.1.5.tgz -> npmpkg-expand-brackets-0.1.5.tgz
https://registry.npmjs.org/extglob/-/extglob-0.3.2.tgz -> npmpkg-extglob-0.3.2.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-1.0.0.tgz -> npmpkg-is-extglob-1.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-2.0.1.tgz -> npmpkg-is-glob-2.0.1.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/micromatch/-/micromatch-2.3.11.tgz -> npmpkg-micromatch-2.3.11.tgz
https://registry.npmjs.org/jest-jasmine2/-/jest-jasmine2-23.6.0.tgz -> npmpkg-jest-jasmine2-23.6.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/jest-leak-detector/-/jest-leak-detector-23.6.0.tgz -> npmpkg-jest-leak-detector-23.6.0.tgz
https://registry.npmjs.org/jest-matcher-utils/-/jest-matcher-utils-23.6.0.tgz -> npmpkg-jest-matcher-utils-23.6.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/jest-message-util/-/jest-message-util-23.4.0.tgz -> npmpkg-jest-message-util-23.4.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/arr-diff/-/arr-diff-2.0.0.tgz -> npmpkg-arr-diff-2.0.0.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.2.1.tgz -> npmpkg-array-unique-0.2.1.tgz
https://registry.npmjs.org/braces/-/braces-1.8.5.tgz -> npmpkg-braces-1.8.5.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/expand-brackets/-/expand-brackets-0.1.5.tgz -> npmpkg-expand-brackets-0.1.5.tgz
https://registry.npmjs.org/extglob/-/extglob-0.3.2.tgz -> npmpkg-extglob-0.3.2.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-1.0.0.tgz -> npmpkg-is-extglob-1.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-2.0.1.tgz -> npmpkg-is-glob-2.0.1.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/micromatch/-/micromatch-2.3.11.tgz -> npmpkg-micromatch-2.3.11.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/jest-mock/-/jest-mock-23.2.0.tgz -> npmpkg-jest-mock-23.2.0.tgz
https://registry.npmjs.org/jest-regex-util/-/jest-regex-util-23.3.0.tgz -> npmpkg-jest-regex-util-23.3.0.tgz
https://registry.npmjs.org/jest-resolve/-/jest-resolve-23.6.0.tgz -> npmpkg-jest-resolve-23.6.0.tgz
https://registry.npmjs.org/jest-resolve-dependencies/-/jest-resolve-dependencies-23.6.0.tgz -> npmpkg-jest-resolve-dependencies-23.6.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/jest-runner/-/jest-runner-23.6.0.tgz -> npmpkg-jest-runner-23.6.0.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/source-map-support/-/source-map-support-0.5.21.tgz -> npmpkg-source-map-support-0.5.21.tgz
https://registry.npmjs.org/jest-runtime/-/jest-runtime-23.6.0.tgz -> npmpkg-jest-runtime-23.6.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/arr-diff/-/arr-diff-2.0.0.tgz -> npmpkg-arr-diff-2.0.0.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.2.1.tgz -> npmpkg-array-unique-0.2.1.tgz
https://registry.npmjs.org/braces/-/braces-1.8.5.tgz -> npmpkg-braces-1.8.5.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/expand-brackets/-/expand-brackets-0.1.5.tgz -> npmpkg-expand-brackets-0.1.5.tgz
https://registry.npmjs.org/extglob/-/extglob-0.3.2.tgz -> npmpkg-extglob-0.3.2.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-1.0.0.tgz -> npmpkg-is-extglob-1.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-2.0.1.tgz -> npmpkg-is-glob-2.0.1.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/micromatch/-/micromatch-2.3.11.tgz -> npmpkg-micromatch-2.3.11.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-3.0.0.tgz -> npmpkg-strip-bom-3.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/jest-serializer/-/jest-serializer-23.0.1.tgz -> npmpkg-jest-serializer-23.0.1.tgz
https://registry.npmjs.org/jest-snapshot/-/jest-snapshot-23.6.0.tgz -> npmpkg-jest-snapshot-23.6.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/jest-util/-/jest-util-23.4.0.tgz -> npmpkg-jest-util-23.4.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/jest-validate/-/jest-validate-23.6.0.tgz -> npmpkg-jest-validate-23.6.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/jest-watcher/-/jest-watcher-23.4.0.tgz -> npmpkg-jest-watcher-23.4.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/jest-worker/-/jest-worker-23.2.0.tgz -> npmpkg-jest-worker-23.2.0.tgz
https://registry.npmjs.org/js-tokens/-/js-tokens-3.0.2.tgz -> npmpkg-js-tokens-3.0.2.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-3.14.1.tgz -> npmpkg-js-yaml-3.14.1.tgz
https://registry.npmjs.org/jsbn/-/jsbn-0.1.1.tgz -> npmpkg-jsbn-0.1.1.tgz
https://registry.npmjs.org/jsdom/-/jsdom-11.12.0.tgz -> npmpkg-jsdom-11.12.0.tgz
https://registry.npmjs.org/jsesc/-/jsesc-1.3.0.tgz -> npmpkg-jsesc-1.3.0.tgz
https://registry.npmjs.org/json-schema/-/json-schema-0.4.0.tgz -> npmpkg-json-schema-0.4.0.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz -> npmpkg-json-schema-traverse-0.4.1.tgz
https://registry.npmjs.org/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz -> npmpkg-json-stable-stringify-without-jsonify-1.0.1.tgz
https://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz -> npmpkg-json-stringify-safe-5.0.1.tgz
https://registry.npmjs.org/json5/-/json5-0.5.1.tgz -> npmpkg-json5-0.5.1.tgz
https://registry.npmjs.org/jsprim/-/jsprim-1.4.2.tgz -> npmpkg-jsprim-1.4.2.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/kleur/-/kleur-2.0.2.tgz -> npmpkg-kleur-2.0.2.tgz
https://registry.npmjs.org/lazy-cache/-/lazy-cache-1.0.4.tgz -> npmpkg-lazy-cache-1.0.4.tgz
https://registry.npmjs.org/lazystream/-/lazystream-1.0.1.tgz -> npmpkg-lazystream-1.0.1.tgz
https://registry.npmjs.org/lcid/-/lcid-2.0.0.tgz -> npmpkg-lcid-2.0.0.tgz
https://registry.npmjs.org/left-pad/-/left-pad-1.3.0.tgz -> npmpkg-left-pad-1.3.0.tgz
https://registry.npmjs.org/leven/-/leven-2.1.0.tgz -> npmpkg-leven-2.1.0.tgz
https://registry.npmjs.org/levn/-/levn-0.3.0.tgz -> npmpkg-levn-0.3.0.tgz
https://registry.npmjs.org/liftup/-/liftup-3.0.1.tgz -> npmpkg-liftup-3.0.1.tgz
https://registry.npmjs.org/extend/-/extend-3.0.2.tgz -> npmpkg-extend-3.0.2.tgz
https://registry.npmjs.org/findup-sync/-/findup-sync-4.0.0.tgz -> npmpkg-findup-sync-4.0.0.tgz
https://registry.npmjs.org/resolve/-/resolve-1.22.2.tgz -> npmpkg-resolve-1.22.2.tgz
https://registry.npmjs.org/load-json-file/-/load-json-file-1.1.0.tgz -> npmpkg-load-json-file-1.1.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-2.0.0.tgz -> npmpkg-locate-path-2.0.0.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/lodash.isequal/-/lodash.isequal-4.5.0.tgz -> npmpkg-lodash.isequal-4.5.0.tgz
https://registry.npmjs.org/lodash.sortby/-/lodash.sortby-4.7.0.tgz -> npmpkg-lodash.sortby-4.7.0.tgz
https://registry.npmjs.org/longest/-/longest-1.0.1.tgz -> npmpkg-longest-1.0.1.tgz
https://registry.npmjs.org/loose-envify/-/loose-envify-1.4.0.tgz -> npmpkg-loose-envify-1.4.0.tgz
https://registry.npmjs.org/loud-rejection/-/loud-rejection-1.6.0.tgz -> npmpkg-loud-rejection-1.6.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-2.7.3.tgz -> npmpkg-lru-cache-2.7.3.tgz
https://registry.npmjs.org/make-iterator/-/make-iterator-1.0.1.tgz -> npmpkg-make-iterator-1.0.1.tgz
https://registry.npmjs.org/makeerror/-/makeerror-1.0.12.tgz -> npmpkg-makeerror-1.0.12.tgz
https://registry.npmjs.org/map-age-cleaner/-/map-age-cleaner-0.1.3.tgz -> npmpkg-map-age-cleaner-0.1.3.tgz
https://registry.npmjs.org/map-cache/-/map-cache-0.2.2.tgz -> npmpkg-map-cache-0.2.2.tgz
https://registry.npmjs.org/map-obj/-/map-obj-1.0.1.tgz -> npmpkg-map-obj-1.0.1.tgz
https://registry.npmjs.org/map-visit/-/map-visit-1.0.0.tgz -> npmpkg-map-visit-1.0.0.tgz
https://registry.npmjs.org/math-random/-/math-random-1.0.4.tgz -> npmpkg-math-random-1.0.4.tgz
https://registry.npmjs.org/maxmin/-/maxmin-1.1.0.tgz -> npmpkg-maxmin-1.1.0.tgz
https://registry.npmjs.org/pretty-bytes/-/pretty-bytes-1.0.4.tgz -> npmpkg-pretty-bytes-1.0.4.tgz
https://registry.npmjs.org/mem/-/mem-4.3.0.tgz -> npmpkg-mem-4.3.0.tgz
https://registry.npmjs.org/meow/-/meow-3.7.0.tgz -> npmpkg-meow-3.7.0.tgz
https://registry.npmjs.org/merge/-/merge-1.2.1.tgz -> npmpkg-merge-1.2.1.tgz
https://registry.npmjs.org/merge-stream/-/merge-stream-1.0.1.tgz -> npmpkg-merge-stream-1.0.1.tgz
https://registry.npmjs.org/micromatch/-/micromatch-4.0.5.tgz -> npmpkg-micromatch-4.0.5.tgz
https://registry.npmjs.org/mime-db/-/mime-db-1.52.0.tgz -> npmpkg-mime-db-1.52.0.tgz
https://registry.npmjs.org/mime-types/-/mime-types-2.1.35.tgz -> npmpkg-mime-types-2.1.35.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-2.1.0.tgz -> npmpkg-mimic-fn-2.1.0.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-2.1.0.tgz -> npmpkg-mimic-response-2.1.0.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.0.8.tgz -> npmpkg-minimatch-3.0.8.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.8.tgz -> npmpkg-minimist-1.2.8.tgz
https://registry.npmjs.org/mixin-deep/-/mixin-deep-1.3.2.tgz -> npmpkg-mixin-deep-1.3.2.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-1.0.1.tgz -> npmpkg-is-extendable-1.0.1.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.6.tgz -> npmpkg-mkdirp-0.5.6.tgz
https://registry.npmjs.org/mkdirp-classic/-/mkdirp-classic-0.5.3.tgz -> npmpkg-mkdirp-classic-0.5.3.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/nan/-/nan-2.17.0.tgz -> npmpkg-nan-2.17.0.tgz
https://registry.npmjs.org/nanomatch/-/nanomatch-1.2.13.tgz -> npmpkg-nanomatch-1.2.13.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-3.0.2.tgz -> npmpkg-extend-shallow-3.0.2.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-1.0.1.tgz -> npmpkg-is-extendable-1.0.1.tgz
https://registry.npmjs.org/napi-build-utils/-/napi-build-utils-1.0.2.tgz -> npmpkg-napi-build-utils-1.0.2.tgz
https://registry.npmjs.org/natural-compare/-/natural-compare-1.4.0.tgz -> npmpkg-natural-compare-1.4.0.tgz
https://registry.npmjs.org/neo-async/-/neo-async-2.6.2.tgz -> npmpkg-neo-async-2.6.2.tgz
https://registry.npmjs.org/nice-try/-/nice-try-1.0.5.tgz -> npmpkg-nice-try-1.0.5.tgz
https://registry.npmjs.org/node-abi/-/node-abi-2.30.1.tgz -> npmpkg-node-abi-2.30.1.tgz
https://registry.npmjs.org/node-int64/-/node-int64-0.4.0.tgz -> npmpkg-node-int64-0.4.0.tgz
https://registry.npmjs.org/node-notifier/-/node-notifier-5.4.5.tgz -> npmpkg-node-notifier-5.4.5.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/noop-logger/-/noop-logger-0.1.1.tgz -> npmpkg-noop-logger-0.1.1.tgz
https://registry.npmjs.org/nopt/-/nopt-3.0.6.tgz -> npmpkg-nopt-3.0.6.tgz
https://registry.npmjs.org/normalize-package-data/-/normalize-package-data-2.5.0.tgz -> npmpkg-normalize-package-data-2.5.0.tgz
https://registry.npmjs.org/resolve/-/resolve-1.22.2.tgz -> npmpkg-resolve-1.22.2.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-2.1.1.tgz -> npmpkg-normalize-path-2.1.1.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-2.0.2.tgz -> npmpkg-npm-run-path-2.0.2.tgz
https://registry.npmjs.org/npmlog/-/npmlog-4.1.2.tgz -> npmpkg-npmlog-4.1.2.tgz
https://registry.npmjs.org/nth-check/-/nth-check-1.0.2.tgz -> npmpkg-nth-check-1.0.2.tgz
https://registry.npmjs.org/number-is-nan/-/number-is-nan-1.0.1.tgz -> npmpkg-number-is-nan-1.0.1.tgz
https://registry.npmjs.org/nwmatcher/-/nwmatcher-1.4.4.tgz -> npmpkg-nwmatcher-1.4.4.tgz
https://registry.npmjs.org/nwsapi/-/nwsapi-2.2.5.tgz -> npmpkg-nwsapi-2.2.5.tgz
https://registry.npmjs.org/oauth-sign/-/oauth-sign-0.9.0.tgz -> npmpkg-oauth-sign-0.9.0.tgz
https://registry.npmjs.org/object-assign/-/object-assign-4.1.1.tgz -> npmpkg-object-assign-4.1.1.tgz
https://registry.npmjs.org/object-copy/-/object-copy-0.1.0.tgz -> npmpkg-object-copy-0.1.0.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz -> npmpkg-is-accessor-descriptor-0.1.6.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz -> npmpkg-is-data-descriptor-0.1.4.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.6.tgz -> npmpkg-is-descriptor-0.1.6.tgz
https://registry.npmjs.org/kind-of/-/kind-of-5.1.0.tgz -> npmpkg-kind-of-5.1.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/object-inspect/-/object-inspect-1.12.3.tgz -> npmpkg-object-inspect-1.12.3.tgz
https://registry.npmjs.org/object-keys/-/object-keys-1.1.1.tgz -> npmpkg-object-keys-1.1.1.tgz
https://registry.npmjs.org/object-visit/-/object-visit-1.0.1.tgz -> npmpkg-object-visit-1.0.1.tgz
https://registry.npmjs.org/object.assign/-/object.assign-4.1.4.tgz -> npmpkg-object.assign-4.1.4.tgz
https://registry.npmjs.org/object.defaults/-/object.defaults-1.1.0.tgz -> npmpkg-object.defaults-1.1.0.tgz
https://registry.npmjs.org/object.getownpropertydescriptors/-/object.getownpropertydescriptors-2.1.6.tgz -> npmpkg-object.getownpropertydescriptors-2.1.6.tgz
https://registry.npmjs.org/object.map/-/object.map-1.0.1.tgz -> npmpkg-object.map-1.0.1.tgz
https://registry.npmjs.org/object.omit/-/object.omit-2.0.1.tgz -> npmpkg-object.omit-2.0.1.tgz
https://registry.npmjs.org/for-own/-/for-own-0.1.5.tgz -> npmpkg-for-own-0.1.5.tgz
https://registry.npmjs.org/object.pick/-/object.pick-1.3.0.tgz -> npmpkg-object.pick-1.3.0.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz -> npmpkg-once-1.4.0.tgz
https://registry.npmjs.org/optionator/-/optionator-0.8.3.tgz -> npmpkg-optionator-0.8.3.tgz
https://registry.npmjs.org/ordered-read-streams/-/ordered-read-streams-0.3.0.tgz -> npmpkg-ordered-read-streams-0.3.0.tgz
https://registry.npmjs.org/os-homedir/-/os-homedir-1.0.2.tgz -> npmpkg-os-homedir-1.0.2.tgz
https://registry.npmjs.org/os-locale/-/os-locale-3.1.0.tgz -> npmpkg-os-locale-3.1.0.tgz
https://registry.npmjs.org/os-tmpdir/-/os-tmpdir-1.0.2.tgz -> npmpkg-os-tmpdir-1.0.2.tgz
https://registry.npmjs.org/osenv/-/osenv-0.1.5.tgz -> npmpkg-osenv-0.1.5.tgz
https://registry.npmjs.org/p-defer/-/p-defer-1.0.0.tgz -> npmpkg-p-defer-1.0.0.tgz
https://registry.npmjs.org/p-finally/-/p-finally-1.0.0.tgz -> npmpkg-p-finally-1.0.0.tgz
https://registry.npmjs.org/p-is-promise/-/p-is-promise-2.1.0.tgz -> npmpkg-p-is-promise-2.1.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-1.3.0.tgz -> npmpkg-p-limit-1.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-2.0.0.tgz -> npmpkg-p-locate-2.0.0.tgz
https://registry.npmjs.org/p-try/-/p-try-1.0.0.tgz -> npmpkg-p-try-1.0.0.tgz
https://registry.npmjs.org/pako/-/pako-0.2.9.tgz -> npmpkg-pako-0.2.9.tgz
https://registry.npmjs.org/parse-filepath/-/parse-filepath-1.0.2.tgz -> npmpkg-parse-filepath-1.0.2.tgz
https://registry.npmjs.org/parse-glob/-/parse-glob-3.0.4.tgz -> npmpkg-parse-glob-3.0.4.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-1.0.0.tgz -> npmpkg-is-extglob-1.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-2.0.1.tgz -> npmpkg-is-glob-2.0.1.tgz
https://registry.npmjs.org/parse-json/-/parse-json-2.2.0.tgz -> npmpkg-parse-json-2.2.0.tgz
https://registry.npmjs.org/parse-passwd/-/parse-passwd-1.0.0.tgz -> npmpkg-parse-passwd-1.0.0.tgz
https://registry.npmjs.org/parse5/-/parse5-4.0.0.tgz -> npmpkg-parse5-4.0.0.tgz
https://registry.npmjs.org/pascalcase/-/pascalcase-0.1.1.tgz -> npmpkg-pascalcase-0.1.1.tgz
https://registry.npmjs.org/path-dirname/-/path-dirname-1.0.2.tgz -> npmpkg-path-dirname-1.0.2.tgz
https://registry.npmjs.org/path-exists/-/path-exists-3.0.0.tgz -> npmpkg-path-exists-3.0.0.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> npmpkg-path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/path-key/-/path-key-2.0.1.tgz -> npmpkg-path-key-2.0.1.tgz
https://registry.npmjs.org/path-parse/-/path-parse-1.0.7.tgz -> npmpkg-path-parse-1.0.7.tgz
https://registry.npmjs.org/path-root/-/path-root-0.1.1.tgz -> npmpkg-path-root-0.1.1.tgz
https://registry.npmjs.org/path-root-regex/-/path-root-regex-0.1.2.tgz -> npmpkg-path-root-regex-0.1.2.tgz
https://registry.npmjs.org/path-type/-/path-type-1.1.0.tgz -> npmpkg-path-type-1.1.0.tgz
https://registry.npmjs.org/performance-now/-/performance-now-2.1.0.tgz -> npmpkg-performance-now-2.1.0.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.3.1.tgz -> npmpkg-picomatch-2.3.1.tgz
https://registry.npmjs.org/pify/-/pify-2.3.0.tgz -> npmpkg-pify-2.3.0.tgz
https://registry.npmjs.org/pinkie/-/pinkie-2.0.4.tgz -> npmpkg-pinkie-2.0.4.tgz
https://registry.npmjs.org/pinkie-promise/-/pinkie-promise-2.0.1.tgz -> npmpkg-pinkie-promise-2.0.1.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-2.0.0.tgz -> npmpkg-pkg-dir-2.0.0.tgz
https://registry.npmjs.org/pn/-/pn-1.1.0.tgz -> npmpkg-pn-1.1.0.tgz
https://registry.npmjs.org/posix-character-classes/-/posix-character-classes-0.1.1.tgz -> npmpkg-posix-character-classes-0.1.1.tgz
https://registry.npmjs.org/prebuild-install/-/prebuild-install-5.3.6.tgz -> npmpkg-prebuild-install-5.3.6.tgz
https://registry.npmjs.org/prelude-ls/-/prelude-ls-1.1.2.tgz -> npmpkg-prelude-ls-1.1.2.tgz
https://registry.npmjs.org/preserve/-/preserve-0.2.0.tgz -> npmpkg-preserve-0.2.0.tgz
https://registry.npmjs.org/pretty-bytes/-/pretty-bytes-4.0.2.tgz -> npmpkg-pretty-bytes-4.0.2.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-23.6.0.tgz -> npmpkg-pretty-format-23.6.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-3.0.1.tgz -> npmpkg-ansi-regex-3.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/private/-/private-0.1.8.tgz -> npmpkg-private-0.1.8.tgz
https://registry.npmjs.org/process-nextick-args/-/process-nextick-args-2.0.1.tgz -> npmpkg-process-nextick-args-2.0.1.tgz
https://registry.npmjs.org/prompts/-/prompts-0.1.14.tgz -> npmpkg-prompts-0.1.14.tgz
https://registry.npmjs.org/psl/-/psl-1.9.0.tgz -> npmpkg-psl-1.9.0.tgz
https://registry.npmjs.org/pump/-/pump-3.0.0.tgz -> npmpkg-pump-3.0.0.tgz
https://registry.npmjs.org/punycode/-/punycode-2.3.0.tgz -> npmpkg-punycode-2.3.0.tgz
https://registry.npmjs.org/qs/-/qs-6.5.3.tgz -> npmpkg-qs-6.5.3.tgz
https://registry.npmjs.org/randomatic/-/randomatic-3.1.1.tgz -> npmpkg-randomatic-3.1.1.tgz
https://registry.npmjs.org/is-number/-/is-number-4.0.0.tgz -> npmpkg-is-number-4.0.0.tgz
https://registry.npmjs.org/rc/-/rc-1.2.8.tgz -> npmpkg-rc-1.2.8.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-1.1.0.tgz -> npmpkg-read-pkg-1.1.0.tgz
https://registry.npmjs.org/read-pkg-up/-/read-pkg-up-1.0.1.tgz -> npmpkg-read-pkg-up-1.0.1.tgz
https://registry.npmjs.org/find-up/-/find-up-1.1.2.tgz -> npmpkg-find-up-1.1.2.tgz
https://registry.npmjs.org/path-exists/-/path-exists-2.1.0.tgz -> npmpkg-path-exists-2.1.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/realpath-native/-/realpath-native-1.1.0.tgz -> npmpkg-realpath-native-1.1.0.tgz
https://registry.npmjs.org/rechoir/-/rechoir-0.7.1.tgz -> npmpkg-rechoir-0.7.1.tgz
https://registry.npmjs.org/resolve/-/resolve-1.22.2.tgz -> npmpkg-resolve-1.22.2.tgz
https://registry.npmjs.org/redent/-/redent-1.0.0.tgz -> npmpkg-redent-1.0.0.tgz
https://registry.npmjs.org/regenerator-runtime/-/regenerator-runtime-0.11.1.tgz -> npmpkg-regenerator-runtime-0.11.1.tgz
https://registry.npmjs.org/regex-cache/-/regex-cache-0.4.4.tgz -> npmpkg-regex-cache-0.4.4.tgz
https://registry.npmjs.org/regex-not/-/regex-not-1.0.2.tgz -> npmpkg-regex-not-1.0.2.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-3.0.2.tgz -> npmpkg-extend-shallow-3.0.2.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-1.0.1.tgz -> npmpkg-is-extendable-1.0.1.tgz
https://registry.npmjs.org/regexp.prototype.flags/-/regexp.prototype.flags-1.5.0.tgz -> npmpkg-regexp.prototype.flags-1.5.0.tgz
https://registry.npmjs.org/remove-trailing-separator/-/remove-trailing-separator-1.1.0.tgz -> npmpkg-remove-trailing-separator-1.1.0.tgz
https://registry.npmjs.org/repeat-element/-/repeat-element-1.1.4.tgz -> npmpkg-repeat-element-1.1.4.tgz
https://registry.npmjs.org/repeat-string/-/repeat-string-1.6.1.tgz -> npmpkg-repeat-string-1.6.1.tgz
https://registry.npmjs.org/repeating/-/repeating-2.0.1.tgz -> npmpkg-repeating-2.0.1.tgz
https://registry.npmjs.org/replace-ext/-/replace-ext-0.0.1.tgz -> npmpkg-replace-ext-0.0.1.tgz
https://registry.npmjs.org/request/-/request-2.88.2.tgz -> npmpkg-request-2.88.2.tgz
https://registry.npmjs.org/request-promise-core/-/request-promise-core-1.1.4.tgz -> npmpkg-request-promise-core-1.1.4.tgz
https://registry.npmjs.org/request-promise-native/-/request-promise-native-1.0.9.tgz -> npmpkg-request-promise-native-1.0.9.tgz
https://registry.npmjs.org/extend/-/extend-3.0.2.tgz -> npmpkg-extend-3.0.2.tgz
https://registry.npmjs.org/require-directory/-/require-directory-2.1.1.tgz -> npmpkg-require-directory-2.1.1.tgz
https://registry.npmjs.org/require-main-filename/-/require-main-filename-1.0.1.tgz -> npmpkg-require-main-filename-1.0.1.tgz
https://registry.npmjs.org/resolve/-/resolve-1.1.7.tgz -> npmpkg-resolve-1.1.7.tgz
https://registry.npmjs.org/resolve-cwd/-/resolve-cwd-2.0.0.tgz -> npmpkg-resolve-cwd-2.0.0.tgz
https://registry.npmjs.org/resolve-dir/-/resolve-dir-1.0.1.tgz -> npmpkg-resolve-dir-1.0.1.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-3.0.0.tgz -> npmpkg-resolve-from-3.0.0.tgz
https://registry.npmjs.org/resolve-url/-/resolve-url-0.2.1.tgz -> npmpkg-resolve-url-0.2.1.tgz
https://registry.npmjs.org/ret/-/ret-0.1.15.tgz -> npmpkg-ret-0.1.15.tgz
https://registry.npmjs.org/right-align/-/right-align-0.1.3.tgz -> npmpkg-right-align-0.1.3.tgz
https://registry.npmjs.org/rimraf/-/rimraf-2.7.1.tgz -> npmpkg-rimraf-2.7.1.tgz
https://registry.npmjs.org/rsvp/-/rsvp-3.6.2.tgz -> npmpkg-rsvp-3.6.2.tgz
https://registry.npmjs.org/safe-array-concat/-/safe-array-concat-1.0.0.tgz -> npmpkg-safe-array-concat-1.0.0.tgz
https://registry.npmjs.org/isarray/-/isarray-2.0.5.tgz -> npmpkg-isarray-2.0.5.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/safe-regex/-/safe-regex-1.1.0.tgz -> npmpkg-safe-regex-1.1.0.tgz
https://registry.npmjs.org/safe-regex-test/-/safe-regex-test-1.0.0.tgz -> npmpkg-safe-regex-test-1.0.0.tgz
https://registry.npmjs.org/safer-buffer/-/safer-buffer-2.1.2.tgz -> npmpkg-safer-buffer-2.1.2.tgz
https://registry.npmjs.org/sane/-/sane-2.5.2.tgz -> npmpkg-sane-2.5.2.tgz
https://registry.npmjs.org/braces/-/braces-2.3.2.tgz -> npmpkg-braces-2.3.2.tgz
https://registry.npmjs.org/fill-range/-/fill-range-4.0.0.tgz -> npmpkg-fill-range-4.0.0.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-1.0.1.tgz -> npmpkg-is-extendable-1.0.1.tgz
https://registry.npmjs.org/is-number/-/is-number-3.0.0.tgz -> npmpkg-is-number-3.0.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/micromatch/-/micromatch-3.1.10.tgz -> npmpkg-micromatch-3.1.10.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-3.0.2.tgz -> npmpkg-extend-shallow-3.0.2.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-2.1.1.tgz -> npmpkg-to-regex-range-2.1.1.tgz
https://registry.npmjs.org/sax/-/sax-1.2.4.tgz -> npmpkg-sax-1.2.4.tgz
https://registry.npmjs.org/semver/-/semver-5.7.1.tgz -> npmpkg-semver-5.7.1.tgz
https://registry.npmjs.org/set-blocking/-/set-blocking-2.0.0.tgz -> npmpkg-set-blocking-2.0.0.tgz
https://registry.npmjs.org/set-value/-/set-value-2.0.1.tgz -> npmpkg-set-value-2.0.1.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-1.2.0.tgz -> npmpkg-shebang-command-1.2.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-1.0.0.tgz -> npmpkg-shebang-regex-1.0.0.tgz
https://registry.npmjs.org/shelljs/-/shelljs-0.8.5.tgz -> npmpkg-shelljs-0.8.5.tgz
https://registry.npmjs.org/rechoir/-/rechoir-0.6.2.tgz -> npmpkg-rechoir-0.6.2.tgz
https://registry.npmjs.org/shellwords/-/shellwords-0.1.1.tgz -> npmpkg-shellwords-0.1.1.tgz
https://registry.npmjs.org/side-channel/-/side-channel-1.0.4.tgz -> npmpkg-side-channel-1.0.4.tgz
https://registry.npmjs.org/sigmund/-/sigmund-1.0.1.tgz -> npmpkg-sigmund-1.0.1.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-3.0.7.tgz -> npmpkg-signal-exit-3.0.7.tgz
https://registry.npmjs.org/simple-concat/-/simple-concat-1.0.1.tgz -> npmpkg-simple-concat-1.0.1.tgz
https://registry.npmjs.org/simple-get/-/simple-get-3.1.1.tgz -> npmpkg-simple-get-3.1.1.tgz
https://registry.npmjs.org/sisteransi/-/sisteransi-0.1.1.tgz -> npmpkg-sisteransi-0.1.1.tgz
https://registry.npmjs.org/slash/-/slash-1.0.0.tgz -> npmpkg-slash-1.0.0.tgz
https://registry.npmjs.org/snapdragon/-/snapdragon-0.8.2.tgz -> npmpkg-snapdragon-0.8.2.tgz
https://registry.npmjs.org/snapdragon-node/-/snapdragon-node-2.1.1.tgz -> npmpkg-snapdragon-node-2.1.1.tgz
https://registry.npmjs.org/define-property/-/define-property-1.0.0.tgz -> npmpkg-define-property-1.0.0.tgz
https://registry.npmjs.org/snapdragon-util/-/snapdragon-util-3.0.1.tgz -> npmpkg-snapdragon-util-3.0.1.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz -> npmpkg-is-accessor-descriptor-0.1.6.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz -> npmpkg-is-data-descriptor-0.1.4.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.6.tgz -> npmpkg-is-descriptor-0.1.6.tgz
https://registry.npmjs.org/kind-of/-/kind-of-5.1.0.tgz -> npmpkg-kind-of-5.1.0.tgz
https://registry.npmjs.org/source-map/-/source-map-0.5.7.tgz -> npmpkg-source-map-0.5.7.tgz
https://registry.npmjs.org/source-map-resolve/-/source-map-resolve-0.5.3.tgz -> npmpkg-source-map-resolve-0.5.3.tgz
https://registry.npmjs.org/source-map-support/-/source-map-support-0.4.18.tgz -> npmpkg-source-map-support-0.4.18.tgz
https://registry.npmjs.org/source-map-url/-/source-map-url-0.4.1.tgz -> npmpkg-source-map-url-0.4.1.tgz
https://registry.npmjs.org/spdx-correct/-/spdx-correct-3.2.0.tgz -> npmpkg-spdx-correct-3.2.0.tgz
https://registry.npmjs.org/spdx-exceptions/-/spdx-exceptions-2.3.0.tgz -> npmpkg-spdx-exceptions-2.3.0.tgz
https://registry.npmjs.org/spdx-expression-parse/-/spdx-expression-parse-3.0.1.tgz -> npmpkg-spdx-expression-parse-3.0.1.tgz
https://registry.npmjs.org/spdx-license-ids/-/spdx-license-ids-3.0.13.tgz -> npmpkg-spdx-license-ids-3.0.13.tgz
https://registry.npmjs.org/split-string/-/split-string-3.1.0.tgz -> npmpkg-split-string-3.1.0.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-3.0.2.tgz -> npmpkg-extend-shallow-3.0.2.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-1.0.1.tgz -> npmpkg-is-extendable-1.0.1.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.0.3.tgz -> npmpkg-sprintf-js-1.0.3.tgz
https://registry.npmjs.org/sshpk/-/sshpk-1.17.0.tgz -> npmpkg-sshpk-1.17.0.tgz
https://registry.npmjs.org/stack-trace/-/stack-trace-0.0.10.tgz -> npmpkg-stack-trace-0.0.10.tgz
https://registry.npmjs.org/stack-utils/-/stack-utils-1.0.5.tgz -> npmpkg-stack-utils-1.0.5.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-2.0.0.tgz -> npmpkg-escape-string-regexp-2.0.0.tgz
https://registry.npmjs.org/static-extend/-/static-extend-0.1.2.tgz -> npmpkg-static-extend-0.1.2.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz -> npmpkg-is-accessor-descriptor-0.1.6.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz -> npmpkg-is-data-descriptor-0.1.4.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.6.tgz -> npmpkg-is-descriptor-0.1.6.tgz
https://registry.npmjs.org/kind-of/-/kind-of-5.1.0.tgz -> npmpkg-kind-of-5.1.0.tgz
https://registry.npmjs.org/stealthy-require/-/stealthy-require-1.1.1.tgz -> npmpkg-stealthy-require-1.1.1.tgz
https://registry.npmjs.org/stream-buffers/-/stream-buffers-2.2.0.tgz -> npmpkg-stream-buffers-2.2.0.tgz
https://registry.npmjs.org/stream-concat/-/stream-concat-0.1.1.tgz -> npmpkg-stream-concat-0.1.1.tgz
https://registry.npmjs.org/stream-shift/-/stream-shift-1.0.1.tgz -> npmpkg-stream-shift-1.0.1.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-1.1.1.tgz -> npmpkg-string_decoder-1.1.1.tgz
https://registry.npmjs.org/string-length/-/string-length-2.0.0.tgz -> npmpkg-string-length-2.0.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-3.0.1.tgz -> npmpkg-ansi-regex-3.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-4.0.0.tgz -> npmpkg-strip-ansi-4.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-1.0.2.tgz -> npmpkg-string-width-1.0.2.tgz
https://registry.npmjs.org/string.prototype.trim/-/string.prototype.trim-1.2.7.tgz -> npmpkg-string.prototype.trim-1.2.7.tgz
https://registry.npmjs.org/string.prototype.trimend/-/string.prototype.trimend-1.0.6.tgz -> npmpkg-string.prototype.trimend-1.0.6.tgz
https://registry.npmjs.org/string.prototype.trimstart/-/string.prototype.trimstart-1.0.6.tgz -> npmpkg-string.prototype.trimstart-1.0.6.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-3.0.1.tgz -> npmpkg-strip-ansi-3.0.1.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-2.0.0.tgz -> npmpkg-strip-bom-2.0.0.tgz
https://registry.npmjs.org/strip-bom-stream/-/strip-bom-stream-1.0.0.tgz -> npmpkg-strip-bom-stream-1.0.0.tgz
https://registry.npmjs.org/strip-eof/-/strip-eof-1.0.0.tgz -> npmpkg-strip-eof-1.0.0.tgz
https://registry.npmjs.org/strip-indent/-/strip-indent-1.0.1.tgz -> npmpkg-strip-indent-1.0.1.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-2.0.1.tgz -> npmpkg-strip-json-comments-2.0.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-2.0.0.tgz -> npmpkg-supports-color-2.0.0.tgz
https://registry.npmjs.org/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz -> npmpkg-supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.npmjs.org/symbol-tree/-/symbol-tree-3.2.4.tgz -> npmpkg-symbol-tree-3.2.4.tgz
https://registry.npmjs.org/tar-fs/-/tar-fs-2.1.1.tgz -> npmpkg-tar-fs-2.1.1.tgz
https://registry.npmjs.org/bl/-/bl-4.1.0.tgz -> npmpkg-bl-4.1.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/tar-stream/-/tar-stream-2.2.0.tgz -> npmpkg-tar-stream-2.2.0.tgz
https://registry.npmjs.org/tar-stream/-/tar-stream-1.6.2.tgz -> npmpkg-tar-stream-1.6.2.tgz
https://registry.npmjs.org/test-exclude/-/test-exclude-4.2.3.tgz -> npmpkg-test-exclude-4.2.3.tgz
https://registry.npmjs.org/arr-diff/-/arr-diff-2.0.0.tgz -> npmpkg-arr-diff-2.0.0.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.2.1.tgz -> npmpkg-array-unique-0.2.1.tgz
https://registry.npmjs.org/braces/-/braces-1.8.5.tgz -> npmpkg-braces-1.8.5.tgz
https://registry.npmjs.org/expand-brackets/-/expand-brackets-0.1.5.tgz -> npmpkg-expand-brackets-0.1.5.tgz
https://registry.npmjs.org/extglob/-/extglob-0.3.2.tgz -> npmpkg-extglob-0.3.2.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-1.0.0.tgz -> npmpkg-is-extglob-1.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-2.0.1.tgz -> npmpkg-is-glob-2.0.1.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/micromatch/-/micromatch-2.3.11.tgz -> npmpkg-micromatch-2.3.11.tgz
https://registry.npmjs.org/throat/-/throat-4.1.0.tgz -> npmpkg-throat-4.1.0.tgz
https://registry.npmjs.org/through2/-/through2-2.0.5.tgz -> npmpkg-through2-2.0.5.tgz
https://registry.npmjs.org/through2-filter/-/through2-filter-2.0.0.tgz -> npmpkg-through2-filter-2.0.0.tgz
https://registry.npmjs.org/tmpl/-/tmpl-1.0.5.tgz -> npmpkg-tmpl-1.0.5.tgz
https://registry.npmjs.org/to-absolute-glob/-/to-absolute-glob-0.1.1.tgz -> npmpkg-to-absolute-glob-0.1.1.tgz
https://registry.npmjs.org/to-buffer/-/to-buffer-1.1.1.tgz -> npmpkg-to-buffer-1.1.1.tgz
https://registry.npmjs.org/to-fast-properties/-/to-fast-properties-1.0.3.tgz -> npmpkg-to-fast-properties-1.0.3.tgz
https://registry.npmjs.org/to-object-path/-/to-object-path-0.3.0.tgz -> npmpkg-to-object-path-0.3.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/to-regex/-/to-regex-3.0.2.tgz -> npmpkg-to-regex-3.0.2.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-3.0.2.tgz -> npmpkg-extend-shallow-3.0.2.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-1.0.1.tgz -> npmpkg-is-extendable-1.0.1.tgz
https://registry.npmjs.org/tough-cookie/-/tough-cookie-2.5.0.tgz -> npmpkg-tough-cookie-2.5.0.tgz
https://registry.npmjs.org/tr46/-/tr46-1.0.1.tgz -> npmpkg-tr46-1.0.1.tgz
https://registry.npmjs.org/trim-newlines/-/trim-newlines-1.0.0.tgz -> npmpkg-trim-newlines-1.0.0.tgz
https://registry.npmjs.org/trim-right/-/trim-right-1.0.1.tgz -> npmpkg-trim-right-1.0.1.tgz
https://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.6.0.tgz -> npmpkg-tunnel-agent-0.6.0.tgz
https://registry.npmjs.org/tweetnacl/-/tweetnacl-0.14.5.tgz -> npmpkg-tweetnacl-0.14.5.tgz
https://registry.npmjs.org/type-check/-/type-check-0.3.2.tgz -> npmpkg-type-check-0.3.2.tgz
https://registry.npmjs.org/typed-array-length/-/typed-array-length-1.0.4.tgz -> npmpkg-typed-array-length-1.0.4.tgz
https://registry.npmjs.org/typedarray/-/typedarray-0.0.6.tgz -> npmpkg-typedarray-0.0.6.tgz
https://registry.npmjs.org/uglify-js/-/uglify-js-2.8.29.tgz -> npmpkg-uglify-js-2.8.29.tgz
https://registry.npmjs.org/camelcase/-/camelcase-1.2.1.tgz -> npmpkg-camelcase-1.2.1.tgz
https://registry.npmjs.org/cliui/-/cliui-2.1.0.tgz -> npmpkg-cliui-2.1.0.tgz
https://registry.npmjs.org/wordwrap/-/wordwrap-0.0.2.tgz -> npmpkg-wordwrap-0.0.2.tgz
https://registry.npmjs.org/yargs/-/yargs-3.10.0.tgz -> npmpkg-yargs-3.10.0.tgz
https://registry.npmjs.org/uglify-to-browserify/-/uglify-to-browserify-1.0.2.tgz -> npmpkg-uglify-to-browserify-1.0.2.tgz
https://registry.npmjs.org/unbox-primitive/-/unbox-primitive-1.0.2.tgz -> npmpkg-unbox-primitive-1.0.2.tgz
https://registry.npmjs.org/unc-path-regex/-/unc-path-regex-0.1.2.tgz -> npmpkg-unc-path-regex-0.1.2.tgz
https://registry.npmjs.org/underscore.string/-/underscore.string-3.3.6.tgz -> npmpkg-underscore.string-3.3.6.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.1.2.tgz -> npmpkg-sprintf-js-1.1.2.tgz
https://registry.npmjs.org/union-value/-/union-value-1.0.1.tgz -> npmpkg-union-value-1.0.1.tgz
https://registry.npmjs.org/unique-stream/-/unique-stream-2.3.1.tgz -> npmpkg-unique-stream-2.3.1.tgz
https://registry.npmjs.org/through2-filter/-/through2-filter-3.0.0.tgz -> npmpkg-through2-filter-3.0.0.tgz
https://registry.npmjs.org/unset-value/-/unset-value-1.0.0.tgz -> npmpkg-unset-value-1.0.0.tgz
https://registry.npmjs.org/has-value/-/has-value-0.3.1.tgz -> npmpkg-has-value-0.3.1.tgz
https://registry.npmjs.org/isobject/-/isobject-2.1.0.tgz -> npmpkg-isobject-2.1.0.tgz
https://registry.npmjs.org/has-values/-/has-values-0.1.4.tgz -> npmpkg-has-values-0.1.4.tgz
https://registry.npmjs.org/uri-js/-/uri-js-4.4.1.tgz -> npmpkg-uri-js-4.4.1.tgz
https://registry.npmjs.org/uri-path/-/uri-path-1.0.0.tgz -> npmpkg-uri-path-1.0.0.tgz
https://registry.npmjs.org/urix/-/urix-0.1.0.tgz -> npmpkg-urix-0.1.0.tgz
https://registry.npmjs.org/use/-/use-3.1.1.tgz -> npmpkg-use-3.1.1.tgz
https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz -> npmpkg-util-deprecate-1.0.2.tgz
https://registry.npmjs.org/util.promisify/-/util.promisify-1.1.2.tgz -> npmpkg-util.promisify-1.1.2.tgz
https://registry.npmjs.org/uuid/-/uuid-3.4.0.tgz -> npmpkg-uuid-3.4.0.tgz
https://registry.npmjs.org/v8flags/-/v8flags-3.2.0.tgz -> npmpkg-v8flags-3.2.0.tgz
https://registry.npmjs.org/vali-date/-/vali-date-1.0.0.tgz -> npmpkg-vali-date-1.0.0.tgz
https://registry.npmjs.org/validate-npm-package-license/-/validate-npm-package-license-3.0.4.tgz -> npmpkg-validate-npm-package-license-3.0.4.tgz
https://registry.npmjs.org/verror/-/verror-1.10.0.tgz -> npmpkg-verror-1.10.0.tgz
https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.2.tgz -> npmpkg-core-util-is-1.0.2.tgz
https://registry.npmjs.org/vinyl/-/vinyl-1.2.0.tgz -> npmpkg-vinyl-1.2.0.tgz
https://registry.npmjs.org/vinyl-fs/-/vinyl-fs-2.4.4.tgz -> npmpkg-vinyl-fs-2.4.4.tgz
https://registry.npmjs.org/w3c-hr-time/-/w3c-hr-time-1.0.2.tgz -> npmpkg-w3c-hr-time-1.0.2.tgz
https://registry.npmjs.org/walkdir/-/walkdir-0.0.11.tgz -> npmpkg-walkdir-0.0.11.tgz
https://registry.npmjs.org/walker/-/walker-1.0.8.tgz -> npmpkg-walker-1.0.8.tgz
https://registry.npmjs.org/watch/-/watch-0.18.0.tgz -> npmpkg-watch-0.18.0.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-4.0.2.tgz -> npmpkg-webidl-conversions-4.0.2.tgz
https://registry.npmjs.org/whatwg-encoding/-/whatwg-encoding-1.0.5.tgz -> npmpkg-whatwg-encoding-1.0.5.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.4.24.tgz -> npmpkg-iconv-lite-0.4.24.tgz
https://registry.npmjs.org/whatwg-mimetype/-/whatwg-mimetype-2.3.0.tgz -> npmpkg-whatwg-mimetype-2.3.0.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-6.5.0.tgz -> npmpkg-whatwg-url-6.5.0.tgz
https://registry.npmjs.org/whatwg-url-compat/-/whatwg-url-compat-0.6.5.tgz -> npmpkg-whatwg-url-compat-0.6.5.tgz
https://registry.npmjs.org/tr46/-/tr46-0.0.3.tgz -> npmpkg-tr46-0.0.3.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/which-boxed-primitive/-/which-boxed-primitive-1.0.2.tgz -> npmpkg-which-boxed-primitive-1.0.2.tgz
https://registry.npmjs.org/which-module/-/which-module-2.0.1.tgz -> npmpkg-which-module-2.0.1.tgz
https://registry.npmjs.org/which-pm-runs/-/which-pm-runs-1.1.0.tgz -> npmpkg-which-pm-runs-1.1.0.tgz
https://registry.npmjs.org/which-typed-array/-/which-typed-array-1.1.9.tgz -> npmpkg-which-typed-array-1.1.9.tgz
https://registry.npmjs.org/wide-align/-/wide-align-1.1.5.tgz -> npmpkg-wide-align-1.1.5.tgz
https://registry.npmjs.org/window-size/-/window-size-0.1.0.tgz -> npmpkg-window-size-0.1.0.tgz
https://registry.npmjs.org/winston/-/winston-2.4.7.tgz -> npmpkg-winston-2.4.7.tgz
https://registry.npmjs.org/async/-/async-2.6.4.tgz -> npmpkg-async-2.6.4.tgz
https://registry.npmjs.org/colors/-/colors-1.0.3.tgz -> npmpkg-colors-1.0.3.tgz
https://registry.npmjs.org/word-wrap/-/word-wrap-1.2.3.tgz -> npmpkg-word-wrap-1.2.3.tgz
https://registry.npmjs.org/wordwrap/-/wordwrap-1.0.0.tgz -> npmpkg-wordwrap-1.0.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-2.1.0.tgz -> npmpkg-wrap-ansi-2.1.0.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
https://registry.npmjs.org/write-file-atomic/-/write-file-atomic-2.4.3.tgz -> npmpkg-write-file-atomic-2.4.3.tgz
https://registry.npmjs.org/ws/-/ws-5.2.3.tgz -> npmpkg-ws-5.2.3.tgz
https://registry.npmjs.org/xml-name-validator/-/xml-name-validator-3.0.0.tgz -> npmpkg-xml-name-validator-3.0.0.tgz
https://registry.npmjs.org/xtend/-/xtend-4.0.2.tgz -> npmpkg-xtend-4.0.2.tgz
https://registry.npmjs.org/y18n/-/y18n-3.2.2.tgz -> npmpkg-y18n-3.2.2.tgz
https://registry.npmjs.org/yargs/-/yargs-11.1.1.tgz -> npmpkg-yargs-11.1.1.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-9.0.2.tgz -> npmpkg-yargs-parser-9.0.2.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-3.0.1.tgz -> npmpkg-ansi-regex-3.0.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-2.1.1.tgz -> npmpkg-string-width-2.1.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-4.0.0.tgz -> npmpkg-strip-ansi-4.0.0.tgz
https://registry.npmjs.org/zip-stream/-/zip-stream-1.2.0.tgz -> npmpkg-zip-stream-1.2.0.tgz
https://registry.npmjs.org/@electron/get/-/get-1.14.1.tgz -> npmpkg-@electron-get-1.14.1.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-4.0.0.tgz -> npmpkg-jsonfile-4.0.0.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/@electron/remote/-/remote-2.0.8.tgz -> npmpkg-@electron-remote-2.0.8.tgz
https://registry.npmjs.org/@sindresorhus/is/-/is-0.14.0.tgz -> npmpkg-@sindresorhus-is-0.14.0.tgz
https://registry.npmjs.org/@szmarczak/http-timer/-/http-timer-1.1.2.tgz -> npmpkg-@szmarczak-http-timer-1.1.2.tgz
https://registry.npmjs.org/@types/node/-/node-16.11.47.tgz -> npmpkg-@types-node-16.11.47.tgz
https://registry.npmjs.org/@types/semver/-/semver-6.2.0.tgz -> npmpkg-@types-semver-6.2.0.tgz
https://registry.npmjs.org/@types/yauzl/-/yauzl-2.10.0.tgz -> npmpkg-@types-yauzl-2.10.0.tgz
https://registry.npmjs.org/accepts/-/accepts-1.3.4.tgz -> npmpkg-accepts-1.3.4.tgz
https://registry.npmjs.org/ajv/-/ajv-5.5.2.tgz -> npmpkg-ajv-5.5.2.tgz
https://registry.npmjs.org/anymatch/-/anymatch-3.1.2.tgz -> npmpkg-anymatch-3.1.2.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz -> npmpkg-normalize-path-3.0.0.tgz
https://registry.npmjs.org/apache-crypt/-/apache-crypt-1.2.1.tgz -> npmpkg-apache-crypt-1.2.1.tgz
https://registry.npmjs.org/apache-md5/-/apache-md5-1.1.2.tgz -> npmpkg-apache-md5-1.1.2.tgz
https://registry.npmjs.org/archiver/-/archiver-2.1.1.tgz -> npmpkg-archiver-2.1.1.tgz
https://registry.npmjs.org/archiver-utils/-/archiver-utils-1.3.0.tgz -> npmpkg-archiver-utils-1.3.0.tgz
https://registry.npmjs.org/argparse/-/argparse-1.0.10.tgz -> npmpkg-argparse-1.0.10.tgz
https://registry.npmjs.org/arr-diff/-/arr-diff-2.0.0.tgz -> npmpkg-arr-diff-2.0.0.tgz
https://registry.npmjs.org/arr-flatten/-/arr-flatten-1.1.0.tgz -> npmpkg-arr-flatten-1.1.0.tgz
https://registry.npmjs.org/arr-union/-/arr-union-3.1.0.tgz -> npmpkg-arr-union-3.1.0.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.2.1.tgz -> npmpkg-array-unique-0.2.1.tgz
https://registry.npmjs.org/asn1/-/asn1-0.2.3.tgz -> npmpkg-asn1-0.2.3.tgz
https://registry.npmjs.org/assert-plus/-/assert-plus-1.0.0.tgz -> npmpkg-assert-plus-1.0.0.tgz
https://registry.npmjs.org/assign-symbols/-/assign-symbols-1.0.0.tgz -> npmpkg-assign-symbols-1.0.0.tgz
https://registry.npmjs.org/async/-/async-2.6.0.tgz -> npmpkg-async-2.6.0.tgz
https://registry.npmjs.org/async-each/-/async-each-1.0.3.tgz -> npmpkg-async-each-1.0.3.tgz
https://registry.npmjs.org/async-limiter/-/async-limiter-1.0.0.tgz -> npmpkg-async-limiter-1.0.0.tgz
https://registry.npmjs.org/asynckit/-/asynckit-0.4.0.tgz -> npmpkg-asynckit-0.4.0.tgz
https://registry.npmjs.org/atob/-/atob-2.1.2.tgz -> npmpkg-atob-2.1.2.tgz
https://registry.npmjs.org/aws-sign2/-/aws-sign2-0.7.0.tgz -> npmpkg-aws-sign2-0.7.0.tgz
https://registry.npmjs.org/aws4/-/aws4-1.6.0.tgz -> npmpkg-aws4-1.6.0.tgz
https://registry.npmjs.org/axios/-/axios-0.19.1.tgz -> npmpkg-axios-0.19.1.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.0.tgz -> npmpkg-balanced-match-1.0.0.tgz
https://registry.npmjs.org/base/-/base-0.11.2.tgz -> npmpkg-base-0.11.2.tgz
https://registry.npmjs.org/define-property/-/define-property-1.0.0.tgz -> npmpkg-define-property-1.0.0.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-1.0.0.tgz -> npmpkg-is-accessor-descriptor-1.0.0.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-1.0.0.tgz -> npmpkg-is-data-descriptor-1.0.0.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-1.0.2.tgz -> npmpkg-is-descriptor-1.0.2.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/basic-auth/-/basic-auth-2.0.0.tgz -> npmpkg-basic-auth-2.0.0.tgz
https://registry.npmjs.org/batch/-/batch-0.6.1.tgz -> npmpkg-batch-0.6.1.tgz
https://registry.npmjs.org/bcrypt-pbkdf/-/bcrypt-pbkdf-1.0.1.tgz -> npmpkg-bcrypt-pbkdf-1.0.1.tgz
https://registry.npmjs.org/bcryptjs/-/bcryptjs-2.4.3.tgz -> npmpkg-bcryptjs-2.4.3.tgz
https://registry.npmjs.org/bignumber.js/-/bignumber.js-2.4.0.tgz -> npmpkg-bignumber.js-2.4.0.tgz
https://registry.npmjs.org/binary-extensions/-/binary-extensions-2.2.0.tgz -> npmpkg-binary-extensions-2.2.0.tgz
https://registry.npmjs.org/bindings/-/bindings-1.5.0.tgz -> npmpkg-bindings-1.5.0.tgz
https://registry.npmjs.org/bl/-/bl-1.2.1.tgz -> npmpkg-bl-1.2.1.tgz
https://registry.npmjs.org/bmp-js/-/bmp-js-0.0.3.tgz -> npmpkg-bmp-js-0.0.3.tgz
https://registry.npmjs.org/boolean/-/boolean-3.2.0.tgz -> npmpkg-boolean-3.2.0.tgz
https://registry.npmjs.org/boom/-/boom-4.3.1.tgz -> npmpkg-boom-4.3.1.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.8.tgz -> npmpkg-brace-expansion-1.1.8.tgz
https://registry.npmjs.org/braces/-/braces-3.0.2.tgz -> npmpkg-braces-3.0.2.tgz
https://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.2.13.tgz -> npmpkg-buffer-crc32-0.2.13.tgz
https://registry.npmjs.org/buffer-equal/-/buffer-equal-0.0.1.tgz -> npmpkg-buffer-equal-0.0.1.tgz
https://registry.npmjs.org/builder-util-runtime/-/builder-util-runtime-8.4.0.tgz -> npmpkg-builder-util-runtime-8.4.0.tgz
https://registry.npmjs.org/debug/-/debug-4.1.1.tgz -> npmpkg-debug-4.1.1.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/sax/-/sax-1.2.4.tgz -> npmpkg-sax-1.2.4.tgz
https://registry.npmjs.org/cache-base/-/cache-base-1.0.1.tgz -> npmpkg-cache-base-1.0.1.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/cacheable-request/-/cacheable-request-6.1.0.tgz -> npmpkg-cacheable-request-6.1.0.tgz
https://registry.npmjs.org/lowercase-keys/-/lowercase-keys-2.0.0.tgz -> npmpkg-lowercase-keys-2.0.0.tgz
https://registry.npmjs.org/caseless/-/caseless-0.12.0.tgz -> npmpkg-caseless-0.12.0.tgz
https://registry.npmjs.org/chokidar/-/chokidar-3.5.1.tgz -> npmpkg-chokidar-3.5.1.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz -> npmpkg-normalize-path-3.0.0.tgz
https://registry.npmjs.org/class-utils/-/class-utils-0.3.6.tgz -> npmpkg-class-utils-0.3.6.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/clone-response/-/clone-response-1.0.3.tgz -> npmpkg-clone-response-1.0.3.tgz
https://registry.npmjs.org/co/-/co-4.6.0.tgz -> npmpkg-co-4.6.0.tgz
https://registry.npmjs.org/collection-visit/-/collection-visit-1.0.0.tgz -> npmpkg-collection-visit-1.0.0.tgz
https://registry.npmjs.org/colors/-/colors-1.1.2.tgz -> npmpkg-colors-1.1.2.tgz
https://registry.npmjs.org/combined-stream/-/combined-stream-1.0.5.tgz -> npmpkg-combined-stream-1.0.5.tgz
https://registry.npmjs.org/component-emitter/-/component-emitter-1.3.0.tgz -> npmpkg-component-emitter-1.3.0.tgz
https://registry.npmjs.org/compress-commons/-/compress-commons-1.2.2.tgz -> npmpkg-compress-commons-1.2.2.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/config-chain/-/config-chain-1.1.13.tgz -> npmpkg-config-chain-1.1.13.tgz
https://registry.npmjs.org/connect/-/connect-3.5.1.tgz -> npmpkg-connect-3.5.1.tgz
https://registry.npmjs.org/debug/-/debug-2.2.0.tgz -> npmpkg-debug-2.2.0.tgz
https://registry.npmjs.org/ms/-/ms-0.7.1.tgz -> npmpkg-ms-0.7.1.tgz
https://registry.npmjs.org/copy-descriptor/-/copy-descriptor-0.1.1.tgz -> npmpkg-copy-descriptor-0.1.1.tgz
https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.2.tgz -> npmpkg-core-util-is-1.0.2.tgz
https://registry.npmjs.org/cors/-/cors-2.8.4.tgz -> npmpkg-cors-2.8.4.tgz
https://registry.npmjs.org/crc/-/crc-3.5.0.tgz -> npmpkg-crc-3.5.0.tgz
https://registry.npmjs.org/crc32-stream/-/crc32-stream-2.0.0.tgz -> npmpkg-crc32-stream-2.0.0.tgz
https://registry.npmjs.org/cryptiles/-/cryptiles-3.1.2.tgz -> npmpkg-cryptiles-3.1.2.tgz
https://registry.npmjs.org/boom/-/boom-5.2.0.tgz -> npmpkg-boom-5.2.0.tgz
https://registry.npmjs.org/dashdash/-/dashdash-1.14.1.tgz -> npmpkg-dashdash-1.14.1.tgz
https://registry.npmjs.org/debug/-/debug-3.1.0.tgz -> npmpkg-debug-3.1.0.tgz
https://registry.npmjs.org/decode-uri-component/-/decode-uri-component-0.2.0.tgz -> npmpkg-decode-uri-component-0.2.0.tgz
https://registry.npmjs.org/decompress-response/-/decompress-response-3.3.0.tgz -> npmpkg-decompress-response-3.3.0.tgz
https://registry.npmjs.org/defer-to-connect/-/defer-to-connect-1.1.3.tgz -> npmpkg-defer-to-connect-1.1.3.tgz
https://registry.npmjs.org/define-properties/-/define-properties-1.1.4.tgz -> npmpkg-define-properties-1.1.4.tgz
https://registry.npmjs.org/define-property/-/define-property-2.0.2.tgz -> npmpkg-define-property-2.0.2.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-1.0.0.tgz -> npmpkg-is-accessor-descriptor-1.0.0.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-1.0.0.tgz -> npmpkg-is-data-descriptor-1.0.0.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-1.0.2.tgz -> npmpkg-is-descriptor-1.0.2.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz -> npmpkg-delayed-stream-1.0.0.tgz
https://registry.npmjs.org/depd/-/depd-1.1.2.tgz -> npmpkg-depd-1.1.2.tgz
https://registry.npmjs.org/destroy/-/destroy-1.0.4.tgz -> npmpkg-destroy-1.0.4.tgz
https://registry.npmjs.org/detect-node/-/detect-node-2.1.0.tgz -> npmpkg-detect-node-2.1.0.tgz
https://registry.npmjs.org/discord-rich-presence/-/discord-rich-presence-0.0.8.tgz -> npmpkg-discord-rich-presence-0.0.8.tgz
https://registry.npmjs.org/node-fetch/-/node-fetch-2.6.1.tgz -> npmpkg-node-fetch-2.6.1.tgz
https://registry.npmjs.org/ws/-/ws-7.1.2.tgz -> npmpkg-ws-7.1.2.tgz
https://registry.npmjs.org/dom-walk/-/dom-walk-0.1.1.tgz -> npmpkg-dom-walk-0.1.1.tgz
https://registry.npmjs.org/dotenv/-/dotenv-4.0.0.tgz -> npmpkg-dotenv-4.0.0.tgz
https://registry.npmjs.org/duplexer/-/duplexer-0.1.1.tgz -> npmpkg-duplexer-0.1.1.tgz
https://registry.npmjs.org/duplexer3/-/duplexer3-0.1.5.tgz -> npmpkg-duplexer3-0.1.5.tgz
https://registry.npmjs.org/ecc-jsbn/-/ecc-jsbn-0.1.1.tgz -> npmpkg-ecc-jsbn-0.1.1.tgz
https://registry.npmjs.org/ee-first/-/ee-first-1.1.1.tgz -> npmpkg-ee-first-1.1.1.tgz
https://registry.npmjs.org/electron/-/electron-20.0.1.tgz -> npmpkg-electron-20.0.1.tgz
https://registry.npmjs.org/electron-editor-context-menu/-/electron-editor-context-menu-1.1.1.tgz -> npmpkg-electron-editor-context-menu-1.1.1.tgz
https://registry.npmjs.org/electron-is/-/electron-is-2.4.0.tgz -> npmpkg-electron-is-2.4.0.tgz
https://registry.npmjs.org/electron-is-dev/-/electron-is-dev-0.1.2.tgz -> npmpkg-electron-is-dev-0.1.2.tgz
https://registry.npmjs.org/electron-log/-/electron-log-4.1.1.tgz -> npmpkg-electron-log-4.1.1.tgz
https://registry.npmjs.org/electron-updater/-/electron-updater-4.2.0.tgz -> npmpkg-electron-updater-4.2.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-4.0.0.tgz -> npmpkg-jsonfile-4.0.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/encodeurl/-/encodeurl-1.0.2.tgz -> npmpkg-encodeurl-1.0.2.tgz
https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.4.1.tgz -> npmpkg-end-of-stream-1.4.1.tgz
https://registry.npmjs.org/env-paths/-/env-paths-2.2.1.tgz -> npmpkg-env-paths-2.2.1.tgz
https://registry.npmjs.org/es6-error/-/es6-error-4.1.1.tgz -> npmpkg-es6-error-4.1.1.tgz
https://registry.npmjs.org/es6-promise/-/es6-promise-3.3.1.tgz -> npmpkg-es6-promise-3.3.1.tgz
https://registry.npmjs.org/escape-html/-/escape-html-1.0.3.tgz -> npmpkg-escape-html-1.0.3.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz -> npmpkg-escape-string-regexp-4.0.0.tgz
https://registry.npmjs.org/esprima/-/esprima-4.0.1.tgz -> npmpkg-esprima-4.0.1.tgz
https://registry.npmjs.org/etag/-/etag-1.8.1.tgz -> npmpkg-etag-1.8.1.tgz
https://registry.npmjs.org/event-stream/-/event-stream-3.3.4.tgz -> npmpkg-event-stream-3.3.4.tgz
https://registry.npmjs.org/exif-parser/-/exif-parser-0.1.12.tgz -> npmpkg-exif-parser-0.1.12.tgz
https://registry.npmjs.org/expand-brackets/-/expand-brackets-0.1.5.tgz -> npmpkg-expand-brackets-0.1.5.tgz
https://registry.npmjs.org/expand-range/-/expand-range-1.8.2.tgz -> npmpkg-expand-range-1.8.2.tgz
https://registry.npmjs.org/fill-range/-/fill-range-2.2.4.tgz -> npmpkg-fill-range-2.2.4.tgz
https://registry.npmjs.org/is-number/-/is-number-2.1.0.tgz -> npmpkg-is-number-2.1.0.tgz
https://registry.npmjs.org/extend/-/extend-3.0.1.tgz -> npmpkg-extend-3.0.1.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-3.0.2.tgz -> npmpkg-extend-shallow-3.0.2.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-1.0.1.tgz -> npmpkg-is-extendable-1.0.1.tgz
https://registry.npmjs.org/extglob/-/extglob-0.3.2.tgz -> npmpkg-extglob-0.3.2.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-1.0.0.tgz -> npmpkg-is-extglob-1.0.0.tgz
https://registry.npmjs.org/extract-zip/-/extract-zip-2.0.1.tgz -> npmpkg-extract-zip-2.0.1.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/extsprintf/-/extsprintf-1.3.0.tgz -> npmpkg-extsprintf-1.3.0.tgz
https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-1.0.0.tgz -> npmpkg-fast-deep-equal-1.0.0.tgz
https://registry.npmjs.org/fast-json-stable-stringify/-/fast-json-stable-stringify-2.0.0.tgz -> npmpkg-fast-json-stable-stringify-2.0.0.tgz
https://registry.npmjs.org/faye-websocket/-/faye-websocket-0.11.1.tgz -> npmpkg-faye-websocket-0.11.1.tgz
https://registry.npmjs.org/fd-slicer/-/fd-slicer-1.1.0.tgz -> npmpkg-fd-slicer-1.1.0.tgz
https://registry.npmjs.org/file-type/-/file-type-3.9.0.tgz -> npmpkg-file-type-3.9.0.tgz
https://registry.npmjs.org/file-uri-to-path/-/file-uri-to-path-1.0.0.tgz -> npmpkg-file-uri-to-path-1.0.0.tgz
https://registry.npmjs.org/filename-regex/-/filename-regex-2.0.1.tgz -> npmpkg-filename-regex-2.0.1.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.0.1.tgz -> npmpkg-fill-range-7.0.1.tgz
https://registry.npmjs.org/finalhandler/-/finalhandler-0.5.1.tgz -> npmpkg-finalhandler-0.5.1.tgz
https://registry.npmjs.org/debug/-/debug-2.2.0.tgz -> npmpkg-debug-2.2.0.tgz
https://registry.npmjs.org/ms/-/ms-0.7.1.tgz -> npmpkg-ms-0.7.1.tgz
https://registry.npmjs.org/follow-redirects/-/follow-redirects-1.5.10.tgz -> npmpkg-follow-redirects-1.5.10.tgz
https://registry.npmjs.org/for-each/-/for-each-0.3.2.tgz -> npmpkg-for-each-0.3.2.tgz
https://registry.npmjs.org/for-in/-/for-in-1.0.2.tgz -> npmpkg-for-in-1.0.2.tgz
https://registry.npmjs.org/for-own/-/for-own-0.1.5.tgz -> npmpkg-for-own-0.1.5.tgz
https://registry.npmjs.org/forever-agent/-/forever-agent-0.6.1.tgz -> npmpkg-forever-agent-0.6.1.tgz
https://registry.npmjs.org/form-data/-/form-data-2.3.1.tgz -> npmpkg-form-data-2.3.1.tgz
https://registry.npmjs.org/fragment-cache/-/fragment-cache-0.2.1.tgz -> npmpkg-fragment-cache-0.2.1.tgz
https://registry.npmjs.org/fresh/-/fresh-0.5.2.tgz -> npmpkg-fresh-0.5.2.tgz
https://registry.npmjs.org/from/-/from-0.1.7.tgz -> npmpkg-from-0.1.7.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-3.0.1.tgz -> npmpkg-fs-extra-3.0.1.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz -> npmpkg-fs.realpath-1.0.0.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.1.tgz -> npmpkg-function-bind-1.1.1.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.1.2.tgz -> npmpkg-get-intrinsic-1.1.2.tgz
https://registry.npmjs.org/get-stream/-/get-stream-5.2.0.tgz -> npmpkg-get-stream-5.2.0.tgz
https://registry.npmjs.org/get-value/-/get-value-2.0.6.tgz -> npmpkg-get-value-2.0.6.tgz
https://registry.npmjs.org/getpass/-/getpass-0.1.7.tgz -> npmpkg-getpass-0.1.7.tgz
https://registry.npmjs.org/glob/-/glob-7.1.2.tgz -> npmpkg-glob-7.1.2.tgz
https://registry.npmjs.org/glob-base/-/glob-base-0.3.0.tgz -> npmpkg-glob-base-0.3.0.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-2.0.0.tgz -> npmpkg-glob-parent-2.0.0.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-1.0.0.tgz -> npmpkg-is-extglob-1.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-2.0.1.tgz -> npmpkg-is-glob-2.0.1.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/global/-/global-4.3.2.tgz -> npmpkg-global-4.3.2.tgz
https://registry.npmjs.org/global-agent/-/global-agent-3.0.0.tgz -> npmpkg-global-agent-3.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.3.7.tgz -> npmpkg-semver-7.3.7.tgz
https://registry.npmjs.org/global-tunnel-ng/-/global-tunnel-ng-2.7.1.tgz -> npmpkg-global-tunnel-ng-2.7.1.tgz
https://registry.npmjs.org/globalthis/-/globalthis-1.0.3.tgz -> npmpkg-globalthis-1.0.3.tgz
https://registry.npmjs.org/got/-/got-9.6.0.tgz -> npmpkg-got-9.6.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-4.1.0.tgz -> npmpkg-get-stream-4.1.0.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.10.tgz -> npmpkg-graceful-fs-4.2.10.tgz
https://registry.npmjs.org/har-schema/-/har-schema-2.0.0.tgz -> npmpkg-har-schema-2.0.0.tgz
https://registry.npmjs.org/har-validator/-/har-validator-5.0.3.tgz -> npmpkg-har-validator-5.0.3.tgz
https://registry.npmjs.org/has/-/has-1.0.3.tgz -> npmpkg-has-1.0.3.tgz
https://registry.npmjs.org/has-property-descriptors/-/has-property-descriptors-1.0.0.tgz -> npmpkg-has-property-descriptors-1.0.0.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.0.3.tgz -> npmpkg-has-symbols-1.0.3.tgz
https://registry.npmjs.org/has-value/-/has-value-1.0.0.tgz -> npmpkg-has-value-1.0.0.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/has-values/-/has-values-1.0.0.tgz -> npmpkg-has-values-1.0.0.tgz
https://registry.npmjs.org/is-number/-/is-number-3.0.0.tgz -> npmpkg-is-number-3.0.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/kind-of/-/kind-of-4.0.0.tgz -> npmpkg-kind-of-4.0.0.tgz
https://registry.npmjs.org/hawk/-/hawk-6.0.2.tgz -> npmpkg-hawk-6.0.2.tgz
https://registry.npmjs.org/hoek/-/hoek-4.2.0.tgz -> npmpkg-hoek-4.2.0.tgz
https://registry.npmjs.org/http-auth/-/http-auth-3.1.3.tgz -> npmpkg-http-auth-3.1.3.tgz
https://registry.npmjs.org/http-cache-semantics/-/http-cache-semantics-4.1.0.tgz -> npmpkg-http-cache-semantics-4.1.0.tgz
https://registry.npmjs.org/http-errors/-/http-errors-1.6.2.tgz -> npmpkg-http-errors-1.6.2.tgz
https://registry.npmjs.org/depd/-/depd-1.1.1.tgz -> npmpkg-depd-1.1.1.tgz
https://registry.npmjs.org/http-parser-js/-/http-parser-js-0.4.10.tgz -> npmpkg-http-parser-js-0.4.10.tgz
https://registry.npmjs.org/http-signature/-/http-signature-1.2.0.tgz -> npmpkg-http-signature-1.2.0.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz -> npmpkg-inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.3.tgz -> npmpkg-inherits-2.0.3.tgz
https://registry.npmjs.org/ini/-/ini-1.3.8.tgz -> npmpkg-ini-1.3.8.tgz
https://registry.npmjs.org/ip-regex/-/ip-regex-1.0.3.tgz -> npmpkg-ip-regex-1.0.3.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz -> npmpkg-is-accessor-descriptor-0.1.6.tgz
https://registry.npmjs.org/is-binary-path/-/is-binary-path-2.1.0.tgz -> npmpkg-is-binary-path-2.1.0.tgz
https://registry.npmjs.org/is-buffer/-/is-buffer-1.1.6.tgz -> npmpkg-is-buffer-1.1.6.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz -> npmpkg-is-data-descriptor-0.1.4.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.6.tgz -> npmpkg-is-descriptor-0.1.6.tgz
https://registry.npmjs.org/kind-of/-/kind-of-5.1.0.tgz -> npmpkg-kind-of-5.1.0.tgz
https://registry.npmjs.org/is-dotfile/-/is-dotfile-1.0.3.tgz -> npmpkg-is-dotfile-1.0.3.tgz
https://registry.npmjs.org/is-equal-shallow/-/is-equal-shallow-0.1.3.tgz -> npmpkg-is-equal-shallow-0.1.3.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz -> npmpkg-is-extglob-2.1.1.tgz
https://registry.npmjs.org/is-function/-/is-function-1.0.1.tgz -> npmpkg-is-function-1.0.1.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.1.tgz -> npmpkg-is-glob-4.0.1.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/is-plain-object/-/is-plain-object-2.0.4.tgz -> npmpkg-is-plain-object-2.0.4.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/is-posix-bracket/-/is-posix-bracket-0.1.1.tgz -> npmpkg-is-posix-bracket-0.1.1.tgz
https://registry.npmjs.org/is-primitive/-/is-primitive-2.0.0.tgz -> npmpkg-is-primitive-2.0.0.tgz
https://registry.npmjs.org/is-typedarray/-/is-typedarray-1.0.0.tgz -> npmpkg-is-typedarray-1.0.0.tgz
https://registry.npmjs.org/is-windows/-/is-windows-1.0.2.tgz -> npmpkg-is-windows-1.0.2.tgz
https://registry.npmjs.org/is-wsl/-/is-wsl-1.1.0.tgz -> npmpkg-is-wsl-1.1.0.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/isobject/-/isobject-2.1.0.tgz -> npmpkg-isobject-2.1.0.tgz
https://registry.npmjs.org/isstream/-/isstream-0.1.2.tgz -> npmpkg-isstream-0.1.2.tgz
https://registry.npmjs.org/jimp/-/jimp-0.2.28.tgz -> npmpkg-jimp-0.2.28.tgz
https://registry.npmjs.org/jpeg-js/-/jpeg-js-0.2.0.tgz -> npmpkg-jpeg-js-0.2.0.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-3.13.1.tgz -> npmpkg-js-yaml-3.13.1.tgz
https://registry.npmjs.org/jsbn/-/jsbn-0.1.1.tgz -> npmpkg-jsbn-0.1.1.tgz
https://registry.npmjs.org/json-buffer/-/json-buffer-3.0.0.tgz -> npmpkg-json-buffer-3.0.0.tgz
https://registry.npmjs.org/json-schema/-/json-schema-0.2.3.tgz -> npmpkg-json-schema-0.2.3.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-0.3.1.tgz -> npmpkg-json-schema-traverse-0.3.1.tgz
https://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz -> npmpkg-json-stringify-safe-5.0.1.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-3.0.1.tgz -> npmpkg-jsonfile-3.0.1.tgz
https://registry.npmjs.org/jsprim/-/jsprim-1.4.1.tgz -> npmpkg-jsprim-1.4.1.tgz
https://registry.npmjs.org/keyv/-/keyv-3.1.0.tgz -> npmpkg-keyv-3.1.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/lazy-val/-/lazy-val-1.0.4.tgz -> npmpkg-lazy-val-1.0.4.tgz
https://registry.npmjs.org/lazystream/-/lazystream-1.0.0.tgz -> npmpkg-lazystream-1.0.0.tgz
https://registry.npmjs.org/live-server/-/live-server-1.2.0.tgz -> npmpkg-live-server-1.2.0.tgz
https://registry.npmjs.org/anymatch/-/anymatch-1.3.2.tgz -> npmpkg-anymatch-1.3.2.tgz
https://registry.npmjs.org/arr-diff/-/arr-diff-4.0.0.tgz -> npmpkg-arr-diff-4.0.0.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.3.2.tgz -> npmpkg-array-unique-0.3.2.tgz
https://registry.npmjs.org/binary-extensions/-/binary-extensions-1.13.1.tgz -> npmpkg-binary-extensions-1.13.1.tgz
https://registry.npmjs.org/braces/-/braces-2.3.2.tgz -> npmpkg-braces-2.3.2.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/chokidar/-/chokidar-1.7.0.tgz -> npmpkg-chokidar-1.7.0.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/expand-brackets/-/expand-brackets-2.1.4.tgz -> npmpkg-expand-brackets-2.1.4.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz -> npmpkg-is-accessor-descriptor-0.1.6.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz -> npmpkg-is-data-descriptor-0.1.4.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.6.tgz -> npmpkg-is-descriptor-0.1.6.tgz
https://registry.npmjs.org/kind-of/-/kind-of-5.1.0.tgz -> npmpkg-kind-of-5.1.0.tgz
https://registry.npmjs.org/extglob/-/extglob-2.0.4.tgz -> npmpkg-extglob-2.0.4.tgz
https://registry.npmjs.org/define-property/-/define-property-1.0.0.tgz -> npmpkg-define-property-1.0.0.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/fill-range/-/fill-range-4.0.0.tgz -> npmpkg-fill-range-4.0.0.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-2.0.0.tgz -> npmpkg-glob-parent-2.0.0.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-1.0.0.tgz -> npmpkg-is-accessor-descriptor-1.0.0.tgz
https://registry.npmjs.org/is-binary-path/-/is-binary-path-1.0.1.tgz -> npmpkg-is-binary-path-1.0.1.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-1.0.0.tgz -> npmpkg-is-data-descriptor-1.0.0.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-1.0.2.tgz -> npmpkg-is-descriptor-1.0.2.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-1.0.0.tgz -> npmpkg-is-extglob-1.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-2.0.1.tgz -> npmpkg-is-glob-2.0.1.tgz
https://registry.npmjs.org/is-number/-/is-number-3.0.0.tgz -> npmpkg-is-number-3.0.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/readdirp/-/readdirp-2.2.1.tgz -> npmpkg-readdirp-2.2.1.tgz
https://registry.npmjs.org/micromatch/-/micromatch-3.1.10.tgz -> npmpkg-micromatch-3.1.10.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-2.1.1.tgz -> npmpkg-to-regex-range-2.1.1.tgz
https://registry.npmjs.org/load-bmfont/-/load-bmfont-1.3.0.tgz -> npmpkg-load-bmfont-1.3.0.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/lodash.clonedeep/-/lodash.clonedeep-4.5.0.tgz -> npmpkg-lodash.clonedeep-4.5.0.tgz
https://registry.npmjs.org/lodash.debounce/-/lodash.debounce-4.0.8.tgz -> npmpkg-lodash.debounce-4.0.8.tgz
https://registry.npmjs.org/lodash.defaults/-/lodash.defaults-4.2.0.tgz -> npmpkg-lodash.defaults-4.2.0.tgz
https://registry.npmjs.org/lodash.isarray/-/lodash.isarray-4.0.0.tgz -> npmpkg-lodash.isarray-4.0.0.tgz
https://registry.npmjs.org/lodash.isempty/-/lodash.isempty-4.4.0.tgz -> npmpkg-lodash.isempty-4.4.0.tgz
https://registry.npmjs.org/lodash.isequal/-/lodash.isequal-4.5.0.tgz -> npmpkg-lodash.isequal-4.5.0.tgz
https://registry.npmjs.org/lodash.isfunction/-/lodash.isfunction-3.0.8.tgz -> npmpkg-lodash.isfunction-3.0.8.tgz
https://registry.npmjs.org/lodash.throttle/-/lodash.throttle-4.1.1.tgz -> npmpkg-lodash.throttle-4.1.1.tgz
https://registry.npmjs.org/lowercase-keys/-/lowercase-keys-1.0.1.tgz -> npmpkg-lowercase-keys-1.0.1.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/map-cache/-/map-cache-0.2.2.tgz -> npmpkg-map-cache-0.2.2.tgz
https://registry.npmjs.org/map-stream/-/map-stream-0.1.0.tgz -> npmpkg-map-stream-0.1.0.tgz
https://registry.npmjs.org/map-visit/-/map-visit-1.0.0.tgz -> npmpkg-map-visit-1.0.0.tgz
https://registry.npmjs.org/matcher/-/matcher-3.0.0.tgz -> npmpkg-matcher-3.0.0.tgz
https://registry.npmjs.org/math-random/-/math-random-1.0.4.tgz -> npmpkg-math-random-1.0.4.tgz
https://registry.npmjs.org/micromatch/-/micromatch-2.3.11.tgz -> npmpkg-micromatch-2.3.11.tgz
https://registry.npmjs.org/braces/-/braces-1.8.5.tgz -> npmpkg-braces-1.8.5.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-1.0.0.tgz -> npmpkg-is-extglob-1.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-2.0.1.tgz -> npmpkg-is-glob-2.0.1.tgz
https://registry.npmjs.org/mime/-/mime-1.6.0.tgz -> npmpkg-mime-1.6.0.tgz
https://registry.npmjs.org/mime-db/-/mime-db-1.30.0.tgz -> npmpkg-mime-db-1.30.0.tgz
https://registry.npmjs.org/mime-types/-/mime-types-2.1.17.tgz -> npmpkg-mime-types-2.1.17.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-1.0.1.tgz -> npmpkg-mimic-response-1.0.1.tgz
https://registry.npmjs.org/min-document/-/min-document-2.19.0.tgz -> npmpkg-min-document-2.19.0.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.0.4.tgz -> npmpkg-minimatch-3.0.4.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.3.tgz -> npmpkg-minimist-1.2.3.tgz
https://registry.npmjs.org/mixin-deep/-/mixin-deep-1.3.2.tgz -> npmpkg-mixin-deep-1.3.2.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-1.0.1.tgz -> npmpkg-is-extendable-1.0.1.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.1.tgz -> npmpkg-mkdirp-0.5.1.tgz
https://registry.npmjs.org/minimist/-/minimist-0.0.8.tgz -> npmpkg-minimist-0.0.8.tgz
https://registry.npmjs.org/morgan/-/morgan-1.9.0.tgz -> npmpkg-morgan-1.9.0.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/nanomatch/-/nanomatch-1.2.13.tgz -> npmpkg-nanomatch-1.2.13.tgz
https://registry.npmjs.org/arr-diff/-/arr-diff-4.0.0.tgz -> npmpkg-arr-diff-4.0.0.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.3.2.tgz -> npmpkg-array-unique-0.3.2.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/negotiator/-/negotiator-0.6.1.tgz -> npmpkg-negotiator-0.6.1.tgz
https://registry.npmjs.org/node-addon-api/-/node-addon-api-1.7.2.tgz -> npmpkg-node-addon-api-1.7.2.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-2.1.1.tgz -> npmpkg-normalize-path-2.1.1.tgz
https://registry.npmjs.org/normalize-url/-/normalize-url-4.5.1.tgz -> npmpkg-normalize-url-4.5.1.tgz
https://registry.npmjs.org/npm-conf/-/npm-conf-1.1.3.tgz -> npmpkg-npm-conf-1.1.3.tgz
https://registry.npmjs.org/oauth-sign/-/oauth-sign-0.8.2.tgz -> npmpkg-oauth-sign-0.8.2.tgz
https://registry.npmjs.org/object-assign/-/object-assign-4.1.1.tgz -> npmpkg-object-assign-4.1.1.tgz
https://registry.npmjs.org/object-copy/-/object-copy-0.1.0.tgz -> npmpkg-object-copy-0.1.0.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/object-keys/-/object-keys-1.1.1.tgz -> npmpkg-object-keys-1.1.1.tgz
https://registry.npmjs.org/object-visit/-/object-visit-1.0.1.tgz -> npmpkg-object-visit-1.0.1.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/object.omit/-/object.omit-2.0.1.tgz -> npmpkg-object.omit-2.0.1.tgz
https://registry.npmjs.org/object.pick/-/object.pick-1.3.0.tgz -> npmpkg-object.pick-1.3.0.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/on-finished/-/on-finished-2.3.0.tgz -> npmpkg-on-finished-2.3.0.tgz
https://registry.npmjs.org/on-headers/-/on-headers-1.0.1.tgz -> npmpkg-on-headers-1.0.1.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz -> npmpkg-once-1.4.0.tgz
https://registry.npmjs.org/opn/-/opn-5.2.0.tgz -> npmpkg-opn-5.2.0.tgz
https://registry.npmjs.org/p-cancelable/-/p-cancelable-1.1.0.tgz -> npmpkg-p-cancelable-1.1.0.tgz
https://registry.npmjs.org/pako/-/pako-1.0.10.tgz -> npmpkg-pako-1.0.10.tgz
https://registry.npmjs.org/parse-bmfont-ascii/-/parse-bmfont-ascii-1.0.6.tgz -> npmpkg-parse-bmfont-ascii-1.0.6.tgz
https://registry.npmjs.org/parse-bmfont-binary/-/parse-bmfont-binary-1.0.6.tgz -> npmpkg-parse-bmfont-binary-1.0.6.tgz
https://registry.npmjs.org/parse-bmfont-xml/-/parse-bmfont-xml-1.1.3.tgz -> npmpkg-parse-bmfont-xml-1.1.3.tgz
https://registry.npmjs.org/parse-glob/-/parse-glob-3.0.4.tgz -> npmpkg-parse-glob-3.0.4.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-1.0.0.tgz -> npmpkg-is-extglob-1.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-2.0.1.tgz -> npmpkg-is-glob-2.0.1.tgz
https://registry.npmjs.org/parse-headers/-/parse-headers-2.0.1.tgz -> npmpkg-parse-headers-2.0.1.tgz
https://registry.npmjs.org/parseurl/-/parseurl-1.3.2.tgz -> npmpkg-parseurl-1.3.2.tgz
https://registry.npmjs.org/pascalcase/-/pascalcase-0.1.1.tgz -> npmpkg-pascalcase-0.1.1.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> npmpkg-path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/pause-stream/-/pause-stream-0.0.11.tgz -> npmpkg-pause-stream-0.0.11.tgz
https://registry.npmjs.org/pend/-/pend-1.2.0.tgz -> npmpkg-pend-1.2.0.tgz
https://registry.npmjs.org/performance-now/-/performance-now-2.1.0.tgz -> npmpkg-performance-now-2.1.0.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.2.3.tgz -> npmpkg-picomatch-2.2.3.tgz
https://registry.npmjs.org/pify/-/pify-3.0.0.tgz -> npmpkg-pify-3.0.0.tgz
https://registry.npmjs.org/pixelmatch/-/pixelmatch-4.0.2.tgz -> npmpkg-pixelmatch-4.0.2.tgz
https://registry.npmjs.org/pngjs/-/pngjs-3.3.1.tgz -> npmpkg-pngjs-3.3.1.tgz
https://registry.npmjs.org/posix-character-classes/-/posix-character-classes-0.1.1.tgz -> npmpkg-posix-character-classes-0.1.1.tgz
https://registry.npmjs.org/prepend-http/-/prepend-http-2.0.0.tgz -> npmpkg-prepend-http-2.0.0.tgz
https://registry.npmjs.org/preserve/-/preserve-0.2.0.tgz -> npmpkg-preserve-0.2.0.tgz
https://registry.npmjs.org/process/-/process-0.5.2.tgz -> npmpkg-process-0.5.2.tgz
https://registry.npmjs.org/process-nextick-args/-/process-nextick-args-1.0.7.tgz -> npmpkg-process-nextick-args-1.0.7.tgz
https://registry.npmjs.org/progress/-/progress-2.0.3.tgz -> npmpkg-progress-2.0.3.tgz
https://registry.npmjs.org/proto-list/-/proto-list-1.2.4.tgz -> npmpkg-proto-list-1.2.4.tgz
https://registry.npmjs.org/proxy-middleware/-/proxy-middleware-0.15.0.tgz -> npmpkg-proxy-middleware-0.15.0.tgz
https://registry.npmjs.org/pump/-/pump-3.0.0.tgz -> npmpkg-pump-3.0.0.tgz
https://registry.npmjs.org/qs/-/qs-6.5.1.tgz -> npmpkg-qs-6.5.1.tgz
https://registry.npmjs.org/randomatic/-/randomatic-3.1.1.tgz -> npmpkg-randomatic-3.1.1.tgz
https://registry.npmjs.org/is-number/-/is-number-4.0.0.tgz -> npmpkg-is-number-4.0.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/range-parser/-/range-parser-1.2.0.tgz -> npmpkg-range-parser-1.2.0.tgz
https://registry.npmjs.org/read-chunk/-/read-chunk-1.0.1.tgz -> npmpkg-read-chunk-1.0.1.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.3.tgz -> npmpkg-readable-stream-2.3.3.tgz
https://registry.npmjs.org/readdirp/-/readdirp-3.5.0.tgz -> npmpkg-readdirp-3.5.0.tgz
https://registry.npmjs.org/regex-cache/-/regex-cache-0.4.4.tgz -> npmpkg-regex-cache-0.4.4.tgz
https://registry.npmjs.org/regex-not/-/regex-not-1.0.2.tgz -> npmpkg-regex-not-1.0.2.tgz
https://registry.npmjs.org/remove-trailing-separator/-/remove-trailing-separator-1.1.0.tgz -> npmpkg-remove-trailing-separator-1.1.0.tgz
https://registry.npmjs.org/repeat-element/-/repeat-element-1.1.4.tgz -> npmpkg-repeat-element-1.1.4.tgz
https://registry.npmjs.org/repeat-string/-/repeat-string-1.6.1.tgz -> npmpkg-repeat-string-1.6.1.tgz
https://registry.npmjs.org/request/-/request-2.83.0.tgz -> npmpkg-request-2.83.0.tgz
https://registry.npmjs.org/resolve-url/-/resolve-url-0.2.1.tgz -> npmpkg-resolve-url-0.2.1.tgz
https://registry.npmjs.org/responselike/-/responselike-1.0.2.tgz -> npmpkg-responselike-1.0.2.tgz
https://registry.npmjs.org/ret/-/ret-0.1.15.tgz -> npmpkg-ret-0.1.15.tgz
https://registry.npmjs.org/roarr/-/roarr-2.15.4.tgz -> npmpkg-roarr-2.15.4.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.1.2.tgz -> npmpkg-sprintf-js-1.1.2.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.1.tgz -> npmpkg-safe-buffer-5.1.1.tgz
https://registry.npmjs.org/safe-regex/-/safe-regex-1.1.0.tgz -> npmpkg-safe-regex-1.1.0.tgz
https://registry.npmjs.org/sax/-/sax-1.2.1.tgz -> npmpkg-sax-1.2.1.tgz
https://registry.npmjs.org/semver/-/semver-5.4.1.tgz -> npmpkg-semver-5.4.1.tgz
https://registry.npmjs.org/semver-compare/-/semver-compare-1.0.0.tgz -> npmpkg-semver-compare-1.0.0.tgz
https://registry.npmjs.org/send/-/send-0.16.2.tgz -> npmpkg-send-0.16.2.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/mime/-/mime-1.4.1.tgz -> npmpkg-mime-1.4.1.tgz
https://registry.npmjs.org/statuses/-/statuses-1.4.0.tgz -> npmpkg-statuses-1.4.0.tgz
https://registry.npmjs.org/serialize-error/-/serialize-error-7.0.1.tgz -> npmpkg-serialize-error-7.0.1.tgz
https://registry.npmjs.org/serve-index/-/serve-index-1.9.1.tgz -> npmpkg-serve-index-1.9.1.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/set-value/-/set-value-2.0.1.tgz -> npmpkg-set-value-2.0.1.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/setprototypeof/-/setprototypeof-1.0.3.tgz -> npmpkg-setprototypeof-1.0.3.tgz
https://registry.npmjs.org/snapdragon/-/snapdragon-0.8.2.tgz -> npmpkg-snapdragon-0.8.2.tgz
https://registry.npmjs.org/snapdragon-node/-/snapdragon-node-2.1.1.tgz -> npmpkg-snapdragon-node-2.1.1.tgz
https://registry.npmjs.org/define-property/-/define-property-1.0.0.tgz -> npmpkg-define-property-1.0.0.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-1.0.0.tgz -> npmpkg-is-accessor-descriptor-1.0.0.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-1.0.0.tgz -> npmpkg-is-data-descriptor-1.0.0.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-1.0.2.tgz -> npmpkg-is-descriptor-1.0.2.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/snapdragon-util/-/snapdragon-util-3.0.1.tgz -> npmpkg-snapdragon-util-3.0.1.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/sntp/-/sntp-2.1.0.tgz -> npmpkg-sntp-2.1.0.tgz
https://registry.npmjs.org/source-map/-/source-map-0.5.7.tgz -> npmpkg-source-map-0.5.7.tgz
https://registry.npmjs.org/source-map-resolve/-/source-map-resolve-0.5.3.tgz -> npmpkg-source-map-resolve-0.5.3.tgz
https://registry.npmjs.org/source-map-url/-/source-map-url-0.4.1.tgz -> npmpkg-source-map-url-0.4.1.tgz
https://registry.npmjs.org/split/-/split-0.3.3.tgz -> npmpkg-split-0.3.3.tgz
https://registry.npmjs.org/split-string/-/split-string-3.1.0.tgz -> npmpkg-split-string-3.1.0.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.0.3.tgz -> npmpkg-sprintf-js-1.0.3.tgz
https://registry.npmjs.org/sshpk/-/sshpk-1.13.1.tgz -> npmpkg-sshpk-1.13.1.tgz
https://registry.npmjs.org/static-extend/-/static-extend-0.1.2.tgz -> npmpkg-static-extend-0.1.2.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/statuses/-/statuses-1.3.1.tgz -> npmpkg-statuses-1.3.1.tgz
https://registry.npmjs.org/stream-combiner/-/stream-combiner-0.0.4.tgz -> npmpkg-stream-combiner-0.0.4.tgz
https://registry.npmjs.org/stream-to/-/stream-to-0.2.2.tgz -> npmpkg-stream-to-0.2.2.tgz
https://registry.npmjs.org/stream-to-buffer/-/stream-to-buffer-0.1.0.tgz -> npmpkg-stream-to-buffer-0.1.0.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-1.0.3.tgz -> npmpkg-string_decoder-1.0.3.tgz
https://registry.npmjs.org/stringstream/-/stringstream-0.0.5.tgz -> npmpkg-stringstream-0.0.5.tgz
https://registry.npmjs.org/sumchecker/-/sumchecker-3.0.1.tgz -> npmpkg-sumchecker-3.0.1.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/tar-stream/-/tar-stream-1.5.5.tgz -> npmpkg-tar-stream-1.5.5.tgz
https://registry.npmjs.org/through/-/through-2.3.8.tgz -> npmpkg-through-2.3.8.tgz
https://registry.npmjs.org/tinycolor2/-/tinycolor2-1.4.1.tgz -> npmpkg-tinycolor2-1.4.1.tgz
https://registry.npmjs.org/to-object-path/-/to-object-path-0.3.0.tgz -> npmpkg-to-object-path-0.3.0.tgz
https://registry.npmjs.org/to-readable-stream/-/to-readable-stream-1.0.0.tgz -> npmpkg-to-readable-stream-1.0.0.tgz
https://registry.npmjs.org/to-regex/-/to-regex-3.0.2.tgz -> npmpkg-to-regex-3.0.2.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/tough-cookie/-/tough-cookie-2.3.3.tgz -> npmpkg-tough-cookie-2.3.3.tgz
https://registry.npmjs.org/punycode/-/punycode-1.4.1.tgz -> npmpkg-punycode-1.4.1.tgz
https://registry.npmjs.org/trim/-/trim-0.0.1.tgz -> npmpkg-trim-0.0.1.tgz
https://registry.npmjs.org/tunnel/-/tunnel-0.0.6.tgz -> npmpkg-tunnel-0.0.6.tgz
https://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.6.0.tgz -> npmpkg-tunnel-agent-0.6.0.tgz
https://registry.npmjs.org/tweetnacl/-/tweetnacl-0.14.5.tgz -> npmpkg-tweetnacl-0.14.5.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.13.1.tgz -> npmpkg-type-fest-0.13.1.tgz
https://registry.npmjs.org/union-value/-/union-value-1.0.1.tgz -> npmpkg-union-value-1.0.1.tgz
https://registry.npmjs.org/universalify/-/universalify-0.1.1.tgz -> npmpkg-universalify-0.1.1.tgz
https://registry.npmjs.org/unix-crypt-td-js/-/unix-crypt-td-js-1.0.0.tgz -> npmpkg-unix-crypt-td-js-1.0.0.tgz
https://registry.npmjs.org/unpipe/-/unpipe-1.0.0.tgz -> npmpkg-unpipe-1.0.0.tgz
https://registry.npmjs.org/unset-value/-/unset-value-1.0.0.tgz -> npmpkg-unset-value-1.0.0.tgz
https://registry.npmjs.org/has-value/-/has-value-0.3.1.tgz -> npmpkg-has-value-0.3.1.tgz
https://registry.npmjs.org/isobject/-/isobject-2.1.0.tgz -> npmpkg-isobject-2.1.0.tgz
https://registry.npmjs.org/has-values/-/has-values-0.1.4.tgz -> npmpkg-has-values-0.1.4.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/urix/-/urix-0.1.0.tgz -> npmpkg-urix-0.1.0.tgz
https://registry.npmjs.org/url-parse-lax/-/url-parse-lax-3.0.0.tgz -> npmpkg-url-parse-lax-3.0.0.tgz
https://registry.npmjs.org/url-regex/-/url-regex-3.2.0.tgz -> npmpkg-url-regex-3.2.0.tgz
https://registry.npmjs.org/use/-/use-3.1.1.tgz -> npmpkg-use-3.1.1.tgz
https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz -> npmpkg-util-deprecate-1.0.2.tgz
https://registry.npmjs.org/utils-merge/-/utils-merge-1.0.0.tgz -> npmpkg-utils-merge-1.0.0.tgz
https://registry.npmjs.org/uuid/-/uuid-3.1.0.tgz -> npmpkg-uuid-3.1.0.tgz
https://registry.npmjs.org/vary/-/vary-1.1.2.tgz -> npmpkg-vary-1.1.2.tgz
https://registry.npmjs.org/verror/-/verror-1.10.0.tgz -> npmpkg-verror-1.10.0.tgz
https://registry.npmjs.org/websocket-driver/-/websocket-driver-0.7.0.tgz -> npmpkg-websocket-driver-0.7.0.tgz
https://registry.npmjs.org/websocket-extensions/-/websocket-extensions-0.1.3.tgz -> npmpkg-websocket-extensions-0.1.3.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
https://registry.npmjs.org/ws/-/ws-5.1.1.tgz -> npmpkg-ws-5.1.1.tgz
https://registry.npmjs.org/xhr/-/xhr-2.4.1.tgz -> npmpkg-xhr-2.4.1.tgz
https://registry.npmjs.org/xml-parse-from-string/-/xml-parse-from-string-1.0.1.tgz -> npmpkg-xml-parse-from-string-1.0.1.tgz
https://registry.npmjs.org/xml2js/-/xml2js-0.4.17.tgz -> npmpkg-xml2js-0.4.17.tgz
https://registry.npmjs.org/xmlbuilder/-/xmlbuilder-4.2.1.tgz -> npmpkg-xmlbuilder-4.2.1.tgz
https://registry.npmjs.org/xtend/-/xtend-4.0.1.tgz -> npmpkg-xtend-4.0.1.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/yauzl/-/yauzl-2.10.0.tgz -> npmpkg-yauzl-2.10.0.tgz
https://registry.npmjs.org/zip-stream/-/zip-stream-1.2.0.tgz -> npmpkg-zip-stream-1.2.0.tgz
https://registry.npmjs.org/@develar/schema-utils/-/schema-utils-2.6.5.tgz -> npmpkg-@develar-schema-utils-2.6.5.tgz
https://registry.npmjs.org/@electron/get/-/get-1.14.1.tgz -> npmpkg-@electron-get-1.14.1.tgz
https://registry.npmjs.org/@electron/remote/-/remote-2.0.8.tgz -> npmpkg-@electron-remote-2.0.8.tgz
https://registry.npmjs.org/@electron/universal/-/universal-1.0.5.tgz -> npmpkg-@electron-universal-1.0.5.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-9.1.0.tgz -> npmpkg-fs-extra-9.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz -> npmpkg-universalify-2.0.0.tgz
https://registry.npmjs.org/@malept/cross-spawn-promise/-/cross-spawn-promise-1.1.1.tgz -> npmpkg-@malept-cross-spawn-promise-1.1.1.tgz
https://registry.npmjs.org/@malept/flatpak-bundler/-/flatpak-bundler-0.4.0.tgz -> npmpkg-@malept-flatpak-bundler-0.4.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-9.1.0.tgz -> npmpkg-fs-extra-9.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz -> npmpkg-universalify-2.0.0.tgz
https://registry.npmjs.org/@sindresorhus/is/-/is-0.14.0.tgz -> npmpkg-@sindresorhus-is-0.14.0.tgz
https://registry.npmjs.org/@szmarczak/http-timer/-/http-timer-1.1.2.tgz -> npmpkg-@szmarczak-http-timer-1.1.2.tgz
https://registry.npmjs.org/@tootallnate/once/-/once-2.0.0.tgz -> npmpkg-@tootallnate-once-2.0.0.tgz
https://registry.npmjs.org/@types/debug/-/debug-4.1.7.tgz -> npmpkg-@types-debug-4.1.7.tgz
https://registry.npmjs.org/@types/fs-extra/-/fs-extra-9.0.13.tgz -> npmpkg-@types-fs-extra-9.0.13.tgz
https://registry.npmjs.org/@types/glob/-/glob-7.2.0.tgz -> npmpkg-@types-glob-7.2.0.tgz
https://registry.npmjs.org/@types/minimatch/-/minimatch-5.1.2.tgz -> npmpkg-@types-minimatch-5.1.2.tgz
https://registry.npmjs.org/@types/ms/-/ms-0.7.31.tgz -> npmpkg-@types-ms-0.7.31.tgz
https://registry.npmjs.org/@types/node/-/node-16.11.33.tgz -> npmpkg-@types-node-16.11.33.tgz
https://registry.npmjs.org/@types/plist/-/plist-3.0.2.tgz -> npmpkg-@types-plist-3.0.2.tgz
https://registry.npmjs.org/@types/verror/-/verror-1.10.6.tgz -> npmpkg-@types-verror-1.10.6.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-17.0.10.tgz -> npmpkg-@types-yargs-17.0.10.tgz
https://registry.npmjs.org/@types/yargs-parser/-/yargs-parser-21.0.0.tgz -> npmpkg-@types-yargs-parser-21.0.0.tgz
https://registry.npmjs.org/7zip-bin/-/7zip-bin-5.1.1.tgz -> npmpkg-7zip-bin-5.1.1.tgz
https://registry.npmjs.org/agent-base/-/agent-base-6.0.2.tgz -> npmpkg-agent-base-6.0.2.tgz
https://registry.npmjs.org/ajv/-/ajv-6.12.6.tgz -> npmpkg-ajv-6.12.6.tgz
https://registry.npmjs.org/ajv-keywords/-/ajv-keywords-3.5.2.tgz -> npmpkg-ajv-keywords-3.5.2.tgz
https://registry.npmjs.org/ansi-align/-/ansi-align-3.0.1.tgz -> npmpkg-ansi-align-3.0.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/app-builder-bin/-/app-builder-bin-3.7.1.tgz -> npmpkg-app-builder-bin-3.7.1.tgz
https://registry.npmjs.org/app-builder-lib/-/app-builder-lib-22.14.13.tgz -> npmpkg-app-builder-lib-22.14.13.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/semver/-/semver-7.3.8.tgz -> npmpkg-semver-7.3.8.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz -> npmpkg-universalify-2.0.0.tgz
https://registry.npmjs.org/argparse/-/argparse-2.0.1.tgz -> npmpkg-argparse-2.0.1.tgz
https://registry.npmjs.org/asar/-/asar-3.2.0.tgz -> npmpkg-asar-3.2.0.tgz
https://registry.npmjs.org/assert-plus/-/assert-plus-1.0.0.tgz -> npmpkg-assert-plus-1.0.0.tgz
https://registry.npmjs.org/astral-regex/-/astral-regex-2.0.0.tgz -> npmpkg-astral-regex-2.0.0.tgz
https://registry.npmjs.org/async/-/async-3.2.4.tgz -> npmpkg-async-3.2.4.tgz
https://registry.npmjs.org/async-exit-hook/-/async-exit-hook-2.0.1.tgz -> npmpkg-async-exit-hook-2.0.1.tgz
https://registry.npmjs.org/asynckit/-/asynckit-0.4.0.tgz -> npmpkg-asynckit-0.4.0.tgz
https://registry.npmjs.org/at-least-node/-/at-least-node-1.0.0.tgz -> npmpkg-at-least-node-1.0.0.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.0.tgz -> npmpkg-balanced-match-1.0.0.tgz
https://registry.npmjs.org/base64-js/-/base64-js-1.5.1.tgz -> npmpkg-base64-js-1.5.1.tgz
https://registry.npmjs.org/big-integer/-/big-integer-1.6.48.tgz -> npmpkg-big-integer-1.6.48.tgz
https://registry.npmjs.org/binary/-/binary-0.3.0.tgz -> npmpkg-binary-0.3.0.tgz
https://registry.npmjs.org/bluebird/-/bluebird-3.7.2.tgz -> npmpkg-bluebird-3.7.2.tgz
https://registry.npmjs.org/bluebird-lst/-/bluebird-lst-1.0.9.tgz -> npmpkg-bluebird-lst-1.0.9.tgz
https://registry.npmjs.org/boolean/-/boolean-3.2.0.tgz -> npmpkg-boolean-3.2.0.tgz
https://registry.npmjs.org/boxen/-/boxen-5.1.2.tgz -> npmpkg-boxen-5.1.2.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.20.2.tgz -> npmpkg-type-fest-0.20.2.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/buffer/-/buffer-5.7.1.tgz -> npmpkg-buffer-5.7.1.tgz
https://registry.npmjs.org/buffer-alloc/-/buffer-alloc-1.2.0.tgz -> npmpkg-buffer-alloc-1.2.0.tgz
https://registry.npmjs.org/buffer-alloc-unsafe/-/buffer-alloc-unsafe-1.1.0.tgz -> npmpkg-buffer-alloc-unsafe-1.1.0.tgz
https://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.2.13.tgz -> npmpkg-buffer-crc32-0.2.13.tgz
https://registry.npmjs.org/buffer-equal/-/buffer-equal-1.0.0.tgz -> npmpkg-buffer-equal-1.0.0.tgz
https://registry.npmjs.org/buffer-fill/-/buffer-fill-1.0.0.tgz -> npmpkg-buffer-fill-1.0.0.tgz
https://registry.npmjs.org/buffer-from/-/buffer-from-1.1.2.tgz -> npmpkg-buffer-from-1.1.2.tgz
https://registry.npmjs.org/buffer-indexof-polyfill/-/buffer-indexof-polyfill-1.0.1.tgz -> npmpkg-buffer-indexof-polyfill-1.0.1.tgz
https://registry.npmjs.org/buffers/-/buffers-0.1.1.tgz -> npmpkg-buffers-0.1.1.tgz
https://registry.npmjs.org/builder-util/-/builder-util-22.14.13.tgz -> npmpkg-builder-util-22.14.13.tgz
https://registry.npmjs.org/builder-util-runtime/-/builder-util-runtime-8.9.2.tgz -> npmpkg-builder-util-runtime-8.9.2.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz -> npmpkg-universalify-2.0.0.tgz
https://registry.npmjs.org/cacheable-request/-/cacheable-request-6.1.0.tgz -> npmpkg-cacheable-request-6.1.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-5.2.0.tgz -> npmpkg-get-stream-5.2.0.tgz
https://registry.npmjs.org/lowercase-keys/-/lowercase-keys-2.0.0.tgz -> npmpkg-lowercase-keys-2.0.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-6.3.0.tgz -> npmpkg-camelcase-6.3.0.tgz
https://registry.npmjs.org/chainsaw/-/chainsaw-0.1.0.tgz -> npmpkg-chainsaw-0.1.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/chromium-pickle-js/-/chromium-pickle-js-0.2.0.tgz -> npmpkg-chromium-pickle-js-0.2.0.tgz
https://registry.npmjs.org/ci-info/-/ci-info-3.7.1.tgz -> npmpkg-ci-info-3.7.1.tgz
https://registry.npmjs.org/cli-boxes/-/cli-boxes-2.2.1.tgz -> npmpkg-cli-boxes-2.2.1.tgz
https://registry.npmjs.org/cli-truncate/-/cli-truncate-2.1.0.tgz -> npmpkg-cli-truncate-2.1.0.tgz
https://registry.npmjs.org/cliui/-/cliui-7.0.4.tgz -> npmpkg-cliui-7.0.4.tgz
https://registry.npmjs.org/clone-response/-/clone-response-1.0.2.tgz -> npmpkg-clone-response-1.0.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/colors/-/colors-1.0.3.tgz -> npmpkg-colors-1.0.3.tgz
https://registry.npmjs.org/combined-stream/-/combined-stream-1.0.8.tgz -> npmpkg-combined-stream-1.0.8.tgz
https://registry.npmjs.org/commander/-/commander-5.1.0.tgz -> npmpkg-commander-5.1.0.tgz
https://registry.npmjs.org/compare-version/-/compare-version-0.1.2.tgz -> npmpkg-compare-version-0.1.2.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/concat-stream/-/concat-stream-1.6.2.tgz -> npmpkg-concat-stream-1.6.2.tgz
https://registry.npmjs.org/config-chain/-/config-chain-1.1.13.tgz -> npmpkg-config-chain-1.1.13.tgz
https://registry.npmjs.org/configstore/-/configstore-5.0.1.tgz -> npmpkg-configstore-5.0.1.tgz
https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.2.tgz -> npmpkg-core-util-is-1.0.2.tgz
https://registry.npmjs.org/crc/-/crc-3.8.0.tgz -> npmpkg-crc-3.8.0.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz -> npmpkg-cross-spawn-7.0.3.tgz
https://registry.npmjs.org/crypto-random-string/-/crypto-random-string-2.0.0.tgz -> npmpkg-crypto-random-string-2.0.0.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/decompress-response/-/decompress-response-3.3.0.tgz -> npmpkg-decompress-response-3.3.0.tgz
https://registry.npmjs.org/deep-extend/-/deep-extend-0.6.0.tgz -> npmpkg-deep-extend-0.6.0.tgz
https://registry.npmjs.org/defer-to-connect/-/defer-to-connect-1.1.3.tgz -> npmpkg-defer-to-connect-1.1.3.tgz
https://registry.npmjs.org/define-properties/-/define-properties-1.1.4.tgz -> npmpkg-define-properties-1.1.4.tgz
https://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz -> npmpkg-delayed-stream-1.0.0.tgz
https://registry.npmjs.org/detect-node/-/detect-node-2.1.0.tgz -> npmpkg-detect-node-2.1.0.tgz
https://registry.npmjs.org/dir-compare/-/dir-compare-2.4.0.tgz -> npmpkg-dir-compare-2.4.0.tgz
https://registry.npmjs.org/commander/-/commander-2.9.0.tgz -> npmpkg-commander-2.9.0.tgz
https://registry.npmjs.org/dmg-builder/-/dmg-builder-22.14.13.tgz -> npmpkg-dmg-builder-22.14.13.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz -> npmpkg-universalify-2.0.0.tgz
https://registry.npmjs.org/dmg-license/-/dmg-license-1.0.11.tgz -> npmpkg-dmg-license-1.0.11.tgz
https://registry.npmjs.org/dot-prop/-/dot-prop-5.3.0.tgz -> npmpkg-dot-prop-5.3.0.tgz
https://registry.npmjs.org/dotenv/-/dotenv-8.2.0.tgz -> npmpkg-dotenv-8.2.0.tgz
https://registry.npmjs.org/dotenv-expand/-/dotenv-expand-5.1.0.tgz -> npmpkg-dotenv-expand-5.1.0.tgz
https://registry.npmjs.org/duplexer2/-/duplexer2-0.1.4.tgz -> npmpkg-duplexer2-0.1.4.tgz
https://registry.npmjs.org/duplexer3/-/duplexer3-0.1.4.tgz -> npmpkg-duplexer3-0.1.4.tgz
https://registry.npmjs.org/ejs/-/ejs-3.1.8.tgz -> npmpkg-ejs-3.1.8.tgz
https://registry.npmjs.org/electron/-/electron-18.2.2.tgz -> npmpkg-electron-18.2.2.tgz
https://registry.npmjs.org/electron-builder/-/electron-builder-22.14.13.tgz -> npmpkg-electron-builder-22.14.13.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz -> npmpkg-universalify-2.0.0.tgz
https://registry.npmjs.org/electron-is/-/electron-is-2.4.1.tgz -> npmpkg-electron-is-2.4.1.tgz
https://registry.npmjs.org/electron-is-dev/-/electron-is-dev-0.3.0.tgz -> npmpkg-electron-is-dev-0.3.0.tgz
https://registry.npmjs.org/semver/-/semver-5.7.1.tgz -> npmpkg-semver-5.7.1.tgz
https://registry.npmjs.org/electron-notarize/-/electron-notarize-0.2.1.tgz -> npmpkg-electron-notarize-0.2.1.tgz
https://registry.npmjs.org/electron-osx-sign/-/electron-osx-sign-0.5.0.tgz -> npmpkg-electron-osx-sign-0.5.0.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/isbinaryfile/-/isbinaryfile-3.0.3.tgz -> npmpkg-isbinaryfile-3.0.3.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/electron-publish/-/electron-publish-22.14.13.tgz -> npmpkg-electron-publish-22.14.13.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz -> npmpkg-universalify-2.0.0.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
https://registry.npmjs.org/encodeurl/-/encodeurl-1.0.2.tgz -> npmpkg-encodeurl-1.0.2.tgz
https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.4.4.tgz -> npmpkg-end-of-stream-1.4.4.tgz
https://registry.npmjs.org/env-paths/-/env-paths-2.2.1.tgz -> npmpkg-env-paths-2.2.1.tgz
https://registry.npmjs.org/es6-error/-/es6-error-4.1.1.tgz -> npmpkg-es6-error-4.1.1.tgz
https://registry.npmjs.org/escalade/-/escalade-3.1.1.tgz -> npmpkg-escalade-3.1.1.tgz
https://registry.npmjs.org/escape-goat/-/escape-goat-2.1.1.tgz -> npmpkg-escape-goat-2.1.1.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz -> npmpkg-escape-string-regexp-4.0.0.tgz
https://registry.npmjs.org/extract-zip/-/extract-zip-1.7.0.tgz -> npmpkg-extract-zip-1.7.0.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/extsprintf/-/extsprintf-1.4.1.tgz -> npmpkg-extsprintf-1.4.1.tgz
https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz -> npmpkg-fast-deep-equal-3.1.3.tgz
https://registry.npmjs.org/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz -> npmpkg-fast-json-stable-stringify-2.1.0.tgz
https://registry.npmjs.org/fd-slicer/-/fd-slicer-1.1.0.tgz -> npmpkg-fd-slicer-1.1.0.tgz
https://registry.npmjs.org/filelist/-/filelist-1.0.4.tgz -> npmpkg-filelist-1.0.4.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-5.1.6.tgz -> npmpkg-minimatch-5.1.6.tgz
https://registry.npmjs.org/form-data/-/form-data-4.0.0.tgz -> npmpkg-form-data-4.0.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz -> npmpkg-fs.realpath-1.0.0.tgz
https://registry.npmjs.org/fstream/-/fstream-1.0.12.tgz -> npmpkg-fstream-1.0.12.tgz
https://registry.npmjs.org/rimraf/-/rimraf-2.7.1.tgz -> npmpkg-rimraf-2.7.1.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.1.tgz -> npmpkg-function-bind-1.1.1.tgz
https://registry.npmjs.org/get-caller-file/-/get-caller-file-2.0.5.tgz -> npmpkg-get-caller-file-2.0.5.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.1.1.tgz -> npmpkg-get-intrinsic-1.1.1.tgz
https://registry.npmjs.org/get-stream/-/get-stream-4.1.0.tgz -> npmpkg-get-stream-4.1.0.tgz
https://registry.npmjs.org/glob/-/glob-7.1.6.tgz -> npmpkg-glob-7.1.6.tgz
https://registry.npmjs.org/global-agent/-/global-agent-3.0.0.tgz -> npmpkg-global-agent-3.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.3.7.tgz -> npmpkg-semver-7.3.7.tgz
https://registry.npmjs.org/global-dirs/-/global-dirs-3.0.0.tgz -> npmpkg-global-dirs-3.0.0.tgz
https://registry.npmjs.org/ini/-/ini-2.0.0.tgz -> npmpkg-ini-2.0.0.tgz
https://registry.npmjs.org/global-tunnel-ng/-/global-tunnel-ng-2.7.1.tgz -> npmpkg-global-tunnel-ng-2.7.1.tgz
https://registry.npmjs.org/globalthis/-/globalthis-1.0.2.tgz -> npmpkg-globalthis-1.0.2.tgz
https://registry.npmjs.org/got/-/got-9.6.0.tgz -> npmpkg-got-9.6.0.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.4.tgz -> npmpkg-graceful-fs-4.2.4.tgz
https://registry.npmjs.org/graceful-readlink/-/graceful-readlink-1.0.1.tgz -> npmpkg-graceful-readlink-1.0.1.tgz
https://registry.npmjs.org/has/-/has-1.0.3.tgz -> npmpkg-has-1.0.3.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/has-property-descriptors/-/has-property-descriptors-1.0.0.tgz -> npmpkg-has-property-descriptors-1.0.0.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.0.3.tgz -> npmpkg-has-symbols-1.0.3.tgz
https://registry.npmjs.org/has-yarn/-/has-yarn-2.1.0.tgz -> npmpkg-has-yarn-2.1.0.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-4.1.0.tgz -> npmpkg-hosted-git-info-4.1.0.tgz
https://registry.npmjs.org/http-cache-semantics/-/http-cache-semantics-4.1.0.tgz -> npmpkg-http-cache-semantics-4.1.0.tgz
https://registry.npmjs.org/http-proxy-agent/-/http-proxy-agent-5.0.0.tgz -> npmpkg-http-proxy-agent-5.0.0.tgz
https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-5.0.1.tgz -> npmpkg-https-proxy-agent-5.0.1.tgz
https://registry.npmjs.org/iconv-corefoundation/-/iconv-corefoundation-1.1.7.tgz -> npmpkg-iconv-corefoundation-1.1.7.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.6.3.tgz -> npmpkg-iconv-lite-0.6.3.tgz
https://registry.npmjs.org/ieee754/-/ieee754-1.2.1.tgz -> npmpkg-ieee754-1.2.1.tgz
https://registry.npmjs.org/import-lazy/-/import-lazy-2.1.0.tgz -> npmpkg-import-lazy-2.1.0.tgz
https://registry.npmjs.org/imurmurhash/-/imurmurhash-0.1.4.tgz -> npmpkg-imurmurhash-0.1.4.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz -> npmpkg-inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz -> npmpkg-inherits-2.0.4.tgz
https://registry.npmjs.org/ini/-/ini-1.3.8.tgz -> npmpkg-ini-1.3.8.tgz
https://registry.npmjs.org/interpret/-/interpret-1.4.0.tgz -> npmpkg-interpret-1.4.0.tgz
https://registry.npmjs.org/is-ci/-/is-ci-3.0.1.tgz -> npmpkg-is-ci-3.0.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> npmpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/is-installed-globally/-/is-installed-globally-0.4.0.tgz -> npmpkg-is-installed-globally-0.4.0.tgz
https://registry.npmjs.org/is-npm/-/is-npm-5.0.0.tgz -> npmpkg-is-npm-5.0.0.tgz
https://registry.npmjs.org/is-obj/-/is-obj-2.0.0.tgz -> npmpkg-is-obj-2.0.0.tgz
https://registry.npmjs.org/is-path-inside/-/is-path-inside-3.0.3.tgz -> npmpkg-is-path-inside-3.0.3.tgz
https://registry.npmjs.org/is-typedarray/-/is-typedarray-1.0.0.tgz -> npmpkg-is-typedarray-1.0.0.tgz
https://registry.npmjs.org/is-yarn-global/-/is-yarn-global-0.3.0.tgz -> npmpkg-is-yarn-global-0.3.0.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/isbinaryfile/-/isbinaryfile-4.0.10.tgz -> npmpkg-isbinaryfile-4.0.10.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz -> npmpkg-isexe-2.0.0.tgz
https://registry.npmjs.org/jake/-/jake-10.8.5.tgz -> npmpkg-jake-10.8.5.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-4.1.0.tgz -> npmpkg-js-yaml-4.1.0.tgz
https://registry.npmjs.org/json-buffer/-/json-buffer-3.0.0.tgz -> npmpkg-json-buffer-3.0.0.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz -> npmpkg-json-schema-traverse-0.4.1.tgz
https://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz -> npmpkg-json-stringify-safe-5.0.1.tgz
https://registry.npmjs.org/json5/-/json5-2.2.3.tgz -> npmpkg-json5-2.2.3.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-4.0.0.tgz -> npmpkg-jsonfile-4.0.0.tgz
https://registry.npmjs.org/keyv/-/keyv-3.1.0.tgz -> npmpkg-keyv-3.1.0.tgz
https://registry.npmjs.org/latest-version/-/latest-version-5.1.0.tgz -> npmpkg-latest-version-5.1.0.tgz
https://registry.npmjs.org/lazy-val/-/lazy-val-1.0.5.tgz -> npmpkg-lazy-val-1.0.5.tgz
https://registry.npmjs.org/listenercount/-/listenercount-1.0.1.tgz -> npmpkg-listenercount-1.0.1.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/lowercase-keys/-/lowercase-keys-1.0.1.tgz -> npmpkg-lowercase-keys-1.0.1.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/make-dir/-/make-dir-3.1.0.tgz -> npmpkg-make-dir-3.1.0.tgz
https://registry.npmjs.org/matcher/-/matcher-3.0.0.tgz -> npmpkg-matcher-3.0.0.tgz
https://registry.npmjs.org/mime/-/mime-2.6.0.tgz -> npmpkg-mime-2.6.0.tgz
https://registry.npmjs.org/mime-db/-/mime-db-1.52.0.tgz -> npmpkg-mime-db-1.52.0.tgz
https://registry.npmjs.org/mime-types/-/mime-types-2.1.35.tgz -> npmpkg-mime-types-2.1.35.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-1.0.1.tgz -> npmpkg-mimic-response-1.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.0.4.tgz -> npmpkg-minimatch-3.0.4.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.5.tgz -> npmpkg-minimist-1.2.5.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.5.tgz -> npmpkg-mkdirp-0.5.5.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/node-addon-api/-/node-addon-api-1.7.2.tgz -> npmpkg-node-addon-api-1.7.2.tgz
https://registry.npmjs.org/normalize-url/-/normalize-url-4.5.1.tgz -> npmpkg-normalize-url-4.5.1.tgz
https://registry.npmjs.org/npm-conf/-/npm-conf-1.1.3.tgz -> npmpkg-npm-conf-1.1.3.tgz
https://registry.npmjs.org/object-keys/-/object-keys-1.1.1.tgz -> npmpkg-object-keys-1.1.1.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz -> npmpkg-once-1.4.0.tgz
https://registry.npmjs.org/p-cancelable/-/p-cancelable-1.1.0.tgz -> npmpkg-p-cancelable-1.1.0.tgz
https://registry.npmjs.org/package-json/-/package-json-6.5.0.tgz -> npmpkg-package-json-6.5.0.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> npmpkg-path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/path-parse/-/path-parse-1.0.6.tgz -> npmpkg-path-parse-1.0.6.tgz
https://registry.npmjs.org/pend/-/pend-1.2.0.tgz -> npmpkg-pend-1.2.0.tgz
https://registry.npmjs.org/pify/-/pify-3.0.0.tgz -> npmpkg-pify-3.0.0.tgz
https://registry.npmjs.org/plist/-/plist-3.0.6.tgz -> npmpkg-plist-3.0.6.tgz
https://registry.npmjs.org/prepend-http/-/prepend-http-2.0.0.tgz -> npmpkg-prepend-http-2.0.0.tgz
https://registry.npmjs.org/prettier/-/prettier-1.15.3.tgz -> npmpkg-prettier-1.15.3.tgz
https://registry.npmjs.org/process-nextick-args/-/process-nextick-args-2.0.1.tgz -> npmpkg-process-nextick-args-2.0.1.tgz
https://registry.npmjs.org/progress/-/progress-2.0.3.tgz -> npmpkg-progress-2.0.3.tgz
https://registry.npmjs.org/proto-list/-/proto-list-1.2.4.tgz -> npmpkg-proto-list-1.2.4.tgz
https://registry.npmjs.org/pump/-/pump-3.0.0.tgz -> npmpkg-pump-3.0.0.tgz
https://registry.npmjs.org/punycode/-/punycode-2.3.0.tgz -> npmpkg-punycode-2.3.0.tgz
https://registry.npmjs.org/pupa/-/pupa-2.1.1.tgz -> npmpkg-pupa-2.1.1.tgz
https://registry.npmjs.org/rc/-/rc-1.2.8.tgz -> npmpkg-rc-1.2.8.tgz
https://registry.npmjs.org/read-config-file/-/read-config-file-6.2.0.tgz -> npmpkg-read-config-file-6.2.0.tgz
https://registry.npmjs.org/dotenv/-/dotenv-9.0.2.tgz -> npmpkg-dotenv-9.0.2.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.7.tgz -> npmpkg-readable-stream-2.3.7.tgz
https://registry.npmjs.org/rechoir/-/rechoir-0.6.2.tgz -> npmpkg-rechoir-0.6.2.tgz
https://registry.npmjs.org/registry-auth-token/-/registry-auth-token-4.2.1.tgz -> npmpkg-registry-auth-token-4.2.1.tgz
https://registry.npmjs.org/registry-url/-/registry-url-5.1.0.tgz -> npmpkg-registry-url-5.1.0.tgz
https://registry.npmjs.org/require-directory/-/require-directory-2.1.1.tgz -> npmpkg-require-directory-2.1.1.tgz
https://registry.npmjs.org/resolve/-/resolve-1.17.0.tgz -> npmpkg-resolve-1.17.0.tgz
https://registry.npmjs.org/responselike/-/responselike-1.0.2.tgz -> npmpkg-responselike-1.0.2.tgz
https://registry.npmjs.org/rimraf/-/rimraf-3.0.2.tgz -> npmpkg-rimraf-3.0.2.tgz
https://registry.npmjs.org/roarr/-/roarr-2.15.4.tgz -> npmpkg-roarr-2.15.4.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/safer-buffer/-/safer-buffer-2.1.2.tgz -> npmpkg-safer-buffer-2.1.2.tgz
https://registry.npmjs.org/sanitize-filename/-/sanitize-filename-1.6.3.tgz -> npmpkg-sanitize-filename-1.6.3.tgz
https://registry.npmjs.org/sax/-/sax-1.2.4.tgz -> npmpkg-sax-1.2.4.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/semver-compare/-/semver-compare-1.0.0.tgz -> npmpkg-semver-compare-1.0.0.tgz
https://registry.npmjs.org/semver-diff/-/semver-diff-3.1.1.tgz -> npmpkg-semver-diff-3.1.1.tgz
https://registry.npmjs.org/serialize-error/-/serialize-error-7.0.1.tgz -> npmpkg-serialize-error-7.0.1.tgz
https://registry.npmjs.org/setimmediate/-/setimmediate-1.0.5.tgz -> npmpkg-setimmediate-1.0.5.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/shelljs/-/shelljs-0.8.4.tgz -> npmpkg-shelljs-0.8.4.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-3.0.7.tgz -> npmpkg-signal-exit-3.0.7.tgz
https://registry.npmjs.org/slice-ansi/-/slice-ansi-3.0.0.tgz -> npmpkg-slice-ansi-3.0.0.tgz
https://registry.npmjs.org/smart-buffer/-/smart-buffer-4.2.0.tgz -> npmpkg-smart-buffer-4.2.0.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/source-map-support/-/source-map-support-0.5.21.tgz -> npmpkg-source-map-support-0.5.21.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.1.2.tgz -> npmpkg-sprintf-js-1.1.2.tgz
https://registry.npmjs.org/stat-mode/-/stat-mode-1.0.0.tgz -> npmpkg-stat-mode-1.0.0.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-1.1.1.tgz -> npmpkg-string_decoder-1.1.1.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-2.0.1.tgz -> npmpkg-strip-json-comments-2.0.1.tgz
https://registry.npmjs.org/sumchecker/-/sumchecker-3.0.1.tgz -> npmpkg-sumchecker-3.0.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/temp-file/-/temp-file-3.4.0.tgz -> npmpkg-temp-file-3.4.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz -> npmpkg-universalify-2.0.0.tgz
https://registry.npmjs.org/tmp/-/tmp-0.2.1.tgz -> npmpkg-tmp-0.2.1.tgz
https://registry.npmjs.org/tmp-promise/-/tmp-promise-3.0.3.tgz -> npmpkg-tmp-promise-3.0.3.tgz
https://registry.npmjs.org/to-readable-stream/-/to-readable-stream-1.0.0.tgz -> npmpkg-to-readable-stream-1.0.0.tgz
https://registry.npmjs.org/traverse/-/traverse-0.3.9.tgz -> npmpkg-traverse-0.3.9.tgz
https://registry.npmjs.org/truncate-utf8-bytes/-/truncate-utf8-bytes-1.0.2.tgz -> npmpkg-truncate-utf8-bytes-1.0.2.tgz
https://registry.npmjs.org/tunnel/-/tunnel-0.0.6.tgz -> npmpkg-tunnel-0.0.6.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.13.1.tgz -> npmpkg-type-fest-0.13.1.tgz
https://registry.npmjs.org/typedarray/-/typedarray-0.0.6.tgz -> npmpkg-typedarray-0.0.6.tgz
https://registry.npmjs.org/typedarray-to-buffer/-/typedarray-to-buffer-3.1.5.tgz -> npmpkg-typedarray-to-buffer-3.1.5.tgz
https://registry.npmjs.org/unique-string/-/unique-string-2.0.0.tgz -> npmpkg-unique-string-2.0.0.tgz
https://registry.npmjs.org/universalify/-/universalify-0.1.2.tgz -> npmpkg-universalify-0.1.2.tgz
https://registry.npmjs.org/unzipper/-/unzipper-0.9.15.tgz -> npmpkg-unzipper-0.9.15.tgz
https://registry.npmjs.org/bluebird/-/bluebird-3.4.7.tgz -> npmpkg-bluebird-3.4.7.tgz
https://registry.npmjs.org/update-notifier/-/update-notifier-5.1.0.tgz -> npmpkg-update-notifier-5.1.0.tgz
https://registry.npmjs.org/ci-info/-/ci-info-2.0.0.tgz -> npmpkg-ci-info-2.0.0.tgz
https://registry.npmjs.org/is-ci/-/is-ci-2.0.0.tgz -> npmpkg-is-ci-2.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.3.7.tgz -> npmpkg-semver-7.3.7.tgz
https://registry.npmjs.org/uri-js/-/uri-js-4.4.1.tgz -> npmpkg-uri-js-4.4.1.tgz
https://registry.npmjs.org/url-parse-lax/-/url-parse-lax-3.0.0.tgz -> npmpkg-url-parse-lax-3.0.0.tgz
https://registry.npmjs.org/utf8-byte-length/-/utf8-byte-length-1.0.4.tgz -> npmpkg-utf8-byte-length-1.0.4.tgz
https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz -> npmpkg-util-deprecate-1.0.2.tgz
https://registry.npmjs.org/verror/-/verror-1.10.1.tgz -> npmpkg-verror-1.10.1.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/widest-line/-/widest-line-3.1.0.tgz -> npmpkg-widest-line-3.1.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> npmpkg-wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
https://registry.npmjs.org/write-file-atomic/-/write-file-atomic-3.0.3.tgz -> npmpkg-write-file-atomic-3.0.3.tgz
https://registry.npmjs.org/xdg-basedir/-/xdg-basedir-4.0.0.tgz -> npmpkg-xdg-basedir-4.0.0.tgz
https://registry.npmjs.org/xmlbuilder/-/xmlbuilder-15.1.1.tgz -> npmpkg-xmlbuilder-15.1.1.tgz
https://registry.npmjs.org/y18n/-/y18n-5.0.8.tgz -> npmpkg-y18n-5.0.8.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/yargs/-/yargs-17.4.1.tgz -> npmpkg-yargs-17.4.1.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-21.0.1.tgz -> npmpkg-yargs-parser-21.0.1.tgz
https://registry.npmjs.org/yauzl/-/yauzl-2.10.0.tgz -> npmpkg-yauzl-2.10.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/babel-plugin-polyfill-corejs3/-/babel-plugin-polyfill-corejs3-0.8.1.tgz -> npmpkg-babel-plugin-polyfill-corejs3-0.8.1.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/@babel/plugin-proposal-private-property-in-object/-/plugin-proposal-private-property-in-object-7.21.0-placeholder-for-preset-env.2.tgz -> npmpkg-@babel-plugin-proposal-private-property-in-object-7.21.0-placeholder-for-preset-env.2.tgz
https://registry.npmjs.org/babel-plugin-polyfill-corejs3/-/babel-plugin-polyfill-corejs3-0.8.1.tgz -> npmpkg-babel-plugin-polyfill-corejs3-0.8.1.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/globals/-/globals-13.20.0.tgz -> npmpkg-globals-13.20.0.tgz
https://registry.npmjs.org/ignore/-/ignore-4.0.6.tgz -> npmpkg-ignore-4.0.6.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz -> npmpkg-import-fresh-3.3.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz -> npmpkg-resolve-from-4.0.0.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-3.1.1.tgz -> npmpkg-strip-json-comments-3.1.1.tgz
https://registry.npmjs.org/@firebase/firestore/-/firestore-0.0.900-exp.d92a36260.tgz -> npmpkg-@firebase-firestore-0.0.900-exp.d92a36260.tgz
https://registry.npmjs.org/node-fetch/-/node-fetch-2.6.1.tgz -> npmpkg-node-fetch-2.6.1.tgz
https://registry.npmjs.org/camelcase/-/camelcase-5.3.1.tgz -> npmpkg-camelcase-5.3.1.tgz
https://registry.npmjs.org/find-up/-/find-up-4.1.0.tgz -> npmpkg-find-up-4.1.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-5.0.0.tgz -> npmpkg-locate-path-5.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-4.1.0.tgz -> npmpkg-p-locate-4.1.0.tgz
https://registry.npmjs.org/@jest/types/-/types-26.6.2.tgz -> npmpkg-@jest-types-26.6.2.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.1.tgz -> npmpkg-@types-istanbul-reports-3.0.1.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-15.0.15.tgz -> npmpkg-@types-yargs-15.0.15.tgz
https://registry.npmjs.org/@jest/types/-/types-26.6.2.tgz -> npmpkg-@jest-types-26.6.2.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.1.tgz -> npmpkg-@types-istanbul-reports-3.0.1.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-15.0.15.tgz -> npmpkg-@types-yargs-15.0.15.tgz
https://registry.npmjs.org/ansi-escapes/-/ansi-escapes-4.3.2.tgz -> npmpkg-ansi-escapes-4.3.2.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/jest-get-type/-/jest-get-type-26.3.0.tgz -> npmpkg-jest-get-type-26.3.0.tgz
https://registry.npmjs.org/jest-regex-util/-/jest-regex-util-26.0.0.tgz -> npmpkg-jest-regex-util-26.0.0.tgz
https://registry.npmjs.org/jest-resolve/-/jest-resolve-26.6.2.tgz -> npmpkg-jest-resolve-26.6.2.tgz
https://registry.npmjs.org/jest-validate/-/jest-validate-26.6.2.tgz -> npmpkg-jest-validate-26.6.2.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-26.6.2.tgz -> npmpkg-pretty-format-26.6.2.tgz
https://registry.npmjs.org/react-is/-/react-is-17.0.2.tgz -> npmpkg-react-is-17.0.2.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.21.3.tgz -> npmpkg-type-fest-0.21.3.tgz
https://registry.npmjs.org/@jest/types/-/types-26.6.2.tgz -> npmpkg-@jest-types-26.6.2.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.1.tgz -> npmpkg-@types-istanbul-reports-3.0.1.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-15.0.15.tgz -> npmpkg-@types-yargs-15.0.15.tgz
https://registry.npmjs.org/@jest/types/-/types-26.6.2.tgz -> npmpkg-@jest-types-26.6.2.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.1.tgz -> npmpkg-@types-istanbul-reports-3.0.1.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-15.0.15.tgz -> npmpkg-@types-yargs-15.0.15.tgz
https://registry.npmjs.org/@jest/types/-/types-26.6.2.tgz -> npmpkg-@jest-types-26.6.2.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.1.tgz -> npmpkg-@types-istanbul-reports-3.0.1.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-15.0.15.tgz -> npmpkg-@types-yargs-15.0.15.tgz
https://registry.npmjs.org/@jest/types/-/types-26.6.2.tgz -> npmpkg-@jest-types-26.6.2.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.1.tgz -> npmpkg-@types-istanbul-reports-3.0.1.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-15.0.15.tgz -> npmpkg-@types-yargs-15.0.15.tgz
https://registry.npmjs.org/istanbul-lib-instrument/-/istanbul-lib-instrument-4.0.3.tgz -> npmpkg-istanbul-lib-instrument-4.0.3.tgz
https://registry.npmjs.org/jest-resolve/-/jest-resolve-26.6.2.tgz -> npmpkg-jest-resolve-26.6.2.tgz
https://registry.npmjs.org/jest-worker/-/jest-worker-26.6.2.tgz -> npmpkg-jest-worker-26.6.2.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/v8-to-istanbul/-/v8-to-istanbul-7.1.2.tgz -> npmpkg-v8-to-istanbul-7.1.2.tgz
https://registry.npmjs.org/source-map/-/source-map-0.7.4.tgz -> npmpkg-source-map-0.7.4.tgz
https://registry.npmjs.org/callsites/-/callsites-3.1.0.tgz -> npmpkg-callsites-3.1.0.tgz
https://registry.npmjs.org/@jest/types/-/types-26.6.2.tgz -> npmpkg-@jest-types-26.6.2.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.1.tgz -> npmpkg-@types-istanbul-reports-3.0.1.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-15.0.15.tgz -> npmpkg-@types-yargs-15.0.15.tgz
https://registry.npmjs.org/@jest/types/-/types-26.6.2.tgz -> npmpkg-@jest-types-26.6.2.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.1.tgz -> npmpkg-@types-istanbul-reports-3.0.1.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-15.0.15.tgz -> npmpkg-@types-yargs-15.0.15.tgz
https://registry.npmjs.org/jest-regex-util/-/jest-regex-util-26.0.0.tgz -> npmpkg-jest-regex-util-26.0.0.tgz
https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.4.14.tgz -> npmpkg-@jridgewell-sourcemap-codec-1.4.14.tgz
https://registry.npmjs.org/date-fns/-/date-fns-1.30.1.tgz -> npmpkg-date-fns-1.30.1.tgz
https://registry.npmjs.org/@babel/core/-/core-7.12.9.tgz -> npmpkg-@babel-core-7.12.9.tgz
https://registry.npmjs.org/@babel/plugin-syntax-jsx/-/plugin-syntax-jsx-7.12.1.tgz -> npmpkg-@babel-plugin-syntax-jsx-7.12.1.tgz
https://registry.npmjs.org/ccount/-/ccount-1.1.0.tgz -> npmpkg-ccount-1.1.0.tgz
https://registry.npmjs.org/remark-parse/-/remark-parse-8.0.3.tgz -> npmpkg-remark-parse-8.0.3.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.5.3.tgz -> npmpkg-semver-7.5.3.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-1.0.4.tgz -> npmpkg-mkdirp-1.0.4.tgz
https://registry.npmjs.org/@storybook/components/-/components-6.3.12.tgz -> npmpkg-@storybook-components-6.3.12.tgz
https://registry.npmjs.org/@storybook/core-events/-/core-events-6.3.12.tgz -> npmpkg-@storybook-core-events-6.3.12.tgz
https://registry.npmjs.org/@storybook/theming/-/theming-6.3.12.tgz -> npmpkg-@storybook-theming-6.3.12.tgz
https://registry.npmjs.org/@storybook/components/-/components-6.3.12.tgz -> npmpkg-@storybook-components-6.3.12.tgz
https://registry.npmjs.org/@storybook/core-events/-/core-events-6.3.12.tgz -> npmpkg-@storybook-core-events-6.3.12.tgz
https://registry.npmjs.org/@storybook/theming/-/theming-6.3.12.tgz -> npmpkg-@storybook-theming-6.3.12.tgz
https://registry.npmjs.org/@storybook/components/-/components-6.3.12.tgz -> npmpkg-@storybook-components-6.3.12.tgz
https://registry.npmjs.org/@storybook/theming/-/theming-6.3.12.tgz -> npmpkg-@storybook-theming-6.3.12.tgz
https://registry.npmjs.org/@storybook/addon-docs/-/addon-docs-6.3.12.tgz -> npmpkg-@storybook-addon-docs-6.3.12.tgz
https://registry.npmjs.org/@storybook/builder-webpack4/-/builder-webpack4-6.3.12.tgz -> npmpkg-@storybook-builder-webpack4-6.3.12.tgz
https://registry.npmjs.org/@storybook/core-common/-/core-common-6.3.12.tgz -> npmpkg-@storybook-core-common-6.3.12.tgz
https://registry.npmjs.org/babel-plugin-macros/-/babel-plugin-macros-3.1.0.tgz -> npmpkg-babel-plugin-macros-3.1.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/fork-ts-checker-webpack-plugin/-/fork-ts-checker-webpack-plugin-6.5.3.tgz -> npmpkg-fork-ts-checker-webpack-plugin-6.5.3.tgz
https://registry.npmjs.org/cosmiconfig/-/cosmiconfig-6.0.0.tgz -> npmpkg-cosmiconfig-6.0.0.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-2.7.0.tgz -> npmpkg-schema-utils-2.7.0.tgz
https://registry.npmjs.org/semver/-/semver-7.5.3.tgz -> npmpkg-semver-7.5.3.tgz
https://registry.npmjs.org/@storybook/ui/-/ui-6.3.12.tgz -> npmpkg-@storybook-ui-6.3.12.tgz
https://registry.npmjs.org/@types/node/-/node-14.18.51.tgz -> npmpkg-@types-node-14.18.51.tgz
https://registry.npmjs.org/babel-loader/-/babel-loader-8.3.0.tgz -> npmpkg-babel-loader-8.3.0.tgz
https://registry.npmjs.org/cosmiconfig/-/cosmiconfig-7.1.0.tgz -> npmpkg-cosmiconfig-7.1.0.tgz
https://registry.npmjs.org/downshift/-/downshift-6.1.12.tgz -> npmpkg-downshift-6.1.12.tgz
https://registry.npmjs.org/find-cache-dir/-/find-cache-dir-3.3.2.tgz -> npmpkg-find-cache-dir-3.3.2.tgz
https://registry.npmjs.org/find-up/-/find-up-4.1.0.tgz -> npmpkg-find-up-4.1.0.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-4.2.0.tgz -> npmpkg-pkg-dir-4.2.0.tgz
https://registry.npmjs.org/fork-ts-checker-webpack-plugin/-/fork-ts-checker-webpack-plugin-4.1.6.tgz -> npmpkg-fork-ts-checker-webpack-plugin-4.1.6.tgz
https://registry.npmjs.org/micromatch/-/micromatch-3.1.10.tgz -> npmpkg-micromatch-3.1.10.tgz
https://registry.npmjs.org/fuse.js/-/fuse.js-3.6.1.tgz -> npmpkg-fuse.js-3.6.1.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz -> npmpkg-import-fresh-3.3.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz -> npmpkg-resolve-from-4.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-5.0.0.tgz -> npmpkg-locate-path-5.0.0.tgz
https://registry.npmjs.org/make-dir/-/make-dir-3.1.0.tgz -> npmpkg-make-dir-3.1.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/markdown-to-jsx/-/markdown-to-jsx-6.11.4.tgz -> npmpkg-markdown-to-jsx-6.11.4.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-4.1.0.tgz -> npmpkg-p-locate-4.1.0.tgz
https://registry.npmjs.org/parse-json/-/parse-json-5.2.0.tgz -> npmpkg-parse-json-5.2.0.tgz
https://registry.npmjs.org/react-is/-/react-is-17.0.2.tgz -> npmpkg-react-is-17.0.2.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-2.7.1.tgz -> npmpkg-schema-utils-2.7.1.tgz
https://registry.npmjs.org/semver/-/semver-5.7.1.tgz -> npmpkg-semver-5.7.1.tgz
https://registry.npmjs.org/@storybook/components/-/components-6.3.12.tgz -> npmpkg-@storybook-components-6.3.12.tgz
https://registry.npmjs.org/@storybook/core/-/core-6.3.12.tgz -> npmpkg-@storybook-core-6.3.12.tgz
https://registry.npmjs.org/@storybook/core-events/-/core-events-6.3.12.tgz -> npmpkg-@storybook-core-events-6.3.12.tgz
https://registry.npmjs.org/@storybook/core-client/-/core-client-6.3.12.tgz -> npmpkg-@storybook-core-client-6.3.12.tgz
https://registry.npmjs.org/@storybook/core-common/-/core-common-6.3.12.tgz -> npmpkg-@storybook-core-common-6.3.12.tgz
https://registry.npmjs.org/@storybook/core-server/-/core-server-6.3.12.tgz -> npmpkg-@storybook-core-server-6.3.12.tgz
https://registry.npmjs.org/@storybook/manager-webpack4/-/manager-webpack4-6.3.12.tgz -> npmpkg-@storybook-manager-webpack4-6.3.12.tgz
https://registry.npmjs.org/@storybook/ui/-/ui-6.3.12.tgz -> npmpkg-@storybook-ui-6.3.12.tgz
https://registry.npmjs.org/@types/node/-/node-14.18.51.tgz -> npmpkg-@types-node-14.18.51.tgz
https://registry.npmjs.org/babel-loader/-/babel-loader-8.3.0.tgz -> npmpkg-babel-loader-8.3.0.tgz
https://registry.npmjs.org/babel-plugin-macros/-/babel-plugin-macros-3.1.0.tgz -> npmpkg-babel-plugin-macros-3.1.0.tgz
https://registry.npmjs.org/boxen/-/boxen-4.2.0.tgz -> npmpkg-boxen-4.2.0.tgz
https://registry.npmjs.org/chalk/-/chalk-3.0.0.tgz -> npmpkg-chalk-3.0.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-5.3.1.tgz -> npmpkg-camelcase-5.3.1.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/cli-table3/-/cli-table3-0.6.0.tgz -> npmpkg-cli-table3-0.6.0.tgz
https://registry.npmjs.org/colors/-/colors-1.4.0.tgz -> npmpkg-colors-1.4.0.tgz
https://registry.npmjs.org/commander/-/commander-6.2.1.tgz -> npmpkg-commander-6.2.1.tgz
https://registry.npmjs.org/cosmiconfig/-/cosmiconfig-7.1.0.tgz -> npmpkg-cosmiconfig-7.1.0.tgz
https://registry.npmjs.org/downshift/-/downshift-6.1.12.tgz -> npmpkg-downshift-6.1.12.tgz
https://registry.npmjs.org/find-cache-dir/-/find-cache-dir-3.3.2.tgz -> npmpkg-find-cache-dir-3.3.2.tgz
https://registry.npmjs.org/find-up/-/find-up-4.1.0.tgz -> npmpkg-find-up-4.1.0.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-4.2.0.tgz -> npmpkg-pkg-dir-4.2.0.tgz
https://registry.npmjs.org/fuse.js/-/fuse.js-3.6.1.tgz -> npmpkg-fuse.js-3.6.1.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz -> npmpkg-import-fresh-3.3.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz -> npmpkg-resolve-from-4.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-5.0.0.tgz -> npmpkg-locate-path-5.0.0.tgz
https://registry.npmjs.org/make-dir/-/make-dir-3.1.0.tgz -> npmpkg-make-dir-3.1.0.tgz
https://registry.npmjs.org/markdown-to-jsx/-/markdown-to-jsx-6.11.4.tgz -> npmpkg-markdown-to-jsx-6.11.4.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-4.1.0.tgz -> npmpkg-p-locate-4.1.0.tgz
https://registry.npmjs.org/parse-json/-/parse-json-5.2.0.tgz -> npmpkg-parse-json-5.2.0.tgz
https://registry.npmjs.org/react-is/-/react-is-17.0.2.tgz -> npmpkg-react-is-17.0.2.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-2.7.1.tgz -> npmpkg-schema-utils-2.7.1.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.8.1.tgz -> npmpkg-type-fest-0.8.1.tgz
https://registry.npmjs.org/@storybook/csf-tools/-/csf-tools-6.3.12.tgz -> npmpkg-@storybook-csf-tools-6.3.12.tgz
https://registry.npmjs.org/@storybook/theming/-/theming-6.3.12.tgz -> npmpkg-@storybook-theming-6.3.12.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/prettier/-/prettier-2.2.1.tgz -> npmpkg-prettier-2.2.1.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/@storybook/components/-/components-6.3.12.tgz -> npmpkg-@storybook-components-6.3.12.tgz
https://registry.npmjs.org/@storybook/theming/-/theming-6.3.12.tgz -> npmpkg-@storybook-theming-6.3.12.tgz
https://registry.npmjs.org/@storybook/components/-/components-6.3.12.tgz -> npmpkg-@storybook-components-6.3.12.tgz
https://registry.npmjs.org/@storybook/core-events/-/core-events-6.3.12.tgz -> npmpkg-@storybook-core-events-6.3.12.tgz
https://registry.npmjs.org/@storybook/theming/-/theming-6.3.12.tgz -> npmpkg-@storybook-theming-6.3.12.tgz
https://registry.npmjs.org/@storybook/core-events/-/core-events-6.3.12.tgz -> npmpkg-@storybook-core-events-6.3.12.tgz
https://registry.npmjs.org/@storybook/theming/-/theming-6.3.12.tgz -> npmpkg-@storybook-theming-6.3.12.tgz
https://registry.npmjs.org/@storybook/core-events/-/core-events-6.3.12.tgz -> npmpkg-@storybook-core-events-6.3.12.tgz
https://registry.npmjs.org/@storybook/theming/-/theming-6.3.12.tgz -> npmpkg-@storybook-theming-6.3.12.tgz
https://registry.npmjs.org/@storybook/addons/-/addons-6.5.16.tgz -> npmpkg-@storybook-addons-6.5.16.tgz
https://registry.npmjs.org/@storybook/api/-/api-6.5.16.tgz -> npmpkg-@storybook-api-6.5.16.tgz
https://registry.npmjs.org/@storybook/channel-postmessage/-/channel-postmessage-6.5.16.tgz -> npmpkg-@storybook-channel-postmessage-6.5.16.tgz
https://registry.npmjs.org/@storybook/channels/-/channels-6.5.16.tgz -> npmpkg-@storybook-channels-6.5.16.tgz
https://registry.npmjs.org/@storybook/client-api/-/client-api-6.5.16.tgz -> npmpkg-@storybook-client-api-6.5.16.tgz
https://registry.npmjs.org/@storybook/client-logger/-/client-logger-6.5.16.tgz -> npmpkg-@storybook-client-logger-6.5.16.tgz
https://registry.npmjs.org/@storybook/csf/-/csf-0.0.2--canary.4566f4d.1.tgz -> npmpkg-@storybook-csf-0.0.2--canary.4566f4d.1.tgz
https://registry.npmjs.org/@storybook/node-logger/-/node-logger-6.5.16.tgz -> npmpkg-@storybook-node-logger-6.5.16.tgz
https://registry.npmjs.org/@storybook/router/-/router-6.5.16.tgz -> npmpkg-@storybook-router-6.5.16.tgz
https://registry.npmjs.org/@storybook/ui/-/ui-6.5.16.tgz -> npmpkg-@storybook-ui-6.5.16.tgz
https://registry.npmjs.org/fork-ts-checker-webpack-plugin/-/fork-ts-checker-webpack-plugin-4.1.6.tgz -> npmpkg-fork-ts-checker-webpack-plugin-4.1.6.tgz
https://registry.npmjs.org/npmlog/-/npmlog-5.0.1.tgz -> npmpkg-npmlog-5.0.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/are-we-there-yet/-/are-we-there-yet-2.0.0.tgz -> npmpkg-are-we-there-yet-2.0.0.tgz
https://registry.npmjs.org/gauge/-/gauge-3.0.2.tgz -> npmpkg-gauge-3.0.2.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/telejson/-/telejson-6.0.8.tgz -> npmpkg-telejson-6.0.8.tgz
https://registry.npmjs.org/isobject/-/isobject-4.0.0.tgz -> npmpkg-isobject-4.0.0.tgz
https://registry.npmjs.org/@storybook/core-events/-/core-events-6.3.12.tgz -> npmpkg-@storybook-core-events-6.3.12.tgz
https://registry.npmjs.org/@storybook/channels/-/channels-6.5.16.tgz -> npmpkg-@storybook-channels-6.5.16.tgz
https://registry.npmjs.org/@storybook/client-logger/-/client-logger-6.5.16.tgz -> npmpkg-@storybook-client-logger-6.5.16.tgz
https://registry.npmjs.org/isobject/-/isobject-4.0.0.tgz -> npmpkg-isobject-4.0.0.tgz
https://registry.npmjs.org/telejson/-/telejson-6.0.8.tgz -> npmpkg-telejson-6.0.8.tgz
https://registry.npmjs.org/@storybook/core-events/-/core-events-6.3.12.tgz -> npmpkg-@storybook-core-events-6.3.12.tgz
https://registry.npmjs.org/@storybook/client-logger/-/client-logger-6.5.16.tgz -> npmpkg-@storybook-client-logger-6.5.16.tgz
https://registry.npmjs.org/@storybook/csf/-/csf-0.0.2--canary.4566f4d.1.tgz -> npmpkg-@storybook-csf-0.0.2--canary.4566f4d.1.tgz
https://registry.npmjs.org/@storybook/addons/-/addons-6.5.16.tgz -> npmpkg-@storybook-addons-6.5.16.tgz
https://registry.npmjs.org/@storybook/api/-/api-6.5.16.tgz -> npmpkg-@storybook-api-6.5.16.tgz
https://registry.npmjs.org/@storybook/channel-postmessage/-/channel-postmessage-6.5.16.tgz -> npmpkg-@storybook-channel-postmessage-6.5.16.tgz
https://registry.npmjs.org/@storybook/channels/-/channels-6.5.16.tgz -> npmpkg-@storybook-channels-6.5.16.tgz
https://registry.npmjs.org/@storybook/client-api/-/client-api-6.5.16.tgz -> npmpkg-@storybook-client-api-6.5.16.tgz
https://registry.npmjs.org/@storybook/client-logger/-/client-logger-6.5.16.tgz -> npmpkg-@storybook-client-logger-6.5.16.tgz
https://registry.npmjs.org/@storybook/csf/-/csf-0.0.2--canary.4566f4d.1.tgz -> npmpkg-@storybook-csf-0.0.2--canary.4566f4d.1.tgz
https://registry.npmjs.org/@storybook/router/-/router-6.5.16.tgz -> npmpkg-@storybook-router-6.5.16.tgz
https://registry.npmjs.org/@storybook/ui/-/ui-6.5.16.tgz -> npmpkg-@storybook-ui-6.5.16.tgz
https://registry.npmjs.org/telejson/-/telejson-6.0.8.tgz -> npmpkg-telejson-6.0.8.tgz
https://registry.npmjs.org/isobject/-/isobject-4.0.0.tgz -> npmpkg-isobject-4.0.0.tgz
https://registry.npmjs.org/@storybook/node-logger/-/node-logger-6.5.16.tgz -> npmpkg-@storybook-node-logger-6.5.16.tgz
https://registry.npmjs.org/babel-plugin-macros/-/babel-plugin-macros-3.1.0.tgz -> npmpkg-babel-plugin-macros-3.1.0.tgz
https://registry.npmjs.org/cosmiconfig/-/cosmiconfig-7.1.0.tgz -> npmpkg-cosmiconfig-7.1.0.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz -> npmpkg-import-fresh-3.3.0.tgz
https://registry.npmjs.org/parse-json/-/parse-json-5.2.0.tgz -> npmpkg-parse-json-5.2.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz -> npmpkg-resolve-from-4.0.0.tgz
https://registry.npmjs.org/isobject/-/isobject-4.0.0.tgz -> npmpkg-isobject-4.0.0.tgz
https://registry.npmjs.org/npmlog/-/npmlog-5.0.1.tgz -> npmpkg-npmlog-5.0.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/are-we-there-yet/-/are-we-there-yet-2.0.0.tgz -> npmpkg-are-we-there-yet-2.0.0.tgz
https://registry.npmjs.org/gauge/-/gauge-3.0.2.tgz -> npmpkg-gauge-3.0.2.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/telejson/-/telejson-6.0.8.tgz -> npmpkg-telejson-6.0.8.tgz
https://registry.npmjs.org/@storybook/csf/-/csf-0.0.2--canary.4566f4d.1.tgz -> npmpkg-@storybook-csf-0.0.2--canary.4566f4d.1.tgz
https://registry.npmjs.org/@storybook/node-logger/-/node-logger-6.5.16.tgz -> npmpkg-@storybook-node-logger-6.5.16.tgz
https://registry.npmjs.org/commander/-/commander-6.2.1.tgz -> npmpkg-commander-6.2.1.tgz
https://registry.npmjs.org/isobject/-/isobject-4.0.0.tgz -> npmpkg-isobject-4.0.0.tgz
https://registry.npmjs.org/npmlog/-/npmlog-5.0.1.tgz -> npmpkg-npmlog-5.0.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/are-we-there-yet/-/are-we-there-yet-2.0.0.tgz -> npmpkg-are-we-there-yet-2.0.0.tgz
https://registry.npmjs.org/gauge/-/gauge-3.0.2.tgz -> npmpkg-gauge-3.0.2.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/telejson/-/telejson-6.0.8.tgz -> npmpkg-telejson-6.0.8.tgz
https://registry.npmjs.org/@storybook/csf/-/csf-0.0.2--canary.4566f4d.1.tgz -> npmpkg-@storybook-csf-0.0.2--canary.4566f4d.1.tgz
https://registry.npmjs.org/@storybook/csf/-/csf-0.0.2--canary.4566f4d.1.tgz -> npmpkg-@storybook-csf-0.0.2--canary.4566f4d.1.tgz
https://registry.npmjs.org/@storybook/addons/-/addons-6.5.16.tgz -> npmpkg-@storybook-addons-6.5.16.tgz
https://registry.npmjs.org/@storybook/api/-/api-6.5.16.tgz -> npmpkg-@storybook-api-6.5.16.tgz
https://registry.npmjs.org/@storybook/channels/-/channels-6.5.16.tgz -> npmpkg-@storybook-channels-6.5.16.tgz
https://registry.npmjs.org/@storybook/client-logger/-/client-logger-6.5.16.tgz -> npmpkg-@storybook-client-logger-6.5.16.tgz
https://registry.npmjs.org/@storybook/csf/-/csf-0.0.2--canary.4566f4d.1.tgz -> npmpkg-@storybook-csf-0.0.2--canary.4566f4d.1.tgz
https://registry.npmjs.org/@storybook/node-logger/-/node-logger-6.5.16.tgz -> npmpkg-@storybook-node-logger-6.5.16.tgz
https://registry.npmjs.org/@storybook/router/-/router-6.5.16.tgz -> npmpkg-@storybook-router-6.5.16.tgz
https://registry.npmjs.org/@storybook/ui/-/ui-6.5.16.tgz -> npmpkg-@storybook-ui-6.5.16.tgz
https://registry.npmjs.org/isobject/-/isobject-4.0.0.tgz -> npmpkg-isobject-4.0.0.tgz
https://registry.npmjs.org/npmlog/-/npmlog-5.0.1.tgz -> npmpkg-npmlog-5.0.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/are-we-there-yet/-/are-we-there-yet-2.0.0.tgz -> npmpkg-are-we-there-yet-2.0.0.tgz
https://registry.npmjs.org/gauge/-/gauge-3.0.2.tgz -> npmpkg-gauge-3.0.2.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/telejson/-/telejson-6.0.8.tgz -> npmpkg-telejson-6.0.8.tgz
https://registry.npmjs.org/prettier/-/prettier-2.3.0.tgz -> npmpkg-prettier-2.3.0.tgz
https://registry.npmjs.org/@storybook/addons/-/addons-6.5.16.tgz -> npmpkg-@storybook-addons-6.5.16.tgz
https://registry.npmjs.org/@storybook/api/-/api-6.5.16.tgz -> npmpkg-@storybook-api-6.5.16.tgz
https://registry.npmjs.org/@storybook/channel-postmessage/-/channel-postmessage-6.5.16.tgz -> npmpkg-@storybook-channel-postmessage-6.5.16.tgz
https://registry.npmjs.org/@storybook/channels/-/channels-6.5.16.tgz -> npmpkg-@storybook-channels-6.5.16.tgz
https://registry.npmjs.org/@storybook/client-logger/-/client-logger-6.5.16.tgz -> npmpkg-@storybook-client-logger-6.5.16.tgz
https://registry.npmjs.org/@storybook/csf/-/csf-0.0.2--canary.4566f4d.1.tgz -> npmpkg-@storybook-csf-0.0.2--canary.4566f4d.1.tgz
https://registry.npmjs.org/@storybook/router/-/router-6.5.16.tgz -> npmpkg-@storybook-router-6.5.16.tgz
https://registry.npmjs.org/telejson/-/telejson-6.0.8.tgz -> npmpkg-telejson-6.0.8.tgz
https://registry.npmjs.org/isobject/-/isobject-4.0.0.tgz -> npmpkg-isobject-4.0.0.tgz
https://registry.npmjs.org/find-cache-dir/-/find-cache-dir-3.3.2.tgz -> npmpkg-find-cache-dir-3.3.2.tgz
https://registry.npmjs.org/make-dir/-/make-dir-3.1.0.tgz -> npmpkg-make-dir-3.1.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-4.2.0.tgz -> npmpkg-pkg-dir-4.2.0.tgz
https://registry.npmjs.org/find-up/-/find-up-4.1.0.tgz -> npmpkg-find-up-4.1.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-5.0.0.tgz -> npmpkg-locate-path-5.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-4.1.0.tgz -> npmpkg-p-locate-4.1.0.tgz
https://registry.npmjs.org/@storybook/addons/-/addons-6.5.16.tgz -> npmpkg-@storybook-addons-6.5.16.tgz
https://registry.npmjs.org/@storybook/api/-/api-6.5.16.tgz -> npmpkg-@storybook-api-6.5.16.tgz
https://registry.npmjs.org/isobject/-/isobject-4.0.0.tgz -> npmpkg-isobject-4.0.0.tgz
https://registry.npmjs.org/telejson/-/telejson-6.0.8.tgz -> npmpkg-telejson-6.0.8.tgz
https://registry.npmjs.org/@storybook/channels/-/channels-6.5.16.tgz -> npmpkg-@storybook-channels-6.5.16.tgz
https://registry.npmjs.org/@storybook/client-logger/-/client-logger-6.5.16.tgz -> npmpkg-@storybook-client-logger-6.5.16.tgz
https://registry.npmjs.org/@storybook/csf/-/csf-0.0.2--canary.4566f4d.1.tgz -> npmpkg-@storybook-csf-0.0.2--canary.4566f4d.1.tgz
https://registry.npmjs.org/@storybook/node-logger/-/node-logger-6.5.16.tgz -> npmpkg-@storybook-node-logger-6.5.16.tgz
https://registry.npmjs.org/@storybook/router/-/router-6.5.16.tgz -> npmpkg-@storybook-router-6.5.16.tgz
https://registry.npmjs.org/npmlog/-/npmlog-5.0.1.tgz -> npmpkg-npmlog-5.0.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/are-we-there-yet/-/are-we-there-yet-2.0.0.tgz -> npmpkg-are-we-there-yet-2.0.0.tgz
https://registry.npmjs.org/gauge/-/gauge-3.0.2.tgz -> npmpkg-gauge-3.0.2.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/find-up/-/find-up-4.1.0.tgz -> npmpkg-find-up-4.1.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-5.0.0.tgz -> npmpkg-locate-path-5.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-4.1.0.tgz -> npmpkg-p-locate-4.1.0.tgz
https://registry.npmjs.org/@storybook/addons/-/addons-6.5.16.tgz -> npmpkg-@storybook-addons-6.5.16.tgz
https://registry.npmjs.org/@storybook/api/-/api-6.5.16.tgz -> npmpkg-@storybook-api-6.5.16.tgz
https://registry.npmjs.org/isobject/-/isobject-4.0.0.tgz -> npmpkg-isobject-4.0.0.tgz
https://registry.npmjs.org/telejson/-/telejson-6.0.8.tgz -> npmpkg-telejson-6.0.8.tgz
https://registry.npmjs.org/@storybook/channels/-/channels-6.5.16.tgz -> npmpkg-@storybook-channels-6.5.16.tgz
https://registry.npmjs.org/@storybook/client-logger/-/client-logger-6.5.16.tgz -> npmpkg-@storybook-client-logger-6.5.16.tgz
https://registry.npmjs.org/@storybook/csf/-/csf-0.0.2--canary.4566f4d.1.tgz -> npmpkg-@storybook-csf-0.0.2--canary.4566f4d.1.tgz
https://registry.npmjs.org/@storybook/router/-/router-6.5.16.tgz -> npmpkg-@storybook-router-6.5.16.tgz
https://registry.npmjs.org/@storybook/client-logger/-/client-logger-6.5.16.tgz -> npmpkg-@storybook-client-logger-6.5.16.tgz
https://registry.npmjs.org/@storybook/client-logger/-/client-logger-6.5.16.tgz -> npmpkg-@storybook-client-logger-6.5.16.tgz
https://registry.npmjs.org/cosmiconfig/-/cosmiconfig-7.1.0.tgz -> npmpkg-cosmiconfig-7.1.0.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz -> npmpkg-import-fresh-3.3.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz -> npmpkg-resolve-from-4.0.0.tgz
https://registry.npmjs.org/parse-json/-/parse-json-5.2.0.tgz -> npmpkg-parse-json-5.2.0.tgz
https://registry.npmjs.org/cosmiconfig/-/cosmiconfig-7.1.0.tgz -> npmpkg-cosmiconfig-7.1.0.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz -> npmpkg-import-fresh-3.3.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz -> npmpkg-resolve-from-4.0.0.tgz
https://registry.npmjs.org/parse-json/-/parse-json-5.2.0.tgz -> npmpkg-parse-json-5.2.0.tgz
https://registry.npmjs.org/csstype/-/csstype-3.1.2.tgz -> npmpkg-csstype-3.1.2.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.5.3.tgz -> npmpkg-semver-7.5.3.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.5.3.tgz -> npmpkg-semver-7.5.3.tgz
https://registry.npmjs.org/algoliasearch/-/algoliasearch-3.33.0.tgz -> npmpkg-algoliasearch-3.33.0.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.0.tgz -> npmpkg-bn.js-4.12.0.tgz
https://registry.npmjs.org/axios/-/axios-0.18.1.tgz -> npmpkg-axios-0.18.1.tgz
https://registry.npmjs.org/axios-mock-adapter/-/axios-mock-adapter-1.21.5.tgz -> npmpkg-axios-mock-adapter-1.21.5.tgz
https://registry.npmjs.org/debug/-/debug-3.1.0.tgz -> npmpkg-debug-3.1.0.tgz
https://registry.npmjs.org/follow-redirects/-/follow-redirects-1.5.10.tgz -> npmpkg-follow-redirects-1.5.10.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/babel-core/-/babel-core-7.0.0-bridge.0.tgz -> npmpkg-babel-core-7.0.0-bridge.0.tgz
https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-1.3.0.tgz -> npmpkg-eslint-visitor-keys-1.3.0.tgz
https://registry.npmjs.org/@jest/types/-/types-26.6.2.tgz -> npmpkg-@jest-types-26.6.2.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.1.tgz -> npmpkg-@types-istanbul-reports-3.0.1.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-15.0.15.tgz -> npmpkg-@types-yargs-15.0.15.tgz
https://registry.npmjs.org/babel-loader/-/babel-loader-8.1.0.tgz -> npmpkg-babel-loader-8.1.0.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-2.7.1.tgz -> npmpkg-schema-utils-2.7.1.tgz
https://registry.npmjs.org/@babel/helper-plugin-utils/-/helper-plugin-utils-7.10.4.tgz -> npmpkg-@babel-helper-plugin-utils-7.10.4.tgz
https://registry.npmjs.org/@babel/helper-plugin-utils/-/helper-plugin-utils-7.10.4.tgz -> npmpkg-@babel-helper-plugin-utils-7.10.4.tgz
https://registry.npmjs.org/babel-plugin-macros/-/babel-plugin-macros-2.8.0.tgz -> npmpkg-babel-plugin-macros-2.8.0.tgz
https://registry.npmjs.org/cosmiconfig/-/cosmiconfig-6.0.0.tgz -> npmpkg-cosmiconfig-6.0.0.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz -> npmpkg-import-fresh-3.3.0.tgz
https://registry.npmjs.org/parse-json/-/parse-json-5.2.0.tgz -> npmpkg-parse-json-5.2.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz -> npmpkg-resolve-from-4.0.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/@babel/helper-define-polyfill-provider/-/helper-define-polyfill-provider-0.1.5.tgz -> npmpkg-@babel-helper-define-polyfill-provider-0.1.5.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/babel-plugin-macros/-/babel-plugin-macros-3.1.0.tgz -> npmpkg-babel-plugin-macros-3.1.0.tgz
https://registry.npmjs.org/cosmiconfig/-/cosmiconfig-7.1.0.tgz -> npmpkg-cosmiconfig-7.1.0.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz -> npmpkg-import-fresh-3.3.0.tgz
https://registry.npmjs.org/parse-json/-/parse-json-5.2.0.tgz -> npmpkg-parse-json-5.2.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz -> npmpkg-resolve-from-4.0.0.tgz
https://registry.npmjs.org/open/-/open-7.4.2.tgz -> npmpkg-open-7.4.2.tgz
https://registry.npmjs.org/blueimp-md5/-/blueimp-md5-2.19.0.tgz -> npmpkg-blueimp-md5-2.19.0.tgz
https://registry.npmjs.org/array-flatten/-/array-flatten-2.1.2.tgz -> npmpkg-array-flatten-2.1.2.tgz
https://registry.npmjs.org/cliui/-/cliui-7.0.4.tgz -> npmpkg-cliui-7.0.4.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/y18n/-/y18n-5.0.8.tgz -> npmpkg-y18n-5.0.8.tgz
https://registry.npmjs.org/yargs/-/yargs-16.2.0.tgz -> npmpkg-yargs-16.2.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-1.0.4.tgz -> npmpkg-mkdirp-1.0.4.tgz
https://registry.npmjs.org/p-map/-/p-map-4.0.0.tgz -> npmpkg-p-map-4.0.0.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.2.tgz -> npmpkg-fsevents-2.3.2.tgz
https://registry.npmjs.org/core-js/-/core-js-3.31.0.tgz -> npmpkg-core-js-3.31.0.tgz
https://registry.npmjs.org/make-dir/-/make-dir-3.1.0.tgz -> npmpkg-make-dir-3.1.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/@types/glob/-/glob-7.2.0.tgz -> npmpkg-@types-glob-7.2.0.tgz
https://registry.npmjs.org/dir-glob/-/dir-glob-2.2.2.tgz -> npmpkg-dir-glob-2.2.2.tgz
https://registry.npmjs.org/fast-glob/-/fast-glob-2.2.7.tgz -> npmpkg-fast-glob-2.2.7.tgz
https://registry.npmjs.org/@nodelib/fs.stat/-/fs.stat-1.1.3.tgz -> npmpkg-@nodelib-fs.stat-1.1.3.tgz
https://registry.npmjs.org/globby/-/globby-9.2.0.tgz -> npmpkg-globby-9.2.0.tgz
https://registry.npmjs.org/ignore/-/ignore-4.0.6.tgz -> npmpkg-ignore-4.0.6.tgz
https://registry.npmjs.org/slash/-/slash-2.0.0.tgz -> npmpkg-slash-2.0.0.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.0.tgz -> npmpkg-bn.js-4.12.0.tgz
https://registry.npmjs.org/cssesc/-/cssesc-2.0.0.tgz -> npmpkg-cssesc-2.0.0.tgz
https://registry.npmjs.org/postcss-selector-parser/-/postcss-selector-parser-5.0.0.tgz -> npmpkg-postcss-selector-parser-5.0.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-5.3.1.tgz -> npmpkg-camelcase-5.3.1.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-2.7.1.tgz -> npmpkg-schema-utils-2.7.1.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/css-tree/-/css-tree-1.1.3.tgz -> npmpkg-css-tree-1.1.3.tgz
https://registry.npmjs.org/mdn-data/-/mdn-data-2.0.14.tgz -> npmpkg-mdn-data-2.0.14.tgz
https://registry.npmjs.org/tr46/-/tr46-2.1.0.tgz -> npmpkg-tr46-2.1.0.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-8.7.0.tgz -> npmpkg-whatwg-url-8.7.0.tgz
https://registry.npmjs.org/date-fns/-/date-fns-2.16.1.tgz -> npmpkg-date-fns-2.16.1.tgz
https://registry.npmjs.org/@types/glob/-/glob-7.2.0.tgz -> npmpkg-@types-glob-7.2.0.tgz
https://registry.npmjs.org/p-map/-/p-map-2.1.0.tgz -> npmpkg-p-map-2.1.0.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.0.tgz -> npmpkg-bn.js-4.12.0.tgz
https://registry.npmjs.org/csstype/-/csstype-3.1.2.tgz -> npmpkg-csstype-3.1.2.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-5.0.0.tgz -> npmpkg-webidl-conversions-5.0.0.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.0.tgz -> npmpkg-bn.js-4.12.0.tgz
https://registry.npmjs.org/memory-fs/-/memory-fs-0.5.0.tgz -> npmpkg-memory-fs-0.5.0.tgz
https://registry.npmjs.org/doctrine/-/doctrine-2.1.0.tgz -> npmpkg-doctrine-2.1.0.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/doctrine/-/doctrine-2.1.0.tgz -> npmpkg-doctrine-2.1.0.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/resolve/-/resolve-2.0.0-next.4.tgz -> npmpkg-resolve-2.0.0-next.4.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/@typescript-eslint/experimental-utils/-/experimental-utils-3.10.1.tgz -> npmpkg-@typescript-eslint-experimental-utils-3.10.1.tgz
https://registry.npmjs.org/@typescript-eslint/types/-/types-3.10.1.tgz -> npmpkg-@typescript-eslint-types-3.10.1.tgz
https://registry.npmjs.org/@typescript-eslint/typescript-estree/-/typescript-estree-3.10.1.tgz -> npmpkg-@typescript-eslint-typescript-estree-3.10.1.tgz
https://registry.npmjs.org/@typescript-eslint/visitor-keys/-/visitor-keys-3.10.1.tgz -> npmpkg-@typescript-eslint-visitor-keys-3.10.1.tgz
https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-1.3.0.tgz -> npmpkg-eslint-visitor-keys-1.3.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.5.3.tgz -> npmpkg-semver-7.5.3.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/eslint-utils/-/eslint-utils-2.1.0.tgz -> npmpkg-eslint-utils-2.1.0.tgz
https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-1.3.0.tgz -> npmpkg-eslint-visitor-keys-1.3.0.tgz
https://registry.npmjs.org/@babel/code-frame/-/code-frame-7.12.11.tgz -> npmpkg-@babel-code-frame-7.12.11.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz -> npmpkg-escape-string-regexp-4.0.0.tgz
https://registry.npmjs.org/eslint-utils/-/eslint-utils-2.1.0.tgz -> npmpkg-eslint-utils-2.1.0.tgz
https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-1.3.0.tgz -> npmpkg-eslint-visitor-keys-1.3.0.tgz
https://registry.npmjs.org/globals/-/globals-13.20.0.tgz -> npmpkg-globals-13.20.0.tgz
https://registry.npmjs.org/ignore/-/ignore-4.0.6.tgz -> npmpkg-ignore-4.0.6.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz -> npmpkg-import-fresh-3.3.0.tgz
https://registry.npmjs.org/levn/-/levn-0.4.1.tgz -> npmpkg-levn-0.4.1.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/optionator/-/optionator-0.9.1.tgz -> npmpkg-optionator-0.9.1.tgz
https://registry.npmjs.org/prelude-ls/-/prelude-ls-1.2.1.tgz -> npmpkg-prelude-ls-1.2.1.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz -> npmpkg-resolve-from-4.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.5.3.tgz -> npmpkg-semver-7.5.3.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-3.1.1.tgz -> npmpkg-strip-json-comments-3.1.1.tgz
https://registry.npmjs.org/type-check/-/type-check-0.4.0.tgz -> npmpkg-type-check-0.4.0.tgz
https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-1.3.0.tgz -> npmpkg-eslint-visitor-keys-1.3.0.tgz
https://registry.npmjs.org/@jest/types/-/types-26.6.2.tgz -> npmpkg-@jest-types-26.6.2.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.1.tgz -> npmpkg-@types-istanbul-reports-3.0.1.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-15.0.15.tgz -> npmpkg-@types-yargs-15.0.15.tgz
https://registry.npmjs.org/jest-get-type/-/jest-get-type-26.3.0.tgz -> npmpkg-jest-get-type-26.3.0.tgz
https://registry.npmjs.org/jest-regex-util/-/jest-regex-util-26.0.0.tgz -> npmpkg-jest-regex-util-26.0.0.tgz
https://registry.npmjs.org/type/-/type-2.7.2.tgz -> npmpkg-type-2.7.2.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/ramda/-/ramda-0.28.0.tgz -> npmpkg-ramda-0.28.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-5.1.6.tgz -> npmpkg-minimatch-5.1.6.tgz
https://registry.npmjs.org/find-up/-/find-up-3.0.0.tgz -> npmpkg-find-up-3.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-3.0.0.tgz -> npmpkg-locate-path-3.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-3.0.0.tgz -> npmpkg-p-locate-3.0.0.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-3.0.0.tgz -> npmpkg-pkg-dir-3.0.0.tgz
https://registry.npmjs.org/firebase/-/firebase-9.0.0-beta.2.tgz -> npmpkg-firebase-9.0.0-beta.2.tgz
https://registry.npmjs.org/glob/-/glob-7.1.1.tgz -> npmpkg-glob-7.1.1.tgz
https://registry.npmjs.org/flow-bin/-/flow-bin-0.131.0.tgz -> npmpkg-flow-bin-0.131.0.tgz
https://registry.npmjs.org/babel-runtime/-/babel-runtime-6.23.0.tgz -> npmpkg-babel-runtime-6.23.0.tgz
https://registry.npmjs.org/core-js/-/core-js-2.6.12.tgz -> npmpkg-core-js-2.6.12.tgz
https://registry.npmjs.org/fbjs/-/fbjs-0.8.18.tgz -> npmpkg-fbjs-0.8.18.tgz
https://registry.npmjs.org/core-js/-/core-js-1.2.7.tgz -> npmpkg-core-js-1.2.7.tgz
https://registry.npmjs.org/ua-parser-js/-/ua-parser-js-0.7.35.tgz -> npmpkg-ua-parser-js-0.7.35.tgz
https://registry.npmjs.org/glob/-/glob-7.1.1.tgz -> npmpkg-glob-7.1.1.tgz
https://registry.npmjs.org/minimist/-/minimist-0.0.8.tgz -> npmpkg-minimist-0.0.8.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.1.tgz -> npmpkg-mkdirp-0.5.1.tgz
https://registry.npmjs.org/prop-types/-/prop-types-15.5.10.tgz -> npmpkg-prop-types-15.5.10.tgz
https://registry.npmjs.org/react/-/react-15.5.4.tgz -> npmpkg-react-15.5.4.tgz
https://registry.npmjs.org/react-dom/-/react-dom-15.5.4.tgz -> npmpkg-react-dom-15.5.4.tgz
https://registry.npmjs.org/regenerator-runtime/-/regenerator-runtime-0.10.5.tgz -> npmpkg-regenerator-runtime-0.10.5.tgz
https://registry.npmjs.org/cosmiconfig/-/cosmiconfig-6.0.0.tgz -> npmpkg-cosmiconfig-6.0.0.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz -> npmpkg-import-fresh-3.3.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz -> npmpkg-resolve-from-4.0.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/parse-json/-/parse-json-5.2.0.tgz -> npmpkg-parse-json-5.2.0.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-2.7.0.tgz -> npmpkg-schema-utils-2.7.0.tgz
https://registry.npmjs.org/semver/-/semver-7.5.3.tgz -> npmpkg-semver-7.5.3.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-0.3.0.tgz -> npmpkg-mkdirp-0.3.0.tgz
https://registry.npmjs.org/commander/-/commander-4.1.1.tgz -> npmpkg-commander-4.1.1.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/find-up/-/find-up-4.1.0.tgz -> npmpkg-find-up-4.1.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-5.0.0.tgz -> npmpkg-locate-path-5.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-4.1.0.tgz -> npmpkg-p-locate-4.1.0.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-4.2.0.tgz -> npmpkg-pkg-dir-4.2.0.tgz
https://registry.npmjs.org/qs/-/qs-6.9.7.tgz -> npmpkg-qs-6.9.7.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/make-dir/-/make-dir-3.1.0.tgz -> npmpkg-make-dir-3.1.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/@jest/types/-/types-26.6.2.tgz -> npmpkg-@jest-types-26.6.2.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.1.tgz -> npmpkg-@types-istanbul-reports-3.0.1.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-15.0.15.tgz -> npmpkg-@types-yargs-15.0.15.tgz
https://registry.npmjs.org/execa/-/execa-4.1.0.tgz -> npmpkg-execa-4.1.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-5.2.0.tgz -> npmpkg-get-stream-5.2.0.tgz
https://registry.npmjs.org/human-signals/-/human-signals-1.1.1.tgz -> npmpkg-human-signals-1.1.1.tgz
https://registry.npmjs.org/@jest/types/-/types-26.6.2.tgz -> npmpkg-@jest-types-26.6.2.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.1.tgz -> npmpkg-@types-istanbul-reports-3.0.1.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-15.0.15.tgz -> npmpkg-@types-yargs-15.0.15.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-26.6.2.tgz -> npmpkg-pretty-format-26.6.2.tgz
https://registry.npmjs.org/react-is/-/react-is-17.0.2.tgz -> npmpkg-react-is-17.0.2.tgz
https://registry.npmjs.org/@jest/types/-/types-26.6.2.tgz -> npmpkg-@jest-types-26.6.2.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.1.tgz -> npmpkg-@types-istanbul-reports-3.0.1.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-15.0.15.tgz -> npmpkg-@types-yargs-15.0.15.tgz
https://registry.npmjs.org/cliui/-/cliui-6.0.0.tgz -> npmpkg-cliui-6.0.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-6.2.0.tgz -> npmpkg-wrap-ansi-6.2.0.tgz
https://registry.npmjs.org/find-up/-/find-up-4.1.0.tgz -> npmpkg-find-up-4.1.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-5.0.0.tgz -> npmpkg-locate-path-5.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-4.1.0.tgz -> npmpkg-p-locate-4.1.0.tgz
https://registry.npmjs.org/jest-get-type/-/jest-get-type-26.3.0.tgz -> npmpkg-jest-get-type-26.3.0.tgz
https://registry.npmjs.org/jest-validate/-/jest-validate-26.6.2.tgz -> npmpkg-jest-validate-26.6.2.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-26.6.2.tgz -> npmpkg-pretty-format-26.6.2.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/react-is/-/react-is-17.0.2.tgz -> npmpkg-react-is-17.0.2.tgz
https://registry.npmjs.org/yargs/-/yargs-15.4.1.tgz -> npmpkg-yargs-15.4.1.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-18.1.3.tgz -> npmpkg-yargs-parser-18.1.3.tgz
https://registry.npmjs.org/camelcase/-/camelcase-5.3.1.tgz -> npmpkg-camelcase-5.3.1.tgz
https://registry.npmjs.org/@jest/types/-/types-26.6.2.tgz -> npmpkg-@jest-types-26.6.2.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.1.tgz -> npmpkg-@types-istanbul-reports-3.0.1.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-15.0.15.tgz -> npmpkg-@types-yargs-15.0.15.tgz
https://registry.npmjs.org/jest-get-type/-/jest-get-type-26.3.0.tgz -> npmpkg-jest-get-type-26.3.0.tgz
https://registry.npmjs.org/jest-regex-util/-/jest-regex-util-26.0.0.tgz -> npmpkg-jest-regex-util-26.0.0.tgz
https://registry.npmjs.org/jest-resolve/-/jest-resolve-26.6.2.tgz -> npmpkg-jest-resolve-26.6.2.tgz
https://registry.npmjs.org/jest-validate/-/jest-validate-26.6.2.tgz -> npmpkg-jest-validate-26.6.2.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-26.6.2.tgz -> npmpkg-pretty-format-26.6.2.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/react-is/-/react-is-17.0.2.tgz -> npmpkg-react-is-17.0.2.tgz
https://registry.npmjs.org/@jest/types/-/types-26.6.2.tgz -> npmpkg-@jest-types-26.6.2.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.1.tgz -> npmpkg-@types-istanbul-reports-3.0.1.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-15.0.15.tgz -> npmpkg-@types-yargs-15.0.15.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/jest-get-type/-/jest-get-type-26.3.0.tgz -> npmpkg-jest-get-type-26.3.0.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-26.6.2.tgz -> npmpkg-pretty-format-26.6.2.tgz
https://registry.npmjs.org/react-is/-/react-is-17.0.2.tgz -> npmpkg-react-is-17.0.2.tgz
https://registry.npmjs.org/@jest/types/-/types-26.6.2.tgz -> npmpkg-@jest-types-26.6.2.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.1.tgz -> npmpkg-@types-istanbul-reports-3.0.1.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-15.0.15.tgz -> npmpkg-@types-yargs-15.0.15.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/jest-get-type/-/jest-get-type-26.3.0.tgz -> npmpkg-jest-get-type-26.3.0.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-26.6.2.tgz -> npmpkg-pretty-format-26.6.2.tgz
https://registry.npmjs.org/react-is/-/react-is-17.0.2.tgz -> npmpkg-react-is-17.0.2.tgz
https://registry.npmjs.org/@jest/types/-/types-26.6.2.tgz -> npmpkg-@jest-types-26.6.2.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.1.tgz -> npmpkg-@types-istanbul-reports-3.0.1.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-15.0.15.tgz -> npmpkg-@types-yargs-15.0.15.tgz
https://registry.npmjs.org/@jest/types/-/types-26.6.2.tgz -> npmpkg-@jest-types-26.6.2.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.1.tgz -> npmpkg-@types-istanbul-reports-3.0.1.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-15.0.15.tgz -> npmpkg-@types-yargs-15.0.15.tgz
https://registry.npmjs.org/@jest/types/-/types-26.6.2.tgz -> npmpkg-@jest-types-26.6.2.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.1.tgz -> npmpkg-@types-istanbul-reports-3.0.1.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-15.0.15.tgz -> npmpkg-@types-yargs-15.0.15.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.2.tgz -> npmpkg-fsevents-2.3.2.tgz
https://registry.npmjs.org/jest-regex-util/-/jest-regex-util-26.0.0.tgz -> npmpkg-jest-regex-util-26.0.0.tgz
https://registry.npmjs.org/jest-worker/-/jest-worker-26.6.2.tgz -> npmpkg-jest-worker-26.6.2.tgz
https://registry.npmjs.org/@jest/types/-/types-26.6.2.tgz -> npmpkg-@jest-types-26.6.2.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.1.tgz -> npmpkg-@types-istanbul-reports-3.0.1.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-15.0.15.tgz -> npmpkg-@types-yargs-15.0.15.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-26.6.2.tgz -> npmpkg-pretty-format-26.6.2.tgz
https://registry.npmjs.org/react-is/-/react-is-17.0.2.tgz -> npmpkg-react-is-17.0.2.tgz
https://registry.npmjs.org/@jest/types/-/types-26.6.2.tgz -> npmpkg-@jest-types-26.6.2.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.1.tgz -> npmpkg-@types-istanbul-reports-3.0.1.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-15.0.15.tgz -> npmpkg-@types-yargs-15.0.15.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/jest-get-type/-/jest-get-type-26.3.0.tgz -> npmpkg-jest-get-type-26.3.0.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-26.6.2.tgz -> npmpkg-pretty-format-26.6.2.tgz
https://registry.npmjs.org/react-is/-/react-is-17.0.2.tgz -> npmpkg-react-is-17.0.2.tgz
https://registry.npmjs.org/@jest/types/-/types-26.6.2.tgz -> npmpkg-@jest-types-26.6.2.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.1.tgz -> npmpkg-@types-istanbul-reports-3.0.1.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-15.0.15.tgz -> npmpkg-@types-yargs-15.0.15.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/jest-get-type/-/jest-get-type-26.3.0.tgz -> npmpkg-jest-get-type-26.3.0.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-26.6.2.tgz -> npmpkg-pretty-format-26.6.2.tgz
https://registry.npmjs.org/react-is/-/react-is-17.0.2.tgz -> npmpkg-react-is-17.0.2.tgz
https://registry.npmjs.org/@jest/types/-/types-26.6.2.tgz -> npmpkg-@jest-types-26.6.2.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.1.tgz -> npmpkg-@types-istanbul-reports-3.0.1.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-15.0.15.tgz -> npmpkg-@types-yargs-15.0.15.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-26.6.2.tgz -> npmpkg-pretty-format-26.6.2.tgz
https://registry.npmjs.org/react-is/-/react-is-17.0.2.tgz -> npmpkg-react-is-17.0.2.tgz
https://registry.npmjs.org/@jest/types/-/types-26.6.2.tgz -> npmpkg-@jest-types-26.6.2.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.1.tgz -> npmpkg-@types-istanbul-reports-3.0.1.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-15.0.15.tgz -> npmpkg-@types-yargs-15.0.15.tgz
https://registry.npmjs.org/@jest/types/-/types-26.6.2.tgz -> npmpkg-@jest-types-26.6.2.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.1.tgz -> npmpkg-@types-istanbul-reports-3.0.1.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-15.0.15.tgz -> npmpkg-@types-yargs-15.0.15.tgz
https://registry.npmjs.org/jest-regex-util/-/jest-regex-util-26.0.0.tgz -> npmpkg-jest-regex-util-26.0.0.tgz
https://registry.npmjs.org/@jest/types/-/types-26.6.2.tgz -> npmpkg-@jest-types-26.6.2.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.1.tgz -> npmpkg-@types-istanbul-reports-3.0.1.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-15.0.15.tgz -> npmpkg-@types-yargs-15.0.15.tgz
https://registry.npmjs.org/@jest/types/-/types-26.6.2.tgz -> npmpkg-@jest-types-26.6.2.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.1.tgz -> npmpkg-@types-istanbul-reports-3.0.1.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-15.0.15.tgz -> npmpkg-@types-yargs-15.0.15.tgz
https://registry.npmjs.org/jest-resolve/-/jest-resolve-26.6.2.tgz -> npmpkg-jest-resolve-26.6.2.tgz
https://registry.npmjs.org/jest-worker/-/jest-worker-26.6.2.tgz -> npmpkg-jest-worker-26.6.2.tgz
https://registry.npmjs.org/@jest/types/-/types-26.6.2.tgz -> npmpkg-@jest-types-26.6.2.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.1.tgz -> npmpkg-@types-istanbul-reports-3.0.1.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-15.0.15.tgz -> npmpkg-@types-yargs-15.0.15.tgz
https://registry.npmjs.org/cliui/-/cliui-6.0.0.tgz -> npmpkg-cliui-6.0.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-6.2.0.tgz -> npmpkg-wrap-ansi-6.2.0.tgz
https://registry.npmjs.org/find-up/-/find-up-4.1.0.tgz -> npmpkg-find-up-4.1.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-5.0.0.tgz -> npmpkg-locate-path-5.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-4.1.0.tgz -> npmpkg-p-locate-4.1.0.tgz
https://registry.npmjs.org/jest-get-type/-/jest-get-type-26.3.0.tgz -> npmpkg-jest-get-type-26.3.0.tgz
https://registry.npmjs.org/jest-regex-util/-/jest-regex-util-26.0.0.tgz -> npmpkg-jest-regex-util-26.0.0.tgz
https://registry.npmjs.org/jest-resolve/-/jest-resolve-26.6.2.tgz -> npmpkg-jest-resolve-26.6.2.tgz
https://registry.npmjs.org/jest-validate/-/jest-validate-26.6.2.tgz -> npmpkg-jest-validate-26.6.2.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-26.6.2.tgz -> npmpkg-pretty-format-26.6.2.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/react-is/-/react-is-17.0.2.tgz -> npmpkg-react-is-17.0.2.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-4.0.0.tgz -> npmpkg-strip-bom-4.0.0.tgz
https://registry.npmjs.org/yargs/-/yargs-15.4.1.tgz -> npmpkg-yargs-15.4.1.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-18.1.3.tgz -> npmpkg-yargs-parser-18.1.3.tgz
https://registry.npmjs.org/camelcase/-/camelcase-5.3.1.tgz -> npmpkg-camelcase-5.3.1.tgz
https://registry.npmjs.org/@jest/types/-/types-26.6.2.tgz -> npmpkg-@jest-types-26.6.2.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.1.tgz -> npmpkg-@types-istanbul-reports-3.0.1.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-15.0.15.tgz -> npmpkg-@types-yargs-15.0.15.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/jest-get-type/-/jest-get-type-26.3.0.tgz -> npmpkg-jest-get-type-26.3.0.tgz
https://registry.npmjs.org/jest-resolve/-/jest-resolve-26.6.2.tgz -> npmpkg-jest-resolve-26.6.2.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-26.6.2.tgz -> npmpkg-pretty-format-26.6.2.tgz
https://registry.npmjs.org/react-is/-/react-is-17.0.2.tgz -> npmpkg-react-is-17.0.2.tgz
https://registry.npmjs.org/semver/-/semver-7.5.3.tgz -> npmpkg-semver-7.5.3.tgz
https://registry.npmjs.org/@jest/types/-/types-26.6.2.tgz -> npmpkg-@jest-types-26.6.2.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.1.tgz -> npmpkg-@types-istanbul-reports-3.0.1.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-15.0.15.tgz -> npmpkg-@types-yargs-15.0.15.tgz
https://registry.npmjs.org/camelcase/-/camelcase-5.3.1.tgz -> npmpkg-camelcase-5.3.1.tgz
https://registry.npmjs.org/ansi-escapes/-/ansi-escapes-4.3.2.tgz -> npmpkg-ansi-escapes-4.3.2.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/jest-regex-util/-/jest-regex-util-26.0.0.tgz -> npmpkg-jest-regex-util-26.0.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.21.3.tgz -> npmpkg-type-fest-0.21.3.tgz
https://registry.npmjs.org/@jest/types/-/types-26.6.2.tgz -> npmpkg-@jest-types-26.6.2.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.1.tgz -> npmpkg-@types-istanbul-reports-3.0.1.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-15.0.15.tgz -> npmpkg-@types-yargs-15.0.15.tgz
https://registry.npmjs.org/ansi-escapes/-/ansi-escapes-4.3.2.tgz -> npmpkg-ansi-escapes-4.3.2.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.21.3.tgz -> npmpkg-type-fest-0.21.3.tgz
https://registry.npmjs.org/supports-color/-/supports-color-8.1.1.tgz -> npmpkg-supports-color-8.1.1.tgz
https://registry.npmjs.org/flow-bin/-/flow-bin-0.50.0.tgz -> npmpkg-flow-bin-0.50.0.tgz
https://registry.npmjs.org/acorn/-/acorn-8.9.0.tgz -> npmpkg-acorn-8.9.0.tgz
https://registry.npmjs.org/tr46/-/tr46-2.1.0.tgz -> npmpkg-tr46-2.1.0.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-8.7.0.tgz -> npmpkg-whatwg-url-8.7.0.tgz
https://registry.npmjs.org/ws/-/ws-7.5.9.tgz -> npmpkg-ws-7.5.9.tgz
https://registry.npmjs.org/csstype/-/csstype-3.1.2.tgz -> npmpkg-csstype-3.1.2.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.3.1.tgz -> npmpkg-type-fest-0.3.1.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-5.0.0.tgz -> npmpkg-escape-string-regexp-5.0.0.tgz
https://registry.npmjs.org/unist-util-is/-/unist-util-is-5.2.1.tgz -> npmpkg-unist-util-is-5.2.1.tgz
https://registry.npmjs.org/unist-util-is/-/unist-util-is-5.2.1.tgz -> npmpkg-unist-util-is-5.2.1.tgz
https://registry.npmjs.org/unist-util-is/-/unist-util-is-5.2.1.tgz -> npmpkg-unist-util-is-5.2.1.tgz
https://registry.npmjs.org/unist-util-visit/-/unist-util-visit-4.1.2.tgz -> npmpkg-unist-util-visit-4.1.2.tgz
https://registry.npmjs.org/zwitch/-/zwitch-2.0.4.tgz -> npmpkg-zwitch-2.0.4.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.0.tgz -> npmpkg-bn.js-4.12.0.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-1.0.0.tgz -> npmpkg-schema-utils-1.0.0.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/events/-/events-3.3.0.tgz -> npmpkg-events-3.3.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.5.3.tgz -> npmpkg-semver-7.5.3.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-4.1.5.tgz -> npmpkg-lru-cache-4.1.5.tgz
https://registry.npmjs.org/yallist/-/yallist-2.1.2.tgz -> npmpkg-yallist-2.1.2.tgz
https://registry.npmjs.org/p-map/-/p-map-2.1.0.tgz -> npmpkg-p-map-2.1.0.tgz
https://registry.npmjs.org/p-map/-/p-map-2.1.0.tgz -> npmpkg-p-map-2.1.0.tgz
https://registry.npmjs.org/open/-/open-7.4.2.tgz -> npmpkg-open-7.4.2.tgz
https://registry.npmjs.org/slash/-/slash-2.0.0.tgz -> npmpkg-slash-2.0.0.tgz
https://registry.npmjs.org/find-up/-/find-up-3.0.0.tgz -> npmpkg-find-up-3.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-3.0.0.tgz -> npmpkg-locate-path-3.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-3.0.0.tgz -> npmpkg-p-locate-3.0.0.tgz
https://registry.npmjs.org/find-up/-/find-up-3.0.0.tgz -> npmpkg-find-up-3.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-3.0.0.tgz -> npmpkg-locate-path-3.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-3.0.0.tgz -> npmpkg-p-locate-3.0.0.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/cssesc/-/cssesc-2.0.0.tgz -> npmpkg-cssesc-2.0.0.tgz
https://registry.npmjs.org/postcss-selector-parser/-/postcss-selector-parser-5.0.0.tgz -> npmpkg-postcss-selector-parser-5.0.0.tgz
https://registry.npmjs.org/cssesc/-/cssesc-2.0.0.tgz -> npmpkg-cssesc-2.0.0.tgz
https://registry.npmjs.org/postcss-selector-parser/-/postcss-selector-parser-5.0.0.tgz -> npmpkg-postcss-selector-parser-5.0.0.tgz
https://registry.npmjs.org/cosmiconfig/-/cosmiconfig-7.1.0.tgz -> npmpkg-cosmiconfig-7.1.0.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz -> npmpkg-import-fresh-3.3.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz -> npmpkg-resolve-from-4.0.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/parse-json/-/parse-json-5.2.0.tgz -> npmpkg-parse-json-5.2.0.tgz
https://registry.npmjs.org/semver/-/semver-7.5.3.tgz -> npmpkg-semver-7.5.3.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-selector-parser/-/postcss-selector-parser-3.1.2.tgz -> npmpkg-postcss-selector-parser-3.1.2.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-selector-parser/-/postcss-selector-parser-3.1.2.tgz -> npmpkg-postcss-selector-parser-3.1.2.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/normalize-url/-/normalize-url-3.3.0.tgz -> npmpkg-normalize-url-3.3.0.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/cssesc/-/cssesc-2.0.0.tgz -> npmpkg-cssesc-2.0.0.tgz
https://registry.npmjs.org/postcss-selector-parser/-/postcss-selector-parser-5.0.0.tgz -> npmpkg-postcss-selector-parser-5.0.0.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/picocolors/-/picocolors-1.0.0.tgz -> npmpkg-picocolors-1.0.0.tgz
https://registry.npmjs.org/postcss/-/postcss-8.4.24.tgz -> npmpkg-postcss-8.4.24.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.0.tgz -> npmpkg-bn.js-4.12.0.tgz
https://registry.npmjs.org/promise/-/promise-8.3.0.tgz -> npmpkg-promise-8.3.0.tgz
https://registry.npmjs.org/@babel/code-frame/-/code-frame-7.10.4.tgz -> npmpkg-@babel-code-frame-7.10.4.tgz
https://registry.npmjs.org/address/-/address-1.1.2.tgz -> npmpkg-address-1.1.2.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/browserslist/-/browserslist-4.14.2.tgz -> npmpkg-browserslist-4.14.2.tgz
https://registry.npmjs.org/find-up/-/find-up-4.1.0.tgz -> npmpkg-find-up-4.1.0.tgz
https://registry.npmjs.org/fork-ts-checker-webpack-plugin/-/fork-ts-checker-webpack-plugin-4.1.6.tgz -> npmpkg-fork-ts-checker-webpack-plugin-4.1.6.tgz
https://registry.npmjs.org/globby/-/globby-11.0.1.tgz -> npmpkg-globby-11.0.1.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-2.0.0.tgz -> npmpkg-loader-utils-2.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-5.0.0.tgz -> npmpkg-locate-path-5.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-4.1.0.tgz -> npmpkg-p-locate-4.1.0.tgz
https://registry.npmjs.org/node-releases/-/node-releases-1.1.77.tgz -> npmpkg-node-releases-1.1.77.tgz
https://registry.npmjs.org/open/-/open-7.4.2.tgz -> npmpkg-open-7.4.2.tgz
https://registry.npmjs.org/prompts/-/prompts-2.4.0.tgz -> npmpkg-prompts-2.4.0.tgz
https://registry.npmjs.org/recursive-readdir/-/recursive-readdir-2.2.2.tgz -> npmpkg-recursive-readdir-2.2.2.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.0.tgz -> npmpkg-strip-ansi-6.0.0.tgz
https://registry.npmjs.org/is-plain-object/-/is-plain-object-5.0.0.tgz -> npmpkg-is-plain-object-5.0.0.tgz
https://registry.npmjs.org/react-is/-/react-is-17.0.2.tgz -> npmpkg-react-is-17.0.2.tgz
https://registry.npmjs.org/bail/-/bail-2.0.2.tgz -> npmpkg-bail-2.0.2.tgz
https://registry.npmjs.org/comma-separated-tokens/-/comma-separated-tokens-2.0.3.tgz -> npmpkg-comma-separated-tokens-2.0.3.tgz
https://registry.npmjs.org/is-plain-obj/-/is-plain-obj-4.1.0.tgz -> npmpkg-is-plain-obj-4.1.0.tgz
https://registry.npmjs.org/property-information/-/property-information-6.2.0.tgz -> npmpkg-property-information-6.2.0.tgz
https://registry.npmjs.org/react-is/-/react-is-18.2.0.tgz -> npmpkg-react-is-18.2.0.tgz
https://registry.npmjs.org/space-separated-tokens/-/space-separated-tokens-2.0.2.tgz -> npmpkg-space-separated-tokens-2.0.2.tgz
https://registry.npmjs.org/style-to-object/-/style-to-object-0.4.1.tgz -> npmpkg-style-to-object-0.4.1.tgz
https://registry.npmjs.org/trough/-/trough-2.1.0.tgz -> npmpkg-trough-2.1.0.tgz
https://registry.npmjs.org/unified/-/unified-10.1.2.tgz -> npmpkg-unified-10.1.2.tgz
https://registry.npmjs.org/unist-util-is/-/unist-util-is-5.2.1.tgz -> npmpkg-unist-util-is-5.2.1.tgz
https://registry.npmjs.org/unist-util-visit/-/unist-util-visit-4.1.2.tgz -> npmpkg-unist-util-visit-4.1.2.tgz
https://registry.npmjs.org/vfile/-/vfile-5.3.7.tgz -> npmpkg-vfile-5.3.7.tgz
https://registry.npmjs.org/vfile-message/-/vfile-message-3.1.4.tgz -> npmpkg-vfile-message-3.1.4.tgz
https://registry.npmjs.org/classnames/-/classnames-2.3.2.tgz -> npmpkg-classnames-2.3.2.tgz
https://registry.npmjs.org/@babel/core/-/core-7.12.3.tgz -> npmpkg-@babel-core-7.12.3.tgz
https://registry.npmjs.org/@pmmmwh/react-refresh-webpack-plugin/-/react-refresh-webpack-plugin-0.4.3.tgz -> npmpkg-@pmmmwh-react-refresh-webpack-plugin-0.4.3.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-2.7.1.tgz -> npmpkg-schema-utils-2.7.1.tgz
https://registry.npmjs.org/case-sensitive-paths-webpack-plugin/-/case-sensitive-paths-webpack-plugin-2.3.0.tgz -> npmpkg-case-sensitive-paths-webpack-plugin-2.3.0.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-2.7.1.tgz -> npmpkg-schema-utils-2.7.1.tgz
https://registry.npmjs.org/dotenv/-/dotenv-8.2.0.tgz -> npmpkg-dotenv-8.2.0.tgz
https://registry.npmjs.org/file-loader/-/file-loader-6.1.1.tgz -> npmpkg-file-loader-6.1.1.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.2.tgz -> npmpkg-fsevents-2.3.2.tgz
https://registry.npmjs.org/html-entities/-/html-entities-1.4.0.tgz -> npmpkg-html-entities-1.4.0.tgz
https://registry.npmjs.org/html-webpack-plugin/-/html-webpack-plugin-4.5.0.tgz -> npmpkg-html-webpack-plugin-4.5.0.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/postcss-loader/-/postcss-loader-3.0.0.tgz -> npmpkg-postcss-loader-3.0.0.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-1.0.0.tgz -> npmpkg-schema-utils-1.0.0.tgz
https://registry.npmjs.org/prompts/-/prompts-2.4.0.tgz -> npmpkg-prompts-2.4.0.tgz
https://registry.npmjs.org/react-refresh/-/react-refresh-0.8.3.tgz -> npmpkg-react-refresh-0.8.3.tgz
https://registry.npmjs.org/resolve/-/resolve-1.18.1.tgz -> npmpkg-resolve-1.18.1.tgz
https://registry.npmjs.org/semver/-/semver-7.3.2.tgz -> npmpkg-semver-7.3.2.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.13.1.tgz -> npmpkg-type-fest-0.13.1.tgz
https://registry.npmjs.org/classnames/-/classnames-2.3.2.tgz -> npmpkg-classnames-2.3.2.tgz
https://registry.npmjs.org/react-transition-group/-/react-transition-group-2.9.0.tgz -> npmpkg-react-transition-group-2.9.0.tgz
https://registry.npmjs.org/find-up/-/find-up-4.1.0.tgz -> npmpkg-find-up-4.1.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-5.0.0.tgz -> npmpkg-locate-path-5.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-4.1.0.tgz -> npmpkg-p-locate-4.1.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.8.1.tgz -> npmpkg-type-fest-0.8.1.tgz
https://registry.npmjs.org/parse-json/-/parse-json-5.2.0.tgz -> npmpkg-parse-json-5.2.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.6.0.tgz -> npmpkg-type-fest-0.6.0.tgz
https://registry.npmjs.org/junk/-/junk-1.0.3.tgz -> npmpkg-junk-1.0.3.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz -> npmpkg-postcss-value-parser-3.3.1.tgz
https://registry.npmjs.org/bail/-/bail-2.0.2.tgz -> npmpkg-bail-2.0.2.tgz
https://registry.npmjs.org/is-plain-obj/-/is-plain-obj-4.1.0.tgz -> npmpkg-is-plain-obj-4.1.0.tgz
https://registry.npmjs.org/trough/-/trough-2.1.0.tgz -> npmpkg-trough-2.1.0.tgz
https://registry.npmjs.org/unified/-/unified-10.1.2.tgz -> npmpkg-unified-10.1.2.tgz
https://registry.npmjs.org/vfile/-/vfile-5.3.7.tgz -> npmpkg-vfile-5.3.7.tgz
https://registry.npmjs.org/vfile-message/-/vfile-message-3.1.4.tgz -> npmpkg-vfile-message-3.1.4.tgz
https://registry.npmjs.org/@babel/core/-/core-7.12.9.tgz -> npmpkg-@babel-core-7.12.9.tgz
https://registry.npmjs.org/@babel/helper-plugin-utils/-/helper-plugin-utils-7.10.4.tgz -> npmpkg-@babel-helper-plugin-utils-7.10.4.tgz
https://registry.npmjs.org/@babel/plugin-proposal-object-rest-spread/-/plugin-proposal-object-rest-spread-7.12.1.tgz -> npmpkg-@babel-plugin-proposal-object-rest-spread-7.12.1.tgz
https://registry.npmjs.org/@babel/plugin-syntax-jsx/-/plugin-syntax-jsx-7.12.1.tgz -> npmpkg-@babel-plugin-syntax-jsx-7.12.1.tgz
https://registry.npmjs.org/ccount/-/ccount-1.1.0.tgz -> npmpkg-ccount-1.1.0.tgz
https://registry.npmjs.org/remark-parse/-/remark-parse-8.0.3.tgz -> npmpkg-remark-parse-8.0.3.tgz
https://registry.npmjs.org/bail/-/bail-2.0.2.tgz -> npmpkg-bail-2.0.2.tgz
https://registry.npmjs.org/is-plain-obj/-/is-plain-obj-4.1.0.tgz -> npmpkg-is-plain-obj-4.1.0.tgz
https://registry.npmjs.org/trough/-/trough-2.1.0.tgz -> npmpkg-trough-2.1.0.tgz
https://registry.npmjs.org/unified/-/unified-10.1.2.tgz -> npmpkg-unified-10.1.2.tgz
https://registry.npmjs.org/vfile/-/vfile-5.3.7.tgz -> npmpkg-vfile-5.3.7.tgz
https://registry.npmjs.org/vfile-message/-/vfile-message-3.1.4.tgz -> npmpkg-vfile-message-3.1.4.tgz
https://registry.npmjs.org/bail/-/bail-2.0.2.tgz -> npmpkg-bail-2.0.2.tgz
https://registry.npmjs.org/is-plain-obj/-/is-plain-obj-4.1.0.tgz -> npmpkg-is-plain-obj-4.1.0.tgz
https://registry.npmjs.org/mdast-util-definitions/-/mdast-util-definitions-5.1.2.tgz -> npmpkg-mdast-util-definitions-5.1.2.tgz
https://registry.npmjs.org/mdast-util-to-hast/-/mdast-util-to-hast-12.3.0.tgz -> npmpkg-mdast-util-to-hast-12.3.0.tgz
https://registry.npmjs.org/trough/-/trough-2.1.0.tgz -> npmpkg-trough-2.1.0.tgz
https://registry.npmjs.org/unified/-/unified-10.1.2.tgz -> npmpkg-unified-10.1.2.tgz
https://registry.npmjs.org/unist-util-generated/-/unist-util-generated-2.0.1.tgz -> npmpkg-unist-util-generated-2.0.1.tgz
https://registry.npmjs.org/unist-util-position/-/unist-util-position-4.0.4.tgz -> npmpkg-unist-util-position-4.0.4.tgz
https://registry.npmjs.org/unist-util-visit/-/unist-util-visit-4.1.2.tgz -> npmpkg-unist-util-visit-4.1.2.tgz
https://registry.npmjs.org/unist-util-is/-/unist-util-is-5.2.1.tgz -> npmpkg-unist-util-is-5.2.1.tgz
https://registry.npmjs.org/vfile/-/vfile-5.3.7.tgz -> npmpkg-vfile-5.3.7.tgz
https://registry.npmjs.org/vfile-message/-/vfile-message-3.1.4.tgz -> npmpkg-vfile-message-3.1.4.tgz
https://registry.npmjs.org/global-modules/-/global-modules-0.2.3.tgz -> npmpkg-global-modules-0.2.3.tgz
https://registry.npmjs.org/global-prefix/-/global-prefix-0.1.5.tgz -> npmpkg-global-prefix-0.1.5.tgz
https://registry.npmjs.org/is-windows/-/is-windows-0.2.0.tgz -> npmpkg-is-windows-0.2.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-5.3.1.tgz -> npmpkg-camelcase-5.3.1.tgz
https://registry.npmjs.org/convert-source-map/-/convert-source-map-1.7.0.tgz -> npmpkg-convert-source-map-1.7.0.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/postcss/-/postcss-7.0.36.tgz -> npmpkg-postcss-7.0.36.tgz
https://registry.npmjs.org/supports-color/-/supports-color-6.1.0.tgz -> npmpkg-supports-color-6.1.0.tgz
https://registry.npmjs.org/onetime/-/onetime-2.0.1.tgz -> npmpkg-onetime-2.0.1.tgz
https://registry.npmjs.org/convert-source-map/-/convert-source-map-0.3.5.tgz -> npmpkg-convert-source-map-0.3.5.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.5.3.tgz -> npmpkg-semver-7.5.3.tgz
https://registry.npmjs.org/ms/-/ms-2.1.1.tgz -> npmpkg-ms-2.1.1.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.1.tgz -> npmpkg-safe-buffer-5.1.1.tgz
https://registry.npmjs.org/interpret/-/interpret-1.4.0.tgz -> npmpkg-interpret-1.4.0.tgz
https://registry.npmjs.org/is-arrayish/-/is-arrayish-0.3.2.tgz -> npmpkg-is-arrayish-0.3.2.tgz
https://registry.npmjs.org/cliui/-/cliui-7.0.4.tgz -> npmpkg-cliui-7.0.4.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/gzip-size/-/gzip-size-6.0.0.tgz -> npmpkg-gzip-size-6.0.0.tgz
https://registry.npmjs.org/open/-/open-7.4.2.tgz -> npmpkg-open-7.4.2.tgz
https://registry.npmjs.org/temp/-/temp-0.9.4.tgz -> npmpkg-temp-0.9.4.tgz
https://registry.npmjs.org/y18n/-/y18n-5.0.8.tgz -> npmpkg-y18n-5.0.8.tgz
https://registry.npmjs.org/yargs/-/yargs-16.2.0.tgz -> npmpkg-yargs-16.2.0.tgz
https://registry.npmjs.org/path-to-regexp/-/path-to-regexp-6.2.1.tgz -> npmpkg-path-to-regexp-6.2.1.tgz
https://registry.npmjs.org/@storybook/client-logger/-/client-logger-6.3.13.tgz -> npmpkg-@storybook-client-logger-6.3.13.tgz
https://registry.npmjs.org/@storybook/components/-/components-6.3.13.tgz -> npmpkg-@storybook-components-6.3.13.tgz
https://registry.npmjs.org/@storybook/core-events/-/core-events-6.3.13.tgz -> npmpkg-@storybook-core-events-6.3.13.tgz
https://registry.npmjs.org/@storybook/theming/-/theming-6.3.13.tgz -> npmpkg-@storybook-theming-6.3.13.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/style-dictionary/-/style-dictionary-2.10.3.tgz -> npmpkg-style-dictionary-2.10.3.tgz
https://registry.npmjs.org/commander/-/commander-5.1.0.tgz -> npmpkg-commander-5.1.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-4.0.0.tgz -> npmpkg-jsonfile-4.0.0.tgz
https://registry.npmjs.org/universalify/-/universalify-0.1.2.tgz -> npmpkg-universalify-0.1.2.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-2.7.1.tgz -> npmpkg-schema-utils-2.7.1.tgz
https://registry.npmjs.org/postcss-selector-parser/-/postcss-selector-parser-3.1.2.tgz -> npmpkg-postcss-selector-parser-3.1.2.tgz
https://registry.npmjs.org/css-select/-/css-select-2.1.0.tgz -> npmpkg-css-select-2.1.0.tgz
https://registry.npmjs.org/css-what/-/css-what-3.4.2.tgz -> npmpkg-css-what-3.4.2.tgz
https://registry.npmjs.org/domutils/-/domutils-1.7.0.tgz -> npmpkg-domutils-1.7.0.tgz
https://registry.npmjs.org/dom-serializer/-/dom-serializer-0.2.2.tgz -> npmpkg-dom-serializer-0.2.2.tgz
https://registry.npmjs.org/domelementtype/-/domelementtype-2.3.0.tgz -> npmpkg-domelementtype-2.3.0.tgz
https://registry.npmjs.org/domelementtype/-/domelementtype-1.3.1.tgz -> npmpkg-domelementtype-1.3.1.tgz
https://registry.npmjs.org/ajv/-/ajv-8.12.0.tgz -> npmpkg-ajv-8.12.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz -> npmpkg-json-schema-traverse-1.0.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/minipass/-/minipass-5.0.0.tgz -> npmpkg-minipass-5.0.0.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-1.0.4.tgz -> npmpkg-mkdirp-1.0.4.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/isobject/-/isobject-4.0.0.tgz -> npmpkg-isobject-4.0.0.tgz
https://registry.npmjs.org/rimraf/-/rimraf-2.2.8.tgz -> npmpkg-rimraf-2.2.8.tgz
https://registry.npmjs.org/ansi-escapes/-/ansi-escapes-4.3.2.tgz -> npmpkg-ansi-escapes-4.3.2.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.21.3.tgz -> npmpkg-type-fest-0.21.3.tgz
https://registry.npmjs.org/acorn/-/acorn-8.9.0.tgz -> npmpkg-acorn-8.9.0.tgz
https://registry.npmjs.org/find-cache-dir/-/find-cache-dir-3.3.2.tgz -> npmpkg-find-cache-dir-3.3.2.tgz
https://registry.npmjs.org/jest-worker/-/jest-worker-26.6.2.tgz -> npmpkg-jest-worker-26.6.2.tgz
https://registry.npmjs.org/make-dir/-/make-dir-3.1.0.tgz -> npmpkg-make-dir-3.1.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-4.2.0.tgz -> npmpkg-pkg-dir-4.2.0.tgz
https://registry.npmjs.org/find-up/-/find-up-4.1.0.tgz -> npmpkg-find-up-4.1.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-5.0.0.tgz -> npmpkg-locate-path-5.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-4.1.0.tgz -> npmpkg-p-locate-4.1.0.tgz
https://registry.npmjs.org/terser/-/terser-5.18.1.tgz -> npmpkg-terser-5.18.1.tgz
https://registry.npmjs.org/universalify/-/universalify-0.2.0.tgz -> npmpkg-universalify-0.2.0.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/typescript/-/typescript-4.9.5.tgz -> npmpkg-typescript-4.9.5.tgz
https://registry.npmjs.org/is-plain-obj/-/is-plain-obj-2.1.0.tgz -> npmpkg-is-plain-obj-2.1.0.tgz
https://registry.npmjs.org/unist-util-is/-/unist-util-is-5.2.1.tgz -> npmpkg-unist-util-is-5.2.1.tgz
https://registry.npmjs.org/unist-util-visit-parents/-/unist-util-visit-parents-3.1.1.tgz -> npmpkg-unist-util-visit-parents-3.1.1.tgz
https://registry.npmjs.org/bluebird/-/bluebird-3.4.7.tgz -> npmpkg-bluebird-3.4.7.tgz
https://registry.npmjs.org/picocolors/-/picocolors-1.0.0.tgz -> npmpkg-picocolors-1.0.0.tgz
https://registry.npmjs.org/kleur/-/kleur-4.1.5.tgz -> npmpkg-kleur-4.1.5.tgz
https://registry.npmjs.org/unist-util-stringify-position/-/unist-util-stringify-position-2.0.3.tgz -> npmpkg-unist-util-stringify-position-2.0.3.tgz
https://registry.npmjs.org/unist-util-stringify-position/-/unist-util-stringify-position-2.0.3.tgz -> npmpkg-unist-util-stringify-position-2.0.3.tgz
https://registry.npmjs.org/fsevents/-/fsevents-1.2.13.tgz -> npmpkg-fsevents-1.2.13.tgz
https://registry.npmjs.org/readdirp/-/readdirp-2.2.1.tgz -> npmpkg-readdirp-2.2.1.tgz
https://registry.npmjs.org/mime/-/mime-2.6.0.tgz -> npmpkg-mime-2.6.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-1.2.13.tgz -> npmpkg-fsevents-1.2.13.tgz
https://registry.npmjs.org/readdirp/-/readdirp-2.2.1.tgz -> npmpkg-readdirp-2.2.1.tgz
https://registry.npmjs.org/cliui/-/cliui-5.0.0.tgz -> npmpkg-cliui-5.0.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-4.1.1.tgz -> npmpkg-ansi-regex-4.1.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-5.2.0.tgz -> npmpkg-strip-ansi-5.2.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-5.1.0.tgz -> npmpkg-wrap-ansi-5.1.0.tgz
https://registry.npmjs.org/find-up/-/find-up-3.0.0.tgz -> npmpkg-find-up-3.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-3.0.0.tgz -> npmpkg-locate-path-3.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-3.0.0.tgz -> npmpkg-p-locate-3.0.0.tgz
https://registry.npmjs.org/html-entities/-/html-entities-1.4.0.tgz -> npmpkg-html-entities-1.4.0.tgz
https://registry.npmjs.org/import-local/-/import-local-2.0.0.tgz -> npmpkg-import-local-2.0.0.tgz
https://registry.npmjs.org/is-absolute-url/-/is-absolute-url-3.0.3.tgz -> npmpkg-is-absolute-url-3.0.3.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-3.0.0.tgz -> npmpkg-pkg-dir-3.0.0.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-1.0.0.tgz -> npmpkg-schema-utils-1.0.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-6.1.0.tgz -> npmpkg-supports-color-6.1.0.tgz
https://registry.npmjs.org/ws/-/ws-6.2.2.tgz -> npmpkg-ws-6.2.2.tgz
https://registry.npmjs.org/yargs/-/yargs-13.3.2.tgz -> npmpkg-yargs-13.3.2.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-13.1.2.tgz -> npmpkg-yargs-parser-13.1.2.tgz
https://registry.npmjs.org/camelcase/-/camelcase-5.3.1.tgz -> npmpkg-camelcase-5.3.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/ansi-colors/-/ansi-colors-3.2.4.tgz -> npmpkg-ansi-colors-3.2.4.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-7.0.1.tgz -> npmpkg-fs-extra-7.0.1.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-4.0.0.tgz -> npmpkg-jsonfile-4.0.0.tgz
https://registry.npmjs.org/universalify/-/universalify-0.1.2.tgz -> npmpkg-universalify-0.1.2.tgz
https://registry.npmjs.org/cacache/-/cacache-12.0.4.tgz -> npmpkg-cacache-12.0.4.tgz
https://registry.npmjs.org/ssri/-/ssri-6.0.2.tgz -> npmpkg-ssri-6.0.2.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-4.0.3.tgz -> npmpkg-eslint-scope-4.0.3.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-1.0.0.tgz -> npmpkg-schema-utils-1.0.0.tgz
https://registry.npmjs.org/serialize-javascript/-/serialize-javascript-4.0.0.tgz -> npmpkg-serialize-javascript-4.0.0.tgz
https://registry.npmjs.org/terser-webpack-plugin/-/terser-webpack-plugin-1.4.5.tgz -> npmpkg-terser-webpack-plugin-1.4.5.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-3.0.1.tgz -> npmpkg-webidl-conversions-3.0.1.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-4.0.3.tgz -> npmpkg-fs-extra-4.0.3.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-4.0.0.tgz -> npmpkg-jsonfile-4.0.0.tgz
https://registry.npmjs.org/universalify/-/universalify-0.1.2.tgz -> npmpkg-universalify-0.1.2.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-4.0.0.tgz -> npmpkg-jsonfile-4.0.0.tgz
https://registry.npmjs.org/universalify/-/universalify-0.1.2.tgz -> npmpkg-universalify-0.1.2.tgz
https://registry.npmjs.org/workbox-background-sync/-/workbox-background-sync-5.1.4.tgz -> npmpkg-workbox-background-sync-5.1.4.tgz
https://registry.npmjs.org/workbox-broadcast-update/-/workbox-broadcast-update-5.1.4.tgz -> npmpkg-workbox-broadcast-update-5.1.4.tgz
https://registry.npmjs.org/workbox-build/-/workbox-build-5.1.4.tgz -> npmpkg-workbox-build-5.1.4.tgz
https://registry.npmjs.org/workbox-cacheable-response/-/workbox-cacheable-response-5.1.4.tgz -> npmpkg-workbox-cacheable-response-5.1.4.tgz
https://registry.npmjs.org/workbox-core/-/workbox-core-5.1.4.tgz -> npmpkg-workbox-core-5.1.4.tgz
https://registry.npmjs.org/workbox-expiration/-/workbox-expiration-5.1.4.tgz -> npmpkg-workbox-expiration-5.1.4.tgz
https://registry.npmjs.org/workbox-google-analytics/-/workbox-google-analytics-5.1.4.tgz -> npmpkg-workbox-google-analytics-5.1.4.tgz
https://registry.npmjs.org/workbox-navigation-preload/-/workbox-navigation-preload-5.1.4.tgz -> npmpkg-workbox-navigation-preload-5.1.4.tgz
https://registry.npmjs.org/workbox-precaching/-/workbox-precaching-5.1.4.tgz -> npmpkg-workbox-precaching-5.1.4.tgz
https://registry.npmjs.org/workbox-range-requests/-/workbox-range-requests-5.1.4.tgz -> npmpkg-workbox-range-requests-5.1.4.tgz
https://registry.npmjs.org/workbox-routing/-/workbox-routing-5.1.4.tgz -> npmpkg-workbox-routing-5.1.4.tgz
https://registry.npmjs.org/workbox-strategies/-/workbox-strategies-5.1.4.tgz -> npmpkg-workbox-strategies-5.1.4.tgz
https://registry.npmjs.org/workbox-streams/-/workbox-streams-5.1.4.tgz -> npmpkg-workbox-streams-5.1.4.tgz
https://registry.npmjs.org/workbox-sw/-/workbox-sw-5.1.4.tgz -> npmpkg-workbox-sw-5.1.4.tgz
https://registry.npmjs.org/workbox-window/-/workbox-window-5.1.4.tgz -> npmpkg-workbox-window-5.1.4.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-2.0.0.tgz -> npmpkg-read-pkg-2.0.0.tgz
https://registry.npmjs.org/read-pkg-up/-/read-pkg-up-2.0.0.tgz -> npmpkg-read-pkg-up-2.0.0.tgz
https://registry.npmjs.org/load-json-file/-/load-json-file-2.0.0.tgz -> npmpkg-load-json-file-2.0.0.tgz
https://registry.npmjs.org/path-type/-/path-type-2.0.0.tgz -> npmpkg-path-type-2.0.0.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-7.0.0.tgz -> npmpkg-yargs-parser-7.0.0.tgz
https://registry.npmjs.org/@babel/code-frame/-/code-frame-7.10.4.tgz -> npmpkg-@babel-code-frame-7.10.4.tgz
https://registry.npmjs.org/@babel/core/-/core-7.12.3.tgz -> npmpkg-@babel-core-7.12.3.tgz
https://registry.npmjs.org/@babel/parser/-/parser-7.12.3.tgz -> npmpkg-@babel-parser-7.12.3.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.20.tgz -> npmpkg-lodash-4.17.20.tgz
https://registry.npmjs.org/@babel/generator/-/generator-7.12.1.tgz -> npmpkg-@babel-generator-7.12.1.tgz
https://registry.npmjs.org/@babel/helper-function-name/-/helper-function-name-7.10.4.tgz -> npmpkg-@babel-helper-function-name-7.10.4.tgz
https://registry.npmjs.org/@babel/helper-get-function-arity/-/helper-get-function-arity-7.10.4.tgz -> npmpkg-@babel-helper-get-function-arity-7.10.4.tgz
https://registry.npmjs.org/@babel/helper-member-expression-to-functions/-/helper-member-expression-to-functions-7.12.1.tgz -> npmpkg-@babel-helper-member-expression-to-functions-7.12.1.tgz
https://registry.npmjs.org/@babel/helper-module-imports/-/helper-module-imports-7.12.1.tgz -> npmpkg-@babel-helper-module-imports-7.12.1.tgz
https://registry.npmjs.org/@babel/helper-module-transforms/-/helper-module-transforms-7.12.1.tgz -> npmpkg-@babel-helper-module-transforms-7.12.1.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.20.tgz -> npmpkg-lodash-4.17.20.tgz
https://registry.npmjs.org/@babel/helper-optimise-call-expression/-/helper-optimise-call-expression-7.10.4.tgz -> npmpkg-@babel-helper-optimise-call-expression-7.10.4.tgz
https://registry.npmjs.org/@babel/helper-replace-supers/-/helper-replace-supers-7.12.1.tgz -> npmpkg-@babel-helper-replace-supers-7.12.1.tgz
https://registry.npmjs.org/@babel/helper-simple-access/-/helper-simple-access-7.12.1.tgz -> npmpkg-@babel-helper-simple-access-7.12.1.tgz
https://registry.npmjs.org/@babel/helper-split-export-declaration/-/helper-split-export-declaration-7.11.0.tgz -> npmpkg-@babel-helper-split-export-declaration-7.11.0.tgz
https://registry.npmjs.org/@babel/helper-validator-identifier/-/helper-validator-identifier-7.10.4.tgz -> npmpkg-@babel-helper-validator-identifier-7.10.4.tgz
https://registry.npmjs.org/@babel/helpers/-/helpers-7.12.1.tgz -> npmpkg-@babel-helpers-7.12.1.tgz
https://registry.npmjs.org/@babel/highlight/-/highlight-7.10.4.tgz -> npmpkg-@babel-highlight-7.10.4.tgz
https://registry.npmjs.org/@babel/parser/-/parser-7.9.4.tgz -> npmpkg-@babel-parser-7.9.4.tgz
https://registry.npmjs.org/@babel/polyfill/-/polyfill-7.12.1.tgz -> npmpkg-@babel-polyfill-7.12.1.tgz
https://registry.npmjs.org/@babel/runtime/-/runtime-7.12.1.tgz -> npmpkg-@babel-runtime-7.12.1.tgz
https://registry.npmjs.org/@babel/template/-/template-7.10.4.tgz -> npmpkg-@babel-template-7.10.4.tgz
https://registry.npmjs.org/@babel/parser/-/parser-7.12.3.tgz -> npmpkg-@babel-parser-7.12.3.tgz
https://registry.npmjs.org/@babel/traverse/-/traverse-7.12.1.tgz -> npmpkg-@babel-traverse-7.12.1.tgz
https://registry.npmjs.org/@babel/parser/-/parser-7.12.3.tgz -> npmpkg-@babel-parser-7.12.3.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.20.tgz -> npmpkg-lodash-4.17.20.tgz
https://registry.npmjs.org/@babel/types/-/types-7.12.1.tgz -> npmpkg-@babel-types-7.12.1.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.20.tgz -> npmpkg-lodash-4.17.20.tgz
https://registry.npmjs.org/@pixi/accessibility/-/accessibility-6.1.2.tgz -> npmpkg-@pixi-accessibility-6.1.2.tgz
https://registry.npmjs.org/@pixi/app/-/app-6.1.2.tgz -> npmpkg-@pixi-app-6.1.2.tgz
https://registry.npmjs.org/@pixi/compressed-textures/-/compressed-textures-6.1.2.tgz -> npmpkg-@pixi-compressed-textures-6.1.2.tgz
https://registry.npmjs.org/@pixi/constants/-/constants-6.1.2.tgz -> npmpkg-@pixi-constants-6.1.2.tgz
https://registry.npmjs.org/@pixi/core/-/core-6.1.2.tgz -> npmpkg-@pixi-core-6.1.2.tgz
https://registry.npmjs.org/@pixi/display/-/display-6.1.2.tgz -> npmpkg-@pixi-display-6.1.2.tgz
https://registry.npmjs.org/@pixi/extract/-/extract-6.1.2.tgz -> npmpkg-@pixi-extract-6.1.2.tgz
https://registry.npmjs.org/@pixi/filter-alpha/-/filter-alpha-6.1.2.tgz -> npmpkg-@pixi-filter-alpha-6.1.2.tgz
https://registry.npmjs.org/@pixi/filter-blur/-/filter-blur-6.1.2.tgz -> npmpkg-@pixi-filter-blur-6.1.2.tgz
https://registry.npmjs.org/@pixi/filter-color-matrix/-/filter-color-matrix-6.1.2.tgz -> npmpkg-@pixi-filter-color-matrix-6.1.2.tgz
https://registry.npmjs.org/@pixi/filter-displacement/-/filter-displacement-6.1.2.tgz -> npmpkg-@pixi-filter-displacement-6.1.2.tgz
https://registry.npmjs.org/@pixi/filter-fxaa/-/filter-fxaa-6.1.2.tgz -> npmpkg-@pixi-filter-fxaa-6.1.2.tgz
https://registry.npmjs.org/@pixi/filter-noise/-/filter-noise-6.1.2.tgz -> npmpkg-@pixi-filter-noise-6.1.2.tgz
https://registry.npmjs.org/@pixi/graphics/-/graphics-6.1.2.tgz -> npmpkg-@pixi-graphics-6.1.2.tgz
https://registry.npmjs.org/@pixi/interaction/-/interaction-6.1.2.tgz -> npmpkg-@pixi-interaction-6.1.2.tgz
https://registry.npmjs.org/@pixi/loaders/-/loaders-6.1.2.tgz -> npmpkg-@pixi-loaders-6.1.2.tgz
https://registry.npmjs.org/@pixi/math/-/math-6.1.2.tgz -> npmpkg-@pixi-math-6.1.2.tgz
https://registry.npmjs.org/@pixi/mesh/-/mesh-6.1.2.tgz -> npmpkg-@pixi-mesh-6.1.2.tgz
https://registry.npmjs.org/@pixi/mesh-extras/-/mesh-extras-6.1.2.tgz -> npmpkg-@pixi-mesh-extras-6.1.2.tgz
https://registry.npmjs.org/@pixi/mixin-cache-as-bitmap/-/mixin-cache-as-bitmap-6.1.2.tgz -> npmpkg-@pixi-mixin-cache-as-bitmap-6.1.2.tgz
https://registry.npmjs.org/@pixi/mixin-get-child-by-name/-/mixin-get-child-by-name-6.1.2.tgz -> npmpkg-@pixi-mixin-get-child-by-name-6.1.2.tgz
https://registry.npmjs.org/@pixi/mixin-get-global-position/-/mixin-get-global-position-6.1.2.tgz -> npmpkg-@pixi-mixin-get-global-position-6.1.2.tgz
https://registry.npmjs.org/@pixi/particle-container/-/particle-container-6.1.2.tgz -> npmpkg-@pixi-particle-container-6.1.2.tgz
https://registry.npmjs.org/@pixi/polyfill/-/polyfill-6.1.2.tgz -> npmpkg-@pixi-polyfill-6.1.2.tgz
https://registry.npmjs.org/@pixi/prepare/-/prepare-6.1.2.tgz -> npmpkg-@pixi-prepare-6.1.2.tgz
https://registry.npmjs.org/@pixi/runner/-/runner-6.1.2.tgz -> npmpkg-@pixi-runner-6.1.2.tgz
https://registry.npmjs.org/@pixi/settings/-/settings-6.1.2.tgz -> npmpkg-@pixi-settings-6.1.2.tgz
https://registry.npmjs.org/@pixi/sprite/-/sprite-6.1.2.tgz -> npmpkg-@pixi-sprite-6.1.2.tgz
https://registry.npmjs.org/@pixi/sprite-animated/-/sprite-animated-6.1.2.tgz -> npmpkg-@pixi-sprite-animated-6.1.2.tgz
https://registry.npmjs.org/@pixi/sprite-tiling/-/sprite-tiling-6.1.2.tgz -> npmpkg-@pixi-sprite-tiling-6.1.2.tgz
https://registry.npmjs.org/@pixi/spritesheet/-/spritesheet-6.1.2.tgz -> npmpkg-@pixi-spritesheet-6.1.2.tgz
https://registry.npmjs.org/@pixi/text/-/text-6.1.2.tgz -> npmpkg-@pixi-text-6.1.2.tgz
https://registry.npmjs.org/@pixi/text-bitmap/-/text-bitmap-6.1.2.tgz -> npmpkg-@pixi-text-bitmap-6.1.2.tgz
https://registry.npmjs.org/@pixi/ticker/-/ticker-6.1.2.tgz -> npmpkg-@pixi-ticker-6.1.2.tgz
https://registry.npmjs.org/@pixi/utils/-/utils-6.1.2.tgz -> npmpkg-@pixi-utils-6.1.2.tgz
https://registry.npmjs.org/@tweenjs/tween.js/-/tween.js-18.6.4.tgz -> npmpkg-@tweenjs-tween.js-18.6.4.tgz
https://registry.npmjs.org/@types/babel-types/-/babel-types-7.0.9.tgz -> npmpkg-@types-babel-types-7.0.9.tgz
https://registry.npmjs.org/@types/babylon/-/babylon-6.16.5.tgz -> npmpkg-@types-babylon-6.16.5.tgz
https://registry.npmjs.org/@types/earcut/-/earcut-2.1.1.tgz -> npmpkg-@types-earcut-2.1.1.tgz
https://registry.npmjs.org/@types/expect.js/-/expect.js-0.3.29.tgz -> npmpkg-@types-expect.js-0.3.29.tgz
https://registry.npmjs.org/@types/mocha/-/mocha-5.2.7.tgz -> npmpkg-@types-mocha-5.2.7.tgz
https://registry.npmjs.org/@types/node/-/node-14.14.0.tgz -> npmpkg-@types-node-14.14.0.tgz
https://registry.npmjs.org/@types/sinon/-/sinon-10.0.13.tgz -> npmpkg-@types-sinon-10.0.13.tgz
https://registry.npmjs.org/@types/sinonjs__fake-timers/-/sinonjs__fake-timers-8.1.2.tgz -> npmpkg-@types-sinonjs__fake-timers-8.1.2.tgz
https://registry.npmjs.org/@types/stats.js/-/stats.js-0.17.0.tgz -> npmpkg-@types-stats.js-0.17.0.tgz
https://registry.npmjs.org/@types/three/-/three-0.152.0.tgz -> npmpkg-@types-three-0.152.0.tgz
https://registry.npmjs.org/@types/webxr/-/webxr-0.5.1.tgz -> npmpkg-@types-webxr-0.5.1.tgz
https://registry.npmjs.org/@yarnpkg/lockfile/-/lockfile-1.1.0.tgz -> npmpkg-@yarnpkg-lockfile-1.1.0.tgz
https://registry.npmjs.org/acorn/-/acorn-8.8.2.tgz -> npmpkg-acorn-8.8.2.tgz
https://registry.npmjs.org/acorn-globals/-/acorn-globals-3.1.0.tgz -> npmpkg-acorn-globals-3.1.0.tgz
https://registry.npmjs.org/acorn/-/acorn-4.0.13.tgz -> npmpkg-acorn-4.0.13.tgz
https://registry.npmjs.org/acorn-jsx/-/acorn-jsx-5.3.1.tgz -> npmpkg-acorn-jsx-5.3.1.tgz
https://registry.npmjs.org/align-text/-/align-text-0.1.4.tgz -> npmpkg-align-text-0.1.4.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/asap/-/asap-2.0.6.tgz -> npmpkg-asap-2.0.6.tgz
https://registry.npmjs.org/ast-types/-/ast-types-0.13.4.tgz -> npmpkg-ast-types-0.13.4.tgz
https://registry.npmjs.org/babel-runtime/-/babel-runtime-6.26.0.tgz -> npmpkg-babel-runtime-6.26.0.tgz
https://registry.npmjs.org/regenerator-runtime/-/regenerator-runtime-0.11.1.tgz -> npmpkg-regenerator-runtime-0.11.1.tgz
https://registry.npmjs.org/babel-types/-/babel-types-6.26.0.tgz -> npmpkg-babel-types-6.26.0.tgz
https://registry.npmjs.org/to-fast-properties/-/to-fast-properties-1.0.3.tgz -> npmpkg-to-fast-properties-1.0.3.tgz
https://registry.npmjs.org/babylon/-/babylon-6.18.0.tgz -> npmpkg-babylon-6.18.0.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.0.tgz -> npmpkg-balanced-match-1.0.0.tgz
https://registry.npmjs.org/better-docs/-/better-docs-2.3.2.tgz -> npmpkg-better-docs-2.3.2.tgz
https://registry.npmjs.org/typescript/-/typescript-3.9.7.tgz -> npmpkg-typescript-3.9.7.tgz
https://registry.npmjs.org/brace/-/brace-0.11.1.tgz -> npmpkg-brace-0.11.1.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/braces/-/braces-3.0.2.tgz -> npmpkg-braces-3.0.2.tgz
https://registry.npmjs.org/camelcase/-/camelcase-1.2.1.tgz -> npmpkg-camelcase-1.2.1.tgz
https://registry.npmjs.org/center-align/-/center-align-0.1.3.tgz -> npmpkg-center-align-0.1.3.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/character-parser/-/character-parser-2.2.0.tgz -> npmpkg-character-parser-2.2.0.tgz
https://registry.npmjs.org/ci-info/-/ci-info-2.0.0.tgz -> npmpkg-ci-info-2.0.0.tgz
https://registry.npmjs.org/clean-css/-/clean-css-4.2.3.tgz -> npmpkg-clean-css-4.2.3.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/cliui/-/cliui-2.1.0.tgz -> npmpkg-cliui-2.1.0.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/commander/-/commander-2.20.3.tgz -> npmpkg-commander-2.20.3.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/constantinople/-/constantinople-3.1.2.tgz -> npmpkg-constantinople-3.1.2.tgz
https://registry.npmjs.org/convert-source-map/-/convert-source-map-1.7.0.tgz -> npmpkg-convert-source-map-1.7.0.tgz
https://registry.npmjs.org/core-js/-/core-js-2.6.11.tgz -> npmpkg-core-js-2.6.11.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-6.0.5.tgz -> npmpkg-cross-spawn-6.0.5.tgz
https://registry.npmjs.org/d/-/d-1.0.1.tgz -> npmpkg-d-1.0.1.tgz
https://registry.npmjs.org/de-indent/-/de-indent-1.0.2.tgz -> npmpkg-de-indent-1.0.2.tgz
https://registry.npmjs.org/debug/-/debug-4.2.0.tgz -> npmpkg-debug-4.2.0.tgz
https://registry.npmjs.org/decamelize/-/decamelize-1.2.0.tgz -> npmpkg-decamelize-1.2.0.tgz
https://registry.npmjs.org/diff-match-patch/-/diff-match-patch-1.0.5.tgz -> npmpkg-diff-match-patch-1.0.5.tgz
https://registry.npmjs.org/doctrine/-/doctrine-3.0.0.tgz -> npmpkg-doctrine-3.0.0.tgz
https://registry.npmjs.org/doctypes/-/doctypes-1.1.0.tgz -> npmpkg-doctypes-1.1.0.tgz
https://registry.npmjs.org/earcut/-/earcut-2.2.3.tgz -> npmpkg-earcut-2.2.3.tgz
https://registry.npmjs.org/es5-ext/-/es5-ext-0.10.53.tgz -> npmpkg-es5-ext-0.10.53.tgz
https://registry.npmjs.org/es6-iterator/-/es6-iterator-2.0.3.tgz -> npmpkg-es6-iterator-2.0.3.tgz
https://registry.npmjs.org/es6-map/-/es6-map-0.1.5.tgz -> npmpkg-es6-map-0.1.5.tgz
https://registry.npmjs.org/es6-set/-/es6-set-0.1.5.tgz -> npmpkg-es6-set-0.1.5.tgz
https://registry.npmjs.org/es6-symbol/-/es6-symbol-3.1.1.tgz -> npmpkg-es6-symbol-3.1.1.tgz
https://registry.npmjs.org/es6-symbol/-/es6-symbol-3.1.3.tgz -> npmpkg-es6-symbol-3.1.3.tgz
https://registry.npmjs.org/es6-weak-map/-/es6-weak-map-2.0.3.tgz -> npmpkg-es6-weak-map-2.0.3.tgz
https://registry.npmjs.org/esbuild/-/esbuild-0.13.12.tgz -> npmpkg-esbuild-0.13.12.tgz
https://registry.npmjs.org/esbuild-linux-64/-/esbuild-linux-64-0.13.12.tgz -> npmpkg-esbuild-linux-64-0.13.12.tgz
https://registry.npmjs.org/escope/-/escope-3.6.0.tgz -> npmpkg-escope-3.6.0.tgz
https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-1.3.0.tgz -> npmpkg-eslint-visitor-keys-1.3.0.tgz
https://registry.npmjs.org/espree/-/espree-5.0.1.tgz -> npmpkg-espree-5.0.1.tgz
https://registry.npmjs.org/acorn/-/acorn-6.4.2.tgz -> npmpkg-acorn-6.4.2.tgz
https://registry.npmjs.org/esprima/-/esprima-4.0.1.tgz -> npmpkg-esprima-4.0.1.tgz
https://registry.npmjs.org/esrecurse/-/esrecurse-4.3.0.tgz -> npmpkg-esrecurse-4.3.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-5.2.0.tgz -> npmpkg-estraverse-5.2.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-4.3.0.tgz -> npmpkg-estraverse-4.3.0.tgz
https://registry.npmjs.org/esutils/-/esutils-2.0.3.tgz -> npmpkg-esutils-2.0.3.tgz
https://registry.npmjs.org/event-emitter/-/event-emitter-0.3.5.tgz -> npmpkg-event-emitter-0.3.5.tgz
https://registry.npmjs.org/eventemitter3/-/eventemitter3-3.1.2.tgz -> npmpkg-eventemitter3-3.1.2.tgz
https://registry.npmjs.org/ext/-/ext-1.4.0.tgz -> npmpkg-ext-1.4.0.tgz
https://registry.npmjs.org/type/-/type-2.1.0.tgz -> npmpkg-type-2.1.0.tgz
https://registry.npmjs.org/f-matches/-/f-matches-1.1.0.tgz -> npmpkg-f-matches-1.1.0.tgz
https://registry.npmjs.org/fflate/-/fflate-0.6.10.tgz -> npmpkg-fflate-0.6.10.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.0.1.tgz -> npmpkg-fill-range-7.0.1.tgz
https://registry.npmjs.org/find-yarn-workspace-root/-/find-yarn-workspace-root-2.0.0.tgz -> npmpkg-find-yarn-workspace-root-2.0.0.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz -> npmpkg-fs.realpath-1.0.0.tgz
https://registry.npmjs.org/gensync/-/gensync-1.0.0-beta.1.tgz -> npmpkg-gensync-1.0.0-beta.1.tgz
https://registry.npmjs.org/glob/-/glob-7.1.6.tgz -> npmpkg-glob-7.1.6.tgz
https://registry.npmjs.org/globals/-/globals-11.12.0.tgz -> npmpkg-globals-11.12.0.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.4.tgz -> npmpkg-graceful-fs-4.2.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.0.1.tgz -> npmpkg-has-symbols-1.0.1.tgz
https://registry.npmjs.org/hash-sum/-/hash-sum-1.0.2.tgz -> npmpkg-hash-sum-1.0.2.tgz
https://registry.npmjs.org/he/-/he-1.2.0.tgz -> npmpkg-he-1.2.0.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz -> npmpkg-inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz -> npmpkg-inherits-2.0.4.tgz
https://registry.npmjs.org/interpret/-/interpret-1.4.0.tgz -> npmpkg-interpret-1.4.0.tgz
https://registry.npmjs.org/is-buffer/-/is-buffer-1.1.6.tgz -> npmpkg-is-buffer-1.1.6.tgz
https://registry.npmjs.org/is-ci/-/is-ci-2.0.0.tgz -> npmpkg-is-ci-2.0.0.tgz
https://registry.npmjs.org/is-docker/-/is-docker-2.2.1.tgz -> npmpkg-is-docker-2.2.1.tgz
https://registry.npmjs.org/is-expression/-/is-expression-3.0.0.tgz -> npmpkg-is-expression-3.0.0.tgz
https://registry.npmjs.org/acorn/-/acorn-4.0.13.tgz -> npmpkg-acorn-4.0.13.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/is-promise/-/is-promise-2.2.2.tgz -> npmpkg-is-promise-2.2.2.tgz
https://registry.npmjs.org/is-regex/-/is-regex-1.1.1.tgz -> npmpkg-is-regex-1.1.1.tgz
https://registry.npmjs.org/is-wsl/-/is-wsl-2.2.0.tgz -> npmpkg-is-wsl-2.2.0.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz -> npmpkg-isexe-2.0.0.tgz
https://registry.npmjs.org/ismobilejs/-/ismobilejs-1.1.1.tgz -> npmpkg-ismobilejs-1.1.1.tgz
https://registry.npmjs.org/js-stringify/-/js-stringify-1.0.2.tgz -> npmpkg-js-stringify-1.0.2.tgz
https://registry.npmjs.org/js-tokens/-/js-tokens-4.0.0.tgz -> npmpkg-js-tokens-4.0.0.tgz
https://registry.npmjs.org/jsesc/-/jsesc-2.5.2.tgz -> npmpkg-jsesc-2.5.2.tgz
https://registry.npmjs.org/json5/-/json5-2.1.3.tgz -> npmpkg-json5-2.1.3.tgz
https://registry.npmjs.org/jsonc-parser/-/jsonc-parser-3.0.0.tgz -> npmpkg-jsonc-parser-3.0.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-4.0.0.tgz -> npmpkg-jsonfile-4.0.0.tgz
https://registry.npmjs.org/jstransformer/-/jstransformer-1.0.0.tgz -> npmpkg-jstransformer-1.0.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/klaw-sync/-/klaw-sync-6.0.0.tgz -> npmpkg-klaw-sync-6.0.0.tgz
https://registry.npmjs.org/lazy-cache/-/lazy-cache-1.0.4.tgz -> npmpkg-lazy-cache-1.0.4.tgz
https://registry.npmjs.org/lebab/-/lebab-3.1.0.tgz -> npmpkg-lebab-3.1.0.tgz
https://registry.npmjs.org/ast-types/-/ast-types-0.13.3.tgz -> npmpkg-ast-types-0.13.3.tgz
https://registry.npmjs.org/recast/-/recast-0.18.10.tgz -> npmpkg-recast-0.18.10.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/lil-gui/-/lil-gui-0.17.0.tgz -> npmpkg-lil-gui-0.17.0.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.15.tgz -> npmpkg-lodash-4.17.15.tgz
https://registry.npmjs.org/lodash.get/-/lodash.get-4.4.2.tgz -> npmpkg-lodash.get-4.4.2.tgz
https://registry.npmjs.org/lodash.isequal/-/lodash.isequal-4.5.0.tgz -> npmpkg-lodash.isequal-4.5.0.tgz
https://registry.npmjs.org/longest/-/longest-1.0.1.tgz -> npmpkg-longest-1.0.1.tgz
https://registry.npmjs.org/loose-envify/-/loose-envify-1.4.0.tgz -> npmpkg-loose-envify-1.4.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-4.1.5.tgz -> npmpkg-lru-cache-4.1.5.tgz
https://registry.npmjs.org/lunr/-/lunr-2.3.9.tgz -> npmpkg-lunr-2.3.9.tgz
https://registry.npmjs.org/micromatch/-/micromatch-4.0.4.tgz -> npmpkg-micromatch-4.0.4.tgz
https://registry.npmjs.org/min-indent/-/min-indent-1.0.1.tgz -> npmpkg-min-indent-1.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.0.4.tgz -> npmpkg-minimatch-3.0.4.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.5.tgz -> npmpkg-minimist-1.2.5.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/neo-async/-/neo-async-2.6.2.tgz -> npmpkg-neo-async-2.6.2.tgz
https://registry.npmjs.org/next-tick/-/next-tick-1.0.0.tgz -> npmpkg-next-tick-1.0.0.tgz
https://registry.npmjs.org/nice-try/-/nice-try-1.0.5.tgz -> npmpkg-nice-try-1.0.5.tgz
https://registry.npmjs.org/node-dir/-/node-dir-0.1.17.tgz -> npmpkg-node-dir-0.1.17.tgz
https://registry.npmjs.org/object-assign/-/object-assign-4.1.1.tgz -> npmpkg-object-assign-4.1.1.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz -> npmpkg-once-1.4.0.tgz
https://registry.npmjs.org/open/-/open-7.4.2.tgz -> npmpkg-open-7.4.2.tgz
https://registry.npmjs.org/os-tmpdir/-/os-tmpdir-1.0.2.tgz -> npmpkg-os-tmpdir-1.0.2.tgz
https://registry.npmjs.org/patch-package/-/patch-package-6.4.7.tgz -> npmpkg-patch-package-6.4.7.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-7.0.1.tgz -> npmpkg-fs-extra-7.0.1.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> npmpkg-path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/path-key/-/path-key-2.0.1.tgz -> npmpkg-path-key-2.0.1.tgz
https://registry.npmjs.org/path-parse/-/path-parse-1.0.6.tgz -> npmpkg-path-parse-1.0.6.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.3.1.tgz -> npmpkg-picomatch-2.3.1.tgz
https://registry.npmjs.org/pixi.js/-/pixi.js-6.1.2.tgz -> npmpkg-pixi.js-6.1.2.tgz
https://registry.npmjs.org/prettier/-/prettier-2.1.2.tgz -> npmpkg-prettier-2.1.2.tgz
https://registry.npmjs.org/private/-/private-0.1.8.tgz -> npmpkg-private-0.1.8.tgz
https://registry.npmjs.org/promise/-/promise-7.3.1.tgz -> npmpkg-promise-7.3.1.tgz
https://registry.npmjs.org/promise-polyfill/-/promise-polyfill-8.2.0.tgz -> npmpkg-promise-polyfill-8.2.0.tgz
https://registry.npmjs.org/prop-types/-/prop-types-15.7.2.tgz -> npmpkg-prop-types-15.7.2.tgz
https://registry.npmjs.org/pseudomap/-/pseudomap-1.0.2.tgz -> npmpkg-pseudomap-1.0.2.tgz
https://registry.npmjs.org/pug/-/pug-2.0.4.tgz -> npmpkg-pug-2.0.4.tgz
https://registry.npmjs.org/pug-attrs/-/pug-attrs-2.0.4.tgz -> npmpkg-pug-attrs-2.0.4.tgz
https://registry.npmjs.org/pug-code-gen/-/pug-code-gen-2.0.2.tgz -> npmpkg-pug-code-gen-2.0.2.tgz
https://registry.npmjs.org/pug-error/-/pug-error-1.3.3.tgz -> npmpkg-pug-error-1.3.3.tgz
https://registry.npmjs.org/pug-filters/-/pug-filters-3.1.1.tgz -> npmpkg-pug-filters-3.1.1.tgz
https://registry.npmjs.org/pug-lexer/-/pug-lexer-4.1.0.tgz -> npmpkg-pug-lexer-4.1.0.tgz
https://registry.npmjs.org/pug-linker/-/pug-linker-3.0.6.tgz -> npmpkg-pug-linker-3.0.6.tgz
https://registry.npmjs.org/pug-load/-/pug-load-2.0.12.tgz -> npmpkg-pug-load-2.0.12.tgz
https://registry.npmjs.org/pug-parser/-/pug-parser-5.0.1.tgz -> npmpkg-pug-parser-5.0.1.tgz
https://registry.npmjs.org/pug-runtime/-/pug-runtime-2.0.5.tgz -> npmpkg-pug-runtime-2.0.5.tgz
https://registry.npmjs.org/pug-strip-comments/-/pug-strip-comments-1.0.4.tgz -> npmpkg-pug-strip-comments-1.0.4.tgz
https://registry.npmjs.org/pug-walk/-/pug-walk-1.1.8.tgz -> npmpkg-pug-walk-1.1.8.tgz
https://registry.npmjs.org/punycode/-/punycode-1.3.2.tgz -> npmpkg-punycode-1.3.2.tgz
https://registry.npmjs.org/querystring/-/querystring-0.2.0.tgz -> npmpkg-querystring-0.2.0.tgz
https://registry.npmjs.org/react/-/react-16.14.0.tgz -> npmpkg-react-16.14.0.tgz
https://registry.npmjs.org/react-ace/-/react-ace-6.6.0.tgz -> npmpkg-react-ace-6.6.0.tgz
https://registry.npmjs.org/react-docgen/-/react-docgen-5.3.0.tgz -> npmpkg-react-docgen-5.3.0.tgz
https://registry.npmjs.org/react-dom/-/react-dom-16.14.0.tgz -> npmpkg-react-dom-16.14.0.tgz
https://registry.npmjs.org/react-frame-component/-/react-frame-component-4.1.3.tgz -> npmpkg-react-frame-component-4.1.3.tgz
https://registry.npmjs.org/react-is/-/react-is-16.13.1.tgz -> npmpkg-react-is-16.13.1.tgz
https://registry.npmjs.org/recast/-/recast-0.17.6.tgz -> npmpkg-recast-0.17.6.tgz
https://registry.npmjs.org/ast-types/-/ast-types-0.12.4.tgz -> npmpkg-ast-types-0.12.4.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/rechoir/-/rechoir-0.6.2.tgz -> npmpkg-rechoir-0.6.2.tgz
https://registry.npmjs.org/recursive-readdir/-/recursive-readdir-2.2.2.tgz -> npmpkg-recursive-readdir-2.2.2.tgz
https://registry.npmjs.org/regenerator-runtime/-/regenerator-runtime-0.13.7.tgz -> npmpkg-regenerator-runtime-0.13.7.tgz
https://registry.npmjs.org/repeat-string/-/repeat-string-1.6.1.tgz -> npmpkg-repeat-string-1.6.1.tgz
https://registry.npmjs.org/resolve/-/resolve-1.17.0.tgz -> npmpkg-resolve-1.17.0.tgz
https://registry.npmjs.org/right-align/-/right-align-0.1.3.tgz -> npmpkg-right-align-0.1.3.tgz
https://registry.npmjs.org/rimraf/-/rimraf-2.7.1.tgz -> npmpkg-rimraf-2.7.1.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/scheduler/-/scheduler-0.19.1.tgz -> npmpkg-scheduler-0.19.1.tgz
https://registry.npmjs.org/semver/-/semver-5.7.1.tgz -> npmpkg-semver-5.7.1.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-1.2.0.tgz -> npmpkg-shebang-command-1.2.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-1.0.0.tgz -> npmpkg-shebang-regex-1.0.0.tgz
https://registry.npmjs.org/shelljs/-/shelljs-0.8.4.tgz -> npmpkg-shelljs-0.8.4.tgz
https://registry.npmjs.org/shiki/-/shiki-0.10.0.tgz -> npmpkg-shiki-0.10.0.tgz
https://registry.npmjs.org/slash/-/slash-2.0.0.tgz -> npmpkg-slash-2.0.0.tgz
https://registry.npmjs.org/source-map/-/source-map-0.5.7.tgz -> npmpkg-source-map-0.5.7.tgz
https://registry.npmjs.org/strip-indent/-/strip-indent-3.0.0.tgz -> npmpkg-strip-indent-3.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/tmp/-/tmp-0.0.33.tgz -> npmpkg-tmp-0.0.33.tgz
https://registry.npmjs.org/to-fast-properties/-/to-fast-properties-2.0.0.tgz -> npmpkg-to-fast-properties-2.0.0.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/token-stream/-/token-stream-0.0.1.tgz -> npmpkg-token-stream-0.0.1.tgz
https://registry.npmjs.org/ts-map/-/ts-map-1.0.3.tgz -> npmpkg-ts-map-1.0.3.tgz
https://registry.npmjs.org/tslib/-/tslib-2.0.3.tgz -> npmpkg-tslib-2.0.3.tgz
https://registry.npmjs.org/type/-/type-1.2.0.tgz -> npmpkg-type-1.2.0.tgz
https://registry.npmjs.org/typedoc/-/typedoc-0.22.11.tgz -> npmpkg-typedoc-0.22.11.tgz
https://registry.npmjs.org/typedoc-plugin-reference-excluder/-/typedoc-plugin-reference-excluder-1.0.0.tgz -> npmpkg-typedoc-plugin-reference-excluder-1.0.0.tgz
https://registry.npmjs.org/glob/-/glob-7.2.0.tgz -> npmpkg-glob-7.2.0.tgz
https://registry.npmjs.org/marked/-/marked-4.0.12.tgz -> npmpkg-marked-4.0.12.tgz
https://registry.npmjs.org/typescript/-/typescript-4.3.2.tgz -> npmpkg-typescript-4.3.2.tgz
https://registry.npmjs.org/uglify-js/-/uglify-js-2.8.29.tgz -> npmpkg-uglify-js-2.8.29.tgz
https://registry.npmjs.org/uglify-to-browserify/-/uglify-to-browserify-1.0.2.tgz -> npmpkg-uglify-to-browserify-1.0.2.tgz
https://registry.npmjs.org/underscore/-/underscore-1.10.2.tgz -> npmpkg-underscore-1.10.2.tgz
https://registry.npmjs.org/universalify/-/universalify-0.1.2.tgz -> npmpkg-universalify-0.1.2.tgz
https://registry.npmjs.org/url/-/url-0.11.0.tgz -> npmpkg-url-0.11.0.tgz
https://registry.npmjs.org/void-elements/-/void-elements-2.0.1.tgz -> npmpkg-void-elements-2.0.1.tgz
https://registry.npmjs.org/vscode-oniguruma/-/vscode-oniguruma-1.6.1.tgz -> npmpkg-vscode-oniguruma-1.6.1.tgz
https://registry.npmjs.org/vscode-textmate/-/vscode-textmate-5.2.0.tgz -> npmpkg-vscode-textmate-5.2.0.tgz
https://registry.npmjs.org/vue-docgen-api/-/vue-docgen-api-3.26.0.tgz -> npmpkg-vue-docgen-api-3.26.0.tgz
https://registry.npmjs.org/ast-types/-/ast-types-0.12.4.tgz -> npmpkg-ast-types-0.12.4.tgz
https://registry.npmjs.org/typescript/-/typescript-3.9.7.tgz -> npmpkg-typescript-3.9.7.tgz
https://registry.npmjs.org/vue-template-compiler/-/vue-template-compiler-2.6.12.tgz -> npmpkg-vue-template-compiler-2.6.12.tgz
https://registry.npmjs.org/vue2-ace-editor/-/vue2-ace-editor-0.0.13.tgz -> npmpkg-vue2-ace-editor-0.0.13.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/window-size/-/window-size-0.1.0.tgz -> npmpkg-window-size-0.1.0.tgz
https://registry.npmjs.org/with/-/with-5.1.1.tgz -> npmpkg-with-5.1.1.tgz
https://registry.npmjs.org/acorn/-/acorn-3.3.0.tgz -> npmpkg-acorn-3.3.0.tgz
https://registry.npmjs.org/wordwrap/-/wordwrap-0.0.2.tgz -> npmpkg-wordwrap-0.0.2.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
https://registry.npmjs.org/yallist/-/yallist-2.1.2.tgz -> npmpkg-yallist-2.1.2.tgz
https://registry.npmjs.org/yargs/-/yargs-3.10.0.tgz -> npmpkg-yargs-3.10.0.tgz
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
	if ver_test ${ACTIVE_VERSION%%.*} -ne ${GDCORE_TESTS_NODEJS_PV%%.*} ; then
eerror
eerror "Please switch to Node.js to ${GDCORE_TESTS_NODEJS_PV%%.*}."
eerror
eerror "Try:"
eerror
eerror "  eselect nodejs list"
eerror "  eselect nodejs set node${GDCORE_TESTS_NODEJS_PV%%.*}"
eerror
		die
	fi
}

pkg_setup() {
	pkg_setup_html5
	check-reqs_pkg_setup
	npm_pkg_setup
}

# @FUNCTION: __npm_src_unpack_default
# @DESCRIPTION:
# Unpacks a npm application.
__npm_src_unpack_default() {
evar_dump "NPM_PROJECT_ROOT" "${NPM_PROJECT_ROOT}"
	if [[ "${NPM_OFFLINE:-1}" == "0" ]] ; then
		:;
	elif declare -f npm_transform_uris > /dev/null ; then
		# For repo
		npm_transform_uris
	else
		npm_transform_uris_default
	fi
	local args=()
	if declare -f npm_unpack_install_pre > /dev/null ; then
		npm_unpack_install_pre
	fi
	local extra_args=()
	if [[ "${NPM_OFFLINE:-1}" ]] ; then
		extra_args+=( "--prefer-offline" )
	fi
	enpm install \
		${extra_args[@]} \
		${NPM_INSTALL_UNPACK_ARGS}
	if declare -f npm_unpack_install_post > /dev/null ; then
		npm_unpack_install_post
	fi

	# Audit fix is broken because of
	# npm ERR! Invalid Version:
	# in newIDE/app/package*.json
	if [[ "${NPM_OFFLINE:-1}" == "0" ]] ; then
		enpm audit fix \
			${NPM_INSTALL_UNPACK_AUDIT_FIX_ARGS}
	fi
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
		enpm install ${NPM_INSTALL_UNPACK_ARGS}
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
		enpm audit fix ${NPM_INSTALL_UNPACK_AUDIT_FIX_ARGS}
		if declare -f \
			npm_update_lock_audit_post > /dev/null ; then
			npm_update_lock_audit_post
		fi

		die
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

		if [[ "${NPM_OFFLINE:-1}" == "1" ]] ; then
			export ELECTRON_SKIP_BINARY_DOWNLOAD=1
			_npm_cp_tarballs

			if [[ -e "${FILESDIR}/${PV}" ]] ; then
				cp -aT "${FILESDIR}/${PV}" "${S}" || die
			fi
		fi

		local lockfiles=(
			"GDevelop.js/package-lock.json"			# Required step #1
			"newIDE/app/package-lock.json"			# Required step #2
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
			pushd "${NPM_PROJECT_ROOT}" || die
				__npm_src_unpack_default
			popd || die
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
#		export EMCC_CFLAGS="-stdlib=libc++"
#	fi
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

einfo
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
einfo
einfo "Building ${MY_PN}.js"
einfo

	npm_hydrate
	if [[ -n "${NPM_UPDATE_LOCK}" ]] ; then
		if [[ ${PV} =~ 9999 ]] ; then
			:;
		elif [[ -n "${NPM_TARBALL}" ]] ; then
			unpack ${NPM_TARBALL}
		else
			unpack ${P}.tar.gz
		fi

einfo "Updating lockfiles"
		mkdir -p "${WORKDIR}/lockfile-image" || die

		local lockfiles=(
			"GDevelop.js/package-lock.json"			# Required step #1
			"newIDE/app/package-lock.json"			# Required step #2
			"GDJS/package-lock.json"			# Required step #2a
			"newIDE/electron-app/package-lock.json"		# Required step #3
			"newIDE/electron-app/app/package-lock.json"	# Required step #3a
#			"newIDE/web-app/package-lock.json"
#			"GDJS/tests/package-lock.json"
		)

		local lockfile
		for lockfile in ${lockfiles[@]} ; do
einfo "Processing ${lockfile}"
			local d="$(dirname ${lockfile})"
			pushd "${S}/${d}" || die
				rm -f package-lock.json
				enpm install
				enpm audit fix
				local dest="${WORKDIR}/lockfile-image/${d}"
				mkdir -p "${dest}"
einfo "package.json -> ${dest}"
				cp -a package.json "${dest}"
einfo "package-lock.json -> ${dest}"
				cp -a package-lock.json "${dest}"
			popd
		done

		die
	else
		__npm_src_unpack
	fi
	grep -e "Error while copying @electron/remote" "${T}/build.log" && die
}

src_prepare() {
	default

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

	#xdg_src_prepare # calls src_unpack
	# Patches have already have been applied.
	# You need to fork to apply custom changes instead.
	touch "${T}/.portage_user_patches_applied"
	touch "${PORTAGE_BUILDDIR}/.user_patches_applied"
	export _CMAKE_UTILS_SRC_PREPARE_HAS_RUN=1
}

src_configure() { :; }

build_gdevelop_js() {
einfo
einfo "Compiling ${MY_PN}.js"
einfo
# In https://github.com/4ian/GDevelop/blob/v5.2.166/GDevelop.js/Gruntfile.js#L88
	pushd "${WORKDIR}/${MY_PN}-${MY_PV}/${MY_PN}.js"
		enpm run build -- --force --dev
	popd
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
einfo
einfo "Building ${MY_PN} IDE"
einfo
	pushd "${WORKDIR}/${MY_PN}-${MY_PV}/newIDE/app"
		enpm run build
	popd
}

build_gdevelop_ide_electron() {
einfo
einfo "Building ${MY_PN} $(ver_cut 1 ${PV}) on the Electron runtime"
einfo
	pushd "${WORKDIR}/${MY_PN}-${MY_PV}/newIDE/electron-app"
		if [[ "${NPM_OFFLINE:-1}" == "1" ]] ; then
			electron-app_cp_electron
		fi
		enpm run build
	popd
}


src_compile() {
	build_gdevelop_js
	build_gdevelop_ide
	build_gdevelop_ide_electron
	grep -q -e "Failed to compile." "${T}/build.log" && die
	grep -q -e "Error: Cannot find module" "${T}/build.log" && die "Detected error.  Retry." # Offline install bug
	grep -q -e "npm ERR! Invalid Version" "${T}/build.log" && die "Detected error.  Retry." # Indeterministic or random failure bug
	grep -q -e "Failed to compile." "${T}/build.log" && die "Detected error.  Retry."
	grep -q -e "Compiled successfully." "${T}/build.log" || die "Detected error.  Retry."
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
	newicon "newIDE/electron-app/build/icon-256x256.png" "${PN}.png"

	make_desktop_entry \
		"/usr/bin/${PN}" \
		"${MY_PN}" \
		"${PN}.png" \
		"Development;IDE"
	local exe_file_list=(
swiftshader/libGLESv2.so
swiftshader/libEGL.so
libGLESv2.so
libffmpeg.so
libvulkan.so.1
libEGL.so
gdevelop
chrome_crashpad_handler
libvk_swiftshader.so
chrome-sandbox
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
# wayland:                    failed
# X:                          passed
# command-line wrapper:       passed
# 2D platformer prototyping:  passed
# 3D platformer prototyping:  passed with transparency
