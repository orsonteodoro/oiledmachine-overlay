# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="Lepton"

YARN_INSTALL_PATH="/opt/${PN}"
NODE_VERSION=14
#ELECTRON_APP_APPIMAGE="1"
ELECTRON_APP_APPIMAGE_ARCHIVE_NAME="${MY_PN}-${PV}.AppImage"
#ELECTRON_APP_SNAP="1"
ELECTRON_APP_SNAP_ARCHIVE_NAME="${MY_PN}_${PV}_amd64.snap"
ELECTRON_APP_ELECTRON_PV="13.1.2"
ELECTRON_APP_LOCKFILE_EXACT_VERSIONS_ONLY="1"
ELECTRON_APP_MODE="yarn"
ELECTRON_APP_REACT_PV="17.0.0"
NODE_ENV="development"

inherit desktop electron-app lcnr yarn

DESCRIPTION="Democratizing Snippet Management (macOS/Win/Linux)"
HOMEPAGE="http://hackjutsu.com/Lepton"
THIRD_PARTY_LICENSES="
	( custom MIT all-rights-reserved keep-copyright-notice )
	( MIT all-rights-reserved )
	( WTFPL-2 ISC )
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
	|| ( Apache-2.0 MPL-2.0 )
"
LICENSE="
	MIT
	${ELECTRON_APP_LICENSES}
	${THIRD_PARTY_LICENSES}
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
IUSE=" r3"
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
#   grep "resolved" /var/tmp/portage/dev-util/lepton-1.10.0/work/lepton-1.10.0/yarn.lock | cut -f 2 -d '"' | cut -f 1 -d "#" | sort | uniq
# For the generator script, see typescript/transform-uris.sh ebuild-package.
# UPDATER_START_YARN_EXTERNAL_URIS
YARN_EXTERNAL_URIS="
https://registry.yarnpkg.com/7zip-bin/-/7zip-bin-5.0.3.tgz -> yarnpkg-7zip-bin-5.0.3.tgz
https://registry.yarnpkg.com/@babel/code-frame/-/code-frame-7.12.11.tgz -> yarnpkg-@babel-code-frame-7.12.11.tgz
https://registry.yarnpkg.com/@babel/code-frame/-/code-frame-7.10.1.tgz -> yarnpkg-@babel-code-frame-7.10.1.tgz
https://registry.yarnpkg.com/@babel/generator/-/generator-7.10.2.tgz -> yarnpkg-@babel-generator-7.10.2.tgz
https://registry.yarnpkg.com/@babel/helper-function-name/-/helper-function-name-7.10.1.tgz -> yarnpkg-@babel-helper-function-name-7.10.1.tgz
https://registry.yarnpkg.com/@babel/helper-get-function-arity/-/helper-get-function-arity-7.10.1.tgz -> yarnpkg-@babel-helper-get-function-arity-7.10.1.tgz
https://registry.yarnpkg.com/@babel/helper-split-export-declaration/-/helper-split-export-declaration-7.10.1.tgz -> yarnpkg-@babel-helper-split-export-declaration-7.10.1.tgz
https://registry.yarnpkg.com/@babel/helper-validator-identifier/-/helper-validator-identifier-7.10.1.tgz -> yarnpkg-@babel-helper-validator-identifier-7.10.1.tgz
https://registry.yarnpkg.com/@babel/helper-validator-identifier/-/helper-validator-identifier-7.14.5.tgz -> yarnpkg-@babel-helper-validator-identifier-7.14.5.tgz
https://registry.yarnpkg.com/@babel/highlight/-/highlight-7.10.1.tgz -> yarnpkg-@babel-highlight-7.10.1.tgz
https://registry.yarnpkg.com/@babel/highlight/-/highlight-7.14.5.tgz -> yarnpkg-@babel-highlight-7.14.5.tgz
https://registry.yarnpkg.com/@babel/parser/-/parser-7.10.2.tgz -> yarnpkg-@babel-parser-7.10.2.tgz
https://registry.yarnpkg.com/@babel/runtime-corejs2/-/runtime-corejs2-7.14.5.tgz -> yarnpkg-@babel-runtime-corejs2-7.14.5.tgz
https://registry.yarnpkg.com/@babel/runtime-corejs3/-/runtime-corejs3-7.10.2.tgz -> yarnpkg-@babel-runtime-corejs3-7.10.2.tgz
https://registry.yarnpkg.com/@babel/runtime/-/runtime-7.14.5.tgz -> yarnpkg-@babel-runtime-7.14.5.tgz
https://registry.yarnpkg.com/@babel/runtime/-/runtime-7.10.2.tgz -> yarnpkg-@babel-runtime-7.10.2.tgz
https://registry.yarnpkg.com/@babel/template/-/template-7.10.1.tgz -> yarnpkg-@babel-template-7.10.1.tgz
https://registry.yarnpkg.com/@babel/traverse/-/traverse-7.10.1.tgz -> yarnpkg-@babel-traverse-7.10.1.tgz
https://registry.yarnpkg.com/@babel/types/-/types-7.10.2.tgz -> yarnpkg-@babel-types-7.10.2.tgz
https://registry.yarnpkg.com/@develar/schema-utils/-/schema-utils-2.6.5.tgz -> yarnpkg-@develar-schema-utils-2.6.5.tgz
https://registry.yarnpkg.com/@electron/get/-/get-1.12.2.tgz -> yarnpkg-@electron-get-1.12.2.tgz
https://registry.yarnpkg.com/@electron/remote/-/remote-1.1.0.tgz -> yarnpkg-@electron-remote-1.1.0.tgz
https://registry.yarnpkg.com/@eslint/eslintrc/-/eslintrc-0.4.2.tgz -> yarnpkg-@eslint-eslintrc-0.4.2.tgz
https://registry.yarnpkg.com/@scarf/scarf/-/scarf-1.0.5.tgz -> yarnpkg-@scarf-scarf-1.0.5.tgz
https://registry.yarnpkg.com/@sindresorhus/is/-/is-0.14.0.tgz -> yarnpkg-@sindresorhus-is-0.14.0.tgz
https://registry.yarnpkg.com/@szmarczak/http-timer/-/http-timer-1.1.2.tgz -> yarnpkg-@szmarczak-http-timer-1.1.2.tgz
https://registry.yarnpkg.com/@tootallnate/once/-/once-1.1.2.tgz -> yarnpkg-@tootallnate-once-1.1.2.tgz
https://registry.yarnpkg.com/@types/color-name/-/color-name-1.1.1.tgz -> yarnpkg-@types-color-name-1.1.1.tgz
https://registry.yarnpkg.com/@types/debug/-/debug-4.1.5.tgz -> yarnpkg-@types-debug-4.1.5.tgz
https://registry.yarnpkg.com/@types/fs-extra/-/fs-extra-9.0.1.tgz -> yarnpkg-@types-fs-extra-9.0.1.tgz
https://registry.yarnpkg.com/@types/json-schema/-/json-schema-7.0.4.tgz -> yarnpkg-@types-json-schema-7.0.4.tgz
https://registry.yarnpkg.com/@types/json-schema/-/json-schema-7.0.7.tgz -> yarnpkg-@types-json-schema-7.0.7.tgz
https://registry.yarnpkg.com/@types/node/-/node-14.0.11.tgz -> yarnpkg-@types-node-14.0.11.tgz
https://registry.yarnpkg.com/@types/node/-/node-14.17.3.tgz -> yarnpkg-@types-node-14.17.3.tgz
https://registry.yarnpkg.com/@types/semver/-/semver-7.2.0.tgz -> yarnpkg-@types-semver-7.2.0.tgz
https://registry.yarnpkg.com/@types/yargs-parser/-/yargs-parser-15.0.0.tgz -> yarnpkg-@types-yargs-parser-15.0.0.tgz
https://registry.yarnpkg.com/@types/yargs/-/yargs-15.0.5.tgz -> yarnpkg-@types-yargs-15.0.5.tgz
https://registry.yarnpkg.com/@webassemblyjs/ast/-/ast-1.9.0.tgz -> yarnpkg-@webassemblyjs-ast-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/floating-point-hex-parser/-/floating-point-hex-parser-1.9.0.tgz -> yarnpkg-@webassemblyjs-floating-point-hex-parser-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-api-error/-/helper-api-error-1.9.0.tgz -> yarnpkg-@webassemblyjs-helper-api-error-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-buffer/-/helper-buffer-1.9.0.tgz -> yarnpkg-@webassemblyjs-helper-buffer-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-code-frame/-/helper-code-frame-1.9.0.tgz -> yarnpkg-@webassemblyjs-helper-code-frame-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-fsm/-/helper-fsm-1.9.0.tgz -> yarnpkg-@webassemblyjs-helper-fsm-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-module-context/-/helper-module-context-1.9.0.tgz -> yarnpkg-@webassemblyjs-helper-module-context-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-wasm-bytecode/-/helper-wasm-bytecode-1.9.0.tgz -> yarnpkg-@webassemblyjs-helper-wasm-bytecode-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-wasm-section/-/helper-wasm-section-1.9.0.tgz -> yarnpkg-@webassemblyjs-helper-wasm-section-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/ieee754/-/ieee754-1.9.0.tgz -> yarnpkg-@webassemblyjs-ieee754-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/leb128/-/leb128-1.9.0.tgz -> yarnpkg-@webassemblyjs-leb128-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/utf8/-/utf8-1.9.0.tgz -> yarnpkg-@webassemblyjs-utf8-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/wasm-edit/-/wasm-edit-1.9.0.tgz -> yarnpkg-@webassemblyjs-wasm-edit-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/wasm-gen/-/wasm-gen-1.9.0.tgz -> yarnpkg-@webassemblyjs-wasm-gen-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/wasm-opt/-/wasm-opt-1.9.0.tgz -> yarnpkg-@webassemblyjs-wasm-opt-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/wasm-parser/-/wasm-parser-1.9.0.tgz -> yarnpkg-@webassemblyjs-wasm-parser-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/wast-parser/-/wast-parser-1.9.0.tgz -> yarnpkg-@webassemblyjs-wast-parser-1.9.0.tgz
https://registry.yarnpkg.com/@webassemblyjs/wast-printer/-/wast-printer-1.9.0.tgz -> yarnpkg-@webassemblyjs-wast-printer-1.9.0.tgz
https://registry.yarnpkg.com/@xtuc/ieee754/-/ieee754-1.2.0.tgz -> yarnpkg-@xtuc-ieee754-1.2.0.tgz
https://registry.yarnpkg.com/@xtuc/long/-/long-4.2.2.tgz -> yarnpkg-@xtuc-long-4.2.2.tgz
https://registry.yarnpkg.com/abab/-/abab-2.0.3.tgz -> yarnpkg-abab-2.0.3.tgz
https://registry.yarnpkg.com/abab/-/abab-2.0.5.tgz -> yarnpkg-abab-2.0.5.tgz
https://registry.yarnpkg.com/abbrev/-/abbrev-1.1.1.tgz -> yarnpkg-abbrev-1.1.1.tgz
https://registry.yarnpkg.com/acorn-globals/-/acorn-globals-6.0.0.tgz -> yarnpkg-acorn-globals-6.0.0.tgz
https://registry.yarnpkg.com/acorn-jsx/-/acorn-jsx-5.3.1.tgz -> yarnpkg-acorn-jsx-5.3.1.tgz
https://registry.yarnpkg.com/acorn-walk/-/acorn-walk-7.1.1.tgz -> yarnpkg-acorn-walk-7.1.1.tgz
https://registry.yarnpkg.com/acorn/-/acorn-6.4.2.tgz -> yarnpkg-acorn-6.4.2.tgz
https://registry.yarnpkg.com/acorn/-/acorn-7.2.0.tgz -> yarnpkg-acorn-7.2.0.tgz
https://registry.yarnpkg.com/acorn/-/acorn-7.4.1.tgz -> yarnpkg-acorn-7.4.1.tgz
https://registry.yarnpkg.com/acorn/-/acorn-8.4.0.tgz -> yarnpkg-acorn-8.4.0.tgz
https://registry.yarnpkg.com/agent-base/-/agent-base-6.0.2.tgz -> yarnpkg-agent-base-6.0.2.tgz
https://registry.yarnpkg.com/ajv-errors/-/ajv-errors-1.0.1.tgz -> yarnpkg-ajv-errors-1.0.1.tgz
https://registry.yarnpkg.com/ajv-keywords/-/ajv-keywords-3.5.2.tgz -> yarnpkg-ajv-keywords-3.5.2.tgz
https://registry.yarnpkg.com/ajv-keywords/-/ajv-keywords-3.4.1.tgz -> yarnpkg-ajv-keywords-3.4.1.tgz
https://registry.yarnpkg.com/ajv/-/ajv-6.12.6.tgz -> yarnpkg-ajv-6.12.6.tgz
https://registry.yarnpkg.com/ajv/-/ajv-6.12.2.tgz -> yarnpkg-ajv-6.12.2.tgz
https://registry.yarnpkg.com/ajv/-/ajv-8.6.0.tgz -> yarnpkg-ajv-8.6.0.tgz
https://registry.yarnpkg.com/amdefine/-/amdefine-1.0.1.tgz -> yarnpkg-amdefine-1.0.1.tgz
https://registry.yarnpkg.com/ansi-align/-/ansi-align-3.0.0.tgz -> yarnpkg-ansi-align-3.0.0.tgz
https://registry.yarnpkg.com/ansi-colors/-/ansi-colors-4.1.1.tgz -> yarnpkg-ansi-colors-4.1.1.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-2.1.1.tgz -> yarnpkg-ansi-regex-2.1.1.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-3.0.0.tgz -> yarnpkg-ansi-regex-3.0.0.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-4.1.0.tgz -> yarnpkg-ansi-regex-4.1.0.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-5.0.0.tgz -> yarnpkg-ansi-regex-5.0.0.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-2.2.1.tgz -> yarnpkg-ansi-styles-2.2.1.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-3.2.1.tgz -> yarnpkg-ansi-styles-3.2.1.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-4.2.1.tgz -> yarnpkg-ansi-styles-4.2.1.tgz
https://registry.yarnpkg.com/ansi_up/-/ansi_up-5.0.1.tgz -> yarnpkg-ansi_up-5.0.1.tgz
https://registry.yarnpkg.com/anymatch/-/anymatch-2.0.0.tgz -> yarnpkg-anymatch-2.0.0.tgz
https://registry.yarnpkg.com/anymatch/-/anymatch-3.1.2.tgz -> yarnpkg-anymatch-3.1.2.tgz
https://registry.yarnpkg.com/app-builder-bin/-/app-builder-bin-3.5.9.tgz -> yarnpkg-app-builder-bin-3.5.9.tgz
https://registry.yarnpkg.com/app-builder-lib/-/app-builder-lib-22.7.0.tgz -> yarnpkg-app-builder-lib-22.7.0.tgz
https://registry.yarnpkg.com/aproba/-/aproba-1.2.0.tgz -> yarnpkg-aproba-1.2.0.tgz
https://registry.yarnpkg.com/are-we-there-yet/-/are-we-there-yet-1.1.5.tgz -> yarnpkg-are-we-there-yet-1.1.5.tgz
https://registry.yarnpkg.com/argparse/-/argparse-1.0.10.tgz -> yarnpkg-argparse-1.0.10.tgz
https://registry.yarnpkg.com/argparse/-/argparse-2.0.1.tgz -> yarnpkg-argparse-2.0.1.tgz
https://registry.yarnpkg.com/arr-diff/-/arr-diff-4.0.0.tgz -> yarnpkg-arr-diff-4.0.0.tgz
https://registry.yarnpkg.com/arr-flatten/-/arr-flatten-1.1.0.tgz -> yarnpkg-arr-flatten-1.1.0.tgz
https://registry.yarnpkg.com/arr-union/-/arr-union-3.1.0.tgz -> yarnpkg-arr-union-3.1.0.tgz
https://registry.yarnpkg.com/array-find-index/-/array-find-index-1.0.2.tgz -> yarnpkg-array-find-index-1.0.2.tgz
https://registry.yarnpkg.com/array-includes/-/array-includes-3.1.1.tgz -> yarnpkg-array-includes-3.1.1.tgz
https://registry.yarnpkg.com/array-unique/-/array-unique-0.3.2.tgz -> yarnpkg-array-unique-0.3.2.tgz
https://registry.yarnpkg.com/array.prototype.flat/-/array.prototype.flat-1.2.3.tgz -> yarnpkg-array.prototype.flat-1.2.3.tgz
https://registry.yarnpkg.com/asap/-/asap-2.0.6.tgz -> yarnpkg-asap-2.0.6.tgz
https://registry.yarnpkg.com/asn1.js/-/asn1.js-5.4.1.tgz -> yarnpkg-asn1.js-5.4.1.tgz
https://registry.yarnpkg.com/asn1/-/asn1-0.2.4.tgz -> yarnpkg-asn1-0.2.4.tgz
https://registry.yarnpkg.com/assert-plus/-/assert-plus-1.0.0.tgz -> yarnpkg-assert-plus-1.0.0.tgz
https://registry.yarnpkg.com/assert/-/assert-1.5.0.tgz -> yarnpkg-assert-1.5.0.tgz
https://registry.yarnpkg.com/assign-symbols/-/assign-symbols-1.0.0.tgz -> yarnpkg-assign-symbols-1.0.0.tgz
https://registry.yarnpkg.com/ast-types/-/ast-types-0.13.4.tgz -> yarnpkg-ast-types-0.13.4.tgz
https://registry.yarnpkg.com/astral-regex/-/astral-regex-2.0.0.tgz -> yarnpkg-astral-regex-2.0.0.tgz
https://registry.yarnpkg.com/async-each/-/async-each-1.0.3.tgz -> yarnpkg-async-each-1.0.3.tgz
https://registry.yarnpkg.com/async-exit-hook/-/async-exit-hook-2.0.1.tgz -> yarnpkg-async-exit-hook-2.0.1.tgz
https://registry.yarnpkg.com/async-foreach/-/async-foreach-0.1.3.tgz -> yarnpkg-async-foreach-0.1.3.tgz
https://registry.yarnpkg.com/async/-/async-0.9.2.tgz -> yarnpkg-async-0.9.2.tgz
https://registry.yarnpkg.com/async/-/async-1.5.2.tgz -> yarnpkg-async-1.5.2.tgz
https://registry.yarnpkg.com/async/-/async-1.0.0.tgz -> yarnpkg-async-1.0.0.tgz
https://registry.yarnpkg.com/asynckit/-/asynckit-0.4.0.tgz -> yarnpkg-asynckit-0.4.0.tgz
https://registry.yarnpkg.com/at-least-node/-/at-least-node-1.0.0.tgz -> yarnpkg-at-least-node-1.0.0.tgz
https://registry.yarnpkg.com/atob/-/atob-2.1.2.tgz -> yarnpkg-atob-2.1.2.tgz
https://registry.yarnpkg.com/autolinker/-/autolinker-3.14.1.tgz -> yarnpkg-autolinker-3.14.1.tgz
https://registry.yarnpkg.com/aws-sign2/-/aws-sign2-0.7.0.tgz -> yarnpkg-aws-sign2-0.7.0.tgz
https://registry.yarnpkg.com/aws4/-/aws4-1.10.0.tgz -> yarnpkg-aws4-1.10.0.tgz
https://registry.yarnpkg.com/babel-code-frame/-/babel-code-frame-6.26.0.tgz -> yarnpkg-babel-code-frame-6.26.0.tgz
https://registry.yarnpkg.com/babel-core/-/babel-core-6.26.3.tgz -> yarnpkg-babel-core-6.26.3.tgz
https://registry.yarnpkg.com/babel-eslint/-/babel-eslint-10.1.0.tgz -> yarnpkg-babel-eslint-10.1.0.tgz
https://registry.yarnpkg.com/babel-generator/-/babel-generator-6.26.1.tgz -> yarnpkg-babel-generator-6.26.1.tgz
https://registry.yarnpkg.com/babel-helper-builder-react-jsx/-/babel-helper-builder-react-jsx-6.26.0.tgz -> yarnpkg-babel-helper-builder-react-jsx-6.26.0.tgz
https://registry.yarnpkg.com/babel-helper-call-delegate/-/babel-helper-call-delegate-6.24.1.tgz -> yarnpkg-babel-helper-call-delegate-6.24.1.tgz
https://registry.yarnpkg.com/babel-helper-define-map/-/babel-helper-define-map-6.26.0.tgz -> yarnpkg-babel-helper-define-map-6.26.0.tgz
https://registry.yarnpkg.com/babel-helper-function-name/-/babel-helper-function-name-6.24.1.tgz -> yarnpkg-babel-helper-function-name-6.24.1.tgz
https://registry.yarnpkg.com/babel-helper-get-function-arity/-/babel-helper-get-function-arity-6.24.1.tgz -> yarnpkg-babel-helper-get-function-arity-6.24.1.tgz
https://registry.yarnpkg.com/babel-helper-hoist-variables/-/babel-helper-hoist-variables-6.24.1.tgz -> yarnpkg-babel-helper-hoist-variables-6.24.1.tgz
https://registry.yarnpkg.com/babel-helper-optimise-call-expression/-/babel-helper-optimise-call-expression-6.24.1.tgz -> yarnpkg-babel-helper-optimise-call-expression-6.24.1.tgz
https://registry.yarnpkg.com/babel-helper-regex/-/babel-helper-regex-6.26.0.tgz -> yarnpkg-babel-helper-regex-6.26.0.tgz
https://registry.yarnpkg.com/babel-helper-replace-supers/-/babel-helper-replace-supers-6.24.1.tgz -> yarnpkg-babel-helper-replace-supers-6.24.1.tgz
https://registry.yarnpkg.com/babel-helpers/-/babel-helpers-6.24.1.tgz -> yarnpkg-babel-helpers-6.24.1.tgz
https://registry.yarnpkg.com/babel-loader/-/babel-loader-7.1.5.tgz -> yarnpkg-babel-loader-7.1.5.tgz
https://registry.yarnpkg.com/babel-messages/-/babel-messages-6.23.0.tgz -> yarnpkg-babel-messages-6.23.0.tgz
https://registry.yarnpkg.com/babel-plugin-check-es2015-constants/-/babel-plugin-check-es2015-constants-6.22.0.tgz -> yarnpkg-babel-plugin-check-es2015-constants-6.22.0.tgz
https://registry.yarnpkg.com/babel-plugin-syntax-dynamic-import/-/babel-plugin-syntax-dynamic-import-6.18.0.tgz -> yarnpkg-babel-plugin-syntax-dynamic-import-6.18.0.tgz
https://registry.yarnpkg.com/babel-plugin-syntax-flow/-/babel-plugin-syntax-flow-6.18.0.tgz -> yarnpkg-babel-plugin-syntax-flow-6.18.0.tgz
https://registry.yarnpkg.com/babel-plugin-syntax-jsx/-/babel-plugin-syntax-jsx-6.18.0.tgz -> yarnpkg-babel-plugin-syntax-jsx-6.18.0.tgz
https://registry.yarnpkg.com/babel-plugin-transform-es2015-arrow-functions/-/babel-plugin-transform-es2015-arrow-functions-6.22.0.tgz -> yarnpkg-babel-plugin-transform-es2015-arrow-functions-6.22.0.tgz
https://registry.yarnpkg.com/babel-plugin-transform-es2015-block-scoped-functions/-/babel-plugin-transform-es2015-block-scoped-functions-6.22.0.tgz -> yarnpkg-babel-plugin-transform-es2015-block-scoped-functions-6.22.0.tgz
https://registry.yarnpkg.com/babel-plugin-transform-es2015-block-scoping/-/babel-plugin-transform-es2015-block-scoping-6.26.0.tgz -> yarnpkg-babel-plugin-transform-es2015-block-scoping-6.26.0.tgz
https://registry.yarnpkg.com/babel-plugin-transform-es2015-classes/-/babel-plugin-transform-es2015-classes-6.24.1.tgz -> yarnpkg-babel-plugin-transform-es2015-classes-6.24.1.tgz
https://registry.yarnpkg.com/babel-plugin-transform-es2015-computed-properties/-/babel-plugin-transform-es2015-computed-properties-6.24.1.tgz -> yarnpkg-babel-plugin-transform-es2015-computed-properties-6.24.1.tgz
https://registry.yarnpkg.com/babel-plugin-transform-es2015-destructuring/-/babel-plugin-transform-es2015-destructuring-6.23.0.tgz -> yarnpkg-babel-plugin-transform-es2015-destructuring-6.23.0.tgz
https://registry.yarnpkg.com/babel-plugin-transform-es2015-duplicate-keys/-/babel-plugin-transform-es2015-duplicate-keys-6.24.1.tgz -> yarnpkg-babel-plugin-transform-es2015-duplicate-keys-6.24.1.tgz
https://registry.yarnpkg.com/babel-plugin-transform-es2015-for-of/-/babel-plugin-transform-es2015-for-of-6.23.0.tgz -> yarnpkg-babel-plugin-transform-es2015-for-of-6.23.0.tgz
https://registry.yarnpkg.com/babel-plugin-transform-es2015-function-name/-/babel-plugin-transform-es2015-function-name-6.24.1.tgz -> yarnpkg-babel-plugin-transform-es2015-function-name-6.24.1.tgz
https://registry.yarnpkg.com/babel-plugin-transform-es2015-literals/-/babel-plugin-transform-es2015-literals-6.22.0.tgz -> yarnpkg-babel-plugin-transform-es2015-literals-6.22.0.tgz
https://registry.yarnpkg.com/babel-plugin-transform-es2015-modules-amd/-/babel-plugin-transform-es2015-modules-amd-6.24.1.tgz -> yarnpkg-babel-plugin-transform-es2015-modules-amd-6.24.1.tgz
https://registry.yarnpkg.com/babel-plugin-transform-es2015-modules-commonjs/-/babel-plugin-transform-es2015-modules-commonjs-6.26.2.tgz -> yarnpkg-babel-plugin-transform-es2015-modules-commonjs-6.26.2.tgz
https://registry.yarnpkg.com/babel-plugin-transform-es2015-modules-systemjs/-/babel-plugin-transform-es2015-modules-systemjs-6.24.1.tgz -> yarnpkg-babel-plugin-transform-es2015-modules-systemjs-6.24.1.tgz
https://registry.yarnpkg.com/babel-plugin-transform-es2015-modules-umd/-/babel-plugin-transform-es2015-modules-umd-6.24.1.tgz -> yarnpkg-babel-plugin-transform-es2015-modules-umd-6.24.1.tgz
https://registry.yarnpkg.com/babel-plugin-transform-es2015-object-super/-/babel-plugin-transform-es2015-object-super-6.24.1.tgz -> yarnpkg-babel-plugin-transform-es2015-object-super-6.24.1.tgz
https://registry.yarnpkg.com/babel-plugin-transform-es2015-parameters/-/babel-plugin-transform-es2015-parameters-6.24.1.tgz -> yarnpkg-babel-plugin-transform-es2015-parameters-6.24.1.tgz
https://registry.yarnpkg.com/babel-plugin-transform-es2015-shorthand-properties/-/babel-plugin-transform-es2015-shorthand-properties-6.24.1.tgz -> yarnpkg-babel-plugin-transform-es2015-shorthand-properties-6.24.1.tgz
https://registry.yarnpkg.com/babel-plugin-transform-es2015-spread/-/babel-plugin-transform-es2015-spread-6.22.0.tgz -> yarnpkg-babel-plugin-transform-es2015-spread-6.22.0.tgz
https://registry.yarnpkg.com/babel-plugin-transform-es2015-sticky-regex/-/babel-plugin-transform-es2015-sticky-regex-6.24.1.tgz -> yarnpkg-babel-plugin-transform-es2015-sticky-regex-6.24.1.tgz
https://registry.yarnpkg.com/babel-plugin-transform-es2015-template-literals/-/babel-plugin-transform-es2015-template-literals-6.22.0.tgz -> yarnpkg-babel-plugin-transform-es2015-template-literals-6.22.0.tgz
https://registry.yarnpkg.com/babel-plugin-transform-es2015-typeof-symbol/-/babel-plugin-transform-es2015-typeof-symbol-6.23.0.tgz -> yarnpkg-babel-plugin-transform-es2015-typeof-symbol-6.23.0.tgz
https://registry.yarnpkg.com/babel-plugin-transform-es2015-unicode-regex/-/babel-plugin-transform-es2015-unicode-regex-6.24.1.tgz -> yarnpkg-babel-plugin-transform-es2015-unicode-regex-6.24.1.tgz
https://registry.yarnpkg.com/babel-plugin-transform-flow-strip-types/-/babel-plugin-transform-flow-strip-types-6.22.0.tgz -> yarnpkg-babel-plugin-transform-flow-strip-types-6.22.0.tgz
https://registry.yarnpkg.com/babel-plugin-transform-react-display-name/-/babel-plugin-transform-react-display-name-6.25.0.tgz -> yarnpkg-babel-plugin-transform-react-display-name-6.25.0.tgz
https://registry.yarnpkg.com/babel-plugin-transform-react-jsx-self/-/babel-plugin-transform-react-jsx-self-6.22.0.tgz -> yarnpkg-babel-plugin-transform-react-jsx-self-6.22.0.tgz
https://registry.yarnpkg.com/babel-plugin-transform-react-jsx-source/-/babel-plugin-transform-react-jsx-source-6.22.0.tgz -> yarnpkg-babel-plugin-transform-react-jsx-source-6.22.0.tgz
https://registry.yarnpkg.com/babel-plugin-transform-react-jsx/-/babel-plugin-transform-react-jsx-6.24.1.tgz -> yarnpkg-babel-plugin-transform-react-jsx-6.24.1.tgz
https://registry.yarnpkg.com/babel-plugin-transform-regenerator/-/babel-plugin-transform-regenerator-6.26.0.tgz -> yarnpkg-babel-plugin-transform-regenerator-6.26.0.tgz
https://registry.yarnpkg.com/babel-plugin-transform-strict-mode/-/babel-plugin-transform-strict-mode-6.24.1.tgz -> yarnpkg-babel-plugin-transform-strict-mode-6.24.1.tgz
https://registry.yarnpkg.com/babel-preset-es2015/-/babel-preset-es2015-6.24.1.tgz -> yarnpkg-babel-preset-es2015-6.24.1.tgz
https://registry.yarnpkg.com/babel-preset-flow/-/babel-preset-flow-6.23.0.tgz -> yarnpkg-babel-preset-flow-6.23.0.tgz
https://registry.yarnpkg.com/babel-preset-react/-/babel-preset-react-6.24.1.tgz -> yarnpkg-babel-preset-react-6.24.1.tgz
https://registry.yarnpkg.com/babel-register/-/babel-register-6.26.0.tgz -> yarnpkg-babel-register-6.26.0.tgz
https://registry.yarnpkg.com/babel-runtime/-/babel-runtime-6.26.0.tgz -> yarnpkg-babel-runtime-6.26.0.tgz
https://registry.yarnpkg.com/babel-template/-/babel-template-6.26.0.tgz -> yarnpkg-babel-template-6.26.0.tgz
https://registry.yarnpkg.com/babel-traverse/-/babel-traverse-6.26.0.tgz -> yarnpkg-babel-traverse-6.26.0.tgz
https://registry.yarnpkg.com/babel-types/-/babel-types-6.26.0.tgz -> yarnpkg-babel-types-6.26.0.tgz
https://registry.yarnpkg.com/babylon/-/babylon-6.18.0.tgz -> yarnpkg-babylon-6.18.0.tgz
https://registry.yarnpkg.com/balanced-match/-/balanced-match-1.0.0.tgz -> yarnpkg-balanced-match-1.0.0.tgz
https://registry.yarnpkg.com/base64-js/-/base64-js-1.5.1.tgz -> yarnpkg-base64-js-1.5.1.tgz
https://registry.yarnpkg.com/base/-/base-0.11.2.tgz -> yarnpkg-base-0.11.2.tgz
https://registry.yarnpkg.com/bcrypt-pbkdf/-/bcrypt-pbkdf-1.0.2.tgz -> yarnpkg-bcrypt-pbkdf-1.0.2.tgz
https://registry.yarnpkg.com/big.js/-/big.js-5.2.2.tgz -> yarnpkg-big.js-5.2.2.tgz
https://registry.yarnpkg.com/binary-extensions/-/binary-extensions-1.13.1.tgz -> yarnpkg-binary-extensions-1.13.1.tgz
https://registry.yarnpkg.com/binary-extensions/-/binary-extensions-2.2.0.tgz -> yarnpkg-binary-extensions-2.2.0.tgz
https://registry.yarnpkg.com/bindings/-/bindings-1.5.0.tgz -> yarnpkg-bindings-1.5.0.tgz
https://registry.yarnpkg.com/block-stream/-/block-stream-0.0.9.tgz -> yarnpkg-block-stream-0.0.9.tgz
https://registry.yarnpkg.com/bluebird-lst/-/bluebird-lst-1.0.9.tgz -> yarnpkg-bluebird-lst-1.0.9.tgz
https://registry.yarnpkg.com/bluebird/-/bluebird-3.7.2.tgz -> yarnpkg-bluebird-3.7.2.tgz
https://registry.yarnpkg.com/bn.js/-/bn.js-4.12.0.tgz -> yarnpkg-bn.js-4.12.0.tgz
https://registry.yarnpkg.com/bn.js/-/bn.js-5.2.0.tgz -> yarnpkg-bn.js-5.2.0.tgz
https://registry.yarnpkg.com/boolean/-/boolean-3.0.1.tgz -> yarnpkg-boolean-3.0.1.tgz
https://registry.yarnpkg.com/boxen/-/boxen-4.2.0.tgz -> yarnpkg-boxen-4.2.0.tgz
https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-1.1.11.tgz -> yarnpkg-brace-expansion-1.1.11.tgz
https://registry.yarnpkg.com/braces/-/braces-2.3.2.tgz -> yarnpkg-braces-2.3.2.tgz
https://registry.yarnpkg.com/braces/-/braces-3.0.2.tgz -> yarnpkg-braces-3.0.2.tgz
https://registry.yarnpkg.com/brorand/-/brorand-1.1.0.tgz -> yarnpkg-brorand-1.1.0.tgz
https://registry.yarnpkg.com/browser-process-hrtime/-/browser-process-hrtime-1.0.0.tgz -> yarnpkg-browser-process-hrtime-1.0.0.tgz
https://registry.yarnpkg.com/browserify-aes/-/browserify-aes-1.2.0.tgz -> yarnpkg-browserify-aes-1.2.0.tgz
https://registry.yarnpkg.com/browserify-cipher/-/browserify-cipher-1.0.1.tgz -> yarnpkg-browserify-cipher-1.0.1.tgz
https://registry.yarnpkg.com/browserify-des/-/browserify-des-1.0.2.tgz -> yarnpkg-browserify-des-1.0.2.tgz
https://registry.yarnpkg.com/browserify-rsa/-/browserify-rsa-4.1.0.tgz -> yarnpkg-browserify-rsa-4.1.0.tgz
https://registry.yarnpkg.com/browserify-sign/-/browserify-sign-4.2.1.tgz -> yarnpkg-browserify-sign-4.2.1.tgz
https://registry.yarnpkg.com/browserify-zlib/-/browserify-zlib-0.2.0.tgz -> yarnpkg-browserify-zlib-0.2.0.tgz
https://registry.yarnpkg.com/buffer-crc32/-/buffer-crc32-0.2.13.tgz -> yarnpkg-buffer-crc32-0.2.13.tgz
https://registry.yarnpkg.com/buffer-from/-/buffer-from-1.1.1.tgz -> yarnpkg-buffer-from-1.1.1.tgz
https://registry.yarnpkg.com/buffer-xor/-/buffer-xor-1.0.3.tgz -> yarnpkg-buffer-xor-1.0.3.tgz
https://registry.yarnpkg.com/buffer/-/buffer-4.9.2.tgz -> yarnpkg-buffer-4.9.2.tgz
https://registry.yarnpkg.com/builder-util-runtime/-/builder-util-runtime-8.7.0.tgz -> yarnpkg-builder-util-runtime-8.7.0.tgz
https://registry.yarnpkg.com/builder-util-runtime/-/builder-util-runtime-8.7.1.tgz -> yarnpkg-builder-util-runtime-8.7.1.tgz
https://registry.yarnpkg.com/builder-util/-/builder-util-22.7.0.tgz -> yarnpkg-builder-util-22.7.0.tgz
https://registry.yarnpkg.com/builtin-status-codes/-/builtin-status-codes-3.0.0.tgz -> yarnpkg-builtin-status-codes-3.0.0.tgz
https://registry.yarnpkg.com/bytes/-/bytes-3.1.0.tgz -> yarnpkg-bytes-3.1.0.tgz
https://registry.yarnpkg.com/cacache/-/cacache-12.0.4.tgz -> yarnpkg-cacache-12.0.4.tgz
https://registry.yarnpkg.com/cache-base/-/cache-base-1.0.1.tgz -> yarnpkg-cache-base-1.0.1.tgz
https://registry.yarnpkg.com/cacheable-request/-/cacheable-request-6.1.0.tgz -> yarnpkg-cacheable-request-6.1.0.tgz
https://registry.yarnpkg.com/callsites/-/callsites-3.1.0.tgz -> yarnpkg-callsites-3.1.0.tgz
https://registry.yarnpkg.com/camel-case/-/camel-case-4.1.1.tgz -> yarnpkg-camel-case-4.1.1.tgz
https://registry.yarnpkg.com/camelcase-keys/-/camelcase-keys-2.1.0.tgz -> yarnpkg-camelcase-keys-2.1.0.tgz
https://registry.yarnpkg.com/camelcase/-/camelcase-2.1.1.tgz -> yarnpkg-camelcase-2.1.1.tgz
https://registry.yarnpkg.com/camelcase/-/camelcase-5.3.1.tgz -> yarnpkg-camelcase-5.3.1.tgz
https://registry.yarnpkg.com/caseless/-/caseless-0.12.0.tgz -> yarnpkg-caseless-0.12.0.tgz
https://registry.yarnpkg.com/chalk/-/chalk-1.1.3.tgz -> yarnpkg-chalk-1.1.3.tgz
https://registry.yarnpkg.com/chalk/-/chalk-2.4.2.tgz -> yarnpkg-chalk-2.4.2.tgz
https://registry.yarnpkg.com/chalk/-/chalk-3.0.0.tgz -> yarnpkg-chalk-3.0.0.tgz
https://registry.yarnpkg.com/chalk/-/chalk-4.0.0.tgz -> yarnpkg-chalk-4.0.0.tgz
https://registry.yarnpkg.com/chart.js/-/chart.js-1.1.1.tgz -> yarnpkg-chart.js-1.1.1.tgz
https://registry.yarnpkg.com/chokidar/-/chokidar-2.1.8.tgz -> yarnpkg-chokidar-2.1.8.tgz
https://registry.yarnpkg.com/chokidar/-/chokidar-3.5.2.tgz -> yarnpkg-chokidar-3.5.2.tgz
https://registry.yarnpkg.com/chownr/-/chownr-1.1.4.tgz -> yarnpkg-chownr-1.1.4.tgz
https://registry.yarnpkg.com/chrome-trace-event/-/chrome-trace-event-1.0.2.tgz -> yarnpkg-chrome-trace-event-1.0.2.tgz
https://registry.yarnpkg.com/chromium-pickle-js/-/chromium-pickle-js-0.2.0.tgz -> yarnpkg-chromium-pickle-js-0.2.0.tgz
https://registry.yarnpkg.com/ci-info/-/ci-info-2.0.0.tgz -> yarnpkg-ci-info-2.0.0.tgz
https://registry.yarnpkg.com/cipher-base/-/cipher-base-1.0.4.tgz -> yarnpkg-cipher-base-1.0.4.tgz
https://registry.yarnpkg.com/class-utils/-/class-utils-0.3.6.tgz -> yarnpkg-class-utils-0.3.6.tgz
https://registry.yarnpkg.com/classnames/-/classnames-2.2.6.tgz -> yarnpkg-classnames-2.2.6.tgz
https://registry.yarnpkg.com/clean-css/-/clean-css-4.2.3.tgz -> yarnpkg-clean-css-4.2.3.tgz
https://registry.yarnpkg.com/cli-boxes/-/cli-boxes-2.2.0.tgz -> yarnpkg-cli-boxes-2.2.0.tgz
https://registry.yarnpkg.com/cli-truncate/-/cli-truncate-2.1.0.tgz -> yarnpkg-cli-truncate-2.1.0.tgz
https://registry.yarnpkg.com/clipboard/-/clipboard-2.0.6.tgz -> yarnpkg-clipboard-2.0.6.tgz
https://registry.yarnpkg.com/cliui/-/cliui-5.0.0.tgz -> yarnpkg-cliui-5.0.0.tgz
https://registry.yarnpkg.com/cliui/-/cliui-6.0.0.tgz -> yarnpkg-cliui-6.0.0.tgz
https://registry.yarnpkg.com/cliui/-/cliui-7.0.4.tgz -> yarnpkg-cliui-7.0.4.tgz
https://registry.yarnpkg.com/clone-deep/-/clone-deep-4.0.1.tgz -> yarnpkg-clone-deep-4.0.1.tgz
https://registry.yarnpkg.com/clone-response/-/clone-response-1.0.2.tgz -> yarnpkg-clone-response-1.0.2.tgz
https://registry.yarnpkg.com/code-point-at/-/code-point-at-1.1.0.tgz -> yarnpkg-code-point-at-1.1.0.tgz
https://registry.yarnpkg.com/codemirror-one-dark-theme/-/codemirror-one-dark-theme-1.1.1.tgz -> yarnpkg-codemirror-one-dark-theme-1.1.1.tgz
https://registry.yarnpkg.com/codemirror/-/codemirror-5.54.0.tgz -> yarnpkg-codemirror-5.54.0.tgz
https://registry.yarnpkg.com/collection-visit/-/collection-visit-1.0.0.tgz -> yarnpkg-collection-visit-1.0.0.tgz
https://registry.yarnpkg.com/color-convert/-/color-convert-1.9.3.tgz -> yarnpkg-color-convert-1.9.3.tgz
https://registry.yarnpkg.com/color-convert/-/color-convert-2.0.1.tgz -> yarnpkg-color-convert-2.0.1.tgz
https://registry.yarnpkg.com/color-name/-/color-name-1.1.3.tgz -> yarnpkg-color-name-1.1.3.tgz
https://registry.yarnpkg.com/color-name/-/color-name-1.1.4.tgz -> yarnpkg-color-name-1.1.4.tgz
https://registry.yarnpkg.com/colorette/-/colorette-1.2.2.tgz -> yarnpkg-colorette-1.2.2.tgz
https://registry.yarnpkg.com/colors/-/colors-1.0.3.tgz -> yarnpkg-colors-1.0.3.tgz
https://registry.yarnpkg.com/combined-stream/-/combined-stream-1.0.8.tgz -> yarnpkg-combined-stream-1.0.8.tgz
https://registry.yarnpkg.com/commander/-/commander-2.20.3.tgz -> yarnpkg-commander-2.20.3.tgz
https://registry.yarnpkg.com/commander/-/commander-4.1.1.tgz -> yarnpkg-commander-4.1.1.tgz
https://registry.yarnpkg.com/commondir/-/commondir-1.0.1.tgz -> yarnpkg-commondir-1.0.1.tgz
https://registry.yarnpkg.com/component-emitter/-/component-emitter-1.3.0.tgz -> yarnpkg-component-emitter-1.3.0.tgz
https://registry.yarnpkg.com/concat-map/-/concat-map-0.0.1.tgz -> yarnpkg-concat-map-0.0.1.tgz
https://registry.yarnpkg.com/concat-stream/-/concat-stream-1.6.2.tgz -> yarnpkg-concat-stream-1.6.2.tgz
https://registry.yarnpkg.com/config-chain/-/config-chain-1.1.12.tgz -> yarnpkg-config-chain-1.1.12.tgz
https://registry.yarnpkg.com/configstore/-/configstore-5.0.1.tgz -> yarnpkg-configstore-5.0.1.tgz
https://registry.yarnpkg.com/console-browserify/-/console-browserify-1.2.0.tgz -> yarnpkg-console-browserify-1.2.0.tgz
https://registry.yarnpkg.com/console-control-strings/-/console-control-strings-1.1.0.tgz -> yarnpkg-console-control-strings-1.1.0.tgz
https://registry.yarnpkg.com/constants-browserify/-/constants-browserify-1.0.0.tgz -> yarnpkg-constants-browserify-1.0.0.tgz
https://registry.yarnpkg.com/contains-path/-/contains-path-0.1.0.tgz -> yarnpkg-contains-path-0.1.0.tgz
https://registry.yarnpkg.com/convert-source-map/-/convert-source-map-1.7.0.tgz -> yarnpkg-convert-source-map-1.7.0.tgz
https://registry.yarnpkg.com/copy-concurrently/-/copy-concurrently-1.0.5.tgz -> yarnpkg-copy-concurrently-1.0.5.tgz
https://registry.yarnpkg.com/copy-descriptor/-/copy-descriptor-0.1.1.tgz -> yarnpkg-copy-descriptor-0.1.1.tgz
https://registry.yarnpkg.com/core-js-pure/-/core-js-pure-3.6.5.tgz -> yarnpkg-core-js-pure-3.6.5.tgz
https://registry.yarnpkg.com/core-js/-/core-js-1.2.7.tgz -> yarnpkg-core-js-1.2.7.tgz
https://registry.yarnpkg.com/core-js/-/core-js-2.6.11.tgz -> yarnpkg-core-js-2.6.11.tgz
https://registry.yarnpkg.com/core-js/-/core-js-2.6.12.tgz -> yarnpkg-core-js-2.6.12.tgz
https://registry.yarnpkg.com/core-js/-/core-js-3.6.5.tgz -> yarnpkg-core-js-3.6.5.tgz
https://registry.yarnpkg.com/core-util-is/-/core-util-is-1.0.2.tgz -> yarnpkg-core-util-is-1.0.2.tgz
https://registry.yarnpkg.com/create-ecdh/-/create-ecdh-4.0.4.tgz -> yarnpkg-create-ecdh-4.0.4.tgz
https://registry.yarnpkg.com/create-hash/-/create-hash-1.2.0.tgz -> yarnpkg-create-hash-1.2.0.tgz
https://registry.yarnpkg.com/create-hmac/-/create-hmac-1.1.7.tgz -> yarnpkg-create-hmac-1.1.7.tgz
https://registry.yarnpkg.com/create-react-class/-/create-react-class-15.6.3.tgz -> yarnpkg-create-react-class-15.6.3.tgz
https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-3.0.1.tgz -> yarnpkg-cross-spawn-3.0.1.tgz
https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-6.0.5.tgz -> yarnpkg-cross-spawn-6.0.5.tgz
https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-7.0.3.tgz -> yarnpkg-cross-spawn-7.0.3.tgz
https://registry.yarnpkg.com/crypto-browserify/-/crypto-browserify-3.12.0.tgz -> yarnpkg-crypto-browserify-3.12.0.tgz
https://registry.yarnpkg.com/crypto-random-string/-/crypto-random-string-2.0.0.tgz -> yarnpkg-crypto-random-string-2.0.0.tgz
https://registry.yarnpkg.com/css-loader/-/css-loader-5.2.6.tgz -> yarnpkg-css-loader-5.2.6.tgz
https://registry.yarnpkg.com/cssesc/-/cssesc-3.0.0.tgz -> yarnpkg-cssesc-3.0.0.tgz
https://registry.yarnpkg.com/cssom/-/cssom-0.4.4.tgz -> yarnpkg-cssom-0.4.4.tgz
https://registry.yarnpkg.com/cssom/-/cssom-0.3.8.tgz -> yarnpkg-cssom-0.3.8.tgz
https://registry.yarnpkg.com/cssstyle/-/cssstyle-2.3.0.tgz -> yarnpkg-cssstyle-2.3.0.tgz
https://registry.yarnpkg.com/currently-unhandled/-/currently-unhandled-0.4.1.tgz -> yarnpkg-currently-unhandled-0.4.1.tgz
https://registry.yarnpkg.com/cycle/-/cycle-1.0.3.tgz -> yarnpkg-cycle-1.0.3.tgz
https://registry.yarnpkg.com/cyclist/-/cyclist-1.0.1.tgz -> yarnpkg-cyclist-1.0.1.tgz
https://registry.yarnpkg.com/dashdash/-/dashdash-1.14.1.tgz -> yarnpkg-dashdash-1.14.1.tgz
https://registry.yarnpkg.com/data-uri-to-buffer/-/data-uri-to-buffer-3.0.1.tgz -> yarnpkg-data-uri-to-buffer-3.0.1.tgz
https://registry.yarnpkg.com/data-urls/-/data-urls-2.0.0.tgz -> yarnpkg-data-urls-2.0.0.tgz
https://registry.yarnpkg.com/debug/-/debug-4.1.1.tgz -> yarnpkg-debug-4.1.1.tgz
https://registry.yarnpkg.com/debug/-/debug-2.6.9.tgz -> yarnpkg-debug-2.6.9.tgz
https://registry.yarnpkg.com/debug/-/debug-3.2.6.tgz -> yarnpkg-debug-3.2.6.tgz
https://registry.yarnpkg.com/debug/-/debug-4.2.0.tgz -> yarnpkg-debug-4.2.0.tgz
https://registry.yarnpkg.com/debuglog/-/debuglog-1.0.1.tgz -> yarnpkg-debuglog-1.0.1.tgz
https://registry.yarnpkg.com/decamelize/-/decamelize-1.2.0.tgz -> yarnpkg-decamelize-1.2.0.tgz
https://registry.yarnpkg.com/decimal.js/-/decimal.js-10.2.1.tgz -> yarnpkg-decimal.js-10.2.1.tgz
https://registry.yarnpkg.com/decode-uri-component/-/decode-uri-component-0.2.0.tgz -> yarnpkg-decode-uri-component-0.2.0.tgz
https://registry.yarnpkg.com/decompress-response/-/decompress-response-3.3.0.tgz -> yarnpkg-decompress-response-3.3.0.tgz
https://registry.yarnpkg.com/deep-extend/-/deep-extend-0.6.0.tgz -> yarnpkg-deep-extend-0.6.0.tgz
https://registry.yarnpkg.com/deep-is/-/deep-is-0.1.3.tgz -> yarnpkg-deep-is-0.1.3.tgz
https://registry.yarnpkg.com/defer-to-connect/-/defer-to-connect-1.1.3.tgz -> yarnpkg-defer-to-connect-1.1.3.tgz
https://registry.yarnpkg.com/define-properties/-/define-properties-1.1.3.tgz -> yarnpkg-define-properties-1.1.3.tgz
https://registry.yarnpkg.com/define-property/-/define-property-0.2.5.tgz -> yarnpkg-define-property-0.2.5.tgz
https://registry.yarnpkg.com/define-property/-/define-property-1.0.0.tgz -> yarnpkg-define-property-1.0.0.tgz
https://registry.yarnpkg.com/define-property/-/define-property-2.0.2.tgz -> yarnpkg-define-property-2.0.2.tgz
https://registry.yarnpkg.com/degenerator/-/degenerator-2.2.0.tgz -> yarnpkg-degenerator-2.2.0.tgz
https://registry.yarnpkg.com/delayed-stream/-/delayed-stream-1.0.0.tgz -> yarnpkg-delayed-stream-1.0.0.tgz
https://registry.yarnpkg.com/delegate/-/delegate-3.2.0.tgz -> yarnpkg-delegate-3.2.0.tgz
https://registry.yarnpkg.com/delegates/-/delegates-1.0.0.tgz -> yarnpkg-delegates-1.0.0.tgz
https://registry.yarnpkg.com/depd/-/depd-1.1.2.tgz -> yarnpkg-depd-1.1.2.tgz
https://registry.yarnpkg.com/des.js/-/des.js-1.0.1.tgz -> yarnpkg-des.js-1.0.1.tgz
https://registry.yarnpkg.com/detect-file/-/detect-file-1.0.0.tgz -> yarnpkg-detect-file-1.0.0.tgz
https://registry.yarnpkg.com/detect-indent/-/detect-indent-4.0.0.tgz -> yarnpkg-detect-indent-4.0.0.tgz
https://registry.yarnpkg.com/detect-node/-/detect-node-2.0.4.tgz -> yarnpkg-detect-node-2.0.4.tgz
https://registry.yarnpkg.com/dezalgo/-/dezalgo-1.0.3.tgz -> yarnpkg-dezalgo-1.0.3.tgz
https://registry.yarnpkg.com/diffie-hellman/-/diffie-hellman-5.0.3.tgz -> yarnpkg-diffie-hellman-5.0.3.tgz
https://registry.yarnpkg.com/dmg-builder/-/dmg-builder-22.7.0.tgz -> yarnpkg-dmg-builder-22.7.0.tgz
https://registry.yarnpkg.com/doctrine/-/doctrine-1.5.0.tgz -> yarnpkg-doctrine-1.5.0.tgz
https://registry.yarnpkg.com/doctrine/-/doctrine-2.1.0.tgz -> yarnpkg-doctrine-2.1.0.tgz
https://registry.yarnpkg.com/doctrine/-/doctrine-3.0.0.tgz -> yarnpkg-doctrine-3.0.0.tgz
https://registry.yarnpkg.com/dom-helpers/-/dom-helpers-3.4.0.tgz -> yarnpkg-dom-helpers-3.4.0.tgz
https://registry.yarnpkg.com/domain-browser/-/domain-browser-1.2.0.tgz -> yarnpkg-domain-browser-1.2.0.tgz
https://registry.yarnpkg.com/domexception/-/domexception-2.0.1.tgz -> yarnpkg-domexception-2.0.1.tgz
https://registry.yarnpkg.com/dompurify/-/dompurify-2.2.9.tgz -> yarnpkg-dompurify-2.2.9.tgz
https://registry.yarnpkg.com/dot-case/-/dot-case-3.0.3.tgz -> yarnpkg-dot-case-3.0.3.tgz
https://registry.yarnpkg.com/dot-prop/-/dot-prop-5.2.0.tgz -> yarnpkg-dot-prop-5.2.0.tgz
https://registry.yarnpkg.com/dotenv-expand/-/dotenv-expand-5.1.0.tgz -> yarnpkg-dotenv-expand-5.1.0.tgz
https://registry.yarnpkg.com/dotenv/-/dotenv-8.2.0.tgz -> yarnpkg-dotenv-8.2.0.tgz
https://registry.yarnpkg.com/duplexer3/-/duplexer3-0.1.4.tgz -> yarnpkg-duplexer3-0.1.4.tgz
https://registry.yarnpkg.com/duplexify/-/duplexify-3.7.1.tgz -> yarnpkg-duplexify-3.7.1.tgz
https://registry.yarnpkg.com/ecc-jsbn/-/ecc-jsbn-0.1.2.tgz -> yarnpkg-ecc-jsbn-0.1.2.tgz
https://registry.yarnpkg.com/ejs/-/ejs-3.1.3.tgz -> yarnpkg-ejs-3.1.3.tgz
https://registry.yarnpkg.com/electron-builder/-/electron-builder-22.7.0.tgz -> yarnpkg-electron-builder-22.7.0.tgz
https://registry.yarnpkg.com/electron-context-menu/-/electron-context-menu-3.1.0.tgz -> yarnpkg-electron-context-menu-3.1.0.tgz
https://registry.yarnpkg.com/electron-dl/-/electron-dl-3.2.1.tgz -> yarnpkg-electron-dl-3.2.1.tgz
https://registry.yarnpkg.com/electron-is-accelerator/-/electron-is-accelerator-0.1.2.tgz -> yarnpkg-electron-is-accelerator-0.1.2.tgz
https://registry.yarnpkg.com/electron-is-dev/-/electron-is-dev-2.0.0.tgz -> yarnpkg-electron-is-dev-2.0.0.tgz
https://registry.yarnpkg.com/electron-json-storage-sync/-/electron-json-storage-sync-1.1.1.tgz -> yarnpkg-electron-json-storage-sync-1.1.1.tgz
https://registry.yarnpkg.com/electron-localshortcut/-/electron-localshortcut-3.2.1.tgz -> yarnpkg-electron-localshortcut-3.2.1.tgz
https://registry.yarnpkg.com/electron-publish/-/electron-publish-22.7.0.tgz -> yarnpkg-electron-publish-22.7.0.tgz
https://registry.yarnpkg.com/electron-updater/-/electron-updater-4.3.1.tgz -> yarnpkg-electron-updater-4.3.1.tgz
https://registry.yarnpkg.com/electron-window-state/-/electron-window-state-5.0.3.tgz -> yarnpkg-electron-window-state-5.0.3.tgz
https://registry.yarnpkg.com/electron/-/electron-13.1.2.tgz -> yarnpkg-electron-13.1.2.tgz
https://registry.yarnpkg.com/elliptic/-/elliptic-6.5.4.tgz -> yarnpkg-elliptic-6.5.4.tgz
https://registry.yarnpkg.com/emoji-regex/-/emoji-regex-7.0.3.tgz -> yarnpkg-emoji-regex-7.0.3.tgz
https://registry.yarnpkg.com/emoji-regex/-/emoji-regex-8.0.0.tgz -> yarnpkg-emoji-regex-8.0.0.tgz
https://registry.yarnpkg.com/emojis-list/-/emojis-list-3.0.0.tgz -> yarnpkg-emojis-list-3.0.0.tgz
https://registry.yarnpkg.com/encodeurl/-/encodeurl-1.0.2.tgz -> yarnpkg-encodeurl-1.0.2.tgz
https://registry.yarnpkg.com/encoding/-/encoding-0.1.12.tgz -> yarnpkg-encoding-0.1.12.tgz
https://registry.yarnpkg.com/end-of-stream/-/end-of-stream-1.4.4.tgz -> yarnpkg-end-of-stream-1.4.4.tgz
https://registry.yarnpkg.com/enhanced-resolve/-/enhanced-resolve-4.5.0.tgz -> yarnpkg-enhanced-resolve-4.5.0.tgz
https://registry.yarnpkg.com/enquirer/-/enquirer-2.3.6.tgz -> yarnpkg-enquirer-2.3.6.tgz
https://registry.yarnpkg.com/entities/-/entities-2.1.0.tgz -> yarnpkg-entities-2.1.0.tgz
https://registry.yarnpkg.com/env-paths/-/env-paths-2.2.0.tgz -> yarnpkg-env-paths-2.2.0.tgz
https://registry.yarnpkg.com/errno/-/errno-0.1.8.tgz -> yarnpkg-errno-0.1.8.tgz
https://registry.yarnpkg.com/error-ex/-/error-ex-1.3.2.tgz -> yarnpkg-error-ex-1.3.2.tgz
https://registry.yarnpkg.com/es-abstract/-/es-abstract-1.17.5.tgz -> yarnpkg-es-abstract-1.17.5.tgz
https://registry.yarnpkg.com/es-to-primitive/-/es-to-primitive-1.2.1.tgz -> yarnpkg-es-to-primitive-1.2.1.tgz
https://registry.yarnpkg.com/es6-error/-/es6-error-4.1.1.tgz -> yarnpkg-es6-error-4.1.1.tgz
https://registry.yarnpkg.com/escalade/-/escalade-3.1.1.tgz -> yarnpkg-escalade-3.1.1.tgz
https://registry.yarnpkg.com/escape-goat/-/escape-goat-2.1.1.tgz -> yarnpkg-escape-goat-2.1.1.tgz
https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> yarnpkg-escape-string-regexp-1.0.5.tgz
https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz -> yarnpkg-escape-string-regexp-4.0.0.tgz
https://registry.yarnpkg.com/escodegen/-/escodegen-1.14.3.tgz -> yarnpkg-escodegen-1.14.3.tgz
https://registry.yarnpkg.com/escodegen/-/escodegen-2.0.0.tgz -> yarnpkg-escodegen-2.0.0.tgz
https://registry.yarnpkg.com/eslint-config-standard/-/eslint-config-standard-16.0.3.tgz -> yarnpkg-eslint-config-standard-16.0.3.tgz
https://registry.yarnpkg.com/eslint-import-resolver-node/-/eslint-import-resolver-node-0.3.3.tgz -> yarnpkg-eslint-import-resolver-node-0.3.3.tgz
https://registry.yarnpkg.com/eslint-module-utils/-/eslint-module-utils-2.6.0.tgz -> yarnpkg-eslint-module-utils-2.6.0.tgz
https://registry.yarnpkg.com/eslint-plugin-es/-/eslint-plugin-es-3.0.1.tgz -> yarnpkg-eslint-plugin-es-3.0.1.tgz
https://registry.yarnpkg.com/eslint-plugin-import/-/eslint-plugin-import-2.20.2.tgz -> yarnpkg-eslint-plugin-import-2.20.2.tgz
https://registry.yarnpkg.com/eslint-plugin-node/-/eslint-plugin-node-11.1.0.tgz -> yarnpkg-eslint-plugin-node-11.1.0.tgz
https://registry.yarnpkg.com/eslint-plugin-promise/-/eslint-plugin-promise-5.1.0.tgz -> yarnpkg-eslint-plugin-promise-5.1.0.tgz
https://registry.yarnpkg.com/eslint-plugin-react/-/eslint-plugin-react-7.20.0.tgz -> yarnpkg-eslint-plugin-react-7.20.0.tgz
https://registry.yarnpkg.com/eslint-plugin-standard/-/eslint-plugin-standard-5.0.0.tgz -> yarnpkg-eslint-plugin-standard-5.0.0.tgz
https://registry.yarnpkg.com/eslint-scope/-/eslint-scope-4.0.3.tgz -> yarnpkg-eslint-scope-4.0.3.tgz
https://registry.yarnpkg.com/eslint-scope/-/eslint-scope-5.1.1.tgz -> yarnpkg-eslint-scope-5.1.1.tgz
https://registry.yarnpkg.com/eslint-utils/-/eslint-utils-2.0.0.tgz -> yarnpkg-eslint-utils-2.0.0.tgz
https://registry.yarnpkg.com/eslint-utils/-/eslint-utils-2.1.0.tgz -> yarnpkg-eslint-utils-2.1.0.tgz
https://registry.yarnpkg.com/eslint-visitor-keys/-/eslint-visitor-keys-1.2.0.tgz -> yarnpkg-eslint-visitor-keys-1.2.0.tgz
https://registry.yarnpkg.com/eslint-visitor-keys/-/eslint-visitor-keys-1.3.0.tgz -> yarnpkg-eslint-visitor-keys-1.3.0.tgz
https://registry.yarnpkg.com/eslint-visitor-keys/-/eslint-visitor-keys-2.1.0.tgz -> yarnpkg-eslint-visitor-keys-2.1.0.tgz
https://registry.yarnpkg.com/eslint/-/eslint-7.28.0.tgz -> yarnpkg-eslint-7.28.0.tgz
https://registry.yarnpkg.com/espree/-/espree-7.3.1.tgz -> yarnpkg-espree-7.3.1.tgz
https://registry.yarnpkg.com/esprima/-/esprima-4.0.1.tgz -> yarnpkg-esprima-4.0.1.tgz
https://registry.yarnpkg.com/esquery/-/esquery-1.4.0.tgz -> yarnpkg-esquery-1.4.0.tgz
https://registry.yarnpkg.com/esrecurse/-/esrecurse-4.3.0.tgz -> yarnpkg-esrecurse-4.3.0.tgz
https://registry.yarnpkg.com/estraverse/-/estraverse-4.3.0.tgz -> yarnpkg-estraverse-4.3.0.tgz
https://registry.yarnpkg.com/estraverse/-/estraverse-5.1.0.tgz -> yarnpkg-estraverse-5.1.0.tgz
https://registry.yarnpkg.com/estraverse/-/estraverse-5.2.0.tgz -> yarnpkg-estraverse-5.2.0.tgz
https://registry.yarnpkg.com/esutils/-/esutils-2.0.3.tgz -> yarnpkg-esutils-2.0.3.tgz
https://registry.yarnpkg.com/events/-/events-3.3.0.tgz -> yarnpkg-events-3.3.0.tgz
https://registry.yarnpkg.com/evp_bytestokey/-/evp_bytestokey-1.0.3.tgz -> yarnpkg-evp_bytestokey-1.0.3.tgz
https://registry.yarnpkg.com/expand-brackets/-/expand-brackets-2.1.4.tgz -> yarnpkg-expand-brackets-2.1.4.tgz
https://registry.yarnpkg.com/expand-tilde/-/expand-tilde-2.0.2.tgz -> yarnpkg-expand-tilde-2.0.2.tgz
https://registry.yarnpkg.com/ext-list/-/ext-list-2.2.2.tgz -> yarnpkg-ext-list-2.2.2.tgz
https://registry.yarnpkg.com/ext-name/-/ext-name-5.0.0.tgz -> yarnpkg-ext-name-5.0.0.tgz
https://registry.yarnpkg.com/extend-shallow/-/extend-shallow-2.0.1.tgz -> yarnpkg-extend-shallow-2.0.1.tgz
https://registry.yarnpkg.com/extend-shallow/-/extend-shallow-3.0.2.tgz -> yarnpkg-extend-shallow-3.0.2.tgz
https://registry.yarnpkg.com/extend/-/extend-3.0.2.tgz -> yarnpkg-extend-3.0.2.tgz
https://registry.yarnpkg.com/extglob/-/extglob-2.0.4.tgz -> yarnpkg-extglob-2.0.4.tgz
https://registry.yarnpkg.com/extract-zip/-/extract-zip-1.7.0.tgz -> yarnpkg-extract-zip-1.7.0.tgz
https://registry.yarnpkg.com/extsprintf/-/extsprintf-1.3.0.tgz -> yarnpkg-extsprintf-1.3.0.tgz
https://registry.yarnpkg.com/extsprintf/-/extsprintf-1.4.0.tgz -> yarnpkg-extsprintf-1.4.0.tgz
https://registry.yarnpkg.com/eyes/-/eyes-0.1.8.tgz -> yarnpkg-eyes-0.1.8.tgz
https://registry.yarnpkg.com/fast-deep-equal/-/fast-deep-equal-3.1.1.tgz -> yarnpkg-fast-deep-equal-3.1.1.tgz
https://registry.yarnpkg.com/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz -> yarnpkg-fast-deep-equal-3.1.3.tgz
https://registry.yarnpkg.com/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz -> yarnpkg-fast-json-stable-stringify-2.1.0.tgz
https://registry.yarnpkg.com/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz -> yarnpkg-fast-levenshtein-2.0.6.tgz
https://registry.yarnpkg.com/fbjs/-/fbjs-0.8.17.tgz -> yarnpkg-fbjs-0.8.17.tgz
https://registry.yarnpkg.com/fd-slicer/-/fd-slicer-1.1.0.tgz -> yarnpkg-fd-slicer-1.1.0.tgz
https://registry.yarnpkg.com/figgy-pudding/-/figgy-pudding-3.5.2.tgz -> yarnpkg-figgy-pudding-3.5.2.tgz
https://registry.yarnpkg.com/file-entry-cache/-/file-entry-cache-6.0.1.tgz -> yarnpkg-file-entry-cache-6.0.1.tgz
https://registry.yarnpkg.com/file-loader/-/file-loader-6.0.0.tgz -> yarnpkg-file-loader-6.0.0.tgz
https://registry.yarnpkg.com/file-uri-to-path/-/file-uri-to-path-1.0.0.tgz -> yarnpkg-file-uri-to-path-1.0.0.tgz
https://registry.yarnpkg.com/file-uri-to-path/-/file-uri-to-path-2.0.0.tgz -> yarnpkg-file-uri-to-path-2.0.0.tgz
https://registry.yarnpkg.com/filelist/-/filelist-1.0.1.tgz -> yarnpkg-filelist-1.0.1.tgz
https://registry.yarnpkg.com/filename-reserved-regex/-/filename-reserved-regex-2.0.0.tgz -> yarnpkg-filename-reserved-regex-2.0.0.tgz
https://registry.yarnpkg.com/fill-range/-/fill-range-4.0.0.tgz -> yarnpkg-fill-range-4.0.0.tgz
https://registry.yarnpkg.com/fill-range/-/fill-range-7.0.1.tgz -> yarnpkg-fill-range-7.0.1.tgz
https://registry.yarnpkg.com/find-cache-dir/-/find-cache-dir-1.0.0.tgz -> yarnpkg-find-cache-dir-1.0.0.tgz
https://registry.yarnpkg.com/find-cache-dir/-/find-cache-dir-2.1.0.tgz -> yarnpkg-find-cache-dir-2.1.0.tgz
https://registry.yarnpkg.com/find-up/-/find-up-1.1.2.tgz -> yarnpkg-find-up-1.1.2.tgz
https://registry.yarnpkg.com/find-up/-/find-up-2.1.0.tgz -> yarnpkg-find-up-2.1.0.tgz
https://registry.yarnpkg.com/find-up/-/find-up-3.0.0.tgz -> yarnpkg-find-up-3.0.0.tgz
https://registry.yarnpkg.com/find-up/-/find-up-4.1.0.tgz -> yarnpkg-find-up-4.1.0.tgz
https://registry.yarnpkg.com/findup-sync/-/findup-sync-3.0.0.tgz -> yarnpkg-findup-sync-3.0.0.tgz
https://registry.yarnpkg.com/flat-cache/-/flat-cache-3.0.4.tgz -> yarnpkg-flat-cache-3.0.4.tgz
https://registry.yarnpkg.com/flatted/-/flatted-3.1.1.tgz -> yarnpkg-flatted-3.1.1.tgz
https://registry.yarnpkg.com/flush-write-stream/-/flush-write-stream-1.1.1.tgz -> yarnpkg-flush-write-stream-1.1.1.tgz
https://registry.yarnpkg.com/for-in/-/for-in-1.0.2.tgz -> yarnpkg-for-in-1.0.2.tgz
https://registry.yarnpkg.com/forever-agent/-/forever-agent-0.6.1.tgz -> yarnpkg-forever-agent-0.6.1.tgz
https://registry.yarnpkg.com/form-data/-/form-data-3.0.1.tgz -> yarnpkg-form-data-3.0.1.tgz
https://registry.yarnpkg.com/form-data/-/form-data-2.3.3.tgz -> yarnpkg-form-data-2.3.3.tgz
https://registry.yarnpkg.com/fragment-cache/-/fragment-cache-0.2.1.tgz -> yarnpkg-fragment-cache-0.2.1.tgz
https://registry.yarnpkg.com/from2/-/from2-2.3.0.tgz -> yarnpkg-from2-2.3.0.tgz
https://registry.yarnpkg.com/fs-extra/-/fs-extra-8.1.0.tgz -> yarnpkg-fs-extra-8.1.0.tgz
https://registry.yarnpkg.com/fs-extra/-/fs-extra-9.0.1.tgz -> yarnpkg-fs-extra-9.0.1.tgz
https://registry.yarnpkg.com/fs-write-stream-atomic/-/fs-write-stream-atomic-1.0.10.tgz -> yarnpkg-fs-write-stream-atomic-1.0.10.tgz
https://registry.yarnpkg.com/fs.realpath/-/fs.realpath-1.0.0.tgz -> yarnpkg-fs.realpath-1.0.0.tgz
https://registry.yarnpkg.com/fsevents/-/fsevents-1.2.13.tgz -> yarnpkg-fsevents-1.2.13.tgz
https://registry.yarnpkg.com/fsevents/-/fsevents-2.3.2.tgz -> yarnpkg-fsevents-2.3.2.tgz
https://registry.yarnpkg.com/fstream/-/fstream-1.0.12.tgz -> yarnpkg-fstream-1.0.12.tgz
https://registry.yarnpkg.com/ftp/-/ftp-0.3.10.tgz -> yarnpkg-ftp-0.3.10.tgz
https://registry.yarnpkg.com/function-bind/-/function-bind-1.1.1.tgz -> yarnpkg-function-bind-1.1.1.tgz
https://registry.yarnpkg.com/functional-red-black-tree/-/functional-red-black-tree-1.0.1.tgz -> yarnpkg-functional-red-black-tree-1.0.1.tgz
https://registry.yarnpkg.com/fuse.js/-/fuse.js-3.6.1.tgz -> yarnpkg-fuse.js-3.6.1.tgz
https://registry.yarnpkg.com/gauge/-/gauge-2.7.4.tgz -> yarnpkg-gauge-2.7.4.tgz
https://registry.yarnpkg.com/gaze/-/gaze-1.1.3.tgz -> yarnpkg-gaze-1.1.3.tgz
https://registry.yarnpkg.com/get-caller-file/-/get-caller-file-2.0.5.tgz -> yarnpkg-get-caller-file-2.0.5.tgz
https://registry.yarnpkg.com/get-stdin/-/get-stdin-4.0.1.tgz -> yarnpkg-get-stdin-4.0.1.tgz
https://registry.yarnpkg.com/get-stream/-/get-stream-4.1.0.tgz -> yarnpkg-get-stream-4.1.0.tgz
https://registry.yarnpkg.com/get-stream/-/get-stream-5.1.0.tgz -> yarnpkg-get-stream-5.1.0.tgz
https://registry.yarnpkg.com/get-uri/-/get-uri-3.0.2.tgz -> yarnpkg-get-uri-3.0.2.tgz
https://registry.yarnpkg.com/get-value/-/get-value-2.0.6.tgz -> yarnpkg-get-value-2.0.6.tgz
https://registry.yarnpkg.com/getpass/-/getpass-0.1.7.tgz -> yarnpkg-getpass-0.1.7.tgz
https://registry.yarnpkg.com/glob-parent/-/glob-parent-3.1.0.tgz -> yarnpkg-glob-parent-3.1.0.tgz
https://registry.yarnpkg.com/glob-parent/-/glob-parent-5.1.2.tgz -> yarnpkg-glob-parent-5.1.2.tgz
https://registry.yarnpkg.com/glob/-/glob-7.1.6.tgz -> yarnpkg-glob-7.1.6.tgz
https://registry.yarnpkg.com/glob/-/glob-7.1.7.tgz -> yarnpkg-glob-7.1.7.tgz
https://registry.yarnpkg.com/global-agent/-/global-agent-2.1.12.tgz -> yarnpkg-global-agent-2.1.12.tgz
https://registry.yarnpkg.com/global-dirs/-/global-dirs-2.0.1.tgz -> yarnpkg-global-dirs-2.0.1.tgz
https://registry.yarnpkg.com/global-modules/-/global-modules-1.0.0.tgz -> yarnpkg-global-modules-1.0.0.tgz
https://registry.yarnpkg.com/global-modules/-/global-modules-2.0.0.tgz -> yarnpkg-global-modules-2.0.0.tgz
https://registry.yarnpkg.com/global-prefix/-/global-prefix-1.0.2.tgz -> yarnpkg-global-prefix-1.0.2.tgz
https://registry.yarnpkg.com/global-prefix/-/global-prefix-3.0.0.tgz -> yarnpkg-global-prefix-3.0.0.tgz
https://registry.yarnpkg.com/global-tunnel-ng/-/global-tunnel-ng-2.7.1.tgz -> yarnpkg-global-tunnel-ng-2.7.1.tgz
https://registry.yarnpkg.com/globals/-/globals-11.12.0.tgz -> yarnpkg-globals-11.12.0.tgz
https://registry.yarnpkg.com/globals/-/globals-13.9.0.tgz -> yarnpkg-globals-13.9.0.tgz
https://registry.yarnpkg.com/globals/-/globals-9.18.0.tgz -> yarnpkg-globals-9.18.0.tgz
https://registry.yarnpkg.com/globalthis/-/globalthis-1.0.1.tgz -> yarnpkg-globalthis-1.0.1.tgz
https://registry.yarnpkg.com/globule/-/globule-1.3.1.tgz -> yarnpkg-globule-1.3.1.tgz
https://registry.yarnpkg.com/good-listener/-/good-listener-1.2.2.tgz -> yarnpkg-good-listener-1.2.2.tgz
https://registry.yarnpkg.com/got/-/got-9.6.0.tgz -> yarnpkg-got-9.6.0.tgz
https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-4.2.6.tgz -> yarnpkg-graceful-fs-4.2.6.tgz
https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-4.2.4.tgz -> yarnpkg-graceful-fs-4.2.4.tgz
https://registry.yarnpkg.com/har-schema/-/har-schema-2.0.0.tgz -> yarnpkg-har-schema-2.0.0.tgz
https://registry.yarnpkg.com/har-validator/-/har-validator-5.1.3.tgz -> yarnpkg-har-validator-5.1.3.tgz
https://registry.yarnpkg.com/has-ansi/-/has-ansi-2.0.0.tgz -> yarnpkg-has-ansi-2.0.0.tgz
https://registry.yarnpkg.com/has-flag/-/has-flag-3.0.0.tgz -> yarnpkg-has-flag-3.0.0.tgz
https://registry.yarnpkg.com/has-flag/-/has-flag-4.0.0.tgz -> yarnpkg-has-flag-4.0.0.tgz
https://registry.yarnpkg.com/has-symbols/-/has-symbols-1.0.1.tgz -> yarnpkg-has-symbols-1.0.1.tgz
https://registry.yarnpkg.com/has-unicode/-/has-unicode-2.0.1.tgz -> yarnpkg-has-unicode-2.0.1.tgz
https://registry.yarnpkg.com/has-value/-/has-value-0.3.1.tgz -> yarnpkg-has-value-0.3.1.tgz
https://registry.yarnpkg.com/has-value/-/has-value-1.0.0.tgz -> yarnpkg-has-value-1.0.0.tgz
https://registry.yarnpkg.com/has-values/-/has-values-0.1.4.tgz -> yarnpkg-has-values-0.1.4.tgz
https://registry.yarnpkg.com/has-values/-/has-values-1.0.0.tgz -> yarnpkg-has-values-1.0.0.tgz
https://registry.yarnpkg.com/has-yarn/-/has-yarn-2.1.0.tgz -> yarnpkg-has-yarn-2.1.0.tgz
https://registry.yarnpkg.com/has/-/has-1.0.3.tgz -> yarnpkg-has-1.0.3.tgz
https://registry.yarnpkg.com/hash-base/-/hash-base-3.1.0.tgz -> yarnpkg-hash-base-3.1.0.tgz
https://registry.yarnpkg.com/hash.js/-/hash.js-1.1.7.tgz -> yarnpkg-hash.js-1.1.7.tgz
https://registry.yarnpkg.com/he/-/he-1.2.0.tgz -> yarnpkg-he-1.2.0.tgz
https://registry.yarnpkg.com/highlight.js/-/highlight.js-11.0.1.tgz -> yarnpkg-highlight.js-11.0.1.tgz
https://registry.yarnpkg.com/highlightjs-graphql/-/highlightjs-graphql-1.0.2.tgz -> yarnpkg-highlightjs-graphql-1.0.2.tgz
https://registry.yarnpkg.com/highlightjs-solidity/-/highlightjs-solidity-1.0.16.tgz -> yarnpkg-highlightjs-solidity-1.0.16.tgz
https://registry.yarnpkg.com/hmac-drbg/-/hmac-drbg-1.0.1.tgz -> yarnpkg-hmac-drbg-1.0.1.tgz
https://registry.yarnpkg.com/hoist-non-react-statics/-/hoist-non-react-statics-3.3.2.tgz -> yarnpkg-hoist-non-react-statics-3.3.2.tgz
https://registry.yarnpkg.com/home-or-tmp/-/home-or-tmp-2.0.0.tgz -> yarnpkg-home-or-tmp-2.0.0.tgz
https://registry.yarnpkg.com/homedir-polyfill/-/homedir-polyfill-1.0.3.tgz -> yarnpkg-homedir-polyfill-1.0.3.tgz
https://registry.yarnpkg.com/hosted-git-info/-/hosted-git-info-2.8.8.tgz -> yarnpkg-hosted-git-info-2.8.8.tgz
https://registry.yarnpkg.com/hosted-git-info/-/hosted-git-info-3.0.4.tgz -> yarnpkg-hosted-git-info-3.0.4.tgz
https://registry.yarnpkg.com/html-encoding-sniffer/-/html-encoding-sniffer-2.0.1.tgz -> yarnpkg-html-encoding-sniffer-2.0.1.tgz
https://registry.yarnpkg.com/html-loader/-/html-loader-2.1.2.tgz -> yarnpkg-html-loader-2.1.2.tgz
https://registry.yarnpkg.com/html-minifier-terser/-/html-minifier-terser-5.1.1.tgz -> yarnpkg-html-minifier-terser-5.1.1.tgz
https://registry.yarnpkg.com/http-cache-semantics/-/http-cache-semantics-4.1.0.tgz -> yarnpkg-http-cache-semantics-4.1.0.tgz
https://registry.yarnpkg.com/http-errors/-/http-errors-1.7.3.tgz -> yarnpkg-http-errors-1.7.3.tgz
https://registry.yarnpkg.com/http-proxy-agent/-/http-proxy-agent-4.0.1.tgz -> yarnpkg-http-proxy-agent-4.0.1.tgz
https://registry.yarnpkg.com/http-signature/-/http-signature-1.2.0.tgz -> yarnpkg-http-signature-1.2.0.tgz
https://registry.yarnpkg.com/https-browserify/-/https-browserify-1.0.0.tgz -> yarnpkg-https-browserify-1.0.0.tgz
https://registry.yarnpkg.com/https-proxy-agent/-/https-proxy-agent-5.0.0.tgz -> yarnpkg-https-proxy-agent-5.0.0.tgz
https://registry.yarnpkg.com/human-readable-time/-/human-readable-time-0.3.0.tgz -> yarnpkg-human-readable-time-0.3.0.tgz
https://registry.yarnpkg.com/iconv-lite/-/iconv-lite-0.4.24.tgz -> yarnpkg-iconv-lite-0.4.24.tgz
https://registry.yarnpkg.com/iconv-lite/-/iconv-lite-0.5.1.tgz -> yarnpkg-iconv-lite-0.5.1.tgz
https://registry.yarnpkg.com/icss-utils/-/icss-utils-5.1.0.tgz -> yarnpkg-icss-utils-5.1.0.tgz
https://registry.yarnpkg.com/ieee754/-/ieee754-1.2.1.tgz -> yarnpkg-ieee754-1.2.1.tgz
https://registry.yarnpkg.com/iferr/-/iferr-0.1.5.tgz -> yarnpkg-iferr-0.1.5.tgz
https://registry.yarnpkg.com/ignore/-/ignore-4.0.6.tgz -> yarnpkg-ignore-4.0.6.tgz
https://registry.yarnpkg.com/ignore/-/ignore-5.1.8.tgz -> yarnpkg-ignore-5.1.8.tgz
https://registry.yarnpkg.com/import-fresh/-/import-fresh-3.2.1.tgz -> yarnpkg-import-fresh-3.2.1.tgz
https://registry.yarnpkg.com/import-fresh/-/import-fresh-3.3.0.tgz -> yarnpkg-import-fresh-3.3.0.tgz
https://registry.yarnpkg.com/import-lazy/-/import-lazy-2.1.0.tgz -> yarnpkg-import-lazy-2.1.0.tgz
https://registry.yarnpkg.com/import-local/-/import-local-2.0.0.tgz -> yarnpkg-import-local-2.0.0.tgz
https://registry.yarnpkg.com/imurmurhash/-/imurmurhash-0.1.4.tgz -> yarnpkg-imurmurhash-0.1.4.tgz
https://registry.yarnpkg.com/in-publish/-/in-publish-2.0.1.tgz -> yarnpkg-in-publish-2.0.1.tgz
https://registry.yarnpkg.com/indent-string/-/indent-string-2.1.0.tgz -> yarnpkg-indent-string-2.1.0.tgz
https://registry.yarnpkg.com/indexes-of/-/indexes-of-1.0.1.tgz -> yarnpkg-indexes-of-1.0.1.tgz
https://registry.yarnpkg.com/infer-owner/-/infer-owner-1.0.4.tgz -> yarnpkg-infer-owner-1.0.4.tgz
https://registry.yarnpkg.com/inflight/-/inflight-1.0.6.tgz -> yarnpkg-inflight-1.0.6.tgz
https://registry.yarnpkg.com/inherits/-/inherits-2.0.4.tgz -> yarnpkg-inherits-2.0.4.tgz
https://registry.yarnpkg.com/inherits/-/inherits-2.0.1.tgz -> yarnpkg-inherits-2.0.1.tgz
https://registry.yarnpkg.com/inherits/-/inherits-2.0.3.tgz -> yarnpkg-inherits-2.0.3.tgz
https://registry.yarnpkg.com/ini/-/ini-1.3.5.tgz -> yarnpkg-ini-1.3.5.tgz
https://registry.yarnpkg.com/ini/-/ini-2.0.0.tgz -> yarnpkg-ini-2.0.0.tgz
https://registry.yarnpkg.com/internal-slot/-/internal-slot-1.0.2.tgz -> yarnpkg-internal-slot-1.0.2.tgz
https://registry.yarnpkg.com/interpret/-/interpret-1.4.0.tgz -> yarnpkg-interpret-1.4.0.tgz
https://registry.yarnpkg.com/invariant/-/invariant-2.2.4.tgz -> yarnpkg-invariant-2.2.4.tgz
https://registry.yarnpkg.com/ip/-/ip-1.1.5.tgz -> yarnpkg-ip-1.1.5.tgz
https://registry.yarnpkg.com/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz -> yarnpkg-is-accessor-descriptor-0.1.6.tgz
https://registry.yarnpkg.com/is-accessor-descriptor/-/is-accessor-descriptor-1.0.0.tgz -> yarnpkg-is-accessor-descriptor-1.0.0.tgz
https://registry.yarnpkg.com/is-arrayish/-/is-arrayish-0.2.1.tgz -> yarnpkg-is-arrayish-0.2.1.tgz
https://registry.yarnpkg.com/is-binary-path/-/is-binary-path-1.0.1.tgz -> yarnpkg-is-binary-path-1.0.1.tgz
https://registry.yarnpkg.com/is-binary-path/-/is-binary-path-2.1.0.tgz -> yarnpkg-is-binary-path-2.1.0.tgz
https://registry.yarnpkg.com/is-buffer/-/is-buffer-1.1.6.tgz -> yarnpkg-is-buffer-1.1.6.tgz
https://registry.yarnpkg.com/is-callable/-/is-callable-1.2.0.tgz -> yarnpkg-is-callable-1.2.0.tgz
https://registry.yarnpkg.com/is-ci/-/is-ci-2.0.0.tgz -> yarnpkg-is-ci-2.0.0.tgz
https://registry.yarnpkg.com/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz -> yarnpkg-is-data-descriptor-0.1.4.tgz
https://registry.yarnpkg.com/is-data-descriptor/-/is-data-descriptor-1.0.0.tgz -> yarnpkg-is-data-descriptor-1.0.0.tgz
https://registry.yarnpkg.com/is-date-object/-/is-date-object-1.0.2.tgz -> yarnpkg-is-date-object-1.0.2.tgz
https://registry.yarnpkg.com/is-descriptor/-/is-descriptor-0.1.6.tgz -> yarnpkg-is-descriptor-0.1.6.tgz
https://registry.yarnpkg.com/is-descriptor/-/is-descriptor-1.0.2.tgz -> yarnpkg-is-descriptor-1.0.2.tgz
https://registry.yarnpkg.com/is-extendable/-/is-extendable-0.1.1.tgz -> yarnpkg-is-extendable-0.1.1.tgz
https://registry.yarnpkg.com/is-extendable/-/is-extendable-1.0.1.tgz -> yarnpkg-is-extendable-1.0.1.tgz
https://registry.yarnpkg.com/is-extglob/-/is-extglob-2.1.1.tgz -> yarnpkg-is-extglob-2.1.1.tgz
https://registry.yarnpkg.com/is-finite/-/is-finite-1.1.0.tgz -> yarnpkg-is-finite-1.1.0.tgz
https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-1.0.0.tgz -> yarnpkg-is-fullwidth-code-point-1.0.0.tgz
https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> yarnpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> yarnpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.yarnpkg.com/is-glob/-/is-glob-3.1.0.tgz -> yarnpkg-is-glob-3.1.0.tgz
https://registry.yarnpkg.com/is-glob/-/is-glob-4.0.1.tgz -> yarnpkg-is-glob-4.0.1.tgz
https://registry.yarnpkg.com/is-installed-globally/-/is-installed-globally-0.3.2.tgz -> yarnpkg-is-installed-globally-0.3.2.tgz
https://registry.yarnpkg.com/is-npm/-/is-npm-4.0.0.tgz -> yarnpkg-is-npm-4.0.0.tgz
https://registry.yarnpkg.com/is-number/-/is-number-3.0.0.tgz -> yarnpkg-is-number-3.0.0.tgz
https://registry.yarnpkg.com/is-number/-/is-number-7.0.0.tgz -> yarnpkg-is-number-7.0.0.tgz
https://registry.yarnpkg.com/is-obj/-/is-obj-2.0.0.tgz -> yarnpkg-is-obj-2.0.0.tgz
https://registry.yarnpkg.com/is-path-inside/-/is-path-inside-3.0.2.tgz -> yarnpkg-is-path-inside-3.0.2.tgz
https://registry.yarnpkg.com/is-plain-obj/-/is-plain-obj-1.1.0.tgz -> yarnpkg-is-plain-obj-1.1.0.tgz
https://registry.yarnpkg.com/is-plain-object/-/is-plain-object-2.0.4.tgz -> yarnpkg-is-plain-object-2.0.4.tgz
https://registry.yarnpkg.com/is-potential-custom-element-name/-/is-potential-custom-element-name-1.0.1.tgz -> yarnpkg-is-potential-custom-element-name-1.0.1.tgz
https://registry.yarnpkg.com/is-promise/-/is-promise-2.2.2.tgz -> yarnpkg-is-promise-2.2.2.tgz
https://registry.yarnpkg.com/is-regex/-/is-regex-1.1.0.tgz -> yarnpkg-is-regex-1.1.0.tgz
https://registry.yarnpkg.com/is-stream/-/is-stream-1.1.0.tgz -> yarnpkg-is-stream-1.1.0.tgz
https://registry.yarnpkg.com/is-string/-/is-string-1.0.5.tgz -> yarnpkg-is-string-1.0.5.tgz
https://registry.yarnpkg.com/is-symbol/-/is-symbol-1.0.3.tgz -> yarnpkg-is-symbol-1.0.3.tgz
https://registry.yarnpkg.com/is-typedarray/-/is-typedarray-1.0.0.tgz -> yarnpkg-is-typedarray-1.0.0.tgz
https://registry.yarnpkg.com/is-utf8/-/is-utf8-0.2.1.tgz -> yarnpkg-is-utf8-0.2.1.tgz
https://registry.yarnpkg.com/is-windows/-/is-windows-1.0.2.tgz -> yarnpkg-is-windows-1.0.2.tgz
https://registry.yarnpkg.com/is-wsl/-/is-wsl-1.1.0.tgz -> yarnpkg-is-wsl-1.1.0.tgz
https://registry.yarnpkg.com/is-yarn-global/-/is-yarn-global-0.3.0.tgz -> yarnpkg-is-yarn-global-0.3.0.tgz
https://registry.yarnpkg.com/isarray/-/isarray-0.0.1.tgz -> yarnpkg-isarray-0.0.1.tgz
https://registry.yarnpkg.com/isarray/-/isarray-1.0.0.tgz -> yarnpkg-isarray-1.0.0.tgz
https://registry.yarnpkg.com/isbinaryfile/-/isbinaryfile-4.0.6.tgz -> yarnpkg-isbinaryfile-4.0.6.tgz
https://registry.yarnpkg.com/isexe/-/isexe-2.0.0.tgz -> yarnpkg-isexe-2.0.0.tgz
https://registry.yarnpkg.com/isobject/-/isobject-2.1.0.tgz -> yarnpkg-isobject-2.1.0.tgz
https://registry.yarnpkg.com/isobject/-/isobject-3.0.1.tgz -> yarnpkg-isobject-3.0.1.tgz
https://registry.yarnpkg.com/isomorphic-fetch/-/isomorphic-fetch-2.2.1.tgz -> yarnpkg-isomorphic-fetch-2.2.1.tgz
https://registry.yarnpkg.com/isstream/-/isstream-0.1.2.tgz -> yarnpkg-isstream-0.1.2.tgz
https://registry.yarnpkg.com/jake/-/jake-10.8.1.tgz -> yarnpkg-jake-10.8.1.tgz
https://registry.yarnpkg.com/js-base64/-/js-base64-2.5.2.tgz -> yarnpkg-js-base64-2.5.2.tgz
https://registry.yarnpkg.com/js-tokens/-/js-tokens-4.0.0.tgz -> yarnpkg-js-tokens-4.0.0.tgz
https://registry.yarnpkg.com/js-tokens/-/js-tokens-3.0.2.tgz -> yarnpkg-js-tokens-3.0.2.tgz
https://registry.yarnpkg.com/js-yaml/-/js-yaml-3.14.0.tgz -> yarnpkg-js-yaml-3.14.0.tgz
https://registry.yarnpkg.com/jsbn/-/jsbn-0.1.1.tgz -> yarnpkg-jsbn-0.1.1.tgz
https://registry.yarnpkg.com/jsdom/-/jsdom-16.6.0.tgz -> yarnpkg-jsdom-16.6.0.tgz
https://registry.yarnpkg.com/jsesc/-/jsesc-1.3.0.tgz -> yarnpkg-jsesc-1.3.0.tgz
https://registry.yarnpkg.com/jsesc/-/jsesc-2.5.2.tgz -> yarnpkg-jsesc-2.5.2.tgz
https://registry.yarnpkg.com/jsesc/-/jsesc-0.5.0.tgz -> yarnpkg-jsesc-0.5.0.tgz
https://registry.yarnpkg.com/json-buffer/-/json-buffer-3.0.0.tgz -> yarnpkg-json-buffer-3.0.0.tgz
https://registry.yarnpkg.com/json-loader/-/json-loader-0.5.7.tgz -> yarnpkg-json-loader-0.5.7.tgz
https://registry.yarnpkg.com/json-parse-better-errors/-/json-parse-better-errors-1.0.2.tgz -> yarnpkg-json-parse-better-errors-1.0.2.tgz
https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz -> yarnpkg-json-schema-traverse-0.4.1.tgz
https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz -> yarnpkg-json-schema-traverse-1.0.0.tgz
https://registry.yarnpkg.com/json-schema/-/json-schema-0.2.3.tgz -> yarnpkg-json-schema-0.2.3.tgz
https://registry.yarnpkg.com/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz -> yarnpkg-json-stable-stringify-without-jsonify-1.0.1.tgz
https://registry.yarnpkg.com/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz -> yarnpkg-json-stringify-safe-5.0.1.tgz
https://registry.yarnpkg.com/json5/-/json5-0.5.1.tgz -> yarnpkg-json5-0.5.1.tgz
https://registry.yarnpkg.com/json5/-/json5-1.0.1.tgz -> yarnpkg-json5-1.0.1.tgz
https://registry.yarnpkg.com/json5/-/json5-2.1.3.tgz -> yarnpkg-json5-2.1.3.tgz
https://registry.yarnpkg.com/jsonfile/-/jsonfile-4.0.0.tgz -> yarnpkg-jsonfile-4.0.0.tgz
https://registry.yarnpkg.com/jsonfile/-/jsonfile-6.0.1.tgz -> yarnpkg-jsonfile-6.0.1.tgz
https://registry.yarnpkg.com/jsprim/-/jsprim-1.4.1.tgz -> yarnpkg-jsprim-1.4.1.tgz
https://registry.yarnpkg.com/jsx-ast-utils/-/jsx-ast-utils-2.3.0.tgz -> yarnpkg-jsx-ast-utils-2.3.0.tgz
https://registry.yarnpkg.com/katex/-/katex-0.6.0.tgz -> yarnpkg-katex-0.6.0.tgz
https://registry.yarnpkg.com/keyboardevent-from-electron-accelerator/-/keyboardevent-from-electron-accelerator-2.0.0.tgz -> yarnpkg-keyboardevent-from-electron-accelerator-2.0.0.tgz
https://registry.yarnpkg.com/keyboardevents-areequal/-/keyboardevents-areequal-0.2.2.tgz -> yarnpkg-keyboardevents-areequal-0.2.2.tgz
https://registry.yarnpkg.com/keycode/-/keycode-2.2.0.tgz -> yarnpkg-keycode-2.2.0.tgz
https://registry.yarnpkg.com/keyv/-/keyv-3.1.0.tgz -> yarnpkg-keyv-3.1.0.tgz
https://registry.yarnpkg.com/kind-of/-/kind-of-3.2.2.tgz -> yarnpkg-kind-of-3.2.2.tgz
https://registry.yarnpkg.com/kind-of/-/kind-of-4.0.0.tgz -> yarnpkg-kind-of-4.0.0.tgz
https://registry.yarnpkg.com/kind-of/-/kind-of-5.1.0.tgz -> yarnpkg-kind-of-5.1.0.tgz
https://registry.yarnpkg.com/kind-of/-/kind-of-6.0.3.tgz -> yarnpkg-kind-of-6.0.3.tgz
https://registry.yarnpkg.com/latest-version/-/latest-version-5.1.0.tgz -> yarnpkg-latest-version-5.1.0.tgz
https://registry.yarnpkg.com/lazy-val/-/lazy-val-1.0.4.tgz -> yarnpkg-lazy-val-1.0.4.tgz
https://registry.yarnpkg.com/levn/-/levn-0.4.1.tgz -> yarnpkg-levn-0.4.1.tgz
https://registry.yarnpkg.com/levn/-/levn-0.3.0.tgz -> yarnpkg-levn-0.3.0.tgz
https://registry.yarnpkg.com/license-checker/-/license-checker-25.0.1.tgz -> yarnpkg-license-checker-25.0.1.tgz
https://registry.yarnpkg.com/linkify-it/-/linkify-it-3.0.2.tgz -> yarnpkg-linkify-it-3.0.2.tgz
https://registry.yarnpkg.com/load-json-file/-/load-json-file-1.1.0.tgz -> yarnpkg-load-json-file-1.1.0.tgz
https://registry.yarnpkg.com/load-json-file/-/load-json-file-2.0.0.tgz -> yarnpkg-load-json-file-2.0.0.tgz
https://registry.yarnpkg.com/loader-runner/-/loader-runner-2.4.0.tgz -> yarnpkg-loader-runner-2.4.0.tgz
https://registry.yarnpkg.com/loader-utils/-/loader-utils-1.4.0.tgz -> yarnpkg-loader-utils-1.4.0.tgz
https://registry.yarnpkg.com/loader-utils/-/loader-utils-2.0.0.tgz -> yarnpkg-loader-utils-2.0.0.tgz
https://registry.yarnpkg.com/locate-path/-/locate-path-2.0.0.tgz -> yarnpkg-locate-path-2.0.0.tgz
https://registry.yarnpkg.com/locate-path/-/locate-path-3.0.0.tgz -> yarnpkg-locate-path-3.0.0.tgz
https://registry.yarnpkg.com/locate-path/-/locate-path-5.0.0.tgz -> yarnpkg-locate-path-5.0.0.tgz
https://registry.yarnpkg.com/lodash.clonedeep/-/lodash.clonedeep-4.5.0.tgz -> yarnpkg-lodash.clonedeep-4.5.0.tgz
https://registry.yarnpkg.com/lodash.debounce/-/lodash.debounce-4.0.8.tgz -> yarnpkg-lodash.debounce-4.0.8.tgz
https://registry.yarnpkg.com/lodash.isequal/-/lodash.isequal-4.5.0.tgz -> yarnpkg-lodash.isequal-4.5.0.tgz
https://registry.yarnpkg.com/lodash.merge/-/lodash.merge-4.6.2.tgz -> yarnpkg-lodash.merge-4.6.2.tgz
https://registry.yarnpkg.com/lodash.sortby/-/lodash.sortby-4.7.0.tgz -> yarnpkg-lodash.sortby-4.7.0.tgz
https://registry.yarnpkg.com/lodash.truncate/-/lodash.truncate-4.4.2.tgz -> yarnpkg-lodash.truncate-4.4.2.tgz
https://registry.yarnpkg.com/lodash/-/lodash-4.17.15.tgz -> yarnpkg-lodash-4.17.15.tgz
https://registry.yarnpkg.com/lodash/-/lodash-4.17.21.tgz -> yarnpkg-lodash-4.17.21.tgz
https://registry.yarnpkg.com/loose-envify/-/loose-envify-1.4.0.tgz -> yarnpkg-loose-envify-1.4.0.tgz
https://registry.yarnpkg.com/loud-rejection/-/loud-rejection-1.6.0.tgz -> yarnpkg-loud-rejection-1.6.0.tgz
https://registry.yarnpkg.com/lower-case/-/lower-case-2.0.1.tgz -> yarnpkg-lower-case-2.0.1.tgz
https://registry.yarnpkg.com/lowercase-keys/-/lowercase-keys-1.0.1.tgz -> yarnpkg-lowercase-keys-1.0.1.tgz
https://registry.yarnpkg.com/lowercase-keys/-/lowercase-keys-2.0.0.tgz -> yarnpkg-lowercase-keys-2.0.0.tgz
https://registry.yarnpkg.com/lru-cache/-/lru-cache-4.1.5.tgz -> yarnpkg-lru-cache-4.1.5.tgz
https://registry.yarnpkg.com/lru-cache/-/lru-cache-5.1.1.tgz -> yarnpkg-lru-cache-5.1.1.tgz
https://registry.yarnpkg.com/lru-cache/-/lru-cache-6.0.0.tgz -> yarnpkg-lru-cache-6.0.0.tgz
https://registry.yarnpkg.com/make-dir/-/make-dir-1.3.0.tgz -> yarnpkg-make-dir-1.3.0.tgz
https://registry.yarnpkg.com/make-dir/-/make-dir-2.1.0.tgz -> yarnpkg-make-dir-2.1.0.tgz
https://registry.yarnpkg.com/make-dir/-/make-dir-3.1.0.tgz -> yarnpkg-make-dir-3.1.0.tgz
https://registry.yarnpkg.com/map-cache/-/map-cache-0.2.2.tgz -> yarnpkg-map-cache-0.2.2.tgz
https://registry.yarnpkg.com/map-obj/-/map-obj-1.0.1.tgz -> yarnpkg-map-obj-1.0.1.tgz
https://registry.yarnpkg.com/map-visit/-/map-visit-1.0.0.tgz -> yarnpkg-map-visit-1.0.0.tgz
https://registry.yarnpkg.com/markdown-it-katex/-/markdown-it-katex-2.0.3.tgz -> yarnpkg-markdown-it-katex-2.0.3.tgz
https://registry.yarnpkg.com/markdown-it-task-lists/-/markdown-it-task-lists-2.1.1.tgz -> yarnpkg-markdown-it-task-lists-2.1.1.tgz
https://registry.yarnpkg.com/markdown-it/-/markdown-it-12.0.6.tgz -> yarnpkg-markdown-it-12.0.6.tgz
https://registry.yarnpkg.com/marked/-/marked-2.0.7.tgz -> yarnpkg-marked-2.0.7.tgz
https://registry.yarnpkg.com/match-at/-/match-at-0.1.1.tgz -> yarnpkg-match-at-0.1.1.tgz
https://registry.yarnpkg.com/matcher/-/matcher-3.0.0.tgz -> yarnpkg-matcher-3.0.0.tgz
https://registry.yarnpkg.com/md5.js/-/md5.js-1.3.5.tgz -> yarnpkg-md5.js-1.3.5.tgz
https://registry.yarnpkg.com/mdurl/-/mdurl-1.0.1.tgz -> yarnpkg-mdurl-1.0.1.tgz
https://registry.yarnpkg.com/memory-fs/-/memory-fs-0.4.1.tgz -> yarnpkg-memory-fs-0.4.1.tgz
https://registry.yarnpkg.com/memory-fs/-/memory-fs-0.5.0.tgz -> yarnpkg-memory-fs-0.5.0.tgz
https://registry.yarnpkg.com/meow/-/meow-3.7.0.tgz -> yarnpkg-meow-3.7.0.tgz
https://registry.yarnpkg.com/micromatch/-/micromatch-3.1.10.tgz -> yarnpkg-micromatch-3.1.10.tgz
https://registry.yarnpkg.com/miller-rabin/-/miller-rabin-4.0.1.tgz -> yarnpkg-miller-rabin-4.0.1.tgz
https://registry.yarnpkg.com/mime-db/-/mime-db-1.44.0.tgz -> yarnpkg-mime-db-1.44.0.tgz
https://registry.yarnpkg.com/mime-types/-/mime-types-2.1.27.tgz -> yarnpkg-mime-types-2.1.27.tgz
https://registry.yarnpkg.com/mime/-/mime-2.4.6.tgz -> yarnpkg-mime-2.4.6.tgz
https://registry.yarnpkg.com/mimic-response/-/mimic-response-1.0.1.tgz -> yarnpkg-mimic-response-1.0.1.tgz
https://registry.yarnpkg.com/minimalistic-assert/-/minimalistic-assert-1.0.1.tgz -> yarnpkg-minimalistic-assert-1.0.1.tgz
https://registry.yarnpkg.com/minimalistic-crypto-utils/-/minimalistic-crypto-utils-1.0.1.tgz -> yarnpkg-minimalistic-crypto-utils-1.0.1.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-3.0.4.tgz -> yarnpkg-minimatch-3.0.4.tgz
https://registry.yarnpkg.com/minimist/-/minimist-1.2.5.tgz -> yarnpkg-minimist-1.2.5.tgz
https://registry.yarnpkg.com/mississippi/-/mississippi-3.0.0.tgz -> yarnpkg-mississippi-3.0.0.tgz
https://registry.yarnpkg.com/mixin-deep/-/mixin-deep-1.3.2.tgz -> yarnpkg-mixin-deep-1.3.2.tgz
https://registry.yarnpkg.com/mkdirp/-/mkdirp-0.5.5.tgz -> yarnpkg-mkdirp-0.5.5.tgz
https://registry.yarnpkg.com/modify-filename/-/modify-filename-1.1.0.tgz -> yarnpkg-modify-filename-1.1.0.tgz
https://registry.yarnpkg.com/moment/-/moment-2.26.0.tgz -> yarnpkg-moment-2.26.0.tgz
https://registry.yarnpkg.com/move-concurrently/-/move-concurrently-1.0.1.tgz -> yarnpkg-move-concurrently-1.0.1.tgz
https://registry.yarnpkg.com/ms/-/ms-2.0.0.tgz -> yarnpkg-ms-2.0.0.tgz
https://registry.yarnpkg.com/ms/-/ms-2.1.2.tgz -> yarnpkg-ms-2.1.2.tgz
https://registry.yarnpkg.com/nan/-/nan-2.14.2.tgz -> yarnpkg-nan-2.14.2.tgz
https://registry.yarnpkg.com/nan/-/nan-2.14.1.tgz -> yarnpkg-nan-2.14.1.tgz
https://registry.yarnpkg.com/nanoid/-/nanoid-3.1.23.tgz -> yarnpkg-nanoid-3.1.23.tgz
https://registry.yarnpkg.com/nanomatch/-/nanomatch-1.2.13.tgz -> yarnpkg-nanomatch-1.2.13.tgz
https://registry.yarnpkg.com/natural-compare/-/natural-compare-1.4.0.tgz -> yarnpkg-natural-compare-1.4.0.tgz
https://registry.yarnpkg.com/nconf/-/nconf-0.11.2.tgz -> yarnpkg-nconf-0.11.2.tgz
https://registry.yarnpkg.com/neo-async/-/neo-async-2.6.2.tgz -> yarnpkg-neo-async-2.6.2.tgz
https://registry.yarnpkg.com/netmask/-/netmask-2.0.2.tgz -> yarnpkg-netmask-2.0.2.tgz
https://registry.yarnpkg.com/nice-try/-/nice-try-1.0.5.tgz -> yarnpkg-nice-try-1.0.5.tgz
https://registry.yarnpkg.com/no-case/-/no-case-3.0.3.tgz -> yarnpkg-no-case-3.0.3.tgz
https://registry.yarnpkg.com/node-fetch/-/node-fetch-1.7.3.tgz -> yarnpkg-node-fetch-1.7.3.tgz
https://registry.yarnpkg.com/node-gyp/-/node-gyp-3.8.0.tgz -> yarnpkg-node-gyp-3.8.0.tgz
https://registry.yarnpkg.com/node-libs-browser/-/node-libs-browser-2.2.1.tgz -> yarnpkg-node-libs-browser-2.2.1.tgz
https://registry.yarnpkg.com/node-sass/-/node-sass-4.14.1.tgz -> yarnpkg-node-sass-4.14.1.tgz
https://registry.yarnpkg.com/nopt/-/nopt-3.0.6.tgz -> yarnpkg-nopt-3.0.6.tgz
https://registry.yarnpkg.com/nopt/-/nopt-4.0.3.tgz -> yarnpkg-nopt-4.0.3.tgz
https://registry.yarnpkg.com/normalize-package-data/-/normalize-package-data-2.5.0.tgz -> yarnpkg-normalize-package-data-2.5.0.tgz
https://registry.yarnpkg.com/normalize-path/-/normalize-path-2.1.1.tgz -> yarnpkg-normalize-path-2.1.1.tgz
https://registry.yarnpkg.com/normalize-path/-/normalize-path-3.0.0.tgz -> yarnpkg-normalize-path-3.0.0.tgz
https://registry.yarnpkg.com/normalize-url/-/normalize-url-4.5.0.tgz -> yarnpkg-normalize-url-4.5.0.tgz
https://registry.yarnpkg.com/notebookjs/-/notebookjs-0.6.4.tgz -> yarnpkg-notebookjs-0.6.4.tgz
https://registry.yarnpkg.com/npm-conf/-/npm-conf-1.1.3.tgz -> yarnpkg-npm-conf-1.1.3.tgz
https://registry.yarnpkg.com/npm-normalize-package-bin/-/npm-normalize-package-bin-1.0.1.tgz -> yarnpkg-npm-normalize-package-bin-1.0.1.tgz
https://registry.yarnpkg.com/npmlog/-/npmlog-4.1.2.tgz -> yarnpkg-npmlog-4.1.2.tgz
https://registry.yarnpkg.com/number-is-nan/-/number-is-nan-1.0.1.tgz -> yarnpkg-number-is-nan-1.0.1.tgz
https://registry.yarnpkg.com/nwsapi/-/nwsapi-2.2.0.tgz -> yarnpkg-nwsapi-2.2.0.tgz
https://registry.yarnpkg.com/oauth-sign/-/oauth-sign-0.9.0.tgz -> yarnpkg-oauth-sign-0.9.0.tgz
https://registry.yarnpkg.com/object-assign/-/object-assign-4.1.1.tgz -> yarnpkg-object-assign-4.1.1.tgz
https://registry.yarnpkg.com/object-copy/-/object-copy-0.1.0.tgz -> yarnpkg-object-copy-0.1.0.tgz
https://registry.yarnpkg.com/object-inspect/-/object-inspect-1.7.0.tgz -> yarnpkg-object-inspect-1.7.0.tgz
https://registry.yarnpkg.com/object-keys/-/object-keys-1.1.1.tgz -> yarnpkg-object-keys-1.1.1.tgz
https://registry.yarnpkg.com/object-visit/-/object-visit-1.0.1.tgz -> yarnpkg-object-visit-1.0.1.tgz
https://registry.yarnpkg.com/object.assign/-/object.assign-4.1.0.tgz -> yarnpkg-object.assign-4.1.0.tgz
https://registry.yarnpkg.com/object.entries/-/object.entries-1.1.2.tgz -> yarnpkg-object.entries-1.1.2.tgz
https://registry.yarnpkg.com/object.fromentries/-/object.fromentries-2.0.2.tgz -> yarnpkg-object.fromentries-2.0.2.tgz
https://registry.yarnpkg.com/object.pick/-/object.pick-1.3.0.tgz -> yarnpkg-object.pick-1.3.0.tgz
https://registry.yarnpkg.com/object.values/-/object.values-1.1.1.tgz -> yarnpkg-object.values-1.1.1.tgz
https://registry.yarnpkg.com/once/-/once-1.4.0.tgz -> yarnpkg-once-1.4.0.tgz
https://registry.yarnpkg.com/optionator/-/optionator-0.8.3.tgz -> yarnpkg-optionator-0.8.3.tgz
https://registry.yarnpkg.com/optionator/-/optionator-0.9.1.tgz -> yarnpkg-optionator-0.9.1.tgz
https://registry.yarnpkg.com/os-browserify/-/os-browserify-0.3.0.tgz -> yarnpkg-os-browserify-0.3.0.tgz
https://registry.yarnpkg.com/os-homedir/-/os-homedir-1.0.2.tgz -> yarnpkg-os-homedir-1.0.2.tgz
https://registry.yarnpkg.com/os-tmpdir/-/os-tmpdir-1.0.2.tgz -> yarnpkg-os-tmpdir-1.0.2.tgz
https://registry.yarnpkg.com/osenv/-/osenv-0.1.5.tgz -> yarnpkg-osenv-0.1.5.tgz
https://registry.yarnpkg.com/p-cancelable/-/p-cancelable-1.1.0.tgz -> yarnpkg-p-cancelable-1.1.0.tgz
https://registry.yarnpkg.com/p-limit/-/p-limit-1.3.0.tgz -> yarnpkg-p-limit-1.3.0.tgz
https://registry.yarnpkg.com/p-limit/-/p-limit-2.3.0.tgz -> yarnpkg-p-limit-2.3.0.tgz
https://registry.yarnpkg.com/p-locate/-/p-locate-2.0.0.tgz -> yarnpkg-p-locate-2.0.0.tgz
https://registry.yarnpkg.com/p-locate/-/p-locate-3.0.0.tgz -> yarnpkg-p-locate-3.0.0.tgz
https://registry.yarnpkg.com/p-locate/-/p-locate-4.1.0.tgz -> yarnpkg-p-locate-4.1.0.tgz
https://registry.yarnpkg.com/p-try/-/p-try-1.0.0.tgz -> yarnpkg-p-try-1.0.0.tgz
https://registry.yarnpkg.com/p-try/-/p-try-2.2.0.tgz -> yarnpkg-p-try-2.2.0.tgz
https://registry.yarnpkg.com/pac-proxy-agent/-/pac-proxy-agent-4.1.0.tgz -> yarnpkg-pac-proxy-agent-4.1.0.tgz
https://registry.yarnpkg.com/pac-resolver/-/pac-resolver-4.2.0.tgz -> yarnpkg-pac-resolver-4.2.0.tgz
https://registry.yarnpkg.com/package-json/-/package-json-6.5.0.tgz -> yarnpkg-package-json-6.5.0.tgz
https://registry.yarnpkg.com/pako/-/pako-1.0.11.tgz -> yarnpkg-pako-1.0.11.tgz
https://registry.yarnpkg.com/parallel-transform/-/parallel-transform-1.2.0.tgz -> yarnpkg-parallel-transform-1.2.0.tgz
https://registry.yarnpkg.com/param-case/-/param-case-3.0.3.tgz -> yarnpkg-param-case-3.0.3.tgz
https://registry.yarnpkg.com/parent-module/-/parent-module-1.0.1.tgz -> yarnpkg-parent-module-1.0.1.tgz
https://registry.yarnpkg.com/parse-asn1/-/parse-asn1-5.1.6.tgz -> yarnpkg-parse-asn1-5.1.6.tgz
https://registry.yarnpkg.com/parse-json/-/parse-json-2.2.0.tgz -> yarnpkg-parse-json-2.2.0.tgz
https://registry.yarnpkg.com/parse-passwd/-/parse-passwd-1.0.0.tgz -> yarnpkg-parse-passwd-1.0.0.tgz
https://registry.yarnpkg.com/parse5/-/parse5-6.0.1.tgz -> yarnpkg-parse5-6.0.1.tgz
https://registry.yarnpkg.com/pascal-case/-/pascal-case-3.1.1.tgz -> yarnpkg-pascal-case-3.1.1.tgz
https://registry.yarnpkg.com/pascalcase/-/pascalcase-0.1.1.tgz -> yarnpkg-pascalcase-0.1.1.tgz
https://registry.yarnpkg.com/path-browserify/-/path-browserify-0.0.1.tgz -> yarnpkg-path-browserify-0.0.1.tgz
https://registry.yarnpkg.com/path-dirname/-/path-dirname-1.0.2.tgz -> yarnpkg-path-dirname-1.0.2.tgz
https://registry.yarnpkg.com/path-exists/-/path-exists-2.1.0.tgz -> yarnpkg-path-exists-2.1.0.tgz
https://registry.yarnpkg.com/path-exists/-/path-exists-3.0.0.tgz -> yarnpkg-path-exists-3.0.0.tgz
https://registry.yarnpkg.com/path-exists/-/path-exists-4.0.0.tgz -> yarnpkg-path-exists-4.0.0.tgz
https://registry.yarnpkg.com/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> yarnpkg-path-is-absolute-1.0.1.tgz
https://registry.yarnpkg.com/path-key/-/path-key-2.0.1.tgz -> yarnpkg-path-key-2.0.1.tgz
https://registry.yarnpkg.com/path-key/-/path-key-3.1.1.tgz -> yarnpkg-path-key-3.1.1.tgz
https://registry.yarnpkg.com/path-parse/-/path-parse-1.0.6.tgz -> yarnpkg-path-parse-1.0.6.tgz
https://registry.yarnpkg.com/path-type/-/path-type-1.1.0.tgz -> yarnpkg-path-type-1.1.0.tgz
https://registry.yarnpkg.com/path-type/-/path-type-2.0.0.tgz -> yarnpkg-path-type-2.0.0.tgz
https://registry.yarnpkg.com/pbkdf2/-/pbkdf2-3.1.2.tgz -> yarnpkg-pbkdf2-3.1.2.tgz
https://registry.yarnpkg.com/pend/-/pend-1.2.0.tgz -> yarnpkg-pend-1.2.0.tgz
https://registry.yarnpkg.com/performance-now/-/performance-now-2.1.0.tgz -> yarnpkg-performance-now-2.1.0.tgz
https://registry.yarnpkg.com/picomatch/-/picomatch-2.3.0.tgz -> yarnpkg-picomatch-2.3.0.tgz
https://registry.yarnpkg.com/pify/-/pify-2.3.0.tgz -> yarnpkg-pify-2.3.0.tgz
https://registry.yarnpkg.com/pify/-/pify-3.0.0.tgz -> yarnpkg-pify-3.0.0.tgz
https://registry.yarnpkg.com/pify/-/pify-4.0.1.tgz -> yarnpkg-pify-4.0.1.tgz
https://registry.yarnpkg.com/pinkie-promise/-/pinkie-promise-2.0.1.tgz -> yarnpkg-pinkie-promise-2.0.1.tgz
https://registry.yarnpkg.com/pinkie/-/pinkie-2.0.4.tgz -> yarnpkg-pinkie-2.0.4.tgz
https://registry.yarnpkg.com/pkg-dir/-/pkg-dir-2.0.0.tgz -> yarnpkg-pkg-dir-2.0.0.tgz
https://registry.yarnpkg.com/pkg-dir/-/pkg-dir-3.0.0.tgz -> yarnpkg-pkg-dir-3.0.0.tgz
https://registry.yarnpkg.com/posix-character-classes/-/posix-character-classes-0.1.1.tgz -> yarnpkg-posix-character-classes-0.1.1.tgz
https://registry.yarnpkg.com/postcss-modules-extract-imports/-/postcss-modules-extract-imports-3.0.0.tgz -> yarnpkg-postcss-modules-extract-imports-3.0.0.tgz
https://registry.yarnpkg.com/postcss-modules-local-by-default/-/postcss-modules-local-by-default-4.0.0.tgz -> yarnpkg-postcss-modules-local-by-default-4.0.0.tgz
https://registry.yarnpkg.com/postcss-modules-scope/-/postcss-modules-scope-3.0.0.tgz -> yarnpkg-postcss-modules-scope-3.0.0.tgz
https://registry.yarnpkg.com/postcss-modules-values/-/postcss-modules-values-4.0.0.tgz -> yarnpkg-postcss-modules-values-4.0.0.tgz
https://registry.yarnpkg.com/postcss-selector-parser/-/postcss-selector-parser-6.0.2.tgz -> yarnpkg-postcss-selector-parser-6.0.2.tgz
https://registry.yarnpkg.com/postcss-selector-parser/-/postcss-selector-parser-6.0.6.tgz -> yarnpkg-postcss-selector-parser-6.0.6.tgz
https://registry.yarnpkg.com/postcss-value-parser/-/postcss-value-parser-4.1.0.tgz -> yarnpkg-postcss-value-parser-4.1.0.tgz
https://registry.yarnpkg.com/postcss/-/postcss-8.3.2.tgz -> yarnpkg-postcss-8.3.2.tgz
https://registry.yarnpkg.com/prelude-ls/-/prelude-ls-1.2.1.tgz -> yarnpkg-prelude-ls-1.2.1.tgz
https://registry.yarnpkg.com/prelude-ls/-/prelude-ls-1.1.2.tgz -> yarnpkg-prelude-ls-1.1.2.tgz
https://registry.yarnpkg.com/prepend-http/-/prepend-http-2.0.0.tgz -> yarnpkg-prepend-http-2.0.0.tgz
https://registry.yarnpkg.com/prismjs/-/prismjs-1.20.0.tgz -> yarnpkg-prismjs-1.20.0.tgz
https://registry.yarnpkg.com/private/-/private-0.1.8.tgz -> yarnpkg-private-0.1.8.tgz
https://registry.yarnpkg.com/process-nextick-args/-/process-nextick-args-2.0.1.tgz -> yarnpkg-process-nextick-args-2.0.1.tgz
https://registry.yarnpkg.com/process/-/process-0.11.10.tgz -> yarnpkg-process-0.11.10.tgz
https://registry.yarnpkg.com/progress/-/progress-2.0.3.tgz -> yarnpkg-progress-2.0.3.tgz
https://registry.yarnpkg.com/promise-inflight/-/promise-inflight-1.0.1.tgz -> yarnpkg-promise-inflight-1.0.1.tgz
https://registry.yarnpkg.com/promise/-/promise-7.3.1.tgz -> yarnpkg-promise-7.3.1.tgz
https://registry.yarnpkg.com/prop-types-extra/-/prop-types-extra-1.1.1.tgz -> yarnpkg-prop-types-extra-1.1.1.tgz
https://registry.yarnpkg.com/prop-types/-/prop-types-15.7.2.tgz -> yarnpkg-prop-types-15.7.2.tgz
https://registry.yarnpkg.com/proto-list/-/proto-list-1.2.4.tgz -> yarnpkg-proto-list-1.2.4.tgz
https://registry.yarnpkg.com/proxy-agent/-/proxy-agent-4.0.1.tgz -> yarnpkg-proxy-agent-4.0.1.tgz
https://registry.yarnpkg.com/proxy-from-env/-/proxy-from-env-1.1.0.tgz -> yarnpkg-proxy-from-env-1.1.0.tgz
https://registry.yarnpkg.com/prr/-/prr-1.0.1.tgz -> yarnpkg-prr-1.0.1.tgz
https://registry.yarnpkg.com/pseudomap/-/pseudomap-1.0.2.tgz -> yarnpkg-pseudomap-1.0.2.tgz
https://registry.yarnpkg.com/psl/-/psl-1.8.0.tgz -> yarnpkg-psl-1.8.0.tgz
https://registry.yarnpkg.com/public-encrypt/-/public-encrypt-4.0.3.tgz -> yarnpkg-public-encrypt-4.0.3.tgz
https://registry.yarnpkg.com/pump/-/pump-2.0.1.tgz -> yarnpkg-pump-2.0.1.tgz
https://registry.yarnpkg.com/pump/-/pump-3.0.0.tgz -> yarnpkg-pump-3.0.0.tgz
https://registry.yarnpkg.com/pumpify/-/pumpify-1.5.1.tgz -> yarnpkg-pumpify-1.5.1.tgz
https://registry.yarnpkg.com/punycode/-/punycode-1.3.2.tgz -> yarnpkg-punycode-1.3.2.tgz
https://registry.yarnpkg.com/punycode/-/punycode-1.4.1.tgz -> yarnpkg-punycode-1.4.1.tgz
https://registry.yarnpkg.com/punycode/-/punycode-2.1.1.tgz -> yarnpkg-punycode-2.1.1.tgz
https://registry.yarnpkg.com/pupa/-/pupa-2.0.1.tgz -> yarnpkg-pupa-2.0.1.tgz
https://registry.yarnpkg.com/qs/-/qs-6.5.2.tgz -> yarnpkg-qs-6.5.2.tgz
https://registry.yarnpkg.com/querystring-es3/-/querystring-es3-0.2.1.tgz -> yarnpkg-querystring-es3-0.2.1.tgz
https://registry.yarnpkg.com/querystring/-/querystring-0.2.0.tgz -> yarnpkg-querystring-0.2.0.tgz
https://registry.yarnpkg.com/randombytes/-/randombytes-2.1.0.tgz -> yarnpkg-randombytes-2.1.0.tgz
https://registry.yarnpkg.com/randomfill/-/randomfill-1.0.4.tgz -> yarnpkg-randomfill-1.0.4.tgz
https://registry.yarnpkg.com/raw-body/-/raw-body-2.4.1.tgz -> yarnpkg-raw-body-2.4.1.tgz
https://registry.yarnpkg.com/raw-loader/-/raw-loader-4.0.1.tgz -> yarnpkg-raw-loader-4.0.1.tgz
https://registry.yarnpkg.com/rc/-/rc-1.2.8.tgz -> yarnpkg-rc-1.2.8.tgz
https://registry.yarnpkg.com/react-bootstrap/-/react-bootstrap-0.32.4.tgz -> yarnpkg-react-bootstrap-0.32.4.tgz
https://registry.yarnpkg.com/react-chartjs/-/react-chartjs-1.2.0.tgz -> yarnpkg-react-chartjs-1.2.0.tgz
https://registry.yarnpkg.com/react-codemirror/-/react-codemirror-1.0.0.tgz -> yarnpkg-react-codemirror-1.0.0.tgz
https://registry.yarnpkg.com/react-dom/-/react-dom-17.0.2.tgz -> yarnpkg-react-dom-17.0.2.tgz
https://registry.yarnpkg.com/react-is/-/react-is-16.13.1.tgz -> yarnpkg-react-is-16.13.1.tgz
https://registry.yarnpkg.com/react-lifecycles-compat/-/react-lifecycles-compat-3.0.4.tgz -> yarnpkg-react-lifecycles-compat-3.0.4.tgz
https://registry.yarnpkg.com/react-overlays/-/react-overlays-0.8.3.tgz -> yarnpkg-react-overlays-0.8.3.tgz
https://registry.yarnpkg.com/react-prop-types/-/react-prop-types-0.4.0.tgz -> yarnpkg-react-prop-types-0.4.0.tgz
https://registry.yarnpkg.com/react-redux/-/react-redux-7.2.0.tgz -> yarnpkg-react-redux-7.2.0.tgz
https://registry.yarnpkg.com/react-split-pane/-/react-split-pane-0.1.91.tgz -> yarnpkg-react-split-pane-0.1.91.tgz
https://registry.yarnpkg.com/react-style-proptype/-/react-style-proptype-3.2.2.tgz -> yarnpkg-react-style-proptype-3.2.2.tgz
https://registry.yarnpkg.com/react-transition-group/-/react-transition-group-2.9.0.tgz -> yarnpkg-react-transition-group-2.9.0.tgz
https://registry.yarnpkg.com/react/-/react-17.0.2.tgz -> yarnpkg-react-17.0.2.tgz
https://registry.yarnpkg.com/read-config-file/-/read-config-file-6.0.0.tgz -> yarnpkg-read-config-file-6.0.0.tgz
https://registry.yarnpkg.com/read-installed/-/read-installed-4.0.3.tgz -> yarnpkg-read-installed-4.0.3.tgz
https://registry.yarnpkg.com/read-package-json/-/read-package-json-2.1.1.tgz -> yarnpkg-read-package-json-2.1.1.tgz
https://registry.yarnpkg.com/read-pkg-up/-/read-pkg-up-1.0.1.tgz -> yarnpkg-read-pkg-up-1.0.1.tgz
https://registry.yarnpkg.com/read-pkg-up/-/read-pkg-up-2.0.0.tgz -> yarnpkg-read-pkg-up-2.0.0.tgz
https://registry.yarnpkg.com/read-pkg/-/read-pkg-1.1.0.tgz -> yarnpkg-read-pkg-1.1.0.tgz
https://registry.yarnpkg.com/read-pkg/-/read-pkg-2.0.0.tgz -> yarnpkg-read-pkg-2.0.0.tgz
https://registry.yarnpkg.com/readable-stream/-/readable-stream-2.3.7.tgz -> yarnpkg-readable-stream-2.3.7.tgz
https://registry.yarnpkg.com/readable-stream/-/readable-stream-1.1.14.tgz -> yarnpkg-readable-stream-1.1.14.tgz
https://registry.yarnpkg.com/readable-stream/-/readable-stream-3.6.0.tgz -> yarnpkg-readable-stream-3.6.0.tgz
https://registry.yarnpkg.com/readdir-scoped-modules/-/readdir-scoped-modules-1.1.0.tgz -> yarnpkg-readdir-scoped-modules-1.1.0.tgz
https://registry.yarnpkg.com/readdirp/-/readdirp-2.2.1.tgz -> yarnpkg-readdirp-2.2.1.tgz
https://registry.yarnpkg.com/readdirp/-/readdirp-3.6.0.tgz -> yarnpkg-readdirp-3.6.0.tgz
https://registry.yarnpkg.com/redent/-/redent-1.0.0.tgz -> yarnpkg-redent-1.0.0.tgz
https://registry.yarnpkg.com/redux-form/-/redux-form-8.3.6.tgz -> yarnpkg-redux-form-8.3.6.tgz
https://registry.yarnpkg.com/redux-thunk/-/redux-thunk-2.3.0.tgz -> yarnpkg-redux-thunk-2.3.0.tgz
https://registry.yarnpkg.com/redux/-/redux-4.0.5.tgz -> yarnpkg-redux-4.0.5.tgz
https://registry.yarnpkg.com/regenerate/-/regenerate-1.4.1.tgz -> yarnpkg-regenerate-1.4.1.tgz
https://registry.yarnpkg.com/regenerator-runtime/-/regenerator-runtime-0.11.1.tgz -> yarnpkg-regenerator-runtime-0.11.1.tgz
https://registry.yarnpkg.com/regenerator-runtime/-/regenerator-runtime-0.13.5.tgz -> yarnpkg-regenerator-runtime-0.13.5.tgz
https://registry.yarnpkg.com/regenerator-transform/-/regenerator-transform-0.10.1.tgz -> yarnpkg-regenerator-transform-0.10.1.tgz
https://registry.yarnpkg.com/regex-not/-/regex-not-1.0.2.tgz -> yarnpkg-regex-not-1.0.2.tgz
https://registry.yarnpkg.com/regexp.prototype.flags/-/regexp.prototype.flags-1.3.0.tgz -> yarnpkg-regexp.prototype.flags-1.3.0.tgz
https://registry.yarnpkg.com/regexpp/-/regexpp-3.1.0.tgz -> yarnpkg-regexpp-3.1.0.tgz
https://registry.yarnpkg.com/regexpu-core/-/regexpu-core-2.0.0.tgz -> yarnpkg-regexpu-core-2.0.0.tgz
https://registry.yarnpkg.com/registry-auth-token/-/registry-auth-token-4.1.1.tgz -> yarnpkg-registry-auth-token-4.1.1.tgz
https://registry.yarnpkg.com/registry-url/-/registry-url-5.1.0.tgz -> yarnpkg-registry-url-5.1.0.tgz
https://registry.yarnpkg.com/regjsgen/-/regjsgen-0.2.0.tgz -> yarnpkg-regjsgen-0.2.0.tgz
https://registry.yarnpkg.com/regjsparser/-/regjsparser-0.1.5.tgz -> yarnpkg-regjsparser-0.1.5.tgz
https://registry.yarnpkg.com/relateurl/-/relateurl-0.2.7.tgz -> yarnpkg-relateurl-0.2.7.tgz
https://registry.yarnpkg.com/remove-trailing-separator/-/remove-trailing-separator-1.1.0.tgz -> yarnpkg-remove-trailing-separator-1.1.0.tgz
https://registry.yarnpkg.com/repeat-element/-/repeat-element-1.1.4.tgz -> yarnpkg-repeat-element-1.1.4.tgz
https://registry.yarnpkg.com/repeat-string/-/repeat-string-1.6.1.tgz -> yarnpkg-repeat-string-1.6.1.tgz
https://registry.yarnpkg.com/repeating/-/repeating-2.0.1.tgz -> yarnpkg-repeating-2.0.1.tgz
https://registry.yarnpkg.com/request-promise-core/-/request-promise-core-1.1.3.tgz -> yarnpkg-request-promise-core-1.1.3.tgz
https://registry.yarnpkg.com/request-promise/-/request-promise-4.2.5.tgz -> yarnpkg-request-promise-4.2.5.tgz
https://registry.yarnpkg.com/request/-/request-2.88.2.tgz -> yarnpkg-request-2.88.2.tgz
https://registry.yarnpkg.com/require-directory/-/require-directory-2.1.1.tgz -> yarnpkg-require-directory-2.1.1.tgz
https://registry.yarnpkg.com/require-from-string/-/require-from-string-2.0.2.tgz -> yarnpkg-require-from-string-2.0.2.tgz
https://registry.yarnpkg.com/require-main-filename/-/require-main-filename-2.0.0.tgz -> yarnpkg-require-main-filename-2.0.0.tgz
https://registry.yarnpkg.com/resolve-cwd/-/resolve-cwd-2.0.0.tgz -> yarnpkg-resolve-cwd-2.0.0.tgz
https://registry.yarnpkg.com/resolve-dir/-/resolve-dir-1.0.1.tgz -> yarnpkg-resolve-dir-1.0.1.tgz
https://registry.yarnpkg.com/resolve-from/-/resolve-from-3.0.0.tgz -> yarnpkg-resolve-from-3.0.0.tgz
https://registry.yarnpkg.com/resolve-from/-/resolve-from-4.0.0.tgz -> yarnpkg-resolve-from-4.0.0.tgz
https://registry.yarnpkg.com/resolve-url/-/resolve-url-0.2.1.tgz -> yarnpkg-resolve-url-0.2.1.tgz
https://registry.yarnpkg.com/resolve/-/resolve-1.17.0.tgz -> yarnpkg-resolve-1.17.0.tgz
https://registry.yarnpkg.com/responselike/-/responselike-1.0.2.tgz -> yarnpkg-responselike-1.0.2.tgz
https://registry.yarnpkg.com/ret/-/ret-0.1.15.tgz -> yarnpkg-ret-0.1.15.tgz
https://registry.yarnpkg.com/rimraf/-/rimraf-2.7.1.tgz -> yarnpkg-rimraf-2.7.1.tgz
https://registry.yarnpkg.com/rimraf/-/rimraf-3.0.2.tgz -> yarnpkg-rimraf-3.0.2.tgz
https://registry.yarnpkg.com/ripemd160/-/ripemd160-2.0.2.tgz -> yarnpkg-ripemd160-2.0.2.tgz
https://registry.yarnpkg.com/roarr/-/roarr-2.15.3.tgz -> yarnpkg-roarr-2.15.3.tgz
https://registry.yarnpkg.com/run-queue/-/run-queue-1.0.3.tgz -> yarnpkg-run-queue-1.0.3.tgz
https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.2.1.tgz -> yarnpkg-safe-buffer-5.2.1.tgz
https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.1.2.tgz -> yarnpkg-safe-buffer-5.1.2.tgz
https://registry.yarnpkg.com/safe-regex/-/safe-regex-1.1.0.tgz -> yarnpkg-safe-regex-1.1.0.tgz
https://registry.yarnpkg.com/safer-buffer/-/safer-buffer-2.1.2.tgz -> yarnpkg-safer-buffer-2.1.2.tgz
https://registry.yarnpkg.com/sanitize-filename/-/sanitize-filename-1.6.3.tgz -> yarnpkg-sanitize-filename-1.6.3.tgz
https://registry.yarnpkg.com/sass-graph/-/sass-graph-2.2.5.tgz -> yarnpkg-sass-graph-2.2.5.tgz
https://registry.yarnpkg.com/sass-loader/-/sass-loader-8.0.2.tgz -> yarnpkg-sass-loader-8.0.2.tgz
https://registry.yarnpkg.com/sax/-/sax-1.2.4.tgz -> yarnpkg-sax-1.2.4.tgz
https://registry.yarnpkg.com/saxes/-/saxes-5.0.1.tgz -> yarnpkg-saxes-5.0.1.tgz
https://registry.yarnpkg.com/scheduler/-/scheduler-0.20.2.tgz -> yarnpkg-scheduler-0.20.2.tgz
https://registry.yarnpkg.com/schema-utils/-/schema-utils-1.0.0.tgz -> yarnpkg-schema-utils-1.0.0.tgz
https://registry.yarnpkg.com/schema-utils/-/schema-utils-2.7.1.tgz -> yarnpkg-schema-utils-2.7.1.tgz
https://registry.yarnpkg.com/schema-utils/-/schema-utils-2.7.0.tgz -> yarnpkg-schema-utils-2.7.0.tgz
https://registry.yarnpkg.com/schema-utils/-/schema-utils-3.0.0.tgz -> yarnpkg-schema-utils-3.0.0.tgz
https://registry.yarnpkg.com/scss-tokenizer/-/scss-tokenizer-0.2.3.tgz -> yarnpkg-scss-tokenizer-0.2.3.tgz
https://registry.yarnpkg.com/secure-keys/-/secure-keys-1.0.0.tgz -> yarnpkg-secure-keys-1.0.0.tgz
https://registry.yarnpkg.com/select/-/select-1.1.2.tgz -> yarnpkg-select-1.1.2.tgz
https://registry.yarnpkg.com/semver-compare/-/semver-compare-1.0.0.tgz -> yarnpkg-semver-compare-1.0.0.tgz
https://registry.yarnpkg.com/semver-diff/-/semver-diff-3.1.1.tgz -> yarnpkg-semver-diff-3.1.1.tgz
https://registry.yarnpkg.com/semver/-/semver-5.7.1.tgz -> yarnpkg-semver-5.7.1.tgz
https://registry.yarnpkg.com/semver/-/semver-6.3.0.tgz -> yarnpkg-semver-6.3.0.tgz
https://registry.yarnpkg.com/semver/-/semver-7.3.2.tgz -> yarnpkg-semver-7.3.2.tgz
https://registry.yarnpkg.com/semver/-/semver-7.3.5.tgz -> yarnpkg-semver-7.3.5.tgz
https://registry.yarnpkg.com/semver/-/semver-5.3.0.tgz -> yarnpkg-semver-5.3.0.tgz
https://registry.yarnpkg.com/serialize-error/-/serialize-error-7.0.1.tgz -> yarnpkg-serialize-error-7.0.1.tgz
https://registry.yarnpkg.com/serialize-javascript/-/serialize-javascript-4.0.0.tgz -> yarnpkg-serialize-javascript-4.0.0.tgz
https://registry.yarnpkg.com/set-blocking/-/set-blocking-2.0.0.tgz -> yarnpkg-set-blocking-2.0.0.tgz
https://registry.yarnpkg.com/set-value/-/set-value-2.0.1.tgz -> yarnpkg-set-value-2.0.1.tgz
https://registry.yarnpkg.com/setimmediate/-/setimmediate-1.0.5.tgz -> yarnpkg-setimmediate-1.0.5.tgz
https://registry.yarnpkg.com/setprototypeof/-/setprototypeof-1.1.1.tgz -> yarnpkg-setprototypeof-1.1.1.tgz
https://registry.yarnpkg.com/sha.js/-/sha.js-2.4.11.tgz -> yarnpkg-sha.js-2.4.11.tgz
https://registry.yarnpkg.com/shallow-clone/-/shallow-clone-3.0.1.tgz -> yarnpkg-shallow-clone-3.0.1.tgz
https://registry.yarnpkg.com/shebang-command/-/shebang-command-1.2.0.tgz -> yarnpkg-shebang-command-1.2.0.tgz
https://registry.yarnpkg.com/shebang-command/-/shebang-command-2.0.0.tgz -> yarnpkg-shebang-command-2.0.0.tgz
https://registry.yarnpkg.com/shebang-regex/-/shebang-regex-1.0.0.tgz -> yarnpkg-shebang-regex-1.0.0.tgz
https://registry.yarnpkg.com/shebang-regex/-/shebang-regex-3.0.0.tgz -> yarnpkg-shebang-regex-3.0.0.tgz
https://registry.yarnpkg.com/side-channel/-/side-channel-1.0.2.tgz -> yarnpkg-side-channel-1.0.2.tgz
https://registry.yarnpkg.com/signal-exit/-/signal-exit-3.0.3.tgz -> yarnpkg-signal-exit-3.0.3.tgz
https://registry.yarnpkg.com/slash/-/slash-1.0.0.tgz -> yarnpkg-slash-1.0.0.tgz
https://registry.yarnpkg.com/slice-ansi/-/slice-ansi-3.0.0.tgz -> yarnpkg-slice-ansi-3.0.0.tgz
https://registry.yarnpkg.com/slice-ansi/-/slice-ansi-4.0.0.tgz -> yarnpkg-slice-ansi-4.0.0.tgz
https://registry.yarnpkg.com/slide/-/slide-1.1.6.tgz -> yarnpkg-slide-1.1.6.tgz
https://registry.yarnpkg.com/smart-buffer/-/smart-buffer-4.1.0.tgz -> yarnpkg-smart-buffer-4.1.0.tgz
https://registry.yarnpkg.com/snapdragon-node/-/snapdragon-node-2.1.1.tgz -> yarnpkg-snapdragon-node-2.1.1.tgz
https://registry.yarnpkg.com/snapdragon-util/-/snapdragon-util-3.0.1.tgz -> yarnpkg-snapdragon-util-3.0.1.tgz
https://registry.yarnpkg.com/snapdragon/-/snapdragon-0.8.2.tgz -> yarnpkg-snapdragon-0.8.2.tgz
https://registry.yarnpkg.com/socks-proxy-agent/-/socks-proxy-agent-5.0.0.tgz -> yarnpkg-socks-proxy-agent-5.0.0.tgz
https://registry.yarnpkg.com/socks/-/socks-2.6.1.tgz -> yarnpkg-socks-2.6.1.tgz
https://registry.yarnpkg.com/sort-keys-length/-/sort-keys-length-1.0.1.tgz -> yarnpkg-sort-keys-length-1.0.1.tgz
https://registry.yarnpkg.com/sort-keys/-/sort-keys-1.1.2.tgz -> yarnpkg-sort-keys-1.1.2.tgz
https://registry.yarnpkg.com/source-list-map/-/source-list-map-2.0.1.tgz -> yarnpkg-source-list-map-2.0.1.tgz
https://registry.yarnpkg.com/source-map-js/-/source-map-js-0.6.2.tgz -> yarnpkg-source-map-js-0.6.2.tgz
https://registry.yarnpkg.com/source-map-resolve/-/source-map-resolve-0.5.3.tgz -> yarnpkg-source-map-resolve-0.5.3.tgz
https://registry.yarnpkg.com/source-map-support/-/source-map-support-0.4.18.tgz -> yarnpkg-source-map-support-0.4.18.tgz
https://registry.yarnpkg.com/source-map-support/-/source-map-support-0.5.19.tgz -> yarnpkg-source-map-support-0.5.19.tgz
https://registry.yarnpkg.com/source-map-url/-/source-map-url-0.4.1.tgz -> yarnpkg-source-map-url-0.4.1.tgz
https://registry.yarnpkg.com/source-map/-/source-map-0.4.4.tgz -> yarnpkg-source-map-0.4.4.tgz
https://registry.yarnpkg.com/source-map/-/source-map-0.5.7.tgz -> yarnpkg-source-map-0.5.7.tgz
https://registry.yarnpkg.com/source-map/-/source-map-0.6.1.tgz -> yarnpkg-source-map-0.6.1.tgz
https://registry.yarnpkg.com/spdx-compare/-/spdx-compare-1.0.0.tgz -> yarnpkg-spdx-compare-1.0.0.tgz
https://registry.yarnpkg.com/spdx-correct/-/spdx-correct-3.1.1.tgz -> yarnpkg-spdx-correct-3.1.1.tgz
https://registry.yarnpkg.com/spdx-exceptions/-/spdx-exceptions-2.3.0.tgz -> yarnpkg-spdx-exceptions-2.3.0.tgz
https://registry.yarnpkg.com/spdx-expression-parse/-/spdx-expression-parse-3.0.1.tgz -> yarnpkg-spdx-expression-parse-3.0.1.tgz
https://registry.yarnpkg.com/spdx-license-ids/-/spdx-license-ids-3.0.5.tgz -> yarnpkg-spdx-license-ids-3.0.5.tgz
https://registry.yarnpkg.com/spdx-ranges/-/spdx-ranges-2.1.1.tgz -> yarnpkg-spdx-ranges-2.1.1.tgz
https://registry.yarnpkg.com/spdx-satisfies/-/spdx-satisfies-4.0.1.tgz -> yarnpkg-spdx-satisfies-4.0.1.tgz
https://registry.yarnpkg.com/split-string/-/split-string-3.1.0.tgz -> yarnpkg-split-string-3.1.0.tgz
https://registry.yarnpkg.com/sprintf-js/-/sprintf-js-1.1.2.tgz -> yarnpkg-sprintf-js-1.1.2.tgz
https://registry.yarnpkg.com/sprintf-js/-/sprintf-js-1.0.3.tgz -> yarnpkg-sprintf-js-1.0.3.tgz
https://registry.yarnpkg.com/sshpk/-/sshpk-1.16.1.tgz -> yarnpkg-sshpk-1.16.1.tgz
https://registry.yarnpkg.com/ssri/-/ssri-6.0.2.tgz -> yarnpkg-ssri-6.0.2.tgz
https://registry.yarnpkg.com/stack-trace/-/stack-trace-0.0.10.tgz -> yarnpkg-stack-trace-0.0.10.tgz
https://registry.yarnpkg.com/stat-mode/-/stat-mode-1.0.0.tgz -> yarnpkg-stat-mode-1.0.0.tgz
https://registry.yarnpkg.com/static-extend/-/static-extend-0.1.2.tgz -> yarnpkg-static-extend-0.1.2.tgz
https://registry.yarnpkg.com/statuses/-/statuses-1.5.0.tgz -> yarnpkg-statuses-1.5.0.tgz
https://registry.yarnpkg.com/stdout-stream/-/stdout-stream-1.4.1.tgz -> yarnpkg-stdout-stream-1.4.1.tgz
https://registry.yarnpkg.com/stealthy-require/-/stealthy-require-1.1.1.tgz -> yarnpkg-stealthy-require-1.1.1.tgz
https://registry.yarnpkg.com/stream-browserify/-/stream-browserify-2.0.2.tgz -> yarnpkg-stream-browserify-2.0.2.tgz
https://registry.yarnpkg.com/stream-each/-/stream-each-1.2.3.tgz -> yarnpkg-stream-each-1.2.3.tgz
https://registry.yarnpkg.com/stream-http/-/stream-http-2.8.3.tgz -> yarnpkg-stream-http-2.8.3.tgz
https://registry.yarnpkg.com/stream-shift/-/stream-shift-1.0.1.tgz -> yarnpkg-stream-shift-1.0.1.tgz
https://registry.yarnpkg.com/string-width/-/string-width-1.0.2.tgz -> yarnpkg-string-width-1.0.2.tgz
https://registry.yarnpkg.com/string-width/-/string-width-2.1.1.tgz -> yarnpkg-string-width-2.1.1.tgz
https://registry.yarnpkg.com/string-width/-/string-width-3.1.0.tgz -> yarnpkg-string-width-3.1.0.tgz
https://registry.yarnpkg.com/string-width/-/string-width-4.2.0.tgz -> yarnpkg-string-width-4.2.0.tgz
https://registry.yarnpkg.com/string.prototype.matchall/-/string.prototype.matchall-4.0.2.tgz -> yarnpkg-string.prototype.matchall-4.0.2.tgz
https://registry.yarnpkg.com/string.prototype.trimend/-/string.prototype.trimend-1.0.1.tgz -> yarnpkg-string.prototype.trimend-1.0.1.tgz
https://registry.yarnpkg.com/string.prototype.trimleft/-/string.prototype.trimleft-2.1.2.tgz -> yarnpkg-string.prototype.trimleft-2.1.2.tgz
https://registry.yarnpkg.com/string.prototype.trimright/-/string.prototype.trimright-2.1.2.tgz -> yarnpkg-string.prototype.trimright-2.1.2.tgz
https://registry.yarnpkg.com/string.prototype.trimstart/-/string.prototype.trimstart-1.0.1.tgz -> yarnpkg-string.prototype.trimstart-1.0.1.tgz
https://registry.yarnpkg.com/string_decoder/-/string_decoder-1.3.0.tgz -> yarnpkg-string_decoder-1.3.0.tgz
https://registry.yarnpkg.com/string_decoder/-/string_decoder-0.10.31.tgz -> yarnpkg-string_decoder-0.10.31.tgz
https://registry.yarnpkg.com/string_decoder/-/string_decoder-1.1.1.tgz -> yarnpkg-string_decoder-1.1.1.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-3.0.1.tgz -> yarnpkg-strip-ansi-3.0.1.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-4.0.0.tgz -> yarnpkg-strip-ansi-4.0.0.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-5.2.0.tgz -> yarnpkg-strip-ansi-5.2.0.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-6.0.0.tgz -> yarnpkg-strip-ansi-6.0.0.tgz
https://registry.yarnpkg.com/strip-bom/-/strip-bom-2.0.0.tgz -> yarnpkg-strip-bom-2.0.0.tgz
https://registry.yarnpkg.com/strip-bom/-/strip-bom-3.0.0.tgz -> yarnpkg-strip-bom-3.0.0.tgz
https://registry.yarnpkg.com/strip-indent/-/strip-indent-1.0.1.tgz -> yarnpkg-strip-indent-1.0.1.tgz
https://registry.yarnpkg.com/strip-json-comments/-/strip-json-comments-3.1.0.tgz -> yarnpkg-strip-json-comments-3.1.0.tgz
https://registry.yarnpkg.com/strip-json-comments/-/strip-json-comments-3.1.1.tgz -> yarnpkg-strip-json-comments-3.1.1.tgz
https://registry.yarnpkg.com/strip-json-comments/-/strip-json-comments-2.0.1.tgz -> yarnpkg-strip-json-comments-2.0.1.tgz
https://registry.yarnpkg.com/style-loader/-/style-loader-1.3.0.tgz -> yarnpkg-style-loader-1.3.0.tgz
https://registry.yarnpkg.com/sumchecker/-/sumchecker-3.0.1.tgz -> yarnpkg-sumchecker-3.0.1.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-2.0.0.tgz -> yarnpkg-supports-color-2.0.0.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-5.5.0.tgz -> yarnpkg-supports-color-5.5.0.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-6.1.0.tgz -> yarnpkg-supports-color-6.1.0.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-7.1.0.tgz -> yarnpkg-supports-color-7.1.0.tgz
https://registry.yarnpkg.com/symbol-observable/-/symbol-observable-1.2.0.tgz -> yarnpkg-symbol-observable-1.2.0.tgz
https://registry.yarnpkg.com/symbol-tree/-/symbol-tree-3.2.4.tgz -> yarnpkg-symbol-tree-3.2.4.tgz
https://registry.yarnpkg.com/table/-/table-6.7.1.tgz -> yarnpkg-table-6.7.1.tgz
https://registry.yarnpkg.com/tapable/-/tapable-1.1.3.tgz -> yarnpkg-tapable-1.1.3.tgz
https://registry.yarnpkg.com/tar/-/tar-2.2.2.tgz -> yarnpkg-tar-2.2.2.tgz
https://registry.yarnpkg.com/temp-file/-/temp-file-3.3.7.tgz -> yarnpkg-temp-file-3.3.7.tgz
https://registry.yarnpkg.com/term-size/-/term-size-2.2.0.tgz -> yarnpkg-term-size-2.2.0.tgz
https://registry.yarnpkg.com/terser-webpack-plugin/-/terser-webpack-plugin-1.4.5.tgz -> yarnpkg-terser-webpack-plugin-1.4.5.tgz
https://registry.yarnpkg.com/terser/-/terser-4.8.0.tgz -> yarnpkg-terser-4.8.0.tgz
https://registry.yarnpkg.com/terser/-/terser-4.7.0.tgz -> yarnpkg-terser-4.7.0.tgz
https://registry.yarnpkg.com/text-loader/-/text-loader-0.0.1.tgz -> yarnpkg-text-loader-0.0.1.tgz
https://registry.yarnpkg.com/text-table/-/text-table-0.2.0.tgz -> yarnpkg-text-table-0.2.0.tgz
https://registry.yarnpkg.com/through2/-/through2-2.0.5.tgz -> yarnpkg-through2-2.0.5.tgz
https://registry.yarnpkg.com/timers-browserify/-/timers-browserify-2.0.12.tgz -> yarnpkg-timers-browserify-2.0.12.tgz
https://registry.yarnpkg.com/tiny-emitter/-/tiny-emitter-2.1.0.tgz -> yarnpkg-tiny-emitter-2.1.0.tgz
https://registry.yarnpkg.com/to-arraybuffer/-/to-arraybuffer-1.0.1.tgz -> yarnpkg-to-arraybuffer-1.0.1.tgz
https://registry.yarnpkg.com/to-fast-properties/-/to-fast-properties-1.0.3.tgz -> yarnpkg-to-fast-properties-1.0.3.tgz
https://registry.yarnpkg.com/to-fast-properties/-/to-fast-properties-2.0.0.tgz -> yarnpkg-to-fast-properties-2.0.0.tgz
https://registry.yarnpkg.com/to-object-path/-/to-object-path-0.3.0.tgz -> yarnpkg-to-object-path-0.3.0.tgz
https://registry.yarnpkg.com/to-readable-stream/-/to-readable-stream-1.0.0.tgz -> yarnpkg-to-readable-stream-1.0.0.tgz
https://registry.yarnpkg.com/to-regex-range/-/to-regex-range-2.1.1.tgz -> yarnpkg-to-regex-range-2.1.1.tgz
https://registry.yarnpkg.com/to-regex-range/-/to-regex-range-5.0.1.tgz -> yarnpkg-to-regex-range-5.0.1.tgz
https://registry.yarnpkg.com/to-regex/-/to-regex-3.0.2.tgz -> yarnpkg-to-regex-3.0.2.tgz
https://registry.yarnpkg.com/toidentifier/-/toidentifier-1.0.0.tgz -> yarnpkg-toidentifier-1.0.0.tgz
https://registry.yarnpkg.com/tough-cookie/-/tough-cookie-2.5.0.tgz -> yarnpkg-tough-cookie-2.5.0.tgz
https://registry.yarnpkg.com/tough-cookie/-/tough-cookie-4.0.0.tgz -> yarnpkg-tough-cookie-4.0.0.tgz
https://registry.yarnpkg.com/tr46/-/tr46-2.0.2.tgz -> yarnpkg-tr46-2.0.2.tgz
https://registry.yarnpkg.com/tr46/-/tr46-2.1.0.tgz -> yarnpkg-tr46-2.1.0.tgz
https://registry.yarnpkg.com/treeify/-/treeify-1.1.0.tgz -> yarnpkg-treeify-1.1.0.tgz
https://registry.yarnpkg.com/trim-newlines/-/trim-newlines-1.0.0.tgz -> yarnpkg-trim-newlines-1.0.0.tgz
https://registry.yarnpkg.com/trim-right/-/trim-right-1.0.1.tgz -> yarnpkg-trim-right-1.0.1.tgz
https://registry.yarnpkg.com/true-case-path/-/true-case-path-1.0.3.tgz -> yarnpkg-true-case-path-1.0.3.tgz
https://registry.yarnpkg.com/truncate-utf8-bytes/-/truncate-utf8-bytes-1.0.2.tgz -> yarnpkg-truncate-utf8-bytes-1.0.2.tgz
https://registry.yarnpkg.com/tslib/-/tslib-1.13.0.tgz -> yarnpkg-tslib-1.13.0.tgz
https://registry.yarnpkg.com/tslib/-/tslib-2.3.0.tgz -> yarnpkg-tslib-2.3.0.tgz
https://registry.yarnpkg.com/tty-browserify/-/tty-browserify-0.0.0.tgz -> yarnpkg-tty-browserify-0.0.0.tgz
https://registry.yarnpkg.com/tunnel-agent/-/tunnel-agent-0.6.0.tgz -> yarnpkg-tunnel-agent-0.6.0.tgz
https://registry.yarnpkg.com/tunnel/-/tunnel-0.0.6.tgz -> yarnpkg-tunnel-0.0.6.tgz
https://registry.yarnpkg.com/tweetnacl/-/tweetnacl-0.14.5.tgz -> yarnpkg-tweetnacl-0.14.5.tgz
https://registry.yarnpkg.com/twemoji-parser/-/twemoji-parser-11.0.2.tgz -> yarnpkg-twemoji-parser-11.0.2.tgz
https://registry.yarnpkg.com/twitter-text/-/twitter-text-3.1.0.tgz -> yarnpkg-twitter-text-3.1.0.tgz
https://registry.yarnpkg.com/type-check/-/type-check-0.4.0.tgz -> yarnpkg-type-check-0.4.0.tgz
https://registry.yarnpkg.com/type-check/-/type-check-0.3.2.tgz -> yarnpkg-type-check-0.3.2.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.13.1.tgz -> yarnpkg-type-fest-0.13.1.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.20.2.tgz -> yarnpkg-type-fest-0.20.2.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.8.1.tgz -> yarnpkg-type-fest-0.8.1.tgz
https://registry.yarnpkg.com/typedarray-to-buffer/-/typedarray-to-buffer-3.1.5.tgz -> yarnpkg-typedarray-to-buffer-3.1.5.tgz
https://registry.yarnpkg.com/typedarray/-/typedarray-0.0.6.tgz -> yarnpkg-typedarray-0.0.6.tgz
https://registry.yarnpkg.com/ua-parser-js/-/ua-parser-js-0.7.21.tgz -> yarnpkg-ua-parser-js-0.7.21.tgz
https://registry.yarnpkg.com/uc.micro/-/uc.micro-1.0.6.tgz -> yarnpkg-uc.micro-1.0.6.tgz
https://registry.yarnpkg.com/uncontrollable/-/uncontrollable-5.1.0.tgz -> yarnpkg-uncontrollable-5.1.0.tgz
https://registry.yarnpkg.com/union-value/-/union-value-1.0.1.tgz -> yarnpkg-union-value-1.0.1.tgz
https://registry.yarnpkg.com/uniq/-/uniq-1.0.1.tgz -> yarnpkg-uniq-1.0.1.tgz
https://registry.yarnpkg.com/unique-filename/-/unique-filename-1.1.1.tgz -> yarnpkg-unique-filename-1.1.1.tgz
https://registry.yarnpkg.com/unique-slug/-/unique-slug-2.0.2.tgz -> yarnpkg-unique-slug-2.0.2.tgz
https://registry.yarnpkg.com/unique-string/-/unique-string-2.0.0.tgz -> yarnpkg-unique-string-2.0.0.tgz
https://registry.yarnpkg.com/universalify/-/universalify-0.1.2.tgz -> yarnpkg-universalify-0.1.2.tgz
https://registry.yarnpkg.com/universalify/-/universalify-1.0.0.tgz -> yarnpkg-universalify-1.0.0.tgz
https://registry.yarnpkg.com/unpipe/-/unpipe-1.0.0.tgz -> yarnpkg-unpipe-1.0.0.tgz
https://registry.yarnpkg.com/unset-value/-/unset-value-1.0.0.tgz -> yarnpkg-unset-value-1.0.0.tgz
https://registry.yarnpkg.com/unused-filename/-/unused-filename-2.1.0.tgz -> yarnpkg-unused-filename-2.1.0.tgz
https://registry.yarnpkg.com/upath/-/upath-1.2.0.tgz -> yarnpkg-upath-1.2.0.tgz
https://registry.yarnpkg.com/update-notifier/-/update-notifier-4.1.0.tgz -> yarnpkg-update-notifier-4.1.0.tgz
https://registry.yarnpkg.com/uri-js/-/uri-js-4.2.2.tgz -> yarnpkg-uri-js-4.2.2.tgz
https://registry.yarnpkg.com/urix/-/urix-0.1.0.tgz -> yarnpkg-urix-0.1.0.tgz
https://registry.yarnpkg.com/url-loader/-/url-loader-4.1.0.tgz -> yarnpkg-url-loader-4.1.0.tgz
https://registry.yarnpkg.com/url-parse-lax/-/url-parse-lax-3.0.0.tgz -> yarnpkg-url-parse-lax-3.0.0.tgz
https://registry.yarnpkg.com/url/-/url-0.11.0.tgz -> yarnpkg-url-0.11.0.tgz
https://registry.yarnpkg.com/use/-/use-3.1.1.tgz -> yarnpkg-use-3.1.1.tgz
https://registry.yarnpkg.com/utf8-byte-length/-/utf8-byte-length-1.0.4.tgz -> yarnpkg-utf8-byte-length-1.0.4.tgz
https://registry.yarnpkg.com/util-deprecate/-/util-deprecate-1.0.2.tgz -> yarnpkg-util-deprecate-1.0.2.tgz
https://registry.yarnpkg.com/util-extend/-/util-extend-1.0.3.tgz -> yarnpkg-util-extend-1.0.3.tgz
https://registry.yarnpkg.com/util/-/util-0.10.3.tgz -> yarnpkg-util-0.10.3.tgz
https://registry.yarnpkg.com/util/-/util-0.11.1.tgz -> yarnpkg-util-0.11.1.tgz
https://registry.yarnpkg.com/uuid/-/uuid-3.4.0.tgz -> yarnpkg-uuid-3.4.0.tgz
https://registry.yarnpkg.com/v8-compile-cache/-/v8-compile-cache-2.1.1.tgz -> yarnpkg-v8-compile-cache-2.1.1.tgz
https://registry.yarnpkg.com/v8-compile-cache/-/v8-compile-cache-2.3.0.tgz -> yarnpkg-v8-compile-cache-2.3.0.tgz
https://registry.yarnpkg.com/valid-filename/-/valid-filename-3.1.0.tgz -> yarnpkg-valid-filename-3.1.0.tgz
https://registry.yarnpkg.com/validate-npm-package-license/-/validate-npm-package-license-3.0.4.tgz -> yarnpkg-validate-npm-package-license-3.0.4.tgz
https://registry.yarnpkg.com/verror/-/verror-1.10.0.tgz -> yarnpkg-verror-1.10.0.tgz
https://registry.yarnpkg.com/vm-browserify/-/vm-browserify-1.1.2.tgz -> yarnpkg-vm-browserify-1.1.2.tgz
https://registry.yarnpkg.com/w3c-hr-time/-/w3c-hr-time-1.0.2.tgz -> yarnpkg-w3c-hr-time-1.0.2.tgz
https://registry.yarnpkg.com/w3c-xmlserializer/-/w3c-xmlserializer-2.0.0.tgz -> yarnpkg-w3c-xmlserializer-2.0.0.tgz
https://registry.yarnpkg.com/warning/-/warning-3.0.0.tgz -> yarnpkg-warning-3.0.0.tgz
https://registry.yarnpkg.com/warning/-/warning-4.0.3.tgz -> yarnpkg-warning-4.0.3.tgz
https://registry.yarnpkg.com/watchpack-chokidar2/-/watchpack-chokidar2-2.0.1.tgz -> yarnpkg-watchpack-chokidar2-2.0.1.tgz
https://registry.yarnpkg.com/watchpack/-/watchpack-1.7.5.tgz -> yarnpkg-watchpack-1.7.5.tgz
https://registry.yarnpkg.com/webidl-conversions/-/webidl-conversions-5.0.0.tgz -> yarnpkg-webidl-conversions-5.0.0.tgz
https://registry.yarnpkg.com/webidl-conversions/-/webidl-conversions-6.1.0.tgz -> yarnpkg-webidl-conversions-6.1.0.tgz
https://registry.yarnpkg.com/webpack-cli/-/webpack-cli-3.3.12.tgz -> yarnpkg-webpack-cli-3.3.12.tgz
https://registry.yarnpkg.com/webpack-node-externals/-/webpack-node-externals-1.7.2.tgz -> yarnpkg-webpack-node-externals-1.7.2.tgz
https://registry.yarnpkg.com/webpack-sources/-/webpack-sources-1.4.3.tgz -> yarnpkg-webpack-sources-1.4.3.tgz
https://registry.yarnpkg.com/webpack/-/webpack-4.46.0.tgz -> yarnpkg-webpack-4.46.0.tgz
https://registry.yarnpkg.com/whatwg-encoding/-/whatwg-encoding-1.0.5.tgz -> yarnpkg-whatwg-encoding-1.0.5.tgz
https://registry.yarnpkg.com/whatwg-fetch/-/whatwg-fetch-3.0.0.tgz -> yarnpkg-whatwg-fetch-3.0.0.tgz
https://registry.yarnpkg.com/whatwg-mimetype/-/whatwg-mimetype-2.3.0.tgz -> yarnpkg-whatwg-mimetype-2.3.0.tgz
https://registry.yarnpkg.com/whatwg-url/-/whatwg-url-8.1.0.tgz -> yarnpkg-whatwg-url-8.1.0.tgz
https://registry.yarnpkg.com/whatwg-url/-/whatwg-url-8.6.0.tgz -> yarnpkg-whatwg-url-8.6.0.tgz
https://registry.yarnpkg.com/which-module/-/which-module-2.0.0.tgz -> yarnpkg-which-module-2.0.0.tgz
https://registry.yarnpkg.com/which/-/which-1.3.1.tgz -> yarnpkg-which-1.3.1.tgz
https://registry.yarnpkg.com/which/-/which-2.0.2.tgz -> yarnpkg-which-2.0.2.tgz
https://registry.yarnpkg.com/wide-align/-/wide-align-1.1.3.tgz -> yarnpkg-wide-align-1.1.3.tgz
https://registry.yarnpkg.com/widest-line/-/widest-line-3.1.0.tgz -> yarnpkg-widest-line-3.1.0.tgz
https://registry.yarnpkg.com/winston/-/winston-2.4.4.tgz -> yarnpkg-winston-2.4.4.tgz
https://registry.yarnpkg.com/word-wrap/-/word-wrap-1.2.3.tgz -> yarnpkg-word-wrap-1.2.3.tgz
https://registry.yarnpkg.com/worker-farm/-/worker-farm-1.7.0.tgz -> yarnpkg-worker-farm-1.7.0.tgz
https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-5.1.0.tgz -> yarnpkg-wrap-ansi-5.1.0.tgz
https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-6.2.0.tgz -> yarnpkg-wrap-ansi-6.2.0.tgz
https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> yarnpkg-wrap-ansi-7.0.0.tgz
https://registry.yarnpkg.com/wrappy/-/wrappy-1.0.2.tgz -> yarnpkg-wrappy-1.0.2.tgz
https://registry.yarnpkg.com/write-file-atomic/-/write-file-atomic-3.0.3.tgz -> yarnpkg-write-file-atomic-3.0.3.tgz
https://registry.yarnpkg.com/ws/-/ws-7.4.6.tgz -> yarnpkg-ws-7.4.6.tgz
https://registry.yarnpkg.com/xdg-basedir/-/xdg-basedir-4.0.0.tgz -> yarnpkg-xdg-basedir-4.0.0.tgz
https://registry.yarnpkg.com/xml-name-validator/-/xml-name-validator-3.0.0.tgz -> yarnpkg-xml-name-validator-3.0.0.tgz
https://registry.yarnpkg.com/xmlchars/-/xmlchars-2.2.0.tgz -> yarnpkg-xmlchars-2.2.0.tgz
https://registry.yarnpkg.com/xregexp/-/xregexp-2.0.0.tgz -> yarnpkg-xregexp-2.0.0.tgz
https://registry.yarnpkg.com/xregexp/-/xregexp-4.3.0.tgz -> yarnpkg-xregexp-4.3.0.tgz
https://registry.yarnpkg.com/xtend/-/xtend-4.0.2.tgz -> yarnpkg-xtend-4.0.2.tgz
https://registry.yarnpkg.com/y18n/-/y18n-4.0.0.tgz -> yarnpkg-y18n-4.0.0.tgz
https://registry.yarnpkg.com/y18n/-/y18n-5.0.8.tgz -> yarnpkg-y18n-5.0.8.tgz
https://registry.yarnpkg.com/yallist/-/yallist-2.1.2.tgz -> yarnpkg-yallist-2.1.2.tgz
https://registry.yarnpkg.com/yallist/-/yallist-3.1.1.tgz -> yarnpkg-yallist-3.1.1.tgz
https://registry.yarnpkg.com/yallist/-/yallist-4.0.0.tgz -> yarnpkg-yallist-4.0.0.tgz
https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-13.1.2.tgz -> yarnpkg-yargs-parser-13.1.2.tgz
https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-18.1.3.tgz -> yarnpkg-yargs-parser-18.1.3.tgz
https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-20.2.7.tgz -> yarnpkg-yargs-parser-20.2.7.tgz
https://registry.yarnpkg.com/yargs/-/yargs-13.3.2.tgz -> yarnpkg-yargs-13.3.2.tgz
https://registry.yarnpkg.com/yargs/-/yargs-15.3.1.tgz -> yarnpkg-yargs-15.3.1.tgz
https://registry.yarnpkg.com/yargs/-/yargs-16.2.0.tgz -> yarnpkg-yargs-16.2.0.tgz
https://registry.yarnpkg.com/yauzl/-/yauzl-2.10.0.tgz -> yarnpkg-yauzl-2.10.0.tgz
"
# UPDATER_END_YARN_EXTERNAL_URIS
SRC_URI="
$(electron-app_gen_electron_uris)
${YARN_EXTERNAL_URIS}
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
	yarn_pkg_setup
}

