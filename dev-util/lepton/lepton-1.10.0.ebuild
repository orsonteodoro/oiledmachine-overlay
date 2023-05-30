# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="Lepton"

NODE_VERSION=14
#ELECTRON_APP_APPIMAGE="1"
ELECTRON_APP_APPIMAGE_ARCHIVE_NAME="${MY_PN}-${PV}.AppImage"
#ELECTRON_APP_SNAP="1"
ELECTRON_APP_SNAP_ARCHIVE_NAME="${MY_PN}_${PV}_amd64.snap"
ELECTRON_APP_ELECTRON_PV="13.6.9"
ELECTRON_APP_LOCKFILE_EXACT_VERSIONS_ONLY="1"
ELECTRON_APP_MODE="npm"
ELECTRON_APP_REACT_PV="17.0.0"
NODE_ENV="development"
NPM_INSTALL_UNPACK_ARGS="--legacy-peer-deps"
NPM_INSTALL_UNPACK_AUDIT_FIX_ARGS="--legacy-peer-deps"
NPM_INSTALL_PATH="/opt/${PN}"

inherit desktop electron-app lcnr npm

DESCRIPTION="Democratizing Snippet Management (macOS/Win/Linux)"
HOMEPAGE="http://hackjutsu.com/Lepton"
THIRD_PARTY_LICENSES="
	(
		custom
		all-rights-reserved
		keep-copyright-notice
		MIT
	)
	(
		all-rights-reserved
		MIT
	)
	(
		WTFPL-2
		ISC
	)
	0BSD
	Apache-2.0
	BSD
	BSD-2
	CC-BY-3.0
	ISC
	MIT
	MIT CC0-1.0
	PSF-2.4
	Unlicense
	|| (
		Apache-2.0
		MPL-2.0
	)
"
LICENSE="
	${ELECTRON_APP_LICENSES}
	${THIRD_PARTY_LICENSES}
	MIT
"

# For ELECTRON_APP_LICENSES, see
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/electron-app.eclass#L67

# ( custom MIT all-rights-reserved keep-copyright-notice ) - node_modules/ecc-jsbn/lib/LICENSE-jsbn
# ( MIT all-rights-reserved ) - node_modules/string_decoder/LICENSE
# ( WTFPL-2 ISC ) - node_modules/sanitize-filename/LICENSE.md
# 0BSD - node_modules/tslib/CopyrightNotice.txt
# Apache-2.0
# BSD
# BSD-2
# CC-BY-3.0 - node_modules/atob/LICENSE.DOCS
# ISC
# MIT
# MIT CC0-1.0 - node_modules/lodash.sortby/LICENSE
# PSF-2.4  - node_modules/argparse/LICENSE
# Unlicense - node_modules/tweetnacl/LICENSE
# || ( Apache-2.0 MPL-2.0 ) - node_modules/dompurify/LICENSE

KEYWORDS="~amd64"
SLOT="0"
IUSE=" r6"
REQUIRED_USE="
!wayland X
"
DEPEND+="
	dev-libs/libsass
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=net-libs/nodejs-${NODE_VERSION}:${NODE_VERSION}
	>=net-libs/nodejs-${NODE_VERSION}[npm]
