# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NODE_ENV="development"
NODE_VERSION=14 # Using nodejs muxer variable name.
YARN_INSTALL_PATH="/opt/${PN}"
YARN_EXE_LIST="
${YARN_INSTALL_PATH}/cli.js
${YARN_INSTALL_PATH}/node_modules/.bin/acorn
${YARN_INSTALL_PATH}/node_modules/.bin/atob
${YARN_INSTALL_PATH}/node_modules/.bin/ava
${YARN_INSTALL_PATH}/node_modules/.bin/babylon
${YARN_INSTALL_PATH}/node_modules/.bin/eslint
${YARN_INSTALL_PATH}/node_modules/.bin/eslint-config-prettier-check
${YARN_INSTALL_PATH}/node_modules/.bin/esparse
${YARN_INSTALL_PATH}/node_modules/.bin/esvalidate
${YARN_INSTALL_PATH}/node_modules/.bin/extract-zip
${YARN_INSTALL_PATH}/node_modules/.bin/husky-upgrade
${YARN_INSTALL_PATH}/node_modules/.bin/import-local-fixture
${YARN_INSTALL_PATH}/node_modules/.bin/is-ci
${YARN_INSTALL_PATH}/node_modules/.bin/js-yaml
${YARN_INSTALL_PATH}/node_modules/.bin/jsesc
${YARN_INSTALL_PATH}/node_modules/.bin/json5
${YARN_INSTALL_PATH}/node_modules/.bin/loose-envify
${YARN_INSTALL_PATH}/node_modules/.bin/mime
${YARN_INSTALL_PATH}/node_modules/.bin/mkdirp
${YARN_INSTALL_PATH}/node_modules/.bin/pixelmatch
${YARN_INSTALL_PATH}/node_modules/.bin/prettier
${YARN_INSTALL_PATH}/node_modules/.bin/pretty-ms
${YARN_INSTALL_PATH}/node_modules/.bin/rc
${YARN_INSTALL_PATH}/node_modules/.bin/regjsparser
${YARN_INSTALL_PATH}/node_modules/.bin/resolve
${YARN_INSTALL_PATH}/node_modules/.bin/rimraf
${YARN_INSTALL_PATH}/node_modules/.bin/run-node
${YARN_INSTALL_PATH}/node_modules/.bin/semver
${YARN_INSTALL_PATH}/node_modules/.bin/strip-ansi
${YARN_INSTALL_PATH}/node_modules/.bin/strip-indent
${YARN_INSTALL_PATH}/node_modules/.bin/which
${YARN_INSTALL_PATH}/node_modules/.bin/xo
${YARN_INSTALL_PATH}/node_modules/@ladjs/time-require/node_modules/.bin/pretty-ms
${YARN_INSTALL_PATH}/node_modules/@ladjs/time-require/node_modules/chalk/node_modules/.bin/strip-ansi
${YARN_INSTALL_PATH}/node_modules/@sindresorhus/jimp/node_modules/.bin/mime
${YARN_INSTALL_PATH}/node_modules/@sindresorhus/jimp/node_modules/.bin/mkdirp
${YARN_INSTALL_PATH}/node_modules/@sindresorhus/jimp/node_modules/.bin/pixelmatch
${YARN_INSTALL_PATH}/node_modules/acorn-jsx/node_modules/.bin/acorn
${YARN_INSTALL_PATH}/node_modules/ava/node_modules/.bin/import-local-fixture
${YARN_INSTALL_PATH}/node_modules/ava/node_modules/.bin/is-ci
${YARN_INSTALL_PATH}/node_modules/ava/node_modules/.bin/semver
${YARN_INSTALL_PATH}/node_modules/ava/node_modules/redent/node_modules/.bin/strip-indent
${YARN_INSTALL_PATH}/node_modules/babel-core/node_modules/.bin/babylon
${YARN_INSTALL_PATH}/node_modules/babel-core/node_modules/.bin/json5
${YARN_INSTALL_PATH}/node_modules/babel-generator/node_modules/.bin/jsesc
${YARN_INSTALL_PATH}/node_modules/babel-plugin-espower/node_modules/.bin/babylon
${YARN_INSTALL_PATH}/node_modules/babel-register/node_modules/.bin/mkdirp
${YARN_INSTALL_PATH}/node_modules/babel-template/node_modules/.bin/babylon
${YARN_INSTALL_PATH}/node_modules/babel-traverse/node_modules/.bin/babylon
${YARN_INSTALL_PATH}/node_modules/caching-transform/node_modules/.bin/mkdirp
${YARN_INSTALL_PATH}/node_modules/child-process-promise/node_modules/cross-spawn/node_modules/.bin/which
${YARN_INSTALL_PATH}/node_modules/concordance/node_modules/.bin/semver
${YARN_INSTALL_PATH}/node_modules/cosmiconfig/node_modules/.bin/js-yaml
${YARN_INSTALL_PATH}/node_modules/cross-spawn-async/node_modules/.bin/which
${YARN_INSTALL_PATH}/node_modules/cross-spawn/node_modules/.bin/which
${YARN_INSTALL_PATH}/node_modules/del/node_modules/.bin/rimraf
${YARN_INSTALL_PATH}/node_modules/eslint-config-prettier/node_modules/.bin/eslint
${YARN_INSTALL_PATH}/node_modules/eslint-config-xo/node_modules/.bin/eslint
${YARN_INSTALL_PATH}/node_modules/eslint-import-resolver-node/node_modules/.bin/resolve
${YARN_INSTALL_PATH}/node_modules/eslint-plugin-ava/node_modules/.bin/eslint
${YARN_INSTALL_PATH}/node_modules/eslint-plugin-import/node_modules/.bin/eslint
${YARN_INSTALL_PATH}/node_modules/eslint-plugin-import/node_modules/.bin/resolve
${YARN_INSTALL_PATH}/node_modules/eslint-plugin-import/node_modules/.bin/semver
${YARN_INSTALL_PATH}/node_modules/eslint-plugin-node/node_modules/.bin/eslint
${YARN_INSTALL_PATH}/node_modules/eslint-plugin-node/node_modules/.bin/resolve
${YARN_INSTALL_PATH}/node_modules/eslint-plugin-node/node_modules/.bin/semver
${YARN_INSTALL_PATH}/node_modules/eslint-plugin-prettier/node_modules/.bin/prettier
${YARN_INSTALL_PATH}/node_modules/eslint-plugin-unicorn/node_modules/.bin/eslint
${YARN_INSTALL_PATH}/node_modules/eslint/node_modules/.bin/js-yaml
${YARN_INSTALL_PATH}/node_modules/eslint/node_modules/.bin/mkdirp
${YARN_INSTALL_PATH}/node_modules/eslint/node_modules/.bin/semver
${YARN_INSTALL_PATH}/node_modules/espree/node_modules/.bin/acorn
${YARN_INSTALL_PATH}/node_modules/execa/node_modules/cross-spawn/node_modules/.bin/semver
${YARN_INSTALL_PATH}/node_modules/execa/node_modules/cross-spawn/node_modules/.bin/which
${YARN_INSTALL_PATH}/node_modules/extract-zip/node_modules/.bin/mkdirp
${YARN_INSTALL_PATH}/node_modules/flat-cache/node_modules/.bin/rimraf
${YARN_INSTALL_PATH}/node_modules/hullabaloo-config-manager/node_modules/.bin/json5
${YARN_INSTALL_PATH}/node_modules/husky/node_modules/.bin/is-ci
${YARN_INSTALL_PATH}/node_modules/husky/node_modules/.bin/run-node
${YARN_INSTALL_PATH}/node_modules/invariant/node_modules/.bin/loose-envify
${YARN_INSTALL_PATH}/node_modules/js-yaml/node_modules/.bin/esparse
${YARN_INSTALL_PATH}/node_modules/js-yaml/node_modules/.bin/esvalidate
${YARN_INSTALL_PATH}/node_modules/load-bmfont/node_modules/.bin/mime
${YARN_INSTALL_PATH}/node_modules/normalize-package-data/node_modules/.bin/resolve
${YARN_INSTALL_PATH}/node_modules/normalize-package-data/node_modules/.bin/semver
${YARN_INSTALL_PATH}/node_modules/package-json/node_modules/.bin/semver
${YARN_INSTALL_PATH}/node_modules/puppeteer/node_modules/.bin/extract-zip
${YARN_INSTALL_PATH}/node_modules/puppeteer/node_modules/.bin/mime
${YARN_INSTALL_PATH}/node_modules/puppeteer/node_modules/.bin/rimraf
${YARN_INSTALL_PATH}/node_modules/regexpu-core/node_modules/.bin/regjsparser
${YARN_INSTALL_PATH}/node_modules/registry-auth-token/node_modules/.bin/rc
${YARN_INSTALL_PATH}/node_modules/registry-url/node_modules/.bin/rc
${YARN_INSTALL_PATH}/node_modules/regjsparser/node_modules/.bin/jsesc
${YARN_INSTALL_PATH}/node_modules/semver-diff/node_modules/.bin/semver
${YARN_INSTALL_PATH}/node_modules/source-map-resolve/node_modules/.bin/atob
${YARN_INSTALL_PATH}/node_modules/supertap/node_modules/.bin/js-yaml
${YARN_INSTALL_PATH}/node_modules/tsconfig-paths/node_modules/.bin/json5
${YARN_INSTALL_PATH}/node_modules/unique-temp-dir/node_modules/.bin/mkdirp
${YARN_INSTALL_PATH}/node_modules/update-notifier/node_modules/.bin/is-ci
${YARN_INSTALL_PATH}/node_modules/write/node_modules/.bin/mkdirp
${YARN_INSTALL_PATH}/node_modules/xo/node_modules/.bin/eslint
${YARN_INSTALL_PATH}/node_modules/xo/node_modules/.bin/eslint-config-prettier-check
${YARN_INSTALL_PATH}/node_modules/xo/node_modules/.bin/prettier
${YARN_INSTALL_PATH}/node_modules/xo/node_modules/.bin/semver
"
inherit desktop yarn

