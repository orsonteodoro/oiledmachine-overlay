# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NODE_VERSION=16
NPM_INSTALL_PATH="/opt/${PN}"

NPM_EXE_LIST="
${NPM_INSTALL_PATH}/cli/synp.js
${NPM_INSTALL_PATH}/cli/write-output.js
${NPM_INSTALL_PATH}/cli/validate-path.js
${NPM_INSTALL_PATH}/cli/validate-args.js
${NPM_INSTALL_PATH}/cli/run.js

${NPM_INSTALL_PATH}/node_modules/.bin/acorn
${NPM_INSTALL_PATH}/node_modules/.bin/eslint
${NPM_INSTALL_PATH}/node_modules/.bin/esparse
${NPM_INSTALL_PATH}/node_modules/.bin/esvalidate
${NPM_INSTALL_PATH}/node_modules/.bin/ignored
${NPM_INSTALL_PATH}/node_modules/.bin/js-yaml
${NPM_INSTALL_PATH}/node_modules/.bin/jsesc
${NPM_INSTALL_PATH}/node_modules/.bin/json5
${NPM_INSTALL_PATH}/node_modules/.bin/loose-envify
${NPM_INSTALL_PATH}/node_modules/.bin/nmtree
${NPM_INSTALL_PATH}/node_modules/.bin/nyc
${NPM_INSTALL_PATH}/node_modules/.bin/parser
${NPM_INSTALL_PATH}/node_modules/.bin/rimraf
${NPM_INSTALL_PATH}/node_modules/.bin/semver
${NPM_INSTALL_PATH}/node_modules/.bin/standard
${NPM_INSTALL_PATH}/node_modules/.bin/tape
${NPM_INSTALL_PATH}/node_modules/.bin/uuid
${NPM_INSTALL_PATH}/node_modules/.bin/which
${NPM_INSTALL_PATH}/node_modules/@babel/core/node_modules/.bin/semver
${NPM_INSTALL_PATH}/node_modules/eslint-plugin-node/node_modules/.bin/semver
${NPM_INSTALL_PATH}/node_modules/eslint/node_modules/.bin/node-which
${NPM_INSTALL_PATH}/node_modules/foreground-child/node_modules/.bin/node-which
${NPM_INSTALL_PATH}/node_modules/istanbul-lib-instrument/node_modules/.bin/semver
${NPM_INSTALL_PATH}/node_modules/istanbul-lib-processinfo/node_modules/.bin/node-which
${NPM_INSTALL_PATH}/node_modules/make-dir/node_modules/.bin/semver
${NPM_INSTALL_PATH}/node_modules/normalize-package-data/node_modules/.bin/semver
${NPM_INSTALL_PATH}/node_modules/spawn-wrap/node_modules/.bin/node-which
${NPM_INSTALL_PATH}/node_modules/tsconfig-paths/node_modules/.bin/json5
"
NPM_TEST_SCRIPT="test"
inherit npm

DESCRIPTION="Convert npm.lock to package-lock.json and vice versa"
HOMEPAGE="https://github.com/imsnif/synp"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test r3"
DEPEND+="
	>=net-libs/nodejs-${NODE_VERSION}:${NODE_VERSION}
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=net-libs/nodejs-${NODE_VERSION}:${NODE_VERSION}
	sys-apps/npm