vrun() {
einfo "Running:\t${@}"
	"${@}" || die
	if [[ "${ELECTRON_APP_SKIP_EXIT_CODE_CHECK}" == "1" ]] ; then
		:;
	elif grep -q -e "Exit code:" "${T}/build.log" ; then
eerror
eerror "Detected failure.  Re-emerge..."
eerror
		die
	fi
}

src_unpack() {
	if [[ "${UPDATE_YARN_LOCK}" == "1" ]] ; then
		unpack ${P}.tar.gz
		cd "${S}" || die
		rm package-lock.json
		npm i --legacy-peer-deps || die
		npm audit fix || die
		yarn import || die
	else
		yarn_src_unpack
	fi
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
	electron-app_cp_electron
	vrun yarn run build
	vrun electron-builder -l --dir
}

src_install() {
	insinto "${YARN_INSTALL_PATH}"
	doins -r "dist/linux-unpacked/"*
	newicon "build/icon/icon.png" "${PN}.png"
	make_desktop_entry \
		"${YARN_INSTALL_PATH}/${PN}" \
		"${PN^}" \
		"${PN}.png" \
		"Development"
	fperms 0755 "${YARN_INSTALL_PATH}/${PN}"
	shred "${S}/configs/account.js"
	electron-app_gen_wrapper \
		"${PN^}" \
		"${YARN_INSTALL_PATH}/${PN}"
	dosym "/usr/bin/${PN^}" "/usr/bin/${PN}"
	LCNR_SOURCE="${WORKDIR}/${PN^}-${PV}"
	lcnr_install_files
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
