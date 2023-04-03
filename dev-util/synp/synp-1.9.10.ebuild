# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

YARN_INSTALL_PATH="/opt/${PN}"
YARN_EXE_LIST="
${YARN_INSTALL_PATH}/cli/synp.js
${YARN_INSTALL_PATH}/cli/write-output.js
${YARN_INSTALL_PATH}/cli/validate-path.js
${YARN_INSTALL_PATH}/cli/validate-args.js
${YARN_INSTALL_PATH}/cli/run.js
${YARN_INSTALL_PATH}/node_modules/.bin/acorn
${YARN_INSTALL_PATH}/node_modules/.bin/eslint
${YARN_INSTALL_PATH}/node_modules/.bin/esparse
${YARN_INSTALL_PATH}/node_modules/.bin/esvalidate
${YARN_INSTALL_PATH}/node_modules/.bin/ignored
${YARN_INSTALL_PATH}/node_modules/.bin/js-yaml
${YARN_INSTALL_PATH}/node_modules/.bin/jsesc
${YARN_INSTALL_PATH}/node_modules/.bin/json5
${YARN_INSTALL_PATH}/node_modules/.bin/loose-envify
${YARN_INSTALL_PATH}/node_modules/.bin/nmtree
${YARN_INSTALL_PATH}/node_modules/.bin/nyc
${YARN_INSTALL_PATH}/node_modules/.bin/parser
${YARN_INSTALL_PATH}/node_modules/.bin/rimraf
${YARN_INSTALL_PATH}/node_modules/.bin/semver
${YARN_INSTALL_PATH}/node_modules/.bin/standard
${YARN_INSTALL_PATH}/node_modules/.bin/tape
${YARN_INSTALL_PATH}/node_modules/.bin/uuid
${YARN_INSTALL_PATH}/node_modules/.bin/which
${YARN_INSTALL_PATH}/node_modules/@babel/core/node_modules/.bin/json5
${YARN_INSTALL_PATH}/node_modules/@babel/core/node_modules/.bin/parser
${YARN_INSTALL_PATH}/node_modules/@babel/core/node_modules/.bin/semver
${YARN_INSTALL_PATH}/node_modules/@babel/generator/node_modules/.bin/jsesc
${YARN_INSTALL_PATH}/node_modules/@babel/template/node_modules/.bin/parser
${YARN_INSTALL_PATH}/node_modules/@babel/traverse/node_modules/.bin/parser
${YARN_INSTALL_PATH}/node_modules/@eslint/eslintrc/node_modules/.bin/js-yaml
${YARN_INSTALL_PATH}/node_modules/@istanbuljs/load-nyc-config/node_modules/.bin/js-yaml
${YARN_INSTALL_PATH}/node_modules/acorn-jsx/node_modules/.bin/acorn
${YARN_INSTALL_PATH}/node_modules/bash-glob/node_modules/cross-spawn/node_modules/.bin/which
${YARN_INSTALL_PATH}/node_modules/cross-spawn/node_modules/.bin/node-which
${YARN_INSTALL_PATH}/node_modules/eslint-config-standard-jsx/node_modules/.bin/eslint
${YARN_INSTALL_PATH}/node_modules/eslint-config-standard/node_modules/.bin/eslint
${YARN_INSTALL_PATH}/node_modules/eslint-plugin-es/node_modules/.bin/eslint
${YARN_INSTALL_PATH}/node_modules/eslint-plugin-import/node_modules/.bin/eslint
${YARN_INSTALL_PATH}/node_modules/eslint-plugin-node/node_modules/.bin/eslint
${YARN_INSTALL_PATH}/node_modules/eslint-plugin-node/node_modules/.bin/semver
${YARN_INSTALL_PATH}/node_modules/eslint-plugin-promise/node_modules/.bin/eslint
${YARN_INSTALL_PATH}/node_modules/eslint-plugin-react/node_modules/.bin/eslint
${YARN_INSTALL_PATH}/node_modules/eslint/node_modules/.bin/js-yaml
${YARN_INSTALL_PATH}/node_modules/eslint/node_modules/.bin/semver
${YARN_INSTALL_PATH}/node_modules/espree/node_modules/.bin/acorn
${YARN_INSTALL_PATH}/node_modules/flat-cache/node_modules/.bin/rimraf
${YARN_INSTALL_PATH}/node_modules/istanbul-lib-instrument/node_modules/.bin/semver
${YARN_INSTALL_PATH}/node_modules/istanbul-lib-processinfo/node_modules/.bin/rimraf
${YARN_INSTALL_PATH}/node_modules/istanbul-lib-processinfo/node_modules/.bin/uuid
${YARN_INSTALL_PATH}/node_modules/js-yaml/node_modules/.bin/esparse
${YARN_INSTALL_PATH}/node_modules/js-yaml/node_modules/.bin/esvalidate
${YARN_INSTALL_PATH}/node_modules/make-dir/node_modules/.bin/semver
${YARN_INSTALL_PATH}/node_modules/normalize-package-data/node_modules/.bin/semver
${YARN_INSTALL_PATH}/node_modules/nyc/node_modules/.bin/rimraf
${YARN_INSTALL_PATH}/node_modules/prop-types/node_modules/.bin/loose-envify
${YARN_INSTALL_PATH}/node_modules/spawn-wrap/node_modules/.bin/node-which
${YARN_INSTALL_PATH}/node_modules/spawn-wrap/node_modules/.bin/rimraf
${YARN_INSTALL_PATH}/node_modules/standard/node_modules/.bin/eslint
${YARN_INSTALL_PATH}/node_modules/tape/node_modules/.bin/ignored
${YARN_INSTALL_PATH}/node_modules/tsconfig-paths/node_modules/.bin/json5
"
YARN_TEST_SCRIPT="test"
inherit yarn