"
# grep "resolved" ${NPM_INSTALL_PATH}package-lock.npm | cut -f 4 -d '"' | cut -f 1 -d "#" | sort | uniq
# UPDATER_START_NPM_EXTERNAL_URIS
NPM_EXTERNAL_URIS="
https://registry.npmjs.org/@babel/code-frame/-/code-frame-7.22.13.tgz -> npmpkg-@babel-code-frame-7.22.13.tgz
https://registry.npmjs.org/@babel/core/-/core-7.12.10.tgz -> npmpkg-@babel-core-7.12.10.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/@babel/generator/-/generator-7.23.0.tgz -> npmpkg-@babel-generator-7.23.0.tgz
https://registry.npmjs.org/@babel/helper-environment-visitor/-/helper-environment-visitor-7.22.20.tgz -> npmpkg-@babel-helper-environment-visitor-7.22.20.tgz
https://registry.npmjs.org/@babel/helper-function-name/-/helper-function-name-7.23.0.tgz -> npmpkg-@babel-helper-function-name-7.23.0.tgz
https://registry.npmjs.org/@babel/helper-hoist-variables/-/helper-hoist-variables-7.22.5.tgz -> npmpkg-@babel-helper-hoist-variables-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-member-expression-to-functions/-/helper-member-expression-to-functions-7.12.7.tgz -> npmpkg-@babel-helper-member-expression-to-functions-7.12.7.tgz
https://registry.npmjs.org/@babel/helper-module-imports/-/helper-module-imports-7.12.5.tgz -> npmpkg-@babel-helper-module-imports-7.12.5.tgz
https://registry.npmjs.org/@babel/helper-module-transforms/-/helper-module-transforms-7.12.1.tgz -> npmpkg-@babel-helper-module-transforms-7.12.1.tgz
https://registry.npmjs.org/@babel/helper-optimise-call-expression/-/helper-optimise-call-expression-7.12.10.tgz -> npmpkg-@babel-helper-optimise-call-expression-7.12.10.tgz
https://registry.npmjs.org/@babel/helper-replace-supers/-/helper-replace-supers-7.12.11.tgz -> npmpkg-@babel-helper-replace-supers-7.12.11.tgz
https://registry.npmjs.org/@babel/helper-simple-access/-/helper-simple-access-7.12.1.tgz -> npmpkg-@babel-helper-simple-access-7.12.1.tgz
https://registry.npmjs.org/@babel/helper-split-export-declaration/-/helper-split-export-declaration-7.22.6.tgz -> npmpkg-@babel-helper-split-export-declaration-7.22.6.tgz
https://registry.npmjs.org/@babel/helper-string-parser/-/helper-string-parser-7.22.5.tgz -> npmpkg-@babel-helper-string-parser-7.22.5.tgz
https://registry.npmjs.org/@babel/helper-validator-identifier/-/helper-validator-identifier-7.22.20.tgz -> npmpkg-@babel-helper-validator-identifier-7.22.20.tgz
https://registry.npmjs.org/@babel/helpers/-/helpers-7.12.5.tgz -> npmpkg-@babel-helpers-7.12.5.tgz
https://registry.npmjs.org/@babel/highlight/-/highlight-7.22.20.tgz -> npmpkg-@babel-highlight-7.22.20.tgz
https://registry.npmjs.org/@babel/parser/-/parser-7.23.0.tgz -> npmpkg-@babel-parser-7.23.0.tgz
https://registry.npmjs.org/@babel/template/-/template-7.22.15.tgz -> npmpkg-@babel-template-7.22.15.tgz
https://registry.npmjs.org/@babel/traverse/-/traverse-7.23.2.tgz -> npmpkg-@babel-traverse-7.23.2.tgz
https://registry.npmjs.org/@babel/types/-/types-7.23.0.tgz -> npmpkg-@babel-types-7.23.0.tgz
https://registry.npmjs.org/@eslint/eslintrc/-/eslintrc-0.3.0.tgz -> npmpkg-@eslint-eslintrc-0.3.0.tgz
https://registry.npmjs.org/globals/-/globals-12.4.0.tgz -> npmpkg-globals-12.4.0.tgz
https://registry.npmjs.org/@istanbuljs/load-nyc-config/-/load-nyc-config-1.1.0.tgz -> npmpkg-@istanbuljs-load-nyc-config-1.1.0.tgz
https://registry.npmjs.org/@istanbuljs/schema/-/schema-0.1.2.tgz -> npmpkg-@istanbuljs-schema-0.1.2.tgz
https://registry.npmjs.org/@jridgewell/gen-mapping/-/gen-mapping-0.3.3.tgz -> npmpkg-@jridgewell-gen-mapping-0.3.3.tgz
https://registry.npmjs.org/@jridgewell/resolve-uri/-/resolve-uri-3.1.1.tgz -> npmpkg-@jridgewell-resolve-uri-3.1.1.tgz
https://registry.npmjs.org/@jridgewell/set-array/-/set-array-1.1.2.tgz -> npmpkg-@jridgewell-set-array-1.1.2.tgz
https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.4.15.tgz -> npmpkg-@jridgewell-sourcemap-codec-1.4.15.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.20.tgz -> npmpkg-@jridgewell-trace-mapping-0.3.20.tgz
https://registry.npmjs.org/@sinonjs/commons/-/commons-1.8.3.tgz -> npmpkg-@sinonjs-commons-1.8.3.tgz
https://registry.npmjs.org/@sinonjs/fake-timers/-/fake-timers-6.0.1.tgz -> npmpkg-@sinonjs-fake-timers-6.0.1.tgz
https://registry.npmjs.org/@sinonjs/samsam/-/samsam-5.3.1.tgz -> npmpkg-@sinonjs-samsam-5.3.1.tgz
https://registry.npmjs.org/@sinonjs/text-encoding/-/text-encoding-0.7.1.tgz -> npmpkg-@sinonjs-text-encoding-0.7.1.tgz
https://registry.npmjs.org/@types/json5/-/json5-0.0.29.tgz -> npmpkg-@types-json5-0.0.29.tgz
https://registry.npmjs.org/@yarnpkg/lockfile/-/lockfile-1.1.0.tgz -> npmpkg-@yarnpkg-lockfile-1.1.0.tgz
https://registry.npmjs.org/acorn/-/acorn-7.4.1.tgz -> npmpkg-acorn-7.4.1.tgz
https://registry.npmjs.org/acorn-jsx/-/acorn-jsx-5.3.1.tgz -> npmpkg-acorn-jsx-5.3.1.tgz
https://registry.npmjs.org/aggregate-error/-/aggregate-error-3.1.0.tgz -> npmpkg-aggregate-error-3.1.0.tgz
https://registry.npmjs.org/ajv/-/ajv-6.12.6.tgz -> npmpkg-ajv-6.12.6.tgz
https://registry.npmjs.org/ansi-colors/-/ansi-colors-4.1.1.tgz -> npmpkg-ansi-colors-4.1.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz -> npmpkg-ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz -> npmpkg-ansi-styles-3.2.1.tgz
https://registry.npmjs.org/append-transform/-/append-transform-2.0.0.tgz -> npmpkg-append-transform-2.0.0.tgz
https://registry.npmjs.org/archy/-/archy-1.0.0.tgz -> npmpkg-archy-1.0.0.tgz
https://registry.npmjs.org/argparse/-/argparse-1.0.10.tgz -> npmpkg-argparse-1.0.10.tgz
https://registry.npmjs.org/arr-union/-/arr-union-3.1.0.tgz -> npmpkg-arr-union-3.1.0.tgz
https://registry.npmjs.org/array-filter/-/array-filter-1.0.0.tgz -> npmpkg-array-filter-1.0.0.tgz
https://registry.npmjs.org/array-includes/-/array-includes-3.1.4.tgz -> npmpkg-array-includes-3.1.4.tgz
https://registry.npmjs.org/array.prototype.every/-/array.prototype.every-1.1.3.tgz -> npmpkg-array.prototype.every-1.1.3.tgz
https://registry.npmjs.org/array.prototype.flat/-/array.prototype.flat-1.2.5.tgz -> npmpkg-array.prototype.flat-1.2.5.tgz
https://registry.npmjs.org/array.prototype.flatmap/-/array.prototype.flatmap-1.2.5.tgz -> npmpkg-array.prototype.flatmap-1.2.5.tgz
https://registry.npmjs.org/astral-regex/-/astral-regex-2.0.0.tgz -> npmpkg-astral-regex-2.0.0.tgz
https://registry.npmjs.org/available-typed-arrays/-/available-typed-arrays-1.0.2.tgz -> npmpkg-available-typed-arrays-1.0.2.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.0.tgz -> npmpkg-balanced-match-1.0.0.tgz
https://registry.npmjs.org/bash-glob/-/bash-glob-2.0.0.tgz -> npmpkg-bash-glob-2.0.0.tgz
https://registry.npmjs.org/bash-path/-/bash-path-1.0.3.tgz -> npmpkg-bash-path-1.0.3.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz -> npmpkg-brace-expansion-1.1.11.tgz
https://registry.npmjs.org/caching-transform/-/caching-transform-4.0.0.tgz -> npmpkg-caching-transform-4.0.0.tgz
https://registry.npmjs.org/call-bind/-/call-bind-1.0.2.tgz -> npmpkg-call-bind-1.0.2.tgz
https://registry.npmjs.org/callsites/-/callsites-3.1.0.tgz -> npmpkg-callsites-3.1.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-5.3.1.tgz -> npmpkg-camelcase-5.3.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz -> npmpkg-chalk-2.4.2.tgz
https://registry.npmjs.org/clean-stack/-/clean-stack-2.2.0.tgz -> npmpkg-clean-stack-2.2.0.tgz
https://registry.npmjs.org/cliui/-/cliui-6.0.0.tgz -> npmpkg-cliui-6.0.0.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz -> npmpkg-color-convert-1.9.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz -> npmpkg-color-name-1.1.3.tgz
https://registry.npmjs.org/colors/-/colors-1.4.0.tgz -> npmpkg-colors-1.4.0.tgz
https://registry.npmjs.org/commander/-/commander-7.2.0.tgz -> npmpkg-commander-7.2.0.tgz
https://registry.npmjs.org/commondir/-/commondir-1.0.1.tgz -> npmpkg-commondir-1.0.1.tgz
https://registry.npmjs.org/component-emitter/-/component-emitter-1.3.0.tgz -> npmpkg-component-emitter-1.3.0.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz -> npmpkg-concat-map-0.0.1.tgz
https://registry.npmjs.org/convert-source-map/-/convert-source-map-1.7.0.tgz -> npmpkg-convert-source-map-1.7.0.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-5.1.0.tgz -> npmpkg-cross-spawn-5.1.0.tgz
https://registry.npmjs.org/debug/-/debug-4.3.1.tgz -> npmpkg-debug-4.3.1.tgz
https://registry.npmjs.org/decamelize/-/decamelize-1.2.0.tgz -> npmpkg-decamelize-1.2.0.tgz
https://registry.npmjs.org/deep-equal/-/deep-equal-2.0.5.tgz -> npmpkg-deep-equal-2.0.5.tgz
https://registry.npmjs.org/isarray/-/isarray-2.0.5.tgz -> npmpkg-isarray-2.0.5.tgz
https://registry.npmjs.org/deep-is/-/deep-is-0.1.3.tgz -> npmpkg-deep-is-0.1.3.tgz
https://registry.npmjs.org/default-require-extensions/-/default-require-extensions-3.0.0.tgz -> npmpkg-default-require-extensions-3.0.0.tgz
https://registry.npmjs.org/define-properties/-/define-properties-1.1.3.tgz -> npmpkg-define-properties-1.1.3.tgz
https://registry.npmjs.org/defined/-/defined-1.0.0.tgz -> npmpkg-defined-1.0.0.tgz
https://registry.npmjs.org/diff/-/diff-4.0.2.tgz -> npmpkg-diff-4.0.2.tgz
https://registry.npmjs.org/doctrine/-/doctrine-3.0.0.tgz -> npmpkg-doctrine-3.0.0.tgz
https://registry.npmjs.org/dotignore/-/dotignore-0.1.2.tgz -> npmpkg-dotignore-0.1.2.tgz
https://registry.npmjs.org/each-parallel-async/-/each-parallel-async-1.0.0.tgz -> npmpkg-each-parallel-async-1.0.0.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz -> npmpkg-emoji-regex-8.0.0.tgz
https://registry.npmjs.org/enquirer/-/enquirer-2.3.6.tgz -> npmpkg-enquirer-2.3.6.tgz
https://registry.npmjs.org/eol/-/eol-0.9.1.tgz -> npmpkg-eol-0.9.1.tgz
https://registry.npmjs.org/error-ex/-/error-ex-1.3.2.tgz -> npmpkg-error-ex-1.3.2.tgz
https://registry.npmjs.org/es-abstract/-/es-abstract-1.19.1.tgz -> npmpkg-es-abstract-1.19.1.tgz
https://registry.npmjs.org/es-get-iterator/-/es-get-iterator-1.1.1.tgz -> npmpkg-es-get-iterator-1.1.1.tgz
https://registry.npmjs.org/isarray/-/isarray-2.0.5.tgz -> npmpkg-isarray-2.0.5.tgz
https://registry.npmjs.org/es-to-primitive/-/es-to-primitive-1.2.1.tgz -> npmpkg-es-to-primitive-1.2.1.tgz
https://registry.npmjs.org/es6-error/-/es6-error-4.1.1.tgz -> npmpkg-es6-error-4.1.1.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> npmpkg-escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/eslint/-/eslint-7.18.0.tgz -> npmpkg-eslint-7.18.0.tgz
https://registry.npmjs.org/eslint-config-standard/-/eslint-config-standard-16.0.3.tgz -> npmpkg-eslint-config-standard-16.0.3.tgz
https://registry.npmjs.org/eslint-config-standard-jsx/-/eslint-config-standard-jsx-10.0.0.tgz -> npmpkg-eslint-config-standard-jsx-10.0.0.tgz
https://registry.npmjs.org/eslint-import-resolver-node/-/eslint-import-resolver-node-0.3.6.tgz -> npmpkg-eslint-import-resolver-node-0.3.6.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/eslint-module-utils/-/eslint-module-utils-2.7.1.tgz -> npmpkg-eslint-module-utils-2.7.1.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz -> npmpkg-debug-3.2.7.tgz
https://registry.npmjs.org/find-up/-/find-up-2.1.0.tgz -> npmpkg-find-up-2.1.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-2.0.0.tgz -> npmpkg-locate-path-2.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-1.3.0.tgz -> npmpkg-p-limit-1.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-2.0.0.tgz -> npmpkg-p-locate-2.0.0.tgz
https://registry.npmjs.org/p-try/-/p-try-1.0.0.tgz -> npmpkg-p-try-1.0.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-3.0.0.tgz -> npmpkg-path-exists-3.0.0.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-2.0.0.tgz -> npmpkg-pkg-dir-2.0.0.tgz
https://registry.npmjs.org/eslint-plugin-es/-/eslint-plugin-es-3.0.1.tgz -> npmpkg-eslint-plugin-es-3.0.1.tgz
https://registry.npmjs.org/eslint-plugin-import/-/eslint-plugin-import-2.24.2.tgz -> npmpkg-eslint-plugin-import-2.24.2.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz -> npmpkg-debug-2.6.9.tgz
https://registry.npmjs.org/doctrine/-/doctrine-2.1.0.tgz -> npmpkg-doctrine-2.1.0.tgz
https://registry.npmjs.org/find-up/-/find-up-2.1.0.tgz -> npmpkg-find-up-2.1.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-2.0.0.tgz -> npmpkg-locate-path-2.0.0.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz -> npmpkg-ms-2.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-1.3.0.tgz -> npmpkg-p-limit-1.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-2.0.0.tgz -> npmpkg-p-locate-2.0.0.tgz
https://registry.npmjs.org/p-try/-/p-try-1.0.0.tgz -> npmpkg-p-try-1.0.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-3.0.0.tgz -> npmpkg-path-exists-3.0.0.tgz
https://registry.npmjs.org/eslint-plugin-node/-/eslint-plugin-node-11.1.0.tgz -> npmpkg-eslint-plugin-node-11.1.0.tgz
https://registry.npmjs.org/ignore/-/ignore-5.1.8.tgz -> npmpkg-ignore-5.1.8.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/eslint-plugin-promise/-/eslint-plugin-promise-5.1.1.tgz -> npmpkg-eslint-plugin-promise-5.1.1.tgz
https://registry.npmjs.org/eslint-plugin-react/-/eslint-plugin-react-7.25.3.tgz -> npmpkg-eslint-plugin-react-7.25.3.tgz
https://registry.npmjs.org/doctrine/-/doctrine-2.1.0.tgz -> npmpkg-doctrine-2.1.0.tgz
https://registry.npmjs.org/resolve/-/resolve-2.0.0-next.3.tgz -> npmpkg-resolve-2.0.0-next.3.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-5.1.1.tgz -> npmpkg-eslint-scope-5.1.1.tgz
https://registry.npmjs.org/estraverse/-/estraverse-4.3.0.tgz -> npmpkg-estraverse-4.3.0.tgz
https://registry.npmjs.org/eslint-utils/-/eslint-utils-2.1.0.tgz -> npmpkg-eslint-utils-2.1.0.tgz
https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-1.3.0.tgz -> npmpkg-eslint-visitor-keys-1.3.0.tgz
https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-2.0.0.tgz -> npmpkg-eslint-visitor-keys-2.0.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.0.tgz -> npmpkg-chalk-4.1.0.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz -> npmpkg-cross-spawn-7.0.3.tgz
https://registry.npmjs.org/globals/-/globals-12.4.0.tgz -> npmpkg-globals-12.4.0.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/espree/-/espree-7.3.1.tgz -> npmpkg-espree-7.3.1.tgz
https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-1.3.0.tgz -> npmpkg-eslint-visitor-keys-1.3.0.tgz
https://registry.npmjs.org/esprima/-/esprima-4.0.1.tgz -> npmpkg-esprima-4.0.1.tgz
https://registry.npmjs.org/esquery/-/esquery-1.3.1.tgz -> npmpkg-esquery-1.3.1.tgz
https://registry.npmjs.org/esrecurse/-/esrecurse-4.3.0.tgz -> npmpkg-esrecurse-4.3.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-5.2.0.tgz -> npmpkg-estraverse-5.2.0.tgz
https://registry.npmjs.org/esutils/-/esutils-2.0.3.tgz -> npmpkg-esutils-2.0.3.tgz
https://registry.npmjs.org/extend-shallow/-/extend-shallow-2.0.1.tgz -> npmpkg-extend-shallow-2.0.1.tgz
https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz -> npmpkg-fast-deep-equal-3.1.3.tgz
https://registry.npmjs.org/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz -> npmpkg-fast-json-stable-stringify-2.1.0.tgz
https://registry.npmjs.org/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz -> npmpkg-fast-levenshtein-2.0.6.tgz
https://registry.npmjs.org/file-entry-cache/-/file-entry-cache-6.0.1.tgz -> npmpkg-file-entry-cache-6.0.1.tgz
https://registry.npmjs.org/find-cache-dir/-/find-cache-dir-3.3.1.tgz -> npmpkg-find-cache-dir-3.3.1.tgz
https://registry.npmjs.org/find-up/-/find-up-4.1.0.tgz -> npmpkg-find-up-4.1.0.tgz
https://registry.npmjs.org/flat-cache/-/flat-cache-3.0.4.tgz -> npmpkg-flat-cache-3.0.4.tgz
https://registry.npmjs.org/flatted/-/flatted-3.2.2.tgz -> npmpkg-flatted-3.2.2.tgz
https://registry.npmjs.org/for-each/-/for-each-0.3.3.tgz -> npmpkg-for-each-0.3.3.tgz
https://registry.npmjs.org/foreach/-/foreach-2.0.5.tgz -> npmpkg-foreach-2.0.5.tgz
https://registry.npmjs.org/foreground-child/-/foreground-child-2.0.0.tgz -> npmpkg-foreground-child-2.0.0.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz -> npmpkg-cross-spawn-7.0.3.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/fromentries/-/fromentries-1.3.2.tgz -> npmpkg-fromentries-1.3.2.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz -> npmpkg-fs.realpath-1.0.0.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.1.tgz -> npmpkg-function-bind-1.1.1.tgz
https://registry.npmjs.org/functional-red-black-tree/-/functional-red-black-tree-1.0.1.tgz -> npmpkg-functional-red-black-tree-1.0.1.tgz
https://registry.npmjs.org/gensync/-/gensync-1.0.0-beta.2.tgz -> npmpkg-gensync-1.0.0-beta.2.tgz
https://registry.npmjs.org/get-caller-file/-/get-caller-file-2.0.5.tgz -> npmpkg-get-caller-file-2.0.5.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.1.1.tgz -> npmpkg-get-intrinsic-1.1.1.tgz
https://registry.npmjs.org/get-package-type/-/get-package-type-0.1.0.tgz -> npmpkg-get-package-type-0.1.0.tgz
https://registry.npmjs.org/get-stdin/-/get-stdin-8.0.0.tgz -> npmpkg-get-stdin-8.0.0.tgz
https://registry.npmjs.org/get-symbol-description/-/get-symbol-description-1.0.0.tgz -> npmpkg-get-symbol-description-1.0.0.tgz
https://registry.npmjs.org/glob/-/glob-7.2.0.tgz -> npmpkg-glob-7.2.0.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz -> npmpkg-glob-parent-5.1.2.tgz
https://registry.npmjs.org/globals/-/globals-11.12.0.tgz -> npmpkg-globals-11.12.0.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.4.tgz -> npmpkg-graceful-fs-4.2.4.tgz
https://registry.npmjs.org/has/-/has-1.0.3.tgz -> npmpkg-has-1.0.3.tgz
https://registry.npmjs.org/has-bigints/-/has-bigints-1.0.1.tgz -> npmpkg-has-bigints-1.0.1.tgz
https://registry.npmjs.org/has-dynamic-import/-/has-dynamic-import-2.0.1.tgz -> npmpkg-has-dynamic-import-2.0.1.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz -> npmpkg-has-flag-3.0.0.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.0.2.tgz -> npmpkg-has-symbols-1.0.2.tgz
https://registry.npmjs.org/has-tostringtag/-/has-tostringtag-1.0.0.tgz -> npmpkg-has-tostringtag-1.0.0.tgz
https://registry.npmjs.org/hasha/-/hasha-5.2.2.tgz -> npmpkg-hasha-5.2.2.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-2.8.9.tgz -> npmpkg-hosted-git-info-2.8.9.tgz
https://registry.npmjs.org/html-escaper/-/html-escaper-2.0.2.tgz -> npmpkg-html-escaper-2.0.2.tgz
https://registry.npmjs.org/ignore/-/ignore-4.0.6.tgz -> npmpkg-ignore-4.0.6.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz -> npmpkg-import-fresh-3.3.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz -> npmpkg-resolve-from-4.0.0.tgz
https://registry.npmjs.org/imurmurhash/-/imurmurhash-0.1.4.tgz -> npmpkg-imurmurhash-0.1.4.tgz
https://registry.npmjs.org/indent-string/-/indent-string-4.0.0.tgz -> npmpkg-indent-string-4.0.0.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz -> npmpkg-inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz -> npmpkg-inherits-2.0.4.tgz
https://registry.npmjs.org/internal-slot/-/internal-slot-1.0.3.tgz -> npmpkg-internal-slot-1.0.3.tgz
https://registry.npmjs.org/is-arguments/-/is-arguments-1.1.0.tgz -> npmpkg-is-arguments-1.1.0.tgz
https://registry.npmjs.org/is-arrayish/-/is-arrayish-0.2.1.tgz -> npmpkg-is-arrayish-0.2.1.tgz
https://registry.npmjs.org/is-bigint/-/is-bigint-1.0.1.tgz -> npmpkg-is-bigint-1.0.1.tgz
https://registry.npmjs.org/is-boolean-object/-/is-boolean-object-1.1.0.tgz -> npmpkg-is-boolean-object-1.1.0.tgz
https://registry.npmjs.org/is-callable/-/is-callable-1.2.4.tgz -> npmpkg-is-callable-1.2.4.tgz
https://registry.npmjs.org/is-core-module/-/is-core-module-2.8.0.tgz -> npmpkg-is-core-module-2.8.0.tgz
https://registry.npmjs.org/is-date-object/-/is-date-object-1.0.2.tgz -> npmpkg-is-date-object-1.0.2.tgz
https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz -> npmpkg-is-extendable-0.1.1.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz -> npmpkg-is-extglob-2.1.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> npmpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.1.tgz -> npmpkg-is-glob-4.0.1.tgz
https://registry.npmjs.org/is-map/-/is-map-2.0.2.tgz -> npmpkg-is-map-2.0.2.tgz
https://registry.npmjs.org/is-negative-zero/-/is-negative-zero-2.0.1.tgz -> npmpkg-is-negative-zero-2.0.1.tgz
https://registry.npmjs.org/is-number-object/-/is-number-object-1.0.4.tgz -> npmpkg-is-number-object-1.0.4.tgz
https://registry.npmjs.org/is-regex/-/is-regex-1.1.4.tgz -> npmpkg-is-regex-1.1.4.tgz
https://registry.npmjs.org/is-set/-/is-set-2.0.2.tgz -> npmpkg-is-set-2.0.2.tgz
https://registry.npmjs.org/is-shared-array-buffer/-/is-shared-array-buffer-1.0.1.tgz -> npmpkg-is-shared-array-buffer-1.0.1.tgz
https://registry.npmjs.org/is-stream/-/is-stream-2.0.0.tgz -> npmpkg-is-stream-2.0.0.tgz
https://registry.npmjs.org/is-string/-/is-string-1.0.7.tgz -> npmpkg-is-string-1.0.7.tgz
https://registry.npmjs.org/is-symbol/-/is-symbol-1.0.3.tgz -> npmpkg-is-symbol-1.0.3.tgz
https://registry.npmjs.org/is-typed-array/-/is-typed-array-1.1.4.tgz -> npmpkg-is-typed-array-1.1.4.tgz
https://registry.npmjs.org/is-typedarray/-/is-typedarray-1.0.0.tgz -> npmpkg-is-typedarray-1.0.0.tgz
https://registry.npmjs.org/is-weakmap/-/is-weakmap-2.0.1.tgz -> npmpkg-is-weakmap-2.0.1.tgz
https://registry.npmjs.org/is-weakref/-/is-weakref-1.0.1.tgz -> npmpkg-is-weakref-1.0.1.tgz
https://registry.npmjs.org/is-weakset/-/is-weakset-2.0.1.tgz -> npmpkg-is-weakset-2.0.1.tgz
https://registry.npmjs.org/is-windows/-/is-windows-1.0.2.tgz -> npmpkg-is-windows-1.0.2.tgz
https://registry.npmjs.org/isarray/-/isarray-0.0.1.tgz -> npmpkg-isarray-0.0.1.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz -> npmpkg-isexe-2.0.0.tgz
https://registry.npmjs.org/istanbul-lib-coverage/-/istanbul-lib-coverage-3.0.0.tgz -> npmpkg-istanbul-lib-coverage-3.0.0.tgz
https://registry.npmjs.org/istanbul-lib-hook/-/istanbul-lib-hook-3.0.0.tgz -> npmpkg-istanbul-lib-hook-3.0.0.tgz
https://registry.npmjs.org/istanbul-lib-instrument/-/istanbul-lib-instrument-4.0.3.tgz -> npmpkg-istanbul-lib-instrument-4.0.3.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/istanbul-lib-processinfo/-/istanbul-lib-processinfo-2.0.2.tgz -> npmpkg-istanbul-lib-processinfo-2.0.2.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz -> npmpkg-cross-spawn-7.0.3.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz -> npmpkg-shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz -> npmpkg-shebang-regex-3.0.0.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/istanbul-lib-report/-/istanbul-lib-report-3.0.0.tgz -> npmpkg-istanbul-lib-report-3.0.0.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/istanbul-lib-source-maps/-/istanbul-lib-source-maps-4.0.0.tgz -> npmpkg-istanbul-lib-source-maps-4.0.0.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz -> npmpkg-source-map-0.6.1.tgz
https://registry.npmjs.org/istanbul-reports/-/istanbul-reports-3.0.2.tgz -> npmpkg-istanbul-reports-3.0.2.tgz
https://registry.npmjs.org/js-tokens/-/js-tokens-4.0.0.tgz -> npmpkg-js-tokens-4.0.0.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-3.14.1.tgz -> npmpkg-js-yaml-3.14.1.tgz
https://registry.npmjs.org/jsesc/-/jsesc-2.5.2.tgz -> npmpkg-jsesc-2.5.2.tgz
https://registry.npmjs.org/json-parse-better-errors/-/json-parse-better-errors-1.0.2.tgz -> npmpkg-json-parse-better-errors-1.0.2.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz -> npmpkg-json-schema-traverse-0.4.1.tgz
https://registry.npmjs.org/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz -> npmpkg-json-stable-stringify-without-jsonify-1.0.1.tgz
https://registry.npmjs.org/json5/-/json5-2.2.3.tgz -> npmpkg-json5-2.2.3.tgz
https://registry.npmjs.org/jsx-ast-utils/-/jsx-ast-utils-3.2.0.tgz -> npmpkg-jsx-ast-utils-3.2.0.tgz
https://registry.npmjs.org/just-extend/-/just-extend-4.1.1.tgz -> npmpkg-just-extend-4.1.1.tgz
https://registry.npmjs.org/levn/-/levn-0.4.1.tgz -> npmpkg-levn-0.4.1.tgz
https://registry.npmjs.org/load-json-file/-/load-json-file-4.0.0.tgz -> npmpkg-load-json-file-4.0.0.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-3.0.0.tgz -> npmpkg-strip-bom-3.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-5.0.0.tgz -> npmpkg-locate-path-5.0.0.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz -> npmpkg-lodash-4.17.21.tgz
https://registry.npmjs.org/lodash.clonedeep/-/lodash.clonedeep-4.5.0.tgz -> npmpkg-lodash.clonedeep-4.5.0.tgz
https://registry.npmjs.org/lodash.flattendeep/-/lodash.flattendeep-4.4.0.tgz -> npmpkg-lodash.flattendeep-4.4.0.tgz
https://registry.npmjs.org/lodash.get/-/lodash.get-4.4.2.tgz -> npmpkg-lodash.get-4.4.2.tgz
https://registry.npmjs.org/lodash.truncate/-/lodash.truncate-4.4.2.tgz -> npmpkg-lodash.truncate-4.4.2.tgz
https://registry.npmjs.org/loose-envify/-/loose-envify-1.4.0.tgz -> npmpkg-loose-envify-1.4.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-4.1.5.tgz -> npmpkg-lru-cache-4.1.5.tgz
https://registry.npmjs.org/make-dir/-/make-dir-3.1.0.tgz -> npmpkg-make-dir-3.1.0.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz -> npmpkg-minimatch-3.1.2.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.8.tgz -> npmpkg-minimist-1.2.8.tgz
https://registry.npmjs.org/ms/-/ms-2.1.2.tgz -> npmpkg-ms-2.1.2.tgz
https://registry.npmjs.org/natural-compare/-/natural-compare-1.4.0.tgz -> npmpkg-natural-compare-1.4.0.tgz
https://registry.npmjs.org/nise/-/nise-4.1.0.tgz -> npmpkg-nise-4.1.0.tgz
https://registry.npmjs.org/nmtree/-/nmtree-1.0.6.tgz -> npmpkg-nmtree-1.0.6.tgz
https://registry.npmjs.org/commander/-/commander-2.20.3.tgz -> npmpkg-commander-2.20.3.tgz
https://registry.npmjs.org/node-preload/-/node-preload-0.2.1.tgz -> npmpkg-node-preload-0.2.1.tgz
https://registry.npmjs.org/normalize-package-data/-/normalize-package-data-2.5.0.tgz -> npmpkg-normalize-package-data-2.5.0.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz -> npmpkg-semver-5.7.2.tgz
https://registry.npmjs.org/nyc/-/nyc-15.1.0.tgz -> npmpkg-nyc-15.1.0.tgz
https://registry.npmjs.org/object-assign/-/object-assign-4.1.1.tgz -> npmpkg-object-assign-4.1.1.tgz
https://registry.npmjs.org/object-inspect/-/object-inspect-1.12.0.tgz -> npmpkg-object-inspect-1.12.0.tgz
https://registry.npmjs.org/object-is/-/object-is-1.1.5.tgz -> npmpkg-object-is-1.1.5.tgz
https://registry.npmjs.org/object-keys/-/object-keys-1.1.1.tgz -> npmpkg-object-keys-1.1.1.tgz
https://registry.npmjs.org/object.assign/-/object.assign-4.1.2.tgz -> npmpkg-object.assign-4.1.2.tgz
https://registry.npmjs.org/object.entries/-/object.entries-1.1.5.tgz -> npmpkg-object.entries-1.1.5.tgz
https://registry.npmjs.org/object.fromentries/-/object.fromentries-2.0.5.tgz -> npmpkg-object.fromentries-2.0.5.tgz
https://registry.npmjs.org/object.hasown/-/object.hasown-1.1.0.tgz -> npmpkg-object.hasown-1.1.0.tgz
https://registry.npmjs.org/object.values/-/object.values-1.1.5.tgz -> npmpkg-object.values-1.1.5.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz -> npmpkg-once-1.4.0.tgz
https://registry.npmjs.org/optionator/-/optionator-0.9.1.tgz -> npmpkg-optionator-0.9.1.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz -> npmpkg-p-limit-2.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-4.1.0.tgz -> npmpkg-p-locate-4.1.0.tgz
https://registry.npmjs.org/p-map/-/p-map-3.0.0.tgz -> npmpkg-p-map-3.0.0.tgz
https://registry.npmjs.org/p-try/-/p-try-2.2.0.tgz -> npmpkg-p-try-2.2.0.tgz
https://registry.npmjs.org/package-hash/-/package-hash-4.0.0.tgz -> npmpkg-package-hash-4.0.0.tgz
https://registry.npmjs.org/parent-module/-/parent-module-1.0.1.tgz -> npmpkg-parent-module-1.0.1.tgz
https://registry.npmjs.org/parse-json/-/parse-json-4.0.0.tgz -> npmpkg-parse-json-4.0.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-4.0.0.tgz -> npmpkg-path-exists-4.0.0.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> npmpkg-path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz -> npmpkg-path-key-3.1.1.tgz
https://registry.npmjs.org/path-parse/-/path-parse-1.0.7.tgz -> npmpkg-path-parse-1.0.7.tgz
https://registry.npmjs.org/path-to-regexp/-/path-to-regexp-1.8.0.tgz -> npmpkg-path-to-regexp-1.8.0.tgz
https://registry.npmjs.org/path-type/-/path-type-3.0.0.tgz -> npmpkg-path-type-3.0.0.tgz
https://registry.npmjs.org/pify/-/pify-3.0.0.tgz -> npmpkg-pify-3.0.0.tgz
https://registry.npmjs.org/pkg-conf/-/pkg-conf-3.1.0.tgz -> npmpkg-pkg-conf-3.1.0.tgz
https://registry.npmjs.org/find-up/-/find-up-3.0.0.tgz -> npmpkg-find-up-3.0.0.tgz
https://registry.npmjs.org/load-json-file/-/load-json-file-5.3.0.tgz -> npmpkg-load-json-file-5.3.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-3.0.0.tgz -> npmpkg-locate-path-3.0.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-3.0.0.tgz -> npmpkg-p-locate-3.0.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-3.0.0.tgz -> npmpkg-path-exists-3.0.0.tgz
https://registry.npmjs.org/pify/-/pify-4.0.1.tgz -> npmpkg-pify-4.0.1.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-3.0.0.tgz -> npmpkg-strip-bom-3.0.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.3.1.tgz -> npmpkg-type-fest-0.3.1.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-4.2.0.tgz -> npmpkg-pkg-dir-4.2.0.tgz
https://registry.npmjs.org/pkg-up/-/pkg-up-2.0.0.tgz -> npmpkg-pkg-up-2.0.0.tgz
https://registry.npmjs.org/find-up/-/find-up-2.1.0.tgz -> npmpkg-find-up-2.1.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-2.0.0.tgz -> npmpkg-locate-path-2.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-1.3.0.tgz -> npmpkg-p-limit-1.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-2.0.0.tgz -> npmpkg-p-locate-2.0.0.tgz
https://registry.npmjs.org/p-try/-/p-try-1.0.0.tgz -> npmpkg-p-try-1.0.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-3.0.0.tgz -> npmpkg-path-exists-3.0.0.tgz
https://registry.npmjs.org/prelude-ls/-/prelude-ls-1.2.1.tgz -> npmpkg-prelude-ls-1.2.1.tgz
https://registry.npmjs.org/process-on-spawn/-/process-on-spawn-1.0.0.tgz -> npmpkg-process-on-spawn-1.0.0.tgz
https://registry.npmjs.org/progress/-/progress-2.0.3.tgz -> npmpkg-progress-2.0.3.tgz
https://registry.npmjs.org/prop-types/-/prop-types-15.7.2.tgz -> npmpkg-prop-types-15.7.2.tgz
https://registry.npmjs.org/pseudomap/-/pseudomap-1.0.2.tgz -> npmpkg-pseudomap-1.0.2.tgz
https://registry.npmjs.org/punycode/-/punycode-2.1.1.tgz -> npmpkg-punycode-2.1.1.tgz
https://registry.npmjs.org/react-is/-/react-is-16.13.1.tgz -> npmpkg-react-is-16.13.1.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-3.0.0.tgz -> npmpkg-read-pkg-3.0.0.tgz
https://registry.npmjs.org/read-pkg-up/-/read-pkg-up-3.0.0.tgz -> npmpkg-read-pkg-up-3.0.0.tgz
https://registry.npmjs.org/find-up/-/find-up-2.1.0.tgz -> npmpkg-find-up-2.1.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-2.0.0.tgz -> npmpkg-locate-path-2.0.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-1.3.0.tgz -> npmpkg-p-limit-1.3.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-2.0.0.tgz -> npmpkg-p-locate-2.0.0.tgz
https://registry.npmjs.org/p-try/-/p-try-1.0.0.tgz -> npmpkg-p-try-1.0.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-3.0.0.tgz -> npmpkg-path-exists-3.0.0.tgz
https://registry.npmjs.org/regexp.prototype.flags/-/regexp.prototype.flags-1.3.1.tgz -> npmpkg-regexp.prototype.flags-1.3.1.tgz
https://registry.npmjs.org/regexpp/-/regexpp-3.1.0.tgz -> npmpkg-regexpp-3.1.0.tgz
https://registry.npmjs.org/release-zalgo/-/release-zalgo-1.0.0.tgz -> npmpkg-release-zalgo-1.0.0.tgz
https://registry.npmjs.org/require-directory/-/require-directory-2.1.1.tgz -> npmpkg-require-directory-2.1.1.tgz
https://registry.npmjs.org/require-from-string/-/require-from-string-2.0.2.tgz -> npmpkg-require-from-string-2.0.2.tgz
https://registry.npmjs.org/require-main-filename/-/require-main-filename-2.0.0.tgz -> npmpkg-require-main-filename-2.0.0.tgz
https://registry.npmjs.org/resolve/-/resolve-1.20.0.tgz -> npmpkg-resolve-1.20.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-5.0.0.tgz -> npmpkg-resolve-from-5.0.0.tgz
https://registry.npmjs.org/resumer/-/resumer-0.0.0.tgz -> npmpkg-resumer-0.0.0.tgz
https://registry.npmjs.org/rimraf/-/rimraf-3.0.2.tgz -> npmpkg-rimraf-3.0.2.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz -> npmpkg-safe-buffer-5.1.2.tgz
https://registry.npmjs.org/semver/-/semver-7.5.4.tgz -> npmpkg-semver-7.5.4.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz -> npmpkg-lru-cache-6.0.0.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz -> npmpkg-yallist-4.0.0.tgz
https://registry.npmjs.org/set-blocking/-/set-blocking-2.0.0.tgz -> npmpkg-set-blocking-2.0.0.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-1.2.0.tgz -> npmpkg-shebang-command-1.2.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-1.0.0.tgz -> npmpkg-shebang-regex-1.0.0.tgz
https://registry.npmjs.org/side-channel/-/side-channel-1.0.4.tgz -> npmpkg-side-channel-1.0.4.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-3.0.3.tgz -> npmpkg-signal-exit-3.0.3.tgz
https://registry.npmjs.org/sinon/-/sinon-9.2.4.tgz -> npmpkg-sinon-9.2.4.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz -> npmpkg-has-flag-4.0.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz -> npmpkg-supports-color-7.2.0.tgz
https://registry.npmjs.org/slice-ansi/-/slice-ansi-4.0.0.tgz -> npmpkg-slice-ansi-4.0.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/sort-object-keys/-/sort-object-keys-1.1.3.tgz -> npmpkg-sort-object-keys-1.1.3.tgz
https://registry.npmjs.org/source-map/-/source-map-0.5.7.tgz -> npmpkg-source-map-0.5.7.tgz
https://registry.npmjs.org/spawn-wrap/-/spawn-wrap-2.0.0.tgz -> npmpkg-spawn-wrap-2.0.0.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz -> npmpkg-which-2.0.2.tgz
https://registry.npmjs.org/spdx-correct/-/spdx-correct-3.1.1.tgz -> npmpkg-spdx-correct-3.1.1.tgz
https://registry.npmjs.org/spdx-exceptions/-/spdx-exceptions-2.3.0.tgz -> npmpkg-spdx-exceptions-2.3.0.tgz
https://registry.npmjs.org/spdx-expression-parse/-/spdx-expression-parse-3.0.1.tgz -> npmpkg-spdx-expression-parse-3.0.1.tgz
https://registry.npmjs.org/spdx-license-ids/-/spdx-license-ids-3.0.7.tgz -> npmpkg-spdx-license-ids-3.0.7.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.0.3.tgz -> npmpkg-sprintf-js-1.0.3.tgz
https://registry.npmjs.org/standard/-/standard-16.0.4.tgz -> npmpkg-standard-16.0.4.tgz
https://registry.npmjs.org/standard-engine/-/standard-engine-14.0.1.tgz -> npmpkg-standard-engine-14.0.1.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz -> npmpkg-string-width-4.2.3.tgz
https://registry.npmjs.org/string.prototype.matchall/-/string.prototype.matchall-4.0.6.tgz -> npmpkg-string.prototype.matchall-4.0.6.tgz
https://registry.npmjs.org/string.prototype.trim/-/string.prototype.trim-1.2.5.tgz -> npmpkg-string.prototype.trim-1.2.5.tgz
https://registry.npmjs.org/string.prototype.trimend/-/string.prototype.trimend-1.0.4.tgz -> npmpkg-string.prototype.trimend-1.0.4.tgz
https://registry.npmjs.org/string.prototype.trimstart/-/string.prototype.trimstart-1.0.4.tgz -> npmpkg-string.prototype.trimstart-1.0.4.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz -> npmpkg-strip-ansi-6.0.1.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-4.0.0.tgz -> npmpkg-strip-bom-4.0.0.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-3.1.1.tgz -> npmpkg-strip-json-comments-3.1.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz -> npmpkg-supports-color-5.5.0.tgz
https://registry.npmjs.org/table/-/table-6.7.2.tgz -> npmpkg-table-6.7.2.tgz
https://registry.npmjs.org/ajv/-/ajv-8.6.3.tgz -> npmpkg-ajv-8.6.3.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz -> npmpkg-json-schema-traverse-1.0.0.tgz
https://registry.npmjs.org/tape/-/tape-5.5.0.tgz -> npmpkg-tape-5.5.0.tgz
https://registry.npmjs.org/resolve/-/resolve-2.0.0-next.3.tgz -> npmpkg-resolve-2.0.0-next.3.tgz
https://registry.npmjs.org/test-exclude/-/test-exclude-6.0.0.tgz -> npmpkg-test-exclude-6.0.0.tgz
https://registry.npmjs.org/text-table/-/text-table-0.2.0.tgz -> npmpkg-text-table-0.2.0.tgz
https://registry.npmjs.org/through/-/through-2.3.8.tgz -> npmpkg-through-2.3.8.tgz
https://registry.npmjs.org/to-fast-properties/-/to-fast-properties-2.0.0.tgz -> npmpkg-to-fast-properties-2.0.0.tgz
https://registry.npmjs.org/tsconfig-paths/-/tsconfig-paths-3.11.0.tgz -> npmpkg-tsconfig-paths-3.11.0.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz -> npmpkg-json5-1.0.2.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-3.0.0.tgz -> npmpkg-strip-bom-3.0.0.tgz
https://registry.npmjs.org/type-check/-/type-check-0.4.0.tgz -> npmpkg-type-check-0.4.0.tgz
https://registry.npmjs.org/type-detect/-/type-detect-4.0.8.tgz -> npmpkg-type-detect-4.0.8.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.8.1.tgz -> npmpkg-type-fest-0.8.1.tgz
https://registry.npmjs.org/typedarray-to-buffer/-/typedarray-to-buffer-3.1.5.tgz -> npmpkg-typedarray-to-buffer-3.1.5.tgz
https://registry.npmjs.org/unbox-primitive/-/unbox-primitive-1.0.1.tgz -> npmpkg-unbox-primitive-1.0.1.tgz
https://registry.npmjs.org/uri-js/-/uri-js-4.4.1.tgz -> npmpkg-uri-js-4.4.1.tgz
https://registry.npmjs.org/uuid/-/uuid-3.4.0.tgz -> npmpkg-uuid-3.4.0.tgz
https://registry.npmjs.org/v8-compile-cache/-/v8-compile-cache-2.2.0.tgz -> npmpkg-v8-compile-cache-2.2.0.tgz
https://registry.npmjs.org/validate-npm-package-license/-/validate-npm-package-license-3.0.4.tgz -> npmpkg-validate-npm-package-license-3.0.4.tgz
https://registry.npmjs.org/which/-/which-1.3.1.tgz -> npmpkg-which-1.3.1.tgz
https://registry.npmjs.org/which-boxed-primitive/-/which-boxed-primitive-1.0.2.tgz -> npmpkg-which-boxed-primitive-1.0.2.tgz
https://registry.npmjs.org/which-collection/-/which-collection-1.0.1.tgz -> npmpkg-which-collection-1.0.1.tgz
https://registry.npmjs.org/which-module/-/which-module-2.0.0.tgz -> npmpkg-which-module-2.0.0.tgz
https://registry.npmjs.org/which-typed-array/-/which-typed-array-1.1.4.tgz -> npmpkg-which-typed-array-1.1.4.tgz
https://registry.npmjs.org/word-wrap/-/word-wrap-1.2.5.tgz -> npmpkg-word-wrap-1.2.5.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-6.2.0.tgz -> npmpkg-wrap-ansi-6.2.0.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz -> npmpkg-ansi-styles-4.3.0.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz -> npmpkg-color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz -> npmpkg-color-name-1.1.4.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz -> npmpkg-wrappy-1.0.2.tgz
https://registry.npmjs.org/write-file-atomic/-/write-file-atomic-3.0.3.tgz -> npmpkg-write-file-atomic-3.0.3.tgz
https://registry.npmjs.org/xdg-basedir/-/xdg-basedir-4.0.0.tgz -> npmpkg-xdg-basedir-4.0.0.tgz
https://registry.npmjs.org/y18n/-/y18n-4.0.1.tgz -> npmpkg-y18n-4.0.1.tgz
https://registry.npmjs.org/yallist/-/yallist-2.1.2.tgz -> npmpkg-yallist-2.1.2.tgz
https://registry.npmjs.org/yargs/-/yargs-15.4.1.tgz -> npmpkg-yargs-15.4.1.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-18.1.3.tgz -> npmpkg-yargs-parser-18.1.3.tgz
"
# UPDATER_END_NPM_EXTERNAL_URIS
SRC_URI="
${NPM_EXTERNAL_URIS}
https://github.com/imsnif/synp/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