DESCRIPTION="Beautiful images of your code from right inside your terminal."
HOMEPAGE="https://github.com/mixn/carbon-now-cli"
LICENSE="MIT"
KEYWORDS="~amd64 ~amd64-linux ~x64-macos ~arm ~arm64 ~ppc ~ppc64 ~x86"
SLOT="0"
IUSE="clipboard custom-browser"
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
#   grep "resolved" /var/tmp/portage/dev-util/carbon-now-cli-1.4.0-r5/work/carbon-now-cli-1.4.0/yarn.lock | cut -f 2 -d '"' | cut -f 1 -d "#" | sort | uniq
# For the generator script, see the typescript/transform-uris.sh ebuild-package.
# UPDATER_START_YARN_EXTERNAL_URIS
YARN_EXTERNAL_URIS="
https://github.com/notmasteryet/jpgjs/archive/f1d30922fda93417669246f5a25cf2393dd9c108.tar.gz -> yarnpkg-jpgjs.git-f1d30922fda93417669246f5a25cf2393dd9c108.tgz
https://registry.yarnpkg.com/@ava/babel-plugin-throws-helper/-/babel-plugin-throws-helper-2.0.0.tgz -> yarnpkg-@ava-babel-plugin-throws-helper-2.0.0.tgz
https://registry.yarnpkg.com/@ava/babel-preset-stage-4/-/babel-preset-stage-4-1.1.0.tgz -> yarnpkg-@ava-babel-preset-stage-4-1.1.0.tgz
https://registry.yarnpkg.com/@ava/babel-preset-transform-test-files/-/babel-preset-transform-test-files-3.0.0.tgz -> yarnpkg-@ava-babel-preset-transform-test-files-3.0.0.tgz
https://registry.yarnpkg.com/@ava/write-file-atomic/-/write-file-atomic-2.2.0.tgz -> yarnpkg-@ava-write-file-atomic-2.2.0.tgz
https://registry.yarnpkg.com/@concordance/react/-/react-1.0.0.tgz -> yarnpkg-@concordance-react-1.0.0.tgz
https://registry.yarnpkg.com/@ladjs/time-require/-/time-require-0.1.4.tgz -> yarnpkg-@ladjs-time-require-0.1.4.tgz
https://registry.yarnpkg.com/@mrmlnc/readdir-enhanced/-/readdir-enhanced-2.2.1.tgz -> yarnpkg-@mrmlnc-readdir-enhanced-2.2.1.tgz
https://registry.yarnpkg.com/@nodelib/fs.stat/-/fs.stat-1.1.3.tgz -> yarnpkg-@nodelib-fs.stat-1.1.3.tgz
https://registry.yarnpkg.com/@samverschueren/stream-to-observable/-/stream-to-observable-0.3.1.tgz -> yarnpkg-@samverschueren-stream-to-observable-0.3.1.tgz
https://registry.yarnpkg.com/@sindresorhus/jimp/-/jimp-0.3.0.tgz -> yarnpkg-@sindresorhus-jimp-0.3.0.tgz
https://registry.yarnpkg.com/@types/json5/-/json5-0.0.29.tgz -> yarnpkg-@types-json5-0.0.29.tgz
https://registry.yarnpkg.com/acorn-jsx/-/acorn-jsx-3.0.1.tgz -> yarnpkg-acorn-jsx-3.0.1.tgz
https://registry.yarnpkg.com/acorn/-/acorn-3.3.0.tgz -> yarnpkg-acorn-3.3.0.tgz
https://registry.yarnpkg.com/acorn/-/acorn-5.7.4.tgz -> yarnpkg-acorn-5.7.4.tgz
https://registry.yarnpkg.com/agent-base/-/agent-base-4.3.0.tgz -> yarnpkg-agent-base-4.3.0.tgz
https://registry.yarnpkg.com/ajv-keywords/-/ajv-keywords-2.1.1.tgz -> yarnpkg-ajv-keywords-2.1.1.tgz
https://registry.yarnpkg.com/ajv/-/ajv-5.5.2.tgz -> yarnpkg-ajv-5.5.2.tgz
https://registry.yarnpkg.com/ansi-align/-/ansi-align-2.0.0.tgz -> yarnpkg-ansi-align-2.0.0.tgz
https://registry.yarnpkg.com/ansi-escapes/-/ansi-escapes-2.0.0.tgz -> yarnpkg-ansi-escapes-2.0.0.tgz
https://registry.yarnpkg.com/ansi-escapes/-/ansi-escapes-3.2.0.tgz -> yarnpkg-ansi-escapes-3.2.0.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-2.1.1.tgz -> yarnpkg-ansi-regex-2.1.1.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-3.0.1.tgz -> yarnpkg-ansi-regex-3.0.1.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-4.1.1.tgz -> yarnpkg-ansi-regex-4.1.1.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-1.0.0.tgz -> yarnpkg-ansi-styles-1.0.0.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-2.2.1.tgz -> yarnpkg-ansi-styles-2.2.1.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-3.2.1.tgz -> yarnpkg-ansi-styles-3.2.1.tgz
https://registry.yarnpkg.com/any-observable/-/any-observable-0.3.0.tgz -> yarnpkg-any-observable-0.3.0.tgz
https://registry.yarnpkg.com/anymatch/-/anymatch-1.3.2.tgz -> yarnpkg-anymatch-1.3.2.tgz
https://registry.yarnpkg.com/app-path/-/app-path-2.2.0.tgz -> yarnpkg-app-path-2.2.0.tgz
https://registry.yarnpkg.com/arch/-/arch-2.2.0.tgz -> yarnpkg-arch-2.2.0.tgz
https://registry.yarnpkg.com/argparse/-/argparse-1.0.10.tgz -> yarnpkg-argparse-1.0.10.tgz
https://registry.yarnpkg.com/arr-diff/-/arr-diff-2.0.0.tgz -> yarnpkg-arr-diff-2.0.0.tgz
https://registry.yarnpkg.com/arr-diff/-/arr-diff-4.0.0.tgz -> yarnpkg-arr-diff-4.0.0.tgz
https://registry.yarnpkg.com/arr-exclude/-/arr-exclude-1.0.0.tgz -> yarnpkg-arr-exclude-1.0.0.tgz
https://registry.yarnpkg.com/arr-flatten/-/arr-flatten-1.1.0.tgz -> yarnpkg-arr-flatten-1.1.0.tgz
https://registry.yarnpkg.com/arr-union/-/arr-union-3.1.0.tgz -> yarnpkg-arr-union-3.1.0.tgz
https://registry.yarnpkg.com/array-buffer-byte-length/-/array-buffer-byte-length-1.0.0.tgz -> yarnpkg-array-buffer-byte-length-1.0.0.tgz
https://registry.yarnpkg.com/array-differ/-/array-differ-1.0.0.tgz -> yarnpkg-array-differ-1.0.0.tgz
https://registry.yarnpkg.com/array-find-index/-/array-find-index-1.0.2.tgz -> yarnpkg-array-find-index-1.0.2.tgz
https://registry.yarnpkg.com/array-includes/-/array-includes-3.1.6.tgz -> yarnpkg-array-includes-3.1.6.tgz
https://registry.yarnpkg.com/array-union/-/array-union-1.0.2.tgz -> yarnpkg-array-union-1.0.2.tgz
https://registry.yarnpkg.com/array-uniq/-/array-uniq-1.0.3.tgz -> yarnpkg-array-uniq-1.0.3.tgz
https://registry.yarnpkg.com/array-unique/-/array-unique-0.2.1.tgz -> yarnpkg-array-unique-0.2.1.tgz
https://registry.yarnpkg.com/array-unique/-/array-unique-0.3.2.tgz -> yarnpkg-array-unique-0.3.2.tgz
https://registry.yarnpkg.com/array.prototype.flat/-/array.prototype.flat-1.3.1.tgz -> yarnpkg-array.prototype.flat-1.3.1.tgz
https://registry.yarnpkg.com/array.prototype.flatmap/-/array.prototype.flatmap-1.3.1.tgz -> yarnpkg-array.prototype.flatmap-1.3.1.tgz
https://registry.yarnpkg.com/arrify/-/arrify-1.0.1.tgz -> yarnpkg-arrify-1.0.1.tgz
https://registry.yarnpkg.com/assign-symbols/-/assign-symbols-1.0.0.tgz -> yarnpkg-assign-symbols-1.0.0.tgz
https://registry.yarnpkg.com/async-each/-/async-each-1.0.6.tgz -> yarnpkg-async-each-1.0.6.tgz
https://registry.yarnpkg.com/async-limiter/-/async-limiter-1.0.1.tgz -> yarnpkg-async-limiter-1.0.1.tgz
https://registry.yarnpkg.com/atob/-/atob-2.1.2.tgz -> yarnpkg-atob-2.1.2.tgz
https://registry.yarnpkg.com/auto-bind/-/auto-bind-1.2.1.tgz -> yarnpkg-auto-bind-1.2.1.tgz
https://registry.yarnpkg.com/ava-init/-/ava-init-0.2.1.tgz -> yarnpkg-ava-init-0.2.1.tgz
https://registry.yarnpkg.com/ava/-/ava-0.25.0.tgz -> yarnpkg-ava-0.25.0.tgz
https://registry.yarnpkg.com/available-typed-arrays/-/available-typed-arrays-1.0.5.tgz -> yarnpkg-available-typed-arrays-1.0.5.tgz
https://registry.yarnpkg.com/babel-code-frame/-/babel-code-frame-6.26.0.tgz -> yarnpkg-babel-code-frame-6.26.0.tgz
https://registry.yarnpkg.com/babel-core/-/babel-core-6.26.3.tgz -> yarnpkg-babel-core-6.26.3.tgz
https://registry.yarnpkg.com/babel-generator/-/babel-generator-6.26.1.tgz -> yarnpkg-babel-generator-6.26.1.tgz
https://registry.yarnpkg.com/babel-helper-builder-binary-assignment-operator-visitor/-/babel-helper-builder-binary-assignment-operator-visitor-6.24.1.tgz -> yarnpkg-babel-helper-builder-binary-assignment-operator-visitor-6.24.1.tgz
https://registry.yarnpkg.com/babel-helper-call-delegate/-/babel-helper-call-delegate-6.24.1.tgz -> yarnpkg-babel-helper-call-delegate-6.24.1.tgz
https://registry.yarnpkg.com/babel-helper-explode-assignable-expression/-/babel-helper-explode-assignable-expression-6.24.1.tgz -> yarnpkg-babel-helper-explode-assignable-expression-6.24.1.tgz
https://registry.yarnpkg.com/babel-helper-function-name/-/babel-helper-function-name-6.24.1.tgz -> yarnpkg-babel-helper-function-name-6.24.1.tgz
https://registry.yarnpkg.com/babel-helper-get-function-arity/-/babel-helper-get-function-arity-6.24.1.tgz -> yarnpkg-babel-helper-get-function-arity-6.24.1.tgz
https://registry.yarnpkg.com/babel-helper-hoist-variables/-/babel-helper-hoist-variables-6.24.1.tgz -> yarnpkg-babel-helper-hoist-variables-6.24.1.tgz
https://registry.yarnpkg.com/babel-helper-regex/-/babel-helper-regex-6.26.0.tgz -> yarnpkg-babel-helper-regex-6.26.0.tgz
https://registry.yarnpkg.com/babel-helper-remap-async-to-generator/-/babel-helper-remap-async-to-generator-6.24.1.tgz -> yarnpkg-babel-helper-remap-async-to-generator-6.24.1.tgz
https://registry.yarnpkg.com/babel-helpers/-/babel-helpers-6.24.1.tgz -> yarnpkg-babel-helpers-6.24.1.tgz
https://registry.yarnpkg.com/babel-messages/-/babel-messages-6.23.0.tgz -> yarnpkg-babel-messages-6.23.0.tgz
https://registry.yarnpkg.com/babel-plugin-check-es2015-constants/-/babel-plugin-check-es2015-constants-6.22.0.tgz -> yarnpkg-babel-plugin-check-es2015-constants-6.22.0.tgz
https://registry.yarnpkg.com/babel-plugin-espower/-/babel-plugin-espower-2.4.0.tgz -> yarnpkg-babel-plugin-espower-2.4.0.tgz
https://registry.yarnpkg.com/babel-plugin-syntax-async-functions/-/babel-plugin-syntax-async-functions-6.13.0.tgz -> yarnpkg-babel-plugin-syntax-async-functions-6.13.0.tgz
https://registry.yarnpkg.com/babel-plugin-syntax-exponentiation-operator/-/babel-plugin-syntax-exponentiation-operator-6.13.0.tgz -> yarnpkg-babel-plugin-syntax-exponentiation-operator-6.13.0.tgz
https://registry.yarnpkg.com/babel-plugin-syntax-object-rest-spread/-/babel-plugin-syntax-object-rest-spread-6.13.0.tgz -> yarnpkg-babel-plugin-syntax-object-rest-spread-6.13.0.tgz
https://registry.yarnpkg.com/babel-plugin-syntax-trailing-function-commas/-/babel-plugin-syntax-trailing-function-commas-6.22.0.tgz -> yarnpkg-babel-plugin-syntax-trailing-function-commas-6.22.0.tgz
https://registry.yarnpkg.com/babel-plugin-transform-async-to-generator/-/babel-plugin-transform-async-to-generator-6.24.1.tgz -> yarnpkg-babel-plugin-transform-async-to-generator-6.24.1.tgz
https://registry.yarnpkg.com/babel-plugin-transform-es2015-destructuring/-/babel-plugin-transform-es2015-destructuring-6.23.0.tgz -> yarnpkg-babel-plugin-transform-es2015-destructuring-6.23.0.tgz
https://registry.yarnpkg.com/babel-plugin-transform-es2015-function-name/-/babel-plugin-transform-es2015-function-name-6.24.1.tgz -> yarnpkg-babel-plugin-transform-es2015-function-name-6.24.1.tgz
https://registry.yarnpkg.com/babel-plugin-transform-es2015-modules-commonjs/-/babel-plugin-transform-es2015-modules-commonjs-6.26.2.tgz -> yarnpkg-babel-plugin-transform-es2015-modules-commonjs-6.26.2.tgz
https://registry.yarnpkg.com/babel-plugin-transform-es2015-parameters/-/babel-plugin-transform-es2015-parameters-6.24.1.tgz -> yarnpkg-babel-plugin-transform-es2015-parameters-6.24.1.tgz
https://registry.yarnpkg.com/babel-plugin-transform-es2015-spread/-/babel-plugin-transform-es2015-spread-6.22.0.tgz -> yarnpkg-babel-plugin-transform-es2015-spread-6.22.0.tgz
https://registry.yarnpkg.com/babel-plugin-transform-es2015-sticky-regex/-/babel-plugin-transform-es2015-sticky-regex-6.24.1.tgz -> yarnpkg-babel-plugin-transform-es2015-sticky-regex-6.24.1.tgz
https://registry.yarnpkg.com/babel-plugin-transform-es2015-unicode-regex/-/babel-plugin-transform-es2015-unicode-regex-6.24.1.tgz -> yarnpkg-babel-plugin-transform-es2015-unicode-regex-6.24.1.tgz
https://registry.yarnpkg.com/babel-plugin-transform-exponentiation-operator/-/babel-plugin-transform-exponentiation-operator-6.24.1.tgz -> yarnpkg-babel-plugin-transform-exponentiation-operator-6.24.1.tgz
https://registry.yarnpkg.com/babel-plugin-transform-strict-mode/-/babel-plugin-transform-strict-mode-6.24.1.tgz -> yarnpkg-babel-plugin-transform-strict-mode-6.24.1.tgz
https://registry.yarnpkg.com/babel-register/-/babel-register-6.26.0.tgz -> yarnpkg-babel-register-6.26.0.tgz
https://registry.yarnpkg.com/babel-runtime/-/babel-runtime-6.26.0.tgz -> yarnpkg-babel-runtime-6.26.0.tgz
https://registry.yarnpkg.com/babel-template/-/babel-template-6.26.0.tgz -> yarnpkg-babel-template-6.26.0.tgz
https://registry.yarnpkg.com/babel-traverse/-/babel-traverse-6.26.0.tgz -> yarnpkg-babel-traverse-6.26.0.tgz
https://registry.yarnpkg.com/babel-types/-/babel-types-6.26.0.tgz -> yarnpkg-babel-types-6.26.0.tgz
https://registry.yarnpkg.com/babylon/-/babylon-6.18.0.tgz -> yarnpkg-babylon-6.18.0.tgz
https://registry.yarnpkg.com/balanced-match/-/balanced-match-1.0.2.tgz -> yarnpkg-balanced-match-1.0.2.tgz
https://registry.yarnpkg.com/base/-/base-0.11.2.tgz -> yarnpkg-base-0.11.2.tgz
https://registry.yarnpkg.com/base64-js/-/base64-js-1.5.1.tgz -> yarnpkg-base64-js-1.5.1.tgz
https://registry.yarnpkg.com/bignumber.js/-/bignumber.js-2.4.0.tgz -> yarnpkg-bignumber.js-2.4.0.tgz
https://registry.yarnpkg.com/binary-extensions/-/binary-extensions-1.13.1.tgz -> yarnpkg-binary-extensions-1.13.1.tgz
https://registry.yarnpkg.com/bindings/-/bindings-1.5.0.tgz -> yarnpkg-bindings-1.5.0.tgz
https://registry.yarnpkg.com/bluebird/-/bluebird-3.7.2.tgz -> yarnpkg-bluebird-3.7.2.tgz
https://registry.yarnpkg.com/bmp-js/-/bmp-js-0.0.3.tgz -> yarnpkg-bmp-js-0.0.3.tgz
https://registry.yarnpkg.com/boxen/-/boxen-1.3.0.tgz -> yarnpkg-boxen-1.3.0.tgz
https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-1.1.11.tgz -> yarnpkg-brace-expansion-1.1.11.tgz
https://registry.yarnpkg.com/braces/-/braces-1.8.5.tgz -> yarnpkg-braces-1.8.5.tgz
https://registry.yarnpkg.com/braces/-/braces-2.3.2.tgz -> yarnpkg-braces-2.3.2.tgz
https://registry.yarnpkg.com/buf-compare/-/buf-compare-1.0.1.tgz -> yarnpkg-buf-compare-1.0.1.tgz
https://registry.yarnpkg.com/buffer-crc32/-/buffer-crc32-0.2.13.tgz -> yarnpkg-buffer-crc32-0.2.13.tgz
https://registry.yarnpkg.com/buffer-equal/-/buffer-equal-0.0.1.tgz -> yarnpkg-buffer-equal-0.0.1.tgz
https://registry.yarnpkg.com/buffer-from/-/buffer-from-1.1.2.tgz -> yarnpkg-buffer-from-1.1.2.tgz
https://registry.yarnpkg.com/bytes/-/bytes-3.1.2.tgz -> yarnpkg-bytes-3.1.2.tgz
https://registry.yarnpkg.com/cache-base/-/cache-base-1.0.1.tgz -> yarnpkg-cache-base-1.0.1.tgz
https://registry.yarnpkg.com/caching-transform/-/caching-transform-1.0.1.tgz -> yarnpkg-caching-transform-1.0.1.tgz
https://registry.yarnpkg.com/call-bind/-/call-bind-1.0.2.tgz -> yarnpkg-call-bind-1.0.2.tgz
https://registry.yarnpkg.com/call-matcher/-/call-matcher-1.1.0.tgz -> yarnpkg-call-matcher-1.1.0.tgz
https://registry.yarnpkg.com/call-me-maybe/-/call-me-maybe-1.0.2.tgz -> yarnpkg-call-me-maybe-1.0.2.tgz
https://registry.yarnpkg.com/call-signature/-/call-signature-0.0.2.tgz -> yarnpkg-call-signature-0.0.2.tgz
https://registry.yarnpkg.com/caller-callsite/-/caller-callsite-2.0.0.tgz -> yarnpkg-caller-callsite-2.0.0.tgz
https://registry.yarnpkg.com/caller-path/-/caller-path-0.1.0.tgz -> yarnpkg-caller-path-0.1.0.tgz
https://registry.yarnpkg.com/caller-path/-/caller-path-2.0.0.tgz -> yarnpkg-caller-path-2.0.0.tgz
https://registry.yarnpkg.com/callsites/-/callsites-0.2.0.tgz -> yarnpkg-callsites-0.2.0.tgz
https://registry.yarnpkg.com/callsites/-/callsites-2.0.0.tgz -> yarnpkg-callsites-2.0.0.tgz
https://registry.yarnpkg.com/camelcase-keys/-/camelcase-keys-2.1.0.tgz -> yarnpkg-camelcase-keys-2.1.0.tgz
https://registry.yarnpkg.com/camelcase-keys/-/camelcase-keys-4.2.0.tgz -> yarnpkg-camelcase-keys-4.2.0.tgz
https://registry.yarnpkg.com/camelcase/-/camelcase-2.1.1.tgz -> yarnpkg-camelcase-2.1.1.tgz
https://registry.yarnpkg.com/camelcase/-/camelcase-4.1.0.tgz -> yarnpkg-camelcase-4.1.0.tgz
https://registry.yarnpkg.com/capture-stack-trace/-/capture-stack-trace-1.0.2.tgz -> yarnpkg-capture-stack-trace-1.0.2.tgz
https://registry.yarnpkg.com/chalk/-/chalk-0.4.0.tgz -> yarnpkg-chalk-0.4.0.tgz
https://registry.yarnpkg.com/chalk/-/chalk-1.1.3.tgz -> yarnpkg-chalk-1.1.3.tgz
https://registry.yarnpkg.com/chalk/-/chalk-2.4.2.tgz -> yarnpkg-chalk-2.4.2.tgz
https://registry.yarnpkg.com/chardet/-/chardet-0.4.2.tgz -> yarnpkg-chardet-0.4.2.tgz
https://registry.yarnpkg.com/chardet/-/chardet-0.7.0.tgz -> yarnpkg-chardet-0.7.0.tgz
https://registry.yarnpkg.com/child-process-promise/-/child-process-promise-2.2.1.tgz -> yarnpkg-child-process-promise-2.2.1.tgz
https://registry.yarnpkg.com/chokidar/-/chokidar-1.7.0.tgz -> yarnpkg-chokidar-1.7.0.tgz
https://registry.yarnpkg.com/ci-info/-/ci-info-1.6.0.tgz -> yarnpkg-ci-info-1.6.0.tgz
https://registry.yarnpkg.com/ci-info/-/ci-info-2.0.0.tgz -> yarnpkg-ci-info-2.0.0.tgz
https://registry.yarnpkg.com/circular-json/-/circular-json-0.3.3.tgz -> yarnpkg-circular-json-0.3.3.tgz
https://registry.yarnpkg.com/class-utils/-/class-utils-0.3.6.tgz -> yarnpkg-class-utils-0.3.6.tgz
https://registry.yarnpkg.com/clean-regexp/-/clean-regexp-1.0.0.tgz -> yarnpkg-clean-regexp-1.0.0.tgz
https://registry.yarnpkg.com/clean-stack/-/clean-stack-1.3.0.tgz -> yarnpkg-clean-stack-1.3.0.tgz
https://registry.yarnpkg.com/clean-yaml-object/-/clean-yaml-object-0.1.0.tgz -> yarnpkg-clean-yaml-object-0.1.0.tgz
https://registry.yarnpkg.com/cli-boxes/-/cli-boxes-1.0.0.tgz -> yarnpkg-cli-boxes-1.0.0.tgz
https://registry.yarnpkg.com/cli-cursor/-/cli-cursor-2.1.0.tgz -> yarnpkg-cli-cursor-2.1.0.tgz
https://registry.yarnpkg.com/cli-spinners/-/cli-spinners-1.3.1.tgz -> yarnpkg-cli-spinners-1.3.1.tgz
https://registry.yarnpkg.com/cli-truncate/-/cli-truncate-0.2.1.tgz -> yarnpkg-cli-truncate-0.2.1.tgz
https://registry.yarnpkg.com/cli-truncate/-/cli-truncate-1.1.0.tgz -> yarnpkg-cli-truncate-1.1.0.tgz
https://registry.yarnpkg.com/cli-width/-/cli-width-2.2.1.tgz -> yarnpkg-cli-width-2.2.1.tgz
https://registry.yarnpkg.com/clipboardy/-/clipboardy-1.2.3.tgz -> yarnpkg-clipboardy-1.2.3.tgz
https://registry.yarnpkg.com/co-with-promise/-/co-with-promise-4.6.0.tgz -> yarnpkg-co-with-promise-4.6.0.tgz
https://registry.yarnpkg.com/co/-/co-4.6.0.tgz -> yarnpkg-co-4.6.0.tgz
https://registry.yarnpkg.com/code-excerpt/-/code-excerpt-2.1.1.tgz -> yarnpkg-code-excerpt-2.1.1.tgz
https://registry.yarnpkg.com/code-point-at/-/code-point-at-1.1.0.tgz -> yarnpkg-code-point-at-1.1.0.tgz
https://registry.yarnpkg.com/collection-visit/-/collection-visit-1.0.0.tgz -> yarnpkg-collection-visit-1.0.0.tgz
https://registry.yarnpkg.com/color-convert/-/color-convert-1.9.3.tgz -> yarnpkg-color-convert-1.9.3.tgz
https://registry.yarnpkg.com/color-name/-/color-name-1.1.3.tgz -> yarnpkg-color-name-1.1.3.tgz
https://registry.yarnpkg.com/common-path-prefix/-/common-path-prefix-1.0.0.tgz -> yarnpkg-common-path-prefix-1.0.0.tgz
https://registry.yarnpkg.com/commondir/-/commondir-1.0.1.tgz -> yarnpkg-commondir-1.0.1.tgz
https://registry.yarnpkg.com/component-emitter/-/component-emitter-1.3.0.tgz -> yarnpkg-component-emitter-1.3.0.tgz
https://registry.yarnpkg.com/concat-map/-/concat-map-0.0.1.tgz -> yarnpkg-concat-map-0.0.1.tgz
https://registry.yarnpkg.com/concat-stream/-/concat-stream-1.6.2.tgz -> yarnpkg-concat-stream-1.6.2.tgz
https://registry.yarnpkg.com/concordance/-/concordance-3.0.0.tgz -> yarnpkg-concordance-3.0.0.tgz
https://registry.yarnpkg.com/configstore/-/configstore-3.1.5.tgz -> yarnpkg-configstore-3.1.5.tgz
https://registry.yarnpkg.com/convert-source-map/-/convert-source-map-1.9.0.tgz -> yarnpkg-convert-source-map-1.9.0.tgz
https://registry.yarnpkg.com/convert-to-spaces/-/convert-to-spaces-1.0.2.tgz -> yarnpkg-convert-to-spaces-1.0.2.tgz
https://registry.yarnpkg.com/copy-descriptor/-/copy-descriptor-0.1.1.tgz -> yarnpkg-copy-descriptor-0.1.1.tgz
https://registry.yarnpkg.com/core-assert/-/core-assert-0.2.1.tgz -> yarnpkg-core-assert-0.2.1.tgz
https://registry.yarnpkg.com/core-js/-/core-js-2.6.12.tgz -> yarnpkg-core-js-2.6.12.tgz
https://registry.yarnpkg.com/core-util-is/-/core-util-is-1.0.3.tgz -> yarnpkg-core-util-is-1.0.3.tgz
https://registry.yarnpkg.com/cosmiconfig/-/cosmiconfig-5.2.1.tgz -> yarnpkg-cosmiconfig-5.2.1.tgz
https://registry.yarnpkg.com/create-error-class/-/create-error-class-3.0.2.tgz -> yarnpkg-create-error-class-3.0.2.tgz
https://registry.yarnpkg.com/cross-spawn-async/-/cross-spawn-async-2.2.5.tgz -> yarnpkg-cross-spawn-async-2.2.5.tgz
https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-4.0.2.tgz -> yarnpkg-cross-spawn-4.0.2.tgz
https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-5.1.0.tgz -> yarnpkg-cross-spawn-5.1.0.tgz
https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-6.0.5.tgz -> yarnpkg-cross-spawn-6.0.5.tgz
https://registry.yarnpkg.com/crypto-random-string/-/crypto-random-string-1.0.0.tgz -> yarnpkg-crypto-random-string-1.0.0.tgz
https://registry.yarnpkg.com/currently-unhandled/-/currently-unhandled-0.4.1.tgz -> yarnpkg-currently-unhandled-0.4.1.tgz
https://registry.yarnpkg.com/date-fns/-/date-fns-1.30.1.tgz -> yarnpkg-date-fns-1.30.1.tgz
https://registry.yarnpkg.com/date-time/-/date-time-0.1.1.tgz -> yarnpkg-date-time-0.1.1.tgz
https://registry.yarnpkg.com/date-time/-/date-time-2.1.0.tgz -> yarnpkg-date-time-2.1.0.tgz
https://registry.yarnpkg.com/debug/-/debug-2.6.9.tgz -> yarnpkg-debug-2.6.9.tgz
https://registry.yarnpkg.com/debug/-/debug-3.2.7.tgz -> yarnpkg-debug-3.2.7.tgz
https://registry.yarnpkg.com/debug/-/debug-4.3.4.tgz -> yarnpkg-debug-4.3.4.tgz
https://registry.yarnpkg.com/decamelize-keys/-/decamelize-keys-1.1.1.tgz -> yarnpkg-decamelize-keys-1.1.1.tgz
https://registry.yarnpkg.com/decamelize/-/decamelize-1.2.0.tgz -> yarnpkg-decamelize-1.2.0.tgz
https://registry.yarnpkg.com/decode-uri-component/-/decode-uri-component-0.2.2.tgz -> yarnpkg-decode-uri-component-0.2.2.tgz
https://registry.yarnpkg.com/deep-equal/-/deep-equal-1.1.1.tgz -> yarnpkg-deep-equal-1.1.1.tgz
https://registry.yarnpkg.com/deep-extend/-/deep-extend-0.6.0.tgz -> yarnpkg-deep-extend-0.6.0.tgz
https://registry.yarnpkg.com/deep-is/-/deep-is-0.1.4.tgz -> yarnpkg-deep-is-0.1.4.tgz
https://registry.yarnpkg.com/deep-strict-equal/-/deep-strict-equal-0.2.0.tgz -> yarnpkg-deep-strict-equal-0.2.0.tgz
https://registry.yarnpkg.com/define-properties/-/define-properties-1.2.0.tgz -> yarnpkg-define-properties-1.2.0.tgz
https://registry.yarnpkg.com/define-property/-/define-property-0.2.5.tgz -> yarnpkg-define-property-0.2.5.tgz
https://registry.yarnpkg.com/define-property/-/define-property-1.0.0.tgz -> yarnpkg-define-property-1.0.0.tgz
https://registry.yarnpkg.com/define-property/-/define-property-2.0.2.tgz -> yarnpkg-define-property-2.0.2.tgz
https://registry.yarnpkg.com/del/-/del-3.0.0.tgz -> yarnpkg-del-3.0.0.tgz
https://registry.yarnpkg.com/depd/-/depd-2.0.0.tgz -> yarnpkg-depd-2.0.0.tgz
https://registry.yarnpkg.com/detect-indent/-/detect-indent-4.0.0.tgz -> yarnpkg-detect-indent-4.0.0.tgz
https://registry.yarnpkg.com/detect-indent/-/detect-indent-5.0.0.tgz -> yarnpkg-detect-indent-5.0.0.tgz
https://registry.yarnpkg.com/dir-glob/-/dir-glob-2.0.0.tgz -> yarnpkg-dir-glob-2.0.0.tgz
https://registry.yarnpkg.com/doctrine/-/doctrine-2.1.0.tgz -> yarnpkg-doctrine-2.1.0.tgz
https://registry.yarnpkg.com/dom-walk/-/dom-walk-0.1.2.tgz -> yarnpkg-dom-walk-0.1.2.tgz
https://registry.yarnpkg.com/dot-prop/-/dot-prop-4.2.1.tgz -> yarnpkg-dot-prop-4.2.1.tgz
https://registry.yarnpkg.com/duplexer3/-/duplexer3-0.1.5.tgz -> yarnpkg-duplexer3-0.1.5.tgz
https://registry.yarnpkg.com/elegant-spinner/-/elegant-spinner-1.0.1.tgz -> yarnpkg-elegant-spinner-1.0.1.tgz
https://registry.yarnpkg.com/empower-core/-/empower-core-0.6.2.tgz -> yarnpkg-empower-core-0.6.2.tgz
https://registry.yarnpkg.com/end-of-stream/-/end-of-stream-1.4.4.tgz -> yarnpkg-end-of-stream-1.4.4.tgz
https://registry.yarnpkg.com/enhance-visitors/-/enhance-visitors-1.0.0.tgz -> yarnpkg-enhance-visitors-1.0.0.tgz
https://registry.yarnpkg.com/env-editor/-/env-editor-0.3.1.tgz -> yarnpkg-env-editor-0.3.1.tgz
https://registry.yarnpkg.com/equal-length/-/equal-length-1.0.1.tgz -> yarnpkg-equal-length-1.0.1.tgz
https://registry.yarnpkg.com/error-ex/-/error-ex-1.3.2.tgz -> yarnpkg-error-ex-1.3.2.tgz
https://registry.yarnpkg.com/es-abstract/-/es-abstract-1.21.2.tgz -> yarnpkg-es-abstract-1.21.2.tgz
https://registry.yarnpkg.com/es-set-tostringtag/-/es-set-tostringtag-2.0.1.tgz -> yarnpkg-es-set-tostringtag-2.0.1.tgz
https://registry.yarnpkg.com/es-shim-unscopables/-/es-shim-unscopables-1.0.0.tgz -> yarnpkg-es-shim-unscopables-1.0.0.tgz
https://registry.yarnpkg.com/es-to-primitive/-/es-to-primitive-1.2.1.tgz -> yarnpkg-es-to-primitive-1.2.1.tgz
https://registry.yarnpkg.com/es6-error/-/es6-error-4.1.1.tgz -> yarnpkg-es6-error-4.1.1.tgz
https://registry.yarnpkg.com/es6-promise/-/es6-promise-4.2.8.tgz -> yarnpkg-es6-promise-4.2.8.tgz
https://registry.yarnpkg.com/es6-promisify/-/es6-promisify-5.0.0.tgz -> yarnpkg-es6-promisify-5.0.0.tgz
https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> yarnpkg-escape-string-regexp-1.0.5.tgz
https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-2.0.0.tgz -> yarnpkg-escape-string-regexp-2.0.0.tgz
https://registry.yarnpkg.com/eslint-ast-utils/-/eslint-ast-utils-1.1.0.tgz -> yarnpkg-eslint-ast-utils-1.1.0.tgz
https://registry.yarnpkg.com/eslint-config-prettier/-/eslint-config-prettier-2.10.0.tgz -> yarnpkg-eslint-config-prettier-2.10.0.tgz
https://registry.yarnpkg.com/eslint-config-xo/-/eslint-config-xo-0.22.2.tgz -> yarnpkg-eslint-config-xo-0.22.2.tgz
https://registry.yarnpkg.com/eslint-formatter-pretty/-/eslint-formatter-pretty-1.3.0.tgz -> yarnpkg-eslint-formatter-pretty-1.3.0.tgz
https://registry.yarnpkg.com/eslint-import-resolver-node/-/eslint-import-resolver-node-0.3.7.tgz -> yarnpkg-eslint-import-resolver-node-0.3.7.tgz
https://registry.yarnpkg.com/eslint-module-utils/-/eslint-module-utils-2.7.4.tgz -> yarnpkg-eslint-module-utils-2.7.4.tgz
https://registry.yarnpkg.com/eslint-plugin-ava/-/eslint-plugin-ava-4.5.1.tgz -> yarnpkg-eslint-plugin-ava-4.5.1.tgz
https://registry.yarnpkg.com/eslint-plugin-import/-/eslint-plugin-import-2.27.5.tgz -> yarnpkg-eslint-plugin-import-2.27.5.tgz
https://registry.yarnpkg.com/eslint-plugin-no-use-extend-native/-/eslint-plugin-no-use-extend-native-0.3.12.tgz -> yarnpkg-eslint-plugin-no-use-extend-native-0.3.12.tgz
https://registry.yarnpkg.com/eslint-plugin-node/-/eslint-plugin-node-6.0.1.tgz -> yarnpkg-eslint-plugin-node-6.0.1.tgz
https://registry.yarnpkg.com/eslint-plugin-prettier/-/eslint-plugin-prettier-2.7.0.tgz -> yarnpkg-eslint-plugin-prettier-2.7.0.tgz
https://registry.yarnpkg.com/eslint-plugin-promise/-/eslint-plugin-promise-3.8.0.tgz -> yarnpkg-eslint-plugin-promise-3.8.0.tgz
https://registry.yarnpkg.com/eslint-plugin-unicorn/-/eslint-plugin-unicorn-4.0.3.tgz -> yarnpkg-eslint-plugin-unicorn-4.0.3.tgz
https://registry.yarnpkg.com/eslint-scope/-/eslint-scope-3.7.3.tgz -> yarnpkg-eslint-scope-3.7.3.tgz
https://registry.yarnpkg.com/eslint-visitor-keys/-/eslint-visitor-keys-1.3.0.tgz -> yarnpkg-eslint-visitor-keys-1.3.0.tgz
https://registry.yarnpkg.com/eslint/-/eslint-4.19.1.tgz -> yarnpkg-eslint-4.19.1.tgz
https://registry.yarnpkg.com/espower-location-detector/-/espower-location-detector-1.0.0.tgz -> yarnpkg-espower-location-detector-1.0.0.tgz
https://registry.yarnpkg.com/espree/-/espree-3.5.4.tgz -> yarnpkg-espree-3.5.4.tgz
https://registry.yarnpkg.com/esprima/-/esprima-4.0.1.tgz -> yarnpkg-esprima-4.0.1.tgz
https://registry.yarnpkg.com/espurify/-/espurify-1.8.1.tgz -> yarnpkg-espurify-1.8.1.tgz
https://registry.yarnpkg.com/esquery/-/esquery-1.5.0.tgz -> yarnpkg-esquery-1.5.0.tgz
https://registry.yarnpkg.com/esrecurse/-/esrecurse-4.3.0.tgz -> yarnpkg-esrecurse-4.3.0.tgz
https://registry.yarnpkg.com/estraverse/-/estraverse-4.3.0.tgz -> yarnpkg-estraverse-4.3.0.tgz
https://registry.yarnpkg.com/estraverse/-/estraverse-5.3.0.tgz -> yarnpkg-estraverse-5.3.0.tgz
https://registry.yarnpkg.com/esutils/-/esutils-2.0.3.tgz -> yarnpkg-esutils-2.0.3.tgz
https://registry.yarnpkg.com/execa/-/execa-0.4.0.tgz -> yarnpkg-execa-0.4.0.tgz
https://registry.yarnpkg.com/execa/-/execa-0.7.0.tgz -> yarnpkg-execa-0.7.0.tgz
https://registry.yarnpkg.com/execa/-/execa-0.8.0.tgz -> yarnpkg-execa-0.8.0.tgz
https://registry.yarnpkg.com/execa/-/execa-0.9.0.tgz -> yarnpkg-execa-0.9.0.tgz
https://registry.yarnpkg.com/execa/-/execa-1.0.0.tgz -> yarnpkg-execa-1.0.0.tgz
https://registry.yarnpkg.com/exif-parser/-/exif-parser-0.1.12.tgz -> yarnpkg-exif-parser-0.1.12.tgz
https://registry.yarnpkg.com/expand-brackets/-/expand-brackets-0.1.5.tgz -> yarnpkg-expand-brackets-0.1.5.tgz
https://registry.yarnpkg.com/expand-brackets/-/expand-brackets-2.1.4.tgz -> yarnpkg-expand-brackets-2.1.4.tgz
https://registry.yarnpkg.com/expand-range/-/expand-range-1.8.2.tgz -> yarnpkg-expand-range-1.8.2.tgz
https://registry.yarnpkg.com/extend-shallow/-/extend-shallow-2.0.1.tgz -> yarnpkg-extend-shallow-2.0.1.tgz
https://registry.yarnpkg.com/extend-shallow/-/extend-shallow-3.0.2.tgz -> yarnpkg-extend-shallow-3.0.2.tgz
https://registry.yarnpkg.com/external-editor/-/external-editor-2.2.0.tgz -> yarnpkg-external-editor-2.2.0.tgz
https://registry.yarnpkg.com/external-editor/-/external-editor-3.1.0.tgz -> yarnpkg-external-editor-3.1.0.tgz
https://registry.yarnpkg.com/extglob/-/extglob-0.3.2.tgz -> yarnpkg-extglob-0.3.2.tgz
https://registry.yarnpkg.com/extglob/-/extglob-2.0.4.tgz -> yarnpkg-extglob-2.0.4.tgz
https://registry.yarnpkg.com/extract-zip/-/extract-zip-1.7.0.tgz -> yarnpkg-extract-zip-1.7.0.tgz
https://registry.yarnpkg.com/fast-deep-equal/-/fast-deep-equal-1.1.0.tgz -> yarnpkg-fast-deep-equal-1.1.0.tgz
https://registry.yarnpkg.com/fast-diff/-/fast-diff-1.2.0.tgz -> yarnpkg-fast-diff-1.2.0.tgz
https://registry.yarnpkg.com/fast-glob/-/fast-glob-2.2.7.tgz -> yarnpkg-fast-glob-2.2.7.tgz
https://registry.yarnpkg.com/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz -> yarnpkg-fast-json-stable-stringify-2.1.0.tgz
https://registry.yarnpkg.com/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz -> yarnpkg-fast-levenshtein-2.0.6.tgz
https://registry.yarnpkg.com/fd-slicer/-/fd-slicer-1.1.0.tgz -> yarnpkg-fd-slicer-1.1.0.tgz
https://registry.yarnpkg.com/figures/-/figures-1.7.0.tgz -> yarnpkg-figures-1.7.0.tgz
https://registry.yarnpkg.com/figures/-/figures-2.0.0.tgz -> yarnpkg-figures-2.0.0.tgz
https://registry.yarnpkg.com/file-entry-cache/-/file-entry-cache-2.0.0.tgz -> yarnpkg-file-entry-cache-2.0.0.tgz
https://registry.yarnpkg.com/file-exists/-/file-exists-5.0.1.tgz -> yarnpkg-file-exists-5.0.1.tgz
https://registry.yarnpkg.com/file-extension/-/file-extension-4.0.5.tgz -> yarnpkg-file-extension-4.0.5.tgz
https://registry.yarnpkg.com/file-type/-/file-type-3.9.0.tgz -> yarnpkg-file-type-3.9.0.tgz
https://registry.yarnpkg.com/file-uri-to-path/-/file-uri-to-path-1.0.0.tgz -> yarnpkg-file-uri-to-path-1.0.0.tgz
https://registry.yarnpkg.com/filename-regex/-/filename-regex-2.0.1.tgz -> yarnpkg-filename-regex-2.0.1.tgz
https://registry.yarnpkg.com/fill-range/-/fill-range-2.2.4.tgz -> yarnpkg-fill-range-2.2.4.tgz
https://registry.yarnpkg.com/fill-range/-/fill-range-4.0.0.tgz -> yarnpkg-fill-range-4.0.0.tgz
https://registry.yarnpkg.com/filter-obj/-/filter-obj-1.1.0.tgz -> yarnpkg-filter-obj-1.1.0.tgz
https://registry.yarnpkg.com/find-cache-dir/-/find-cache-dir-1.0.0.tgz -> yarnpkg-find-cache-dir-1.0.0.tgz
https://registry.yarnpkg.com/find-up/-/find-up-1.1.2.tgz -> yarnpkg-find-up-1.1.2.tgz
https://registry.yarnpkg.com/find-up/-/find-up-2.1.0.tgz -> yarnpkg-find-up-2.1.0.tgz
https://registry.yarnpkg.com/find-up/-/find-up-3.0.0.tgz -> yarnpkg-find-up-3.0.0.tgz
https://registry.yarnpkg.com/flat-cache/-/flat-cache-1.3.4.tgz -> yarnpkg-flat-cache-1.3.4.tgz
https://registry.yarnpkg.com/fn-name/-/fn-name-2.0.1.tgz -> yarnpkg-fn-name-2.0.1.tgz
https://registry.yarnpkg.com/for-each/-/for-each-0.3.3.tgz -> yarnpkg-for-each-0.3.3.tgz
https://registry.yarnpkg.com/for-in/-/for-in-1.0.2.tgz -> yarnpkg-for-in-1.0.2.tgz
https://registry.yarnpkg.com/for-own/-/for-own-0.1.5.tgz -> yarnpkg-for-own-0.1.5.tgz
https://registry.yarnpkg.com/fragment-cache/-/fragment-cache-0.2.1.tgz -> yarnpkg-fragment-cache-0.2.1.tgz
https://registry.yarnpkg.com/fs.realpath/-/fs.realpath-1.0.0.tgz -> yarnpkg-fs.realpath-1.0.0.tgz
https://registry.yarnpkg.com/fsevents/-/fsevents-1.2.13.tgz -> yarnpkg-fsevents-1.2.13.tgz
https://registry.yarnpkg.com/function-bind/-/function-bind-1.1.1.tgz -> yarnpkg-function-bind-1.1.1.tgz
https://registry.yarnpkg.com/function-name-support/-/function-name-support-0.2.0.tgz -> yarnpkg-function-name-support-0.2.0.tgz
https://registry.yarnpkg.com/function.prototype.name/-/function.prototype.name-1.1.5.tgz -> yarnpkg-function.prototype.name-1.1.5.tgz
https://registry.yarnpkg.com/functional-red-black-tree/-/functional-red-black-tree-1.0.1.tgz -> yarnpkg-functional-red-black-tree-1.0.1.tgz
https://registry.yarnpkg.com/functions-have-names/-/functions-have-names-1.2.3.tgz -> yarnpkg-functions-have-names-1.2.3.tgz
https://registry.yarnpkg.com/get-intrinsic/-/get-intrinsic-1.2.0.tgz -> yarnpkg-get-intrinsic-1.2.0.tgz
https://registry.yarnpkg.com/get-port/-/get-port-3.2.0.tgz -> yarnpkg-get-port-3.2.0.tgz
https://registry.yarnpkg.com/get-set-props/-/get-set-props-0.1.0.tgz -> yarnpkg-get-set-props-0.1.0.tgz
https://registry.yarnpkg.com/get-stdin/-/get-stdin-4.0.1.tgz -> yarnpkg-get-stdin-4.0.1.tgz
https://registry.yarnpkg.com/get-stdin/-/get-stdin-5.0.1.tgz -> yarnpkg-get-stdin-5.0.1.tgz
https://registry.yarnpkg.com/get-stdin/-/get-stdin-6.0.0.tgz -> yarnpkg-get-stdin-6.0.0.tgz
https://registry.yarnpkg.com/get-stream/-/get-stream-3.0.0.tgz -> yarnpkg-get-stream-3.0.0.tgz
https://registry.yarnpkg.com/get-stream/-/get-stream-4.1.0.tgz -> yarnpkg-get-stream-4.1.0.tgz
https://registry.yarnpkg.com/get-symbol-description/-/get-symbol-description-1.0.0.tgz -> yarnpkg-get-symbol-description-1.0.0.tgz
https://registry.yarnpkg.com/get-value/-/get-value-2.0.6.tgz -> yarnpkg-get-value-2.0.6.tgz
https://registry.yarnpkg.com/glob-base/-/glob-base-0.3.0.tgz -> yarnpkg-glob-base-0.3.0.tgz
https://registry.yarnpkg.com/glob-parent/-/glob-parent-2.0.0.tgz -> yarnpkg-glob-parent-2.0.0.tgz
https://registry.yarnpkg.com/glob-parent/-/glob-parent-3.1.0.tgz -> yarnpkg-glob-parent-3.1.0.tgz
https://registry.yarnpkg.com/glob-to-regexp/-/glob-to-regexp-0.3.0.tgz -> yarnpkg-glob-to-regexp-0.3.0.tgz
https://registry.yarnpkg.com/glob/-/glob-7.2.3.tgz -> yarnpkg-glob-7.2.3.tgz
https://registry.yarnpkg.com/global-dirs/-/global-dirs-0.1.1.tgz -> yarnpkg-global-dirs-0.1.1.tgz
https://registry.yarnpkg.com/global/-/global-4.4.0.tgz -> yarnpkg-global-4.4.0.tgz
https://registry.yarnpkg.com/globals/-/globals-11.12.0.tgz -> yarnpkg-globals-11.12.0.tgz
https://registry.yarnpkg.com/globals/-/globals-9.18.0.tgz -> yarnpkg-globals-9.18.0.tgz
https://registry.yarnpkg.com/globalthis/-/globalthis-1.0.3.tgz -> yarnpkg-globalthis-1.0.3.tgz
https://registry.yarnpkg.com/globby/-/globby-6.1.0.tgz -> yarnpkg-globby-6.1.0.tgz
https://registry.yarnpkg.com/globby/-/globby-8.0.2.tgz -> yarnpkg-globby-8.0.2.tgz
https://registry.yarnpkg.com/gopd/-/gopd-1.0.1.tgz -> yarnpkg-gopd-1.0.1.tgz
https://registry.yarnpkg.com/got/-/got-6.7.1.tgz -> yarnpkg-got-6.7.1.tgz
https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-4.2.11.tgz -> yarnpkg-graceful-fs-4.2.11.tgz
https://registry.yarnpkg.com/has-ansi/-/has-ansi-2.0.0.tgz -> yarnpkg-has-ansi-2.0.0.tgz
https://registry.yarnpkg.com/has-bigints/-/has-bigints-1.0.2.tgz -> yarnpkg-has-bigints-1.0.2.tgz
https://registry.yarnpkg.com/has-color/-/has-color-0.1.7.tgz -> yarnpkg-has-color-0.1.7.tgz
https://registry.yarnpkg.com/has-flag/-/has-flag-2.0.0.tgz -> yarnpkg-has-flag-2.0.0.tgz
https://registry.yarnpkg.com/has-flag/-/has-flag-3.0.0.tgz -> yarnpkg-has-flag-3.0.0.tgz
https://registry.yarnpkg.com/has-property-descriptors/-/has-property-descriptors-1.0.0.tgz -> yarnpkg-has-property-descriptors-1.0.0.tgz
https://registry.yarnpkg.com/has-proto/-/has-proto-1.0.1.tgz -> yarnpkg-has-proto-1.0.1.tgz
https://registry.yarnpkg.com/has-symbols/-/has-symbols-1.0.3.tgz -> yarnpkg-has-symbols-1.0.3.tgz
https://registry.yarnpkg.com/has-tostringtag/-/has-tostringtag-1.0.0.tgz -> yarnpkg-has-tostringtag-1.0.0.tgz
https://registry.yarnpkg.com/has-value/-/has-value-0.3.1.tgz -> yarnpkg-has-value-0.3.1.tgz
https://registry.yarnpkg.com/has-value/-/has-value-1.0.0.tgz -> yarnpkg-has-value-1.0.0.tgz
https://registry.yarnpkg.com/has-values/-/has-values-0.1.4.tgz -> yarnpkg-has-values-0.1.4.tgz
https://registry.yarnpkg.com/has-values/-/has-values-1.0.0.tgz -> yarnpkg-has-values-1.0.0.tgz
https://registry.yarnpkg.com/has-yarn/-/has-yarn-1.0.0.tgz -> yarnpkg-has-yarn-1.0.0.tgz
https://registry.yarnpkg.com/has/-/has-1.0.3.tgz -> yarnpkg-has-1.0.3.tgz
https://registry.yarnpkg.com/home-or-tmp/-/home-or-tmp-2.0.0.tgz -> yarnpkg-home-or-tmp-2.0.0.tgz
https://registry.yarnpkg.com/hosted-git-info/-/hosted-git-info-2.8.9.tgz -> yarnpkg-hosted-git-info-2.8.9.tgz
https://registry.yarnpkg.com/http-errors/-/http-errors-2.0.0.tgz -> yarnpkg-http-errors-2.0.0.tgz
https://registry.yarnpkg.com/https-proxy-agent/-/https-proxy-agent-2.2.4.tgz -> yarnpkg-https-proxy-agent-2.2.4.tgz
https://registry.yarnpkg.com/hullabaloo-config-manager/-/hullabaloo-config-manager-1.1.1.tgz -> yarnpkg-hullabaloo-config-manager-1.1.1.tgz
https://registry.yarnpkg.com/husky/-/husky-1.3.1.tgz -> yarnpkg-husky-1.3.1.tgz
https://registry.yarnpkg.com/iconv-lite/-/iconv-lite-0.4.24.tgz -> yarnpkg-iconv-lite-0.4.24.tgz
https://registry.yarnpkg.com/ignore-by-default/-/ignore-by-default-1.0.1.tgz -> yarnpkg-ignore-by-default-1.0.1.tgz
https://registry.yarnpkg.com/ignore/-/ignore-3.3.10.tgz -> yarnpkg-ignore-3.3.10.tgz
https://registry.yarnpkg.com/import-fresh/-/import-fresh-2.0.0.tgz -> yarnpkg-import-fresh-2.0.0.tgz
https://registry.yarnpkg.com/import-lazy/-/import-lazy-2.1.0.tgz -> yarnpkg-import-lazy-2.1.0.tgz
https://registry.yarnpkg.com/import-local/-/import-local-0.1.1.tgz -> yarnpkg-import-local-0.1.1.tgz
https://registry.yarnpkg.com/import-modules/-/import-modules-1.1.0.tgz -> yarnpkg-import-modules-1.1.0.tgz
https://registry.yarnpkg.com/imurmurhash/-/imurmurhash-0.1.4.tgz -> yarnpkg-imurmurhash-0.1.4.tgz
https://registry.yarnpkg.com/indent-string/-/indent-string-2.1.0.tgz -> yarnpkg-indent-string-2.1.0.tgz
https://registry.yarnpkg.com/indent-string/-/indent-string-3.2.0.tgz -> yarnpkg-indent-string-3.2.0.tgz
https://registry.yarnpkg.com/inflight/-/inflight-1.0.6.tgz -> yarnpkg-inflight-1.0.6.tgz
https://registry.yarnpkg.com/inherits/-/inherits-2.0.4.tgz -> yarnpkg-inherits-2.0.4.tgz
https://registry.yarnpkg.com/ini/-/ini-1.3.8.tgz -> yarnpkg-ini-1.3.8.tgz
https://registry.yarnpkg.com/inquirer/-/inquirer-3.3.0.tgz -> yarnpkg-inquirer-3.3.0.tgz
https://registry.yarnpkg.com/inquirer/-/inquirer-6.5.2.tgz -> yarnpkg-inquirer-6.5.2.tgz
https://registry.yarnpkg.com/internal-slot/-/internal-slot-1.0.5.tgz -> yarnpkg-internal-slot-1.0.5.tgz
https://registry.yarnpkg.com/invariant/-/invariant-2.2.4.tgz -> yarnpkg-invariant-2.2.4.tgz
https://registry.yarnpkg.com/irregular-plurals/-/irregular-plurals-1.4.0.tgz -> yarnpkg-irregular-plurals-1.4.0.tgz
https://registry.yarnpkg.com/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz -> yarnpkg-is-accessor-descriptor-0.1.6.tgz
https://registry.yarnpkg.com/is-accessor-descriptor/-/is-accessor-descriptor-1.0.0.tgz -> yarnpkg-is-accessor-descriptor-1.0.0.tgz
https://registry.yarnpkg.com/is-arguments/-/is-arguments-1.1.1.tgz -> yarnpkg-is-arguments-1.1.1.tgz
https://registry.yarnpkg.com/is-array-buffer/-/is-array-buffer-3.0.2.tgz -> yarnpkg-is-array-buffer-3.0.2.tgz
https://registry.yarnpkg.com/is-arrayish/-/is-arrayish-0.2.1.tgz -> yarnpkg-is-arrayish-0.2.1.tgz
https://registry.yarnpkg.com/is-bigint/-/is-bigint-1.0.4.tgz -> yarnpkg-is-bigint-1.0.4.tgz
https://registry.yarnpkg.com/is-binary-path/-/is-binary-path-1.0.1.tgz -> yarnpkg-is-binary-path-1.0.1.tgz
https://registry.yarnpkg.com/is-boolean-object/-/is-boolean-object-1.1.2.tgz -> yarnpkg-is-boolean-object-1.1.2.tgz
https://registry.yarnpkg.com/is-buffer/-/is-buffer-1.1.6.tgz -> yarnpkg-is-buffer-1.1.6.tgz
https://registry.yarnpkg.com/is-callable/-/is-callable-1.2.7.tgz -> yarnpkg-is-callable-1.2.7.tgz
https://registry.yarnpkg.com/is-ci/-/is-ci-1.2.1.tgz -> yarnpkg-is-ci-1.2.1.tgz
https://registry.yarnpkg.com/is-ci/-/is-ci-2.0.0.tgz -> yarnpkg-is-ci-2.0.0.tgz
https://registry.yarnpkg.com/is-core-module/-/is-core-module-2.11.0.tgz -> yarnpkg-is-core-module-2.11.0.tgz
https://registry.yarnpkg.com/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz -> yarnpkg-is-data-descriptor-0.1.4.tgz
https://registry.yarnpkg.com/is-data-descriptor/-/is-data-descriptor-1.0.0.tgz -> yarnpkg-is-data-descriptor-1.0.0.tgz
https://registry.yarnpkg.com/is-date-object/-/is-date-object-1.0.5.tgz -> yarnpkg-is-date-object-1.0.5.tgz
https://registry.yarnpkg.com/is-descriptor/-/is-descriptor-0.1.6.tgz -> yarnpkg-is-descriptor-0.1.6.tgz
https://registry.yarnpkg.com/is-descriptor/-/is-descriptor-1.0.2.tgz -> yarnpkg-is-descriptor-1.0.2.tgz
https://registry.yarnpkg.com/is-directory/-/is-directory-0.3.1.tgz -> yarnpkg-is-directory-0.3.1.tgz
https://registry.yarnpkg.com/is-dotfile/-/is-dotfile-1.0.3.tgz -> yarnpkg-is-dotfile-1.0.3.tgz
https://registry.yarnpkg.com/is-equal-shallow/-/is-equal-shallow-0.1.3.tgz -> yarnpkg-is-equal-shallow-0.1.3.tgz
https://registry.yarnpkg.com/is-error/-/is-error-2.2.2.tgz -> yarnpkg-is-error-2.2.2.tgz
https://registry.yarnpkg.com/is-extendable/-/is-extendable-0.1.1.tgz -> yarnpkg-is-extendable-0.1.1.tgz
https://registry.yarnpkg.com/is-extendable/-/is-extendable-1.0.1.tgz -> yarnpkg-is-extendable-1.0.1.tgz
https://registry.yarnpkg.com/is-extglob/-/is-extglob-1.0.0.tgz -> yarnpkg-is-extglob-1.0.0.tgz
https://registry.yarnpkg.com/is-extglob/-/is-extglob-2.1.1.tgz -> yarnpkg-is-extglob-2.1.1.tgz
https://registry.yarnpkg.com/is-finite/-/is-finite-1.1.0.tgz -> yarnpkg-is-finite-1.1.0.tgz
https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-1.0.0.tgz -> yarnpkg-is-fullwidth-code-point-1.0.0.tgz
https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz -> yarnpkg-is-fullwidth-code-point-2.0.0.tgz
https://registry.yarnpkg.com/is-function/-/is-function-1.0.2.tgz -> yarnpkg-is-function-1.0.2.tgz
https://registry.yarnpkg.com/is-generator-fn/-/is-generator-fn-1.0.0.tgz -> yarnpkg-is-generator-fn-1.0.0.tgz
https://registry.yarnpkg.com/is-get-set-prop/-/is-get-set-prop-1.0.0.tgz -> yarnpkg-is-get-set-prop-1.0.0.tgz
https://registry.yarnpkg.com/is-glob/-/is-glob-2.0.1.tgz -> yarnpkg-is-glob-2.0.1.tgz
https://registry.yarnpkg.com/is-glob/-/is-glob-3.1.0.tgz -> yarnpkg-is-glob-3.1.0.tgz
https://registry.yarnpkg.com/is-glob/-/is-glob-4.0.3.tgz -> yarnpkg-is-glob-4.0.3.tgz
https://registry.yarnpkg.com/is-installed-globally/-/is-installed-globally-0.1.0.tgz -> yarnpkg-is-installed-globally-0.1.0.tgz
https://registry.yarnpkg.com/is-js-type/-/is-js-type-2.0.0.tgz -> yarnpkg-is-js-type-2.0.0.tgz
https://registry.yarnpkg.com/is-negative-zero/-/is-negative-zero-2.0.2.tgz -> yarnpkg-is-negative-zero-2.0.2.tgz
https://registry.yarnpkg.com/is-npm/-/is-npm-1.0.0.tgz -> yarnpkg-is-npm-1.0.0.tgz
https://registry.yarnpkg.com/is-number-object/-/is-number-object-1.0.7.tgz -> yarnpkg-is-number-object-1.0.7.tgz
https://registry.yarnpkg.com/is-number/-/is-number-2.1.0.tgz -> yarnpkg-is-number-2.1.0.tgz
https://registry.yarnpkg.com/is-number/-/is-number-3.0.0.tgz -> yarnpkg-is-number-3.0.0.tgz
https://registry.yarnpkg.com/is-number/-/is-number-4.0.0.tgz -> yarnpkg-is-number-4.0.0.tgz
https://registry.yarnpkg.com/is-obj-prop/-/is-obj-prop-1.0.0.tgz -> yarnpkg-is-obj-prop-1.0.0.tgz
https://registry.yarnpkg.com/is-obj/-/is-obj-1.0.1.tgz -> yarnpkg-is-obj-1.0.1.tgz
https://registry.yarnpkg.com/is-observable/-/is-observable-0.2.0.tgz -> yarnpkg-is-observable-0.2.0.tgz
https://registry.yarnpkg.com/is-observable/-/is-observable-1.1.0.tgz -> yarnpkg-is-observable-1.1.0.tgz
https://registry.yarnpkg.com/is-path-cwd/-/is-path-cwd-1.0.0.tgz -> yarnpkg-is-path-cwd-1.0.0.tgz
https://registry.yarnpkg.com/is-path-in-cwd/-/is-path-in-cwd-1.0.1.tgz -> yarnpkg-is-path-in-cwd-1.0.1.tgz
https://registry.yarnpkg.com/is-path-inside/-/is-path-inside-1.0.1.tgz -> yarnpkg-is-path-inside-1.0.1.tgz
https://registry.yarnpkg.com/is-plain-obj/-/is-plain-obj-1.1.0.tgz -> yarnpkg-is-plain-obj-1.1.0.tgz
https://registry.yarnpkg.com/is-plain-object/-/is-plain-object-2.0.4.tgz -> yarnpkg-is-plain-object-2.0.4.tgz
https://registry.yarnpkg.com/is-posix-bracket/-/is-posix-bracket-0.1.1.tgz -> yarnpkg-is-posix-bracket-0.1.1.tgz
https://registry.yarnpkg.com/is-primitive/-/is-primitive-2.0.0.tgz -> yarnpkg-is-primitive-2.0.0.tgz
https://registry.yarnpkg.com/is-promise/-/is-promise-2.2.2.tgz -> yarnpkg-is-promise-2.2.2.tgz
https://registry.yarnpkg.com/is-proto-prop/-/is-proto-prop-1.0.1.tgz -> yarnpkg-is-proto-prop-1.0.1.tgz
https://registry.yarnpkg.com/is-redirect/-/is-redirect-1.0.0.tgz -> yarnpkg-is-redirect-1.0.0.tgz
https://registry.yarnpkg.com/is-regex/-/is-regex-1.1.4.tgz -> yarnpkg-is-regex-1.1.4.tgz
https://registry.yarnpkg.com/is-resolvable/-/is-resolvable-1.1.0.tgz -> yarnpkg-is-resolvable-1.1.0.tgz
https://registry.yarnpkg.com/is-retry-allowed/-/is-retry-allowed-1.2.0.tgz -> yarnpkg-is-retry-allowed-1.2.0.tgz
https://registry.yarnpkg.com/is-shared-array-buffer/-/is-shared-array-buffer-1.0.2.tgz -> yarnpkg-is-shared-array-buffer-1.0.2.tgz
https://registry.yarnpkg.com/is-stream/-/is-stream-1.1.0.tgz -> yarnpkg-is-stream-1.1.0.tgz
https://registry.yarnpkg.com/is-string/-/is-string-1.0.7.tgz -> yarnpkg-is-string-1.0.7.tgz
https://registry.yarnpkg.com/is-symbol/-/is-symbol-1.0.4.tgz -> yarnpkg-is-symbol-1.0.4.tgz
https://registry.yarnpkg.com/is-typed-array/-/is-typed-array-1.1.10.tgz -> yarnpkg-is-typed-array-1.1.10.tgz
https://registry.yarnpkg.com/is-url/-/is-url-1.2.4.tgz -> yarnpkg-is-url-1.2.4.tgz
https://registry.yarnpkg.com/is-utf8/-/is-utf8-0.2.1.tgz -> yarnpkg-is-utf8-0.2.1.tgz
https://registry.yarnpkg.com/is-weakref/-/is-weakref-1.0.2.tgz -> yarnpkg-is-weakref-1.0.2.tgz
https://registry.yarnpkg.com/is-windows/-/is-windows-1.0.2.tgz -> yarnpkg-is-windows-1.0.2.tgz
https://registry.yarnpkg.com/is-wsl/-/is-wsl-1.1.0.tgz -> yarnpkg-is-wsl-1.1.0.tgz
https://registry.yarnpkg.com/isarray/-/isarray-1.0.0.tgz -> yarnpkg-isarray-1.0.0.tgz
https://registry.yarnpkg.com/isexe/-/isexe-2.0.0.tgz -> yarnpkg-isexe-2.0.0.tgz
https://registry.yarnpkg.com/isobject/-/isobject-2.1.0.tgz -> yarnpkg-isobject-2.1.0.tgz
https://registry.yarnpkg.com/isobject/-/isobject-3.0.1.tgz -> yarnpkg-isobject-3.0.1.tgz
https://registry.yarnpkg.com/iterm2-version/-/iterm2-version-3.0.0.tgz -> yarnpkg-iterm2-version-3.0.0.tgz
https://registry.yarnpkg.com/jest-docblock/-/jest-docblock-21.2.0.tgz -> yarnpkg-jest-docblock-21.2.0.tgz
https://registry.yarnpkg.com/jpeg-js/-/jpeg-js-0.2.0.tgz -> yarnpkg-jpeg-js-0.2.0.tgz
https://registry.yarnpkg.com/js-string-escape/-/js-string-escape-1.0.1.tgz -> yarnpkg-js-string-escape-1.0.1.tgz
https://registry.yarnpkg.com/js-tokens/-/js-tokens-3.0.2.tgz -> yarnpkg-js-tokens-3.0.2.tgz
https://registry.yarnpkg.com/js-types/-/js-types-1.0.0.tgz -> yarnpkg-js-types-1.0.0.tgz
https://registry.yarnpkg.com/js-yaml/-/js-yaml-3.14.1.tgz -> yarnpkg-js-yaml-3.14.1.tgz
https://registry.yarnpkg.com/jsesc/-/jsesc-0.5.0.tgz -> yarnpkg-jsesc-0.5.0.tgz
https://registry.yarnpkg.com/jsesc/-/jsesc-1.3.0.tgz -> yarnpkg-jsesc-1.3.0.tgz
https://registry.yarnpkg.com/json-parse-better-errors/-/json-parse-better-errors-1.0.2.tgz -> yarnpkg-json-parse-better-errors-1.0.2.tgz
https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-0.3.1.tgz -> yarnpkg-json-schema-traverse-0.3.1.tgz
https://registry.yarnpkg.com/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz -> yarnpkg-json-stable-stringify-without-jsonify-1.0.1.tgz
https://registry.yarnpkg.com/json5/-/json5-0.5.1.tgz -> yarnpkg-json5-0.5.1.tgz
https://registry.yarnpkg.com/json5/-/json5-1.0.2.tgz -> yarnpkg-json5-1.0.2.tgz
https://registry.yarnpkg.com/jsonfile/-/jsonfile-5.0.0.tgz -> yarnpkg-jsonfile-5.0.0.tgz
https://registry.yarnpkg.com/kind-of/-/kind-of-3.2.2.tgz -> yarnpkg-kind-of-3.2.2.tgz
https://registry.yarnpkg.com/kind-of/-/kind-of-4.0.0.tgz -> yarnpkg-kind-of-4.0.0.tgz
https://registry.yarnpkg.com/kind-of/-/kind-of-5.1.0.tgz -> yarnpkg-kind-of-5.1.0.tgz
https://registry.yarnpkg.com/kind-of/-/kind-of-6.0.3.tgz -> yarnpkg-kind-of-6.0.3.tgz
https://registry.yarnpkg.com/last-line-stream/-/last-line-stream-1.0.0.tgz -> yarnpkg-last-line-stream-1.0.0.tgz
https://registry.yarnpkg.com/latest-version/-/latest-version-3.1.0.tgz -> yarnpkg-latest-version-3.1.0.tgz
https://registry.yarnpkg.com/levn/-/levn-0.3.0.tgz -> yarnpkg-levn-0.3.0.tgz
https://registry.yarnpkg.com/line-column-path/-/line-column-path-1.0.0.tgz -> yarnpkg-line-column-path-1.0.0.tgz
https://registry.yarnpkg.com/listr-silent-renderer/-/listr-silent-renderer-1.1.1.tgz -> yarnpkg-listr-silent-renderer-1.1.1.tgz
https://registry.yarnpkg.com/listr-update-renderer/-/listr-update-renderer-0.5.0.tgz -> yarnpkg-listr-update-renderer-0.5.0.tgz
https://registry.yarnpkg.com/listr-verbose-renderer/-/listr-verbose-renderer-0.5.0.tgz -> yarnpkg-listr-verbose-renderer-0.5.0.tgz
https://registry.yarnpkg.com/listr/-/listr-0.14.3.tgz -> yarnpkg-listr-0.14.3.tgz
https://registry.yarnpkg.com/load-bmfont/-/load-bmfont-1.4.1.tgz -> yarnpkg-load-bmfont-1.4.1.tgz
https://registry.yarnpkg.com/load-json-file/-/load-json-file-1.1.0.tgz -> yarnpkg-load-json-file-1.1.0.tgz
https://registry.yarnpkg.com/load-json-file/-/load-json-file-2.0.0.tgz -> yarnpkg-load-json-file-2.0.0.tgz
https://registry.yarnpkg.com/load-json-file/-/load-json-file-4.0.0.tgz -> yarnpkg-load-json-file-4.0.0.tgz
https://registry.yarnpkg.com/locate-path/-/locate-path-2.0.0.tgz -> yarnpkg-locate-path-2.0.0.tgz
https://registry.yarnpkg.com/locate-path/-/locate-path-3.0.0.tgz -> yarnpkg-locate-path-3.0.0.tgz
https://registry.yarnpkg.com/lodash.camelcase/-/lodash.camelcase-4.3.0.tgz -> yarnpkg-lodash.camelcase-4.3.0.tgz
https://registry.yarnpkg.com/lodash.clonedeep/-/lodash.clonedeep-4.5.0.tgz -> yarnpkg-lodash.clonedeep-4.5.0.tgz
https://registry.yarnpkg.com/lodash.clonedeepwith/-/lodash.clonedeepwith-4.5.0.tgz -> yarnpkg-lodash.clonedeepwith-4.5.0.tgz
https://registry.yarnpkg.com/lodash.debounce/-/lodash.debounce-4.0.8.tgz -> yarnpkg-lodash.debounce-4.0.8.tgz
https://registry.yarnpkg.com/lodash.difference/-/lodash.difference-4.5.0.tgz -> yarnpkg-lodash.difference-4.5.0.tgz
https://registry.yarnpkg.com/lodash.flatten/-/lodash.flatten-4.4.0.tgz -> yarnpkg-lodash.flatten-4.4.0.tgz
https://registry.yarnpkg.com/lodash.flattendeep/-/lodash.flattendeep-4.4.0.tgz -> yarnpkg-lodash.flattendeep-4.4.0.tgz
https://registry.yarnpkg.com/lodash.get/-/lodash.get-4.4.2.tgz -> yarnpkg-lodash.get-4.4.2.tgz
https://registry.yarnpkg.com/lodash.isequal/-/lodash.isequal-4.5.0.tgz -> yarnpkg-lodash.isequal-4.5.0.tgz
https://registry.yarnpkg.com/lodash.kebabcase/-/lodash.kebabcase-4.1.1.tgz -> yarnpkg-lodash.kebabcase-4.1.1.tgz
https://registry.yarnpkg.com/lodash.merge/-/lodash.merge-4.6.2.tgz -> yarnpkg-lodash.merge-4.6.2.tgz
https://registry.yarnpkg.com/lodash.mergewith/-/lodash.mergewith-4.6.2.tgz -> yarnpkg-lodash.mergewith-4.6.2.tgz
https://registry.yarnpkg.com/lodash.snakecase/-/lodash.snakecase-4.1.1.tgz -> yarnpkg-lodash.snakecase-4.1.1.tgz
https://registry.yarnpkg.com/lodash.upperfirst/-/lodash.upperfirst-4.3.1.tgz -> yarnpkg-lodash.upperfirst-4.3.1.tgz
https://registry.yarnpkg.com/lodash.zip/-/lodash.zip-4.2.0.tgz -> yarnpkg-lodash.zip-4.2.0.tgz
https://registry.yarnpkg.com/lodash/-/lodash-4.17.21.tgz -> yarnpkg-lodash-4.17.21.tgz
https://registry.yarnpkg.com/log-symbols/-/log-symbols-1.0.2.tgz -> yarnpkg-log-symbols-1.0.2.tgz
https://registry.yarnpkg.com/log-symbols/-/log-symbols-2.2.0.tgz -> yarnpkg-log-symbols-2.2.0.tgz
https://registry.yarnpkg.com/log-update/-/log-update-2.3.0.tgz -> yarnpkg-log-update-2.3.0.tgz
https://registry.yarnpkg.com/loose-envify/-/loose-envify-1.4.0.tgz -> yarnpkg-loose-envify-1.4.0.tgz
https://registry.yarnpkg.com/loud-rejection/-/loud-rejection-1.6.0.tgz -> yarnpkg-loud-rejection-1.6.0.tgz
https://registry.yarnpkg.com/lowercase-keys/-/lowercase-keys-1.0.1.tgz -> yarnpkg-lowercase-keys-1.0.1.tgz
https://registry.yarnpkg.com/lru-cache/-/lru-cache-4.1.5.tgz -> yarnpkg-lru-cache-4.1.5.tgz
https://registry.yarnpkg.com/make-dir/-/make-dir-1.3.0.tgz -> yarnpkg-make-dir-1.3.0.tgz
https://registry.yarnpkg.com/map-cache/-/map-cache-0.2.2.tgz -> yarnpkg-map-cache-0.2.2.tgz
https://registry.yarnpkg.com/map-obj/-/map-obj-1.0.1.tgz -> yarnpkg-map-obj-1.0.1.tgz
https://registry.yarnpkg.com/map-obj/-/map-obj-2.0.0.tgz -> yarnpkg-map-obj-2.0.0.tgz
https://registry.yarnpkg.com/map-visit/-/map-visit-1.0.0.tgz -> yarnpkg-map-visit-1.0.0.tgz
https://registry.yarnpkg.com/matcher/-/matcher-1.1.1.tgz -> yarnpkg-matcher-1.1.1.tgz
https://registry.yarnpkg.com/math-random/-/math-random-1.0.4.tgz -> yarnpkg-math-random-1.0.4.tgz
https://registry.yarnpkg.com/md5-hex/-/md5-hex-1.3.0.tgz -> yarnpkg-md5-hex-1.3.0.tgz
https://registry.yarnpkg.com/md5-hex/-/md5-hex-2.0.0.tgz -> yarnpkg-md5-hex-2.0.0.tgz
https://registry.yarnpkg.com/md5-o-matic/-/md5-o-matic-0.1.1.tgz -> yarnpkg-md5-o-matic-0.1.1.tgz
https://registry.yarnpkg.com/meow/-/meow-3.7.0.tgz -> yarnpkg-meow-3.7.0.tgz
https://registry.yarnpkg.com/meow/-/meow-5.0.0.tgz -> yarnpkg-meow-5.0.0.tgz
https://registry.yarnpkg.com/merge2/-/merge2-1.4.1.tgz -> yarnpkg-merge2-1.4.1.tgz
https://registry.yarnpkg.com/micromatch/-/micromatch-2.3.11.tgz -> yarnpkg-micromatch-2.3.11.tgz
https://registry.yarnpkg.com/micromatch/-/micromatch-3.1.10.tgz -> yarnpkg-micromatch-3.1.10.tgz
https://registry.yarnpkg.com/mime/-/mime-1.6.0.tgz -> yarnpkg-mime-1.6.0.tgz
https://registry.yarnpkg.com/mime/-/mime-2.6.0.tgz -> yarnpkg-mime-2.6.0.tgz
https://registry.yarnpkg.com/mimic-fn/-/mimic-fn-1.2.0.tgz -> yarnpkg-mimic-fn-1.2.0.tgz
https://registry.yarnpkg.com/min-document/-/min-document-2.19.0.tgz -> yarnpkg-min-document-2.19.0.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-3.1.2.tgz -> yarnpkg-minimatch-3.1.2.tgz
https://registry.yarnpkg.com/minimist-options/-/minimist-options-3.0.2.tgz -> yarnpkg-minimist-options-3.0.2.tgz
https://registry.yarnpkg.com/minimist/-/minimist-0.0.8.tgz -> yarnpkg-minimist-0.0.8.tgz
https://registry.yarnpkg.com/minimist/-/minimist-1.2.8.tgz -> yarnpkg-minimist-1.2.8.tgz
https://registry.yarnpkg.com/mixin-deep/-/mixin-deep-1.3.2.tgz -> yarnpkg-mixin-deep-1.3.2.tgz
https://registry.yarnpkg.com/mkdirp/-/mkdirp-0.5.1.tgz -> yarnpkg-mkdirp-0.5.1.tgz
https://registry.yarnpkg.com/mkdirp/-/mkdirp-0.5.6.tgz -> yarnpkg-mkdirp-0.5.6.tgz
https://registry.yarnpkg.com/ms/-/ms-2.0.0.tgz -> yarnpkg-ms-2.0.0.tgz
https://registry.yarnpkg.com/ms/-/ms-2.1.2.tgz -> yarnpkg-ms-2.1.2.tgz
https://registry.yarnpkg.com/ms/-/ms-2.1.3.tgz -> yarnpkg-ms-2.1.3.tgz
https://registry.yarnpkg.com/multimatch/-/multimatch-2.1.0.tgz -> yarnpkg-multimatch-2.1.0.tgz
https://registry.yarnpkg.com/mute-stream/-/mute-stream-0.0.7.tgz -> yarnpkg-mute-stream-0.0.7.tgz
https://registry.yarnpkg.com/nan/-/nan-2.17.0.tgz -> yarnpkg-nan-2.17.0.tgz
https://registry.yarnpkg.com/nanoid/-/nanoid-2.1.11.tgz -> yarnpkg-nanoid-2.1.11.tgz
https://registry.yarnpkg.com/nanomatch/-/nanomatch-1.2.13.tgz -> yarnpkg-nanomatch-1.2.13.tgz
https://registry.yarnpkg.com/natural-compare/-/natural-compare-1.4.0.tgz -> yarnpkg-natural-compare-1.4.0.tgz
https://registry.yarnpkg.com/nice-try/-/nice-try-1.0.5.tgz -> yarnpkg-nice-try-1.0.5.tgz
https://registry.yarnpkg.com/node-version/-/node-version-1.2.0.tgz -> yarnpkg-node-version-1.2.0.tgz
https://registry.yarnpkg.com/normalize-package-data/-/normalize-package-data-2.5.0.tgz -> yarnpkg-normalize-package-data-2.5.0.tgz
https://registry.yarnpkg.com/normalize-path/-/normalize-path-2.1.1.tgz -> yarnpkg-normalize-path-2.1.1.tgz
https://registry.yarnpkg.com/npm-run-path/-/npm-run-path-1.0.0.tgz -> yarnpkg-npm-run-path-1.0.0.tgz
https://registry.yarnpkg.com/npm-run-path/-/npm-run-path-2.0.2.tgz -> yarnpkg-npm-run-path-2.0.2.tgz
https://registry.yarnpkg.com/number-is-nan/-/number-is-nan-1.0.1.tgz -> yarnpkg-number-is-nan-1.0.1.tgz
https://registry.yarnpkg.com/obj-props/-/obj-props-1.4.0.tgz -> yarnpkg-obj-props-1.4.0.tgz
https://registry.yarnpkg.com/object-assign/-/object-assign-4.1.1.tgz -> yarnpkg-object-assign-4.1.1.tgz
https://registry.yarnpkg.com/object-copy/-/object-copy-0.1.0.tgz -> yarnpkg-object-copy-0.1.0.tgz
https://registry.yarnpkg.com/object-inspect/-/object-inspect-1.12.3.tgz -> yarnpkg-object-inspect-1.12.3.tgz
https://registry.yarnpkg.com/object-is/-/object-is-1.1.5.tgz -> yarnpkg-object-is-1.1.5.tgz
https://registry.yarnpkg.com/object-keys/-/object-keys-1.1.1.tgz -> yarnpkg-object-keys-1.1.1.tgz
https://registry.yarnpkg.com/object-visit/-/object-visit-1.0.1.tgz -> yarnpkg-object-visit-1.0.1.tgz
https://registry.yarnpkg.com/object.assign/-/object.assign-4.1.4.tgz -> yarnpkg-object.assign-4.1.4.tgz
https://registry.yarnpkg.com/object.omit/-/object.omit-2.0.1.tgz -> yarnpkg-object.omit-2.0.1.tgz
https://registry.yarnpkg.com/object.pick/-/object.pick-1.3.0.tgz -> yarnpkg-object.pick-1.3.0.tgz
https://registry.yarnpkg.com/object.values/-/object.values-1.1.6.tgz -> yarnpkg-object.values-1.1.6.tgz
https://registry.yarnpkg.com/observable-to-promise/-/observable-to-promise-0.5.0.tgz -> yarnpkg-observable-to-promise-0.5.0.tgz
https://registry.yarnpkg.com/once/-/once-1.4.0.tgz -> yarnpkg-once-1.4.0.tgz
https://registry.yarnpkg.com/onetime/-/onetime-2.0.1.tgz -> yarnpkg-onetime-2.0.1.tgz
https://registry.yarnpkg.com/open-editor/-/open-editor-1.2.0.tgz -> yarnpkg-open-editor-1.2.0.tgz
https://registry.yarnpkg.com/opn/-/opn-5.5.0.tgz -> yarnpkg-opn-5.5.0.tgz
https://registry.yarnpkg.com/option-chain/-/option-chain-1.0.0.tgz -> yarnpkg-option-chain-1.0.0.tgz
https://registry.yarnpkg.com/optionator/-/optionator-0.8.3.tgz -> yarnpkg-optionator-0.8.3.tgz
https://registry.yarnpkg.com/os-homedir/-/os-homedir-1.0.2.tgz -> yarnpkg-os-homedir-1.0.2.tgz
https://registry.yarnpkg.com/os-tmpdir/-/os-tmpdir-1.0.2.tgz -> yarnpkg-os-tmpdir-1.0.2.tgz
https://registry.yarnpkg.com/p-finally/-/p-finally-1.0.0.tgz -> yarnpkg-p-finally-1.0.0.tgz
https://registry.yarnpkg.com/p-limit/-/p-limit-1.3.0.tgz -> yarnpkg-p-limit-1.3.0.tgz
https://registry.yarnpkg.com/p-limit/-/p-limit-2.3.0.tgz -> yarnpkg-p-limit-2.3.0.tgz
https://registry.yarnpkg.com/p-locate/-/p-locate-2.0.0.tgz -> yarnpkg-p-locate-2.0.0.tgz
https://registry.yarnpkg.com/p-locate/-/p-locate-3.0.0.tgz -> yarnpkg-p-locate-3.0.0.tgz
https://registry.yarnpkg.com/p-map/-/p-map-1.2.0.tgz -> yarnpkg-p-map-1.2.0.tgz
https://registry.yarnpkg.com/p-map/-/p-map-2.1.0.tgz -> yarnpkg-p-map-2.1.0.tgz
https://registry.yarnpkg.com/p-try/-/p-try-1.0.0.tgz -> yarnpkg-p-try-1.0.0.tgz
https://registry.yarnpkg.com/p-try/-/p-try-2.2.0.tgz -> yarnpkg-p-try-2.2.0.tgz
https://registry.yarnpkg.com/package-hash/-/package-hash-1.2.0.tgz -> yarnpkg-package-hash-1.2.0.tgz
https://registry.yarnpkg.com/package-hash/-/package-hash-2.0.0.tgz -> yarnpkg-package-hash-2.0.0.tgz
https://registry.yarnpkg.com/package-json/-/package-json-4.0.1.tgz -> yarnpkg-package-json-4.0.1.tgz
https://registry.yarnpkg.com/pako/-/pako-1.0.11.tgz -> yarnpkg-pako-1.0.11.tgz
https://registry.yarnpkg.com/parse-bmfont-ascii/-/parse-bmfont-ascii-1.0.6.tgz -> yarnpkg-parse-bmfont-ascii-1.0.6.tgz
https://registry.yarnpkg.com/parse-bmfont-binary/-/parse-bmfont-binary-1.0.6.tgz -> yarnpkg-parse-bmfont-binary-1.0.6.tgz
https://registry.yarnpkg.com/parse-bmfont-xml/-/parse-bmfont-xml-1.1.4.tgz -> yarnpkg-parse-bmfont-xml-1.1.4.tgz
https://registry.yarnpkg.com/parse-glob/-/parse-glob-3.0.4.tgz -> yarnpkg-parse-glob-3.0.4.tgz
https://registry.yarnpkg.com/parse-headers/-/parse-headers-2.0.5.tgz -> yarnpkg-parse-headers-2.0.5.tgz
https://registry.yarnpkg.com/parse-json/-/parse-json-2.2.0.tgz -> yarnpkg-parse-json-2.2.0.tgz
https://registry.yarnpkg.com/parse-json/-/parse-json-4.0.0.tgz -> yarnpkg-parse-json-4.0.0.tgz
https://registry.yarnpkg.com/parse-ms/-/parse-ms-0.1.2.tgz -> yarnpkg-parse-ms-0.1.2.tgz
https://registry.yarnpkg.com/parse-ms/-/parse-ms-1.0.1.tgz -> yarnpkg-parse-ms-1.0.1.tgz
https://registry.yarnpkg.com/pascalcase/-/pascalcase-0.1.1.tgz -> yarnpkg-pascalcase-0.1.1.tgz
https://registry.yarnpkg.com/path-dirname/-/path-dirname-1.0.2.tgz -> yarnpkg-path-dirname-1.0.2.tgz
https://registry.yarnpkg.com/path-exists/-/path-exists-2.1.0.tgz -> yarnpkg-path-exists-2.1.0.tgz
https://registry.yarnpkg.com/path-exists/-/path-exists-3.0.0.tgz -> yarnpkg-path-exists-3.0.0.tgz
https://registry.yarnpkg.com/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> yarnpkg-path-is-absolute-1.0.1.tgz
https://registry.yarnpkg.com/path-is-inside/-/path-is-inside-1.0.2.tgz -> yarnpkg-path-is-inside-1.0.2.tgz
https://registry.yarnpkg.com/path-key/-/path-key-1.0.0.tgz -> yarnpkg-path-key-1.0.0.tgz
https://registry.yarnpkg.com/path-key/-/path-key-2.0.1.tgz -> yarnpkg-path-key-2.0.1.tgz
https://registry.yarnpkg.com/path-parse/-/path-parse-1.0.7.tgz -> yarnpkg-path-parse-1.0.7.tgz
https://registry.yarnpkg.com/path-type/-/path-type-1.1.0.tgz -> yarnpkg-path-type-1.1.0.tgz
https://registry.yarnpkg.com/path-type/-/path-type-2.0.0.tgz -> yarnpkg-path-type-2.0.0.tgz
https://registry.yarnpkg.com/path-type/-/path-type-3.0.0.tgz -> yarnpkg-path-type-3.0.0.tgz
https://registry.yarnpkg.com/pend/-/pend-1.2.0.tgz -> yarnpkg-pend-1.2.0.tgz
https://registry.yarnpkg.com/phin/-/phin-2.9.3.tgz -> yarnpkg-phin-2.9.3.tgz
https://registry.yarnpkg.com/pify/-/pify-2.3.0.tgz -> yarnpkg-pify-2.3.0.tgz
https://registry.yarnpkg.com/pify/-/pify-3.0.0.tgz -> yarnpkg-pify-3.0.0.tgz
https://registry.yarnpkg.com/pinkie-promise/-/pinkie-promise-1.0.0.tgz -> yarnpkg-pinkie-promise-1.0.0.tgz
https://registry.yarnpkg.com/pinkie-promise/-/pinkie-promise-2.0.1.tgz -> yarnpkg-pinkie-promise-2.0.1.tgz
https://registry.yarnpkg.com/pinkie/-/pinkie-1.0.0.tgz -> yarnpkg-pinkie-1.0.0.tgz
https://registry.yarnpkg.com/pinkie/-/pinkie-2.0.4.tgz -> yarnpkg-pinkie-2.0.4.tgz
https://registry.yarnpkg.com/pixelmatch/-/pixelmatch-4.0.2.tgz -> yarnpkg-pixelmatch-4.0.2.tgz
https://registry.yarnpkg.com/pkg-conf/-/pkg-conf-2.1.0.tgz -> yarnpkg-pkg-conf-2.1.0.tgz
https://registry.yarnpkg.com/pkg-dir/-/pkg-dir-2.0.0.tgz -> yarnpkg-pkg-dir-2.0.0.tgz
https://registry.yarnpkg.com/pkg-dir/-/pkg-dir-3.0.0.tgz -> yarnpkg-pkg-dir-3.0.0.tgz
https://registry.yarnpkg.com/pkg-up/-/pkg-up-2.0.0.tgz -> yarnpkg-pkg-up-2.0.0.tgz
https://registry.yarnpkg.com/please-upgrade-node/-/please-upgrade-node-3.2.0.tgz -> yarnpkg-please-upgrade-node-3.2.0.tgz
https://registry.yarnpkg.com/plist/-/plist-3.0.6.tgz -> yarnpkg-plist-3.0.6.tgz
https://registry.yarnpkg.com/plur/-/plur-2.1.2.tgz -> yarnpkg-plur-2.1.2.tgz
https://registry.yarnpkg.com/pluralize/-/pluralize-7.0.0.tgz -> yarnpkg-pluralize-7.0.0.tgz
https://registry.yarnpkg.com/pngjs/-/pngjs-3.4.0.tgz -> yarnpkg-pngjs-3.4.0.tgz
https://registry.yarnpkg.com/posix-character-classes/-/posix-character-classes-0.1.1.tgz -> yarnpkg-posix-character-classes-0.1.1.tgz
https://registry.yarnpkg.com/prelude-ls/-/prelude-ls-1.1.2.tgz -> yarnpkg-prelude-ls-1.1.2.tgz
https://registry.yarnpkg.com/prepend-http/-/prepend-http-1.0.4.tgz -> yarnpkg-prepend-http-1.0.4.tgz
https://registry.yarnpkg.com/preserve/-/preserve-0.2.0.tgz -> yarnpkg-preserve-0.2.0.tgz
https://registry.yarnpkg.com/prettier/-/prettier-1.19.1.tgz -> yarnpkg-prettier-1.19.1.tgz
https://registry.yarnpkg.com/pretty-ms/-/pretty-ms-0.2.2.tgz -> yarnpkg-pretty-ms-0.2.2.tgz
https://registry.yarnpkg.com/pretty-ms/-/pretty-ms-3.2.0.tgz -> yarnpkg-pretty-ms-3.2.0.tgz
https://registry.yarnpkg.com/private/-/private-0.1.8.tgz -> yarnpkg-private-0.1.8.tgz
https://registry.yarnpkg.com/process-nextick-args/-/process-nextick-args-2.0.1.tgz -> yarnpkg-process-nextick-args-2.0.1.tgz
https://registry.yarnpkg.com/process/-/process-0.11.10.tgz -> yarnpkg-process-0.11.10.tgz
https://registry.yarnpkg.com/progress/-/progress-2.0.3.tgz -> yarnpkg-progress-2.0.3.tgz
https://registry.yarnpkg.com/promise-polyfill/-/promise-polyfill-6.1.0.tgz -> yarnpkg-promise-polyfill-6.1.0.tgz
https://registry.yarnpkg.com/proto-props/-/proto-props-1.1.0.tgz -> yarnpkg-proto-props-1.1.0.tgz
https://registry.yarnpkg.com/proxy-from-env/-/proxy-from-env-1.1.0.tgz -> yarnpkg-proxy-from-env-1.1.0.tgz
https://registry.yarnpkg.com/pseudomap/-/pseudomap-1.0.2.tgz -> yarnpkg-pseudomap-1.0.2.tgz
https://registry.yarnpkg.com/pump/-/pump-3.0.0.tgz -> yarnpkg-pump-3.0.0.tgz
https://registry.yarnpkg.com/puppeteer/-/puppeteer-1.20.0.tgz -> yarnpkg-puppeteer-1.20.0.tgz
https://registry.yarnpkg.com/query-string/-/query-string-6.14.1.tgz -> yarnpkg-query-string-6.14.1.tgz
https://registry.yarnpkg.com/quick-lru/-/quick-lru-1.1.0.tgz -> yarnpkg-quick-lru-1.1.0.tgz
https://registry.yarnpkg.com/randomatic/-/randomatic-3.1.1.tgz -> yarnpkg-randomatic-3.1.1.tgz
https://registry.yarnpkg.com/raw-body/-/raw-body-2.5.2.tgz -> yarnpkg-raw-body-2.5.2.tgz
https://registry.yarnpkg.com/rc/-/rc-1.2.8.tgz -> yarnpkg-rc-1.2.8.tgz
https://registry.yarnpkg.com/read-pkg-up/-/read-pkg-up-1.0.1.tgz -> yarnpkg-read-pkg-up-1.0.1.tgz
https://registry.yarnpkg.com/read-pkg-up/-/read-pkg-up-2.0.0.tgz -> yarnpkg-read-pkg-up-2.0.0.tgz
https://registry.yarnpkg.com/read-pkg-up/-/read-pkg-up-3.0.0.tgz -> yarnpkg-read-pkg-up-3.0.0.tgz
https://registry.yarnpkg.com/read-pkg/-/read-pkg-1.1.0.tgz -> yarnpkg-read-pkg-1.1.0.tgz
https://registry.yarnpkg.com/read-pkg/-/read-pkg-2.0.0.tgz -> yarnpkg-read-pkg-2.0.0.tgz
https://registry.yarnpkg.com/read-pkg/-/read-pkg-3.0.0.tgz -> yarnpkg-read-pkg-3.0.0.tgz
https://registry.yarnpkg.com/read-pkg/-/read-pkg-4.0.1.tgz -> yarnpkg-read-pkg-4.0.1.tgz
https://registry.yarnpkg.com/readable-stream/-/readable-stream-2.3.8.tgz -> yarnpkg-readable-stream-2.3.8.tgz
https://registry.yarnpkg.com/readdirp/-/readdirp-2.2.1.tgz -> yarnpkg-readdirp-2.2.1.tgz
https://registry.yarnpkg.com/redent/-/redent-1.0.0.tgz -> yarnpkg-redent-1.0.0.tgz
https://registry.yarnpkg.com/redent/-/redent-2.0.0.tgz -> yarnpkg-redent-2.0.0.tgz
https://registry.yarnpkg.com/regenerate/-/regenerate-1.4.2.tgz -> yarnpkg-regenerate-1.4.2.tgz
https://registry.yarnpkg.com/regenerator-runtime/-/regenerator-runtime-0.11.1.tgz -> yarnpkg-regenerator-runtime-0.11.1.tgz
https://registry.yarnpkg.com/regex-cache/-/regex-cache-0.4.4.tgz -> yarnpkg-regex-cache-0.4.4.tgz
https://registry.yarnpkg.com/regex-not/-/regex-not-1.0.2.tgz -> yarnpkg-regex-not-1.0.2.tgz
https://registry.yarnpkg.com/regexp.prototype.flags/-/regexp.prototype.flags-1.4.3.tgz -> yarnpkg-regexp.prototype.flags-1.4.3.tgz
https://registry.yarnpkg.com/regexpp/-/regexpp-1.1.0.tgz -> yarnpkg-regexpp-1.1.0.tgz
https://registry.yarnpkg.com/regexpu-core/-/regexpu-core-2.0.0.tgz -> yarnpkg-regexpu-core-2.0.0.tgz
https://registry.yarnpkg.com/registry-auth-token/-/registry-auth-token-3.4.0.tgz -> yarnpkg-registry-auth-token-3.4.0.tgz
https://registry.yarnpkg.com/registry-url/-/registry-url-3.1.0.tgz -> yarnpkg-registry-url-3.1.0.tgz
https://registry.yarnpkg.com/regjsgen/-/regjsgen-0.2.0.tgz -> yarnpkg-regjsgen-0.2.0.tgz
https://registry.yarnpkg.com/regjsparser/-/regjsparser-0.1.5.tgz -> yarnpkg-regjsparser-0.1.5.tgz
https://registry.yarnpkg.com/release-zalgo/-/release-zalgo-1.0.0.tgz -> yarnpkg-release-zalgo-1.0.0.tgz
https://registry.yarnpkg.com/remove-trailing-separator/-/remove-trailing-separator-1.1.0.tgz -> yarnpkg-remove-trailing-separator-1.1.0.tgz
https://registry.yarnpkg.com/repeat-element/-/repeat-element-1.1.4.tgz -> yarnpkg-repeat-element-1.1.4.tgz
https://registry.yarnpkg.com/repeat-string/-/repeat-string-1.6.1.tgz -> yarnpkg-repeat-string-1.6.1.tgz
https://registry.yarnpkg.com/repeating/-/repeating-2.0.1.tgz -> yarnpkg-repeating-2.0.1.tgz
https://registry.yarnpkg.com/require-precompiled/-/require-precompiled-0.1.0.tgz -> yarnpkg-require-precompiled-0.1.0.tgz
https://registry.yarnpkg.com/require-uncached/-/require-uncached-1.0.3.tgz -> yarnpkg-require-uncached-1.0.3.tgz
https://registry.yarnpkg.com/resolve-cwd/-/resolve-cwd-2.0.0.tgz -> yarnpkg-resolve-cwd-2.0.0.tgz
https://registry.yarnpkg.com/resolve-from/-/resolve-from-1.0.1.tgz -> yarnpkg-resolve-from-1.0.1.tgz
https://registry.yarnpkg.com/resolve-from/-/resolve-from-3.0.0.tgz -> yarnpkg-resolve-from-3.0.0.tgz
https://registry.yarnpkg.com/resolve-from/-/resolve-from-4.0.0.tgz -> yarnpkg-resolve-from-4.0.0.tgz
https://registry.yarnpkg.com/resolve-url/-/resolve-url-0.2.1.tgz -> yarnpkg-resolve-url-0.2.1.tgz
https://registry.yarnpkg.com/resolve/-/resolve-1.22.1.tgz -> yarnpkg-resolve-1.22.1.tgz
https://registry.yarnpkg.com/restore-cursor/-/restore-cursor-2.0.0.tgz -> yarnpkg-restore-cursor-2.0.0.tgz
https://registry.yarnpkg.com/ret/-/ret-0.1.15.tgz -> yarnpkg-ret-0.1.15.tgz
https://registry.yarnpkg.com/rimraf/-/rimraf-2.6.3.tgz -> yarnpkg-rimraf-2.6.3.tgz
https://registry.yarnpkg.com/rimraf/-/rimraf-2.7.1.tgz -> yarnpkg-rimraf-2.7.1.tgz
https://registry.yarnpkg.com/run-async/-/run-async-2.4.1.tgz -> yarnpkg-run-async-2.4.1.tgz
https://registry.yarnpkg.com/run-node/-/run-node-1.0.0.tgz -> yarnpkg-run-node-1.0.0.tgz
https://registry.yarnpkg.com/rx-lite-aggregates/-/rx-lite-aggregates-4.0.8.tgz -> yarnpkg-rx-lite-aggregates-4.0.8.tgz
https://registry.yarnpkg.com/rx-lite/-/rx-lite-4.0.8.tgz -> yarnpkg-rx-lite-4.0.8.tgz
https://registry.yarnpkg.com/rxjs/-/rxjs-6.6.7.tgz -> yarnpkg-rxjs-6.6.7.tgz
https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.1.2.tgz -> yarnpkg-safe-buffer-5.1.2.tgz
https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.2.1.tgz -> yarnpkg-safe-buffer-5.2.1.tgz
https://registry.yarnpkg.com/safe-regex-test/-/safe-regex-test-1.0.0.tgz -> yarnpkg-safe-regex-test-1.0.0.tgz
https://registry.yarnpkg.com/safe-regex/-/safe-regex-1.1.0.tgz -> yarnpkg-safe-regex-1.1.0.tgz
https://registry.yarnpkg.com/safer-buffer/-/safer-buffer-2.1.2.tgz -> yarnpkg-safer-buffer-2.1.2.tgz
https://registry.yarnpkg.com/sax/-/sax-1.2.4.tgz -> yarnpkg-sax-1.2.4.tgz
https://registry.yarnpkg.com/semver-compare/-/semver-compare-1.0.0.tgz -> yarnpkg-semver-compare-1.0.0.tgz
https://registry.yarnpkg.com/semver-diff/-/semver-diff-2.1.0.tgz -> yarnpkg-semver-diff-2.1.0.tgz
https://registry.yarnpkg.com/semver/-/semver-5.7.1.tgz -> yarnpkg-semver-5.7.1.tgz
https://registry.yarnpkg.com/semver/-/semver-6.3.0.tgz -> yarnpkg-semver-6.3.0.tgz
https://registry.yarnpkg.com/serialize-error/-/serialize-error-2.1.0.tgz -> yarnpkg-serialize-error-2.1.0.tgz
https://registry.yarnpkg.com/set-value/-/set-value-2.0.1.tgz -> yarnpkg-set-value-2.0.1.tgz
https://registry.yarnpkg.com/setprototypeof/-/setprototypeof-1.2.0.tgz -> yarnpkg-setprototypeof-1.2.0.tgz
https://registry.yarnpkg.com/shebang-command/-/shebang-command-1.2.0.tgz -> yarnpkg-shebang-command-1.2.0.tgz
https://registry.yarnpkg.com/shebang-regex/-/shebang-regex-1.0.0.tgz -> yarnpkg-shebang-regex-1.0.0.tgz
https://registry.yarnpkg.com/side-channel/-/side-channel-1.0.4.tgz -> yarnpkg-side-channel-1.0.4.tgz
https://registry.yarnpkg.com/signal-exit/-/signal-exit-3.0.7.tgz -> yarnpkg-signal-exit-3.0.7.tgz
https://registry.yarnpkg.com/slash/-/slash-1.0.0.tgz -> yarnpkg-slash-1.0.0.tgz
https://registry.yarnpkg.com/slash/-/slash-2.0.0.tgz -> yarnpkg-slash-2.0.0.tgz
https://registry.yarnpkg.com/slice-ansi/-/slice-ansi-0.0.4.tgz -> yarnpkg-slice-ansi-0.0.4.tgz
https://registry.yarnpkg.com/slice-ansi/-/slice-ansi-1.0.0.tgz -> yarnpkg-slice-ansi-1.0.0.tgz
https://registry.yarnpkg.com/slide/-/slide-1.1.6.tgz -> yarnpkg-slide-1.1.6.tgz
https://registry.yarnpkg.com/snapdragon-node/-/snapdragon-node-2.1.1.tgz -> yarnpkg-snapdragon-node-2.1.1.tgz
https://registry.yarnpkg.com/snapdragon-util/-/snapdragon-util-3.0.1.tgz -> yarnpkg-snapdragon-util-3.0.1.tgz
https://registry.yarnpkg.com/snapdragon/-/snapdragon-0.8.2.tgz -> yarnpkg-snapdragon-0.8.2.tgz
https://registry.yarnpkg.com/sort-keys/-/sort-keys-2.0.0.tgz -> yarnpkg-sort-keys-2.0.0.tgz
https://registry.yarnpkg.com/source-map-resolve/-/source-map-resolve-0.5.3.tgz -> yarnpkg-source-map-resolve-0.5.3.tgz
https://registry.yarnpkg.com/source-map-support/-/source-map-support-0.4.18.tgz -> yarnpkg-source-map-support-0.4.18.tgz
https://registry.yarnpkg.com/source-map-support/-/source-map-support-0.5.21.tgz -> yarnpkg-source-map-support-0.5.21.tgz
https://registry.yarnpkg.com/source-map-url/-/source-map-url-0.4.1.tgz -> yarnpkg-source-map-url-0.4.1.tgz
https://registry.yarnpkg.com/source-map/-/source-map-0.5.7.tgz -> yarnpkg-source-map-0.5.7.tgz
https://registry.yarnpkg.com/source-map/-/source-map-0.6.1.tgz -> yarnpkg-source-map-0.6.1.tgz
https://registry.yarnpkg.com/spdx-correct/-/spdx-correct-3.2.0.tgz -> yarnpkg-spdx-correct-3.2.0.tgz
https://registry.yarnpkg.com/spdx-exceptions/-/spdx-exceptions-2.3.0.tgz -> yarnpkg-spdx-exceptions-2.3.0.tgz
https://registry.yarnpkg.com/spdx-expression-parse/-/spdx-expression-parse-3.0.1.tgz -> yarnpkg-spdx-expression-parse-3.0.1.tgz
https://registry.yarnpkg.com/spdx-license-ids/-/spdx-license-ids-3.0.13.tgz -> yarnpkg-spdx-license-ids-3.0.13.tgz
https://registry.yarnpkg.com/split-on-first/-/split-on-first-1.1.0.tgz -> yarnpkg-split-on-first-1.1.0.tgz
https://registry.yarnpkg.com/split-string/-/split-string-3.1.0.tgz -> yarnpkg-split-string-3.1.0.tgz
https://registry.yarnpkg.com/sprintf-js/-/sprintf-js-1.0.3.tgz -> yarnpkg-sprintf-js-1.0.3.tgz
https://registry.yarnpkg.com/stack-utils/-/stack-utils-1.0.5.tgz -> yarnpkg-stack-utils-1.0.5.tgz
https://registry.yarnpkg.com/static-extend/-/static-extend-0.1.2.tgz -> yarnpkg-static-extend-0.1.2.tgz
https://registry.yarnpkg.com/statuses/-/statuses-2.0.1.tgz -> yarnpkg-statuses-2.0.1.tgz
https://registry.yarnpkg.com/strict-uri-encode/-/strict-uri-encode-2.0.0.tgz -> yarnpkg-strict-uri-encode-2.0.0.tgz
https://registry.yarnpkg.com/string-width/-/string-width-1.0.2.tgz -> yarnpkg-string-width-1.0.2.tgz
https://registry.yarnpkg.com/string-width/-/string-width-2.1.1.tgz -> yarnpkg-string-width-2.1.1.tgz
https://registry.yarnpkg.com/string.prototype.trim/-/string.prototype.trim-1.2.7.tgz -> yarnpkg-string.prototype.trim-1.2.7.tgz
https://registry.yarnpkg.com/string.prototype.trimend/-/string.prototype.trimend-1.0.6.tgz -> yarnpkg-string.prototype.trimend-1.0.6.tgz
https://registry.yarnpkg.com/string.prototype.trimstart/-/string.prototype.trimstart-1.0.6.tgz -> yarnpkg-string.prototype.trimstart-1.0.6.tgz
https://registry.yarnpkg.com/string_decoder/-/string_decoder-1.1.1.tgz -> yarnpkg-string_decoder-1.1.1.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-0.1.1.tgz -> yarnpkg-strip-ansi-0.1.1.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-3.0.1.tgz -> yarnpkg-strip-ansi-3.0.1.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-4.0.0.tgz -> yarnpkg-strip-ansi-4.0.0.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-5.2.0.tgz -> yarnpkg-strip-ansi-5.2.0.tgz
https://registry.yarnpkg.com/strip-bom-buf/-/strip-bom-buf-1.0.0.tgz -> yarnpkg-strip-bom-buf-1.0.0.tgz
https://registry.yarnpkg.com/strip-bom/-/strip-bom-2.0.0.tgz -> yarnpkg-strip-bom-2.0.0.tgz
https://registry.yarnpkg.com/strip-bom/-/strip-bom-3.0.0.tgz -> yarnpkg-strip-bom-3.0.0.tgz
https://registry.yarnpkg.com/strip-eof/-/strip-eof-1.0.0.tgz -> yarnpkg-strip-eof-1.0.0.tgz
https://registry.yarnpkg.com/strip-indent/-/strip-indent-1.0.1.tgz -> yarnpkg-strip-indent-1.0.1.tgz
https://registry.yarnpkg.com/strip-indent/-/strip-indent-2.0.0.tgz -> yarnpkg-strip-indent-2.0.0.tgz
https://registry.yarnpkg.com/strip-json-comments/-/strip-json-comments-2.0.1.tgz -> yarnpkg-strip-json-comments-2.0.1.tgz
https://registry.yarnpkg.com/supertap/-/supertap-1.0.0.tgz -> yarnpkg-supertap-1.0.0.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-2.0.0.tgz -> yarnpkg-supports-color-2.0.0.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-5.5.0.tgz -> yarnpkg-supports-color-5.5.0.tgz
https://registry.yarnpkg.com/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz -> yarnpkg-supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.yarnpkg.com/symbol-observable/-/symbol-observable-0.2.4.tgz -> yarnpkg-symbol-observable-0.2.4.tgz
https://registry.yarnpkg.com/symbol-observable/-/symbol-observable-1.2.0.tgz -> yarnpkg-symbol-observable-1.2.0.tgz
https://registry.yarnpkg.com/table/-/table-4.0.2.tgz -> yarnpkg-table-4.0.2.tgz
https://registry.yarnpkg.com/temp-dir/-/temp-dir-1.0.0.tgz -> yarnpkg-temp-dir-1.0.0.tgz
https://registry.yarnpkg.com/tempy/-/tempy-0.2.1.tgz -> yarnpkg-tempy-0.2.1.tgz
https://registry.yarnpkg.com/term-img/-/term-img-3.0.0.tgz -> yarnpkg-term-img-3.0.0.tgz
https://registry.yarnpkg.com/term-size/-/term-size-1.2.0.tgz -> yarnpkg-term-size-1.2.0.tgz
https://registry.yarnpkg.com/terminal-image/-/terminal-image-0.1.2.tgz -> yarnpkg-terminal-image-0.1.2.tgz
https://registry.yarnpkg.com/text-table/-/text-table-0.2.0.tgz -> yarnpkg-text-table-0.2.0.tgz
https://registry.yarnpkg.com/the-argv/-/the-argv-1.0.0.tgz -> yarnpkg-the-argv-1.0.0.tgz
https://registry.yarnpkg.com/through/-/through-2.3.8.tgz -> yarnpkg-through-2.3.8.tgz
https://registry.yarnpkg.com/through2/-/through2-2.0.5.tgz -> yarnpkg-through2-2.0.5.tgz
https://registry.yarnpkg.com/time-zone/-/time-zone-1.0.0.tgz -> yarnpkg-time-zone-1.0.0.tgz
https://registry.yarnpkg.com/timed-out/-/timed-out-4.0.1.tgz -> yarnpkg-timed-out-4.0.1.tgz
https://registry.yarnpkg.com/tinycolor2/-/tinycolor2-1.6.0.tgz -> yarnpkg-tinycolor2-1.6.0.tgz
https://registry.yarnpkg.com/tmp/-/tmp-0.0.33.tgz -> yarnpkg-tmp-0.0.33.tgz
https://registry.yarnpkg.com/to-fast-properties/-/to-fast-properties-1.0.3.tgz -> yarnpkg-to-fast-properties-1.0.3.tgz
https://registry.yarnpkg.com/to-object-path/-/to-object-path-0.3.0.tgz -> yarnpkg-to-object-path-0.3.0.tgz
https://registry.yarnpkg.com/to-regex-range/-/to-regex-range-2.1.1.tgz -> yarnpkg-to-regex-range-2.1.1.tgz
https://registry.yarnpkg.com/to-regex/-/to-regex-3.0.2.tgz -> yarnpkg-to-regex-3.0.2.tgz
https://registry.yarnpkg.com/toidentifier/-/toidentifier-1.0.1.tgz -> yarnpkg-toidentifier-1.0.1.tgz
https://registry.yarnpkg.com/trim-newlines/-/trim-newlines-1.0.0.tgz -> yarnpkg-trim-newlines-1.0.0.tgz
https://registry.yarnpkg.com/trim-newlines/-/trim-newlines-2.0.0.tgz -> yarnpkg-trim-newlines-2.0.0.tgz
https://registry.yarnpkg.com/trim-off-newlines/-/trim-off-newlines-1.0.3.tgz -> yarnpkg-trim-off-newlines-1.0.3.tgz
https://registry.yarnpkg.com/trim-right/-/trim-right-1.0.1.tgz -> yarnpkg-trim-right-1.0.1.tgz
https://registry.yarnpkg.com/tsconfig-paths/-/tsconfig-paths-3.14.2.tgz -> yarnpkg-tsconfig-paths-3.14.2.tgz
https://registry.yarnpkg.com/tslib/-/tslib-1.14.1.tgz -> yarnpkg-tslib-1.14.1.tgz
https://registry.yarnpkg.com/type-check/-/type-check-0.3.2.tgz -> yarnpkg-type-check-0.3.2.tgz
https://registry.yarnpkg.com/typed-array-length/-/typed-array-length-1.0.4.tgz -> yarnpkg-typed-array-length-1.0.4.tgz
https://registry.yarnpkg.com/typedarray/-/typedarray-0.0.6.tgz -> yarnpkg-typedarray-0.0.6.tgz
https://registry.yarnpkg.com/uid2/-/uid2-0.0.3.tgz -> yarnpkg-uid2-0.0.3.tgz
https://registry.yarnpkg.com/unbox-primitive/-/unbox-primitive-1.0.2.tgz -> yarnpkg-unbox-primitive-1.0.2.tgz
https://registry.yarnpkg.com/union-value/-/union-value-1.0.1.tgz -> yarnpkg-union-value-1.0.1.tgz
https://registry.yarnpkg.com/unique-string/-/unique-string-1.0.0.tgz -> yarnpkg-unique-string-1.0.0.tgz
https://registry.yarnpkg.com/unique-temp-dir/-/unique-temp-dir-1.0.0.tgz -> yarnpkg-unique-temp-dir-1.0.0.tgz
https://registry.yarnpkg.com/universalify/-/universalify-0.1.2.tgz -> yarnpkg-universalify-0.1.2.tgz
https://registry.yarnpkg.com/unpipe/-/unpipe-1.0.0.tgz -> yarnpkg-unpipe-1.0.0.tgz
https://registry.yarnpkg.com/unset-value/-/unset-value-1.0.0.tgz -> yarnpkg-unset-value-1.0.0.tgz
https://registry.yarnpkg.com/unzip-response/-/unzip-response-2.0.1.tgz -> yarnpkg-unzip-response-2.0.1.tgz
https://registry.yarnpkg.com/update-notifier/-/update-notifier-2.5.0.tgz -> yarnpkg-update-notifier-2.5.0.tgz
https://registry.yarnpkg.com/urix/-/urix-0.1.0.tgz -> yarnpkg-urix-0.1.0.tgz
https://registry.yarnpkg.com/url-parse-lax/-/url-parse-lax-1.0.0.tgz -> yarnpkg-url-parse-lax-1.0.0.tgz
https://registry.yarnpkg.com/use/-/use-3.1.1.tgz -> yarnpkg-use-3.1.1.tgz
https://registry.yarnpkg.com/utif/-/utif-1.3.0.tgz -> yarnpkg-utif-1.3.0.tgz
https://registry.yarnpkg.com/util-deprecate/-/util-deprecate-1.0.2.tgz -> yarnpkg-util-deprecate-1.0.2.tgz
https://registry.yarnpkg.com/validate-npm-package-license/-/validate-npm-package-license-3.0.4.tgz -> yarnpkg-validate-npm-package-license-3.0.4.tgz
https://registry.yarnpkg.com/well-known-symbols/-/well-known-symbols-1.0.0.tgz -> yarnpkg-well-known-symbols-1.0.0.tgz
https://registry.yarnpkg.com/which-boxed-primitive/-/which-boxed-primitive-1.0.2.tgz -> yarnpkg-which-boxed-primitive-1.0.2.tgz
https://registry.yarnpkg.com/which-typed-array/-/which-typed-array-1.1.9.tgz -> yarnpkg-which-typed-array-1.1.9.tgz
https://registry.yarnpkg.com/which/-/which-1.3.1.tgz -> yarnpkg-which-1.3.1.tgz
https://registry.yarnpkg.com/widest-line/-/widest-line-2.0.1.tgz -> yarnpkg-widest-line-2.0.1.tgz
https://registry.yarnpkg.com/word-wrap/-/word-wrap-1.2.3.tgz -> yarnpkg-word-wrap-1.2.3.tgz
https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-3.0.1.tgz -> yarnpkg-wrap-ansi-3.0.1.tgz
https://registry.yarnpkg.com/wrappy/-/wrappy-1.0.2.tgz -> yarnpkg-wrappy-1.0.2.tgz
https://registry.yarnpkg.com/write-file-atomic/-/write-file-atomic-1.3.4.tgz -> yarnpkg-write-file-atomic-1.3.4.tgz
https://registry.yarnpkg.com/write-file-atomic/-/write-file-atomic-2.4.3.tgz -> yarnpkg-write-file-atomic-2.4.3.tgz
https://registry.yarnpkg.com/write-json-file/-/write-json-file-2.3.0.tgz -> yarnpkg-write-json-file-2.3.0.tgz
https://registry.yarnpkg.com/write-pkg/-/write-pkg-3.2.0.tgz -> yarnpkg-write-pkg-3.2.0.tgz
https://registry.yarnpkg.com/write/-/write-0.2.1.tgz -> yarnpkg-write-0.2.1.tgz
https://registry.yarnpkg.com/ws/-/ws-6.2.2.tgz -> yarnpkg-ws-6.2.2.tgz
https://registry.yarnpkg.com/xdg-basedir/-/xdg-basedir-3.0.0.tgz -> yarnpkg-xdg-basedir-3.0.0.tgz
https://registry.yarnpkg.com/xhr/-/xhr-2.6.0.tgz -> yarnpkg-xhr-2.6.0.tgz
https://registry.yarnpkg.com/xml-parse-from-string/-/xml-parse-from-string-1.0.1.tgz -> yarnpkg-xml-parse-from-string-1.0.1.tgz
https://registry.yarnpkg.com/xml2js/-/xml2js-0.4.23.tgz -> yarnpkg-xml2js-0.4.23.tgz
https://registry.yarnpkg.com/xmlbuilder/-/xmlbuilder-11.0.1.tgz -> yarnpkg-xmlbuilder-11.0.1.tgz
https://registry.yarnpkg.com/xmlbuilder/-/xmlbuilder-15.1.1.tgz -> yarnpkg-xmlbuilder-15.1.1.tgz
https://registry.yarnpkg.com/xo-init/-/xo-init-0.7.0.tgz -> yarnpkg-xo-init-0.7.0.tgz
https://registry.yarnpkg.com/xo/-/xo-0.21.1.tgz -> yarnpkg-xo-0.21.1.tgz
https://registry.yarnpkg.com/xtend/-/xtend-4.0.2.tgz -> yarnpkg-xtend-4.0.2.tgz
https://registry.yarnpkg.com/yallist/-/yallist-2.1.2.tgz -> yarnpkg-yallist-2.1.2.tgz
https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-10.1.0.tgz -> yarnpkg-yargs-parser-10.1.0.tgz
https://registry.yarnpkg.com/yauzl/-/yauzl-2.10.0.tgz -> yarnpkg-yauzl-2.10.0.tgz
"
# UPDATER_END_YARN_EXTERNAL_URIS
SRC_URI="
${YARN_EXTERNAL_URIS}
https://github.com/mixn/carbon-now-cli/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${PN}-${PV}"

src_unpack() {
	if [[ "${UPDATE_YARN_LOCK}" == "1" ]] ; then
		unpack ${P}.tar.gz
		cd "${S}" || die
		rm package-lock.json
		npm i || die
		npm audit fix || die
		yarn import || die
	else
		yarn_src_unpack
	fi
}

src_compile() { :; }

src_install() {
	insinto "${YARN_INSTALL_PATH}"
	doins -r *

	local path
	for path in ${YARN_EXE_LIST} ; do
		fperms 0755 "${path}"
	done

	cp "${FILESDIR}/${MY_PN}" "${T}" || die
	sed -i -e "s|__NODE_VERSION__|${NODE_VERSION}|g" \
		"${T}/${MY_PN}" \
		|| die
	exeinto /usr/bin
	doexe "${T}/${MY_PN}"
	sed -i -e ""
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
	rm -rf "${ED}${YARN_INSTALL_PATH}/node_modules/puppeteer/.local-chromium" || die
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
