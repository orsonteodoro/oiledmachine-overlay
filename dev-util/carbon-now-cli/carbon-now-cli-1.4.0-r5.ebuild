# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NODE_ENV="development"
NODE_VERSION=14 # Using nodejs muxer variable name.
NPM_INSTALL_PATH="/opt/${PN}"
NPM_EXE_LIST="
${NPM_INSTALL_PATH}/cli.js

${NPM_INSTALL_PATH}/node_modules/.bin/acorn
${NPM_INSTALL_PATH}/node_modules/.bin/atob
${NPM_INSTALL_PATH}/node_modules/.bin/ava
${NPM_INSTALL_PATH}/node_modules/.bin/babylon
${NPM_INSTALL_PATH}/node_modules/.bin/eslint
${NPM_INSTALL_PATH}/node_modules/.bin/eslint-config-prettier-check
${NPM_INSTALL_PATH}/node_modules/.bin/esparse
${NPM_INSTALL_PATH}/node_modules/.bin/esvalidate
${NPM_INSTALL_PATH}/node_modules/.bin/extract-zip
${NPM_INSTALL_PATH}/node_modules/.bin/husky-upgrade
${NPM_INSTALL_PATH}/node_modules/.bin/import-local-fixture
${NPM_INSTALL_PATH}/node_modules/.bin/is-ci
${NPM_INSTALL_PATH}/node_modules/.bin/js-yaml
${NPM_INSTALL_PATH}/node_modules/.bin/jsesc
${NPM_INSTALL_PATH}/node_modules/.bin/json5
${NPM_INSTALL_PATH}/node_modules/.bin/loose-envify
${NPM_INSTALL_PATH}/node_modules/.bin/mime
${NPM_INSTALL_PATH}/node_modules/.bin/mkdirp
${NPM_INSTALL_PATH}/node_modules/.bin/pixelmatch
${NPM_INSTALL_PATH}/node_modules/.bin/prettier
${NPM_INSTALL_PATH}/node_modules/.bin/rc
${NPM_INSTALL_PATH}/node_modules/.bin/regjsparser
${NPM_INSTALL_PATH}/node_modules/.bin/resolve
${NPM_INSTALL_PATH}/node_modules/.bin/rimraf
${NPM_INSTALL_PATH}/node_modules/.bin/run-node
${NPM_INSTALL_PATH}/node_modules/.bin/semver
${NPM_INSTALL_PATH}/node_modules/.bin/which
${NPM_INSTALL_PATH}/node_modules/.bin/xo
${NPM_INSTALL_PATH}/node_modules/@ladjs/time-require/node_modules/.bin/pretty-ms
${NPM_INSTALL_PATH}/node_modules/@ladjs/time-require/node_modules/.bin/strip-ansi
${NPM_INSTALL_PATH}/node_modules/@sindresorhus/jimp/node_modules/.bin/mime
${NPM_INSTALL_PATH}/node_modules/@sindresorhus/jimp/node_modules/.bin/mkdirp
${NPM_INSTALL_PATH}/node_modules/acorn-jsx/node_modules/.bin/acorn
${NPM_INSTALL_PATH}/node_modules/ava/node_modules/.bin/strip-indent
${NPM_INSTALL_PATH}/node_modules/eslint-plugin-import/node_modules/.bin/semver
${NPM_INSTALL_PATH}/node_modules/flat-cache/node_modules/.bin/rimraf
${NPM_INSTALL_PATH}/node_modules/husky/node_modules/.bin/is-ci
${NPM_INSTALL_PATH}/node_modules/load-bmfont/node_modules/.bin/mime
${NPM_INSTALL_PATH}/node_modules/regjsparser/node_modules/.bin/jsesc
${NPM_INSTALL_PATH}/node_modules/tsconfig-paths/node_modules/.bin/json5
"
inherit desktop npm