"
# Initially generated from:
#   grep "resolved" /var/tmp/portage/dev-util/lepton-1.10.0/work/lepton-1.10.0/package-lock.json | cut -f 4 -d '"' | cut -f 1 -d "#" | sort | uniq
# UPDATER_START_NPM_EXTERNAL_URIS
NPM_EXTERNAL_URIS="
https://registry.npmjs.org/@babel/code-frame/-/code-frame-7.12.11.tgz -> npmpkg-@babel-code-frame-7.12.11.tgz
https://registry.npmjs.org/@babel/generator/-/generator-7.10.2.tgz -> npmpkg-@babel-generator-7.10.2.tgz
https://registry.npmjs.org/@babel/helper-function-name/-/helper-function-name-7.10.1.tgz -> npmpkg-@babel-helper-function-name-7.10.1.tgz
https://registry.npmjs.org/@babel/helper-get-function-arity/-/helper-get-function-arity-7.10.1.tgz -> npmpkg-@babel-helper-get-function-arity-7.10.1.tgz
https://registry.npmjs.org/@babel/helper-split-export-declaration/-/helper-split-export-declaration-7.10.1.tgz -> npmpkg-@babel-helper-split-export-declaration-7.10.1.tgz
https://registry.npmjs.org/@babel/helper-validator-identifier/-/helper-validator-identifier-7.14.5.tgz -> npmpkg-@babel-helper-validator-identifier-7.14.5.tgz
https://registry.npmjs.org/@babel/highlight/-/highlight-7.14.5.tgz -> npmpkg-@babel-highlight-7.14.5.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/js-tokens/-/js-tokens-4.0.0.tgz -> npmpkg-js-tokens-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/@babel/parser/-/parser-7.10.2.tgz -> npmpkg-@babel-parser-7.10.2.tgz
https://registry.npmjs.org/@babel/runtime/-/runtime-7.14.5.tgz -> npmpkg-@babel-runtime-7.14.5.tgz
https://registry.npmjs.org/@babel/runtime-corejs2/-/runtime-corejs2-7.14.5.tgz -> npmpkg-@babel-runtime-corejs2-7.14.5.tgz
https://registry.npmjs.org/regenerator-runtime/-/regenerator-runtime-0.13.5.tgz -> npmpkg-regenerator-runtime-0.13.5.tgz
https://registry.npmjs.org/@babel/runtime-corejs3/-/runtime-corejs3-7.10.2.tgz -> npmpkg-@babel-runtime-corejs3-7.10.2.tgz
https://registry.npmjs.org/regenerator-runtime/-/regenerator-runtime-0.13.5.tgz -> npmpkg-regenerator-runtime-0.13.5.tgz
https://registry.npmjs.org/regenerator-runtime/-/regenerator-runtime-0.13.5.tgz -> npmpkg-regenerator-runtime-0.13.5.tgz
https://registry.npmjs.org/@babel/template/-/template-7.10.1.tgz -> npmpkg-@babel-template-7.10.1.tgz
https://registry.npmjs.org/@babel/traverse/-/traverse-7.10.1.tgz -> npmpkg-@babel-traverse-7.10.1.tgz
https://registry.npmjs.org/debug/-/debug-4.1.1.tgz -> npmpkg-debug-4.1.1.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/@babel/types/-/types-7.10.2.tgz -> npmpkg-@babel-types-7.10.2.tgz
https://registry.npmjs.org/@develar/schema-utils/-/schema-utils-2.6.5.tgz -> npmpkg-@develar-schema-utils-2.6.5.tgz
https://registry.npmjs.org/@electron/get/-/get-1.14.1.tgz -> npmpkg-@electron-get-1.14.1.tgz
https://registry.npmjs.org/debug/-/debug-4.1.1.tgz -> npmpkg-debug-4.1.1.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/@electron/remote/-/remote-1.1.0.tgz -> npmpkg-@electron-remote-1.1.0.tgz
https://registry.npmjs.org/@electron/universal/-/universal-1.0.5.tgz -> npmpkg-@electron-universal-1.0.5.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-9.1.0.tgz -> npmpkg-fs-extra-9.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz -> npmpkg-universalify-2.0.0.tgz
https://registry.npmjs.org/@eslint/eslintrc/-/eslintrc-0.4.2.tgz -> npmpkg-@eslint-eslintrc-0.4.2.tgz
https://registry.npmjs.org/debug/-/debug-4.1.1.tgz -> npmpkg-debug-4.1.1.tgz
https://registry.npmjs.org/globals/-/globals-13.9.0.tgz -> npmpkg-globals-13.9.0.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.20.2.tgz -> npmpkg-type-fest-0.20.2.tgz
https://registry.npmjs.org/@malept/cross-spawn-promise/-/cross-spawn-promise-1.1.1.tgz -> npmpkg-@malept-cross-spawn-promise-1.1.1.tgz
https://registry.npmjs.org/@malept/flatpak-bundler/-/flatpak-bundler-0.4.0.tgz -> npmpkg-@malept-flatpak-bundler-0.4.0.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-9.1.0.tgz -> npmpkg-fs-extra-9.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz -> npmpkg-universalify-2.0.0.tgz
https://registry.npmjs.org/@scarf/scarf/-/scarf-1.0.5.tgz -> npmpkg-@scarf-scarf-1.0.5.tgz
https://registry.npmjs.org/@sindresorhus/is/-/is-0.14.0.tgz -> npmpkg-@sindresorhus-is-0.14.0.tgz
https://registry.npmjs.org/@szmarczak/http-timer/-/http-timer-1.1.2.tgz -> npmpkg-@szmarczak-http-timer-1.1.2.tgz
https://registry.npmjs.org/@tootallnate/once/-/once-1.1.2.tgz -> npmpkg-@tootallnate-once-1.1.2.tgz
https://registry.npmjs.org/@types/color-name/-/color-name-1.1.1.tgz -> npmpkg-@types-color-name-1.1.1.tgz
https://registry.npmjs.org/@types/debug/-/debug-4.1.7.tgz -> npmpkg-@types-debug-4.1.7.tgz
https://registry.npmjs.org/@types/fs-extra/-/fs-extra-9.0.13.tgz -> npmpkg-@types-fs-extra-9.0.13.tgz
https://registry.npmjs.org/@types/glob/-/glob-7.2.0.tgz -> npmpkg-@types-glob-7.2.0.tgz
https://registry.npmjs.org/@types/json-schema/-/json-schema-7.0.7.tgz -> npmpkg-@types-json-schema-7.0.7.tgz
https://registry.npmjs.org/@types/minimatch/-/minimatch-5.1.2.tgz -> npmpkg-@types-minimatch-5.1.2.tgz
https://registry.npmjs.org/@types/ms/-/ms-0.7.31.tgz -> npmpkg-@types-ms-0.7.31.tgz
https://registry.npmjs.org/@types/node/-/node-14.17.3.tgz -> npmpkg-@types-node-14.17.3.tgz
https://registry.npmjs.org/@types/plist/-/plist-3.0.2.tgz -> npmpkg-@types-plist-3.0.2.tgz
https://registry.npmjs.org/@types/semver/-/semver-7.2.0.tgz -> npmpkg-@types-semver-7.2.0.tgz
https://registry.npmjs.org/@types/verror/-/verror-1.10.6.tgz -> npmpkg-@types-verror-1.10.6.tgz
https://registry.npmjs.org/@types/yargs/-/yargs-17.0.24.tgz -> npmpkg-@types-yargs-17.0.24.tgz
https://registry.npmjs.org/@types/yargs-parser/-/yargs-parser-21.0.0.tgz -> npmpkg-@types-yargs-parser-21.0.0.tgz
https://registry.npmjs.org/@webassemblyjs/ast/-/ast-1.9.0.tgz -> npmpkg-@webassemblyjs-ast-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/floating-point-hex-parser/-/floating-point-hex-parser-1.9.0.tgz -> npmpkg-@webassemblyjs-floating-point-hex-parser-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/helper-api-error/-/helper-api-error-1.9.0.tgz -> npmpkg-@webassemblyjs-helper-api-error-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/helper-buffer/-/helper-buffer-1.9.0.tgz -> npmpkg-@webassemblyjs-helper-buffer-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/helper-code-frame/-/helper-code-frame-1.9.0.tgz -> npmpkg-@webassemblyjs-helper-code-frame-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/helper-fsm/-/helper-fsm-1.9.0.tgz -> npmpkg-@webassemblyjs-helper-fsm-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/helper-module-context/-/helper-module-context-1.9.0.tgz -> npmpkg-@webassemblyjs-helper-module-context-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/helper-wasm-bytecode/-/helper-wasm-bytecode-1.9.0.tgz -> npmpkg-@webassemblyjs-helper-wasm-bytecode-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/helper-wasm-section/-/helper-wasm-section-1.9.0.tgz -> npmpkg-@webassemblyjs-helper-wasm-section-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/ieee754/-/ieee754-1.9.0.tgz -> npmpkg-@webassemblyjs-ieee754-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/leb128/-/leb128-1.9.0.tgz -> npmpkg-@webassemblyjs-leb128-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/utf8/-/utf8-1.9.0.tgz -> npmpkg-@webassemblyjs-utf8-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-edit/-/wasm-edit-1.9.0.tgz -> npmpkg-@webassemblyjs-wasm-edit-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-gen/-/wasm-gen-1.9.0.tgz -> npmpkg-@webassemblyjs-wasm-gen-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-opt/-/wasm-opt-1.9.0.tgz -> npmpkg-@webassemblyjs-wasm-opt-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-parser/-/wasm-parser-1.9.0.tgz -> npmpkg-@webassemblyjs-wasm-parser-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/wast-parser/-/wast-parser-1.9.0.tgz -> npmpkg-@webassemblyjs-wast-parser-1.9.0.tgz
https://registry.npmjs.org/@webassemblyjs/wast-printer/-/wast-printer-1.9.0.tgz -> npmpkg-@webassemblyjs-wast-printer-1.9.0.tgz
https://registry.npmjs.org/@xtuc/ieee754/-/ieee754-1.2.0.tgz -> npmpkg-@xtuc-ieee754-1.2.0.tgz
https://registry.npmjs.org/@xtuc/long/-/long-4.2.2.tgz -> npmpkg-@xtuc-long-4.2.2.tgz
https://registry.npmjs.org/7zip-bin/-/7zip-bin-5.1.1.tgz -> npmpkg-7zip-bin-5.1.1.tgz
https://registry.npmjs.org/abab/-/abab-2.0.5.tgz -> npmpkg-abab-2.0.5.tgz
https://registry.npmjs.org/abbrev/-/abbrev-1.1.1.tgz -> npmpkg-abbrev-1.1.1.tgz
https://registry.npmjs.org/acorn/-/acorn-7.4.1.tgz -> npmpkg-acorn-7.4.1.tgz
https://registry.npmjs.org/acorn-globals/-/acorn-globals-6.0.0.tgz -> npmpkg-acorn-globals-6.0.0.tgz
https://registry.npmjs.org/acorn-jsx/-/acorn-jsx-5.3.1.tgz -> npmpkg-acorn-jsx-5.3.1.tgz
https://registry.npmjs.org/acorn-walk/-/acorn-walk-7.1.1.tgz -> npmpkg-acorn-walk-7.1.1.tgz
https://registry.npmjs.org/agent-base/-/agent-base-6.0.2.tgz -> npmpkg-agent-base-6.0.2.tgz
https://registry.npmjs.org/debug/-/debug-4.1.1.tgz -> npmpkg-debug-4.1.1.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/ajv/-/ajv-6.12.6.tgz -> npmpkg-ajv-6.12.6.tgz
https://registry.npmjs.org/ajv-errors/-/ajv-errors-1.0.1.tgz -> npmpkg-ajv-errors-1.0.1.tgz
https://registry.npmjs.org/ajv-keywords/-/ajv-keywords-3.5.2.tgz -> npmpkg-ajv-keywords-3.5.2.tgz
https://registry.npmjs.org/amdefine/-/amdefine-1.0.1.tgz -> npmpkg-amdefine-1.0.1.tgz
https://registry.npmjs.org/ansi_up/-/ansi_up-5.0.1.tgz -> npmpkg-ansi_up-5.0.1.tgz
https://registry.npmjs.org/ansi-align/-/ansi-align-3.0.1.tgz -> npmpkg-ansi-align-3.0.1.tgz
https://registry.npmjs.org/ansi-colors/-/ansi-colors-4.1.1.tgz -> npmpkg-ansi-colors-4.1.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-2.1.1.tgz -> npmpkg-ansi-regex-2.1.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-2.2.1.tgz -> npmpkg-ansi-styles-2.2.1.tgz
https://registry.npmjs.org/anymatch/-/anymatch-3.1.2.tgz -> npmpkg-anymatch-3.1.2.tgz
https://registry.npmjs.org/app-builder-bin/-/app-builder-bin-3.7.1.tgz -> npmpkg-app-builder-bin-3.7.1.tgz
https://registry.npmjs.org/app-builder-lib/-/app-builder-lib-22.14.13.tgz -> npmpkg-app-builder-lib-22.14.13.tgz
https://registry.npmjs.org/argparse/-/argparse-2.0.1.tgz -> npmpkg-argparse-2.0.1.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/form-data/-/form-data-4.0.0.tgz -> npmpkg-form-data-4.0.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-4.1.0.tgz -> npmpkg-js-yaml-4.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz -> npmpkg-universalify-2.0.0.tgz
https://registry.npmjs.org/aproba/-/aproba-1.2.0.tgz -> npmpkg-aproba-1.2.0.tgz
https://registry.npmjs.org/are-we-there-yet/-/are-we-there-yet-1.1.5.tgz -> npmpkg-are-we-there-yet-1.1.5.tgz
https://registry.npmjs.org/argparse/-/argparse-1.0.10.tgz -> npmpkg-argparse-1.0.10.tgz
https://registry.npmjs.org/arr-diff/-/arr-diff-4.0.0.tgz -> npmpkg-arr-diff-4.0.0.tgz
https://registry.npmjs.org/arr-flatten/-/arr-flatten-1.1.0.tgz -> npmpkg-arr-flatten-1.1.0.tgz
https://registry.npmjs.org/arr-union/-/arr-union-3.1.0.tgz -> npmpkg-arr-union-3.1.0.tgz
https://registry.npmjs.org/array-find-index/-/array-find-index-1.0.2.tgz -> npmpkg-array-find-index-1.0.2.tgz
https://registry.npmjs.org/array-includes/-/array-includes-3.1.1.tgz -> npmpkg-array-includes-3.1.1.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.3.2.tgz -> npmpkg-array-unique-0.3.2.tgz
https://registry.npmjs.org/array.prototype.flat/-/array.prototype.flat-1.2.3.tgz -> npmpkg-array.prototype.flat-1.2.3.tgz
https://registry.npmjs.org/asap/-/asap-2.0.6.tgz -> npmpkg-asap-2.0.6.tgz
https://registry.npmjs.org/asar/-/asar-3.2.0.tgz -> npmpkg-asar-3.2.0.tgz
https://registry.npmjs.org/commander/-/commander-5.1.0.tgz -> npmpkg-commander-5.1.0.tgz
https://registry.npmjs.org/asn1/-/asn1-0.2.4.tgz -> npmpkg-asn1-0.2.4.tgz
https://registry.npmjs.org/asn1.js/-/asn1.js-5.4.1.tgz -> npmpkg-asn1.js-5.4.1.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.0.tgz -> npmpkg-bn.js-4.12.0.tgz
https://registry.npmjs.org/assert/-/assert-1.5.0.tgz -> npmpkg-assert-1.5.0.tgz
https://registry.npmjs.org/assert-plus/-/assert-plus-1.0.0.tgz -> npmpkg-assert-plus-1.0.0.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.1.tgz -> npmpkg-inherits-2.0.1.tgz
https://registry.npmjs.org/util/-/util-0.10.3.tgz -> npmpkg-util-0.10.3.tgz
https://registry.npmjs.org/assign-symbols/-/assign-symbols-1.0.0.tgz -> npmpkg-assign-symbols-1.0.0.tgz
https://registry.npmjs.org/ast-types/-/ast-types-0.13.4.tgz -> npmpkg-ast-types-0.13.4.tgz
https://registry.npmjs.org/tslib/-/tslib-2.3.0.tgz -> npmpkg-tslib-2.3.0.tgz
https://registry.npmjs.org/astral-regex/-/astral-regex-2.0.0.tgz -> npmpkg-astral-regex-2.0.0.tgz
https://registry.npmjs.org/async/-/async-3.2.4.tgz -> npmpkg-async-3.2.4.tgz
https://registry.npmjs.org/async-each/-/async-each-1.0.3.tgz -> npmpkg-async-each-1.0.3.tgz
https://registry.npmjs.org/async-exit-hook/-/async-exit-hook-2.0.1.tgz -> npmpkg-async-exit-hook-2.0.1.tgz
https://registry.npmjs.org/async-foreach/-/async-foreach-0.1.3.tgz -> npmpkg-async-foreach-0.1.3.tgz
https://registry.npmjs.org/asynckit/-/asynckit-0.4.0.tgz -> npmpkg-asynckit-0.4.0.tgz
https://registry.npmjs.org/at-least-node/-/at-least-node-1.0.0.tgz -> npmpkg-at-least-node-1.0.0.tgz
https://registry.npmjs.org/atob/-/atob-2.1.2.tgz -> npmpkg-atob-2.1.2.tgz
https://registry.npmjs.org/autolinker/-/autolinker-3.14.1.tgz -> npmpkg-autolinker-3.14.1.tgz
https://registry.npmjs.org/aws-sign2/-/aws-sign2-0.7.0.tgz -> npmpkg-aws-sign2-0.7.0.tgz
https://registry.npmjs.org/aws4/-/aws4-1.10.0.tgz -> npmpkg-aws4-1.10.0.tgz
https://registry.npmjs.org/babel-code-frame/-/babel-code-frame-6.26.0.tgz -> npmpkg-babel-code-frame-6.26.0.tgz
https://registry.npmjs.org/babel-core/-/babel-core-6.26.3.tgz -> npmpkg-babel-core-6.26.3.tgz
https://registry.npmjs.org/babel-eslint/-/babel-eslint-10.1.0.tgz -> npmpkg-babel-eslint-10.1.0.tgz
https://registry.npmjs.org/babel-generator/-/babel-generator-6.26.1.tgz -> npmpkg-babel-generator-6.26.1.tgz
https://registry.npmjs.org/jsesc/-/jsesc-1.3.0.tgz -> npmpkg-jsesc-1.3.0.tgz
https://registry.npmjs.org/babel-helper-builder-react-jsx/-/babel-helper-builder-react-jsx-6.26.0.tgz -> npmpkg-babel-helper-builder-react-jsx-6.26.0.tgz
https://registry.npmjs.org/babel-helper-call-delegate/-/babel-helper-call-delegate-6.24.1.tgz -> npmpkg-babel-helper-call-delegate-6.24.1.tgz
https://registry.npmjs.org/babel-helper-define-map/-/babel-helper-define-map-6.26.0.tgz -> npmpkg-babel-helper-define-map-6.26.0.tgz
https://registry.npmjs.org/babel-helper-function-name/-/babel-helper-function-name-6.24.1.tgz -> npmpkg-babel-helper-function-name-6.24.1.tgz
https://registry.npmjs.org/babel-helper-get-function-arity/-/babel-helper-get-function-arity-6.24.1.tgz -> npmpkg-babel-helper-get-function-arity-6.24.1.tgz
https://registry.npmjs.org/babel-helper-hoist-variables/-/babel-helper-hoist-variables-6.24.1.tgz -> npmpkg-babel-helper-hoist-variables-6.24.1.tgz
https://registry.npmjs.org/babel-helper-optimise-call-expression/-/babel-helper-optimise-call-expression-6.24.1.tgz -> npmpkg-babel-helper-optimise-call-expression-6.24.1.tgz
https://registry.npmjs.org/babel-helper-regex/-/babel-helper-regex-6.26.0.tgz -> npmpkg-babel-helper-regex-6.26.0.tgz
https://registry.npmjs.org/babel-helper-replace-supers/-/babel-helper-replace-supers-6.24.1.tgz -> npmpkg-babel-helper-replace-supers-6.24.1.tgz
https://registry.npmjs.org/babel-helpers/-/babel-helpers-6.24.1.tgz -> npmpkg-babel-helpers-6.24.1.tgz
https://registry.npmjs.org/babel-loader/-/babel-loader-7.1.5.tgz -> npmpkg-babel-loader-7.1.5.tgz
https://registry.npmjs.org/babel-messages/-/babel-messages-6.23.0.tgz -> npmpkg-babel-messages-6.23.0.tgz
https://registry.npmjs.org/babel-plugin-check-es2015-constants/-/babel-plugin-check-es2015-constants-6.22.0.tgz -> npmpkg-babel-plugin-check-es2015-constants-6.22.0.tgz
https://registry.npmjs.org/babel-plugin-syntax-dynamic-import/-/babel-plugin-syntax-dynamic-import-6.18.0.tgz -> npmpkg-babel-plugin-syntax-dynamic-import-6.18.0.tgz
https://registry.npmjs.org/babel-plugin-syntax-flow/-/babel-plugin-syntax-flow-6.18.0.tgz -> npmpkg-babel-plugin-syntax-flow-6.18.0.tgz
https://registry.npmjs.org/babel-plugin-syntax-jsx/-/babel-plugin-syntax-jsx-6.18.0.tgz -> npmpkg-babel-plugin-syntax-jsx-6.18.0.tgz
https://registry.npmjs.org/babel-plugin-transform-es2015-arrow-functions/-/babel-plugin-transform-es2015-arrow-functions-6.22.0.tgz -> npmpkg-babel-plugin-transform-es2015-arrow-functions-6.22.0.tgz
https://registry.npmjs.org/babel-plugin-transform-es2015-block-scoped-functions/-/babel-plugin-transform-es2015-block-scoped-functions-6.22.0.tgz -> npmpkg-babel-plugin-transform-es2015-block-scoped-functions-6.22.0.tgz
https://registry.npmjs.org/babel-plugin-transform-es2015-block-scoping/-/babel-plugin-transform-es2015-block-scoping-6.26.0.tgz -> npmpkg-babel-plugin-transform-es2015-block-scoping-6.26.0.tgz
https://registry.npmjs.org/babel-plugin-transform-es2015-classes/-/babel-plugin-transform-es2015-classes-6.24.1.tgz -> npmpkg-babel-plugin-transform-es2015-classes-6.24.1.tgz
https://registry.npmjs.org/babel-plugin-transform-es2015-computed-properties/-/babel-plugin-transform-es2015-computed-properties-6.24.1.tgz -> npmpkg-babel-plugin-transform-es2015-computed-properties-6.24.1.tgz
https://registry.npmjs.org/babel-plugin-transform-es2015-destructuring/-/babel-plugin-transform-es2015-destructuring-6.23.0.tgz -> npmpkg-babel-plugin-transform-es2015-destructuring-6.23.0.tgz
https://registry.npmjs.org/babel-plugin-transform-es2015-duplicate-keys/-/babel-plugin-transform-es2015-duplicate-keys-6.24.1.tgz -> npmpkg-babel-plugin-transform-es2015-duplicate-keys-6.24.1.tgz
https://registry.npmjs.org/babel-plugin-transform-es2015-for-of/-/babel-plugin-transform-es2015-for-of-6.23.0.tgz -> npmpkg-babel-plugin-transform-es2015-for-of-6.23.0.tgz
https://registry.npmjs.org/babel-plugin-transform-es2015-function-name/-/babel-plugin-transform-es2015-function-name-6.24.1.tgz -> npmpkg-babel-plugin-transform-es2015-function-name-6.24.1.tgz
https://registry.npmjs.org/babel-plugin-transform-es2015-literals/-/babel-plugin-transform-es2015-literals-6.22.0.tgz -> npmpkg-babel-plugin-transform-es2015-literals-6.22.0.tgz
https://registry.npmjs.org/babel-plugin-transform-es2015-modules-amd/-/babel-plugin-transform-es2015-modules-amd-6.24.1.tgz -> npmpkg-babel-plugin-transform-es2015-modules-amd-6.24.1.tgz
https://registry.npmjs.org/babel-plugin-transform-es2015-modules-commonjs/-/babel-plugin-transform-es2015-modules-commonjs-6.26.2.tgz -> npmpkg-babel-plugin-transform-es2015-modules-commonjs-6.26.2.tgz
https://registry.npmjs.org/babel-plugin-transform-es2015-modules-systemjs/-/babel-plugin-transform-es2015-modules-systemjs-6.24.1.tgz -> npmpkg-babel-plugin-transform-es2015-modules-systemjs-6.24.1.tgz
https://registry.npmjs.org/babel-plugin-transform-es2015-modules-umd/-/babel-plugin-transform-es2015-modules-umd-6.24.1.tgz -> npmpkg-babel-plugin-transform-es2015-modules-umd-6.24.1.tgz
https://registry.npmjs.org/babel-plugin-transform-es2015-object-super/-/babel-plugin-transform-es2015-object-super-6.24.1.tgz -> npmpkg-babel-plugin-transform-es2015-object-super-6.24.1.tgz
https://registry.npmjs.org/babel-plugin-transform-es2015-parameters/-/babel-plugin-transform-es2015-parameters-6.24.1.tgz -> npmpkg-babel-plugin-transform-es2015-parameters-6.24.1.tgz
https://registry.npmjs.org/babel-plugin-transform-es2015-shorthand-properties/-/babel-plugin-transform-es2015-shorthand-properties-6.24.1.tgz -> npmpkg-babel-plugin-transform-es2015-shorthand-properties-6.24.1.tgz
https://registry.npmjs.org/babel-plugin-transform-es2015-spread/-/babel-plugin-transform-es2015-spread-6.22.0.tgz -> npmpkg-babel-plugin-transform-es2015-spread-6.22.0.tgz
https://registry.npmjs.org/babel-plugin-transform-es2015-sticky-regex/-/babel-plugin-transform-es2015-sticky-regex-6.24.1.tgz -> npmpkg-babel-plugin-transform-es2015-sticky-regex-6.24.1.tgz
https://registry.npmjs.org/babel-plugin-transform-es2015-template-literals/-/babel-plugin-transform-es2015-template-literals-6.22.0.tgz -> npmpkg-babel-plugin-transform-es2015-template-literals-6.22.0.tgz
https://registry.npmjs.org/babel-plugin-transform-es2015-typeof-symbol/-/babel-plugin-transform-es2015-typeof-symbol-6.23.0.tgz -> npmpkg-babel-plugin-transform-es2015-typeof-symbol-6.23.0.tgz
https://registry.npmjs.org/babel-plugin-transform-es2015-unicode-regex/-/babel-plugin-transform-es2015-unicode-regex-6.24.1.tgz -> npmpkg-babel-plugin-transform-es2015-unicode-regex-6.24.1.tgz
https://registry.npmjs.org/babel-plugin-transform-flow-strip-types/-/babel-plugin-transform-flow-strip-types-6.22.0.tgz -> npmpkg-babel-plugin-transform-flow-strip-types-6.22.0.tgz
https://registry.npmjs.org/babel-plugin-transform-react-display-name/-/babel-plugin-transform-react-display-name-6.25.0.tgz -> npmpkg-babel-plugin-transform-react-display-name-6.25.0.tgz
https://registry.npmjs.org/babel-plugin-transform-react-jsx/-/babel-plugin-transform-react-jsx-6.24.1.tgz -> npmpkg-babel-plugin-transform-react-jsx-6.24.1.tgz
https://registry.npmjs.org/babel-plugin-transform-react-jsx-self/-/babel-plugin-transform-react-jsx-self-6.22.0.tgz -> npmpkg-babel-plugin-transform-react-jsx-self-6.22.0.tgz
https://registry.npmjs.org/babel-plugin-transform-react-jsx-source/-/babel-plugin-transform-react-jsx-source-6.22.0.tgz -> npmpkg-babel-plugin-transform-react-jsx-source-6.22.0.tgz
https://registry.npmjs.org/babel-plugin-transform-regenerator/-/babel-plugin-transform-regenerator-6.26.0.tgz -> npmpkg-babel-plugin-transform-regenerator-6.26.0.tgz
https://registry.npmjs.org/babel-plugin-transform-strict-mode/-/babel-plugin-transform-strict-mode-6.24.1.tgz -> npmpkg-babel-plugin-transform-strict-mode-6.24.1.tgz
https://registry.npmjs.org/babel-preset-es2015/-/babel-preset-es2015-6.24.1.tgz -> npmpkg-babel-preset-es2015-6.24.1.tgz
https://registry.npmjs.org/babel-preset-flow/-/babel-preset-flow-6.23.0.tgz -> npmpkg-babel-preset-flow-6.23.0.tgz
https://registry.npmjs.org/babel-preset-react/-/babel-preset-react-6.24.1.tgz -> npmpkg-babel-preset-react-6.24.1.tgz
https://registry.npmjs.org/babel-register/-/babel-register-6.26.0.tgz -> npmpkg-babel-register-6.26.0.tgz
https://registry.npmjs.org/babel-runtime/-/babel-runtime-6.26.0.tgz -> npmpkg-babel-runtime-6.26.0.tgz
https://registry.npmjs.org/babel-template/-/babel-template-6.26.0.tgz -> npmpkg-babel-template-6.26.0.tgz
https://registry.npmjs.org/babel-traverse/-/babel-traverse-6.26.0.tgz -> npmpkg-babel-traverse-6.26.0.tgz
https://registry.npmjs.org/globals/-/globals-9.18.0.tgz -> npmpkg-globals-9.18.0.tgz
https://registry.npmjs.org/babel-types/-/babel-types-6.26.0.tgz -> npmpkg-babel-types-6.26.0.tgz
https://registry.npmjs.org/to-fast-properties/-/to-fast-properties-1.0.3.tgz -> npmpkg-to-fast-properties-1.0.3.tgz
https://registry.npmjs.org/babylon/-/babylon-6.18.0.tgz -> npmpkg-babylon-6.18.0.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.0.tgz -> npmpkg-balanced-match-1.0.0.tgz
https://registry.npmjs.org/base/-/base-0.11.2.tgz -> npmpkg-base-0.11.2.tgz
https://registry.npmjs.org/define-property/-/define-property-1.0.0.tgz -> npmpkg-define-property-1.0.0.tgz
https://registry.npmjs.org/base64-js/-/base64-js-1.5.1.tgz -> npmpkg-base64-js-1.5.1.tgz
https://registry.npmjs.org/bcrypt-pbkdf/-/bcrypt-pbkdf-1.0.2.tgz -> npmpkg-bcrypt-pbkdf-1.0.2.tgz
https://registry.npmjs.org/big.js/-/big.js-5.2.2.tgz -> npmpkg-big.js-5.2.2.tgz
https://registry.npmjs.org/binary-extensions/-/binary-extensions-2.2.0.tgz -> npmpkg-binary-extensions-2.2.0.tgz
https://registry.npmjs.org/bindings/-/bindings-1.5.0.tgz -> npmpkg-bindings-1.5.0.tgz
https://registry.npmjs.org/file-uri-to-path/-/file-uri-to-path-1.0.0.tgz -> npmpkg-file-uri-to-path-1.0.0.tgz
https://registry.npmjs.org/block-stream/-/block-stream-0.0.9.tgz -> npmpkg-block-stream-0.0.9.tgz
https://registry.npmjs.org/bluebird/-/bluebird-3.7.2.tgz -> npmpkg-bluebird-3.7.2.tgz
https://registry.npmjs.org/bluebird-lst/-/bluebird-lst-1.0.9.tgz -> npmpkg-bluebird-lst-1.0.9.tgz
https://registry.npmjs.org/bn.js/-/bn.js-5.2.0.tgz -> npmpkg-bn.js-5.2.0.tgz
https://registry.npmjs.org/boolean/-/boolean-3.2.0.tgz -> npmpkg-boolean-3.2.0.tgz
https://registry.npmjs.org/boxen/-/boxen-5.1.2.tgz -> npmpkg-boxen-5.1.2.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-6.3.0.tgz -> npmpkg-camelcase-6.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.20.2.tgz -> npmpkg-type-fest-0.20.2.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/braces/-/braces-2.3.2.tgz -> npmpkg-braces-2.3.2.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/brorand/-/brorand-1.1.0.tgz -> npmpkg-brorand-1.1.0.tgz
https://registry.npmjs.org/browser-process-hrtime/-/browser-process-hrtime-1.0.0.tgz -> npmpkg-browser-process-hrtime-1.0.0.tgz
https://registry.npmjs.org/browserify-aes/-/browserify-aes-1.2.0.tgz -> npmpkg-browserify-aes-1.2.0.tgz
https://registry.npmjs.org/browserify-cipher/-/browserify-cipher-1.0.1.tgz -> npmpkg-browserify-cipher-1.0.1.tgz
https://registry.npmjs.org/browserify-des/-/browserify-des-1.0.2.tgz -> npmpkg-browserify-des-1.0.2.tgz
https://registry.npmjs.org/browserify-rsa/-/browserify-rsa-4.1.0.tgz -> npmpkg-browserify-rsa-4.1.0.tgz
https://registry.npmjs.org/browserify-sign/-/browserify-sign-4.2.1.tgz -> npmpkg-browserify-sign-4.2.1.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.0.tgz -> npmpkg-readable-stream-3.6.0.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz -> npmpkg-safe-buffer-5.2.1.tgz
https://registry.npmjs.org/browserify-zlib/-/browserify-zlib-0.2.0.tgz -> npmpkg-browserify-zlib-0.2.0.tgz
https://registry.npmjs.org/buffer/-/buffer-4.9.2.tgz -> npmpkg-buffer-4.9.2.tgz
https://registry.npmjs.org/buffer-alloc/-/buffer-alloc-1.2.0.tgz -> npmpkg-buffer-alloc-1.2.0.tgz
https://registry.npmjs.org/buffer-alloc-unsafe/-/buffer-alloc-unsafe-1.1.0.tgz -> npmpkg-buffer-alloc-unsafe-1.1.0.tgz
https://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.2.13.tgz -> npmpkg-buffer-crc32-0.2.13.tgz
https://registry.npmjs.org/buffer-equal/-/buffer-equal-1.0.0.tgz -> npmpkg-buffer-equal-1.0.0.tgz
https://registry.npmjs.org/buffer-fill/-/buffer-fill-1.0.0.tgz -> npmpkg-buffer-fill-1.0.0.tgz
https://registry.npmjs.org/buffer-from/-/buffer-from-1.1.1.tgz -> npmpkg-buffer-from-1.1.1.tgz
https://registry.npmjs.org/buffer-xor/-/buffer-xor-1.0.3.tgz -> npmpkg-buffer-xor-1.0.3.tgz
https://registry.npmjs.org/builder-util/-/builder-util-22.14.13.tgz -> npmpkg-builder-util-22.14.13.tgz
https://registry.npmjs.org/builder-util-runtime/-/builder-util-runtime-8.9.2.tgz -> npmpkg-builder-util-runtime-8.9.2.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/@tootallnate/once/-/once-2.0.0.tgz -> npmpkg-@tootallnate-once-2.0.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/argparse/-/argparse-2.0.1.tgz -> npmpkg-argparse-2.0.1.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/http-proxy-agent/-/http-proxy-agent-5.0.0.tgz -> npmpkg-http-proxy-agent-5.0.0.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-4.1.0.tgz -> npmpkg-js-yaml-4.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/source-map-support/-/source-map-support-0.5.21.tgz -> npmpkg-source-map-support-0.5.21.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz -> npmpkg-universalify-2.0.0.tgz
https://registry.npmjs.org/builtin-status-codes/-/builtin-status-codes-3.0.0.tgz -> npmpkg-builtin-status-codes-3.0.0.tgz
https://registry.npmjs.org/bytes/-/bytes-3.1.0.tgz -> npmpkg-bytes-3.1.0.tgz
https://registry.npmjs.org/cacache/-/cacache-12.0.4.tgz -> npmpkg-cacache-12.0.4.tgz
https://registry.npmjs.org/cache-base/-/cache-base-1.0.1.tgz -> npmpkg-cache-base-1.0.1.tgz
https://registry.npmjs.org/cacheable-request/-/cacheable-request-6.1.0.tgz -> npmpkg-cacheable-request-6.1.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-5.1.0.tgz -> npmpkg-get-stream-5.1.0.tgz
https://registry.npmjs.org/lowercase-keys/-/lowercase-keys-2.0.0.tgz -> npmpkg-lowercase-keys-2.0.0.tgz
https://registry.npmjs.org/callsites/-/callsites-3.1.0.tgz -> npmpkg-callsites-3.1.0.tgz
https://registry.npmjs.org/camel-case/-/camel-case-4.1.1.tgz -> npmpkg-camel-case-4.1.1.tgz
https://registry.npmjs.org/camelcase/-/camelcase-2.1.1.tgz -> npmpkg-camelcase-2.1.1.tgz
https://registry.npmjs.org/camelcase-keys/-/camelcase-keys-2.1.0.tgz -> npmpkg-camelcase-keys-2.1.0.tgz
https://registry.npmjs.org/caseless/-/caseless-0.12.0.tgz -> npmpkg-caseless-0.12.0.tgz
https://registry.npmjs.org/chalk/-/chalk-1.1.3.tgz -> npmpkg-chalk-1.1.3.tgz
https://registry.npmjs.org/chart.js/-/chart.js-1.1.1.tgz -> npmpkg-chart.js-1.1.1.tgz
https://registry.npmjs.org/chokidar/-/chokidar-3.5.2.tgz -> npmpkg-chokidar-3.5.2.tgz
https://registry.npmjs.org/braces/-/braces-3.0.2.tgz -> npmpkg-braces-3.0.2.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.0.1.tgz -> npmpkg-fill-range-7.0.1.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/chownr/-/chownr-1.1.4.tgz -> npmpkg-chownr-1.1.4.tgz
https://registry.npmjs.org/chrome-trace-event/-/chrome-trace-event-1.0.2.tgz -> npmpkg-chrome-trace-event-1.0.2.tgz
https://registry.npmjs.org/chromium-pickle-js/-/chromium-pickle-js-0.2.0.tgz -> npmpkg-chromium-pickle-js-0.2.0.tgz
https://registry.npmjs.org/ci-info/-/ci-info-3.8.0.tgz -> npmpkg-ci-info-3.8.0.tgz
https://registry.npmjs.org/cipher-base/-/cipher-base-1.0.4.tgz -> npmpkg-cipher-base-1.0.4.tgz
https://registry.npmjs.org/class-utils/-/class-utils-0.3.6.tgz -> npmpkg-class-utils-0.3.6.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz -> npmpkg-is-accessor-descriptor-0.1.6.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz -> npmpkg-is-data-descriptor-0.1.4.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.6.tgz -> npmpkg-is-descriptor-0.1.6.tgz
https://registry.npmjs.org/kind-of/-/kind-of-5.1.0.tgz -> npmpkg-kind-of-5.1.0.tgz
https://registry.npmjs.org/classnames/-/classnames-2.2.6.tgz -> npmpkg-classnames-2.2.6.tgz
https://registry.npmjs.org/clean-css/-/clean-css-4.2.3.tgz -> npmpkg-clean-css-4.2.3.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/cli-boxes/-/cli-boxes-2.2.1.tgz -> npmpkg-cli-boxes-2.2.1.tgz
https://registry.npmjs.org/cli-truncate/-/cli-truncate-2.1.0.tgz -> npmpkg-cli-truncate-2.1.0.tgz
https://registry.npmjs.org/cliui/-/cliui-8.0.1.tgz -> npmpkg-cliui-8.0.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/clone-deep/-/clone-deep-4.0.1.tgz -> npmpkg-clone-deep-4.0.1.tgz
https://registry.npmjs.org/clone-response/-/clone-response-1.0.2.tgz -> npmpkg-clone-response-1.0.2.tgz
https://registry.npmjs.org/code-point-at/-/code-point-at-1.1.0.tgz -> npmpkg-code-point-at-1.1.0.tgz
https://registry.npmjs.org/codemirror/-/codemirror-5.65.12.tgz -> npmpkg-codemirror-5.65.12.tgz
https://registry.npmjs.org/codemirror-one-dark-theme/-/codemirror-one-dark-theme-1.1.1.tgz -> npmpkg-codemirror-one-dark-theme-1.1.1.tgz
https://registry.npmjs.org/collection-visit/-/collection-visit-1.0.0.tgz -> npmpkg-collection-visit-1.0.0.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/colorette/-/colorette-1.2.2.tgz -> npmpkg-colorette-1.2.2.tgz
https://registry.npmjs.org/colors/-/colors-1.0.3.tgz -> npmpkg-colors-1.0.3.tgz
https://registry.npmjs.org/combined-stream/-/combined-stream-1.0.8.tgz -> npmpkg-combined-stream-1.0.8.tgz
https://registry.npmjs.org/commander/-/commander-4.1.1.tgz -> npmpkg-commander-4.1.1.tgz
https://registry.npmjs.org/commondir/-/commondir-1.0.1.tgz -> npmpkg-commondir-1.0.1.tgz
https://registry.npmjs.org/compare-version/-/compare-version-0.1.2.tgz -> npmpkg-compare-version-0.1.2.tgz
https://registry.npmjs.org/component-emitter/-/component-emitter-1.3.0.tgz -> npmpkg-component-emitter-1.3.0.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/concat-stream/-/concat-stream-1.6.2.tgz -> npmpkg-concat-stream-1.6.2.tgz
https://registry.npmjs.org/config-chain/-/config-chain-1.1.12.tgz -> npmpkg-config-chain-1.1.12.tgz
https://registry.npmjs.org/ini/-/ini-1.3.8.tgz -> npmpkg-ini-1.3.8.tgz
https://registry.npmjs.org/configstore/-/configstore-5.0.1.tgz -> npmpkg-configstore-5.0.1.tgz
https://registry.npmjs.org/make-dir/-/make-dir-3.1.0.tgz -> npmpkg-make-dir-3.1.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/console-browserify/-/console-browserify-1.2.0.tgz -> npmpkg-console-browserify-1.2.0.tgz
https://registry.npmjs.org/console-control-strings/-/console-control-strings-1.1.0.tgz -> npmpkg-console-control-strings-1.1.0.tgz
https://registry.npmjs.org/constants-browserify/-/constants-browserify-1.0.0.tgz -> npmpkg-constants-browserify-1.0.0.tgz
https://registry.npmjs.org/contains-path/-/contains-path-0.1.0.tgz -> npmpkg-contains-path-0.1.0.tgz
https://registry.npmjs.org/convert-source-map/-/convert-source-map-1.7.0.tgz -> npmpkg-convert-source-map-1.7.0.tgz
https://registry.npmjs.org/copy-concurrently/-/copy-concurrently-1.0.5.tgz -> npmpkg-copy-concurrently-1.0.5.tgz
https://registry.npmjs.org/copy-descriptor/-/copy-descriptor-0.1.1.tgz -> npmpkg-copy-descriptor-0.1.1.tgz
https://registry.npmjs.org/core-js/-/core-js-2.6.11.tgz -> npmpkg-core-js-2.6.11.tgz
https://registry.npmjs.org/core-js-pure/-/core-js-pure-3.6.5.tgz -> npmpkg-core-js-pure-3.6.5.tgz
https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.2.tgz -> npmpkg-core-util-is-1.0.2.tgz
https://registry.npmjs.org/crc/-/crc-3.8.0.tgz -> npmpkg-crc-3.8.0.tgz
https://registry.npmjs.org/buffer/-/buffer-5.7.1.tgz -> npmpkg-buffer-5.7.1.tgz
https://registry.npmjs.org/create-ecdh/-/create-ecdh-4.0.4.tgz -> npmpkg-create-ecdh-4.0.4.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.0.tgz -> npmpkg-bn.js-4.12.0.tgz
https://registry.npmjs.org/create-hash/-/create-hash-1.2.0.tgz -> npmpkg-create-hash-1.2.0.tgz
https://registry.npmjs.org/create-hmac/-/create-hmac-1.1.7.tgz -> npmpkg-create-hmac-1.1.7.tgz
https://registry.npmjs.org/create-react-class/-/create-react-class-15.7.0.tgz -> npmpkg-create-react-class-15.7.0.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz -> npmpkg-cross-spawn-7.0.3.tgz
https://registry.npmjs.org/crypto-browserify/-/crypto-browserify-3.12.0.tgz -> npmpkg-crypto-browserify-3.12.0.tgz
https://registry.npmjs.org/crypto-random-string/-/crypto-random-string-2.0.0.tgz -> npmpkg-crypto-random-string-2.0.0.tgz
https://registry.npmjs.org/css-loader/-/css-loader-5.2.6.tgz -> npmpkg-css-loader-5.2.6.tgz
https://registry.npmjs.org/json5/-/json5-2.2.3.tgz -> npmpkg-json5-2.2.3.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-2.0.4.tgz -> npmpkg-loader-utils-2.0.4.tgz
https://registry.npmjs.org/cssesc/-/cssesc-3.0.0.tgz -> npmpkg-cssesc-3.0.0.tgz
https://registry.npmjs.org/cssom/-/cssom-0.4.4.tgz -> npmpkg-cssom-0.4.4.tgz
https://registry.npmjs.org/cssstyle/-/cssstyle-2.3.0.tgz -> npmpkg-cssstyle-2.3.0.tgz
https://registry.npmjs.org/cssom/-/cssom-0.3.8.tgz -> npmpkg-cssom-0.3.8.tgz
https://registry.npmjs.org/currently-unhandled/-/currently-unhandled-0.4.1.tgz -> npmpkg-currently-unhandled-0.4.1.tgz
https://registry.npmjs.org/cycle/-/cycle-1.0.3.tgz -> npmpkg-cycle-1.0.3.tgz
https://registry.npmjs.org/cyclist/-/cyclist-1.0.1.tgz -> npmpkg-cyclist-1.0.1.tgz
https://registry.npmjs.org/dashdash/-/dashdash-1.14.1.tgz -> npmpkg-dashdash-1.14.1.tgz
https://registry.npmjs.org/data-uri-to-buffer/-/data-uri-to-buffer-3.0.1.tgz -> npmpkg-data-uri-to-buffer-3.0.1.tgz
https://registry.npmjs.org/data-urls/-/data-urls-2.0.0.tgz -> npmpkg-data-urls-2.0.0.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/debuglog/-/debuglog-1.0.1.tgz -> npmpkg-debuglog-1.0.1.tgz
https://registry.npmjs.org/decamelize/-/decamelize-1.2.0.tgz -> npmpkg-decamelize-1.2.0.tgz
https://registry.npmjs.org/decimal.js/-/decimal.js-10.2.1.tgz -> npmpkg-decimal.js-10.2.1.tgz
https://registry.npmjs.org/decode-uri-component/-/decode-uri-component-0.2.2.tgz -> npmpkg-decode-uri-component-0.2.2.tgz
https://registry.npmjs.org/decompress-response/-/decompress-response-3.3.0.tgz -> npmpkg-decompress-response-3.3.0.tgz
https://registry.npmjs.org/deep-extend/-/deep-extend-0.6.0.tgz -> npmpkg-deep-extend-0.6.0.tgz
https://registry.npmjs.org/deep-is/-/deep-is-0.1.3.tgz -> npmpkg-deep-is-0.1.3.tgz
https://registry.npmjs.org/defer-to-connect/-/defer-to-connect-1.1.3.tgz -> npmpkg-defer-to-connect-1.1.3.tgz
https://registry.npmjs.org/define-properties/-/define-properties-1.1.3.tgz -> npmpkg-define-properties-1.1.3.tgz
https://registry.npmjs.org/define-property/-/define-property-2.0.2.tgz -> npmpkg-define-property-2.0.2.tgz
https://registry.npmjs.org/degenerator/-/degenerator-2.2.0.tgz -> npmpkg-degenerator-2.2.0.tgz
https://registry.npmjs.org/escodegen/-/escodegen-1.14.3.tgz -> npmpkg-escodegen-1.14.3.tgz
https://registry.npmjs.org/levn/-/levn-0.3.0.tgz -> npmpkg-levn-0.3.0.tgz
https://registry.npmjs.org/optionator/-/optionator-0.8.3.tgz -> npmpkg-optionator-0.8.3.tgz
https://registry.npmjs.org/prelude-ls/-/prelude-ls-1.1.2.tgz -> npmpkg-prelude-ls-1.1.2.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/type-check/-/type-check-0.3.2.tgz -> npmpkg-type-check-0.3.2.tgz
https://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz -> npmpkg-delayed-stream-1.0.0.tgz
https://registry.npmjs.org/delegates/-/delegates-1.0.0.tgz -> npmpkg-delegates-1.0.0.tgz
https://registry.npmjs.org/depd/-/depd-1.1.2.tgz -> npmpkg-depd-1.1.2.tgz
https://registry.npmjs.org/des.js/-/des.js-1.0.1.tgz -> npmpkg-des.js-1.0.1.tgz
https://registry.npmjs.org/detect-file/-/detect-file-1.0.0.tgz -> npmpkg-detect-file-1.0.0.tgz
https://registry.npmjs.org/detect-indent/-/detect-indent-4.0.0.tgz -> npmpkg-detect-indent-4.0.0.tgz
https://registry.npmjs.org/detect-node/-/detect-node-2.1.0.tgz -> npmpkg-detect-node-2.1.0.tgz
https://registry.npmjs.org/dezalgo/-/dezalgo-1.0.3.tgz -> npmpkg-dezalgo-1.0.3.tgz
https://registry.npmjs.org/diffie-hellman/-/diffie-hellman-5.0.3.tgz -> npmpkg-diffie-hellman-5.0.3.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.0.tgz -> npmpkg-bn.js-4.12.0.tgz
https://registry.npmjs.org/dir-compare/-/dir-compare-2.4.0.tgz -> npmpkg-dir-compare-2.4.0.tgz
https://registry.npmjs.org/commander/-/commander-2.9.0.tgz -> npmpkg-commander-2.9.0.tgz
https://registry.npmjs.org/dmg-builder/-/dmg-builder-22.14.13.tgz -> npmpkg-dmg-builder-22.14.13.tgz
https://registry.npmjs.org/argparse/-/argparse-2.0.1.tgz -> npmpkg-argparse-2.0.1.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-4.1.0.tgz -> npmpkg-js-yaml-4.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz -> npmpkg-universalify-2.0.0.tgz
https://registry.npmjs.org/dmg-license/-/dmg-license-1.0.11.tgz -> npmpkg-dmg-license-1.0.11.tgz
https://registry.npmjs.org/doctrine/-/doctrine-3.0.0.tgz -> npmpkg-doctrine-3.0.0.tgz
https://registry.npmjs.org/dom-helpers/-/dom-helpers-3.4.0.tgz -> npmpkg-dom-helpers-3.4.0.tgz
https://registry.npmjs.org/domain-browser/-/domain-browser-1.2.0.tgz -> npmpkg-domain-browser-1.2.0.tgz
https://registry.npmjs.org/domexception/-/domexception-2.0.1.tgz -> npmpkg-domexception-2.0.1.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-5.0.0.tgz -> npmpkg-webidl-conversions-5.0.0.tgz
https://registry.npmjs.org/dompurify/-/dompurify-2.2.9.tgz -> npmpkg-dompurify-2.2.9.tgz
https://registry.npmjs.org/dot-case/-/dot-case-3.0.3.tgz -> npmpkg-dot-case-3.0.3.tgz
https://registry.npmjs.org/dot-prop/-/dot-prop-5.3.0.tgz -> npmpkg-dot-prop-5.3.0.tgz
https://registry.npmjs.org/dotenv/-/dotenv-9.0.2.tgz -> npmpkg-dotenv-9.0.2.tgz
https://registry.npmjs.org/dotenv-expand/-/dotenv-expand-5.1.0.tgz -> npmpkg-dotenv-expand-5.1.0.tgz
https://registry.npmjs.org/duplexer3/-/duplexer3-0.1.4.tgz -> npmpkg-duplexer3-0.1.4.tgz
https://registry.npmjs.org/duplexify/-/duplexify-3.7.1.tgz -> npmpkg-duplexify-3.7.1.tgz
https://registry.npmjs.org/ecc-jsbn/-/ecc-jsbn-0.1.2.tgz -> npmpkg-ecc-jsbn-0.1.2.tgz
https://registry.npmjs.org/ejs/-/ejs-3.1.9.tgz -> npmpkg-ejs-3.1.9.tgz
https://registry.npmjs.org/electron/-/electron-13.6.9.tgz -> npmpkg-electron-13.6.9.tgz
https://registry.npmjs.org/electron-builder/-/electron-builder-22.14.13.tgz -> npmpkg-electron-builder-22.14.13.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz -> npmpkg-universalify-2.0.0.tgz
https://registry.npmjs.org/electron-context-menu/-/electron-context-menu-3.1.0.tgz -> npmpkg-electron-context-menu-3.1.0.tgz
https://registry.npmjs.org/electron-dl/-/electron-dl-3.2.1.tgz -> npmpkg-electron-dl-3.2.1.tgz
https://registry.npmjs.org/electron-is-accelerator/-/electron-is-accelerator-0.1.2.tgz -> npmpkg-electron-is-accelerator-0.1.2.tgz
https://registry.npmjs.org/electron-is-dev/-/electron-is-dev-2.0.0.tgz -> npmpkg-electron-is-dev-2.0.0.tgz
https://registry.npmjs.org/electron-json-storage-sync/-/electron-json-storage-sync-1.1.1.tgz -> npmpkg-electron-json-storage-sync-1.1.1.tgz
https://registry.npmjs.org/electron-localshortcut/-/electron-localshortcut-3.2.1.tgz -> npmpkg-electron-localshortcut-3.2.1.tgz
https://registry.npmjs.org/debug/-/debug-4.1.1.tgz -> npmpkg-debug-4.1.1.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/electron-osx-sign/-/electron-osx-sign-0.5.0.tgz -> npmpkg-electron-osx-sign-0.5.0.tgz
https://registry.npmjs.org/isbinaryfile/-/isbinaryfile-3.0.3.tgz -> npmpkg-isbinaryfile-3.0.3.tgz
https://registry.npmjs.org/electron-publish/-/electron-publish-22.14.13.tgz -> npmpkg-electron-publish-22.14.13.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz -> npmpkg-universalify-2.0.0.tgz
https://registry.npmjs.org/electron-updater/-/electron-updater-4.3.1.tgz -> npmpkg-electron-updater-4.3.1.tgz
https://registry.npmjs.org/builder-util-runtime/-/builder-util-runtime-8.7.0.tgz -> npmpkg-builder-util-runtime-8.7.0.tgz
https://registry.npmjs.org/debug/-/debug-4.1.1.tgz -> npmpkg-debug-4.1.1.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-9.0.1.tgz -> npmpkg-fs-extra-9.0.1.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.0.1.tgz -> npmpkg-jsonfile-6.0.1.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/universalify/-/universalify-1.0.0.tgz -> npmpkg-universalify-1.0.0.tgz
https://registry.npmjs.org/electron-window-state/-/electron-window-state-5.0.3.tgz -> npmpkg-electron-window-state-5.0.3.tgz
https://registry.npmjs.org/elliptic/-/elliptic-6.5.4.tgz -> npmpkg-elliptic-6.5.4.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.0.tgz -> npmpkg-bn.js-4.12.0.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
https://registry.npmjs.org/emojis-list/-/emojis-list-3.0.0.tgz -> npmpkg-emojis-list-3.0.0.tgz
https://registry.npmjs.org/encodeurl/-/encodeurl-1.0.2.tgz -> npmpkg-encodeurl-1.0.2.tgz
https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.4.4.tgz -> npmpkg-end-of-stream-1.4.4.tgz
https://registry.npmjs.org/enhanced-resolve/-/enhanced-resolve-4.5.0.tgz -> npmpkg-enhanced-resolve-4.5.0.tgz
https://registry.npmjs.org/memory-fs/-/memory-fs-0.5.0.tgz -> npmpkg-memory-fs-0.5.0.tgz
https://registry.npmjs.org/enquirer/-/enquirer-2.3.6.tgz -> npmpkg-enquirer-2.3.6.tgz
https://registry.npmjs.org/entities/-/entities-2.1.0.tgz -> npmpkg-entities-2.1.0.tgz
https://registry.npmjs.org/env-paths/-/env-paths-2.2.0.tgz -> npmpkg-env-paths-2.2.0.tgz
https://registry.npmjs.org/errno/-/errno-0.1.8.tgz -> npmpkg-errno-0.1.8.tgz
https://registry.npmjs.org/error-ex/-/error-ex-1.3.2.tgz -> npmpkg-error-ex-1.3.2.tgz
https://registry.npmjs.org/es-abstract/-/es-abstract-1.17.5.tgz -> npmpkg-es-abstract-1.17.5.tgz
https://registry.npmjs.org/es-to-primitive/-/es-to-primitive-1.2.1.tgz -> npmpkg-es-to-primitive-1.2.1.tgz
https://registry.npmjs.org/es6-error/-/es6-error-4.1.1.tgz -> npmpkg-es6-error-4.1.1.tgz
https://registry.npmjs.org/escalade/-/escalade-3.1.1.tgz -> npmpkg-escalade-3.1.1.tgz
https://registry.npmjs.org/escape-goat/-/escape-goat-2.1.1.tgz -> npmpkg-escape-goat-2.1.1.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/escodegen/-/escodegen-2.0.0.tgz -> npmpkg-escodegen-2.0.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-5.2.0.tgz -> npmpkg-estraverse-5.2.0.tgz
https://registry.npmjs.org/levn/-/levn-0.3.0.tgz -> npmpkg-levn-0.3.0.tgz
https://registry.npmjs.org/optionator/-/optionator-0.8.3.tgz -> npmpkg-optionator-0.8.3.tgz
https://registry.npmjs.org/prelude-ls/-/prelude-ls-1.1.2.tgz -> npmpkg-prelude-ls-1.1.2.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/type-check/-/type-check-0.3.2.tgz -> npmpkg-type-check-0.3.2.tgz
https://registry.npmjs.org/eslint/-/eslint-7.28.0.tgz -> npmpkg-eslint-7.28.0.tgz
https://registry.npmjs.org/eslint-config-standard/-/eslint-config-standard-16.0.3.tgz -> npmpkg-eslint-config-standard-16.0.3.tgz
https://registry.npmjs.org/eslint-import-resolver-node/-/eslint-import-resolver-node-0.3.3.tgz -> npmpkg-eslint-import-resolver-node-0.3.3.tgz
https://registry.npmjs.org/eslint-module-utils/-/eslint-module-utils-2.6.0.tgz -> npmpkg-eslint-module-utils-2.6.0.tgz
https://registry.npmjs.org/eslint-plugin-es/-/eslint-plugin-es-3.0.1.tgz -> npmpkg-eslint-plugin-es-3.0.1.tgz
https://registry.npmjs.org/eslint-plugin-import/-/eslint-plugin-import-2.20.2.tgz -> npmpkg-eslint-plugin-import-2.20.2.tgz
https://registry.npmjs.org/doctrine/-/doctrine-1.5.0.tgz -> npmpkg-doctrine-1.5.0.tgz
https://registry.npmjs.org/eslint-plugin-node/-/eslint-plugin-node-11.1.0.tgz -> npmpkg-eslint-plugin-node-11.1.0.tgz
https://registry.npmjs.org/ignore/-/ignore-5.1.8.tgz -> npmpkg-ignore-5.1.8.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/eslint-plugin-promise/-/eslint-plugin-promise-5.1.0.tgz -> npmpkg-eslint-plugin-promise-5.1.0.tgz
https://registry.npmjs.org/eslint-plugin-react/-/eslint-plugin-react-7.20.0.tgz -> npmpkg-eslint-plugin-react-7.20.0.tgz
https://registry.npmjs.org/doctrine/-/doctrine-2.1.0.tgz -> npmpkg-doctrine-2.1.0.tgz
https://registry.npmjs.org/eslint-plugin-standard/-/eslint-plugin-standard-5.0.0.tgz -> npmpkg-eslint-plugin-standard-5.0.0.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-5.1.1.tgz -> npmpkg-eslint-scope-5.1.1.tgz
https://registry.npmjs.org/eslint-utils/-/eslint-utils-2.1.0.tgz -> npmpkg-eslint-utils-2.1.0.tgz
https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-1.3.0.tgz -> npmpkg-eslint-visitor-keys-1.3.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.2.1.tgz -> npmpkg-ansi-styles-4.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-4.0.0.tgz -> npmpkg-chalk-4.0.0.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/debug/-/debug-4.1.1.tgz -> npmpkg-debug-4.1.1.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz -> npmpkg-escape-string-regexp-4.0.0.tgz
https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-2.1.0.tgz -> npmpkg-eslint-visitor-keys-2.1.0.tgz
https://registry.npmjs.org/globals/-/globals-13.9.0.tgz -> npmpkg-globals-13.9.0.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.0.tgz -> npmpkg-strip-ansi-6.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.1.0.tgz -> npmpkg-supports-color-7.1.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.20.2.tgz -> npmpkg-type-fest-0.20.2.tgz
https://registry.npmjs.org/espree/-/espree-7.3.1.tgz -> npmpkg-espree-7.3.1.tgz
https://registry.npmjs.org/esprima/-/esprima-4.0.1.tgz -> npmpkg-esprima-4.0.1.tgz
https://registry.npmjs.org/esquery/-/esquery-1.4.0.tgz -> npmpkg-esquery-1.4.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-5.1.0.tgz -> npmpkg-estraverse-5.1.0.tgz
https://registry.npmjs.org/esrecurse/-/esrecurse-4.3.0.tgz -> npmpkg-esrecurse-4.3.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-5.2.0.tgz -> npmpkg-estraverse-5.2.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-4.3.0.tgz -> npmpkg-estraverse-4.3.0.tgz
https://registry.npmjs.org/esutils/-/esutils-2.0.3.tgz -> npmpkg-esutils-2.0.3.tgz
https://registry.npmjs.org/events/-/events-3.3.0.tgz -> npmpkg-events-3.3.0.tgz
https://registry.npmjs.org/evp_bytestokey/-/evp_bytestokey-1.0.3.tgz -> npmpkg-evp_bytestokey-1.0.3.tgz
https://registry.npmjs.org/expand-brackets/-/expand-brackets-2.1.4.tgz -> npmpkg-expand-brackets-2.1.4.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz -> npmpkg-is-accessor-descriptor-0.1.6.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz -> npmpkg-is-data-descriptor-0.1.4.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.6.tgz -> npmpkg-is-descriptor-0.1.6.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/kind-of/-/kind-of-5.1.0.tgz -> npmpkg-kind-of-5.1.0.tgz
https://registry.npmjs.org/expand-tilde/-/expand-tilde-2.0.2.tgz -> npmpkg-expand-tilde-2.0.2.tgz
https://registry.npmjs.org/ext-list/-/ext-list-2.2.2.tgz -> npmpkg-ext-list-2.2.2.tgz
https://registry.npmjs.org/ext-name/-/ext-name-5.0.0.tgz -> npmpkg-ext-name-5.0.0.tgz
https://registry.npmjs.org/extend/-/extend-3.0.2.tgz -> npmpkg-extend-3.0.2.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-3.0.2.tgz -> npmpkg-extend-shallow-3.0.2.tgz
https://registry.npmjs.org/extglob/-/extglob-2.0.4.tgz -> npmpkg-extglob-2.0.4.tgz
https://registry.npmjs.org/define-property/-/define-property-1.0.0.tgz -> npmpkg-define-property-1.0.0.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/extract-zip/-/extract-zip-1.7.0.tgz -> npmpkg-extract-zip-1.7.0.tgz
https://registry.npmjs.org/extsprintf/-/extsprintf-1.3.0.tgz -> npmpkg-extsprintf-1.3.0.tgz
https://registry.npmjs.org/eyes/-/eyes-0.1.8.tgz -> npmpkg-eyes-0.1.8.tgz
https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz -> npmpkg-fast-deep-equal-3.1.3.tgz
https://registry.npmjs.org/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz -> npmpkg-fast-json-stable-stringify-2.1.0.tgz
https://registry.npmjs.org/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz -> npmpkg-fast-levenshtein-2.0.6.tgz
https://registry.npmjs.org/fd-slicer/-/fd-slicer-1.1.0.tgz -> npmpkg-fd-slicer-1.1.0.tgz
https://registry.npmjs.org/figgy-pudding/-/figgy-pudding-3.5.2.tgz -> npmpkg-figgy-pudding-3.5.2.tgz
https://registry.npmjs.org/file-entry-cache/-/file-entry-cache-6.0.1.tgz -> npmpkg-file-entry-cache-6.0.1.tgz
https://registry.npmjs.org/file-loader/-/file-loader-6.0.0.tgz -> npmpkg-file-loader-6.0.0.tgz
https://registry.npmjs.org/json5/-/json5-2.2.3.tgz -> npmpkg-json5-2.2.3.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-2.0.4.tgz -> npmpkg-loader-utils-2.0.4.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-2.7.0.tgz -> npmpkg-schema-utils-2.7.0.tgz
https://registry.npmjs.org/file-uri-to-path/-/file-uri-to-path-2.0.0.tgz -> npmpkg-file-uri-to-path-2.0.0.tgz
https://registry.npmjs.org/filelist/-/filelist-1.0.4.tgz -> npmpkg-filelist-1.0.4.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz -> npmpkg-brace-expansion-2.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-5.1.6.tgz -> npmpkg-minimatch-5.1.6.tgz
https://registry.npmjs.org/filename-reserved-regex/-/filename-reserved-regex-2.0.0.tgz -> npmpkg-filename-reserved-regex-2.0.0.tgz
https://registry.npmjs.org/fill-range/-/fill-range-4.0.0.tgz -> npmpkg-fill-range-4.0.0.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/find-cache-dir/-/find-cache-dir-1.0.0.tgz -> npmpkg-find-cache-dir-1.0.0.tgz
https://registry.npmjs.org/find-up/-/find-up-2.1.0.tgz -> npmpkg-find-up-2.1.0.tgz
https://registry.npmjs.org/findup-sync/-/findup-sync-3.0.0.tgz -> npmpkg-findup-sync-3.0.0.tgz
https://registry.npmjs.org/flat-cache/-/flat-cache-3.0.4.tgz -> npmpkg-flat-cache-3.0.4.tgz
https://registry.npmjs.org/rimraf/-/rimraf-3.0.2.tgz -> npmpkg-rimraf-3.0.2.tgz
https://registry.npmjs.org/flatted/-/flatted-3.1.1.tgz -> npmpkg-flatted-3.1.1.tgz
https://registry.npmjs.org/flush-write-stream/-/flush-write-stream-1.1.1.tgz -> npmpkg-flush-write-stream-1.1.1.tgz
https://registry.npmjs.org/for-in/-/for-in-1.0.2.tgz -> npmpkg-for-in-1.0.2.tgz
https://registry.npmjs.org/forever-agent/-/forever-agent-0.6.1.tgz -> npmpkg-forever-agent-0.6.1.tgz
https://registry.npmjs.org/form-data/-/form-data-3.0.1.tgz -> npmpkg-form-data-3.0.1.tgz
https://registry.npmjs.org/fragment-cache/-/fragment-cache-0.2.1.tgz -> npmpkg-fragment-cache-0.2.1.tgz
https://registry.npmjs.org/from2/-/from2-2.3.0.tgz -> npmpkg-from2-2.3.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz -> npmpkg-fs-extra-8.1.0.tgz
https://registry.npmjs.org/fs-write-stream-atomic/-/fs-write-stream-atomic-1.0.10.tgz -> npmpkg-fs-write-stream-atomic-1.0.10.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz -> npmpkg-fs.realpath-1.0.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.2.tgz -> npmpkg-fsevents-2.3.2.tgz
https://registry.npmjs.org/fstream/-/fstream-1.0.12.tgz -> npmpkg-fstream-1.0.12.tgz
https://registry.npmjs.org/ftp/-/ftp-0.3.10.tgz -> npmpkg-ftp-0.3.10.tgz
https://registry.npmjs.org/isarray/-/isarray-0.0.1.tgz -> npmpkg-isarray-0.0.1.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-1.1.14.tgz -> npmpkg-readable-stream-1.1.14.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-0.10.31.tgz -> npmpkg-string_decoder-0.10.31.tgz
https://registry.npmjs.org/xregexp/-/xregexp-2.0.0.tgz -> npmpkg-xregexp-2.0.0.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.1.tgz -> npmpkg-function-bind-1.1.1.tgz
https://registry.npmjs.org/functional-red-black-tree/-/functional-red-black-tree-1.0.1.tgz -> npmpkg-functional-red-black-tree-1.0.1.tgz
https://registry.npmjs.org/fuse.js/-/fuse.js-3.6.1.tgz -> npmpkg-fuse.js-3.6.1.tgz
https://registry.npmjs.org/gauge/-/gauge-2.7.4.tgz -> npmpkg-gauge-2.7.4.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-1.0.0.tgz -> npmpkg-is-fullwidth-code-point-1.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-1.0.2.tgz -> npmpkg-string-width-1.0.2.tgz
https://registry.npmjs.org/gaze/-/gaze-1.1.3.tgz -> npmpkg-gaze-1.1.3.tgz
https://registry.npmjs.org/get-caller-file/-/get-caller-file-2.0.5.tgz -> npmpkg-get-caller-file-2.0.5.tgz
https://registry.npmjs.org/get-stdin/-/get-stdin-4.0.1.tgz -> npmpkg-get-stdin-4.0.1.tgz
https://registry.npmjs.org/get-stream/-/get-stream-4.1.0.tgz -> npmpkg-get-stream-4.1.0.tgz
https://registry.npmjs.org/get-uri/-/get-uri-3.0.2.tgz -> npmpkg-get-uri-3.0.2.tgz
https://registry.npmjs.org/debug/-/debug-4.1.1.tgz -> npmpkg-debug-4.1.1.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/get-value/-/get-value-2.0.6.tgz -> npmpkg-get-value-2.0.6.tgz
https://registry.npmjs.org/getpass/-/getpass-0.1.7.tgz -> npmpkg-getpass-0.1.7.tgz
https://registry.npmjs.org/glob/-/glob-7.1.6.tgz -> npmpkg-glob-7.1.6.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/global-agent/-/global-agent-3.0.0.tgz -> npmpkg-global-agent-3.0.0.tgz
https://registry.npmjs.org/global-dirs/-/global-dirs-3.0.1.tgz -> npmpkg-global-dirs-3.0.1.tgz
https://registry.npmjs.org/global-modules/-/global-modules-2.0.0.tgz -> npmpkg-global-modules-2.0.0.tgz
https://registry.npmjs.org/global-prefix/-/global-prefix-3.0.0.tgz -> npmpkg-global-prefix-3.0.0.tgz
https://registry.npmjs.org/ini/-/ini-1.3.8.tgz -> npmpkg-ini-1.3.8.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/global-tunnel-ng/-/global-tunnel-ng-2.7.1.tgz -> npmpkg-global-tunnel-ng-2.7.1.tgz
https://registry.npmjs.org/globals/-/globals-11.12.0.tgz -> npmpkg-globals-11.12.0.tgz
https://registry.npmjs.org/globalthis/-/globalthis-1.0.3.tgz -> npmpkg-globalthis-1.0.3.tgz
https://registry.npmjs.org/globule/-/globule-1.3.1.tgz -> npmpkg-globule-1.3.1.tgz
https://registry.npmjs.org/got/-/got-9.6.0.tgz -> npmpkg-got-9.6.0.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.4.tgz -> npmpkg-graceful-fs-4.2.4.tgz
https://registry.npmjs.org/graceful-readlink/-/graceful-readlink-1.0.1.tgz -> npmpkg-graceful-readlink-1.0.1.tgz
https://registry.npmjs.org/har-schema/-/har-schema-2.0.0.tgz -> npmpkg-har-schema-2.0.0.tgz
https://registry.npmjs.org/har-validator/-/har-validator-5.1.3.tgz -> npmpkg-har-validator-5.1.3.tgz
https://registry.npmjs.org/has/-/has-1.0.3.tgz -> npmpkg-has-1.0.3.tgz
https://registry.npmjs.org/has-ansi/-/has-ansi-2.0.0.tgz -> npmpkg-has-ansi-2.0.0.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.0.1.tgz -> npmpkg-has-symbols-1.0.1.tgz
https://registry.npmjs.org/has-unicode/-/has-unicode-2.0.1.tgz -> npmpkg-has-unicode-2.0.1.tgz
https://registry.npmjs.org/has-value/-/has-value-1.0.0.tgz -> npmpkg-has-value-1.0.0.tgz
https://registry.npmjs.org/has-values/-/has-values-1.0.0.tgz -> npmpkg-has-values-1.0.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-4.0.0.tgz -> npmpkg-kind-of-4.0.0.tgz
https://registry.npmjs.org/has-yarn/-/has-yarn-2.1.0.tgz -> npmpkg-has-yarn-2.1.0.tgz
https://registry.npmjs.org/hash-base/-/hash-base-3.1.0.tgz -> npmpkg-hash-base-3.1.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.0.tgz -> npmpkg-readable-stream-3.6.0.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz -> npmpkg-safe-buffer-5.2.1.tgz
https://registry.npmjs.org/hash.js/-/hash.js-1.1.7.tgz -> npmpkg-hash.js-1.1.7.tgz
https://registry.npmjs.org/he/-/he-1.2.0.tgz -> npmpkg-he-1.2.0.tgz
https://registry.npmjs.org/highlight.js/-/highlight.js-11.0.1.tgz -> npmpkg-highlight.js-11.0.1.tgz
https://registry.npmjs.org/highlightjs-graphql/-/highlightjs-graphql-1.0.2.tgz -> npmpkg-highlightjs-graphql-1.0.2.tgz
https://registry.npmjs.org/highlightjs-solidity/-/highlightjs-solidity-1.0.16.tgz -> npmpkg-highlightjs-solidity-1.0.16.tgz
https://registry.npmjs.org/hmac-drbg/-/hmac-drbg-1.0.1.tgz -> npmpkg-hmac-drbg-1.0.1.tgz
https://registry.npmjs.org/hoist-non-react-statics/-/hoist-non-react-statics-3.3.2.tgz -> npmpkg-hoist-non-react-statics-3.3.2.tgz
https://registry.npmjs.org/home-or-tmp/-/home-or-tmp-2.0.0.tgz -> npmpkg-home-or-tmp-2.0.0.tgz
https://registry.npmjs.org/homedir-polyfill/-/homedir-polyfill-1.0.3.tgz -> npmpkg-homedir-polyfill-1.0.3.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-4.1.0.tgz -> npmpkg-hosted-git-info-4.1.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/html-encoding-sniffer/-/html-encoding-sniffer-2.0.1.tgz -> npmpkg-html-encoding-sniffer-2.0.1.tgz
https://registry.npmjs.org/html-loader/-/html-loader-2.1.2.tgz -> npmpkg-html-loader-2.1.2.tgz
https://registry.npmjs.org/html-minifier-terser/-/html-minifier-terser-5.1.1.tgz -> npmpkg-html-minifier-terser-5.1.1.tgz
https://registry.npmjs.org/http-cache-semantics/-/http-cache-semantics-4.1.1.tgz -> npmpkg-http-cache-semantics-4.1.1.tgz
https://registry.npmjs.org/http-errors/-/http-errors-1.7.3.tgz -> npmpkg-http-errors-1.7.3.tgz
https://registry.npmjs.org/http-proxy-agent/-/http-proxy-agent-4.0.1.tgz -> npmpkg-http-proxy-agent-4.0.1.tgz
https://registry.npmjs.org/debug/-/debug-4.1.1.tgz -> npmpkg-debug-4.1.1.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/http-signature/-/http-signature-1.2.0.tgz -> npmpkg-http-signature-1.2.0.tgz
https://registry.npmjs.org/https-browserify/-/https-browserify-1.0.0.tgz -> npmpkg-https-browserify-1.0.0.tgz
https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-5.0.0.tgz -> npmpkg-https-proxy-agent-5.0.0.tgz
https://registry.npmjs.org/debug/-/debug-4.1.1.tgz -> npmpkg-debug-4.1.1.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/human-readable-time/-/human-readable-time-0.3.0.tgz -> npmpkg-human-readable-time-0.3.0.tgz
https://registry.npmjs.org/iconv-corefoundation/-/iconv-corefoundation-1.1.7.tgz -> npmpkg-iconv-corefoundation-1.1.7.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.6.3.tgz -> npmpkg-iconv-lite-0.6.3.tgz
https://registry.npmjs.org/icss-utils/-/icss-utils-5.1.0.tgz -> npmpkg-icss-utils-5.1.0.tgz
https://registry.npmjs.org/ieee754/-/ieee754-1.2.1.tgz -> npmpkg-ieee754-1.2.1.tgz
https://registry.npmjs.org/iferr/-/iferr-0.1.5.tgz -> npmpkg-iferr-0.1.5.tgz
https://registry.npmjs.org/ignore/-/ignore-4.0.6.tgz -> npmpkg-ignore-4.0.6.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-3.2.1.tgz -> npmpkg-import-fresh-3.2.1.tgz
https://registry.npmjs.org/import-lazy/-/import-lazy-2.1.0.tgz -> npmpkg-import-lazy-2.1.0.tgz
https://registry.npmjs.org/import-local/-/import-local-2.0.0.tgz -> npmpkg-import-local-2.0.0.tgz
https://registry.npmjs.org/find-up/-/find-up-3.0.0.tgz -> npmpkg-find-up-3.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-3.0.0.tgz -> npmpkg-locate-path-3.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-3.0.0.tgz -> npmpkg-p-locate-3.0.0.tgz
https://registry.npmjs.org/p-try/-/p-try-2.2.0.tgz -> npmpkg-p-try-2.2.0.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-3.0.0.tgz -> npmpkg-pkg-dir-3.0.0.tgz
https://registry.npmjs.org/imurmurhash/-/imurmurhash-0.1.4.tgz -> npmpkg-imurmurhash-0.1.4.tgz
https://registry.npmjs.org/in-publish/-/in-publish-2.0.1.tgz -> npmpkg-in-publish-2.0.1.tgz
https://registry.npmjs.org/indent-string/-/indent-string-2.1.0.tgz -> npmpkg-indent-string-2.1.0.tgz
https://registry.npmjs.org/infer-owner/-/infer-owner-1.0.4.tgz -> npmpkg-infer-owner-1.0.4.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz -> npmpkg-inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz -> npmpkg-inherits-2.0.4.tgz
https://registry.npmjs.org/ini/-/ini-2.0.0.tgz -> npmpkg-ini-2.0.0.tgz
https://registry.npmjs.org/internal-slot/-/internal-slot-1.0.2.tgz -> npmpkg-internal-slot-1.0.2.tgz
https://registry.npmjs.org/interpret/-/interpret-1.4.0.tgz -> npmpkg-interpret-1.4.0.tgz
https://registry.npmjs.org/invariant/-/invariant-2.2.4.tgz -> npmpkg-invariant-2.2.4.tgz
https://registry.npmjs.org/ip/-/ip-1.1.5.tgz -> npmpkg-ip-1.1.5.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-1.0.0.tgz -> npmpkg-is-accessor-descriptor-1.0.0.tgz
https://registry.npmjs.org/is-arrayish/-/is-arrayish-0.2.1.tgz -> npmpkg-is-arrayish-0.2.1.tgz
https://registry.npmjs.org/is-binary-path/-/is-binary-path-2.1.0.tgz -> npmpkg-is-binary-path-2.1.0.tgz
https://registry.npmjs.org/is-buffer/-/is-buffer-1.1.6.tgz -> npmpkg-is-buffer-1.1.6.tgz
https://registry.npmjs.org/is-callable/-/is-callable-1.2.0.tgz -> npmpkg-is-callable-1.2.0.tgz
https://registry.npmjs.org/is-ci/-/is-ci-3.0.1.tgz -> npmpkg-is-ci-3.0.1.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-1.0.0.tgz -> npmpkg-is-data-descriptor-1.0.0.tgz
https://registry.npmjs.org/is-date-object/-/is-date-object-1.0.2.tgz -> npmpkg-is-date-object-1.0.2.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-1.0.2.tgz -> npmpkg-is-descriptor-1.0.2.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-1.0.1.tgz -> npmpkg-is-extendable-1.0.1.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz -> npmpkg-is-extglob-2.1.1.tgz
https://registry.npmjs.org/is-finite/-/is-finite-1.1.0.tgz -> npmpkg-is-finite-1.1.0.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> npmpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.1.tgz -> npmpkg-is-glob-4.0.1.tgz
https://registry.npmjs.org/is-installed-globally/-/is-installed-globally-0.4.0.tgz -> npmpkg-is-installed-globally-0.4.0.tgz
https://registry.npmjs.org/is-npm/-/is-npm-5.0.0.tgz -> npmpkg-is-npm-5.0.0.tgz
https://registry.npmjs.org/is-number/-/is-number-3.0.0.tgz -> npmpkg-is-number-3.0.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/is-obj/-/is-obj-2.0.0.tgz -> npmpkg-is-obj-2.0.0.tgz
https://registry.npmjs.org/is-path-inside/-/is-path-inside-3.0.3.tgz -> npmpkg-is-path-inside-3.0.3.tgz
https://registry.npmjs.org/is-plain-obj/-/is-plain-obj-1.1.0.tgz -> npmpkg-is-plain-obj-1.1.0.tgz
https://registry.npmjs.org/is-plain-object/-/is-plain-object-2.0.4.tgz -> npmpkg-is-plain-object-2.0.4.tgz
https://registry.npmjs.org/is-potential-custom-element-name/-/is-potential-custom-element-name-1.0.1.tgz -> npmpkg-is-potential-custom-element-name-1.0.1.tgz
https://registry.npmjs.org/is-promise/-/is-promise-2.2.2.tgz -> npmpkg-is-promise-2.2.2.tgz
https://registry.npmjs.org/is-regex/-/is-regex-1.1.0.tgz -> npmpkg-is-regex-1.1.0.tgz
https://registry.npmjs.org/is-string/-/is-string-1.0.5.tgz -> npmpkg-is-string-1.0.5.tgz
https://registry.npmjs.org/is-symbol/-/is-symbol-1.0.3.tgz -> npmpkg-is-symbol-1.0.3.tgz
https://registry.npmjs.org/is-typedarray/-/is-typedarray-1.0.0.tgz -> npmpkg-is-typedarray-1.0.0.tgz
https://registry.npmjs.org/is-utf8/-/is-utf8-0.2.1.tgz -> npmpkg-is-utf8-0.2.1.tgz
https://registry.npmjs.org/is-windows/-/is-windows-1.0.2.tgz -> npmpkg-is-windows-1.0.2.tgz
https://registry.npmjs.org/is-wsl/-/is-wsl-1.1.0.tgz -> npmpkg-is-wsl-1.1.0.tgz
https://registry.npmjs.org/is-yarn-global/-/is-yarn-global-0.3.0.tgz -> npmpkg-is-yarn-global-0.3.0.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/isbinaryfile/-/isbinaryfile-4.0.10.tgz -> npmpkg-isbinaryfile-4.0.10.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz -> npmpkg-isexe-2.0.0.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/isstream/-/isstream-0.1.2.tgz -> npmpkg-isstream-0.1.2.tgz
https://registry.npmjs.org/jake/-/jake-10.8.5.tgz -> npmpkg-jake-10.8.5.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/js-base64/-/js-base64-2.5.2.tgz -> npmpkg-js-base64-2.5.2.tgz
https://registry.npmjs.org/js-tokens/-/js-tokens-3.0.2.tgz -> npmpkg-js-tokens-3.0.2.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-3.14.0.tgz -> npmpkg-js-yaml-3.14.0.tgz
https://registry.npmjs.org/jsbn/-/jsbn-0.1.1.tgz -> npmpkg-jsbn-0.1.1.tgz
https://registry.npmjs.org/jsdom/-/jsdom-16.6.0.tgz -> npmpkg-jsdom-16.6.0.tgz
https://registry.npmjs.org/acorn/-/acorn-8.4.0.tgz -> npmpkg-acorn-8.4.0.tgz
https://registry.npmjs.org/jsesc/-/jsesc-2.5.2.tgz -> npmpkg-jsesc-2.5.2.tgz
https://registry.npmjs.org/json-buffer/-/json-buffer-3.0.0.tgz -> npmpkg-json-buffer-3.0.0.tgz
https://registry.npmjs.org/json-loader/-/json-loader-0.5.7.tgz -> npmpkg-json-loader-0.5.7.tgz
https://registry.npmjs.org/json-parse-better-errors/-/json-parse-better-errors-1.0.2.tgz -> npmpkg-json-parse-better-errors-1.0.2.tgz
https://registry.npmjs.org/json-schema/-/json-schema-0.4.0.tgz -> npmpkg-json-schema-0.4.0.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz -> npmpkg-json-schema-traverse-0.4.1.tgz
https://registry.npmjs.org/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz -> npmpkg-json-stable-stringify-without-jsonify-1.0.1.tgz
https://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz -> npmpkg-json-stringify-safe-5.0.1.tgz
https://registry.npmjs.org/json5/-/json5-0.5.1.tgz -> npmpkg-json5-0.5.1.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-4.0.0.tgz -> npmpkg-jsonfile-4.0.0.tgz
https://registry.npmjs.org/jsprim/-/jsprim-1.4.2.tgz -> npmpkg-jsprim-1.4.2.tgz
https://registry.npmjs.org/jsx-ast-utils/-/jsx-ast-utils-2.3.0.tgz -> npmpkg-jsx-ast-utils-2.3.0.tgz
https://registry.npmjs.org/katex/-/katex-0.6.0.tgz -> npmpkg-katex-0.6.0.tgz
https://registry.npmjs.org/keyboardevent-from-electron-accelerator/-/keyboardevent-from-electron-accelerator-2.0.0.tgz -> npmpkg-keyboardevent-from-electron-accelerator-2.0.0.tgz
https://registry.npmjs.org/keyboardevents-areequal/-/keyboardevents-areequal-0.2.2.tgz -> npmpkg-keyboardevents-areequal-0.2.2.tgz
https://registry.npmjs.org/keycode/-/keycode-2.2.0.tgz -> npmpkg-keycode-2.2.0.tgz
https://registry.npmjs.org/keyv/-/keyv-3.1.0.tgz -> npmpkg-keyv-3.1.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/latest-version/-/latest-version-5.1.0.tgz -> npmpkg-latest-version-5.1.0.tgz
https://registry.npmjs.org/lazy-val/-/lazy-val-1.0.5.tgz -> npmpkg-lazy-val-1.0.5.tgz
https://registry.npmjs.org/levn/-/levn-0.4.1.tgz -> npmpkg-levn-0.4.1.tgz
https://registry.npmjs.org/license-checker/-/license-checker-25.0.1.tgz -> npmpkg-license-checker-25.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/debug/-/debug-3.2.6.tgz -> npmpkg-debug-3.2.6.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/semver/-/semver-5.7.1.tgz -> npmpkg-semver-5.7.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/linkify-it/-/linkify-it-3.0.2.tgz -> npmpkg-linkify-it-3.0.2.tgz
https://registry.npmjs.org/load-json-file/-/load-json-file-2.0.0.tgz -> npmpkg-load-json-file-2.0.0.tgz
https://registry.npmjs.org/pify/-/pify-2.3.0.tgz -> npmpkg-pify-2.3.0.tgz
https://registry.npmjs.org/loader-runner/-/loader-runner-2.4.0.tgz -> npmpkg-loader-runner-2.4.0.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/locate-path/-/locate-path-2.0.0.tgz -> npmpkg-locate-path-2.0.0.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/lodash.clonedeep/-/lodash.clonedeep-4.5.0.tgz -> npmpkg-lodash.clonedeep-4.5.0.tgz
https://registry.npmjs.org/lodash.debounce/-/lodash.debounce-4.0.8.tgz -> npmpkg-lodash.debounce-4.0.8.tgz
https://registry.npmjs.org/lodash.isequal/-/lodash.isequal-4.5.0.tgz -> npmpkg-lodash.isequal-4.5.0.tgz
https://registry.npmjs.org/lodash.merge/-/lodash.merge-4.6.2.tgz -> npmpkg-lodash.merge-4.6.2.tgz
https://registry.npmjs.org/lodash.truncate/-/lodash.truncate-4.4.2.tgz -> npmpkg-lodash.truncate-4.4.2.tgz
https://registry.npmjs.org/loose-envify/-/loose-envify-1.4.0.tgz -> npmpkg-loose-envify-1.4.0.tgz
https://registry.npmjs.org/loud-rejection/-/loud-rejection-1.6.0.tgz -> npmpkg-loud-rejection-1.6.0.tgz
https://registry.npmjs.org/lower-case/-/lower-case-2.0.1.tgz -> npmpkg-lower-case-2.0.1.tgz
https://registry.npmjs.org/lowercase-keys/-/lowercase-keys-1.0.1.tgz -> npmpkg-lowercase-keys-1.0.1.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-5.1.1.tgz -> npmpkg-lru-cache-5.1.1.tgz
https://registry.npmjs.org/make-dir/-/make-dir-1.3.0.tgz -> npmpkg-make-dir-1.3.0.tgz
https://registry.npmjs.org/map-cache/-/map-cache-0.2.2.tgz -> npmpkg-map-cache-0.2.2.tgz
https://registry.npmjs.org/map-obj/-/map-obj-1.0.1.tgz -> npmpkg-map-obj-1.0.1.tgz
https://registry.npmjs.org/map-visit/-/map-visit-1.0.0.tgz -> npmpkg-map-visit-1.0.0.tgz
https://registry.npmjs.org/markdown-it/-/markdown-it-12.3.2.tgz -> npmpkg-markdown-it-12.3.2.tgz
https://registry.npmjs.org/markdown-it-katex/-/markdown-it-katex-2.0.3.tgz -> npmpkg-markdown-it-katex-2.0.3.tgz
https://registry.npmjs.org/markdown-it-task-lists/-/markdown-it-task-lists-2.1.1.tgz -> npmpkg-markdown-it-task-lists-2.1.1.tgz
https://registry.npmjs.org/argparse/-/argparse-2.0.1.tgz -> npmpkg-argparse-2.0.1.tgz
https://registry.npmjs.org/marked/-/marked-4.3.0.tgz -> npmpkg-marked-4.3.0.tgz
https://registry.npmjs.org/match-at/-/match-at-0.1.1.tgz -> npmpkg-match-at-0.1.1.tgz
https://registry.npmjs.org/matcher/-/matcher-3.0.0.tgz -> npmpkg-matcher-3.0.0.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz -> npmpkg-escape-string-regexp-4.0.0.tgz
https://registry.npmjs.org/md5.js/-/md5.js-1.3.5.tgz -> npmpkg-md5.js-1.3.5.tgz
https://registry.npmjs.org/mdurl/-/mdurl-1.0.1.tgz -> npmpkg-mdurl-1.0.1.tgz
https://registry.npmjs.org/memory-fs/-/memory-fs-0.4.1.tgz -> npmpkg-memory-fs-0.4.1.tgz
https://registry.npmjs.org/meow/-/meow-3.7.0.tgz -> npmpkg-meow-3.7.0.tgz
https://registry.npmjs.org/find-up/-/find-up-1.1.2.tgz -> npmpkg-find-up-1.1.2.tgz
https://registry.npmjs.org/load-json-file/-/load-json-file-1.1.0.tgz -> npmpkg-load-json-file-1.1.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-2.1.0.tgz -> npmpkg-path-exists-2.1.0.tgz
https://registry.npmjs.org/path-type/-/path-type-1.1.0.tgz -> npmpkg-path-type-1.1.0.tgz
https://registry.npmjs.org/pify/-/pify-2.3.0.tgz -> npmpkg-pify-2.3.0.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-1.1.0.tgz -> npmpkg-read-pkg-1.1.0.tgz
https://registry.npmjs.org/read-pkg-up/-/read-pkg-up-1.0.1.tgz -> npmpkg-read-pkg-up-1.0.1.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-2.0.0.tgz -> npmpkg-strip-bom-2.0.0.tgz
https://registry.npmjs.org/micromatch/-/micromatch-3.1.10.tgz -> npmpkg-micromatch-3.1.10.tgz
https://registry.npmjs.org/miller-rabin/-/miller-rabin-4.0.1.tgz -> npmpkg-miller-rabin-4.0.1.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.0.tgz -> npmpkg-bn.js-4.12.0.tgz
https://registry.npmjs.org/mime/-/mime-2.6.0.tgz -> npmpkg-mime-2.6.0.tgz
https://registry.npmjs.org/mime-db/-/mime-db-1.44.0.tgz -> npmpkg-mime-db-1.44.0.tgz
https://registry.npmjs.org/mime-types/-/mime-types-2.1.27.tgz -> npmpkg-mime-types-2.1.27.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-1.0.1.tgz -> npmpkg-mimic-response-1.0.1.tgz
https://registry.npmjs.org/minimalistic-assert/-/minimalistic-assert-1.0.1.tgz -> npmpkg-minimalistic-assert-1.0.1.tgz
https://registry.npmjs.org/minimalistic-crypto-utils/-/minimalistic-crypto-utils-1.0.1.tgz -> npmpkg-minimalistic-crypto-utils-1.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.0.4.tgz -> npmpkg-minimatch-3.0.4.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.8.tgz -> npmpkg-minimist-1.2.8.tgz
https://registry.npmjs.org/mississippi/-/mississippi-3.0.0.tgz -> npmpkg-mississippi-3.0.0.tgz
https://registry.npmjs.org/mixin-deep/-/mixin-deep-1.3.2.tgz -> npmpkg-mixin-deep-1.3.2.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.5.tgz -> npmpkg-mkdirp-0.5.5.tgz
https://registry.npmjs.org/modify-filename/-/modify-filename-1.1.0.tgz -> npmpkg-modify-filename-1.1.0.tgz
https://registry.npmjs.org/moment/-/moment-2.29.4.tgz -> npmpkg-moment-2.29.4.tgz
https://registry.npmjs.org/move-concurrently/-/move-concurrently-1.0.1.tgz -> npmpkg-move-concurrently-1.0.1.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/nan/-/nan-2.14.1.tgz -> npmpkg-nan-2.14.1.tgz
https://registry.npmjs.org/nanoid/-/nanoid-3.3.6.tgz -> npmpkg-nanoid-3.3.6.tgz
https://registry.npmjs.org/nanomatch/-/nanomatch-1.2.13.tgz -> npmpkg-nanomatch-1.2.13.tgz
https://registry.npmjs.org/natural-compare/-/natural-compare-1.4.0.tgz -> npmpkg-natural-compare-1.4.0.tgz
https://registry.npmjs.org/nconf/-/nconf-0.11.4.tgz -> npmpkg-nconf-0.11.4.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/async/-/async-1.5.2.tgz -> npmpkg-async-1.5.2.tgz
https://registry.npmjs.org/cliui/-/cliui-7.0.4.tgz -> npmpkg-cliui-7.0.4.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.0.tgz -> npmpkg-strip-ansi-6.0.0.tgz
https://registry.npmjs.org/y18n/-/y18n-5.0.8.tgz -> npmpkg-y18n-5.0.8.tgz
https://registry.npmjs.org/yargs/-/yargs-16.2.0.tgz -> npmpkg-yargs-16.2.0.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-20.2.7.tgz -> npmpkg-yargs-parser-20.2.7.tgz
https://registry.npmjs.org/neo-async/-/neo-async-2.6.2.tgz -> npmpkg-neo-async-2.6.2.tgz
https://registry.npmjs.org/netmask/-/netmask-2.0.2.tgz -> npmpkg-netmask-2.0.2.tgz
https://registry.npmjs.org/nice-try/-/nice-try-1.0.5.tgz -> npmpkg-nice-try-1.0.5.tgz
https://registry.npmjs.org/no-case/-/no-case-3.0.3.tgz -> npmpkg-no-case-3.0.3.tgz
https://registry.npmjs.org/node-addon-api/-/node-addon-api-1.7.2.tgz -> npmpkg-node-addon-api-1.7.2.tgz
https://registry.npmjs.org/node-gyp/-/node-gyp-3.8.0.tgz -> npmpkg-node-gyp-3.8.0.tgz
https://registry.npmjs.org/nopt/-/nopt-3.0.6.tgz -> npmpkg-nopt-3.0.6.tgz
https://registry.npmjs.org/semver/-/semver-5.3.0.tgz -> npmpkg-semver-5.3.0.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/node-libs-browser/-/node-libs-browser-2.2.1.tgz -> npmpkg-node-libs-browser-2.2.1.tgz
https://registry.npmjs.org/punycode/-/punycode-1.4.1.tgz -> npmpkg-punycode-1.4.1.tgz
https://registry.npmjs.org/node-sass/-/node-sass-4.14.1.tgz -> npmpkg-node-sass-4.14.1.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-3.0.1.tgz -> npmpkg-cross-spawn-3.0.1.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-4.1.5.tgz -> npmpkg-lru-cache-4.1.5.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/yallist/-/yallist-2.1.2.tgz -> npmpkg-yallist-2.1.2.tgz
https://registry.npmjs.org/nopt/-/nopt-4.0.3.tgz -> npmpkg-nopt-4.0.3.tgz
https://registry.npmjs.org/normalize-package-data/-/normalize-package-data-2.5.0.tgz -> npmpkg-normalize-package-data-2.5.0.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-2.8.9.tgz -> npmpkg-hosted-git-info-2.8.9.tgz
https://registry.npmjs.org/semver/-/semver-5.7.1.tgz -> npmpkg-semver-5.7.1.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz -> npmpkg-normalize-path-3.0.0.tgz
https://registry.npmjs.org/normalize-url/-/normalize-url-4.5.1.tgz -> npmpkg-normalize-url-4.5.1.tgz
https://registry.npmjs.org/notebookjs/-/notebookjs-0.6.7.tgz -> npmpkg-notebookjs-0.6.7.tgz
https://registry.npmjs.org/npm-conf/-/npm-conf-1.1.3.tgz -> npmpkg-npm-conf-1.1.3.tgz
https://registry.npmjs.org/npm-normalize-package-bin/-/npm-normalize-package-bin-1.0.1.tgz -> npmpkg-npm-normalize-package-bin-1.0.1.tgz
https://registry.npmjs.org/npmlog/-/npmlog-4.1.2.tgz -> npmpkg-npmlog-4.1.2.tgz
https://registry.npmjs.org/number-is-nan/-/number-is-nan-1.0.1.tgz -> npmpkg-number-is-nan-1.0.1.tgz
https://registry.npmjs.org/nwsapi/-/nwsapi-2.2.0.tgz -> npmpkg-nwsapi-2.2.0.tgz
https://registry.npmjs.org/oauth-sign/-/oauth-sign-0.9.0.tgz -> npmpkg-oauth-sign-0.9.0.tgz
https://registry.npmjs.org/object-assign/-/object-assign-4.1.1.tgz -> npmpkg-object-assign-4.1.1.tgz
https://registry.npmjs.org/object-copy/-/object-copy-0.1.0.tgz -> npmpkg-object-copy-0.1.0.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz -> npmpkg-is-accessor-descriptor-0.1.6.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz -> npmpkg-is-data-descriptor-0.1.4.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.6.tgz -> npmpkg-is-descriptor-0.1.6.tgz
https://registry.npmjs.org/kind-of/-/kind-of-5.1.0.tgz -> npmpkg-kind-of-5.1.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/object-inspect/-/object-inspect-1.7.0.tgz -> npmpkg-object-inspect-1.7.0.tgz
https://registry.npmjs.org/object-keys/-/object-keys-1.1.1.tgz -> npmpkg-object-keys-1.1.1.tgz
https://registry.npmjs.org/object-visit/-/object-visit-1.0.1.tgz -> npmpkg-object-visit-1.0.1.tgz
https://registry.npmjs.org/object.assign/-/object.assign-4.1.0.tgz -> npmpkg-object.assign-4.1.0.tgz
https://registry.npmjs.org/object.entries/-/object.entries-1.1.2.tgz -> npmpkg-object.entries-1.1.2.tgz
https://registry.npmjs.org/object.fromentries/-/object.fromentries-2.0.2.tgz -> npmpkg-object.fromentries-2.0.2.tgz
https://registry.npmjs.org/object.pick/-/object.pick-1.3.0.tgz -> npmpkg-object.pick-1.3.0.tgz
https://registry.npmjs.org/object.values/-/object.values-1.1.1.tgz -> npmpkg-object.values-1.1.1.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz -> npmpkg-once-1.4.0.tgz
https://registry.npmjs.org/optionator/-/optionator-0.9.1.tgz -> npmpkg-optionator-0.9.1.tgz
https://registry.npmjs.org/os-browserify/-/os-browserify-0.3.0.tgz -> npmpkg-os-browserify-0.3.0.tgz
https://registry.npmjs.org/os-homedir/-/os-homedir-1.0.2.tgz -> npmpkg-os-homedir-1.0.2.tgz
https://registry.npmjs.org/os-tmpdir/-/os-tmpdir-1.0.2.tgz -> npmpkg-os-tmpdir-1.0.2.tgz
https://registry.npmjs.org/osenv/-/osenv-0.1.5.tgz -> npmpkg-osenv-0.1.5.tgz
https://registry.npmjs.org/p-cancelable/-/p-cancelable-1.1.0.tgz -> npmpkg-p-cancelable-1.1.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-1.3.0.tgz -> npmpkg-p-limit-1.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-2.0.0.tgz -> npmpkg-p-locate-2.0.0.tgz
https://registry.npmjs.org/p-try/-/p-try-1.0.0.tgz -> npmpkg-p-try-1.0.0.tgz
https://registry.npmjs.org/pac-proxy-agent/-/pac-proxy-agent-4.1.0.tgz -> npmpkg-pac-proxy-agent-4.1.0.tgz
https://registry.npmjs.org/debug/-/debug-4.1.1.tgz -> npmpkg-debug-4.1.1.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/pac-resolver/-/pac-resolver-4.2.0.tgz -> npmpkg-pac-resolver-4.2.0.tgz
https://registry.npmjs.org/package-json/-/package-json-6.5.0.tgz -> npmpkg-package-json-6.5.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/pako/-/pako-1.0.11.tgz -> npmpkg-pako-1.0.11.tgz
https://registry.npmjs.org/parallel-transform/-/parallel-transform-1.2.0.tgz -> npmpkg-parallel-transform-1.2.0.tgz
https://registry.npmjs.org/param-case/-/param-case-3.0.3.tgz -> npmpkg-param-case-3.0.3.tgz
https://registry.npmjs.org/parent-module/-/parent-module-1.0.1.tgz -> npmpkg-parent-module-1.0.1.tgz
https://registry.npmjs.org/parse-asn1/-/parse-asn1-5.1.6.tgz -> npmpkg-parse-asn1-5.1.6.tgz
https://registry.npmjs.org/parse-json/-/parse-json-2.2.0.tgz -> npmpkg-parse-json-2.2.0.tgz
https://registry.npmjs.org/parse-passwd/-/parse-passwd-1.0.0.tgz -> npmpkg-parse-passwd-1.0.0.tgz
https://registry.npmjs.org/parse5/-/parse5-6.0.1.tgz -> npmpkg-parse5-6.0.1.tgz
https://registry.npmjs.org/pascal-case/-/pascal-case-3.1.1.tgz -> npmpkg-pascal-case-3.1.1.tgz
https://registry.npmjs.org/pascalcase/-/pascalcase-0.1.1.tgz -> npmpkg-pascalcase-0.1.1.tgz
https://registry.npmjs.org/path-browserify/-/path-browserify-0.0.1.tgz -> npmpkg-path-browserify-0.0.1.tgz
https://registry.npmjs.org/path-dirname/-/path-dirname-1.0.2.tgz -> npmpkg-path-dirname-1.0.2.tgz
https://registry.npmjs.org/path-exists/-/path-exists-3.0.0.tgz -> npmpkg-path-exists-3.0.0.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> npmpkg-path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/path-parse/-/path-parse-1.0.7.tgz -> npmpkg-path-parse-1.0.7.tgz
https://registry.npmjs.org/path-type/-/path-type-2.0.0.tgz -> npmpkg-path-type-2.0.0.tgz
https://registry.npmjs.org/pify/-/pify-2.3.0.tgz -> npmpkg-pify-2.3.0.tgz
https://registry.npmjs.org/pbkdf2/-/pbkdf2-3.1.2.tgz -> npmpkg-pbkdf2-3.1.2.tgz
https://registry.npmjs.org/pend/-/pend-1.2.0.tgz -> npmpkg-pend-1.2.0.tgz
https://registry.npmjs.org/performance-now/-/performance-now-2.1.0.tgz -> npmpkg-performance-now-2.1.0.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.3.0.tgz -> npmpkg-picomatch-2.3.0.tgz
https://registry.npmjs.org/pify/-/pify-3.0.0.tgz -> npmpkg-pify-3.0.0.tgz
https://registry.npmjs.org/pinkie/-/pinkie-2.0.4.tgz -> npmpkg-pinkie-2.0.4.tgz
https://registry.npmjs.org/pinkie-promise/-/pinkie-promise-2.0.1.tgz -> npmpkg-pinkie-promise-2.0.1.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-2.0.0.tgz -> npmpkg-pkg-dir-2.0.0.tgz
https://registry.npmjs.org/plist/-/plist-3.0.6.tgz -> npmpkg-plist-3.0.6.tgz
https://registry.npmjs.org/posix-character-classes/-/posix-character-classes-0.1.1.tgz -> npmpkg-posix-character-classes-0.1.1.tgz
https://registry.npmjs.org/postcss/-/postcss-8.3.2.tgz -> npmpkg-postcss-8.3.2.tgz
https://registry.npmjs.org/postcss-modules-extract-imports/-/postcss-modules-extract-imports-3.0.0.tgz -> npmpkg-postcss-modules-extract-imports-3.0.0.tgz
https://registry.npmjs.org/postcss-modules-local-by-default/-/postcss-modules-local-by-default-4.0.0.tgz -> npmpkg-postcss-modules-local-by-default-4.0.0.tgz
https://registry.npmjs.org/postcss-modules-scope/-/postcss-modules-scope-3.0.0.tgz -> npmpkg-postcss-modules-scope-3.0.0.tgz
https://registry.npmjs.org/postcss-modules-values/-/postcss-modules-values-4.0.0.tgz -> npmpkg-postcss-modules-values-4.0.0.tgz
https://registry.npmjs.org/postcss-selector-parser/-/postcss-selector-parser-6.0.6.tgz -> npmpkg-postcss-selector-parser-6.0.6.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-4.1.0.tgz -> npmpkg-postcss-value-parser-4.1.0.tgz
https://registry.npmjs.org/prelude-ls/-/prelude-ls-1.2.1.tgz -> npmpkg-prelude-ls-1.2.1.tgz
https://registry.npmjs.org/prepend-http/-/prepend-http-2.0.0.tgz -> npmpkg-prepend-http-2.0.0.tgz
https://registry.npmjs.org/prismjs/-/prismjs-1.29.0.tgz -> npmpkg-prismjs-1.29.0.tgz
https://registry.npmjs.org/private/-/private-0.1.8.tgz -> npmpkg-private-0.1.8.tgz
https://registry.npmjs.org/process/-/process-0.11.10.tgz -> npmpkg-process-0.11.10.tgz
https://registry.npmjs.org/process-nextick-args/-/process-nextick-args-2.0.1.tgz -> npmpkg-process-nextick-args-2.0.1.tgz
https://registry.npmjs.org/progress/-/progress-2.0.3.tgz -> npmpkg-progress-2.0.3.tgz
https://registry.npmjs.org/promise-inflight/-/promise-inflight-1.0.1.tgz -> npmpkg-promise-inflight-1.0.1.tgz
https://registry.npmjs.org/prop-types/-/prop-types-15.7.2.tgz -> npmpkg-prop-types-15.7.2.tgz
https://registry.npmjs.org/prop-types-extra/-/prop-types-extra-1.1.1.tgz -> npmpkg-prop-types-extra-1.1.1.tgz
https://registry.npmjs.org/warning/-/warning-4.0.3.tgz -> npmpkg-warning-4.0.3.tgz
https://registry.npmjs.org/proto-list/-/proto-list-1.2.4.tgz -> npmpkg-proto-list-1.2.4.tgz
https://registry.npmjs.org/proxy-agent/-/proxy-agent-4.0.1.tgz -> npmpkg-proxy-agent-4.0.1.tgz
https://registry.npmjs.org/debug/-/debug-4.1.1.tgz -> npmpkg-debug-4.1.1.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/proxy-from-env/-/proxy-from-env-1.1.0.tgz -> npmpkg-proxy-from-env-1.1.0.tgz
https://registry.npmjs.org/prr/-/prr-1.0.1.tgz -> npmpkg-prr-1.0.1.tgz
https://registry.npmjs.org/pseudomap/-/pseudomap-1.0.2.tgz -> npmpkg-pseudomap-1.0.2.tgz
https://registry.npmjs.org/psl/-/psl-1.8.0.tgz -> npmpkg-psl-1.8.0.tgz
https://registry.npmjs.org/public-encrypt/-/public-encrypt-4.0.3.tgz -> npmpkg-public-encrypt-4.0.3.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.0.tgz -> npmpkg-bn.js-4.12.0.tgz
https://registry.npmjs.org/pump/-/pump-3.0.0.tgz -> npmpkg-pump-3.0.0.tgz
https://registry.npmjs.org/pumpify/-/pumpify-1.5.1.tgz -> npmpkg-pumpify-1.5.1.tgz
https://registry.npmjs.org/pump/-/pump-2.0.1.tgz -> npmpkg-pump-2.0.1.tgz
https://registry.npmjs.org/punycode/-/punycode-2.1.1.tgz -> npmpkg-punycode-2.1.1.tgz
https://registry.npmjs.org/pupa/-/pupa-2.1.1.tgz -> npmpkg-pupa-2.1.1.tgz
https://registry.npmjs.org/qs/-/qs-6.5.3.tgz -> npmpkg-qs-6.5.3.tgz
https://registry.npmjs.org/querystring/-/querystring-0.2.0.tgz -> npmpkg-querystring-0.2.0.tgz
https://registry.npmjs.org/querystring-es3/-/querystring-es3-0.2.1.tgz -> npmpkg-querystring-es3-0.2.1.tgz
https://registry.npmjs.org/randombytes/-/randombytes-2.1.0.tgz -> npmpkg-randombytes-2.1.0.tgz
https://registry.npmjs.org/randomfill/-/randomfill-1.0.4.tgz -> npmpkg-randomfill-1.0.4.tgz
https://registry.npmjs.org/raw-body/-/raw-body-2.4.1.tgz -> npmpkg-raw-body-2.4.1.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.4.24.tgz -> npmpkg-iconv-lite-0.4.24.tgz
https://registry.npmjs.org/raw-loader/-/raw-loader-4.0.1.tgz -> npmpkg-raw-loader-4.0.1.tgz
https://registry.npmjs.org/json5/-/json5-2.2.3.tgz -> npmpkg-json5-2.2.3.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-2.0.4.tgz -> npmpkg-loader-utils-2.0.4.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-2.7.0.tgz -> npmpkg-schema-utils-2.7.0.tgz
https://registry.npmjs.org/rc/-/rc-1.2.8.tgz -> npmpkg-rc-1.2.8.tgz
https://registry.npmjs.org/ini/-/ini-1.3.8.tgz -> npmpkg-ini-1.3.8.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-2.0.1.tgz -> npmpkg-strip-json-comments-2.0.1.tgz
https://registry.npmjs.org/react/-/react-17.0.2.tgz -> npmpkg-react-17.0.2.tgz
https://registry.npmjs.org/react-bootstrap/-/react-bootstrap-0.32.4.tgz -> npmpkg-react-bootstrap-0.32.4.tgz
https://registry.npmjs.org/react-chartjs/-/react-chartjs-1.2.0.tgz -> npmpkg-react-chartjs-1.2.0.tgz
https://registry.npmjs.org/react-codemirror/-/react-codemirror-1.0.0.tgz -> npmpkg-react-codemirror-1.0.0.tgz
https://registry.npmjs.org/react-dom/-/react-dom-17.0.2.tgz -> npmpkg-react-dom-17.0.2.tgz
https://registry.npmjs.org/react-is/-/react-is-16.13.1.tgz -> npmpkg-react-is-16.13.1.tgz
https://registry.npmjs.org/react-lifecycles-compat/-/react-lifecycles-compat-3.0.4.tgz -> npmpkg-react-lifecycles-compat-3.0.4.tgz
https://registry.npmjs.org/react-overlays/-/react-overlays-0.8.3.tgz -> npmpkg-react-overlays-0.8.3.tgz
https://registry.npmjs.org/react-prop-types/-/react-prop-types-0.4.0.tgz -> npmpkg-react-prop-types-0.4.0.tgz
https://registry.npmjs.org/react-redux/-/react-redux-7.2.0.tgz -> npmpkg-react-redux-7.2.0.tgz
https://registry.npmjs.org/react-split-pane/-/react-split-pane-0.1.91.tgz -> npmpkg-react-split-pane-0.1.91.tgz
https://registry.npmjs.org/react-style-proptype/-/react-style-proptype-3.2.2.tgz -> npmpkg-react-style-proptype-3.2.2.tgz
https://registry.npmjs.org/react-transition-group/-/react-transition-group-2.9.0.tgz -> npmpkg-react-transition-group-2.9.0.tgz
https://registry.npmjs.org/read-config-file/-/read-config-file-6.2.0.tgz -> npmpkg-read-config-file-6.2.0.tgz
https://registry.npmjs.org/argparse/-/argparse-2.0.1.tgz -> npmpkg-argparse-2.0.1.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-4.1.0.tgz -> npmpkg-js-yaml-4.1.0.tgz
https://registry.npmjs.org/json5/-/json5-2.2.3.tgz -> npmpkg-json5-2.2.3.tgz
https://registry.npmjs.org/read-installed/-/read-installed-4.0.3.tgz -> npmpkg-read-installed-4.0.3.tgz
https://registry.npmjs.org/semver/-/semver-5.7.1.tgz -> npmpkg-semver-5.7.1.tgz
https://registry.npmjs.org/read-package-json/-/read-package-json-2.1.1.tgz -> npmpkg-read-package-json-2.1.1.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-2.0.0.tgz -> npmpkg-read-pkg-2.0.0.tgz
https://registry.npmjs.org/read-pkg-up/-/read-pkg-up-2.0.0.tgz -> npmpkg-read-pkg-up-2.0.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.7.tgz -> npmpkg-readable-stream-2.3.7.tgz
https://registry.npmjs.org/readdir-scoped-modules/-/readdir-scoped-modules-1.1.0.tgz -> npmpkg-readdir-scoped-modules-1.1.0.tgz
https://registry.npmjs.org/readdirp/-/readdirp-3.6.0.tgz -> npmpkg-readdirp-3.6.0.tgz
https://registry.npmjs.org/redent/-/redent-1.0.0.tgz -> npmpkg-redent-1.0.0.tgz
https://registry.npmjs.org/redux/-/redux-4.0.5.tgz -> npmpkg-redux-4.0.5.tgz
https://registry.npmjs.org/redux-form/-/redux-form-8.3.6.tgz -> npmpkg-redux-form-8.3.6.tgz
https://registry.npmjs.org/redux-thunk/-/redux-thunk-2.3.0.tgz -> npmpkg-redux-thunk-2.3.0.tgz
https://registry.npmjs.org/regenerate/-/regenerate-1.4.1.tgz -> npmpkg-regenerate-1.4.1.tgz
https://registry.npmjs.org/regenerator-runtime/-/regenerator-runtime-0.11.1.tgz -> npmpkg-regenerator-runtime-0.11.1.tgz
https://registry.npmjs.org/regenerator-transform/-/regenerator-transform-0.10.1.tgz -> npmpkg-regenerator-transform-0.10.1.tgz
https://registry.npmjs.org/regex-not/-/regex-not-1.0.2.tgz -> npmpkg-regex-not-1.0.2.tgz
https://registry.npmjs.org/regexp.prototype.flags/-/regexp.prototype.flags-1.3.0.tgz -> npmpkg-regexp.prototype.flags-1.3.0.tgz
https://registry.npmjs.org/regexpp/-/regexpp-3.1.0.tgz -> npmpkg-regexpp-3.1.0.tgz
https://registry.npmjs.org/regexpu-core/-/regexpu-core-2.0.0.tgz -> npmpkg-regexpu-core-2.0.0.tgz
https://registry.npmjs.org/registry-auth-token/-/registry-auth-token-4.2.2.tgz -> npmpkg-registry-auth-token-4.2.2.tgz
https://registry.npmjs.org/registry-url/-/registry-url-5.1.0.tgz -> npmpkg-registry-url-5.1.0.tgz
https://registry.npmjs.org/regjsgen/-/regjsgen-0.2.0.tgz -> npmpkg-regjsgen-0.2.0.tgz
https://registry.npmjs.org/regjsparser/-/regjsparser-0.1.5.tgz -> npmpkg-regjsparser-0.1.5.tgz
https://registry.npmjs.org/jsesc/-/jsesc-0.5.0.tgz -> npmpkg-jsesc-0.5.0.tgz
https://registry.npmjs.org/relateurl/-/relateurl-0.2.7.tgz -> npmpkg-relateurl-0.2.7.tgz
https://registry.npmjs.org/remove-trailing-separator/-/remove-trailing-separator-1.1.0.tgz -> npmpkg-remove-trailing-separator-1.1.0.tgz
https://registry.npmjs.org/repeat-element/-/repeat-element-1.1.4.tgz -> npmpkg-repeat-element-1.1.4.tgz
https://registry.npmjs.org/repeat-string/-/repeat-string-1.6.1.tgz -> npmpkg-repeat-string-1.6.1.tgz
https://registry.npmjs.org/repeating/-/repeating-2.0.1.tgz -> npmpkg-repeating-2.0.1.tgz
https://registry.npmjs.org/request/-/request-2.88.2.tgz -> npmpkg-request-2.88.2.tgz
https://registry.npmjs.org/request-promise/-/request-promise-4.2.5.tgz -> npmpkg-request-promise-4.2.5.tgz
https://registry.npmjs.org/request-promise-core/-/request-promise-core-1.1.3.tgz -> npmpkg-request-promise-core-1.1.3.tgz
https://registry.npmjs.org/tough-cookie/-/tough-cookie-2.5.0.tgz -> npmpkg-tough-cookie-2.5.0.tgz
https://registry.npmjs.org/form-data/-/form-data-2.3.3.tgz -> npmpkg-form-data-2.3.3.tgz
https://registry.npmjs.org/tough-cookie/-/tough-cookie-2.5.0.tgz -> npmpkg-tough-cookie-2.5.0.tgz
https://registry.npmjs.org/require-directory/-/require-directory-2.1.1.tgz -> npmpkg-require-directory-2.1.1.tgz
https://registry.npmjs.org/require-from-string/-/require-from-string-2.0.2.tgz -> npmpkg-require-from-string-2.0.2.tgz
https://registry.npmjs.org/require-main-filename/-/require-main-filename-2.0.0.tgz -> npmpkg-require-main-filename-2.0.0.tgz
https://registry.npmjs.org/resolve/-/resolve-1.17.0.tgz -> npmpkg-resolve-1.17.0.tgz
https://registry.npmjs.org/resolve-cwd/-/resolve-cwd-2.0.0.tgz -> npmpkg-resolve-cwd-2.0.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-3.0.0.tgz -> npmpkg-resolve-from-3.0.0.tgz
https://registry.npmjs.org/resolve-dir/-/resolve-dir-1.0.1.tgz -> npmpkg-resolve-dir-1.0.1.tgz
https://registry.npmjs.org/global-modules/-/global-modules-1.0.0.tgz -> npmpkg-global-modules-1.0.0.tgz
https://registry.npmjs.org/global-prefix/-/global-prefix-1.0.2.tgz -> npmpkg-global-prefix-1.0.2.tgz
https://registry.npmjs.org/ini/-/ini-1.3.8.tgz -> npmpkg-ini-1.3.8.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz -> npmpkg-resolve-from-4.0.0.tgz
https://registry.npmjs.org/resolve-url/-/resolve-url-0.2.1.tgz -> npmpkg-resolve-url-0.2.1.tgz
https://registry.npmjs.org/responselike/-/responselike-1.0.2.tgz -> npmpkg-responselike-1.0.2.tgz
https://registry.npmjs.org/ret/-/ret-0.1.15.tgz -> npmpkg-ret-0.1.15.tgz
https://registry.npmjs.org/rimraf/-/rimraf-2.7.1.tgz -> npmpkg-rimraf-2.7.1.tgz
https://registry.npmjs.org/ripemd160/-/ripemd160-2.0.2.tgz -> npmpkg-ripemd160-2.0.2.tgz
https://registry.npmjs.org/roarr/-/roarr-2.15.4.tgz -> npmpkg-roarr-2.15.4.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.1.2.tgz -> npmpkg-sprintf-js-1.1.2.tgz
https://registry.npmjs.org/run-queue/-/run-queue-1.0.3.tgz -> npmpkg-run-queue-1.0.3.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/safe-regex/-/safe-regex-1.1.0.tgz -> npmpkg-safe-regex-1.1.0.tgz
https://registry.npmjs.org/safer-buffer/-/safer-buffer-2.1.2.tgz -> npmpkg-safer-buffer-2.1.2.tgz
https://registry.npmjs.org/sanitize-filename/-/sanitize-filename-1.6.3.tgz -> npmpkg-sanitize-filename-1.6.3.tgz
https://registry.npmjs.org/sass-graph/-/sass-graph-2.2.5.tgz -> npmpkg-sass-graph-2.2.5.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-4.1.1.tgz -> npmpkg-ansi-regex-4.1.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/camelcase/-/camelcase-5.3.1.tgz -> npmpkg-camelcase-5.3.1.tgz
https://registry.npmjs.org/cliui/-/cliui-5.0.0.tgz -> npmpkg-cliui-5.0.0.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-7.0.3.tgz -> npmpkg-emoji-regex-7.0.3.tgz
https://registry.npmjs.org/find-up/-/find-up-3.0.0.tgz -> npmpkg-find-up-3.0.0.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-3.0.0.tgz -> npmpkg-locate-path-3.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-3.0.0.tgz -> npmpkg-p-locate-3.0.0.tgz
https://registry.npmjs.org/p-try/-/p-try-2.2.0.tgz -> npmpkg-p-try-2.2.0.tgz
https://registry.npmjs.org/string-width/-/string-width-3.1.0.tgz -> npmpkg-string-width-3.1.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-5.2.0.tgz -> npmpkg-strip-ansi-5.2.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-5.1.0.tgz -> npmpkg-wrap-ansi-5.1.0.tgz
https://registry.npmjs.org/yargs/-/yargs-13.3.2.tgz -> npmpkg-yargs-13.3.2.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-13.1.2.tgz -> npmpkg-yargs-parser-13.1.2.tgz
https://registry.npmjs.org/sass-loader/-/sass-loader-8.0.2.tgz -> npmpkg-sass-loader-8.0.2.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-2.7.1.tgz -> npmpkg-schema-utils-2.7.1.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/sax/-/sax-1.2.4.tgz -> npmpkg-sax-1.2.4.tgz
https://registry.npmjs.org/saxes/-/saxes-5.0.1.tgz -> npmpkg-saxes-5.0.1.tgz
https://registry.npmjs.org/scheduler/-/scheduler-0.20.2.tgz -> npmpkg-scheduler-0.20.2.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-3.0.0.tgz -> npmpkg-schema-utils-3.0.0.tgz
https://registry.npmjs.org/scss-tokenizer/-/scss-tokenizer-0.2.3.tgz -> npmpkg-scss-tokenizer-0.2.3.tgz
https://registry.npmjs.org/source-map/-/source-map-0.4.4.tgz -> npmpkg-source-map-0.4.4.tgz
https://registry.npmjs.org/secure-keys/-/secure-keys-1.0.0.tgz -> npmpkg-secure-keys-1.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.3.5.tgz -> npmpkg-semver-7.3.5.tgz
https://registry.npmjs.org/semver-compare/-/semver-compare-1.0.0.tgz -> npmpkg-semver-compare-1.0.0.tgz
https://registry.npmjs.org/semver-diff/-/semver-diff-3.1.1.tgz -> npmpkg-semver-diff-3.1.1.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/serialize-error/-/serialize-error-7.0.1.tgz -> npmpkg-serialize-error-7.0.1.tgz
https://registry.npmjs.org/serialize-javascript/-/serialize-javascript-4.0.0.tgz -> npmpkg-serialize-javascript-4.0.0.tgz
https://registry.npmjs.org/set-blocking/-/set-blocking-2.0.0.tgz -> npmpkg-set-blocking-2.0.0.tgz
https://registry.npmjs.org/set-value/-/set-value-2.0.1.tgz -> npmpkg-set-value-2.0.1.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/setimmediate/-/setimmediate-1.0.5.tgz -> npmpkg-setimmediate-1.0.5.tgz
https://registry.npmjs.org/setprototypeof/-/setprototypeof-1.1.1.tgz -> npmpkg-setprototypeof-1.1.1.tgz
https://registry.npmjs.org/sha.js/-/sha.js-2.4.11.tgz -> npmpkg-sha.js-2.4.11.tgz
https://registry.npmjs.org/shallow-clone/-/shallow-clone-3.0.1.tgz -> npmpkg-shallow-clone-3.0.1.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/side-channel/-/side-channel-1.0.2.tgz -> npmpkg-side-channel-1.0.2.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-3.0.3.tgz -> npmpkg-signal-exit-3.0.3.tgz
https://registry.npmjs.org/slash/-/slash-1.0.0.tgz -> npmpkg-slash-1.0.0.tgz
https://registry.npmjs.org/slice-ansi/-/slice-ansi-3.0.0.tgz -> npmpkg-slice-ansi-3.0.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.2.1.tgz -> npmpkg-ansi-styles-4.2.1.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/slide/-/slide-1.1.6.tgz -> npmpkg-slide-1.1.6.tgz
https://registry.npmjs.org/smart-buffer/-/smart-buffer-4.1.0.tgz -> npmpkg-smart-buffer-4.1.0.tgz
https://registry.npmjs.org/snapdragon/-/snapdragon-0.8.2.tgz -> npmpkg-snapdragon-0.8.2.tgz
https://registry.npmjs.org/snapdragon-node/-/snapdragon-node-2.1.1.tgz -> npmpkg-snapdragon-node-2.1.1.tgz
https://registry.npmjs.org/define-property/-/define-property-1.0.0.tgz -> npmpkg-define-property-1.0.0.tgz
https://registry.npmjs.org/snapdragon-util/-/snapdragon-util-3.0.1.tgz -> npmpkg-snapdragon-util-3.0.1.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz -> npmpkg-is-accessor-descriptor-0.1.6.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz -> npmpkg-is-data-descriptor-0.1.4.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.6.tgz -> npmpkg-is-descriptor-0.1.6.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/kind-of/-/kind-of-5.1.0.tgz -> npmpkg-kind-of-5.1.0.tgz
https://registry.npmjs.org/socks/-/socks-2.6.1.tgz -> npmpkg-socks-2.6.1.tgz
https://registry.npmjs.org/socks-proxy-agent/-/socks-proxy-agent-5.0.0.tgz -> npmpkg-socks-proxy-agent-5.0.0.tgz
https://registry.npmjs.org/debug/-/debug-4.1.1.tgz -> npmpkg-debug-4.1.1.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/sort-keys/-/sort-keys-1.1.2.tgz -> npmpkg-sort-keys-1.1.2.tgz
https://registry.npmjs.org/sort-keys-length/-/sort-keys-length-1.0.1.tgz -> npmpkg-sort-keys-length-1.0.1.tgz
https://registry.npmjs.org/source-list-map/-/source-list-map-2.0.1.tgz -> npmpkg-source-list-map-2.0.1.tgz
https://registry.npmjs.org/source-map/-/source-map-0.5.7.tgz -> npmpkg-source-map-0.5.7.tgz
https://registry.npmjs.org/source-map-js/-/source-map-js-0.6.2.tgz -> npmpkg-source-map-js-0.6.2.tgz
https://registry.npmjs.org/source-map-resolve/-/source-map-resolve-0.5.3.tgz -> npmpkg-source-map-resolve-0.5.3.tgz
https://registry.npmjs.org/source-map-support/-/source-map-support-0.4.18.tgz -> npmpkg-source-map-support-0.4.18.tgz
https://registry.npmjs.org/source-map-url/-/source-map-url-0.4.1.tgz -> npmpkg-source-map-url-0.4.1.tgz
https://registry.npmjs.org/spdx-compare/-/spdx-compare-1.0.0.tgz -> npmpkg-spdx-compare-1.0.0.tgz
https://registry.npmjs.org/spdx-correct/-/spdx-correct-3.1.1.tgz -> npmpkg-spdx-correct-3.1.1.tgz
https://registry.npmjs.org/spdx-exceptions/-/spdx-exceptions-2.3.0.tgz -> npmpkg-spdx-exceptions-2.3.0.tgz
https://registry.npmjs.org/spdx-expression-parse/-/spdx-expression-parse-3.0.1.tgz -> npmpkg-spdx-expression-parse-3.0.1.tgz
https://registry.npmjs.org/spdx-license-ids/-/spdx-license-ids-3.0.5.tgz -> npmpkg-spdx-license-ids-3.0.5.tgz
https://registry.npmjs.org/spdx-ranges/-/spdx-ranges-2.1.1.tgz -> npmpkg-spdx-ranges-2.1.1.tgz
https://registry.npmjs.org/spdx-satisfies/-/spdx-satisfies-4.0.1.tgz -> npmpkg-spdx-satisfies-4.0.1.tgz
https://registry.npmjs.org/split-string/-/split-string-3.1.0.tgz -> npmpkg-split-string-3.1.0.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.0.3.tgz -> npmpkg-sprintf-js-1.0.3.tgz
https://registry.npmjs.org/sshpk/-/sshpk-1.16.1.tgz -> npmpkg-sshpk-1.16.1.tgz
https://registry.npmjs.org/ssri/-/ssri-6.0.2.tgz -> npmpkg-ssri-6.0.2.tgz
https://registry.npmjs.org/stack-trace/-/stack-trace-0.0.10.tgz -> npmpkg-stack-trace-0.0.10.tgz
https://registry.npmjs.org/stat-mode/-/stat-mode-1.0.0.tgz -> npmpkg-stat-mode-1.0.0.tgz
https://registry.npmjs.org/static-extend/-/static-extend-0.1.2.tgz -> npmpkg-static-extend-0.1.2.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz -> npmpkg-is-accessor-descriptor-0.1.6.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz -> npmpkg-is-data-descriptor-0.1.4.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.6.tgz -> npmpkg-is-descriptor-0.1.6.tgz
https://registry.npmjs.org/kind-of/-/kind-of-5.1.0.tgz -> npmpkg-kind-of-5.1.0.tgz
https://registry.npmjs.org/statuses/-/statuses-1.5.0.tgz -> npmpkg-statuses-1.5.0.tgz
https://registry.npmjs.org/stdout-stream/-/stdout-stream-1.4.1.tgz -> npmpkg-stdout-stream-1.4.1.tgz
https://registry.npmjs.org/stealthy-require/-/stealthy-require-1.1.1.tgz -> npmpkg-stealthy-require-1.1.1.tgz
https://registry.npmjs.org/stream-browserify/-/stream-browserify-2.0.2.tgz -> npmpkg-stream-browserify-2.0.2.tgz
https://registry.npmjs.org/stream-each/-/stream-each-1.2.3.tgz -> npmpkg-stream-each-1.2.3.tgz
https://registry.npmjs.org/stream-http/-/stream-http-2.8.3.tgz -> npmpkg-stream-http-2.8.3.tgz
https://registry.npmjs.org/stream-shift/-/stream-shift-1.0.1.tgz -> npmpkg-stream-shift-1.0.1.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-1.1.1.tgz -> npmpkg-string_decoder-1.1.1.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/string.prototype.matchall/-/string.prototype.matchall-4.0.2.tgz -> npmpkg-string.prototype.matchall-4.0.2.tgz
https://registry.npmjs.org/string.prototype.trimend/-/string.prototype.trimend-1.0.1.tgz -> npmpkg-string.prototype.trimend-1.0.1.tgz
https://registry.npmjs.org/string.prototype.trimleft/-/string.prototype.trimleft-2.1.2.tgz -> npmpkg-string.prototype.trimleft-2.1.2.tgz
https://registry.npmjs.org/string.prototype.trimright/-/string.prototype.trimright-2.1.2.tgz -> npmpkg-string.prototype.trimright-2.1.2.tgz
https://registry.npmjs.org/string.prototype.trimstart/-/string.prototype.trimstart-1.0.1.tgz -> npmpkg-string.prototype.trimstart-1.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-3.0.1.tgz -> npmpkg-strip-ansi-3.0.1.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-3.0.0.tgz -> npmpkg-strip-bom-3.0.0.tgz
https://registry.npmjs.org/strip-indent/-/strip-indent-1.0.1.tgz -> npmpkg-strip-indent-1.0.1.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-3.1.1.tgz -> npmpkg-strip-json-comments-3.1.1.tgz
https://registry.npmjs.org/style-loader/-/style-loader-1.3.0.tgz -> npmpkg-style-loader-1.3.0.tgz
https://registry.npmjs.org/json5/-/json5-2.2.3.tgz -> npmpkg-json5-2.2.3.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-2.0.4.tgz -> npmpkg-loader-utils-2.0.4.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-2.7.1.tgz -> npmpkg-schema-utils-2.7.1.tgz
https://registry.npmjs.org/sumchecker/-/sumchecker-3.0.1.tgz -> npmpkg-sumchecker-3.0.1.tgz
https://registry.npmjs.org/debug/-/debug-4.1.1.tgz -> npmpkg-debug-4.1.1.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/supports-color/-/supports-color-2.0.0.tgz -> npmpkg-supports-color-2.0.0.tgz
https://registry.npmjs.org/symbol-observable/-/symbol-observable-1.2.0.tgz -> npmpkg-symbol-observable-1.2.0.tgz
https://registry.npmjs.org/symbol-tree/-/symbol-tree-3.2.4.tgz -> npmpkg-symbol-tree-3.2.4.tgz
https://registry.npmjs.org/table/-/table-6.7.1.tgz -> npmpkg-table-6.7.1.tgz
https://registry.npmjs.org/ajv/-/ajv-8.6.0.tgz -> npmpkg-ajv-8.6.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.2.1.tgz -> npmpkg-ansi-styles-4.2.1.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz -> npmpkg-json-schema-traverse-1.0.0.tgz
https://registry.npmjs.org/slice-ansi/-/slice-ansi-4.0.0.tgz -> npmpkg-slice-ansi-4.0.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.0.tgz -> npmpkg-strip-ansi-6.0.0.tgz
https://registry.npmjs.org/tapable/-/tapable-1.1.3.tgz -> npmpkg-tapable-1.1.3.tgz
https://registry.npmjs.org/tar/-/tar-2.2.2.tgz -> npmpkg-tar-2.2.2.tgz
https://registry.npmjs.org/temp-file/-/temp-file-3.4.0.tgz -> npmpkg-temp-file-3.4.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz -> npmpkg-fs-extra-10.1.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz -> npmpkg-jsonfile-6.1.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz -> npmpkg-universalify-2.0.0.tgz
https://registry.npmjs.org/terser/-/terser-4.8.1.tgz -> npmpkg-terser-4.8.1.tgz
https://registry.npmjs.org/terser-webpack-plugin/-/terser-webpack-plugin-1.4.5.tgz -> npmpkg-terser-webpack-plugin-1.4.5.tgz
https://registry.npmjs.org/find-cache-dir/-/find-cache-dir-2.1.0.tgz -> npmpkg-find-cache-dir-2.1.0.tgz
https://registry.npmjs.org/find-up/-/find-up-3.0.0.tgz -> npmpkg-find-up-3.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-3.0.0.tgz -> npmpkg-locate-path-3.0.0.tgz
https://registry.npmjs.org/make-dir/-/make-dir-2.1.0.tgz -> npmpkg-make-dir-2.1.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-3.0.0.tgz -> npmpkg-p-locate-3.0.0.tgz
https://registry.npmjs.org/p-try/-/p-try-2.2.0.tgz -> npmpkg-p-try-2.2.0.tgz
https://registry.npmjs.org/pify/-/pify-4.0.1.tgz -> npmpkg-pify-4.0.1.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-3.0.0.tgz -> npmpkg-pkg-dir-3.0.0.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-1.0.0.tgz -> npmpkg-schema-utils-1.0.0.tgz
https://registry.npmjs.org/semver/-/semver-5.7.1.tgz -> npmpkg-semver-5.7.1.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/commander/-/commander-2.20.3.tgz -> npmpkg-commander-2.20.3.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/source-map-support/-/source-map-support-0.5.19.tgz -> npmpkg-source-map-support-0.5.19.tgz
https://registry.npmjs.org/text-loader/-/text-loader-0.0.1.tgz -> npmpkg-text-loader-0.0.1.tgz
https://registry.npmjs.org/text-table/-/text-table-0.2.0.tgz -> npmpkg-text-table-0.2.0.tgz
https://registry.npmjs.org/through2/-/through2-2.0.5.tgz -> npmpkg-through2-2.0.5.tgz
https://registry.npmjs.org/timers-browserify/-/timers-browserify-2.0.12.tgz -> npmpkg-timers-browserify-2.0.12.tgz
https://registry.npmjs.org/tmp/-/tmp-0.2.1.tgz -> npmpkg-tmp-0.2.1.tgz
https://registry.npmjs.org/tmp-promise/-/tmp-promise-3.0.3.tgz -> npmpkg-tmp-promise-3.0.3.tgz
https://registry.npmjs.org/rimraf/-/rimraf-3.0.2.tgz -> npmpkg-rimraf-3.0.2.tgz
https://registry.npmjs.org/to-arraybuffer/-/to-arraybuffer-1.0.1.tgz -> npmpkg-to-arraybuffer-1.0.1.tgz
https://registry.npmjs.org/to-fast-properties/-/to-fast-properties-2.0.0.tgz -> npmpkg-to-fast-properties-2.0.0.tgz
https://registry.npmjs.org/to-object-path/-/to-object-path-0.3.0.tgz -> npmpkg-to-object-path-0.3.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/to-readable-stream/-/to-readable-stream-1.0.0.tgz -> npmpkg-to-readable-stream-1.0.0.tgz
https://registry.npmjs.org/to-regex/-/to-regex-3.0.2.tgz -> npmpkg-to-regex-3.0.2.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-2.1.1.tgz -> npmpkg-to-regex-range-2.1.1.tgz
https://registry.npmjs.org/toidentifier/-/toidentifier-1.0.0.tgz -> npmpkg-toidentifier-1.0.0.tgz
https://registry.npmjs.org/tough-cookie/-/tough-cookie-4.0.0.tgz -> npmpkg-tough-cookie-4.0.0.tgz
https://registry.npmjs.org/tr46/-/tr46-2.1.0.tgz -> npmpkg-tr46-2.1.0.tgz
https://registry.npmjs.org/treeify/-/treeify-1.1.0.tgz -> npmpkg-treeify-1.1.0.tgz
https://registry.npmjs.org/trim-newlines/-/trim-newlines-1.0.0.tgz -> npmpkg-trim-newlines-1.0.0.tgz
https://registry.npmjs.org/trim-right/-/trim-right-1.0.1.tgz -> npmpkg-trim-right-1.0.1.tgz
https://registry.npmjs.org/true-case-path/-/true-case-path-1.0.3.tgz -> npmpkg-true-case-path-1.0.3.tgz
https://registry.npmjs.org/truncate-utf8-bytes/-/truncate-utf8-bytes-1.0.2.tgz -> npmpkg-truncate-utf8-bytes-1.0.2.tgz
https://registry.npmjs.org/tslib/-/tslib-1.13.0.tgz -> npmpkg-tslib-1.13.0.tgz
https://registry.npmjs.org/tty-browserify/-/tty-browserify-0.0.0.tgz -> npmpkg-tty-browserify-0.0.0.tgz
https://registry.npmjs.org/tunnel/-/tunnel-0.0.6.tgz -> npmpkg-tunnel-0.0.6.tgz
https://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.6.0.tgz -> npmpkg-tunnel-agent-0.6.0.tgz
https://registry.npmjs.org/tweetnacl/-/tweetnacl-0.14.5.tgz -> npmpkg-tweetnacl-0.14.5.tgz
https://registry.npmjs.org/twemoji-parser/-/twemoji-parser-11.0.2.tgz -> npmpkg-twemoji-parser-11.0.2.tgz
https://registry.npmjs.org/twitter-text/-/twitter-text-3.1.0.tgz -> npmpkg-twitter-text-3.1.0.tgz
https://registry.npmjs.org/punycode/-/punycode-1.4.1.tgz -> npmpkg-punycode-1.4.1.tgz
https://registry.npmjs.org/type-check/-/type-check-0.4.0.tgz -> npmpkg-type-check-0.4.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.13.1.tgz -> npmpkg-type-fest-0.13.1.tgz
https://registry.npmjs.org/typedarray/-/typedarray-0.0.6.tgz -> npmpkg-typedarray-0.0.6.tgz
https://registry.npmjs.org/typedarray-to-buffer/-/typedarray-to-buffer-3.1.5.tgz -> npmpkg-typedarray-to-buffer-3.1.5.tgz
https://registry.npmjs.org/uc.micro/-/uc.micro-1.0.6.tgz -> npmpkg-uc.micro-1.0.6.tgz
https://registry.npmjs.org/uncontrollable/-/uncontrollable-5.1.0.tgz -> npmpkg-uncontrollable-5.1.0.tgz
https://registry.npmjs.org/union-value/-/union-value-1.0.1.tgz -> npmpkg-union-value-1.0.1.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/unique-filename/-/unique-filename-1.1.1.tgz -> npmpkg-unique-filename-1.1.1.tgz
https://registry.npmjs.org/unique-slug/-/unique-slug-2.0.2.tgz -> npmpkg-unique-slug-2.0.2.tgz
https://registry.npmjs.org/unique-string/-/unique-string-2.0.0.tgz -> npmpkg-unique-string-2.0.0.tgz
https://registry.npmjs.org/universalify/-/universalify-0.1.2.tgz -> npmpkg-universalify-0.1.2.tgz
https://registry.npmjs.org/unpipe/-/unpipe-1.0.0.tgz -> npmpkg-unpipe-1.0.0.tgz
https://registry.npmjs.org/unset-value/-/unset-value-1.0.0.tgz -> npmpkg-unset-value-1.0.0.tgz
https://registry.npmjs.org/has-value/-/has-value-0.3.1.tgz -> npmpkg-has-value-0.3.1.tgz
https://registry.npmjs.org/isobject/-/isobject-2.1.0.tgz -> npmpkg-isobject-2.1.0.tgz
https://registry.npmjs.org/has-values/-/has-values-0.1.4.tgz -> npmpkg-has-values-0.1.4.tgz
https://registry.npmjs.org/unused-filename/-/unused-filename-2.1.0.tgz -> npmpkg-unused-filename-2.1.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-4.0.0.tgz -> npmpkg-path-exists-4.0.0.tgz
https://registry.npmjs.org/upath/-/upath-1.2.0.tgz -> npmpkg-upath-1.2.0.tgz
https://registry.npmjs.org/update-notifier/-/update-notifier-5.1.0.tgz -> npmpkg-update-notifier-5.1.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/ci-info/-/ci-info-2.0.0.tgz -> npmpkg-ci-info-2.0.0.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/is-ci/-/is-ci-2.0.0.tgz -> npmpkg-is-ci-2.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/uri-js/-/uri-js-4.2.2.tgz -> npmpkg-uri-js-4.2.2.tgz
https://registry.npmjs.org/urix/-/urix-0.1.0.tgz -> npmpkg-urix-0.1.0.tgz
https://registry.npmjs.org/url/-/url-0.11.0.tgz -> npmpkg-url-0.11.0.tgz
https://registry.npmjs.org/url-loader/-/url-loader-4.1.0.tgz -> npmpkg-url-loader-4.1.0.tgz
https://registry.npmjs.org/json5/-/json5-2.2.3.tgz -> npmpkg-json5-2.2.3.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-2.0.4.tgz -> npmpkg-loader-utils-2.0.4.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-2.7.0.tgz -> npmpkg-schema-utils-2.7.0.tgz
https://registry.npmjs.org/url-parse-lax/-/url-parse-lax-3.0.0.tgz -> npmpkg-url-parse-lax-3.0.0.tgz
https://registry.npmjs.org/punycode/-/punycode-1.3.2.tgz -> npmpkg-punycode-1.3.2.tgz
https://registry.npmjs.org/use/-/use-3.1.1.tgz -> npmpkg-use-3.1.1.tgz
https://registry.npmjs.org/utf8-byte-length/-/utf8-byte-length-1.0.4.tgz -> npmpkg-utf8-byte-length-1.0.4.tgz
https://registry.npmjs.org/util/-/util-0.11.1.tgz -> npmpkg-util-0.11.1.tgz
https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz -> npmpkg-util-deprecate-1.0.2.tgz
https://registry.npmjs.org/util-extend/-/util-extend-1.0.3.tgz -> npmpkg-util-extend-1.0.3.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.3.tgz -> npmpkg-inherits-2.0.3.tgz
https://registry.npmjs.org/uuid/-/uuid-3.4.0.tgz -> npmpkg-uuid-3.4.0.tgz
https://registry.npmjs.org/v8-compile-cache/-/v8-compile-cache-2.1.1.tgz -> npmpkg-v8-compile-cache-2.1.1.tgz
https://registry.npmjs.org/valid-filename/-/valid-filename-3.1.0.tgz -> npmpkg-valid-filename-3.1.0.tgz
https://registry.npmjs.org/validate-npm-package-license/-/validate-npm-package-license-3.0.4.tgz -> npmpkg-validate-npm-package-license-3.0.4.tgz
https://registry.npmjs.org/verror/-/verror-1.10.0.tgz -> npmpkg-verror-1.10.0.tgz
https://registry.npmjs.org/vm-browserify/-/vm-browserify-1.1.2.tgz -> npmpkg-vm-browserify-1.1.2.tgz
https://registry.npmjs.org/w3c-hr-time/-/w3c-hr-time-1.0.2.tgz -> npmpkg-w3c-hr-time-1.0.2.tgz
https://registry.npmjs.org/w3c-xmlserializer/-/w3c-xmlserializer-2.0.0.tgz -> npmpkg-w3c-xmlserializer-2.0.0.tgz
https://registry.npmjs.org/warning/-/warning-3.0.0.tgz -> npmpkg-warning-3.0.0.tgz
https://registry.npmjs.org/watchpack/-/watchpack-1.7.5.tgz -> npmpkg-watchpack-1.7.5.tgz
https://registry.npmjs.org/watchpack-chokidar2/-/watchpack-chokidar2-2.0.1.tgz -> npmpkg-watchpack-chokidar2-2.0.1.tgz
https://registry.npmjs.org/anymatch/-/anymatch-2.0.0.tgz -> npmpkg-anymatch-2.0.0.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-2.1.1.tgz -> npmpkg-normalize-path-2.1.1.tgz
https://registry.npmjs.org/binary-extensions/-/binary-extensions-1.13.1.tgz -> npmpkg-binary-extensions-1.13.1.tgz
https://registry.npmjs.org/chokidar/-/chokidar-2.1.8.tgz -> npmpkg-chokidar-2.1.8.tgz
https://registry.npmjs.org/fsevents/-/fsevents-1.2.13.tgz -> npmpkg-fsevents-1.2.13.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-3.1.0.tgz -> npmpkg-glob-parent-3.1.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-3.1.0.tgz -> npmpkg-is-glob-3.1.0.tgz
https://registry.npmjs.org/is-binary-path/-/is-binary-path-1.0.1.tgz -> npmpkg-is-binary-path-1.0.1.tgz
https://registry.npmjs.org/readdirp/-/readdirp-2.2.1.tgz -> npmpkg-readdirp-2.2.1.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-6.1.0.tgz -> npmpkg-webidl-conversions-6.1.0.tgz
https://registry.npmjs.org/webpack/-/webpack-4.46.0.tgz -> npmpkg-webpack-4.46.0.tgz
https://registry.npmjs.org/webpack-cli/-/webpack-cli-3.3.12.tgz -> npmpkg-webpack-cli-3.3.12.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-4.1.1.tgz -> npmpkg-ansi-regex-4.1.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/camelcase/-/camelcase-5.3.1.tgz -> npmpkg-camelcase-5.3.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/cliui/-/cliui-5.0.0.tgz -> npmpkg-cliui-5.0.0.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-6.0.5.tgz -> npmpkg-cross-spawn-6.0.5.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-7.0.3.tgz -> npmpkg-emoji-regex-7.0.3.tgz
https://registry.npmjs.org/find-up/-/find-up-3.0.0.tgz -> npmpkg-find-up-3.0.0.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-3.0.0.tgz -> npmpkg-locate-path-3.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-3.0.0.tgz -> npmpkg-p-locate-3.0.0.tgz
https://registry.npmjs.org/p-try/-/p-try-2.2.0.tgz -> npmpkg-p-try-2.2.0.tgz
https://registry.npmjs.org/path-key/-/path-key-2.0.1.tgz -> npmpkg-path-key-2.0.1.tgz
https://registry.npmjs.org/semver/-/semver-5.7.1.tgz -> npmpkg-semver-5.7.1.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-1.2.0.tgz -> npmpkg-shebang-command-1.2.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-1.0.0.tgz -> npmpkg-shebang-regex-1.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-3.1.0.tgz -> npmpkg-string-width-3.1.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-5.2.0.tgz -> npmpkg-strip-ansi-5.2.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-6.1.0.tgz -> npmpkg-supports-color-6.1.0.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-5.1.0.tgz -> npmpkg-wrap-ansi-5.1.0.tgz
https://registry.npmjs.org/yargs/-/yargs-13.3.2.tgz -> npmpkg-yargs-13.3.2.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-13.1.2.tgz -> npmpkg-yargs-parser-13.1.2.tgz
https://registry.npmjs.org/webpack-node-externals/-/webpack-node-externals-1.7.2.tgz -> npmpkg-webpack-node-externals-1.7.2.tgz
https://registry.npmjs.org/webpack-sources/-/webpack-sources-1.4.3.tgz -> npmpkg-webpack-sources-1.4.3.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/acorn/-/acorn-6.4.2.tgz -> npmpkg-acorn-6.4.2.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-4.0.3.tgz -> npmpkg-eslint-scope-4.0.3.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-1.0.0.tgz -> npmpkg-schema-utils-1.0.0.tgz
https://registry.npmjs.org/whatwg-encoding/-/whatwg-encoding-1.0.5.tgz -> npmpkg-whatwg-encoding-1.0.5.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.4.24.tgz -> npmpkg-iconv-lite-0.4.24.tgz
https://registry.npmjs.org/whatwg-mimetype/-/whatwg-mimetype-2.3.0.tgz -> npmpkg-whatwg-mimetype-2.3.0.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-8.6.0.tgz -> npmpkg-whatwg-url-8.6.0.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/which-module/-/which-module-2.0.0.tgz -> npmpkg-which-module-2.0.0.tgz
https://registry.npmjs.org/wide-align/-/wide-align-1.1.3.tgz -> npmpkg-wide-align-1.1.3.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-3.0.1.tgz -> npmpkg-ansi-regex-3.0.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/string-width/-/string-width-2.1.1.tgz -> npmpkg-string-width-2.1.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-4.0.0.tgz -> npmpkg-strip-ansi-4.0.0.tgz
https://registry.npmjs.org/widest-line/-/widest-line-3.1.0.tgz -> npmpkg-widest-line-3.1.0.tgz
https://registry.npmjs.org/winston/-/winston-2.4.4.tgz -> npmpkg-winston-2.4.4.tgz
https://registry.npmjs.org/async/-/async-1.0.0.tgz -> npmpkg-async-1.0.0.tgz
https://registry.npmjs.org/word-wrap/-/word-wrap-1.2.3.tgz -> npmpkg-word-wrap-1.2.3.tgz
https://registry.npmjs.org/worker-farm/-/worker-farm-1.7.0.tgz -> npmpkg-worker-farm-1.7.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> npmpkg-wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
https://registry.npmjs.org/write-file-atomic/-/write-file-atomic-3.0.3.tgz -> npmpkg-write-file-atomic-3.0.3.tgz
https://registry.npmjs.org/ws/-/ws-7.4.6.tgz -> npmpkg-ws-7.4.6.tgz
https://registry.npmjs.org/xdg-basedir/-/xdg-basedir-4.0.0.tgz -> npmpkg-xdg-basedir-4.0.0.tgz
https://registry.npmjs.org/xml-name-validator/-/xml-name-validator-3.0.0.tgz -> npmpkg-xml-name-validator-3.0.0.tgz
https://registry.npmjs.org/xmlbuilder/-/xmlbuilder-15.1.1.tgz -> npmpkg-xmlbuilder-15.1.1.tgz
https://registry.npmjs.org/xmlchars/-/xmlchars-2.2.0.tgz -> npmpkg-xmlchars-2.2.0.tgz
https://registry.npmjs.org/xregexp/-/xregexp-4.3.0.tgz -> npmpkg-xregexp-4.3.0.tgz
https://registry.npmjs.org/xtend/-/xtend-4.0.2.tgz -> npmpkg-xtend-4.0.2.tgz
https://registry.npmjs.org/y18n/-/y18n-4.0.3.tgz -> npmpkg-y18n-4.0.3.tgz
https://registry.npmjs.org/yallist/-/yallist-3.1.1.tgz -> npmpkg-yallist-3.1.1.tgz
https://registry.npmjs.org/yargs/-/yargs-17.7.1.tgz -> npmpkg-yargs-17.7.1.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-21.1.1.tgz -> npmpkg-yargs-parser-21.1.1.tgz
https://registry.npmjs.org/y18n/-/y18n-5.0.8.tgz -> npmpkg-y18n-5.0.8.tgz
https://registry.npmjs.org/yauzl/-/yauzl-2.10.0.tgz -> npmpkg-yauzl-2.10.0.tgz
"
# UPDATER_END_NPM_EXTERNAL_URIS
SRC_URI="
$(electron-app_gen_electron_uris)
${NPM_EXTERNAL_URIS}
https://github.com/hackjutsu/Lepton/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${PN^}-${PV}"
RESTRICT="mirror"
LIBSASS_EXT="auto"