DESCRIPTION="Convert yarn.lock to package-lock.json and vice versa"
HOMEPAGE="https://github.com/imsnif/synp"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
DEPEND+="
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	dev-util/yarn
"
# grep "resolved" /var/tmp/portage/dev-util/synp-1.9.10/work/synp-1.9.10/yarn.lock | cut -f 2 -d '"' | cut -f 1 -d "#" | sort | uniq
# UPDATER_START_YARN_EXTERNAL_URIS
YARN_EXTERNAL_URIS="
https://registry.yarnpkg.com/@babel/code-frame/-/code-frame-7.12.11.tgz -> yarnpkg-@babel-code-frame-7.12.11.tgz
https://registry.yarnpkg.com/@babel/core/-/core-7.12.10.tgz -> yarnpkg-@babel-core-7.12.10.tgz
https://registry.yarnpkg.com/@babel/generator/-/generator-7.12.11.tgz -> yarnpkg-@babel-generator-7.12.11.tgz
https://registry.yarnpkg.com/@babel/helper-function-name/-/helper-function-name-7.12.11.tgz -> yarnpkg-@babel-helper-function-name-7.12.11.tgz
https://registry.yarnpkg.com/@babel/helper-get-function-arity/-/helper-get-function-arity-7.12.10.tgz -> yarnpkg-@babel-helper-get-function-arity-7.12.10.tgz
https://registry.yarnpkg.com/@babel/helper-member-expression-to-functions/-/helper-member-expression-to-functions-7.12.7.tgz -> yarnpkg-@babel-helper-member-expression-to-functions-7.12.7.tgz
https://registry.yarnpkg.com/@babel/helper-module-imports/-/helper-module-imports-7.12.5.tgz -> yarnpkg-@babel-helper-module-imports-7.12.5.tgz
https://registry.yarnpkg.com/@babel/helper-module-transforms/-/helper-module-transforms-7.12.1.tgz -> yarnpkg-@babel-helper-module-transforms-7.12.1.tgz
https://registry.yarnpkg.com/@babel/helper-optimise-call-expression/-/helper-optimise-call-expression-7.12.10.tgz -> yarnpkg-@babel-helper-optimise-call-expression-7.12.10.tgz
https://registry.yarnpkg.com/@babel/helper-replace-supers/-/helper-replace-supers-7.12.11.tgz -> yarnpkg-@babel-helper-replace-supers-7.12.11.tgz
https://registry.yarnpkg.com/@babel/helper-simple-access/-/helper-simple-access-7.12.1.tgz -> yarnpkg-@babel-helper-simple-access-7.12.1.tgz
https://registry.yarnpkg.com/@babel/helper-split-export-declaration/-/helper-split-export-declaration-7.12.11.tgz -> yarnpkg-@babel-helper-split-export-declaration-7.12.11.tgz
https://registry.yarnpkg.com/@babel/helper-validator-identifier/-/helper-validator-identifier-7.12.11.tgz -> yarnpkg-@babel-helper-validator-identifier-7.12.11.tgz
https://registry.yarnpkg.com/@babel/helpers/-/helpers-7.12.5.tgz -> yarnpkg-@babel-helpers-7.12.5.tgz
https://registry.yarnpkg.com/@babel/highlight/-/highlight-7.10.4.tgz -> yarnpkg-@babel-highlight-7.10.4.tgz
https://registry.yarnpkg.com/@babel/parser/-/parser-7.12.11.tgz -> yarnpkg-@babel-parser-7.12.11.tgz
https://registry.yarnpkg.com/@babel/template/-/template-7.12.7.tgz -> yarnpkg-@babel-template-7.12.7.tgz
https://registry.yarnpkg.com/@babel/traverse/-/traverse-7.12.12.tgz -> yarnpkg-@babel-traverse-7.12.12.tgz
https://registry.yarnpkg.com/@babel/types/-/types-7.12.12.tgz -> yarnpkg-@babel-types-7.12.12.tgz
https://registry.yarnpkg.com/@eslint/eslintrc/-/eslintrc-0.3.0.tgz -> yarnpkg-@eslint-eslintrc-0.3.0.tgz
https://registry.yarnpkg.com/@istanbuljs/load-nyc-config/-/load-nyc-config-1.1.0.tgz -> yarnpkg-@istanbuljs-load-nyc-config-1.1.0.tgz
https://registry.yarnpkg.com/@istanbuljs/schema/-/schema-0.1.2.tgz -> yarnpkg-@istanbuljs-schema-0.1.2.tgz
https://registry.yarnpkg.com/@sinonjs/commons/-/commons-1.8.2.tgz -> yarnpkg-@sinonjs-commons-1.8.2.tgz
https://registry.yarnpkg.com/@sinonjs/commons/-/commons-1.8.3.tgz -> yarnpkg-@sinonjs-commons-1.8.3.tgz
https://registry.yarnpkg.com/@sinonjs/fake-timers/-/fake-timers-6.0.1.tgz -> yarnpkg-@sinonjs-fake-timers-6.0.1.tgz
https://registry.yarnpkg.com/@sinonjs/samsam/-/samsam-5.3.1.tgz -> yarnpkg-@sinonjs-samsam-5.3.1.tgz
https://registry.yarnpkg.com/@sinonjs/text-encoding/-/text-encoding-0.7.1.tgz -> yarnpkg-@sinonjs-text-encoding-0.7.1.tgz
https://registry.yarnpkg.com/@types/json5/-/json5-0.0.29.tgz -> yarnpkg-@types-json5-0.0.29.tgz
https://registry.yarnpkg.com/@yarnpkg/lockfile/-/lockfile-1.1.0.tgz -> yarnpkg-@yarnpkg-lockfile-1.1.0.tgz
https://registry.yarnpkg.com/acorn-jsx/-/acorn-jsx-5.3.1.tgz -> yarnpkg-acorn-jsx-5.3.1.tgz
https://registry.yarnpkg.com/acorn/-/acorn-7.4.1.tgz -> yarnpkg-acorn-7.4.1.tgz
https://registry.yarnpkg.com/aggregate-error/-/aggregate-error-3.1.0.tgz -> yarnpkg-aggregate-error-3.1.0.tgz
https://registry.yarnpkg.com/ajv/-/ajv-6.12.6.tgz -> yarnpkg-ajv-6.12.6.tgz
https://registry.yarnpkg.com/ajv/-/ajv-8.6.3.tgz -> yarnpkg-ajv-8.6.3.tgz
https://registry.yarnpkg.com/ansi-colors/-/ansi-colors-4.1.1.tgz -> yarnpkg-ansi-colors-4.1.1.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-5.0.1.tgz -> yarnpkg-ansi-regex-5.0.1.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-3.2.1.tgz -> yarnpkg-ansi-styles-3.2.1.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-4.3.0.tgz -> yarnpkg-ansi-styles-4.3.0.tgz
https://registry.yarnpkg.com/append-transform/-/append-transform-2.0.0.tgz -> yarnpkg-append-transform-2.0.0.tgz
https://registry.yarnpkg.com/archy/-/archy-1.0.0.tgz -> yarnpkg-archy-1.0.0.tgz
https://registry.yarnpkg.com/argparse/-/argparse-1.0.10.tgz -> yarnpkg-argparse-1.0.10.tgz
https://registry.yarnpkg.com/arr-union/-/arr-union-3.1.0.tgz -> yarnpkg-arr-union-3.1.0.tgz
https://registry.yarnpkg.com/array-filter/-/array-filter-1.0.0.tgz -> yarnpkg-array-filter-1.0.0.tgz
https://registry.yarnpkg.com/array-includes/-/array-includes-3.1.2.tgz -> yarnpkg-array-includes-3.1.2.tgz
https://registry.yarnpkg.com/array-includes/-/array-includes-3.1.4.tgz -> yarnpkg-array-includes-3.1.4.tgz
https://registry.yarnpkg.com/array.prototype.every/-/array.prototype.every-1.1.3.tgz -> yarnpkg-array.prototype.every-1.1.3.tgz
https://registry.yarnpkg.com/array.prototype.flat/-/array.prototype.flat-1.2.5.tgz -> yarnpkg-array.prototype.flat-1.2.5.tgz
https://registry.yarnpkg.com/array.prototype.flatmap/-/array.prototype.flatmap-1.2.5.tgz -> yarnpkg-array.prototype.flatmap-1.2.5.tgz
https://registry.yarnpkg.com/astral-regex/-/astral-regex-2.0.0.tgz -> yarnpkg-astral-regex-2.0.0.tgz
https://registry.yarnpkg.com/available-typed-arrays/-/available-typed-arrays-1.0.2.tgz -> yarnpkg-available-typed-arrays-1.0.2.tgz
https://registry.yarnpkg.com/balanced-match/-/balanced-match-1.0.0.tgz -> yarnpkg-balanced-match-1.0.0.tgz
https://registry.yarnpkg.com/bash-glob/-/bash-glob-2.0.0.tgz -> yarnpkg-bash-glob-2.0.0.tgz
https://registry.yarnpkg.com/bash-path/-/bash-path-1.0.3.tgz -> yarnpkg-bash-path-1.0.3.tgz
https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-1.1.11.tgz -> yarnpkg-brace-expansion-1.1.11.tgz
https://registry.yarnpkg.com/caching-transform/-/caching-transform-4.0.0.tgz -> yarnpkg-caching-transform-4.0.0.tgz
https://registry.yarnpkg.com/call-bind/-/call-bind-1.0.2.tgz -> yarnpkg-call-bind-1.0.2.tgz
https://registry.yarnpkg.com/callsites/-/callsites-3.1.0.tgz -> yarnpkg-callsites-3.1.0.tgz
https://registry.yarnpkg.com/camelcase/-/camelcase-5.3.1.tgz -> yarnpkg-camelcase-5.3.1.tgz
https://registry.yarnpkg.com/chalk/-/chalk-2.4.2.tgz -> yarnpkg-chalk-2.4.2.tgz
https://registry.yarnpkg.com/chalk/-/chalk-4.1.0.tgz -> yarnpkg-chalk-4.1.0.tgz
https://registry.yarnpkg.com/clean-stack/-/clean-stack-2.2.0.tgz -> yarnpkg-clean-stack-2.2.0.tgz
https://registry.yarnpkg.com/cliui/-/cliui-6.0.0.tgz -> yarnpkg-cliui-6.0.0.tgz
https://registry.yarnpkg.com/color-convert/-/color-convert-1.9.3.tgz -> yarnpkg-color-convert-1.9.3.tgz
https://registry.yarnpkg.com/color-convert/-/color-convert-2.0.1.tgz -> yarnpkg-color-convert-2.0.1.tgz
https://registry.yarnpkg.com/color-name/-/color-name-1.1.3.tgz -> yarnpkg-color-name-1.1.3.tgz
https://registry.yarnpkg.com/color-name/-/color-name-1.1.4.tgz -> yarnpkg-color-name-1.1.4.tgz
https://registry.yarnpkg.com/colors/-/colors-1.4.0.tgz -> yarnpkg-colors-1.4.0.tgz
https://registry.yarnpkg.com/commander/-/commander-2.20.3.tgz -> yarnpkg-commander-2.20.3.tgz
https://registry.yarnpkg.com/commander/-/commander-7.2.0.tgz -> yarnpkg-commander-7.2.0.tgz
https://registry.yarnpkg.com/commondir/-/commondir-1.0.1.tgz -> yarnpkg-commondir-1.0.1.tgz
https://registry.yarnpkg.com/component-emitter/-/component-emitter-1.3.0.tgz -> yarnpkg-component-emitter-1.3.0.tgz
https://registry.yarnpkg.com/concat-map/-/concat-map-0.0.1.tgz -> yarnpkg-concat-map-0.0.1.tgz
https://registry.yarnpkg.com/convert-source-map/-/convert-source-map-1.7.0.tgz -> yarnpkg-convert-source-map-1.7.0.tgz
https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-5.1.0.tgz -> yarnpkg-cross-spawn-5.1.0.tgz
https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-7.0.3.tgz -> yarnpkg-cross-spawn-7.0.3.tgz
https://registry.yarnpkg.com/debug/-/debug-2.6.9.tgz -> yarnpkg-debug-2.6.9.tgz
https://registry.yarnpkg.com/debug/-/debug-3.2.7.tgz -> yarnpkg-debug-3.2.7.tgz
https://registry.yarnpkg.com/debug/-/debug-4.3.1.tgz -> yarnpkg-debug-4.3.1.tgz
https://registry.yarnpkg.com/decamelize/-/decamelize-1.2.0.tgz -> yarnpkg-decamelize-1.2.0.tgz
https://registry.yarnpkg.com/deep-equal/-/deep-equal-2.0.5.tgz -> yarnpkg-deep-equal-2.0.5.tgz
https://registry.yarnpkg.com/deep-is/-/deep-is-0.1.3.tgz -> yarnpkg-deep-is-0.1.3.tgz
https://registry.yarnpkg.com/default-require-extensions/-/default-require-extensions-3.0.0.tgz -> yarnpkg-default-require-extensions-3.0.0.tgz
https://registry.yarnpkg.com/define-properties/-/define-properties-1.1.3.tgz -> yarnpkg-define-properties-1.1.3.tgz
https://registry.yarnpkg.com/defined/-/defined-1.0.0.tgz -> yarnpkg-defined-1.0.0.tgz
https://registry.yarnpkg.com/diff/-/diff-4.0.2.tgz -> yarnpkg-diff-4.0.2.tgz
https://registry.yarnpkg.com/doctrine/-/doctrine-2.1.0.tgz -> yarnpkg-doctrine-2.1.0.tgz
https://registry.yarnpkg.com/doctrine/-/doctrine-3.0.0.tgz -> yarnpkg-doctrine-3.0.0.tgz
https://registry.yarnpkg.com/dotignore/-/dotignore-0.1.2.tgz -> yarnpkg-dotignore-0.1.2.tgz
https://registry.yarnpkg.com/each-parallel-async/-/each-parallel-async-1.0.0.tgz -> yarnpkg-each-parallel-async-1.0.0.tgz
https://registry.yarnpkg.com/emoji-regex/-/emoji-regex-8.0.0.tgz -> yarnpkg-emoji-regex-8.0.0.tgz
https://registry.yarnpkg.com/enquirer/-/enquirer-2.3.6.tgz -> yarnpkg-enquirer-2.3.6.tgz
https://registry.yarnpkg.com/eol/-/eol-0.9.1.tgz -> yarnpkg-eol-0.9.1.tgz
https://registry.yarnpkg.com/error-ex/-/error-ex-1.3.2.tgz -> yarnpkg-error-ex-1.3.2.tgz
https://registry.yarnpkg.com/es-abstract/-/es-abstract-1.18.0-next.2.tgz -> yarnpkg-es-abstract-1.18.0-next.2.tgz
https://registry.yarnpkg.com/es-abstract/-/es-abstract-1.19.1.tgz -> yarnpkg-es-abstract-1.19.1.tgz
https://registry.yarnpkg.com/es-get-iterator/-/es-get-iterator-1.1.1.tgz -> yarnpkg-es-get-iterator-1.1.1.tgz
https://registry.yarnpkg.com/es-to-primitive/-/es-to-primitive-1.2.1.tgz -> yarnpkg-es-to-primitive-1.2.1.tgz
https://registry.yarnpkg.com/es6-error/-/es6-error-4.1.1.tgz -> yarnpkg-es6-error-4.1.1.tgz
https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> yarnpkg-escape-string-regexp-1.0.5.tgz
https://registry.yarnpkg.com/eslint-config-standard-jsx/-/eslint-config-standard-jsx-10.0.0.tgz -> yarnpkg-eslint-config-standard-jsx-10.0.0.tgz
https://registry.yarnpkg.com/eslint-config-standard/-/eslint-config-standard-16.0.3.tgz -> yarnpkg-eslint-config-standard-16.0.3.tgz
https://registry.yarnpkg.com/eslint-import-resolver-node/-/eslint-import-resolver-node-0.3.6.tgz -> yarnpkg-eslint-import-resolver-node-0.3.6.tgz
https://registry.yarnpkg.com/eslint-module-utils/-/eslint-module-utils-2.7.1.tgz -> yarnpkg-eslint-module-utils-2.7.1.tgz
https://registry.yarnpkg.com/eslint-plugin-es/-/eslint-plugin-es-3.0.1.tgz -> yarnpkg-eslint-plugin-es-3.0.1.tgz
https://registry.yarnpkg.com/eslint-plugin-import/-/eslint-plugin-import-2.24.2.tgz -> yarnpkg-eslint-plugin-import-2.24.2.tgz
https://registry.yarnpkg.com/eslint-plugin-node/-/eslint-plugin-node-11.1.0.tgz -> yarnpkg-eslint-plugin-node-11.1.0.tgz
https://registry.yarnpkg.com/eslint-plugin-promise/-/eslint-plugin-promise-5.1.1.tgz -> yarnpkg-eslint-plugin-promise-5.1.1.tgz
https://registry.yarnpkg.com/eslint-plugin-react/-/eslint-plugin-react-7.25.3.tgz -> yarnpkg-eslint-plugin-react-7.25.3.tgz
https://registry.yarnpkg.com/eslint-scope/-/eslint-scope-5.1.1.tgz -> yarnpkg-eslint-scope-5.1.1.tgz
https://registry.yarnpkg.com/eslint-utils/-/eslint-utils-2.1.0.tgz -> yarnpkg-eslint-utils-2.1.0.tgz
https://registry.yarnpkg.com/eslint-visitor-keys/-/eslint-visitor-keys-1.3.0.tgz -> yarnpkg-eslint-visitor-keys-1.3.0.tgz
https://registry.yarnpkg.com/eslint-visitor-keys/-/eslint-visitor-keys-2.0.0.tgz -> yarnpkg-eslint-visitor-keys-2.0.0.tgz
https://registry.yarnpkg.com/eslint/-/eslint-7.18.0.tgz -> yarnpkg-eslint-7.18.0.tgz
https://registry.yarnpkg.com/espree/-/espree-7.3.1.tgz -> yarnpkg-espree-7.3.1.tgz
https://registry.yarnpkg.com/esprima/-/esprima-4.0.1.tgz -> yarnpkg-esprima-4.0.1.tgz
https://registry.yarnpkg.com/esquery/-/esquery-1.3.1.tgz -> yarnpkg-esquery-1.3.1.tgz
https://registry.yarnpkg.com/esrecurse/-/esrecurse-4.3.0.tgz -> yarnpkg-esrecurse-4.3.0.tgz
https://registry.yarnpkg.com/estraverse/-/estraverse-4.3.0.tgz -> yarnpkg-estraverse-4.3.0.tgz
https://registry.yarnpkg.com/estraverse/-/estraverse-5.2.0.tgz -> yarnpkg-estraverse-5.2.0.tgz
https://registry.yarnpkg.com/esutils/-/esutils-2.0.3.tgz -> yarnpkg-esutils-2.0.3.tgz
https://registry.yarnpkg.com/extend-shallow/-/extend-shallow-2.0.1.tgz -> yarnpkg-extend-shallow-2.0.1.tgz
https://registry.yarnpkg.com/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz -> yarnpkg-fast-deep-equal-3.1.3.tgz
https://registry.yarnpkg.com/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz -> yarnpkg-fast-json-stable-stringify-2.1.0.tgz
https://registry.yarnpkg.com/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz -> yarnpkg-fast-levenshtein-2.0.6.tgz
https://registry.yarnpkg.com/file-entry-cache/-/file-entry-cache-6.0.1.tgz -> yarnpkg-file-entry-cache-6.0.1.tgz
https://registry.yarnpkg.com/find-cache-dir/-/find-cache-dir-3.3.1.tgz -> yarnpkg-find-cache-dir-3.3.1.tgz
https://registry.yarnpkg.com/find-up/-/find-up-2.1.0.tgz -> yarnpkg-find-up-2.1.0.tgz
https://registry.yarnpkg.com/find-up/-/find-up-3.0.0.tgz -> yarnpkg-find-up-3.0.0.tgz
https://registry.yarnpkg.com/find-up/-/find-up-4.1.0.tgz -> yarnpkg-find-up-4.1.0.tgz
https://registry.yarnpkg.com/flat-cache/-/flat-cache-3.0.4.tgz -> yarnpkg-flat-cache-3.0.4.tgz
https://registry.yarnpkg.com/flatted/-/flatted-3.2.2.tgz -> yarnpkg-flatted-3.2.2.tgz
https://registry.yarnpkg.com/for-each/-/for-each-0.3.3.tgz -> yarnpkg-for-each-0.3.3.tgz
https://registry.yarnpkg.com/foreach/-/foreach-2.0.5.tgz -> yarnpkg-foreach-2.0.5.tgz
https://registry.yarnpkg.com/foreground-child/-/foreground-child-2.0.0.tgz -> yarnpkg-foreground-child-2.0.0.tgz
https://registry.yarnpkg.com/fromentries/-/fromentries-1.3.2.tgz -> yarnpkg-fromentries-1.3.2.tgz
https://registry.yarnpkg.com/fs.realpath/-/fs.realpath-1.0.0.tgz -> yarnpkg-fs.realpath-1.0.0.tgz
https://registry.yarnpkg.com/function-bind/-/function-bind-1.1.1.tgz -> yarnpkg-function-bind-1.1.1.tgz
https://registry.yarnpkg.com/functional-red-black-tree/-/functional-red-black-tree-1.0.1.tgz -> yarnpkg-functional-red-black-tree-1.0.1.tgz
https://registry.yarnpkg.com/gensync/-/gensync-1.0.0-beta.2.tgz -> yarnpkg-gensync-1.0.0-beta.2.tgz
https://registry.yarnpkg.com/get-caller-file/-/get-caller-file-2.0.5.tgz -> yarnpkg-get-caller-file-2.0.5.tgz
https://registry.yarnpkg.com/get-intrinsic/-/get-intrinsic-1.1.0.tgz -> yarnpkg-get-intrinsic-1.1.0.tgz
https://registry.yarnpkg.com/get-intrinsic/-/get-intrinsic-1.1.1.tgz -> yarnpkg-get-intrinsic-1.1.1.tgz
https://registry.yarnpkg.com/get-package-type/-/get-package-type-0.1.0.tgz -> yarnpkg-get-package-type-0.1.0.tgz
https://registry.yarnpkg.com/get-stdin/-/get-stdin-8.0.0.tgz -> yarnpkg-get-stdin-8.0.0.tgz
https://registry.yarnpkg.com/get-symbol-description/-/get-symbol-description-1.0.0.tgz -> yarnpkg-get-symbol-description-1.0.0.tgz
https://registry.yarnpkg.com/glob-parent/-/glob-parent-5.1.2.tgz -> yarnpkg-glob-parent-5.1.2.tgz
https://registry.yarnpkg.com/glob/-/glob-7.1.6.tgz -> yarnpkg-glob-7.1.6.tgz
https://registry.yarnpkg.com/glob/-/glob-7.2.0.tgz -> yarnpkg-glob-7.2.0.tgz
https://registry.yarnpkg.com/globals/-/globals-11.12.0.tgz -> yarnpkg-globals-11.12.0.tgz
https://registry.yarnpkg.com/globals/-/globals-12.4.0.tgz -> yarnpkg-globals-12.4.0.tgz
https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-4.2.4.tgz -> yarnpkg-graceful-fs-4.2.4.tgz
https://registry.yarnpkg.com/has-bigints/-/has-bigints-1.0.1.tgz -> yarnpkg-has-bigints-1.0.1.tgz
https://registry.yarnpkg.com/has-dynamic-import/-/has-dynamic-import-2.0.1.tgz -> yarnpkg-has-dynamic-import-2.0.1.tgz
https://registry.yarnpkg.com/has-flag/-/has-flag-3.0.0.tgz -> yarnpkg-has-flag-3.0.0.tgz
https://registry.yarnpkg.com/has-flag/-/has-flag-4.0.0.tgz -> yarnpkg-has-flag-4.0.0.tgz
https://registry.yarnpkg.com/has-symbols/-/has-symbols-1.0.1.tgz -> yarnpkg-has-symbols-1.0.1.tgz
https://registry.yarnpkg.com/has-symbols/-/has-symbols-1.0.2.tgz -> yarnpkg-has-symbols-1.0.2.tgz
https://registry.yarnpkg.com/has-tostringtag/-/has-tostringtag-1.0.0.tgz -> yarnpkg-has-tostringtag-1.0.0.tgz
https://registry.yarnpkg.com/has/-/has-1.0.3.tgz -> yarnpkg-has-1.0.3.tgz
https://registry.yarnpkg.com/hasha/-/hasha-5.2.2.tgz -> yarnpkg-hasha-5.2.2.tgz
https://registry.yarnpkg.com/hosted-git-info/-/hosted-git-info-2.8.9.tgz -> yarnpkg-hosted-git-info-2.8.9.tgz
https://registry.yarnpkg.com/html-escaper/-/html-escaper-2.0.2.tgz -> yarnpkg-html-escaper-2.0.2.tgz
https://registry.yarnpkg.com/ignore/-/ignore-4.0.6.tgz -> yarnpkg-ignore-4.0.6.tgz
https://registry.yarnpkg.com/ignore/-/ignore-5.1.8.tgz -> yarnpkg-ignore-5.1.8.tgz
https://registry.yarnpkg.com/import-fresh/-/import-fresh-3.3.0.tgz -> yarnpkg-import-fresh-3.3.0.tgz
https://registry.yarnpkg.com/imurmurhash/-/imurmurhash-0.1.4.tgz -> yarnpkg-imurmurhash-0.1.4.tgz
https://registry.yarnpkg.com/indent-string/-/indent-string-4.0.0.tgz -> yarnpkg-indent-string-4.0.0.tgz
https://registry.yarnpkg.com/inflight/-/inflight-1.0.6.tgz -> yarnpkg-inflight-1.0.6.tgz
https://registry.yarnpkg.com/inherits/-/inherits-2.0.4.tgz -> yarnpkg-inherits-2.0.4.tgz
https://registry.yarnpkg.com/internal-slot/-/internal-slot-1.0.3.tgz -> yarnpkg-internal-slot-1.0.3.tgz
https://registry.yarnpkg.com/is-arguments/-/is-arguments-1.1.0.tgz -> yarnpkg-is-arguments-1.1.0.tgz
https://registry.yarnpkg.com/is-arrayish/-/is-arrayish-0.2.1.tgz -> yarnpkg-is-arrayish-0.2.1.tgz
https://registry.yarnpkg.com/is-bigint/-/is-bigint-1.0.1.tgz -> yarnpkg-is-bigint-1.0.1.tgz
https://registry.yarnpkg.com/is-boolean-object/-/is-boolean-object-1.1.0.tgz -> yarnpkg-is-boolean-object-1.1.0.tgz
https://registry.yarnpkg.com/is-callable/-/is-callable-1.2.2.tgz -> yarnpkg-is-callable-1.2.2.tgz
https://registry.yarnpkg.com/is-callable/-/is-callable-1.2.4.tgz -> yarnpkg-is-callable-1.2.4.tgz
https://registry.yarnpkg.com/is-core-module/-/is-core-module-2.2.0.tgz -> yarnpkg-is-core-module-2.2.0.tgz
https://registry.yarnpkg.com/is-core-module/-/is-core-module-2.8.0.tgz -> yarnpkg-is-core-module-2.8.0.tgz
https://registry.yarnpkg.com/is-date-object/-/is-date-object-1.0.2.tgz -> yarnpkg-is-date-object-1.0.2.tgz
https://registry.yarnpkg.com/is-extendable/-/is-extendable-0.1.1.tgz -> yarnpkg-is-extendable-0.1.1.tgz
https://registry.yarnpkg.com/is-extglob/-/is-extglob-2.1.1.tgz -> yarnpkg-is-extglob-2.1.1.tgz
https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> yarnpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.yarnpkg.com/is-glob/-/is-glob-4.0.1.tgz -> yarnpkg-is-glob-4.0.1.tgz
https://registry.yarnpkg.com/is-map/-/is-map-2.0.2.tgz -> yarnpkg-is-map-2.0.2.tgz
https://registry.yarnpkg.com/is-negative-zero/-/is-negative-zero-2.0.1.tgz -> yarnpkg-is-negative-zero-2.0.1.tgz
https://registry.yarnpkg.com/is-number-object/-/is-number-object-1.0.4.tgz -> yarnpkg-is-number-object-1.0.4.tgz
https://registry.yarnpkg.com/is-regex/-/is-regex-1.1.1.tgz -> yarnpkg-is-regex-1.1.1.tgz
https://registry.yarnpkg.com/is-regex/-/is-regex-1.1.4.tgz -> yarnpkg-is-regex-1.1.4.tgz
https://registry.yarnpkg.com/is-set/-/is-set-2.0.2.tgz -> yarnpkg-is-set-2.0.2.tgz
https://registry.yarnpkg.com/is-shared-array-buffer/-/is-shared-array-buffer-1.0.1.tgz -> yarnpkg-is-shared-array-buffer-1.0.1.tgz
https://registry.yarnpkg.com/is-stream/-/is-stream-2.0.0.tgz -> yarnpkg-is-stream-2.0.0.tgz
https://registry.yarnpkg.com/is-string/-/is-string-1.0.5.tgz -> yarnpkg-is-string-1.0.5.tgz
https://registry.yarnpkg.com/is-string/-/is-string-1.0.7.tgz -> yarnpkg-is-string-1.0.7.tgz
https://registry.yarnpkg.com/is-symbol/-/is-symbol-1.0.3.tgz -> yarnpkg-is-symbol-1.0.3.tgz
https://registry.yarnpkg.com/is-typed-array/-/is-typed-array-1.1.4.tgz -> yarnpkg-is-typed-array-1.1.4.tgz
https://registry.yarnpkg.com/is-typedarray/-/is-typedarray-1.0.0.tgz -> yarnpkg-is-typedarray-1.0.0.tgz
https://registry.yarnpkg.com/is-weakmap/-/is-weakmap-2.0.1.tgz -> yarnpkg-is-weakmap-2.0.1.tgz
https://registry.yarnpkg.com/is-weakref/-/is-weakref-1.0.1.tgz -> yarnpkg-is-weakref-1.0.1.tgz
https://registry.yarnpkg.com/is-weakset/-/is-weakset-2.0.1.tgz -> yarnpkg-is-weakset-2.0.1.tgz
https://registry.yarnpkg.com/is-windows/-/is-windows-1.0.2.tgz -> yarnpkg-is-windows-1.0.2.tgz
https://registry.yarnpkg.com/isarray/-/isarray-0.0.1.tgz -> yarnpkg-isarray-0.0.1.tgz
https://registry.yarnpkg.com/isarray/-/isarray-2.0.5.tgz -> yarnpkg-isarray-2.0.5.tgz
https://registry.yarnpkg.com/isexe/-/isexe-2.0.0.tgz -> yarnpkg-isexe-2.0.0.tgz
https://registry.yarnpkg.com/istanbul-lib-coverage/-/istanbul-lib-coverage-3.0.0.tgz -> yarnpkg-istanbul-lib-coverage-3.0.0.tgz
https://registry.yarnpkg.com/istanbul-lib-hook/-/istanbul-lib-hook-3.0.0.tgz -> yarnpkg-istanbul-lib-hook-3.0.0.tgz
https://registry.yarnpkg.com/istanbul-lib-instrument/-/istanbul-lib-instrument-4.0.3.tgz -> yarnpkg-istanbul-lib-instrument-4.0.3.tgz
https://registry.yarnpkg.com/istanbul-lib-processinfo/-/istanbul-lib-processinfo-2.0.2.tgz -> yarnpkg-istanbul-lib-processinfo-2.0.2.tgz
https://registry.yarnpkg.com/istanbul-lib-report/-/istanbul-lib-report-3.0.0.tgz -> yarnpkg-istanbul-lib-report-3.0.0.tgz
https://registry.yarnpkg.com/istanbul-lib-source-maps/-/istanbul-lib-source-maps-4.0.0.tgz -> yarnpkg-istanbul-lib-source-maps-4.0.0.tgz
https://registry.yarnpkg.com/istanbul-reports/-/istanbul-reports-3.0.2.tgz -> yarnpkg-istanbul-reports-3.0.2.tgz
https://registry.yarnpkg.com/js-tokens/-/js-tokens-4.0.0.tgz -> yarnpkg-js-tokens-4.0.0.tgz
https://registry.yarnpkg.com/js-yaml/-/js-yaml-3.14.1.tgz -> yarnpkg-js-yaml-3.14.1.tgz
https://registry.yarnpkg.com/jsesc/-/jsesc-2.5.2.tgz -> yarnpkg-jsesc-2.5.2.tgz
https://registry.yarnpkg.com/json-parse-better-errors/-/json-parse-better-errors-1.0.2.tgz -> yarnpkg-json-parse-better-errors-1.0.2.tgz
https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz -> yarnpkg-json-schema-traverse-0.4.1.tgz
https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz -> yarnpkg-json-schema-traverse-1.0.0.tgz
https://registry.yarnpkg.com/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz -> yarnpkg-json-stable-stringify-without-jsonify-1.0.1.tgz
https://registry.yarnpkg.com/json5/-/json5-1.0.1.tgz -> yarnpkg-json5-1.0.1.tgz
https://registry.yarnpkg.com/json5/-/json5-2.1.3.tgz -> yarnpkg-json5-2.1.3.tgz
https://registry.yarnpkg.com/jsx-ast-utils/-/jsx-ast-utils-3.2.0.tgz -> yarnpkg-jsx-ast-utils-3.2.0.tgz
https://registry.yarnpkg.com/just-extend/-/just-extend-4.1.1.tgz -> yarnpkg-just-extend-4.1.1.tgz
https://registry.yarnpkg.com/levn/-/levn-0.4.1.tgz -> yarnpkg-levn-0.4.1.tgz
https://registry.yarnpkg.com/load-json-file/-/load-json-file-4.0.0.tgz -> yarnpkg-load-json-file-4.0.0.tgz
https://registry.yarnpkg.com/load-json-file/-/load-json-file-5.3.0.tgz -> yarnpkg-load-json-file-5.3.0.tgz
https://registry.yarnpkg.com/locate-path/-/locate-path-2.0.0.tgz -> yarnpkg-locate-path-2.0.0.tgz
https://registry.yarnpkg.com/locate-path/-/locate-path-3.0.0.tgz -> yarnpkg-locate-path-3.0.0.tgz
https://registry.yarnpkg.com/locate-path/-/locate-path-5.0.0.tgz -> yarnpkg-locate-path-5.0.0.tgz
https://registry.yarnpkg.com/lodash.clonedeep/-/lodash.clonedeep-4.5.0.tgz -> yarnpkg-lodash.clonedeep-4.5.0.tgz
https://registry.yarnpkg.com/lodash.flattendeep/-/lodash.flattendeep-4.4.0.tgz -> yarnpkg-lodash.flattendeep-4.4.0.tgz
https://registry.yarnpkg.com/lodash.get/-/lodash.get-4.4.2.tgz -> yarnpkg-lodash.get-4.4.2.tgz
https://registry.yarnpkg.com/lodash.truncate/-/lodash.truncate-4.4.2.tgz -> yarnpkg-lodash.truncate-4.4.2.tgz
https://registry.yarnpkg.com/lodash/-/lodash-4.17.21.tgz -> yarnpkg-lodash-4.17.21.tgz
https://registry.yarnpkg.com/loose-envify/-/loose-envify-1.4.0.tgz -> yarnpkg-loose-envify-1.4.0.tgz
https://registry.yarnpkg.com/lru-cache/-/lru-cache-4.1.5.tgz -> yarnpkg-lru-cache-4.1.5.tgz
https://registry.yarnpkg.com/lru-cache/-/lru-cache-6.0.0.tgz -> yarnpkg-lru-cache-6.0.0.tgz
https://registry.yarnpkg.com/make-dir/-/make-dir-3.1.0.tgz -> yarnpkg-make-dir-3.1.0.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-3.0.4.tgz -> yarnpkg-minimatch-3.0.4.tgz
https://registry.yarnpkg.com/minimist/-/minimist-1.2.5.tgz -> yarnpkg-minimist-1.2.5.tgz
https://registry.yarnpkg.com/ms/-/ms-2.0.0.tgz -> yarnpkg-ms-2.0.0.tgz
https://registry.yarnpkg.com/ms/-/ms-2.1.2.tgz -> yarnpkg-ms-2.1.2.tgz
https://registry.yarnpkg.com/ms/-/ms-2.1.3.tgz -> yarnpkg-ms-2.1.3.tgz
https://registry.yarnpkg.com/natural-compare/-/natural-compare-1.4.0.tgz -> yarnpkg-natural-compare-1.4.0.tgz
https://registry.yarnpkg.com/nise/-/nise-4.1.0.tgz -> yarnpkg-nise-4.1.0.tgz
https://registry.yarnpkg.com/nmtree/-/nmtree-1.0.6.tgz -> yarnpkg-nmtree-1.0.6.tgz
https://registry.yarnpkg.com/node-preload/-/node-preload-0.2.1.tgz -> yarnpkg-node-preload-0.2.1.tgz
https://registry.yarnpkg.com/normalize-package-data/-/normalize-package-data-2.5.0.tgz -> yarnpkg-normalize-package-data-2.5.0.tgz
https://registry.yarnpkg.com/nyc/-/nyc-15.1.0.tgz -> yarnpkg-nyc-15.1.0.tgz
https://registry.yarnpkg.com/object-assign/-/object-assign-4.1.1.tgz -> yarnpkg-object-assign-4.1.1.tgz
https://registry.yarnpkg.com/object-inspect/-/object-inspect-1.11.0.tgz -> yarnpkg-object-inspect-1.11.0.tgz
https://registry.yarnpkg.com/object-inspect/-/object-inspect-1.12.0.tgz -> yarnpkg-object-inspect-1.12.0.tgz
https://registry.yarnpkg.com/object-inspect/-/object-inspect-1.9.0.tgz -> yarnpkg-object-inspect-1.9.0.tgz
https://registry.yarnpkg.com/object-is/-/object-is-1.1.4.tgz -> yarnpkg-object-is-1.1.4.tgz
https://registry.yarnpkg.com/object-is/-/object-is-1.1.5.tgz -> yarnpkg-object-is-1.1.5.tgz
https://registry.yarnpkg.com/object-keys/-/object-keys-1.1.1.tgz -> yarnpkg-object-keys-1.1.1.tgz
https://registry.yarnpkg.com/object.assign/-/object.assign-4.1.2.tgz -> yarnpkg-object.assign-4.1.2.tgz
https://registry.yarnpkg.com/object.entries/-/object.entries-1.1.5.tgz -> yarnpkg-object.entries-1.1.5.tgz
https://registry.yarnpkg.com/object.fromentries/-/object.fromentries-2.0.5.tgz -> yarnpkg-object.fromentries-2.0.5.tgz
https://registry.yarnpkg.com/object.hasown/-/object.hasown-1.1.0.tgz -> yarnpkg-object.hasown-1.1.0.tgz
https://registry.yarnpkg.com/object.values/-/object.values-1.1.5.tgz -> yarnpkg-object.values-1.1.5.tgz
https://registry.yarnpkg.com/once/-/once-1.4.0.tgz -> yarnpkg-once-1.4.0.tgz
https://registry.yarnpkg.com/optionator/-/optionator-0.9.1.tgz -> yarnpkg-optionator-0.9.1.tgz
https://registry.yarnpkg.com/p-limit/-/p-limit-1.3.0.tgz -> yarnpkg-p-limit-1.3.0.tgz
https://registry.yarnpkg.com/p-limit/-/p-limit-2.3.0.tgz -> yarnpkg-p-limit-2.3.0.tgz
https://registry.yarnpkg.com/p-locate/-/p-locate-2.0.0.tgz -> yarnpkg-p-locate-2.0.0.tgz
https://registry.yarnpkg.com/p-locate/-/p-locate-3.0.0.tgz -> yarnpkg-p-locate-3.0.0.tgz
https://registry.yarnpkg.com/p-locate/-/p-locate-4.1.0.tgz -> yarnpkg-p-locate-4.1.0.tgz
https://registry.yarnpkg.com/p-map/-/p-map-3.0.0.tgz -> yarnpkg-p-map-3.0.0.tgz
https://registry.yarnpkg.com/p-try/-/p-try-1.0.0.tgz -> yarnpkg-p-try-1.0.0.tgz
https://registry.yarnpkg.com/p-try/-/p-try-2.2.0.tgz -> yarnpkg-p-try-2.2.0.tgz
https://registry.yarnpkg.com/package-hash/-/package-hash-4.0.0.tgz -> yarnpkg-package-hash-4.0.0.tgz
https://registry.yarnpkg.com/parent-module/-/parent-module-1.0.1.tgz -> yarnpkg-parent-module-1.0.1.tgz
https://registry.yarnpkg.com/parse-json/-/parse-json-4.0.0.tgz -> yarnpkg-parse-json-4.0.0.tgz
https://registry.yarnpkg.com/path-exists/-/path-exists-3.0.0.tgz -> yarnpkg-path-exists-3.0.0.tgz
https://registry.yarnpkg.com/path-exists/-/path-exists-4.0.0.tgz -> yarnpkg-path-exists-4.0.0.tgz
https://registry.yarnpkg.com/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> yarnpkg-path-is-absolute-1.0.1.tgz
https://registry.yarnpkg.com/path-key/-/path-key-3.1.1.tgz -> yarnpkg-path-key-3.1.1.tgz
https://registry.yarnpkg.com/path-parse/-/path-parse-1.0.7.tgz -> yarnpkg-path-parse-1.0.7.tgz
https://registry.yarnpkg.com/path-to-regexp/-/path-to-regexp-1.8.0.tgz -> yarnpkg-path-to-regexp-1.8.0.tgz
https://registry.yarnpkg.com/path-type/-/path-type-3.0.0.tgz -> yarnpkg-path-type-3.0.0.tgz
https://registry.yarnpkg.com/pify/-/pify-3.0.0.tgz -> yarnpkg-pify-3.0.0.tgz
https://registry.yarnpkg.com/pify/-/pify-4.0.1.tgz -> yarnpkg-pify-4.0.1.tgz
https://registry.yarnpkg.com/pkg-conf/-/pkg-conf-3.1.0.tgz -> yarnpkg-pkg-conf-3.1.0.tgz
https://registry.yarnpkg.com/pkg-dir/-/pkg-dir-2.0.0.tgz -> yarnpkg-pkg-dir-2.0.0.tgz
https://registry.yarnpkg.com/pkg-dir/-/pkg-dir-4.2.0.tgz -> yarnpkg-pkg-dir-4.2.0.tgz
https://registry.yarnpkg.com/pkg-up/-/pkg-up-2.0.0.tgz -> yarnpkg-pkg-up-2.0.0.tgz
https://registry.yarnpkg.com/prelude-ls/-/prelude-ls-1.2.1.tgz -> yarnpkg-prelude-ls-1.2.1.tgz
https://registry.yarnpkg.com/process-on-spawn/-/process-on-spawn-1.0.0.tgz -> yarnpkg-process-on-spawn-1.0.0.tgz
https://registry.yarnpkg.com/progress/-/progress-2.0.3.tgz -> yarnpkg-progress-2.0.3.tgz
https://registry.yarnpkg.com/prop-types/-/prop-types-15.7.2.tgz -> yarnpkg-prop-types-15.7.2.tgz
https://registry.yarnpkg.com/pseudomap/-/pseudomap-1.0.2.tgz -> yarnpkg-pseudomap-1.0.2.tgz
https://registry.yarnpkg.com/punycode/-/punycode-2.1.1.tgz -> yarnpkg-punycode-2.1.1.tgz
https://registry.yarnpkg.com/react-is/-/react-is-16.13.1.tgz -> yarnpkg-react-is-16.13.1.tgz
https://registry.yarnpkg.com/read-pkg-up/-/read-pkg-up-3.0.0.tgz -> yarnpkg-read-pkg-up-3.0.0.tgz
https://registry.yarnpkg.com/read-pkg/-/read-pkg-3.0.0.tgz -> yarnpkg-read-pkg-3.0.0.tgz
https://registry.yarnpkg.com/regexp.prototype.flags/-/regexp.prototype.flags-1.3.1.tgz -> yarnpkg-regexp.prototype.flags-1.3.1.tgz
https://registry.yarnpkg.com/regexpp/-/regexpp-3.1.0.tgz -> yarnpkg-regexpp-3.1.0.tgz
https://registry.yarnpkg.com/release-zalgo/-/release-zalgo-1.0.0.tgz -> yarnpkg-release-zalgo-1.0.0.tgz
https://registry.yarnpkg.com/require-directory/-/require-directory-2.1.1.tgz -> yarnpkg-require-directory-2.1.1.tgz
https://registry.yarnpkg.com/require-from-string/-/require-from-string-2.0.2.tgz -> yarnpkg-require-from-string-2.0.2.tgz
https://registry.yarnpkg.com/require-main-filename/-/require-main-filename-2.0.0.tgz -> yarnpkg-require-main-filename-2.0.0.tgz
https://registry.yarnpkg.com/resolve-from/-/resolve-from-4.0.0.tgz -> yarnpkg-resolve-from-4.0.0.tgz
https://registry.yarnpkg.com/resolve-from/-/resolve-from-5.0.0.tgz -> yarnpkg-resolve-from-5.0.0.tgz
https://registry.yarnpkg.com/resolve/-/resolve-1.19.0.tgz -> yarnpkg-resolve-1.19.0.tgz
https://registry.yarnpkg.com/resolve/-/resolve-1.20.0.tgz -> yarnpkg-resolve-1.20.0.tgz
https://registry.yarnpkg.com/resolve/-/resolve-2.0.0-next.3.tgz -> yarnpkg-resolve-2.0.0-next.3.tgz
https://registry.yarnpkg.com/resumer/-/resumer-0.0.0.tgz -> yarnpkg-resumer-0.0.0.tgz
https://registry.yarnpkg.com/rimraf/-/rimraf-3.0.2.tgz -> yarnpkg-rimraf-3.0.2.tgz
https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.1.2.tgz -> yarnpkg-safe-buffer-5.1.2.tgz
https://registry.yarnpkg.com/semver/-/semver-5.7.1.tgz -> yarnpkg-semver-5.7.1.tgz
https://registry.yarnpkg.com/semver/-/semver-6.3.0.tgz -> yarnpkg-semver-6.3.0.tgz
https://registry.yarnpkg.com/semver/-/semver-7.3.4.tgz -> yarnpkg-semver-7.3.4.tgz
https://registry.yarnpkg.com/semver/-/semver-7.3.5.tgz -> yarnpkg-semver-7.3.5.tgz
https://registry.yarnpkg.com/set-blocking/-/set-blocking-2.0.0.tgz -> yarnpkg-set-blocking-2.0.0.tgz
https://registry.yarnpkg.com/shebang-command/-/shebang-command-1.2.0.tgz -> yarnpkg-shebang-command-1.2.0.tgz
https://registry.yarnpkg.com/shebang-command/-/shebang-command-2.0.0.tgz -> yarnpkg-shebang-command-2.0.0.tgz
https://registry.yarnpkg.com/shebang-regex/-/shebang-regex-1.0.0.tgz -> yarnpkg-shebang-regex-1.0.0.tgz
https://registry.yarnpkg.com/shebang-regex/-/shebang-regex-3.0.0.tgz -> yarnpkg-shebang-regex-3.0.0.tgz
https://registry.yarnpkg.com/side-channel/-/side-channel-1.0.4.tgz -> yarnpkg-side-channel-1.0.4.tgz
https://registry.yarnpkg.com/signal-exit/-/signal-exit-3.0.3.tgz -> yarnpkg-signal-exit-3.0.3.tgz
https://registry.yarnpkg.com/sinon/-/sinon-9.2.4.tgz -> yarnpkg-sinon-9.2.4.tgz
https://registry.yarnpkg.com/slice-ansi/-/slice-ansi-4.0.0.tgz -> yarnpkg-slice-ansi-4.0.0.tgz
https://registry.yarnpkg.com/sort-object-keys/-/sort-object-keys-1.1.3.tgz -> yarnpkg-sort-object-keys-1.1.3.tgz
https://registry.yarnpkg.com/source-map/-/source-map-0.5.7.tgz -> yarnpkg-source-map-0.5.7.tgz
https://registry.yarnpkg.com/source-map/-/source-map-0.6.1.tgz -> yarnpkg-source-map-0.6.1.tgz
https://registry.yarnpkg.com/spawn-wrap/-/spawn-wrap-2.0.0.tgz -> yarnpkg-spawn-wrap-2.0.0.tgz
https://registry.yarnpkg.com/spdx-correct/-/spdx-correct-3.1.1.tgz -> yarnpkg-spdx-correct-3.1.1.tgz
https://registry.yarnpkg.com/spdx-exceptions/-/spdx-exceptions-2.3.0.tgz -> yarnpkg-spdx-exceptions-2.3.0.tgz
https://registry.yarnpkg.com/spdx-expression-parse/-/spdx-expression-parse-3.0.1.tgz -> yarnpkg-spdx-expression-parse-3.0.1.tgz
https://registry.yarnpkg.com/spdx-license-ids/-/spdx-license-ids-3.0.7.tgz -> yarnpkg-spdx-license-ids-3.0.7.tgz
https://registry.yarnpkg.com/sprintf-js/-/sprintf-js-1.0.3.tgz -> yarnpkg-sprintf-js-1.0.3.tgz
https://registry.yarnpkg.com/standard-engine/-/standard-engine-14.0.1.tgz -> yarnpkg-standard-engine-14.0.1.tgz
https://registry.yarnpkg.com/standard/-/standard-16.0.4.tgz -> yarnpkg-standard-16.0.4.tgz
https://registry.yarnpkg.com/string-width/-/string-width-4.2.0.tgz -> yarnpkg-string-width-4.2.0.tgz
https://registry.yarnpkg.com/string-width/-/string-width-4.2.3.tgz -> yarnpkg-string-width-4.2.3.tgz
https://registry.yarnpkg.com/string.prototype.matchall/-/string.prototype.matchall-4.0.6.tgz -> yarnpkg-string.prototype.matchall-4.0.6.tgz
https://registry.yarnpkg.com/string.prototype.trim/-/string.prototype.trim-1.2.5.tgz -> yarnpkg-string.prototype.trim-1.2.5.tgz
https://registry.yarnpkg.com/string.prototype.trimend/-/string.prototype.trimend-1.0.3.tgz -> yarnpkg-string.prototype.trimend-1.0.3.tgz
https://registry.yarnpkg.com/string.prototype.trimend/-/string.prototype.trimend-1.0.4.tgz -> yarnpkg-string.prototype.trimend-1.0.4.tgz
https://registry.yarnpkg.com/string.prototype.trimstart/-/string.prototype.trimstart-1.0.3.tgz -> yarnpkg-string.prototype.trimstart-1.0.3.tgz
https://registry.yarnpkg.com/string.prototype.trimstart/-/string.prototype.trimstart-1.0.4.tgz -> yarnpkg-string.prototype.trimstart-1.0.4.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-6.0.0.tgz -> yarnpkg-strip-ansi-6.0.0.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-6.0.1.tgz -> yarnpkg-strip-ansi-6.0.1.tgz
https://registry.yarnpkg.com/strip-bom/-/strip-bom-3.0.0.tgz -> yarnpkg-strip-bom-3.0.0.tgz
https://registry.yarnpkg.com/strip-bom/-/strip-bom-4.0.0.tgz -> yarnpkg-strip-bom-4.0.0.tgz
https://registry.yarnpkg.com/strip-json-comments/-/strip-json-comments-3.1.1.tgz -> yarnpkg-strip-json-comments-3.1.1.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-5.5.0.tgz -> yarnpkg-supports-color-5.5.0.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-7.2.0.tgz -> yarnpkg-supports-color-7.2.0.tgz
https://registry.yarnpkg.com/table/-/table-6.7.2.tgz -> yarnpkg-table-6.7.2.tgz
https://registry.yarnpkg.com/tape/-/tape-5.5.0.tgz -> yarnpkg-tape-5.5.0.tgz
https://registry.yarnpkg.com/test-exclude/-/test-exclude-6.0.0.tgz -> yarnpkg-test-exclude-6.0.0.tgz
https://registry.yarnpkg.com/text-table/-/text-table-0.2.0.tgz -> yarnpkg-text-table-0.2.0.tgz
https://registry.yarnpkg.com/through/-/through-2.3.8.tgz -> yarnpkg-through-2.3.8.tgz
https://registry.yarnpkg.com/to-fast-properties/-/to-fast-properties-2.0.0.tgz -> yarnpkg-to-fast-properties-2.0.0.tgz
https://registry.yarnpkg.com/tsconfig-paths/-/tsconfig-paths-3.11.0.tgz -> yarnpkg-tsconfig-paths-3.11.0.tgz
https://registry.yarnpkg.com/type-check/-/type-check-0.4.0.tgz -> yarnpkg-type-check-0.4.0.tgz
https://registry.yarnpkg.com/type-detect/-/type-detect-4.0.8.tgz -> yarnpkg-type-detect-4.0.8.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.3.1.tgz -> yarnpkg-type-fest-0.3.1.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.8.1.tgz -> yarnpkg-type-fest-0.8.1.tgz
https://registry.yarnpkg.com/typedarray-to-buffer/-/typedarray-to-buffer-3.1.5.tgz -> yarnpkg-typedarray-to-buffer-3.1.5.tgz
https://registry.yarnpkg.com/unbox-primitive/-/unbox-primitive-1.0.1.tgz -> yarnpkg-unbox-primitive-1.0.1.tgz
https://registry.yarnpkg.com/uri-js/-/uri-js-4.4.1.tgz -> yarnpkg-uri-js-4.4.1.tgz
https://registry.yarnpkg.com/uuid/-/uuid-3.4.0.tgz -> yarnpkg-uuid-3.4.0.tgz
https://registry.yarnpkg.com/v8-compile-cache/-/v8-compile-cache-2.2.0.tgz -> yarnpkg-v8-compile-cache-2.2.0.tgz
https://registry.yarnpkg.com/validate-npm-package-license/-/validate-npm-package-license-3.0.4.tgz -> yarnpkg-validate-npm-package-license-3.0.4.tgz
https://registry.yarnpkg.com/which-boxed-primitive/-/which-boxed-primitive-1.0.2.tgz -> yarnpkg-which-boxed-primitive-1.0.2.tgz
https://registry.yarnpkg.com/which-collection/-/which-collection-1.0.1.tgz -> yarnpkg-which-collection-1.0.1.tgz
https://registry.yarnpkg.com/which-module/-/which-module-2.0.0.tgz -> yarnpkg-which-module-2.0.0.tgz
https://registry.yarnpkg.com/which-typed-array/-/which-typed-array-1.1.4.tgz -> yarnpkg-which-typed-array-1.1.4.tgz
https://registry.yarnpkg.com/which/-/which-1.3.1.tgz -> yarnpkg-which-1.3.1.tgz
https://registry.yarnpkg.com/which/-/which-2.0.2.tgz -> yarnpkg-which-2.0.2.tgz
https://registry.yarnpkg.com/word-wrap/-/word-wrap-1.2.3.tgz -> yarnpkg-word-wrap-1.2.3.tgz
https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-6.2.0.tgz -> yarnpkg-wrap-ansi-6.2.0.tgz
https://registry.yarnpkg.com/wrappy/-/wrappy-1.0.2.tgz -> yarnpkg-wrappy-1.0.2.tgz
https://registry.yarnpkg.com/write-file-atomic/-/write-file-atomic-3.0.3.tgz -> yarnpkg-write-file-atomic-3.0.3.tgz
https://registry.yarnpkg.com/xdg-basedir/-/xdg-basedir-4.0.0.tgz -> yarnpkg-xdg-basedir-4.0.0.tgz
https://registry.yarnpkg.com/y18n/-/y18n-4.0.1.tgz -> yarnpkg-y18n-4.0.1.tgz
https://registry.yarnpkg.com/yallist/-/yallist-2.1.2.tgz -> yarnpkg-yallist-2.1.2.tgz
https://registry.yarnpkg.com/yallist/-/yallist-4.0.0.tgz -> yarnpkg-yallist-4.0.0.tgz
https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-18.1.3.tgz -> yarnpkg-yargs-parser-18.1.3.tgz
https://registry.yarnpkg.com/yargs/-/yargs-15.4.1.tgz -> yarnpkg-yargs-15.4.1.tgz
"
SRC_URI="
${YARN_EXTERNAL_URIS}
https://github.com/imsnif/synp/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