DESCRIPTION="Beautiful images of your code from right inside your terminal."
HOMEPAGE="https://github.com/mixn/carbon-now-cli"
LICENSE="MIT"
KEYWORDS="~amd64 ~amd64-linux ~x64-macos ~arm ~arm64 ~ppc ~ppc64 ~x86"
SLOT="0"
IUSE="clipboard custom-browser r1"
NODEJS_PV="8.3" # Upstream uses 10 on CI
RDEPEND="
	>=net-libs/nodejs-${NODEJS_PV}:${NODE_VERSION}
	>=net-libs/nodejs-${NODE_VERSION}[npm]
	clipboard? ( x11-misc/xclip )
	!custom-browser? (
		|| (
			www-client/chromium-bin
			www-client/chromium
			www-client/google-chrome
		)
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=net-libs/nodejs-${NODEJS_PV}:${NODE_VERSION}
	>=net-libs/nodejs-${NODE_VERSION}[npm]
"
MY_PN="${PN//-cli/}"
# Initially generated from:
#   grep "resolved" ${NPM_INSTALL_PATH}/package-lock.json | cut -f 4 -d '"' | cut -f 1 -d "#" | sort | uniq
# For the generator script, see the typescript/transform-uris.sh ebuild-package.
# UPDATER_START_NPM_EXTERNAL_URIS
NPM_EXTERNAL_URIS="
https://registry.npmjs.org/@ava/babel-plugin-throws-helper/-/babel-plugin-throws-helper-2.0.0.tgz -> npmpkg-@ava-babel-plugin-throws-helper-2.0.0.tgz
https://registry.npmjs.org/@ava/babel-preset-stage-4/-/babel-preset-stage-4-1.1.0.tgz -> npmpkg-@ava-babel-preset-stage-4-1.1.0.tgz
https://registry.npmjs.org/md5-hex/-/md5-hex-1.3.0.tgz -> npmpkg-md5-hex-1.3.0.tgz
https://registry.npmjs.org/package-hash/-/package-hash-1.2.0.tgz -> npmpkg-package-hash-1.2.0.tgz
https://registry.npmjs.org/@ava/babel-preset-transform-test-files/-/babel-preset-transform-test-files-3.0.0.tgz -> npmpkg-@ava-babel-preset-transform-test-files-3.0.0.tgz
https://registry.npmjs.org/@ava/write-file-atomic/-/write-file-atomic-2.2.0.tgz -> npmpkg-@ava-write-file-atomic-2.2.0.tgz
https://registry.npmjs.org/@concordance/react/-/react-1.0.0.tgz -> npmpkg-@concordance-react-1.0.0.tgz
https://registry.npmjs.org/@ladjs/time-require/-/time-require-0.1.4.tgz -> npmpkg-@ladjs-time-require-0.1.4.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-1.0.0.tgz -> npmpkg-ansi-styles-1.0.0.tgz
https://registry.npmjs.org/chalk/-/chalk-0.4.0.tgz -> npmpkg-chalk-0.4.0.tgz
https://registry.npmjs.org/parse-ms/-/parse-ms-0.1.2.tgz -> npmpkg-parse-ms-0.1.2.tgz
https://registry.npmjs.org/pretty-ms/-/pretty-ms-0.2.2.tgz -> npmpkg-pretty-ms-0.2.2.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-0.1.1.tgz -> npmpkg-strip-ansi-0.1.1.tgz
https://registry.npmjs.org/@mrmlnc/readdir-enhanced/-/readdir-enhanced-2.2.1.tgz -> npmpkg-@mrmlnc-readdir-enhanced-2.2.1.tgz
https://registry.npmjs.org/@nodelib/fs.stat/-/fs.stat-1.1.3.tgz -> npmpkg-@nodelib-fs.stat-1.1.3.tgz
https://registry.npmjs.org/@samverschueren/stream-to-observable/-/stream-to-observable-0.3.1.tgz -> npmpkg-@samverschueren-stream-to-observable-0.3.1.tgz
https://registry.npmjs.org/@sindresorhus/jimp/-/jimp-0.3.0.tgz -> npmpkg-@sindresorhus-jimp-0.3.0.tgz
https://registry.npmjs.org/mime/-/mime-1.6.0.tgz -> npmpkg-mime-1.6.0.tgz
https://registry.npmjs.org/minimist/-/minimist-0.0.8.tgz -> npmpkg-minimist-0.0.8.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.1.tgz -> npmpkg-mkdirp-0.5.1.tgz
https://registry.npmjs.org/@types/json5/-/json5-0.0.29.tgz -> npmpkg-@types-json5-0.0.29.tgz
https://registry.npmjs.org/acorn/-/acorn-5.7.4.tgz -> npmpkg-acorn-5.7.4.tgz
https://registry.npmjs.org/acorn-jsx/-/acorn-jsx-3.0.1.tgz -> npmpkg-acorn-jsx-3.0.1.tgz
https://registry.npmjs.org/acorn/-/acorn-3.3.0.tgz -> npmpkg-acorn-3.3.0.tgz
https://registry.npmjs.org/agent-base/-/agent-base-4.3.0.tgz -> npmpkg-agent-base-4.3.0.tgz
https://registry.npmjs.org/ajv/-/ajv-5.5.2.tgz -> npmpkg-ajv-5.5.2.tgz
https://registry.npmjs.org/ajv-keywords/-/ajv-keywords-2.1.1.tgz -> npmpkg-ajv-keywords-2.1.1.tgz
https://registry.npmjs.org/ansi-align/-/ansi-align-2.0.0.tgz -> npmpkg-ansi-align-2.0.0.tgz
https://registry.npmjs.org/ansi-escapes/-/ansi-escapes-3.2.0.tgz -> npmpkg-ansi-escapes-3.2.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-3.0.1.tgz -> npmpkg-ansi-regex-3.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/any-observable/-/any-observable-0.3.0.tgz -> npmpkg-any-observable-0.3.0.tgz
https://registry.npmjs.org/anymatch/-/anymatch-1.3.2.tgz -> npmpkg-anymatch-1.3.2.tgz
https://registry.npmjs.org/app-path/-/app-path-2.2.0.tgz -> npmpkg-app-path-2.2.0.tgz
https://registry.npmjs.org/execa/-/execa-0.4.0.tgz -> npmpkg-execa-0.4.0.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-1.0.0.tgz -> npmpkg-npm-run-path-1.0.0.tgz
https://registry.npmjs.org/path-key/-/path-key-1.0.0.tgz -> npmpkg-path-key-1.0.0.tgz
https://registry.npmjs.org/arch/-/arch-2.2.0.tgz -> npmpkg-arch-2.2.0.tgz
https://registry.npmjs.org/argparse/-/argparse-1.0.10.tgz -> npmpkg-argparse-1.0.10.tgz
https://registry.npmjs.org/arr-diff/-/arr-diff-2.0.0.tgz -> npmpkg-arr-diff-2.0.0.tgz
https://registry.npmjs.org/arr-exclude/-/arr-exclude-1.0.0.tgz -> npmpkg-arr-exclude-1.0.0.tgz
https://registry.npmjs.org/arr-flatten/-/arr-flatten-1.1.0.tgz -> npmpkg-arr-flatten-1.1.0.tgz
https://registry.npmjs.org/arr-union/-/arr-union-3.1.0.tgz -> npmpkg-arr-union-3.1.0.tgz
https://registry.npmjs.org/array-buffer-byte-length/-/array-buffer-byte-length-1.0.0.tgz -> npmpkg-array-buffer-byte-length-1.0.0.tgz
https://registry.npmjs.org/array-differ/-/array-differ-1.0.0.tgz -> npmpkg-array-differ-1.0.0.tgz
https://registry.npmjs.org/array-find-index/-/array-find-index-1.0.2.tgz -> npmpkg-array-find-index-1.0.2.tgz
https://registry.npmjs.org/array-includes/-/array-includes-3.1.6.tgz -> npmpkg-array-includes-3.1.6.tgz
https://registry.npmjs.org/array-union/-/array-union-1.0.2.tgz -> npmpkg-array-union-1.0.2.tgz
https://registry.npmjs.org/array-uniq/-/array-uniq-1.0.3.tgz -> npmpkg-array-uniq-1.0.3.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.2.1.tgz -> npmpkg-array-unique-0.2.1.tgz
https://registry.npmjs.org/array.prototype.flat/-/array.prototype.flat-1.3.1.tgz -> npmpkg-array.prototype.flat-1.3.1.tgz
https://registry.npmjs.org/array.prototype.flatmap/-/array.prototype.flatmap-1.3.1.tgz -> npmpkg-array.prototype.flatmap-1.3.1.tgz
https://registry.npmjs.org/arrify/-/arrify-1.0.1.tgz -> npmpkg-arrify-1.0.1.tgz
https://registry.npmjs.org/assign-symbols/-/assign-symbols-1.0.0.tgz -> npmpkg-assign-symbols-1.0.0.tgz
https://registry.npmjs.org/async-each/-/async-each-1.0.6.tgz -> npmpkg-async-each-1.0.6.tgz
https://registry.npmjs.org/async-limiter/-/async-limiter-1.0.1.tgz -> npmpkg-async-limiter-1.0.1.tgz
https://registry.npmjs.org/atob/-/atob-2.1.2.tgz -> npmpkg-atob-2.1.2.tgz
https://registry.npmjs.org/auto-bind/-/auto-bind-1.2.1.tgz -> npmpkg-auto-bind-1.2.1.tgz
https://registry.npmjs.org/ava/-/ava-0.25.0.tgz -> npmpkg-ava-0.25.0.tgz
https://registry.npmjs.org/ava-init/-/ava-init-0.2.1.tgz -> npmpkg-ava-init-0.2.1.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-5.1.0.tgz -> npmpkg-cross-spawn-5.1.0.tgz
https://registry.npmjs.org/execa/-/execa-0.7.0.tgz -> npmpkg-execa-0.7.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-3.0.0.tgz -> npmpkg-get-stream-3.0.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-2.1.1.tgz -> npmpkg-camelcase-2.1.1.tgz
https://registry.npmjs.org/camelcase-keys/-/camelcase-keys-2.1.0.tgz -> npmpkg-camelcase-keys-2.1.0.tgz
https://registry.npmjs.org/find-up/-/find-up-1.1.2.tgz -> npmpkg-find-up-1.1.2.tgz
https://registry.npmjs.org/get-stdin/-/get-stdin-4.0.1.tgz -> npmpkg-get-stdin-4.0.1.tgz
https://registry.npmjs.org/globby/-/globby-6.1.0.tgz -> npmpkg-globby-6.1.0.tgz
https://registry.npmjs.org/load-json-file/-/load-json-file-1.1.0.tgz -> npmpkg-load-json-file-1.1.0.tgz
https://registry.npmjs.org/map-obj/-/map-obj-1.0.1.tgz -> npmpkg-map-obj-1.0.1.tgz
https://registry.npmjs.org/meow/-/meow-3.7.0.tgz -> npmpkg-meow-3.7.0.tgz
https://registry.npmjs.org/parse-json/-/parse-json-2.2.0.tgz -> npmpkg-parse-json-2.2.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-2.1.0.tgz -> npmpkg-path-exists-2.1.0.tgz
https://registry.npmjs.org/path-type/-/path-type-1.1.0.tgz -> npmpkg-path-type-1.1.0.tgz
https://registry.npmjs.org/pify/-/pify-2.3.0.tgz -> npmpkg-pify-2.3.0.tgz
https://registry.npmjs.org/pinkie/-/pinkie-2.0.4.tgz -> npmpkg-pinkie-2.0.4.tgz
https://registry.npmjs.org/pinkie-promise/-/pinkie-promise-2.0.1.tgz -> npmpkg-pinkie-promise-2.0.1.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-1.1.0.tgz -> npmpkg-read-pkg-1.1.0.tgz
https://registry.npmjs.org/read-pkg-up/-/read-pkg-up-1.0.1.tgz -> npmpkg-read-pkg-up-1.0.1.tgz
https://registry.npmjs.org/redent/-/redent-1.0.0.tgz -> npmpkg-redent-1.0.0.tgz
https://registry.npmjs.org/indent-string/-/indent-string-2.1.0.tgz -> npmpkg-indent-string-2.1.0.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-2.0.0.tgz -> npmpkg-strip-bom-2.0.0.tgz
https://registry.npmjs.org/strip-indent/-/strip-indent-1.0.1.tgz -> npmpkg-strip-indent-1.0.1.tgz
https://registry.npmjs.org/trim-newlines/-/trim-newlines-1.0.0.tgz -> npmpkg-trim-newlines-1.0.0.tgz
https://registry.npmjs.org/available-typed-arrays/-/available-typed-arrays-1.0.5.tgz -> npmpkg-available-typed-arrays-1.0.5.tgz
https://registry.npmjs.org/babel-code-frame/-/babel-code-frame-6.26.0.tgz -> npmpkg-babel-code-frame-6.26.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-2.1.1.tgz -> npmpkg-ansi-regex-2.1.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-2.2.1.tgz -> npmpkg-ansi-styles-2.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-1.1.3.tgz -> npmpkg-chalk-1.1.3.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-3.0.1.tgz -> npmpkg-strip-ansi-3.0.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-2.0.0.tgz -> npmpkg-supports-color-2.0.0.tgz
https://registry.npmjs.org/babel-core/-/babel-core-6.26.3.tgz -> npmpkg-babel-core-6.26.3.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/babel-generator/-/babel-generator-6.26.1.tgz -> npmpkg-babel-generator-6.26.1.tgz
https://registry.npmjs.org/babel-helper-builder-binary-assignment-operator-visitor/-/babel-helper-builder-binary-assignment-operator-visitor-6.24.1.tgz -> npmpkg-babel-helper-builder-binary-assignment-operator-visitor-6.24.1.tgz
https://registry.npmjs.org/babel-helper-call-delegate/-/babel-helper-call-delegate-6.24.1.tgz -> npmpkg-babel-helper-call-delegate-6.24.1.tgz
https://registry.npmjs.org/babel-helper-explode-assignable-expression/-/babel-helper-explode-assignable-expression-6.24.1.tgz -> npmpkg-babel-helper-explode-assignable-expression-6.24.1.tgz
https://registry.npmjs.org/babel-helper-function-name/-/babel-helper-function-name-6.24.1.tgz -> npmpkg-babel-helper-function-name-6.24.1.tgz
https://registry.npmjs.org/babel-helper-get-function-arity/-/babel-helper-get-function-arity-6.24.1.tgz -> npmpkg-babel-helper-get-function-arity-6.24.1.tgz
https://registry.npmjs.org/babel-helper-hoist-variables/-/babel-helper-hoist-variables-6.24.1.tgz -> npmpkg-babel-helper-hoist-variables-6.24.1.tgz
https://registry.npmjs.org/babel-helper-regex/-/babel-helper-regex-6.26.0.tgz -> npmpkg-babel-helper-regex-6.26.0.tgz
https://registry.npmjs.org/babel-helper-remap-async-to-generator/-/babel-helper-remap-async-to-generator-6.24.1.tgz -> npmpkg-babel-helper-remap-async-to-generator-6.24.1.tgz
https://registry.npmjs.org/babel-helpers/-/babel-helpers-6.24.1.tgz -> npmpkg-babel-helpers-6.24.1.tgz
https://registry.npmjs.org/babel-messages/-/babel-messages-6.23.0.tgz -> npmpkg-babel-messages-6.23.0.tgz
https://registry.npmjs.org/babel-plugin-check-es2015-constants/-/babel-plugin-check-es2015-constants-6.22.0.tgz -> npmpkg-babel-plugin-check-es2015-constants-6.22.0.tgz
https://registry.npmjs.org/babel-plugin-espower/-/babel-plugin-espower-2.4.0.tgz -> npmpkg-babel-plugin-espower-2.4.0.tgz
https://registry.npmjs.org/babel-plugin-syntax-async-functions/-/babel-plugin-syntax-async-functions-6.13.0.tgz -> npmpkg-babel-plugin-syntax-async-functions-6.13.0.tgz
https://registry.npmjs.org/babel-plugin-syntax-exponentiation-operator/-/babel-plugin-syntax-exponentiation-operator-6.13.0.tgz -> npmpkg-babel-plugin-syntax-exponentiation-operator-6.13.0.tgz
https://registry.npmjs.org/babel-plugin-syntax-object-rest-spread/-/babel-plugin-syntax-object-rest-spread-6.13.0.tgz -> npmpkg-babel-plugin-syntax-object-rest-spread-6.13.0.tgz
https://registry.npmjs.org/babel-plugin-syntax-trailing-function-commas/-/babel-plugin-syntax-trailing-function-commas-6.22.0.tgz -> npmpkg-babel-plugin-syntax-trailing-function-commas-6.22.0.tgz
https://registry.npmjs.org/babel-plugin-transform-async-to-generator/-/babel-plugin-transform-async-to-generator-6.24.1.tgz -> npmpkg-babel-plugin-transform-async-to-generator-6.24.1.tgz
https://registry.npmjs.org/babel-plugin-transform-es2015-destructuring/-/babel-plugin-transform-es2015-destructuring-6.23.0.tgz -> npmpkg-babel-plugin-transform-es2015-destructuring-6.23.0.tgz
https://registry.npmjs.org/babel-plugin-transform-es2015-function-name/-/babel-plugin-transform-es2015-function-name-6.24.1.tgz -> npmpkg-babel-plugin-transform-es2015-function-name-6.24.1.tgz
https://registry.npmjs.org/babel-plugin-transform-es2015-modules-commonjs/-/babel-plugin-transform-es2015-modules-commonjs-6.26.2.tgz -> npmpkg-babel-plugin-transform-es2015-modules-commonjs-6.26.2.tgz
https://registry.npmjs.org/babel-plugin-transform-es2015-parameters/-/babel-plugin-transform-es2015-parameters-6.24.1.tgz -> npmpkg-babel-plugin-transform-es2015-parameters-6.24.1.tgz
https://registry.npmjs.org/babel-plugin-transform-es2015-spread/-/babel-plugin-transform-es2015-spread-6.22.0.tgz -> npmpkg-babel-plugin-transform-es2015-spread-6.22.0.tgz
https://registry.npmjs.org/babel-plugin-transform-es2015-sticky-regex/-/babel-plugin-transform-es2015-sticky-regex-6.24.1.tgz -> npmpkg-babel-plugin-transform-es2015-sticky-regex-6.24.1.tgz
https://registry.npmjs.org/babel-plugin-transform-es2015-unicode-regex/-/babel-plugin-transform-es2015-unicode-regex-6.24.1.tgz -> npmpkg-babel-plugin-transform-es2015-unicode-regex-6.24.1.tgz
https://registry.npmjs.org/babel-plugin-transform-exponentiation-operator/-/babel-plugin-transform-exponentiation-operator-6.24.1.tgz -> npmpkg-babel-plugin-transform-exponentiation-operator-6.24.1.tgz
https://registry.npmjs.org/babel-plugin-transform-strict-mode/-/babel-plugin-transform-strict-mode-6.24.1.tgz -> npmpkg-babel-plugin-transform-strict-mode-6.24.1.tgz
https://registry.npmjs.org/babel-register/-/babel-register-6.26.0.tgz -> npmpkg-babel-register-6.26.0.tgz
https://registry.npmjs.org/source-map-support/-/source-map-support-0.4.18.tgz -> npmpkg-source-map-support-0.4.18.tgz
https://registry.npmjs.org/babel-runtime/-/babel-runtime-6.26.0.tgz -> npmpkg-babel-runtime-6.26.0.tgz
https://registry.npmjs.org/babel-template/-/babel-template-6.26.0.tgz -> npmpkg-babel-template-6.26.0.tgz
https://registry.npmjs.org/babel-traverse/-/babel-traverse-6.26.0.tgz -> npmpkg-babel-traverse-6.26.0.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/babel-types/-/babel-types-6.26.0.tgz -> npmpkg-babel-types-6.26.0.tgz
https://registry.npmjs.org/babylon/-/babylon-6.18.0.tgz -> npmpkg-babylon-6.18.0.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.2.tgz -> npmpkg-balanced-match-1.0.2.tgz
https://registry.npmjs.org/base/-/base-0.11.2.tgz -> npmpkg-base-0.11.2.tgz
https://registry.npmjs.org/define-property/-/define-property-1.0.0.tgz -> npmpkg-define-property-1.0.0.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/base64-js/-/base64-js-1.5.1.tgz -> npmpkg-base64-js-1.5.1.tgz
https://registry.npmjs.org/bignumber.js/-/bignumber.js-2.4.0.tgz -> npmpkg-bignumber.js-2.4.0.tgz
https://registry.npmjs.org/binary-extensions/-/binary-extensions-1.13.1.tgz -> npmpkg-binary-extensions-1.13.1.tgz
https://registry.npmjs.org/bindings/-/bindings-1.5.0.tgz -> npmpkg-bindings-1.5.0.tgz
https://registry.npmjs.org/bluebird/-/bluebird-3.7.2.tgz -> npmpkg-bluebird-3.7.2.tgz
https://registry.npmjs.org/bmp-js/-/bmp-js-0.0.3.tgz -> npmpkg-bmp-js-0.0.3.tgz
https://registry.npmjs.org/boxen/-/boxen-1.3.0.tgz -> npmpkg-boxen-1.3.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/braces/-/braces-1.8.5.tgz -> npmpkg-braces-1.8.5.tgz
https://registry.npmjs.org/buf-compare/-/buf-compare-1.0.1.tgz -> npmpkg-buf-compare-1.0.1.tgz
https://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.2.13.tgz -> npmpkg-buffer-crc32-0.2.13.tgz
https://registry.npmjs.org/buffer-equal/-/buffer-equal-0.0.1.tgz -> npmpkg-buffer-equal-0.0.1.tgz
https://registry.npmjs.org/buffer-from/-/buffer-from-1.1.2.tgz -> npmpkg-buffer-from-1.1.2.tgz
https://registry.npmjs.org/bytes/-/bytes-3.1.2.tgz -> npmpkg-bytes-3.1.2.tgz
https://registry.npmjs.org/cache-base/-/cache-base-1.0.1.tgz -> npmpkg-cache-base-1.0.1.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/caching-transform/-/caching-transform-1.0.1.tgz -> npmpkg-caching-transform-1.0.1.tgz
https://registry.npmjs.org/md5-hex/-/md5-hex-1.3.0.tgz -> npmpkg-md5-hex-1.3.0.tgz
https://registry.npmjs.org/call-bind/-/call-bind-1.0.2.tgz -> npmpkg-call-bind-1.0.2.tgz
https://registry.npmjs.org/call-matcher/-/call-matcher-1.1.0.tgz -> npmpkg-call-matcher-1.1.0.tgz
https://registry.npmjs.org/call-me-maybe/-/call-me-maybe-1.0.2.tgz -> npmpkg-call-me-maybe-1.0.2.tgz
https://registry.npmjs.org/call-signature/-/call-signature-0.0.2.tgz -> npmpkg-call-signature-0.0.2.tgz
https://registry.npmjs.org/caller-callsite/-/caller-callsite-2.0.0.tgz -> npmpkg-caller-callsite-2.0.0.tgz
https://registry.npmjs.org/caller-path/-/caller-path-2.0.0.tgz -> npmpkg-caller-path-2.0.0.tgz
https://registry.npmjs.org/callsites/-/callsites-2.0.0.tgz -> npmpkg-callsites-2.0.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-4.1.0.tgz -> npmpkg-camelcase-4.1.0.tgz
https://registry.npmjs.org/camelcase-keys/-/camelcase-keys-4.2.0.tgz -> npmpkg-camelcase-keys-4.2.0.tgz
https://registry.npmjs.org/capture-stack-trace/-/capture-stack-trace-1.0.2.tgz -> npmpkg-capture-stack-trace-1.0.2.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/chardet/-/chardet-0.7.0.tgz -> npmpkg-chardet-0.7.0.tgz
https://registry.npmjs.org/child-process-promise/-/child-process-promise-2.2.1.tgz -> npmpkg-child-process-promise-2.2.1.tgz
https://registry.npmjs.org/chokidar/-/chokidar-1.7.0.tgz -> npmpkg-chokidar-1.7.0.tgz
https://registry.npmjs.org/ci-info/-/ci-info-1.6.0.tgz -> npmpkg-ci-info-1.6.0.tgz
https://registry.npmjs.org/circular-json/-/circular-json-0.3.3.tgz -> npmpkg-circular-json-0.3.3.tgz
https://registry.npmjs.org/class-utils/-/class-utils-0.3.6.tgz -> npmpkg-class-utils-0.3.6.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz -> npmpkg-is-accessor-descriptor-0.1.6.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz -> npmpkg-is-data-descriptor-0.1.4.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.6.tgz -> npmpkg-is-descriptor-0.1.6.tgz
https://registry.npmjs.org/kind-of/-/kind-of-5.1.0.tgz -> npmpkg-kind-of-5.1.0.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/clean-regexp/-/clean-regexp-1.0.0.tgz -> npmpkg-clean-regexp-1.0.0.tgz
https://registry.npmjs.org/clean-stack/-/clean-stack-1.3.0.tgz -> npmpkg-clean-stack-1.3.0.tgz
https://registry.npmjs.org/clean-yaml-object/-/clean-yaml-object-0.1.0.tgz -> npmpkg-clean-yaml-object-0.1.0.tgz
https://registry.npmjs.org/cli-boxes/-/cli-boxes-1.0.0.tgz -> npmpkg-cli-boxes-1.0.0.tgz
https://registry.npmjs.org/cli-cursor/-/cli-cursor-2.1.0.tgz -> npmpkg-cli-cursor-2.1.0.tgz
https://registry.npmjs.org/cli-spinners/-/cli-spinners-1.3.1.tgz -> npmpkg-cli-spinners-1.3.1.tgz
https://registry.npmjs.org/cli-truncate/-/cli-truncate-1.1.0.tgz -> npmpkg-cli-truncate-1.1.0.tgz
https://registry.npmjs.org/cli-width/-/cli-width-2.2.1.tgz -> npmpkg-cli-width-2.2.1.tgz
https://registry.npmjs.org/clipboardy/-/clipboardy-1.2.3.tgz -> npmpkg-clipboardy-1.2.3.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-5.1.0.tgz -> npmpkg-cross-spawn-5.1.0.tgz
https://registry.npmjs.org/execa/-/execa-0.8.0.tgz -> npmpkg-execa-0.8.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-3.0.0.tgz -> npmpkg-get-stream-3.0.0.tgz
https://registry.npmjs.org/co/-/co-4.6.0.tgz -> npmpkg-co-4.6.0.tgz
https://registry.npmjs.org/co-with-promise/-/co-with-promise-4.6.0.tgz -> npmpkg-co-with-promise-4.6.0.tgz
https://registry.npmjs.org/code-excerpt/-/code-excerpt-2.1.1.tgz -> npmpkg-code-excerpt-2.1.1.tgz
https://registry.npmjs.org/code-point-at/-/code-point-at-1.1.0.tgz -> npmpkg-code-point-at-1.1.0.tgz
https://registry.npmjs.org/collection-visit/-/collection-visit-1.0.0.tgz -> npmpkg-collection-visit-1.0.0.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/common-path-prefix/-/common-path-prefix-1.0.0.tgz -> npmpkg-common-path-prefix-1.0.0.tgz
https://registry.npmjs.org/commondir/-/commondir-1.0.1.tgz -> npmpkg-commondir-1.0.1.tgz
https://registry.npmjs.org/component-emitter/-/component-emitter-1.3.0.tgz -> npmpkg-component-emitter-1.3.0.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/concat-stream/-/concat-stream-1.6.2.tgz -> npmpkg-concat-stream-1.6.2.tgz
https://registry.npmjs.org/concordance/-/concordance-3.0.0.tgz -> npmpkg-concordance-3.0.0.tgz
https://registry.npmjs.org/date-time/-/date-time-2.1.0.tgz -> npmpkg-date-time-2.1.0.tgz
https://registry.npmjs.org/configstore/-/configstore-3.1.5.tgz -> npmpkg-configstore-3.1.5.tgz
https://registry.npmjs.org/write-file-atomic/-/write-file-atomic-2.4.3.tgz -> npmpkg-write-file-atomic-2.4.3.tgz
https://registry.npmjs.org/convert-source-map/-/convert-source-map-1.9.0.tgz -> npmpkg-convert-source-map-1.9.0.tgz
https://registry.npmjs.org/convert-to-spaces/-/convert-to-spaces-1.0.2.tgz -> npmpkg-convert-to-spaces-1.0.2.tgz
https://registry.npmjs.org/copy-descriptor/-/copy-descriptor-0.1.1.tgz -> npmpkg-copy-descriptor-0.1.1.tgz
https://registry.npmjs.org/core-assert/-/core-assert-0.2.1.tgz -> npmpkg-core-assert-0.2.1.tgz
https://registry.npmjs.org/core-js/-/core-js-2.6.12.tgz -> npmpkg-core-js-2.6.12.tgz
https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.3.tgz -> npmpkg-core-util-is-1.0.3.tgz
https://registry.npmjs.org/cosmiconfig/-/cosmiconfig-5.2.1.tgz -> npmpkg-cosmiconfig-5.2.1.tgz
https://registry.npmjs.org/create-error-class/-/create-error-class-3.0.2.tgz -> npmpkg-create-error-class-3.0.2.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-4.0.2.tgz -> npmpkg-cross-spawn-4.0.2.tgz
https://registry.npmjs.org/cross-spawn-async/-/cross-spawn-async-2.2.5.tgz -> npmpkg-cross-spawn-async-2.2.5.tgz
https://registry.npmjs.org/crypto-random-string/-/crypto-random-string-1.0.0.tgz -> npmpkg-crypto-random-string-1.0.0.tgz
https://registry.npmjs.org/currently-unhandled/-/currently-unhandled-0.4.1.tgz -> npmpkg-currently-unhandled-0.4.1.tgz
https://registry.npmjs.org/date-fns/-/date-fns-1.30.1.tgz -> npmpkg-date-fns-1.30.1.tgz
https://registry.npmjs.org/date-time/-/date-time-0.1.1.tgz -> npmpkg-date-time-0.1.1.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/decamelize/-/decamelize-1.2.0.tgz -> npmpkg-decamelize-1.2.0.tgz
https://registry.npmjs.org/decamelize-keys/-/decamelize-keys-1.1.1.tgz -> npmpkg-decamelize-keys-1.1.1.tgz
https://registry.npmjs.org/map-obj/-/map-obj-1.0.1.tgz -> npmpkg-map-obj-1.0.1.tgz
https://registry.npmjs.org/decode-uri-component/-/decode-uri-component-0.2.2.tgz -> npmpkg-decode-uri-component-0.2.2.tgz
https://registry.npmjs.org/deep-equal/-/deep-equal-1.1.1.tgz -> npmpkg-deep-equal-1.1.1.tgz
https://registry.npmjs.org/deep-extend/-/deep-extend-0.6.0.tgz -> npmpkg-deep-extend-0.6.0.tgz
https://registry.npmjs.org/deep-is/-/deep-is-0.1.4.tgz -> npmpkg-deep-is-0.1.4.tgz
https://registry.npmjs.org/deep-strict-equal/-/deep-strict-equal-0.2.0.tgz -> npmpkg-deep-strict-equal-0.2.0.tgz
https://registry.npmjs.org/define-properties/-/define-properties-1.2.0.tgz -> npmpkg-define-properties-1.2.0.tgz
https://registry.npmjs.org/define-property/-/define-property-2.0.2.tgz -> npmpkg-define-property-2.0.2.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/del/-/del-3.0.0.tgz -> npmpkg-del-3.0.0.tgz
https://registry.npmjs.org/globby/-/globby-6.1.0.tgz -> npmpkg-globby-6.1.0.tgz
https://registry.npmjs.org/pify/-/pify-2.3.0.tgz -> npmpkg-pify-2.3.0.tgz
https://registry.npmjs.org/pinkie/-/pinkie-2.0.4.tgz -> npmpkg-pinkie-2.0.4.tgz
https://registry.npmjs.org/pinkie-promise/-/pinkie-promise-2.0.1.tgz -> npmpkg-pinkie-promise-2.0.1.tgz
https://registry.npmjs.org/depd/-/depd-2.0.0.tgz -> npmpkg-depd-2.0.0.tgz
https://registry.npmjs.org/detect-indent/-/detect-indent-4.0.0.tgz -> npmpkg-detect-indent-4.0.0.tgz
https://registry.npmjs.org/dir-glob/-/dir-glob-2.0.0.tgz -> npmpkg-dir-glob-2.0.0.tgz
https://registry.npmjs.org/doctrine/-/doctrine-2.1.0.tgz -> npmpkg-doctrine-2.1.0.tgz
https://registry.npmjs.org/dom-walk/-/dom-walk-0.1.2.tgz -> npmpkg-dom-walk-0.1.2.tgz
https://registry.npmjs.org/dot-prop/-/dot-prop-4.2.1.tgz -> npmpkg-dot-prop-4.2.1.tgz
https://registry.npmjs.org/duplexer3/-/duplexer3-0.1.5.tgz -> npmpkg-duplexer3-0.1.5.tgz
https://registry.npmjs.org/elegant-spinner/-/elegant-spinner-1.0.1.tgz -> npmpkg-elegant-spinner-1.0.1.tgz
https://registry.npmjs.org/empower-core/-/empower-core-0.6.2.tgz -> npmpkg-empower-core-0.6.2.tgz
https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.4.4.tgz -> npmpkg-end-of-stream-1.4.4.tgz
https://registry.npmjs.org/enhance-visitors/-/enhance-visitors-1.0.0.tgz -> npmpkg-enhance-visitors-1.0.0.tgz
https://registry.npmjs.org/env-editor/-/env-editor-0.3.1.tgz -> npmpkg-env-editor-0.3.1.tgz
https://registry.npmjs.org/equal-length/-/equal-length-1.0.1.tgz -> npmpkg-equal-length-1.0.1.tgz
https://registry.npmjs.org/error-ex/-/error-ex-1.3.2.tgz -> npmpkg-error-ex-1.3.2.tgz
https://registry.npmjs.org/es-abstract/-/es-abstract-1.21.2.tgz -> npmpkg-es-abstract-1.21.2.tgz
https://registry.npmjs.org/es-set-tostringtag/-/es-set-tostringtag-2.0.1.tgz -> npmpkg-es-set-tostringtag-2.0.1.tgz
https://registry.npmjs.org/es-shim-unscopables/-/es-shim-unscopables-1.0.0.tgz -> npmpkg-es-shim-unscopables-1.0.0.tgz
https://registry.npmjs.org/es-to-primitive/-/es-to-primitive-1.2.1.tgz -> npmpkg-es-to-primitive-1.2.1.tgz
https://registry.npmjs.org/es6-error/-/es6-error-4.1.1.tgz -> npmpkg-es6-error-4.1.1.tgz
https://registry.npmjs.org/es6-promise/-/es6-promise-4.2.8.tgz -> npmpkg-es6-promise-4.2.8.tgz
https://registry.npmjs.org/es6-promisify/-/es6-promisify-5.0.0.tgz -> npmpkg-es6-promisify-5.0.0.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/eslint/-/eslint-4.19.1.tgz -> npmpkg-eslint-4.19.1.tgz
https://registry.npmjs.org/eslint-ast-utils/-/eslint-ast-utils-1.1.0.tgz -> npmpkg-eslint-ast-utils-1.1.0.tgz
https://registry.npmjs.org/eslint-config-prettier/-/eslint-config-prettier-2.10.0.tgz -> npmpkg-eslint-config-prettier-2.10.0.tgz
https://registry.npmjs.org/get-stdin/-/get-stdin-5.0.1.tgz -> npmpkg-get-stdin-5.0.1.tgz
https://registry.npmjs.org/eslint-config-xo/-/eslint-config-xo-0.22.2.tgz -> npmpkg-eslint-config-xo-0.22.2.tgz
https://registry.npmjs.org/eslint-formatter-pretty/-/eslint-formatter-pretty-1.3.0.tgz -> npmpkg-eslint-formatter-pretty-1.3.0.tgz
https://registry.npmjs.org/ansi-escapes/-/ansi-escapes-2.0.0.tgz -> npmpkg-ansi-escapes-2.0.0.tgz
https://registry.npmjs.org/log-symbols/-/log-symbols-2.2.0.tgz -> npmpkg-log-symbols-2.2.0.tgz
https://registry.npmjs.org/eslint-import-resolver-node/-/eslint-import-resolver-node-0.3.7.tgz -> npmpkg-eslint-import-resolver-node-0.3.7.tgz
https://registry.npmjs.org/eslint-module-utils/-/eslint-module-utils-2.7.4.tgz -> npmpkg-eslint-module-utils-2.7.4.tgz
https://registry.npmjs.org/eslint-plugin-ava/-/eslint-plugin-ava-4.5.1.tgz -> npmpkg-eslint-plugin-ava-4.5.1.tgz
https://registry.npmjs.org/eslint-plugin-import/-/eslint-plugin-import-2.27.5.tgz -> npmpkg-eslint-plugin-import-2.27.5.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz -> npmpkg-is-extglob-2.1.1.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/semver/-/semver-6.3.0.tgz -> npmpkg-semver-6.3.0.tgz
https://registry.npmjs.org/eslint-plugin-no-use-extend-native/-/eslint-plugin-no-use-extend-native-0.3.12.tgz -> npmpkg-eslint-plugin-no-use-extend-native-0.3.12.tgz
https://registry.npmjs.org/eslint-plugin-node/-/eslint-plugin-node-6.0.1.tgz -> npmpkg-eslint-plugin-node-6.0.1.tgz
https://registry.npmjs.org/eslint-plugin-prettier/-/eslint-plugin-prettier-2.7.0.tgz -> npmpkg-eslint-plugin-prettier-2.7.0.tgz
https://registry.npmjs.org/eslint-plugin-promise/-/eslint-plugin-promise-3.8.0.tgz -> npmpkg-eslint-plugin-promise-3.8.0.tgz
https://registry.npmjs.org/eslint-plugin-unicorn/-/eslint-plugin-unicorn-4.0.3.tgz -> npmpkg-eslint-plugin-unicorn-4.0.3.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-3.7.3.tgz -> npmpkg-eslint-scope-3.7.3.tgz
https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-1.3.0.tgz -> npmpkg-eslint-visitor-keys-1.3.0.tgz
https://registry.npmjs.org/chardet/-/chardet-0.4.2.tgz -> npmpkg-chardet-0.4.2.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-5.1.0.tgz -> npmpkg-cross-spawn-5.1.0.tgz
https://registry.npmjs.org/external-editor/-/external-editor-2.2.0.tgz -> npmpkg-external-editor-2.2.0.tgz
https://registry.npmjs.org/globals/-/globals-11.12.0.tgz -> npmpkg-globals-11.12.0.tgz
https://registry.npmjs.org/inquirer/-/inquirer-3.3.0.tgz -> npmpkg-inquirer-3.3.0.tgz
https://registry.npmjs.org/espower-location-detector/-/espower-location-detector-1.0.0.tgz -> npmpkg-espower-location-detector-1.0.0.tgz
https://registry.npmjs.org/espree/-/espree-3.5.4.tgz -> npmpkg-espree-3.5.4.tgz
https://registry.npmjs.org/esprima/-/esprima-4.0.1.tgz -> npmpkg-esprima-4.0.1.tgz
https://registry.npmjs.org/espurify/-/espurify-1.8.1.tgz -> npmpkg-espurify-1.8.1.tgz
https://registry.npmjs.org/esquery/-/esquery-1.5.0.tgz -> npmpkg-esquery-1.5.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-5.3.0.tgz -> npmpkg-estraverse-5.3.0.tgz
https://registry.npmjs.org/esrecurse/-/esrecurse-4.3.0.tgz -> npmpkg-esrecurse-4.3.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-5.3.0.tgz -> npmpkg-estraverse-5.3.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-4.3.0.tgz -> npmpkg-estraverse-4.3.0.tgz
https://registry.npmjs.org/esutils/-/esutils-2.0.3.tgz -> npmpkg-esutils-2.0.3.tgz
https://registry.npmjs.org/execa/-/execa-1.0.0.tgz -> npmpkg-execa-1.0.0.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-6.0.5.tgz -> npmpkg-cross-spawn-6.0.5.tgz
https://registry.npmjs.org/exif-parser/-/exif-parser-0.1.12.tgz -> npmpkg-exif-parser-0.1.12.tgz
https://registry.npmjs.org/expand-brackets/-/expand-brackets-0.1.5.tgz -> npmpkg-expand-brackets-0.1.5.tgz
https://registry.npmjs.org/expand-range/-/expand-range-1.8.2.tgz -> npmpkg-expand-range-1.8.2.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-3.0.2.tgz -> npmpkg-extend-shallow-3.0.2.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-1.0.1.tgz -> npmpkg-is-extendable-1.0.1.tgz
https://registry.npmjs.org/external-editor/-/external-editor-3.1.0.tgz -> npmpkg-external-editor-3.1.0.tgz
https://registry.npmjs.org/extglob/-/extglob-0.3.2.tgz -> npmpkg-extglob-0.3.2.tgz
https://registry.npmjs.org/extract-zip/-/extract-zip-1.7.0.tgz -> npmpkg-extract-zip-1.7.0.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-1.1.0.tgz -> npmpkg-fast-deep-equal-1.1.0.tgz
https://registry.npmjs.org/fast-diff/-/fast-diff-1.2.0.tgz -> npmpkg-fast-diff-1.2.0.tgz
https://registry.npmjs.org/fast-glob/-/fast-glob-2.2.7.tgz -> npmpkg-fast-glob-2.2.7.tgz
https://registry.npmjs.org/arr-diff/-/arr-diff-4.0.0.tgz -> npmpkg-arr-diff-4.0.0.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.3.2.tgz -> npmpkg-array-unique-0.3.2.tgz
https://registry.npmjs.org/braces/-/braces-2.3.2.tgz -> npmpkg-braces-2.3.2.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/expand-brackets/-/expand-brackets-2.1.4.tgz -> npmpkg-expand-brackets-2.1.4.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.6.tgz -> npmpkg-is-descriptor-0.1.6.tgz
https://registry.npmjs.org/kind-of/-/kind-of-5.1.0.tgz -> npmpkg-kind-of-5.1.0.tgz
https://registry.npmjs.org/extglob/-/extglob-2.0.4.tgz -> npmpkg-extglob-2.0.4.tgz
https://registry.npmjs.org/define-property/-/define-property-1.0.0.tgz -> npmpkg-define-property-1.0.0.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/fill-range/-/fill-range-4.0.0.tgz -> npmpkg-fill-range-4.0.0.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-3.1.0.tgz -> npmpkg-glob-parent-3.1.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-3.1.0.tgz -> npmpkg-is-glob-3.1.0.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz -> npmpkg-is-accessor-descriptor-0.1.6.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz -> npmpkg-is-data-descriptor-0.1.4.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz -> npmpkg-is-extglob-2.1.1.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz -> npmpkg-is-glob-4.0.3.tgz
https://registry.npmjs.org/is-number/-/is-number-3.0.0.tgz -> npmpkg-is-number-3.0.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/micromatch/-/micromatch-3.1.10.tgz -> npmpkg-micromatch-3.1.10.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz -> npmpkg-fast-json-stable-stringify-2.1.0.tgz
https://registry.npmjs.org/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz -> npmpkg-fast-levenshtein-2.0.6.tgz
https://registry.npmjs.org/fd-slicer/-/fd-slicer-1.1.0.tgz -> npmpkg-fd-slicer-1.1.0.tgz
https://registry.npmjs.org/figures/-/figures-2.0.0.tgz -> npmpkg-figures-2.0.0.tgz
https://registry.npmjs.org/file-entry-cache/-/file-entry-cache-2.0.0.tgz -> npmpkg-file-entry-cache-2.0.0.tgz
https://registry.npmjs.org/file-exists/-/file-exists-5.0.1.tgz -> npmpkg-file-exists-5.0.1.tgz
https://registry.npmjs.org/file-extension/-/file-extension-4.0.5.tgz -> npmpkg-file-extension-4.0.5.tgz
https://registry.npmjs.org/file-type/-/file-type-3.9.0.tgz -> npmpkg-file-type-3.9.0.tgz
https://registry.npmjs.org/file-uri-to-path/-/file-uri-to-path-1.0.0.tgz -> npmpkg-file-uri-to-path-1.0.0.tgz
https://registry.npmjs.org/filename-regex/-/filename-regex-2.0.1.tgz -> npmpkg-filename-regex-2.0.1.tgz
https://registry.npmjs.org/fill-range/-/fill-range-2.2.4.tgz -> npmpkg-fill-range-2.2.4.tgz
https://registry.npmjs.org/filter-obj/-/filter-obj-1.1.0.tgz -> npmpkg-filter-obj-1.1.0.tgz
https://registry.npmjs.org/find-cache-dir/-/find-cache-dir-1.0.0.tgz -> npmpkg-find-cache-dir-1.0.0.tgz
https://registry.npmjs.org/find-up/-/find-up-3.0.0.tgz -> npmpkg-find-up-3.0.0.tgz
https://registry.npmjs.org/flat-cache/-/flat-cache-1.3.4.tgz -> npmpkg-flat-cache-1.3.4.tgz
https://registry.npmjs.org/rimraf/-/rimraf-2.6.3.tgz -> npmpkg-rimraf-2.6.3.tgz
https://registry.npmjs.org/fn-name/-/fn-name-2.0.1.tgz -> npmpkg-fn-name-2.0.1.tgz
https://registry.npmjs.org/for-each/-/for-each-0.3.3.tgz -> npmpkg-for-each-0.3.3.tgz
https://registry.npmjs.org/for-in/-/for-in-1.0.2.tgz -> npmpkg-for-in-1.0.2.tgz
https://registry.npmjs.org/for-own/-/for-own-0.1.5.tgz -> npmpkg-for-own-0.1.5.tgz
https://registry.npmjs.org/fragment-cache/-/fragment-cache-0.2.1.tgz -> npmpkg-fragment-cache-0.2.1.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz -> npmpkg-fs.realpath-1.0.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-1.2.13.tgz -> npmpkg-fsevents-1.2.13.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.1.tgz -> npmpkg-function-bind-1.1.1.tgz
https://registry.npmjs.org/function-name-support/-/function-name-support-0.2.0.tgz -> npmpkg-function-name-support-0.2.0.tgz
https://registry.npmjs.org/function.prototype.name/-/function.prototype.name-1.1.5.tgz -> npmpkg-function.prototype.name-1.1.5.tgz
https://registry.npmjs.org/functional-red-black-tree/-/functional-red-black-tree-1.0.1.tgz -> npmpkg-functional-red-black-tree-1.0.1.tgz
https://registry.npmjs.org/functions-have-names/-/functions-have-names-1.2.3.tgz -> npmpkg-functions-have-names-1.2.3.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.2.0.tgz -> npmpkg-get-intrinsic-1.2.0.tgz
https://registry.npmjs.org/get-port/-/get-port-3.2.0.tgz -> npmpkg-get-port-3.2.0.tgz
https://registry.npmjs.org/get-set-props/-/get-set-props-0.1.0.tgz -> npmpkg-get-set-props-0.1.0.tgz
https://registry.npmjs.org/get-stdin/-/get-stdin-6.0.0.tgz -> npmpkg-get-stdin-6.0.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-4.1.0.tgz -> npmpkg-get-stream-4.1.0.tgz
https://registry.npmjs.org/get-symbol-description/-/get-symbol-description-1.0.0.tgz -> npmpkg-get-symbol-description-1.0.0.tgz
https://registry.npmjs.org/get-value/-/get-value-2.0.6.tgz -> npmpkg-get-value-2.0.6.tgz
https://registry.npmjs.org/glob/-/glob-7.2.3.tgz -> npmpkg-glob-7.2.3.tgz
https://registry.npmjs.org/glob-base/-/glob-base-0.3.0.tgz -> npmpkg-glob-base-0.3.0.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-2.0.0.tgz -> npmpkg-glob-parent-2.0.0.tgz
https://registry.npmjs.org/glob-to-regexp/-/glob-to-regexp-0.3.0.tgz -> npmpkg-glob-to-regexp-0.3.0.tgz
https://registry.npmjs.org/global/-/global-4.4.0.tgz -> npmpkg-global-4.4.0.tgz
https://registry.npmjs.org/global-dirs/-/global-dirs-0.1.1.tgz -> npmpkg-global-dirs-0.1.1.tgz
https://registry.npmjs.org/globals/-/globals-9.18.0.tgz -> npmpkg-globals-9.18.0.tgz
https://registry.npmjs.org/globalthis/-/globalthis-1.0.3.tgz -> npmpkg-globalthis-1.0.3.tgz
https://registry.npmjs.org/globby/-/globby-8.0.2.tgz -> npmpkg-globby-8.0.2.tgz
https://registry.npmjs.org/gopd/-/gopd-1.0.1.tgz -> npmpkg-gopd-1.0.1.tgz
https://registry.npmjs.org/got/-/got-6.7.1.tgz -> npmpkg-got-6.7.1.tgz
https://registry.npmjs.org/get-stream/-/get-stream-3.0.0.tgz -> npmpkg-get-stream-3.0.0.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.11.tgz -> npmpkg-graceful-fs-4.2.11.tgz
https://registry.npmjs.org/has/-/has-1.0.3.tgz -> npmpkg-has-1.0.3.tgz
https://registry.npmjs.org/has-ansi/-/has-ansi-2.0.0.tgz -> npmpkg-has-ansi-2.0.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-2.1.1.tgz -> npmpkg-ansi-regex-2.1.1.tgz
https://registry.npmjs.org/has-bigints/-/has-bigints-1.0.2.tgz -> npmpkg-has-bigints-1.0.2.tgz
https://registry.npmjs.org/has-color/-/has-color-0.1.7.tgz -> npmpkg-has-color-0.1.7.tgz
https://registry.npmjs.org/has-flag/-/has-flag-2.0.0.tgz -> npmpkg-has-flag-2.0.0.tgz
https://registry.npmjs.org/has-property-descriptors/-/has-property-descriptors-1.0.0.tgz -> npmpkg-has-property-descriptors-1.0.0.tgz
https://registry.npmjs.org/has-proto/-/has-proto-1.0.1.tgz -> npmpkg-has-proto-1.0.1.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.0.3.tgz -> npmpkg-has-symbols-1.0.3.tgz
https://registry.npmjs.org/has-tostringtag/-/has-tostringtag-1.0.0.tgz -> npmpkg-has-tostringtag-1.0.0.tgz
https://registry.npmjs.org/has-value/-/has-value-1.0.0.tgz -> npmpkg-has-value-1.0.0.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/has-values/-/has-values-1.0.0.tgz -> npmpkg-has-values-1.0.0.tgz
https://registry.npmjs.org/is-number/-/is-number-3.0.0.tgz -> npmpkg-is-number-3.0.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/kind-of/-/kind-of-4.0.0.tgz -> npmpkg-kind-of-4.0.0.tgz
https://registry.npmjs.org/has-yarn/-/has-yarn-1.0.0.tgz -> npmpkg-has-yarn-1.0.0.tgz
https://registry.npmjs.org/home-or-tmp/-/home-or-tmp-2.0.0.tgz -> npmpkg-home-or-tmp-2.0.0.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-2.8.9.tgz -> npmpkg-hosted-git-info-2.8.9.tgz
https://registry.npmjs.org/http-errors/-/http-errors-2.0.0.tgz -> npmpkg-http-errors-2.0.0.tgz
https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-2.2.4.tgz -> npmpkg-https-proxy-agent-2.2.4.tgz
https://registry.npmjs.org/hullabaloo-config-manager/-/hullabaloo-config-manager-1.1.1.tgz -> npmpkg-hullabaloo-config-manager-1.1.1.tgz
https://registry.npmjs.org/husky/-/husky-1.3.1.tgz -> npmpkg-husky-1.3.1.tgz
https://registry.npmjs.org/ci-info/-/ci-info-2.0.0.tgz -> npmpkg-ci-info-2.0.0.tgz
https://registry.npmjs.org/is-ci/-/is-ci-2.0.0.tgz -> npmpkg-is-ci-2.0.0.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-3.0.0.tgz -> npmpkg-pkg-dir-3.0.0.tgz
https://registry.npmjs.org/slash/-/slash-2.0.0.tgz -> npmpkg-slash-2.0.0.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.4.24.tgz -> npmpkg-iconv-lite-0.4.24.tgz
https://registry.npmjs.org/ignore/-/ignore-3.3.10.tgz -> npmpkg-ignore-3.3.10.tgz
https://registry.npmjs.org/ignore-by-default/-/ignore-by-default-1.0.1.tgz -> npmpkg-ignore-by-default-1.0.1.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-2.0.0.tgz -> npmpkg-import-fresh-2.0.0.tgz
https://registry.npmjs.org/import-lazy/-/import-lazy-2.1.0.tgz -> npmpkg-import-lazy-2.1.0.tgz
https://registry.npmjs.org/import-local/-/import-local-0.1.1.tgz -> npmpkg-import-local-0.1.1.tgz
https://registry.npmjs.org/import-modules/-/import-modules-1.1.0.tgz -> npmpkg-import-modules-1.1.0.tgz
https://registry.npmjs.org/imurmurhash/-/imurmurhash-0.1.4.tgz -> npmpkg-imurmurhash-0.1.4.tgz
https://registry.npmjs.org/indent-string/-/indent-string-3.2.0.tgz -> npmpkg-indent-string-3.2.0.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz -> npmpkg-inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz -> npmpkg-inherits-2.0.4.tgz
https://registry.npmjs.org/ini/-/ini-1.3.8.tgz -> npmpkg-ini-1.3.8.tgz
https://registry.npmjs.org/inquirer/-/inquirer-6.5.2.tgz -> npmpkg-inquirer-6.5.2.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-4.1.1.tgz -> npmpkg-ansi-regex-4.1.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-5.2.0.tgz -> npmpkg-strip-ansi-5.2.0.tgz
https://registry.npmjs.org/internal-slot/-/internal-slot-1.0.5.tgz -> npmpkg-internal-slot-1.0.5.tgz
https://registry.npmjs.org/invariant/-/invariant-2.2.4.tgz -> npmpkg-invariant-2.2.4.tgz
https://registry.npmjs.org/irregular-plurals/-/irregular-plurals-1.4.0.tgz -> npmpkg-irregular-plurals-1.4.0.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-1.0.0.tgz -> npmpkg-is-accessor-descriptor-1.0.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/is-arguments/-/is-arguments-1.1.1.tgz -> npmpkg-is-arguments-1.1.1.tgz
https://registry.npmjs.org/is-array-buffer/-/is-array-buffer-3.0.2.tgz -> npmpkg-is-array-buffer-3.0.2.tgz
https://registry.npmjs.org/is-arrayish/-/is-arrayish-0.2.1.tgz -> npmpkg-is-arrayish-0.2.1.tgz
https://registry.npmjs.org/is-bigint/-/is-bigint-1.0.4.tgz -> npmpkg-is-bigint-1.0.4.tgz
https://registry.npmjs.org/is-binary-path/-/is-binary-path-1.0.1.tgz -> npmpkg-is-binary-path-1.0.1.tgz
https://registry.npmjs.org/is-boolean-object/-/is-boolean-object-1.1.2.tgz -> npmpkg-is-boolean-object-1.1.2.tgz
https://registry.npmjs.org/is-buffer/-/is-buffer-1.1.6.tgz -> npmpkg-is-buffer-1.1.6.tgz
https://registry.npmjs.org/is-callable/-/is-callable-1.2.7.tgz -> npmpkg-is-callable-1.2.7.tgz
https://registry.npmjs.org/is-ci/-/is-ci-1.2.1.tgz -> npmpkg-is-ci-1.2.1.tgz
https://registry.npmjs.org/is-core-module/-/is-core-module-2.12.0.tgz -> npmpkg-is-core-module-2.12.0.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-1.0.0.tgz -> npmpkg-is-data-descriptor-1.0.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/is-date-object/-/is-date-object-1.0.5.tgz -> npmpkg-is-date-object-1.0.5.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-1.0.2.tgz -> npmpkg-is-descriptor-1.0.2.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/is-directory/-/is-directory-0.3.1.tgz -> npmpkg-is-directory-0.3.1.tgz
https://registry.npmjs.org/is-dotfile/-/is-dotfile-1.0.3.tgz -> npmpkg-is-dotfile-1.0.3.tgz
https://registry.npmjs.org/is-equal-shallow/-/is-equal-shallow-0.1.3.tgz -> npmpkg-is-equal-shallow-0.1.3.tgz
https://registry.npmjs.org/is-error/-/is-error-2.2.2.tgz -> npmpkg-is-error-2.2.2.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-1.0.0.tgz -> npmpkg-is-extglob-1.0.0.tgz
https://registry.npmjs.org/is-finite/-/is-finite-1.1.0.tgz -> npmpkg-is-finite-1.1.0.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> npmpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.npmjs.org/is-function/-/is-function-1.0.2.tgz -> npmpkg-is-function-1.0.2.tgz
https://registry.npmjs.org/is-generator-fn/-/is-generator-fn-1.0.0.tgz -> npmpkg-is-generator-fn-1.0.0.tgz
https://registry.npmjs.org/is-get-set-prop/-/is-get-set-prop-1.0.0.tgz -> npmpkg-is-get-set-prop-1.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-2.0.1.tgz -> npmpkg-is-glob-2.0.1.tgz
https://registry.npmjs.org/is-installed-globally/-/is-installed-globally-0.1.0.tgz -> npmpkg-is-installed-globally-0.1.0.tgz
https://registry.npmjs.org/is-js-type/-/is-js-type-2.0.0.tgz -> npmpkg-is-js-type-2.0.0.tgz
https://registry.npmjs.org/is-negative-zero/-/is-negative-zero-2.0.2.tgz -> npmpkg-is-negative-zero-2.0.2.tgz
https://registry.npmjs.org/is-npm/-/is-npm-1.0.0.tgz -> npmpkg-is-npm-1.0.0.tgz
https://registry.npmjs.org/is-number/-/is-number-2.1.0.tgz -> npmpkg-is-number-2.1.0.tgz
https://registry.npmjs.org/is-number-object/-/is-number-object-1.0.7.tgz -> npmpkg-is-number-object-1.0.7.tgz
https://registry.npmjs.org/is-obj/-/is-obj-1.0.1.tgz -> npmpkg-is-obj-1.0.1.tgz
https://registry.npmjs.org/is-obj-prop/-/is-obj-prop-1.0.0.tgz -> npmpkg-is-obj-prop-1.0.0.tgz
https://registry.npmjs.org/is-observable/-/is-observable-1.1.0.tgz -> npmpkg-is-observable-1.1.0.tgz
https://registry.npmjs.org/is-path-cwd/-/is-path-cwd-1.0.0.tgz -> npmpkg-is-path-cwd-1.0.0.tgz
https://registry.npmjs.org/is-path-in-cwd/-/is-path-in-cwd-1.0.1.tgz -> npmpkg-is-path-in-cwd-1.0.1.tgz
https://registry.npmjs.org/is-path-inside/-/is-path-inside-1.0.1.tgz -> npmpkg-is-path-inside-1.0.1.tgz
https://registry.npmjs.org/is-plain-obj/-/is-plain-obj-1.1.0.tgz -> npmpkg-is-plain-obj-1.1.0.tgz
https://registry.npmjs.org/is-plain-object/-/is-plain-object-2.0.4.tgz -> npmpkg-is-plain-object-2.0.4.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/is-posix-bracket/-/is-posix-bracket-0.1.1.tgz -> npmpkg-is-posix-bracket-0.1.1.tgz
https://registry.npmjs.org/is-primitive/-/is-primitive-2.0.0.tgz -> npmpkg-is-primitive-2.0.0.tgz
https://registry.npmjs.org/is-promise/-/is-promise-2.2.2.tgz -> npmpkg-is-promise-2.2.2.tgz
https://registry.npmjs.org/is-proto-prop/-/is-proto-prop-1.0.1.tgz -> npmpkg-is-proto-prop-1.0.1.tgz
https://registry.npmjs.org/is-redirect/-/is-redirect-1.0.0.tgz -> npmpkg-is-redirect-1.0.0.tgz
https://registry.npmjs.org/is-regex/-/is-regex-1.1.4.tgz -> npmpkg-is-regex-1.1.4.tgz
https://registry.npmjs.org/is-resolvable/-/is-resolvable-1.1.0.tgz -> npmpkg-is-resolvable-1.1.0.tgz
https://registry.npmjs.org/is-retry-allowed/-/is-retry-allowed-1.2.0.tgz -> npmpkg-is-retry-allowed-1.2.0.tgz
https://registry.npmjs.org/is-shared-array-buffer/-/is-shared-array-buffer-1.0.2.tgz -> npmpkg-is-shared-array-buffer-1.0.2.tgz
https://registry.npmjs.org/is-stream/-/is-stream-1.1.0.tgz -> npmpkg-is-stream-1.1.0.tgz
https://registry.npmjs.org/is-string/-/is-string-1.0.7.tgz -> npmpkg-is-string-1.0.7.tgz
https://registry.npmjs.org/is-symbol/-/is-symbol-1.0.4.tgz -> npmpkg-is-symbol-1.0.4.tgz
https://registry.npmjs.org/is-typed-array/-/is-typed-array-1.1.10.tgz -> npmpkg-is-typed-array-1.1.10.tgz
https://registry.npmjs.org/is-url/-/is-url-1.2.4.tgz -> npmpkg-is-url-1.2.4.tgz
https://registry.npmjs.org/is-utf8/-/is-utf8-0.2.1.tgz -> npmpkg-is-utf8-0.2.1.tgz
https://registry.npmjs.org/is-weakref/-/is-weakref-1.0.2.tgz -> npmpkg-is-weakref-1.0.2.tgz
https://registry.npmjs.org/is-windows/-/is-windows-1.0.2.tgz -> npmpkg-is-windows-1.0.2.tgz
https://registry.npmjs.org/is-wsl/-/is-wsl-1.1.0.tgz -> npmpkg-is-wsl-1.1.0.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz -> npmpkg-isarray-1.0.0.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz -> npmpkg-isexe-2.0.0.tgz
https://registry.npmjs.org/isobject/-/isobject-2.1.0.tgz -> npmpkg-isobject-2.1.0.tgz
https://registry.npmjs.org/iterm2-version/-/iterm2-version-3.0.0.tgz -> npmpkg-iterm2-version-3.0.0.tgz
https://registry.npmjs.org/jest-docblock/-/jest-docblock-21.2.0.tgz -> npmpkg-jest-docblock-21.2.0.tgz
https://registry.npmjs.org/jpeg-js/-/jpeg-js-0.2.0.tgz -> npmpkg-jpeg-js-0.2.0.tgz
https://github.com/notmasteryet/jpgjs/archive/f1d30922fda93417669246f5a25cf2393dd9c108.tar.gz -> npmpkg-jpgjs.git-f1d30922fda93417669246f5a25cf2393dd9c108.tgz
https://registry.npmjs.org/js-string-escape/-/js-string-escape-1.0.1.tgz -> npmpkg-js-string-escape-1.0.1.tgz
https://registry.npmjs.org/js-tokens/-/js-tokens-3.0.2.tgz -> npmpkg-js-tokens-3.0.2.tgz
https://registry.npmjs.org/js-types/-/js-types-1.0.0.tgz -> npmpkg-js-types-1.0.0.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-3.14.1.tgz -> npmpkg-js-yaml-3.14.1.tgz
https://registry.npmjs.org/jsesc/-/jsesc-1.3.0.tgz -> npmpkg-jsesc-1.3.0.tgz
https://registry.npmjs.org/json-parse-better-errors/-/json-parse-better-errors-1.0.2.tgz -> npmpkg-json-parse-better-errors-1.0.2.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-0.3.1.tgz -> npmpkg-json-schema-traverse-0.3.1.tgz
https://registry.npmjs.org/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz -> npmpkg-json-stable-stringify-without-jsonify-1.0.1.tgz
https://registry.npmjs.org/json5/-/json5-0.5.1.tgz -> npmpkg-json5-0.5.1.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-5.0.0.tgz -> npmpkg-jsonfile-5.0.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/last-line-stream/-/last-line-stream-1.0.0.tgz -> npmpkg-last-line-stream-1.0.0.tgz
https://registry.npmjs.org/latest-version/-/latest-version-3.1.0.tgz -> npmpkg-latest-version-3.1.0.tgz
https://registry.npmjs.org/levn/-/levn-0.3.0.tgz -> npmpkg-levn-0.3.0.tgz
https://registry.npmjs.org/line-column-path/-/line-column-path-1.0.0.tgz -> npmpkg-line-column-path-1.0.0.tgz
https://registry.npmjs.org/listr/-/listr-0.14.3.tgz -> npmpkg-listr-0.14.3.tgz
https://registry.npmjs.org/listr-silent-renderer/-/listr-silent-renderer-1.1.1.tgz -> npmpkg-listr-silent-renderer-1.1.1.tgz
https://registry.npmjs.org/listr-update-renderer/-/listr-update-renderer-0.5.0.tgz -> npmpkg-listr-update-renderer-0.5.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-2.1.1.tgz -> npmpkg-ansi-regex-2.1.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-2.2.1.tgz -> npmpkg-ansi-styles-2.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-1.1.3.tgz -> npmpkg-chalk-1.1.3.tgz
https://registry.npmjs.org/cli-truncate/-/cli-truncate-0.2.1.tgz -> npmpkg-cli-truncate-0.2.1.tgz
https://registry.npmjs.org/figures/-/figures-1.7.0.tgz -> npmpkg-figures-1.7.0.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-1.0.0.tgz -> npmpkg-is-fullwidth-code-point-1.0.0.tgz
https://registry.npmjs.org/slice-ansi/-/slice-ansi-0.0.4.tgz -> npmpkg-slice-ansi-0.0.4.tgz
https://registry.npmjs.org/string-width/-/string-width-1.0.2.tgz -> npmpkg-string-width-1.0.2.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-3.0.1.tgz -> npmpkg-strip-ansi-3.0.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-2.0.0.tgz -> npmpkg-supports-color-2.0.0.tgz
https://registry.npmjs.org/listr-verbose-renderer/-/listr-verbose-renderer-0.5.0.tgz -> npmpkg-listr-verbose-renderer-0.5.0.tgz
https://registry.npmjs.org/p-map/-/p-map-2.1.0.tgz -> npmpkg-p-map-2.1.0.tgz
https://registry.npmjs.org/load-bmfont/-/load-bmfont-1.4.1.tgz -> npmpkg-load-bmfont-1.4.1.tgz
https://registry.npmjs.org/mime/-/mime-1.6.0.tgz -> npmpkg-mime-1.6.0.tgz
https://registry.npmjs.org/load-json-file/-/load-json-file-4.0.0.tgz -> npmpkg-load-json-file-4.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-3.0.0.tgz -> npmpkg-locate-path-3.0.0.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/lodash.camelcase/-/lodash.camelcase-4.3.0.tgz -> npmpkg-lodash.camelcase-4.3.0.tgz
https://registry.npmjs.org/lodash.clonedeep/-/lodash.clonedeep-4.5.0.tgz -> npmpkg-lodash.clonedeep-4.5.0.tgz
https://registry.npmjs.org/lodash.clonedeepwith/-/lodash.clonedeepwith-4.5.0.tgz -> npmpkg-lodash.clonedeepwith-4.5.0.tgz
https://registry.npmjs.org/lodash.debounce/-/lodash.debounce-4.0.8.tgz -> npmpkg-lodash.debounce-4.0.8.tgz
https://registry.npmjs.org/lodash.difference/-/lodash.difference-4.5.0.tgz -> npmpkg-lodash.difference-4.5.0.tgz
https://registry.npmjs.org/lodash.flatten/-/lodash.flatten-4.4.0.tgz -> npmpkg-lodash.flatten-4.4.0.tgz
https://registry.npmjs.org/lodash.flattendeep/-/lodash.flattendeep-4.4.0.tgz -> npmpkg-lodash.flattendeep-4.4.0.tgz
https://registry.npmjs.org/lodash.get/-/lodash.get-4.4.2.tgz -> npmpkg-lodash.get-4.4.2.tgz
https://registry.npmjs.org/lodash.isequal/-/lodash.isequal-4.5.0.tgz -> npmpkg-lodash.isequal-4.5.0.tgz
https://registry.npmjs.org/lodash.kebabcase/-/lodash.kebabcase-4.1.1.tgz -> npmpkg-lodash.kebabcase-4.1.1.tgz
https://registry.npmjs.org/lodash.merge/-/lodash.merge-4.6.2.tgz -> npmpkg-lodash.merge-4.6.2.tgz
https://registry.npmjs.org/lodash.mergewith/-/lodash.mergewith-4.6.2.tgz -> npmpkg-lodash.mergewith-4.6.2.tgz
https://registry.npmjs.org/lodash.snakecase/-/lodash.snakecase-4.1.1.tgz -> npmpkg-lodash.snakecase-4.1.1.tgz
https://registry.npmjs.org/lodash.upperfirst/-/lodash.upperfirst-4.3.1.tgz -> npmpkg-lodash.upperfirst-4.3.1.tgz
https://registry.npmjs.org/lodash.zip/-/lodash.zip-4.2.0.tgz -> npmpkg-lodash.zip-4.2.0.tgz
https://registry.npmjs.org/log-symbols/-/log-symbols-1.0.2.tgz -> npmpkg-log-symbols-1.0.2.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-2.1.1.tgz -> npmpkg-ansi-regex-2.1.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-2.2.1.tgz -> npmpkg-ansi-styles-2.2.1.tgz
https://registry.npmjs.org/chalk/-/chalk-1.1.3.tgz -> npmpkg-chalk-1.1.3.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-3.0.1.tgz -> npmpkg-strip-ansi-3.0.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-2.0.0.tgz -> npmpkg-supports-color-2.0.0.tgz
https://registry.npmjs.org/log-update/-/log-update-2.3.0.tgz -> npmpkg-log-update-2.3.0.tgz
https://registry.npmjs.org/loose-envify/-/loose-envify-1.4.0.tgz -> npmpkg-loose-envify-1.4.0.tgz
https://registry.npmjs.org/loud-rejection/-/loud-rejection-1.6.0.tgz -> npmpkg-loud-rejection-1.6.0.tgz
https://registry.npmjs.org/lowercase-keys/-/lowercase-keys-1.0.1.tgz -> npmpkg-lowercase-keys-1.0.1.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-4.1.5.tgz -> npmpkg-lru-cache-4.1.5.tgz
https://registry.npmjs.org/make-dir/-/make-dir-1.3.0.tgz -> npmpkg-make-dir-1.3.0.tgz
https://registry.npmjs.org/map-cache/-/map-cache-0.2.2.tgz -> npmpkg-map-cache-0.2.2.tgz
https://registry.npmjs.org/map-obj/-/map-obj-2.0.0.tgz -> npmpkg-map-obj-2.0.0.tgz
https://registry.npmjs.org/map-visit/-/map-visit-1.0.0.tgz -> npmpkg-map-visit-1.0.0.tgz
https://registry.npmjs.org/matcher/-/matcher-1.1.1.tgz -> npmpkg-matcher-1.1.1.tgz
https://registry.npmjs.org/math-random/-/math-random-1.0.4.tgz -> npmpkg-math-random-1.0.4.tgz
https://registry.npmjs.org/md5-hex/-/md5-hex-2.0.0.tgz -> npmpkg-md5-hex-2.0.0.tgz
https://registry.npmjs.org/md5-o-matic/-/md5-o-matic-0.1.1.tgz -> npmpkg-md5-o-matic-0.1.1.tgz
https://registry.npmjs.org/meow/-/meow-5.0.0.tgz -> npmpkg-meow-5.0.0.tgz
https://registry.npmjs.org/find-up/-/find-up-2.1.0.tgz -> npmpkg-find-up-2.1.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-2.0.0.tgz -> npmpkg-locate-path-2.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-1.3.0.tgz -> npmpkg-p-limit-1.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-2.0.0.tgz -> npmpkg-p-locate-2.0.0.tgz
https://registry.npmjs.org/p-try/-/p-try-1.0.0.tgz -> npmpkg-p-try-1.0.0.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-3.0.0.tgz -> npmpkg-read-pkg-3.0.0.tgz
https://registry.npmjs.org/read-pkg-up/-/read-pkg-up-3.0.0.tgz -> npmpkg-read-pkg-up-3.0.0.tgz
https://registry.npmjs.org/merge2/-/merge2-1.4.1.tgz -> npmpkg-merge2-1.4.1.tgz
https://registry.npmjs.org/micromatch/-/micromatch-2.3.11.tgz -> npmpkg-micromatch-2.3.11.tgz
https://registry.npmjs.org/mime/-/mime-2.6.0.tgz -> npmpkg-mime-2.6.0.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-1.2.0.tgz -> npmpkg-mimic-fn-1.2.0.tgz
https://registry.npmjs.org/min-document/-/min-document-2.19.0.tgz -> npmpkg-min-document-2.19.0.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.8.tgz -> npmpkg-minimist-1.2.8.tgz
https://registry.npmjs.org/minimist-options/-/minimist-options-3.0.2.tgz -> npmpkg-minimist-options-3.0.2.tgz
https://registry.npmjs.org/mixin-deep/-/mixin-deep-1.3.2.tgz -> npmpkg-mixin-deep-1.3.2.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-1.0.1.tgz -> npmpkg-is-extendable-1.0.1.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.6.tgz -> npmpkg-mkdirp-0.5.6.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz -> npmpkg-ms-2.1.3.tgz
https://registry.npmjs.org/multimatch/-/multimatch-2.1.0.tgz -> npmpkg-multimatch-2.1.0.tgz
https://registry.npmjs.org/mute-stream/-/mute-stream-0.0.7.tgz -> npmpkg-mute-stream-0.0.7.tgz
https://registry.npmjs.org/nan/-/nan-2.17.0.tgz -> npmpkg-nan-2.17.0.tgz
https://registry.npmjs.org/nanoid/-/nanoid-2.1.11.tgz -> npmpkg-nanoid-2.1.11.tgz
https://registry.npmjs.org/nanomatch/-/nanomatch-1.2.13.tgz -> npmpkg-nanomatch-1.2.13.tgz
https://registry.npmjs.org/arr-diff/-/arr-diff-4.0.0.tgz -> npmpkg-arr-diff-4.0.0.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.3.2.tgz -> npmpkg-array-unique-0.3.2.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/natural-compare/-/natural-compare-1.4.0.tgz -> npmpkg-natural-compare-1.4.0.tgz
https://registry.npmjs.org/nice-try/-/nice-try-1.0.5.tgz -> npmpkg-nice-try-1.0.5.tgz
https://registry.npmjs.org/node-version/-/node-version-1.2.0.tgz -> npmpkg-node-version-1.2.0.tgz
https://registry.npmjs.org/normalize-package-data/-/normalize-package-data-2.5.0.tgz -> npmpkg-normalize-package-data-2.5.0.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-2.1.1.tgz -> npmpkg-normalize-path-2.1.1.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-2.0.2.tgz -> npmpkg-npm-run-path-2.0.2.tgz
https://registry.npmjs.org/number-is-nan/-/number-is-nan-1.0.1.tgz -> npmpkg-number-is-nan-1.0.1.tgz
https://registry.npmjs.org/obj-props/-/obj-props-1.4.0.tgz -> npmpkg-obj-props-1.4.0.tgz
https://registry.npmjs.org/object-assign/-/object-assign-4.1.1.tgz -> npmpkg-object-assign-4.1.1.tgz
https://registry.npmjs.org/object-copy/-/object-copy-0.1.0.tgz -> npmpkg-object-copy-0.1.0.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz -> npmpkg-is-accessor-descriptor-0.1.6.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz -> npmpkg-is-data-descriptor-0.1.4.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.6.tgz -> npmpkg-is-descriptor-0.1.6.tgz
https://registry.npmjs.org/kind-of/-/kind-of-5.1.0.tgz -> npmpkg-kind-of-5.1.0.tgz
https://registry.npmjs.org/object-inspect/-/object-inspect-1.12.3.tgz -> npmpkg-object-inspect-1.12.3.tgz
https://registry.npmjs.org/object-is/-/object-is-1.1.5.tgz -> npmpkg-object-is-1.1.5.tgz
https://registry.npmjs.org/object-keys/-/object-keys-1.1.1.tgz -> npmpkg-object-keys-1.1.1.tgz
https://registry.npmjs.org/object-visit/-/object-visit-1.0.1.tgz -> npmpkg-object-visit-1.0.1.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/object.assign/-/object.assign-4.1.4.tgz -> npmpkg-object.assign-4.1.4.tgz
https://registry.npmjs.org/object.omit/-/object.omit-2.0.1.tgz -> npmpkg-object.omit-2.0.1.tgz
https://registry.npmjs.org/object.pick/-/object.pick-1.3.0.tgz -> npmpkg-object.pick-1.3.0.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/object.values/-/object.values-1.1.6.tgz -> npmpkg-object.values-1.1.6.tgz
https://registry.npmjs.org/observable-to-promise/-/observable-to-promise-0.5.0.tgz -> npmpkg-observable-to-promise-0.5.0.tgz
https://registry.npmjs.org/is-observable/-/is-observable-0.2.0.tgz -> npmpkg-is-observable-0.2.0.tgz
https://registry.npmjs.org/symbol-observable/-/symbol-observable-0.2.4.tgz -> npmpkg-symbol-observable-0.2.4.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz -> npmpkg-once-1.4.0.tgz
https://registry.npmjs.org/onetime/-/onetime-2.0.1.tgz -> npmpkg-onetime-2.0.1.tgz
https://registry.npmjs.org/open-editor/-/open-editor-1.2.0.tgz -> npmpkg-open-editor-1.2.0.tgz
https://registry.npmjs.org/opn/-/opn-5.5.0.tgz -> npmpkg-opn-5.5.0.tgz
https://registry.npmjs.org/option-chain/-/option-chain-1.0.0.tgz -> npmpkg-option-chain-1.0.0.tgz
https://registry.npmjs.org/optionator/-/optionator-0.8.3.tgz -> npmpkg-optionator-0.8.3.tgz
https://registry.npmjs.org/os-homedir/-/os-homedir-1.0.2.tgz -> npmpkg-os-homedir-1.0.2.tgz
https://registry.npmjs.org/os-tmpdir/-/os-tmpdir-1.0.2.tgz -> npmpkg-os-tmpdir-1.0.2.tgz
https://registry.npmjs.org/p-finally/-/p-finally-1.0.0.tgz -> npmpkg-p-finally-1.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-3.0.0.tgz -> npmpkg-p-locate-3.0.0.tgz
https://registry.npmjs.org/p-map/-/p-map-1.2.0.tgz -> npmpkg-p-map-1.2.0.tgz
https://registry.npmjs.org/p-try/-/p-try-2.2.0.tgz -> npmpkg-p-try-2.2.0.tgz
https://registry.npmjs.org/package-hash/-/package-hash-2.0.0.tgz -> npmpkg-package-hash-2.0.0.tgz
https://registry.npmjs.org/package-json/-/package-json-4.0.1.tgz -> npmpkg-package-json-4.0.1.tgz
https://registry.npmjs.org/pako/-/pako-1.0.11.tgz -> npmpkg-pako-1.0.11.tgz
https://registry.npmjs.org/parse-bmfont-ascii/-/parse-bmfont-ascii-1.0.6.tgz -> npmpkg-parse-bmfont-ascii-1.0.6.tgz
https://registry.npmjs.org/parse-bmfont-binary/-/parse-bmfont-binary-1.0.6.tgz -> npmpkg-parse-bmfont-binary-1.0.6.tgz
https://registry.npmjs.org/parse-bmfont-xml/-/parse-bmfont-xml-1.1.4.tgz -> npmpkg-parse-bmfont-xml-1.1.4.tgz
https://registry.npmjs.org/parse-glob/-/parse-glob-3.0.4.tgz -> npmpkg-parse-glob-3.0.4.tgz
https://registry.npmjs.org/parse-headers/-/parse-headers-2.0.5.tgz -> npmpkg-parse-headers-2.0.5.tgz
https://registry.npmjs.org/parse-json/-/parse-json-4.0.0.tgz -> npmpkg-parse-json-4.0.0.tgz
https://registry.npmjs.org/parse-ms/-/parse-ms-1.0.1.tgz -> npmpkg-parse-ms-1.0.1.tgz
https://registry.npmjs.org/pascalcase/-/pascalcase-0.1.1.tgz -> npmpkg-pascalcase-0.1.1.tgz
https://registry.npmjs.org/path-dirname/-/path-dirname-1.0.2.tgz -> npmpkg-path-dirname-1.0.2.tgz
https://registry.npmjs.org/path-exists/-/path-exists-3.0.0.tgz -> npmpkg-path-exists-3.0.0.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> npmpkg-path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/path-is-inside/-/path-is-inside-1.0.2.tgz -> npmpkg-path-is-inside-1.0.2.tgz
https://registry.npmjs.org/path-key/-/path-key-2.0.1.tgz -> npmpkg-path-key-2.0.1.tgz
https://registry.npmjs.org/path-parse/-/path-parse-1.0.7.tgz -> npmpkg-path-parse-1.0.7.tgz
https://registry.npmjs.org/path-type/-/path-type-3.0.0.tgz -> npmpkg-path-type-3.0.0.tgz
https://registry.npmjs.org/pend/-/pend-1.2.0.tgz -> npmpkg-pend-1.2.0.tgz
https://registry.npmjs.org/phin/-/phin-2.9.3.tgz -> npmpkg-phin-2.9.3.tgz
https://registry.npmjs.org/pify/-/pify-3.0.0.tgz -> npmpkg-pify-3.0.0.tgz
https://registry.npmjs.org/pinkie/-/pinkie-1.0.0.tgz -> npmpkg-pinkie-1.0.0.tgz
https://registry.npmjs.org/pinkie-promise/-/pinkie-promise-1.0.0.tgz -> npmpkg-pinkie-promise-1.0.0.tgz
https://registry.npmjs.org/pixelmatch/-/pixelmatch-4.0.2.tgz -> npmpkg-pixelmatch-4.0.2.tgz
https://registry.npmjs.org/pkg-conf/-/pkg-conf-2.1.0.tgz -> npmpkg-pkg-conf-2.1.0.tgz
https://registry.npmjs.org/find-up/-/find-up-2.1.0.tgz -> npmpkg-find-up-2.1.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-2.0.0.tgz -> npmpkg-locate-path-2.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-1.3.0.tgz -> npmpkg-p-limit-1.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-2.0.0.tgz -> npmpkg-p-locate-2.0.0.tgz
https://registry.npmjs.org/p-try/-/p-try-1.0.0.tgz -> npmpkg-p-try-1.0.0.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-2.0.0.tgz -> npmpkg-pkg-dir-2.0.0.tgz
https://registry.npmjs.org/find-up/-/find-up-2.1.0.tgz -> npmpkg-find-up-2.1.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-2.0.0.tgz -> npmpkg-locate-path-2.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-1.3.0.tgz -> npmpkg-p-limit-1.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-2.0.0.tgz -> npmpkg-p-locate-2.0.0.tgz
https://registry.npmjs.org/p-try/-/p-try-1.0.0.tgz -> npmpkg-p-try-1.0.0.tgz
https://registry.npmjs.org/pkg-up/-/pkg-up-2.0.0.tgz -> npmpkg-pkg-up-2.0.0.tgz
https://registry.npmjs.org/find-up/-/find-up-2.1.0.tgz -> npmpkg-find-up-2.1.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-2.0.0.tgz -> npmpkg-locate-path-2.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-1.3.0.tgz -> npmpkg-p-limit-1.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-2.0.0.tgz -> npmpkg-p-locate-2.0.0.tgz
https://registry.npmjs.org/p-try/-/p-try-1.0.0.tgz -> npmpkg-p-try-1.0.0.tgz
https://registry.npmjs.org/please-upgrade-node/-/please-upgrade-node-3.2.0.tgz -> npmpkg-please-upgrade-node-3.2.0.tgz
https://registry.npmjs.org/plist/-/plist-3.0.6.tgz -> npmpkg-plist-3.0.6.tgz
https://registry.npmjs.org/plur/-/plur-2.1.2.tgz -> npmpkg-plur-2.1.2.tgz
https://registry.npmjs.org/pluralize/-/pluralize-7.0.0.tgz -> npmpkg-pluralize-7.0.0.tgz
https://registry.npmjs.org/pngjs/-/pngjs-3.4.0.tgz -> npmpkg-pngjs-3.4.0.tgz
https://registry.npmjs.org/posix-character-classes/-/posix-character-classes-0.1.1.tgz -> npmpkg-posix-character-classes-0.1.1.tgz
https://registry.npmjs.org/prelude-ls/-/prelude-ls-1.1.2.tgz -> npmpkg-prelude-ls-1.1.2.tgz
https://registry.npmjs.org/prepend-http/-/prepend-http-1.0.4.tgz -> npmpkg-prepend-http-1.0.4.tgz
https://registry.npmjs.org/preserve/-/preserve-0.2.0.tgz -> npmpkg-preserve-0.2.0.tgz
https://registry.npmjs.org/prettier/-/prettier-1.19.1.tgz -> npmpkg-prettier-1.19.1.tgz
https://registry.npmjs.org/pretty-ms/-/pretty-ms-3.2.0.tgz -> npmpkg-pretty-ms-3.2.0.tgz
https://registry.npmjs.org/private/-/private-0.1.8.tgz -> npmpkg-private-0.1.8.tgz
https://registry.npmjs.org/process/-/process-0.11.10.tgz -> npmpkg-process-0.11.10.tgz
https://registry.npmjs.org/process-nextick-args/-/process-nextick-args-2.0.1.tgz -> npmpkg-process-nextick-args-2.0.1.tgz
https://registry.npmjs.org/progress/-/progress-2.0.3.tgz -> npmpkg-progress-2.0.3.tgz
https://registry.npmjs.org/promise-polyfill/-/promise-polyfill-6.1.0.tgz -> npmpkg-promise-polyfill-6.1.0.tgz
https://registry.npmjs.org/proto-props/-/proto-props-1.1.0.tgz -> npmpkg-proto-props-1.1.0.tgz
https://registry.npmjs.org/proxy-from-env/-/proxy-from-env-1.1.0.tgz -> npmpkg-proxy-from-env-1.1.0.tgz
https://registry.npmjs.org/pseudomap/-/pseudomap-1.0.2.tgz -> npmpkg-pseudomap-1.0.2.tgz
https://registry.npmjs.org/pump/-/pump-3.0.0.tgz -> npmpkg-pump-3.0.0.tgz
https://registry.npmjs.org/puppeteer/-/puppeteer-1.20.0.tgz -> npmpkg-puppeteer-1.20.0.tgz
https://registry.npmjs.org/debug/-/debug-4.3.4.tgz -> npmpkg-debug-4.3.4.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/query-string/-/query-string-6.14.1.tgz -> npmpkg-query-string-6.14.1.tgz
https://registry.npmjs.org/quick-lru/-/quick-lru-1.1.0.tgz -> npmpkg-quick-lru-1.1.0.tgz
https://registry.npmjs.org/randomatic/-/randomatic-3.1.1.tgz -> npmpkg-randomatic-3.1.1.tgz
https://registry.npmjs.org/is-number/-/is-number-4.0.0.tgz -> npmpkg-is-number-4.0.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/raw-body/-/raw-body-2.5.2.tgz -> npmpkg-raw-body-2.5.2.tgz
https://registry.npmjs.org/rc/-/rc-1.2.8.tgz -> npmpkg-rc-1.2.8.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-4.0.1.tgz -> npmpkg-read-pkg-4.0.1.tgz
https://registry.npmjs.org/read-pkg-up/-/read-pkg-up-2.0.0.tgz -> npmpkg-read-pkg-up-2.0.0.tgz
https://registry.npmjs.org/find-up/-/find-up-2.1.0.tgz -> npmpkg-find-up-2.1.0.tgz
https://registry.npmjs.org/load-json-file/-/load-json-file-2.0.0.tgz -> npmpkg-load-json-file-2.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-2.0.0.tgz -> npmpkg-locate-path-2.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-1.3.0.tgz -> npmpkg-p-limit-1.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-2.0.0.tgz -> npmpkg-p-locate-2.0.0.tgz
https://registry.npmjs.org/p-try/-/p-try-1.0.0.tgz -> npmpkg-p-try-1.0.0.tgz
https://registry.npmjs.org/parse-json/-/parse-json-2.2.0.tgz -> npmpkg-parse-json-2.2.0.tgz
https://registry.npmjs.org/path-type/-/path-type-2.0.0.tgz -> npmpkg-path-type-2.0.0.tgz
https://registry.npmjs.org/pify/-/pify-2.3.0.tgz -> npmpkg-pify-2.3.0.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-2.0.0.tgz -> npmpkg-read-pkg-2.0.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.8.tgz -> npmpkg-readable-stream-2.3.8.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/readdirp/-/readdirp-2.2.1.tgz -> npmpkg-readdirp-2.2.1.tgz
https://registry.npmjs.org/arr-diff/-/arr-diff-4.0.0.tgz -> npmpkg-arr-diff-4.0.0.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.3.2.tgz -> npmpkg-array-unique-0.3.2.tgz
https://registry.npmjs.org/braces/-/braces-2.3.2.tgz -> npmpkg-braces-2.3.2.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/expand-brackets/-/expand-brackets-2.1.4.tgz -> npmpkg-expand-brackets-2.1.4.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.6.tgz -> npmpkg-is-descriptor-0.1.6.tgz
https://registry.npmjs.org/kind-of/-/kind-of-5.1.0.tgz -> npmpkg-kind-of-5.1.0.tgz
https://registry.npmjs.org/extglob/-/extglob-2.0.4.tgz -> npmpkg-extglob-2.0.4.tgz
https://registry.npmjs.org/define-property/-/define-property-1.0.0.tgz -> npmpkg-define-property-1.0.0.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/fill-range/-/fill-range-4.0.0.tgz -> npmpkg-fill-range-4.0.0.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz -> npmpkg-is-accessor-descriptor-0.1.6.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz -> npmpkg-is-data-descriptor-0.1.4.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/is-number/-/is-number-3.0.0.tgz -> npmpkg-is-number-3.0.0.tgz
https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz -> npmpkg-kind-of-3.2.2.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz -> npmpkg-kind-of-6.0.3.tgz
https://registry.npmjs.org/micromatch/-/micromatch-3.1.10.tgz -> npmpkg-micromatch-3.1.10.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/redent/-/redent-2.0.0.tgz -> npmpkg-redent-2.0.0.tgz
https://registry.npmjs.org/regenerate/-/regenerate-1.4.2.tgz -> npmpkg-regenerate-1.4.2.tgz
https://registry.npmjs.org/regenerator-runtime/-/regenerator-runtime-0.11.1.tgz -> npmpkg-regenerator-runtime-0.11.1.tgz
https://registry.npmjs.org/regex-cache/-/regex-cache-0.4.4.tgz -> npmpkg-regex-cache-0.4.4.tgz
https://registry.npmjs.org/regex-not/-/regex-not-1.0.2.tgz -> npmpkg-regex-not-1.0.2.tgz
https://registry.npmjs.org/regexp.prototype.flags/-/regexp.prototype.flags-1.4.3.tgz -> npmpkg-regexp.prototype.flags-1.4.3.tgz
https://registry.npmjs.org/regexpp/-/regexpp-1.1.0.tgz -> npmpkg-regexpp-1.1.0.tgz
https://registry.npmjs.org/regexpu-core/-/regexpu-core-2.0.0.tgz -> npmpkg-regexpu-core-2.0.0.tgz
https://registry.npmjs.org/registry-auth-token/-/registry-auth-token-3.4.0.tgz -> npmpkg-registry-auth-token-3.4.0.tgz
https://registry.npmjs.org/registry-url/-/registry-url-3.1.0.tgz -> npmpkg-registry-url-3.1.0.tgz
https://registry.npmjs.org/regjsgen/-/regjsgen-0.2.0.tgz -> npmpkg-regjsgen-0.2.0.tgz
https://registry.npmjs.org/regjsparser/-/regjsparser-0.1.5.tgz -> npmpkg-regjsparser-0.1.5.tgz
https://registry.npmjs.org/jsesc/-/jsesc-0.5.0.tgz -> npmpkg-jsesc-0.5.0.tgz
https://registry.npmjs.org/release-zalgo/-/release-zalgo-1.0.0.tgz -> npmpkg-release-zalgo-1.0.0.tgz
https://registry.npmjs.org/remove-trailing-separator/-/remove-trailing-separator-1.1.0.tgz -> npmpkg-remove-trailing-separator-1.1.0.tgz
https://registry.npmjs.org/repeat-element/-/repeat-element-1.1.4.tgz -> npmpkg-repeat-element-1.1.4.tgz
https://registry.npmjs.org/repeat-string/-/repeat-string-1.6.1.tgz -> npmpkg-repeat-string-1.6.1.tgz
https://registry.npmjs.org/repeating/-/repeating-2.0.1.tgz -> npmpkg-repeating-2.0.1.tgz
https://registry.npmjs.org/require-precompiled/-/require-precompiled-0.1.0.tgz -> npmpkg-require-precompiled-0.1.0.tgz
https://registry.npmjs.org/require-uncached/-/require-uncached-1.0.3.tgz -> npmpkg-require-uncached-1.0.3.tgz
https://registry.npmjs.org/caller-path/-/caller-path-0.1.0.tgz -> npmpkg-caller-path-0.1.0.tgz
https://registry.npmjs.org/callsites/-/callsites-0.2.0.tgz -> npmpkg-callsites-0.2.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-1.0.1.tgz -> npmpkg-resolve-from-1.0.1.tgz
https://registry.npmjs.org/resolve/-/resolve-1.22.2.tgz -> npmpkg-resolve-1.22.2.tgz
https://registry.npmjs.org/resolve-cwd/-/resolve-cwd-2.0.0.tgz -> npmpkg-resolve-cwd-2.0.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-3.0.0.tgz -> npmpkg-resolve-from-3.0.0.tgz
https://registry.npmjs.org/resolve-url/-/resolve-url-0.2.1.tgz -> npmpkg-resolve-url-0.2.1.tgz
https://registry.npmjs.org/restore-cursor/-/restore-cursor-2.0.0.tgz -> npmpkg-restore-cursor-2.0.0.tgz
https://registry.npmjs.org/ret/-/ret-0.1.15.tgz -> npmpkg-ret-0.1.15.tgz
https://registry.npmjs.org/rimraf/-/rimraf-2.7.1.tgz -> npmpkg-rimraf-2.7.1.tgz
https://registry.npmjs.org/run-async/-/run-async-2.4.1.tgz -> npmpkg-run-async-2.4.1.tgz
https://registry.npmjs.org/run-node/-/run-node-1.0.0.tgz -> npmpkg-run-node-1.0.0.tgz
https://registry.npmjs.org/rx-lite/-/rx-lite-4.0.8.tgz -> npmpkg-rx-lite-4.0.8.tgz
https://registry.npmjs.org/rx-lite-aggregates/-/rx-lite-aggregates-4.0.8.tgz -> npmpkg-rx-lite-aggregates-4.0.8.tgz
https://registry.npmjs.org/rxjs/-/rxjs-6.6.7.tgz -> npmpkg-rxjs-6.6.7.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz -> npmpkg-safe-buffer-5.2.1.tgz
https://registry.npmjs.org/safe-regex/-/safe-regex-1.1.0.tgz -> npmpkg-safe-regex-1.1.0.tgz
https://registry.npmjs.org/safe-regex-test/-/safe-regex-test-1.0.0.tgz -> npmpkg-safe-regex-test-1.0.0.tgz
https://registry.npmjs.org/safer-buffer/-/safer-buffer-2.1.2.tgz -> npmpkg-safer-buffer-2.1.2.tgz
https://registry.npmjs.org/sax/-/sax-1.2.4.tgz -> npmpkg-sax-1.2.4.tgz
https://registry.npmjs.org/semver/-/semver-5.7.1.tgz -> npmpkg-semver-5.7.1.tgz
https://registry.npmjs.org/semver-compare/-/semver-compare-1.0.0.tgz -> npmpkg-semver-compare-1.0.0.tgz
https://registry.npmjs.org/semver-diff/-/semver-diff-2.1.0.tgz -> npmpkg-semver-diff-2.1.0.tgz
https://registry.npmjs.org/serialize-error/-/serialize-error-2.1.0.tgz -> npmpkg-serialize-error-2.1.0.tgz
https://registry.npmjs.org/set-value/-/set-value-2.0.1.tgz -> npmpkg-set-value-2.0.1.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/setprototypeof/-/setprototypeof-1.2.0.tgz -> npmpkg-setprototypeof-1.2.0.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-1.2.0.tgz -> npmpkg-shebang-command-1.2.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-1.0.0.tgz -> npmpkg-shebang-regex-1.0.0.tgz
https://registry.npmjs.org/side-channel/-/side-channel-1.0.4.tgz -> npmpkg-side-channel-1.0.4.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-3.0.7.tgz -> npmpkg-signal-exit-3.0.7.tgz
https://registry.npmjs.org/slash/-/slash-1.0.0.tgz -> npmpkg-slash-1.0.0.tgz
https://registry.npmjs.org/slice-ansi/-/slice-ansi-1.0.0.tgz -> npmpkg-slice-ansi-1.0.0.tgz
https://registry.npmjs.org/slide/-/slide-1.1.6.tgz -> npmpkg-slide-1.1.6.tgz
https://registry.npmjs.org/snapdragon/-/snapdragon-0.8.2.tgz -> npmpkg-snapdragon-0.8.2.tgz
https://registry.npmjs.org/snapdragon-node/-/snapdragon-node-2.1.1.tgz -> npmpkg-snapdragon-node-2.1.1.tgz
https://registry.npmjs.org/define-property/-/define-property-1.0.0.tgz -> npmpkg-define-property-1.0.0.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/snapdragon-util/-/snapdragon-util-3.0.1.tgz -> npmpkg-snapdragon-util-3.0.1.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz -> npmpkg-is-accessor-descriptor-0.1.6.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz -> npmpkg-is-data-descriptor-0.1.4.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.6.tgz -> npmpkg-is-descriptor-0.1.6.tgz
https://registry.npmjs.org/kind-of/-/kind-of-5.1.0.tgz -> npmpkg-kind-of-5.1.0.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/sort-keys/-/sort-keys-2.0.0.tgz -> npmpkg-sort-keys-2.0.0.tgz
https://registry.npmjs.org/source-map/-/source-map-0.5.7.tgz -> npmpkg-source-map-0.5.7.tgz
https://registry.npmjs.org/source-map-resolve/-/source-map-resolve-0.5.3.tgz -> npmpkg-source-map-resolve-0.5.3.tgz
https://registry.npmjs.org/source-map-support/-/source-map-support-0.5.21.tgz -> npmpkg-source-map-support-0.5.21.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/source-map-url/-/source-map-url-0.4.1.tgz -> npmpkg-source-map-url-0.4.1.tgz
https://registry.npmjs.org/spdx-correct/-/spdx-correct-3.2.0.tgz -> npmpkg-spdx-correct-3.2.0.tgz
https://registry.npmjs.org/spdx-exceptions/-/spdx-exceptions-2.3.0.tgz -> npmpkg-spdx-exceptions-2.3.0.tgz
https://registry.npmjs.org/spdx-expression-parse/-/spdx-expression-parse-3.0.1.tgz -> npmpkg-spdx-expression-parse-3.0.1.tgz
https://registry.npmjs.org/spdx-license-ids/-/spdx-license-ids-3.0.13.tgz -> npmpkg-spdx-license-ids-3.0.13.tgz
https://registry.npmjs.org/split-on-first/-/split-on-first-1.1.0.tgz -> npmpkg-split-on-first-1.1.0.tgz
https://registry.npmjs.org/split-string/-/split-string-3.1.0.tgz -> npmpkg-split-string-3.1.0.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.0.3.tgz -> npmpkg-sprintf-js-1.0.3.tgz
https://registry.npmjs.org/stack-utils/-/stack-utils-1.0.5.tgz -> npmpkg-stack-utils-1.0.5.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-2.0.0.tgz -> npmpkg-escape-string-regexp-2.0.0.tgz
https://registry.npmjs.org/static-extend/-/static-extend-0.1.2.tgz -> npmpkg-static-extend-0.1.2.tgz
https://registry.npmjs.org/define-property/-/define-property-0.2.5.tgz -> npmpkg-define-property-0.2.5.tgz
https://registry.npmjs.org/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz -> npmpkg-is-accessor-descriptor-0.1.6.tgz
https://registry.npmjs.org/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz -> npmpkg-is-data-descriptor-0.1.4.tgz
https://registry.npmjs.org/is-descriptor/-/is-descriptor-0.1.6.tgz -> npmpkg-is-descriptor-0.1.6.tgz
https://registry.npmjs.org/kind-of/-/kind-of-5.1.0.tgz -> npmpkg-kind-of-5.1.0.tgz
https://registry.npmjs.org/statuses/-/statuses-2.0.1.tgz -> npmpkg-statuses-2.0.1.tgz
https://registry.npmjs.org/strict-uri-encode/-/strict-uri-encode-2.0.0.tgz -> npmpkg-strict-uri-encode-2.0.0.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-1.1.1.tgz -> npmpkg-string_decoder-1.1.1.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/string-width/-/string-width-2.1.1.tgz -> npmpkg-string-width-2.1.1.tgz
https://registry.npmjs.org/string.prototype.trim/-/string.prototype.trim-1.2.7.tgz -> npmpkg-string.prototype.trim-1.2.7.tgz
https://registry.npmjs.org/string.prototype.trimend/-/string.prototype.trimend-1.0.6.tgz -> npmpkg-string.prototype.trimend-1.0.6.tgz
https://registry.npmjs.org/string.prototype.trimstart/-/string.prototype.trimstart-1.0.6.tgz -> npmpkg-string.prototype.trimstart-1.0.6.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-4.0.0.tgz -> npmpkg-strip-ansi-4.0.0.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-3.0.0.tgz -> npmpkg-strip-bom-3.0.0.tgz
https://registry.npmjs.org/strip-bom-buf/-/strip-bom-buf-1.0.0.tgz -> npmpkg-strip-bom-buf-1.0.0.tgz
https://registry.npmjs.org/strip-eof/-/strip-eof-1.0.0.tgz -> npmpkg-strip-eof-1.0.0.tgz
https://registry.npmjs.org/strip-indent/-/strip-indent-2.0.0.tgz -> npmpkg-strip-indent-2.0.0.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-2.0.1.tgz -> npmpkg-strip-json-comments-2.0.1.tgz
https://registry.npmjs.org/supertap/-/supertap-1.0.0.tgz -> npmpkg-supertap-1.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz -> npmpkg-supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.npmjs.org/symbol-observable/-/symbol-observable-1.2.0.tgz -> npmpkg-symbol-observable-1.2.0.tgz
https://registry.npmjs.org/table/-/table-4.0.2.tgz -> npmpkg-table-4.0.2.tgz
https://registry.npmjs.org/temp-dir/-/temp-dir-1.0.0.tgz -> npmpkg-temp-dir-1.0.0.tgz
https://registry.npmjs.org/tempy/-/tempy-0.2.1.tgz -> npmpkg-tempy-0.2.1.tgz
https://registry.npmjs.org/term-img/-/term-img-3.0.0.tgz -> npmpkg-term-img-3.0.0.tgz
https://registry.npmjs.org/term-size/-/term-size-1.2.0.tgz -> npmpkg-term-size-1.2.0.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-5.1.0.tgz -> npmpkg-cross-spawn-5.1.0.tgz
https://registry.npmjs.org/execa/-/execa-0.7.0.tgz -> npmpkg-execa-0.7.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-3.0.0.tgz -> npmpkg-get-stream-3.0.0.tgz
https://registry.npmjs.org/terminal-image/-/terminal-image-0.1.2.tgz -> npmpkg-terminal-image-0.1.2.tgz
https://registry.npmjs.org/text-table/-/text-table-0.2.0.tgz -> npmpkg-text-table-0.2.0.tgz
https://registry.npmjs.org/the-argv/-/the-argv-1.0.0.tgz -> npmpkg-the-argv-1.0.0.tgz
https://registry.npmjs.org/through/-/through-2.3.8.tgz -> npmpkg-through-2.3.8.tgz
https://registry.npmjs.org/through2/-/through2-2.0.5.tgz -> npmpkg-through2-2.0.5.tgz
https://registry.npmjs.org/time-zone/-/time-zone-1.0.0.tgz -> npmpkg-time-zone-1.0.0.tgz
https://registry.npmjs.org/timed-out/-/timed-out-4.0.1.tgz -> npmpkg-timed-out-4.0.1.tgz
https://registry.npmjs.org/tinycolor2/-/tinycolor2-1.6.0.tgz -> npmpkg-tinycolor2-1.6.0.tgz
https://registry.npmjs.org/tmp/-/tmp-0.0.33.tgz -> npmpkg-tmp-0.0.33.tgz
https://registry.npmjs.org/to-fast-properties/-/to-fast-properties-1.0.3.tgz -> npmpkg-to-fast-properties-1.0.3.tgz
https://registry.npmjs.org/to-object-path/-/to-object-path-0.3.0.tgz -> npmpkg-to-object-path-0.3.0.tgz
https://registry.npmjs.org/to-regex/-/to-regex-3.0.2.tgz -> npmpkg-to-regex-3.0.2.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-2.1.1.tgz -> npmpkg-to-regex-range-2.1.1.tgz
https://registry.npmjs.org/is-number/-/is-number-3.0.0.tgz -> npmpkg-is-number-3.0.0.tgz
https://registry.npmjs.org/toidentifier/-/toidentifier-1.0.1.tgz -> npmpkg-toidentifier-1.0.1.tgz
https://registry.npmjs.org/trim-newlines/-/trim-newlines-2.0.0.tgz -> npmpkg-trim-newlines-2.0.0.tgz
https://registry.npmjs.org/trim-off-newlines/-/trim-off-newlines-1.0.3.tgz -> npmpkg-trim-off-newlines-1.0.3.tgz
https://registry.npmjs.org/trim-right/-/trim-right-1.0.1.tgz -> npmpkg-trim-right-1.0.1.tgz
https://registry.npmjs.org/tsconfig-paths/-/tsconfig-paths-3.14.2.tgz -> npmpkg-tsconfig-paths-3.14.2.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/tslib/-/tslib-1.14.1.tgz -> npmpkg-tslib-1.14.1.tgz
https://registry.npmjs.org/type-check/-/type-check-0.3.2.tgz -> npmpkg-type-check-0.3.2.tgz
https://registry.npmjs.org/typed-array-length/-/typed-array-length-1.0.4.tgz -> npmpkg-typed-array-length-1.0.4.tgz
https://registry.npmjs.org/typedarray/-/typedarray-0.0.6.tgz -> npmpkg-typedarray-0.0.6.tgz
https://registry.npmjs.org/uid2/-/uid2-0.0.3.tgz -> npmpkg-uid2-0.0.3.tgz
https://registry.npmjs.org/unbox-primitive/-/unbox-primitive-1.0.2.tgz -> npmpkg-unbox-primitive-1.0.2.tgz
https://registry.npmjs.org/union-value/-/union-value-1.0.1.tgz -> npmpkg-union-value-1.0.1.tgz
https://registry.npmjs.org/unique-string/-/unique-string-1.0.0.tgz -> npmpkg-unique-string-1.0.0.tgz
https://registry.npmjs.org/unique-temp-dir/-/unique-temp-dir-1.0.0.tgz -> npmpkg-unique-temp-dir-1.0.0.tgz
https://registry.npmjs.org/universalify/-/universalify-0.1.2.tgz -> npmpkg-universalify-0.1.2.tgz
https://registry.npmjs.org/unpipe/-/unpipe-1.0.0.tgz -> npmpkg-unpipe-1.0.0.tgz
https://registry.npmjs.org/unset-value/-/unset-value-1.0.0.tgz -> npmpkg-unset-value-1.0.0.tgz
https://registry.npmjs.org/has-value/-/has-value-0.3.1.tgz -> npmpkg-has-value-0.3.1.tgz
https://registry.npmjs.org/isobject/-/isobject-2.1.0.tgz -> npmpkg-isobject-2.1.0.tgz
https://registry.npmjs.org/has-values/-/has-values-0.1.4.tgz -> npmpkg-has-values-0.1.4.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz -> npmpkg-isobject-3.0.1.tgz
https://registry.npmjs.org/unzip-response/-/unzip-response-2.0.1.tgz -> npmpkg-unzip-response-2.0.1.tgz
https://registry.npmjs.org/update-notifier/-/update-notifier-2.5.0.tgz -> npmpkg-update-notifier-2.5.0.tgz
https://registry.npmjs.org/urix/-/urix-0.1.0.tgz -> npmpkg-urix-0.1.0.tgz
https://registry.npmjs.org/url-parse-lax/-/url-parse-lax-1.0.0.tgz -> npmpkg-url-parse-lax-1.0.0.tgz
https://registry.npmjs.org/use/-/use-3.1.1.tgz -> npmpkg-use-3.1.1.tgz
https://registry.npmjs.org/utif/-/utif-1.3.0.tgz -> npmpkg-utif-1.3.0.tgz
https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz -> npmpkg-util-deprecate-1.0.2.tgz
https://registry.npmjs.org/validate-npm-package-license/-/validate-npm-package-license-3.0.4.tgz -> npmpkg-validate-npm-package-license-3.0.4.tgz
https://registry.npmjs.org/well-known-symbols/-/well-known-symbols-1.0.0.tgz -> npmpkg-well-known-symbols-1.0.0.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/which-boxed-primitive/-/which-boxed-primitive-1.0.2.tgz -> npmpkg-which-boxed-primitive-1.0.2.tgz
https://registry.npmjs.org/which-typed-array/-/which-typed-array-1.1.9.tgz -> npmpkg-which-typed-array-1.1.9.tgz
https://registry.npmjs.org/widest-line/-/widest-line-2.0.1.tgz -> npmpkg-widest-line-2.0.1.tgz
https://registry.npmjs.org/word-wrap/-/word-wrap-1.2.3.tgz -> npmpkg-word-wrap-1.2.3.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-3.0.1.tgz -> npmpkg-wrap-ansi-3.0.1.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
https://registry.npmjs.org/write/-/write-0.2.1.tgz -> npmpkg-write-0.2.1.tgz
https://registry.npmjs.org/write-file-atomic/-/write-file-atomic-1.3.4.tgz -> npmpkg-write-file-atomic-1.3.4.tgz
https://registry.npmjs.org/write-json-file/-/write-json-file-2.3.0.tgz -> npmpkg-write-json-file-2.3.0.tgz
https://registry.npmjs.org/detect-indent/-/detect-indent-5.0.0.tgz -> npmpkg-detect-indent-5.0.0.tgz
https://registry.npmjs.org/write-file-atomic/-/write-file-atomic-2.4.3.tgz -> npmpkg-write-file-atomic-2.4.3.tgz
https://registry.npmjs.org/write-pkg/-/write-pkg-3.2.0.tgz -> npmpkg-write-pkg-3.2.0.tgz
https://registry.npmjs.org/ws/-/ws-6.2.2.tgz -> npmpkg-ws-6.2.2.tgz
https://registry.npmjs.org/xdg-basedir/-/xdg-basedir-3.0.0.tgz -> npmpkg-xdg-basedir-3.0.0.tgz
https://registry.npmjs.org/xhr/-/xhr-2.6.0.tgz -> npmpkg-xhr-2.6.0.tgz
https://registry.npmjs.org/xml-parse-from-string/-/xml-parse-from-string-1.0.1.tgz -> npmpkg-xml-parse-from-string-1.0.1.tgz
https://registry.npmjs.org/xml2js/-/xml2js-0.4.23.tgz -> npmpkg-xml2js-0.4.23.tgz
https://registry.npmjs.org/xmlbuilder/-/xmlbuilder-11.0.1.tgz -> npmpkg-xmlbuilder-11.0.1.tgz
https://registry.npmjs.org/xmlbuilder/-/xmlbuilder-15.1.1.tgz -> npmpkg-xmlbuilder-15.1.1.tgz
https://registry.npmjs.org/xo/-/xo-0.21.1.tgz -> npmpkg-xo-0.21.1.tgz
https://registry.npmjs.org/xo-init/-/xo-init-0.7.0.tgz -> npmpkg-xo-init-0.7.0.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-5.1.0.tgz -> npmpkg-cross-spawn-5.1.0.tgz
https://registry.npmjs.org/execa/-/execa-0.9.0.tgz -> npmpkg-execa-0.9.0.tgz
https://registry.npmjs.org/find-up/-/find-up-2.1.0.tgz -> npmpkg-find-up-2.1.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-3.0.0.tgz -> npmpkg-get-stream-3.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-2.0.0.tgz -> npmpkg-locate-path-2.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-1.3.0.tgz -> npmpkg-p-limit-1.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-2.0.0.tgz -> npmpkg-p-locate-2.0.0.tgz
https://registry.npmjs.org/p-try/-/p-try-1.0.0.tgz -> npmpkg-p-try-1.0.0.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-3.0.0.tgz -> npmpkg-read-pkg-3.0.0.tgz
https://registry.npmjs.org/read-pkg-up/-/read-pkg-up-3.0.0.tgz -> npmpkg-read-pkg-up-3.0.0.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz -> npmpkg-resolve-from-4.0.0.tgz
https://registry.npmjs.org/slash/-/slash-2.0.0.tgz -> npmpkg-slash-2.0.0.tgz
https://registry.npmjs.org/xtend/-/xtend-4.0.2.tgz -> npmpkg-xtend-4.0.2.tgz
https://registry.npmjs.org/yallist/-/yallist-2.1.2.tgz -> npmpkg-yallist-2.1.2.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-10.1.0.tgz -> npmpkg-yargs-parser-10.1.0.tgz
https://registry.npmjs.org/yauzl/-/yauzl-2.10.0.tgz -> npmpkg-yauzl-2.10.0.tgz
"
# UPDATER_END_NPM_EXTERNAL_URIS
SRC_URI="
${NPM_EXTERNAL_URIS}
https://github.com/mixn/carbon-now-cli/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${PN}-${PV}"

src_compile() { :; }

src_install() {
	insinto "${NPM_INSTALL_PATH}"
	doins -r *

	local path
	for path in ${NPM_EXE_LIST} ; do
		fperms 0755 "${path}"
	done

	cp "${FILESDIR}/${MY_PN}" "${T}" || die
	sed -i -e "s|__NODE_VERSION__|${NODE_VERSION}|g" \
		"${T}/${MY_PN}" \
		|| die
	exeinto /usr/bin
	doexe "${T}/${MY_PN}"
	if use custom-browser && [[ -z "${CARBON_NOW_BROWSER_PATH}" ]] ; then
eerror
eerror "custom-browser USE flag requires CARBON_NOW_BROWSER_PATH"
eerror "be set as an environment variable."
eerror
		die
	fi
	local browser_path=""
	if [[ -n "${CARBON_NOW_BROWSER_PATH}" ]] ; then
		browser_path="${CARBON_NOW_BROWSER_PATH}"
		[[ -e "${browser_path}" ]] || die "Fix CARBON_NOW_BROWSER_PATH"
	elif has_version "www-client/chromium-bin" ; then
		browser_path="/opt/chromium-bin/chrome"
	elif has_version "www-client/chromium" ; then
		browser_path="/opt/chromium/chrome"
	elif has_version "www-client/google-chrome" ; then
		browser_path="/opt/google/chrome/chrome"
	fi
	sed -i -e "1aexport PUPPETEER_EXECUTABLE_PATH=\"${browser_path}\"" \
		"${ED}"/usr/bin/carbon-now || die

	# The internal Chromium is broken
	# Removed vulnerable version
	rm -rf "${ED}${NPM_INSTALL_PATH}/node_modules/puppeteer/.local-chromium" || die
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