check_credentials() {
	if [[ -z "${LEPTON_CLIENT_ACCOUNT_JS_PATH}" \
		|| ! -f "${LEPTON_CLIENT_ACCOUNT_JS_PATH}" ]] ; then
eerror
eerror "You must define LEPTON_CLIENT_ACCOUNT_JS_PATH as the absolute path to"
eerror "account.js.  A template can be found in the files directory of this"
eerror "ebuild."
eerror
eerror "https://github.com/hackjutsu/Lepton#client-idsecret"
eerror "https://github.com/hackjutsu/Lepton/issues/265"
eerror
		die
	fi
}

pkg_setup() {
	check_credentials
	npm_pkg_setup
}

src_prepare() {
	default
	cat \
		"${LEPTON_CLIENT_ACCOUNT_JS_PATH}" \
		> \
		"${S}/configs/account.js" \
		|| die
}

src_compile() {
	export PATH="${S}/node_modules/.bin:${PATH}"
	cd "${S}" || die
	npm_hydrate
	electron-app_cp_electron
	enpm run build
	electron-builder -l --dir
}

src_install() {
	insinto "${NPM_INSTALL_PATH}"
	doins -r "dist/linux-unpacked/"*
	newicon "build/icon/icon.png" "${PN}.png"
	make_desktop_entry \
		"${NPM_INSTALL_PATH}/${PN}" \
		"${PN^}" \
		"${PN}.png" \
		"Development"
	fperms 0755 "${NPM_INSTALL_PATH}/${PN}"
	shred "${S}/configs/account.js"
	electron-app_gen_wrapper \
		"${PN^}" \
		"${NPM_INSTALL_PATH}/${PN}"
	dosym "/usr/bin/${PN^}" "/usr/bin/${PN}"
	LCNR_SOURCE="${WORKDIR}/${PN^}-${PV}"
	lcnr_install_files
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
