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

CR_LATEST_STABLE="129.0.6668.89"
CR_LATEST_STABLE_DATE="Oct 1, 2024"
CR_ELECTRON="108.0.5359.215"
CR_ELECTRON_DATE="Jan 23, 2023"

CHECKREQS_DISK_BUILD="2752M"
CHECKREQS_DISK_USR="2736M"
CHECKREQS_MEMORY="8192M"
CMAKE_BUILD_TYPE="Release"
export NPM_INSTALL_PATH="/opt/${PN}/${SLOT_MAJOR}"
#ELECTRON_APP_APPIMAGE="1"
ELECTRON_APP_APPIMAGE_ARCHIVE_NAME="${MY_PN}-${PV%%.*}-${PV}.AppImage"
#ELECTRON_APP_ELECTRON_PV="31.1.0" # Chromium 126.0.6478.114 ; Runtime breakage
ELECTRON_APP_ELECTRON_PV="22.3.27" # Chromium 108.0.5359.215 ; It works.
#ELECTRON_APP_ELECTRON_PV="18.2.2" # Chromium 100.0.4896.143 ; It works.
# For ELECTRON_APP_ELECTRON_PV, see \
# https://github.com/4ian/GDevelop/blob/v5.4.213/newIDE/electron-app/package-lock.json#L1440 \
# and \
# strings /var/tmp/portage/dev-games/gdevelop-5.3.204/work/GDevelop-5.3.204/newIDE/electron-app/dist/linux-unpacked/* | grep -E "Chrome/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+"
ELECTRON_APP_REACT_PV="16.14.0" # See \
# The last supported for react 16.14.0 is node 14.0. \
# https://github.com/facebook/react/blob/v16.14.0/package.json#L100 \
# https://github.com/4ian/GDevelop/blob/v5.4.213/newIDE/app/package-lock.json#L27009
ELECTRON_APP_REACT_PV="ignore" # The lock file says >=0.10.0 but it is wrong.  We force it because CI tests passed.
EMBUILD_DIR="${WORKDIR}/build"
#EMSCRIPTEN_PV="3.1.21" # Based on CI.  EMSCRIPTEN_PV == EMSDK_PV
EMSCRIPTEN_PV="1.39.20" # Temporary until 3.1.30 ebuild is fixed.
# Emscripten 3.1.21 requires llvm 16 for wasm, 4.1.1 nodejs
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
NPM_AUDIT_FIX=0 # Audit fix is broken
NPM_AUDIT_FIX_ARGS=(
)
PYTHON_COMPAT=( python3_{10,11} ) # CI uses 3.8, 3.9

# Using yarn results in failures.
inherit check-reqs desktop electron-app evar_dump flag-o-matic llvm npm
inherit python-r1 toolchain-funcs xdg

# UPDATER_START_NPM_EXTERNAL_URIS
NPM_EXTERNAL_URIS="
https://registry.npmjs.org/@ampproject/remapping/-/remapping-2.2.1.tgz -> npmpkg-@ampproject-remapping-2.2.1.tgz
https://registry.npmjs.org/@babel/code-frame/-/code-frame-7.24.7.tgz -> npmpkg-@babel-code-frame-7.24.7.tgz
https://registry.npmjs.org/@babel/compat-data/-/compat-data-7.25.4.tgz -> npmpkg-@babel-compat-data-7.25.4.tgz
https://registry.npmjs.org/@babel/core/-/core-7.25.2.tgz -> npmpkg-@babel-core-7.25.2.tgz
https://registry.npmjs.org/convert-source-map/-/convert-source-map-2.0.0.tgz -> npmpkg-convert-source-map-2.0.0.tgz
https://registry.npmjs.org/@babel/generator/-/generator-7.25.6.tgz -> npmpkg-@babel-generator-7.25.6.tgz
https://registry.npmjs.org/@babel/helper-compilation-targets/-/helper-compilation-targets-7.25.2.tgz -> npmpkg-@babel-helper-compilation-targets-7.25.2.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-5.1.1.tgz -> npmpkg-lru-cache-5.1.1.tgz
https://registry.npmjs.org/@babel/helper-module-imports/-/helper-module-imports-7.24.7.tgz -> npmpkg-@babel-helper-module-imports-7.24.7.tgz
https://registry.npmjs.org/@babel/helper-module-transforms/-/helper-module-transforms-7.25.2.tgz -> npmpkg-@babel-helper-module-transforms-7.25.2.tgz
https://registry.npmjs.org/@babel/helper-plugin-utils/-/helper-plugin-utils-7.22.5.tgz -> npmpkg-@babel-helper-plugin-utils-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-simple-access/-/helper-simple-access-7.24.7.tgz -> npmpkg-@babel-helper-simple-access-7.24.7.tgz
https://registry.npmjs.org/@babel/helper-string-parser/-/helper-string-parser-7.24.8.tgz -> npmpkg-@babel-helper-string-parser-7.24.8.tgz
https://registry.npmjs.org/@babel/helper-validator-identifier/-/helper-validator-identifier-7.24.7.tgz -> npmpkg-@babel-helper-validator-identifier-7.24.7.tgz
https://registry.npmjs.org/@babel/helper-validator-option/-/helper-validator-option-7.24.8.tgz -> npmpkg-@babel-helper-validator-option-7.24.8.tgz
https://registry.npmjs.org/@babel/helpers/-/helpers-7.25.6.tgz -> npmpkg-@babel-helpers-7.25.6.tgz
https://registry.npmjs.org/@babel/highlight/-/highlight-7.24.7.tgz -> npmpkg-@babel-highlight-7.24.7.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/@babel/parser/-/parser-7.25.6.tgz -> npmpkg-@babel-parser-7.25.6.tgz
https://registry.npmjs.org/@babel/plugin-syntax-async-generators/-/plugin-syntax-async-generators-7.8.4.tgz -> npmpkg-@babel-plugin-syntax-async-generators-7.8.4.tgz
https://registry.npmjs.org/@babel/plugin-syntax-bigint/-/plugin-syntax-bigint-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-bigint-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-class-properties/-/plugin-syntax-class-properties-7.12.13.tgz -> npmpkg-@babel-plugin-syntax-class-properties-7.12.13.tgz
https://registry.npmjs.org/@babel/plugin-syntax-import-meta/-/plugin-syntax-import-meta-7.10.4.tgz -> npmpkg-@babel-plugin-syntax-import-meta-7.10.4.tgz
https://registry.npmjs.org/@babel/plugin-syntax-json-strings/-/plugin-syntax-json-strings-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-json-strings-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-jsx/-/plugin-syntax-jsx-7.23.3.tgz -> npmpkg-@babel-plugin-syntax-jsx-7.23.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-logical-assignment-operators/-/plugin-syntax-logical-assignment-operators-7.10.4.tgz -> npmpkg-@babel-plugin-syntax-logical-assignment-operators-7.10.4.tgz
https://registry.npmjs.org/@babel/plugin-syntax-nullish-coalescing-operator/-/plugin-syntax-nullish-coalescing-operator-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-nullish-coalescing-operator-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-numeric-separator/-/plugin-syntax-numeric-separator-7.10.4.tgz -> npmpkg-@babel-plugin-syntax-numeric-separator-7.10.4.tgz
https://registry.npmjs.org/@babel/plugin-syntax-object-rest-spread/-/plugin-syntax-object-rest-spread-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-object-rest-spread-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-optional-catch-binding/-/plugin-syntax-optional-catch-binding-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-optional-catch-binding-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-optional-chaining/-/plugin-syntax-optional-chaining-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-optional-chaining-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-top-level-await/-/plugin-syntax-top-level-await-7.14.5.tgz -> npmpkg-@babel-plugin-syntax-top-level-await-7.14.5.tgz
https://registry.npmjs.org/@babel/plugin-syntax-typescript/-/plugin-syntax-typescript-7.23.3.tgz -> npmpkg-@babel-plugin-syntax-typescript-7.23.3.tgz
https://registry.npmjs.org/@babel/template/-/template-7.25.0.tgz -> npmpkg-@babel-template-7.25.0.tgz
https://registry.npmjs.org/@babel/traverse/-/traverse-7.25.6.tgz -> npmpkg-@babel-traverse-7.25.6.tgz
https://registry.npmjs.org/@babel/types/-/types-7.25.6.tgz -> npmpkg-@babel-types-7.25.6.tgz
https://registry.npmjs.org/@bcoe/v8-coverage/-/v8-coverage-0.2.3.tgz -> npmpkg-@bcoe-v8-coverage-0.2.3.tgz
https://registry.npmjs.org/@hapi/boom/-/boom-9.1.4.tgz -> npmpkg-@hapi-boom-9.1.4.tgz
https://registry.npmjs.org/@hapi/cryptiles/-/cryptiles-5.1.0.tgz -> npmpkg-@hapi-cryptiles-5.1.0.tgz
https://registry.npmjs.org/@hapi/hoek/-/hoek-9.3.0.tgz -> npmpkg-@hapi-hoek-9.3.0.tgz
https://registry.npmjs.org/@istanbuljs/load-nyc-config/-/load-nyc-config-1.1.0.tgz -> npmpkg-@istanbuljs-load-nyc-config-1.1.0.tgz
https://registry.npmjs.org/@istanbuljs/schema/-/schema-0.1.3.tgz -> npmpkg-@istanbuljs-schema-0.1.3.tgz
https://registry.npmjs.org/@jest/console/-/console-29.7.0.tgz -> npmpkg-@jest-console-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/@jest/core/-/core-29.7.0.tgz -> npmpkg-@jest-core-29.7.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/micromatch/-/micromatch-4.0.8.tgz -> npmpkg-micromatch-4.0.8.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/@jest/environment/-/environment-29.7.0.tgz -> npmpkg-@jest-environment-29.7.0.tgz
https://registry.npmjs.org/@jest/expect/-/expect-29.7.0.tgz -> npmpkg-@jest-expect-29.7.0.tgz
https://registry.npmjs.org/@jest/expect-utils/-/expect-utils-29.7.0.tgz -> npmpkg-@jest-expect-utils-29.7.0.tgz
https://registry.npmjs.org/@jest/fake-timers/-/fake-timers-29.7.0.tgz -> npmpkg-@jest-fake-timers-29.7.0.tgz
https://registry.npmjs.org/@jest/globals/-/globals-29.7.0.tgz -> npmpkg-@jest-globals-29.7.0.tgz
https://registry.npmjs.org/@jest/reporters/-/reporters-29.7.0.tgz -> npmpkg-@jest-reporters-29.7.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/@jest/schemas/-/schemas-29.6.3.tgz -> npmpkg-@jest-schemas-29.6.3.tgz
https://registry.npmjs.org/@jest/source-map/-/source-map-29.6.3.tgz -> npmpkg-@jest-source-map-29.6.3.tgz
https://registry.npmjs.org/@jest/test-result/-/test-result-29.7.0.tgz -> npmpkg-@jest-test-result-29.7.0.tgz
https://registry.npmjs.org/@jest/test-sequencer/-/test-sequencer-29.7.0.tgz -> npmpkg-@jest-test-sequencer-29.7.0.tgz
https://registry.npmjs.org/@jest/transform/-/transform-29.7.0.tgz -> npmpkg-@jest-transform-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/convert-source-map/-/convert-source-map-2.0.0.tgz -> npmpkg-convert-source-map-2.0.0.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/micromatch/-/micromatch-4.0.8.tgz -> npmpkg-micromatch-4.0.8.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/@jest/types/-/types-29.6.3.tgz -> npmpkg-@jest-types-29.6.3.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/@jridgewell/gen-mapping/-/gen-mapping-0.3.5.tgz -> npmpkg-@jridgewell-gen-mapping-0.3.5.tgz
https://registry.npmjs.org/@jridgewell/resolve-uri/-/resolve-uri-3.1.1.tgz -> npmpkg-@jridgewell-resolve-uri-3.1.1.tgz
https://registry.npmjs.org/@jridgewell/set-array/-/set-array-1.2.1.tgz -> npmpkg-@jridgewell-set-array-1.2.1.tgz
https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.4.15.tgz -> npmpkg-@jridgewell-sourcemap-codec-1.4.15.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.25.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.25.tgz
https://registry.npmjs.org/@sinclair/typebox/-/typebox-0.27.8.tgz -> npmpkg-@sinclair-typebox-0.27.8.tgz
https://registry.npmjs.org/@sinonjs/commons/-/commons-3.0.0.tgz -> npmpkg-@sinonjs-commons-3.0.0.tgz
https://registry.npmjs.org/@sinonjs/fake-timers/-/fake-timers-10.3.0.tgz -> npmpkg-@sinonjs-fake-timers-10.3.0.tgz
https://registry.npmjs.org/@tootallnate/once/-/once-1.1.2.tgz -> npmpkg-@tootallnate-once-1.1.2.tgz
https://registry.npmjs.org/@types/babel__core/-/babel__core-7.20.5.tgz -> npmpkg-@types-babel__core-7.20.5.tgz
https://registry.npmjs.org/@types/babel__generator/-/babel__generator-7.6.7.tgz -> npmpkg-@types-babel__generator-7.6.7.tgz
https://registry.npmjs.org/@types/babel__template/-/babel__template-7.4.4.tgz -> npmpkg-@types-babel__template-7.4.4.tgz
https://registry.npmjs.org/@types/babel__traverse/-/babel__traverse-7.20.4.tgz -> npmpkg-@types-babel__traverse-7.20.4.tgz
https://registry.npmjs.org/@types/graceful-fs/-/graceful-fs-4.1.9.tgz -> npmpkg-@types-graceful-fs-4.1.9.tgz
https://registry.npmjs.org/@types/istanbul-lib-coverage/-/istanbul-lib-coverage-2.0.6.tgz -> npmpkg-@types-istanbul-lib-coverage-2.0.6.tgz
https://registry.npmjs.org/@types/istanbul-lib-report/-/istanbul-lib-report-3.0.3.tgz -> npmpkg-@types-istanbul-lib-report-3.0.3.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.4.tgz -> npmpkg-@types-istanbul-reports-3.0.4.tgz
https://registry.npmjs.org/@types/node/-/node-20.10.0.tgz -> npmpkg-@types-node-20.10.0.tgz
https://registry.npmjs.org/@types/stack-utils/-/stack-utils-2.0.3.tgz -> npmpkg-@types-stack-utils-2.0.3.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-17.0.32.tgz -> npmpkg-@types-yargs-17.0.32.tgz
https://registry.npmjs.org/@types/yargs-parser/-/yargs-parser-21.0.3.tgz -> npmpkg-@types-yargs-parser-21.0.3.tgz
https://registry.npmjs.org/abab/-/abab-2.0.6.tgz -> npmpkg-abab-2.0.6.tgz
https://registry.npmjs.org/abbrev/-/abbrev-1.1.1.tgz -> npmpkg-abbrev-1.1.1.tgz
https://registry.npmjs.org/acorn/-/acorn-8.12.1.tgz -> npmpkg-acorn-8.12.1.tgz
https://registry.npmjs.org/acorn-globals/-/acorn-globals-6.0.0.tgz -> npmpkg-acorn-globals-6.0.0.tgz
https://registry.npmjs.org/acorn/-/acorn-7.4.1.tgz -> npmpkg-acorn-7.4.1.tgz
https://registry.npmjs.org/acorn-walk/-/acorn-walk-7.2.0.tgz -> npmpkg-acorn-walk-7.2.0.tgz
https://registry.npmjs.org/adm-zip/-/adm-zip-0.5.16.tgz -> npmpkg-adm-zip-0.5.16.tgz
https://registry.npmjs.org/agent-base/-/agent-base-6.0.2.tgz -> npmpkg-agent-base-6.0.2.tgz
https://registry.npmjs.org/ajv/-/ajv-6.12.6.tgz -> npmpkg-ajv-6.12.6.tgz
https://registry.npmjs.org/ansi-escapes/-/ansi-escapes-4.3.2.tgz -> npmpkg-ansi-escapes-4.3.2.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-2.1.1.tgz -> npmpkg-ansi-regex-2.1.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-2.2.1.tgz -> npmpkg-ansi-styles-2.2.1.tgz
https://registry.npmjs.org/anymatch/-/anymatch-3.1.3.tgz -> npmpkg-anymatch-3.1.3.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz -> npmpkg-normalize-path-3.0.0.tgz
https://registry.npmjs.org/archiver/-/archiver-5.3.2.tgz -> npmpkg-archiver-5.3.2.tgz
https://registry.npmjs.org/archiver-utils/-/archiver-utils-2.1.0.tgz -> npmpkg-archiver-utils-2.1.0.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz -> npmpkg-normalize-path-3.0.0.tgz
https://registry.npmjs.org/async/-/async-3.2.6.tgz -> npmpkg-async-3.2.6.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/argparse/-/argparse-1.0.9.tgz -> npmpkg-argparse-1.0.9.tgz
https://registry.npmjs.org/arr-diff/-/arr-diff-2.0.0.tgz -> npmpkg-arr-diff-2.0.0.tgz
https://registry.npmjs.org/arr-flatten/-/arr-flatten-1.1.0.tgz -> npmpkg-arr-flatten-1.1.0.tgz
https://registry.npmjs.org/array-each/-/array-each-1.0.1.tgz -> npmpkg-array-each-1.0.1.tgz
https://registry.npmjs.org/array-slice/-/array-slice-1.1.0.tgz -> npmpkg-array-slice-1.1.0.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.2.1.tgz -> npmpkg-array-unique-0.2.1.tgz
https://registry.npmjs.org/asn1/-/asn1-0.2.3.tgz -> npmpkg-asn1-0.2.3.tgz
https://registry.npmjs.org/assert-plus/-/assert-plus-1.0.0.tgz -> npmpkg-assert-plus-1.0.0.tgz
https://registry.npmjs.org/async/-/async-1.5.2.tgz -> npmpkg-async-1.5.2.tgz
https://registry.npmjs.org/asynckit/-/asynckit-0.4.0.tgz -> npmpkg-asynckit-0.4.0.tgz
https://registry.npmjs.org/aws-sign2/-/aws-sign2-0.7.0.tgz -> npmpkg-aws-sign2-0.7.0.tgz
https://registry.npmjs.org/aws4/-/aws4-1.13.2.tgz -> npmpkg-aws4-1.13.2.tgz
https://registry.npmjs.org/babel-jest/-/babel-jest-29.7.0.tgz -> npmpkg-babel-jest-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/babel-plugin-istanbul/-/babel-plugin-istanbul-6.1.1.tgz -> npmpkg-babel-plugin-istanbul-6.1.1.tgz
https://registry.npmjs.org/istanbul-lib-instrument/-/istanbul-lib-instrument-5.2.1.tgz -> npmpkg-istanbul-lib-instrument-5.2.1.tgz
https://registry.npmjs.org/babel-plugin-jest-hoist/-/babel-plugin-jest-hoist-29.6.3.tgz -> npmpkg-babel-plugin-jest-hoist-29.6.3.tgz
https://registry.npmjs.org/babel-preset-current-node-syntax/-/babel-preset-current-node-syntax-1.0.1.tgz -> npmpkg-babel-preset-current-node-syntax-1.0.1.tgz
https://registry.npmjs.org/babel-preset-jest/-/babel-preset-jest-29.6.3.tgz -> npmpkg-babel-preset-jest-29.6.3.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.0.tgz -> npmpkg-balanced-match-1.0.0.tgz
https://registry.npmjs.org/base64-js/-/base64-js-1.5.1.tgz -> npmpkg-base64-js-1.5.1.tgz
https://registry.npmjs.org/bcrypt-pbkdf/-/bcrypt-pbkdf-1.0.1.tgz -> npmpkg-bcrypt-pbkdf-1.0.1.tgz
https://registry.npmjs.org/bl/-/bl-1.2.3.tgz -> npmpkg-bl-1.2.3.tgz
https://registry.npmjs.org/boolbase/-/boolbase-1.0.0.tgz -> npmpkg-boolbase-1.0.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/braces/-/braces-3.0.3.tgz -> npmpkg-braces-3.0.3.tgz
https://registry.npmjs.org/browser-process-hrtime/-/browser-process-hrtime-1.0.0.tgz -> npmpkg-browser-process-hrtime-1.0.0.tgz
https://registry.npmjs.org/browserslist/-/browserslist-4.24.0.tgz -> npmpkg-browserslist-4.24.0.tgz
https://registry.npmjs.org/bser/-/bser-2.1.1.tgz -> npmpkg-bser-2.1.1.tgz
https://registry.npmjs.org/buffer/-/buffer-5.7.1.tgz -> npmpkg-buffer-5.7.1.tgz
https://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.2.13.tgz -> npmpkg-buffer-crc32-0.2.13.tgz
https://registry.npmjs.org/buffer-from/-/buffer-from-1.1.2.tgz -> npmpkg-buffer-from-1.1.2.tgz
https://registry.npmjs.org/callsites/-/callsites-3.1.0.tgz -> npmpkg-callsites-3.1.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-5.3.1.tgz -> npmpkg-camelcase-5.3.1.tgz
https://registry.npmjs.org/caniuse-lite/-/caniuse-lite-1.0.30001666.tgz -> npmpkg-caniuse-lite-1.0.30001666.tgz
https://registry.npmjs.org/caseless/-/caseless-0.12.0.tgz -> npmpkg-caseless-0.12.0.tgz
https://registry.npmjs.org/chalk/-/chalk-1.1.3.tgz -> npmpkg-chalk-1.1.3.tgz
https://registry.npmjs.org/char-regex/-/char-regex-1.0.2.tgz -> npmpkg-char-regex-1.0.2.tgz
https://registry.npmjs.org/cheerio/-/cheerio-0.20.0.tgz -> npmpkg-cheerio-0.20.0.tgz
https://registry.npmjs.org/abab/-/abab-1.0.4.tgz -> npmpkg-abab-1.0.4.tgz
https://registry.npmjs.org/acorn/-/acorn-2.7.0.tgz -> npmpkg-acorn-2.7.0.tgz
https://registry.npmjs.org/acorn-globals/-/acorn-globals-1.0.9.tgz -> npmpkg-acorn-globals-1.0.9.tgz
https://registry.npmjs.org/cssstyle/-/cssstyle-0.2.37.tgz -> npmpkg-cssstyle-0.2.37.tgz
https://registry.npmjs.org/jsdom/-/jsdom-7.2.2.tgz -> npmpkg-jsdom-7.2.2.tgz
https://registry.npmjs.org/parse5/-/parse5-1.5.1.tgz -> npmpkg-parse5-1.5.1.tgz
https://registry.npmjs.org/tough-cookie/-/tough-cookie-2.5.0.tgz -> npmpkg-tough-cookie-2.5.0.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-2.0.1.tgz -> npmpkg-webidl-conversions-2.0.1.tgz
https://registry.npmjs.org/xml-name-validator/-/xml-name-validator-2.0.1.tgz -> npmpkg-xml-name-validator-2.0.1.tgz
https://registry.npmjs.org/chownr/-/chownr-1.1.4.tgz -> npmpkg-chownr-1.1.4.tgz
https://registry.npmjs.org/ci-info/-/ci-info-3.9.0.tgz -> npmpkg-ci-info-3.9.0.tgz
https://registry.npmjs.org/cjs-module-lexer/-/cjs-module-lexer-1.2.3.tgz -> npmpkg-cjs-module-lexer-1.2.3.tgz
https://registry.npmjs.org/clone/-/clone-1.0.4.tgz -> npmpkg-clone-1.0.4.tgz
https://registry.npmjs.org/clone-stats/-/clone-stats-0.0.1.tgz -> npmpkg-clone-stats-0.0.1.tgz
https://registry.npmjs.org/co/-/co-4.6.0.tgz -> npmpkg-co-4.6.0.tgz
https://registry.npmjs.org/collect-v8-coverage/-/collect-v8-coverage-1.0.2.tgz -> npmpkg-collect-v8-coverage-1.0.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/colors/-/colors-1.1.2.tgz -> npmpkg-colors-1.1.2.tgz
https://registry.npmjs.org/combined-stream/-/combined-stream-1.0.8.tgz -> npmpkg-combined-stream-1.0.8.tgz
https://registry.npmjs.org/commander/-/commander-2.20.3.tgz -> npmpkg-commander-2.20.3.tgz
https://registry.npmjs.org/compress-commons/-/compress-commons-4.1.2.tgz -> npmpkg-compress-commons-4.1.2.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz -> npmpkg-normalize-path-3.0.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/convert-source-map/-/convert-source-map-1.9.0.tgz -> npmpkg-convert-source-map-1.9.0.tgz
https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.2.tgz -> npmpkg-core-util-is-1.0.2.tgz
https://registry.npmjs.org/crc-32/-/crc-32-1.2.2.tgz -> npmpkg-crc-32-1.2.2.tgz
https://registry.npmjs.org/crc32-stream/-/crc32-stream-4.0.3.tgz -> npmpkg-crc32-stream-4.0.3.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/create-jest/-/create-jest-29.7.0.tgz -> npmpkg-create-jest-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz -> npmpkg-cross-spawn-7.0.3.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/css-select/-/css-select-1.2.0.tgz -> npmpkg-css-select-1.2.0.tgz
https://registry.npmjs.org/css-what/-/css-what-2.1.3.tgz -> npmpkg-css-what-2.1.3.tgz
https://registry.npmjs.org/cssom/-/cssom-0.3.8.tgz -> npmpkg-cssom-0.3.8.tgz
https://registry.npmjs.org/cssstyle/-/cssstyle-2.3.0.tgz -> npmpkg-cssstyle-2.3.0.tgz
https://registry.npmjs.org/cycle/-/cycle-1.0.3.tgz -> npmpkg-cycle-1.0.3.tgz
https://registry.npmjs.org/dashdash/-/dashdash-1.14.1.tgz -> npmpkg-dashdash-1.14.1.tgz
https://registry.npmjs.org/data-urls/-/data-urls-2.0.0.tgz -> npmpkg-data-urls-2.0.0.tgz
https://registry.npmjs.org/dateformat/-/dateformat-4.6.3.tgz -> npmpkg-dateformat-4.6.3.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/decimal.js/-/decimal.js-10.4.3.tgz -> npmpkg-decimal.js-10.4.3.tgz
https://registry.npmjs.org/dedent/-/dedent-1.5.1.tgz -> npmpkg-dedent-1.5.1.tgz
https://registry.npmjs.org/deep-is/-/deep-is-0.1.3.tgz -> npmpkg-deep-is-0.1.3.tgz
https://registry.npmjs.org/deepmerge/-/deepmerge-4.3.1.tgz -> npmpkg-deepmerge-4.3.1.tgz
https://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz -> npmpkg-delayed-stream-1.0.0.tgz
https://registry.npmjs.org/detect-file/-/detect-file-1.0.0.tgz -> npmpkg-detect-file-1.0.0.tgz
https://registry.npmjs.org/detect-newline/-/detect-newline-3.1.0.tgz -> npmpkg-detect-newline-3.1.0.tgz
https://registry.npmjs.org/diff-sequences/-/diff-sequences-29.6.3.tgz -> npmpkg-diff-sequences-29.6.3.tgz
https://registry.npmjs.org/dom-serializer/-/dom-serializer-0.1.1.tgz -> npmpkg-dom-serializer-0.1.1.tgz
https://registry.npmjs.org/domelementtype/-/domelementtype-1.3.1.tgz -> npmpkg-domelementtype-1.3.1.tgz
https://registry.npmjs.org/domexception/-/domexception-2.0.1.tgz -> npmpkg-domexception-2.0.1.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-5.0.0.tgz -> npmpkg-webidl-conversions-5.0.0.tgz
https://registry.npmjs.org/domhandler/-/domhandler-2.3.0.tgz -> npmpkg-domhandler-2.3.0.tgz
https://registry.npmjs.org/domutils/-/domutils-1.5.1.tgz -> npmpkg-domutils-1.5.1.tgz
https://registry.npmjs.org/duplexer/-/duplexer-0.1.2.tgz -> npmpkg-duplexer-0.1.2.tgz
https://registry.npmjs.org/duplexify/-/duplexify-3.7.1.tgz -> npmpkg-duplexify-3.7.1.tgz
https://registry.npmjs.org/ecc-jsbn/-/ecc-jsbn-0.1.1.tgz -> npmpkg-ecc-jsbn-0.1.1.tgz
https://registry.npmjs.org/ejs/-/ejs-3.1.10.tgz -> npmpkg-ejs-3.1.10.tgz
https://registry.npmjs.org/electron-to-chromium/-/electron-to-chromium-1.5.31.tgz -> npmpkg-electron-to-chromium-1.5.31.tgz
https://registry.npmjs.org/emittery/-/emittery-0.13.1.tgz -> npmpkg-emittery-0.13.1.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.4.4.tgz -> npmpkg-end-of-stream-1.4.4.tgz
https://registry.npmjs.org/entities/-/entities-1.1.2.tgz -> npmpkg-entities-1.1.2.tgz
https://registry.npmjs.org/error-ex/-/error-ex-1.3.1.tgz -> npmpkg-error-ex-1.3.1.tgz
https://registry.npmjs.org/escalade/-/escalade-3.2.0.tgz -> npmpkg-escalade-3.2.0.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/escodegen/-/escodegen-1.14.3.tgz -> npmpkg-escodegen-1.14.3.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/esprima/-/esprima-4.0.1.tgz -> npmpkg-esprima-4.0.1.tgz
https://registry.npmjs.org/estraverse/-/estraverse-4.3.0.tgz -> npmpkg-estraverse-4.3.0.tgz
https://registry.npmjs.org/esutils/-/esutils-2.0.2.tgz -> npmpkg-esutils-2.0.2.tgz
https://registry.npmjs.org/eventemitter2/-/eventemitter2-0.4.14.tgz -> npmpkg-eventemitter2-0.4.14.tgz
https://registry.npmjs.org/execa/-/execa-5.1.1.tgz -> npmpkg-execa-5.1.1.tgz
https://registry.npmjs.org/is-stream/-/is-stream-2.0.1.tgz -> npmpkg-is-stream-2.0.1.tgz
https://registry.npmjs.org/merge-stream/-/merge-stream-2.0.0.tgz -> npmpkg-merge-stream-2.0.0.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-4.0.1.tgz -> npmpkg-npm-run-path-4.0.1.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/exit/-/exit-0.1.2.tgz -> npmpkg-exit-0.1.2.tgz
https://registry.npmjs.org/expand-brackets/-/expand-brackets-0.1.5.tgz -> npmpkg-expand-brackets-0.1.5.tgz
https://registry.npmjs.org/expand-range/-/expand-range-1.8.2.tgz -> npmpkg-expand-range-1.8.2.tgz
https://registry.npmjs.org/fill-range/-/fill-range-2.2.4.tgz -> npmpkg-fill-range-2.2.4.tgz
https://registry.npmjs.org/is-number/-/is-number-2.1.0.tgz -> npmpkg-is-number-2.1.0.tgz
https://registry.npmjs.org/isobject/-/isobject-2.1.0.tgz -> npmpkg-isobject-2.1.0.tgz
https://registry.npmjs.org/expand-tilde/-/expand-tilde-2.0.2.tgz -> npmpkg-expand-tilde-2.0.2.tgz
https://registry.npmjs.org/expect/-/expect-29.7.0.tgz -> npmpkg-expect-29.7.0.tgz
https://registry.npmjs.org/extend/-/extend-2.0.2.tgz -> npmpkg-extend-2.0.2.tgz
https://registry.npmjs.org/extglob/-/extglob-0.3.2.tgz -> npmpkg-extglob-0.3.2.tgz
https://registry.npmjs.org/extsprintf/-/extsprintf-1.3.0.tgz -> npmpkg-extsprintf-1.3.0.tgz
https://registry.npmjs.org/eyes/-/eyes-0.1.8.tgz -> npmpkg-eyes-0.1.8.tgz
https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz -> npmpkg-fast-deep-equal-3.1.3.tgz
https://registry.npmjs.org/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz -> npmpkg-fast-json-stable-stringify-2.1.0.tgz
https://registry.npmjs.org/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz -> npmpkg-fast-levenshtein-2.0.6.tgz
https://registry.npmjs.org/fb-watchman/-/fb-watchman-2.0.2.tgz -> npmpkg-fb-watchman-2.0.2.tgz
https://registry.npmjs.org/figures/-/figures-3.2.0.tgz -> npmpkg-figures-3.2.0.tgz
https://registry.npmjs.org/file-sync-cmp/-/file-sync-cmp-0.1.1.tgz -> npmpkg-file-sync-cmp-0.1.1.tgz
https://registry.npmjs.org/filelist/-/filelist-1.0.4.tgz -> npmpkg-filelist-1.0.4.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-5.1.6.tgz -> npmpkg-minimatch-5.1.6.tgz
https://registry.npmjs.org/filename-regex/-/filename-regex-2.0.1.tgz -> npmpkg-filename-regex-2.0.1.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.1.1.tgz -> npmpkg-fill-range-7.1.1.tgz
https://registry.npmjs.org/find-up/-/find-up-4.1.0.tgz -> npmpkg-find-up-4.1.0.tgz
https://registry.npmjs.org/findup-sync/-/findup-sync-5.0.0.tgz -> npmpkg-findup-sync-5.0.0.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz -> npmpkg-is-extglob-2.1.1.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/micromatch/-/micromatch-4.0.8.tgz -> npmpkg-micromatch-4.0.8.tgz
https://registry.npmjs.org/fined/-/fined-1.2.0.tgz -> npmpkg-fined-1.2.0.tgz
https://registry.npmjs.org/first-chunk-stream/-/first-chunk-stream-1.0.0.tgz -> npmpkg-first-chunk-stream-1.0.0.tgz
https://registry.npmjs.org/flagged-respawn/-/flagged-respawn-1.0.1.tgz -> npmpkg-flagged-respawn-1.0.1.tgz
https://registry.npmjs.org/for-in/-/for-in-1.0.2.tgz -> npmpkg-for-in-1.0.2.tgz
https://registry.npmjs.org/for-own/-/for-own-0.1.5.tgz -> npmpkg-for-own-0.1.5.tgz
https://registry.npmjs.org/forever-agent/-/forever-agent-0.6.1.tgz -> npmpkg-forever-agent-0.6.1.tgz
https://registry.npmjs.org/form-data/-/form-data-2.3.3.tgz -> npmpkg-form-data-2.3.3.tgz
https://registry.npmjs.org/fs-constants/-/fs-constants-1.0.0.tgz -> npmpkg-fs-constants-1.0.0.tgz
https://registry.npmjs.org/fs-minipass/-/fs-minipass-1.2.7.tgz -> npmpkg-fs-minipass-1.2.7.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz -> npmpkg-fs.realpath-1.0.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz -> npmpkg-fsevents-2.3.3.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.2.tgz -> npmpkg-function-bind-1.1.2.tgz
https://registry.npmjs.org/gensync/-/gensync-1.0.0-beta.2.tgz -> npmpkg-gensync-1.0.0-beta.2.tgz
https://registry.npmjs.org/get-caller-file/-/get-caller-file-2.0.5.tgz -> npmpkg-get-caller-file-2.0.5.tgz
https://registry.npmjs.org/get-package-type/-/get-package-type-0.1.0.tgz -> npmpkg-get-package-type-0.1.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-6.0.1.tgz -> npmpkg-get-stream-6.0.1.tgz
https://registry.npmjs.org/getobject/-/getobject-1.0.0.tgz -> npmpkg-getobject-1.0.0.tgz
https://registry.npmjs.org/getpass/-/getpass-0.1.7.tgz -> npmpkg-getpass-0.1.7.tgz
https://registry.npmjs.org/glob/-/glob-7.1.7.tgz -> npmpkg-glob-7.1.7.tgz
https://registry.npmjs.org/glob-base/-/glob-base-0.3.0.tgz -> npmpkg-glob-base-0.3.0.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-2.0.0.tgz -> npmpkg-glob-parent-2.0.0.tgz
https://registry.npmjs.org/glob-stream/-/glob-stream-5.3.5.tgz -> npmpkg-glob-stream-5.3.5.tgz
https://registry.npmjs.org/extend/-/extend-3.0.2.tgz -> npmpkg-extend-3.0.2.tgz
https://registry.npmjs.org/glob/-/glob-5.0.15.tgz -> npmpkg-glob-5.0.15.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-3.1.0.tgz -> npmpkg-glob-parent-3.1.0.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz -> npmpkg-is-extglob-2.1.1.tgz
https://registry.npmjs.org/is-glob/-/is-glob-3.1.0.tgz -> npmpkg-is-glob-3.1.0.tgz
https://registry.npmjs.org/isarray/-/isarray-0.0.1.tgz -> npmpkg-isarray-0.0.1.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-1.0.34.tgz -> npmpkg-readable-stream-1.0.34.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-0.10.31.tgz -> npmpkg-string_decoder-0.10.31.tgz
https://registry.npmjs.org/through2/-/through2-0.6.5.tgz -> npmpkg-through2-0.6.5.tgz
https://registry.npmjs.org/global-modules/-/global-modules-1.0.0.tgz -> npmpkg-global-modules-1.0.0.tgz
https://registry.npmjs.org/global-prefix/-/global-prefix-1.0.2.tgz -> npmpkg-global-prefix-1.0.2.tgz
https://registry.npmjs.org/globals/-/globals-11.12.0.tgz -> npmpkg-globals-11.12.0.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.11.tgz -> npmpkg-graceful-fs-4.2.11.tgz
https://registry.npmjs.org/grunt/-/grunt-1.6.1.tgz -> npmpkg-grunt-1.6.1.tgz
https://registry.npmjs.org/grunt-cli/-/grunt-cli-1.4.3.tgz -> npmpkg-grunt-cli-1.4.3.tgz
https://registry.npmjs.org/nopt/-/nopt-4.0.3.tgz -> npmpkg-nopt-4.0.3.tgz
https://registry.npmjs.org/grunt-contrib-clean/-/grunt-contrib-clean-2.0.1.tgz -> npmpkg-grunt-contrib-clean-2.0.1.tgz
https://registry.npmjs.org/async/-/async-3.2.6.tgz -> npmpkg-async-3.2.6.tgz
https://registry.npmjs.org/grunt-contrib-compress/-/grunt-contrib-compress-2.0.0.tgz -> npmpkg-grunt-contrib-compress-2.0.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/grunt-contrib-concat/-/grunt-contrib-concat-2.1.0.tgz -> npmpkg-grunt-contrib-concat-2.1.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/grunt-contrib-copy/-/grunt-contrib-copy-1.0.0.tgz -> npmpkg-grunt-contrib-copy-1.0.0.tgz
https://registry.npmjs.org/grunt-contrib-uglify/-/grunt-contrib-uglify-5.2.2.tgz -> npmpkg-grunt-contrib-uglify-5.2.2.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
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
https://registry.npmjs.org/async/-/async-3.2.6.tgz -> npmpkg-async-3.2.6.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/grunt-mkdir/-/grunt-mkdir-1.1.0.tgz -> npmpkg-grunt-mkdir-1.1.0.tgz
https://registry.npmjs.org/grunt-newer/-/grunt-newer-1.3.0.tgz -> npmpkg-grunt-newer-1.3.0.tgz
https://registry.npmjs.org/grunt-shell/-/grunt-shell-4.0.0.tgz -> npmpkg-grunt-shell-4.0.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-3.0.0.tgz -> npmpkg-chalk-3.0.0.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/grunt-string-replace/-/grunt-string-replace-1.3.3.tgz -> npmpkg-grunt-string-replace-1.3.3.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/async/-/async-3.2.6.tgz -> npmpkg-async-3.2.6.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/gulp-sourcemaps/-/gulp-sourcemaps-1.6.0.tgz -> npmpkg-gulp-sourcemaps-1.6.0.tgz
https://registry.npmjs.org/gzip-size/-/gzip-size-5.1.1.tgz -> npmpkg-gzip-size-5.1.1.tgz
https://registry.npmjs.org/har-schema/-/har-schema-2.0.0.tgz -> npmpkg-har-schema-2.0.0.tgz
https://registry.npmjs.org/har-validator/-/har-validator-5.1.5.tgz -> npmpkg-har-validator-5.1.5.tgz
https://registry.npmjs.org/has-ansi/-/has-ansi-2.0.0.tgz -> npmpkg-has-ansi-2.0.0.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/hasown/-/hasown-2.0.0.tgz -> npmpkg-hasown-2.0.0.tgz
https://registry.npmjs.org/helmsman/-/helmsman-1.0.3.tgz -> npmpkg-helmsman-1.0.3.tgz
https://registry.npmjs.org/colors/-/colors-0.6.2.tgz -> npmpkg-colors-0.6.2.tgz
https://registry.npmjs.org/glob/-/glob-3.2.11.tgz -> npmpkg-glob-3.2.11.tgz
https://registry.npmjs.org/minimatch/-/minimatch-0.3.0.tgz -> npmpkg-minimatch-0.3.0.tgz
https://registry.npmjs.org/underscore.string/-/underscore.string-2.3.3.tgz -> npmpkg-underscore.string-2.3.3.tgz
https://registry.npmjs.org/highland/-/highland-2.13.5.tgz -> npmpkg-highland-2.13.5.tgz
https://registry.npmjs.org/homedir-polyfill/-/homedir-polyfill-1.0.3.tgz -> npmpkg-homedir-polyfill-1.0.3.tgz
https://registry.npmjs.org/hooker/-/hooker-0.2.3.tgz -> npmpkg-hooker-0.2.3.tgz
https://registry.npmjs.org/html-encoding-sniffer/-/html-encoding-sniffer-2.0.1.tgz -> npmpkg-html-encoding-sniffer-2.0.1.tgz
https://registry.npmjs.org/html-escaper/-/html-escaper-2.0.2.tgz -> npmpkg-html-escaper-2.0.2.tgz
https://registry.npmjs.org/htmlparser2/-/htmlparser2-3.8.3.tgz -> npmpkg-htmlparser2-3.8.3.tgz
https://registry.npmjs.org/entities/-/entities-1.0.0.tgz -> npmpkg-entities-1.0.0.tgz
https://registry.npmjs.org/isarray/-/isarray-0.0.1.tgz -> npmpkg-isarray-0.0.1.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-1.1.14.tgz -> npmpkg-readable-stream-1.1.14.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-0.10.31.tgz -> npmpkg-string_decoder-0.10.31.tgz
https://registry.npmjs.org/http-proxy-agent/-/http-proxy-agent-4.0.1.tgz -> npmpkg-http-proxy-agent-4.0.1.tgz
https://registry.npmjs.org/http-signature/-/http-signature-1.2.0.tgz -> npmpkg-http-signature-1.2.0.tgz
https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-5.0.1.tgz -> npmpkg-https-proxy-agent-5.0.1.tgz
https://registry.npmjs.org/human-signals/-/human-signals-2.1.0.tgz -> npmpkg-human-signals-2.1.0.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.6.3.tgz -> npmpkg-iconv-lite-0.6.3.tgz
https://registry.npmjs.org/ieee754/-/ieee754-1.2.1.tgz -> npmpkg-ieee754-1.2.1.tgz
https://registry.npmjs.org/import-local/-/import-local-3.1.0.tgz -> npmpkg-import-local-3.1.0.tgz
https://registry.npmjs.org/imurmurhash/-/imurmurhash-0.1.4.tgz -> npmpkg-imurmurhash-0.1.4.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz -> npmpkg-inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz -> npmpkg-inherits-2.0.4.tgz
https://registry.npmjs.org/ini/-/ini-1.3.8.tgz -> npmpkg-ini-1.3.8.tgz
https://registry.npmjs.org/interpret/-/interpret-1.1.0.tgz -> npmpkg-interpret-1.1.0.tgz
https://registry.npmjs.org/is-absolute/-/is-absolute-1.0.0.tgz -> npmpkg-is-absolute-1.0.0.tgz
https://registry.npmjs.org/is-arrayish/-/is-arrayish-0.2.1.tgz -> npmpkg-is-arrayish-0.2.1.tgz
https://registry.npmjs.org/is-buffer/-/is-buffer-1.1.6.tgz -> npmpkg-is-buffer-1.1.6.tgz
https://registry.npmjs.org/is-core-module/-/is-core-module-2.13.1.tgz -> npmpkg-is-core-module-2.13.1.tgz
https://registry.npmjs.org/is-dotfile/-/is-dotfile-1.0.3.tgz -> npmpkg-is-dotfile-1.0.3.tgz
https://registry.npmjs.org/is-equal-shallow/-/is-equal-shallow-0.1.3.tgz -> npmpkg-is-equal-shallow-0.1.3.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-1.0.0.tgz -> npmpkg-is-extglob-1.0.0.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> npmpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/is-generator-fn/-/is-generator-fn-2.1.0.tgz -> npmpkg-is-generator-fn-2.1.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-2.0.1.tgz -> npmpkg-is-glob-2.0.1.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/is-plain-object/-/is-plain-object-2.0.4.tgz -> npmpkg-is-plain-object-2.0.4.tgz
https://registry.npmjs.org/is-posix-bracket/-/is-posix-bracket-0.1.1.tgz -> npmpkg-is-posix-bracket-0.1.1.tgz
https://registry.npmjs.org/is-potential-custom-element-name/-/is-potential-custom-element-name-1.0.1.tgz -> npmpkg-is-potential-custom-element-name-1.0.1.tgz
https://registry.npmjs.org/is-primitive/-/is-primitive-2.0.0.tgz -> npmpkg-is-primitive-2.0.0.tgz
https://registry.npmjs.org/is-relative/-/is-relative-1.0.0.tgz -> npmpkg-is-relative-1.0.0.tgz
https://registry.npmjs.org/is-stream/-/is-stream-1.1.0.tgz -> npmpkg-is-stream-1.1.0.tgz
https://registry.npmjs.org/is-typedarray/-/is-typedarray-1.0.0.tgz -> npmpkg-is-typedarray-1.0.0.tgz
https://registry.npmjs.org/is-unc-path/-/is-unc-path-1.0.0.tgz -> npmpkg-is-unc-path-1.0.0.tgz
https://registry.npmjs.org/is-utf8/-/is-utf8-0.2.1.tgz -> npmpkg-is-utf8-0.2.1.tgz
https://registry.npmjs.org/is-valid-glob/-/is-valid-glob-0.3.0.tgz -> npmpkg-is-valid-glob-0.3.0.tgz
https://registry.npmjs.org/is-windows/-/is-windows-1.0.2.tgz -> npmpkg-is-windows-1.0.2.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz -> npmpkg-isexe-2.0.0.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/isstream/-/isstream-0.1.2.tgz -> npmpkg-isstream-0.1.2.tgz
https://registry.npmjs.org/istanbul-lib-coverage/-/istanbul-lib-coverage-3.2.2.tgz -> npmpkg-istanbul-lib-coverage-3.2.2.tgz
https://registry.npmjs.org/istanbul-lib-instrument/-/istanbul-lib-instrument-6.0.3.tgz -> npmpkg-istanbul-lib-instrument-6.0.3.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/istanbul-lib-report/-/istanbul-lib-report-3.0.1.tgz -> npmpkg-istanbul-lib-report-3.0.1.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/istanbul-lib-source-maps/-/istanbul-lib-source-maps-4.0.1.tgz -> npmpkg-istanbul-lib-source-maps-4.0.1.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/istanbul-reports/-/istanbul-reports-3.1.6.tgz -> npmpkg-istanbul-reports-3.1.6.tgz
https://registry.npmjs.org/jake/-/jake-10.9.2.tgz -> npmpkg-jake-10.9.2.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/async/-/async-3.2.6.tgz -> npmpkg-async-3.2.6.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/jest/-/jest-29.7.0.tgz -> npmpkg-jest-29.7.0.tgz
https://registry.npmjs.org/jest-changed-files/-/jest-changed-files-29.7.0.tgz -> npmpkg-jest-changed-files-29.7.0.tgz
https://registry.npmjs.org/jest-circus/-/jest-circus-29.7.0.tgz -> npmpkg-jest-circus-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/jest-cli/-/jest-cli-29.7.0.tgz -> npmpkg-jest-cli-29.7.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/cliui/-/cliui-8.0.1.tgz -> npmpkg-cliui-8.0.1.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/yargs/-/yargs-17.7.2.tgz -> npmpkg-yargs-17.7.2.tgz
https://registry.npmjs.org/jest-config/-/jest-config-29.7.0.tgz -> npmpkg-jest-config-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/micromatch/-/micromatch-4.0.8.tgz -> npmpkg-micromatch-4.0.8.tgz
https://registry.npmjs.org/parse-json/-/parse-json-5.2.0.tgz -> npmpkg-parse-json-5.2.0.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-3.1.1.tgz -> npmpkg-strip-json-comments-3.1.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/jest-diff/-/jest-diff-29.7.0.tgz -> npmpkg-jest-diff-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/jest-docblock/-/jest-docblock-29.7.0.tgz -> npmpkg-jest-docblock-29.7.0.tgz
https://registry.npmjs.org/jest-each/-/jest-each-29.7.0.tgz -> npmpkg-jest-each-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/jest-environment-node/-/jest-environment-node-29.7.0.tgz -> npmpkg-jest-environment-node-29.7.0.tgz
https://registry.npmjs.org/jest-get-type/-/jest-get-type-29.6.3.tgz -> npmpkg-jest-get-type-29.6.3.tgz
https://registry.npmjs.org/jest-haste-map/-/jest-haste-map-29.7.0.tgz -> npmpkg-jest-haste-map-29.7.0.tgz
https://registry.npmjs.org/micromatch/-/micromatch-4.0.8.tgz -> npmpkg-micromatch-4.0.8.tgz
https://registry.npmjs.org/jest-leak-detector/-/jest-leak-detector-29.7.0.tgz -> npmpkg-jest-leak-detector-29.7.0.tgz
https://registry.npmjs.org/jest-matcher-utils/-/jest-matcher-utils-29.7.0.tgz -> npmpkg-jest-matcher-utils-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/jest-message-util/-/jest-message-util-29.7.0.tgz -> npmpkg-jest-message-util-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/micromatch/-/micromatch-4.0.8.tgz -> npmpkg-micromatch-4.0.8.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/jest-mock/-/jest-mock-29.7.0.tgz -> npmpkg-jest-mock-29.7.0.tgz
https://registry.npmjs.org/jest-pnp-resolver/-/jest-pnp-resolver-1.2.3.tgz -> npmpkg-jest-pnp-resolver-1.2.3.tgz
https://registry.npmjs.org/jest-regex-util/-/jest-regex-util-29.6.3.tgz -> npmpkg-jest-regex-util-29.6.3.tgz
https://registry.npmjs.org/jest-resolve/-/jest-resolve-29.7.0.tgz -> npmpkg-jest-resolve-29.7.0.tgz
https://registry.npmjs.org/jest-resolve-dependencies/-/jest-resolve-dependencies-29.7.0.tgz -> npmpkg-jest-resolve-dependencies-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/jest-runner/-/jest-runner-29.7.0.tgz -> npmpkg-jest-runner-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/jest-runtime/-/jest-runtime-29.7.0.tgz -> npmpkg-jest-runtime-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-4.0.0.tgz -> npmpkg-strip-bom-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/jest-snapshot/-/jest-snapshot-29.7.0.tgz -> npmpkg-jest-snapshot-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/jest-util/-/jest-util-29.7.0.tgz -> npmpkg-jest-util-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/jest-validate/-/jest-validate-29.7.0.tgz -> npmpkg-jest-validate-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-6.3.0.tgz -> npmpkg-camelcase-6.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/jest-watcher/-/jest-watcher-29.7.0.tgz -> npmpkg-jest-watcher-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/jest-worker/-/jest-worker-29.7.0.tgz -> npmpkg-jest-worker-29.7.0.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/merge-stream/-/merge-stream-2.0.0.tgz -> npmpkg-merge-stream-2.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-8.1.1.tgz -> npmpkg-supports-color-8.1.1.tgz
https://registry.npmjs.org/js-tokens/-/js-tokens-4.0.0.tgz -> npmpkg-js-tokens-4.0.0.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-3.14.1.tgz -> npmpkg-js-yaml-3.14.1.tgz
https://registry.npmjs.org/jsbn/-/jsbn-0.1.1.tgz -> npmpkg-jsbn-0.1.1.tgz
https://registry.npmjs.org/jsdom/-/jsdom-16.7.0.tgz -> npmpkg-jsdom-16.7.0.tgz
https://registry.npmjs.org/cssom/-/cssom-0.4.4.tgz -> npmpkg-cssom-0.4.4.tgz
https://registry.npmjs.org/escodegen/-/escodegen-2.1.0.tgz -> npmpkg-escodegen-2.1.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-5.3.0.tgz -> npmpkg-estraverse-5.3.0.tgz
https://registry.npmjs.org/form-data/-/form-data-3.0.1.tgz -> npmpkg-form-data-3.0.1.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/jsesc/-/jsesc-2.5.2.tgz -> npmpkg-jsesc-2.5.2.tgz
https://registry.npmjs.org/json-parse-even-better-errors/-/json-parse-even-better-errors-2.3.1.tgz -> npmpkg-json-parse-even-better-errors-2.3.1.tgz
https://registry.npmjs.org/json-schema/-/json-schema-0.4.0.tgz -> npmpkg-json-schema-0.4.0.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz -> npmpkg-json-schema-traverse-0.4.1.tgz
https://registry.npmjs.org/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz -> npmpkg-json-stable-stringify-without-jsonify-1.0.1.tgz
https://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz -> npmpkg-json-stringify-safe-5.0.1.tgz
https://registry.npmjs.org/json5/-/json5-2.2.3.tgz -> npmpkg-json5-2.2.3.tgz
https://registry.npmjs.org/jsprim/-/jsprim-1.4.1.tgz -> npmpkg-jsprim-1.4.1.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/kleur/-/kleur-3.0.3.tgz -> npmpkg-kleur-3.0.3.tgz
https://registry.npmjs.org/lazystream/-/lazystream-1.0.0.tgz -> npmpkg-lazystream-1.0.0.tgz
https://registry.npmjs.org/leven/-/leven-3.1.0.tgz -> npmpkg-leven-3.1.0.tgz
https://registry.npmjs.org/levn/-/levn-0.3.0.tgz -> npmpkg-levn-0.3.0.tgz
https://registry.npmjs.org/liftup/-/liftup-3.0.1.tgz -> npmpkg-liftup-3.0.1.tgz
https://registry.npmjs.org/extend/-/extend-3.0.2.tgz -> npmpkg-extend-3.0.2.tgz
https://registry.npmjs.org/findup-sync/-/findup-sync-4.0.0.tgz -> npmpkg-findup-sync-4.0.0.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz -> npmpkg-is-extglob-2.1.1.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/micromatch/-/micromatch-4.0.8.tgz -> npmpkg-micromatch-4.0.8.tgz
https://registry.npmjs.org/rechoir/-/rechoir-0.7.1.tgz -> npmpkg-rechoir-0.7.1.tgz
https://registry.npmjs.org/lines-and-columns/-/lines-and-columns-1.2.4.tgz -> npmpkg-lines-and-columns-1.2.4.tgz
https://registry.npmjs.org/locate-path/-/locate-path-5.0.0.tgz -> npmpkg-locate-path-5.0.0.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/lodash.defaults/-/lodash.defaults-4.2.0.tgz -> npmpkg-lodash.defaults-4.2.0.tgz
https://registry.npmjs.org/lodash.difference/-/lodash.difference-4.5.0.tgz -> npmpkg-lodash.difference-4.5.0.tgz
https://registry.npmjs.org/lodash.flatten/-/lodash.flatten-4.4.0.tgz -> npmpkg-lodash.flatten-4.4.0.tgz
https://registry.npmjs.org/lodash.isequal/-/lodash.isequal-4.5.0.tgz -> npmpkg-lodash.isequal-4.5.0.tgz
https://registry.npmjs.org/lodash.isplainobject/-/lodash.isplainobject-4.0.6.tgz -> npmpkg-lodash.isplainobject-4.0.6.tgz
https://registry.npmjs.org/lodash.union/-/lodash.union-4.6.0.tgz -> npmpkg-lodash.union-4.6.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-2.7.3.tgz -> npmpkg-lru-cache-2.7.3.tgz
https://registry.npmjs.org/make-dir/-/make-dir-4.0.0.tgz -> npmpkg-make-dir-4.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/make-iterator/-/make-iterator-1.0.1.tgz -> npmpkg-make-iterator-1.0.1.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/makeerror/-/makeerror-1.0.12.tgz -> npmpkg-makeerror-1.0.12.tgz
https://registry.npmjs.org/map-cache/-/map-cache-0.2.2.tgz -> npmpkg-map-cache-0.2.2.tgz
https://registry.npmjs.org/math-random/-/math-random-1.0.4.tgz -> npmpkg-math-random-1.0.4.tgz
https://registry.npmjs.org/maxmin/-/maxmin-3.0.0.tgz -> npmpkg-maxmin-3.0.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/merge-stream/-/merge-stream-1.0.1.tgz -> npmpkg-merge-stream-1.0.1.tgz
https://registry.npmjs.org/micromatch/-/micromatch-2.3.11.tgz -> npmpkg-micromatch-2.3.11.tgz
https://registry.npmjs.org/braces/-/braces-1.8.5.tgz -> npmpkg-braces-1.8.5.tgz
https://registry.npmjs.org/mime-db/-/mime-db-1.52.0.tgz -> npmpkg-mime-db-1.52.0.tgz
https://registry.npmjs.org/mime-types/-/mime-types-2.1.35.tgz -> npmpkg-mime-types-2.1.35.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-2.1.0.tgz -> npmpkg-mimic-fn-2.1.0.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.0.8.tgz -> npmpkg-minimatch-3.0.8.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.6.tgz -> npmpkg-minimist-1.2.6.tgz
https://registry.npmjs.org/minipass/-/minipass-2.9.0.tgz -> npmpkg-minipass-2.9.0.tgz
https://registry.npmjs.org/minizlib/-/minizlib-1.3.3.tgz -> npmpkg-minizlib-1.3.3.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.6.tgz -> npmpkg-mkdirp-0.5.6.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/natural-compare/-/natural-compare-1.4.0.tgz -> npmpkg-natural-compare-1.4.0.tgz
https://registry.npmjs.org/node-int64/-/node-int64-0.4.0.tgz -> npmpkg-node-int64-0.4.0.tgz
https://registry.npmjs.org/node-releases/-/node-releases-2.0.18.tgz -> npmpkg-node-releases-2.0.18.tgz
https://registry.npmjs.org/nopt/-/nopt-3.0.6.tgz -> npmpkg-nopt-3.0.6.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-2.1.1.tgz -> npmpkg-normalize-path-2.1.1.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-2.0.2.tgz -> npmpkg-npm-run-path-2.0.2.tgz
https://registry.npmjs.org/nth-check/-/nth-check-1.0.2.tgz -> npmpkg-nth-check-1.0.2.tgz
https://registry.npmjs.org/nwmatcher/-/nwmatcher-1.4.4.tgz -> npmpkg-nwmatcher-1.4.4.tgz
https://registry.npmjs.org/nwsapi/-/nwsapi-2.2.13.tgz -> npmpkg-nwsapi-2.2.13.tgz
https://registry.npmjs.org/oauth-sign/-/oauth-sign-0.9.0.tgz -> npmpkg-oauth-sign-0.9.0.tgz
https://registry.npmjs.org/object-assign/-/object-assign-4.1.1.tgz -> npmpkg-object-assign-4.1.1.tgz
https://registry.npmjs.org/object.defaults/-/object.defaults-1.1.0.tgz -> npmpkg-object.defaults-1.1.0.tgz
https://registry.npmjs.org/for-own/-/for-own-1.0.0.tgz -> npmpkg-for-own-1.0.0.tgz
https://registry.npmjs.org/object.map/-/object.map-1.0.1.tgz -> npmpkg-object.map-1.0.1.tgz
https://registry.npmjs.org/for-own/-/for-own-1.0.0.tgz -> npmpkg-for-own-1.0.0.tgz
https://registry.npmjs.org/object.omit/-/object.omit-2.0.1.tgz -> npmpkg-object.omit-2.0.1.tgz
https://registry.npmjs.org/object.pick/-/object.pick-1.3.0.tgz -> npmpkg-object.pick-1.3.0.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz -> npmpkg-once-1.4.0.tgz
https://registry.npmjs.org/onetime/-/onetime-5.1.2.tgz -> npmpkg-onetime-5.1.2.tgz
https://registry.npmjs.org/optionator/-/optionator-0.8.2.tgz -> npmpkg-optionator-0.8.2.tgz
https://registry.npmjs.org/wordwrap/-/wordwrap-1.0.0.tgz -> npmpkg-wordwrap-1.0.0.tgz
https://registry.npmjs.org/ordered-read-streams/-/ordered-read-streams-0.3.0.tgz -> npmpkg-ordered-read-streams-0.3.0.tgz
https://registry.npmjs.org/os-homedir/-/os-homedir-1.0.2.tgz -> npmpkg-os-homedir-1.0.2.tgz
https://registry.npmjs.org/os-tmpdir/-/os-tmpdir-1.0.2.tgz -> npmpkg-os-tmpdir-1.0.2.tgz
https://registry.npmjs.org/osenv/-/osenv-0.1.5.tgz -> npmpkg-osenv-0.1.5.tgz
https://registry.npmjs.org/p-limit/-/p-limit-3.1.0.tgz -> npmpkg-p-limit-3.1.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-4.1.0.tgz -> npmpkg-p-locate-4.1.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-try/-/p-try-2.2.0.tgz -> npmpkg-p-try-2.2.0.tgz
https://registry.npmjs.org/parse-filepath/-/parse-filepath-1.0.2.tgz -> npmpkg-parse-filepath-1.0.2.tgz
https://registry.npmjs.org/parse-glob/-/parse-glob-3.0.4.tgz -> npmpkg-parse-glob-3.0.4.tgz
https://registry.npmjs.org/parse-passwd/-/parse-passwd-1.0.0.tgz -> npmpkg-parse-passwd-1.0.0.tgz
https://registry.npmjs.org/parse5/-/parse5-6.0.1.tgz -> npmpkg-parse5-6.0.1.tgz
https://registry.npmjs.org/path-dirname/-/path-dirname-1.0.2.tgz -> npmpkg-path-dirname-1.0.2.tgz
https://registry.npmjs.org/path-exists/-/path-exists-4.0.0.tgz -> npmpkg-path-exists-4.0.0.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> npmpkg-path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/path-key/-/path-key-2.0.1.tgz -> npmpkg-path-key-2.0.1.tgz
https://registry.npmjs.org/path-parse/-/path-parse-1.0.7.tgz -> npmpkg-path-parse-1.0.7.tgz
https://registry.npmjs.org/path-root/-/path-root-0.1.1.tgz -> npmpkg-path-root-0.1.1.tgz
https://registry.npmjs.org/path-root-regex/-/path-root-regex-0.1.2.tgz -> npmpkg-path-root-regex-0.1.2.tgz
https://registry.npmjs.org/performance-now/-/performance-now-2.1.0.tgz -> npmpkg-performance-now-2.1.0.tgz
https://registry.npmjs.org/picocolors/-/picocolors-1.1.0.tgz -> npmpkg-picocolors-1.1.0.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.3.1.tgz -> npmpkg-picomatch-2.3.1.tgz
https://registry.npmjs.org/pify/-/pify-4.0.1.tgz -> npmpkg-pify-4.0.1.tgz
https://registry.npmjs.org/pirates/-/pirates-4.0.6.tgz -> npmpkg-pirates-4.0.6.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-4.2.0.tgz -> npmpkg-pkg-dir-4.2.0.tgz
https://registry.npmjs.org/prelude-ls/-/prelude-ls-1.1.2.tgz -> npmpkg-prelude-ls-1.1.2.tgz
https://registry.npmjs.org/preserve/-/preserve-0.2.0.tgz -> npmpkg-preserve-0.2.0.tgz
https://registry.npmjs.org/prettier/-/prettier-3.2.2.tgz -> npmpkg-prettier-3.2.2.tgz
https://registry.npmjs.org/pretty-bytes/-/pretty-bytes-5.6.0.tgz -> npmpkg-pretty-bytes-5.6.0.tgz
https://registry.npmjs.org/pretty-format/-/pretty-format-29.7.0.tgz -> npmpkg-pretty-format-29.7.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-5.2.0.tgz -> npmpkg-ansi-styles-5.2.0.tgz
https://registry.npmjs.org/process-nextick-args/-/process-nextick-args-2.0.1.tgz -> npmpkg-process-nextick-args-2.0.1.tgz
https://registry.npmjs.org/prompts/-/prompts-2.4.2.tgz -> npmpkg-prompts-2.4.2.tgz
https://registry.npmjs.org/psl/-/psl-1.9.0.tgz -> npmpkg-psl-1.9.0.tgz
https://registry.npmjs.org/punycode/-/punycode-2.3.1.tgz -> npmpkg-punycode-2.3.1.tgz
https://registry.npmjs.org/pure-rand/-/pure-rand-6.0.4.tgz -> npmpkg-pure-rand-6.0.4.tgz
https://registry.npmjs.org/qs/-/qs-6.5.3.tgz -> npmpkg-qs-6.5.3.tgz
https://registry.npmjs.org/querystringify/-/querystringify-2.2.0.tgz -> npmpkg-querystringify-2.2.0.tgz
https://registry.npmjs.org/randomatic/-/randomatic-3.1.1.tgz -> npmpkg-randomatic-3.1.1.tgz
https://registry.npmjs.org/is-number/-/is-number-4.0.0.tgz -> npmpkg-is-number-4.0.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/react-is/-/react-is-18.2.0.tgz -> npmpkg-react-is-18.2.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/readdir-glob/-/readdir-glob-1.1.3.tgz -> npmpkg-readdir-glob-1.1.3.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-5.1.6.tgz -> npmpkg-minimatch-5.1.6.tgz
https://registry.npmjs.org/rechoir/-/rechoir-0.6.2.tgz -> npmpkg-rechoir-0.6.2.tgz
https://registry.npmjs.org/regex-cache/-/regex-cache-0.4.4.tgz -> npmpkg-regex-cache-0.4.4.tgz
https://registry.npmjs.org/remove-trailing-separator/-/remove-trailing-separator-1.1.0.tgz -> npmpkg-remove-trailing-separator-1.1.0.tgz
https://registry.npmjs.org/repeat-element/-/repeat-element-1.1.4.tgz -> npmpkg-repeat-element-1.1.4.tgz
https://registry.npmjs.org/repeat-string/-/repeat-string-1.6.1.tgz -> npmpkg-repeat-string-1.6.1.tgz
https://registry.npmjs.org/replace-ext/-/replace-ext-0.0.1.tgz -> npmpkg-replace-ext-0.0.1.tgz
https://registry.npmjs.org/request/-/request-2.88.2.tgz -> npmpkg-request-2.88.2.tgz
https://registry.npmjs.org/extend/-/extend-3.0.2.tgz -> npmpkg-extend-3.0.2.tgz
https://registry.npmjs.org/require-directory/-/require-directory-2.1.1.tgz -> npmpkg-require-directory-2.1.1.tgz
https://registry.npmjs.org/requires-port/-/requires-port-1.0.0.tgz -> npmpkg-requires-port-1.0.0.tgz
https://registry.npmjs.org/resolve/-/resolve-1.22.8.tgz -> npmpkg-resolve-1.22.8.tgz
https://registry.npmjs.org/resolve-cwd/-/resolve-cwd-3.0.0.tgz -> npmpkg-resolve-cwd-3.0.0.tgz
https://registry.npmjs.org/resolve-dir/-/resolve-dir-1.0.1.tgz -> npmpkg-resolve-dir-1.0.1.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-5.0.0.tgz -> npmpkg-resolve-from-5.0.0.tgz
https://registry.npmjs.org/resolve.exports/-/resolve.exports-2.0.2.tgz -> npmpkg-resolve.exports-2.0.2.tgz
https://registry.npmjs.org/rimraf/-/rimraf-2.7.1.tgz -> npmpkg-rimraf-2.7.1.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/safer-buffer/-/safer-buffer-2.1.2.tgz -> npmpkg-safer-buffer-2.1.2.tgz
https://registry.npmjs.org/sax/-/sax-1.2.4.tgz -> npmpkg-sax-1.2.4.tgz
https://registry.npmjs.org/saxes/-/saxes-5.0.1.tgz -> npmpkg-saxes-5.0.1.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/shelljs/-/shelljs-0.8.5.tgz -> npmpkg-shelljs-0.8.5.tgz
https://registry.npmjs.org/sigmund/-/sigmund-1.0.1.tgz -> npmpkg-sigmund-1.0.1.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-3.0.7.tgz -> npmpkg-signal-exit-3.0.7.tgz
https://registry.npmjs.org/sisteransi/-/sisteransi-1.0.5.tgz -> npmpkg-sisteransi-1.0.5.tgz
https://registry.npmjs.org/slash/-/slash-3.0.0.tgz -> npmpkg-slash-3.0.0.tgz
https://registry.npmjs.org/source-map/-/source-map-0.5.7.tgz -> npmpkg-source-map-0.5.7.tgz
https://registry.npmjs.org/source-map-support/-/source-map-support-0.5.13.tgz -> npmpkg-source-map-support-0.5.13.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.0.3.tgz -> npmpkg-sprintf-js-1.0.3.tgz
https://registry.npmjs.org/sshpk/-/sshpk-1.13.1.tgz -> npmpkg-sshpk-1.13.1.tgz
https://registry.npmjs.org/stack-trace/-/stack-trace-0.0.10.tgz -> npmpkg-stack-trace-0.0.10.tgz
https://registry.npmjs.org/stack-utils/-/stack-utils-2.0.6.tgz -> npmpkg-stack-utils-2.0.6.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-2.0.0.tgz -> npmpkg-escape-string-regexp-2.0.0.tgz
https://registry.npmjs.org/stream-buffers/-/stream-buffers-3.0.3.tgz -> npmpkg-stream-buffers-3.0.3.tgz
https://registry.npmjs.org/stream-concat/-/stream-concat-0.1.1.tgz -> npmpkg-stream-concat-0.1.1.tgz
https://registry.npmjs.org/stream-shift/-/stream-shift-1.0.1.tgz -> npmpkg-stream-shift-1.0.1.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-1.1.1.tgz -> npmpkg-string_decoder-1.1.1.tgz
https://registry.npmjs.org/string-length/-/string-length-4.0.2.tgz -> npmpkg-string-length-4.0.2.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-3.0.1.tgz -> npmpkg-strip-ansi-3.0.1.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-2.0.0.tgz -> npmpkg-strip-bom-2.0.0.tgz
https://registry.npmjs.org/strip-bom-stream/-/strip-bom-stream-1.0.0.tgz -> npmpkg-strip-bom-stream-1.0.0.tgz
https://registry.npmjs.org/strip-final-newline/-/strip-final-newline-2.0.0.tgz -> npmpkg-strip-final-newline-2.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-2.0.0.tgz -> npmpkg-supports-color-2.0.0.tgz
https://registry.npmjs.org/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz -> npmpkg-supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.npmjs.org/symbol-tree/-/symbol-tree-3.2.4.tgz -> npmpkg-symbol-tree-3.2.4.tgz
https://registry.npmjs.org/tar/-/tar-4.4.18.tgz -> npmpkg-tar-4.4.18.tgz
https://registry.npmjs.org/tar-stream/-/tar-stream-2.2.0.tgz -> npmpkg-tar-stream-2.2.0.tgz
https://registry.npmjs.org/bl/-/bl-4.1.0.tgz -> npmpkg-bl-4.1.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz -> npmpkg-safe-buffer-5.2.1.tgz
https://registry.npmjs.org/test-exclude/-/test-exclude-6.0.0.tgz -> npmpkg-test-exclude-6.0.0.tgz
https://registry.npmjs.org/through2/-/through2-2.0.5.tgz -> npmpkg-through2-2.0.5.tgz
https://registry.npmjs.org/through2-filter/-/through2-filter-2.0.0.tgz -> npmpkg-through2-filter-2.0.0.tgz
https://registry.npmjs.org/tmpl/-/tmpl-1.0.5.tgz -> npmpkg-tmpl-1.0.5.tgz
https://registry.npmjs.org/to-absolute-glob/-/to-absolute-glob-0.1.1.tgz -> npmpkg-to-absolute-glob-0.1.1.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/to-fast-properties/-/to-fast-properties-2.0.0.tgz -> npmpkg-to-fast-properties-2.0.0.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/tough-cookie/-/tough-cookie-4.1.3.tgz -> npmpkg-tough-cookie-4.1.3.tgz
https://registry.npmjs.org/tr46/-/tr46-2.1.0.tgz -> npmpkg-tr46-2.1.0.tgz
https://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.6.0.tgz -> npmpkg-tunnel-agent-0.6.0.tgz
https://registry.npmjs.org/tweetnacl/-/tweetnacl-0.14.5.tgz -> npmpkg-tweetnacl-0.14.5.tgz
https://registry.npmjs.org/type-check/-/type-check-0.3.2.tgz -> npmpkg-type-check-0.3.2.tgz
https://registry.npmjs.org/type-detect/-/type-detect-4.0.8.tgz -> npmpkg-type-detect-4.0.8.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.21.3.tgz -> npmpkg-type-fest-0.21.3.tgz
https://registry.npmjs.org/uglify-js/-/uglify-js-3.19.3.tgz -> npmpkg-uglify-js-3.19.3.tgz
https://registry.npmjs.org/unc-path-regex/-/unc-path-regex-0.1.2.tgz -> npmpkg-unc-path-regex-0.1.2.tgz
https://registry.npmjs.org/underscore.string/-/underscore.string-3.3.6.tgz -> npmpkg-underscore.string-3.3.6.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.1.3.tgz -> npmpkg-sprintf-js-1.1.3.tgz
https://registry.npmjs.org/undici-types/-/undici-types-5.26.5.tgz -> npmpkg-undici-types-5.26.5.tgz
https://registry.npmjs.org/unique-stream/-/unique-stream-2.3.1.tgz -> npmpkg-unique-stream-2.3.1.tgz
https://registry.npmjs.org/through2-filter/-/through2-filter-3.0.0.tgz -> npmpkg-through2-filter-3.0.0.tgz
https://registry.npmjs.org/universalify/-/universalify-0.2.0.tgz -> npmpkg-universalify-0.2.0.tgz
https://registry.npmjs.org/update-browserslist-db/-/update-browserslist-db-1.1.1.tgz -> npmpkg-update-browserslist-db-1.1.1.tgz
https://registry.npmjs.org/uri-js/-/uri-js-4.4.1.tgz -> npmpkg-uri-js-4.4.1.tgz
https://registry.npmjs.org/uri-path/-/uri-path-1.0.0.tgz -> npmpkg-uri-path-1.0.0.tgz
https://registry.npmjs.org/url-parse/-/url-parse-1.5.10.tgz -> npmpkg-url-parse-1.5.10.tgz
https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz -> npmpkg-util-deprecate-1.0.2.tgz
https://registry.npmjs.org/uuid/-/uuid-3.4.0.tgz -> npmpkg-uuid-3.4.0.tgz
https://registry.npmjs.org/v8-to-istanbul/-/v8-to-istanbul-9.2.0.tgz -> npmpkg-v8-to-istanbul-9.2.0.tgz
https://registry.npmjs.org/convert-source-map/-/convert-source-map-2.0.0.tgz -> npmpkg-convert-source-map-2.0.0.tgz
https://registry.npmjs.org/v8flags/-/v8flags-3.2.0.tgz -> npmpkg-v8flags-3.2.0.tgz
https://registry.npmjs.org/vali-date/-/vali-date-1.0.0.tgz -> npmpkg-vali-date-1.0.0.tgz
https://registry.npmjs.org/verror/-/verror-1.10.0.tgz -> npmpkg-verror-1.10.0.tgz
https://registry.npmjs.org/vinyl/-/vinyl-1.2.0.tgz -> npmpkg-vinyl-1.2.0.tgz
https://registry.npmjs.org/vinyl-fs/-/vinyl-fs-2.4.4.tgz -> npmpkg-vinyl-fs-2.4.4.tgz
https://registry.npmjs.org/w3c-hr-time/-/w3c-hr-time-1.0.2.tgz -> npmpkg-w3c-hr-time-1.0.2.tgz
https://registry.npmjs.org/w3c-xmlserializer/-/w3c-xmlserializer-2.0.0.tgz -> npmpkg-w3c-xmlserializer-2.0.0.tgz
https://registry.npmjs.org/walker/-/walker-1.0.8.tgz -> npmpkg-walker-1.0.8.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-6.1.0.tgz -> npmpkg-webidl-conversions-6.1.0.tgz
https://github.com/4ian/webidl-tools/archive/348f9c03afc9d8f278efccdd74543e265a41fd11.tar.gz -> npmpkg-webidl-tools.git-348f9c03afc9d8f278efccdd74543e265a41fd11.tgz
https://github.com/markandrus/webidl2.js/archive/e470735423d73fbbc20d472d9e0174592b80a463.tar.gz -> npmpkg-webidl2.js.git-e470735423d73fbbc20d472d9e0174592b80a463.tgz
https://registry.npmjs.org/whatwg-encoding/-/whatwg-encoding-1.0.5.tgz -> npmpkg-whatwg-encoding-1.0.5.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.4.24.tgz -> npmpkg-iconv-lite-0.4.24.tgz
https://registry.npmjs.org/whatwg-mimetype/-/whatwg-mimetype-2.3.0.tgz -> npmpkg-whatwg-mimetype-2.3.0.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-8.7.0.tgz -> npmpkg-whatwg-url-8.7.0.tgz
https://registry.npmjs.org/whatwg-url-compat/-/whatwg-url-compat-0.6.5.tgz -> npmpkg-whatwg-url-compat-0.6.5.tgz
https://registry.npmjs.org/tr46/-/tr46-0.0.3.tgz -> npmpkg-tr46-0.0.3.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/winston/-/winston-2.4.5.tgz -> npmpkg-winston-2.4.5.tgz
https://registry.npmjs.org/async/-/async-1.0.0.tgz -> npmpkg-async-1.0.0.tgz
https://registry.npmjs.org/colors/-/colors-1.0.3.tgz -> npmpkg-colors-1.0.3.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> npmpkg-wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
https://registry.npmjs.org/write-file-atomic/-/write-file-atomic-4.0.2.tgz -> npmpkg-write-file-atomic-4.0.2.tgz
https://registry.npmjs.org/ws/-/ws-7.5.10.tgz -> npmpkg-ws-7.5.10.tgz
https://registry.npmjs.org/xml-name-validator/-/xml-name-validator-3.0.0.tgz -> npmpkg-xml-name-validator-3.0.0.tgz
https://registry.npmjs.org/xmlchars/-/xmlchars-2.2.0.tgz -> npmpkg-xmlchars-2.2.0.tgz
https://registry.npmjs.org/xtend/-/xtend-4.0.1.tgz -> npmpkg-xtend-4.0.1.tgz
https://registry.npmjs.org/y18n/-/y18n-5.0.8.tgz -> npmpkg-y18n-5.0.8.tgz
https://registry.npmjs.org/yallist/-/yallist-3.1.1.tgz -> npmpkg-yallist-3.1.1.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-21.1.1.tgz -> npmpkg-yargs-parser-21.1.1.tgz
https://registry.npmjs.org/yocto-queue/-/yocto-queue-0.1.0.tgz -> npmpkg-yocto-queue-0.1.0.tgz
https://registry.npmjs.org/zip-stream/-/zip-stream-4.1.1.tgz -> npmpkg-zip-stream-4.1.1.tgz
https://registry.npmjs.org/archiver-utils/-/archiver-utils-3.0.4.tgz -> npmpkg-archiver-utils-3.0.4.tgz
https://registry.npmjs.org/glob/-/glob-7.2.3.tgz -> npmpkg-glob-7.2.3.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz -> npmpkg-normalize-path-3.0.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/@electron/get/-/get-2.0.3.tgz -> npmpkg-@electron-get-2.0.3.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-4.0.0.tgz -> npmpkg-jsonfile-4.0.0.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/@electron/remote/-/remote-2.0.8.tgz -> npmpkg-@electron-remote-2.0.8.tgz
https://registry.npmjs.org/@sindresorhus/is/-/is-4.6.0.tgz -> npmpkg-@sindresorhus-is-4.6.0.tgz
https://registry.npmjs.org/@szmarczak/http-timer/-/http-timer-4.0.6.tgz -> npmpkg-@szmarczak-http-timer-4.0.6.tgz
https://registry.npmjs.org/@types/cacheable-request/-/cacheable-request-6.0.3.tgz -> npmpkg-@types-cacheable-request-6.0.3.tgz
https://registry.npmjs.org/@types/http-cache-semantics/-/http-cache-semantics-4.0.4.tgz -> npmpkg-@types-http-cache-semantics-4.0.4.tgz
https://registry.npmjs.org/@types/keyv/-/keyv-3.1.4.tgz -> npmpkg-@types-keyv-3.1.4.tgz
https://registry.npmjs.org/@types/node/-/node-16.18.112.tgz -> npmpkg-@types-node-16.18.112.tgz
https://registry.npmjs.org/@types/responselike/-/responselike-1.0.3.tgz -> npmpkg-@types-responselike-1.0.3.tgz
https://registry.npmjs.org/@types/semver/-/semver-6.2.0.tgz -> npmpkg-@types-semver-6.2.0.tgz
https://registry.npmjs.org/@types/yauzl/-/yauzl-2.10.0.tgz -> npmpkg-@types-yauzl-2.10.0.tgz
https://registry.npmjs.org/accepts/-/accepts-1.3.4.tgz -> npmpkg-accepts-1.3.4.tgz
https://registry.npmjs.org/anymatch/-/anymatch-3.1.3.tgz -> npmpkg-anymatch-3.1.3.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz -> npmpkg-normalize-path-3.0.0.tgz
https://registry.npmjs.org/apache-crypt/-/apache-crypt-1.2.1.tgz -> npmpkg-apache-crypt-1.2.1.tgz
https://registry.npmjs.org/apache-md5/-/apache-md5-1.1.2.tgz -> npmpkg-apache-md5-1.1.2.tgz
https://registry.npmjs.org/archiver/-/archiver-2.1.1.tgz -> npmpkg-archiver-2.1.1.tgz
https://registry.npmjs.org/archiver-utils/-/archiver-utils-1.3.0.tgz -> npmpkg-archiver-utils-1.3.0.tgz
https://registry.npmjs.org/argparse/-/argparse-1.0.10.tgz -> npmpkg-argparse-1.0.10.tgz
https://registry.npmjs.org/arr-diff/-/arr-diff-4.0.0.tgz -> npmpkg-arr-diff-4.0.0.tgz
https://registry.npmjs.org/arr-flatten/-/arr-flatten-1.1.0.tgz -> npmpkg-arr-flatten-1.1.0.tgz
https://registry.npmjs.org/arr-union/-/arr-union-3.1.0.tgz -> npmpkg-arr-union-3.1.0.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.3.2.tgz -> npmpkg-array-unique-0.3.2.tgz
https://registry.npmjs.org/assign-symbols/-/assign-symbols-1.0.0.tgz -> npmpkg-assign-symbols-1.0.0.tgz
https://registry.npmjs.org/async/-/async-2.6.4.tgz -> npmpkg-async-2.6.4.tgz
https://registry.npmjs.org/async-each/-/async-each-1.0.6.tgz -> npmpkg-async-each-1.0.6.tgz
https://registry.npmjs.org/asynckit/-/asynckit-0.4.0.tgz -> npmpkg-asynckit-0.4.0.tgz
https://registry.npmjs.org/atob/-/atob-2.1.2.tgz -> npmpkg-atob-2.1.2.tgz
https://registry.npmjs.org/axios/-/axios-0.28.0.tgz -> npmpkg-axios-0.28.0.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.0.tgz -> npmpkg-balanced-match-1.0.0.tgz
https://registry.npmjs.org/base/-/base-0.11.2.tgz -> npmpkg-base-0.11.2.tgz
https://registry.npmjs.org/define-property/-/define-property-1.0.0.tgz -> npmpkg-define-property-1.0.0.tgz
https://registry.npmjs.org/basic-auth/-/basic-auth-2.0.1.tgz -> npmpkg-basic-auth-2.0.1.tgz
https://registry.npmjs.org/batch/-/batch-0.6.1.tgz -> npmpkg-batch-0.6.1.tgz
https://registry.npmjs.org/bcryptjs/-/bcryptjs-2.4.3.tgz -> npmpkg-bcryptjs-2.4.3.tgz
https://registry.npmjs.org/binary-extensions/-/binary-extensions-2.3.0.tgz -> npmpkg-binary-extensions-2.3.0.tgz
https://registry.npmjs.org/bindings/-/bindings-1.5.0.tgz -> npmpkg-bindings-1.5.0.tgz
https://registry.npmjs.org/bl/-/bl-1.2.3.tgz -> npmpkg-bl-1.2.3.tgz
https://registry.npmjs.org/boolean/-/boolean-3.2.0.tgz -> npmpkg-boolean-3.2.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.8.tgz -> npmpkg-brace-expansion-1.1.8.tgz
https://registry.npmjs.org/braces/-/braces-3.0.3.tgz -> npmpkg-braces-3.0.3.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.1.1.tgz -> npmpkg-fill-range-7.1.1.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.2.13.tgz -> npmpkg-buffer-crc32-0.2.13.tgz
https://registry.npmjs.org/builder-util-runtime/-/builder-util-runtime-8.4.0.tgz -> npmpkg-builder-util-runtime-8.4.0.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/sax/-/sax-1.2.4.tgz -> npmpkg-sax-1.2.4.tgz
https://registry.npmjs.org/cache-base/-/cache-base-1.0.1.tgz -> npmpkg-cache-base-1.0.1.tgz
https://registry.npmjs.org/cacheable-lookup/-/cacheable-lookup-5.0.4.tgz -> npmpkg-cacheable-lookup-5.0.4.tgz
https://registry.npmjs.org/cacheable-request/-/cacheable-request-7.0.4.tgz -> npmpkg-cacheable-request-7.0.4.tgz
https://registry.npmjs.org/chokidar/-/chokidar-3.5.3.tgz -> npmpkg-chokidar-3.5.3.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz -> npmpkg-normalize-path-3.0.0.tgz
https://registry.npmjs.org/class-utils/-/class-utils-0.3.6.tgz -> npmpkg-class-utils-0.3.6.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.7.tgz -> npmpkg-is-descriptor-0.1.7.tgz
https://registry.npmjs.org/clone-response/-/clone-response-1.0.3.tgz -> npmpkg-clone-response-1.0.3.tgz
https://registry.npmjs.org/collection-visit/-/collection-visit-1.0.0.tgz -> npmpkg-collection-visit-1.0.0.tgz
https://registry.npmjs.org/colors/-/colors-1.4.0.tgz -> npmpkg-colors-1.4.0.tgz
https://registry.npmjs.org/combined-stream/-/combined-stream-1.0.8.tgz -> npmpkg-combined-stream-1.0.8.tgz
https://registry.npmjs.org/component-emitter/-/component-emitter-1.3.1.tgz -> npmpkg-component-emitter-1.3.1.tgz
https://registry.npmjs.org/compress-commons/-/compress-commons-1.2.2.tgz -> npmpkg-compress-commons-1.2.2.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/connect/-/connect-3.7.0.tgz -> npmpkg-connect-3.7.0.tgz
https://registry.npmjs.org/copy-descriptor/-/copy-descriptor-0.1.1.tgz -> npmpkg-copy-descriptor-0.1.1.tgz
https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.2.tgz -> npmpkg-core-util-is-1.0.2.tgz
https://registry.npmjs.org/cors/-/cors-2.8.4.tgz -> npmpkg-cors-2.8.4.tgz
https://registry.npmjs.org/crc/-/crc-3.5.0.tgz -> npmpkg-crc-3.5.0.tgz
https://registry.npmjs.org/crc32-stream/-/crc32-stream-2.0.0.tgz -> npmpkg-crc32-stream-2.0.0.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/decode-uri-component/-/decode-uri-component-0.2.1.tgz -> npmpkg-decode-uri-component-0.2.1.tgz
https://registry.npmjs.org/decompress-response/-/decompress-response-6.0.0.tgz -> npmpkg-decompress-response-6.0.0.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-3.1.0.tgz -> npmpkg-mimic-response-3.1.0.tgz
https://registry.npmjs.org/defer-to-connect/-/defer-to-connect-2.0.1.tgz -> npmpkg-defer-to-connect-2.0.1.tgz
https://registry.npmjs.org/define-data-property/-/define-data-property-1.1.4.tgz -> npmpkg-define-data-property-1.1.4.tgz
https://registry.npmjs.org/define-properties/-/define-properties-1.2.1.tgz -> npmpkg-define-properties-1.2.1.tgz
https://registry.npmjs.org/define-property/-/define-property-2.0.2.tgz -> npmpkg-define-property-2.0.2.tgz
https://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz -> npmpkg-delayed-stream-1.0.0.tgz
https://registry.npmjs.org/depd/-/depd-1.1.2.tgz -> npmpkg-depd-1.1.2.tgz
https://registry.npmjs.org/destroy/-/destroy-1.0.4.tgz -> npmpkg-destroy-1.0.4.tgz
https://registry.npmjs.org/detect-node/-/detect-node-2.1.0.tgz -> npmpkg-detect-node-2.1.0.tgz
https://registry.npmjs.org/discord-rich-presence/-/discord-rich-presence-0.0.8.tgz -> npmpkg-discord-rich-presence-0.0.8.tgz
https://github.com/discordjs/rpc/archive/9e7de2a6d917591f10a66389e62e1dc053c04fec.tar.gz -> npmpkg-rpc.git-9e7de2a6d917591f10a66389e62e1dc053c04fec.tgz
https://registry.npmjs.org/dotenv/-/dotenv-4.0.0.tgz -> npmpkg-dotenv-4.0.0.tgz
https://registry.npmjs.org/duplexer/-/duplexer-0.1.1.tgz -> npmpkg-duplexer-0.1.1.tgz
https://registry.npmjs.org/ee-first/-/ee-first-1.1.1.tgz -> npmpkg-ee-first-1.1.1.tgz
https://registry.npmjs.org/electron/-/electron-22.3.27.tgz -> npmpkg-electron-22.3.27.tgz
https://registry.npmjs.org/electron-editor-context-menu/-/electron-editor-context-menu-1.1.1.tgz -> npmpkg-electron-editor-context-menu-1.1.1.tgz
https://registry.npmjs.org/electron-is-dev/-/electron-is-dev-2.0.0.tgz -> npmpkg-electron-is-dev-2.0.0.tgz
https://registry.npmjs.org/electron-log/-/electron-log-4.1.1.tgz -> npmpkg-electron-log-4.1.1.tgz
https://registry.npmjs.org/electron-updater/-/electron-updater-4.2.0.tgz -> npmpkg-electron-updater-4.2.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-4.0.0.tgz -> npmpkg-jsonfile-4.0.0.tgz
https://registry.npmjs.org/encodeurl/-/encodeurl-1.0.2.tgz -> npmpkg-encodeurl-1.0.2.tgz
https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.4.1.tgz -> npmpkg-end-of-stream-1.4.1.tgz
https://registry.npmjs.org/env-paths/-/env-paths-2.2.1.tgz -> npmpkg-env-paths-2.2.1.tgz
https://registry.npmjs.org/es-define-property/-/es-define-property-1.0.0.tgz -> npmpkg-es-define-property-1.0.0.tgz
https://registry.npmjs.org/es-errors/-/es-errors-1.3.0.tgz -> npmpkg-es-errors-1.3.0.tgz
https://registry.npmjs.org/es6-error/-/es6-error-4.1.1.tgz -> npmpkg-es6-error-4.1.1.tgz
https://registry.npmjs.org/escape-html/-/escape-html-1.0.3.tgz -> npmpkg-escape-html-1.0.3.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz -> npmpkg-escape-string-regexp-4.0.0.tgz
https://registry.npmjs.org/esprima/-/esprima-4.0.1.tgz -> npmpkg-esprima-4.0.1.tgz
https://registry.npmjs.org/etag/-/etag-1.8.1.tgz -> npmpkg-etag-1.8.1.tgz
https://registry.npmjs.org/event-stream/-/event-stream-3.3.4.tgz -> npmpkg-event-stream-3.3.4.tgz
https://registry.npmjs.org/expand-brackets/-/expand-brackets-2.1.4.tgz -> npmpkg-expand-brackets-2.1.4.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.7.tgz -> npmpkg-is-descriptor-0.1.7.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-3.0.2.tgz -> npmpkg-extend-shallow-3.0.2.tgz
https://registry.npmjs.org/extglob/-/extglob-2.0.4.tgz -> npmpkg-extglob-2.0.4.tgz
https://registry.npmjs.org/define-property/-/define-property-1.0.0.tgz -> npmpkg-define-property-1.0.0.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/extract-zip/-/extract-zip-2.0.1.tgz -> npmpkg-extract-zip-2.0.1.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/faye-websocket/-/faye-websocket-0.11.1.tgz -> npmpkg-faye-websocket-0.11.1.tgz
https://registry.npmjs.org/fd-slicer/-/fd-slicer-1.1.0.tgz -> npmpkg-fd-slicer-1.1.0.tgz
https://registry.npmjs.org/file-uri-to-path/-/file-uri-to-path-1.0.0.tgz -> npmpkg-file-uri-to-path-1.0.0.tgz
https://registry.npmjs.org/fill-range/-/fill-range-4.0.0.tgz -> npmpkg-fill-range-4.0.0.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/finalhandler/-/finalhandler-1.1.2.tgz -> npmpkg-finalhandler-1.1.2.tgz
https://registry.npmjs.org/follow-redirects/-/follow-redirects-1.15.9.tgz -> npmpkg-follow-redirects-1.15.9.tgz
https://registry.npmjs.org/for-in/-/for-in-1.0.2.tgz -> npmpkg-for-in-1.0.2.tgz
https://registry.npmjs.org/form-data/-/form-data-4.0.0.tgz -> npmpkg-form-data-4.0.0.tgz
https://registry.npmjs.org/fragment-cache/-/fragment-cache-0.2.1.tgz -> npmpkg-fragment-cache-0.2.1.tgz
https://registry.npmjs.org/fresh/-/fresh-0.5.2.tgz -> npmpkg-fresh-0.5.2.tgz
https://registry.npmjs.org/from/-/from-0.1.7.tgz -> npmpkg-from-0.1.7.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-3.0.1.tgz -> npmpkg-fs-extra-3.0.1.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz -> npmpkg-fs.realpath-1.0.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz -> npmpkg-fsevents-2.3.3.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.2.tgz -> npmpkg-function-bind-1.1.2.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.2.4.tgz -> npmpkg-get-intrinsic-1.2.4.tgz
https://registry.npmjs.org/get-stream/-/get-stream-5.2.0.tgz -> npmpkg-get-stream-5.2.0.tgz
https://registry.npmjs.org/get-value/-/get-value-2.0.6.tgz -> npmpkg-get-value-2.0.6.tgz
https://registry.npmjs.org/glob/-/glob-7.1.2.tgz -> npmpkg-glob-7.1.2.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/global-agent/-/global-agent-3.0.0.tgz -> npmpkg-global-agent-3.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/globalthis/-/globalthis-1.0.4.tgz -> npmpkg-globalthis-1.0.4.tgz
https://registry.npmjs.org/gopd/-/gopd-1.0.1.tgz -> npmpkg-gopd-1.0.1.tgz
https://registry.npmjs.org/got/-/got-11.8.6.tgz -> npmpkg-got-11.8.6.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.10.tgz -> npmpkg-graceful-fs-4.2.10.tgz
https://registry.npmjs.org/has-property-descriptors/-/has-property-descriptors-1.0.2.tgz -> npmpkg-has-property-descriptors-1.0.2.tgz
https://registry.npmjs.org/has-proto/-/has-proto-1.0.3.tgz -> npmpkg-has-proto-1.0.3.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.0.3.tgz -> npmpkg-has-symbols-1.0.3.tgz
https://registry.npmjs.org/has-value/-/has-value-1.0.0.tgz -> npmpkg-has-value-1.0.0.tgz
https://registry.npmjs.org/has-values/-/has-values-1.0.0.tgz -> npmpkg-has-values-1.0.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-4.0.0.tgz -> npmpkg-kind-of-4.0.0.tgz
https://registry.npmjs.org/hasown/-/hasown-2.0.2.tgz -> npmpkg-hasown-2.0.2.tgz
https://registry.npmjs.org/http-auth/-/http-auth-3.1.3.tgz -> npmpkg-http-auth-3.1.3.tgz
https://registry.npmjs.org/http-cache-semantics/-/http-cache-semantics-4.1.1.tgz -> npmpkg-http-cache-semantics-4.1.1.tgz
https://registry.npmjs.org/http-errors/-/http-errors-1.6.2.tgz -> npmpkg-http-errors-1.6.2.tgz
https://registry.npmjs.org/depd/-/depd-1.1.1.tgz -> npmpkg-depd-1.1.1.tgz
https://registry.npmjs.org/http-parser-js/-/http-parser-js-0.4.10.tgz -> npmpkg-http-parser-js-0.4.10.tgz
https://registry.npmjs.org/http2-wrapper/-/http2-wrapper-1.0.3.tgz -> npmpkg-http2-wrapper-1.0.3.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz -> npmpkg-inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.3.tgz -> npmpkg-inherits-2.0.3.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-1.0.1.tgz -> npmpkg-is-accessor-descriptor-1.0.1.tgz
https://registry.npmjs.org/is-binary-path/-/is-binary-path-2.1.0.tgz -> npmpkg-is-binary-path-2.1.0.tgz
https://registry.npmjs.org/is-buffer/-/is-buffer-1.1.6.tgz -> npmpkg-is-buffer-1.1.6.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-1.0.1.tgz -> npmpkg-is-data-descriptor-1.0.1.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-1.0.3.tgz -> npmpkg-is-descriptor-1.0.3.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-1.0.1.tgz -> npmpkg-is-extendable-1.0.1.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz -> npmpkg-is-extglob-2.1.1.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/is-number/-/is-number-3.0.0.tgz -> npmpkg-is-number-3.0.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/is-plain-object/-/is-plain-object-2.0.4.tgz -> npmpkg-is-plain-object-2.0.4.tgz
https://registry.npmjs.org/is-windows/-/is-windows-1.0.2.tgz -> npmpkg-is-windows-1.0.2.tgz
https://registry.npmjs.org/is-wsl/-/is-wsl-1.1.0.tgz -> npmpkg-is-wsl-1.1.0.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-3.13.1.tgz -> npmpkg-js-yaml-3.13.1.tgz
https://registry.npmjs.org/json-buffer/-/json-buffer-3.0.1.tgz -> npmpkg-json-buffer-3.0.1.tgz
https://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz -> npmpkg-json-stringify-safe-5.0.1.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-3.0.1.tgz -> npmpkg-jsonfile-3.0.1.tgz
https://registry.npmjs.org/keyv/-/keyv-4.5.4.tgz -> npmpkg-keyv-4.5.4.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/lazy-val/-/lazy-val-1.0.4.tgz -> npmpkg-lazy-val-1.0.4.tgz
https://registry.npmjs.org/lazystream/-/lazystream-1.0.0.tgz -> npmpkg-lazystream-1.0.0.tgz
https://registry.npmjs.org/live-server/-/live-server-1.2.2.tgz -> npmpkg-live-server-1.2.2.tgz
https://registry.npmjs.org/anymatch/-/anymatch-2.0.0.tgz -> npmpkg-anymatch-2.0.0.tgz
https://registry.npmjs.org/binary-extensions/-/binary-extensions-1.13.1.tgz -> npmpkg-binary-extensions-1.13.1.tgz
https://registry.npmjs.org/braces/-/braces-2.3.2.tgz -> npmpkg-braces-2.3.2.tgz
https://registry.npmjs.org/chokidar/-/chokidar-2.1.8.tgz -> npmpkg-chokidar-2.1.8.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz -> npmpkg-normalize-path-3.0.0.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/fsevents/-/fsevents-1.2.13.tgz -> npmpkg-fsevents-1.2.13.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-3.1.0.tgz -> npmpkg-glob-parent-3.1.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-3.1.0.tgz -> npmpkg-is-glob-3.1.0.tgz
https://registry.npmjs.org/is-binary-path/-/is-binary-path-1.0.1.tgz -> npmpkg-is-binary-path-1.0.1.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/readdirp/-/readdirp-2.2.1.tgz -> npmpkg-readdirp-2.2.1.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/lodash.clonedeep/-/lodash.clonedeep-4.5.0.tgz -> npmpkg-lodash.clonedeep-4.5.0.tgz
https://registry.npmjs.org/lodash.debounce/-/lodash.debounce-4.0.8.tgz -> npmpkg-lodash.debounce-4.0.8.tgz
https://registry.npmjs.org/lodash.defaults/-/lodash.defaults-4.2.0.tgz -> npmpkg-lodash.defaults-4.2.0.tgz
https://registry.npmjs.org/lodash.isarray/-/lodash.isarray-4.0.0.tgz -> npmpkg-lodash.isarray-4.0.0.tgz
https://registry.npmjs.org/lodash.isempty/-/lodash.isempty-4.4.0.tgz -> npmpkg-lodash.isempty-4.4.0.tgz
https://registry.npmjs.org/lodash.isequal/-/lodash.isequal-4.5.0.tgz -> npmpkg-lodash.isequal-4.5.0.tgz
https://registry.npmjs.org/lodash.isfunction/-/lodash.isfunction-3.0.8.tgz -> npmpkg-lodash.isfunction-3.0.8.tgz
https://registry.npmjs.org/lodash.throttle/-/lodash.throttle-4.1.1.tgz -> npmpkg-lodash.throttle-4.1.1.tgz
https://registry.npmjs.org/lowercase-keys/-/lowercase-keys-2.0.0.tgz -> npmpkg-lowercase-keys-2.0.0.tgz
https://registry.npmjs.org/map-cache/-/map-cache-0.2.2.tgz -> npmpkg-map-cache-0.2.2.tgz
https://registry.npmjs.org/map-stream/-/map-stream-0.1.0.tgz -> npmpkg-map-stream-0.1.0.tgz
https://registry.npmjs.org/map-visit/-/map-visit-1.0.0.tgz -> npmpkg-map-visit-1.0.0.tgz
https://registry.npmjs.org/matcher/-/matcher-3.0.0.tgz -> npmpkg-matcher-3.0.0.tgz
https://registry.npmjs.org/micromatch/-/micromatch-3.1.10.tgz -> npmpkg-micromatch-3.1.10.tgz
https://registry.npmjs.org/mime-db/-/mime-db-1.30.0.tgz -> npmpkg-mime-db-1.30.0.tgz
https://registry.npmjs.org/mime-types/-/mime-types-2.1.17.tgz -> npmpkg-mime-types-2.1.17.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-1.0.1.tgz -> npmpkg-mimic-response-1.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.0.5.tgz -> npmpkg-minimatch-3.0.5.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.6.tgz -> npmpkg-minimist-1.2.6.tgz
https://registry.npmjs.org/mixin-deep/-/mixin-deep-1.3.2.tgz -> npmpkg-mixin-deep-1.3.2.tgz
https://registry.npmjs.org/morgan/-/morgan-1.9.1.tgz -> npmpkg-morgan-1.9.1.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/nan/-/nan-2.20.0.tgz -> npmpkg-nan-2.20.0.tgz
https://registry.npmjs.org/nanomatch/-/nanomatch-1.2.13.tgz -> npmpkg-nanomatch-1.2.13.tgz
https://registry.npmjs.org/negotiator/-/negotiator-0.6.1.tgz -> npmpkg-negotiator-0.6.1.tgz
https://registry.npmjs.org/node-addon-api/-/node-addon-api-1.7.2.tgz -> npmpkg-node-addon-api-1.7.2.tgz
https://registry.npmjs.org/node-fetch/-/node-fetch-2.6.7.tgz -> npmpkg-node-fetch-2.6.7.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-2.1.1.tgz -> npmpkg-normalize-path-2.1.1.tgz
https://registry.npmjs.org/normalize-url/-/normalize-url-6.1.0.tgz -> npmpkg-normalize-url-6.1.0.tgz
https://registry.npmjs.org/object-assign/-/object-assign-4.1.1.tgz -> npmpkg-object-assign-4.1.1.tgz
https://registry.npmjs.org/object-copy/-/object-copy-0.1.0.tgz -> npmpkg-object-copy-0.1.0.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.7.tgz -> npmpkg-is-descriptor-0.1.7.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/object-keys/-/object-keys-1.1.1.tgz -> npmpkg-object-keys-1.1.1.tgz
https://registry.npmjs.org/object-visit/-/object-visit-1.0.1.tgz -> npmpkg-object-visit-1.0.1.tgz
https://registry.npmjs.org/object.pick/-/object.pick-1.3.0.tgz -> npmpkg-object.pick-1.3.0.tgz
https://registry.npmjs.org/on-finished/-/on-finished-2.3.0.tgz -> npmpkg-on-finished-2.3.0.tgz
https://registry.npmjs.org/on-headers/-/on-headers-1.0.2.tgz -> npmpkg-on-headers-1.0.2.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz -> npmpkg-once-1.4.0.tgz
https://registry.npmjs.org/opn/-/opn-5.2.0.tgz -> npmpkg-opn-5.2.0.tgz
https://registry.npmjs.org/p-cancelable/-/p-cancelable-2.1.1.tgz -> npmpkg-p-cancelable-2.1.1.tgz
https://registry.npmjs.org/pako/-/pako-1.0.10.tgz -> npmpkg-pako-1.0.10.tgz
https://registry.npmjs.org/parseurl/-/parseurl-1.3.3.tgz -> npmpkg-parseurl-1.3.3.tgz
https://registry.npmjs.org/pascalcase/-/pascalcase-0.1.1.tgz -> npmpkg-pascalcase-0.1.1.tgz
https://registry.npmjs.org/path-dirname/-/path-dirname-1.0.2.tgz -> npmpkg-path-dirname-1.0.2.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> npmpkg-path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/pause-stream/-/pause-stream-0.0.11.tgz -> npmpkg-pause-stream-0.0.11.tgz
https://registry.npmjs.org/pend/-/pend-1.2.0.tgz -> npmpkg-pend-1.2.0.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.3.1.tgz -> npmpkg-picomatch-2.3.1.tgz
https://registry.npmjs.org/posix-character-classes/-/posix-character-classes-0.1.1.tgz -> npmpkg-posix-character-classes-0.1.1.tgz
https://registry.npmjs.org/process-nextick-args/-/process-nextick-args-2.0.1.tgz -> npmpkg-process-nextick-args-2.0.1.tgz
https://registry.npmjs.org/progress/-/progress-2.0.3.tgz -> npmpkg-progress-2.0.3.tgz
https://registry.npmjs.org/proxy-from-env/-/proxy-from-env-1.1.0.tgz -> npmpkg-proxy-from-env-1.1.0.tgz
https://registry.npmjs.org/proxy-middleware/-/proxy-middleware-0.15.0.tgz -> npmpkg-proxy-middleware-0.15.0.tgz
https://registry.npmjs.org/pump/-/pump-3.0.0.tgz -> npmpkg-pump-3.0.0.tgz
https://registry.npmjs.org/quick-lru/-/quick-lru-5.1.1.tgz -> npmpkg-quick-lru-5.1.1.tgz
https://registry.npmjs.org/range-parser/-/range-parser-1.2.0.tgz -> npmpkg-range-parser-1.2.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/readdirp/-/readdirp-3.6.0.tgz -> npmpkg-readdirp-3.6.0.tgz
https://registry.npmjs.org/regex-not/-/regex-not-1.0.2.tgz -> npmpkg-regex-not-1.0.2.tgz
https://github.com/devsnek/node-register-scheme/archive/e7cc9a63a1f512565da44cb57316d9fb10750e17.tar.gz -> npmpkg-node-register-scheme.git-e7cc9a63a1f512565da44cb57316d9fb10750e17.tgz
https://registry.npmjs.org/remove-trailing-separator/-/remove-trailing-separator-1.1.0.tgz -> npmpkg-remove-trailing-separator-1.1.0.tgz
https://registry.npmjs.org/repeat-element/-/repeat-element-1.1.4.tgz -> npmpkg-repeat-element-1.1.4.tgz
https://registry.npmjs.org/repeat-string/-/repeat-string-1.6.1.tgz -> npmpkg-repeat-string-1.6.1.tgz
https://registry.npmjs.org/resolve-alpn/-/resolve-alpn-1.2.1.tgz -> npmpkg-resolve-alpn-1.2.1.tgz
https://registry.npmjs.org/resolve-url/-/resolve-url-0.2.1.tgz -> npmpkg-resolve-url-0.2.1.tgz
https://registry.npmjs.org/responselike/-/responselike-2.0.1.tgz -> npmpkg-responselike-2.0.1.tgz
https://registry.npmjs.org/ret/-/ret-0.1.15.tgz -> npmpkg-ret-0.1.15.tgz
https://registry.npmjs.org/roarr/-/roarr-2.15.4.tgz -> npmpkg-roarr-2.15.4.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.1.3.tgz -> npmpkg-sprintf-js-1.1.3.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/safe-regex/-/safe-regex-1.1.0.tgz -> npmpkg-safe-regex-1.1.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/semver-compare/-/semver-compare-1.0.0.tgz -> npmpkg-semver-compare-1.0.0.tgz
https://registry.npmjs.org/send/-/send-0.16.2.tgz -> npmpkg-send-0.16.2.tgz
https://registry.npmjs.org/mime/-/mime-1.4.1.tgz -> npmpkg-mime-1.4.1.tgz
https://registry.npmjs.org/statuses/-/statuses-1.4.0.tgz -> npmpkg-statuses-1.4.0.tgz
https://registry.npmjs.org/serialize-error/-/serialize-error-7.0.1.tgz -> npmpkg-serialize-error-7.0.1.tgz
https://registry.npmjs.org/serve-index/-/serve-index-1.9.1.tgz -> npmpkg-serve-index-1.9.1.tgz
https://registry.npmjs.org/set-value/-/set-value-2.0.1.tgz -> npmpkg-set-value-2.0.1.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/setprototypeof/-/setprototypeof-1.0.3.tgz -> npmpkg-setprototypeof-1.0.3.tgz
https://registry.npmjs.org/snapdragon/-/snapdragon-0.8.2.tgz -> npmpkg-snapdragon-0.8.2.tgz
https://registry.npmjs.org/snapdragon-node/-/snapdragon-node-2.1.1.tgz -> npmpkg-snapdragon-node-2.1.1.tgz
https://registry.npmjs.org/define-property/-/define-property-1.0.0.tgz -> npmpkg-define-property-1.0.0.tgz
https://registry.npmjs.org/snapdragon-util/-/snapdragon-util-3.0.1.tgz -> npmpkg-snapdragon-util-3.0.1.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.7.tgz -> npmpkg-is-descriptor-0.1.7.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/source-map/-/source-map-0.5.7.tgz -> npmpkg-source-map-0.5.7.tgz
https://registry.npmjs.org/source-map-resolve/-/source-map-resolve-0.5.3.tgz -> npmpkg-source-map-resolve-0.5.3.tgz
https://registry.npmjs.org/source-map-url/-/source-map-url-0.4.1.tgz -> npmpkg-source-map-url-0.4.1.tgz
https://registry.npmjs.org/split/-/split-0.3.3.tgz -> npmpkg-split-0.3.3.tgz
https://registry.npmjs.org/split-string/-/split-string-3.1.0.tgz -> npmpkg-split-string-3.1.0.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.0.3.tgz -> npmpkg-sprintf-js-1.0.3.tgz
https://registry.npmjs.org/static-extend/-/static-extend-0.1.2.tgz -> npmpkg-static-extend-0.1.2.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.7.tgz -> npmpkg-is-descriptor-0.1.7.tgz
https://registry.npmjs.org/statuses/-/statuses-1.5.0.tgz -> npmpkg-statuses-1.5.0.tgz
https://registry.npmjs.org/steamworks.js/-/steamworks.js-0.3.1.tgz -> npmpkg-steamworks.js-0.3.1.tgz
https://registry.npmjs.org/stream-combiner/-/stream-combiner-0.0.4.tgz -> npmpkg-stream-combiner-0.0.4.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-1.1.1.tgz -> npmpkg-string_decoder-1.1.1.tgz
https://registry.npmjs.org/sumchecker/-/sumchecker-3.0.1.tgz -> npmpkg-sumchecker-3.0.1.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/tar-stream/-/tar-stream-1.5.5.tgz -> npmpkg-tar-stream-1.5.5.tgz
https://registry.npmjs.org/through/-/through-2.3.8.tgz -> npmpkg-through-2.3.8.tgz
https://registry.npmjs.org/to-object-path/-/to-object-path-0.3.0.tgz -> npmpkg-to-object-path-0.3.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/to-regex/-/to-regex-3.0.2.tgz -> npmpkg-to-regex-3.0.2.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-2.1.1.tgz -> npmpkg-to-regex-range-2.1.1.tgz
https://registry.npmjs.org/tr46/-/tr46-0.0.3.tgz -> npmpkg-tr46-0.0.3.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.13.1.tgz -> npmpkg-type-fest-0.13.1.tgz
https://registry.npmjs.org/union-value/-/union-value-1.0.1.tgz -> npmpkg-union-value-1.0.1.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/universalify/-/universalify-0.1.1.tgz -> npmpkg-universalify-0.1.1.tgz
https://registry.npmjs.org/unix-crypt-td-js/-/unix-crypt-td-js-1.0.0.tgz -> npmpkg-unix-crypt-td-js-1.0.0.tgz
https://registry.npmjs.org/unpipe/-/unpipe-1.0.0.tgz -> npmpkg-unpipe-1.0.0.tgz
https://registry.npmjs.org/unset-value/-/unset-value-1.0.0.tgz -> npmpkg-unset-value-1.0.0.tgz
https://registry.npmjs.org/has-value/-/has-value-0.3.1.tgz -> npmpkg-has-value-0.3.1.tgz
https://registry.npmjs.org/isobject/-/isobject-2.1.0.tgz -> npmpkg-isobject-2.1.0.tgz
https://registry.npmjs.org/has-values/-/has-values-0.1.4.tgz -> npmpkg-has-values-0.1.4.tgz
https://registry.npmjs.org/upath/-/upath-1.2.0.tgz -> npmpkg-upath-1.2.0.tgz
https://registry.npmjs.org/urix/-/urix-0.1.0.tgz -> npmpkg-urix-0.1.0.tgz
https://registry.npmjs.org/use/-/use-3.1.1.tgz -> npmpkg-use-3.1.1.tgz
https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz -> npmpkg-util-deprecate-1.0.2.tgz
https://registry.npmjs.org/utils-merge/-/utils-merge-1.0.1.tgz -> npmpkg-utils-merge-1.0.1.tgz
https://registry.npmjs.org/uuid/-/uuid-3.1.0.tgz -> npmpkg-uuid-3.1.0.tgz
https://registry.npmjs.org/vary/-/vary-1.1.2.tgz -> npmpkg-vary-1.1.2.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-3.0.1.tgz -> npmpkg-webidl-conversions-3.0.1.tgz
https://registry.npmjs.org/websocket-driver/-/websocket-driver-0.7.0.tgz -> npmpkg-websocket-driver-0.7.0.tgz
https://registry.npmjs.org/websocket-extensions/-/websocket-extensions-0.1.4.tgz -> npmpkg-websocket-extensions-0.1.4.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-5.0.0.tgz -> npmpkg-whatwg-url-5.0.0.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
https://registry.npmjs.org/ws/-/ws-7.5.10.tgz -> npmpkg-ws-7.5.10.tgz
https://registry.npmjs.org/xtend/-/xtend-4.0.1.tgz -> npmpkg-xtend-4.0.1.tgz
https://registry.npmjs.org/yauzl/-/yauzl-2.10.0.tgz -> npmpkg-yauzl-2.10.0.tgz
https://registry.npmjs.org/zip-stream/-/zip-stream-1.2.0.tgz -> npmpkg-zip-stream-1.2.0.tgz
https://registry.npmjs.org/@electron/get/-/get-2.0.3.tgz -> npmpkg-@electron-get-2.0.3.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-4.0.0.tgz -> npmpkg-jsonfile-4.0.0.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/@electron/remote/-/remote-2.0.8.tgz -> npmpkg-@electron-remote-2.0.8.tgz
https://registry.npmjs.org/@sindresorhus/is/-/is-4.6.0.tgz -> npmpkg-@sindresorhus-is-4.6.0.tgz
https://registry.npmjs.org/@szmarczak/http-timer/-/http-timer-4.0.6.tgz -> npmpkg-@szmarczak-http-timer-4.0.6.tgz
https://registry.npmjs.org/@types/cacheable-request/-/cacheable-request-6.0.3.tgz -> npmpkg-@types-cacheable-request-6.0.3.tgz
https://registry.npmjs.org/@types/http-cache-semantics/-/http-cache-semantics-4.0.4.tgz -> npmpkg-@types-http-cache-semantics-4.0.4.tgz
https://registry.npmjs.org/@types/keyv/-/keyv-3.1.4.tgz -> npmpkg-@types-keyv-3.1.4.tgz
https://registry.npmjs.org/@types/node/-/node-16.18.112.tgz -> npmpkg-@types-node-16.18.112.tgz
https://registry.npmjs.org/@types/responselike/-/responselike-1.0.3.tgz -> npmpkg-@types-responselike-1.0.3.tgz
https://registry.npmjs.org/@types/semver/-/semver-6.2.0.tgz -> npmpkg-@types-semver-6.2.0.tgz
https://registry.npmjs.org/@types/yauzl/-/yauzl-2.10.0.tgz -> npmpkg-@types-yauzl-2.10.0.tgz
https://registry.npmjs.org/accepts/-/accepts-1.3.4.tgz -> npmpkg-accepts-1.3.4.tgz
https://registry.npmjs.org/anymatch/-/anymatch-3.1.3.tgz -> npmpkg-anymatch-3.1.3.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz -> npmpkg-normalize-path-3.0.0.tgz
https://registry.npmjs.org/apache-crypt/-/apache-crypt-1.2.1.tgz -> npmpkg-apache-crypt-1.2.1.tgz
https://registry.npmjs.org/apache-md5/-/apache-md5-1.1.2.tgz -> npmpkg-apache-md5-1.1.2.tgz
https://registry.npmjs.org/archiver/-/archiver-2.1.1.tgz -> npmpkg-archiver-2.1.1.tgz
https://registry.npmjs.org/archiver-utils/-/archiver-utils-1.3.0.tgz -> npmpkg-archiver-utils-1.3.0.tgz
https://registry.npmjs.org/argparse/-/argparse-1.0.10.tgz -> npmpkg-argparse-1.0.10.tgz
https://registry.npmjs.org/arr-diff/-/arr-diff-4.0.0.tgz -> npmpkg-arr-diff-4.0.0.tgz
https://registry.npmjs.org/arr-flatten/-/arr-flatten-1.1.0.tgz -> npmpkg-arr-flatten-1.1.0.tgz
https://registry.npmjs.org/arr-union/-/arr-union-3.1.0.tgz -> npmpkg-arr-union-3.1.0.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.3.2.tgz -> npmpkg-array-unique-0.3.2.tgz
https://registry.npmjs.org/assign-symbols/-/assign-symbols-1.0.0.tgz -> npmpkg-assign-symbols-1.0.0.tgz
https://registry.npmjs.org/async/-/async-2.6.4.tgz -> npmpkg-async-2.6.4.tgz
https://registry.npmjs.org/async-each/-/async-each-1.0.6.tgz -> npmpkg-async-each-1.0.6.tgz
https://registry.npmjs.org/asynckit/-/asynckit-0.4.0.tgz -> npmpkg-asynckit-0.4.0.tgz
https://registry.npmjs.org/atob/-/atob-2.1.2.tgz -> npmpkg-atob-2.1.2.tgz
https://registry.npmjs.org/axios/-/axios-0.28.0.tgz -> npmpkg-axios-0.28.0.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.0.tgz -> npmpkg-balanced-match-1.0.0.tgz
https://registry.npmjs.org/base/-/base-0.11.2.tgz -> npmpkg-base-0.11.2.tgz
https://registry.npmjs.org/define-property/-/define-property-1.0.0.tgz -> npmpkg-define-property-1.0.0.tgz
https://registry.npmjs.org/basic-auth/-/basic-auth-2.0.1.tgz -> npmpkg-basic-auth-2.0.1.tgz
https://registry.npmjs.org/batch/-/batch-0.6.1.tgz -> npmpkg-batch-0.6.1.tgz
https://registry.npmjs.org/bcryptjs/-/bcryptjs-2.4.3.tgz -> npmpkg-bcryptjs-2.4.3.tgz
https://registry.npmjs.org/binary-extensions/-/binary-extensions-2.3.0.tgz -> npmpkg-binary-extensions-2.3.0.tgz
https://registry.npmjs.org/bindings/-/bindings-1.5.0.tgz -> npmpkg-bindings-1.5.0.tgz
https://registry.npmjs.org/bl/-/bl-1.2.3.tgz -> npmpkg-bl-1.2.3.tgz
https://registry.npmjs.org/boolean/-/boolean-3.2.0.tgz -> npmpkg-boolean-3.2.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.8.tgz -> npmpkg-brace-expansion-1.1.8.tgz
https://registry.npmjs.org/braces/-/braces-3.0.3.tgz -> npmpkg-braces-3.0.3.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.1.1.tgz -> npmpkg-fill-range-7.1.1.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.2.13.tgz -> npmpkg-buffer-crc32-0.2.13.tgz
https://registry.npmjs.org/builder-util-runtime/-/builder-util-runtime-8.4.0.tgz -> npmpkg-builder-util-runtime-8.4.0.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/sax/-/sax-1.2.4.tgz -> npmpkg-sax-1.2.4.tgz
https://registry.npmjs.org/cache-base/-/cache-base-1.0.1.tgz -> npmpkg-cache-base-1.0.1.tgz
https://registry.npmjs.org/cacheable-lookup/-/cacheable-lookup-5.0.4.tgz -> npmpkg-cacheable-lookup-5.0.4.tgz
https://registry.npmjs.org/cacheable-request/-/cacheable-request-7.0.4.tgz -> npmpkg-cacheable-request-7.0.4.tgz
https://registry.npmjs.org/chokidar/-/chokidar-3.5.3.tgz -> npmpkg-chokidar-3.5.3.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz -> npmpkg-normalize-path-3.0.0.tgz
https://registry.npmjs.org/class-utils/-/class-utils-0.3.6.tgz -> npmpkg-class-utils-0.3.6.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.7.tgz -> npmpkg-is-descriptor-0.1.7.tgz
https://registry.npmjs.org/clone-response/-/clone-response-1.0.3.tgz -> npmpkg-clone-response-1.0.3.tgz
https://registry.npmjs.org/collection-visit/-/collection-visit-1.0.0.tgz -> npmpkg-collection-visit-1.0.0.tgz
https://registry.npmjs.org/colors/-/colors-1.4.0.tgz -> npmpkg-colors-1.4.0.tgz
https://registry.npmjs.org/combined-stream/-/combined-stream-1.0.8.tgz -> npmpkg-combined-stream-1.0.8.tgz
https://registry.npmjs.org/component-emitter/-/component-emitter-1.3.1.tgz -> npmpkg-component-emitter-1.3.1.tgz
https://registry.npmjs.org/compress-commons/-/compress-commons-1.2.2.tgz -> npmpkg-compress-commons-1.2.2.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/connect/-/connect-3.7.0.tgz -> npmpkg-connect-3.7.0.tgz
https://registry.npmjs.org/copy-descriptor/-/copy-descriptor-0.1.1.tgz -> npmpkg-copy-descriptor-0.1.1.tgz
https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.2.tgz -> npmpkg-core-util-is-1.0.2.tgz
https://registry.npmjs.org/cors/-/cors-2.8.4.tgz -> npmpkg-cors-2.8.4.tgz
https://registry.npmjs.org/crc/-/crc-3.5.0.tgz -> npmpkg-crc-3.5.0.tgz
https://registry.npmjs.org/crc32-stream/-/crc32-stream-2.0.0.tgz -> npmpkg-crc32-stream-2.0.0.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/decode-uri-component/-/decode-uri-component-0.2.1.tgz -> npmpkg-decode-uri-component-0.2.1.tgz
https://registry.npmjs.org/decompress-response/-/decompress-response-6.0.0.tgz -> npmpkg-decompress-response-6.0.0.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-3.1.0.tgz -> npmpkg-mimic-response-3.1.0.tgz
https://registry.npmjs.org/defer-to-connect/-/defer-to-connect-2.0.1.tgz -> npmpkg-defer-to-connect-2.0.1.tgz
https://registry.npmjs.org/define-data-property/-/define-data-property-1.1.4.tgz -> npmpkg-define-data-property-1.1.4.tgz
https://registry.npmjs.org/define-properties/-/define-properties-1.2.1.tgz -> npmpkg-define-properties-1.2.1.tgz
https://registry.npmjs.org/define-property/-/define-property-2.0.2.tgz -> npmpkg-define-property-2.0.2.tgz
https://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz -> npmpkg-delayed-stream-1.0.0.tgz
https://registry.npmjs.org/depd/-/depd-1.1.2.tgz -> npmpkg-depd-1.1.2.tgz
https://registry.npmjs.org/destroy/-/destroy-1.0.4.tgz -> npmpkg-destroy-1.0.4.tgz
https://registry.npmjs.org/detect-node/-/detect-node-2.1.0.tgz -> npmpkg-detect-node-2.1.0.tgz
https://registry.npmjs.org/discord-rich-presence/-/discord-rich-presence-0.0.8.tgz -> npmpkg-discord-rich-presence-0.0.8.tgz
https://registry.npmjs.org/dotenv/-/dotenv-4.0.0.tgz -> npmpkg-dotenv-4.0.0.tgz
https://registry.npmjs.org/duplexer/-/duplexer-0.1.1.tgz -> npmpkg-duplexer-0.1.1.tgz
https://registry.npmjs.org/ee-first/-/ee-first-1.1.1.tgz -> npmpkg-ee-first-1.1.1.tgz
https://registry.npmjs.org/electron/-/electron-22.3.27.tgz -> npmpkg-electron-22.3.27.tgz
https://registry.npmjs.org/electron-editor-context-menu/-/electron-editor-context-menu-1.1.1.tgz -> npmpkg-electron-editor-context-menu-1.1.1.tgz
https://registry.npmjs.org/electron-is-dev/-/electron-is-dev-2.0.0.tgz -> npmpkg-electron-is-dev-2.0.0.tgz
https://registry.npmjs.org/electron-log/-/electron-log-4.1.1.tgz -> npmpkg-electron-log-4.1.1.tgz
https://registry.npmjs.org/electron-updater/-/electron-updater-4.2.0.tgz -> npmpkg-electron-updater-4.2.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-4.0.0.tgz -> npmpkg-jsonfile-4.0.0.tgz
https://registry.npmjs.org/encodeurl/-/encodeurl-1.0.2.tgz -> npmpkg-encodeurl-1.0.2.tgz
https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.4.1.tgz -> npmpkg-end-of-stream-1.4.1.tgz
https://registry.npmjs.org/env-paths/-/env-paths-2.2.1.tgz -> npmpkg-env-paths-2.2.1.tgz
https://registry.npmjs.org/es-define-property/-/es-define-property-1.0.0.tgz -> npmpkg-es-define-property-1.0.0.tgz
https://registry.npmjs.org/es-errors/-/es-errors-1.3.0.tgz -> npmpkg-es-errors-1.3.0.tgz
https://registry.npmjs.org/es6-error/-/es6-error-4.1.1.tgz -> npmpkg-es6-error-4.1.1.tgz
https://registry.npmjs.org/escape-html/-/escape-html-1.0.3.tgz -> npmpkg-escape-html-1.0.3.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz -> npmpkg-escape-string-regexp-4.0.0.tgz
https://registry.npmjs.org/esprima/-/esprima-4.0.1.tgz -> npmpkg-esprima-4.0.1.tgz
https://registry.npmjs.org/etag/-/etag-1.8.1.tgz -> npmpkg-etag-1.8.1.tgz
https://registry.npmjs.org/event-stream/-/event-stream-3.3.4.tgz -> npmpkg-event-stream-3.3.4.tgz
https://registry.npmjs.org/expand-brackets/-/expand-brackets-2.1.4.tgz -> npmpkg-expand-brackets-2.1.4.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.7.tgz -> npmpkg-is-descriptor-0.1.7.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-3.0.2.tgz -> npmpkg-extend-shallow-3.0.2.tgz
https://registry.npmjs.org/extglob/-/extglob-2.0.4.tgz -> npmpkg-extglob-2.0.4.tgz
https://registry.npmjs.org/define-property/-/define-property-1.0.0.tgz -> npmpkg-define-property-1.0.0.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/extract-zip/-/extract-zip-2.0.1.tgz -> npmpkg-extract-zip-2.0.1.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/faye-websocket/-/faye-websocket-0.11.1.tgz -> npmpkg-faye-websocket-0.11.1.tgz
https://registry.npmjs.org/fd-slicer/-/fd-slicer-1.1.0.tgz -> npmpkg-fd-slicer-1.1.0.tgz
https://registry.npmjs.org/file-uri-to-path/-/file-uri-to-path-1.0.0.tgz -> npmpkg-file-uri-to-path-1.0.0.tgz
https://registry.npmjs.org/fill-range/-/fill-range-4.0.0.tgz -> npmpkg-fill-range-4.0.0.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/finalhandler/-/finalhandler-1.1.2.tgz -> npmpkg-finalhandler-1.1.2.tgz
https://registry.npmjs.org/follow-redirects/-/follow-redirects-1.15.9.tgz -> npmpkg-follow-redirects-1.15.9.tgz
https://registry.npmjs.org/for-in/-/for-in-1.0.2.tgz -> npmpkg-for-in-1.0.2.tgz
https://registry.npmjs.org/form-data/-/form-data-4.0.0.tgz -> npmpkg-form-data-4.0.0.tgz
https://registry.npmjs.org/fragment-cache/-/fragment-cache-0.2.1.tgz -> npmpkg-fragment-cache-0.2.1.tgz
https://registry.npmjs.org/fresh/-/fresh-0.5.2.tgz -> npmpkg-fresh-0.5.2.tgz
https://registry.npmjs.org/from/-/from-0.1.7.tgz -> npmpkg-from-0.1.7.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-3.0.1.tgz -> npmpkg-fs-extra-3.0.1.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz -> npmpkg-fs.realpath-1.0.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz -> npmpkg-fsevents-2.3.3.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.2.tgz -> npmpkg-function-bind-1.1.2.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.2.4.tgz -> npmpkg-get-intrinsic-1.2.4.tgz
https://registry.npmjs.org/get-stream/-/get-stream-5.2.0.tgz -> npmpkg-get-stream-5.2.0.tgz
https://registry.npmjs.org/get-value/-/get-value-2.0.6.tgz -> npmpkg-get-value-2.0.6.tgz
https://registry.npmjs.org/glob/-/glob-7.1.2.tgz -> npmpkg-glob-7.1.2.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/global-agent/-/global-agent-3.0.0.tgz -> npmpkg-global-agent-3.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/globalthis/-/globalthis-1.0.4.tgz -> npmpkg-globalthis-1.0.4.tgz
https://registry.npmjs.org/gopd/-/gopd-1.0.1.tgz -> npmpkg-gopd-1.0.1.tgz
https://registry.npmjs.org/got/-/got-11.8.6.tgz -> npmpkg-got-11.8.6.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.10.tgz -> npmpkg-graceful-fs-4.2.10.tgz
https://registry.npmjs.org/has-property-descriptors/-/has-property-descriptors-1.0.2.tgz -> npmpkg-has-property-descriptors-1.0.2.tgz
https://registry.npmjs.org/has-proto/-/has-proto-1.0.3.tgz -> npmpkg-has-proto-1.0.3.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.0.3.tgz -> npmpkg-has-symbols-1.0.3.tgz
https://registry.npmjs.org/has-value/-/has-value-1.0.0.tgz -> npmpkg-has-value-1.0.0.tgz
https://registry.npmjs.org/has-values/-/has-values-1.0.0.tgz -> npmpkg-has-values-1.0.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-4.0.0.tgz -> npmpkg-kind-of-4.0.0.tgz
https://registry.npmjs.org/hasown/-/hasown-2.0.2.tgz -> npmpkg-hasown-2.0.2.tgz
https://registry.npmjs.org/http-auth/-/http-auth-3.1.3.tgz -> npmpkg-http-auth-3.1.3.tgz
https://registry.npmjs.org/http-cache-semantics/-/http-cache-semantics-4.1.1.tgz -> npmpkg-http-cache-semantics-4.1.1.tgz
https://registry.npmjs.org/http-errors/-/http-errors-1.6.2.tgz -> npmpkg-http-errors-1.6.2.tgz
https://registry.npmjs.org/depd/-/depd-1.1.1.tgz -> npmpkg-depd-1.1.1.tgz
https://registry.npmjs.org/http-parser-js/-/http-parser-js-0.4.10.tgz -> npmpkg-http-parser-js-0.4.10.tgz
https://registry.npmjs.org/http2-wrapper/-/http2-wrapper-1.0.3.tgz -> npmpkg-http2-wrapper-1.0.3.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz -> npmpkg-inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.3.tgz -> npmpkg-inherits-2.0.3.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-1.0.1.tgz -> npmpkg-is-accessor-descriptor-1.0.1.tgz
https://registry.npmjs.org/is-binary-path/-/is-binary-path-2.1.0.tgz -> npmpkg-is-binary-path-2.1.0.tgz
https://registry.npmjs.org/is-buffer/-/is-buffer-1.1.6.tgz -> npmpkg-is-buffer-1.1.6.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-1.0.1.tgz -> npmpkg-is-data-descriptor-1.0.1.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-1.0.3.tgz -> npmpkg-is-descriptor-1.0.3.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-1.0.1.tgz -> npmpkg-is-extendable-1.0.1.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz -> npmpkg-is-extglob-2.1.1.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/is-number/-/is-number-3.0.0.tgz -> npmpkg-is-number-3.0.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/is-plain-object/-/is-plain-object-2.0.4.tgz -> npmpkg-is-plain-object-2.0.4.tgz
https://registry.npmjs.org/is-windows/-/is-windows-1.0.2.tgz -> npmpkg-is-windows-1.0.2.tgz
https://registry.npmjs.org/is-wsl/-/is-wsl-1.1.0.tgz -> npmpkg-is-wsl-1.1.0.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-3.13.1.tgz -> npmpkg-js-yaml-3.13.1.tgz
https://registry.npmjs.org/json-buffer/-/json-buffer-3.0.1.tgz -> npmpkg-json-buffer-3.0.1.tgz
https://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz -> npmpkg-json-stringify-safe-5.0.1.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-3.0.1.tgz -> npmpkg-jsonfile-3.0.1.tgz
https://registry.npmjs.org/keyv/-/keyv-4.5.4.tgz -> npmpkg-keyv-4.5.4.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/lazy-val/-/lazy-val-1.0.4.tgz -> npmpkg-lazy-val-1.0.4.tgz
https://registry.npmjs.org/lazystream/-/lazystream-1.0.0.tgz -> npmpkg-lazystream-1.0.0.tgz
https://registry.npmjs.org/live-server/-/live-server-1.2.2.tgz -> npmpkg-live-server-1.2.2.tgz
https://registry.npmjs.org/anymatch/-/anymatch-2.0.0.tgz -> npmpkg-anymatch-2.0.0.tgz
https://registry.npmjs.org/binary-extensions/-/binary-extensions-1.13.1.tgz -> npmpkg-binary-extensions-1.13.1.tgz
https://registry.npmjs.org/braces/-/braces-2.3.2.tgz -> npmpkg-braces-2.3.2.tgz
https://registry.npmjs.org/chokidar/-/chokidar-2.1.8.tgz -> npmpkg-chokidar-2.1.8.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz -> npmpkg-normalize-path-3.0.0.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/fsevents/-/fsevents-1.2.13.tgz -> npmpkg-fsevents-1.2.13.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-3.1.0.tgz -> npmpkg-glob-parent-3.1.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-3.1.0.tgz -> npmpkg-is-glob-3.1.0.tgz
https://registry.npmjs.org/is-binary-path/-/is-binary-path-1.0.1.tgz -> npmpkg-is-binary-path-1.0.1.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/readdirp/-/readdirp-2.2.1.tgz -> npmpkg-readdirp-2.2.1.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/lodash.clonedeep/-/lodash.clonedeep-4.5.0.tgz -> npmpkg-lodash.clonedeep-4.5.0.tgz
https://registry.npmjs.org/lodash.debounce/-/lodash.debounce-4.0.8.tgz -> npmpkg-lodash.debounce-4.0.8.tgz
https://registry.npmjs.org/lodash.defaults/-/lodash.defaults-4.2.0.tgz -> npmpkg-lodash.defaults-4.2.0.tgz
https://registry.npmjs.org/lodash.isarray/-/lodash.isarray-4.0.0.tgz -> npmpkg-lodash.isarray-4.0.0.tgz
https://registry.npmjs.org/lodash.isempty/-/lodash.isempty-4.4.0.tgz -> npmpkg-lodash.isempty-4.4.0.tgz
https://registry.npmjs.org/lodash.isequal/-/lodash.isequal-4.5.0.tgz -> npmpkg-lodash.isequal-4.5.0.tgz
https://registry.npmjs.org/lodash.isfunction/-/lodash.isfunction-3.0.8.tgz -> npmpkg-lodash.isfunction-3.0.8.tgz
https://registry.npmjs.org/lodash.throttle/-/lodash.throttle-4.1.1.tgz -> npmpkg-lodash.throttle-4.1.1.tgz
https://registry.npmjs.org/lowercase-keys/-/lowercase-keys-2.0.0.tgz -> npmpkg-lowercase-keys-2.0.0.tgz
https://registry.npmjs.org/map-cache/-/map-cache-0.2.2.tgz -> npmpkg-map-cache-0.2.2.tgz
https://registry.npmjs.org/map-stream/-/map-stream-0.1.0.tgz -> npmpkg-map-stream-0.1.0.tgz
https://registry.npmjs.org/map-visit/-/map-visit-1.0.0.tgz -> npmpkg-map-visit-1.0.0.tgz
https://registry.npmjs.org/matcher/-/matcher-3.0.0.tgz -> npmpkg-matcher-3.0.0.tgz
https://registry.npmjs.org/micromatch/-/micromatch-3.1.10.tgz -> npmpkg-micromatch-3.1.10.tgz
https://registry.npmjs.org/mime-db/-/mime-db-1.30.0.tgz -> npmpkg-mime-db-1.30.0.tgz
https://registry.npmjs.org/mime-types/-/mime-types-2.1.17.tgz -> npmpkg-mime-types-2.1.17.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-1.0.1.tgz -> npmpkg-mimic-response-1.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.0.5.tgz -> npmpkg-minimatch-3.0.5.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.6.tgz -> npmpkg-minimist-1.2.6.tgz
https://registry.npmjs.org/mixin-deep/-/mixin-deep-1.3.2.tgz -> npmpkg-mixin-deep-1.3.2.tgz
https://registry.npmjs.org/morgan/-/morgan-1.9.1.tgz -> npmpkg-morgan-1.9.1.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/nan/-/nan-2.20.0.tgz -> npmpkg-nan-2.20.0.tgz
https://registry.npmjs.org/nanomatch/-/nanomatch-1.2.13.tgz -> npmpkg-nanomatch-1.2.13.tgz
https://registry.npmjs.org/negotiator/-/negotiator-0.6.1.tgz -> npmpkg-negotiator-0.6.1.tgz
https://registry.npmjs.org/node-addon-api/-/node-addon-api-1.7.2.tgz -> npmpkg-node-addon-api-1.7.2.tgz
https://registry.npmjs.org/node-fetch/-/node-fetch-2.6.7.tgz -> npmpkg-node-fetch-2.6.7.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-2.1.1.tgz -> npmpkg-normalize-path-2.1.1.tgz
https://registry.npmjs.org/normalize-url/-/normalize-url-6.1.0.tgz -> npmpkg-normalize-url-6.1.0.tgz
https://registry.npmjs.org/object-assign/-/object-assign-4.1.1.tgz -> npmpkg-object-assign-4.1.1.tgz
https://registry.npmjs.org/object-copy/-/object-copy-0.1.0.tgz -> npmpkg-object-copy-0.1.0.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.7.tgz -> npmpkg-is-descriptor-0.1.7.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/object-keys/-/object-keys-1.1.1.tgz -> npmpkg-object-keys-1.1.1.tgz
https://registry.npmjs.org/object-visit/-/object-visit-1.0.1.tgz -> npmpkg-object-visit-1.0.1.tgz
https://registry.npmjs.org/object.pick/-/object.pick-1.3.0.tgz -> npmpkg-object.pick-1.3.0.tgz
https://registry.npmjs.org/on-finished/-/on-finished-2.3.0.tgz -> npmpkg-on-finished-2.3.0.tgz
https://registry.npmjs.org/on-headers/-/on-headers-1.0.2.tgz -> npmpkg-on-headers-1.0.2.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz -> npmpkg-once-1.4.0.tgz
https://registry.npmjs.org/opn/-/opn-5.2.0.tgz -> npmpkg-opn-5.2.0.tgz
https://registry.npmjs.org/p-cancelable/-/p-cancelable-2.1.1.tgz -> npmpkg-p-cancelable-2.1.1.tgz
https://registry.npmjs.org/pako/-/pako-1.0.10.tgz -> npmpkg-pako-1.0.10.tgz
https://registry.npmjs.org/parseurl/-/parseurl-1.3.3.tgz -> npmpkg-parseurl-1.3.3.tgz
https://registry.npmjs.org/pascalcase/-/pascalcase-0.1.1.tgz -> npmpkg-pascalcase-0.1.1.tgz
https://registry.npmjs.org/path-dirname/-/path-dirname-1.0.2.tgz -> npmpkg-path-dirname-1.0.2.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> npmpkg-path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/pause-stream/-/pause-stream-0.0.11.tgz -> npmpkg-pause-stream-0.0.11.tgz
https://registry.npmjs.org/pend/-/pend-1.2.0.tgz -> npmpkg-pend-1.2.0.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.3.1.tgz -> npmpkg-picomatch-2.3.1.tgz
https://registry.npmjs.org/posix-character-classes/-/posix-character-classes-0.1.1.tgz -> npmpkg-posix-character-classes-0.1.1.tgz
https://registry.npmjs.org/process-nextick-args/-/process-nextick-args-2.0.1.tgz -> npmpkg-process-nextick-args-2.0.1.tgz
https://registry.npmjs.org/progress/-/progress-2.0.3.tgz -> npmpkg-progress-2.0.3.tgz
https://registry.npmjs.org/proxy-from-env/-/proxy-from-env-1.1.0.tgz -> npmpkg-proxy-from-env-1.1.0.tgz
https://registry.npmjs.org/proxy-middleware/-/proxy-middleware-0.15.0.tgz -> npmpkg-proxy-middleware-0.15.0.tgz
https://registry.npmjs.org/pump/-/pump-3.0.0.tgz -> npmpkg-pump-3.0.0.tgz
https://registry.npmjs.org/quick-lru/-/quick-lru-5.1.1.tgz -> npmpkg-quick-lru-5.1.1.tgz
https://registry.npmjs.org/range-parser/-/range-parser-1.2.0.tgz -> npmpkg-range-parser-1.2.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/readdirp/-/readdirp-3.6.0.tgz -> npmpkg-readdirp-3.6.0.tgz
https://registry.npmjs.org/regex-not/-/regex-not-1.0.2.tgz -> npmpkg-regex-not-1.0.2.tgz
https://registry.npmjs.org/remove-trailing-separator/-/remove-trailing-separator-1.1.0.tgz -> npmpkg-remove-trailing-separator-1.1.0.tgz
https://registry.npmjs.org/repeat-element/-/repeat-element-1.1.4.tgz -> npmpkg-repeat-element-1.1.4.tgz
https://registry.npmjs.org/repeat-string/-/repeat-string-1.6.1.tgz -> npmpkg-repeat-string-1.6.1.tgz
https://registry.npmjs.org/resolve-alpn/-/resolve-alpn-1.2.1.tgz -> npmpkg-resolve-alpn-1.2.1.tgz
https://registry.npmjs.org/resolve-url/-/resolve-url-0.2.1.tgz -> npmpkg-resolve-url-0.2.1.tgz
https://registry.npmjs.org/responselike/-/responselike-2.0.1.tgz -> npmpkg-responselike-2.0.1.tgz
https://registry.npmjs.org/ret/-/ret-0.1.15.tgz -> npmpkg-ret-0.1.15.tgz
https://registry.npmjs.org/roarr/-/roarr-2.15.4.tgz -> npmpkg-roarr-2.15.4.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.1.3.tgz -> npmpkg-sprintf-js-1.1.3.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/safe-regex/-/safe-regex-1.1.0.tgz -> npmpkg-safe-regex-1.1.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/semver-compare/-/semver-compare-1.0.0.tgz -> npmpkg-semver-compare-1.0.0.tgz
https://registry.npmjs.org/send/-/send-0.16.2.tgz -> npmpkg-send-0.16.2.tgz
https://registry.npmjs.org/mime/-/mime-1.4.1.tgz -> npmpkg-mime-1.4.1.tgz
https://registry.npmjs.org/statuses/-/statuses-1.4.0.tgz -> npmpkg-statuses-1.4.0.tgz
https://registry.npmjs.org/serialize-error/-/serialize-error-7.0.1.tgz -> npmpkg-serialize-error-7.0.1.tgz
https://registry.npmjs.org/serve-index/-/serve-index-1.9.1.tgz -> npmpkg-serve-index-1.9.1.tgz
https://registry.npmjs.org/set-value/-/set-value-2.0.1.tgz -> npmpkg-set-value-2.0.1.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/setprototypeof/-/setprototypeof-1.0.3.tgz -> npmpkg-setprototypeof-1.0.3.tgz
https://registry.npmjs.org/snapdragon/-/snapdragon-0.8.2.tgz -> npmpkg-snapdragon-0.8.2.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.7.tgz -> npmpkg-is-descriptor-0.1.7.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/snapdragon-node/-/snapdragon-node-2.1.1.tgz -> npmpkg-snapdragon-node-2.1.1.tgz
https://registry.npmjs.org/define-property/-/define-property-1.0.0.tgz -> npmpkg-define-property-1.0.0.tgz
https://registry.npmjs.org/snapdragon-util/-/snapdragon-util-3.0.1.tgz -> npmpkg-snapdragon-util-3.0.1.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/source-map/-/source-map-0.5.7.tgz -> npmpkg-source-map-0.5.7.tgz
https://registry.npmjs.org/source-map-resolve/-/source-map-resolve-0.5.3.tgz -> npmpkg-source-map-resolve-0.5.3.tgz
https://registry.npmjs.org/source-map-url/-/source-map-url-0.4.1.tgz -> npmpkg-source-map-url-0.4.1.tgz
https://registry.npmjs.org/split/-/split-0.3.3.tgz -> npmpkg-split-0.3.3.tgz
https://registry.npmjs.org/split-string/-/split-string-3.1.0.tgz -> npmpkg-split-string-3.1.0.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.0.3.tgz -> npmpkg-sprintf-js-1.0.3.tgz
https://registry.npmjs.org/static-extend/-/static-extend-0.1.2.tgz -> npmpkg-static-extend-0.1.2.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.7.tgz -> npmpkg-is-descriptor-0.1.7.tgz
https://registry.npmjs.org/statuses/-/statuses-1.5.0.tgz -> npmpkg-statuses-1.5.0.tgz
https://registry.npmjs.org/steamworks.js/-/steamworks.js-0.3.1.tgz -> npmpkg-steamworks.js-0.3.1.tgz
https://registry.npmjs.org/stream-combiner/-/stream-combiner-0.0.4.tgz -> npmpkg-stream-combiner-0.0.4.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-1.1.1.tgz -> npmpkg-string_decoder-1.1.1.tgz
https://registry.npmjs.org/sumchecker/-/sumchecker-3.0.1.tgz -> npmpkg-sumchecker-3.0.1.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/tar-stream/-/tar-stream-1.5.5.tgz -> npmpkg-tar-stream-1.5.5.tgz
https://registry.npmjs.org/through/-/through-2.3.8.tgz -> npmpkg-through-2.3.8.tgz
https://registry.npmjs.org/to-object-path/-/to-object-path-0.3.0.tgz -> npmpkg-to-object-path-0.3.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/to-regex/-/to-regex-3.0.2.tgz -> npmpkg-to-regex-3.0.2.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-2.1.1.tgz -> npmpkg-to-regex-range-2.1.1.tgz
https://registry.npmjs.org/tr46/-/tr46-0.0.3.tgz -> npmpkg-tr46-0.0.3.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.13.1.tgz -> npmpkg-type-fest-0.13.1.tgz
https://registry.npmjs.org/union-value/-/union-value-1.0.1.tgz -> npmpkg-union-value-1.0.1.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/universalify/-/universalify-0.1.1.tgz -> npmpkg-universalify-0.1.1.tgz
https://registry.npmjs.org/unix-crypt-td-js/-/unix-crypt-td-js-1.0.0.tgz -> npmpkg-unix-crypt-td-js-1.0.0.tgz
https://registry.npmjs.org/unpipe/-/unpipe-1.0.0.tgz -> npmpkg-unpipe-1.0.0.tgz
https://registry.npmjs.org/unset-value/-/unset-value-1.0.0.tgz -> npmpkg-unset-value-1.0.0.tgz
https://registry.npmjs.org/has-value/-/has-value-0.3.1.tgz -> npmpkg-has-value-0.3.1.tgz
https://registry.npmjs.org/isobject/-/isobject-2.1.0.tgz -> npmpkg-isobject-2.1.0.tgz
https://registry.npmjs.org/has-values/-/has-values-0.1.4.tgz -> npmpkg-has-values-0.1.4.tgz
https://registry.npmjs.org/upath/-/upath-1.2.0.tgz -> npmpkg-upath-1.2.0.tgz
https://registry.npmjs.org/urix/-/urix-0.1.0.tgz -> npmpkg-urix-0.1.0.tgz
https://registry.npmjs.org/use/-/use-3.1.1.tgz -> npmpkg-use-3.1.1.tgz
https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz -> npmpkg-util-deprecate-1.0.2.tgz
https://registry.npmjs.org/utils-merge/-/utils-merge-1.0.1.tgz -> npmpkg-utils-merge-1.0.1.tgz
https://registry.npmjs.org/uuid/-/uuid-3.1.0.tgz -> npmpkg-uuid-3.1.0.tgz
https://registry.npmjs.org/vary/-/vary-1.1.2.tgz -> npmpkg-vary-1.1.2.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-3.0.1.tgz -> npmpkg-webidl-conversions-3.0.1.tgz
https://registry.npmjs.org/websocket-driver/-/websocket-driver-0.7.0.tgz -> npmpkg-websocket-driver-0.7.0.tgz
https://registry.npmjs.org/websocket-extensions/-/websocket-extensions-0.1.4.tgz -> npmpkg-websocket-extensions-0.1.4.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-5.0.0.tgz -> npmpkg-whatwg-url-5.0.0.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
https://registry.npmjs.org/ws/-/ws-7.5.10.tgz -> npmpkg-ws-7.5.10.tgz
https://registry.npmjs.org/xtend/-/xtend-4.0.1.tgz -> npmpkg-xtend-4.0.1.tgz
https://registry.npmjs.org/yauzl/-/yauzl-2.10.0.tgz -> npmpkg-yauzl-2.10.0.tgz
https://registry.npmjs.org/zip-stream/-/zip-stream-1.2.0.tgz -> npmpkg-zip-stream-1.2.0.tgz
https://registry.npmjs.org/@develar/schema-utils/-/schema-utils-2.6.5.tgz -> npmpkg-@develar-schema-utils-2.6.5.tgz
https://registry.npmjs.org/@electron/asar/-/asar-3.2.13.tgz -> npmpkg-@electron-asar-3.2.13.tgz
https://registry.npmjs.org/@electron/get/-/get-2.0.3.tgz -> npmpkg-@electron-get-2.0.3.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/@electron/notarize/-/notarize-2.2.1.tgz -> npmpkg-@electron-notarize-2.2.1.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-9.1.0.tgz -> npmpkg-fs-extra-9.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/@electron/osx-sign/-/osx-sign-1.0.5.tgz -> npmpkg-@electron-osx-sign-1.0.5.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/isbinaryfile/-/isbinaryfile-4.0.10.tgz -> npmpkg-isbinaryfile-4.0.10.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/@electron/remote/-/remote-2.0.8.tgz -> npmpkg-@electron-remote-2.0.8.tgz
https://registry.npmjs.org/@electron/universal/-/universal-1.5.1.tgz -> npmpkg-@electron-universal-1.5.1.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-9.1.0.tgz -> npmpkg-fs-extra-9.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/@isaacs/cliui/-/cliui-8.0.2.tgz -> npmpkg-@isaacs-cliui-8.0.2.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-6.1.0.tgz -> npmpkg-ansi-regex-6.1.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-6.2.1.tgz -> npmpkg-ansi-styles-6.2.1.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-9.2.2.tgz -> npmpkg-emoji-regex-9.2.2.tgz
https://registry.npmjs.org/string-width/-/string-width-5.1.2.tgz -> npmpkg-string-width-5.1.2.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-7.1.0.tgz -> npmpkg-strip-ansi-7.1.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-8.1.0.tgz -> npmpkg-wrap-ansi-8.1.0.tgz
https://registry.npmjs.org/@malept/cross-spawn-promise/-/cross-spawn-promise-1.1.1.tgz -> npmpkg-@malept-cross-spawn-promise-1.1.1.tgz
https://registry.npmjs.org/@malept/flatpak-bundler/-/flatpak-bundler-0.4.0.tgz -> npmpkg-@malept-flatpak-bundler-0.4.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-9.1.0.tgz -> npmpkg-fs-extra-9.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/@pkgjs/parseargs/-/parseargs-0.11.0.tgz -> npmpkg-@pkgjs-parseargs-0.11.0.tgz
https://registry.npmjs.org/@sindresorhus/is/-/is-4.6.0.tgz -> npmpkg-@sindresorhus-is-4.6.0.tgz
https://registry.npmjs.org/@szmarczak/http-timer/-/http-timer-4.0.6.tgz -> npmpkg-@szmarczak-http-timer-4.0.6.tgz
https://registry.npmjs.org/@tootallnate/once/-/once-2.0.0.tgz -> npmpkg-@tootallnate-once-2.0.0.tgz
https://registry.npmjs.org/@types/cacheable-request/-/cacheable-request-6.0.3.tgz -> npmpkg-@types-cacheable-request-6.0.3.tgz
https://registry.npmjs.org/@types/debug/-/debug-4.1.12.tgz -> npmpkg-@types-debug-4.1.12.tgz
https://registry.npmjs.org/@types/fs-extra/-/fs-extra-9.0.13.tgz -> npmpkg-@types-fs-extra-9.0.13.tgz
https://registry.npmjs.org/@types/glob/-/glob-7.2.0.tgz -> npmpkg-@types-glob-7.2.0.tgz
https://registry.npmjs.org/@types/http-cache-semantics/-/http-cache-semantics-4.0.4.tgz -> npmpkg-@types-http-cache-semantics-4.0.4.tgz
https://registry.npmjs.org/@types/keyv/-/keyv-3.1.4.tgz -> npmpkg-@types-keyv-3.1.4.tgz
https://registry.npmjs.org/@types/minimatch/-/minimatch-5.1.2.tgz -> npmpkg-@types-minimatch-5.1.2.tgz
https://registry.npmjs.org/@types/ms/-/ms-0.7.34.tgz -> npmpkg-@types-ms-0.7.34.tgz
https://registry.npmjs.org/@types/node/-/node-16.11.33.tgz -> npmpkg-@types-node-16.11.33.tgz
https://registry.npmjs.org/@types/plist/-/plist-3.0.5.tgz -> npmpkg-@types-plist-3.0.5.tgz
https://registry.npmjs.org/@types/responselike/-/responselike-1.0.3.tgz -> npmpkg-@types-responselike-1.0.3.tgz
https://registry.npmjs.org/@types/verror/-/verror-1.10.9.tgz -> npmpkg-@types-verror-1.10.9.tgz
https://registry.npmjs.org/@types/yauzl/-/yauzl-2.10.3.tgz -> npmpkg-@types-yauzl-2.10.3.tgz
https://registry.npmjs.org/@xmldom/xmldom/-/xmldom-0.8.10.tgz -> npmpkg-@xmldom-xmldom-0.8.10.tgz
https://registry.npmjs.org/7zip-bin/-/7zip-bin-5.2.0.tgz -> npmpkg-7zip-bin-5.2.0.tgz
https://registry.npmjs.org/adm-zip/-/adm-zip-0.5.10.tgz -> npmpkg-adm-zip-0.5.10.tgz
https://registry.npmjs.org/agent-base/-/agent-base-6.0.2.tgz -> npmpkg-agent-base-6.0.2.tgz
https://registry.npmjs.org/ajv/-/ajv-6.12.6.tgz -> npmpkg-ajv-6.12.6.tgz
https://registry.npmjs.org/ajv-keywords/-/ajv-keywords-3.5.2.tgz -> npmpkg-ajv-keywords-3.5.2.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/app-builder-bin/-/app-builder-bin-4.0.0.tgz -> npmpkg-app-builder-bin-4.0.0.tgz
https://registry.npmjs.org/app-builder-lib/-/app-builder-lib-24.13.2.tgz -> npmpkg-app-builder-lib-24.13.2.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/builder-util/-/builder-util-24.13.1.tgz -> npmpkg-builder-util-24.13.1.tgz
https://registry.npmjs.org/builder-util-runtime/-/builder-util-runtime-9.2.4.tgz -> npmpkg-builder-util-runtime-9.2.4.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/minimatch/-/minimatch-5.1.6.tgz -> npmpkg-minimatch-5.1.6.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/archiver/-/archiver-5.3.2.tgz -> npmpkg-archiver-5.3.2.tgz
https://registry.npmjs.org/archiver-utils/-/archiver-utils-2.1.0.tgz -> npmpkg-archiver-utils-2.1.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/argparse/-/argparse-2.0.1.tgz -> npmpkg-argparse-2.0.1.tgz
https://registry.npmjs.org/assert-plus/-/assert-plus-1.0.0.tgz -> npmpkg-assert-plus-1.0.0.tgz
https://registry.npmjs.org/astral-regex/-/astral-regex-2.0.0.tgz -> npmpkg-astral-regex-2.0.0.tgz
https://registry.npmjs.org/async/-/async-3.2.5.tgz -> npmpkg-async-3.2.5.tgz
https://registry.npmjs.org/async-exit-hook/-/async-exit-hook-2.0.1.tgz -> npmpkg-async-exit-hook-2.0.1.tgz
https://registry.npmjs.org/asynckit/-/asynckit-0.4.0.tgz -> npmpkg-asynckit-0.4.0.tgz
https://registry.npmjs.org/at-least-node/-/at-least-node-1.0.0.tgz -> npmpkg-at-least-node-1.0.0.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.0.tgz -> npmpkg-balanced-match-1.0.0.tgz
https://registry.npmjs.org/base64-js/-/base64-js-1.5.1.tgz -> npmpkg-base64-js-1.5.1.tgz
https://registry.npmjs.org/bl/-/bl-4.1.0.tgz -> npmpkg-bl-4.1.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/bluebird/-/bluebird-3.7.2.tgz -> npmpkg-bluebird-3.7.2.tgz
https://registry.npmjs.org/bluebird-lst/-/bluebird-lst-1.0.9.tgz -> npmpkg-bluebird-lst-1.0.9.tgz
https://registry.npmjs.org/boolean/-/boolean-3.2.0.tgz -> npmpkg-boolean-3.2.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/buffer/-/buffer-5.7.1.tgz -> npmpkg-buffer-5.7.1.tgz
https://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.2.13.tgz -> npmpkg-buffer-crc32-0.2.13.tgz
https://registry.npmjs.org/buffer-equal/-/buffer-equal-1.0.1.tgz -> npmpkg-buffer-equal-1.0.1.tgz
https://registry.npmjs.org/buffer-from/-/buffer-from-1.1.2.tgz -> npmpkg-buffer-from-1.1.2.tgz
https://registry.npmjs.org/builder-util/-/builder-util-24.8.1.tgz -> npmpkg-builder-util-24.8.1.tgz
https://registry.npmjs.org/builder-util-runtime/-/builder-util-runtime-9.2.3.tgz -> npmpkg-builder-util-runtime-9.2.3.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/cacheable-lookup/-/cacheable-lookup-5.0.4.tgz -> npmpkg-cacheable-lookup-5.0.4.tgz
https://registry.npmjs.org/cacheable-request/-/cacheable-request-7.0.4.tgz -> npmpkg-cacheable-request-7.0.4.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/chownr/-/chownr-2.0.0.tgz -> npmpkg-chownr-2.0.0.tgz
https://registry.npmjs.org/chromium-pickle-js/-/chromium-pickle-js-0.2.0.tgz -> npmpkg-chromium-pickle-js-0.2.0.tgz
https://registry.npmjs.org/ci-info/-/ci-info-3.9.0.tgz -> npmpkg-ci-info-3.9.0.tgz
https://registry.npmjs.org/cli-truncate/-/cli-truncate-2.1.0.tgz -> npmpkg-cli-truncate-2.1.0.tgz
https://registry.npmjs.org/cliui/-/cliui-8.0.1.tgz -> npmpkg-cliui-8.0.1.tgz
https://registry.npmjs.org/clone-response/-/clone-response-1.0.3.tgz -> npmpkg-clone-response-1.0.3.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/combined-stream/-/combined-stream-1.0.8.tgz -> npmpkg-combined-stream-1.0.8.tgz
https://registry.npmjs.org/commander/-/commander-5.1.0.tgz -> npmpkg-commander-5.1.0.tgz
https://registry.npmjs.org/compare-version/-/compare-version-0.1.2.tgz -> npmpkg-compare-version-0.1.2.tgz
https://registry.npmjs.org/compress-commons/-/compress-commons-4.1.2.tgz -> npmpkg-compress-commons-4.1.2.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/config-file-ts/-/config-file-ts-0.2.6.tgz -> npmpkg-config-file-ts-0.2.6.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/glob/-/glob-10.4.5.tgz -> npmpkg-glob-10.4.5.tgz
https://registry.npmjs.org/minimatch/-/minimatch-9.0.5.tgz -> npmpkg-minimatch-9.0.5.tgz
https://registry.npmjs.org/minipass/-/minipass-7.1.2.tgz -> npmpkg-minipass-7.1.2.tgz
https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.2.tgz -> npmpkg-core-util-is-1.0.2.tgz
https://registry.npmjs.org/crc/-/crc-3.8.0.tgz -> npmpkg-crc-3.8.0.tgz
https://registry.npmjs.org/crc-32/-/crc-32-1.2.2.tgz -> npmpkg-crc-32-1.2.2.tgz
https://registry.npmjs.org/crc32-stream/-/crc32-stream-4.0.3.tgz -> npmpkg-crc32-stream-4.0.3.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz -> npmpkg-cross-spawn-7.0.3.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/decompress-response/-/decompress-response-6.0.0.tgz -> npmpkg-decompress-response-6.0.0.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-3.1.0.tgz -> npmpkg-mimic-response-3.1.0.tgz
https://registry.npmjs.org/defer-to-connect/-/defer-to-connect-2.0.1.tgz -> npmpkg-defer-to-connect-2.0.1.tgz
https://registry.npmjs.org/define-data-property/-/define-data-property-1.1.4.tgz -> npmpkg-define-data-property-1.1.4.tgz
https://registry.npmjs.org/define-properties/-/define-properties-1.2.1.tgz -> npmpkg-define-properties-1.2.1.tgz
https://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz -> npmpkg-delayed-stream-1.0.0.tgz
https://registry.npmjs.org/detect-node/-/detect-node-2.1.0.tgz -> npmpkg-detect-node-2.1.0.tgz
https://registry.npmjs.org/dir-compare/-/dir-compare-3.3.0.tgz -> npmpkg-dir-compare-3.3.0.tgz
https://registry.npmjs.org/dmg-builder/-/dmg-builder-24.13.2.tgz -> npmpkg-dmg-builder-24.13.2.tgz
https://registry.npmjs.org/builder-util/-/builder-util-24.13.1.tgz -> npmpkg-builder-util-24.13.1.tgz
https://registry.npmjs.org/builder-util-runtime/-/builder-util-runtime-9.2.4.tgz -> npmpkg-builder-util-runtime-9.2.4.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/dmg-license/-/dmg-license-1.0.11.tgz -> npmpkg-dmg-license-1.0.11.tgz
https://registry.npmjs.org/dotenv/-/dotenv-8.6.0.tgz -> npmpkg-dotenv-8.6.0.tgz
https://registry.npmjs.org/dotenv-expand/-/dotenv-expand-5.1.0.tgz -> npmpkg-dotenv-expand-5.1.0.tgz
https://registry.npmjs.org/eastasianwidth/-/eastasianwidth-0.2.0.tgz -> npmpkg-eastasianwidth-0.2.0.tgz
https://registry.npmjs.org/ejs/-/ejs-3.1.10.tgz -> npmpkg-ejs-3.1.10.tgz
https://registry.npmjs.org/electron/-/electron-22.3.27.tgz -> npmpkg-electron-22.3.27.tgz
https://registry.npmjs.org/electron-builder/-/electron-builder-24.9.1.tgz -> npmpkg-electron-builder-24.9.1.tgz
https://registry.npmjs.org/electron-builder-squirrel-windows/-/electron-builder-squirrel-windows-24.13.2.tgz -> npmpkg-electron-builder-squirrel-windows-24.13.2.tgz
https://registry.npmjs.org/builder-util/-/builder-util-24.13.1.tgz -> npmpkg-builder-util-24.13.1.tgz
https://registry.npmjs.org/builder-util-runtime/-/builder-util-runtime-9.2.4.tgz -> npmpkg-builder-util-runtime-9.2.4.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/dmg-builder/-/dmg-builder-24.9.1.tgz -> npmpkg-dmg-builder-24.9.1.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/electron-is/-/electron-is-2.4.1.tgz -> npmpkg-electron-is-2.4.1.tgz
https://registry.npmjs.org/electron-is-dev/-/electron-is-dev-0.3.0.tgz -> npmpkg-electron-is-dev-0.3.0.tgz
https://registry.npmjs.org/electron-publish/-/electron-publish-24.13.1.tgz -> npmpkg-electron-publish-24.13.1.tgz
https://registry.npmjs.org/builder-util/-/builder-util-24.13.1.tgz -> npmpkg-builder-util-24.13.1.tgz
https://registry.npmjs.org/builder-util-runtime/-/builder-util-runtime-9.2.4.tgz -> npmpkg-builder-util-runtime-9.2.4.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.4.4.tgz -> npmpkg-end-of-stream-1.4.4.tgz
https://registry.npmjs.org/env-paths/-/env-paths-2.2.1.tgz -> npmpkg-env-paths-2.2.1.tgz
https://registry.npmjs.org/err-code/-/err-code-2.0.3.tgz -> npmpkg-err-code-2.0.3.tgz
https://registry.npmjs.org/es-define-property/-/es-define-property-1.0.0.tgz -> npmpkg-es-define-property-1.0.0.tgz
https://registry.npmjs.org/es-errors/-/es-errors-1.3.0.tgz -> npmpkg-es-errors-1.3.0.tgz
https://registry.npmjs.org/es6-error/-/es6-error-4.1.1.tgz -> npmpkg-es6-error-4.1.1.tgz
https://registry.npmjs.org/escalade/-/escalade-3.1.1.tgz -> npmpkg-escalade-3.1.1.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz -> npmpkg-escape-string-regexp-4.0.0.tgz
https://registry.npmjs.org/extract-zip/-/extract-zip-2.0.1.tgz -> npmpkg-extract-zip-2.0.1.tgz
https://registry.npmjs.org/extsprintf/-/extsprintf-1.4.1.tgz -> npmpkg-extsprintf-1.4.1.tgz
https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz -> npmpkg-fast-deep-equal-3.1.3.tgz
https://registry.npmjs.org/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz -> npmpkg-fast-json-stable-stringify-2.1.0.tgz
https://registry.npmjs.org/fd-slicer/-/fd-slicer-1.1.0.tgz -> npmpkg-fd-slicer-1.1.0.tgz
https://registry.npmjs.org/filelist/-/filelist-1.0.4.tgz -> npmpkg-filelist-1.0.4.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-5.1.6.tgz -> npmpkg-minimatch-5.1.6.tgz
https://registry.npmjs.org/foreground-child/-/foreground-child-3.1.1.tgz -> npmpkg-foreground-child-3.1.1.tgz
https://registry.npmjs.org/form-data/-/form-data-4.0.0.tgz -> npmpkg-form-data-4.0.0.tgz
https://registry.npmjs.org/fs-constants/-/fs-constants-1.0.0.tgz -> npmpkg-fs-constants-1.0.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/fs-minipass/-/fs-minipass-2.1.0.tgz -> npmpkg-fs-minipass-2.1.0.tgz
https://registry.npmjs.org/minipass/-/minipass-3.3.6.tgz -> npmpkg-minipass-3.3.6.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz -> npmpkg-fs.realpath-1.0.0.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.2.tgz -> npmpkg-function-bind-1.1.2.tgz
https://registry.npmjs.org/get-caller-file/-/get-caller-file-2.0.5.tgz -> npmpkg-get-caller-file-2.0.5.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.2.4.tgz -> npmpkg-get-intrinsic-1.2.4.tgz
https://registry.npmjs.org/get-stream/-/get-stream-5.2.0.tgz -> npmpkg-get-stream-5.2.0.tgz
https://registry.npmjs.org/glob/-/glob-7.2.3.tgz -> npmpkg-glob-7.2.3.tgz
https://registry.npmjs.org/global-agent/-/global-agent-3.0.0.tgz -> npmpkg-global-agent-3.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/globalthis/-/globalthis-1.0.4.tgz -> npmpkg-globalthis-1.0.4.tgz
https://registry.npmjs.org/gopd/-/gopd-1.0.1.tgz -> npmpkg-gopd-1.0.1.tgz
https://registry.npmjs.org/got/-/got-11.8.6.tgz -> npmpkg-got-11.8.6.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.4.tgz -> npmpkg-graceful-fs-4.2.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/has-property-descriptors/-/has-property-descriptors-1.0.2.tgz -> npmpkg-has-property-descriptors-1.0.2.tgz
https://registry.npmjs.org/has-proto/-/has-proto-1.0.3.tgz -> npmpkg-has-proto-1.0.3.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.0.3.tgz -> npmpkg-has-symbols-1.0.3.tgz
https://registry.npmjs.org/hasown/-/hasown-2.0.2.tgz -> npmpkg-hasown-2.0.2.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-4.1.0.tgz -> npmpkg-hosted-git-info-4.1.0.tgz
https://registry.npmjs.org/http-cache-semantics/-/http-cache-semantics-4.1.1.tgz -> npmpkg-http-cache-semantics-4.1.1.tgz
https://registry.npmjs.org/http-proxy-agent/-/http-proxy-agent-5.0.0.tgz -> npmpkg-http-proxy-agent-5.0.0.tgz
https://registry.npmjs.org/http2-wrapper/-/http2-wrapper-1.0.3.tgz -> npmpkg-http2-wrapper-1.0.3.tgz
https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-5.0.1.tgz -> npmpkg-https-proxy-agent-5.0.1.tgz
https://registry.npmjs.org/iconv-corefoundation/-/iconv-corefoundation-1.1.7.tgz -> npmpkg-iconv-corefoundation-1.1.7.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.6.3.tgz -> npmpkg-iconv-lite-0.6.3.tgz
https://registry.npmjs.org/ieee754/-/ieee754-1.2.1.tgz -> npmpkg-ieee754-1.2.1.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz -> npmpkg-inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz -> npmpkg-inherits-2.0.4.tgz
https://registry.npmjs.org/interpret/-/interpret-1.4.0.tgz -> npmpkg-interpret-1.4.0.tgz
https://registry.npmjs.org/is-ci/-/is-ci-3.0.1.tgz -> npmpkg-is-ci-3.0.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> npmpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/isbinaryfile/-/isbinaryfile-5.0.2.tgz -> npmpkg-isbinaryfile-5.0.2.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz -> npmpkg-isexe-2.0.0.tgz
https://registry.npmjs.org/jackspeak/-/jackspeak-3.4.3.tgz -> npmpkg-jackspeak-3.4.3.tgz
https://registry.npmjs.org/jake/-/jake-10.8.7.tgz -> npmpkg-jake-10.8.7.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-4.1.0.tgz -> npmpkg-js-yaml-4.1.0.tgz
https://registry.npmjs.org/json-buffer/-/json-buffer-3.0.1.tgz -> npmpkg-json-buffer-3.0.1.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz -> npmpkg-json-schema-traverse-0.4.1.tgz
https://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz -> npmpkg-json-stringify-safe-5.0.1.tgz
https://registry.npmjs.org/json5/-/json5-2.2.3.tgz -> npmpkg-json5-2.2.3.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-4.0.0.tgz -> npmpkg-jsonfile-4.0.0.tgz
https://registry.npmjs.org/keyv/-/keyv-4.5.4.tgz -> npmpkg-keyv-4.5.4.tgz
https://registry.npmjs.org/lazy-val/-/lazy-val-1.0.5.tgz -> npmpkg-lazy-val-1.0.5.tgz
https://registry.npmjs.org/lazystream/-/lazystream-1.0.1.tgz -> npmpkg-lazystream-1.0.1.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/lodash.defaults/-/lodash.defaults-4.2.0.tgz -> npmpkg-lodash.defaults-4.2.0.tgz
https://registry.npmjs.org/lodash.difference/-/lodash.difference-4.5.0.tgz -> npmpkg-lodash.difference-4.5.0.tgz
https://registry.npmjs.org/lodash.flatten/-/lodash.flatten-4.4.0.tgz -> npmpkg-lodash.flatten-4.4.0.tgz
https://registry.npmjs.org/lodash.isplainobject/-/lodash.isplainobject-4.0.6.tgz -> npmpkg-lodash.isplainobject-4.0.6.tgz
https://registry.npmjs.org/lodash.union/-/lodash.union-4.6.0.tgz -> npmpkg-lodash.union-4.6.0.tgz
https://registry.npmjs.org/lowercase-keys/-/lowercase-keys-2.0.0.tgz -> npmpkg-lowercase-keys-2.0.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/matcher/-/matcher-3.0.0.tgz -> npmpkg-matcher-3.0.0.tgz
https://registry.npmjs.org/mime/-/mime-2.6.0.tgz -> npmpkg-mime-2.6.0.tgz
https://registry.npmjs.org/mime-db/-/mime-db-1.52.0.tgz -> npmpkg-mime-db-1.52.0.tgz
https://registry.npmjs.org/mime-types/-/mime-types-2.1.35.tgz -> npmpkg-mime-types-2.1.35.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-1.0.1.tgz -> npmpkg-mimic-response-1.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.8.tgz -> npmpkg-minimist-1.2.8.tgz
https://registry.npmjs.org/minipass/-/minipass-5.0.0.tgz -> npmpkg-minipass-5.0.0.tgz
https://registry.npmjs.org/minizlib/-/minizlib-2.1.2.tgz -> npmpkg-minizlib-2.1.2.tgz
https://registry.npmjs.org/minipass/-/minipass-3.3.6.tgz -> npmpkg-minipass-3.3.6.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/node-addon-api/-/node-addon-api-1.7.2.tgz -> npmpkg-node-addon-api-1.7.2.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz -> npmpkg-normalize-path-3.0.0.tgz
https://registry.npmjs.org/normalize-url/-/normalize-url-6.1.0.tgz -> npmpkg-normalize-url-6.1.0.tgz
https://registry.npmjs.org/object-keys/-/object-keys-1.1.1.tgz -> npmpkg-object-keys-1.1.1.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz -> npmpkg-once-1.4.0.tgz
https://registry.npmjs.org/p-cancelable/-/p-cancelable-2.1.1.tgz -> npmpkg-p-cancelable-2.1.1.tgz
https://registry.npmjs.org/package-json-from-dist/-/package-json-from-dist-1.0.1.tgz -> npmpkg-package-json-from-dist-1.0.1.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> npmpkg-path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/path-parse/-/path-parse-1.0.6.tgz -> npmpkg-path-parse-1.0.6.tgz
https://registry.npmjs.org/path-scurry/-/path-scurry-1.11.1.tgz -> npmpkg-path-scurry-1.11.1.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-10.4.3.tgz -> npmpkg-lru-cache-10.4.3.tgz
https://registry.npmjs.org/pend/-/pend-1.2.0.tgz -> npmpkg-pend-1.2.0.tgz
https://registry.npmjs.org/plist/-/plist-3.1.0.tgz -> npmpkg-plist-3.1.0.tgz
https://registry.npmjs.org/prettier/-/prettier-1.15.3.tgz -> npmpkg-prettier-1.15.3.tgz
https://registry.npmjs.org/process-nextick-args/-/process-nextick-args-2.0.1.tgz -> npmpkg-process-nextick-args-2.0.1.tgz
https://registry.npmjs.org/progress/-/progress-2.0.3.tgz -> npmpkg-progress-2.0.3.tgz
https://registry.npmjs.org/promise-retry/-/promise-retry-2.0.1.tgz -> npmpkg-promise-retry-2.0.1.tgz
https://registry.npmjs.org/pump/-/pump-3.0.2.tgz -> npmpkg-pump-3.0.2.tgz
https://registry.npmjs.org/punycode/-/punycode-2.3.1.tgz -> npmpkg-punycode-2.3.1.tgz
https://registry.npmjs.org/quick-lru/-/quick-lru-5.1.1.tgz -> npmpkg-quick-lru-5.1.1.tgz
https://registry.npmjs.org/read-config-file/-/read-config-file-6.3.2.tgz -> npmpkg-read-config-file-6.3.2.tgz
https://registry.npmjs.org/dotenv/-/dotenv-9.0.2.tgz -> npmpkg-dotenv-9.0.2.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/readdir-glob/-/readdir-glob-1.1.3.tgz -> npmpkg-readdir-glob-1.1.3.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-5.1.6.tgz -> npmpkg-minimatch-5.1.6.tgz
https://registry.npmjs.org/rechoir/-/rechoir-0.6.2.tgz -> npmpkg-rechoir-0.6.2.tgz
https://registry.npmjs.org/require-directory/-/require-directory-2.1.1.tgz -> npmpkg-require-directory-2.1.1.tgz
https://registry.npmjs.org/resolve/-/resolve-1.17.0.tgz -> npmpkg-resolve-1.17.0.tgz
https://registry.npmjs.org/resolve-alpn/-/resolve-alpn-1.2.1.tgz -> npmpkg-resolve-alpn-1.2.1.tgz
https://registry.npmjs.org/responselike/-/responselike-2.0.1.tgz -> npmpkg-responselike-2.0.1.tgz
https://registry.npmjs.org/retry/-/retry-0.12.0.tgz -> npmpkg-retry-0.12.0.tgz
https://registry.npmjs.org/rimraf/-/rimraf-3.0.2.tgz -> npmpkg-rimraf-3.0.2.tgz
https://registry.npmjs.org/roarr/-/roarr-2.15.4.tgz -> npmpkg-roarr-2.15.4.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/safer-buffer/-/safer-buffer-2.1.2.tgz -> npmpkg-safer-buffer-2.1.2.tgz
https://registry.npmjs.org/sanitize-filename/-/sanitize-filename-1.6.3.tgz -> npmpkg-sanitize-filename-1.6.3.tgz
https://registry.npmjs.org/sax/-/sax-1.3.0.tgz -> npmpkg-sax-1.3.0.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/semver-compare/-/semver-compare-1.0.0.tgz -> npmpkg-semver-compare-1.0.0.tgz
https://registry.npmjs.org/serialize-error/-/serialize-error-7.0.1.tgz -> npmpkg-serialize-error-7.0.1.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/shelljs/-/shelljs-0.8.5.tgz -> npmpkg-shelljs-0.8.5.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-4.1.0.tgz -> npmpkg-signal-exit-4.1.0.tgz
https://registry.npmjs.org/simple-update-notifier/-/simple-update-notifier-2.0.0.tgz -> npmpkg-simple-update-notifier-2.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/slice-ansi/-/slice-ansi-3.0.0.tgz -> npmpkg-slice-ansi-3.0.0.tgz
https://registry.npmjs.org/smart-buffer/-/smart-buffer-4.2.0.tgz -> npmpkg-smart-buffer-4.2.0.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/source-map-support/-/source-map-support-0.5.21.tgz -> npmpkg-source-map-support-0.5.21.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.1.3.tgz -> npmpkg-sprintf-js-1.1.3.tgz
https://registry.npmjs.org/stat-mode/-/stat-mode-1.0.0.tgz -> npmpkg-stat-mode-1.0.0.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-1.1.1.tgz -> npmpkg-string_decoder-1.1.1.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/sumchecker/-/sumchecker-3.0.1.tgz -> npmpkg-sumchecker-3.0.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/tar/-/tar-6.2.0.tgz -> npmpkg-tar-6.2.0.tgz
https://registry.npmjs.org/tar-stream/-/tar-stream-2.2.0.tgz -> npmpkg-tar-stream-2.2.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-1.0.4.tgz -> npmpkg-mkdirp-1.0.4.tgz
https://registry.npmjs.org/temp-file/-/temp-file-3.4.0.tgz -> npmpkg-temp-file-3.4.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/tmp/-/tmp-0.2.1.tgz -> npmpkg-tmp-0.2.1.tgz
https://registry.npmjs.org/tmp-promise/-/tmp-promise-3.0.3.tgz -> npmpkg-tmp-promise-3.0.3.tgz
https://registry.npmjs.org/truncate-utf8-bytes/-/truncate-utf8-bytes-1.0.2.tgz -> npmpkg-truncate-utf8-bytes-1.0.2.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.13.1.tgz -> npmpkg-type-fest-0.13.1.tgz
https://registry.npmjs.org/typescript/-/typescript-5.3.3.tgz -> npmpkg-typescript-5.3.3.tgz
https://registry.npmjs.org/universalify/-/universalify-0.1.2.tgz -> npmpkg-universalify-0.1.2.tgz
https://registry.npmjs.org/uri-js/-/uri-js-4.4.1.tgz -> npmpkg-uri-js-4.4.1.tgz
https://registry.npmjs.org/utf8-byte-length/-/utf8-byte-length-1.0.4.tgz -> npmpkg-utf8-byte-length-1.0.4.tgz
https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz -> npmpkg-util-deprecate-1.0.2.tgz
https://registry.npmjs.org/verror/-/verror-1.10.1.tgz -> npmpkg-verror-1.10.1.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> npmpkg-wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> npmpkg-wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
https://registry.npmjs.org/xmlbuilder/-/xmlbuilder-15.1.1.tgz -> npmpkg-xmlbuilder-15.1.1.tgz
https://registry.npmjs.org/y18n/-/y18n-5.0.8.tgz -> npmpkg-y18n-5.0.8.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/yargs/-/yargs-17.7.2.tgz -> npmpkg-yargs-17.7.2.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-21.1.1.tgz -> npmpkg-yargs-parser-21.1.1.tgz
https://registry.npmjs.org/yauzl/-/yauzl-2.10.0.tgz -> npmpkg-yauzl-2.10.0.tgz
https://registry.npmjs.org/zip-stream/-/zip-stream-4.1.1.tgz -> npmpkg-zip-stream-4.1.1.tgz
https://registry.npmjs.org/archiver-utils/-/archiver-utils-3.0.4.tgz -> npmpkg-archiver-utils-3.0.4.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/@develar/schema-utils/-/schema-utils-2.6.5.tgz -> npmpkg-@develar-schema-utils-2.6.5.tgz
https://registry.npmjs.org/@electron/asar/-/asar-3.2.13.tgz -> npmpkg-@electron-asar-3.2.13.tgz
https://registry.npmjs.org/@electron/get/-/get-2.0.3.tgz -> npmpkg-@electron-get-2.0.3.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/@electron/notarize/-/notarize-2.2.1.tgz -> npmpkg-@electron-notarize-2.2.1.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-9.1.0.tgz -> npmpkg-fs-extra-9.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/@electron/osx-sign/-/osx-sign-1.0.5.tgz -> npmpkg-@electron-osx-sign-1.0.5.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/isbinaryfile/-/isbinaryfile-4.0.10.tgz -> npmpkg-isbinaryfile-4.0.10.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/@electron/remote/-/remote-2.0.8.tgz -> npmpkg-@electron-remote-2.0.8.tgz
https://registry.npmjs.org/@electron/universal/-/universal-1.5.1.tgz -> npmpkg-@electron-universal-1.5.1.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-9.1.0.tgz -> npmpkg-fs-extra-9.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/@isaacs/cliui/-/cliui-8.0.2.tgz -> npmpkg-@isaacs-cliui-8.0.2.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-6.1.0.tgz -> npmpkg-ansi-regex-6.1.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-6.2.1.tgz -> npmpkg-ansi-styles-6.2.1.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-9.2.2.tgz -> npmpkg-emoji-regex-9.2.2.tgz
https://registry.npmjs.org/string-width/-/string-width-5.1.2.tgz -> npmpkg-string-width-5.1.2.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-7.1.0.tgz -> npmpkg-strip-ansi-7.1.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-8.1.0.tgz -> npmpkg-wrap-ansi-8.1.0.tgz
https://registry.npmjs.org/@malept/cross-spawn-promise/-/cross-spawn-promise-1.1.1.tgz -> npmpkg-@malept-cross-spawn-promise-1.1.1.tgz
https://registry.npmjs.org/@malept/flatpak-bundler/-/flatpak-bundler-0.4.0.tgz -> npmpkg-@malept-flatpak-bundler-0.4.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-9.1.0.tgz -> npmpkg-fs-extra-9.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/@pkgjs/parseargs/-/parseargs-0.11.0.tgz -> npmpkg-@pkgjs-parseargs-0.11.0.tgz
https://registry.npmjs.org/@sindresorhus/is/-/is-4.6.0.tgz -> npmpkg-@sindresorhus-is-4.6.0.tgz
https://registry.npmjs.org/@szmarczak/http-timer/-/http-timer-4.0.6.tgz -> npmpkg-@szmarczak-http-timer-4.0.6.tgz
https://registry.npmjs.org/@tootallnate/once/-/once-2.0.0.tgz -> npmpkg-@tootallnate-once-2.0.0.tgz
https://registry.npmjs.org/@types/cacheable-request/-/cacheable-request-6.0.3.tgz -> npmpkg-@types-cacheable-request-6.0.3.tgz
https://registry.npmjs.org/@types/debug/-/debug-4.1.12.tgz -> npmpkg-@types-debug-4.1.12.tgz
https://registry.npmjs.org/@types/fs-extra/-/fs-extra-9.0.13.tgz -> npmpkg-@types-fs-extra-9.0.13.tgz
https://registry.npmjs.org/@types/glob/-/glob-7.2.0.tgz -> npmpkg-@types-glob-7.2.0.tgz
https://registry.npmjs.org/@types/http-cache-semantics/-/http-cache-semantics-4.0.4.tgz -> npmpkg-@types-http-cache-semantics-4.0.4.tgz
https://registry.npmjs.org/@types/keyv/-/keyv-3.1.4.tgz -> npmpkg-@types-keyv-3.1.4.tgz
https://registry.npmjs.org/@types/minimatch/-/minimatch-5.1.2.tgz -> npmpkg-@types-minimatch-5.1.2.tgz
https://registry.npmjs.org/@types/ms/-/ms-0.7.34.tgz -> npmpkg-@types-ms-0.7.34.tgz
https://registry.npmjs.org/@types/node/-/node-16.11.33.tgz -> npmpkg-@types-node-16.11.33.tgz
https://registry.npmjs.org/@types/plist/-/plist-3.0.5.tgz -> npmpkg-@types-plist-3.0.5.tgz
https://registry.npmjs.org/@types/responselike/-/responselike-1.0.3.tgz -> npmpkg-@types-responselike-1.0.3.tgz
https://registry.npmjs.org/@types/verror/-/verror-1.10.9.tgz -> npmpkg-@types-verror-1.10.9.tgz
https://registry.npmjs.org/@types/yauzl/-/yauzl-2.10.3.tgz -> npmpkg-@types-yauzl-2.10.3.tgz
https://registry.npmjs.org/@xmldom/xmldom/-/xmldom-0.8.10.tgz -> npmpkg-@xmldom-xmldom-0.8.10.tgz
https://registry.npmjs.org/7zip-bin/-/7zip-bin-5.2.0.tgz -> npmpkg-7zip-bin-5.2.0.tgz
https://registry.npmjs.org/adm-zip/-/adm-zip-0.5.10.tgz -> npmpkg-adm-zip-0.5.10.tgz
https://registry.npmjs.org/agent-base/-/agent-base-6.0.2.tgz -> npmpkg-agent-base-6.0.2.tgz
https://registry.npmjs.org/ajv/-/ajv-6.12.6.tgz -> npmpkg-ajv-6.12.6.tgz
https://registry.npmjs.org/ajv-keywords/-/ajv-keywords-3.5.2.tgz -> npmpkg-ajv-keywords-3.5.2.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/app-builder-bin/-/app-builder-bin-4.0.0.tgz -> npmpkg-app-builder-bin-4.0.0.tgz
https://registry.npmjs.org/app-builder-lib/-/app-builder-lib-24.13.2.tgz -> npmpkg-app-builder-lib-24.13.2.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/builder-util/-/builder-util-24.13.1.tgz -> npmpkg-builder-util-24.13.1.tgz
https://registry.npmjs.org/builder-util-runtime/-/builder-util-runtime-9.2.4.tgz -> npmpkg-builder-util-runtime-9.2.4.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/minimatch/-/minimatch-5.1.6.tgz -> npmpkg-minimatch-5.1.6.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/archiver/-/archiver-5.3.2.tgz -> npmpkg-archiver-5.3.2.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/archiver-utils/-/archiver-utils-2.1.0.tgz -> npmpkg-archiver-utils-2.1.0.tgz
https://registry.npmjs.org/argparse/-/argparse-2.0.1.tgz -> npmpkg-argparse-2.0.1.tgz
https://registry.npmjs.org/assert-plus/-/assert-plus-1.0.0.tgz -> npmpkg-assert-plus-1.0.0.tgz
https://registry.npmjs.org/astral-regex/-/astral-regex-2.0.0.tgz -> npmpkg-astral-regex-2.0.0.tgz
https://registry.npmjs.org/async/-/async-3.2.5.tgz -> npmpkg-async-3.2.5.tgz
https://registry.npmjs.org/async-exit-hook/-/async-exit-hook-2.0.1.tgz -> npmpkg-async-exit-hook-2.0.1.tgz
https://registry.npmjs.org/asynckit/-/asynckit-0.4.0.tgz -> npmpkg-asynckit-0.4.0.tgz
https://registry.npmjs.org/at-least-node/-/at-least-node-1.0.0.tgz -> npmpkg-at-least-node-1.0.0.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.0.tgz -> npmpkg-balanced-match-1.0.0.tgz
https://registry.npmjs.org/base64-js/-/base64-js-1.5.1.tgz -> npmpkg-base64-js-1.5.1.tgz
https://registry.npmjs.org/bl/-/bl-4.1.0.tgz -> npmpkg-bl-4.1.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/bluebird/-/bluebird-3.7.2.tgz -> npmpkg-bluebird-3.7.2.tgz
https://registry.npmjs.org/bluebird-lst/-/bluebird-lst-1.0.9.tgz -> npmpkg-bluebird-lst-1.0.9.tgz
https://registry.npmjs.org/boolean/-/boolean-3.2.0.tgz -> npmpkg-boolean-3.2.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/buffer/-/buffer-5.7.1.tgz -> npmpkg-buffer-5.7.1.tgz
https://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.2.13.tgz -> npmpkg-buffer-crc32-0.2.13.tgz
https://registry.npmjs.org/buffer-equal/-/buffer-equal-1.0.1.tgz -> npmpkg-buffer-equal-1.0.1.tgz
https://registry.npmjs.org/buffer-from/-/buffer-from-1.1.2.tgz -> npmpkg-buffer-from-1.1.2.tgz
https://registry.npmjs.org/builder-util/-/builder-util-24.8.1.tgz -> npmpkg-builder-util-24.8.1.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/builder-util-runtime/-/builder-util-runtime-9.2.3.tgz -> npmpkg-builder-util-runtime-9.2.3.tgz
https://registry.npmjs.org/cacheable-lookup/-/cacheable-lookup-5.0.4.tgz -> npmpkg-cacheable-lookup-5.0.4.tgz
https://registry.npmjs.org/cacheable-request/-/cacheable-request-7.0.4.tgz -> npmpkg-cacheable-request-7.0.4.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/chownr/-/chownr-2.0.0.tgz -> npmpkg-chownr-2.0.0.tgz
https://registry.npmjs.org/chromium-pickle-js/-/chromium-pickle-js-0.2.0.tgz -> npmpkg-chromium-pickle-js-0.2.0.tgz
https://registry.npmjs.org/ci-info/-/ci-info-3.9.0.tgz -> npmpkg-ci-info-3.9.0.tgz
https://registry.npmjs.org/cli-truncate/-/cli-truncate-2.1.0.tgz -> npmpkg-cli-truncate-2.1.0.tgz
https://registry.npmjs.org/cliui/-/cliui-8.0.1.tgz -> npmpkg-cliui-8.0.1.tgz
https://registry.npmjs.org/clone-response/-/clone-response-1.0.3.tgz -> npmpkg-clone-response-1.0.3.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/combined-stream/-/combined-stream-1.0.8.tgz -> npmpkg-combined-stream-1.0.8.tgz
https://registry.npmjs.org/commander/-/commander-5.1.0.tgz -> npmpkg-commander-5.1.0.tgz
https://registry.npmjs.org/compare-version/-/compare-version-0.1.2.tgz -> npmpkg-compare-version-0.1.2.tgz
https://registry.npmjs.org/compress-commons/-/compress-commons-4.1.2.tgz -> npmpkg-compress-commons-4.1.2.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/config-file-ts/-/config-file-ts-0.2.6.tgz -> npmpkg-config-file-ts-0.2.6.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/glob/-/glob-10.4.5.tgz -> npmpkg-glob-10.4.5.tgz
https://registry.npmjs.org/minimatch/-/minimatch-9.0.5.tgz -> npmpkg-minimatch-9.0.5.tgz
https://registry.npmjs.org/minipass/-/minipass-7.1.2.tgz -> npmpkg-minipass-7.1.2.tgz
https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.2.tgz -> npmpkg-core-util-is-1.0.2.tgz
https://registry.npmjs.org/crc/-/crc-3.8.0.tgz -> npmpkg-crc-3.8.0.tgz
https://registry.npmjs.org/crc-32/-/crc-32-1.2.2.tgz -> npmpkg-crc-32-1.2.2.tgz
https://registry.npmjs.org/crc32-stream/-/crc32-stream-4.0.3.tgz -> npmpkg-crc32-stream-4.0.3.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz -> npmpkg-cross-spawn-7.0.3.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/decompress-response/-/decompress-response-6.0.0.tgz -> npmpkg-decompress-response-6.0.0.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-3.1.0.tgz -> npmpkg-mimic-response-3.1.0.tgz
https://registry.npmjs.org/defer-to-connect/-/defer-to-connect-2.0.1.tgz -> npmpkg-defer-to-connect-2.0.1.tgz
https://registry.npmjs.org/define-data-property/-/define-data-property-1.1.4.tgz -> npmpkg-define-data-property-1.1.4.tgz
https://registry.npmjs.org/define-properties/-/define-properties-1.2.1.tgz -> npmpkg-define-properties-1.2.1.tgz
https://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz -> npmpkg-delayed-stream-1.0.0.tgz
https://registry.npmjs.org/detect-node/-/detect-node-2.1.0.tgz -> npmpkg-detect-node-2.1.0.tgz
https://registry.npmjs.org/dir-compare/-/dir-compare-3.3.0.tgz -> npmpkg-dir-compare-3.3.0.tgz
https://registry.npmjs.org/dmg-builder/-/dmg-builder-24.13.2.tgz -> npmpkg-dmg-builder-24.13.2.tgz
https://registry.npmjs.org/builder-util/-/builder-util-24.13.1.tgz -> npmpkg-builder-util-24.13.1.tgz
https://registry.npmjs.org/builder-util-runtime/-/builder-util-runtime-9.2.4.tgz -> npmpkg-builder-util-runtime-9.2.4.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/dmg-license/-/dmg-license-1.0.11.tgz -> npmpkg-dmg-license-1.0.11.tgz
https://registry.npmjs.org/dotenv/-/dotenv-8.6.0.tgz -> npmpkg-dotenv-8.6.0.tgz
https://registry.npmjs.org/dotenv-expand/-/dotenv-expand-5.1.0.tgz -> npmpkg-dotenv-expand-5.1.0.tgz
https://registry.npmjs.org/eastasianwidth/-/eastasianwidth-0.2.0.tgz -> npmpkg-eastasianwidth-0.2.0.tgz
https://registry.npmjs.org/ejs/-/ejs-3.1.10.tgz -> npmpkg-ejs-3.1.10.tgz
https://registry.npmjs.org/electron/-/electron-22.3.27.tgz -> npmpkg-electron-22.3.27.tgz
https://registry.npmjs.org/electron-builder/-/electron-builder-24.9.1.tgz -> npmpkg-electron-builder-24.9.1.tgz
https://registry.npmjs.org/dmg-builder/-/dmg-builder-24.9.1.tgz -> npmpkg-dmg-builder-24.9.1.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/electron-builder-squirrel-windows/-/electron-builder-squirrel-windows-24.13.2.tgz -> npmpkg-electron-builder-squirrel-windows-24.13.2.tgz
https://registry.npmjs.org/builder-util/-/builder-util-24.13.1.tgz -> npmpkg-builder-util-24.13.1.tgz
https://registry.npmjs.org/builder-util-runtime/-/builder-util-runtime-9.2.4.tgz -> npmpkg-builder-util-runtime-9.2.4.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/electron-is/-/electron-is-2.4.1.tgz -> npmpkg-electron-is-2.4.1.tgz
https://registry.npmjs.org/electron-is-dev/-/electron-is-dev-0.3.0.tgz -> npmpkg-electron-is-dev-0.3.0.tgz
https://registry.npmjs.org/electron-publish/-/electron-publish-24.13.1.tgz -> npmpkg-electron-publish-24.13.1.tgz
https://registry.npmjs.org/builder-util/-/builder-util-24.13.1.tgz -> npmpkg-builder-util-24.13.1.tgz
https://registry.npmjs.org/builder-util-runtime/-/builder-util-runtime-9.2.4.tgz -> npmpkg-builder-util-runtime-9.2.4.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.4.4.tgz -> npmpkg-end-of-stream-1.4.4.tgz
https://registry.npmjs.org/env-paths/-/env-paths-2.2.1.tgz -> npmpkg-env-paths-2.2.1.tgz
https://registry.npmjs.org/err-code/-/err-code-2.0.3.tgz -> npmpkg-err-code-2.0.3.tgz
https://registry.npmjs.org/es-define-property/-/es-define-property-1.0.0.tgz -> npmpkg-es-define-property-1.0.0.tgz
https://registry.npmjs.org/es-errors/-/es-errors-1.3.0.tgz -> npmpkg-es-errors-1.3.0.tgz
https://registry.npmjs.org/es6-error/-/es6-error-4.1.1.tgz -> npmpkg-es6-error-4.1.1.tgz
https://registry.npmjs.org/escalade/-/escalade-3.1.1.tgz -> npmpkg-escalade-3.1.1.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz -> npmpkg-escape-string-regexp-4.0.0.tgz
https://registry.npmjs.org/extract-zip/-/extract-zip-2.0.1.tgz -> npmpkg-extract-zip-2.0.1.tgz
https://registry.npmjs.org/extsprintf/-/extsprintf-1.4.1.tgz -> npmpkg-extsprintf-1.4.1.tgz
https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz -> npmpkg-fast-deep-equal-3.1.3.tgz
https://registry.npmjs.org/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz -> npmpkg-fast-json-stable-stringify-2.1.0.tgz
https://registry.npmjs.org/fd-slicer/-/fd-slicer-1.1.0.tgz -> npmpkg-fd-slicer-1.1.0.tgz
https://registry.npmjs.org/filelist/-/filelist-1.0.4.tgz -> npmpkg-filelist-1.0.4.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-5.1.6.tgz -> npmpkg-minimatch-5.1.6.tgz
https://registry.npmjs.org/foreground-child/-/foreground-child-3.1.1.tgz -> npmpkg-foreground-child-3.1.1.tgz
https://registry.npmjs.org/form-data/-/form-data-4.0.0.tgz -> npmpkg-form-data-4.0.0.tgz
https://registry.npmjs.org/fs-constants/-/fs-constants-1.0.0.tgz -> npmpkg-fs-constants-1.0.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/fs-minipass/-/fs-minipass-2.1.0.tgz -> npmpkg-fs-minipass-2.1.0.tgz
https://registry.npmjs.org/minipass/-/minipass-3.3.6.tgz -> npmpkg-minipass-3.3.6.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz -> npmpkg-fs.realpath-1.0.0.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.2.tgz -> npmpkg-function-bind-1.1.2.tgz
https://registry.npmjs.org/get-caller-file/-/get-caller-file-2.0.5.tgz -> npmpkg-get-caller-file-2.0.5.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.2.4.tgz -> npmpkg-get-intrinsic-1.2.4.tgz
https://registry.npmjs.org/get-stream/-/get-stream-5.2.0.tgz -> npmpkg-get-stream-5.2.0.tgz
https://registry.npmjs.org/glob/-/glob-7.2.3.tgz -> npmpkg-glob-7.2.3.tgz
https://registry.npmjs.org/global-agent/-/global-agent-3.0.0.tgz -> npmpkg-global-agent-3.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/globalthis/-/globalthis-1.0.4.tgz -> npmpkg-globalthis-1.0.4.tgz
https://registry.npmjs.org/gopd/-/gopd-1.0.1.tgz -> npmpkg-gopd-1.0.1.tgz
https://registry.npmjs.org/got/-/got-11.8.6.tgz -> npmpkg-got-11.8.6.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.4.tgz -> npmpkg-graceful-fs-4.2.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/has-property-descriptors/-/has-property-descriptors-1.0.2.tgz -> npmpkg-has-property-descriptors-1.0.2.tgz
https://registry.npmjs.org/has-proto/-/has-proto-1.0.3.tgz -> npmpkg-has-proto-1.0.3.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.0.3.tgz -> npmpkg-has-symbols-1.0.3.tgz
https://registry.npmjs.org/hasown/-/hasown-2.0.2.tgz -> npmpkg-hasown-2.0.2.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-4.1.0.tgz -> npmpkg-hosted-git-info-4.1.0.tgz
https://registry.npmjs.org/http-cache-semantics/-/http-cache-semantics-4.1.1.tgz -> npmpkg-http-cache-semantics-4.1.1.tgz
https://registry.npmjs.org/http-proxy-agent/-/http-proxy-agent-5.0.0.tgz -> npmpkg-http-proxy-agent-5.0.0.tgz
https://registry.npmjs.org/http2-wrapper/-/http2-wrapper-1.0.3.tgz -> npmpkg-http2-wrapper-1.0.3.tgz
https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-5.0.1.tgz -> npmpkg-https-proxy-agent-5.0.1.tgz
https://registry.npmjs.org/iconv-corefoundation/-/iconv-corefoundation-1.1.7.tgz -> npmpkg-iconv-corefoundation-1.1.7.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.6.3.tgz -> npmpkg-iconv-lite-0.6.3.tgz
https://registry.npmjs.org/ieee754/-/ieee754-1.2.1.tgz -> npmpkg-ieee754-1.2.1.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz -> npmpkg-inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz -> npmpkg-inherits-2.0.4.tgz
https://registry.npmjs.org/interpret/-/interpret-1.4.0.tgz -> npmpkg-interpret-1.4.0.tgz
https://registry.npmjs.org/is-ci/-/is-ci-3.0.1.tgz -> npmpkg-is-ci-3.0.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> npmpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/isbinaryfile/-/isbinaryfile-5.0.2.tgz -> npmpkg-isbinaryfile-5.0.2.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz -> npmpkg-isexe-2.0.0.tgz
https://registry.npmjs.org/jackspeak/-/jackspeak-3.4.3.tgz -> npmpkg-jackspeak-3.4.3.tgz
https://registry.npmjs.org/jake/-/jake-10.8.7.tgz -> npmpkg-jake-10.8.7.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-4.1.0.tgz -> npmpkg-js-yaml-4.1.0.tgz
https://registry.npmjs.org/json-buffer/-/json-buffer-3.0.1.tgz -> npmpkg-json-buffer-3.0.1.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz -> npmpkg-json-schema-traverse-0.4.1.tgz
https://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz -> npmpkg-json-stringify-safe-5.0.1.tgz
https://registry.npmjs.org/json5/-/json5-2.2.3.tgz -> npmpkg-json5-2.2.3.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-4.0.0.tgz -> npmpkg-jsonfile-4.0.0.tgz
https://registry.npmjs.org/keyv/-/keyv-4.5.4.tgz -> npmpkg-keyv-4.5.4.tgz
https://registry.npmjs.org/lazy-val/-/lazy-val-1.0.5.tgz -> npmpkg-lazy-val-1.0.5.tgz
https://registry.npmjs.org/lazystream/-/lazystream-1.0.1.tgz -> npmpkg-lazystream-1.0.1.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/lodash.defaults/-/lodash.defaults-4.2.0.tgz -> npmpkg-lodash.defaults-4.2.0.tgz
https://registry.npmjs.org/lodash.difference/-/lodash.difference-4.5.0.tgz -> npmpkg-lodash.difference-4.5.0.tgz
https://registry.npmjs.org/lodash.flatten/-/lodash.flatten-4.4.0.tgz -> npmpkg-lodash.flatten-4.4.0.tgz
https://registry.npmjs.org/lodash.isplainobject/-/lodash.isplainobject-4.0.6.tgz -> npmpkg-lodash.isplainobject-4.0.6.tgz
https://registry.npmjs.org/lodash.union/-/lodash.union-4.6.0.tgz -> npmpkg-lodash.union-4.6.0.tgz
https://registry.npmjs.org/lowercase-keys/-/lowercase-keys-2.0.0.tgz -> npmpkg-lowercase-keys-2.0.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/matcher/-/matcher-3.0.0.tgz -> npmpkg-matcher-3.0.0.tgz
https://registry.npmjs.org/mime/-/mime-2.6.0.tgz -> npmpkg-mime-2.6.0.tgz
https://registry.npmjs.org/mime-db/-/mime-db-1.52.0.tgz -> npmpkg-mime-db-1.52.0.tgz
https://registry.npmjs.org/mime-types/-/mime-types-2.1.35.tgz -> npmpkg-mime-types-2.1.35.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-1.0.1.tgz -> npmpkg-mimic-response-1.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.8.tgz -> npmpkg-minimist-1.2.8.tgz
https://registry.npmjs.org/minipass/-/minipass-5.0.0.tgz -> npmpkg-minipass-5.0.0.tgz
https://registry.npmjs.org/minizlib/-/minizlib-2.1.2.tgz -> npmpkg-minizlib-2.1.2.tgz
https://registry.npmjs.org/minipass/-/minipass-3.3.6.tgz -> npmpkg-minipass-3.3.6.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/node-addon-api/-/node-addon-api-1.7.2.tgz -> npmpkg-node-addon-api-1.7.2.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz -> npmpkg-normalize-path-3.0.0.tgz
https://registry.npmjs.org/normalize-url/-/normalize-url-6.1.0.tgz -> npmpkg-normalize-url-6.1.0.tgz
https://registry.npmjs.org/object-keys/-/object-keys-1.1.1.tgz -> npmpkg-object-keys-1.1.1.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz -> npmpkg-once-1.4.0.tgz
https://registry.npmjs.org/p-cancelable/-/p-cancelable-2.1.1.tgz -> npmpkg-p-cancelable-2.1.1.tgz
https://registry.npmjs.org/package-json-from-dist/-/package-json-from-dist-1.0.1.tgz -> npmpkg-package-json-from-dist-1.0.1.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> npmpkg-path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/path-parse/-/path-parse-1.0.6.tgz -> npmpkg-path-parse-1.0.6.tgz
https://registry.npmjs.org/path-scurry/-/path-scurry-1.11.1.tgz -> npmpkg-path-scurry-1.11.1.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-10.4.3.tgz -> npmpkg-lru-cache-10.4.3.tgz
https://registry.npmjs.org/pend/-/pend-1.2.0.tgz -> npmpkg-pend-1.2.0.tgz
https://registry.npmjs.org/plist/-/plist-3.1.0.tgz -> npmpkg-plist-3.1.0.tgz
https://registry.npmjs.org/prettier/-/prettier-1.15.3.tgz -> npmpkg-prettier-1.15.3.tgz
https://registry.npmjs.org/process-nextick-args/-/process-nextick-args-2.0.1.tgz -> npmpkg-process-nextick-args-2.0.1.tgz
https://registry.npmjs.org/progress/-/progress-2.0.3.tgz -> npmpkg-progress-2.0.3.tgz
https://registry.npmjs.org/promise-retry/-/promise-retry-2.0.1.tgz -> npmpkg-promise-retry-2.0.1.tgz
https://registry.npmjs.org/pump/-/pump-3.0.2.tgz -> npmpkg-pump-3.0.2.tgz
https://registry.npmjs.org/punycode/-/punycode-2.3.1.tgz -> npmpkg-punycode-2.3.1.tgz
https://registry.npmjs.org/quick-lru/-/quick-lru-5.1.1.tgz -> npmpkg-quick-lru-5.1.1.tgz
https://registry.npmjs.org/read-config-file/-/read-config-file-6.3.2.tgz -> npmpkg-read-config-file-6.3.2.tgz
https://registry.npmjs.org/dotenv/-/dotenv-9.0.2.tgz -> npmpkg-dotenv-9.0.2.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/readdir-glob/-/readdir-glob-1.1.3.tgz -> npmpkg-readdir-glob-1.1.3.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-5.1.6.tgz -> npmpkg-minimatch-5.1.6.tgz
https://registry.npmjs.org/rechoir/-/rechoir-0.6.2.tgz -> npmpkg-rechoir-0.6.2.tgz
https://registry.npmjs.org/require-directory/-/require-directory-2.1.1.tgz -> npmpkg-require-directory-2.1.1.tgz
https://registry.npmjs.org/resolve/-/resolve-1.17.0.tgz -> npmpkg-resolve-1.17.0.tgz
https://registry.npmjs.org/resolve-alpn/-/resolve-alpn-1.2.1.tgz -> npmpkg-resolve-alpn-1.2.1.tgz
https://registry.npmjs.org/responselike/-/responselike-2.0.1.tgz -> npmpkg-responselike-2.0.1.tgz
https://registry.npmjs.org/retry/-/retry-0.12.0.tgz -> npmpkg-retry-0.12.0.tgz
https://registry.npmjs.org/rimraf/-/rimraf-3.0.2.tgz -> npmpkg-rimraf-3.0.2.tgz
https://registry.npmjs.org/roarr/-/roarr-2.15.4.tgz -> npmpkg-roarr-2.15.4.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/safer-buffer/-/safer-buffer-2.1.2.tgz -> npmpkg-safer-buffer-2.1.2.tgz
https://registry.npmjs.org/sanitize-filename/-/sanitize-filename-1.6.3.tgz -> npmpkg-sanitize-filename-1.6.3.tgz
https://registry.npmjs.org/sax/-/sax-1.3.0.tgz -> npmpkg-sax-1.3.0.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/semver-compare/-/semver-compare-1.0.0.tgz -> npmpkg-semver-compare-1.0.0.tgz
https://registry.npmjs.org/serialize-error/-/serialize-error-7.0.1.tgz -> npmpkg-serialize-error-7.0.1.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/shelljs/-/shelljs-0.8.5.tgz -> npmpkg-shelljs-0.8.5.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-4.1.0.tgz -> npmpkg-signal-exit-4.1.0.tgz
https://registry.npmjs.org/simple-update-notifier/-/simple-update-notifier-2.0.0.tgz -> npmpkg-simple-update-notifier-2.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/slice-ansi/-/slice-ansi-3.0.0.tgz -> npmpkg-slice-ansi-3.0.0.tgz
https://registry.npmjs.org/smart-buffer/-/smart-buffer-4.2.0.tgz -> npmpkg-smart-buffer-4.2.0.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/source-map-support/-/source-map-support-0.5.21.tgz -> npmpkg-source-map-support-0.5.21.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.1.3.tgz -> npmpkg-sprintf-js-1.1.3.tgz
https://registry.npmjs.org/stat-mode/-/stat-mode-1.0.0.tgz -> npmpkg-stat-mode-1.0.0.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-1.1.1.tgz -> npmpkg-string_decoder-1.1.1.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/sumchecker/-/sumchecker-3.0.1.tgz -> npmpkg-sumchecker-3.0.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/tar/-/tar-6.2.0.tgz -> npmpkg-tar-6.2.0.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-1.0.4.tgz -> npmpkg-mkdirp-1.0.4.tgz
https://registry.npmjs.org/tar-stream/-/tar-stream-2.2.0.tgz -> npmpkg-tar-stream-2.2.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/temp-file/-/temp-file-3.4.0.tgz -> npmpkg-temp-file-3.4.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/tmp/-/tmp-0.2.1.tgz -> npmpkg-tmp-0.2.1.tgz
https://registry.npmjs.org/tmp-promise/-/tmp-promise-3.0.3.tgz -> npmpkg-tmp-promise-3.0.3.tgz
https://registry.npmjs.org/truncate-utf8-bytes/-/truncate-utf8-bytes-1.0.2.tgz -> npmpkg-truncate-utf8-bytes-1.0.2.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.13.1.tgz -> npmpkg-type-fest-0.13.1.tgz
https://registry.npmjs.org/typescript/-/typescript-5.3.3.tgz -> npmpkg-typescript-5.3.3.tgz
https://registry.npmjs.org/universalify/-/universalify-0.1.2.tgz -> npmpkg-universalify-0.1.2.tgz
https://registry.npmjs.org/uri-js/-/uri-js-4.4.1.tgz -> npmpkg-uri-js-4.4.1.tgz
https://registry.npmjs.org/utf8-byte-length/-/utf8-byte-length-1.0.4.tgz -> npmpkg-utf8-byte-length-1.0.4.tgz
https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz -> npmpkg-util-deprecate-1.0.2.tgz
https://registry.npmjs.org/verror/-/verror-1.10.1.tgz -> npmpkg-verror-1.10.1.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> npmpkg-wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> npmpkg-wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
https://registry.npmjs.org/xmlbuilder/-/xmlbuilder-15.1.1.tgz -> npmpkg-xmlbuilder-15.1.1.tgz
https://registry.npmjs.org/y18n/-/y18n-5.0.8.tgz -> npmpkg-y18n-5.0.8.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/yargs/-/yargs-17.7.2.tgz -> npmpkg-yargs-17.7.2.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-21.1.1.tgz -> npmpkg-yargs-parser-21.1.1.tgz
https://registry.npmjs.org/yauzl/-/yauzl-2.10.0.tgz -> npmpkg-yauzl-2.10.0.tgz
https://registry.npmjs.org/zip-stream/-/zip-stream-4.1.1.tgz -> npmpkg-zip-stream-4.1.1.tgz
https://registry.npmjs.org/archiver-utils/-/archiver-utils-3.0.4.tgz -> npmpkg-archiver-utils-3.0.4.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/@aw-web-design/x-default-browser/-/x-default-browser-1.4.126.tgz -> npmpkg-@aw-web-design-x-default-browser-1.4.126.tgz
https://registry.npmjs.org/@babel/code-frame/-/code-frame-7.24.7.tgz -> npmpkg-@babel-code-frame-7.24.7.tgz
https://registry.npmjs.org/@babel/compat-data/-/compat-data-7.25.4.tgz -> npmpkg-@babel-compat-data-7.25.4.tgz
https://registry.npmjs.org/@babel/core/-/core-7.25.2.tgz -> npmpkg-@babel-core-7.25.2.tgz
https://registry.npmjs.org/convert-source-map/-/convert-source-map-2.0.0.tgz -> npmpkg-convert-source-map-2.0.0.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/@babel/generator/-/generator-7.25.6.tgz -> npmpkg-@babel-generator-7.25.6.tgz
https://registry.npmjs.org/@jridgewell/gen-mapping/-/gen-mapping-0.3.5.tgz -> npmpkg-@jridgewell-gen-mapping-0.3.5.tgz
https://registry.npmjs.org/@babel/helper-annotate-as-pure/-/helper-annotate-as-pure-7.22.5.tgz -> npmpkg-@babel-helper-annotate-as-pure-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-builder-binary-assignment-operator-visitor/-/helper-builder-binary-assignment-operator-visitor-7.22.15.tgz -> npmpkg-@babel-helper-builder-binary-assignment-operator-visitor-7.22.15.tgz
https://registry.npmjs.org/@babel/helper-compilation-targets/-/helper-compilation-targets-7.25.2.tgz -> npmpkg-@babel-helper-compilation-targets-7.25.2.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-5.1.1.tgz -> npmpkg-lru-cache-5.1.1.tgz
https://registry.npmjs.org/yallist/-/yallist-3.1.1.tgz -> npmpkg-yallist-3.1.1.tgz
https://registry.npmjs.org/@babel/helper-create-class-features-plugin/-/helper-create-class-features-plugin-7.22.15.tgz -> npmpkg-@babel-helper-create-class-features-plugin-7.22.15.tgz
https://registry.npmjs.org/@babel/helper-create-regexp-features-plugin/-/helper-create-regexp-features-plugin-7.22.15.tgz -> npmpkg-@babel-helper-create-regexp-features-plugin-7.22.15.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/@babel/helper-environment-visitor/-/helper-environment-visitor-7.22.20.tgz -> npmpkg-@babel-helper-environment-visitor-7.22.20.tgz
https://registry.npmjs.org/@babel/helper-function-name/-/helper-function-name-7.23.0.tgz -> npmpkg-@babel-helper-function-name-7.23.0.tgz
https://registry.npmjs.org/@babel/helper-hoist-variables/-/helper-hoist-variables-7.22.5.tgz -> npmpkg-@babel-helper-hoist-variables-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-member-expression-to-functions/-/helper-member-expression-to-functions-7.23.0.tgz -> npmpkg-@babel-helper-member-expression-to-functions-7.23.0.tgz
https://registry.npmjs.org/@babel/helper-module-imports/-/helper-module-imports-7.24.7.tgz -> npmpkg-@babel-helper-module-imports-7.24.7.tgz
https://registry.npmjs.org/@babel/helper-module-transforms/-/helper-module-transforms-7.25.2.tgz -> npmpkg-@babel-helper-module-transforms-7.25.2.tgz
https://registry.npmjs.org/@babel/helper-optimise-call-expression/-/helper-optimise-call-expression-7.22.5.tgz -> npmpkg-@babel-helper-optimise-call-expression-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-plugin-utils/-/helper-plugin-utils-7.22.5.tgz -> npmpkg-@babel-helper-plugin-utils-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-remap-async-to-generator/-/helper-remap-async-to-generator-7.22.20.tgz -> npmpkg-@babel-helper-remap-async-to-generator-7.22.20.tgz
https://registry.npmjs.org/@babel/helper-replace-supers/-/helper-replace-supers-7.22.20.tgz -> npmpkg-@babel-helper-replace-supers-7.22.20.tgz
https://registry.npmjs.org/@babel/helper-simple-access/-/helper-simple-access-7.24.7.tgz -> npmpkg-@babel-helper-simple-access-7.24.7.tgz
https://registry.npmjs.org/@babel/helper-skip-transparent-expression-wrappers/-/helper-skip-transparent-expression-wrappers-7.22.5.tgz -> npmpkg-@babel-helper-skip-transparent-expression-wrappers-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-split-export-declaration/-/helper-split-export-declaration-7.22.6.tgz -> npmpkg-@babel-helper-split-export-declaration-7.22.6.tgz
https://registry.npmjs.org/@babel/helper-string-parser/-/helper-string-parser-7.24.8.tgz -> npmpkg-@babel-helper-string-parser-7.24.8.tgz
https://registry.npmjs.org/@babel/helper-validator-identifier/-/helper-validator-identifier-7.24.7.tgz -> npmpkg-@babel-helper-validator-identifier-7.24.7.tgz
https://registry.npmjs.org/@babel/helper-validator-option/-/helper-validator-option-7.24.8.tgz -> npmpkg-@babel-helper-validator-option-7.24.8.tgz
https://registry.npmjs.org/@babel/helper-wrap-function/-/helper-wrap-function-7.22.20.tgz -> npmpkg-@babel-helper-wrap-function-7.22.20.tgz
https://registry.npmjs.org/@babel/helpers/-/helpers-7.25.6.tgz -> npmpkg-@babel-helpers-7.25.6.tgz
https://registry.npmjs.org/@babel/highlight/-/highlight-7.24.7.tgz -> npmpkg-@babel-highlight-7.24.7.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/@babel/parser/-/parser-7.25.6.tgz -> npmpkg-@babel-parser-7.25.6.tgz
https://registry.npmjs.org/@babel/plugin-bugfix-safari-id-destructuring-collision-in-function-expression/-/plugin-bugfix-safari-id-destructuring-collision-in-function-expression-7.22.15.tgz -> npmpkg-@babel-plugin-bugfix-safari-id-destructuring-collision-in-function-expression-7.22.15.tgz
https://registry.npmjs.org/@babel/plugin-bugfix-v8-spread-parameters-in-optional-chaining/-/plugin-bugfix-v8-spread-parameters-in-optional-chaining-7.22.15.tgz -> npmpkg-@babel-plugin-bugfix-v8-spread-parameters-in-optional-chaining-7.22.15.tgz
https://registry.npmjs.org/@babel/plugin-proposal-private-property-in-object/-/plugin-proposal-private-property-in-object-7.21.11.tgz -> npmpkg-@babel-plugin-proposal-private-property-in-object-7.21.11.tgz
https://registry.npmjs.org/@babel/plugin-syntax-class-static-block/-/plugin-syntax-class-static-block-7.14.5.tgz -> npmpkg-@babel-plugin-syntax-class-static-block-7.14.5.tgz
https://registry.npmjs.org/@babel/plugin-syntax-export-namespace-from/-/plugin-syntax-export-namespace-from-7.8.3.tgz -> npmpkg-@babel-plugin-syntax-export-namespace-from-7.8.3.tgz
https://registry.npmjs.org/@babel/plugin-syntax-flow/-/plugin-syntax-flow-7.22.5.tgz -> npmpkg-@babel-plugin-syntax-flow-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-syntax-import-assertions/-/plugin-syntax-import-assertions-7.22.5.tgz -> npmpkg-@babel-plugin-syntax-import-assertions-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-syntax-import-attributes/-/plugin-syntax-import-attributes-7.22.5.tgz -> npmpkg-@babel-plugin-syntax-import-attributes-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-syntax-jsx/-/plugin-syntax-jsx-7.22.5.tgz -> npmpkg-@babel-plugin-syntax-jsx-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-syntax-unicode-sets-regex/-/plugin-syntax-unicode-sets-regex-7.18.6.tgz -> npmpkg-@babel-plugin-syntax-unicode-sets-regex-7.18.6.tgz
https://registry.npmjs.org/@babel/plugin-transform-arrow-functions/-/plugin-transform-arrow-functions-7.22.5.tgz -> npmpkg-@babel-plugin-transform-arrow-functions-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-async-generator-functions/-/plugin-transform-async-generator-functions-7.22.15.tgz -> npmpkg-@babel-plugin-transform-async-generator-functions-7.22.15.tgz
https://registry.npmjs.org/@babel/plugin-transform-async-to-generator/-/plugin-transform-async-to-generator-7.22.5.tgz -> npmpkg-@babel-plugin-transform-async-to-generator-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-block-scoped-functions/-/plugin-transform-block-scoped-functions-7.22.5.tgz -> npmpkg-@babel-plugin-transform-block-scoped-functions-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-block-scoping/-/plugin-transform-block-scoping-7.23.0.tgz -> npmpkg-@babel-plugin-transform-block-scoping-7.23.0.tgz
https://registry.npmjs.org/@babel/plugin-transform-class-properties/-/plugin-transform-class-properties-7.22.5.tgz -> npmpkg-@babel-plugin-transform-class-properties-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-class-static-block/-/plugin-transform-class-static-block-7.22.11.tgz -> npmpkg-@babel-plugin-transform-class-static-block-7.22.11.tgz
https://registry.npmjs.org/@babel/plugin-transform-classes/-/plugin-transform-classes-7.22.15.tgz -> npmpkg-@babel-plugin-transform-classes-7.22.15.tgz
https://registry.npmjs.org/@babel/plugin-transform-computed-properties/-/plugin-transform-computed-properties-7.22.5.tgz -> npmpkg-@babel-plugin-transform-computed-properties-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-destructuring/-/plugin-transform-destructuring-7.23.0.tgz -> npmpkg-@babel-plugin-transform-destructuring-7.23.0.tgz
https://registry.npmjs.org/@babel/plugin-transform-dotall-regex/-/plugin-transform-dotall-regex-7.22.5.tgz -> npmpkg-@babel-plugin-transform-dotall-regex-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-duplicate-keys/-/plugin-transform-duplicate-keys-7.22.5.tgz -> npmpkg-@babel-plugin-transform-duplicate-keys-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-dynamic-import/-/plugin-transform-dynamic-import-7.22.11.tgz -> npmpkg-@babel-plugin-transform-dynamic-import-7.22.11.tgz
https://registry.npmjs.org/@babel/plugin-transform-exponentiation-operator/-/plugin-transform-exponentiation-operator-7.22.5.tgz -> npmpkg-@babel-plugin-transform-exponentiation-operator-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-export-namespace-from/-/plugin-transform-export-namespace-from-7.22.11.tgz -> npmpkg-@babel-plugin-transform-export-namespace-from-7.22.11.tgz
https://registry.npmjs.org/@babel/plugin-transform-flow-strip-types/-/plugin-transform-flow-strip-types-7.22.5.tgz -> npmpkg-@babel-plugin-transform-flow-strip-types-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-for-of/-/plugin-transform-for-of-7.22.15.tgz -> npmpkg-@babel-plugin-transform-for-of-7.22.15.tgz
https://registry.npmjs.org/@babel/plugin-transform-function-name/-/plugin-transform-function-name-7.22.5.tgz -> npmpkg-@babel-plugin-transform-function-name-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-json-strings/-/plugin-transform-json-strings-7.22.11.tgz -> npmpkg-@babel-plugin-transform-json-strings-7.22.11.tgz
https://registry.npmjs.org/@babel/plugin-transform-literals/-/plugin-transform-literals-7.22.5.tgz -> npmpkg-@babel-plugin-transform-literals-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-logical-assignment-operators/-/plugin-transform-logical-assignment-operators-7.22.11.tgz -> npmpkg-@babel-plugin-transform-logical-assignment-operators-7.22.11.tgz
https://registry.npmjs.org/@babel/plugin-transform-member-expression-literals/-/plugin-transform-member-expression-literals-7.22.5.tgz -> npmpkg-@babel-plugin-transform-member-expression-literals-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-modules-amd/-/plugin-transform-modules-amd-7.23.0.tgz -> npmpkg-@babel-plugin-transform-modules-amd-7.23.0.tgz
https://registry.npmjs.org/@babel/plugin-transform-modules-commonjs/-/plugin-transform-modules-commonjs-7.23.0.tgz -> npmpkg-@babel-plugin-transform-modules-commonjs-7.23.0.tgz
https://registry.npmjs.org/@babel/plugin-transform-modules-systemjs/-/plugin-transform-modules-systemjs-7.23.0.tgz -> npmpkg-@babel-plugin-transform-modules-systemjs-7.23.0.tgz
https://registry.npmjs.org/@babel/plugin-transform-modules-umd/-/plugin-transform-modules-umd-7.22.5.tgz -> npmpkg-@babel-plugin-transform-modules-umd-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-named-capturing-groups-regex/-/plugin-transform-named-capturing-groups-regex-7.22.5.tgz -> npmpkg-@babel-plugin-transform-named-capturing-groups-regex-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-new-target/-/plugin-transform-new-target-7.22.5.tgz -> npmpkg-@babel-plugin-transform-new-target-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-nullish-coalescing-operator/-/plugin-transform-nullish-coalescing-operator-7.22.11.tgz -> npmpkg-@babel-plugin-transform-nullish-coalescing-operator-7.22.11.tgz
https://registry.npmjs.org/@babel/plugin-transform-numeric-separator/-/plugin-transform-numeric-separator-7.22.11.tgz -> npmpkg-@babel-plugin-transform-numeric-separator-7.22.11.tgz
https://registry.npmjs.org/@babel/plugin-transform-object-rest-spread/-/plugin-transform-object-rest-spread-7.22.15.tgz -> npmpkg-@babel-plugin-transform-object-rest-spread-7.22.15.tgz
https://registry.npmjs.org/@babel/plugin-transform-object-super/-/plugin-transform-object-super-7.22.5.tgz -> npmpkg-@babel-plugin-transform-object-super-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-optional-catch-binding/-/plugin-transform-optional-catch-binding-7.22.11.tgz -> npmpkg-@babel-plugin-transform-optional-catch-binding-7.22.11.tgz
https://registry.npmjs.org/@babel/plugin-transform-optional-chaining/-/plugin-transform-optional-chaining-7.23.0.tgz -> npmpkg-@babel-plugin-transform-optional-chaining-7.23.0.tgz
https://registry.npmjs.org/@babel/plugin-transform-parameters/-/plugin-transform-parameters-7.22.15.tgz -> npmpkg-@babel-plugin-transform-parameters-7.22.15.tgz
https://registry.npmjs.org/@babel/plugin-transform-private-methods/-/plugin-transform-private-methods-7.22.5.tgz -> npmpkg-@babel-plugin-transform-private-methods-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-private-property-in-object/-/plugin-transform-private-property-in-object-7.22.11.tgz -> npmpkg-@babel-plugin-transform-private-property-in-object-7.22.11.tgz
https://registry.npmjs.org/@babel/plugin-transform-property-literals/-/plugin-transform-property-literals-7.22.5.tgz -> npmpkg-@babel-plugin-transform-property-literals-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-react-display-name/-/plugin-transform-react-display-name-7.22.5.tgz -> npmpkg-@babel-plugin-transform-react-display-name-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-react-jsx/-/plugin-transform-react-jsx-7.22.15.tgz -> npmpkg-@babel-plugin-transform-react-jsx-7.22.15.tgz
https://registry.npmjs.org/@babel/plugin-transform-react-jsx-development/-/plugin-transform-react-jsx-development-7.22.5.tgz -> npmpkg-@babel-plugin-transform-react-jsx-development-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-react-pure-annotations/-/plugin-transform-react-pure-annotations-7.22.5.tgz -> npmpkg-@babel-plugin-transform-react-pure-annotations-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-regenerator/-/plugin-transform-regenerator-7.22.10.tgz -> npmpkg-@babel-plugin-transform-regenerator-7.22.10.tgz
https://registry.npmjs.org/@babel/plugin-transform-reserved-words/-/plugin-transform-reserved-words-7.22.5.tgz -> npmpkg-@babel-plugin-transform-reserved-words-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-shorthand-properties/-/plugin-transform-shorthand-properties-7.22.5.tgz -> npmpkg-@babel-plugin-transform-shorthand-properties-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-spread/-/plugin-transform-spread-7.22.5.tgz -> npmpkg-@babel-plugin-transform-spread-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-sticky-regex/-/plugin-transform-sticky-regex-7.22.5.tgz -> npmpkg-@babel-plugin-transform-sticky-regex-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-template-literals/-/plugin-transform-template-literals-7.22.5.tgz -> npmpkg-@babel-plugin-transform-template-literals-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-typeof-symbol/-/plugin-transform-typeof-symbol-7.22.5.tgz -> npmpkg-@babel-plugin-transform-typeof-symbol-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-unicode-escapes/-/plugin-transform-unicode-escapes-7.22.10.tgz -> npmpkg-@babel-plugin-transform-unicode-escapes-7.22.10.tgz
https://registry.npmjs.org/@babel/plugin-transform-unicode-property-regex/-/plugin-transform-unicode-property-regex-7.22.5.tgz -> npmpkg-@babel-plugin-transform-unicode-property-regex-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-unicode-regex/-/plugin-transform-unicode-regex-7.22.5.tgz -> npmpkg-@babel-plugin-transform-unicode-regex-7.22.5.tgz
https://registry.npmjs.org/@babel/plugin-transform-unicode-sets-regex/-/plugin-transform-unicode-sets-regex-7.22.5.tgz -> npmpkg-@babel-plugin-transform-unicode-sets-regex-7.22.5.tgz
https://registry.npmjs.org/@babel/preset-env/-/preset-env-7.22.20.tgz -> npmpkg-@babel-preset-env-7.22.20.tgz
https://registry.npmjs.org/@babel/helper-define-polyfill-provider/-/helper-define-polyfill-provider-0.6.2.tgz -> npmpkg-@babel-helper-define-polyfill-provider-0.6.2.tgz
https://registry.npmjs.org/@babel/plugin-proposal-private-property-in-object/-/plugin-proposal-private-property-in-object-7.21.0-placeholder-for-preset-env.2.tgz -> npmpkg-@babel-plugin-proposal-private-property-in-object-7.21.0-placeholder-for-preset-env.2.tgz
https://registry.npmjs.org/babel-plugin-polyfill-corejs2/-/babel-plugin-polyfill-corejs2-0.4.11.tgz -> npmpkg-babel-plugin-polyfill-corejs2-0.4.11.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/babel-plugin-polyfill-corejs3/-/babel-plugin-polyfill-corejs3-0.8.7.tgz -> npmpkg-babel-plugin-polyfill-corejs3-0.8.7.tgz
https://registry.npmjs.org/@babel/helper-define-polyfill-provider/-/helper-define-polyfill-provider-0.4.4.tgz -> npmpkg-@babel-helper-define-polyfill-provider-0.4.4.tgz
https://registry.npmjs.org/babel-plugin-polyfill-regenerator/-/babel-plugin-polyfill-regenerator-0.5.5.tgz -> npmpkg-babel-plugin-polyfill-regenerator-0.5.5.tgz
https://registry.npmjs.org/@babel/helper-define-polyfill-provider/-/helper-define-polyfill-provider-0.5.0.tgz -> npmpkg-@babel-helper-define-polyfill-provider-0.5.0.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/@babel/preset-flow/-/preset-flow-7.22.15.tgz -> npmpkg-@babel-preset-flow-7.22.15.tgz
https://registry.npmjs.org/@babel/preset-modules/-/preset-modules-0.1.6-no-external-plugins.tgz -> npmpkg-@babel-preset-modules-0.1.6-no-external-plugins.tgz
https://registry.npmjs.org/@babel/preset-react/-/preset-react-7.22.15.tgz -> npmpkg-@babel-preset-react-7.22.15.tgz
https://registry.npmjs.org/@babel/register/-/register-7.22.15.tgz -> npmpkg-@babel-register-7.22.15.tgz
https://registry.npmjs.org/find-cache-dir/-/find-cache-dir-2.1.0.tgz -> npmpkg-find-cache-dir-2.1.0.tgz
https://registry.npmjs.org/@babel/regjsgen/-/regjsgen-0.8.0.tgz -> npmpkg-@babel-regjsgen-0.8.0.tgz
https://registry.npmjs.org/@babel/template/-/template-7.25.0.tgz -> npmpkg-@babel-template-7.25.0.tgz
https://registry.npmjs.org/@babel/traverse/-/traverse-7.25.6.tgz -> npmpkg-@babel-traverse-7.25.6.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/@babel/types/-/types-7.25.6.tgz -> npmpkg-@babel-types-7.25.6.tgz
https://registry.npmjs.org/@base2/pretty-print-object/-/pretty-print-object-1.0.1.tgz -> npmpkg-@base2-pretty-print-object-1.0.1.tgz
https://registry.npmjs.org/@bazel/runfiles/-/runfiles-5.8.1.tgz -> npmpkg-@bazel-runfiles-5.8.1.tgz
https://registry.npmjs.org/@colors/colors/-/colors-1.5.0.tgz -> npmpkg-@colors-colors-1.5.0.tgz
https://registry.npmjs.org/@discoveryjs/json-ext/-/json-ext-0.5.7.tgz -> npmpkg-@discoveryjs-json-ext-0.5.7.tgz
https://registry.npmjs.org/@emotion/use-insertion-effect-with-fallbacks/-/use-insertion-effect-with-fallbacks-1.0.1.tgz -> npmpkg-@emotion-use-insertion-effect-with-fallbacks-1.0.1.tgz
https://registry.npmjs.org/@esbuild/android-arm/-/android-arm-0.18.20.tgz -> npmpkg-@esbuild-android-arm-0.18.20.tgz
https://registry.npmjs.org/@esbuild/android-arm64/-/android-arm64-0.18.20.tgz -> npmpkg-@esbuild-android-arm64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/android-x64/-/android-x64-0.18.20.tgz -> npmpkg-@esbuild-android-x64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/darwin-arm64/-/darwin-arm64-0.18.20.tgz -> npmpkg-@esbuild-darwin-arm64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/darwin-x64/-/darwin-x64-0.18.20.tgz -> npmpkg-@esbuild-darwin-x64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/freebsd-arm64/-/freebsd-arm64-0.18.20.tgz -> npmpkg-@esbuild-freebsd-arm64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/freebsd-x64/-/freebsd-x64-0.18.20.tgz -> npmpkg-@esbuild-freebsd-x64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/linux-arm/-/linux-arm-0.18.20.tgz -> npmpkg-@esbuild-linux-arm-0.18.20.tgz
https://registry.npmjs.org/@esbuild/linux-arm64/-/linux-arm64-0.18.20.tgz -> npmpkg-@esbuild-linux-arm64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/linux-ia32/-/linux-ia32-0.18.20.tgz -> npmpkg-@esbuild-linux-ia32-0.18.20.tgz
https://registry.npmjs.org/@esbuild/linux-loong64/-/linux-loong64-0.18.20.tgz -> npmpkg-@esbuild-linux-loong64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/linux-mips64el/-/linux-mips64el-0.18.20.tgz -> npmpkg-@esbuild-linux-mips64el-0.18.20.tgz
https://registry.npmjs.org/@esbuild/linux-ppc64/-/linux-ppc64-0.18.20.tgz -> npmpkg-@esbuild-linux-ppc64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/linux-riscv64/-/linux-riscv64-0.18.20.tgz -> npmpkg-@esbuild-linux-riscv64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/linux-s390x/-/linux-s390x-0.18.20.tgz -> npmpkg-@esbuild-linux-s390x-0.18.20.tgz
https://registry.npmjs.org/@esbuild/linux-x64/-/linux-x64-0.18.20.tgz -> npmpkg-@esbuild-linux-x64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/netbsd-x64/-/netbsd-x64-0.18.20.tgz -> npmpkg-@esbuild-netbsd-x64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/openbsd-x64/-/openbsd-x64-0.18.20.tgz -> npmpkg-@esbuild-openbsd-x64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/sunos-x64/-/sunos-x64-0.18.20.tgz -> npmpkg-@esbuild-sunos-x64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/win32-arm64/-/win32-arm64-0.18.20.tgz -> npmpkg-@esbuild-win32-arm64-0.18.20.tgz
https://registry.npmjs.org/@esbuild/win32-ia32/-/win32-ia32-0.18.20.tgz -> npmpkg-@esbuild-win32-ia32-0.18.20.tgz
https://registry.npmjs.org/@esbuild/win32-x64/-/win32-x64-0.18.20.tgz -> npmpkg-@esbuild-win32-x64-0.18.20.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/globals/-/globals-13.24.0.tgz -> npmpkg-globals-13.24.0.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/@fal-works/esbuild-plugin-global-externals/-/esbuild-plugin-global-externals-2.1.2.tgz -> npmpkg-@fal-works-esbuild-plugin-global-externals-2.1.2.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/selenium-webdriver/-/selenium-webdriver-4.25.0.tgz -> npmpkg-selenium-webdriver-4.25.0.tgz
https://registry.npmjs.org/tmp/-/tmp-0.2.3.tgz -> npmpkg-tmp-0.2.3.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/ws/-/ws-8.18.0.tgz -> npmpkg-ws-8.18.0.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/@floating-ui/core/-/core-1.5.0.tgz -> npmpkg-@floating-ui-core-1.5.0.tgz
https://registry.npmjs.org/@floating-ui/dom/-/dom-1.5.3.tgz -> npmpkg-@floating-ui-dom-1.5.3.tgz
https://registry.npmjs.org/@floating-ui/react-dom/-/react-dom-2.0.2.tgz -> npmpkg-@floating-ui-react-dom-2.0.2.tgz
https://registry.npmjs.org/@floating-ui/utils/-/utils-0.1.6.tgz -> npmpkg-@floating-ui-utils-0.1.6.tgz
https://registry.npmjs.org/@grpc/grpc-js/-/grpc-js-1.8.22.tgz -> npmpkg-@grpc-grpc-js-1.8.22.tgz
https://registry.npmjs.org/@grpc/proto-loader/-/proto-loader-0.7.13.tgz -> npmpkg-@grpc-proto-loader-0.7.13.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/cliui/-/cliui-8.0.1.tgz -> npmpkg-cliui-8.0.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> npmpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/long/-/long-5.2.3.tgz -> npmpkg-long-5.2.3.tgz
https://registry.npmjs.org/protobufjs/-/protobufjs-7.4.0.tgz -> npmpkg-protobufjs-7.4.0.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> npmpkg-wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/y18n/-/y18n-5.0.8.tgz -> npmpkg-y18n-5.0.8.tgz
https://registry.npmjs.org/yargs/-/yargs-17.7.2.tgz -> npmpkg-yargs-17.7.2.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-21.1.1.tgz -> npmpkg-yargs-parser-21.1.1.tgz
https://registry.npmjs.org/@hapi/boom/-/boom-9.1.4.tgz -> npmpkg-@hapi-boom-9.1.4.tgz
https://registry.npmjs.org/@hapi/hoek/-/hoek-9.3.0.tgz -> npmpkg-@hapi-hoek-9.3.0.tgz
https://registry.npmjs.org/@hapi/cryptiles/-/cryptiles-5.1.0.tgz -> npmpkg-@hapi-cryptiles-5.1.0.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/@isaacs/cliui/-/cliui-8.0.2.tgz -> npmpkg-@isaacs-cliui-8.0.2.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-6.1.0.tgz -> npmpkg-ansi-regex-6.1.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-6.2.1.tgz -> npmpkg-ansi-styles-6.2.1.tgz
https://registry.npmjs.org/eastasianwidth/-/eastasianwidth-0.2.0.tgz -> npmpkg-eastasianwidth-0.2.0.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-9.2.2.tgz -> npmpkg-emoji-regex-9.2.2.tgz
https://registry.npmjs.org/string-width/-/string-width-5.1.2.tgz -> npmpkg-string-width-5.1.2.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-7.1.0.tgz -> npmpkg-strip-ansi-7.1.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-8.1.0.tgz -> npmpkg-wrap-ansi-8.1.0.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.4.tgz -> npmpkg-@types-istanbul-reports-3.0.4.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-16.0.9.tgz -> npmpkg-@types-yargs-16.0.9.tgz
https://registry.npmjs.org/ci-info/-/ci-info-3.9.0.tgz -> npmpkg-ci-info-3.9.0.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.4.tgz -> npmpkg-@types-istanbul-reports-3.0.4.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-16.0.9.tgz -> npmpkg-@types-yargs-16.0.9.tgz
https://registry.npmjs.org/ci-info/-/ci-info-3.9.0.tgz -> npmpkg-ci-info-3.9.0.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.4.tgz -> npmpkg-@types-istanbul-reports-3.0.4.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-16.0.9.tgz -> npmpkg-@types-yargs-16.0.9.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.4.tgz -> npmpkg-@types-istanbul-reports-3.0.4.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-16.0.9.tgz -> npmpkg-@types-yargs-16.0.9.tgz
https://registry.npmjs.org/ci-info/-/ci-info-3.9.0.tgz -> npmpkg-ci-info-3.9.0.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.4.tgz -> npmpkg-@types-istanbul-reports-3.0.4.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-16.0.9.tgz -> npmpkg-@types-yargs-16.0.9.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.4.tgz -> npmpkg-@types-istanbul-reports-3.0.4.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-16.0.9.tgz -> npmpkg-@types-yargs-16.0.9.tgz
https://registry.npmjs.org/ci-info/-/ci-info-3.9.0.tgz -> npmpkg-ci-info-3.9.0.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.4.tgz -> npmpkg-@types-istanbul-reports-3.0.4.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-16.0.9.tgz -> npmpkg-@types-yargs-16.0.9.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.4.tgz -> npmpkg-@types-istanbul-reports-3.0.4.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-16.0.9.tgz -> npmpkg-@types-yargs-16.0.9.tgz
https://registry.npmjs.org/ci-info/-/ci-info-3.9.0.tgz -> npmpkg-ci-info-3.9.0.tgz
https://registry.npmjs.org/@jest/transform/-/transform-29.7.0.tgz -> npmpkg-@jest-transform-29.7.0.tgz
https://registry.npmjs.org/@jest/schemas/-/schemas-29.6.3.tgz -> npmpkg-@jest-schemas-29.6.3.tgz
https://registry.npmjs.org/@jest/types/-/types-29.6.3.tgz -> npmpkg-@jest-types-29.6.3.tgz
https://registry.npmjs.org/@sinclair/typebox/-/typebox-0.27.8.tgz -> npmpkg-@sinclair-typebox-0.27.8.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.4.tgz -> npmpkg-@types-istanbul-reports-3.0.4.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-17.0.33.tgz -> npmpkg-@types-yargs-17.0.33.tgz
https://registry.npmjs.org/convert-source-map/-/convert-source-map-2.0.0.tgz -> npmpkg-convert-source-map-2.0.0.tgz
https://registry.npmjs.org/jest-regex-util/-/jest-regex-util-29.6.3.tgz -> npmpkg-jest-regex-util-29.6.3.tgz
https://registry.npmjs.org/slash/-/slash-3.0.0.tgz -> npmpkg-slash-3.0.0.tgz
https://registry.npmjs.org/write-file-atomic/-/write-file-atomic-4.0.2.tgz -> npmpkg-write-file-atomic-4.0.2.tgz
https://registry.npmjs.org/@jridgewell/set-array/-/set-array-1.2.1.tgz -> npmpkg-@jridgewell-set-array-1.2.1.tgz
https://registry.npmjs.org/@jridgewell/gen-mapping/-/gen-mapping-0.3.5.tgz -> npmpkg-@jridgewell-gen-mapping-0.3.5.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.25.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.25.tgz
https://registry.npmjs.org/@juggle/resize-observer/-/resize-observer-3.4.0.tgz -> npmpkg-@juggle-resize-observer-3.4.0.tgz
https://registry.npmjs.org/@lingui/core/-/core-2.7.3.tgz -> npmpkg-@lingui-core-2.7.3.tgz
https://github.com/4ian/lingui-react/archive/dc6b1e013470d952cf85f96cc4affdd28e29634a.tar.gz -> npmpkg-lingui-react.git-dc6b1e013470d952cf85f96cc4affdd28e29634a.tgz
https://registry.npmjs.org/@mdx-js/react/-/react-2.3.0.tgz -> npmpkg-@mdx-js-react-2.3.0.tgz
https://registry.npmjs.org/@ndelangen/get-tarball/-/get-tarball-3.0.9.tgz -> npmpkg-@ndelangen-get-tarball-3.0.9.tgz
https://registry.npmjs.org/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz -> npmpkg-@nodelib-fs.stat-2.0.5.tgz
https://registry.npmjs.org/@pixi-spine/base/-/base-4.0.3.tgz -> npmpkg-@pixi-spine-base-4.0.3.tgz
https://registry.npmjs.org/@pixi-spine/loader-base/-/loader-base-4.0.4.tgz -> npmpkg-@pixi-spine-loader-base-4.0.4.tgz
https://registry.npmjs.org/@pixi-spine/loader-uni/-/loader-uni-4.0.3.tgz -> npmpkg-@pixi-spine-loader-uni-4.0.3.tgz
https://registry.npmjs.org/@pixi-spine/runtime-3.7/-/runtime-3.7-4.0.3.tgz -> npmpkg-@pixi-spine-runtime-3.7-4.0.3.tgz
https://registry.npmjs.org/@pixi-spine/runtime-3.8/-/runtime-3.8-4.0.3.tgz -> npmpkg-@pixi-spine-runtime-3.8-4.0.3.tgz
https://registry.npmjs.org/@pixi-spine/runtime-4.0/-/runtime-4.0-4.0.3.tgz -> npmpkg-@pixi-spine-runtime-4.0-4.0.3.tgz
https://registry.npmjs.org/@pixi-spine/runtime-4.1/-/runtime-4.1-4.0.3.tgz -> npmpkg-@pixi-spine-runtime-4.1-4.0.3.tgz
https://registry.npmjs.org/@pixi/accessibility/-/accessibility-7.3.0.tgz -> npmpkg-@pixi-accessibility-7.3.0.tgz
https://registry.npmjs.org/@pixi/app/-/app-7.3.0.tgz -> npmpkg-@pixi-app-7.3.0.tgz
https://registry.npmjs.org/@pixi/assets/-/assets-7.3.0.tgz -> npmpkg-@pixi-assets-7.3.0.tgz
https://registry.npmjs.org/@pixi/canvas-display/-/canvas-display-7.3.0.tgz -> npmpkg-@pixi-canvas-display-7.3.0.tgz
https://registry.npmjs.org/@pixi/canvas-extract/-/canvas-extract-7.3.0.tgz -> npmpkg-@pixi-canvas-extract-7.3.0.tgz
https://registry.npmjs.org/@pixi/canvas-graphics/-/canvas-graphics-7.3.0.tgz -> npmpkg-@pixi-canvas-graphics-7.3.0.tgz
https://registry.npmjs.org/@pixi/canvas-mesh/-/canvas-mesh-7.3.0.tgz -> npmpkg-@pixi-canvas-mesh-7.3.0.tgz
https://registry.npmjs.org/@pixi/canvas-particle-container/-/canvas-particle-container-7.3.0.tgz -> npmpkg-@pixi-canvas-particle-container-7.3.0.tgz
https://registry.npmjs.org/@pixi/canvas-prepare/-/canvas-prepare-7.3.0.tgz -> npmpkg-@pixi-canvas-prepare-7.3.0.tgz
https://registry.npmjs.org/@pixi/canvas-renderer/-/canvas-renderer-7.3.0.tgz -> npmpkg-@pixi-canvas-renderer-7.3.0.tgz
https://registry.npmjs.org/@pixi/canvas-sprite/-/canvas-sprite-7.3.0.tgz -> npmpkg-@pixi-canvas-sprite-7.3.0.tgz
https://registry.npmjs.org/@pixi/canvas-sprite-tiling/-/canvas-sprite-tiling-7.3.0.tgz -> npmpkg-@pixi-canvas-sprite-tiling-7.3.0.tgz
https://registry.npmjs.org/@pixi/canvas-text/-/canvas-text-7.3.0.tgz -> npmpkg-@pixi-canvas-text-7.3.0.tgz
https://registry.npmjs.org/@pixi/color/-/color-7.3.0.tgz -> npmpkg-@pixi-color-7.3.0.tgz
https://registry.npmjs.org/@pixi/compressed-textures/-/compressed-textures-7.3.0.tgz -> npmpkg-@pixi-compressed-textures-7.3.0.tgz
https://registry.npmjs.org/@pixi/constants/-/constants-7.3.0.tgz -> npmpkg-@pixi-constants-7.3.0.tgz
https://registry.npmjs.org/@pixi/core/-/core-7.3.0.tgz -> npmpkg-@pixi-core-7.3.0.tgz
https://registry.npmjs.org/@pixi/display/-/display-7.3.0.tgz -> npmpkg-@pixi-display-7.3.0.tgz
https://registry.npmjs.org/@pixi/events/-/events-7.3.0.tgz -> npmpkg-@pixi-events-7.3.0.tgz
https://registry.npmjs.org/@pixi/extensions/-/extensions-7.3.0.tgz -> npmpkg-@pixi-extensions-7.3.0.tgz
https://registry.npmjs.org/@pixi/extract/-/extract-7.3.0.tgz -> npmpkg-@pixi-extract-7.3.0.tgz
https://registry.npmjs.org/@pixi/filter-alpha/-/filter-alpha-7.3.0.tgz -> npmpkg-@pixi-filter-alpha-7.3.0.tgz
https://registry.npmjs.org/@pixi/filter-blur/-/filter-blur-7.3.0.tgz -> npmpkg-@pixi-filter-blur-7.3.0.tgz
https://registry.npmjs.org/@pixi/filter-color-matrix/-/filter-color-matrix-7.3.0.tgz -> npmpkg-@pixi-filter-color-matrix-7.3.0.tgz
https://registry.npmjs.org/@pixi/filter-displacement/-/filter-displacement-7.3.0.tgz -> npmpkg-@pixi-filter-displacement-7.3.0.tgz
https://registry.npmjs.org/@pixi/filter-fxaa/-/filter-fxaa-7.3.0.tgz -> npmpkg-@pixi-filter-fxaa-7.3.0.tgz
https://registry.npmjs.org/@pixi/filter-noise/-/filter-noise-7.3.0.tgz -> npmpkg-@pixi-filter-noise-7.3.0.tgz
https://registry.npmjs.org/@pixi/graphics/-/graphics-7.3.0.tgz -> npmpkg-@pixi-graphics-7.3.0.tgz
https://registry.npmjs.org/@pixi/math/-/math-7.3.0.tgz -> npmpkg-@pixi-math-7.3.0.tgz
https://registry.npmjs.org/@pixi/mesh/-/mesh-7.3.0.tgz -> npmpkg-@pixi-mesh-7.3.0.tgz
https://registry.npmjs.org/@pixi/mesh-extras/-/mesh-extras-7.3.0.tgz -> npmpkg-@pixi-mesh-extras-7.3.0.tgz
https://registry.npmjs.org/@pixi/mixin-cache-as-bitmap/-/mixin-cache-as-bitmap-7.3.0.tgz -> npmpkg-@pixi-mixin-cache-as-bitmap-7.3.0.tgz
https://registry.npmjs.org/@pixi/mixin-get-child-by-name/-/mixin-get-child-by-name-7.3.0.tgz -> npmpkg-@pixi-mixin-get-child-by-name-7.3.0.tgz
https://registry.npmjs.org/@pixi/mixin-get-global-position/-/mixin-get-global-position-7.3.0.tgz -> npmpkg-@pixi-mixin-get-global-position-7.3.0.tgz
https://registry.npmjs.org/@pixi/particle-container/-/particle-container-7.3.0.tgz -> npmpkg-@pixi-particle-container-7.3.0.tgz
https://registry.npmjs.org/@pixi/prepare/-/prepare-7.3.0.tgz -> npmpkg-@pixi-prepare-7.3.0.tgz
https://registry.npmjs.org/@pixi/runner/-/runner-7.3.0.tgz -> npmpkg-@pixi-runner-7.3.0.tgz
https://registry.npmjs.org/@pixi/settings/-/settings-7.3.0.tgz -> npmpkg-@pixi-settings-7.3.0.tgz
https://registry.npmjs.org/@pixi/sprite/-/sprite-7.3.0.tgz -> npmpkg-@pixi-sprite-7.3.0.tgz
https://registry.npmjs.org/@pixi/sprite-animated/-/sprite-animated-7.3.0.tgz -> npmpkg-@pixi-sprite-animated-7.3.0.tgz
https://registry.npmjs.org/@pixi/sprite-tiling/-/sprite-tiling-7.3.0.tgz -> npmpkg-@pixi-sprite-tiling-7.3.0.tgz
https://registry.npmjs.org/@pixi/spritesheet/-/spritesheet-7.3.0.tgz -> npmpkg-@pixi-spritesheet-7.3.0.tgz
https://registry.npmjs.org/@pixi/text/-/text-7.3.0.tgz -> npmpkg-@pixi-text-7.3.0.tgz
https://registry.npmjs.org/@pixi/text-bitmap/-/text-bitmap-7.3.0.tgz -> npmpkg-@pixi-text-bitmap-7.3.0.tgz
https://registry.npmjs.org/@pixi/text-html/-/text-html-7.3.0.tgz -> npmpkg-@pixi-text-html-7.3.0.tgz
https://registry.npmjs.org/@pixi/ticker/-/ticker-7.3.0.tgz -> npmpkg-@pixi-ticker-7.3.0.tgz
https://registry.npmjs.org/@pixi/utils/-/utils-7.3.0.tgz -> npmpkg-@pixi-utils-7.3.0.tgz
https://registry.npmjs.org/@pkgjs/parseargs/-/parseargs-0.11.0.tgz -> npmpkg-@pkgjs-parseargs-0.11.0.tgz
https://registry.npmjs.org/@radix-ui/number/-/number-1.0.1.tgz -> npmpkg-@radix-ui-number-1.0.1.tgz
https://registry.npmjs.org/@radix-ui/primitive/-/primitive-1.0.1.tgz -> npmpkg-@radix-ui-primitive-1.0.1.tgz
https://registry.npmjs.org/@radix-ui/react-arrow/-/react-arrow-1.0.3.tgz -> npmpkg-@radix-ui-react-arrow-1.0.3.tgz
https://registry.npmjs.org/@radix-ui/react-collection/-/react-collection-1.0.3.tgz -> npmpkg-@radix-ui-react-collection-1.0.3.tgz
https://registry.npmjs.org/@radix-ui/react-compose-refs/-/react-compose-refs-1.0.1.tgz -> npmpkg-@radix-ui-react-compose-refs-1.0.1.tgz
https://registry.npmjs.org/@radix-ui/react-context/-/react-context-1.0.1.tgz -> npmpkg-@radix-ui-react-context-1.0.1.tgz
https://registry.npmjs.org/@radix-ui/react-direction/-/react-direction-1.0.1.tgz -> npmpkg-@radix-ui-react-direction-1.0.1.tgz
https://registry.npmjs.org/@radix-ui/react-dismissable-layer/-/react-dismissable-layer-1.0.4.tgz -> npmpkg-@radix-ui-react-dismissable-layer-1.0.4.tgz
https://registry.npmjs.org/@radix-ui/react-focus-guards/-/react-focus-guards-1.0.1.tgz -> npmpkg-@radix-ui-react-focus-guards-1.0.1.tgz
https://registry.npmjs.org/@radix-ui/react-focus-scope/-/react-focus-scope-1.0.3.tgz -> npmpkg-@radix-ui-react-focus-scope-1.0.3.tgz
https://registry.npmjs.org/@radix-ui/react-id/-/react-id-1.0.1.tgz -> npmpkg-@radix-ui-react-id-1.0.1.tgz
https://registry.npmjs.org/@radix-ui/react-popper/-/react-popper-1.1.2.tgz -> npmpkg-@radix-ui-react-popper-1.1.2.tgz
https://registry.npmjs.org/@radix-ui/react-portal/-/react-portal-1.0.3.tgz -> npmpkg-@radix-ui-react-portal-1.0.3.tgz
https://registry.npmjs.org/@radix-ui/react-primitive/-/react-primitive-1.0.3.tgz -> npmpkg-@radix-ui-react-primitive-1.0.3.tgz
https://registry.npmjs.org/@radix-ui/react-roving-focus/-/react-roving-focus-1.0.4.tgz -> npmpkg-@radix-ui-react-roving-focus-1.0.4.tgz
https://registry.npmjs.org/@radix-ui/react-select/-/react-select-1.2.2.tgz -> npmpkg-@radix-ui-react-select-1.2.2.tgz
https://registry.npmjs.org/@radix-ui/react-separator/-/react-separator-1.0.3.tgz -> npmpkg-@radix-ui-react-separator-1.0.3.tgz
https://registry.npmjs.org/@radix-ui/react-slot/-/react-slot-1.0.2.tgz -> npmpkg-@radix-ui-react-slot-1.0.2.tgz
https://registry.npmjs.org/@radix-ui/react-toggle/-/react-toggle-1.0.3.tgz -> npmpkg-@radix-ui-react-toggle-1.0.3.tgz
https://registry.npmjs.org/@radix-ui/react-toggle-group/-/react-toggle-group-1.0.4.tgz -> npmpkg-@radix-ui-react-toggle-group-1.0.4.tgz
https://registry.npmjs.org/@radix-ui/react-toolbar/-/react-toolbar-1.0.4.tgz -> npmpkg-@radix-ui-react-toolbar-1.0.4.tgz
https://registry.npmjs.org/@radix-ui/react-use-callback-ref/-/react-use-callback-ref-1.0.1.tgz -> npmpkg-@radix-ui-react-use-callback-ref-1.0.1.tgz
https://registry.npmjs.org/@radix-ui/react-use-controllable-state/-/react-use-controllable-state-1.0.1.tgz -> npmpkg-@radix-ui-react-use-controllable-state-1.0.1.tgz
https://registry.npmjs.org/@radix-ui/react-use-escape-keydown/-/react-use-escape-keydown-1.0.3.tgz -> npmpkg-@radix-ui-react-use-escape-keydown-1.0.3.tgz
https://registry.npmjs.org/@radix-ui/react-use-layout-effect/-/react-use-layout-effect-1.0.1.tgz -> npmpkg-@radix-ui-react-use-layout-effect-1.0.1.tgz
https://registry.npmjs.org/@radix-ui/react-use-previous/-/react-use-previous-1.0.1.tgz -> npmpkg-@radix-ui-react-use-previous-1.0.1.tgz
https://registry.npmjs.org/@radix-ui/react-use-rect/-/react-use-rect-1.0.1.tgz -> npmpkg-@radix-ui-react-use-rect-1.0.1.tgz
https://registry.npmjs.org/@radix-ui/react-use-size/-/react-use-size-1.0.1.tgz -> npmpkg-@radix-ui-react-use-size-1.0.1.tgz
https://registry.npmjs.org/@radix-ui/react-visually-hidden/-/react-visually-hidden-1.0.3.tgz -> npmpkg-@radix-ui-react-visually-hidden-1.0.3.tgz
https://registry.npmjs.org/@radix-ui/rect/-/rect-1.0.1.tgz -> npmpkg-@radix-ui-rect-1.0.1.tgz
https://registry.npmjs.org/@rollup/plugin-terser/-/plugin-terser-0.4.4.tgz -> npmpkg-@rollup-plugin-terser-0.4.4.tgz
https://registry.npmjs.org/serialize-javascript/-/serialize-javascript-6.0.2.tgz -> npmpkg-serialize-javascript-6.0.2.tgz
https://registry.npmjs.org/@storybook/addon-actions/-/addon-actions-7.4.6.tgz -> npmpkg-@storybook-addon-actions-7.4.6.tgz
https://registry.npmjs.org/uuid/-/uuid-9.0.1.tgz -> npmpkg-uuid-9.0.1.tgz
https://registry.npmjs.org/@storybook/addon-backgrounds/-/addon-backgrounds-7.4.6.tgz -> npmpkg-@storybook-addon-backgrounds-7.4.6.tgz
https://registry.npmjs.org/@storybook/addon-controls/-/addon-controls-7.4.6.tgz -> npmpkg-@storybook-addon-controls-7.4.6.tgz
https://registry.npmjs.org/@storybook/addon-docs/-/addon-docs-7.4.6.tgz -> npmpkg-@storybook-addon-docs-7.4.6.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-11.2.0.tgz -> npmpkg-fs-extra-11.2.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/@storybook/addon-essentials/-/addon-essentials-7.4.6.tgz -> npmpkg-@storybook-addon-essentials-7.4.6.tgz
https://registry.npmjs.org/@storybook/addon-highlight/-/addon-highlight-7.4.6.tgz -> npmpkg-@storybook-addon-highlight-7.4.6.tgz
https://registry.npmjs.org/@storybook/addon-measure/-/addon-measure-7.4.6.tgz -> npmpkg-@storybook-addon-measure-7.4.6.tgz
https://registry.npmjs.org/@storybook/addon-outline/-/addon-outline-7.4.6.tgz -> npmpkg-@storybook-addon-outline-7.4.6.tgz
https://registry.npmjs.org/@storybook/addon-toolbars/-/addon-toolbars-7.4.6.tgz -> npmpkg-@storybook-addon-toolbars-7.4.6.tgz
https://registry.npmjs.org/@storybook/addon-viewport/-/addon-viewport-7.4.6.tgz -> npmpkg-@storybook-addon-viewport-7.4.6.tgz
https://registry.npmjs.org/@storybook/addons/-/addons-7.4.6.tgz -> npmpkg-@storybook-addons-7.4.6.tgz
https://registry.npmjs.org/@storybook/blocks/-/blocks-7.4.6.tgz -> npmpkg-@storybook-blocks-7.4.6.tgz
https://registry.npmjs.org/@storybook/builder-manager/-/builder-manager-7.4.6.tgz -> npmpkg-@storybook-builder-manager-7.4.6.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-11.2.0.tgz -> npmpkg-fs-extra-11.2.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/@storybook/builder-webpack5/-/builder-webpack5-7.4.6.tgz -> npmpkg-@storybook-builder-webpack5-7.4.6.tgz
https://registry.npmjs.org/ajv/-/ajv-8.17.1.tgz -> npmpkg-ajv-8.17.1.tgz
https://registry.npmjs.org/ajv-keywords/-/ajv-keywords-5.1.0.tgz -> npmpkg-ajv-keywords-5.1.0.tgz
https://registry.npmjs.org/babel-loader/-/babel-loader-9.2.1.tgz -> npmpkg-babel-loader-9.2.1.tgz
https://registry.npmjs.org/find-cache-dir/-/find-cache-dir-4.0.0.tgz -> npmpkg-find-cache-dir-4.0.0.tgz
https://registry.npmjs.org/find-up/-/find-up-6.3.0.tgz -> npmpkg-find-up-6.3.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-11.2.0.tgz -> npmpkg-fs-extra-11.2.0.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz -> npmpkg-json-schema-traverse-1.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-7.2.0.tgz -> npmpkg-locate-path-7.2.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-4.0.0.tgz -> npmpkg-p-limit-4.0.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-6.0.0.tgz -> npmpkg-p-locate-6.0.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-5.0.0.tgz -> npmpkg-path-exists-5.0.0.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-7.0.0.tgz -> npmpkg-pkg-dir-7.0.0.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-4.2.0.tgz -> npmpkg-schema-utils-4.2.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/yocto-queue/-/yocto-queue-1.1.1.tgz -> npmpkg-yocto-queue-1.1.1.tgz
https://registry.npmjs.org/@storybook/channels/-/channels-7.4.6.tgz -> npmpkg-@storybook-channels-7.4.6.tgz
https://registry.npmjs.org/@storybook/cli/-/cli-7.4.6.tgz -> npmpkg-@storybook-cli-7.4.6.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/cli-cursor/-/cli-cursor-3.1.0.tgz -> npmpkg-cli-cursor-3.1.0.tgz
https://registry.npmjs.org/commander/-/commander-6.2.1.tgz -> npmpkg-commander-6.2.1.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz -> npmpkg-cross-spawn-7.0.3.tgz
https://registry.npmjs.org/detect-indent/-/detect-indent-6.1.0.tgz -> npmpkg-detect-indent-6.1.0.tgz
https://registry.npmjs.org/execa/-/execa-5.1.1.tgz -> npmpkg-execa-5.1.1.tgz
https://registry.npmjs.org/find-up/-/find-up-5.0.0.tgz -> npmpkg-find-up-5.0.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-11.2.0.tgz -> npmpkg-fs-extra-11.2.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-6.0.1.tgz -> npmpkg-get-stream-6.0.1.tgz
https://registry.npmjs.org/is-stream/-/is-stream-2.0.1.tgz -> npmpkg-is-stream-2.0.1.tgz
https://registry.npmjs.org/locate-path/-/locate-path-6.0.0.tgz -> npmpkg-locate-path-6.0.0.tgz
https://registry.npmjs.org/log-symbols/-/log-symbols-4.1.0.tgz -> npmpkg-log-symbols-4.1.0.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-2.1.0.tgz -> npmpkg-mimic-fn-2.1.0.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-4.0.1.tgz -> npmpkg-npm-run-path-4.0.1.tgz
https://registry.npmjs.org/onetime/-/onetime-5.1.2.tgz -> npmpkg-onetime-5.1.2.tgz
https://registry.npmjs.org/ora/-/ora-5.4.1.tgz -> npmpkg-ora-5.4.1.tgz
https://registry.npmjs.org/p-limit/-/p-limit-3.1.0.tgz -> npmpkg-p-limit-3.1.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-5.0.0.tgz -> npmpkg-p-locate-5.0.0.tgz
https://registry.npmjs.org/parse-json/-/parse-json-5.2.0.tgz -> npmpkg-parse-json-5.2.0.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/prettier/-/prettier-2.8.8.tgz -> npmpkg-prettier-2.8.8.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-5.2.0.tgz -> npmpkg-read-pkg-5.2.0.tgz
https://registry.npmjs.org/read-pkg-up/-/read-pkg-up-7.0.1.tgz -> npmpkg-read-pkg-up-7.0.1.tgz
https://registry.npmjs.org/find-up/-/find-up-4.1.0.tgz -> npmpkg-find-up-4.1.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-5.0.0.tgz -> npmpkg-locate-path-5.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-4.1.0.tgz -> npmpkg-p-locate-4.1.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.6.0.tgz -> npmpkg-type-fest-0.6.0.tgz
https://registry.npmjs.org/restore-cursor/-/restore-cursor-3.1.0.tgz -> npmpkg-restore-cursor-3.1.0.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-3.1.1.tgz -> npmpkg-strip-json-comments-3.1.1.tgz
https://registry.npmjs.org/tempy/-/tempy-1.0.1.tgz -> npmpkg-tempy-1.0.1.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.16.0.tgz -> npmpkg-type-fest-0.16.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.8.1.tgz -> npmpkg-type-fest-0.8.1.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/@storybook/client-api/-/client-api-7.4.6.tgz -> npmpkg-@storybook-client-api-7.4.6.tgz
https://registry.npmjs.org/@storybook/client-logger/-/client-logger-7.4.6.tgz -> npmpkg-@storybook-client-logger-7.4.6.tgz
https://registry.npmjs.org/@storybook/codemod/-/codemod-7.4.6.tgz -> npmpkg-@storybook-codemod-7.4.6.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz -> npmpkg-cross-spawn-7.0.3.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/prettier/-/prettier-2.8.8.tgz -> npmpkg-prettier-2.8.8.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/@storybook/components/-/components-7.4.6.tgz -> npmpkg-@storybook-components-7.4.6.tgz
https://registry.npmjs.org/@storybook/core-client/-/core-client-7.4.6.tgz -> npmpkg-@storybook-core-client-7.4.6.tgz
https://registry.npmjs.org/@storybook/core-common/-/core-common-7.4.6.tgz -> npmpkg-@storybook-core-common-7.4.6.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz -> npmpkg-cross-spawn-7.0.3.tgz
https://registry.npmjs.org/find-up/-/find-up-5.0.0.tgz -> npmpkg-find-up-5.0.0.tgz
https://registry.npmjs.org/foreground-child/-/foreground-child-3.3.0.tgz -> npmpkg-foreground-child-3.3.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-11.2.0.tgz -> npmpkg-fs-extra-11.2.0.tgz
https://registry.npmjs.org/glob/-/glob-10.4.5.tgz -> npmpkg-glob-10.4.5.tgz
https://registry.npmjs.org/locate-path/-/locate-path-6.0.0.tgz -> npmpkg-locate-path-6.0.0.tgz
https://registry.npmjs.org/minimatch/-/minimatch-9.0.5.tgz -> npmpkg-minimatch-9.0.5.tgz
https://registry.npmjs.org/minipass/-/minipass-7.1.2.tgz -> npmpkg-minipass-7.1.2.tgz
https://registry.npmjs.org/p-limit/-/p-limit-3.1.0.tgz -> npmpkg-p-limit-3.1.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-5.0.0.tgz -> npmpkg-p-locate-5.0.0.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-5.0.0.tgz -> npmpkg-pkg-dir-5.0.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-5.0.0.tgz -> npmpkg-resolve-from-5.0.0.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-4.1.0.tgz -> npmpkg-signal-exit-4.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/@storybook/core-events/-/core-events-7.4.6.tgz -> npmpkg-@storybook-core-events-7.4.6.tgz
https://registry.npmjs.org/@storybook/core-server/-/core-server-7.4.6.tgz -> npmpkg-@storybook-core-server-7.4.6.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-11.2.0.tgz -> npmpkg-fs-extra-11.2.0.tgz
https://registry.npmjs.org/open/-/open-8.4.2.tgz -> npmpkg-open-8.4.2.tgz
https://registry.npmjs.org/parse-json/-/parse-json-5.2.0.tgz -> npmpkg-parse-json-5.2.0.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-5.2.0.tgz -> npmpkg-read-pkg-5.2.0.tgz
https://registry.npmjs.org/read-pkg-up/-/read-pkg-up-7.0.1.tgz -> npmpkg-read-pkg-up-7.0.1.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.6.0.tgz -> npmpkg-type-fest-0.6.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.8.1.tgz -> npmpkg-type-fest-0.8.1.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/ws/-/ws-8.18.0.tgz -> npmpkg-ws-8.18.0.tgz
https://registry.npmjs.org/@storybook/core-webpack/-/core-webpack-7.4.6.tgz -> npmpkg-@storybook-core-webpack-7.4.6.tgz
https://registry.npmjs.org/@storybook/csf/-/csf-0.1.1.tgz -> npmpkg-@storybook-csf-0.1.1.tgz
https://registry.npmjs.org/@storybook/csf-plugin/-/csf-plugin-7.4.6.tgz -> npmpkg-@storybook-csf-plugin-7.4.6.tgz
https://registry.npmjs.org/@storybook/csf-tools/-/csf-tools-7.4.6.tgz -> npmpkg-@storybook-csf-tools-7.4.6.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-11.2.0.tgz -> npmpkg-fs-extra-11.2.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/type-fest/-/type-fest-2.19.0.tgz -> npmpkg-type-fest-2.19.0.tgz
https://registry.npmjs.org/@storybook/docs-mdx/-/docs-mdx-0.1.0.tgz -> npmpkg-@storybook-docs-mdx-0.1.0.tgz
https://registry.npmjs.org/@storybook/docs-tools/-/docs-tools-7.4.6.tgz -> npmpkg-@storybook-docs-tools-7.4.6.tgz
https://registry.npmjs.org/@storybook/global/-/global-5.0.0.tgz -> npmpkg-@storybook-global-5.0.0.tgz
https://registry.npmjs.org/@storybook/manager/-/manager-7.4.6.tgz -> npmpkg-@storybook-manager-7.4.6.tgz
https://registry.npmjs.org/@storybook/manager-api/-/manager-api-7.4.6.tgz -> npmpkg-@storybook-manager-api-7.4.6.tgz
https://registry.npmjs.org/@storybook/mdx2-csf/-/mdx2-csf-1.1.0.tgz -> npmpkg-@storybook-mdx2-csf-1.1.0.tgz
https://registry.npmjs.org/@storybook/node-logger/-/node-logger-7.4.6.tgz -> npmpkg-@storybook-node-logger-7.4.6.tgz
https://registry.npmjs.org/@storybook/postinstall/-/postinstall-7.4.6.tgz -> npmpkg-@storybook-postinstall-7.4.6.tgz
https://registry.npmjs.org/@storybook/preset-create-react-app/-/preset-create-react-app-7.4.6.tgz -> npmpkg-@storybook-preset-create-react-app-7.4.6.tgz
https://registry.npmjs.org/@storybook/preset-react-webpack/-/preset-react-webpack-7.4.6.tgz -> npmpkg-@storybook-preset-react-webpack-7.4.6.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-11.2.0.tgz -> npmpkg-fs-extra-11.2.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/@storybook/preview/-/preview-7.4.6.tgz -> npmpkg-@storybook-preview-7.4.6.tgz
https://registry.npmjs.org/@storybook/preview-api/-/preview-api-7.4.6.tgz -> npmpkg-@storybook-preview-api-7.4.6.tgz
https://registry.npmjs.org/@storybook/react/-/react-7.4.6.tgz -> npmpkg-@storybook-react-7.4.6.tgz
https://registry.npmjs.org/@storybook/react-docgen-typescript-plugin/-/react-docgen-typescript-plugin-1.0.6--canary.9.0c3f3b7.0.tgz -> npmpkg-@storybook-react-docgen-typescript-plugin-1.0.6--canary.9.0c3f3b7.0.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/@storybook/react-dom-shim/-/react-dom-shim-7.4.6.tgz -> npmpkg-@storybook-react-dom-shim-7.4.6.tgz
https://registry.npmjs.org/@storybook/react-webpack5/-/react-webpack5-7.4.6.tgz -> npmpkg-@storybook-react-webpack5-7.4.6.tgz
https://registry.npmjs.org/type-fest/-/type-fest-2.19.0.tgz -> npmpkg-type-fest-2.19.0.tgz
https://registry.npmjs.org/@storybook/router/-/router-7.4.6.tgz -> npmpkg-@storybook-router-7.4.6.tgz
https://registry.npmjs.org/@storybook/store/-/store-7.4.6.tgz -> npmpkg-@storybook-store-7.4.6.tgz
https://registry.npmjs.org/@storybook/telemetry/-/telemetry-7.4.6.tgz -> npmpkg-@storybook-telemetry-7.4.6.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-11.2.0.tgz -> npmpkg-fs-extra-11.2.0.tgz
https://registry.npmjs.org/parse-json/-/parse-json-5.2.0.tgz -> npmpkg-parse-json-5.2.0.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-5.2.0.tgz -> npmpkg-read-pkg-5.2.0.tgz
https://registry.npmjs.org/read-pkg-up/-/read-pkg-up-7.0.1.tgz -> npmpkg-read-pkg-up-7.0.1.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.6.0.tgz -> npmpkg-type-fest-0.6.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.8.1.tgz -> npmpkg-type-fest-0.8.1.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/@storybook/theming/-/theming-7.4.6.tgz -> npmpkg-@storybook-theming-7.4.6.tgz
https://registry.npmjs.org/@storybook/types/-/types-7.4.6.tgz -> npmpkg-@storybook-types-7.4.6.tgz
https://registry.npmjs.org/cosmiconfig/-/cosmiconfig-7.1.0.tgz -> npmpkg-cosmiconfig-7.1.0.tgz
https://registry.npmjs.org/cosmiconfig/-/cosmiconfig-7.1.0.tgz -> npmpkg-cosmiconfig-7.1.0.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-2.0.4.tgz -> npmpkg-loader-utils-2.0.4.tgz
https://registry.npmjs.org/@swc/core/-/core-1.3.92.tgz -> npmpkg-@swc-core-1.3.92.tgz
https://registry.npmjs.org/@swc/core-darwin-arm64/-/core-darwin-arm64-1.3.92.tgz -> npmpkg-@swc-core-darwin-arm64-1.3.92.tgz
https://registry.npmjs.org/@swc/core-darwin-x64/-/core-darwin-x64-1.3.92.tgz -> npmpkg-@swc-core-darwin-x64-1.3.92.tgz
https://registry.npmjs.org/@swc/core-linux-arm-gnueabihf/-/core-linux-arm-gnueabihf-1.3.92.tgz -> npmpkg-@swc-core-linux-arm-gnueabihf-1.3.92.tgz
https://registry.npmjs.org/@swc/core-linux-arm64-gnu/-/core-linux-arm64-gnu-1.3.92.tgz -> npmpkg-@swc-core-linux-arm64-gnu-1.3.92.tgz
https://registry.npmjs.org/@swc/core-linux-arm64-musl/-/core-linux-arm64-musl-1.3.92.tgz -> npmpkg-@swc-core-linux-arm64-musl-1.3.92.tgz
https://registry.npmjs.org/@swc/core-linux-x64-gnu/-/core-linux-x64-gnu-1.3.92.tgz -> npmpkg-@swc-core-linux-x64-gnu-1.3.92.tgz
https://registry.npmjs.org/@swc/core-linux-x64-musl/-/core-linux-x64-musl-1.3.92.tgz -> npmpkg-@swc-core-linux-x64-musl-1.3.92.tgz
https://registry.npmjs.org/@swc/core-win32-arm64-msvc/-/core-win32-arm64-msvc-1.3.92.tgz -> npmpkg-@swc-core-win32-arm64-msvc-1.3.92.tgz
https://registry.npmjs.org/@swc/core-win32-ia32-msvc/-/core-win32-ia32-msvc-1.3.92.tgz -> npmpkg-@swc-core-win32-ia32-msvc-1.3.92.tgz
https://registry.npmjs.org/@swc/core-win32-x64-msvc/-/core-win32-x64-msvc-1.3.92.tgz -> npmpkg-@swc-core-win32-x64-msvc-1.3.92.tgz
https://registry.npmjs.org/@swc/counter/-/counter-0.1.2.tgz -> npmpkg-@swc-counter-0.1.2.tgz
https://registry.npmjs.org/@swc/types/-/types-0.1.5.tgz -> npmpkg-@swc-types-0.1.5.tgz
https://registry.npmjs.org/@types/cross-spawn/-/cross-spawn-6.0.3.tgz -> npmpkg-@types-cross-spawn-6.0.3.tgz
https://registry.npmjs.org/@types/css-font-loading-module/-/css-font-loading-module-0.0.7.tgz -> npmpkg-@types-css-font-loading-module-0.0.7.tgz
https://registry.npmjs.org/@types/detect-port/-/detect-port-1.3.3.tgz -> npmpkg-@types-detect-port-1.3.3.tgz
https://registry.npmjs.org/@types/doctrine/-/doctrine-0.0.3.tgz -> npmpkg-@types-doctrine-0.0.3.tgz
https://registry.npmjs.org/@types/earcut/-/earcut-2.1.3.tgz -> npmpkg-@types-earcut-2.1.3.tgz
https://registry.npmjs.org/@types/ejs/-/ejs-3.1.3.tgz -> npmpkg-@types-ejs-3.1.3.tgz
https://registry.npmjs.org/@types/emscripten/-/emscripten-1.39.8.tgz -> npmpkg-@types-emscripten-1.39.8.tgz
https://registry.npmjs.org/@types/escodegen/-/escodegen-0.0.6.tgz -> npmpkg-@types-escodegen-0.0.6.tgz
https://registry.npmjs.org/@types/find-cache-dir/-/find-cache-dir-3.2.1.tgz -> npmpkg-@types-find-cache-dir-3.2.1.tgz
https://registry.npmjs.org/@types/html-minifier-terser/-/html-minifier-terser-6.1.0.tgz -> npmpkg-@types-html-minifier-terser-6.1.0.tgz
https://registry.npmjs.org/@types/lodash/-/lodash-4.14.199.tgz -> npmpkg-@types-lodash-4.14.199.tgz
https://registry.npmjs.org/@types/mdx/-/mdx-2.0.8.tgz -> npmpkg-@types-mdx-2.0.8.tgz
https://registry.npmjs.org/@types/mime-types/-/mime-types-2.1.2.tgz -> npmpkg-@types-mime-types-2.1.2.tgz
https://registry.npmjs.org/@types/node-fetch/-/node-fetch-2.6.6.tgz -> npmpkg-@types-node-fetch-2.6.6.tgz
https://registry.npmjs.org/form-data/-/form-data-4.0.0.tgz -> npmpkg-form-data-4.0.0.tgz
https://registry.npmjs.org/@types/normalize-package-data/-/normalize-package-data-2.4.2.tgz -> npmpkg-@types-normalize-package-data-2.4.2.tgz
https://registry.npmjs.org/@types/offscreencanvas/-/offscreencanvas-2019.7.2.tgz -> npmpkg-@types-offscreencanvas-2019.7.2.tgz
https://registry.npmjs.org/@types/pretty-hrtime/-/pretty-hrtime-1.0.1.tgz -> npmpkg-@types-pretty-hrtime-1.0.1.tgz
https://registry.npmjs.org/csstype/-/csstype-3.1.3.tgz -> npmpkg-csstype-3.1.3.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-13.0.12.tgz -> npmpkg-@types-yargs-13.0.12.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/@webassemblyjs/ast/-/ast-1.11.6.tgz -> npmpkg-@webassemblyjs-ast-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/floating-point-hex-parser/-/floating-point-hex-parser-1.11.6.tgz -> npmpkg-@webassemblyjs-floating-point-hex-parser-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/helper-api-error/-/helper-api-error-1.11.6.tgz -> npmpkg-@webassemblyjs-helper-api-error-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/helper-buffer/-/helper-buffer-1.11.6.tgz -> npmpkg-@webassemblyjs-helper-buffer-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/helper-numbers/-/helper-numbers-1.11.6.tgz -> npmpkg-@webassemblyjs-helper-numbers-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/helper-wasm-bytecode/-/helper-wasm-bytecode-1.11.6.tgz -> npmpkg-@webassemblyjs-helper-wasm-bytecode-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/helper-wasm-section/-/helper-wasm-section-1.11.6.tgz -> npmpkg-@webassemblyjs-helper-wasm-section-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/ieee754/-/ieee754-1.11.6.tgz -> npmpkg-@webassemblyjs-ieee754-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/leb128/-/leb128-1.11.6.tgz -> npmpkg-@webassemblyjs-leb128-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/utf8/-/utf8-1.11.6.tgz -> npmpkg-@webassemblyjs-utf8-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-edit/-/wasm-edit-1.11.6.tgz -> npmpkg-@webassemblyjs-wasm-edit-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-gen/-/wasm-gen-1.11.6.tgz -> npmpkg-@webassemblyjs-wasm-gen-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-opt/-/wasm-opt-1.11.6.tgz -> npmpkg-@webassemblyjs-wasm-opt-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-parser/-/wasm-parser-1.11.6.tgz -> npmpkg-@webassemblyjs-wasm-parser-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/wast-printer/-/wast-printer-1.11.6.tgz -> npmpkg-@webassemblyjs-wast-printer-1.11.6.tgz
https://registry.npmjs.org/@xtuc/ieee754/-/ieee754-1.2.0.tgz -> npmpkg-@xtuc-ieee754-1.2.0.tgz
https://registry.npmjs.org/@xtuc/long/-/long-4.2.2.tgz -> npmpkg-@xtuc-long-4.2.2.tgz
https://registry.npmjs.org/@yarnpkg/esbuild-plugin-pnp/-/esbuild-plugin-pnp-3.0.0-rc.15.tgz -> npmpkg-@yarnpkg-esbuild-plugin-pnp-3.0.0-rc.15.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/@yarnpkg/fslib/-/fslib-2.10.3.tgz -> npmpkg-@yarnpkg-fslib-2.10.3.tgz
https://registry.npmjs.org/@yarnpkg/libzip/-/libzip-2.3.0.tgz -> npmpkg-@yarnpkg-libzip-2.3.0.tgz
https://registry.npmjs.org/acorn/-/acorn-8.12.1.tgz -> npmpkg-acorn-8.12.1.tgz
https://registry.npmjs.org/acorn-import-assertions/-/acorn-import-assertions-1.9.0.tgz -> npmpkg-acorn-import-assertions-1.9.0.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/aggregate-error/-/aggregate-error-3.1.0.tgz -> npmpkg-aggregate-error-3.1.0.tgz
https://registry.npmjs.org/ajv/-/ajv-6.12.6.tgz -> npmpkg-ajv-6.12.6.tgz
https://registry.npmjs.org/ajv/-/ajv-8.17.1.tgz -> npmpkg-ajv-8.17.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/app-root-dir/-/app-root-dir-1.0.2.tgz -> npmpkg-app-root-dir-1.0.2.tgz
https://registry.npmjs.org/aria-hidden/-/aria-hidden-1.2.3.tgz -> npmpkg-aria-hidden-1.2.3.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/async-limiter/-/async-limiter-1.0.1.tgz -> npmpkg-async-limiter-1.0.1.tgz
https://registry.npmjs.org/axios/-/axios-0.28.0.tgz -> npmpkg-axios-0.28.0.tgz
https://registry.npmjs.org/form-data/-/form-data-4.0.0.tgz -> npmpkg-form-data-4.0.0.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.4.tgz -> npmpkg-@types-istanbul-reports-3.0.4.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-16.0.9.tgz -> npmpkg-@types-yargs-16.0.9.tgz
https://registry.npmjs.org/ci-info/-/ci-info-3.9.0.tgz -> npmpkg-ci-info-3.9.0.tgz
https://registry.npmjs.org/babel-plugin-add-react-displayname/-/babel-plugin-add-react-displayname-0.0.5.tgz -> npmpkg-babel-plugin-add-react-displayname-0.0.5.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz -> npmpkg-import-fresh-3.3.0.tgz
https://registry.npmjs.org/parse-json/-/parse-json-5.2.0.tgz -> npmpkg-parse-json-5.2.0.tgz
https://registry.npmjs.org/babel-plugin-named-exports-order/-/babel-plugin-named-exports-order-0.0.2.tgz -> npmpkg-babel-plugin-named-exports-order-0.0.2.tgz
https://registry.npmjs.org/babel-plugin-polyfill-corejs2/-/babel-plugin-polyfill-corejs2-0.3.3.tgz -> npmpkg-babel-plugin-polyfill-corejs2-0.3.3.tgz
https://registry.npmjs.org/@babel/helper-define-polyfill-provider/-/helper-define-polyfill-provider-0.3.3.tgz -> npmpkg-@babel-helper-define-polyfill-provider-0.3.3.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/babel-plugin-polyfill-corejs3/-/babel-plugin-polyfill-corejs3-0.5.3.tgz -> npmpkg-babel-plugin-polyfill-corejs3-0.5.3.tgz
https://registry.npmjs.org/@babel/helper-define-polyfill-provider/-/helper-define-polyfill-provider-0.3.3.tgz -> npmpkg-@babel-helper-define-polyfill-provider-0.3.3.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/babel-plugin-polyfill-regenerator/-/babel-plugin-polyfill-regenerator-0.3.1.tgz -> npmpkg-babel-plugin-polyfill-regenerator-0.3.1.tgz
https://registry.npmjs.org/cosmiconfig/-/cosmiconfig-7.1.0.tgz -> npmpkg-cosmiconfig-7.1.0.tgz
https://registry.npmjs.org/base64-js/-/base64-js-1.5.1.tgz -> npmpkg-base64-js-1.5.1.tgz
https://registry.npmjs.org/better-opn/-/better-opn-3.0.2.tgz -> npmpkg-better-opn-3.0.2.tgz
https://registry.npmjs.org/open/-/open-8.4.2.tgz -> npmpkg-open-8.4.2.tgz
https://registry.npmjs.org/big-integer/-/big-integer-1.6.51.tgz -> npmpkg-big-integer-1.6.51.tgz
https://registry.npmjs.org/bl/-/bl-4.1.0.tgz -> npmpkg-bl-4.1.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/body-parser/-/body-parser-1.20.2.tgz -> npmpkg-body-parser-1.20.2.tgz
https://registry.npmjs.org/depd/-/depd-2.0.0.tgz -> npmpkg-depd-2.0.0.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.4.24.tgz -> npmpkg-iconv-lite-0.4.24.tgz
https://registry.npmjs.org/bplist-parser/-/bplist-parser-0.2.0.tgz -> npmpkg-bplist-parser-0.2.0.tgz
https://registry.npmjs.org/braces/-/braces-3.0.3.tgz -> npmpkg-braces-3.0.3.tgz
https://registry.npmjs.org/browser-assert/-/browser-assert-1.2.1.tgz -> npmpkg-browser-assert-1.2.1.tgz
https://registry.npmjs.org/browserify-zlib/-/browserify-zlib-0.1.4.tgz -> npmpkg-browserify-zlib-0.1.4.tgz
https://registry.npmjs.org/pako/-/pako-0.2.9.tgz -> npmpkg-pako-0.2.9.tgz
https://registry.npmjs.org/browserslist/-/browserslist-4.24.0.tgz -> npmpkg-browserslist-4.24.0.tgz
https://registry.npmjs.org/buffer/-/buffer-5.7.1.tgz -> npmpkg-buffer-5.7.1.tgz
https://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.2.13.tgz -> npmpkg-buffer-crc32-0.2.13.tgz
https://registry.npmjs.org/bytes/-/bytes-3.1.2.tgz -> npmpkg-bytes-3.1.2.tgz
https://registry.npmjs.org/call-bind/-/call-bind-1.0.7.tgz -> npmpkg-call-bind-1.0.7.tgz
https://registry.npmjs.org/camel-case/-/camel-case-4.1.2.tgz -> npmpkg-camel-case-4.1.2.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/caniuse-lite/-/caniuse-lite-1.0.30001666.tgz -> npmpkg-caniuse-lite-1.0.30001666.tgz
https://registry.npmjs.org/chownr/-/chownr-2.0.0.tgz -> npmpkg-chownr-2.0.0.tgz
https://registry.npmjs.org/clean-css/-/clean-css-5.3.2.tgz -> npmpkg-clean-css-5.3.2.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/clean-stack/-/clean-stack-2.2.0.tgz -> npmpkg-clean-stack-2.2.0.tgz
https://registry.npmjs.org/cli-spinners/-/cli-spinners-2.9.1.tgz -> npmpkg-cli-spinners-2.9.1.tgz
https://registry.npmjs.org/cli-table3/-/cli-table3-0.6.3.tgz -> npmpkg-cli-table3-0.6.3.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> npmpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/clone-deep/-/clone-deep-4.0.1.tgz -> npmpkg-clone-deep-4.0.1.tgz
https://registry.npmjs.org/is-plain-object/-/is-plain-object-2.0.4.tgz -> npmpkg-is-plain-object-2.0.4.tgz
https://registry.npmjs.org/colorette/-/colorette-2.0.20.tgz -> npmpkg-colorette-2.0.20.tgz
https://registry.npmjs.org/concat-stream/-/concat-stream-1.6.2.tgz -> npmpkg-concat-stream-1.6.2.tgz
https://registry.npmjs.org/constants-browserify/-/constants-browserify-1.0.0.tgz -> npmpkg-constants-browserify-1.0.0.tgz
https://registry.npmjs.org/content-type/-/content-type-1.0.5.tgz -> npmpkg-content-type-1.0.5.tgz
https://registry.npmjs.org/convert-source-map/-/convert-source-map-1.9.0.tgz -> npmpkg-convert-source-map-1.9.0.tgz
https://registry.npmjs.org/cookie/-/cookie-0.6.0.tgz -> npmpkg-cookie-0.6.0.tgz
https://registry.npmjs.org/core-js/-/core-js-2.6.12.tgz -> npmpkg-core-js-2.6.12.tgz
https://registry.npmjs.org/core-js-compat/-/core-js-compat-3.38.1.tgz -> npmpkg-core-js-compat-3.38.1.tgz
https://registry.npmjs.org/css-loader/-/css-loader-6.8.1.tgz -> npmpkg-css-loader-6.8.1.tgz
https://registry.npmjs.org/icss-utils/-/icss-utils-5.1.0.tgz -> npmpkg-icss-utils-5.1.0.tgz
https://registry.npmjs.org/postcss-modules-extract-imports/-/postcss-modules-extract-imports-3.0.0.tgz -> npmpkg-postcss-modules-extract-imports-3.0.0.tgz
https://registry.npmjs.org/postcss-modules-local-by-default/-/postcss-modules-local-by-default-4.0.3.tgz -> npmpkg-postcss-modules-local-by-default-4.0.3.tgz
https://registry.npmjs.org/postcss-modules-scope/-/postcss-modules-scope-3.0.0.tgz -> npmpkg-postcss-modules-scope-3.0.0.tgz
https://registry.npmjs.org/postcss-modules-values/-/postcss-modules-values-4.0.0.tgz -> npmpkg-postcss-modules-values-4.0.0.tgz
https://registry.npmjs.org/css-select/-/css-select-4.3.0.tgz -> npmpkg-css-select-4.3.0.tgz
https://registry.npmjs.org/nth-check/-/nth-check-2.1.1.tgz -> npmpkg-nth-check-2.1.1.tgz
https://registry.npmjs.org/css-what/-/css-what-6.1.0.tgz -> npmpkg-css-what-6.1.0.tgz
https://registry.npmjs.org/csstype/-/csstype-2.6.21.tgz -> npmpkg-csstype-2.6.21.tgz
https://registry.npmjs.org/d3-color/-/d3-color-3.1.0.tgz -> npmpkg-d3-color-3.1.0.tgz
https://registry.npmjs.org/default-browser-id/-/default-browser-id-3.0.0.tgz -> npmpkg-default-browser-id-3.0.0.tgz
https://registry.npmjs.org/define-data-property/-/define-data-property-1.1.4.tgz -> npmpkg-define-data-property-1.1.4.tgz
https://registry.npmjs.org/defu/-/defu-6.1.2.tgz -> npmpkg-defu-6.1.2.tgz
https://registry.npmjs.org/del/-/del-6.1.1.tgz -> npmpkg-del-6.1.1.tgz
https://registry.npmjs.org/rimraf/-/rimraf-3.0.2.tgz -> npmpkg-rimraf-3.0.2.tgz
https://registry.npmjs.org/slash/-/slash-3.0.0.tgz -> npmpkg-slash-3.0.0.tgz
https://registry.npmjs.org/destroy/-/destroy-1.2.0.tgz -> npmpkg-destroy-1.2.0.tgz
https://registry.npmjs.org/detect-node-es/-/detect-node-es-1.1.0.tgz -> npmpkg-detect-node-es-1.1.0.tgz
https://registry.npmjs.org/detect-package-manager/-/detect-package-manager-2.0.1.tgz -> npmpkg-detect-package-manager-2.0.1.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz -> npmpkg-cross-spawn-7.0.3.tgz
https://registry.npmjs.org/execa/-/execa-5.1.1.tgz -> npmpkg-execa-5.1.1.tgz
https://registry.npmjs.org/get-stream/-/get-stream-6.0.1.tgz -> npmpkg-get-stream-6.0.1.tgz
https://registry.npmjs.org/is-stream/-/is-stream-2.0.1.tgz -> npmpkg-is-stream-2.0.1.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-2.1.0.tgz -> npmpkg-mimic-fn-2.1.0.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-4.0.1.tgz -> npmpkg-npm-run-path-4.0.1.tgz
https://registry.npmjs.org/onetime/-/onetime-5.1.2.tgz -> npmpkg-onetime-5.1.2.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/detect-port/-/detect-port-1.5.1.tgz -> npmpkg-detect-port-1.5.1.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/dom-converter/-/dom-converter-0.2.0.tgz -> npmpkg-dom-converter-0.2.0.tgz
https://registry.npmjs.org/dom-helpers/-/dom-helpers-5.2.1.tgz -> npmpkg-dom-helpers-5.2.1.tgz
https://registry.npmjs.org/csstype/-/csstype-3.1.3.tgz -> npmpkg-csstype-3.1.3.tgz
https://registry.npmjs.org/dot-case/-/dot-case-3.0.4.tgz -> npmpkg-dot-case-3.0.4.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/dotenv/-/dotenv-16.4.5.tgz -> npmpkg-dotenv-16.4.5.tgz
https://registry.npmjs.org/duplexify/-/duplexify-3.7.1.tgz -> npmpkg-duplexify-3.7.1.tgz
https://registry.npmjs.org/earcut/-/earcut-2.2.4.tgz -> npmpkg-earcut-2.2.4.tgz
https://registry.npmjs.org/ee-first/-/ee-first-1.1.1.tgz -> npmpkg-ee-first-1.1.1.tgz
https://registry.npmjs.org/ejs/-/ejs-3.1.10.tgz -> npmpkg-ejs-3.1.10.tgz
https://registry.npmjs.org/electron-to-chromium/-/electron-to-chromium-1.5.31.tgz -> npmpkg-electron-to-chromium-1.5.31.tgz
https://registry.npmjs.org/encodeurl/-/encodeurl-1.0.2.tgz -> npmpkg-encodeurl-1.0.2.tgz
https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.4.4.tgz -> npmpkg-end-of-stream-1.4.4.tgz
https://registry.npmjs.org/endent/-/endent-2.1.0.tgz -> npmpkg-endent-2.1.0.tgz
https://registry.npmjs.org/enhanced-resolve/-/enhanced-resolve-5.15.0.tgz -> npmpkg-enhanced-resolve-5.15.0.tgz
https://registry.npmjs.org/envinfo/-/envinfo-7.10.0.tgz -> npmpkg-envinfo-7.10.0.tgz
https://registry.npmjs.org/es-define-property/-/es-define-property-1.0.0.tgz -> npmpkg-es-define-property-1.0.0.tgz
https://registry.npmjs.org/es-errors/-/es-errors-1.3.0.tgz -> npmpkg-es-errors-1.3.0.tgz
https://registry.npmjs.org/esbuild/-/esbuild-0.18.20.tgz -> npmpkg-esbuild-0.18.20.tgz
https://registry.npmjs.org/esbuild-plugin-alias/-/esbuild-plugin-alias-0.2.1.tgz -> npmpkg-esbuild-plugin-alias-0.2.1.tgz
https://registry.npmjs.org/esbuild-register/-/esbuild-register-3.5.0.tgz -> npmpkg-esbuild-register-3.5.0.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/escalade/-/escalade-3.2.0.tgz -> npmpkg-escalade-3.2.0.tgz
https://registry.npmjs.org/escodegen/-/escodegen-2.1.0.tgz -> npmpkg-escodegen-2.1.0.tgz
https://registry.npmjs.org/resolve/-/resolve-2.0.0-next.5.tgz -> npmpkg-resolve-2.0.0-next.5.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-5.1.1.tgz -> npmpkg-eslint-scope-5.1.1.tgz
https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-3.4.3.tgz -> npmpkg-eslint-visitor-keys-3.4.3.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-7.2.2.tgz -> npmpkg-eslint-scope-7.2.2.tgz
https://registry.npmjs.org/globals/-/globals-13.24.0.tgz -> npmpkg-globals-13.24.0.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz -> npmpkg-import-fresh-3.3.0.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/estraverse/-/estraverse-5.3.0.tgz -> npmpkg-estraverse-5.3.0.tgz
https://registry.npmjs.org/etag/-/etag-1.8.1.tgz -> npmpkg-etag-1.8.1.tgz
https://registry.npmjs.org/eventemitter3/-/eventemitter3-4.0.7.tgz -> npmpkg-eventemitter3-4.0.7.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.4.tgz -> npmpkg-@types-istanbul-reports-3.0.4.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-16.0.9.tgz -> npmpkg-@types-yargs-16.0.9.tgz
https://registry.npmjs.org/express/-/express-4.19.2.tgz -> npmpkg-express-4.19.2.tgz
https://registry.npmjs.org/extract-zip/-/extract-zip-1.7.0.tgz -> npmpkg-extract-zip-1.7.0.tgz
https://registry.npmjs.org/fast-glob/-/fast-glob-3.3.2.tgz -> npmpkg-fast-glob-3.3.2.tgz
https://registry.npmjs.org/fast-json-parse/-/fast-json-parse-1.0.3.tgz -> npmpkg-fast-json-parse-1.0.3.tgz
https://registry.npmjs.org/fast-uri/-/fast-uri-3.0.2.tgz -> npmpkg-fast-uri-3.0.2.tgz
https://registry.npmjs.org/fd-slicer/-/fd-slicer-1.1.0.tgz -> npmpkg-fd-slicer-1.1.0.tgz
https://registry.npmjs.org/fetch-retry/-/fetch-retry-5.0.6.tgz -> npmpkg-fetch-retry-5.0.6.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-2.0.4.tgz -> npmpkg-loader-utils-2.0.4.tgz
https://registry.npmjs.org/file-system-cache/-/file-system-cache-2.3.0.tgz -> npmpkg-file-system-cache-2.3.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-11.1.1.tgz -> npmpkg-fs-extra-11.1.1.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-5.1.6.tgz -> npmpkg-minimatch-5.1.6.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.1.1.tgz -> npmpkg-fill-range-7.1.1.tgz
https://registry.npmjs.org/finalhandler/-/finalhandler-1.2.0.tgz -> npmpkg-finalhandler-1.2.0.tgz
https://registry.npmjs.org/statuses/-/statuses-2.0.1.tgz -> npmpkg-statuses-2.0.1.tgz
https://registry.npmjs.org/find-cache-dir/-/find-cache-dir-3.3.2.tgz -> npmpkg-find-cache-dir-3.3.2.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-3.0.1.tgz -> npmpkg-ansi-regex-3.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.0.4.tgz -> npmpkg-minimatch-3.0.4.tgz
https://registry.npmjs.org/minimist/-/minimist-0.2.4.tgz -> npmpkg-minimist-0.2.4.tgz
https://registry.npmjs.org/prop-types/-/prop-types-15.5.10.tgz -> npmpkg-prop-types-15.5.10.tgz
https://registry.npmjs.org/flow-parser/-/flow-parser-0.218.0.tgz -> npmpkg-flow-parser-0.218.0.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/follow-redirects/-/follow-redirects-1.15.6.tgz -> npmpkg-follow-redirects-1.15.6.tgz
https://registry.npmjs.org/fork-ts-checker-webpack-plugin/-/fork-ts-checker-webpack-plugin-8.0.0.tgz -> npmpkg-fork-ts-checker-webpack-plugin-8.0.0.tgz
https://registry.npmjs.org/cosmiconfig/-/cosmiconfig-7.1.0.tgz -> npmpkg-cosmiconfig-7.1.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz -> npmpkg-import-fresh-3.3.0.tgz
https://registry.npmjs.org/parse-json/-/parse-json-5.2.0.tgz -> npmpkg-parse-json-5.2.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz -> npmpkg-resolve-from-4.0.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/fresh/-/fresh-0.5.2.tgz -> npmpkg-fresh-0.5.2.tgz
https://registry.npmjs.org/fs-constants/-/fs-constants-1.0.0.tgz -> npmpkg-fs-constants-1.0.0.tgz
https://registry.npmjs.org/fs-minipass/-/fs-minipass-2.1.0.tgz -> npmpkg-fs-minipass-2.1.0.tgz
https://registry.npmjs.org/minipass/-/minipass-3.3.6.tgz -> npmpkg-minipass-3.3.6.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz -> npmpkg-fsevents-2.3.3.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.2.tgz -> npmpkg-function-bind-1.1.2.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.2.4.tgz -> npmpkg-get-intrinsic-1.2.4.tgz
https://registry.npmjs.org/get-nonce/-/get-nonce-1.0.1.tgz -> npmpkg-get-nonce-1.0.1.tgz
https://registry.npmjs.org/get-npm-tarball-url/-/get-npm-tarball-url-2.0.3.tgz -> npmpkg-get-npm-tarball-url-2.0.3.tgz
https://registry.npmjs.org/get-port/-/get-port-5.1.1.tgz -> npmpkg-get-port-5.1.1.tgz
https://registry.npmjs.org/getobject/-/getobject-1.0.0.tgz -> npmpkg-getobject-1.0.0.tgz
https://registry.npmjs.org/giget/-/giget-1.1.3.tgz -> npmpkg-giget-1.1.3.tgz
https://registry.npmjs.org/agent-base/-/agent-base-7.1.1.tgz -> npmpkg-agent-base-7.1.1.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-7.0.5.tgz -> npmpkg-https-proxy-agent-7.0.5.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/github-slugger/-/github-slugger-1.5.0.tgz -> npmpkg-github-slugger-1.5.0.tgz
https://registry.npmjs.org/glob-to-regexp/-/glob-to-regexp-0.4.1.tgz -> npmpkg-glob-to-regexp-0.4.1.tgz
https://registry.npmjs.org/gunzip-maybe/-/gunzip-maybe-1.4.2.tgz -> npmpkg-gunzip-maybe-1.4.2.tgz
https://registry.npmjs.org/handlebars/-/handlebars-4.7.8.tgz -> npmpkg-handlebars-4.7.8.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/has-property-descriptors/-/has-property-descriptors-1.0.2.tgz -> npmpkg-has-property-descriptors-1.0.2.tgz
https://registry.npmjs.org/hasown/-/hasown-2.0.2.tgz -> npmpkg-hasown-2.0.2.tgz
https://registry.npmjs.org/he/-/he-1.2.0.tgz -> npmpkg-he-1.2.0.tgz
https://registry.npmjs.org/html-minifier-terser/-/html-minifier-terser-6.1.0.tgz -> npmpkg-html-minifier-terser-6.1.0.tgz
https://registry.npmjs.org/commander/-/commander-8.3.0.tgz -> npmpkg-commander-8.3.0.tgz
https://registry.npmjs.org/html-webpack-plugin/-/html-webpack-plugin-5.5.3.tgz -> npmpkg-html-webpack-plugin-5.5.3.tgz
https://registry.npmjs.org/htmlparser2/-/htmlparser2-6.1.0.tgz -> npmpkg-htmlparser2-6.1.0.tgz
https://registry.npmjs.org/http-errors/-/http-errors-2.0.0.tgz -> npmpkg-http-errors-2.0.0.tgz
https://registry.npmjs.org/depd/-/depd-2.0.0.tgz -> npmpkg-depd-2.0.0.tgz
https://registry.npmjs.org/statuses/-/statuses-2.0.1.tgz -> npmpkg-statuses-2.0.1.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/ieee754/-/ieee754-1.2.1.tgz -> npmpkg-ieee754-1.2.1.tgz
https://registry.npmjs.org/indent-string/-/indent-string-4.0.0.tgz -> npmpkg-indent-string-4.0.0.tgz
https://registry.npmjs.org/ini/-/ini-1.3.6.tgz -> npmpkg-ini-1.3.6.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-3.0.1.tgz -> npmpkg-ansi-regex-3.0.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-4.1.1.tgz -> npmpkg-ansi-regex-4.1.1.tgz
https://registry.npmjs.org/ip/-/ip-2.0.1.tgz -> npmpkg-ip-2.0.1.tgz
https://registry.npmjs.org/is-absolute-url/-/is-absolute-url-3.0.3.tgz -> npmpkg-is-absolute-url-3.0.3.tgz
https://registry.npmjs.org/is-arguments/-/is-arguments-1.1.1.tgz -> npmpkg-is-arguments-1.1.1.tgz
https://registry.npmjs.org/is-core-module/-/is-core-module-2.15.1.tgz -> npmpkg-is-core-module-2.15.1.tgz
https://registry.npmjs.org/is-deflate/-/is-deflate-1.0.0.tgz -> npmpkg-is-deflate-1.0.0.tgz
https://registry.npmjs.org/is-generator-function/-/is-generator-function-1.0.10.tgz -> npmpkg-is-generator-function-1.0.10.tgz
https://registry.npmjs.org/is-gzip/-/is-gzip-1.0.0.tgz -> npmpkg-is-gzip-1.0.0.tgz
https://registry.npmjs.org/is-interactive/-/is-interactive-1.0.0.tgz -> npmpkg-is-interactive-1.0.0.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/is-path-cwd/-/is-path-cwd-2.2.0.tgz -> npmpkg-is-path-cwd-2.2.0.tgz
https://registry.npmjs.org/is-plain-object/-/is-plain-object-5.0.0.tgz -> npmpkg-is-plain-object-5.0.0.tgz
https://registry.npmjs.org/is-unicode-supported/-/is-unicode-supported-0.1.0.tgz -> npmpkg-is-unicode-supported-0.1.0.tgz
https://registry.npmjs.org/ismobilejs/-/ismobilejs-1.1.1.tgz -> npmpkg-ismobilejs-1.1.1.tgz
https://registry.npmjs.org/iso-639-1/-/iso-639-1-3.1.2.tgz -> npmpkg-iso-639-1-3.1.2.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/jackspeak/-/jackspeak-3.4.3.tgz -> npmpkg-jackspeak-3.4.3.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.4.tgz -> npmpkg-@types-istanbul-reports-3.0.4.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-16.0.9.tgz -> npmpkg-@types-yargs-16.0.9.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.4.tgz -> npmpkg-@types-istanbul-reports-3.0.4.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-16.0.9.tgz -> npmpkg-@types-yargs-16.0.9.tgz
https://registry.npmjs.org/ci-info/-/ci-info-3.9.0.tgz -> npmpkg-ci-info-3.9.0.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.4.tgz -> npmpkg-@types-istanbul-reports-3.0.4.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-16.0.9.tgz -> npmpkg-@types-yargs-16.0.9.tgz
https://registry.npmjs.org/ci-info/-/ci-info-3.9.0.tgz -> npmpkg-ci-info-3.9.0.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.4.tgz -> npmpkg-@types-istanbul-reports-3.0.4.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-16.0.9.tgz -> npmpkg-@types-yargs-16.0.9.tgz
https://registry.npmjs.org/ci-info/-/ci-info-3.9.0.tgz -> npmpkg-ci-info-3.9.0.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.4.tgz -> npmpkg-@types-istanbul-reports-3.0.4.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-16.0.9.tgz -> npmpkg-@types-yargs-16.0.9.tgz
https://registry.npmjs.org/ci-info/-/ci-info-3.9.0.tgz -> npmpkg-ci-info-3.9.0.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.4.tgz -> npmpkg-@types-istanbul-reports-3.0.4.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-16.0.9.tgz -> npmpkg-@types-yargs-16.0.9.tgz
https://registry.npmjs.org/ci-info/-/ci-info-3.9.0.tgz -> npmpkg-ci-info-3.9.0.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.4.tgz -> npmpkg-@types-istanbul-reports-3.0.4.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-16.0.9.tgz -> npmpkg-@types-yargs-16.0.9.tgz
https://registry.npmjs.org/ci-info/-/ci-info-3.9.0.tgz -> npmpkg-ci-info-3.9.0.tgz
https://registry.npmjs.org/jest-haste-map/-/jest-haste-map-29.7.0.tgz -> npmpkg-jest-haste-map-29.7.0.tgz
https://registry.npmjs.org/@jest/schemas/-/schemas-29.6.3.tgz -> npmpkg-@jest-schemas-29.6.3.tgz
https://registry.npmjs.org/@jest/types/-/types-29.6.3.tgz -> npmpkg-@jest-types-29.6.3.tgz
https://registry.npmjs.org/@sinclair/typebox/-/typebox-0.27.8.tgz -> npmpkg-@sinclair-typebox-0.27.8.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.4.tgz -> npmpkg-@types-istanbul-reports-3.0.4.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-17.0.33.tgz -> npmpkg-@types-yargs-17.0.33.tgz
https://registry.npmjs.org/jest-regex-util/-/jest-regex-util-29.6.3.tgz -> npmpkg-jest-regex-util-29.6.3.tgz
https://registry.npmjs.org/jest-worker/-/jest-worker-29.7.0.tgz -> npmpkg-jest-worker-29.7.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-8.1.1.tgz -> npmpkg-supports-color-8.1.1.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.4.tgz -> npmpkg-@types-istanbul-reports-3.0.4.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-16.0.9.tgz -> npmpkg-@types-yargs-16.0.9.tgz
https://registry.npmjs.org/ci-info/-/ci-info-3.9.0.tgz -> npmpkg-ci-info-3.9.0.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.4.tgz -> npmpkg-@types-istanbul-reports-3.0.4.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-16.0.9.tgz -> npmpkg-@types-yargs-16.0.9.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.4.tgz -> npmpkg-@types-istanbul-reports-3.0.4.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-16.0.9.tgz -> npmpkg-@types-yargs-16.0.9.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.4.tgz -> npmpkg-@types-istanbul-reports-3.0.4.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-16.0.9.tgz -> npmpkg-@types-yargs-16.0.9.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.4.tgz -> npmpkg-@types-istanbul-reports-3.0.4.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-16.0.9.tgz -> npmpkg-@types-yargs-16.0.9.tgz
https://registry.npmjs.org/ci-info/-/ci-info-3.9.0.tgz -> npmpkg-ci-info-3.9.0.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.4.tgz -> npmpkg-@types-istanbul-reports-3.0.4.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-16.0.9.tgz -> npmpkg-@types-yargs-16.0.9.tgz
https://registry.npmjs.org/ci-info/-/ci-info-3.9.0.tgz -> npmpkg-ci-info-3.9.0.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.4.tgz -> npmpkg-@types-istanbul-reports-3.0.4.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-16.0.9.tgz -> npmpkg-@types-yargs-16.0.9.tgz
https://registry.npmjs.org/ci-info/-/ci-info-3.9.0.tgz -> npmpkg-ci-info-3.9.0.tgz
https://registry.npmjs.org/jest-serializer/-/jest-serializer-27.5.1.tgz -> npmpkg-jest-serializer-27.5.1.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.4.tgz -> npmpkg-@types-istanbul-reports-3.0.4.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-16.0.9.tgz -> npmpkg-@types-yargs-16.0.9.tgz
https://registry.npmjs.org/ci-info/-/ci-info-3.9.0.tgz -> npmpkg-ci-info-3.9.0.tgz
https://registry.npmjs.org/jest-util/-/jest-util-29.7.0.tgz -> npmpkg-jest-util-29.7.0.tgz
https://registry.npmjs.org/@jest/schemas/-/schemas-29.6.3.tgz -> npmpkg-@jest-schemas-29.6.3.tgz
https://registry.npmjs.org/@jest/types/-/types-29.6.3.tgz -> npmpkg-@jest-types-29.6.3.tgz
https://registry.npmjs.org/@sinclair/typebox/-/typebox-0.27.8.tgz -> npmpkg-@sinclair-typebox-0.27.8.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.4.tgz -> npmpkg-@types-istanbul-reports-3.0.4.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-17.0.33.tgz -> npmpkg-@types-yargs-17.0.33.tgz
https://registry.npmjs.org/ci-info/-/ci-info-3.9.0.tgz -> npmpkg-ci-info-3.9.0.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.4.tgz -> npmpkg-@types-istanbul-reports-3.0.4.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-17.0.33.tgz -> npmpkg-@types-yargs-17.0.33.tgz
https://registry.npmjs.org/ci-info/-/ci-info-3.9.0.tgz -> npmpkg-ci-info-3.9.0.tgz
https://registry.npmjs.org/react-is/-/react-is-18.3.1.tgz -> npmpkg-react-is-18.3.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-6.1.0.tgz -> npmpkg-ansi-regex-6.1.0.tgz
https://registry.npmjs.org/@types/istanbul-reports/-/istanbul-reports-3.0.4.tgz -> npmpkg-@types-istanbul-reports-3.0.4.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-16.0.9.tgz -> npmpkg-@types-yargs-16.0.9.tgz
https://registry.npmjs.org/ci-info/-/ci-info-3.9.0.tgz -> npmpkg-ci-info-3.9.0.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-3.14.1.tgz -> npmpkg-js-yaml-3.14.1.tgz
https://registry.npmjs.org/jscodeshift/-/jscodeshift-0.14.0.tgz -> npmpkg-jscodeshift-0.14.0.tgz
https://registry.npmjs.org/ast-types/-/ast-types-0.15.2.tgz -> npmpkg-ast-types-0.15.2.tgz
https://registry.npmjs.org/recast/-/recast-0.21.5.tgz -> npmpkg-recast-0.21.5.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/temp/-/temp-0.8.4.tgz -> npmpkg-temp-0.8.4.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/write-file-atomic/-/write-file-atomic-2.4.3.tgz -> npmpkg-write-file-atomic-2.4.3.tgz
https://registry.npmjs.org/jsdom/-/jsdom-16.6.0.tgz -> npmpkg-jsdom-16.6.0.tgz
https://registry.npmjs.org/json-schema/-/json-schema-0.4.0.tgz -> npmpkg-json-schema-0.4.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/csstype/-/csstype-3.1.3.tgz -> npmpkg-csstype-3.1.3.tgz
https://registry.npmjs.org/jszip/-/jszip-3.10.1.tgz -> npmpkg-jszip-3.10.1.tgz
https://registry.npmjs.org/lazy-universal-dotenv/-/lazy-universal-dotenv-4.0.0.tgz -> npmpkg-lazy-universal-dotenv-4.0.0.tgz
https://registry.npmjs.org/dotenv-expand/-/dotenv-expand-10.0.0.tgz -> npmpkg-dotenv-expand-10.0.0.tgz
https://registry.npmjs.org/loader-runner/-/loader-runner-4.3.0.tgz -> npmpkg-loader-runner-4.3.0.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/lower-case/-/lower-case-2.0.2.tgz -> npmpkg-lower-case-2.0.2.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/markdown-to-jsx/-/markdown-to-jsx-7.3.2.tgz -> npmpkg-markdown-to-jsx-7.3.2.tgz
https://registry.npmjs.org/mdast-util-definitions/-/mdast-util-definitions-4.0.0.tgz -> npmpkg-mdast-util-definitions-4.0.0.tgz
https://registry.npmjs.org/mdast-util-to-string/-/mdast-util-to-string-1.1.0.tgz -> npmpkg-mdast-util-to-string-1.1.0.tgz
https://registry.npmjs.org/media-typer/-/media-typer-0.3.0.tgz -> npmpkg-media-typer-0.3.0.tgz
https://registry.npmjs.org/memoize-one/-/memoize-one-5.2.1.tgz -> npmpkg-memoize-one-5.2.1.tgz
https://registry.npmjs.org/merge-descriptors/-/merge-descriptors-1.0.1.tgz -> npmpkg-merge-descriptors-1.0.1.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/micromatch/-/micromatch-4.0.5.tgz -> npmpkg-micromatch-4.0.5.tgz
https://registry.npmjs.org/mime/-/mime-1.6.0.tgz -> npmpkg-mime-1.6.0.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.0.5.tgz -> npmpkg-minimatch-3.0.5.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.8.tgz -> npmpkg-minimist-1.2.8.tgz
https://registry.npmjs.org/minipass/-/minipass-5.0.0.tgz -> npmpkg-minipass-5.0.0.tgz
https://registry.npmjs.org/minizlib/-/minizlib-2.1.2.tgz -> npmpkg-minizlib-2.1.2.tgz
https://registry.npmjs.org/minipass/-/minipass-3.3.6.tgz -> npmpkg-minipass-3.3.6.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.6.tgz -> npmpkg-mkdirp-0.5.6.tgz
https://registry.npmjs.org/mkdirp-classic/-/mkdirp-classic-0.5.3.tgz -> npmpkg-mkdirp-classic-0.5.3.tgz
https://registry.npmjs.org/mock-xmlhttprequest/-/mock-xmlhttprequest-8.2.0.tgz -> npmpkg-mock-xmlhttprequest-8.2.0.tgz
https://registry.npmjs.org/nanoid/-/nanoid-3.3.7.tgz -> npmpkg-nanoid-3.3.7.tgz
https://registry.npmjs.org/no-case/-/no-case-3.0.4.tgz -> npmpkg-no-case-3.0.4.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/node-abort-controller/-/node-abort-controller-3.1.1.tgz -> npmpkg-node-abort-controller-3.1.1.tgz
https://registry.npmjs.org/node-fetch/-/node-fetch-2.6.7.tgz -> npmpkg-node-fetch-2.6.7.tgz
https://registry.npmjs.org/node-fetch-native/-/node-fetch-native-1.4.0.tgz -> npmpkg-node-fetch-native-1.4.0.tgz
https://registry.npmjs.org/tr46/-/tr46-0.0.3.tgz -> npmpkg-tr46-0.0.3.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-3.0.1.tgz -> npmpkg-webidl-conversions-3.0.1.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-5.0.0.tgz -> npmpkg-whatwg-url-5.0.0.tgz
https://registry.npmjs.org/node-releases/-/node-releases-2.0.18.tgz -> npmpkg-node-releases-2.0.18.tgz
https://registry.npmjs.org/object-inspect/-/object-inspect-1.13.2.tgz -> npmpkg-object-inspect-1.13.2.tgz
https://registry.npmjs.org/objectorarray/-/objectorarray-1.0.5.tgz -> npmpkg-objectorarray-1.0.5.tgz
https://registry.npmjs.org/on-finished/-/on-finished-2.4.1.tgz -> npmpkg-on-finished-2.4.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-4.1.1.tgz -> npmpkg-ansi-regex-4.1.1.tgz
https://registry.npmjs.org/p-map/-/p-map-4.0.0.tgz -> npmpkg-p-map-4.0.0.tgz
https://registry.npmjs.org/package-json-from-dist/-/package-json-from-dist-1.0.1.tgz -> npmpkg-package-json-from-dist-1.0.1.tgz
https://registry.npmjs.org/param-case/-/param-case-3.0.4.tgz -> npmpkg-param-case-3.0.4.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/pascal-case/-/pascal-case-3.1.2.tgz -> npmpkg-pascal-case-3.1.2.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/path-scurry/-/path-scurry-1.11.1.tgz -> npmpkg-path-scurry-1.11.1.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-10.4.3.tgz -> npmpkg-lru-cache-10.4.3.tgz
https://registry.npmjs.org/path-to-regexp/-/path-to-regexp-0.1.7.tgz -> npmpkg-path-to-regexp-0.1.7.tgz
https://registry.npmjs.org/pathe/-/pathe-1.1.1.tgz -> npmpkg-pathe-1.1.1.tgz
https://registry.npmjs.org/peek-stream/-/peek-stream-1.1.3.tgz -> npmpkg-peek-stream-1.1.3.tgz
https://registry.npmjs.org/pend/-/pend-1.2.0.tgz -> npmpkg-pend-1.2.0.tgz
https://registry.npmjs.org/picocolors/-/picocolors-1.1.0.tgz -> npmpkg-picocolors-1.1.0.tgz
https://registry.npmjs.org/pixi-spine/-/pixi-spine-4.0.4.tgz -> npmpkg-pixi-spine-4.0.4.tgz
https://registry.npmjs.org/pixi.js/-/pixi.js-7.3.0.tgz -> npmpkg-pixi.js-7.3.0.tgz
https://registry.npmjs.org/pixi.js-legacy/-/pixi.js-legacy-7.3.0.tgz -> npmpkg-pixi.js-legacy-7.3.0.tgz
https://registry.npmjs.org/pnp-webpack-plugin/-/pnp-webpack-plugin-1.7.0.tgz -> npmpkg-pnp-webpack-plugin-1.7.0.tgz
https://registry.npmjs.org/polished/-/polished-4.2.2.tgz -> npmpkg-polished-4.2.2.tgz
https://registry.npmjs.org/postcss/-/postcss-8.4.31.tgz -> npmpkg-postcss-8.4.31.tgz
https://registry.npmjs.org/pretty-error/-/pretty-error-4.0.0.tgz -> npmpkg-pretty-error-4.0.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-4.1.1.tgz -> npmpkg-ansi-regex-4.1.1.tgz
https://registry.npmjs.org/pretty-hrtime/-/pretty-hrtime-1.0.3.tgz -> npmpkg-pretty-hrtime-1.0.3.tgz
https://registry.npmjs.org/progress/-/progress-2.0.3.tgz -> npmpkg-progress-2.0.3.tgz
https://registry.npmjs.org/protobufjs/-/protobufjs-6.11.4.tgz -> npmpkg-protobufjs-6.11.4.tgz
https://registry.npmjs.org/proxy-from-env/-/proxy-from-env-1.1.0.tgz -> npmpkg-proxy-from-env-1.1.0.tgz
https://registry.npmjs.org/pump/-/pump-3.0.2.tgz -> npmpkg-pump-3.0.2.tgz
https://registry.npmjs.org/pumpify/-/pumpify-1.5.1.tgz -> npmpkg-pumpify-1.5.1.tgz
https://registry.npmjs.org/pump/-/pump-2.0.1.tgz -> npmpkg-pump-2.0.1.tgz
https://registry.npmjs.org/puppeteer-core/-/puppeteer-core-2.1.1.tgz -> npmpkg-puppeteer-core-2.1.1.tgz
https://registry.npmjs.org/agent-base/-/agent-base-5.1.1.tgz -> npmpkg-agent-base-5.1.1.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-4.0.0.tgz -> npmpkg-https-proxy-agent-4.0.0.tgz
https://registry.npmjs.org/mime/-/mime-2.6.0.tgz -> npmpkg-mime-2.6.0.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/ws/-/ws-6.2.3.tgz -> npmpkg-ws-6.2.3.tgz
https://registry.npmjs.org/qs/-/qs-6.11.0.tgz -> npmpkg-qs-6.11.0.tgz
https://registry.npmjs.org/ramda/-/ramda-0.29.0.tgz -> npmpkg-ramda-0.29.0.tgz
https://registry.npmjs.org/raw-body/-/raw-body-2.5.2.tgz -> npmpkg-raw-body-2.5.2.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.4.24.tgz -> npmpkg-iconv-lite-0.4.24.tgz
https://registry.npmjs.org/core-js/-/core-js-3.38.1.tgz -> npmpkg-core-js-3.38.1.tgz
https://registry.npmjs.org/react-colorful/-/react-colorful-5.6.1.tgz -> npmpkg-react-colorful-5.6.1.tgz
https://registry.npmjs.org/react-docgen-typescript/-/react-docgen-typescript-2.2.2.tgz -> npmpkg-react-docgen-typescript-2.2.2.tgz
https://registry.npmjs.org/react-element-to-jsx-string/-/react-element-to-jsx-string-15.0.0.tgz -> npmpkg-react-element-to-jsx-string-15.0.0.tgz
https://registry.npmjs.org/react-is/-/react-is-18.1.0.tgz -> npmpkg-react-is-18.1.0.tgz
https://registry.npmjs.org/react-inspector/-/react-inspector-6.0.2.tgz -> npmpkg-react-inspector-6.0.2.tgz
https://registry.npmjs.org/react-is/-/react-is-18.3.1.tgz -> npmpkg-react-is-18.3.1.tgz
https://github.com/4ian/react-mosaic/archive/d5ef155119d786c08c7c72e34997dcef2f01f98b.tar.gz -> npmpkg-react-mosaic.git-d5ef155119d786c08c7c72e34997dcef2f01f98b.tgz
https://registry.npmjs.org/classnames/-/classnames-2.5.1.tgz -> npmpkg-classnames-2.5.1.tgz
https://registry.npmjs.org/react-remove-scroll/-/react-remove-scroll-2.5.5.tgz -> npmpkg-react-remove-scroll-2.5.5.tgz
https://registry.npmjs.org/react-remove-scroll-bar/-/react-remove-scroll-bar-2.3.4.tgz -> npmpkg-react-remove-scroll-bar-2.3.4.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/babel-loader/-/babel-loader-8.4.1.tgz -> npmpkg-babel-loader-8.4.1.tgz
https://registry.npmjs.org/commander/-/commander-7.2.0.tgz -> npmpkg-commander-7.2.0.tgz
https://registry.npmjs.org/ajv/-/ajv-8.17.1.tgz -> npmpkg-ajv-8.17.1.tgz
https://registry.npmjs.org/ajv/-/ajv-8.17.1.tgz -> npmpkg-ajv-8.17.1.tgz
https://registry.npmjs.org/ajv/-/ajv-8.17.1.tgz -> npmpkg-ajv-8.17.1.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-3.3.1.tgz -> npmpkg-loader-utils-3.3.1.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-2.7.0.tgz -> npmpkg-schema-utils-2.7.0.tgz
https://registry.npmjs.org/serialize-javascript/-/serialize-javascript-6.0.2.tgz -> npmpkg-serialize-javascript-6.0.2.tgz
https://registry.npmjs.org/tapable/-/tapable-1.1.3.tgz -> npmpkg-tapable-1.1.3.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/react-style-singleton/-/react-style-singleton-2.2.1.tgz -> npmpkg-react-style-singleton-2.2.1.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/react-transition-group/-/react-transition-group-4.4.5.tgz -> npmpkg-react-transition-group-4.4.5.tgz
https://registry.npmjs.org/react-window/-/react-window-1.8.9.tgz -> npmpkg-react-window-1.8.9.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/recast/-/recast-0.23.9.tgz -> npmpkg-recast-0.23.9.tgz
https://registry.npmjs.org/ast-types/-/ast-types-0.16.1.tgz -> npmpkg-ast-types-0.16.1.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.0.4.tgz -> npmpkg-minimatch-3.0.4.tgz
https://registry.npmjs.org/regenerate/-/regenerate-1.4.2.tgz -> npmpkg-regenerate-1.4.2.tgz
https://registry.npmjs.org/regenerate-unicode-properties/-/regenerate-unicode-properties-10.1.1.tgz -> npmpkg-regenerate-unicode-properties-10.1.1.tgz
https://registry.npmjs.org/regenerator-transform/-/regenerator-transform-0.15.2.tgz -> npmpkg-regenerator-transform-0.15.2.tgz
https://registry.npmjs.org/regexpu-core/-/regexpu-core-5.3.2.tgz -> npmpkg-regexpu-core-5.3.2.tgz
https://registry.npmjs.org/regjsparser/-/regjsparser-0.9.1.tgz -> npmpkg-regjsparser-0.9.1.tgz
https://registry.npmjs.org/jsesc/-/jsesc-0.5.0.tgz -> npmpkg-jsesc-0.5.0.tgz
https://registry.npmjs.org/relateurl/-/relateurl-0.2.7.tgz -> npmpkg-relateurl-0.2.7.tgz
https://registry.npmjs.org/remark-external-links/-/remark-external-links-8.0.0.tgz -> npmpkg-remark-external-links-8.0.0.tgz
https://registry.npmjs.org/remark-slug/-/remark-slug-6.1.0.tgz -> npmpkg-remark-slug-6.1.0.tgz
https://registry.npmjs.org/renderkid/-/renderkid-3.0.0.tgz -> npmpkg-renderkid-3.0.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/resolve/-/resolve-1.22.8.tgz -> npmpkg-resolve-1.22.8.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-3.3.0.tgz -> npmpkg-schema-utils-3.3.0.tgz
https://registry.npmjs.org/tmp/-/tmp-0.2.3.tgz -> npmpkg-tmp-0.2.3.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz -> npmpkg-semver-7.6.3.tgz
https://registry.npmjs.org/send/-/send-0.18.0.tgz -> npmpkg-send-0.18.0.tgz
https://registry.npmjs.org/depd/-/depd-2.0.0.tgz -> npmpkg-depd-2.0.0.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/statuses/-/statuses-2.0.1.tgz -> npmpkg-statuses-2.0.1.tgz
https://registry.npmjs.org/serve-static/-/serve-static-1.15.0.tgz -> npmpkg-serve-static-1.15.0.tgz
https://registry.npmjs.org/set-function-length/-/set-function-length-1.2.2.tgz -> npmpkg-set-function-length-1.2.2.tgz
https://registry.npmjs.org/setprototypeof/-/setprototypeof-1.2.0.tgz -> npmpkg-setprototypeof-1.2.0.tgz
https://registry.npmjs.org/shallow-clone/-/shallow-clone-3.0.1.tgz -> npmpkg-shallow-clone-3.0.1.tgz
https://registry.npmjs.org/shell-quote/-/shell-quote-1.8.1.tgz -> npmpkg-shell-quote-1.8.1.tgz
https://registry.npmjs.org/shelljs/-/shelljs-0.8.5.tgz -> npmpkg-shelljs-0.8.5.tgz
https://registry.npmjs.org/side-channel/-/side-channel-1.0.6.tgz -> npmpkg-side-channel-1.0.6.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-3.0.7.tgz -> npmpkg-signal-exit-3.0.7.tgz
https://registry.npmjs.org/simple-update-notifier/-/simple-update-notifier-2.0.0.tgz -> npmpkg-simple-update-notifier-2.0.0.tgz
https://registry.npmjs.org/smob/-/smob-1.5.0.tgz -> npmpkg-smob-1.5.0.tgz
https://registry.npmjs.org/source-map/-/source-map-0.7.4.tgz -> npmpkg-source-map-0.7.4.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/y18n/-/y18n-4.0.3.tgz -> npmpkg-y18n-4.0.3.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-18.1.3.tgz -> npmpkg-yargs-parser-18.1.3.tgz
https://registry.npmjs.org/source-map-js/-/source-map-js-1.2.1.tgz -> npmpkg-source-map-js-1.2.1.tgz
https://registry.npmjs.org/space-separated-tokens/-/space-separated-tokens-1.1.5.tgz -> npmpkg-space-separated-tokens-1.1.5.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/debug/-/debug-4.3.7.tgz -> npmpkg-debug-4.3.7.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/store2/-/store2-2.14.2.tgz -> npmpkg-store2-2.14.2.tgz
https://registry.npmjs.org/storybook/-/storybook-7.4.6.tgz -> npmpkg-storybook-7.4.6.tgz
https://registry.npmjs.org/storybook-addon-mock/-/storybook-addon-mock-4.2.1.tgz -> npmpkg-storybook-addon-mock-4.2.1.tgz
https://registry.npmjs.org/path-to-regexp/-/path-to-regexp-6.3.0.tgz -> npmpkg-path-to-regexp-6.3.0.tgz
https://registry.npmjs.org/stream-shift/-/stream-shift-1.0.1.tgz -> npmpkg-stream-shift-1.0.1.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> npmpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/strip-comments/-/strip-comments-2.0.1.tgz -> npmpkg-strip-comments-2.0.1.tgz
https://registry.npmjs.org/style-loader/-/style-loader-3.3.3.tgz -> npmpkg-style-loader-3.3.3.tgz
https://registry.npmjs.org/@jridgewell/gen-mapping/-/gen-mapping-0.3.5.tgz -> npmpkg-@jridgewell-gen-mapping-0.3.5.tgz
https://registry.npmjs.org/swc-loader/-/swc-loader-0.2.3.tgz -> npmpkg-swc-loader-0.2.3.tgz
https://registry.npmjs.org/synchronous-promise/-/synchronous-promise-2.0.17.tgz -> npmpkg-synchronous-promise-2.0.17.tgz
https://registry.npmjs.org/yaml/-/yaml-2.5.1.tgz -> npmpkg-yaml-2.5.1.tgz
https://registry.npmjs.org/tapable/-/tapable-2.2.1.tgz -> npmpkg-tapable-2.2.1.tgz
https://registry.npmjs.org/tar/-/tar-6.2.0.tgz -> npmpkg-tar-6.2.0.tgz
https://registry.npmjs.org/tar-fs/-/tar-fs-2.1.1.tgz -> npmpkg-tar-fs-2.1.1.tgz
https://registry.npmjs.org/chownr/-/chownr-1.1.4.tgz -> npmpkg-chownr-1.1.4.tgz
https://registry.npmjs.org/tar-stream/-/tar-stream-2.2.0.tgz -> npmpkg-tar-stream-2.2.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz -> npmpkg-readable-stream-3.6.2.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-1.0.4.tgz -> npmpkg-mkdirp-1.0.4.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/telejson/-/telejson-7.2.0.tgz -> npmpkg-telejson-7.2.0.tgz
https://registry.npmjs.org/temp/-/temp-0.9.4.tgz -> npmpkg-temp-0.9.4.tgz
https://registry.npmjs.org/terser/-/terser-5.21.0.tgz -> npmpkg-terser-5.21.0.tgz
https://registry.npmjs.org/terser-webpack-plugin/-/terser-webpack-plugin-5.3.9.tgz -> npmpkg-terser-webpack-plugin-5.3.9.tgz
https://registry.npmjs.org/serialize-javascript/-/serialize-javascript-6.0.2.tgz -> npmpkg-serialize-javascript-6.0.2.tgz
https://registry.npmjs.org/three/-/three-0.160.0.tgz -> npmpkg-three-0.160.0.tgz
https://registry.npmjs.org/through2/-/through2-2.0.5.tgz -> npmpkg-through2-2.0.5.tgz
https://registry.npmjs.org/tiny-invariant/-/tiny-invariant-1.3.3.tgz -> npmpkg-tiny-invariant-1.3.3.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/tocbot/-/tocbot-4.21.2.tgz -> npmpkg-tocbot-4.21.2.tgz
https://registry.npmjs.org/toidentifier/-/toidentifier-1.0.1.tgz -> npmpkg-toidentifier-1.0.1.tgz
https://registry.npmjs.org/punycode/-/punycode-2.3.1.tgz -> npmpkg-punycode-2.3.1.tgz
https://registry.npmjs.org/punycode/-/punycode-2.3.1.tgz -> npmpkg-punycode-2.3.1.tgz
https://registry.npmjs.org/ts-pnp/-/ts-pnp-1.2.0.tgz -> npmpkg-ts-pnp-1.2.0.tgz
https://registry.npmjs.org/tslib/-/tslib-1.14.1.tgz -> npmpkg-tslib-1.14.1.tgz
https://registry.npmjs.org/type-is/-/type-is-1.6.18.tgz -> npmpkg-type-is-1.6.18.tgz
https://registry.npmjs.org/typedarray/-/typedarray-0.0.6.tgz -> npmpkg-typedarray-0.0.6.tgz
https://registry.npmjs.org/ua-parser-js/-/ua-parser-js-0.7.33.tgz -> npmpkg-ua-parser-js-0.7.33.tgz
https://registry.npmjs.org/uglify-js/-/uglify-js-3.17.4.tgz -> npmpkg-uglify-js-3.17.4.tgz
https://registry.npmjs.org/unicode-canonical-property-names-ecmascript/-/unicode-canonical-property-names-ecmascript-2.0.0.tgz -> npmpkg-unicode-canonical-property-names-ecmascript-2.0.0.tgz
https://registry.npmjs.org/unicode-match-property-ecmascript/-/unicode-match-property-ecmascript-2.0.0.tgz -> npmpkg-unicode-match-property-ecmascript-2.0.0.tgz
https://registry.npmjs.org/unicode-match-property-value-ecmascript/-/unicode-match-property-value-ecmascript-2.1.0.tgz -> npmpkg-unicode-match-property-value-ecmascript-2.1.0.tgz
https://registry.npmjs.org/unicode-property-aliases-ecmascript/-/unicode-property-aliases-ecmascript-2.1.0.tgz -> npmpkg-unicode-property-aliases-ecmascript-2.1.0.tgz
https://registry.npmjs.org/unist-util-is/-/unist-util-is-4.1.0.tgz -> npmpkg-unist-util-is-4.1.0.tgz
https://registry.npmjs.org/unist-util-stringify-position/-/unist-util-stringify-position-3.0.3.tgz -> npmpkg-unist-util-stringify-position-3.0.3.tgz
https://registry.npmjs.org/unist-util-visit/-/unist-util-visit-2.0.3.tgz -> npmpkg-unist-util-visit-2.0.3.tgz
https://registry.npmjs.org/unist-util-visit-parents/-/unist-util-visit-parents-3.1.1.tgz -> npmpkg-unist-util-visit-parents-3.1.1.tgz
https://registry.npmjs.org/unpipe/-/unpipe-1.0.0.tgz -> npmpkg-unpipe-1.0.0.tgz
https://registry.npmjs.org/unplugin/-/unplugin-1.5.0.tgz -> npmpkg-unplugin-1.5.0.tgz
https://registry.npmjs.org/webpack-sources/-/webpack-sources-3.2.3.tgz -> npmpkg-webpack-sources-3.2.3.tgz
https://registry.npmjs.org/untildify/-/untildify-4.0.0.tgz -> npmpkg-untildify-4.0.0.tgz
https://registry.npmjs.org/update-browserslist-db/-/update-browserslist-db-1.1.1.tgz -> npmpkg-update-browserslist-db-1.1.1.tgz
https://registry.npmjs.org/punycode/-/punycode-2.3.1.tgz -> npmpkg-punycode-2.3.1.tgz
https://registry.npmjs.org/use-callback-ref/-/use-callback-ref-1.3.0.tgz -> npmpkg-use-callback-ref-1.3.0.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/use-resize-observer/-/use-resize-observer-9.1.0.tgz -> npmpkg-use-resize-observer-9.1.0.tgz
https://registry.npmjs.org/use-sidecar/-/use-sidecar-1.1.2.tgz -> npmpkg-use-sidecar-1.1.2.tgz
https://registry.npmjs.org/tslib/-/tslib-2.7.0.tgz -> npmpkg-tslib-2.7.0.tgz
https://registry.npmjs.org/util/-/util-0.12.5.tgz -> npmpkg-util-0.12.5.tgz
https://registry.npmjs.org/utila/-/utila-0.4.0.tgz -> npmpkg-utila-0.4.0.tgz
https://registry.npmjs.org/vfile/-/vfile-5.3.7.tgz -> npmpkg-vfile-5.3.7.tgz
https://registry.npmjs.org/vfile-message/-/vfile-message-3.1.4.tgz -> npmpkg-vfile-message-3.1.4.tgz
https://registry.npmjs.org/watchpack/-/watchpack-2.4.0.tgz -> npmpkg-watchpack-2.4.0.tgz
https://registry.npmjs.org/webpack/-/webpack-5.88.2.tgz -> npmpkg-webpack-5.88.2.tgz
https://registry.npmjs.org/webpack-dev-middleware/-/webpack-dev-middleware-6.1.3.tgz -> npmpkg-webpack-dev-middleware-6.1.3.tgz
https://registry.npmjs.org/ajv/-/ajv-8.17.1.tgz -> npmpkg-ajv-8.17.1.tgz
https://registry.npmjs.org/ajv-keywords/-/ajv-keywords-5.1.0.tgz -> npmpkg-ajv-keywords-5.1.0.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz -> npmpkg-json-schema-traverse-1.0.0.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-4.2.0.tgz -> npmpkg-schema-utils-4.2.0.tgz
https://registry.npmjs.org/ajv/-/ajv-8.17.1.tgz -> npmpkg-ajv-8.17.1.tgz
https://registry.npmjs.org/ipaddr.js/-/ipaddr.js-2.2.0.tgz -> npmpkg-ipaddr.js-2.2.0.tgz
https://registry.npmjs.org/webpack-dev-middleware/-/webpack-dev-middleware-5.3.4.tgz -> npmpkg-webpack-dev-middleware-5.3.4.tgz
https://registry.npmjs.org/ws/-/ws-8.18.0.tgz -> npmpkg-ws-8.18.0.tgz
https://registry.npmjs.org/webpack-virtual-modules/-/webpack-virtual-modules-0.5.0.tgz -> npmpkg-webpack-virtual-modules-0.5.0.tgz
https://registry.npmjs.org/@types/estree/-/estree-1.0.6.tgz -> npmpkg-@types-estree-1.0.6.tgz
https://registry.npmjs.org/events/-/events-3.3.0.tgz -> npmpkg-events-3.3.0.tgz
https://registry.npmjs.org/webpack-sources/-/webpack-sources-3.2.3.tgz -> npmpkg-webpack-sources-3.2.3.tgz
https://registry.npmjs.org/wordwrap/-/wordwrap-1.0.0.tgz -> npmpkg-wordwrap-1.0.0.tgz
https://registry.npmjs.org/workbox-background-sync/-/workbox-background-sync-7.1.0.tgz -> npmpkg-workbox-background-sync-7.1.0.tgz
https://registry.npmjs.org/idb/-/idb-7.1.1.tgz -> npmpkg-idb-7.1.1.tgz
https://registry.npmjs.org/workbox-broadcast-update/-/workbox-broadcast-update-7.1.0.tgz -> npmpkg-workbox-broadcast-update-7.1.0.tgz
https://registry.npmjs.org/workbox-build/-/workbox-build-7.1.1.tgz -> npmpkg-workbox-build-7.1.1.tgz
https://registry.npmjs.org/@apideck/better-ajv-errors/-/better-ajv-errors-0.3.6.tgz -> npmpkg-@apideck-better-ajv-errors-0.3.6.tgz
https://registry.npmjs.org/@rollup/plugin-node-resolve/-/plugin-node-resolve-15.3.0.tgz -> npmpkg-@rollup-plugin-node-resolve-15.3.0.tgz
https://registry.npmjs.org/@rollup/pluginutils/-/pluginutils-5.1.2.tgz -> npmpkg-@rollup-pluginutils-5.1.2.tgz
https://registry.npmjs.org/@types/estree/-/estree-1.0.6.tgz -> npmpkg-@types-estree-1.0.6.tgz
https://registry.npmjs.org/@types/resolve/-/resolve-1.20.2.tgz -> npmpkg-@types-resolve-1.20.2.tgz
https://registry.npmjs.org/ajv/-/ajv-8.17.1.tgz -> npmpkg-ajv-8.17.1.tgz
https://registry.npmjs.org/estree-walker/-/estree-walker-2.0.2.tgz -> npmpkg-estree-walker-2.0.2.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-9.1.0.tgz -> npmpkg-fs-extra-9.1.0.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz -> npmpkg-json-schema-traverse-1.0.0.tgz
https://registry.npmjs.org/punycode/-/punycode-2.3.1.tgz -> npmpkg-punycode-2.3.1.tgz
https://registry.npmjs.org/source-map/-/source-map-0.8.0-beta.0.tgz -> npmpkg-source-map-0.8.0-beta.0.tgz
https://registry.npmjs.org/tr46/-/tr46-1.0.1.tgz -> npmpkg-tr46-1.0.1.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-4.0.2.tgz -> npmpkg-webidl-conversions-4.0.2.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-7.1.0.tgz -> npmpkg-whatwg-url-7.1.0.tgz
https://registry.npmjs.org/workbox-recipes/-/workbox-recipes-7.1.0.tgz -> npmpkg-workbox-recipes-7.1.0.tgz
https://registry.npmjs.org/workbox-cacheable-response/-/workbox-cacheable-response-7.1.0.tgz -> npmpkg-workbox-cacheable-response-7.1.0.tgz
https://registry.npmjs.org/workbox-core/-/workbox-core-7.1.0.tgz -> npmpkg-workbox-core-7.1.0.tgz
https://registry.npmjs.org/workbox-expiration/-/workbox-expiration-7.1.0.tgz -> npmpkg-workbox-expiration-7.1.0.tgz
https://registry.npmjs.org/idb/-/idb-7.1.1.tgz -> npmpkg-idb-7.1.1.tgz
https://registry.npmjs.org/workbox-google-analytics/-/workbox-google-analytics-7.1.0.tgz -> npmpkg-workbox-google-analytics-7.1.0.tgz
https://registry.npmjs.org/workbox-navigation-preload/-/workbox-navigation-preload-7.1.0.tgz -> npmpkg-workbox-navigation-preload-7.1.0.tgz
https://registry.npmjs.org/workbox-precaching/-/workbox-precaching-7.1.0.tgz -> npmpkg-workbox-precaching-7.1.0.tgz
https://registry.npmjs.org/workbox-range-requests/-/workbox-range-requests-7.1.0.tgz -> npmpkg-workbox-range-requests-7.1.0.tgz
https://registry.npmjs.org/workbox-routing/-/workbox-routing-7.1.0.tgz -> npmpkg-workbox-routing-7.1.0.tgz
https://registry.npmjs.org/workbox-strategies/-/workbox-strategies-7.1.0.tgz -> npmpkg-workbox-strategies-7.1.0.tgz
https://registry.npmjs.org/workbox-streams/-/workbox-streams-7.1.0.tgz -> npmpkg-workbox-streams-7.1.0.tgz
https://registry.npmjs.org/workbox-sw/-/workbox-sw-7.1.0.tgz -> npmpkg-workbox-sw-7.1.0.tgz
https://registry.npmjs.org/ajv/-/ajv-8.17.1.tgz -> npmpkg-ajv-8.17.1.tgz
https://registry.npmjs.org/punycode/-/punycode-2.3.1.tgz -> npmpkg-punycode-2.3.1.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz -> npmpkg-universalify-2.0.1.tgz
https://registry.npmjs.org/workbox-window/-/workbox-window-7.1.0.tgz -> npmpkg-workbox-window-7.1.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> npmpkg-wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> npmpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/ws/-/ws-7.5.10.tgz -> npmpkg-ws-7.5.10.tgz
https://registry.npmjs.org/xtend/-/xtend-4.0.2.tgz -> npmpkg-xtend-4.0.2.tgz
https://registry.npmjs.org/y18n/-/y18n-3.2.2.tgz -> npmpkg-y18n-3.2.2.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-13.1.2.tgz -> npmpkg-yargs-parser-13.1.2.tgz
https://registry.npmjs.org/yauzl/-/yauzl-2.10.0.tgz -> npmpkg-yauzl-2.10.0.tgz
https://registry.npmjs.org/@pixi-spine/base/-/base-4.0.3.tgz -> npmpkg-@pixi-spine-base-4.0.3.tgz
https://registry.npmjs.org/@pixi-spine/loader-base/-/loader-base-4.0.4.tgz -> npmpkg-@pixi-spine-loader-base-4.0.4.tgz
https://registry.npmjs.org/@pixi-spine/loader-uni/-/loader-uni-4.0.3.tgz -> npmpkg-@pixi-spine-loader-uni-4.0.3.tgz
https://registry.npmjs.org/@pixi-spine/runtime-3.7/-/runtime-3.7-4.0.3.tgz -> npmpkg-@pixi-spine-runtime-3.7-4.0.3.tgz
https://registry.npmjs.org/@pixi-spine/runtime-3.8/-/runtime-3.8-4.0.3.tgz -> npmpkg-@pixi-spine-runtime-3.8-4.0.3.tgz
https://registry.npmjs.org/@pixi-spine/runtime-4.0/-/runtime-4.0-4.0.3.tgz -> npmpkg-@pixi-spine-runtime-4.0-4.0.3.tgz
https://registry.npmjs.org/@pixi-spine/runtime-4.1/-/runtime-4.1-4.0.3.tgz -> npmpkg-@pixi-spine-runtime-4.1-4.0.3.tgz
https://registry.npmjs.org/@pixi/accessibility/-/accessibility-7.3.0.tgz -> npmpkg-@pixi-accessibility-7.3.0.tgz
https://registry.npmjs.org/@pixi/app/-/app-7.3.0.tgz -> npmpkg-@pixi-app-7.3.0.tgz
https://registry.npmjs.org/@pixi/assets/-/assets-7.3.0.tgz -> npmpkg-@pixi-assets-7.3.0.tgz
https://registry.npmjs.org/@pixi/color/-/color-7.3.0.tgz -> npmpkg-@pixi-color-7.3.0.tgz
https://registry.npmjs.org/@pixi/compressed-textures/-/compressed-textures-7.3.0.tgz -> npmpkg-@pixi-compressed-textures-7.3.0.tgz
https://registry.npmjs.org/@pixi/constants/-/constants-7.3.0.tgz -> npmpkg-@pixi-constants-7.3.0.tgz
https://registry.npmjs.org/@pixi/core/-/core-7.3.0.tgz -> npmpkg-@pixi-core-7.3.0.tgz
https://registry.npmjs.org/@pixi/display/-/display-7.3.0.tgz -> npmpkg-@pixi-display-7.3.0.tgz
https://registry.npmjs.org/@pixi/events/-/events-7.3.0.tgz -> npmpkg-@pixi-events-7.3.0.tgz
https://registry.npmjs.org/@pixi/extensions/-/extensions-7.3.0.tgz -> npmpkg-@pixi-extensions-7.3.0.tgz
https://registry.npmjs.org/@pixi/extract/-/extract-7.3.0.tgz -> npmpkg-@pixi-extract-7.3.0.tgz
https://registry.npmjs.org/@pixi/filter-alpha/-/filter-alpha-7.3.0.tgz -> npmpkg-@pixi-filter-alpha-7.3.0.tgz
https://registry.npmjs.org/@pixi/filter-blur/-/filter-blur-7.3.0.tgz -> npmpkg-@pixi-filter-blur-7.3.0.tgz
https://registry.npmjs.org/@pixi/filter-color-matrix/-/filter-color-matrix-7.3.0.tgz -> npmpkg-@pixi-filter-color-matrix-7.3.0.tgz
https://registry.npmjs.org/@pixi/filter-displacement/-/filter-displacement-7.3.0.tgz -> npmpkg-@pixi-filter-displacement-7.3.0.tgz
https://registry.npmjs.org/@pixi/filter-fxaa/-/filter-fxaa-7.3.0.tgz -> npmpkg-@pixi-filter-fxaa-7.3.0.tgz
https://registry.npmjs.org/@pixi/filter-noise/-/filter-noise-7.3.0.tgz -> npmpkg-@pixi-filter-noise-7.3.0.tgz
https://registry.npmjs.org/@pixi/graphics/-/graphics-7.3.0.tgz -> npmpkg-@pixi-graphics-7.3.0.tgz
https://registry.npmjs.org/@pixi/math/-/math-7.3.0.tgz -> npmpkg-@pixi-math-7.3.0.tgz
https://registry.npmjs.org/@pixi/mesh/-/mesh-7.3.0.tgz -> npmpkg-@pixi-mesh-7.3.0.tgz
https://registry.npmjs.org/@pixi/mesh-extras/-/mesh-extras-7.3.0.tgz -> npmpkg-@pixi-mesh-extras-7.3.0.tgz
https://registry.npmjs.org/@pixi/mixin-cache-as-bitmap/-/mixin-cache-as-bitmap-7.3.0.tgz -> npmpkg-@pixi-mixin-cache-as-bitmap-7.3.0.tgz
https://registry.npmjs.org/@pixi/mixin-get-child-by-name/-/mixin-get-child-by-name-7.3.0.tgz -> npmpkg-@pixi-mixin-get-child-by-name-7.3.0.tgz
https://registry.npmjs.org/@pixi/mixin-get-global-position/-/mixin-get-global-position-7.3.0.tgz -> npmpkg-@pixi-mixin-get-global-position-7.3.0.tgz
https://registry.npmjs.org/@pixi/particle-container/-/particle-container-7.3.0.tgz -> npmpkg-@pixi-particle-container-7.3.0.tgz
https://registry.npmjs.org/@pixi/prepare/-/prepare-7.3.0.tgz -> npmpkg-@pixi-prepare-7.3.0.tgz
https://registry.npmjs.org/@pixi/runner/-/runner-7.3.0.tgz -> npmpkg-@pixi-runner-7.3.0.tgz
https://registry.npmjs.org/@pixi/settings/-/settings-7.3.0.tgz -> npmpkg-@pixi-settings-7.3.0.tgz
https://registry.npmjs.org/@pixi/sprite/-/sprite-7.3.0.tgz -> npmpkg-@pixi-sprite-7.3.0.tgz
https://registry.npmjs.org/@pixi/sprite-animated/-/sprite-animated-7.3.0.tgz -> npmpkg-@pixi-sprite-animated-7.3.0.tgz
https://registry.npmjs.org/@pixi/sprite-tiling/-/sprite-tiling-7.3.0.tgz -> npmpkg-@pixi-sprite-tiling-7.3.0.tgz
https://registry.npmjs.org/@pixi/spritesheet/-/spritesheet-7.3.0.tgz -> npmpkg-@pixi-spritesheet-7.3.0.tgz
https://registry.npmjs.org/@pixi/text/-/text-7.3.0.tgz -> npmpkg-@pixi-text-7.3.0.tgz
https://registry.npmjs.org/@pixi/text-bitmap/-/text-bitmap-7.3.0.tgz -> npmpkg-@pixi-text-bitmap-7.3.0.tgz
https://registry.npmjs.org/@pixi/text-html/-/text-html-7.3.0.tgz -> npmpkg-@pixi-text-html-7.3.0.tgz
https://registry.npmjs.org/@pixi/ticker/-/ticker-7.3.0.tgz -> npmpkg-@pixi-ticker-7.3.0.tgz
https://registry.npmjs.org/@pixi/utils/-/utils-7.3.0.tgz -> npmpkg-@pixi-utils-7.3.0.tgz
https://registry.npmjs.org/@types/css-font-loading-module/-/css-font-loading-module-0.0.7.tgz -> npmpkg-@types-css-font-loading-module-0.0.7.tgz
https://registry.npmjs.org/@types/earcut/-/earcut-2.1.1.tgz -> npmpkg-@types-earcut-2.1.1.tgz
https://registry.npmjs.org/@types/expect.js/-/expect.js-0.3.29.tgz -> npmpkg-@types-expect.js-0.3.29.tgz
https://registry.npmjs.org/@types/mocha/-/mocha-5.2.7.tgz -> npmpkg-@types-mocha-5.2.7.tgz
https://registry.npmjs.org/@types/node/-/node-14.14.0.tgz -> npmpkg-@types-node-14.14.0.tgz
https://registry.npmjs.org/@types/offscreencanvas/-/offscreencanvas-2019.7.1.tgz -> npmpkg-@types-offscreencanvas-2019.7.1.tgz
https://registry.npmjs.org/@types/sinon/-/sinon-10.0.13.tgz -> npmpkg-@types-sinon-10.0.13.tgz
https://registry.npmjs.org/@types/sinonjs__fake-timers/-/sinonjs__fake-timers-8.1.2.tgz -> npmpkg-@types-sinonjs__fake-timers-8.1.2.tgz
https://registry.npmjs.org/@types/stats.js/-/stats.js-0.17.0.tgz -> npmpkg-@types-stats.js-0.17.0.tgz
https://registry.npmjs.org/@types/three/-/three-0.160.0.tgz -> npmpkg-@types-three-0.160.0.tgz
https://registry.npmjs.org/@types/webxr/-/webxr-0.5.1.tgz -> npmpkg-@types-webxr-0.5.1.tgz
https://registry.npmjs.org/@yarnpkg/lockfile/-/lockfile-1.1.0.tgz -> npmpkg-@yarnpkg-lockfile-1.1.0.tgz
https://registry.npmjs.org/acorn/-/acorn-6.4.2.tgz -> npmpkg-acorn-6.4.2.tgz
https://registry.npmjs.org/acorn-jsx/-/acorn-jsx-5.3.1.tgz -> npmpkg-acorn-jsx-5.3.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.0.tgz -> npmpkg-balanced-match-1.0.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/braces/-/braces-3.0.3.tgz -> npmpkg-braces-3.0.3.tgz
https://registry.npmjs.org/call-bind/-/call-bind-1.0.2.tgz -> npmpkg-call-bind-1.0.2.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/ci-info/-/ci-info-2.0.0.tgz -> npmpkg-ci-info-2.0.0.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/colord/-/colord-2.9.3.tgz -> npmpkg-colord-2.9.3.tgz
https://registry.npmjs.org/commander/-/commander-2.20.3.tgz -> npmpkg-commander-2.20.3.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-6.0.5.tgz -> npmpkg-cross-spawn-6.0.5.tgz
https://registry.npmjs.org/d/-/d-1.0.2.tgz -> npmpkg-d-1.0.2.tgz
https://registry.npmjs.org/earcut/-/earcut-2.2.4.tgz -> npmpkg-earcut-2.2.4.tgz
https://registry.npmjs.org/es5-ext/-/es5-ext-0.10.64.tgz -> npmpkg-es5-ext-0.10.64.tgz
https://registry.npmjs.org/es6-iterator/-/es6-iterator-2.0.3.tgz -> npmpkg-es6-iterator-2.0.3.tgz
https://registry.npmjs.org/es6-map/-/es6-map-0.1.5.tgz -> npmpkg-es6-map-0.1.5.tgz
https://registry.npmjs.org/es6-set/-/es6-set-0.1.5.tgz -> npmpkg-es6-set-0.1.5.tgz
https://registry.npmjs.org/es6-symbol/-/es6-symbol-3.1.1.tgz -> npmpkg-es6-symbol-3.1.1.tgz
https://registry.npmjs.org/es6-symbol/-/es6-symbol-3.1.4.tgz -> npmpkg-es6-symbol-3.1.4.tgz
https://registry.npmjs.org/es6-weak-map/-/es6-weak-map-2.0.3.tgz -> npmpkg-es6-weak-map-2.0.3.tgz
https://registry.npmjs.org/esbuild/-/esbuild-0.13.12.tgz -> npmpkg-esbuild-0.13.12.tgz
https://registry.npmjs.org/esbuild-android-arm64/-/esbuild-android-arm64-0.13.12.tgz -> npmpkg-esbuild-android-arm64-0.13.12.tgz
https://registry.npmjs.org/esbuild-darwin-64/-/esbuild-darwin-64-0.13.12.tgz -> npmpkg-esbuild-darwin-64-0.13.12.tgz
https://registry.npmjs.org/esbuild-darwin-arm64/-/esbuild-darwin-arm64-0.13.12.tgz -> npmpkg-esbuild-darwin-arm64-0.13.12.tgz
https://registry.npmjs.org/esbuild-freebsd-64/-/esbuild-freebsd-64-0.13.12.tgz -> npmpkg-esbuild-freebsd-64-0.13.12.tgz
https://registry.npmjs.org/esbuild-freebsd-arm64/-/esbuild-freebsd-arm64-0.13.12.tgz -> npmpkg-esbuild-freebsd-arm64-0.13.12.tgz
https://registry.npmjs.org/esbuild-linux-32/-/esbuild-linux-32-0.13.12.tgz -> npmpkg-esbuild-linux-32-0.13.12.tgz
https://registry.npmjs.org/esbuild-linux-64/-/esbuild-linux-64-0.13.12.tgz -> npmpkg-esbuild-linux-64-0.13.12.tgz
https://registry.npmjs.org/esbuild-linux-arm/-/esbuild-linux-arm-0.13.12.tgz -> npmpkg-esbuild-linux-arm-0.13.12.tgz
https://registry.npmjs.org/esbuild-linux-arm64/-/esbuild-linux-arm64-0.13.12.tgz -> npmpkg-esbuild-linux-arm64-0.13.12.tgz
https://registry.npmjs.org/esbuild-linux-mips64le/-/esbuild-linux-mips64le-0.13.12.tgz -> npmpkg-esbuild-linux-mips64le-0.13.12.tgz
https://registry.npmjs.org/esbuild-linux-ppc64le/-/esbuild-linux-ppc64le-0.13.12.tgz -> npmpkg-esbuild-linux-ppc64le-0.13.12.tgz
https://registry.npmjs.org/esbuild-netbsd-64/-/esbuild-netbsd-64-0.13.12.tgz -> npmpkg-esbuild-netbsd-64-0.13.12.tgz
https://registry.npmjs.org/esbuild-openbsd-64/-/esbuild-openbsd-64-0.13.12.tgz -> npmpkg-esbuild-openbsd-64-0.13.12.tgz
https://registry.npmjs.org/esbuild-sunos-64/-/esbuild-sunos-64-0.13.12.tgz -> npmpkg-esbuild-sunos-64-0.13.12.tgz
https://registry.npmjs.org/esbuild-windows-32/-/esbuild-windows-32-0.13.12.tgz -> npmpkg-esbuild-windows-32-0.13.12.tgz
https://registry.npmjs.org/esbuild-windows-64/-/esbuild-windows-64-0.13.12.tgz -> npmpkg-esbuild-windows-64-0.13.12.tgz
https://registry.npmjs.org/esbuild-windows-arm64/-/esbuild-windows-arm64-0.13.12.tgz -> npmpkg-esbuild-windows-arm64-0.13.12.tgz
https://registry.npmjs.org/escope/-/escope-3.6.0.tgz -> npmpkg-escope-3.6.0.tgz
https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-1.3.0.tgz -> npmpkg-eslint-visitor-keys-1.3.0.tgz
https://registry.npmjs.org/esniff/-/esniff-2.0.1.tgz -> npmpkg-esniff-2.0.1.tgz
https://registry.npmjs.org/espree/-/espree-5.0.1.tgz -> npmpkg-espree-5.0.1.tgz
https://registry.npmjs.org/esprima/-/esprima-4.0.1.tgz -> npmpkg-esprima-4.0.1.tgz
https://registry.npmjs.org/esrecurse/-/esrecurse-4.3.0.tgz -> npmpkg-esrecurse-4.3.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-5.3.0.tgz -> npmpkg-estraverse-5.3.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-4.3.0.tgz -> npmpkg-estraverse-4.3.0.tgz
https://registry.npmjs.org/event-emitter/-/event-emitter-0.3.5.tgz -> npmpkg-event-emitter-0.3.5.tgz
https://registry.npmjs.org/eventemitter3/-/eventemitter3-4.0.7.tgz -> npmpkg-eventemitter3-4.0.7.tgz
https://registry.npmjs.org/ext/-/ext-1.7.0.tgz -> npmpkg-ext-1.7.0.tgz
https://registry.npmjs.org/f-matches/-/f-matches-1.1.0.tgz -> npmpkg-f-matches-1.1.0.tgz
https://registry.npmjs.org/fflate/-/fflate-0.6.10.tgz -> npmpkg-fflate-0.6.10.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.1.1.tgz -> npmpkg-fill-range-7.1.1.tgz
https://registry.npmjs.org/find-yarn-workspace-root/-/find-yarn-workspace-root-2.0.0.tgz -> npmpkg-find-yarn-workspace-root-2.0.0.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz -> npmpkg-fs.realpath-1.0.0.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.1.tgz -> npmpkg-function-bind-1.1.1.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.2.1.tgz -> npmpkg-get-intrinsic-1.2.1.tgz
https://registry.npmjs.org/glob/-/glob-7.2.3.tgz -> npmpkg-glob-7.2.3.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.4.tgz -> npmpkg-graceful-fs-4.2.4.tgz
https://registry.npmjs.org/has/-/has-1.0.3.tgz -> npmpkg-has-1.0.3.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/has-proto/-/has-proto-1.0.1.tgz -> npmpkg-has-proto-1.0.1.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.0.3.tgz -> npmpkg-has-symbols-1.0.3.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz -> npmpkg-inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz -> npmpkg-inherits-2.0.4.tgz
https://registry.npmjs.org/interpret/-/interpret-1.4.0.tgz -> npmpkg-interpret-1.4.0.tgz
https://registry.npmjs.org/is-ci/-/is-ci-2.0.0.tgz -> npmpkg-is-ci-2.0.0.tgz
https://registry.npmjs.org/is-docker/-/is-docker-2.2.1.tgz -> npmpkg-is-docker-2.2.1.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/is-wsl/-/is-wsl-2.2.0.tgz -> npmpkg-is-wsl-2.2.0.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz -> npmpkg-isexe-2.0.0.tgz
https://registry.npmjs.org/ismobilejs/-/ismobilejs-1.1.1.tgz -> npmpkg-ismobilejs-1.1.1.tgz
https://registry.npmjs.org/jsonc-parser/-/jsonc-parser-3.0.0.tgz -> npmpkg-jsonc-parser-3.0.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-4.0.0.tgz -> npmpkg-jsonfile-4.0.0.tgz
https://registry.npmjs.org/klaw-sync/-/klaw-sync-6.0.0.tgz -> npmpkg-klaw-sync-6.0.0.tgz
https://registry.npmjs.org/lebab/-/lebab-3.1.0.tgz -> npmpkg-lebab-3.1.0.tgz
https://registry.npmjs.org/ast-types/-/ast-types-0.13.3.tgz -> npmpkg-ast-types-0.13.3.tgz
https://registry.npmjs.org/recast/-/recast-0.18.10.tgz -> npmpkg-recast-0.18.10.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/lunr/-/lunr-2.3.9.tgz -> npmpkg-lunr-2.3.9.tgz
https://registry.npmjs.org/meshoptimizer/-/meshoptimizer-0.18.1.tgz -> npmpkg-meshoptimizer-0.18.1.tgz
https://registry.npmjs.org/micromatch/-/micromatch-4.0.4.tgz -> npmpkg-micromatch-4.0.4.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.0.4.tgz -> npmpkg-minimatch-3.0.4.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.6.tgz -> npmpkg-minimist-1.2.6.tgz
https://registry.npmjs.org/next-tick/-/next-tick-1.1.0.tgz -> npmpkg-next-tick-1.1.0.tgz
https://registry.npmjs.org/nice-try/-/nice-try-1.0.5.tgz -> npmpkg-nice-try-1.0.5.tgz
https://registry.npmjs.org/object-inspect/-/object-inspect-1.12.3.tgz -> npmpkg-object-inspect-1.12.3.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz -> npmpkg-once-1.4.0.tgz
https://registry.npmjs.org/open/-/open-7.4.2.tgz -> npmpkg-open-7.4.2.tgz
https://registry.npmjs.org/os-tmpdir/-/os-tmpdir-1.0.2.tgz -> npmpkg-os-tmpdir-1.0.2.tgz
https://registry.npmjs.org/patch-package/-/patch-package-6.4.7.tgz -> npmpkg-patch-package-6.4.7.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-7.0.1.tgz -> npmpkg-fs-extra-7.0.1.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> npmpkg-path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/path-key/-/path-key-2.0.1.tgz -> npmpkg-path-key-2.0.1.tgz
https://registry.npmjs.org/path-parse/-/path-parse-1.0.6.tgz -> npmpkg-path-parse-1.0.6.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.3.1.tgz -> npmpkg-picomatch-2.3.1.tgz
https://registry.npmjs.org/pixi-spine/-/pixi-spine-4.0.4.tgz -> npmpkg-pixi-spine-4.0.4.tgz
https://registry.npmjs.org/pixi.js/-/pixi.js-7.3.0.tgz -> npmpkg-pixi.js-7.3.0.tgz
https://registry.npmjs.org/prettier/-/prettier-2.1.2.tgz -> npmpkg-prettier-2.1.2.tgz
https://registry.npmjs.org/private/-/private-0.1.8.tgz -> npmpkg-private-0.1.8.tgz
https://registry.npmjs.org/punycode/-/punycode-1.4.1.tgz -> npmpkg-punycode-1.4.1.tgz
https://registry.npmjs.org/qs/-/qs-6.11.2.tgz -> npmpkg-qs-6.11.2.tgz
https://registry.npmjs.org/rechoir/-/rechoir-0.6.2.tgz -> npmpkg-rechoir-0.6.2.tgz
https://registry.npmjs.org/recursive-readdir/-/recursive-readdir-2.2.2.tgz -> npmpkg-recursive-readdir-2.2.2.tgz
https://registry.npmjs.org/resolve/-/resolve-1.17.0.tgz -> npmpkg-resolve-1.17.0.tgz
https://registry.npmjs.org/rimraf/-/rimraf-2.7.1.tgz -> npmpkg-rimraf-2.7.1.tgz
https://registry.npmjs.org/semver/-/semver-5.7.1.tgz -> npmpkg-semver-5.7.1.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-1.2.0.tgz -> npmpkg-shebang-command-1.2.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-1.0.0.tgz -> npmpkg-shebang-regex-1.0.0.tgz
https://registry.npmjs.org/shelljs/-/shelljs-0.8.5.tgz -> npmpkg-shelljs-0.8.5.tgz
https://registry.npmjs.org/shiki/-/shiki-0.10.0.tgz -> npmpkg-shiki-0.10.0.tgz
https://registry.npmjs.org/side-channel/-/side-channel-1.0.4.tgz -> npmpkg-side-channel-1.0.4.tgz
https://registry.npmjs.org/slash/-/slash-2.0.0.tgz -> npmpkg-slash-2.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/tmp/-/tmp-0.0.33.tgz -> npmpkg-tmp-0.0.33.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/type/-/type-2.7.3.tgz -> npmpkg-type-2.7.3.tgz
https://registry.npmjs.org/typedoc/-/typedoc-0.22.11.tgz -> npmpkg-typedoc-0.22.11.tgz
https://registry.npmjs.org/typedoc-plugin-reference-excluder/-/typedoc-plugin-reference-excluder-1.0.0.tgz -> npmpkg-typedoc-plugin-reference-excluder-1.0.0.tgz
https://registry.npmjs.org/marked/-/marked-4.0.12.tgz -> npmpkg-marked-4.0.12.tgz
https://registry.npmjs.org/typescript/-/typescript-4.3.2.tgz -> npmpkg-typescript-4.3.2.tgz
https://registry.npmjs.org/universalify/-/universalify-0.1.2.tgz -> npmpkg-universalify-0.1.2.tgz
https://registry.npmjs.org/url/-/url-0.11.3.tgz -> npmpkg-url-0.11.3.tgz
https://registry.npmjs.org/vscode-oniguruma/-/vscode-oniguruma-1.6.1.tgz -> npmpkg-vscode-oniguruma-1.6.1.tgz
https://registry.npmjs.org/vscode-textmate/-/vscode-textmate-5.2.0.tgz -> npmpkg-vscode-textmate-5.2.0.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
https://registry.npmjs.org/@pixi-spine/base/-/base-4.0.3.tgz -> npmpkg-@pixi-spine-base-4.0.3.tgz
https://registry.npmjs.org/@pixi-spine/loader-base/-/loader-base-4.0.4.tgz -> npmpkg-@pixi-spine-loader-base-4.0.4.tgz
https://registry.npmjs.org/@pixi-spine/loader-uni/-/loader-uni-4.0.3.tgz -> npmpkg-@pixi-spine-loader-uni-4.0.3.tgz
https://registry.npmjs.org/@pixi-spine/runtime-3.7/-/runtime-3.7-4.0.3.tgz -> npmpkg-@pixi-spine-runtime-3.7-4.0.3.tgz
https://registry.npmjs.org/@pixi-spine/runtime-3.8/-/runtime-3.8-4.0.3.tgz -> npmpkg-@pixi-spine-runtime-3.8-4.0.3.tgz
https://registry.npmjs.org/@pixi-spine/runtime-4.0/-/runtime-4.0-4.0.3.tgz -> npmpkg-@pixi-spine-runtime-4.0-4.0.3.tgz
https://registry.npmjs.org/@pixi-spine/runtime-4.1/-/runtime-4.1-4.0.3.tgz -> npmpkg-@pixi-spine-runtime-4.1-4.0.3.tgz
https://registry.npmjs.org/@pixi/accessibility/-/accessibility-7.3.0.tgz -> npmpkg-@pixi-accessibility-7.3.0.tgz
https://registry.npmjs.org/@pixi/app/-/app-7.3.0.tgz -> npmpkg-@pixi-app-7.3.0.tgz
https://registry.npmjs.org/@pixi/assets/-/assets-7.3.0.tgz -> npmpkg-@pixi-assets-7.3.0.tgz
https://registry.npmjs.org/@pixi/color/-/color-7.3.0.tgz -> npmpkg-@pixi-color-7.3.0.tgz
https://registry.npmjs.org/@pixi/compressed-textures/-/compressed-textures-7.3.0.tgz -> npmpkg-@pixi-compressed-textures-7.3.0.tgz
https://registry.npmjs.org/@pixi/constants/-/constants-7.3.0.tgz -> npmpkg-@pixi-constants-7.3.0.tgz
https://registry.npmjs.org/@pixi/core/-/core-7.3.0.tgz -> npmpkg-@pixi-core-7.3.0.tgz
https://registry.npmjs.org/@pixi/display/-/display-7.3.0.tgz -> npmpkg-@pixi-display-7.3.0.tgz
https://registry.npmjs.org/@pixi/events/-/events-7.3.0.tgz -> npmpkg-@pixi-events-7.3.0.tgz
https://registry.npmjs.org/@pixi/extensions/-/extensions-7.3.0.tgz -> npmpkg-@pixi-extensions-7.3.0.tgz
https://registry.npmjs.org/@pixi/extract/-/extract-7.3.0.tgz -> npmpkg-@pixi-extract-7.3.0.tgz
https://registry.npmjs.org/@pixi/filter-alpha/-/filter-alpha-7.3.0.tgz -> npmpkg-@pixi-filter-alpha-7.3.0.tgz
https://registry.npmjs.org/@pixi/filter-blur/-/filter-blur-7.3.0.tgz -> npmpkg-@pixi-filter-blur-7.3.0.tgz
https://registry.npmjs.org/@pixi/filter-color-matrix/-/filter-color-matrix-7.3.0.tgz -> npmpkg-@pixi-filter-color-matrix-7.3.0.tgz
https://registry.npmjs.org/@pixi/filter-displacement/-/filter-displacement-7.3.0.tgz -> npmpkg-@pixi-filter-displacement-7.3.0.tgz
https://registry.npmjs.org/@pixi/filter-fxaa/-/filter-fxaa-7.3.0.tgz -> npmpkg-@pixi-filter-fxaa-7.3.0.tgz
https://registry.npmjs.org/@pixi/filter-noise/-/filter-noise-7.3.0.tgz -> npmpkg-@pixi-filter-noise-7.3.0.tgz
https://registry.npmjs.org/@pixi/graphics/-/graphics-7.3.0.tgz -> npmpkg-@pixi-graphics-7.3.0.tgz
https://registry.npmjs.org/@pixi/math/-/math-7.3.0.tgz -> npmpkg-@pixi-math-7.3.0.tgz
https://registry.npmjs.org/@pixi/mesh/-/mesh-7.3.0.tgz -> npmpkg-@pixi-mesh-7.3.0.tgz
https://registry.npmjs.org/@pixi/mesh-extras/-/mesh-extras-7.3.0.tgz -> npmpkg-@pixi-mesh-extras-7.3.0.tgz
https://registry.npmjs.org/@pixi/mixin-cache-as-bitmap/-/mixin-cache-as-bitmap-7.3.0.tgz -> npmpkg-@pixi-mixin-cache-as-bitmap-7.3.0.tgz
https://registry.npmjs.org/@pixi/mixin-get-child-by-name/-/mixin-get-child-by-name-7.3.0.tgz -> npmpkg-@pixi-mixin-get-child-by-name-7.3.0.tgz
https://registry.npmjs.org/@pixi/mixin-get-global-position/-/mixin-get-global-position-7.3.0.tgz -> npmpkg-@pixi-mixin-get-global-position-7.3.0.tgz
https://registry.npmjs.org/@pixi/particle-container/-/particle-container-7.3.0.tgz -> npmpkg-@pixi-particle-container-7.3.0.tgz
https://registry.npmjs.org/@pixi/prepare/-/prepare-7.3.0.tgz -> npmpkg-@pixi-prepare-7.3.0.tgz
https://registry.npmjs.org/@pixi/runner/-/runner-7.3.0.tgz -> npmpkg-@pixi-runner-7.3.0.tgz
https://registry.npmjs.org/@pixi/settings/-/settings-7.3.0.tgz -> npmpkg-@pixi-settings-7.3.0.tgz
https://registry.npmjs.org/@pixi/sprite/-/sprite-7.3.0.tgz -> npmpkg-@pixi-sprite-7.3.0.tgz
https://registry.npmjs.org/@pixi/sprite-animated/-/sprite-animated-7.3.0.tgz -> npmpkg-@pixi-sprite-animated-7.3.0.tgz
https://registry.npmjs.org/@pixi/sprite-tiling/-/sprite-tiling-7.3.0.tgz -> npmpkg-@pixi-sprite-tiling-7.3.0.tgz
https://registry.npmjs.org/@pixi/spritesheet/-/spritesheet-7.3.0.tgz -> npmpkg-@pixi-spritesheet-7.3.0.tgz
https://registry.npmjs.org/@pixi/text/-/text-7.3.0.tgz -> npmpkg-@pixi-text-7.3.0.tgz
https://registry.npmjs.org/@pixi/text-bitmap/-/text-bitmap-7.3.0.tgz -> npmpkg-@pixi-text-bitmap-7.3.0.tgz
https://registry.npmjs.org/@pixi/text-html/-/text-html-7.3.0.tgz -> npmpkg-@pixi-text-html-7.3.0.tgz
https://registry.npmjs.org/@pixi/ticker/-/ticker-7.3.0.tgz -> npmpkg-@pixi-ticker-7.3.0.tgz
https://registry.npmjs.org/@pixi/utils/-/utils-7.3.0.tgz -> npmpkg-@pixi-utils-7.3.0.tgz
https://registry.npmjs.org/@types/css-font-loading-module/-/css-font-loading-module-0.0.7.tgz -> npmpkg-@types-css-font-loading-module-0.0.7.tgz
https://registry.npmjs.org/@types/earcut/-/earcut-2.1.1.tgz -> npmpkg-@types-earcut-2.1.1.tgz
https://registry.npmjs.org/@types/expect.js/-/expect.js-0.3.29.tgz -> npmpkg-@types-expect.js-0.3.29.tgz
https://registry.npmjs.org/@types/mocha/-/mocha-5.2.7.tgz -> npmpkg-@types-mocha-5.2.7.tgz
https://registry.npmjs.org/@types/node/-/node-14.14.0.tgz -> npmpkg-@types-node-14.14.0.tgz
https://registry.npmjs.org/@types/offscreencanvas/-/offscreencanvas-2019.7.1.tgz -> npmpkg-@types-offscreencanvas-2019.7.1.tgz
https://registry.npmjs.org/@types/sinon/-/sinon-10.0.13.tgz -> npmpkg-@types-sinon-10.0.13.tgz
https://registry.npmjs.org/@types/sinonjs__fake-timers/-/sinonjs__fake-timers-8.1.2.tgz -> npmpkg-@types-sinonjs__fake-timers-8.1.2.tgz
https://registry.npmjs.org/@types/stats.js/-/stats.js-0.17.0.tgz -> npmpkg-@types-stats.js-0.17.0.tgz
https://registry.npmjs.org/@types/three/-/three-0.160.0.tgz -> npmpkg-@types-three-0.160.0.tgz
https://registry.npmjs.org/@types/webxr/-/webxr-0.5.1.tgz -> npmpkg-@types-webxr-0.5.1.tgz
https://registry.npmjs.org/@yarnpkg/lockfile/-/lockfile-1.1.0.tgz -> npmpkg-@yarnpkg-lockfile-1.1.0.tgz
https://registry.npmjs.org/acorn/-/acorn-6.4.2.tgz -> npmpkg-acorn-6.4.2.tgz
https://registry.npmjs.org/acorn-jsx/-/acorn-jsx-5.3.1.tgz -> npmpkg-acorn-jsx-5.3.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.0.tgz -> npmpkg-balanced-match-1.0.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/braces/-/braces-3.0.3.tgz -> npmpkg-braces-3.0.3.tgz
https://registry.npmjs.org/call-bind/-/call-bind-1.0.2.tgz -> npmpkg-call-bind-1.0.2.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/ci-info/-/ci-info-2.0.0.tgz -> npmpkg-ci-info-2.0.0.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/colord/-/colord-2.9.3.tgz -> npmpkg-colord-2.9.3.tgz
https://registry.npmjs.org/commander/-/commander-2.20.3.tgz -> npmpkg-commander-2.20.3.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-6.0.5.tgz -> npmpkg-cross-spawn-6.0.5.tgz
https://registry.npmjs.org/d/-/d-1.0.2.tgz -> npmpkg-d-1.0.2.tgz
https://registry.npmjs.org/earcut/-/earcut-2.2.4.tgz -> npmpkg-earcut-2.2.4.tgz
https://registry.npmjs.org/es5-ext/-/es5-ext-0.10.64.tgz -> npmpkg-es5-ext-0.10.64.tgz
https://registry.npmjs.org/es6-iterator/-/es6-iterator-2.0.3.tgz -> npmpkg-es6-iterator-2.0.3.tgz
https://registry.npmjs.org/es6-map/-/es6-map-0.1.5.tgz -> npmpkg-es6-map-0.1.5.tgz
https://registry.npmjs.org/es6-set/-/es6-set-0.1.5.tgz -> npmpkg-es6-set-0.1.5.tgz
https://registry.npmjs.org/es6-symbol/-/es6-symbol-3.1.1.tgz -> npmpkg-es6-symbol-3.1.1.tgz
https://registry.npmjs.org/es6-symbol/-/es6-symbol-3.1.4.tgz -> npmpkg-es6-symbol-3.1.4.tgz
https://registry.npmjs.org/es6-weak-map/-/es6-weak-map-2.0.3.tgz -> npmpkg-es6-weak-map-2.0.3.tgz
https://registry.npmjs.org/esbuild/-/esbuild-0.13.12.tgz -> npmpkg-esbuild-0.13.12.tgz
https://registry.npmjs.org/esbuild-android-arm64/-/esbuild-android-arm64-0.13.12.tgz -> npmpkg-esbuild-android-arm64-0.13.12.tgz
https://registry.npmjs.org/esbuild-darwin-64/-/esbuild-darwin-64-0.13.12.tgz -> npmpkg-esbuild-darwin-64-0.13.12.tgz
https://registry.npmjs.org/esbuild-darwin-arm64/-/esbuild-darwin-arm64-0.13.12.tgz -> npmpkg-esbuild-darwin-arm64-0.13.12.tgz
https://registry.npmjs.org/esbuild-freebsd-64/-/esbuild-freebsd-64-0.13.12.tgz -> npmpkg-esbuild-freebsd-64-0.13.12.tgz
https://registry.npmjs.org/esbuild-freebsd-arm64/-/esbuild-freebsd-arm64-0.13.12.tgz -> npmpkg-esbuild-freebsd-arm64-0.13.12.tgz
https://registry.npmjs.org/esbuild-linux-32/-/esbuild-linux-32-0.13.12.tgz -> npmpkg-esbuild-linux-32-0.13.12.tgz
https://registry.npmjs.org/esbuild-linux-64/-/esbuild-linux-64-0.13.12.tgz -> npmpkg-esbuild-linux-64-0.13.12.tgz
https://registry.npmjs.org/esbuild-linux-arm/-/esbuild-linux-arm-0.13.12.tgz -> npmpkg-esbuild-linux-arm-0.13.12.tgz
https://registry.npmjs.org/esbuild-linux-arm64/-/esbuild-linux-arm64-0.13.12.tgz -> npmpkg-esbuild-linux-arm64-0.13.12.tgz
https://registry.npmjs.org/esbuild-linux-mips64le/-/esbuild-linux-mips64le-0.13.12.tgz -> npmpkg-esbuild-linux-mips64le-0.13.12.tgz
https://registry.npmjs.org/esbuild-linux-ppc64le/-/esbuild-linux-ppc64le-0.13.12.tgz -> npmpkg-esbuild-linux-ppc64le-0.13.12.tgz
https://registry.npmjs.org/esbuild-netbsd-64/-/esbuild-netbsd-64-0.13.12.tgz -> npmpkg-esbuild-netbsd-64-0.13.12.tgz
https://registry.npmjs.org/esbuild-openbsd-64/-/esbuild-openbsd-64-0.13.12.tgz -> npmpkg-esbuild-openbsd-64-0.13.12.tgz
https://registry.npmjs.org/esbuild-sunos-64/-/esbuild-sunos-64-0.13.12.tgz -> npmpkg-esbuild-sunos-64-0.13.12.tgz
https://registry.npmjs.org/esbuild-windows-32/-/esbuild-windows-32-0.13.12.tgz -> npmpkg-esbuild-windows-32-0.13.12.tgz
https://registry.npmjs.org/esbuild-windows-64/-/esbuild-windows-64-0.13.12.tgz -> npmpkg-esbuild-windows-64-0.13.12.tgz
https://registry.npmjs.org/esbuild-windows-arm64/-/esbuild-windows-arm64-0.13.12.tgz -> npmpkg-esbuild-windows-arm64-0.13.12.tgz
https://registry.npmjs.org/escope/-/escope-3.6.0.tgz -> npmpkg-escope-3.6.0.tgz
https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-1.3.0.tgz -> npmpkg-eslint-visitor-keys-1.3.0.tgz
https://registry.npmjs.org/esniff/-/esniff-2.0.1.tgz -> npmpkg-esniff-2.0.1.tgz
https://registry.npmjs.org/espree/-/espree-5.0.1.tgz -> npmpkg-espree-5.0.1.tgz
https://registry.npmjs.org/esprima/-/esprima-4.0.1.tgz -> npmpkg-esprima-4.0.1.tgz
https://registry.npmjs.org/esrecurse/-/esrecurse-4.3.0.tgz -> npmpkg-esrecurse-4.3.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-5.3.0.tgz -> npmpkg-estraverse-5.3.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-4.3.0.tgz -> npmpkg-estraverse-4.3.0.tgz
https://registry.npmjs.org/event-emitter/-/event-emitter-0.3.5.tgz -> npmpkg-event-emitter-0.3.5.tgz
https://registry.npmjs.org/eventemitter3/-/eventemitter3-4.0.7.tgz -> npmpkg-eventemitter3-4.0.7.tgz
https://registry.npmjs.org/ext/-/ext-1.7.0.tgz -> npmpkg-ext-1.7.0.tgz
https://registry.npmjs.org/f-matches/-/f-matches-1.1.0.tgz -> npmpkg-f-matches-1.1.0.tgz
https://registry.npmjs.org/fflate/-/fflate-0.6.10.tgz -> npmpkg-fflate-0.6.10.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.1.1.tgz -> npmpkg-fill-range-7.1.1.tgz
https://registry.npmjs.org/find-yarn-workspace-root/-/find-yarn-workspace-root-2.0.0.tgz -> npmpkg-find-yarn-workspace-root-2.0.0.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz -> npmpkg-fs.realpath-1.0.0.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.1.tgz -> npmpkg-function-bind-1.1.1.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.2.1.tgz -> npmpkg-get-intrinsic-1.2.1.tgz
https://registry.npmjs.org/glob/-/glob-7.2.3.tgz -> npmpkg-glob-7.2.3.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.4.tgz -> npmpkg-graceful-fs-4.2.4.tgz
https://registry.npmjs.org/has/-/has-1.0.3.tgz -> npmpkg-has-1.0.3.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/has-proto/-/has-proto-1.0.1.tgz -> npmpkg-has-proto-1.0.1.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.0.3.tgz -> npmpkg-has-symbols-1.0.3.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz -> npmpkg-inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz -> npmpkg-inherits-2.0.4.tgz
https://registry.npmjs.org/interpret/-/interpret-1.4.0.tgz -> npmpkg-interpret-1.4.0.tgz
https://registry.npmjs.org/is-ci/-/is-ci-2.0.0.tgz -> npmpkg-is-ci-2.0.0.tgz
https://registry.npmjs.org/is-docker/-/is-docker-2.2.1.tgz -> npmpkg-is-docker-2.2.1.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/is-wsl/-/is-wsl-2.2.0.tgz -> npmpkg-is-wsl-2.2.0.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz -> npmpkg-isexe-2.0.0.tgz
https://registry.npmjs.org/ismobilejs/-/ismobilejs-1.1.1.tgz -> npmpkg-ismobilejs-1.1.1.tgz
https://registry.npmjs.org/jsonc-parser/-/jsonc-parser-3.0.0.tgz -> npmpkg-jsonc-parser-3.0.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-4.0.0.tgz -> npmpkg-jsonfile-4.0.0.tgz
https://registry.npmjs.org/klaw-sync/-/klaw-sync-6.0.0.tgz -> npmpkg-klaw-sync-6.0.0.tgz
https://registry.npmjs.org/lebab/-/lebab-3.1.0.tgz -> npmpkg-lebab-3.1.0.tgz
https://registry.npmjs.org/ast-types/-/ast-types-0.13.3.tgz -> npmpkg-ast-types-0.13.3.tgz
https://registry.npmjs.org/recast/-/recast-0.18.10.tgz -> npmpkg-recast-0.18.10.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/lunr/-/lunr-2.3.9.tgz -> npmpkg-lunr-2.3.9.tgz
https://registry.npmjs.org/meshoptimizer/-/meshoptimizer-0.18.1.tgz -> npmpkg-meshoptimizer-0.18.1.tgz
https://registry.npmjs.org/micromatch/-/micromatch-4.0.4.tgz -> npmpkg-micromatch-4.0.4.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.0.4.tgz -> npmpkg-minimatch-3.0.4.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.6.tgz -> npmpkg-minimist-1.2.6.tgz
https://registry.npmjs.org/next-tick/-/next-tick-1.1.0.tgz -> npmpkg-next-tick-1.1.0.tgz
https://registry.npmjs.org/nice-try/-/nice-try-1.0.5.tgz -> npmpkg-nice-try-1.0.5.tgz
https://registry.npmjs.org/object-inspect/-/object-inspect-1.12.3.tgz -> npmpkg-object-inspect-1.12.3.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz -> npmpkg-once-1.4.0.tgz
https://registry.npmjs.org/open/-/open-7.4.2.tgz -> npmpkg-open-7.4.2.tgz
https://registry.npmjs.org/os-tmpdir/-/os-tmpdir-1.0.2.tgz -> npmpkg-os-tmpdir-1.0.2.tgz
https://registry.npmjs.org/patch-package/-/patch-package-6.4.7.tgz -> npmpkg-patch-package-6.4.7.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-7.0.1.tgz -> npmpkg-fs-extra-7.0.1.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> npmpkg-path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/path-key/-/path-key-2.0.1.tgz -> npmpkg-path-key-2.0.1.tgz
https://registry.npmjs.org/path-parse/-/path-parse-1.0.6.tgz -> npmpkg-path-parse-1.0.6.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.3.1.tgz -> npmpkg-picomatch-2.3.1.tgz
https://registry.npmjs.org/pixi-spine/-/pixi-spine-4.0.4.tgz -> npmpkg-pixi-spine-4.0.4.tgz
https://registry.npmjs.org/pixi.js/-/pixi.js-7.3.0.tgz -> npmpkg-pixi.js-7.3.0.tgz
https://registry.npmjs.org/prettier/-/prettier-2.1.2.tgz -> npmpkg-prettier-2.1.2.tgz
https://registry.npmjs.org/private/-/private-0.1.8.tgz -> npmpkg-private-0.1.8.tgz
https://registry.npmjs.org/punycode/-/punycode-1.4.1.tgz -> npmpkg-punycode-1.4.1.tgz
https://registry.npmjs.org/qs/-/qs-6.11.2.tgz -> npmpkg-qs-6.11.2.tgz
https://registry.npmjs.org/rechoir/-/rechoir-0.6.2.tgz -> npmpkg-rechoir-0.6.2.tgz
https://registry.npmjs.org/recursive-readdir/-/recursive-readdir-2.2.2.tgz -> npmpkg-recursive-readdir-2.2.2.tgz
https://registry.npmjs.org/resolve/-/resolve-1.17.0.tgz -> npmpkg-resolve-1.17.0.tgz
https://registry.npmjs.org/rimraf/-/rimraf-2.7.1.tgz -> npmpkg-rimraf-2.7.1.tgz
https://registry.npmjs.org/semver/-/semver-5.7.1.tgz -> npmpkg-semver-5.7.1.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-1.2.0.tgz -> npmpkg-shebang-command-1.2.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-1.0.0.tgz -> npmpkg-shebang-regex-1.0.0.tgz
https://registry.npmjs.org/shelljs/-/shelljs-0.8.5.tgz -> npmpkg-shelljs-0.8.5.tgz
https://registry.npmjs.org/shiki/-/shiki-0.10.0.tgz -> npmpkg-shiki-0.10.0.tgz
https://registry.npmjs.org/side-channel/-/side-channel-1.0.4.tgz -> npmpkg-side-channel-1.0.4.tgz
https://registry.npmjs.org/slash/-/slash-2.0.0.tgz -> npmpkg-slash-2.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/tmp/-/tmp-0.0.33.tgz -> npmpkg-tmp-0.0.33.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/type/-/type-2.7.3.tgz -> npmpkg-type-2.7.3.tgz
https://registry.npmjs.org/typedoc/-/typedoc-0.22.11.tgz -> npmpkg-typedoc-0.22.11.tgz
https://registry.npmjs.org/marked/-/marked-4.0.12.tgz -> npmpkg-marked-4.0.12.tgz
https://registry.npmjs.org/typedoc-plugin-reference-excluder/-/typedoc-plugin-reference-excluder-1.0.0.tgz -> npmpkg-typedoc-plugin-reference-excluder-1.0.0.tgz
https://registry.npmjs.org/typescript/-/typescript-4.3.2.tgz -> npmpkg-typescript-4.3.2.tgz
https://registry.npmjs.org/universalify/-/universalify-0.1.2.tgz -> npmpkg-universalify-0.1.2.tgz
https://registry.npmjs.org/url/-/url-0.11.3.tgz -> npmpkg-url-0.11.3.tgz
https://registry.npmjs.org/vscode-oniguruma/-/vscode-oniguruma-1.6.1.tgz -> npmpkg-vscode-oniguruma-1.6.1.tgz
https://registry.npmjs.org/vscode-textmate/-/vscode-textmate-5.2.0.tgz -> npmpkg-vscode-textmate-5.2.0.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
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
	ebuild_revision_4
"
REQUIRED_USE+="
	!wayland
	${LLVM_COMPAT[@]/#/llvm_slot_}
	${PYTHON_REQUIRED_USE}
	X
"
# Dependency lists:
# https://github.com/4ian/GDevelop/blob/v5.3.204/.circleci/config.yml#L85
# https://github.com/4ian/GDevelop/blob/v5.3.204/.travis.yml
# https://github.com/4ian/GDevelop/blob/v5.3.204/ExtLibs/installDeps.sh
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
	>=net-libs/nodejs-${GDEVELOP_JS_NODEJS_PV}:${GDEVELOP_JS_NODEJS_PV%%.*}
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

	llvm_pkg_setup

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

# @FUNCTION: __src_unpack_all_production
# @DESCRIPTION:
# Unpacks a npm application.
__src_unpack_all_production() {
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

	local offline="${NPM_OFFLINE:-1}"
	if [[ "${offline}" == "1" || "${offline}" == "2" ]] ; then
		export ELECTRON_SKIP_BINARY_DOWNLOAD=1
		_npm_cp_tarballs

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
einfo "Running \`npm dedupe ${NPM_AUDIT_FIX_ARGS[@]}\` per each lockfile"
	local lockfile
	for lockfile in ${lockfiles[@]} ; do
		local d="$(dirname ${lockfile})"
		pushd "${S}/${d}" >/dev/null 2>&1 || die
			enpm dedupe
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
			enpm install \
				${NPM_INSTALL_ARGS[@]}
		popd >/dev/null 2>&1 || die
	done
einfo "Running \`npm audit fix ${NPM_AUDIT_FIX_ARGS[@]}\` per each lockfile"
	local lockfile
	for lockfile in ${lockfiles[@]} ; do
		local d="$(dirname ${lockfile})"
		pushd "${S}/${d}" >/dev/null 2>&1 || die
			enpm audit fix \
				${NPM_AUDIT_FIX_ARGS[@]}
			if [[ "${NPM_DEDUPE}" == "1" ]] ; then
				enpm dedupe
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
	if [[ -n "${NPM_UPDATE_LOCK}" ]] ; then
		if [[ "${PV}" =~ "9999" ]] ; then
			:
		elif [[ -n "${NPM_TARBALL}" ]] ; then
			unpack "${NPM_TARBALL}"
		else
			unpack "${P}.tar.gz"
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
			enpm install ${pkgs[@]} -P
		popd || die

		if [[ "${NPM_AUDIT_FIX}" == 0 ]] ; then
einfo "Fixing vulnerabilities"
			patch_edits() {
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

				pushd "${S}/newIDE/app" || die
					sed -i -e "s|\"@grpc/grpc-js\": \"^1.0.0\"|\"@grpc/grpc-js\": \"^1.8.22\"|g" "package-lock.json" || die
					sed -i -e "s|\"axios\": \"^0.21.2\"|\"axios\": \"^0.28.0\"|g" "package-lock.json" || die
					sed -i -e "s|\"d3-color\": \"1 - 2\"|\"d3-color\": \"^3.1.0\"|g" "package-lock.json" || die
					sed -i -e "s|\"express\": \"^4.17.3\"|\"express\": \"^4.19.2\"|g" "package-lock.json" || die
					sed -i -e "s|\"follow-redirects\": \"^1.0.0\"|\"follow-redirects\": \"^1.15.6\"|g" "package-lock.json" || die
					sed -i -e "s|\"follow-redirects\": \"^1.14.0\"|\"follow-redirects\": \"^1.15.6\"|g" "package-lock.json" || die
					sed -i -e "s|\"follow-redirects\": \"^1.14.7\"|\"follow-redirects\": \"^1.15.6\"|g" "package-lock.json" || die
					sed -i -e "s|\"jsdom\": \"^16.5.0\"|\"jsdom\": \"^16.6.0\"|g" "package-lock.json" || die
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
					sed -i -e "s|\"yargs-parser\": \"^7.0.0\"|\"yargs-parser\": \"^13.1.2\"|g" "package-lock.json" || die
					sed -i -e "s|\"workbox-build\": \"^4.3.1\"|\"workbox-build\": \"^7.1.1\"|g" "package-lock.json" || die
				popd || die

				pushd "${S}/newIDE/electron-app/app" || die
					sed -i -e "s|\"axios\": \"^0.21.2\"|\"axios\": \"^0.28.0\"|g" "package-lock.json" || die
					sed -i -e "s|\"bl\": \"^1.0.0\"|\"bl\": \"^1.0.0\"|g" "package-lock.json" || die
					sed -i -e "s|\"braces\": \"^1.8.2\"|\"braces\": \"^3.0.3\"|g" "package-lock.json" || die
					sed -i -e "s|\"braces\": \"^2.3.1\"|\"braces\": \"^3.0.3\"|g" "package-lock.json" || die
					sed -i -e "s|\"braces\": \"~3.0.2\"|\"braces\": \"~3.0.3\"|g" "package-lock.json" || die
					sed -i -e "s|\"debug\": \"~2.2.0\"|\"debug\": \"~2.6.9\"|g" "package-lock.json" || die
					sed -i -e "s|\"electron-updater\": \"4.2.0\"|\"electron-updater\": \"6.3.0-alpha.6\"|g" "package-lock.json" || die
					sed -i -e "s|\"follow-redirects\": \"^1.14.0\"|\"follow-redirects\": \"^1.15.6\"|g" "package-lock.json" || die
					sed -i -e "s|\"follow-redirects\": \"^1.14.7\"|\"follow-redirects\": \"^1.15.6\"|g" "package-lock.json" || die
					sed -i -e "s|\"glob-parent\": \"^2.0.0\"|\"glob-parent\": \"^5.1.2\"|g" "package-lock.json" || die
					sed -i -e "s|\"node-fetch\": \"2.6.0\"|\"node-fetch\": \"^2.6.7\"|g" "package-lock.json" || die
					sed -i -e "s|\"ws\": \"7.1.2\"|\"ws\": \"^7.5.10\"|g" "package-lock.json" || die
				popd || die

				pushd "${S}/newIDE/electron-app" || die
					sed -i -e "s|\"app-builder-lib\": \"24.9.1\"|\"app-builder-lib\": \"^24.13.2\"|g" "package-lock.json" || die
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
				enpm uninstall ${pkgs[@]}
				pkgs=(
					"@hapi/cryptiles@5.1.0"
					"bl@1.2.3"				# DoS, ID		# CVE-2020-8244
					"braces@3.0.3"				# DoS			# CVE-2024-4068, CVE-2018-1109, GHSA-g95f-p29q-9xw4
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
				)
				enpm install ${pkgs[@]} -D
			popd || die
			pushd "${S}/GDJS" || die
				pkgs=(
					"braces@3.0.3"				# DoS			# CVE-2024-4068
					"lodash@4.17.21"			# DoS, DT, ID		# CVE-2021-23337, CVE-2020-28500
					"minimist@1.2.6"			# DoS, DT, ID		# CVE-2021-44906
					"shelljs@0.8.5"				# DoS, ID		# CVE-2022-0144, GHSA-64g7-mvw6-v9qj
				)
				enpm install ${pkgs[@]} -D
			popd || die
			pushd "${S}/newIDE/app" || die
				pkgs=(
					"cryptiles"
				)
				enpm uninstall ${pkgs[@]}
				pkgs=(
					"@babel/traverse@7.23.2"		# DoS, DT, ID		# CVE-2023-45133
					"@hapi/cryptiles@5.1.0"			# DoS, DT, ID													# [11]
					"braces@3.0.3"				# DoS			# CVE-2024-4068, CVE-2024-4067
					"ejs@3.1.10"				# DoS			# CVE-2024-33883
					"express@4.19.2"			# DT, ID		# CVE-2024-43796, CVE-2024-29041
					"follow-redirects@1.14.8"		# DoS, DT, ID		# CVE-2022-0155, CVE-2024-28849, CVE-2023-26159, CVE-2022-0536
					"getobject@1.0.0"
					"ini@1.3.6"				# DoS, DT, ID		# CVE-2020-7788
					"ip@2.0.1"				# DoS, DT, ID		# CVE-2024-29415, CVE-2023-42282							# Still broken
					"jsdom@16.6.0"				# DoS, DT, ID													# [12]
					"json-schema@0.4.0"
					#"lodash@4.17.21"			# DoS, DT, ID													# * [7] ; No fix for lodash.template
					"minimatch@3.0.5"			# DoS			# CVE-2022-3517
					"minimist@0.2.4"			# DoS, DT, ID		# CVE-2021-44906, CVE-2020-7598
					"minimist@1.2.6"			# DoS, DT, ID		# CVE-2021-44906, CVE-2020-7598
					"postcss@8.4.31"			# DT			# CVE-2023-44270
					"shelljs@0.8.5"				# DoS, ID		# CVE-2022-0144, GHSA-64g7-mvw6-v9qj
					"workbox-build@7.1.1"			# DoS, DT, ID													# [7 contained in lodash.template dep]
					"ws@7.5.10"				# DoS			# CVE-2024-37890
					"yargs-parser@13.1.2"			# DoS, DT, ID		# CVE-2020-7608
				)
				enpm install ${pkgs[@]} -D
				pkgs=(
					"@grpc/grpc-js@1.8.22"			# DoS			# CVE-2024-37168
					"axios@0.28.0"				# DoS, ID		# CVE-2021-3749, CVE-2023-45857, CVE-2020-28168
					"d3-color@3.1.0"			# DoS			# GHSA-36jr-mh4h-2g58
					"follow-redirects@1.15.6"		# DoS, DT, ID		# CVE-2022-0155, CVE-2024-28849, CVE-2023-26159, CVE-2022-0536
					"lodash@4.17.21"			# DoS, DT, ID		# CVE-2019-10744, CVE-2019-1010266, CVE-2021-23337, CVE-2020-28500
					"node-fetch@2.6.7"			# DoS, DT, ID		# CVE-2022-0235
					"protobufjs@6.11.4"			# DoS, DT, ID		# CVE-2023-36665, CVE-2022-25878
					"semver@7.5.2"				# DoS			# CVE-2022-25883
					"ua-parser-js@0.7.33"			# DoS			# CVE-2022-25927, CVE-2020-7793, CVE-2021-27292
				)
				enpm install ${pkgs[@]} -P
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
				enpm install ${pkgs[@]} -D

			popd || die

			pushd "${S}/newIDE/electron-app/app" || die
				pkgs=(
					"bl@1.2.3"				# DoS, ID		# CVE-2020-8244
					"electron-updater@6.3.0-alpha.6"	# DoS, DT, ID		# CVE-2024-39698
					"electron@${ELECTRON_APP_ELECTRON_PV}"	# DoS, DT, ID		# CVE-2023-5217, CVE-2023-44402, CVE-2023-39956, CVE-2023-29198
					"http-cache-semantics@4.1.1"		# DT, ID		# CVE-2022-25881									# Depends on electron
				)
				enpm install ${pkgs[@]} -D
				pkgs=(
					"async@2.6.4"				# DoS, DT, ID		# CVE-2021-43138
					"axios@0.28.0"				# DoS, ID		# CVE-2021-3749, CVE-2020-28168
					"braces@2.3.1"				# DoS			# CVE-2018-1109, GHSA-g95f-p29q-9xw4
					"braces@3.0.3"				# DoS			# CVE-2018-1109, GHSA-g95f-p29q-9xw4
					"debug@2.6.9"				# DoS			# CVE-2017-20165, CVE-2017-16137
					"decode-uri-component@0.2.1"		# DoS			# CVE-2022-38900
					"follow-redirects@1.14.8"		# DoS, DT, ID		# CVE-2022-0155, CVE-2022-0536
					"follow-redirects@1.15.6"		# DoS, DT, ID		# CVE-2022-0155, CVE-2022-0536
					"glob-parent@5.1.2"			# DoS														# [8]
					"minimatch@3.0.5"			# DoS			# CVE-2022-3517
					"minimist@1.2.6"			# DoS, DT, ID		# CVE-2021-44906, CVE-2020-7598
					"morgan@1.9.1"				# DoS, DT, ID		# CVE-2019-5413
					"node-fetch@2.6.7"			# DoS, DT, ID		# CVE-2022-0235
					"websocket-extensions@0.1.4"		# DT, ID		# CVE-2020-7662
					"ws@7.5.10"				# ID			# CVE-2021-32640
				)
				enpm install ${pkgs[@]} -P
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
		eapply "${FILESDIR}/${PN}-5.4.204-disable-analytics.patch"
	fi
	eapply "${FILESDIR}/${PN}-5.0.0_beta97-use-emscripten-envvar-for-webidl_binder_py.patch"
	eapply "${FILESDIR}/${PN}-5.0.0_beta108-unix-make.patch"
#	eapply #"${FILESDIR}/${PN}-5.0.127-fix-cmake-cxx-tests.patch"
	eapply --binary "${FILESDIR}/${PN}-5.0.127-SFML-define-linux-00.patch"
	eapply "${FILESDIR}/${PN}-5.0.127-SFML-define-linux-01.patch"
	eapply "${FILESDIR}/${PN}-5.3.198-electron-builder-placeholder.patch"

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
# In https://github.com/4ian/GDevelop/blob/v5.3.204/GDevelop.js/Gruntfile.js#L88
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
}

src_install() {
	insinto "${NPM_INSTALL_PATH}"
	doins -r "newIDE/electron-app/dist/linux-unpacked/"*
	electron-app_gen_wrapper \
		"${PN}" \
		"${NPM_INSTALL_PATH}/${PN}"

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
# wayland:                    failed
# X:                          passed
# command-line wrapper:       passed
# 2D platformer prototyping:  passed
# 3D platformer prototyping:  passed with transparency
