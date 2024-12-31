# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NODE_VERSION="20"

inherit npm

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/rdkcentral/ThunderUI.git"
	FALLBACK_COMMIT="7fd8bd29280cc9c2261d1b25f154386d2aae0091" # Jul 23, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
# UPDATER_START_NPM_EXTERNAL_URIS
NPM_EXTERNAL_URIS="
https://registry.npmjs.org/@babel/code-frame/-/code-frame-7.26.2.tgz -> npmpkg-@babel-code-frame-7.26.2.tgz
https://registry.npmjs.org/@babel/helper-validator-identifier/-/helper-validator-identifier-7.25.9.tgz -> npmpkg-@babel-helper-validator-identifier-7.25.9.tgz
https://registry.npmjs.org/@babel/runtime/-/runtime-7.26.0.tgz -> npmpkg-@babel-runtime-7.26.0.tgz
https://registry.npmjs.org/@types/json-schema/-/json-schema-7.0.15.tgz -> npmpkg-@types-json-schema-7.0.15.tgz
https://registry.npmjs.org/@types/parse-json/-/parse-json-4.0.2.tgz -> npmpkg-@types-parse-json-4.0.2.tgz
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
https://registry.npmjs.org/acorn/-/acorn-6.4.2.tgz -> npmpkg-acorn-6.4.2.tgz
https://registry.npmjs.org/ajv/-/ajv-6.12.6.tgz -> npmpkg-ajv-6.12.6.tgz
https://registry.npmjs.org/ajv-errors/-/ajv-errors-1.0.1.tgz -> npmpkg-ajv-errors-1.0.1.tgz
https://registry.npmjs.org/ajv-keywords/-/ajv-keywords-3.5.2.tgz -> npmpkg-ajv-keywords-3.5.2.tgz
https://registry.npmjs.org/ansi-colors/-/ansi-colors-3.2.4.tgz -> npmpkg-ansi-colors-3.2.4.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-4.1.1.tgz -> npmpkg-ansi-regex-4.1.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/ansi-to-html/-/ansi-to-html-0.7.2.tgz -> npmpkg-ansi-to-html-0.7.2.tgz
https://registry.npmjs.org/anymatch/-/anymatch-3.1.3.tgz -> npmpkg-anymatch-3.1.3.tgz
https://registry.npmjs.org/aproba/-/aproba-1.2.0.tgz -> npmpkg-aproba-1.2.0.tgz
https://registry.npmjs.org/arr-diff/-/arr-diff-4.0.0.tgz -> npmpkg-arr-diff-4.0.0.tgz
https://registry.npmjs.org/arr-flatten/-/arr-flatten-1.1.0.tgz -> npmpkg-arr-flatten-1.1.0.tgz
https://registry.npmjs.org/arr-union/-/arr-union-3.1.0.tgz -> npmpkg-arr-union-3.1.0.tgz
https://registry.npmjs.org/array-union/-/array-union-1.0.2.tgz -> npmpkg-array-union-1.0.2.tgz
https://registry.npmjs.org/array-uniq/-/array-uniq-1.0.3.tgz -> npmpkg-array-uniq-1.0.3.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.3.2.tgz -> npmpkg-array-unique-0.3.2.tgz
https://registry.npmjs.org/asn1.js/-/asn1.js-4.10.1.tgz -> npmpkg-asn1.js-4.10.1.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.1.tgz -> npmpkg-bn.js-4.12.1.tgz
https://registry.npmjs.org/assert/-/assert-1.5.1.tgz -> npmpkg-assert-1.5.1.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.3.tgz -> npmpkg-inherits-2.0.3.tgz
https://registry.npmjs.org/util/-/util-0.10.4.tgz -> npmpkg-util-0.10.4.tgz
https://registry.npmjs.org/assign-symbols/-/assign-symbols-1.0.0.tgz -> npmpkg-assign-symbols-1.0.0.tgz
https://registry.npmjs.org/async/-/async-2.6.4.tgz -> npmpkg-async-2.6.4.tgz
https://registry.npmjs.org/async-each/-/async-each-1.0.6.tgz -> npmpkg-async-each-1.0.6.tgz
https://registry.npmjs.org/atob/-/atob-2.1.2.tgz -> npmpkg-atob-2.1.2.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.2.tgz -> npmpkg-balanced-match-1.0.2.tgz
https://registry.npmjs.org/base/-/base-0.11.2.tgz -> npmpkg-base-0.11.2.tgz
https://registry.npmjs.org/define-property/-/define-property-1.0.0.tgz -> npmpkg-define-property-1.0.0.tgz
https://registry.npmjs.org/base64-js/-/base64-js-1.5.1.tgz -> npmpkg-base64-js-1.5.1.tgz
https://registry.npmjs.org/basic-auth/-/basic-auth-1.1.0.tgz -> npmpkg-basic-auth-1.1.0.tgz
https://registry.npmjs.org/big.js/-/big.js-5.2.2.tgz -> npmpkg-big.js-5.2.2.tgz
https://registry.npmjs.org/binary-extensions/-/binary-extensions-2.3.0.tgz -> npmpkg-binary-extensions-2.3.0.tgz
https://registry.npmjs.org/bindings/-/bindings-1.5.0.tgz -> npmpkg-bindings-1.5.0.tgz
https://registry.npmjs.org/bluebird/-/bluebird-3.7.2.tgz -> npmpkg-bluebird-3.7.2.tgz
https://registry.npmjs.org/bn.js/-/bn.js-5.2.1.tgz -> npmpkg-bn.js-5.2.1.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/braces/-/braces-2.3.2.tgz -> npmpkg-braces-2.3.2.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/brorand/-/brorand-1.1.0.tgz -> npmpkg-brorand-1.1.0.tgz
https://registry.npmjs.org/browserify-aes/-/browserify-aes-1.2.0.tgz -> npmpkg-browserify-aes-1.2.0.tgz
https://registry.npmjs.org/browserify-cipher/-/browserify-cipher-1.0.1.tgz -> npmpkg-browserify-cipher-1.0.1.tgz
https://registry.npmjs.org/browserify-des/-/browserify-des-1.0.2.tgz -> npmpkg-browserify-des-1.0.2.tgz
https://registry.npmjs.org/browserify-rsa/-/browserify-rsa-4.1.1.tgz -> npmpkg-browserify-rsa-4.1.1.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz -> npmpkg-safe-buffer-5.2.1.tgz
https://registry.npmjs.org/browserify-sign/-/browserify-sign-4.2.3.tgz -> npmpkg-browserify-sign-4.2.3.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz -> npmpkg-safe-buffer-5.2.1.tgz
https://registry.npmjs.org/browserify-zlib/-/browserify-zlib-0.2.0.tgz -> npmpkg-browserify-zlib-0.2.0.tgz
https://registry.npmjs.org/buffer/-/buffer-4.9.2.tgz -> npmpkg-buffer-4.9.2.tgz
https://registry.npmjs.org/buffer-from/-/buffer-from-1.1.2.tgz -> npmpkg-buffer-from-1.1.2.tgz
https://registry.npmjs.org/buffer-xor/-/buffer-xor-1.0.3.tgz -> npmpkg-buffer-xor-1.0.3.tgz
https://registry.npmjs.org/builtin-status-codes/-/builtin-status-codes-3.0.0.tgz -> npmpkg-builtin-status-codes-3.0.0.tgz
https://registry.npmjs.org/cacache/-/cacache-12.0.4.tgz -> npmpkg-cacache-12.0.4.tgz
https://registry.npmjs.org/cache-base/-/cache-base-1.0.1.tgz -> npmpkg-cache-base-1.0.1.tgz
https://registry.npmjs.org/call-bind/-/call-bind-1.0.7.tgz -> npmpkg-call-bind-1.0.7.tgz
https://registry.npmjs.org/callsites/-/callsites-3.1.0.tgz -> npmpkg-callsites-3.1.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-5.3.1.tgz -> npmpkg-camelcase-5.3.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/chokidar/-/chokidar-3.6.0.tgz -> npmpkg-chokidar-3.6.0.tgz
https://registry.npmjs.org/braces/-/braces-3.0.3.tgz -> npmpkg-braces-3.0.3.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.1.1.tgz -> npmpkg-fill-range-7.1.1.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz -> npmpkg-is-number-7.0.0.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz -> npmpkg-to-regex-range-5.0.1.tgz
https://registry.npmjs.org/chownr/-/chownr-1.1.4.tgz -> npmpkg-chownr-1.1.4.tgz
https://registry.npmjs.org/chrome-trace-event/-/chrome-trace-event-1.0.4.tgz -> npmpkg-chrome-trace-event-1.0.4.tgz
https://registry.npmjs.org/ci-info/-/ci-info-2.0.0.tgz -> npmpkg-ci-info-2.0.0.tgz
https://registry.npmjs.org/cipher-base/-/cipher-base-1.0.4.tgz -> npmpkg-cipher-base-1.0.4.tgz
https://registry.npmjs.org/class-utils/-/class-utils-0.3.6.tgz -> npmpkg-class-utils-0.3.6.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.7.tgz -> npmpkg-is-descriptor-0.1.7.tgz
https://registry.npmjs.org/cliui/-/cliui-5.0.0.tgz -> npmpkg-cliui-5.0.0.tgz
https://registry.npmjs.org/collection-visit/-/collection-visit-1.0.0.tgz -> npmpkg-collection-visit-1.0.0.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/colors/-/colors-1.4.0.tgz -> npmpkg-colors-1.4.0.tgz
https://registry.npmjs.org/commander/-/commander-2.20.3.tgz -> npmpkg-commander-2.20.3.tgz
https://registry.npmjs.org/commondir/-/commondir-1.0.1.tgz -> npmpkg-commondir-1.0.1.tgz
https://registry.npmjs.org/compare-versions/-/compare-versions-3.6.0.tgz -> npmpkg-compare-versions-3.6.0.tgz
https://registry.npmjs.org/component-emitter/-/component-emitter-1.3.1.tgz -> npmpkg-component-emitter-1.3.1.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/concat-stream/-/concat-stream-1.6.2.tgz -> npmpkg-concat-stream-1.6.2.tgz
https://registry.npmjs.org/concurrently/-/concurrently-5.3.0.tgz -> npmpkg-concurrently-5.3.0.tgz
https://registry.npmjs.org/console-browserify/-/console-browserify-1.2.0.tgz -> npmpkg-console-browserify-1.2.0.tgz
https://registry.npmjs.org/constants-browserify/-/constants-browserify-1.0.0.tgz -> npmpkg-constants-browserify-1.0.0.tgz
https://registry.npmjs.org/copy-concurrently/-/copy-concurrently-1.0.5.tgz -> npmpkg-copy-concurrently-1.0.5.tgz
https://registry.npmjs.org/copy-descriptor/-/copy-descriptor-0.1.1.tgz -> npmpkg-copy-descriptor-0.1.1.tgz
https://registry.npmjs.org/copy-webpack-plugin/-/copy-webpack-plugin-5.1.2.tgz -> npmpkg-copy-webpack-plugin-5.1.2.tgz
https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.3.tgz -> npmpkg-core-util-is-1.0.3.tgz
https://registry.npmjs.org/corser/-/corser-2.0.1.tgz -> npmpkg-corser-2.0.1.tgz
https://registry.npmjs.org/cosmiconfig/-/cosmiconfig-7.1.0.tgz -> npmpkg-cosmiconfig-7.1.0.tgz
https://registry.npmjs.org/path-type/-/path-type-4.0.0.tgz -> npmpkg-path-type-4.0.0.tgz
https://registry.npmjs.org/create-ecdh/-/create-ecdh-4.0.4.tgz -> npmpkg-create-ecdh-4.0.4.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.1.tgz -> npmpkg-bn.js-4.12.1.tgz
https://registry.npmjs.org/create-hash/-/create-hash-1.2.0.tgz -> npmpkg-create-hash-1.2.0.tgz
https://registry.npmjs.org/create-hmac/-/create-hmac-1.1.7.tgz -> npmpkg-create-hmac-1.1.7.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-6.0.5.tgz -> npmpkg-cross-spawn-6.0.5.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/crypto-browserify/-/crypto-browserify-3.12.1.tgz -> npmpkg-crypto-browserify-3.12.1.tgz
https://registry.npmjs.org/css-loader/-/css-loader-3.6.0.tgz -> npmpkg-css-loader-3.6.0.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-2.7.1.tgz -> npmpkg-schema-utils-2.7.1.tgz
https://registry.npmjs.org/cssesc/-/cssesc-3.0.0.tgz -> npmpkg-cssesc-3.0.0.tgz
https://registry.npmjs.org/cyclist/-/cyclist-1.0.2.tgz -> npmpkg-cyclist-1.0.2.tgz
https://registry.npmjs.org/date-fns/-/date-fns-2.30.0.tgz -> npmpkg-date-fns-2.30.0.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/decamelize/-/decamelize-1.2.0.tgz -> npmpkg-decamelize-1.2.0.tgz
https://registry.npmjs.org/decode-uri-component/-/decode-uri-component-0.2.2.tgz -> npmpkg-decode-uri-component-0.2.2.tgz
https://registry.npmjs.org/define-data-property/-/define-data-property-1.1.4.tgz -> npmpkg-define-data-property-1.1.4.tgz
https://registry.npmjs.org/define-properties/-/define-properties-1.2.1.tgz -> npmpkg-define-properties-1.2.1.tgz
https://registry.npmjs.org/define-property/-/define-property-2.0.2.tgz -> npmpkg-define-property-2.0.2.tgz
https://registry.npmjs.org/des.js/-/des.js-1.1.0.tgz -> npmpkg-des.js-1.1.0.tgz
https://registry.npmjs.org/detect-file/-/detect-file-1.0.0.tgz -> npmpkg-detect-file-1.0.0.tgz
https://registry.npmjs.org/diffie-hellman/-/diffie-hellman-5.0.3.tgz -> npmpkg-diffie-hellman-5.0.3.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.1.tgz -> npmpkg-bn.js-4.12.1.tgz
https://registry.npmjs.org/dir-glob/-/dir-glob-2.2.2.tgz -> npmpkg-dir-glob-2.2.2.tgz
https://registry.npmjs.org/domain-browser/-/domain-browser-1.2.0.tgz -> npmpkg-domain-browser-1.2.0.tgz
https://registry.npmjs.org/dotenv/-/dotenv-6.2.0.tgz -> npmpkg-dotenv-6.2.0.tgz
https://registry.npmjs.org/dotenv-defaults/-/dotenv-defaults-1.1.1.tgz -> npmpkg-dotenv-defaults-1.1.1.tgz
https://registry.npmjs.org/dotenv-webpack/-/dotenv-webpack-1.8.0.tgz -> npmpkg-dotenv-webpack-1.8.0.tgz
https://registry.npmjs.org/duplexify/-/duplexify-3.7.1.tgz -> npmpkg-duplexify-3.7.1.tgz
https://registry.npmjs.org/ecstatic/-/ecstatic-3.3.2.tgz -> npmpkg-ecstatic-3.3.2.tgz
https://registry.npmjs.org/elliptic/-/elliptic-6.6.1.tgz -> npmpkg-elliptic-6.6.1.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.1.tgz -> npmpkg-bn.js-4.12.1.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-7.0.3.tgz -> npmpkg-emoji-regex-7.0.3.tgz
https://registry.npmjs.org/emojis-list/-/emojis-list-3.0.0.tgz -> npmpkg-emojis-list-3.0.0.tgz
https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.4.4.tgz -> npmpkg-end-of-stream-1.4.4.tgz
https://registry.npmjs.org/enhanced-resolve/-/enhanced-resolve-4.5.0.tgz -> npmpkg-enhanced-resolve-4.5.0.tgz
https://registry.npmjs.org/memory-fs/-/memory-fs-0.5.0.tgz -> npmpkg-memory-fs-0.5.0.tgz
https://registry.npmjs.org/entities/-/entities-2.2.0.tgz -> npmpkg-entities-2.2.0.tgz
https://registry.npmjs.org/errno/-/errno-0.1.8.tgz -> npmpkg-errno-0.1.8.tgz
https://registry.npmjs.org/error-ex/-/error-ex-1.3.2.tgz -> npmpkg-error-ex-1.3.2.tgz
https://registry.npmjs.org/es-define-property/-/es-define-property-1.0.0.tgz -> npmpkg-es-define-property-1.0.0.tgz
https://registry.npmjs.org/es-errors/-/es-errors-1.3.0.tgz -> npmpkg-es-errors-1.3.0.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-4.0.3.tgz -> npmpkg-eslint-scope-4.0.3.tgz
https://registry.npmjs.org/esrecurse/-/esrecurse-4.3.0.tgz -> npmpkg-esrecurse-4.3.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-5.3.0.tgz -> npmpkg-estraverse-5.3.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-4.3.0.tgz -> npmpkg-estraverse-4.3.0.tgz
https://registry.npmjs.org/eventemitter3/-/eventemitter3-4.0.7.tgz -> npmpkg-eventemitter3-4.0.7.tgz
https://registry.npmjs.org/events/-/events-3.3.0.tgz -> npmpkg-events-3.3.0.tgz
https://registry.npmjs.org/evp_bytestokey/-/evp_bytestokey-1.0.3.tgz -> npmpkg-evp_bytestokey-1.0.3.tgz
https://registry.npmjs.org/expand-brackets/-/expand-brackets-2.1.4.tgz -> npmpkg-expand-brackets-2.1.4.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.7.tgz -> npmpkg-is-descriptor-0.1.7.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/expand-tilde/-/expand-tilde-2.0.2.tgz -> npmpkg-expand-tilde-2.0.2.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-3.0.2.tgz -> npmpkg-extend-shallow-3.0.2.tgz
https://registry.npmjs.org/extglob/-/extglob-2.0.4.tgz -> npmpkg-extglob-2.0.4.tgz
https://registry.npmjs.org/define-property/-/define-property-1.0.0.tgz -> npmpkg-define-property-1.0.0.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz -> npmpkg-fast-deep-equal-3.1.3.tgz
https://registry.npmjs.org/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz -> npmpkg-fast-json-stable-stringify-2.1.0.tgz
https://registry.npmjs.org/figgy-pudding/-/figgy-pudding-3.5.2.tgz -> npmpkg-figgy-pudding-3.5.2.tgz
https://registry.npmjs.org/file-uri-to-path/-/file-uri-to-path-1.0.0.tgz -> npmpkg-file-uri-to-path-1.0.0.tgz
https://registry.npmjs.org/fill-range/-/fill-range-4.0.0.tgz -> npmpkg-fill-range-4.0.0.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/find-cache-dir/-/find-cache-dir-2.1.0.tgz -> npmpkg-find-cache-dir-2.1.0.tgz
https://registry.npmjs.org/find-up/-/find-up-3.0.0.tgz -> npmpkg-find-up-3.0.0.tgz
https://registry.npmjs.org/find-versions/-/find-versions-4.0.0.tgz -> npmpkg-find-versions-4.0.0.tgz
https://registry.npmjs.org/findup-sync/-/findup-sync-3.0.0.tgz -> npmpkg-findup-sync-3.0.0.tgz
https://registry.npmjs.org/flush-write-stream/-/flush-write-stream-1.1.1.tgz -> npmpkg-flush-write-stream-1.1.1.tgz
https://registry.npmjs.org/follow-redirects/-/follow-redirects-1.15.9.tgz -> npmpkg-follow-redirects-1.15.9.tgz
https://registry.npmjs.org/for-in/-/for-in-1.0.2.tgz -> npmpkg-for-in-1.0.2.tgz
https://registry.npmjs.org/fragment-cache/-/fragment-cache-0.2.1.tgz -> npmpkg-fragment-cache-0.2.1.tgz
https://registry.npmjs.org/from2/-/from2-2.3.0.tgz -> npmpkg-from2-2.3.0.tgz
https://registry.npmjs.org/fs-write-stream-atomic/-/fs-write-stream-atomic-1.0.10.tgz -> npmpkg-fs-write-stream-atomic-1.0.10.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz -> npmpkg-fs.realpath-1.0.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz -> npmpkg-fsevents-2.3.3.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.2.tgz -> npmpkg-function-bind-1.1.2.tgz
https://registry.npmjs.org/get-caller-file/-/get-caller-file-2.0.5.tgz -> npmpkg-get-caller-file-2.0.5.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.2.4.tgz -> npmpkg-get-intrinsic-1.2.4.tgz
https://registry.npmjs.org/get-value/-/get-value-2.0.6.tgz -> npmpkg-get-value-2.0.6.tgz
https://registry.npmjs.org/glob/-/glob-7.2.3.tgz -> npmpkg-glob-7.2.3.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-3.1.0.tgz -> npmpkg-glob-parent-3.1.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-3.1.0.tgz -> npmpkg-is-glob-3.1.0.tgz
https://registry.npmjs.org/global-modules/-/global-modules-2.0.0.tgz -> npmpkg-global-modules-2.0.0.tgz
https://registry.npmjs.org/global-prefix/-/global-prefix-3.0.0.tgz -> npmpkg-global-prefix-3.0.0.tgz
https://registry.npmjs.org/globby/-/globby-7.1.1.tgz -> npmpkg-globby-7.1.1.tgz
https://registry.npmjs.org/gopd/-/gopd-1.0.1.tgz -> npmpkg-gopd-1.0.1.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.11.tgz -> npmpkg-graceful-fs-4.2.11.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/has-property-descriptors/-/has-property-descriptors-1.0.2.tgz -> npmpkg-has-property-descriptors-1.0.2.tgz
https://registry.npmjs.org/has-proto/-/has-proto-1.0.3.tgz -> npmpkg-has-proto-1.0.3.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.0.3.tgz -> npmpkg-has-symbols-1.0.3.tgz
https://registry.npmjs.org/has-value/-/has-value-1.0.0.tgz -> npmpkg-has-value-1.0.0.tgz
https://registry.npmjs.org/has-values/-/has-values-1.0.0.tgz -> npmpkg-has-values-1.0.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-4.0.0.tgz -> npmpkg-kind-of-4.0.0.tgz
https://registry.npmjs.org/hash-base/-/hash-base-3.0.4.tgz -> npmpkg-hash-base-3.0.4.tgz
https://registry.npmjs.org/hash.js/-/hash.js-1.1.7.tgz -> npmpkg-hash.js-1.1.7.tgz
https://registry.npmjs.org/hasown/-/hasown-2.0.2.tgz -> npmpkg-hasown-2.0.2.tgz
https://registry.npmjs.org/he/-/he-1.2.0.tgz -> npmpkg-he-1.2.0.tgz
https://registry.npmjs.org/hmac-drbg/-/hmac-drbg-1.0.1.tgz -> npmpkg-hmac-drbg-1.0.1.tgz
https://registry.npmjs.org/homedir-polyfill/-/homedir-polyfill-1.0.3.tgz -> npmpkg-homedir-polyfill-1.0.3.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-2.8.9.tgz -> npmpkg-hosted-git-info-2.8.9.tgz
https://registry.npmjs.org/http-proxy/-/http-proxy-1.18.1.tgz -> npmpkg-http-proxy-1.18.1.tgz
https://registry.npmjs.org/http-server/-/http-server-0.12.3.tgz -> npmpkg-http-server-0.12.3.tgz
https://registry.npmjs.org/https-browserify/-/https-browserify-1.0.0.tgz -> npmpkg-https-browserify-1.0.0.tgz
https://registry.npmjs.org/husky/-/husky-4.3.8.tgz -> npmpkg-husky-4.3.8.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz -> npmpkg-chalk-4.1.2.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/find-up/-/find-up-5.0.0.tgz -> npmpkg-find-up-5.0.0.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-6.0.0.tgz -> npmpkg-locate-path-6.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-3.1.0.tgz -> npmpkg-p-limit-3.1.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-5.0.0.tgz -> npmpkg-p-locate-5.0.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-4.0.0.tgz -> npmpkg-path-exists-4.0.0.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-5.0.0.tgz -> npmpkg-pkg-dir-5.0.0.tgz
https://registry.npmjs.org/slash/-/slash-3.0.0.tgz -> npmpkg-slash-3.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/icss-utils/-/icss-utils-4.1.1.tgz -> npmpkg-icss-utils-4.1.1.tgz
https://registry.npmjs.org/ieee754/-/ieee754-1.2.1.tgz -> npmpkg-ieee754-1.2.1.tgz
https://registry.npmjs.org/iferr/-/iferr-0.1.5.tgz -> npmpkg-iferr-0.1.5.tgz
https://registry.npmjs.org/ignore/-/ignore-3.3.10.tgz -> npmpkg-ignore-3.3.10.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz -> npmpkg-import-fresh-3.3.0.tgz
https://registry.npmjs.org/import-local/-/import-local-2.0.0.tgz -> npmpkg-import-local-2.0.0.tgz
https://registry.npmjs.org/imurmurhash/-/imurmurhash-0.1.4.tgz -> npmpkg-imurmurhash-0.1.4.tgz
https://registry.npmjs.org/infer-owner/-/infer-owner-1.0.4.tgz -> npmpkg-infer-owner-1.0.4.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz -> npmpkg-inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz -> npmpkg-inherits-2.0.4.tgz
https://registry.npmjs.org/ini/-/ini-1.3.8.tgz -> npmpkg-ini-1.3.8.tgz
https://registry.npmjs.org/interpret/-/interpret-1.4.0.tgz -> npmpkg-interpret-1.4.0.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-1.0.1.tgz -> npmpkg-is-accessor-descriptor-1.0.1.tgz
https://registry.npmjs.org/is-arrayish/-/is-arrayish-0.2.1.tgz -> npmpkg-is-arrayish-0.2.1.tgz
https://registry.npmjs.org/is-binary-path/-/is-binary-path-2.1.0.tgz -> npmpkg-is-binary-path-2.1.0.tgz
https://registry.npmjs.org/is-buffer/-/is-buffer-1.1.6.tgz -> npmpkg-is-buffer-1.1.6.tgz
https://registry.npmjs.org/is-core-module/-/is-core-module-2.15.1.tgz -> npmpkg-is-core-module-2.15.1.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-1.0.1.tgz -> npmpkg-is-data-descriptor-1.0.1.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-1.0.3.tgz -> npmpkg-is-descriptor-1.0.3.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-1.0.1.tgz -> npmpkg-is-extendable-1.0.1.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz -> npmpkg-is-extglob-2.1.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/is-number/-/is-number-3.0.0.tgz -> npmpkg-is-number-3.0.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/is-plain-object/-/is-plain-object-2.0.4.tgz -> npmpkg-is-plain-object-2.0.4.tgz
https://registry.npmjs.org/is-windows/-/is-windows-1.0.2.tgz -> npmpkg-is-windows-1.0.2.tgz
https://registry.npmjs.org/is-wsl/-/is-wsl-1.1.0.tgz -> npmpkg-is-wsl-1.1.0.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz -> npmpkg-isexe-2.0.0.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/js-tokens/-/js-tokens-4.0.0.tgz -> npmpkg-js-tokens-4.0.0.tgz
https://registry.npmjs.org/json-parse-better-errors/-/json-parse-better-errors-1.0.2.tgz -> npmpkg-json-parse-better-errors-1.0.2.tgz
https://registry.npmjs.org/json-parse-even-better-errors/-/json-parse-even-better-errors-2.3.1.tgz -> npmpkg-json-parse-even-better-errors-2.3.1.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz -> npmpkg-json-schema-traverse-0.4.1.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/lines-and-columns/-/lines-and-columns-1.2.4.tgz -> npmpkg-lines-and-columns-1.2.4.tgz
https://registry.npmjs.org/loader-runner/-/loader-runner-2.4.0.tgz -> npmpkg-loader-runner-2.4.0.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz -> npmpkg-loader-utils-1.4.2.tgz
https://registry.npmjs.org/locate-path/-/locate-path-3.0.0.tgz -> npmpkg-locate-path-3.0.0.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-5.1.1.tgz -> npmpkg-lru-cache-5.1.1.tgz
https://registry.npmjs.org/make-dir/-/make-dir-2.1.0.tgz -> npmpkg-make-dir-2.1.0.tgz
https://registry.npmjs.org/pify/-/pify-4.0.1.tgz -> npmpkg-pify-4.0.1.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/map-cache/-/map-cache-0.2.2.tgz -> npmpkg-map-cache-0.2.2.tgz
https://registry.npmjs.org/map-visit/-/map-visit-1.0.0.tgz -> npmpkg-map-visit-1.0.0.tgz
https://registry.npmjs.org/md5.js/-/md5.js-1.3.5.tgz -> npmpkg-md5.js-1.3.5.tgz
https://registry.npmjs.org/memory-fs/-/memory-fs-0.4.1.tgz -> npmpkg-memory-fs-0.4.1.tgz
https://registry.npmjs.org/micromatch/-/micromatch-3.1.10.tgz -> npmpkg-micromatch-3.1.10.tgz
https://registry.npmjs.org/miller-rabin/-/miller-rabin-4.0.1.tgz -> npmpkg-miller-rabin-4.0.1.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.1.tgz -> npmpkg-bn.js-4.12.1.tgz
https://registry.npmjs.org/mime/-/mime-1.6.0.tgz -> npmpkg-mime-1.6.0.tgz
https://registry.npmjs.org/minimalistic-assert/-/minimalistic-assert-1.0.1.tgz -> npmpkg-minimalistic-assert-1.0.1.tgz
https://registry.npmjs.org/minimalistic-crypto-utils/-/minimalistic-crypto-utils-1.0.1.tgz -> npmpkg-minimalistic-crypto-utils-1.0.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.8.tgz -> npmpkg-minimist-1.2.8.tgz
https://registry.npmjs.org/mississippi/-/mississippi-3.0.0.tgz -> npmpkg-mississippi-3.0.0.tgz
https://registry.npmjs.org/mixin-deep/-/mixin-deep-1.3.2.tgz -> npmpkg-mixin-deep-1.3.2.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.6.tgz -> npmpkg-mkdirp-0.5.6.tgz
https://registry.npmjs.org/move-concurrently/-/move-concurrently-1.0.1.tgz -> npmpkg-move-concurrently-1.0.1.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/nan/-/nan-2.22.0.tgz -> npmpkg-nan-2.22.0.tgz
https://registry.npmjs.org/nanomatch/-/nanomatch-1.2.13.tgz -> npmpkg-nanomatch-1.2.13.tgz
https://registry.npmjs.org/neo-async/-/neo-async-2.6.2.tgz -> npmpkg-neo-async-2.6.2.tgz
https://registry.npmjs.org/nice-try/-/nice-try-1.0.5.tgz -> npmpkg-nice-try-1.0.5.tgz
https://registry.npmjs.org/node-libs-browser/-/node-libs-browser-2.2.1.tgz -> npmpkg-node-libs-browser-2.2.1.tgz
https://registry.npmjs.org/punycode/-/punycode-1.4.1.tgz -> npmpkg-punycode-1.4.1.tgz
https://registry.npmjs.org/normalize-package-data/-/normalize-package-data-2.5.0.tgz -> npmpkg-normalize-package-data-2.5.0.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz -> npmpkg-normalize-path-3.0.0.tgz
https://registry.npmjs.org/object-copy/-/object-copy-0.1.0.tgz -> npmpkg-object-copy-0.1.0.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.7.tgz -> npmpkg-is-descriptor-0.1.7.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/object-inspect/-/object-inspect-1.13.3.tgz -> npmpkg-object-inspect-1.13.3.tgz
https://registry.npmjs.org/object-keys/-/object-keys-1.1.1.tgz -> npmpkg-object-keys-1.1.1.tgz
https://registry.npmjs.org/object-visit/-/object-visit-1.0.1.tgz -> npmpkg-object-visit-1.0.1.tgz
https://registry.npmjs.org/object.assign/-/object.assign-4.1.5.tgz -> npmpkg-object.assign-4.1.5.tgz
https://registry.npmjs.org/object.pick/-/object.pick-1.3.0.tgz -> npmpkg-object.pick-1.3.0.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz -> npmpkg-once-1.4.0.tgz
https://registry.npmjs.org/opencollective-postinstall/-/opencollective-postinstall-2.0.3.tgz -> npmpkg-opencollective-postinstall-2.0.3.tgz
https://registry.npmjs.org/opener/-/opener-1.5.2.tgz -> npmpkg-opener-1.5.2.tgz
https://registry.npmjs.org/os-browserify/-/os-browserify-0.3.0.tgz -> npmpkg-os-browserify-0.3.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-3.0.0.tgz -> npmpkg-p-locate-3.0.0.tgz
https://registry.npmjs.org/p-try/-/p-try-2.2.0.tgz -> npmpkg-p-try-2.2.0.tgz
https://registry.npmjs.org/pako/-/pako-1.0.11.tgz -> npmpkg-pako-1.0.11.tgz
https://registry.npmjs.org/parallel-transform/-/parallel-transform-1.2.0.tgz -> npmpkg-parallel-transform-1.2.0.tgz
https://registry.npmjs.org/parent-module/-/parent-module-1.0.1.tgz -> npmpkg-parent-module-1.0.1.tgz
https://registry.npmjs.org/parse-asn1/-/parse-asn1-5.1.7.tgz -> npmpkg-parse-asn1-5.1.7.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz -> npmpkg-safe-buffer-5.2.1.tgz
https://registry.npmjs.org/parse-json/-/parse-json-5.2.0.tgz -> npmpkg-parse-json-5.2.0.tgz
https://registry.npmjs.org/parse-passwd/-/parse-passwd-1.0.0.tgz -> npmpkg-parse-passwd-1.0.0.tgz
https://registry.npmjs.org/pascalcase/-/pascalcase-0.1.1.tgz -> npmpkg-pascalcase-0.1.1.tgz
https://registry.npmjs.org/path-browserify/-/path-browserify-0.0.1.tgz -> npmpkg-path-browserify-0.0.1.tgz
https://registry.npmjs.org/path-dirname/-/path-dirname-1.0.2.tgz -> npmpkg-path-dirname-1.0.2.tgz
https://registry.npmjs.org/path-exists/-/path-exists-3.0.0.tgz -> npmpkg-path-exists-3.0.0.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> npmpkg-path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/path-key/-/path-key-2.0.1.tgz -> npmpkg-path-key-2.0.1.tgz
https://registry.npmjs.org/path-parse/-/path-parse-1.0.7.tgz -> npmpkg-path-parse-1.0.7.tgz
https://registry.npmjs.org/path-type/-/path-type-3.0.0.tgz -> npmpkg-path-type-3.0.0.tgz
https://registry.npmjs.org/pbkdf2/-/pbkdf2-3.1.2.tgz -> npmpkg-pbkdf2-3.1.2.tgz
https://registry.npmjs.org/picocolors/-/picocolors-1.1.1.tgz -> npmpkg-picocolors-1.1.1.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.3.1.tgz -> npmpkg-picomatch-2.3.1.tgz
https://registry.npmjs.org/pify/-/pify-3.0.0.tgz -> npmpkg-pify-3.0.0.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-3.0.0.tgz -> npmpkg-pkg-dir-3.0.0.tgz
https://registry.npmjs.org/please-upgrade-node/-/please-upgrade-node-3.2.0.tgz -> npmpkg-please-upgrade-node-3.2.0.tgz
https://registry.npmjs.org/portfinder/-/portfinder-1.0.32.tgz -> npmpkg-portfinder-1.0.32.tgz
https://registry.npmjs.org/posix-character-classes/-/posix-character-classes-0.1.1.tgz -> npmpkg-posix-character-classes-0.1.1.tgz
https://registry.npmjs.org/postcss/-/postcss-7.0.39.tgz -> npmpkg-postcss-7.0.39.tgz
https://registry.npmjs.org/postcss-modules-extract-imports/-/postcss-modules-extract-imports-2.0.0.tgz -> npmpkg-postcss-modules-extract-imports-2.0.0.tgz
https://registry.npmjs.org/postcss-modules-local-by-default/-/postcss-modules-local-by-default-3.0.3.tgz -> npmpkg-postcss-modules-local-by-default-3.0.3.tgz
https://registry.npmjs.org/postcss-modules-scope/-/postcss-modules-scope-2.2.0.tgz -> npmpkg-postcss-modules-scope-2.2.0.tgz
https://registry.npmjs.org/postcss-modules-values/-/postcss-modules-values-3.0.0.tgz -> npmpkg-postcss-modules-values-3.0.0.tgz
https://registry.npmjs.org/postcss-selector-parser/-/postcss-selector-parser-6.1.2.tgz -> npmpkg-postcss-selector-parser-6.1.2.tgz
https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-4.2.0.tgz -> npmpkg-postcss-value-parser-4.2.0.tgz
https://registry.npmjs.org/picocolors/-/picocolors-0.2.1.tgz -> npmpkg-picocolors-0.2.1.tgz
https://registry.npmjs.org/process/-/process-0.11.10.tgz -> npmpkg-process-0.11.10.tgz
https://registry.npmjs.org/process-nextick-args/-/process-nextick-args-2.0.1.tgz -> npmpkg-process-nextick-args-2.0.1.tgz
https://registry.npmjs.org/promise-inflight/-/promise-inflight-1.0.1.tgz -> npmpkg-promise-inflight-1.0.1.tgz
https://registry.npmjs.org/prr/-/prr-1.0.1.tgz -> npmpkg-prr-1.0.1.tgz
https://registry.npmjs.org/public-encrypt/-/public-encrypt-4.0.3.tgz -> npmpkg-public-encrypt-4.0.3.tgz
https://registry.npmjs.org/bn.js/-/bn.js-4.12.1.tgz -> npmpkg-bn.js-4.12.1.tgz
https://registry.npmjs.org/pump/-/pump-3.0.2.tgz -> npmpkg-pump-3.0.2.tgz
https://registry.npmjs.org/pumpify/-/pumpify-1.5.1.tgz -> npmpkg-pumpify-1.5.1.tgz
https://registry.npmjs.org/pump/-/pump-2.0.1.tgz -> npmpkg-pump-2.0.1.tgz
https://registry.npmjs.org/punycode/-/punycode-2.3.1.tgz -> npmpkg-punycode-2.3.1.tgz
https://registry.npmjs.org/qs/-/qs-6.13.0.tgz -> npmpkg-qs-6.13.0.tgz
https://registry.npmjs.org/querystring-es3/-/querystring-es3-0.2.1.tgz -> npmpkg-querystring-es3-0.2.1.tgz
https://registry.npmjs.org/randombytes/-/randombytes-2.1.0.tgz -> npmpkg-randombytes-2.1.0.tgz
https://registry.npmjs.org/randomfill/-/randomfill-1.0.4.tgz -> npmpkg-randomfill-1.0.4.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-4.0.1.tgz -> npmpkg-read-pkg-4.0.1.tgz
https://registry.npmjs.org/parse-json/-/parse-json-4.0.0.tgz -> npmpkg-parse-json-4.0.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/readdirp/-/readdirp-3.6.0.tgz -> npmpkg-readdirp-3.6.0.tgz
https://registry.npmjs.org/regenerator-runtime/-/regenerator-runtime-0.14.1.tgz -> npmpkg-regenerator-runtime-0.14.1.tgz
https://registry.npmjs.org/regex-not/-/regex-not-1.0.2.tgz -> npmpkg-regex-not-1.0.2.tgz
https://registry.npmjs.org/remove-trailing-separator/-/remove-trailing-separator-1.1.0.tgz -> npmpkg-remove-trailing-separator-1.1.0.tgz
https://registry.npmjs.org/repeat-element/-/repeat-element-1.1.4.tgz -> npmpkg-repeat-element-1.1.4.tgz
https://registry.npmjs.org/repeat-string/-/repeat-string-1.6.1.tgz -> npmpkg-repeat-string-1.6.1.tgz
https://registry.npmjs.org/require-directory/-/require-directory-2.1.1.tgz -> npmpkg-require-directory-2.1.1.tgz
https://registry.npmjs.org/require-main-filename/-/require-main-filename-2.0.0.tgz -> npmpkg-require-main-filename-2.0.0.tgz
https://registry.npmjs.org/requires-port/-/requires-port-1.0.0.tgz -> npmpkg-requires-port-1.0.0.tgz
https://registry.npmjs.org/resolve/-/resolve-1.22.8.tgz -> npmpkg-resolve-1.22.8.tgz
https://registry.npmjs.org/resolve-cwd/-/resolve-cwd-2.0.0.tgz -> npmpkg-resolve-cwd-2.0.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-3.0.0.tgz -> npmpkg-resolve-from-3.0.0.tgz
https://registry.npmjs.org/resolve-dir/-/resolve-dir-1.0.1.tgz -> npmpkg-resolve-dir-1.0.1.tgz
https://registry.npmjs.org/global-modules/-/global-modules-1.0.0.tgz -> npmpkg-global-modules-1.0.0.tgz
https://registry.npmjs.org/global-prefix/-/global-prefix-1.0.2.tgz -> npmpkg-global-prefix-1.0.2.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz -> npmpkg-resolve-from-4.0.0.tgz
https://registry.npmjs.org/resolve-url/-/resolve-url-0.2.1.tgz -> npmpkg-resolve-url-0.2.1.tgz
https://registry.npmjs.org/ret/-/ret-0.1.15.tgz -> npmpkg-ret-0.1.15.tgz
https://registry.npmjs.org/rimraf/-/rimraf-2.7.1.tgz -> npmpkg-rimraf-2.7.1.tgz
https://registry.npmjs.org/ripemd160/-/ripemd160-2.0.2.tgz -> npmpkg-ripemd160-2.0.2.tgz
https://registry.npmjs.org/run-queue/-/run-queue-1.0.3.tgz -> npmpkg-run-queue-1.0.3.tgz
https://registry.npmjs.org/rxjs/-/rxjs-6.6.7.tgz -> npmpkg-rxjs-6.6.7.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/safe-regex/-/safe-regex-1.1.0.tgz -> npmpkg-safe-regex-1.1.0.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-1.0.0.tgz -> npmpkg-schema-utils-1.0.0.tgz
https://registry.npmjs.org/secure-compare/-/secure-compare-3.0.1.tgz -> npmpkg-secure-compare-3.0.1.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/semver-compare/-/semver-compare-1.0.0.tgz -> npmpkg-semver-compare-1.0.0.tgz
https://registry.npmjs.org/semver-regex/-/semver-regex-3.1.4.tgz -> npmpkg-semver-regex-3.1.4.tgz
https://registry.npmjs.org/serialize-javascript/-/serialize-javascript-4.0.0.tgz -> npmpkg-serialize-javascript-4.0.0.tgz
https://registry.npmjs.org/set-blocking/-/set-blocking-2.0.0.tgz -> npmpkg-set-blocking-2.0.0.tgz
https://registry.npmjs.org/set-function-length/-/set-function-length-1.2.2.tgz -> npmpkg-set-function-length-1.2.2.tgz
https://registry.npmjs.org/set-value/-/set-value-2.0.1.tgz -> npmpkg-set-value-2.0.1.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/setimmediate/-/setimmediate-1.0.5.tgz -> npmpkg-setimmediate-1.0.5.tgz
https://registry.npmjs.org/sha.js/-/sha.js-2.4.11.tgz -> npmpkg-sha.js-2.4.11.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-1.2.0.tgz -> npmpkg-shebang-command-1.2.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-1.0.0.tgz -> npmpkg-shebang-regex-1.0.0.tgz
https://registry.npmjs.org/side-channel/-/side-channel-1.0.6.tgz -> npmpkg-side-channel-1.0.6.tgz
https://registry.npmjs.org/slash/-/slash-1.0.0.tgz -> npmpkg-slash-1.0.0.tgz
https://registry.npmjs.org/snapdragon/-/snapdragon-0.8.2.tgz -> npmpkg-snapdragon-0.8.2.tgz
https://registry.npmjs.org/snapdragon-node/-/snapdragon-node-2.1.1.tgz -> npmpkg-snapdragon-node-2.1.1.tgz
https://registry.npmjs.org/define-property/-/define-property-1.0.0.tgz -> npmpkg-define-property-1.0.0.tgz
https://registry.npmjs.org/snapdragon-util/-/snapdragon-util-3.0.1.tgz -> npmpkg-snapdragon-util-3.0.1.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.7.tgz -> npmpkg-is-descriptor-0.1.7.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/source-map/-/source-map-0.5.7.tgz -> npmpkg-source-map-0.5.7.tgz
https://registry.npmjs.org/source-list-map/-/source-list-map-2.0.1.tgz -> npmpkg-source-list-map-2.0.1.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/source-map-resolve/-/source-map-resolve-0.5.3.tgz -> npmpkg-source-map-resolve-0.5.3.tgz
https://registry.npmjs.org/source-map-support/-/source-map-support-0.5.21.tgz -> npmpkg-source-map-support-0.5.21.tgz
https://registry.npmjs.org/source-map-url/-/source-map-url-0.4.1.tgz -> npmpkg-source-map-url-0.4.1.tgz
https://registry.npmjs.org/spawn-command/-/spawn-command-0.0.2.tgz -> npmpkg-spawn-command-0.0.2.tgz
https://registry.npmjs.org/spdx-correct/-/spdx-correct-3.2.0.tgz -> npmpkg-spdx-correct-3.2.0.tgz
https://registry.npmjs.org/spdx-exceptions/-/spdx-exceptions-2.5.0.tgz -> npmpkg-spdx-exceptions-2.5.0.tgz
https://registry.npmjs.org/spdx-expression-parse/-/spdx-expression-parse-3.0.1.tgz -> npmpkg-spdx-expression-parse-3.0.1.tgz
https://registry.npmjs.org/spdx-license-ids/-/spdx-license-ids-3.0.20.tgz -> npmpkg-spdx-license-ids-3.0.20.tgz
https://registry.npmjs.org/split-string/-/split-string-3.1.0.tgz -> npmpkg-split-string-3.1.0.tgz
https://registry.npmjs.org/ssri/-/ssri-6.0.2.tgz -> npmpkg-ssri-6.0.2.tgz
https://registry.npmjs.org/static-extend/-/static-extend-0.1.2.tgz -> npmpkg-static-extend-0.1.2.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.7.tgz -> npmpkg-is-descriptor-0.1.7.tgz
https://registry.npmjs.org/stream-browserify/-/stream-browserify-2.0.2.tgz -> npmpkg-stream-browserify-2.0.2.tgz
https://registry.npmjs.org/stream-each/-/stream-each-1.2.3.tgz -> npmpkg-stream-each-1.2.3.tgz
https://registry.npmjs.org/stream-http/-/stream-http-2.8.3.tgz -> npmpkg-stream-http-2.8.3.tgz
https://registry.npmjs.org/stream-shift/-/stream-shift-1.0.3.tgz -> npmpkg-stream-shift-1.0.3.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-1.1.1.tgz -> npmpkg-string_decoder-1.1.1.tgz
https://registry.npmjs.org/string-width/-/string-width-3.1.0.tgz -> npmpkg-string-width-3.1.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-5.2.0.tgz -> npmpkg-strip-ansi-5.2.0.tgz
https://registry.npmjs.org/style-loader/-/style-loader-1.3.0.tgz -> npmpkg-style-loader-1.3.0.tgz
https://registry.npmjs.org/json5/-/json5-2.2.3.tgz -> npmpkg-json5-2.2.3.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-2.0.4.tgz -> npmpkg-loader-utils-2.0.4.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-2.7.1.tgz -> npmpkg-schema-utils-2.7.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-6.1.0.tgz -> npmpkg-supports-color-6.1.0.tgz
https://registry.npmjs.org/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz -> npmpkg-supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.npmjs.org/tapable/-/tapable-1.1.3.tgz -> npmpkg-tapable-1.1.3.tgz
https://registry.npmjs.org/terser/-/terser-4.8.1.tgz -> npmpkg-terser-4.8.1.tgz
https://registry.npmjs.org/terser-webpack-plugin/-/terser-webpack-plugin-1.4.6.tgz -> npmpkg-terser-webpack-plugin-1.4.6.tgz
https://registry.npmjs.org/through2/-/through2-2.0.5.tgz -> npmpkg-through2-2.0.5.tgz
https://github.com/rdkcentral/ThunderJS/archive/069dab31982f6032ea7b5a5bfa71c372b45bee52.tar.gz -> npmpkg-ThunderJS.git-069dab31982f6032ea7b5a5bfa71c372b45bee52.tgz
https://registry.npmjs.org/timers-browserify/-/timers-browserify-2.0.12.tgz -> npmpkg-timers-browserify-2.0.12.tgz
https://registry.npmjs.org/to-arraybuffer/-/to-arraybuffer-1.0.1.tgz -> npmpkg-to-arraybuffer-1.0.1.tgz
https://registry.npmjs.org/to-object-path/-/to-object-path-0.3.0.tgz -> npmpkg-to-object-path-0.3.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/to-regex/-/to-regex-3.0.2.tgz -> npmpkg-to-regex-3.0.2.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-2.1.1.tgz -> npmpkg-to-regex-range-2.1.1.tgz
https://registry.npmjs.org/tree-kill/-/tree-kill-1.2.2.tgz -> npmpkg-tree-kill-1.2.2.tgz
https://registry.npmjs.org/tslib/-/tslib-1.14.1.tgz -> npmpkg-tslib-1.14.1.tgz
https://registry.npmjs.org/tty-browserify/-/tty-browserify-0.0.0.tgz -> npmpkg-tty-browserify-0.0.0.tgz
https://registry.npmjs.org/typedarray/-/typedarray-0.0.6.tgz -> npmpkg-typedarray-0.0.6.tgz
https://registry.npmjs.org/union/-/union-0.5.0.tgz -> npmpkg-union-0.5.0.tgz
https://registry.npmjs.org/union-value/-/union-value-1.0.1.tgz -> npmpkg-union-value-1.0.1.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/unique-filename/-/unique-filename-1.1.1.tgz -> npmpkg-unique-filename-1.1.1.tgz
https://registry.npmjs.org/unique-slug/-/unique-slug-2.0.2.tgz -> npmpkg-unique-slug-2.0.2.tgz
https://registry.npmjs.org/unset-value/-/unset-value-1.0.0.tgz -> npmpkg-unset-value-1.0.0.tgz
https://registry.npmjs.org/has-value/-/has-value-0.3.1.tgz -> npmpkg-has-value-0.3.1.tgz
https://registry.npmjs.org/isobject/-/isobject-2.1.0.tgz -> npmpkg-isobject-2.1.0.tgz
https://registry.npmjs.org/has-values/-/has-values-0.1.4.tgz -> npmpkg-has-values-0.1.4.tgz
https://registry.npmjs.org/upath/-/upath-1.2.0.tgz -> npmpkg-upath-1.2.0.tgz
https://registry.npmjs.org/uri-js/-/uri-js-4.4.1.tgz -> npmpkg-uri-js-4.4.1.tgz
https://registry.npmjs.org/urix/-/urix-0.1.0.tgz -> npmpkg-urix-0.1.0.tgz
https://registry.npmjs.org/url/-/url-0.11.4.tgz -> npmpkg-url-0.11.4.tgz
https://registry.npmjs.org/url-join/-/url-join-2.0.5.tgz -> npmpkg-url-join-2.0.5.tgz
https://registry.npmjs.org/punycode/-/punycode-1.4.1.tgz -> npmpkg-punycode-1.4.1.tgz
https://registry.npmjs.org/use/-/use-3.1.1.tgz -> npmpkg-use-3.1.1.tgz
https://registry.npmjs.org/util/-/util-0.11.1.tgz -> npmpkg-util-0.11.1.tgz
https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz -> npmpkg-util-deprecate-1.0.2.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.3.tgz -> npmpkg-inherits-2.0.3.tgz
https://registry.npmjs.org/uuid/-/uuid-3.4.0.tgz -> npmpkg-uuid-3.4.0.tgz
https://registry.npmjs.org/v8-compile-cache/-/v8-compile-cache-2.4.0.tgz -> npmpkg-v8-compile-cache-2.4.0.tgz
https://registry.npmjs.org/validate-npm-package-license/-/validate-npm-package-license-3.0.4.tgz -> npmpkg-validate-npm-package-license-3.0.4.tgz
https://registry.npmjs.org/vm-browserify/-/vm-browserify-1.1.2.tgz -> npmpkg-vm-browserify-1.1.2.tgz
https://registry.npmjs.org/watchpack/-/watchpack-1.7.5.tgz -> npmpkg-watchpack-1.7.5.tgz
https://registry.npmjs.org/watchpack-chokidar2/-/watchpack-chokidar2-2.0.1.tgz -> npmpkg-watchpack-chokidar2-2.0.1.tgz
https://registry.npmjs.org/anymatch/-/anymatch-2.0.0.tgz -> npmpkg-anymatch-2.0.0.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-2.1.1.tgz -> npmpkg-normalize-path-2.1.1.tgz
https://registry.npmjs.org/binary-extensions/-/binary-extensions-1.13.1.tgz -> npmpkg-binary-extensions-1.13.1.tgz
https://registry.npmjs.org/chokidar/-/chokidar-2.1.8.tgz -> npmpkg-chokidar-2.1.8.tgz
https://registry.npmjs.org/fsevents/-/fsevents-1.2.13.tgz -> npmpkg-fsevents-1.2.13.tgz
https://registry.npmjs.org/is-binary-path/-/is-binary-path-1.0.1.tgz -> npmpkg-is-binary-path-1.0.1.tgz
https://registry.npmjs.org/readdirp/-/readdirp-2.2.1.tgz -> npmpkg-readdirp-2.2.1.tgz
https://registry.npmjs.org/webpack/-/webpack-4.47.0.tgz -> npmpkg-webpack-4.47.0.tgz
https://registry.npmjs.org/webpack-cli/-/webpack-cli-3.3.12.tgz -> npmpkg-webpack-cli-3.3.12.tgz
https://registry.npmjs.org/webpack-log/-/webpack-log-2.0.0.tgz -> npmpkg-webpack-log-2.0.0.tgz
https://registry.npmjs.org/webpack-sources/-/webpack-sources-1.4.3.tgz -> npmpkg-webpack-sources-1.4.3.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/which-module/-/which-module-2.0.1.tgz -> npmpkg-which-module-2.0.1.tgz
https://registry.npmjs.org/which-pm-runs/-/which-pm-runs-1.1.0.tgz -> npmpkg-which-pm-runs-1.1.0.tgz
https://registry.npmjs.org/worker-farm/-/worker-farm-1.7.0.tgz -> npmpkg-worker-farm-1.7.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-5.1.0.tgz -> npmpkg-wrap-ansi-5.1.0.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
https://registry.npmjs.org/ws/-/ws-7.5.10.tgz -> npmpkg-ws-7.5.10.tgz
https://registry.npmjs.org/xtend/-/xtend-4.0.2.tgz -> npmpkg-xtend-4.0.2.tgz
https://registry.npmjs.org/y18n/-/y18n-4.0.3.tgz -> npmpkg-y18n-4.0.3.tgz
https://registry.npmjs.org/yallist/-/yallist-3.1.1.tgz -> npmpkg-yallist-3.1.1.tgz
https://registry.npmjs.org/yaml/-/yaml-1.10.2.tgz -> npmpkg-yaml-1.10.2.tgz
https://registry.npmjs.org/yargs/-/yargs-13.3.2.tgz -> npmpkg-yargs-13.3.2.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-13.1.2.tgz -> npmpkg-yargs-parser-13.1.2.tgz
https://registry.npmjs.org/yocto-queue/-/yocto-queue-0.1.0.tgz -> npmpkg-yocto-queue-0.1.0.tgz
"
# UPDATER_END_NPM_EXTERNAL_URIS
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-R${PV}"
	SRC_URI="
${NPM_EXTERNAL_URIS}
https://github.com/rdkcentral/ThunderUI/archive/refs/tags/R${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="ThunderUI is the development and test UI that runs on top of Thunder"
HOMEPAGE="
	https://github.com/rdkcentral/ThunderUI
"
LICENSE="
	ISC
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
ebuild_revision_1
"
RDEPEND+="
	net-libs/nodejs:18[jit]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "readme.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		npm_src_unpack
	fi
}

src_configure() {
	:
}

src_compile() {
	npm_hydrate
	export NODE_OPTIONS="--openssl-legacy-provider"
	enpm run build
}

src_install() {
	insinto "/usr/share/Thunder/Controller/UI"
	doins -r "dist/"*
	docinto "licenses"
	dodoc "COPYING"
	dodoc "LICENSE"
	dodoc "NOTICE"
	docinto "ReleaseNotes"
	dodoc "ReleaseNotes/ReleaseNotes_R5.0.md"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
